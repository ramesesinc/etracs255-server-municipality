[getFunds]
select fund.* 
from fundgroup g, fund 
where g.objid = fund.groupid ${filter} 
order by g.indexno, fund.code, fund.title 


[getRemittedCollectionByFund]
select 
  t1.fundid, fund.code as fundcode, fund.title as fundname, 
  t1.acctid, t1.acctcode, t1.acctname, sum(t1.amount)-sum(t1.share) as amount 
from ( 
  select fundid, acctid, acctcode, acctname, sum(amount) as amount, 0.0 as share 
  from vw_remittance_cashreceiptitem 
  where remittance_controldate >= $P{fromdate} 
    and remittance_controldate <  $P{todate} 
  group by fundid, acctid, acctcode, acctname 

  union all 

  select t1.fundid, t1.acctid, t1.acctcode, t1.acctname, 0.0 as amount, sum(cs.amount) as share 
  from ( 
    select receiptid, fundid, acctid, acctcode, acctname, count(*) as icount 
    from vw_remittance_cashreceiptitem 
    where remittance_controldate >= $P{fromdate} 
      and remittance_controldate <  $P{todate} 
    group by receiptid, fundid, acctid, acctcode, acctname 
  )t1, vw_remittance_cashreceiptshare cs 
  where cs.receiptid = t1.receiptid and cs.refacctid = t1.acctid 
  group by t1.fundid, t1.acctid, t1.acctcode, t1.acctname

  union all 

  select fundid, acctid, acctcode, acctname, sum(amount) as amount, 0.0 as share  
  from vw_remittance_cashreceiptshare  
  where remittance_controldate >= $P{fromdate} 
    and remittance_controldate <  $P{todate} 
  group by fundid, acctid, acctcode, acctname 
)t1, fund 
where fund.objid = t1.fundid ${filter} 
group by t1.fundid, fund.code, fund.title, t1.acctid, t1.acctcode, t1.acctname
order by fund.code, fund.title, t1.acctcode 


[getLiquidatedCollectionByFund]
select 
  t1.fundid, fund.code as fundcode, fund.title as fundname, 
  t1.acctid, t1.acctcode, t1.acctname, sum(t1.amount)-sum(t1.share) as amount 
from ( 
  select fundid, acctid, acctcode, acctname, sum(amount) as amount, 0.0 as share 
  from vw_collectionvoucher_cashreceiptitem 
  where collectionvoucher_controldate >= $P{fromdate} 
    and collectionvoucher_controldate <  $P{todate} 
  group by fundid, acctid, acctcode, acctname 

  union all 

  select t1.fundid, t1.acctid, t1.acctcode, t1.acctname, 0.0 as amount, sum(cs.amount) as share 
  from ( 
    select receiptid, fundid, acctid, acctcode, acctname, count(*) as icount 
    from vw_collectionvoucher_cashreceiptitem 
    where collectionvoucher_controldate >= $P{fromdate} 
      and collectionvoucher_controldate <  $P{todate} 
    group by receiptid, fundid, acctid, acctcode, acctname 
  )t1, vw_collectionvoucher_cashreceiptshare cs 
  where cs.receiptid = t1.receiptid and cs.refacctid = t1.acctid 
  group by t1.fundid, t1.acctid, t1.acctcode, t1.acctname

  union all 

  select fundid, acctid, acctcode, acctname, sum(amount) as amount, 0.0 as share  
  from vw_collectionvoucher_cashreceiptshare  
  where collectionvoucher_controldate >= $P{fromdate} 
    and collectionvoucher_controldate <  $P{todate} 
  group by fundid, acctid, acctcode, acctname 
)t1, fund 
where fund.objid = t1.fundid ${filter} 
group by t1.fundid, fund.code, fund.title, t1.acctid, t1.acctcode, t1.acctname
order by fund.code, fund.title, t1.acctcode 


[getAbstractOfCollection]
select 
  t1.formno, t1.receiptno, t1.receiptdate, t1.formtype, 
  t1.collectorid, t1.collectorname, t1.collectortitle, 
  t1.payorname, t1.payoraddress, t1.fundid, fund.title as fundname, 
  t1.acctid, t1.acctname as accttitle, sum(t1.amount)-sum(t1.share) as amount 
from ( 
  select 
    formno, receiptno, receiptdate, formtype, 
    collectorid, collectorname, collectortitle, 
    case when voided=0 then paidby else '*** VOIDED ***' end as payorname, 
    case when voided=0 then paidbyaddress else '' end as payoraddress, 
    fundid, acctid, acctname, sum(amount) as amount, 0.0 as share 
  from vw_remittance_cashreceiptitem 
  where remittance_controldate >= $P{fromdate} 
    and remittance_controldate <  $P{todate} 
  group by 
    formno, receiptno, receiptdate, formtype, 
    collectorid, collectorname, collectortitle, 
    voided, paidby, paidbyaddress, fundid, acctid, acctname 

  union all 

  select 
    cs.formno, cs.receiptno, cs.receiptdate, cs.formtype, 
    cs.collectorid, cs.collectorname, cs.collectortitle, 
    case when t1.voided=0 then cs.paidby else '*** VOIDED ***' end as payorname, 
    case when t1.voided=0 then cs.paidbyaddress else '' end as payoraddress, 
    t1.fundid, t1.acctid, t1.acctname, 0.0 as amount, sum(cs.amount) as share 
  from ( 
    select receiptid, fundid, acctid, acctname, voided, count(*) as icount 
    from vw_remittance_cashreceiptitem 
    where remittance_controldate >= $P{fromdate} 
      and remittance_controldate <  $P{todate} 
    group by receiptid, fundid, acctid, acctcode, acctname, voided 
  )t1, vw_remittance_cashreceiptshare cs 
  where cs.receiptid = t1.receiptid and cs.refacctid = t1.acctid 
  group by 
    cs.formno, cs.receiptno, cs.receiptdate, cs.formtype, 
    cs.collectorid, cs.collectorname, cs.collectortitle, 
    t1.voided, cs.paidby, cs.paidbyaddress, t1.fundid, t1.acctid, t1.acctname 

  union all 

  select 
    formno, receiptno, receiptdate, formtype, 
    collectorid, collectorname, collectortitle, 
    case when voided=0 then paidby else '*** VOIDED ***' end as payorname, 
    case when voided=0 then paidbyaddress else '' end as payoraddress, 
    fundid, acctid, acctname, sum(amount) as amount, 0.0 as share  
  from vw_remittance_cashreceiptshare  
  where remittance_controldate >= $P{fromdate} 
    and remittance_controldate <  $P{todate} 
  group by 
    formno, receiptno, receiptdate, formtype, 
    collectorid, collectorname, collectortitle, 
    voided, paidby, paidbyaddress, fundid, acctid, acctname 
)t1, fund 
where fund.objid = t1.fundid ${filter} 
group by 
  t1.formno, t1.receiptno, t1.receiptdate, t1.formtype, 
  t1.collectorid, t1.collectorname, t1.collectortitle, 
  t1.payorname, t1.payoraddress, t1.fundid, fund.title, t1.acctid, t1.acctname 
order by t1.formno, t1.receiptno 
