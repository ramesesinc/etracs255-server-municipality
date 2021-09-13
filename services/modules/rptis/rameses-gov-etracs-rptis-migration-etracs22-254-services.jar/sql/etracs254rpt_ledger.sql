
[findFaasById]
select 
  f.taxpayer_objid, 
  f.fullpin, 
  f.tdno, 
  rp.cadastrallotno, 
  r.rputype, 
  f.txntype_objid, 
  pc.code as classcode, 
  r.totalav, 
  r.totalmv, 
  r.totalareaha, 
  r.taxable, 
  f.owner_name, 
  f.prevtdno, 
  r.classification_objid, 
  f.titleno, 
  0 as undercompromise,
  rp.barangayid
from faas f 
  inner join rpu r on f.rpuid = r.objid 
  inner join realproperty rp on f.realpropertyid = rp.objid 
  inner join propertyclassification pc on r.classification_objid = pc.objid 
where f.objid = $P{objid}

[findBarangayByName]
select objid from barangay where name = $P{name}