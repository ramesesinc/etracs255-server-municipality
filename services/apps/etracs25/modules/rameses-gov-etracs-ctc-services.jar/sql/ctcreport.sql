[getAbstractCTCIndividual]
SELECT
	r.controlno as txnno, r.dtposted as txndate,
	r.controlno, r.controldate, c.receiptno AS orno,
	CASE WHEN cv.objid IS null THEN c.receiptdate ELSE NULL END AS ordate,
	CASE WHEN cv.objid IS null THEN c.paidby ELSE '*** VOIDED ***' END AS paidby,
	CASE WHEN cv.objid IS null THEN c.amount ELSE 0.0 END AS amount,
	r.collector_name as collectorname,
	r.collector_title as  collectortitle,
	r.liquidatingofficer_name as liquidatingofficername,
	r.liquidatingofficer_title as liquidatingofficertitle,
	CASE WHEN cv.objid IS null THEN 0 else 1 end as voided,
	ctci.basictax as basic, 
	(ctci.salarytax + ctci.propertyincometax + ctci.businessgrosstax + ctci.additionaltax) as additional,
	ctci.interestdue as penalty,
	ctci.amountdue as total 
FROM remittance r
	INNER JOIN cashreceipt c on c.remittanceid = r.objid 
	INNER JOIN cashreceipt_ctc_individual ctci on ctci.objid = c.objid 
	LEFT JOIN cashreceipt_void cv on cv.receiptid = c.objid 
WHERE r.objid = $P{objid} 
  AND c.formno = '0016' 


[getTaxRoll]
select 
	rem.remittancedate, rem.txnno, rem.collector_name, 
	cr.paidby, cr.paidbyaddress, cr.receiptdate, cr.receiptno, ei.birthdate, 
	ctci.basictax, ctci.additionaltax, ctci.interest, 
	(ctci.basictax + ctci.additionaltax + ctci.interest) as total, 
	cr.objid as receiptid 
from remittance rem 
	inner join cashreceipt cr on cr.remittanceid = rem.objid 
	inner join cashreceipt_ctc_individual ctci on cr.objid=ctci.objid 
	left join entityindividual ei on cr.payer_objid=ei.objid 
where rem.remittancedate >= $P{startdate} 
	and rem.remittancedate < $P{enddate} 
	and cr.formno='0016' 
order by rem.remittancedate, rem.collector_name, cr.series   
