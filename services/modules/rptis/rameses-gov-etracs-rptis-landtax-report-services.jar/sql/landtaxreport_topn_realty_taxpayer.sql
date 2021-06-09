[getTopNPayments]
select distinct 
    amount
from (
    select 
        case when c.payer_objid is null or c.payer_name = 'UNKNOWN' then c.paidby else c.payer_objid end as payer_objid, 
        min(cro.year) as fromyear, 
        max(cro.year) as toyear, 
        sum(basic + basicint - basicdisc + 
        sef + sefint - sefdisc + firecode +
        basicidle + basicidleint - basicidledisc +
        sh + shint - shdisc ) as amount 
    from cashreceipt c
        inner join cashreceipt_rpt cr on c.objid = cr.objid 
        inner join rptpayment rp on cr.objid = rp.receiptid 
        inner join vw_rptpayment_item_detail cro on rp.objid = cro.parentid
        inner join rptledger rl on rp.refid = rl.objid 
        inner join remittance rem on rem.objid = c.remittanceid 
        inner join collectionvoucher l on l.objid = rem.collectionvoucherid 
        left join cashreceipt_void cv on c.objid = cv.receiptid
    where year(l.dtposted) = $P{year}
        and rl.rputype like $P{type}
        and cv.objid is null 
    group by case when c.payer_objid is null or c.payer_name = 'UNKNOWN' then c.paidby else c.payer_objid end
)x
order by x.amount desc 


[getTopNTaxpayerPayments]
select 
    x.payer_objid,
    x.payer_name, 
    x.amount,
    x.fromyear,
    x.toyear
from (
    select 
        case when c.payer_objid is null or c.payer_name = 'UNKNOWN' then c.paidby else c.payer_objid end as payer_objid,
        case when c.payer_objid is null or c.payer_name = 'UNKNOWN' then c.paidby else c.payer_name end as payer_name,
        min(cro.year) as fromyear, 
        max(cro.year) as toyear, 
        sum(basic + basicint - basicdisc + 
        sef + sefint - sefdisc + firecode +
        basicidle + basicidleint - basicidledisc) as amount 
    from cashreceipt c
        inner join cashreceipt_rpt cr on c.objid = cr.objid
        inner join rptpayment rp on cr.objid = rp.receiptid 
        inner join vw_rptpayment_item_detail cro on rp.objid = cro.parentid
        inner join rptledger rl on rp.refid = rl.objid 
        inner join remittance rem on rem.objid = c.remittanceid 
        inner join collectionvoucher l on l.objid = rem.collectionvoucherid 
        left join cashreceipt_void cv on c.objid = cv.receiptid
    where year(l.dtposted) = $P{year}
        and rl.rputype like $P{type}
        and cv.objid is null 
    group by 
        case when c.payer_objid is null or c.payer_name = 'UNKNOWN' then c.paidby else c.payer_objid end,
        case when c.payer_objid is null or c.payer_name = 'UNKNOWN' then c.paidby else c.payer_name end
)x
where x.amount = $P{amount}
order by x.payer_objid, x.payer_name



