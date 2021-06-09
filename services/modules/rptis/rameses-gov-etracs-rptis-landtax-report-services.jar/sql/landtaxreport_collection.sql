[getStandardReport]
select 
  pc.name as classname, pc.orderno, pc.special,  
  sum(case when ri.revperiod='current' and ri.revtype = 'basic' then ri.amount else 0.0 end)  as basiccurrent,
  sum(case when ri.revtype = 'basic' then ri.discount else 0.0 end)  as basicdisc,
  sum(case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basic'  then ri.amount else 0.0 end)  as basicprev,
  sum(case when ri.revperiod='current' and ri.revtype = 'basic'  then ri.interest else 0.0 end)  as basiccurrentint,
  sum(case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basic'  then ri.interest else 0.0 end)  as basicprevint,
  sum(case when ri.revtype = 'basic' then ri.amount - ri.discount+ ri.interest else 0 end) as basicnet, 

  sum(case when ri.revperiod='current' and ri.revtype = 'sef' then ri.amount else 0.0 end)  as sefcurrent,
  sum(case when ri.revtype = 'sef' then ri.discount else 0.0 end)  as sefdisc,
  sum(case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sef'  then ri.amount else 0.0 end)  as sefprev,
  sum(case when ri.revperiod='current' and ri.revtype = 'sef'  then ri.interest else 0.0 end)  as sefcurrentint,
  sum(case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sef'  then ri.interest else 0.0 end)  as sefprevint,
  sum(case when ri.revtype = 'sef' then ri.amount - ri.discount+ ri.interest else 0 end) as sefnet, 

  sum(case when ri.revperiod='current' and ri.revtype = 'basicidle' then ri.amount else 0.0 end)  as idlecurrent,
  sum(case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'basicidle'  then ri.amount else 0.0 end)  as idleprev,
  sum(case when ri.revtype = 'basicidle' then ri.discount else 0.0 end)  as idledisc,
  sum(case when ri.revtype = 'basicidle' then ri.interest else 0 end )  as idleint, 
  sum(case when ri.revtype = 'basicidle'then ri.amount - ri.discount + ri.interest else 0 end) as idlenet, 

  sum(case when ri.revperiod='current' and ri.revtype = 'sh' then ri.amount else 0.0 end)  as shcurrent,
  sum(case when ri.revperiod in ('previous', 'prior') and ri.revtype = 'sh' then ri.amount else 0.0 end)  as shprev,
  sum(case when ri.revtype = 'sh' then ri.discount else 0.0 end)  as shdisc,
  sum(case when ri.revtype = 'sh' then ri.interest else 0 end)  as shint, 
  sum(case when ri.revtype = 'sh' then ri.amount - ri.discount + ri.interest else 0 end) as shnet, 

  sum(case when ri.revtype = 'firecode' then ri.amount - ri.discount + ri.interest else 0 end ) as firecode,

  0.0 as levynet 
from remittance rem 
  inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
  inner join cashreceipt cr on cr.remittanceid = rem.objid 
  inner join rptpayment rp on cr.objid = rp.receiptid 
  inner join rptpayment_item ri on rp.objid = ri.parentid
  left join rptledger rl ON rp.refid = rl.objid  
  left join propertyclassification pc ON rl.classification_objid = pc.objid 
where ${filter} 
  and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
  and ri.revperiod <> 'advance'
group by pc.name, pc.orderno, pc.special
order by pc.orderno 


[getAdvanceReport]
select 
  ri.year, pc.name as classname, pc.orderno, pc.special,  
  sum(case when ri.revtype = 'basic' then ri.amount else 0 end ) as basic, 
  sum(case when ri.revtype = 'basic' then ri.discount else 0 end ) as basicdisc, 
  sum(case when ri.revtype = 'basic' then ri.amount - ri.discount else 0 end ) as basicnet,
  sum(case when ri.revtype = 'sef' then ri.amount else 0 end ) as sef, 
  sum(case when ri.revtype = 'sef' then ri.discount else 0 end ) as sefdisc, 
  sum(case when ri.revtype = 'sef' then ri.amount - ri.discount else 0 end ) as sefnet,
  sum(case when ri.revtype = 'basicidle' then ri.amount - ri.discount else 0 end ) as idle,
  sum(case when ri.revtype = 'sh' then ri.amount - ri.discount else 0 end ) as sh,
  sum(case when ri.revtype = 'firecode' then ri.amount else 0 end ) as firecode,
  sum(ri.amount - ri.discount) as netgrandtotal
from remittance rem 
  inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
  inner join cashreceipt cr on cr.remittanceid = rem.objid 
  inner join rptpayment rp on cr.objid = rp.receiptid 
  inner join rptpayment_item ri on rp.objid = ri.parentid
  inner join rptledger rl ON rp.refid = rl.objid  
  inner join propertyclassification pc ON rl.classification_objid = pc.objid 
where ${filter}  
  and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
  and ri.revperiod = 'advance'
group by ri.year, pc.name, pc.orderno, pc.special
order by ri.year, pc.orderno 


[findStandardDispositionReport]
select 
  sum( provcitybasicshare ) as provcitybasicshare, 
  sum( munibasicshare ) as munibasicshare, 
  sum( brgybasicshare ) as brgybasicshare, 
  sum( provcitysefshare ) as provcitysefshare, 
  sum( munisefshare ) as munisefshare, 
  sum( brgysefshare ) as brgysefshare 
from ( 
  select   
    case when ri.revtype in ('basic', 'basicint', 'basicidle', 'basicidleint') and ri.sharetype in ('province', 'city') then ri.amount else 0.0 end as provcitybasicshare,
    case when ri.revtype in ('basic', 'basicint', 'basicidle', 'basicidleint') and ri.sharetype in ('municipality') then ri.amount else 0.0 end as munibasicshare,
    case when ri.revtype in ('basic', 'basicint') and ri.sharetype in ('barangay') then ri.amount else 0.0 end as brgybasicshare,
    case when ri.revtype in ('sef', 'sefint') and ri.sharetype in ('province', 'city') then ri.amount else 0.0 end as provcitysefshare,
    case when ri.revtype in ('sef', 'sefint') and ri.sharetype in ('municipality') then ri.amount else 0.0 end as munisefshare,
    0.0 as brgysefshare 
  from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share ri on rp.objid = ri.parentid
  where ${filter}  
    and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid) 
    and ri.revperiod <> 'advance' 
)t 


[findAdvanceDispositionReport]
select 
  sum( provcitybasicshare ) as provcitybasicshare,
  sum( munibasicshare ) as munibasicshare,
  sum( brgybasicshare ) as brgybasicshare,
  sum( provcitysefshare ) as provcitysefshare,
  sum( munisefshare ) as munisefshare,
  sum( brgysefshare ) as brgysefshare
from ( 
  select 
    case when ri.revtype in ('basic', 'basicint', 'basicidle', 'basicidleint') and ri.sharetype in ('province', 'city') then ri.amount else 0.0 end as provcitybasicshare,
    case when ri.revtype in ('basic', 'basicint', 'basicidle', 'basicidleint') and ri.sharetype in ('municipality') then ri.amount else 0.0 end as munibasicshare,
    case when ri.revtype in ('basic', 'basicint', 'basicidle', 'basicidleint') and ri.sharetype in ('barangay') then ri.amount else 0.0 end as brgybasicshare,
    case when ri.revtype in ('sef', 'sefint') and ri.sharetype in ('province', 'city') then ri.amount else 0.0 end as provcitysefshare,
    case when ri.revtype in ('sef', 'sefint') and ri.sharetype in ('municipality') then ri.amount else 0.0 end as munisefshare,
    case when ri.revtype in ('sef', 'sefint') and ri.sharetype in ('barangay') then ri.amount else 0.0 end as brgysefshare 
  from remittance rem 
    inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on cr.remittanceid = rem.objid 
    inner join rptpayment rp on cr.objid = rp.receiptid 
    inner join rptpayment_share ri on rp.objid = ri.parentid
  where ${filter}  
    and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid)
    and ri.revperiod = 'advance' 
)t 



[findAdvanceDispositionReport2]
select 
  sum(case when ri.revtype = 'basic' then ri.amount else 0 end) as basic,
  sum(case when ri.revtype = 'basic' then ri.discount else 0 end) as basicdisc,
  sum(case when ri.revtype = 'basicidle' then ri.amount else 0 end) as basicidle,
  sum(case when ri.revtype = 'basicidle' then ri.discount else 0 end) as basicidledisc,
  sum(case when ri.revtype = 'sef' then ri.amount else 0 end) as sef,
  sum(case when ri.revtype = 'sef' then ri.discount else 0 end) as sefdisc
from remittance rem 
  inner join collectionvoucher cv on cv.objid = rem.collectionvoucherid 
  inner join cashreceipt cr on cr.remittanceid = rem.objid 
  inner join rptpayment rp on cr.objid = rp.receiptid 
  inner join rptpayment_item ri on rp.objid = ri.parentid
where ${filter}  
  and cr.objid not in (select receiptid from cashreceipt_void where receiptid=cr.objid)
  and ri.revperiod = 'advance' 


[getCollectionSummaryByMonth]
select 
  $P{year} as cy, 
  x.revtype,
  x.mon, 
  sum(x.cytax) as cytax,
  sum(x.cydisc) as cydisc,
  sum(x.cynet) as cynet,
  sum(x.cyint) as cyint,
  sum(x.immediatetax) as immediatetax,
  sum(x.immediateint) as immediateint,
  sum(x.priortax) as priortax,
  sum(x.priorint) as priorint,
  sum(x.subtotaltax) as subtotaltax,
  sum(x.subtotalint) as subtotalint,
  sum(x.total) as total,
  sum(x.gross) as gross
from (
  select 
    rpi.revtype, 
    month(cr.receiptdate) as imon, 
    case 
      when month(cr.receiptdate) = 1 then 'JANUARY'
      when month(cr.receiptdate) = 2 then 'FEBRUARY'
      when month(cr.receiptdate) = 3 then 'MARCH'
      when month(cr.receiptdate) = 4 then 'APRIL'
      when month(cr.receiptdate) = 5 then 'MAY'
      when month(cr.receiptdate) = 6 then 'JUNE'
      when month(cr.receiptdate) = 7 then 'JULY'
      when month(cr.receiptdate) = 8 then 'AUGUST'
      when month(cr.receiptdate) = 9 then 'SEPTEMBER'
      when month(cr.receiptdate) = 10 then 'OCTOBER'
      when month(cr.receiptdate) = 11 then 'NOVEMBER'
      else 'DECEMBER' 
    end as mon, 
    case when $P{year} = rpi.year then rpi.amount else 0 end as cytax,
    case when $P{year} = rpi.year then rpi.discount else 0 end as cydisc,
    case when $P{year} = rpi.year then rpi.amount - rpi.discount else 0 end as cynet,
    case when $P{year} = rpi.year then rpi.interest else 0 end as cyint,

    case when $P{year} - 1 = rpi.year then rpi.amount else 0 end as immediatetax,
    case when $P{year} - 1 = rpi.year then rpi.interest else 0 end as immediateint,
    
    case when $P{year} > rpi.year then rpi.amount else 0 end as subtotaltax,
    case when $P{year} > rpi.year then rpi.interest else 0 end as subtotalint,

    case when $P{year} - 1 > rpi.year then rpi.amount else 0 end as priortax,
    case when $P{year} - 1 > rpi.year then rpi.interest else 0 end as priorint,
    
    rpi.amount - rpi.discount + rpi.interest as total,
    rpi.amount + rpi.interest as gross

  from collectionvoucher cv
    inner join remittance rem on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on rem.objid = cr.remittanceid 
    inner join rptpayment p on cr.objid = p.receiptid 
    inner join rptledger rl on p.refid = rl.objid 
    inner join barangay b on rl.barangayid = b.objid 
    inner join rptpayment_item rpi on p.objid = rpi.parentid
    left join cashreceipt_void v on cr.objid = v.receiptid 
    where ${filter} 
      and rpi.revperiod <> 'advance'
      and v.objid is null
) x 
group by 
  x.revtype,
  x.imon,
  x.mon 
order by 
  x.revtype,
  x.imon
  

[getCollectionSummaryByBrgy]
select 
  x.brgyindex,
  x.barangay,
  $P{year} as cy, 
  x.revtype,
  sum(x.cytax) as cytax,
  sum(x.cydisc) as cydisc,
  sum(x.cynet) as cynet,
  sum(x.cyint) as cyint,
  sum(x.immediatetax) as immediatetax,
  sum(x.immediateint) as immediateint,
  sum(x.priortax) as priortax,
  sum(x.priorint) as priorint,
  sum(x.subtotaltax) as subtotaltax,
  sum(x.subtotalint) as subtotalint,
  sum(x.prevtotal) as prevtotal,
  sum(x.total) as total
from (
  select 
    b.indexno as brgyindex, 
    b.name as barangay,
    rpi.revtype, 
    case when $P{year} = rpi.year then rpi.amount else 0 end as cytax,
    case when $P{year} = rpi.year then rpi.discount else 0 end as cydisc,
    case when $P{year} = rpi.year then rpi.amount - rpi.discount else 0 end as cynet,
    case when $P{year} = rpi.year then rpi.interest else 0 end as cyint,

    case when $P{year} - 1 = rpi.year then rpi.amount else 0 end as immediatetax,
    case when $P{year} - 1 = rpi.year then rpi.interest else 0 end as immediateint,
    
    case when $P{year} > rpi.year then rpi.amount else 0 end as subtotaltax,
    case when $P{year} > rpi.year then rpi.interest else 0 end as subtotalint,

    case when $P{year} - 1 > rpi.year then rpi.amount else 0 end as priortax,
    case when $P{year} - 1 > rpi.year then rpi.interest else 0 end as priorint,
    
    0 as prevtotal,
    rpi.amount - rpi.discount + rpi.interest as total

  from collectionvoucher cv
    inner join remittance rem on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on rem.objid = cr.remittanceid 
    inner join rptpayment p on cr.objid = p.receiptid 
    inner join rptledger rl on p.refid = rl.objid 
    inner join barangay b on rl.barangayid = b.objid 
    inner join rptpayment_item rpi on p.objid = rpi.parentid
    left join cashreceipt_void v on cr.objid = v.receiptid 
    where ${filter} 
      and rpi.revperiod <> 'advance'
      and v.objid is null
) x 
group by 
  x.brgyindex,
  x.barangay,
  x.revtype
order by 
  x.brgyindex,
  x.barangay, 
  x.revtype
  
  
[getPreviousCollectionSummaryByBrgy]
select 
  x.brgyindex,
  x.barangay,
  x.revtype,
  sum(x.total) as total
from (
  select 
    b.indexno as brgyindex, 
    b.name as barangay,
    rpi.revtype, 
    rpi.amount - rpi.discount + rpi.interest as total
  from collectionvoucher cv
    inner join remittance rem on cv.objid = rem.collectionvoucherid 
    inner join cashreceipt cr on rem.objid = cr.remittanceid 
    inner join rptpayment p on cr.objid = p.receiptid 
    inner join rptledger rl on p.refid = rl.objid 
    inner join barangay b on rl.barangayid = b.objid 
    inner join rptpayment_item rpi on p.objid = rpi.parentid
    left join cashreceipt_void v on cr.objid = v.receiptid 
    where ${filter}
      and rpi.revperiod <> 'advance'
      and v.objid is null
) x 
group by 
  x.brgyindex,
  x.barangay,
  x.revtype
order by 
  x.brgyindex,
  x.barangay, 
  x.revtype
  
  
