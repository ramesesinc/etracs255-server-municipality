[findLedgerInfo]
select 
    e.entityno, e.name, e.address_text AS address,  
    pc.code AS classcode, 
    rl.*
from rptledger rl 
    inner join entity e on rl.taxpayer_objid = e.objid 
    inner join propertyclassification pc on rl.classification_objid = pc.objid 
where rl.objid = $P{objid}



[getLedgerCredits]
select 
    rp.receiptno as refno,
    rp.receiptdate as refdate,
    case when cr.collector_name is null then rp.postedby else cr.collector_name end as collector_name,
    case when cr.paidby is null then rp.paidby_name else cr.paidby end as paidby_name,
    rp.fromyear,
    rp.fromqtr,
    rp.toyear,
    rp.toqtr,
    rp.type as mode,
    rpi.partialled,
    rlf.tdno,
    rlf.assessedvalue,
    sum(rpi.basic) as basic,
    sum(rpi.basicint) as basicint,
    sum(rpi.basicdisc) as basicdisc,
    sum(rpi.basicidle - rpi.basicidledisc + rpi.basicidleint) as basicidle,
    sum(rpi.sef) as sef,
    sum(rpi.sefint) as sefint,
    sum(rpi.sefdisc) as sefdisc,
    sum(rpi.firecode) as firecode,
    sum(rpi.sh - rpi.shdisc + rpi.shint) as sh,
    sum(rpi.basic+ rpi.basicint - rpi.basicdisc + 
        rpi.basicidle - rpi.basicidledisc + rpi.basicidleint +
        rpi.sef + rpi.sefint - rpi.sefdisc + 
        rpi.sh + rpi.shint - rpi.shdisc + rpi.firecode) as amount
from rptpayment rp 
    inner join vw_rptpayment_item rpi on rp.objid = rpi.parentid
    inner join rptledger rl on rp.refid = rl.objid 
    left join rptledgerfaas rlf on rpi.rptledgerfaasid = rlf.objid 
    left join cashreceipt cr on rp.receiptid = cr.objid 
    left join cashreceipt_void cv on cr.objid = cv.receiptid 
where rp.refid = $P{objid}
    and cv.objid is null    
group by 
    rp.receiptno,
    rp.receiptdate,
    cr.collector_name,
    cr.paidby,
    rp.fromyear,
    rp.fromqtr,
    rp.toyear,
    rp.toqtr,
    rp.type,
    rpi.partialled,
    rlf.tdno,
    rlf.assessedvalue,
    rp.postedby,
    rp.paidby_name
    
