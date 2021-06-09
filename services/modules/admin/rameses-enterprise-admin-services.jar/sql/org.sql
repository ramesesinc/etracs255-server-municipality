[getList]
SELECT * FROM sys_org 
WHERE orgclass=$P{orgclass} ORDER BY name 

[getOrgClasses]
SELECT * FROM sys_orgclass

[getLookup]
SELECT o.* FROM sys_org o WHERE o.orgclass=$P{orgclass} ORDER BY o.name 



[findRoot]
SELECT * FROM sys_org WHERE root = 1

[findByName]
SELECT * FROM sys_org WHERE name=$P{name} 

[findByCode]
SELECT * FROM sys_org WHERE code=$P{code} 

[getOrgsByParent]
SELECT * FROM sys_org WHERE parent_objid = $P{objid}
