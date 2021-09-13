[getBarangays]
select * from barangay order by indexno 


[clearItems]
delete from report_bpdelinquency_item where parentid=$P{reportid} 


[build]
insert into report_bpdelinquency_item ( 
	objid, parentid, applicationid 
) 
select 
	NEWID() as objid, $P{reportid} as parentid, tmpa.applicationid 
from ( 
	select applicationid, sum(amount-amtpaid) as balance 
	from business_receivable  
	group by applicationid 
	having sum(amount-amtpaid) > 0 
)tmpa 
	inner join business_application ba on ba.objid=tmpa.applicationid 
where ba.state in ('PAYMENT','RELEASE','COMPLETED') 


[updateHeader]
update report_bpdelinquency set 
	totalcount = (select count(*) from report_bpdelinquency_item where parentid=$P{reportid}), 
	processedcount = (select count(*) from report_bpdelinquency_item where parentid=$P{reportid} and total is not null) 
where objid=$P{reportid} 


[getBuildItems]
select * 
from ( 
	select 
		rpt.*, ba.appno, ba.apptype, ba.appyear, ba.tradename,  
		addr.barangay_objid as barangayid, 
		addr.barangay_name as barangayname 
	from report_bpdelinquency_item rpt 
		inner join report_bpdelinquency rptp on rpt.parentid=rptp.objid 
		inner join business_application ba on ba.objid=rpt.applicationid 
		inner join business b on ba.business_objid=b.objid 
		left join business_address addr on b.address_objid=addr.objid 
	where rpt.parentid=$P{reportid} 
		and rptp.state=$P{state} 
		and ba.state in ('PAYMENT','RELEASE','COMPLETED') 
		and ba.apptype in ('NEW','RENEW') 
		and b.state in ('ACTIVE','PROCESSING') 
		and rpt.total is null 
)tmpa 
where 1=1 ${filter} 
order by barangayname, appyear, appno 


[findLedger]
select 
	tmpa.applicationid, b.appyear, b.appno, b.tradename, b.apptype, 
	isnull(tmpa.amount,0.0) as amount, isnull(tmpa.amtpaid,0.0) as amtpaid, 
	isnull(tmpa.tax,0.0) as tax, isnull(tmpa.regfee,0.0) as regfee, 
	isnull(tmpa.othercharge,0.0) as othercharge 
from ( 
	select 
		ba.objid as applicationid, 
		(select sum(amount) from business_receivable where applicationid=ba.objid) as amount, 
		(select sum(amtpaid) from business_receivable where applicationid=ba.objid) as amtpaid,
		(select sum(amount-amtpaid) from business_receivable where applicationid=ba.objid and taxfeetype='TAX') as tax,
		(select sum(amount-amtpaid) from business_receivable where applicationid=ba.objid and taxfeetype='REGFEE') as regfee, 
		(select sum(amount-amtpaid) from business_receivable where applicationid=ba.objid and taxfeetype='OTHERCHARGE') as othercharge  
	from business_application ba  
	where ba.objid=$P{applicationid} 
)tmpa, business_application b   
where b.objid=tmpa.applicationid 


[getReport]
select 
	tmpc.dtgenerated, tmpc.businessid, tmpc.tradename, tmpc.businessname, tmpc.ownername, 
	min(tmpc.appyear) as minyear, max(tmpc.appyear) as maxyear, 
	sum(tmpc.taxdue) as taxdue, sum(tmpc.regfeedue) as regfeedue, sum(tmpc.otherdue) as otherdue, 
	sum(tmpc.surcharge) as surcharge, sum(tmpc.interest) as interest, sum(tmpc.total) as total, 
	tmpc.barangayid, tmpc.barangayname 
from ( 
	select 
		b.objid as businessid, b.tradename, b.businessname, b.owner_name AS ownername, 
		ba.appyear, tmpb.taxdue, tmpb.regfeedue, tmpb.otherdue, tmpb.surcharge, tmpb.interest, 
		(tmpb.taxdue + tmpb.regfeedue + tmpb.otherdue + tmpb.surcharge + tmpb.interest) as total, 
		tmpb.dtfiled as dtgenerated, 
		(case when baddr.barangay_objid is null then null else baddr.barangay_objid end) as barangayid, 
		(case when baddr.barangay_objid is null then null else baddr.barangay_name end) as barangayname  
	from ( 
		select
			tmpa.objid, tmpa.parentid, tmpa.applicationid, tmpa.dtfiled, tmpa.surcharge, tmpa.interest, 
			sum(tmpa.taxdue) as taxdue, sum(tmpa.regfeedue) as regfeedue, sum(tmpa.otherdue) as otherdue 
		from ( 
			select 
				rpta.objid, rpta.parentid, rpta.applicationid, rpt.dtfiled, rpta.surcharge, rpta.interest, 
				(CASE WHEN br.taxfeetype = 'TAX' THEN br.amount-br.amtpaid ELSE 0.0 END) AS taxdue, 
				(CASE WHEN br.taxfeetype = 'REGFEE' THEN br.amount-br.amtpaid ELSE 0.0 END) AS regfeedue, 
				(CASE WHEN br.taxfeetype = 'OTHERCHARGE' THEN br.amount-br.amtpaid ELSE 0.0 END) AS otherdue 
			from report_bpdelinquency_item rpta  
				inner join report_bpdelinquency rpt on rpta.parentid=rpt.objid 
				inner join business_receivable br on rpta.applicationid=br.applicationid 
			where rpta.parentid = $P{reportid} 
				and rpt.state = 'APPROVED' 
				and rpta.total > 0.0 
				and (br.amount-br.amtpaid) > 0 
		)tmpa 
		group by tmpa.objid, tmpa.parentid, tmpa.applicationid, tmpa.dtfiled, tmpa.surcharge, tmpa.interest 
	)tmpb 
		inner join business_application ba on ba.objid=tmpb.applicationid 
		inner join business b on ba.business_objid=b.objid 
		left join business_address baddr on b.address_objid=baddr.objid 
	where ba.apptype <> 'RETIRE' 
		and ba.appyear < $P{currentyear} 
		and ba.dtfiled >= $P{startdate} 
		and ba.dtfiled <  $P{enddate}  
		${filter} 
)tmpc 
group by 
	tmpc.dtgenerated, tmpc.businessid, tmpc.tradename, tmpc.businessname, 
	tmpc.ownername, tmpc.barangayid, tmpc.barangayname 
order by tmpc.barangayname, tmpc.tradename 

[getReportB]
select 
	b.objid as businessid, ba.tradename, b.businessname, ba.ownername AS ownername, 
	ba.appyear, tmpb.taxdue, tmpb.regfeedue, tmpb.otherdue, tmpb.surcharge, tmpb.interest, 
	(tmpb.taxdue + tmpb.regfeedue + tmpb.otherdue + tmpb.surcharge + tmpb.interest) as total, 
	tmpb.dtfiled as dtgenerated 
from ( 
	select
		tmpa.objid, tmpa.parentid, tmpa.applicationid, tmpa.dtfiled, tmpa.surcharge, tmpa.interest, 
		sum(tmpa.taxdue) as taxdue, sum(tmpa.regfeedue) as regfeedue, sum(tmpa.otherdue) as otherdue 
	from ( 
		select 
			rpta.objid, rpta.parentid, rpta.applicationid, rpt.dtfiled, rpta.surcharge, rpta.interest, 
			(CASE WHEN br.taxfeetype = 'TAX' THEN br.amount-br.amtpaid ELSE 0.0 END) AS taxdue, 
			(CASE WHEN br.taxfeetype = 'REGFEE' THEN br.amount-br.amtpaid ELSE 0.0 END) AS regfeedue, 
			(CASE WHEN br.taxfeetype = 'OTHERCHARGE' THEN br.amount-br.amtpaid ELSE 0.0 END) AS otherdue 
		from report_bpdelinquency_item rpta  
			inner join report_bpdelinquency rpt on rpta.parentid=rpt.objid 
			inner join business_receivable br on rpta.applicationid=br.applicationid 
		where rpta.parentid = $P{reportid} 
			and rpt.state = 'APPROVED' 
			and rpta.total > 0.0 
			and (br.amount-br.amtpaid) > 0 
	)tmpa 
	group by tmpa.objid, tmpa.parentid, tmpa.applicationid, tmpa.dtfiled, tmpa.surcharge, tmpa.interest 
)tmpb 
	inner join business_application ba on ba.objid=tmpb.applicationid 
	inner join business b on ba.business_objid=b.objid 
where ba.apptype <> 'RETIRE' 
	and ba.appyear < $P{currentyear} 
order by ba.appyear, ba.tradename 
