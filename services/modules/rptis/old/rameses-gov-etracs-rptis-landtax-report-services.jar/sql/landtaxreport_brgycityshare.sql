[getCollectionsByBarangay]
select   
	b.indexno as brgyindex, 
	b.name as brgyname,
	sum(ri.amount) as basictotal,
	sum(case when ri.sharetype = 'barangay' then ri.amount else 0 end) as basic30,
	0 as brgyshare,
	0 as commonshare
from remittance rem 
	inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
	inner join cashreceipt cr on cr.remittanceid = rem.objid 
	inner join rptpayment rp on cr.objid = rp.receiptid 
	inner join rptpayment_share ri on rp.objid = ri.parentid
	left join rptledger rl on rp.refid = rl.objid 
	left join barangay b on rl.barangayid = b.objid 
where ${filter} 
	and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
	and ri.revperiod <> 'advance' 
	and ri.revtype in ('basic', 'basicint')
group by b.indexno, b.name
order by b.indexno



[getBarangays]
select 
	b.indexno as brgyindex, 
	b.name as brgyname,
	0 as basictotal,
	0 as basic30,
	0 as brgyshare,
	0 as commonshare
from barangay b
order by b.indexno 
