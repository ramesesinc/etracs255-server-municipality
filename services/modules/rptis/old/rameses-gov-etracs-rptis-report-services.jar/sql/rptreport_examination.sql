[getUsers]
select distinct u.objid, u.name, u.jobtitle  
from sys_user u
inner join examiner_finding e on u.objid = e.inspectedby_objid
order by u.name 


[getExaminationFindings]
select x.* 
from (
  select 
    ef.dtinspected, ef.findings, ef.recommendations, ef.notedby, ef.notedbytitle,
    ef.inspectedby_name, ef.inspectedby_title, ef.objid, ef.inspectedby_objid,
    case when f.tdno is not null then f.tdno else concat('Prev# ', f.prevtdno) end as refno
  from examiner_finding ef
    inner join faas f on ef.parent_objid = f.objid 
  where ef.dtinspected >= $P{startdate} and ef.dtinspected < $P{enddate}
    and ef.inspectedby_objid like $P{userid}

  union all 

  select 
    ef.dtinspected, ef.findings, ef.recommendations, ef.notedby, ef.notedbytitle,
    ef.inspectedby_name, ef.inspectedby_title, ef.objid, ef.inspectedby_objid,
    concat('SD# ', s.txnno) as refno
  from examiner_finding ef
    inner join subdivision s on ef.parent_objid = s.objid 
  where ef.dtinspected >= $P{startdate} and ef.dtinspected < $P{enddate}
    and ef.inspectedby_objid like $P{userid}

  union all 

  select 
    ef.dtinspected, ef.findings, ef.recommendations, ef.notedby, ef.notedbytitle,
    ef.inspectedby_name, ef.inspectedby_title, ef.objid, ef.inspectedby_objid,
    concat('CS# ',c.txnno) as refno
  from examiner_finding ef
    inner join consolidation c on ef.parent_objid = c.objid 
  where ef.dtinspected >= $P{startdate} and ef.dtinspected < $P{enddate}
    and ef.inspectedby_objid like $P{userid}
) x
order by x.dtinspected, x.inspectedby_name, x.refno



