[getSubdividedLands]
select 
	s.txnno, 
	b.name as barangay,
	f.tdno,
	f.titleno, 
	f.fullpin,
	rp.cadastrallotno,
	rp.surveyno,
	r.totalareaha,
	r.totalareasqm,
	r.totalmv,
	r.totalav 
from subdividedland sl 
	inner join subdivision s on sl.subdivisionid = s.objid 
	inner join faas f on sl.newfaasid = f.objid 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 
	inner join barangay b on rp.barangayid = b.objid 
where sl.subdivisionid = $P{objid}
order by blockno, cadastrallotno


[getMotherLandsSummary]
select 
	f.tdno,
	f.titleno, 
	f.fullpin,
	rp.cadastrallotno,
	rp.surveyno,
	r.totalareaha,
	r.totalareasqm,
	r.totalmv,
	r.totalav 
from subdivision_motherland m
	inner join faas f on m.landfaasid = f.objid 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 
where m.subdivisionid = $P{objid}
