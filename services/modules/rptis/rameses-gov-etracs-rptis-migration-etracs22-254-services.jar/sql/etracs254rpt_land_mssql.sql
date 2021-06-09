[updateLandAdjustments]
update adj set  
  adj.basemarketvalue = (select sum(basemarketvalue) from landdetail where landrpuid = r.objid),
  adj.marketvalue = (select sum(marketvalue) from landdetail where landrpuid = r.objid)
from rpu r 
  inner join landadjustment adj on r.objid = adj.landrpuid
where rpu.objid = $P{objid}
  and adj.type='LV' 
  and adj.basemarketvalue is null;


[updateLandDetailAdjustments]
update adj set 
  adj.landrpuid = ld.landrpuid,
  adj.basemarketvalue = ld.basemarketvalue,
  adj.marketvalue = ld.marketvalue 
from landdetail ld
  inner join landadjustment adj on ld.objid = adj.landdetailid
where ld.landrpuid = $P{objid}
  and adj.type = 'AU' 
  and adj.basemarketvalue is null 
