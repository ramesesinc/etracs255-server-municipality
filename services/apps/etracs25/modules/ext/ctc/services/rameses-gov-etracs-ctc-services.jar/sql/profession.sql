[getList]
SELECT * FROM profession WHERE objid LIKE $P{searchtext} 


[findById]
SELECT * FROM profession WHERE objid = $P{objid}


[createProfession]
INSERT INTO profession(objid) VALUES($P{objid})


[deleteEntity]
DELETE FROM profession WHERE objid = $P{objid}

