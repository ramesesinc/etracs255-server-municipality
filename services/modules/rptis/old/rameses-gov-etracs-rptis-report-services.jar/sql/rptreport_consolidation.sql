[getConsolidations]
select 
	c.txnno,
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
from consolidation c
	inner join faas f on c.newfaasid = f.objid 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 	
	inner join barangay b on rp.barangayid = b.objid 
where c.objid = $P{objid}
order by cadastrallotno


[getConsolidatedLands]
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
from consolidatedland cl 
	inner join faas f on cl.landfaasid = f.objid 
	inner join rpu r on f.rpuid = r.objid 
	inner join realproperty rp on f.realpropertyid = rp.objid 
where cl.consolidationid = $P{objid}
order by rp.cadastrallotno