[insertItems]
insert into batchgr_item(
  objid,
  parent_objid,
  state,
  rputype,
  tdno,
  fullpin,
  pin,
  suffix
)
select 
  f.objid,
  $P{objid} as parentid,
  'FORREVISION' as state,
  r.rputype,
  f.tdno,
  f.fullpin,
  rp.pin,
  r.suffix
from faas f 
    inner join rpu r on f.rpuid = r.objid 
    inner join realproperty rp on f.realpropertyid = rp.objid
    inner join propertyclassification pc on r.classification_objid = pc.objid 
    inner join barangay b on rp.barangayid = b.objid 
where rp.barangayid = $P{barangayid}
  and r.ry < $P{ry}
  and f.state = 'CURRENT'
  and r.rputype like $P{rputype}
  and r.classification_objid like $P{classificationid}
  and rp.section like $P{section}
  and not exists(select * from batchgr_item where objid = f.objid)


[findCounts]
select 
  sum(1) as count,
  sum(case when state = 'REVISED' then 1 else 0 end) as revised,
  sum(case when state = 'CURRENT' then 1 else 0 end) as currentcnt,
  sum(case when state = 'ERROR' then 1 else 0 end) as error
from batchgr_item 
where parent_objid = $P{objid}


[getFaasListing]
SELECT 
  f.objid, 
  CASE WHEN f.tdno IS NULL THEN f.utdno ELSE f.tdno END AS tdno, 
  r.rputype,
  r.fullpin 
FROM batchgr_item bi
  INNER JOIN faas f ON bi.newfaasid = f.objid 
  INNER JOIN rpu r ON f.rpuid = r.objid 
  INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
WHERE bi.parent_objid = $P{objid}
ORDER BY f.tdno, rp.pin, r.suffix, r.subsuffix



[insertRevisedFaasSignatories]
INSERT INTO faas_task 
     (objid, refid, parentprocessid, state, startdate, enddate, 
      assignee_objid, assignee_name, assignee_title, 
      actor_objid, actor_name, actor_title, message, signature) 
select
    concat(bt.objid, f.utdno) as objid, 
    bi.newfaasid, 
    bt.parentprocessid, 
    bt.state, 
    bt.startdate, 
    bt.enddate, 
    bt.assignee_objid, 
    bt.assignee_name, 
    bt.assignee_title, 
    bt.actor_objid, 
    bt.actor_name, 
    bt.actor_title, 
    bt.message, 
    bt.signature
from batchgr_item bi
  inner join faas f on bi.newfaasid = f.objid 
  inner join batchgr_task bt on bi.parent_objid = bt.refid 
where bi.parent_objid = $P{objid}
  and bt.state not like 'assign%'
  and not exists(select * from batchgr_task where objid = concat(bt.objid, f.utdno))

[insertFaasSignatories]
INSERT INTO faas_task 
     (objid, refid, parentprocessid, state, startdate, enddate, 
      assignee_objid, assignee_name, assignee_title, 
      actor_objid, actor_name, actor_title, message, signature) 
select
    concat(bt.objid, f.utdno) as objid, 
    bi.newfaasid, 
    bt.parentprocessid, 
    bt.state, 
    bt.startdate, 
    bt.enddate, 
    bt.assignee_objid, 
    bt.assignee_name, 
    bt.assignee_title, 
    bt.actor_objid, 
    bt.actor_name, 
    bt.actor_title, 
    bt.message, 
    bt.signature
from batchgr_item bi
  inner join faas f on bi.newfaasid = f.objid 
  inner join batchgr_task bt on bi.parent_objid = bt.refid 
where bi.newfaasid = $P{newfaasid}
  and bt.state not like 'assign%'
  and not exists(select * from batchgr_task where objid = concat(bt.objid, f.utdno))  

[findFaasInfo]
select 
  f.*,
  rp.barangayid as rp_barangay_objid,
  rp.ry as rpu_ry 
from faas f 
inner join realproperty rp on f.realpropertyid = rp.objid 
where f.objid = $P{objid}


[findPendingFaasesCount]
select count(*) as icount 
from batchgr_item bi 
  inner join faas f on bi.newfaasid = f.objid 
where bi.parent_objid = $P{objid}
and f.state = 'PENDING'  
