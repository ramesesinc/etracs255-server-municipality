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
where rp.barangayid = $P{_barangayid}
  and r.ry < $P{ry}
  and f.state = 'CURRENT'
  and r.rputype like $P{_rputype}
  and r.classification_objid like $P{_classid}
  and rp.section like $P{_section}
  and not exists(select * from batchgr_item where objid = f.objid)


[findCounts]
select 
  sum(1) as count,
  sum(case when state = 'REVISED' then 1 else 0 end) as revised,
  sum(case when state = 'CURRENT' then 1 else 0 end) as currentcnt,
  sum(case when state = 'ERROR' then 1 else 0 end) as error
from batchgr_item 
where parent_objid = $P{objid}