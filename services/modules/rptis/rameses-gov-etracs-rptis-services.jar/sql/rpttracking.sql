[getLogs]
select *
from (
	select 
		startdate, 
		state,
		assignee_name
	from faas_task
	where refid = $P{objid}

	union 

	select 
		startdate, 
		state,
		assignee_name
	from subdivision_task
	where refid = $P{objid}

	union 

	select 
		startdate, 
		state,
		assignee_name
	from consolidation_task
	where refid = $P{objid}

	union 

	select 
		startdate, 
		state,
		assignee_name
	from cancelledfaas_task
	where refid = $P{objid}

	union 

	select 
		startdate, 
		state,
		assignee_name
	from resection_task
	where refid = $P{objid}
)x
order by x.startdate
