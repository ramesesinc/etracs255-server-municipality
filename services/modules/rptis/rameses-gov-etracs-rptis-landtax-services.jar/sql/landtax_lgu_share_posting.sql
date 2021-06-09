[findPaidLedger]
select rl.objid, c.objid as receiptid, rp.objid as paymentid, rp.amount 
from cashreceipt c 
inner join rptpayment rp on c.objid = rp.receiptid 
inner join rptledger rl on rp.refid = rl.objid 
where c.objid = $P{receiptid}
and rl.objid = $P{rptledgerid}

[getPaidItems]
select 
	rl.lguid, 
	o.parent_objid as provid, 
	rl.barangayid,
	rp.receiptid,
	rp.objid as paymentid,
	rpi.revtype,
	rpi.revperiod,
	null as year, 
	sum(rpi.amount) as amount,
	sum(rpi.interest) as interest,
	sum(rpi.discount) as discount 
from rptpayment rp 
inner join rptpayment_item rpi on rp.objid = rpi.parentid 
inner join rptledger rl on rp.refid = rl.objid 
left join sys_org o on rl.lguid = o.objid 
where rp.refid = $P{objid}
and rp.receiptid = $P{receiptid}
and rpi.revperiod <> 'advance'
and rpi.amount > 0
group by 
	rl.lguid,
	o.parent_objid,
	rl.barangayid,
	rp.receiptid,
	rp.objid,
	rpi.revtype,
	rpi.revperiod

union all 

select 
	rl.lguid, 
	o.parent_objid as provid, 
	rl.barangayid,
	rp.receiptid,
	rp.objid as paymentid,
	rpi.revtype,
	rpi.revperiod,
	rpi.year, 
	sum(rpi.amount) as amount,
	sum(rpi.interest) as interest,
	sum(rpi.discount) as discount 
from rptpayment rp 
inner join rptpayment_item rpi on rp.objid = rpi.parentid 
inner join rptledger rl on rp.refid = rl.objid 
left join sys_org o on rl.lguid = o.objid 
where rp.refid = $P{objid}
and rp.receiptid = $P{receiptid}
and rpi.revperiod = 'advance'
and rpi.amount > 0
group by 
	rl.lguid,
	o.parent_objid,
	rl.barangayid,
	rp.receiptid,
	rp.objid,
	rpi.revtype,
	rpi.revperiod,
	rpi.year



[findPendingReceiptForPosting]
select count(*) as cnt 
from remittance r 
inner join cashreceipt cr on r.objid = cr.remittanceid
inner join cashreceipt_rpt_share_forposting s on cr.objid = s.receiptid
${filter}