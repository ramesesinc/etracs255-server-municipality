[getUsers]
select distinct 
	u.objid, 
	u.name
from txnlog l
inner join sys_user u on l.userid = u.objid 
where u.state = 'ACTIVE' or u.state is null 
order by u.name 

[getRefTypes]
select distinct 
	ref
from txnlog 
order by ref 


[getList]
select 
	x.username,
	x.ref,
	x.action, 
	sum(x.cnt) as cnt 
from vw_txn_log x
where x.txndate >= $P{startdate} and txndate < $P{enddate}
${filter}
group by x.username, x.ref, x.action
order by x.username, x.ref, x.action
