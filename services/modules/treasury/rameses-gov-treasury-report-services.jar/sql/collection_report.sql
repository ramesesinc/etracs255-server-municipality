[getReportListing]
select 
	fundtitle, formno, controlid, series, receiptno, receiptdate, amount, payorname, 
	itemid, itemcode, itemtitle, sum(itemamount) as itemamount, 
	collector_objid, collector_name, fundsortorder  
from ( 
	select 
		cr.formno, cr.controlid, cr.series, cr.receiptno, cr.receiptdate, cr.amount, 
		case 
			when t1.voided <> 0 then '***VOIDED***' 
			when cr.payer_name is null then cr.paidby 
			else cr.payer_name 
		end as payorname, 
		case when t1.voided=0 then cri.item_objid else '***VOIDED***' end as itemid, 
		case when t1.voided=0 then cri.item_code else '' end as itemcode,
		case when t1.voided=0 then cri.item_title else '***VOIDED***' end as itemtitle,
		case when t1.voided=0 then cri.amount else 0.00 end as itemamount,
		ia.fund_title as fundtitle, 
		case 
			when ia.fund_objid='GENERAL' then 1 
			when ia.fund_objid='SEF' then 2 
			when ia.fund_objid='TRUST' then 3 
			else 4 
		end as fundsortorder, 
		cr.collector_objid, cr.collector_name 
	from ( 
		select c.objid, c.remittanceid,  
			(select count(*) from cashreceipt_void where receiptid=c.objid) as voided 
		from remittance r  
			inner join collectionvoucher cv on cv.objid = r.collectionvoucherid 
			inner join cashreceipt c on c.remittanceid = r.objid 
		where 'BY_REMITTANCE_DATE' = $P{postingtypeid} 
			and r.controldate >= $P{startdate}
			and r.controldate <  $P{enddate} 
			and r.collector_objid like $P{collectorid} 

		union 

		select c.objid, c.remittanceid,  
			(select count(*) from cashreceipt_void where receiptid=c.objid) as voided 
		from collectionvoucher cv 
			inner join remittance r on r.collectionvoucherid = cv.objid 
			inner join cashreceipt c on c.remittanceid = r.objid 
		where 'BY_LIQUIDATION_DATE' = $P{postingtypeid} 
			and cv.controldate >= $P{startdate} 
			and cv.controldate <  $P{enddate} 
			and r.collector_objid like $P{collectorid}  
	)t1 
		inner join cashreceipt cr on cr.objid = t1.objid 
		inner join cashreceiptitem cri on cri.receiptid = cr.objid  
		left join itemaccount ia on ia.objid = cri.item_objid 
)xx 
group by 
	formno, controlid, series, receiptno, receiptdate, amount, payorname, 
	itemid, itemcode, itemtitle, collector_objid, collector_name, fundtitle, fundsortorder 
order by 
	collector_name, formno, fundsortorder, fundtitle, receiptdate, series, itemcode   


[getReportListingByLiquidation]
select 
	fundtitle, formno, controlid, series, receiptno, receiptdate, amount, payorname, 
	itemid, itemcode, itemtitle, sum(itemamount) as itemamount, 
	collector_objid, collector_name, fundsortorder  
from ( 
	select 
		cr.formno, cr.controlid, cr.series, cr.receiptno, cr.receiptdate, cr.amount, 
		case 
			when xx.voided <> 0 then '***VOIDED***' 
			when cr.payer_name is null then cr.paidby 
			else cr.payer_name 
		end as payorname, 
		case when xx.voided=0 then cri.item_objid else '***VOIDED***' end as itemid, 
		case when xx.voided=0 then cri.item_code else '' end as itemcode,
		case when xx.voided=0 then cri.item_title else '***VOIDED***' end as itemtitle,
		case when xx.voided=0 then cri.amount else 0.00 end as itemamount,
		ia.fund_title as fundtitle, 
		case 
			when ia.fund_objid='GENERAL' then 1 
			when ia.fund_objid='SEF' then 2 
			when ia.fund_objid='TRUST' then 3 
			else 4 
		end as fundsortorder, 
		cr.collector_objid, cr.collector_name 
	from ( 
		select remc.objid, 
			(select count(*) from cashreceipt_void where receiptid=remc.objid) as voided 
		from liquidation liq 
			inner join liquidation_remittance lrem on liq.objid=lrem.liquidationid 
			inner join remittance_cashreceipt remc on remc.remittanceid=lrem.objid 
			inner join remittance rem on remc.remittanceid=rem.objid 
		where liq.dtposted >= $P{startdate} 
			and liq.dtposted < $P{enddate} 
			and rem.collector_objid like $P{collectorid} 
	)xx 
		inner join cashreceipt cr on xx.objid=cr.objid 
		inner join cashreceiptitem cri on cr.objid=cri.receiptid 
		left join itemaccount ia on cri.item_objid = ia.objid 
)xx 
group by 
	formno, controlid, series, receiptno, receiptdate, amount, payorname, 
	itemid, itemcode, itemtitle, collector_objid, collector_name, fundtitle, fundsortorder 
order by 
	collector_name, formno, fundsortorder, fundtitle, receiptdate, series, itemcode   


[getReportFundSummary]
select a.*, b.parentid, b.sortindex  
from ( 
	select 
		convert(cr.receiptdate, date) as receiptdate, 
		ia.fund_objid, ia.fund_title, sum(cri.amount) as amount 
	from ( 
		select remc.objid 
		from remittance rem 
			inner join liquidation_remittance lrem on rem.objid=lrem.objid 		
			inner join remittance_cashreceipt remc on rem.objid=remc.remittanceid 
		where rem.dtposted >= $P{startdate}   
			and rem.dtposted < $P{enddate}   
			and rem.collector_objid like $P{collectorid}  
			and remc.objid not in (select receiptid from cashreceipt_void where receiptid=remc.objid) 
	)xx 
		inner join cashreceipt cr on xx.objid=cr.objid 
		inner join cashreceiptitem cri on cr.objid=cri.receiptid 
		inner join itemaccount ia on cri.item_objid = ia.objid 
	group by convert(cr.receiptdate, date), ia.fund_objid, ia.fund_title 
)a, ( 
	select 
		objid, parentid, 
		case 
			when objid='GENERAL' then 1
			when objid='SEF' then 3
			when objid='TRUST' then 5 
			else 10   
		end as sortindex 
	from fund 
	where parentid is null 
	union all 
	select 
		objid, parentid, 
		case 
			when parentid='GENERAL' then 2
			when parentid='SEF' then 4
			when parentid='TRUST' then 6 
			else 11   
		end as sortindex 
	from fund 
	where parentid is not null 
)b 
where a.fund_objid=b.objid 
order by a.receiptdate, b.sortindex 
