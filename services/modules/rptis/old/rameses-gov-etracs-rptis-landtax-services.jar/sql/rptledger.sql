[getList]
SELECT 
    ${columns}
FROM rptledger rl 
    INNER JOIN entity e ON rl.taxpayer_objid = e.objid 
    INNER JOIN barangay b ON rl.barangayid = b.objid 
    LEFT JOIN faas f on rl.faasid = f.objid 
WHERE 1=1
${fixfilters}
${filters}
${orderby}


[closePaidAvDifference]
update rptledger_avdifference set 
	paid = 1
where not exists(
	select * from rptledger_item 
	where parentid = rptledger_avdifference.parent_objid
	and year = rptledger_avdifference.year 
	and taxdifference = 1 
)


[findLastPayment]
select
  rpi.year,
  sum(case when rpi.revtype = 'basic' then rpi.amount else 0 end) as basic,
  sum(case when rpi.revtype = 'sef' then rpi.amount else 0 end) as sef
from rptpayment_item rpi
inner join rptpayment rp on rpi.parentid = rp.objid
where rp.refid  =   $P{objid}
and rpi.year = $P{year}
and rp.voided = 0 
group by year 
