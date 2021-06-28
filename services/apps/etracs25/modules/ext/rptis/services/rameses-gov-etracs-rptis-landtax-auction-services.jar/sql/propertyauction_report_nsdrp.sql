[getPublication]
select 
	rl.objid as ledgerid,
	rl.tdno,
	rl.fullpin,
	rl.cadastrallotno,
	rl.titleno,
	rl.blockno,
	rl.classcode,
	pc.name as classification, 
	case when f.objid is null then e.name else f.owner_name end as owner_name,
	case when f.objid is null then e.address_text else f.owner_address end as owner_address,
	b.name as barangay,
	o.name as lgu, 
	rl.totalareaha,
	rl.totalareaha * 10000 as totalareasqm, 
	rl.totalmv,
	rl.totalav, 
	n.objid as noticeid, 
	n.period,
	n.basic,
	n.basicint,
	n.basicdisc,
	n.sef,
	n.sefint,
	n.sefdisc,
	n.basicidle,
	n.basicidleint,
	n.basicidledisc,
	n.firecode,
	n.costofsale,
	n.amtdue
from propertyauction a
inner join propertyauction_publication p on a.objid = p.parent_objid
inner join propertyauction_notice n on p.notice_objid = n.objid 
inner join rptledger rl on n.rptledger_objid = rl.objid 
inner join entity e on rl.taxpayer_objid = e.objid 
inner join barangay b on rl.barangayid = b.objid 
left join faas f on rl.faasid = f.objid 
left join sys_org o on rl.lguid = o.objid
inner join propertyclassification pc on rl.classification_objid = pc.objid 
where ${filter}
order by o.code, b.pin, rl.tdno 