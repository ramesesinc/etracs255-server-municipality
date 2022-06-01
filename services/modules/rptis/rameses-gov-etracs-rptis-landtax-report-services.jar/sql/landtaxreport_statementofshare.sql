[getIdleLandSharesAbstract]
select 
    b.name as barangay,
    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidle' then cra.amount else 0 end) as brgycurr,
    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidleint' then cra.amount else 0 end) as brgycurrpenalty,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidle' then cra.amount else 0 end) as brgyprev,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidleint' then cra.amount else 0 end) as brgyprevpenalty,
    sum(0.0) as brgypenalty,
    sum(case when cra.revperiod <> 'advance' and cra.revtype in ('basicidle','basicidleint') then cra.amount else 0 end) as brgytotal,

    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidle' and cra.sharetype = 'city' then cra.amount else 0 end) as citycurrshare,
    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidleint' and cra.sharetype = 'city' then cra.amount else 0 end) as citycurrsharepenalty,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidle' and cra.sharetype = 'city' then cra.amount else 0 end) as cityprevshare,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidleint' and cra.sharetype = 'city' then cra.amount else 0 end) as cityprevsharepenalty,
    sum(0.0) as citypenaltyshare,
    sum(case when cra.revperiod <> 'advance' and cra.revtype in ('basicidle','basicidleint') and cra.sharetype = 'city' then cra.amount else 0 end) as citysharetotal,

    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidle' and cra.sharetype = 'municipality' then cra.amount else 0 end) as municurrshare,
    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidleint' and cra.sharetype = 'municipality' then cra.amount else 0 end) as municurrsharepenalty,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidle' and cra.sharetype = 'municipality' then cra.amount else 0 end) as muniprevshare,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidleint' and cra.sharetype = 'municipality' then cra.amount else 0 end) as muniprevsharepenalty,
    sum(0.0) as munipenaltyshare,
    sum(case when cra.revperiod <> 'advance' and cra.revtype in ('basicidle','basicidleint') and cra.sharetype = 'municipality' then cra.amount else 0 end) as munisharetotal,

    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidle' and cra.sharetype = 'province' then cra.amount else 0 end) as provcurrshare,
    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidleint' and cra.sharetype = 'province' then cra.amount else 0 end) as provcurrsharepenalty,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidle' and cra.sharetype = 'province' then cra.amount else 0 end) as provprevshare,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidleint' and cra.sharetype = 'province' then cra.amount else 0 end) as provprevsharepenalty,
    sum(0.0) as provpenaltyshare,
    sum(case when cra.revperiod <> 'advance' and  cra.revtype in ('basicidle','basicidleint') and cra.sharetype = 'province' then cra.amount else 0 end) as provsharetotal
from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share cra on rp.objid = cra.parentid
    left join rptledger rl on rp.refid = rl.objid
    left join barangay b on rl.barangayid = b.objid 
where ${filter}   
    and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
    and cra.revtype in  ('basicidle', 'basicidleint') 
    and cra.amount > 0
group by b.name 


[getIdleLandShares]
select 
    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidle' and cra.sharetype = 'city' then cra.amount else 0 end) as citycurrshare,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidle' and cra.sharetype = 'city' then cra.amount else 0 end) as cityprevshare,
    sum(0.0) as citypenaltyshare,
    sum(case when cra.revperiod <> 'advance' and cra.revtype = 'basicidle' and cra.sharetype = 'city' then cra.amount else 0 end) as citysharetotal,

    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidle' and cra.sharetype = 'municipality' then cra.amount else 0 end) as municurrshare,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidle' and cra.sharetype = 'municipality' then cra.amount else 0 end) as muniprevshare,
    sum(0.0) as munipenaltyshare,
    sum(case when cra.revperiod <> 'advance' and cra.revtype = 'basicidle' and cra.sharetype = 'municipality' then cra.amount else 0 end) as munisharetotal,

    sum(case when cra.revperiod = 'current' and cra.revtype = 'basicidle' and cra.sharetype = 'province' then cra.amount else 0 end) as provcurrshare,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basicidle' and cra.sharetype = 'province' then cra.amount else 0 end) as provprevshare,
    sum(0.0) as provpenaltyshare,
    sum(case when cra.revperiod <> 'advance' and  cra.revtype = 'basicidle' and cra.sharetype = 'province' then cra.amount else 0 end) as provsharetotal
from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share cra on rp.objid = cra.parentid
where ${filter} 
    and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 


[getBasicSharesAbstract]
select 
    b.objid as barangayid,
    b.name as barangay, 
    sum(case when cra.revperiod = 'current' and cra.revtype = 'basic' then cra.amount else 0 end) as brgycurr,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' then cra.amount else 0 end) as brgyprev,
    sum(case when cra.revtype = 'basicint' then cra.amount else 0 end) as brgypenalty,
    
    sum(case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype = 'barangay' then cra.amount else 0 end) as brgycurrshare,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype = 'barangay' then cra.amount else 0 end) as brgyprevshare,
    sum(case when cra.revtype = 'basicint' and cra.sharetype = 'barangay' then cra.amount else 0 end) as brgypenaltyshare,

    sum(case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype in ('city') then cra.amount else 0 end) as citycurrshare,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype in ('city') then cra.amount else 0 end) as cityprevshare,
    sum(case when cra.revtype = 'basicint' and cra.sharetype in ('city') then cra.amount else 0 end) as citypenaltyshare,

    sum(case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype in ('province', 'municipality') then cra.amount else 0 end) as provmunicurrshare,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype in ('province', 'municipality') then cra.amount else 0 end) as provmuniprevshare,
    sum(case when cra.revtype = 'basicint' and cra.sharetype in ('province', 'municipality') then cra.amount else 0 end) as provmunipenaltyshare
from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share cra on rp.objid = cra.parentid
    left join rptledger rl on rp.refid = rl.objid
    left join barangay b on rl.barangayid = b.objid 
where ${filter} 
    and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
    and cra.revperiod <> 'advance' 
    and cra.revtype in ('basic', 'basicint')
group by b.objid, b.name
order by b.name 



[getBasicShares]
select
    b.name as barangay,
    sum(t.brgytotalshare) as brgytotalshare,
    sum(t.citycurrshare) as citycurrshare,
    sum(t.cityprevshare) as cityprevshare,
    sum(t.citypenaltyshare) as citypenaltyshare,
    sum(t.municurrshare) as municurrshare,
    sum(t.muniprevshare) as muniprevshare,
    sum(t.munipenaltyshare) as munipenaltyshare,
    sum(t.provcurrshare) as provcurrshare,
    sum(t.provprevshare) as provprevshare,
    sum(t.provpenaltyshare) as provpenaltyshare,
    sum(t.brgytotalshare + t.municurrshare + t.muniprevshare + t.munipenaltyshare +
            t.provcurrshare + t.provprevshare + t.provpenaltyshare + 
            t.citycurrshare + t.cityprevshare + t.citypenaltyshare 
    ) as grandtotal
from (
    select 
        b.objid as barangayid,
        case when cra.sharetype = 'barangay' then cra.amount else 0 end as brgytotalshare,

        case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype = 'city' then cra.amount else 0 end as citycurrshare,
        case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype = 'city' then cra.amount else 0 end as cityprevshare,
        case when cra.revtype = 'basicint' and cra.sharetype = 'city' then cra.amount else 0 end as citypenaltyshare,

        case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype = 'municipality' then cra.amount else 0 end as municurrshare,
        case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype = 'municipality' then cra.amount else 0 end as muniprevshare,
        case when cra.revtype = 'basicint' and cra.sharetype = 'municipality' then cra.amount else 0 end as munipenaltyshare,

        case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype = 'province' then cra.amount else 0 end as provcurrshare,
        case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype = 'province' then cra.amount else 0 end as provprevshare,
        case when cra.revtype = 'basicint' and cra.sharetype = 'province' then cra.amount else 0 end as provpenaltyshare
    from remittance rem 
        inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
        inner join cashreceipt cr on cr.remittanceid = rem.objid 
        inner join rptpayment rp on cr.objid = rp.receiptid 
        inner join rptpayment_share cra on rp.objid = cra.parentid
        left join rptledger rl on rp.refid = rl.objid
        left join barangay b on rl.barangayid = b.objid 
    where ${filter} 
        and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
        and cra.revperiod <> 'advance' 
        and cra.revtype in ('basic', 'basicint')
) t
left join barangay b on t.barangayid = b.objid 
group by b.name 


[getBasicSharesSummary]   
select xx.*, 
    (brgytotalshare + munitotalshare + provtotalshare + citytotalshare) as totalshare 
from ( 
    select 
        sum(case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype = 'barangay' then cra.amount else 0 end) as brgycurrshare,
        sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype = 'barangay' then cra.amount else 0 end) as brgyprevshare,
        sum(case when cra.revtype = 'basicint' and cra.sharetype = 'barangay' then cra.amount else 0 end) as  brgypenaltyshare,
        sum(case when cra.sharetype = 'barangay' then cra.amount else 0 end) as  brgytotalshare,

        sum(case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype = 'city' then cra.amount else 0 end) as  citycurrshare,
        sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype = 'city' then cra.amount else 0 end) as  cityprevshare,
        sum(case when cra.revtype = 'basicint' and cra.sharetype = 'city' then cra.amount else 0 end) as  citypenaltyshare,
        sum(case when cra.sharetype = 'city' then cra.amount else 0 end) as  citytotalshare,

        sum(case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype = 'municipality' then cra.amount else 0 end) as  municurrshare,
        sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype = 'municipality' then cra.amount else 0 end) as  muniprevshare,
        sum(case when cra.revtype = 'basicint' and cra.sharetype = 'municipality' then cra.amount else 0 end) as  munipenaltyshare,
        sum(case when cra.sharetype = 'municipality' then cra.amount else 0 end) as  munitotalshare,

        sum(case when cra.revperiod = 'current' and cra.revtype = 'basic' and cra.sharetype = 'province' then cra.amount else 0 end) as  provcurrshare,
        sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'basic' and cra.sharetype = 'province' then cra.amount else 0 end) as  provprevshare,
        sum(case when cra.revtype = 'basicint' and cra.sharetype = 'province' then cra.amount else 0 end) as  provpenaltyshare,
        sum(case when cra.sharetype = 'province' then cra.amount else 0 end) as  provtotalshare 
    from remittance rem 
        inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
        inner join cashreceipt cr on cr.remittanceid = rem.objid 
        inner join rptpayment rp on cr.objid = rp.receiptid 
        inner join rptpayment_share cra on rp.objid = cra.parentid
    where ${filter}   
        and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
        and cra.revperiod <> 'advance' 
        and cra.revtype in ('basic', 'basicint')
)xx 


[getSefShares]
select 
    sum(case when cra.revperiod = 'current' and cra.revtype = 'sef' and cra.sharetype = 'city' then cra.amount else 0 end) as citycurrshare,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'sef' and cra.sharetype = 'city' then cra.amount else 0 end) as cityprevshare,
    sum(case when cra.revtype = 'sefint' and cra.sharetype = 'city' then cra.amount else 0 end) as citypenaltyshare,
    sum(case when cra.revtype in ('sef', 'sefint') and cra.sharetype = 'city' then cra.amount else 0 end) as citysharetotal,

    sum(case when cra.revperiod = 'current' and cra.revtype = 'sef' and cra.sharetype = 'municipality' then cra.amount else 0 end) as municurrshare,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'sef' and cra.sharetype = 'municipality' then cra.amount else 0 end) as muniprevshare,
    sum(case when cra.revtype = 'sefint' and cra.sharetype = 'municipality' then cra.amount else 0 end) as munipenaltyshare,
    sum(case when cra.revtype in ('sef', 'sefint') and cra.sharetype = 'municipality' then cra.amount else 0 end) as munisharetotal,

    sum(case when cra.revperiod = 'current' and cra.revtype = 'sef' and cra.sharetype = 'province' then cra.amount else 0 end) as provcurrshare,
    sum(case when cra.revperiod in ('previous', 'prior') and cra.revtype = 'sef' and cra.sharetype = 'province' then cra.amount else 0 end) as provprevshare,
    sum(case when cra.revtype = 'sefint' and cra.sharetype = 'province' then cra.amount else 0 end) as provpenaltyshare,
    sum(case when cra.revtype in ('sef', 'sefint') and cra.sharetype = 'province' then cra.amount else 0 end) as provsharetotal
from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share cra on rp.objid = cra.parentid
where ${filter} 
    and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
    and cra.revperiod <> 'advance'
    and cra.revtype in ('sef', 'sefint')


[getBrgyShares]
select  
    b.name as brgyname, 
    sum(case when cra.revperiod='current' and revtype='basic' then cra.amount + cra.discount else 0.0 end )as basiccurrentamt,     
    sum(case when cra.revperiod='current' and revtype='basic' then cra.discount else 0.0 end )as basiccurrentdiscamt,     
    sum(case when cra.revperiod = 'current' and revtype ='basicint' then cra.amount else 0.0 end) as basiccurrentintamt,
    sum(case when cra.revperiod in ('previous', 'prior') and revtype ='basic' then cra.amount else 0.0 end) as basicprevamt,    
    sum(case when cra.revperiod in ('previous', 'prior') and revtype ='basicint' then cra.amount else 0.0 end) as basicprevintamt,
    sum(case when revtype like 'basic%' then cra.amount else 0.0 end) as total
from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share cra on rp.objid = cra.parentid
    inner join itemaccount ia on cra.item_objid = ia.objid 
    left join barangay b on ia.org_objid = b.objid
where ${filter} 
    and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
    and cra.sharetype ='barangay'
    and cra.revperiod <> 'advance'
group by b.name

[getBrgySharesAdvance]
select  
    min(b.name) as brgyname, 
    sum(case when cra.revperiod='advance' and revtype='basic' then cra.amount else 0.0 end )as basiccurrentamt,     
    sum(case when cra.revperiod = 'advance' and revtype ='basicint' then cra.amount else 0.0 end) as basiccurrentintamt
from cashreceipt cr 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share cra on rp.objid = cra.parentid
    left join cashreceipt_void cv on cr.objid = cv.receiptid 
    left join rptledger rl on rp.refid = rl.objid
    left join barangay b on rl.barangayid = b.objid 
    inner join remittance r on r.objid = cr.remittanceid 
where cr.receiptdate >= $P{fromdate} and cr.receiptdate < $P{todate}
    and cra.sharetype ='barangay'
     and cv.objid is null  
     and cra.revperiod = 'advance'
group by b.objid  





[getAdvanceCollectionsByBrgy]
select  
    rpi.year, 
    b.objid as brgyid,
    sum(rpi.amount) as basic,     
    sum(rpi.discount) as disc,     
    sum(rpi.amount - rpi.discount) as total
from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_item rpi on rp.objid = rpi.parentid 
    inner join rptledger rl on rp.refid = rl.objid 
    inner join barangay b on rl.barangayid = b.objid 
where ${filter} 
    and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
    and rpi.revperiod = 'advance'
    and rpi.revtype like 'basic' 
group by rpi.year, b.objid

[getAdvanceBrgySharesAnnual]
select  
    rps.year, 
    b.objid as brgyid, 
    sum(rps.amount + rps.discount) as brgybasic,
    sum(rps.discount) as brgydisc,
    sum(rps.amount) as brgyshare
from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share rps on rp.objid = rps.parentid
    inner join itemaccount ia on rps.item_objid = ia.objid 
    inner join barangay b on ia.org_objid = b.objid 
where ${filter} 
    and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
    and rps.revperiod = 'advance'
    and rps.revtype in ('basic', 'basicint')
    and rps.sharetype = 'barangay'
group by rps.year, b.objid 

[getAdvanceLguSharesAnnual]
select  
    rps.year, 
    b.objid as brgyid, 
    sum(rps.amount + rps.discount) as lgubasic,     
    sum(rps.discount) as lgudisc,     
    sum(rps.amount) as lgushare
from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share rps on rp.objid = rps.parentid
    inner join rptledger rl on rp.refid = rl.objid 
    inner join barangay b on rl.barangayid = b.objid 
where ${filter} 
    and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
    and rps.revperiod = 'advance'
    and rps.revtype in ('basic', 'basicint')
    and rps.sharetype <> 'barangay'
group by rps.year, b.objid 

