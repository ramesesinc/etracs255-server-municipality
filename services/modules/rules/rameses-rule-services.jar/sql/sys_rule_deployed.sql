[getRulesByRuleset]
select r.*, d.ruletext  
from sys_rule r 
	inner join sys_rule_deployed d on d.objid = r.objid 
where r.ruleset = $P{ruleset} 
