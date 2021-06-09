[findBeginBalance]
select sum(dr) as dr, sum(cr) as cr, sum(dr)-sum(cr) as balance 
from ( 
	select sum(dr) as dr, sum(cr) as cr 
	from vw_cashbook_cashreceipt 
	where refdate < $P{fromdate} 
		and collectorid = $P{accountid} 
		and fundid = $P{fundid} 
	union all 
	select sum(dr) as dr, sum(cr) as cr 
	from vw_cashbook_cashreceiptvoid 
	where refdate < $P{fromdate} 
		and collectorid = $P{accountid} 
		and fundid = $P{fundid} 
	union all 
	select sum(v.dr) as dr, sum(v.cr) as cr  
	from vw_cashbook_remittance v, remittance r  
	where v.refdate < $P{fromdate} 
		and v.collectorid = $P{accountid} 
		and v.fundid = $P{fundid} 
		and v.objid = r.objid 
		and r.liquidatingofficer_objid is not null 
)t1 


[findRevolvingFund]
select 
	year(controldate) as controlyear, 
	month(controldate) as controlmonth, 
	sum(amount) as amount, 
	((year(controldate)*12) + month(controldate)) as indexno 
from cashbook_revolving_fund 
where issueto_objid = $P{accountid} 
	and controldate <= $P{fromdate} 
	and state = 'POSTED' 
group by year(controldate), month(controldate), ((year(controldate)*12) + month(controldate)) 
order by ((year(controldate)*12) + month(controldate)) desc 


[getDetails]
select refdate, refno, reftype, sum(dr) as dr, sum(cr) as cr, sortdate 
from ( 
	select refdate, refno, reftype, sum(dr) as dr, sum(cr) as cr, sortdate 
	from ( 
		select refdate, refno, reftype, sum(dr) as dr, 0.0 as cr, sortdate 
		from vw_cashbook_cashreceipt 
		where refdate >= $P{fromdate} 
			and refdate <  $P{todate} 
			and collectorid = $P{accountid} 
			and fundid in (${fundfilter})
		group by refdate, refno, reftype, sortdate 
		union all 
		select refdate, refno, reftype, -sum(dr) as dr, 0.0 as cr, sortdate 
		from vw_cashbook_cashreceipt_share  
		where refdate >= $P{fromdate} 
			and refdate <  $P{todate} 
			and collectorid = $P{accountid} 
			and fundid in (${fundfilter})
		group by refdate, refno, reftype, sortdate 
		union all 
		select refdate, refno, reftype, sum(dr) as dr, 0.0 as cr, sortdate 
		from vw_cashbook_cashreceipt_share_payable  
		where refdate >= $P{fromdate} 
			and refdate <  $P{todate} 
			and collectorid = $P{accountid} 
			and fundid in (${fundfilter})
		group by refdate, refno, reftype, sortdate 
	)t0 
	group by refdate, refno, reftype, sortdate 

	union all 

	select refdate, refno, reftype, sum(dr) as dr, sum(cr) as cr, sortdate 
	from ( 
		select refdate, refno, reftype, sum(dr) as dr, sum(cr) as cr, sortdate 
		from vw_cashbook_remittance 
		where refdate >= $P{fromdate} 
			and refdate <  $P{todate} 
			and collectorid = $P{accountid} 
			and fundid in (${fundfilter})
			and liquidatingofficer_objid is not null 
		group by refdate, refno, reftype, sortdate 
		union all 
		select refdate, refno, reftype, -sum(dr) as dr, -sum(cr) as cr, sortdate 
		from vw_cashbook_remittance 
		where refdate >= $P{fromdate} 
			and refdate <  $P{todate} 
			and collectorid = $P{accountid} 
			and fundid in (${fundfilter})
			and liquidatingofficer_objid is not null 
			and voiddate <= txndate 
		group by refdate, refno, reftype, sortdate 
	)t0 
	group by refdate, refno, reftype, sortdate 

	union all 

	select refdate, refno, reftype, -sum(dr) as dr, -sum(cr) as cr, sortdate 
	from ( 
		select refdate, refno, reftype, sum(dr) as dr, sum(cr) as cr, sortdate 
		from vw_cashbook_remittance_share  
		where refdate >= $P{fromdate} 
			and refdate <  $P{todate} 
			and collectorid = $P{accountid} 
			and fundid in (${fundfilter})
			and liquidatingofficer_objid is not null 
		group by refdate, refno, reftype, sortdate 
		union all 
		select refdate, refno, reftype, -sum(dr) as dr, -sum(cr) as cr, sortdate 
		from vw_cashbook_remittance_share 
		where refdate >= $P{fromdate} 
			and refdate <  $P{todate} 
			and collectorid = $P{accountid} 
			and fundid in (${fundfilter})
			and liquidatingofficer_objid is not null 
			and voiddate <= txndate 
		group by refdate, refno, reftype, sortdate 
	)t0 
	group by refdate, refno, reftype, sortdate 

	union all 

	select refdate, refno, reftype, sum(dr) as dr, sum(cr) as cr, sortdate 
	from ( 
		select refdate, refno, reftype, sum(dr) as dr, sum(cr) as cr, sortdate 
		from vw_cashbook_remittance_share_payable
		where refdate >= $P{fromdate} 
			and refdate <  $P{todate} 
			and collectorid = $P{accountid} 
			and fundid in (${fundfilter})
			and liquidatingofficer_objid is not null 
		group by refdate, refno, reftype, sortdate 
		union all 
		select refdate, refno, reftype, -sum(dr) as dr, -sum(cr) as cr, sortdate 
		from vw_cashbook_remittance_share_payable 
		where refdate >= $P{fromdate} 
			and refdate <  $P{todate} 
			and collectorid = $P{accountid} 
			and fundid in (${fundfilter})
			and liquidatingofficer_objid is not null 
			and voiddate <= txndate 
		group by refdate, refno, reftype, sortdate 
	)t0 
	group by refdate, refno, reftype, sortdate 

	union all 

	select refdate, refno, reftype, -sum(dr) as dr, -sum(cr) as cr, sortdate 
	from ( 
		select refdate, refno, reftype, sum(dr) as dr, 0.0 as cr, sortdate 
		from vw_cashbook_cashreceiptvoid 
		where refdate >= $P{fromdate} 
			and refdate <  $P{todate} 
			and collectorid = $P{accountid} 
			and fundid in (${fundfilter})
			and (remittanceid is null or txndate <= remittancedtposted) 
		group by refdate, refno, reftype, sortdate 
		union all 
		select refdate, refno, reftype, -sum(dr) as dr, 0.0 as cr, sortdate 
		from vw_cashbook_cashreceiptvoid_share
		where refdate >= $P{fromdate} 
			and refdate <  $P{todate} 
			and collectorid = $P{accountid} 
			and fundid in (${fundfilter}) 
			and (remittanceid is null or txndate <= remittancedtposted) 
		group by refdate, refno, reftype, sortdate 
		union all 
		select refdate, refno, reftype, sum(dr) as dr, 0.0 as cr, sortdate 
		from vw_cashbook_cashreceiptvoid_share_payable
		where refdate >= $P{fromdate} 
			and refdate <  $P{todate} 
			and collectorid = $P{accountid} 
			and fundid in (${fundfilter}) 
			and (remittanceid is null or txndate <= remittancedtposted) 
		group by refdate, refno, reftype, sortdate 
	)t0 
	group by refdate, refno, reftype, sortdate 

	union all 

	select refdate, refno, reftype, -sum(dr) as dr, -sum(cr) as cr, sortdate 
	from ( 
		select refdate, refno, reftype, sum(dr) as dr, sum(dr) as cr, sortdate 
		from vw_cashbook_cashreceiptvoid 
		where refdate >= $P{fromdate} 
			and refdate <  $P{todate} 
			and collectorid = $P{accountid} 
			and fundid in (${fundfilter})
			and txndate > remittancedtposted 
		group by refdate, refno, reftype, sortdate 
		union all 
		select refdate, refno, reftype, -sum(dr) as dr, -sum(dr) as cr, sortdate 
		from vw_cashbook_cashreceiptvoid_share
		where refdate >= $P{fromdate} 
			and refdate <  $P{todate} 
			and collectorid = $P{accountid} 
			and fundid in (${fundfilter})
			and txndate > remittancedtposted 
		group by refdate, refno, reftype, sortdate 
		union all 
		select refdate, refno, reftype, sum(dr) as dr, sum(dr) as cr, sortdate 
		from vw_cashbook_cashreceiptvoid_share_payable
		where refdate >= $P{fromdate} 
			and refdate <  $P{todate} 
			and collectorid = $P{accountid} 
			and fundid in (${fundfilter})
			and txndate > remittancedtposted 
		group by refdate, refno, reftype, sortdate 
	)t0 
	group by refdate, refno, reftype, sortdate 
)tt 
group by refdate, refno, reftype, sortdate 
order by sortdate, refdate 


[getSummaries]
select refdate, particulars, refno, sum(dr) as dr, sum(cr) as cr, min(sortdate) as sortdate, min(idxno) as idxno 
from ( 
	select 
		0 as idxno, t.refdate, t.controlid, t.formno, min(t.series) as minseries, min(t.series) as maxseries, 
		min((case when t.formno = '51' then 'VARIOUS TAXES AND FEES' else t.af_title end)) as particulars,
		min(('*** VOIDED - AF '+ t.formno +'#'+ t.refno +' ***')) as refno, 0 as unremitted, 
		-sum(t.dr) as dr, -sum(t.cr) as cr, min(t.sortdate) as sortdate 
	from ( 
		select 
			v.refdate, v.refno, v.refid as controlid, v.formno, v.series, af.title as af_title, v.dr, v.cr, v.sortdate 
		from vw_cashbook_cashreceiptvoid v 
			inner join af on af.objid = v.formno 
		where v.refdate >= $P{fromdate} 
			and v.refdate <  $P{todate} 
			and v.receiptdate < v.refdate 
			and v.collectorid = $P{accountid} 
			and v.fundid in (${fundfilter}) 
		union all 
		select 
			v.refdate, v.refno, v.refid as controlid, v.formno, v.series, af.title as af_title, -v.dr, -v.cr, v.sortdate 
		from vw_cashbook_cashreceiptvoid_share v 
			inner join af on af.objid = v.formno 
		where v.refdate >= $P{fromdate} 
			and v.refdate <  $P{todate} 
			and v.receiptdate < v.refdate 
			and v.collectorid = $P{accountid} 
			and v.fundid in (${fundfilter}) 
		union all 
		select 
			v.refdate, v.refno, v.refid as controlid, v.formno, v.series, af.title as af_title, v.dr, v.cr, v.sortdate 
		from vw_cashbook_cashreceiptvoid_share_payable v 
			inner join af on af.objid = v.formno 
		where v.refdate >= $P{fromdate} 
			and v.refdate <  $P{todate} 
			and v.receiptdate < v.refdate 
			and v.collectorid = $P{accountid} 
			and v.fundid in (${fundfilter}) 
	)t 
	group by t.refdate, t.controlid, t.formno  

	union all 

	select 
		1 as idxno, refdate, controlid, formno, min(series) as minseries, max(series) as maxseries, 
		(case when formno = '51' then 'VARIOUS TAXES AND FEES' else af_title end) as particulars, 
		('AF '+ formno +'#'+ min(refno) +'-'+ max(refno)) as refno, unremitted, 
		sum(dr) as dr, 0.0 as cr, min(sortdate) as sortdate 
	from ( 
		select 
			c.refdate, c.controlid, c.formno, c.series, 
			af.title as af_title, c.refno, c.dr, c.cr, c.sortdate, 
			(case when c.remittanceid is null then 1 else 0 end) as unremitted 
		from vw_cashbook_cashreceipt c  
			inner join af on af.objid = c.formno 
		where c.refdate >= $P{fromdate} 
			and c.refdate <  $P{todate} 
			and c.collectorid = $P{accountid} 
			and c.fundid in (${fundfilter}) 
			and af.formtype = 'serial' 
		union all 
		select 
			c.refdate, c.controlid, c.formno, c.series, 
			af.title as af_title, c.refno, -c.dr as dr, c.cr, c.sortdate, 
			(case when c.remittanceid is null then 1 else 0 end) as unremitted 
		from vw_cashbook_cashreceipt_share c  
			inner join af on af.objid = c.formno 
		where c.refdate >= $P{fromdate} 
			and c.refdate <  $P{todate} 
			and c.collectorid = $P{accountid} 
			and c.fundid in (${fundfilter}) 
			and af.formtype = 'serial' 
		union all 
		select 
			c.refdate, c.controlid, c.formno, c.series, 
			af.title as af_title, c.refno, c.dr, c.cr, c.sortdate, 
			(case when c.remittanceid is null then 1 else 0 end) as unremitted 
		from vw_cashbook_cashreceipt_share_payable c  
			inner join af on af.objid = c.formno 
		where c.refdate >= $P{fromdate} 
			and c.refdate <  $P{todate} 
			and c.collectorid = $P{accountid} 
			and c.fundid in (${fundfilter}) 
			and af.formtype = 'serial' 
	)t0 
	group by refdate, formno, controlid, unremitted, 
		(case when formno = '51' then 'VARIOUS TAXES AND FEES' else af_title end) 

	union all 

	select 
		1 as idxno, t.refdate, null as controlid, null as formno, null as minseries, null as maxseries, 
		('REMITTANCE - '+ t.liquidatingofficer_name) as particulars, t.refno, 0 as unremitted, 
		sum(t.dr) as dr, sum(t.cr) as cr, min(t.sortdate) as sortdate  
	from ( 
		select 
			r.refdate, r.refno, r.liquidatingofficer_name, r.dr, r.cr, r.sortdate 
		from vw_cashbook_remittance r 
		where r.refdate >= $P{fromdate} 
			and r.refdate <  $P{todate} 
			and r.collectorid = $P{accountid} 
			and r.fundid in (${fundfilter}) 
			and r.liquidatingofficer_objid is not null 
		union all 
		select 
			r.refdate, r.refno, r.liquidatingofficer_name, -r.dr as dr, -r.cr as cr, r.sortdate 
		from vw_cashbook_remittance r 
		where r.refdate >= $P{fromdate} 
			and r.refdate <  $P{todate} 
			and r.collectorid = $P{accountid} 
			and r.fundid in (${fundfilter}) 
			and r.liquidatingofficer_objid is not null 
			and r.voiddate <= r.txndate 
	)t 
	group by t.refdate, t.refno, ('REMITTANCE - '+ t.liquidatingofficer_name) 

	union all 

	select 
		1 as idxno, t.refdate, null as controlid, null as formno, null as minseries, null as maxseries, 
		('REMITTANCE - '+ t.liquidatingofficer_name) as particulars, t.refno, 0 as unremitted, 
		-sum(t.dr) as dr, -sum(t.cr) as cr, min(t.sortdate) as sortdate  
	from ( 
		select r.refdate, r.refno, r.liquidatingofficer_name, r.dr, r.cr, r.sortdate 
		from vw_cashbook_remittance_share r 
		where r.refdate >= $P{fromdate} 
			and r.refdate <  $P{todate} 
			and r.collectorid = $P{accountid} 
			and r.fundid in (${fundfilter}) 
			and r.liquidatingofficer_objid is not null 
		union all 
		select r.refdate, r.refno, r.liquidatingofficer_name, -r.dr as dr, -r.cr as cr, r.sortdate 
		from vw_cashbook_remittance_share r 
		where r.refdate >= $P{fromdate} 
			and r.refdate <  $P{todate} 
			and r.collectorid = $P{accountid} 
			and r.fundid in (${fundfilter}) 
			and r.liquidatingofficer_objid is not null 
			and r.voiddate <= r.txndate 
	)t 
	group by t.refdate, t.refno, ('REMITTANCE - '+ t.liquidatingofficer_name) 

	union all 

	select 
		1 as idxno, t.refdate, null as controlid, null as formno, null as minseries, null as maxseries, 
		('REMITTANCE - '+ t.liquidatingofficer_name) as particulars, t.refno, 0 as unremitted, 
		sum(t.dr) as dr, sum(t.cr) as cr, min(t.sortdate) as sortdate  
	from ( 
		select r.refdate, r.refno, r.liquidatingofficer_name, r.dr, r.cr, r.sortdate 
		from vw_cashbook_remittance_share_payable r 
		where r.refdate >= $P{fromdate} 
			and r.refdate <  $P{todate} 
			and r.collectorid = $P{accountid} 
			and r.fundid in (${fundfilter}) 
		union all 
		select r.refdate, r.refno, r.liquidatingofficer_name, -r.dr as dr, -r.cr as cr, r.sortdate 
		from vw_cashbook_remittance_share_payable r 
		where r.refdate >= $P{fromdate} 
			and r.refdate <  $P{todate} 
			and r.collectorid = $P{accountid} 
			and r.fundid in (${fundfilter}) 
			and r.voiddate <= r.txndate 
	)t 
	group by t.refdate, t.refno, ('REMITTANCE - '+ t.liquidatingofficer_name) 

	union all 

	select 
		1 as idxno, t.refdate, t.controlid, t.formno, min(t.series) as minseries, min(t.series) as maxseries, 
		min((case when t.formno = '51' then 'VARIOUS TAXES AND FEES' else t.af_title end)) as particulars,
		min(('*** VOIDED - AF '+ t.formno +'#'+ t.refno +' ***')) as refno, 0 as unremitted, 
		-sum(t.dr) as dr, -sum(t.cr) as cr, min(t.sortdate) as sortdate 
	from ( 
		select 
			v.refdate, v.refno, v.refid as controlid, v.formno, v.series, af.title as af_title, v.dr, v.cr, v.sortdate 
		from vw_cashbook_cashreceiptvoid v 
			inner join af on af.objid = v.formno 
		where v.refdate >= $P{fromdate} 
			and v.refdate <  $P{todate} 
			and v.receiptdate >= v.refdate 
			and v.collectorid = $P{accountid} 
			and v.fundid in (${fundfilter}) 
		union all 
		select 
			v.refdate, v.refno, v.refid as controlid, v.formno, v.series, af.title as af_title, -v.dr, -v.cr, v.sortdate 
		from vw_cashbook_cashreceiptvoid_share v 
			inner join af on af.objid = v.formno 
		where v.refdate >= $P{fromdate} 
			and v.refdate <  $P{todate} 
			and v.receiptdate >= v.refdate 
			and v.collectorid = $P{accountid} 
			and v.fundid in (${fundfilter}) 
		union all 
		select 
			v.refdate, v.refno, v.refid as controlid, v.formno, v.series, af.title as af_title, v.dr, v.cr, v.sortdate 
		from vw_cashbook_cashreceiptvoid_share_payable v 
			inner join af on af.objid = v.formno 
		where v.refdate >= $P{fromdate} 
			and v.refdate <  $P{todate} 
			and v.receiptdate >= v.refdate 
			and v.collectorid = $P{accountid} 
			and v.fundid in (${fundfilter}) 
	)t 
	group by t.refdate, t.controlid, t.formno  
)tt 
group by refdate, particulars, refno 
order by refdate, min(idxno), min(sortdate) 

[findBeginBalance2]
select sum(dr) as dr, sum(cr) as cr, sum(dr)-sum(cr) as balance  
from ( 
	select sum(dr) as dr, sum(cr) as cr 
	from ( 
		select sum(c.dr) as dr, 0.0 as cr 
		from vw_cashbook_cashreceipt c  
		where c.refdate >= $P{fromdate} 
			and c.refdate <  $P{todate} 
			and c.collectorid = $P{accountid} 
			and c.fundid in (${fundfilter}) 
		union all 
		select -sum(c.dr) as dr, 0.0 as cr 
		from vw_cashbook_cashreceipt_share c  
		where c.refdate >= $P{fromdate} 
			and c.refdate <  $P{todate} 
			and c.collectorid = $P{accountid} 
			and c.fundid in (${fundfilter}) 
		union all 
		select sum(c.dr) as dr, 0.0 as cr 
		from vw_cashbook_cashreceipt_share_payable c  
		where c.refdate >= $P{fromdate} 
			and c.refdate <  $P{todate} 
			and c.collectorid = $P{accountid} 
			and c.fundid in (${fundfilter}) 
	)t0 

	union all 

	select sum(dr) as dr, sum(cr) as cr 
	from ( 
		select sum(r.dr) as dr, sum(r.cr) as cr 
		from vw_cashbook_remittance r 
		where r.refdate >= $P{fromdate} 
			and r.refdate <  $P{todate} 
			and r.collectorid = $P{accountid} 
			and r.fundid in (${fundfilter}) 
			and r.liquidatingofficer_objid is not null 
		union all 
		select -sum(r.dr) as dr, -sum(r.cr) as cr 
		from vw_cashbook_remittance r 
		where r.refdate >= $P{fromdate} 
			and r.refdate <  $P{todate} 
			and r.collectorid = $P{accountid} 
			and r.fundid in (${fundfilter}) 
			and r.liquidatingofficer_objid is not null 
			and r.voiddate <= r.txndate 
	)t0 

	union all 

	select -sum(dr) as dr, -sum(cr) as cr 
	from ( 
		select sum(r.dr) as dr, sum(r.cr) as cr 
		from vw_cashbook_remittance_share r 
		where r.refdate >= $P{fromdate} 
			and r.refdate <  $P{todate} 
			and r.collectorid = $P{accountid} 
			and r.fundid in (${fundfilter}) 
			and r.liquidatingofficer_objid is not null 
		union all 
		select -sum(r.dr) as dr, -sum(r.cr) as cr 
		from vw_cashbook_remittance_share r 
		where r.refdate >= $P{fromdate} 
			and r.refdate <  $P{todate} 
			and r.collectorid = $P{accountid} 
			and r.fundid in (${fundfilter}) 
			and r.liquidatingofficer_objid is not null 
			and r.voiddate <= r.txndate 
	)t0 

	union all 

	select sum(dr) as dr, sum(cr) as cr 
	from ( 
		select sum(r.dr) as dr, sum(r.cr) as cr 
		from vw_cashbook_remittance_share_payable r 
		where r.refdate >= $P{fromdate} 
			and r.refdate <  $P{todate} 
			and r.collectorid = $P{accountid} 
			and r.fundid in (${fundfilter}) 
		union all 
		select -sum(r.dr) as dr, -sum(r.cr) as cr 
		from vw_cashbook_remittance_share_payable r 
		where r.refdate >= $P{fromdate} 
			and r.refdate <  $P{todate} 
			and r.collectorid = $P{accountid} 
			and r.fundid in (${fundfilter}) 
			and r.voiddate <= r.txndate 
	)t0 

	union all 

	select -sum(dr) as dr, -sum(cr) as cr 
	from ( 
		select sum(v.dr) as dr, sum(v.cr) as cr 
		from vw_cashbook_cashreceiptvoid v 
			inner join af on af.objid = v.formno 
		where v.refdate >= $P{fromdate} 
			and v.refdate <  $P{todate} 
			and v.collectorid = $P{accountid} 
			and v.fundid in (${fundfilter}) 
		union all 
		select -sum(v.dr) as dr, -sum(v.cr) as cr 
		from vw_cashbook_cashreceiptvoid_share v 
			inner join af on af.objid = v.formno 
		where v.refdate >= $P{fromdate} 
			and v.refdate <  $P{todate} 
			and v.collectorid = $P{accountid} 
			and v.fundid in (${fundfilter}) 
		union all 
		select sum(v.dr) as dr, sum(v.cr) as cr 
		from vw_cashbook_cashreceiptvoid_share_payable v 
			inner join af on af.objid = v.formno 
		where v.refdate >= $P{fromdate} 
			and v.refdate <  $P{todate} 
			and v.collectorid = $P{accountid} 
			and v.fundid in (${fundfilter}) 
	)t0 
)tt
