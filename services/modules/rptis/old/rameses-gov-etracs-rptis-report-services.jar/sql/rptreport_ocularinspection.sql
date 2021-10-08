[findOcularInspectionInfo]
SELECT 
	'faas' as doctype,
	ef.*,
	f.owner_name, f.titleno, f.fullpin,
	rp.cadastrallotno, r.totalareaha,
	b.name as barangay_name, rp.barangayid, b.parentid as barangay_parentid, rp.purok, rp.street
FROM examiner_finding ef 
	INNER JOIN faas f ON ef.parent_objid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
WHERE ef.objid = $P{objid}

UNION 

SELECT 
	'consolidation' as doctype,
	ef.*,
	f.owner_name, f.titleno, f.fullpin,
	rp.cadastrallotno, r.totalareaha,
	b.name as barangay_name, rp.barangayid, b.parentid as barangay_parentid, rp.purok, rp.street
FROM examiner_finding ef 
	inner join consolidation c on ef.parent_objid = c.objid 
	INNER JOIN faas f ON c.newfaasid = f.objid 
	INNER JOIN rpu r ON f.rpuid = r.objid 
	INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
	INNER JOIN barangay b ON rp.barangayid = b.objid 
WHERE ef.objid =  $P{objid}

UNION 

SELECT 
	'subdivision' as doctype,
	ef.*,
	'' as owner_name, '' as titleno, '' as fullpin,
	'' as cadastrallotno, 0.0 as totalareaha,
	'' as barangay_name, '' as barangayid, '' as barangay_parentid, '' as purok, '' as street
FROM examiner_finding ef 
	inner join subdivision c on ef.parent_objid = c.objid 
WHERE ef.objid = $P{objid}
