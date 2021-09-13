[updateLandAdjustments]
update 
	landadjustment adj,
	rpu r
set  
  adj.basemarketvalue = (select sum(basemarketvalue) from landdetail where landrpuid = r.objid),
  adj.marketvalue = (select sum(marketvalue) from landdetail where landrpuid = r.objid)
where adj.landrpuid = $P{objid}
  and adj.landrpuid = r.objid 
  and adj.type='LV' 
  and adj.basemarketvalue is null;

[updateLandDetailAdjustments]
update 
	landdetail ld, 
	landadjustment adj
set 
  adj.landrpuid = ld.landrpuid,
  adj.basemarketvalue = ld.basemarketvalue,
  adj.marketvalue = ld.marketvalue 
where ld.landrpuid = $P{objid}
  and ld.objid = adj.landdetailid 
  and adj.type = 'AU' 
  and adj.basemarketvalue is null 
