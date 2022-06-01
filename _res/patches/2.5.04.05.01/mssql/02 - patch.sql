if exists(select * from sysobjects where id = OBJECT_ID('vw_real_property_payment'))
begin
	drop view vw_real_property_payment
end 
go 

create view vw_real_property_payment as 
select 
	cv.controldate as cv_controldate,
	rem.controldate as rem_controldate,
	rl.owner_name,
	rl.tdno,
	pc.name as classification, 
	case 
		when rl.rputype = 'land' then 'LAND' 
		when rl.rputype = 'bldg' then 'BUILDING' 
		when rl.rputype = 'mach' then 'MACHINERY' 
		when rl.rputype = 'planttree' then 'PLANT/TREE' 
		else 'MISCELLANEOUS'
	end as rputype,
	b.name as barangay,
	rpi.year, 
	rpi.qtr,
	rpi.amount + rpi.interest - rpi.discount as amount,
	case when v.objid is null then 0 else 1 end as voided
from collectionvoucher cv 
	inner join remittance rem on cv.objid = rem.collectionvoucherid
	inner join cashreceipt cr on rem.objid = cr.remittanceid
	inner join rptpayment rp on cr.objid = rp.receiptid 
	inner join rptpayment_item rpi on rp.objid = rpi.parentid 
	inner join rptledger rl on rp.refid = rl.objid 
	inner join barangay b on rl.barangayid = b.objid 
	inner join propertyclassification pc on rl.classification_objid = pc.objid 
	left join cashreceipt_void v on cr.objid = v.receiptid 
go


if exists(select * from sysobjects where id = OBJECT_ID('vw_newly_assessed_property'))
begin
	drop view vw_newly_assessed_property
end 
go 

create view vw_newly_assessed_property
as 
select
	f.objid,
	f.owner_name,
	f.tdno,
	b.name as barangay,
	case 
		when f.rputype = 'land' then 'LAND' 
		when f.rputype = 'bldg' then 'BUILDING' 
		when f.rputype = 'mach' then 'MACHINERY' 
		when f.rputype = 'planttree' then 'PLANT/TREE' 
		else 'MISCELLANEOUS'
	end as rputype,
	f.totalav,
	f.effectivityyear
from faas_list f 
	inner join barangay b on f.barangayid = b.objid 
where f.state in ('CURRENT', 'CANCELLED') 
and f.txntype_objid = 'ND' 
go


if exists(select * from sysobjects where id = OBJECT_ID('vw_report_orc'))
begin
	drop view vw_report_orc
end 
go 


create view vw_report_orc as 
select 
	f.objid,
	f.state,
	e.objid as taxpayerid,
	e.name as taxpayer_name,
	e.address_text as taxpayer_address,
  	o.name as lgu_name,
	o.code as lgu_indexno,
	f.dtapproved,
	r.rputype,
	pc.code as classcode,
	pc.name as classification,
	f.fullpin as pin,
	f.titleno,
	rp.cadastrallotno,
	f.tdno,
	'' as arpno,
	f.prevowner,
	b.name as location,
	r.totalareaha,
	r.totalareasqm,
	r.totalmv, 
	r.totalav,
	case when f.state = 'CURRENT' then '' else 'CANCELLED' end as remarks
from faas f
inner join rpu r on f.rpuid = r.objid 
inner join realproperty rp on f.realpropertyid = rp.objid 
inner join propertyclassification pc on r.classification_objid = pc.objid 
inner join entity e on f.taxpayer_objid = e.objid 
inner join sys_org o on rp.lguid = o.objid 
inner join barangay b on rp.barangayid = b.objid 
where f.state in ('CURRENT', 'CANCELLED')
go 




create index ix_year on rptpayment_item (year)
go
create index ix_revperiod on rptpayment_item (revperiod)
go
create index ix_revtype on rptpayment_item (revtype)
go 



create index ix_year on rptpayment_share (year)
go
create index ix_revperiod on rptpayment_share (revperiod)
go
create index ix_revtype on rptpayment_share (revtype)
go


CREATE TABLE cashreceipt_rpt_share_forposting_repost (
	objid varchar(50) NOT NULL,
  rptpaymentid varchar(50) NOT NULL,
  receiptid varchar(50) NOT NULL,
  receiptdate date NOT NULL,
  rptledgerid varchar(50) NOT NULL,
	primary key (objid)
)
go

create unique index ux_receiptid_rptledgerid on cashreceipt_rpt_share_forposting_repost (receiptid,rptledgerid)
go 

create index fk_rptshare_repost_rptledgerid on cashreceipt_rpt_share_forposting_repost (rptledgerid)
go

create index fk_rptshare_repost_cashreceiptid on cashreceipt_rpt_share_forposting_repost (receiptid)
go

alter table cashreceipt_rpt_share_forposting_repost 
	add CONSTRAINT fk_rptshare_repost_cashreceipt FOREIGN KEY (receiptid) REFERENCES cashreceipt (objid)
go 

alter table cashreceipt_rpt_share_forposting_repost 
	add CONSTRAINT fk_rptshare_repost_rptledger FOREIGN KEY (rptledgerid) REFERENCES rptledger (objid)
go 

update sys_sequence set objid = ('TDNO-' + objid ) where objid like '[0-9][0-9]%'
go 



create table faas_requested_series (
  objid varchar(50) not null,
  parentid varchar(50) not null,
  series varchar(255) not null,
  requestedby_name varchar(255) not null,
  requestedby_date date not null,
  createdby_name varchar(255) not null,
  createdby_date datetime not null,
  primary key (objid)
) 
go 

create index fk_faas_requested_series_sys_sequence on faas_requested_series (parentid)
go 

alter table faas_requested_series 
  add constraint fk_faas_requested_series_sys_sequence 
  foreign key (parentid) references sys_sequence (objid)
go 






if exists(select * from sysobjects where id = object_id('rpt_syncdata_item_completed'))
begin 
  drop table rpt_syncdata_item_completed
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_completed'))
begin 
  drop table rpt_syncdata_completed
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_forsync'))
begin 
  drop table rpt_syncdata_forsync
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_fordownload'))
begin 
  drop table rpt_syncdata_fordownload
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_error'))
begin 
  drop table rpt_syncdata_error
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_item'))
begin 
  drop table rpt_syncdata_item
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata'))
begin 
  drop table rpt_syncdata
end 
go 

CREATE TABLE rpt_syncdata (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  [action] varchar(50) NOT NULL,
  dtfiled datetime NOT NULL,
  orgid varchar(50) NOT NULL,
  remote_orgid varchar(50) DEFAULT NULL,
  remote_orgcode varchar(5) DEFAULT NULL,
  remote_orgclass varchar(25) DEFAULT NULL,
  sender_objid varchar(50) DEFAULT NULL,
  sender_name varchar(255) DEFAULT NULL,
  sender_title varchar(80) DEFAULT NULL,
  info text,
  PRIMARY KEY (objid)
) 
go

create index ix_state on rpt_syncdata(state)
go
create index ix_refid on rpt_syncdata(refid)
go
create index ix_refno on rpt_syncdata(refno)
go
create index ix_orgid on rpt_syncdata(orgid)
go

CREATE TABLE rpt_syncdata_item (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  [action] varchar(50) NOT NULL,
  idx int NOT NULL,
  info text,
  error text,
  filekey varchar(1200) DEFAULT NULL,
  etag varchar(255) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create index ix_parentid on rpt_syncdata_item (parentid)
go
create index ix_state on rpt_syncdata_item (state)
go
create index ix_refid on rpt_syncdata_item (refid)
go
create index ix_refno on rpt_syncdata_item (refno)
go
alter table rpt_syncdata_item 
add CONSTRAINT rpt_syncdata_item_ibfk_1 FOREIGN KEY (parentid) REFERENCES rpt_syncdata (objid)
go 

CREATE TABLE rpt_syncdata_forsync (
  objid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  [action] varchar(50) NOT NULL,
  orgid varchar(50) NOT NULL,
  dtfiled datetime NOT NULL,
  createdby_objid varchar(50) DEFAULT NULL,
  createdby_name varchar(255) DEFAULT NULL,
  createdby_title varchar(50) DEFAULT NULL,
  remote_orgid varchar(15) DEFAULT NULL,
  state varchar(25) DEFAULT NULL,
  info text,
  PRIMARY KEY (objid)
) 
go

create index ix_refno on rpt_syncdata_forsync (refno)
go
create index ix_orgid on rpt_syncdata_forsync (orgid)
go
create index ix_state on rpt_syncdata_forsync (state)
go

CREATE TABLE rpt_syncdata_fordownload (
  objid varchar(255) NOT NULL,
  etag varchar(64) NOT NULL,
  error int NOT NULL,
  PRIMARY KEY (objid)
)
go 

create index ix_error on rpt_syncdata_fordownload(error)
go 

CREATE TABLE rpt_syncdata_error (
  objid varchar(50) NOT NULL,
  filekey varchar(1000) NOT NULL,
  error text,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  [action] varchar(50) NOT NULL,
  idx int NOT NULL,
  info text,
  parent text,
  remote_orgid varchar(50) DEFAULT NULL,
  remote_orgcode varchar(5) DEFAULT NULL,
  remote_orgclass varchar(50) DEFAULT NULL,
  state varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create index ix_refid on rpt_syncdata_error(refid)
go
create index ix_refno on rpt_syncdata_error(refno)
go
create index ix_filekey on rpt_syncdata_error(filekey)
go
create index ix_remote_orgid on rpt_syncdata_error(remote_orgid)
go
create index ix_remote_orgcode on rpt_syncdata_error(remote_orgcode)
go
create index ix_state on rpt_syncdata_error(state)
go

CREATE TABLE rpt_syncdata_completed (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  [action] varchar(50) NOT NULL,
  dtfiled datetime NOT NULL,
  orgid varchar(50) NOT NULL,
  remote_orgid varchar(50) DEFAULT NULL,
  remote_orgcode varchar(5) DEFAULT NULL,
  remote_orgclass varchar(25) DEFAULT NULL,
  sender_objid varchar(50) DEFAULT NULL,
  sender_name varchar(255) DEFAULT NULL,
  sender_title varchar(80) DEFAULT NULL,
  info text,
  PRIMARY KEY (objid)
) 
go 

create index ix_state on rpt_syncdata_completed (state)
go
create index ix_refid on rpt_syncdata_completed (refid)
go
create index ix_refno on rpt_syncdata_completed (refno)
go
create index ix_orgid on rpt_syncdata_completed (orgid)
go

CREATE TABLE rpt_syncdata_item_completed (
  objid varchar(255) NOT NULL,
  parentid varchar(50) NOT NULL,
  state varchar(50) DEFAULT NULL,
  refid varchar(50) DEFAULT NULL,
  reftype varchar(50) DEFAULT NULL,
  refno varchar(50) DEFAULT NULL,
  [action] varchar(100) DEFAULT NULL,
  idx int DEFAULT NULL,
  info text,
  error text,
  PRIMARY KEY (objid)
) 
go

create index ix_refno on rpt_syncdata_item_completed (refno)
go
create index ix_refid on rpt_syncdata_item_completed (refid)
go
create index ix_remote_orgid on rpt_syncdata_item_completed (parentid)
go



if exists(select * from sysobjects where id = object_id('cashreceipt_rpt_share_forposting_repost'))
begin 
  drop table cashreceipt_rpt_share_forposting_repost
end 
go 

CREATE TABLE cashreceipt_rpt_share_forposting_repost (
  objid varchar(100) NOT NULL,
  rptpaymentid varchar(50) NOT NULL,
  receiptid varchar(50) NOT NULL,
  receiptdate date NOT NULL,
  rptledgerid varchar(50) NOT NULL,
  error int DEFAULT NULL,
  msg text,
  PRIMARY KEY (objid)
) 
go

create index ux_receiptid_rptledgerid on cashreceipt_rpt_share_forposting_repost (receiptid,rptledgerid)
go
create index fk_rptshare_repost_rptledgerid on cashreceipt_rpt_share_forposting_repost (rptledgerid) 
go
create index fk_rptshare_repost_cashreceiptid on cashreceipt_rpt_share_forposting_repost (receiptid) 
go
alter table cashreceipt_rpt_share_forposting_repost 
  add CONSTRAINT cashreceipt_rpt_share_forposting_repost_ibfk_1 FOREIGN KEY (receiptid) REFERENCES cashreceipt (objid)
go

alter table cashreceipt_rpt_share_forposting_repost 
  add CONSTRAINT cashreceipt_rpt_share_forposting_repost_ibfk_2 FOREIGN KEY (rptledgerid) REFERENCES rptledger (objid)
go


if exists(select * from sysobjects where id = object_id('rpt_syncdata_completed'))
begin 
  drop table rpt_syncdata_completed
end 
go 
CREATE TABLE rpt_syncdata_completed (
  objid varchar(50) NOT NULL,
  idx int,
  [action] varchar(50) ,
  refid varchar(50) ,
  reftype varchar(50) ,
  refno varchar(50) ,
  parent_orgid varchar(50) ,
  sender_name varchar(255) DEFAULT NULL,
  sender_title varchar(80) DEFAULT NULL,
  dtcreated datetime,
  info text,
  PRIMARY KEY (objid)
) 
go

create index ix_refid on rpt_syncdata_completed (refid)
go
create index ix_refno on rpt_syncdata_completed (refno)
go
create index ix_parent_orgid on rpt_syncdata_completed (parent_orgid)
go



alter table cashreceipt_rpt_share_forposting_repost add receipttype varchar(10)
go

alter table cashreceipt_rpt_share_forposting_repost drop constraint fk_rptshare_repost_cashreceipt
go


/* MACHUSE: TAXABLE SUPPORT  */

alter table machuse add taxable int
go
update machuse set taxable = 1 where taxable is null
go
create unique index ux_actualuseid_taxable on machuse(machrpuid, actualuse_objid, taxable)
go


/* SYNCDATA: pre-download file */

if exists(select * from sysobjects where id = object_id('rpt_syncdata_item_completed'))
begin
  drop table rpt_syncdata_item_completed
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_completed'))
begin
  drop table rpt_syncdata_completed
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_item'))
begin
  drop table rpt_syncdata_item
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata'))
begin
  drop table rpt_syncdata
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_forsync'))
begin
  drop table rpt_syncdata_forsync
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_fordownload'))
begin
  drop table rpt_syncdata_fordownload
end 
go 

CREATE TABLE rpt_syncdata_forsync (
  objid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  action varchar(50) NOT NULL,
  orgid varchar(50) NOT NULL,
  dtfiled datetime NOT NULL,
  createdby_objid varchar(50) DEFAULT NULL,
  createdby_name varchar(255) DEFAULT NULL,
  createdby_title varchar(50) DEFAULT NULL,
  remote_orgid varchar(15) DEFAULT NULL,
  state varchar(25) DEFAULT NULL,
  info text,
  PRIMARY KEY (objid)
) 
go 

create index ix_refno on rpt_syncdata_forsync (refno)
go
create index ix_orgid on rpt_syncdata_forsync (orgid)
go
create index ix_state on rpt_syncdata_forsync (state)
go

CREATE TABLE rpt_syncdata_fordownload (
  objid varchar(255) NOT NULL,
  etag varchar(64) NOT NULL,
  error int NOT NULL,
  state varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go

create index ix_error on rpt_syncdata_fordownload (error)
go
create index ix_state on rpt_syncdata_fordownload (state)
go

CREATE TABLE rpt_syncdata (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  action varchar(50) NOT NULL,
  dtfiled datetime NOT NULL,
  orgid varchar(50) NOT NULL,
  remote_orgid varchar(50) DEFAULT NULL,
  remote_orgcode varchar(5) DEFAULT NULL,
  remote_orgclass varchar(25) DEFAULT NULL,
  sender_objid varchar(50) DEFAULT NULL,
  sender_name varchar(255) DEFAULT NULL,
  sender_title varchar(80) DEFAULT NULL,
  info text,
  PRIMARY KEY (objid)
)
go

create index ix_state on rpt_syncdata (state)
go
create index ix_refid on rpt_syncdata (refid)
go
create index ix_refno on rpt_syncdata (refno)
go
create index ix_orgid on rpt_syncdata (orgid)
go

CREATE TABLE rpt_syncdata_item (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  action varchar(50) NOT NULL,
  idx int NOT NULL,
  info text,
  error text,
  filekey varchar(1200) DEFAULT NULL,
  etag varchar(255) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create index ix_parentid on rpt_syncdata_item (parentid)
go
create index ix_state on rpt_syncdata_item (state)
go
create index ix_refid on rpt_syncdata_item (refid)
go
create index ix_refno on rpt_syncdata_item (refno)
go
alter table rpt_syncdata_item 
add CONSTRAINT rpt_syncdata_item_ibfk_1 FOREIGN KEY (parentid) REFERENCES rpt_syncdata (objid)
go 

CREATE TABLE rpt_syncdata_completed (
  objid varchar(50) NOT NULL,
  action varchar(50) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  sender_name varchar(255) DEFAULT NULL,
  sender_title varchar(80) DEFAULT NULL,
  dtcreated datetime DEFAULT NULL,
  info text,
  dtfiled datetime DEFAULT NULL,
  orgid varchar(50) DEFAULT NULL,
  sender_objid varchar(50) DEFAULT NULL,
  remote_orgid varchar(50) DEFAULT NULL,
  remote_orgcode varchar(25) DEFAULT NULL,
  remote_orgclass varchar(25) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go

create index ix_refid on rpt_syncdata_completed (refid)
go
create index ix_refno on rpt_syncdata_completed (refno)
go

CREATE TABLE rpt_syncdata_item_completed (
  objid varchar(255) NOT NULL,
  parentid varchar(50) NOT NULL,
  refid varchar(50) DEFAULT NULL,
  reftype varchar(50) DEFAULT NULL,
  refno varchar(50) DEFAULT NULL,
  action varchar(100) DEFAULT NULL,
  idx int DEFAULT NULL,
  info text,
  PRIMARY KEY (objid)
) 
go 

create index ix_refno on rpt_syncdata_item_completed (refno)
go
create index ix_refid on rpt_syncdata_item_completed (refid)
go
create index ix_remote_orgid on rpt_syncdata_item_completed (parentid)
go





/* RPT CERTIFICATION WORKFLOW */
delete from sys_wf_node where processname = 'rptcertification';
delete from sys_wf_transition where processname = 'rptcertificastion';

INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('start', 'rptcertification', 'Start', 'start', '1', NULL, NULL, NULL, '[:]', '[fillColor:''#00ff00'',size:[32,32],pos:[102,127],type:''start'']', NULL)
GO
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('receiver', 'rptcertification', 'Received', 'state', '2', NULL, 'RPT', 'CERTIFICATION_ISSUER', '[:]', '[fillColor:''#c0c0c0'',size:[114,40],pos:[206,127],type:''state'']', '1')
GO
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('verifier', 'rptcertification', 'For Verification', 'state', '3', NULL, 'RPT', 'CERTIFICATION_VERIFIER', '[:]', '[fillColor:''#c0c0c0'',size:[129,44],pos:[412,127],type:''state'']', '1')
GO
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('approver', 'rptcertification', 'For Approval', 'state', '4', NULL, 'RPT', 'CERTIFICATION_APPROVER', '[:]', '[fillColor:''#c0c0c0'',size:[118,42],pos:[604,141],type:''state'']', '1')
GO
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-releaser', 'rptcertification', 'Releasing', 'state', '6', NULL, 'RPT', 'CERTIFICATION_RELEASER', '[:]', '[fillColor:''#c0c0c0'',size:[118,42],pos:[604,141],type:''state'']', '1')
GO
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('releaser', 'rptcertification', 'For Release', 'state', '7', NULL, 'RPT', 'CERTIFICATION_RELEASER', '[:]', '[fillColor:''#c0c0c0'',size:[118,42],pos:[604,141],type:''state'']', '1')
GO
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('released', 'rptcertification', 'Released', 'end', '8', NULL, 'RPT', 'CERTIFICATION_RELEASER', '[:]', '[fillColor:''#ff0000'',size:[32,32],pos:[797,148],type:''end'']', '1')
GO

INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('start', 'rptcertification', 'assign', 'receiver', '1', NULL, '[:]', NULL, 'Assign', '[size:[72,0],pos:[134,142],type:''arrow'',points:[134,142,206,142]]')
GO
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('receiver', 'rptcertification', 'cancelissuance', 'end', '5', NULL, '[caption:''Cancel Issuance'', confirm:''Cancel issuance?'',closeonend:true]', NULL, 'Cancel Issuance', '[size:[559,116],pos:[258,32],type:''arrow'',points:[262,127,258,32,817,40,813,148]]')
GO
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('receiver', 'rptcertification', 'submit', 'verifier', '6', NULL, '[caption:''Submit to Verifier'', confirm:''Submit to verifier?'', messagehandler:''rptmessage:info'',targetrole:''RPT.CERTIFICATION_VERIFIER'']', NULL, 'Submit to Verifier', '[size:[92,0],pos:[320,146],type:''arrow'',points:[320,146,412,146]]')
GO
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('verifier', 'rptcertification', 'return_receiver', 'receiver', '10', NULL, '[caption:''Return to Issuer'', confirm:''Return to issuer?'', messagehandler:''default'']', NULL, 'Return to Receiver', '[size:[160,63],pos:[292,64],type:''arrow'',points:[452,127,385,64,292,127]]')
GO
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('verifier', 'rptcertification', 'submit', 'approver', '11', NULL, '[caption:''Submit for Approval'', confirm:''Submit for approval?'', messagehandler:''rptmessage:sign'',targetrole:''RPT.CERTIFICATION_APPROVER'']', NULL, 'Submit to Approver', '[size:[63,4],pos:[541,152],type:''arrow'',points:[541,152,604,156]]')
GO
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('approver', 'rptcertification', 'return_receiver', 'receiver', '15', NULL, '[caption:''Return to Issuer'', confirm:''Return to issuer?'', messagehandler:''default'']', NULL, 'Return to Receiver', '[size:[333,113],pos:[285,167],type:''arrow'',points:[618,183,414,280,285,167]]')
GO
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('approver', 'rptcertification', 'submit', 'assign-releaser', '16', NULL, '[caption:''Approve'', confirm:''Approve?'', messagehandler:''rptmessage:sign'']', NULL, 'Approve', '[size:[75,0],pos:[722,162],type:''arrow'',points:[722,162,797,162]]')
GO
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-releaser', 'rptcertification', 'assign', 'releaser', '20', NULL, '[caption:''Assign to Me'', confirm:''Assign task to you?'']', NULL, 'Assign To Me', '[size:[63,4],pos:[541,152],type:''arrow'',points:[541,152,604,156]]')
GO
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('releaser', 'rptcertification', 'submit', 'released', '100', '', '[caption:''Release Certification'', confirm:''Release certifications?'', closeonend:false, messagehandler:''rptmessage:info'']', '', 'Release Certification', '[:]')
GO

INSERT INTO  sys_usergroup ([objid], [title], [domain], [userclass], [orgclass], [role]) VALUES ('RPT.CERTIFICATION_APPROVER', 'CERTIFICATION_APPROVER', 'RPT', NULL, NULL, 'CERTIFICATION_APPROVER')
GO
INSERT INTO  sys_usergroup ([objid], [title], [domain], [userclass], [orgclass], [role]) VALUES ('RPT.CERTIFICATION_ISSUER', 'CERTIFICATION_ISSUER', 'RPT', 'usergroup', NULL, 'CERTIFICATION_ISSUER')
GO
INSERT INTO  sys_usergroup ([objid], [title], [domain], [userclass], [orgclass], [role]) VALUES ('RPT.CERTIFICATION_RELEASER', 'RPT CERTIFICATION_RELEASER', 'RPT', NULL, NULL, 'CERTIFICATION_RELEASER')
GO
INSERT INTO  sys_usergroup ([objid], [title], [domain], [userclass], [orgclass], [role]) VALUES ('RPT.CERTIFICATION_VERIFIER', 'RPT CERTIFICATION_VERIFIER', 'RPT', NULL, NULL, 'CERTIFICATION_VERIFIER')
GO


alter table rptcertification add taskid varchar(50)
go

CREATE TABLE rptcertification_task (
  objid varchar(50) NOT NULL,
  refid varchar(50) DEFAULT NULL,
  parentprocessid varchar(50) DEFAULT NULL,
  state varchar(50) DEFAULT NULL,
  startdate datetime DEFAULT NULL,
  enddate datetime DEFAULT NULL,
  assignee_objid varchar(50) DEFAULT NULL,
  assignee_name varchar(100) DEFAULT NULL,
  assignee_title varchar(80) DEFAULT NULL,
  actor_objid varchar(50) DEFAULT NULL,
  actor_name varchar(100) DEFAULT NULL,
  actor_title varchar(80) DEFAULT NULL,
  message varchar(255) DEFAULT NULL,
  signature text,
  returnedby varchar(100) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create index ix_refid on rptcertification_task (refid)
go 

create index ix_assignee_objid on rptcertification_task (assignee_objid)
go 

alter table rptcertification_task 
add CONSTRAINT rptcertification_task_ibfk_1 FOREIGN KEY (refid) REFERENCES rptcertification (objid)
go 


/* STOREY ADJUSTMENT SUPPORT */
alter table bldgtype add storeyadjtype varchar(10)
go
update bldgtype set storeyadjtype = 'bytype' where storeyadjtype is null
go


alter table bldgflooradditional add issystem int
go
update bldgflooradditional set issystem = 0 where issystem is null 
go

INSERT INTO rptparameter ([objid], [state], [name], [caption], [description], [paramtype], [minvalue], [maxvalue]) 
VALUES ('MULTI_STOREY_RATE', 'APPROVED', 'MULTI_STOREY_RATE', 'MULTI-STOREY RATE', NULL, 'decimal', '0.00', '0.00')
go


INSERT INTO bldgadditionalitem ([objid], [bldgrysettingid], [code], [name], [unit], [expr], [previd], [type], [addareatobldgtotalarea], [idx]) 
select
  ('BMSA-' + r.objid) as objid, 
  r.objid as bldgrysettingid, 
  'BMSA' as code, 
  'MULTI-STOREY ADJUSTMENT' as name, 
  'RATE' as unit, 
  'SYS_AREA * SYS_BASE_VALUE * MULTI_STOREY_RATE  / 100.0' as expr, 
  NULL as previd, 
  'adjustment' as type, 
  '0' as addareatobldgtotalarea, 
  '100' as idx
from bldgrysetting r
go 

if exists(select * from sysobjects where id = object_id('bldgtype_storeyadjustment_bldgkind'))
begin
  DROP TABLE bldgtype_storeyadjustment_bldgkind
end
go

if exists(select * from sysobjects where id = object_id('bldgtype_storeyadjustment'))
begin
  DROP TABLE bldgtype_storeyadjustment
end
go


CREATE TABLE bldgtype_storeyadjustment (
  objid varchar(50) NOT NULL,
  bldgrysettingid varchar(50) NOT NULL,
  bldgtypeid varchar(50) NOT NULL,
  floorno int NOT NULL,
  rate decimal(16,2) NOT NULL,
  previd varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create UNIQUE index ux_bldgtype_storeyadjustment on bldgtype_storeyadjustment(bldgtypeid,floorno,rate)
go 
create index bldgtypeid on bldgtype_storeyadjustment (bldgtypeid)
go 
create index FK_bldgtype_storeyadjustment on bldgtype_storeyadjustment (previd)
go 
create index FK_bldgtype_storeyadjustment_bldgrysetting on bldgtype_storeyadjustment (bldgrysettingid)
go 
alter table bldgtype_storeyadjustment 
add CONSTRAINT bldgtype_storeyadjustment_ibfk_1 FOREIGN KEY (previd) REFERENCES bldgtype_storeyadjustment (objid)
go 
alter table bldgtype_storeyadjustment 
add CONSTRAINT bldgtype_storeyadjustment_ibfk_2 FOREIGN KEY (bldgrysettingid) REFERENCES bldgrysetting (objid)
go 
alter table bldgtype_storeyadjustment 
add CONSTRAINT bldgtype_storeyadjustment_ibfk_3 FOREIGN KEY (bldgtypeid) REFERENCES bldgtype (objid)
go 

CREATE TABLE bldgtype_storeyadjustment_bldgkind (
  objid varchar(50) NOT NULL,
  bldgrysettingid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  bldgtypeid varchar(50) NOT NULL,
  floorno int NOT NULL,
  bldgkindid varchar(50) NOT NULL,
  PRIMARY KEY (objid)
) 
go 

create UNIQUE index ux_bldgtype_kind_floorno on bldgtype_storeyadjustment_bldgkind (bldgtypeid,bldgkindid,floorno)
go 
create index fk_storeyadjustment_bldgkind_bldgrysetting on bldgtype_storeyadjustment_bldgkind (bldgrysettingid)
go
create index fk_storeyadjustment_bldgkind_parent on bldgtype_storeyadjustment_bldgkind (parentid)
go
alter table bldgtype_storeyadjustment_bldgkind 
add CONSTRAINT fk_storeyadjustment_bldgkind_bldgrysetting FOREIGN KEY (bldgrysettingid) REFERENCES bldgrysetting (objid)
go
alter table bldgtype_storeyadjustment_bldgkind 
add CONSTRAINT fk_storeyadjustment_bldgkind_bldgtype FOREIGN KEY (bldgtypeid) REFERENCES bldgtype (objid)
go
alter table bldgtype_storeyadjustment_bldgkind 
add CONSTRAINT fk_storeyadjustment_bldgkind_parent FOREIGN KEY (parentid) REFERENCES bldgtype_storeyadjustment (objid)
go


if exists(select * from sysobjects where id = object_id('vw_assessment_notice_item'))
begin
  drop view vw_assessment_notice_item
end
go 
if exists(select * from sysobjects where id = object_id('vw_assessment_notice'))
begin
  drop view vw_assessment_notice
end
go 
if exists(select * from sysobjects where id = object_id('vw_batch_rpttaxcredit_error'))
begin
  drop view vw_batch_rpttaxcredit_error
end
go 
if exists(select * from sysobjects where id = object_id('vw_batchgr'))
begin
  drop view vw_batchgr
end
go 
if exists(select * from sysobjects where id = object_id('vw_building'))
begin
  drop view vw_building
end
go 
if exists(select * from sysobjects where id = object_id('vw_certification_land_improvement'))
begin
  drop view vw_certification_land_improvement
end
go 
if exists(select * from sysobjects where id = object_id('vw_certification_landdetail'))
begin
  drop view vw_certification_landdetail
end
go 
if exists(select * from sysobjects where id = object_id('vw_faas_lookup'))
begin
  drop view vw_faas_lookup
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_abstract_of_collection_detail'))
begin
  drop view vw_landtax_abstract_of_collection_detail
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_abstract_of_collection_detail_eor'))
begin
  drop view vw_landtax_abstract_of_collection_detail_eor
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_collection_detail'))
begin
  drop view vw_landtax_collection_detail
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_collection_detail_eor'))
begin
  drop view vw_landtax_collection_detail_eor
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_collection_disposition_detail'))
begin
  drop view vw_landtax_collection_disposition_detail
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_collection_disposition_detail_eor'))
begin
  drop view vw_landtax_collection_disposition_detail_eor
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_collection_share_detail'))
begin
  drop view vw_landtax_collection_share_detail
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_collection_share_detail_eor'))
begin
  drop view vw_landtax_collection_share_detail_eor
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_eor'))
begin
  drop view vw_landtax_eor
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_eor_remittance'))
begin
  drop view vw_landtax_eor_remittance
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_lgu_account_mapping'))
begin
  drop view vw_landtax_lgu_account_mapping
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_report_rptdelinquency_detail'))
begin
  drop view vw_landtax_report_rptdelinquency_detail
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_report_rptdelinquency'))
begin
  drop view vw_landtax_report_rptdelinquency
end
go 
if exists(select * from sysobjects where id = object_id('vw_machine_smv'))
begin
  drop view vw_machine_smv
end
go 
if exists(select * from sysobjects where id = object_id('vw_machinery'))
begin
  drop view vw_machinery
end
go 
if exists(select * from sysobjects where id = object_id('vw_newly_assessed_property'))
begin
  drop view vw_newly_assessed_property
end
go 
if exists(select * from sysobjects where id = object_id('vw_online_rptcertification'))
begin
  drop view vw_online_rptcertification
end
go 
if exists(select * from sysobjects where id = object_id('vw_real_property_payment'))
begin
  drop view vw_real_property_payment
end
go 
if exists(select * from sysobjects where id = object_id('vw_report_orc'))
begin
  drop view vw_report_orc
end
go 
if exists(select * from sysobjects where id = object_id('vw_rptcertification_item'))
begin
  drop view vw_rptcertification_item
end
go 
if exists(select * from sysobjects where id = object_id('vw_rptledger_avdifference'))
begin
  drop view vw_rptledger_avdifference
end
go 
if exists(select * from sysobjects where id = object_id('vw_rptledger_cancelled_faas'))
begin
  drop view vw_rptledger_cancelled_faas
end
go 
if exists(select * from sysobjects where id = object_id('vw_rptpayment_item_detail'))
begin
  drop view vw_rptpayment_item_detail
end
go 
if exists(select * from sysobjects where id = object_id('vw_rpu_assessment'))
begin
  drop view vw_rpu_assessment
end
go 

if exists(select * from sysobjects where id = object_id('vw_assessment_notice_item'))
begin 
  drop table vw_assessment_notice_item
end
go 
if exists(select * from sysobjects where id = object_id('vw_assessment_notice'))
begin 
  drop table vw_assessment_notice
end
go 
if exists(select * from sysobjects where id = object_id('vw_batch_rpttaxcredit_error'))
begin 
  drop table vw_batch_rpttaxcredit_error
end
go 
if exists(select * from sysobjects where id = object_id('vw_batchgr'))
begin 
  drop table vw_batchgr
end
go 
if exists(select * from sysobjects where id = object_id('vw_building'))
begin 
  drop table vw_building
end
go 
if exists(select * from sysobjects where id = object_id('vw_certification_land_improvement'))
begin 
  drop table vw_certification_land_improvement
end
go 
if exists(select * from sysobjects where id = object_id('vw_certification_landdetail'))
begin 
  drop table vw_certification_landdetail
end
go 
if exists(select * from sysobjects where id = object_id('vw_faas_lookup'))
begin 
  drop table vw_faas_lookup
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_abstract_of_collection_detail'))
begin 
  drop table vw_landtax_abstract_of_collection_detail
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_abstract_of_collection_detail_eor'))
begin 
  drop table vw_landtax_abstract_of_collection_detail_eor
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_collection_detail'))
begin 
  drop table vw_landtax_collection_detail
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_collection_detail_eor'))
begin 
  drop table vw_landtax_collection_detail_eor
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_collection_disposition_detail'))
begin 
  drop table vw_landtax_collection_disposition_detail
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_collection_disposition_detail_eor'))
begin 
  drop table vw_landtax_collection_disposition_detail_eor
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_collection_share_detail'))
begin 
  drop table vw_landtax_collection_share_detail
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_collection_share_detail_eor'))
begin 
  drop table vw_landtax_collection_share_detail_eor
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_eor'))
begin 
  drop table vw_landtax_eor
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_eor_remittance'))
begin 
  drop table vw_landtax_eor_remittance
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_lgu_account_mapping'))
begin 
  drop table vw_landtax_lgu_account_mapping
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_report_rptdelinquency_detail'))
begin 
  drop table vw_landtax_report_rptdelinquency_detail
end
go 
if exists(select * from sysobjects where id = object_id('vw_landtax_report_rptdelinquency'))
begin 
  drop table vw_landtax_report_rptdelinquency
end
go 
if exists(select * from sysobjects where id = object_id('vw_machine_smv'))
begin 
  drop table vw_machine_smv
end
go 
if exists(select * from sysobjects where id = object_id('vw_machinery'))
begin 
  drop table vw_machinery
end
go 
if exists(select * from sysobjects where id = object_id('vw_newly_assessed_property'))
begin 
  drop table vw_newly_assessed_property
end
go 
if exists(select * from sysobjects where id = object_id('vw_online_rptcertification'))
begin 
  drop table vw_online_rptcertification
end
go 
if exists(select * from sysobjects where id = object_id('vw_real_property_payment'))
begin 
  drop table vw_real_property_payment
end
go 
if exists(select * from sysobjects where id = object_id('vw_report_orc'))
begin 
  drop table vw_report_orc
end
go 
if exists(select * from sysobjects where id = object_id('vw_rptcertification_item'))
begin 
  drop table vw_rptcertification_item
end
go 
if exists(select * from sysobjects where id = object_id('vw_rptledger_avdifference'))
begin 
  drop table vw_rptledger_avdifference
end
go 
if exists(select * from sysobjects where id = object_id('vw_rptledger_cancelled_faas'))
begin 
  drop table vw_rptledger_cancelled_faas
end
go 
if exists(select * from sysobjects where id = object_id('vw_rptpayment_item_detail'))
begin 
  drop table vw_rptpayment_item_detail
end
go 
if exists(select * from sysobjects where id = object_id('vw_rpu_assessment'))
begin 
  drop table vw_rpu_assessment
end
go 


CREATE VIEW vw_landtax_eor AS select  objid AS objid, receiptno AS receiptno, receiptdate AS receiptdate, txndate AS txndate, state AS state, partnerid AS partnerid, txntype AS txntype, traceid AS traceid, tracedate AS tracedate, refid AS refid, paidby AS paidby, paidbyaddress AS paidbyaddress, payer_objid AS payer_objid, paymethod AS paymethod, paymentrefid AS paymentrefid, remittanceid AS remittanceid, remarks AS remarks, amount AS amount, lockid AS lockid from  eor..eor
go
CREATE VIEW vw_landtax_eor_remittance AS select objid AS objid,state AS state,controlno AS controlno,partnerid AS partnerid,controldate AS controldate,dtcreated AS dtcreated,createdby_objid AS createdby_objid,createdby_name AS createdby_name,amount AS amount,dtposted AS dtposted,postedby_objid AS postedby_objid,postedby_name AS postedby_name,lockid AS lockid from eor..eor_remittance 
go

CREATE VIEW vw_assessment_notice AS select a.objid AS objid,a.state AS state,a.txnno AS txnno,a.txndate AS txndate,a.taxpayerid AS taxpayerid,a.taxpayername AS taxpayername,a.taxpayeraddress AS taxpayeraddress,a.dtdelivered AS dtdelivered,a.receivedby AS receivedby,a.remarks AS remarks,a.assessmentyear AS assessmentyear,a.administrator_name AS administrator_name,a.administrator_address AS administrator_address,fl.tdno AS tdno,fl.displaypin AS fullpin,fl.cadastrallotno AS cadastrallotno,fl.titleno AS titleno from ((assessmentnotice a join assessmentnoticeitem i on((a.objid = i.assessmentnoticeid))) join faas_list fl on((i.faasid = fl.objid)))
go
CREATE VIEW vw_assessment_notice_item AS select ni.objid AS objid,ni.assessmentnoticeid AS assessmentnoticeid,f.objid AS faasid,f.effectivityyear AS effectivityyear,f.effectivityqtr AS effectivityqtr,f.tdno AS tdno,f.taxpayer_objid AS taxpayer_objid,e.name AS taxpayer_name,e.address_text AS taxpayer_address,f.owner_name AS owner_name,f.owner_address AS owner_address,f.administrator_name AS administrator_name,f.administrator_address AS administrator_address,f.rpuid AS rpuid,f.lguid AS lguid,f.txntype_objid AS txntype_objid,ft.displaycode AS txntype_code,rpu.rputype AS rputype,rpu.ry AS ry,rpu.fullpin AS fullpin,rpu.taxable AS taxable,rpu.totalareaha AS totalareaha,rpu.totalareasqm AS totalareasqm,rpu.totalbmv AS totalbmv,rpu.totalmv AS totalmv,rpu.totalav AS totalav,rp.section AS section,rp.parcel AS parcel,rp.surveyno AS surveyno,rp.cadastrallotno AS cadastrallotno,rp.blockno AS blockno,rp.claimno AS claimno,rp.street AS street,o.name AS lguname,b.name AS barangay,pc.code AS classcode,pc.name AS classification from (((((((((assessmentnoticeitem ni join faas f on((ni.faasid = f.objid))) left join txnsignatory ts on(((ts.refid = f.objid) and (ts.type = 'APPROVER')))) join rpu on((f.rpuid = rpu.objid))) join propertyclassification pc on((rpu.classification_objid = pc.objid))) join realproperty rp on((f.realpropertyid = rp.objid))) join barangay b on((rp.barangayid = b.objid))) join sys_org o on((f.lguid = o.objid))) join entity e on((f.taxpayer_objid = e.objid))) join faas_txntype ft on((f.txntype_objid = ft.objid)))
go
CREATE VIEW vw_batch_rpttaxcredit_error AS select br.objid AS objid,br.parentid AS parentid,br.state AS state,br.error AS error,br.barangayid AS barangayid,rl.tdno AS tdno from (batch_rpttaxcredit_ledger br join rptledger rl on((br.objid = rl.objid))) where (br.state = 'ERROR')
go
CREATE VIEW vw_batchgr AS select bg.objid AS objid,bg.state AS state,bg.ry AS ry,bg.lgu_objid AS lgu_objid,bg.barangay_objid AS barangay_objid,bg.rputype AS rputype,bg.classification_objid AS classification_objid,bg.section AS section,bg.memoranda AS memoranda,bg.txntype_objid AS txntype_objid,bg.txnno AS txnno,bg.txndate AS txndate,bg.effectivityyear AS effectivityyear,bg.effectivityqtr AS effectivityqtr,bg.originlgu_objid AS originlgu_objid,l.name AS lgu_name,b.name AS barangay_name,b.pin AS barangay_pin,pc.name AS classification_name,t.objid AS taskid,t.state AS taskstate,t.assignee_objid AS assignee_objid from ((((batchgr bg join sys_org l on((bg.lgu_objid = l.objid))) left join barangay b on((bg.barangay_objid = b.objid))) left join propertyclassification pc on((bg.classification_objid = pc.objid))) left join batchgr_task t on(((bg.objid = t.refid) and t.enddate is null)))
go
CREATE VIEW vw_building AS select f.objid AS objid,f.state AS state,f.rpuid AS rpuid,f.realpropertyid AS realpropertyid,f.tdno AS tdno,f.fullpin AS fullpin,f.taxpayer_objid AS taxpayer_objid,f.owner_name AS owner_name,f.owner_address AS owner_address,f.administrator_name AS administrator_name,f.administrator_address AS administrator_address,f.lguid AS lgu_objid,o.name AS lgu_name,b.objid AS barangay_objid,b.name AS barangay_name,r.classification_objid AS classification_objid,pc.name AS classification_name,rp.pin AS pin,rp.section AS section,rp.ry AS ry,rp.cadastrallotno AS cadastrallotno,rp.blockno AS blockno,rp.surveyno AS surveyno,bt.objid AS bldgtype_objid,bt.name AS bldgtype_name,bk.objid AS bldgkind_objid,bk.name AS bldgkind_name,bu.basemarketvalue AS basemarketvalue,bu.adjustment AS adjustment,bu.depreciationvalue AS depreciationvalue,bu.marketvalue AS marketvalue,bu.assessedvalue AS assessedvalue,al.objid AS actualuse_objid,al.name AS actualuse_name,r.totalareaha AS totalareaha,r.totalareasqm AS totalareasqm,r.totalmv AS totalmv,r.totalav AS totalav from (((((((((((faas f join rpu r on((f.rpuid = r.objid))) join propertyclassification pc on((r.classification_objid = pc.objid))) join realproperty rp on((f.realpropertyid = rp.objid))) join barangay b on((rp.barangayid = b.objid))) join sys_org o on((f.lguid = o.objid))) join bldgrpu_structuraltype bst on((r.objid = bst.bldgrpuid))) join bldgtype bt on((bst.bldgtype_objid = bt.objid))) join bldgkindbucc bucc on((bst.bldgkindbucc_objid = bucc.objid))) join bldgkind bk on((bucc.bldgkind_objid = bk.objid))) join bldguse bu on((bst.objid = bu.structuraltype_objid))) join bldgassesslevel al on((bu.actualuse_objid = al.objid)))
go
CREATE VIEW vw_certification_land_improvement AS select f.objid AS faasid,pt.name AS improvement,ptd.areacovered AS areacovered,ptd.productive AS productive,ptd.nonproductive AS nonproductive,ptd.basemarketvalue AS basemarketvalue,ptd.marketvalue AS marketvalue,ptd.unitvalue AS unitvalue,ptd.assessedvalue AS assessedvalue from ((faas f join planttreedetail ptd on((f.rpuid = ptd.landrpuid))) join planttree pt on((ptd.planttree_objid = pt.objid)))
go
CREATE VIEW vw_certification_landdetail AS select f.objid AS faasid,ld.areaha AS areaha,ld.areasqm AS areasqm,ld.assessedvalue AS assessedvalue,ld.marketvalue AS marketvalue,ld.basemarketvalue AS basemarketvalue,ld.unitvalue AS unitvalue,lspc.name AS specificclass_name from ((faas f join landdetail ld on((f.rpuid = ld.landrpuid))) join landspecificclass lspc on((ld.landspecificclass_objid = lspc.objid)))
go
CREATE VIEW vw_faas_lookup AS select fl.objid AS objid,fl.state AS state,fl.rpuid AS rpuid,fl.utdno AS utdno,fl.tdno AS tdno,fl.txntype_objid AS txntype_objid,fl.effectivityyear AS effectivityyear,fl.effectivityqtr AS effectivityqtr,fl.taxpayer_objid AS taxpayer_objid,fl.owner_name AS owner_name,fl.owner_address AS owner_address,fl.prevtdno AS prevtdno,fl.cancelreason AS cancelreason,fl.cancelledbytdnos AS cancelledbytdnos,fl.lguid AS lguid,fl.realpropertyid AS realpropertyid,fl.displaypin AS fullpin,fl.originlguid AS originlguid,e.name AS taxpayer_name,e.address_text AS taxpayer_address,pc.code AS classification_code,pc.code AS classcode,pc.name AS classification_name,pc.name AS classname,fl.ry AS ry,fl.rputype AS rputype,fl.totalmv AS totalmv,fl.totalav AS totalav,fl.totalareasqm AS totalareasqm,fl.totalareaha AS totalareaha,fl.barangayid AS barangayid,fl.cadastrallotno AS cadastrallotno,fl.blockno AS blockno,fl.surveyno AS surveyno,fl.pin AS pin,fl.barangay AS barangay_name,fl.trackingno AS trackingno from ((faas_list fl left join propertyclassification pc on((fl.classification_objid = pc.objid))) left join entity e on((fl.taxpayer_objid = e.objid)))
go
CREATE VIEW vw_landtax_abstract_of_collection_detail 
AS 
select 
  liq.objid AS liquidationid,
  liq.controldate AS liquidationdate,
  rem.objid AS remittanceid,
  rem.dtposted AS remittancedate,
  cr.objid AS receiptid,
  cr.receiptdate AS ordate,
  cr.receiptno AS orno,
  cr.collector_objid AS collectorid,
  rl.objid AS rptledgerid,
  rl.fullpin AS fullpin,
  rl.titleno AS titleno,
  rl.cadastrallotno AS cadastrallotno,
  rl.rputype AS rputype,
  rl.totalmv AS totalmv,
  b.name AS barangay,
  rp.fromqtr AS fromqtr,
  rp.toqtr AS toqtr,
  rpi.year AS year,
  rpi.qtr AS qtr,
  rpi.revtype AS revtype,
  (case when cv.objid is null then rl.owner_name else '*** voided ***' end) AS taxpayername,
  (case when cv.objid is null then rl.tdno else '' end) AS tdno,
  (case when m.name is null then c.name else m.name end) AS municityname,
  (case when cv.objid is null then rl.classcode else '' end) AS classification,
  (case when cv.objid is null then rl.totalav else 0.0 end) AS assessvalue,
  (case when cv.objid is null then rl.totalav else 0.0 end) AS assessedvalue,
  (case when  cv.objid is null and (rpi.revtype = 'basic') and (rpi.revperiod in ('current','advance')) then rpi.amount else 0.0 end) AS basiccurrentyear,
  (case when  cv.objid is null and (rpi.revtype = 'basic') and (rpi.revperiod in ('previous','prior')) then rpi.amount else 0.0 end) AS basicpreviousyear,
  (case when  cv.objid is null and (rpi.revtype = 'basic') then rpi.discount else 0.0 end) AS basicdiscount,
  (case when  cv.objid is null and (rpi.revtype = 'basic') and (rpi.revperiod in ('current','advance')) then rpi.interest else 0.0 end) AS basicpenaltycurrent,
  (case when  cv.objid is null and (rpi.revtype = 'basic') and (rpi.revperiod in ('previous','prior')) then rpi.interest else 0.0 end) AS basicpenaltyprevious,
  (case when  cv.objid is null and (rpi.revtype = 'sef') and (rpi.revperiod in ('current','advance')) then rpi.amount else 0.0 end) AS sefcurrentyear,
  (case when  cv.objid is null and (rpi.revtype = 'sef') and (rpi.revperiod in ('previous','prior')) then rpi.amount else 0.0 end) AS sefpreviousyear,
  (case when  cv.objid is null and (rpi.revtype = 'sef') then rpi.discount else 0.0 end) AS sefdiscount,
  (case when  cv.objid is null and (rpi.revtype = 'sef') and (rpi.revperiod in ('current','advance')) then rpi.interest else 0.0 end) AS sefpenaltycurrent,
  (case when  cv.objid is null and (rpi.revtype = 'sef') and (rpi.revperiod in ('previous','prior')) then rpi.interest else 0.0 end) AS sefpenaltyprevious,
  (case when  cv.objid is null and (rpi.revtype = 'basicidle') and (rpi.revperiod in ('current','advance')) then rpi.amount else 0.0 end) AS basicidlecurrent,
  (case when  cv.objid is null and (rpi.revtype = 'basicidle') and (rpi.revperiod in ('previous','prior')) then rpi.amount else 0.0 end) AS basicidleprevious,
  (case when  cv.objid is null and (rpi.revtype = 'basicidle') then rpi.amount else 0.0 end) AS basicidlediscount,
  (case when  cv.objid is null and (rpi.revtype = 'basicidle') and (rpi.revperiod in ('current','advance')) then rpi.interest else 0.0 end) AS basicidlecurrentpenalty,
  (case when  cv.objid is null and (rpi.revtype = 'basicidle') and (rpi.revperiod in ('previous','prior')) then rpi.interest else 0.0 end) AS basicidlepreviouspenalty,
  (case when  cv.objid is null and (rpi.revtype = 'sh') and (rpi.revperiod in ('current','advance')) then rpi.amount else 0.0 end) AS shcurrent,
  (case when  cv.objid is null and (rpi.revtype = 'sh') and (rpi.revperiod in ('previous','prior')) then rpi.amount else 0.0 end) AS shprevious,
  (case when  cv.objid is null and (rpi.revtype = 'sh') then rpi.discount else 0.0 end) AS shdiscount,
  (case when  cv.objid is null and (rpi.revtype = 'sh') and (rpi.revperiod in ('current','advance')) then rpi.interest else 0.0 end) AS shcurrentpenalty,
  (case when  cv.objid is null and (rpi.revtype = 'sh') and (rpi.revperiod in ('previous','prior')) then rpi.interest else 0.0 end) AS shpreviouspenalty,
  (case when  cv.objid is null and (rpi.revtype = 'firecode') then rpi.amount else 0.0 end) AS firecode,
  (case when cv.objid is null then rpi.amount - rpi.discount + rpi.interest else 0.0 end) AS total,
  (case when cv.objid is null then rpi.partialled else 0 end) AS partialled 
  from collectionvoucher liq 
  join remittance rem on rem.collectionvoucherid = liq.objid 
  join cashreceipt cr on rem.objid = cr.remittanceid 
  left join cashreceipt_void cv on cr.objid = cv.receiptid 
  join rptpayment rp on rp.receiptid = cr.objid 
  join rptpayment_item rpi on rpi.parentid = rp.objid 
  join rptledger rl on rl.objid = rp.refid 
  join barangay b on b.objid = rl.barangayid 
  left join district d on b.parentid = d.objid 
  left join city c on d.parentid = c.objid 
  left join municipality m on b.parentid = m.objid
go
CREATE VIEW vw_landtax_abstract_of_collection_detail_eor 
AS 
select 
  rem.objid AS liquidationid,
  rem.controldate AS liquidationdate,
  rem.objid AS remittanceid,
  rem.controldate AS remittancedate,
  eor.objid AS receiptid,
  eor.receiptdate AS ordate,
  eor.receiptno AS orno,
  rem.createdby_objid AS collectorid,
  rl.objid AS rptledgerid,
  rl.fullpin AS fullpin,
  rl.titleno AS titleno,
  rl.cadastrallotno AS cadastrallotno,
  rl.rputype AS rputype,
  rl.totalmv AS totalmv,
  b.name AS barangay,
  rp.fromqtr AS fromqtr,
  rp.toqtr AS toqtr,
  rpi.year AS year,
  rpi.qtr AS qtr,
  rpi.revtype AS revtype,
(case when cv.objid is null then rl.owner_name else '*** voided ***' end) AS taxpayername,
(case when cv.objid is null then rl.tdno else '' end) AS tdno,
(case when m.name is null then c.name else m.name end) AS municityname,
(case when cv.objid is null then rl.classcode else '' end) AS classification,
(case when cv.objid is null then rl.totalav else 0.0 end) AS assessvalue,
(case when cv.objid is null then rl.totalav else 0.0 end) AS assessedvalue,
(case when (cv.objid is null and (rpi.revtype = 'basic') and (rpi.revperiod in ('current','advance'))) then rpi.amount else 0.0 end) AS basiccurrentyear,
(case when (cv.objid is null and (rpi.revtype = 'basic') and (rpi.revperiod in ('previous',
'prior'))) then rpi.amount else 0.0 end) AS basicpreviousyear,
(case when (cv.objid is null and (rpi.revtype = 'basic')) then rpi.discount else 0.0 end) AS basicdiscount,
(case when (cv.objid is null and (rpi.revtype = 'basic') and (rpi.revperiod in ('current','advance'))) then rpi.interest else 0.0 end) AS basicpenaltycurrent,
(case when (cv.objid is null and (rpi.revtype = 'basic') and (rpi.revperiod in ('previous',
'prior'))) then rpi.interest else 0.0 end) AS basicpenaltyprevious,
(case when (cv.objid is null and (rpi.revtype = 'sef') and (rpi.revperiod in ('current','advance'))) then rpi.amount else 0.0 end) AS sefcurrentyear,
(case when (cv.objid is null and (rpi.revtype = 'sef') and (rpi.revperiod in ('previous',
'prior'))) then rpi.amount else 0.0 end) AS sefpreviousyear,
(case when (cv.objid is null and (rpi.revtype = 'sef')) then rpi.discount else 0.0 end) AS sefdiscount,
(case when (cv.objid is null and (rpi.revtype = 'sef') and (rpi.revperiod in ('current','advance'))) then rpi.interest else 0.0 end) AS sefpenaltycurrent,
(case when (cv.objid is null and (rpi.revtype = 'sef') and (rpi.revperiod in ('previous',
'prior'))) then rpi.interest else 0.0 end) AS sefpenaltyprevious,
(case when (cv.objid is null and (rpi.revtype = 'basicidle') and (rpi.revperiod in ('current','advance'))) then rpi.amount else 0.0 end) AS basicidlecurrent,
(case when (cv.objid is null and (rpi.revtype = 'basicidle') and (rpi.revperiod in ('previous',
'prior'))) then rpi.amount else 0.0 end) AS basicidleprevious,
(case when (cv.objid is null and (rpi.revtype = 'basicidle')) then rpi.amount else 0.0 end) AS basicidlediscount,
(case when (cv.objid is null and (rpi.revtype = 'basicidle') and (rpi.revperiod in ('current','advance'))) then rpi.interest else 0.0 end) AS basicidlecurrentpenalty,
(case when (cv.objid is null and (rpi.revtype = 'basicidle') and (rpi.revperiod in ('previous',
'prior'))) then rpi.interest else 0.0 end) AS basicidlepreviouspenalty,
(case when (cv.objid is null and (rpi.revtype = 'sh') and (rpi.revperiod in ('current','advance'))) then rpi.amount else 0.0 end) AS shcurrent,
(case when (cv.objid is null and (rpi.revtype = 'sh') and (rpi.revperiod in ('previous',
'prior'))) then rpi.amount else 0.0 end) AS shprevious,
(case when (cv.objid is null and (rpi.revtype = 'sh')) then rpi.discount else 0.0 end) AS shdiscount,
(case when (cv.objid is null and (rpi.revtype = 'sh') and (rpi.revperiod in ('current','advance'))) then rpi.interest else 0.0 end) AS shcurrentpenalty,
(case when (cv.objid is null and (rpi.revtype = 'sh') and (rpi.revperiod in ('previous',
'prior'))) then rpi.interest else 0.0 end) AS shpreviouspenalty,
(case when (cv.objid is null and (rpi.revtype = 'firecode')) then rpi.amount else 0.0 end) AS firecode,
(case when cv.objid is null then ((rpi.amount - rpi.discount) + rpi.interest) else 0.0 end) AS total,
(case when cv.objid is null then rpi.partialled else 0 end) AS partialled from (((((((((vw_landtax_eor_remittance rem join vw_landtax_eor eor on((rem.objid = eor.remittanceid))) left join cashreceipt_void cv on((eor.objid = cv.receiptid))) join rptpayment rp on((eor.objid = rp.receiptid))) join rptpayment_item rpi on((rpi.parentid = rp.objid))) join rptledger rl on((rl.objid = rp.refid))) join barangay b on((b.objid = rl.barangayid))) left join district d on((b.parentid = d.objid))) left join city c on((d.parentid = c.objid))) left join municipality m on((b.parentid = m.objid)))
go
CREATE VIEW vw_landtax_collection_detail AS 
select 
  cv.objid AS liquidationid,
  cv.controldate AS liquidationdate,
  rem.objid AS remittanceid,
  rem.controldate AS remittancedate,
  cr.receiptdate AS receiptdate,
  o.objid AS lguid,
  o.name AS lgu,
  b.objid AS barangayid,
  b.indexno AS brgyindex,
  b.name AS barangay,
  ri.revperiod AS revperiod,
  ri.revtype AS revtype,
  ri.year AS year,
  ri.qtr AS qtr,
  ri.amount AS amount,
  ri.interest AS interest,
  ri.discount AS discount,
  pc.name AS classname,
  pc.orderno AS orderno,
  pc.special AS special,
  (case when ((ri.revperiod = 'current') and (ri.revtype = 'basic')) then ri.amount else 0.0 end) AS basiccurrent,
  (case when (ri.revtype = 'basic') then ri.discount else 0.0 end) AS basicdisc,
  (case when ((ri.revperiod in ('previous','prior')) and (ri.revtype = 'basic')) then ri.amount else 0.0 end) AS basicprev,
  (case when ((ri.revperiod = 'current') and (ri.revtype = 'basic')) then ri.interest else 0.0 end) AS basiccurrentint,
  (case when ((ri.revperiod in ('previous','prior')) and (ri.revtype = 'basic')) then ri.interest else 0.0 end) AS basicprevint,
  (case when (ri.revtype = 'basic') then ((ri.amount - ri.discount) + ri.interest) else 0 end) AS basicnet,
  (case when ((ri.revperiod = 'current') and (ri.revtype = 'sef')) then ri.amount else 0.0 end) AS sefcurrent,
  (case when (ri.revtype = 'sef') then ri.discount else 0.0 end) AS sefdisc,
  (case when ((ri.revperiod in ('previous','prior')) and (ri.revtype = 'sef')) then ri.amount else 0.0 end) AS sefprev,
  (case when ((ri.revperiod = 'current') and (ri.revtype = 'sef')) then ri.interest else 0.0 end) AS sefcurrentint,
  (case when ((ri.revperiod in ('previous','prior')) and (ri.revtype = 'sef')) then ri.interest else 0.0 end) AS sefprevint,
  (case when (ri.revtype = 'sef') then ((ri.amount - ri.discount) + ri.interest) else 0 end) AS sefnet,
  (case when ((ri.revperiod = 'current') and (ri.revtype = 'basicidle')) then ri.amount else 0.0 end) AS idlecurrent,
  (case when ((ri.revperiod in ('previous','prior')) and (ri.revtype = 'basicidle')) then ri.amount else 0.0 end) AS idleprev,
  (case when (ri.revtype = 'basicidle') then ri.discount else 0.0 end) AS idledisc,
  (case when (ri.revtype = 'basicidle') then ri.interest else 0 end) AS idleint,
  (case when (ri.revtype = 'basicidle') then ((ri.amount - ri.discount) + ri.interest) else 0 end) AS idlenet,
  (case when ((ri.revperiod = 'current') and (ri.revtype = 'sh')) then ri.amount else 0.0 end) AS shcurrent,
  (case when ((ri.revperiod in ('previous','prior')) and (ri.revtype = 'sh')) then ri.amount else 0.0 end) AS shprev,
  (case when (ri.revtype = 'sh') then ri.discount else 0.0 end) AS shdisc,
  (case when (ri.revtype = 'sh') then ri.interest else 0 end) AS shint,
  (case when (ri.revtype = 'sh') then ((ri.amount - ri.discount) + ri.interest) else 0 end) AS shnet,
  (case when (ri.revtype = 'firecode') then ((ri.amount - ri.discount) + ri.interest) else 0 end) AS firecode,
  0.0 AS levynet,
  case when crv.objid is null then 0 else 1 end as voided
from (((((((((remittance rem 
join collectionvoucher cv on((cv.objid = rem.collectionvoucherid))) 
join cashreceipt cr on((cr.remittanceid = rem.objid))) left 
join cashreceipt_void crv on((cr.objid = crv.receiptid))) 
join rptpayment rp on((cr.objid = rp.receiptid))) 
join rptpayment_item ri on((rp.objid = ri.parentid))) left 
join rptledger rl on((rp.refid = rl.objid))) left 
join barangay b on((rl.barangayid = b.objid))) left 
join sys_org o on((rl.lguid = o.objid))) left 
join propertyclassification pc on((rl.classification_objid = pc.objid))) 
go
CREATE VIEW vw_landtax_collection_detail_eor AS select rem.objid AS liquidationid,rem.controldate AS liquidationdate,rem.objid AS remittanceid,rem.controldate AS remittancedate,eor.receiptdate AS receiptdate,o.objid AS lguid,o.name AS lgu,b.objid AS barangayid,b.indexno AS brgyindex,b.name AS barangay,ri.revperiod AS revperiod,ri.revtype AS revtype,ri.year AS year,ri.qtr AS qtr,ri.amount AS amount,ri.interest AS interest,ri.discount AS discount,pc.name AS classname,pc.orderno AS orderno,pc.special AS special,(case when ((ri.revperiod = 'current') and (ri.revtype = 'basic')) then ri.amount else 0.0 end) AS basiccurrent,(case when (ri.revtype = 'basic') then ri.discount else 0.0 end) AS basicdisc,(case when ((ri.revperiod in ('previous','prior')) and (ri.revtype = 'basic')) then ri.amount else 0.0 end) AS basicprev,(case when ((ri.revperiod = 'current') and (ri.revtype = 'basic')) then ri.interest else 0.0 end) AS basiccurrentint,(case when ((ri.revperiod in ('previous','prior')) and (ri.revtype = 'basic')) then ri.interest else 0.0 end) AS basicprevint,(case when (ri.revtype = 'basic') then ((ri.amount - ri.discount) + ri.interest) else 0 end) AS basicnet,(case when ((ri.revperiod = 'current') and (ri.revtype = 'sef')) then ri.amount else 0.0 end) AS sefcurrent,(case when (ri.revtype = 'sef') then ri.discount else 0.0 end) AS sefdisc,(case when ((ri.revperiod in ('previous','prior')) and (ri.revtype = 'sef')) then ri.amount else 0.0 end) AS sefprev,(case when ((ri.revperiod = 'current') and (ri.revtype = 'sef')) then ri.interest else 0.0 end) AS sefcurrentint,(case when ((ri.revperiod in ('previous','prior')) and (ri.revtype = 'sef')) then ri.interest else 0.0 end) AS sefprevint,(case when (ri.revtype = 'sef') then ((ri.amount - ri.discount) + ri.interest) else 0 end) AS sefnet,(case when ((ri.revperiod = 'current') and (ri.revtype = 'basicidle')) then ri.amount else 0.0 end) AS idlecurrent,(case when ((ri.revperiod in ('previous','prior')) and (ri.revtype = 'basicidle')) then ri.amount else 0.0 end) AS idleprev,(case when (ri.revtype = 'basicidle') then ri.discount else 0.0 end) AS idledisc,(case when (ri.revtype = 'basicidle') then ri.interest else 0 end) AS idleint,(case when (ri.revtype = 'basicidle') then ((ri.amount - ri.discount) + ri.interest) else 0 end) AS idlenet,(case when ((ri.revperiod = 'current') and (ri.revtype = 'sh')) then ri.amount else 0.0 end) AS shcurrent,(case when ((ri.revperiod in ('previous','prior')) and (ri.revtype = 'sh')) then ri.amount else 0.0 end) AS shprev,(case when (ri.revtype = 'sh') then ri.discount else 0.0 end) AS shdisc,(case when (ri.revtype = 'sh') then ri.interest else 0 end) AS shint,(case when (ri.revtype = 'sh') then ((ri.amount - ri.discount) + ri.interest) else 0 end) AS shnet,(case when (ri.revtype = 'firecode') then ((ri.amount - ri.discount) + ri.interest) else 0 end) AS firecode,0.0 AS levynet from (((((((vw_landtax_eor_remittance rem join vw_landtax_eor eor on((rem.objid = eor.remittanceid))) join rptpayment rp on((eor.objid = rp.receiptid))) join rptpayment_item ri on((rp.objid = ri.parentid))) left join rptledger rl on((rp.refid = rl.objid))) left join barangay b on((rl.barangayid = b.objid))) left join sys_org o on((rl.lguid = o.objid))) left join propertyclassification pc on((rl.classification_objid = pc.objid)))
go
CREATE VIEW vw_landtax_collection_disposition_detail 
AS 
select 
  cv.objid AS liquidationid,
  cv.controldate AS liquidationdate,
  rem.objid AS remittanceid,
  rem.controldate AS remittancedate,
  cr.receiptdate AS receiptdate,
  ri.revperiod AS revperiod,
  (case when ((ri.revtype in ('basic','basicint','basicidle','basicidleint')) and (ri.sharetype in ('province','city'))) then ri.amount else 0.0 end) AS provcitybasicshare,
  (case when ((ri.revtype in ('basic','basicint','basicidle','basicidleint')) and (ri.sharetype = 'municipality')) then ri.amount else 0.0 end) AS munibasicshare,
  (case when ((ri.revtype in ('basic','basicint')) and (ri.sharetype = 'barangay')) then ri.amount else 0.0 end) AS brgybasicshare,
  (case when ((ri.revtype in ('sef','sefint')) and (ri.sharetype in ('province','city'))) then ri.amount else 0.0 end) AS provcitysefshare,
  (case when ((ri.revtype in ('sef','sefint')) and (ri.sharetype = 'municipality')) then ri.amount else 0.0 end) AS munisefshare,
  0.0 AS brgysefshare,
  case when crv.objid is null then 0 else 1 end as voided
from (((((remittance rem 
join collectionvoucher cv on((cv.objid = rem.collectionvoucherid))) 
join cashreceipt cr on((cr.remittanceid = rem.objid))) left 
join cashreceipt_void crv on((cr.objid = crv.receiptid))) 
join rptpayment rp on((cr.objid = rp.receiptid))) 
join rptpayment_share ri on((rp.objid = ri.parentid))) 
go
CREATE VIEW vw_landtax_collection_disposition_detail_eor AS select rem.objid AS liquidationid,rem.controldate AS liquidationdate,rem.objid AS remittanceid,rem.controldate AS remittancedate,eor.receiptdate AS receiptdate,ri.revperiod AS revperiod,(case when ((ri.revtype in ('basic','basicint','basicidle','basicidleint')) and (ri.sharetype in ('province','city'))) then ri.amount else 0.0 end) AS provcitybasicshare,(case when ((ri.revtype in ('basic','basicint','basicidle','basicidleint')) and (ri.sharetype = 'municipality')) then ri.amount else 0.0 end) AS munibasicshare,(case when ((ri.revtype in ('basic','basicint')) and (ri.sharetype = 'barangay')) then ri.amount else 0.0 end) AS brgybasicshare,(case when ((ri.revtype in ('sef','sefint')) and (ri.sharetype in ('province','city'))) then ri.amount else 0.0 end) AS provcitysefshare,(case when ((ri.revtype in ('sef','sefint')) and (ri.sharetype = 'municipality')) then ri.amount else 0.0 end) AS munisefshare,0.0 AS brgysefshare from (((vw_landtax_eor_remittance rem join vw_landtax_eor eor on((rem.objid = eor.remittanceid))) join rptpayment rp on((eor.objid = rp.receiptid))) join rptpayment_share ri on((rp.objid = ri.parentid)))
go
CREATE VIEW vw_landtax_collection_share_detail AS 
select 
  cv.objid AS liquidationid,
  cv.controlno AS liquidationno,
  cv.controldate AS liquidationdate,
  rem.objid AS remittanceid,
  rem.controlno AS remittanceno,
  rem.controldate AS remittancedate,
  cr.objid AS receiptid,
  cr.receiptno AS receiptno,
  cr.receiptdate AS receiptdate,
  cr.txndate AS txndate,
  o.name AS lgu,
  b.objid AS barangayid,
  b.name AS barangay,
  cra.revtype AS revtype,
  cra.revperiod AS revperiod,
  cra.sharetype AS sharetype,
  (case when ((cra.revperiod = 'current') and (cra.revtype = 'basic')) then cra.amount else 0 end) AS brgycurr,
  (case when ((cra.revperiod in ('previous','prior')) and (cra.revtype = 'basic')) then cra.amount else 0 end) AS brgyprev,
  (case when (cra.revtype = 'basicint') then cra.amount else 0 end) AS brgypenalty,
  (case when ((cra.revperiod = 'current') and (cra.revtype = 'basic') and (cra.sharetype = 'barangay')) then cra.amount else 0 end) AS brgycurrshare,
  (case when ((cra.revperiod in ('previous','prior')) and (cra.revtype = 'basic') and (cra.sharetype = 'barangay')) then cra.amount else 0 end) AS brgyprevshare,
  (case when ((cra.revtype = 'basicint') and (cra.sharetype = 'barangay')) then cra.amount else 0 end) AS brgypenaltyshare,
  (case when ((cra.revperiod = 'current') and (cra.revtype = 'basic') and (cra.sharetype = 'city')) then cra.amount else 0 end) AS citycurrshare,
  (case when ((cra.revperiod in ('previous','prior')) and (cra.revtype = 'basic') and (cra.sharetype = 'city')) then cra.amount else 0 end) AS cityprevshare,
  (case when ((cra.revtype = 'basicint') and (cra.sharetype = 'city')) then cra.amount else 0 end) AS citypenaltyshare,
  (case when ((cra.revperiod = 'current') and (cra.revtype = 'basic') and (cra.sharetype in ('province','municipality'))) then cra.amount else 0 end) AS provmunicurrshare,
  (case when ((cra.revperiod in ('previous','prior')) and (cra.revtype = 'basic') and (cra.sharetype in ('province','municipality'))) then cra.amount else 0 end) AS provmuniprevshare,
  (case when ((cra.revtype = 'basicint') and (cra.sharetype in ('province','municipality'))) then cra.amount else 0 end) AS provmunipenaltyshare,
  cra.amount AS amount,
  cra.discount AS discount,
  (case when crv.objid is null  then 0 else 1 end) AS voided 
  from ((((((((remittance rem join collectionvoucher cv on((cv.objid = rem.collectionvoucherid))) join cashreceipt cr on((cr.remittanceid = rem.objid))) join rptpayment rp on((cr.objid = rp.receiptid))) join rptpayment_share cra on((rp.objid = cra.parentid))) left join rptledger rl on((rp.refid = rl.objid))) left join sys_org o on((rl.lguid = o.objid))) left join barangay b on((rl.barangayid = b.objid))) left join cashreceipt_void crv on((cr.objid = crv.receiptid)))
go
CREATE VIEW vw_landtax_collection_share_detail_eor AS select rem.objid AS liquidationid,rem.controlno AS liquidationno,rem.controldate AS liquidationdate,rem.objid AS remittanceid,rem.controlno AS remittanceno,rem.controldate AS remittancedate,eor.objid AS receiptid,eor.receiptno AS receiptno,eor.receiptdate AS receiptdate,eor.txndate AS txndate,o.name AS lgu,b.objid AS barangayid,b.name AS barangay,cra.revtype AS revtype,cra.revperiod AS revperiod,cra.sharetype AS sharetype,(case when ((cra.revperiod = 'current') and (cra.revtype = 'basic')) then cra.amount else 0 end) AS brgycurr,(case when ((cra.revperiod in ('previous','prior')) and (cra.revtype = 'basic')) then cra.amount else 0 end) AS brgyprev,(case when (cra.revtype = 'basicint') then cra.amount else 0 end) AS brgypenalty,(case when ((cra.revperiod = 'current') and (cra.revtype = 'basic') and (cra.sharetype = 'barangay')) then cra.amount else 0 end) AS brgycurrshare,(case when ((cra.revperiod in ('previous','prior')) and (cra.revtype = 'basic') and (cra.sharetype = 'barangay')) then cra.amount else 0 end) AS brgyprevshare,(case when ((cra.revtype = 'basicint') and (cra.sharetype = 'barangay')) then cra.amount else 0 end) AS brgypenaltyshare,(case when ((cra.revperiod = 'current') and (cra.revtype = 'basic') and (cra.sharetype = 'city')) then cra.amount else 0 end) AS citycurrshare,(case when ((cra.revperiod in ('previous','prior')) and (cra.revtype = 'basic') and (cra.sharetype = 'city')) then cra.amount else 0 end) AS cityprevshare,(case when ((cra.revtype = 'basicint') and (cra.sharetype = 'city')) then cra.amount else 0 end) AS citypenaltyshare,(case when ((cra.revperiod = 'current') and (cra.revtype = 'basic') and (cra.sharetype in ('province','municipality'))) then cra.amount else 0 end) AS provmunicurrshare,(case when ((cra.revperiod in ('previous','prior')) and (cra.revtype = 'basic') and (cra.sharetype in ('province','municipality'))) then cra.amount else 0 end) AS provmuniprevshare,(case when ((cra.revtype = 'basicint') and (cra.sharetype in ('province','municipality'))) then cra.amount else 0 end) AS provmunipenaltyshare,cra.amount AS amount,cra.discount AS discount from (((((((vw_landtax_eor_remittance rem join vw_landtax_eor eor on((rem.objid = eor.remittanceid))) join rptpayment rp on((eor.objid = rp.receiptid))) join rptpayment_share cra on((rp.objid = cra.parentid))) left join rptledger rl on((rp.refid = rl.objid))) left join sys_org o on((rl.lguid = o.objid))) left join barangay b on((rl.barangayid = b.objid))) left join cashreceipt_void crv on((eor.objid = crv.receiptid)))
go
CREATE VIEW vw_landtax_lgu_account_mapping AS select ia.org_objid AS org_objid,ia.org_name AS org_name,o.orgclass AS org_class,p.objid AS parent_objid,p.code AS parent_code,p.title AS parent_title,ia.objid AS item_objid,ia.code AS item_code,ia.title AS item_title,ia.fund_objid AS item_fund_objid,ia.fund_code AS item_fund_code,ia.fund_title AS item_fund_title,ia.type AS item_type,pt.tag AS item_tag from (((itemaccount ia join itemaccount p on((ia.parentid = p.objid))) join itemaccount_tag pt on((p.objid = pt.acctid))) join sys_org o on((ia.org_objid = o.objid))) where (p.state = 'ACTIVE')
go
CREATE VIEW vw_landtax_report_rptdelinquency AS select ri.objid AS objid,ri.rptledgerid AS rptledgerid,ri.barangayid AS barangayid,ri.year AS year,ri.qtr AS qtr,r.dtgenerated AS dtgenerated,r.dtcomputed AS dtcomputed,r.generatedby_name AS generatedby_name,r.generatedby_title AS generatedby_title,(case when (ri.revtype = 'basic') then ri.amount else 0 end) AS basic,(case when (ri.revtype = 'basic') then ri.interest else 0 end) AS basicint,(case when (ri.revtype = 'basic') then ri.discount else 0 end) AS basicdisc,(case when (ri.revtype = 'basic') then (ri.interest - ri.discount) else 0 end) AS basicdp,(case when (ri.revtype = 'basic') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS basicnet,(case when (ri.revtype = 'basicidle') then ri.amount else 0 end) AS basicidle,(case when (ri.revtype = 'basicidle') then ri.interest else 0 end) AS basicidleint,(case when (ri.revtype = 'basicidle') then ri.discount else 0 end) AS basicidledisc,(case when (ri.revtype = 'basicidle') then (ri.interest - ri.discount) else 0 end) AS basicidledp,(case when (ri.revtype = 'basicidle') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS basicidlenet,(case when (ri.revtype = 'sef') then ri.amount else 0 end) AS sef,(case when (ri.revtype = 'sef') then ri.interest else 0 end) AS sefint,(case when (ri.revtype = 'sef') then ri.discount else 0 end) AS sefdisc,(case when (ri.revtype = 'sef') then (ri.interest - ri.discount) else 0 end) AS sefdp,(case when (ri.revtype = 'sef') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS sefnet,(case when (ri.revtype = 'firecode') then ri.amount else 0 end) AS firecode,(case when (ri.revtype = 'firecode') then ri.interest else 0 end) AS firecodeint,(case when (ri.revtype = 'firecode') then ri.discount else 0 end) AS firecodedisc,(case when (ri.revtype = 'firecode') then (ri.interest - ri.discount) else 0 end) AS firecodedp,(case when (ri.revtype = 'firecode') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS firecodenet,(case when (ri.revtype = 'sh') then ri.amount else 0 end) AS sh,(case when (ri.revtype = 'sh') then ri.interest else 0 end) AS shint,(case when (ri.revtype = 'sh') then ri.discount else 0 end) AS shdisc,(case when (ri.revtype = 'sh') then (ri.interest - ri.discount) else 0 end) AS shdp,(case when (ri.revtype = 'sh') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS shnet,((ri.amount + ri.interest) - ri.discount) AS total from (report_rptdelinquency_item ri join report_rptdelinquency r on((ri.parentid = r.objid)))
go
CREATE VIEW vw_landtax_report_rptdelinquency_detail AS select ri.objid AS objid,ri.rptledgerid AS rptledgerid,ri.barangayid AS barangayid,ri.year AS year,ri.qtr AS qtr,r.dtgenerated AS dtgenerated,r.dtcomputed AS dtcomputed,r.generatedby_name AS generatedby_name,r.generatedby_title AS generatedby_title,(case when (ri.revtype = 'basic') then ri.amount else 0 end) AS basic,(case when (ri.revtype = 'basic') then ri.interest else 0 end) AS basicint,(case when (ri.revtype = 'basic') then ri.discount else 0 end) AS basicdisc,(case when (ri.revtype = 'basic') then (ri.interest - ri.discount) else 0 end) AS basicdp,(case when (ri.revtype = 'basic') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS basicnet,(case when (ri.revtype = 'basicidle') then ri.amount else 0 end) AS basicidle,(case when (ri.revtype = 'basicidle') then ri.interest else 0 end) AS basicidleint,(case when (ri.revtype = 'basicidle') then ri.discount else 0 end) AS basicidledisc,(case when (ri.revtype = 'basicidle') then (ri.interest - ri.discount) else 0 end) AS basicidledp,(case when (ri.revtype = 'basicidle') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS basicidlenet,(case when (ri.revtype = 'sef') then ri.amount else 0 end) AS sef,(case when (ri.revtype = 'sef') then ri.interest else 0 end) AS sefint,(case when (ri.revtype = 'sef') then ri.discount else 0 end) AS sefdisc,(case when (ri.revtype = 'sef') then (ri.interest - ri.discount) else 0 end) AS sefdp,(case when (ri.revtype = 'sef') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS sefnet,(case when (ri.revtype = 'firecode') then ri.amount else 0 end) AS firecode,(case when (ri.revtype = 'firecode') then ri.interest else 0 end) AS firecodeint,(case when (ri.revtype = 'firecode') then ri.discount else 0 end) AS firecodedisc,(case when (ri.revtype = 'firecode') then (ri.interest - ri.discount) else 0 end) AS firecodedp,(case when (ri.revtype = 'firecode') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS firecodenet,(case when (ri.revtype = 'sh') then ri.amount else 0 end) AS sh,(case when (ri.revtype = 'sh') then ri.interest else 0 end) AS shint,(case when (ri.revtype = 'sh') then ri.discount else 0 end) AS shdisc,(case when (ri.revtype = 'sh') then (ri.interest - ri.discount) else 0 end) AS shdp,(case when (ri.revtype = 'sh') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS shnet,((ri.amount + ri.interest) - ri.discount) AS total from (report_rptdelinquency_item ri join report_rptdelinquency r on((ri.parentid = r.objid)))
go
CREATE VIEW vw_machine_smv AS select ms.objid AS objid,ms.parent_objid AS parent_objid,ms.machine_objid AS machine_objid,ms.expr AS expr,ms.previd AS previd,m.code AS code,m.name AS name from (machine_smv ms join machine m on((ms.machine_objid = m.objid)))
go
CREATE VIEW vw_machinery AS select f.objid AS objid,f.state AS state,f.rpuid AS rpuid,f.realpropertyid AS realpropertyid,f.tdno AS tdno,f.fullpin AS fullpin,f.taxpayer_objid AS taxpayer_objid,f.owner_name AS owner_name,f.owner_address AS owner_address,f.administrator_name AS administrator_name,f.administrator_address AS administrator_address,f.lguid AS lgu_objid,o.name AS lgu_name,b.objid AS barangay_objid,b.name AS barangay_name,r.classification_objid AS classification_objid,pc.name AS classification_name,rp.pin AS pin,rp.section AS section,rp.ry AS ry,rp.cadastrallotno AS cadastrallotno,rp.blockno AS blockno,rp.surveyno AS surveyno,m.objid AS machine_objid,m.name AS machine_name,mu.basemarketvalue AS basemarketvalue,mu.marketvalue AS marketvalue,mu.assessedvalue AS assessedvalue,al.objid AS actualuse_objid,al.name AS actualuse_name,r.totalareaha AS totalareaha,r.totalareasqm AS totalareasqm,r.totalmv AS totalmv,r.totalav AS totalav from (((((((((faas f join rpu r on((f.rpuid = r.objid))) join propertyclassification pc on((r.classification_objid = pc.objid))) join realproperty rp on((f.realpropertyid = rp.objid))) join barangay b on((rp.barangayid = b.objid))) join sys_org o on((f.lguid = o.objid))) join machuse mu on((r.objid = mu.machrpuid))) join machdetail md on((mu.objid = md.machuseid))) join machine m on((md.machine_objid = m.objid))) join machassesslevel al on((mu.actualuse_objid = al.objid)))
go
CREATE VIEW vw_newly_assessed_property AS select f.objid AS objid,f.owner_name AS owner_name,f.tdno AS tdno,b.name AS barangay,(case when (f.rputype = 'land') then 'LAND' when (f.rputype = 'bldg') then 'BUILDING' when (f.rputype = 'mach') then 'MACHINERY' when (f.rputype = 'planttree') then 'PLANT/TREE' else 'MISCELLANEOUS' end) AS rputype,f.totalav AS totalav,f.effectivityyear AS effectivityyear from (faas_list f join barangay b on((f.barangayid = b.objid))) where ((f.state in ('CURRENT','CANCELLED')) and (f.txntype_objid = 'ND'))
go
CREATE VIEW vw_online_rptcertification AS select c.objid AS objid,c.txnno AS txnno,c.txndate AS txndate,c.opener AS opener,c.taxpayer_objid AS taxpayer_objid,c.taxpayer_name AS taxpayer_name,c.taxpayer_address AS taxpayer_address,c.requestedby AS requestedby,c.requestedbyaddress AS requestedbyaddress,c.certifiedby AS certifiedby,c.certifiedbytitle AS certifiedbytitle,c.official AS official,c.purpose AS purpose,c.orno AS orno,c.ordate AS ordate,c.oramount AS oramount,c.taskid AS taskid,t.state AS task_state,t.startdate AS task_startdate,t.enddate AS task_enddate,t.assignee_objid AS task_assignee_objid,t.assignee_name AS task_assignee_name,t.actor_objid AS task_actor_objid,t.actor_name AS task_actor_name from (rptcertification c join rptcertification_task t on((c.taskid = t.objid)))
go
CREATE VIEW vw_real_property_payment AS 
select 
  cv.controldate AS cv_controldate,
  rem.controldate AS rem_controldate,
  rl.owner_name AS owner_name,
  rl.tdno AS tdno,
  pc.name AS classification,
  (case when (rl.rputype = 'land') then 'LAND' when (rl.rputype = 'bldg') then 'BUILDING' when (rl.rputype = 'mach') then 'MACHINERY' when (rl.rputype = 'planttree') then 'PLANT/TREE' else 'MISCELLANEOUS' end) AS rputype,
  b.name AS barangay,
  rpi.year AS year,
  rpi.qtr AS qtr,
  ((rpi.amount + rpi.interest) - rpi.discount) AS amount,
  (case when v.objid is null  then 0 else 1 end) AS voided 
  from ((((((((collectionvoucher cv join remittance rem on((cv.objid = rem.collectionvoucherid))) join cashreceipt cr on((rem.objid = cr.remittanceid))) join rptpayment rp on((cr.objid = rp.receiptid))) join rptpayment_item rpi on((rp.objid = rpi.parentid))) join rptledger rl on((rp.refid = rl.objid))) join barangay b on((rl.barangayid = b.objid))) join propertyclassification pc on((rl.classification_objid = pc.objid))) left join cashreceipt_void v on((cr.objid = v.receiptid)))
go
CREATE VIEW vw_report_orc AS select f.objid AS objid,f.state AS state,e.objid AS taxpayerid,e.name AS taxpayer_name,e.address_text AS taxpayer_address,o.name AS lgu_name,o.code AS lgu_indexno,f.dtapproved AS dtapproved,r.rputype AS rputype,pc.code AS classcode,pc.name AS classification,f.fullpin AS pin,f.titleno AS titleno,rp.cadastrallotno AS cadastrallotno,f.tdno AS tdno,'' AS arpno,f.prevowner AS prevowner,b.name AS location,r.totalareaha AS totalareaha,r.totalareasqm AS totalareasqm,r.totalmv AS totalmv,r.totalav AS totalav,(case when (f.state = 'CURRENT') then '' else 'CANCELLED' end) AS remarks from ((((((faas f join rpu r on((f.rpuid = r.objid))) join realproperty rp on((f.realpropertyid = rp.objid))) join propertyclassification pc on((r.classification_objid = pc.objid))) join entity e on((f.taxpayer_objid = e.objid))) join sys_org o on((rp.lguid = o.objid))) join barangay b on((rp.barangayid = b.objid))) where (f.state in ('CURRENT','CANCELLED'))
go
CREATE VIEW vw_rptcertification_item AS select rci.rptcertificationid AS rptcertificationid,f.objid AS faasid,f.fullpin AS fullpin,f.tdno AS tdno,e.objid AS taxpayerid,e.name AS taxpayer_name,f.owner_name AS owner_name,f.administrator_name AS administrator_name,f.titleno AS titleno,f.rpuid AS rpuid,pc.code AS classcode,pc.name AS classname,so.name AS lguname,b.name AS barangay,r.rputype AS rputype,r.suffix AS suffix,r.totalareaha AS totalareaha,r.totalareasqm AS totalareasqm,r.totalav AS totalav,r.totalmv AS totalmv,rp.street AS street,rp.blockno AS blockno,rp.cadastrallotno AS cadastrallotno,rp.surveyno AS surveyno,r.taxable AS taxable,f.effectivityyear AS effectivityyear,f.effectivityqtr AS effectivityqtr from (((((((rptcertificationitem rci join faas f on((rci.refid = f.objid))) join rpu r on((f.rpuid = r.objid))) join propertyclassification pc on((r.classification_objid = pc.objid))) join realproperty rp on((f.realpropertyid = rp.objid))) join barangay b on((rp.barangayid = b.objid))) join sys_org so on((f.lguid = so.objid))) join entity e on((f.taxpayer_objid = e.objid)))
go
CREATE VIEW vw_rptledger_avdifference AS select rlf.objid AS objid,'APPROVED' AS state,d.parent_objid AS rptledgerid,rl.faasid AS faasid,rl.tdno AS tdno,rlf.txntype_objid AS txntype_objid,rlf.classification_objid AS classification_objid,rlf.actualuse_objid AS actualuse_objid,rlf.taxable AS taxable,rlf.backtax AS backtax,d.year AS fromyear,1 AS fromqtr,d.year AS toyear,4 AS toqtr,d.av AS assessedvalue,1 AS systemcreated,rlf.reclassed AS reclassed,rlf.idleland AS idleland,1 AS taxdifference from ((rptledger_avdifference d join rptledgerfaas rlf on((d.rptledgerfaas_objid = rlf.objid))) join rptledger rl on((d.parent_objid = rl.objid)))
go
CREATE VIEW vw_rptledger_cancelled_faas AS select rl.objid AS objid,rl.state AS state,rl.faasid AS faasid,rl.lastyearpaid AS lastyearpaid,rl.lastqtrpaid AS lastqtrpaid,rl.barangayid AS barangayid,rl.taxpayer_objid AS taxpayer_objid,rl.fullpin AS fullpin,rl.tdno AS tdno,rl.cadastrallotno AS cadastrallotno,rl.rputype AS rputype,rl.txntype_objid AS txntype_objid,rl.classification_objid AS classification_objid,rl.classcode AS classcode,rl.totalav AS totalav,rl.totalmv AS totalmv,rl.totalareaha AS totalareaha,rl.taxable AS taxable,rl.owner_name AS owner_name,rl.prevtdno AS prevtdno,rl.titleno AS titleno,rl.administrator_name AS administrator_name,rl.blockno AS blockno,rl.lguid AS lguid,rl.beneficiary_objid AS beneficiary_objid,pc.name AS classification,b.name AS barangay,o.name AS lgu from (((((rptledger rl join faas f on((rl.faasid = f.objid))) left join barangay b on((rl.barangayid = b.objid))) left join sys_org o on((rl.lguid = o.objid))) left join propertyclassification pc on((rl.classification_objid = pc.objid))) join entity e on((rl.taxpayer_objid = e.objid))) where ((rl.state = 'APPROVED') and (f.state = 'CANCELLED'))
go
CREATE VIEW vw_rptpayment_item_detail AS select rpi.objid AS objid,rpi.parentid AS parentid,rpi.rptledgerfaasid AS rptledgerfaasid,rpi.year AS year,rpi.qtr AS qtr,rpi.revperiod AS revperiod,(case when (rpi.revtype = 'basic') then rpi.amount else 0 end) AS basic,(case when (rpi.revtype = 'basic') then rpi.interest else 0 end) AS basicint,(case when (rpi.revtype = 'basic') then rpi.discount else 0 end) AS basicdisc,(case when (rpi.revtype = 'basic') then (rpi.interest - rpi.discount) else 0 end) AS basicdp,(case when (rpi.revtype = 'basic') then ((rpi.amount + rpi.interest) - rpi.discount) else 0 end) AS basicnet,(case when (rpi.revtype = 'basicidle') then ((rpi.amount + rpi.interest) - rpi.discount) else 0 end) AS basicidle,(case when (rpi.revtype = 'basicidle') then rpi.interest else 0 end) AS basicidleint,(case when (rpi.revtype = 'basicidle') then rpi.discount else 0 end) AS basicidledisc,(case when (rpi.revtype = 'basicidle') then (rpi.interest - rpi.discount) else 0 end) AS basicidledp,(case when (rpi.revtype = 'sef') then rpi.amount else 0 end) AS sef,(case when (rpi.revtype = 'sef') then rpi.interest else 0 end) AS sefint,(case when (rpi.revtype = 'sef') then rpi.discount else 0 end) AS sefdisc,(case when (rpi.revtype = 'sef') then (rpi.interest - rpi.discount) else 0 end) AS sefdp,(case when (rpi.revtype = 'sef') then ((rpi.amount + rpi.interest) - rpi.discount) else 0 end) AS sefnet,(case when (rpi.revtype = 'firecode') then ((rpi.amount + rpi.interest) - rpi.discount) else 0 end) AS firecode,(case when (rpi.revtype = 'sh') then ((rpi.amount + rpi.interest) - rpi.discount) else 0 end) AS sh,(case when (rpi.revtype = 'sh') then rpi.interest else 0 end) AS shint,(case when (rpi.revtype = 'sh') then rpi.discount else 0 end) AS shdisc,(case when (rpi.revtype = 'sh') then (rpi.interest - rpi.discount) else 0 end) AS shdp,(case when (rpi.revtype = 'sh') then ((rpi.amount + rpi.interest) - rpi.discount) else 0 end) AS shnet,((rpi.amount + rpi.interest) - rpi.discount) AS amount,rpi.partialled AS partialled from rptpayment_item rpi
go
CREATE VIEW vw_rpu_assessment AS select r.objid AS objid,r.rputype AS rputype,dpc.objid AS dominantclass_objid,dpc.code AS dominantclass_code,dpc.name AS dominantclass_name,dpc.orderno AS dominantclass_orderno,ra.areasqm AS areasqm,ra.areaha AS areaha,ra.marketvalue AS marketvalue,ra.assesslevel AS assesslevel,ra.assessedvalue AS assessedvalue,ra.taxable AS taxable,au.code AS actualuse_code,au.name AS actualuse_name,auc.objid AS actualuse_objid,auc.code AS actualuse_classcode,auc.name AS actualuse_classname,auc.orderno AS actualuse_orderno from ((((rpu r join propertyclassification dpc on((r.classification_objid = dpc.objid))) join rpu_assessment ra on((r.objid = ra.rpuid))) join landassesslevel au on((ra.actualuse_objid = au.objid))) left join propertyclassification auc on((au.classification_objid = auc.objid))) union select r.objid AS objid,r.rputype AS rputype,dpc.objid AS dominantclass_objid,dpc.code AS dominantclass_code,dpc.name AS dominantclass_name,dpc.orderno AS dominantclass_orderno,ra.areasqm AS areasqm,ra.areaha AS areaha,ra.marketvalue AS marketvalue,ra.assesslevel AS assesslevel,ra.assessedvalue AS assessedvalue,ra.taxable AS taxable,au.code AS actualuse_code,au.name AS actualuse_name,auc.objid AS actualuse_objid,auc.code AS actualuse_classcode,auc.name AS actualuse_classname,auc.orderno AS actualuse_orderno from ((((rpu r join propertyclassification dpc on((r.classification_objid = dpc.objid))) join rpu_assessment ra on((r.objid = ra.rpuid))) join bldgassesslevel au on((ra.actualuse_objid = au.objid))) left join propertyclassification auc on((au.classification_objid = auc.objid))) union select r.objid AS objid,r.rputype AS rputype,dpc.objid AS dominantclass_objid,dpc.code AS dominantclass_code,dpc.name AS dominantclass_name,dpc.orderno AS dominantclass_orderno,ra.areasqm AS areasqm,ra.areaha AS areaha,ra.marketvalue AS marketvalue,ra.assesslevel AS assesslevel,ra.assessedvalue AS assessedvalue,ra.taxable AS taxable,au.code AS actualuse_code,au.name AS actualuse_name,auc.objid AS actualuse_objid,auc.code AS actualuse_classcode,auc.name AS actualuse_classname,auc.orderno AS actualuse_orderno from ((((rpu r join propertyclassification dpc on((r.classification_objid = dpc.objid))) join rpu_assessment ra on((r.objid = ra.rpuid))) join machassesslevel au on((ra.actualuse_objid = au.objid))) left join propertyclassification auc on((au.classification_objid = auc.objid))) union select r.objid AS objid,r.rputype AS rputype,dpc.objid AS dominantclass_objid,dpc.code AS dominantclass_code,dpc.name AS dominantclass_name,dpc.orderno AS dominantclass_orderno,ra.areasqm AS areasqm,ra.areaha AS areaha,ra.marketvalue AS marketvalue,ra.assesslevel AS assesslevel,ra.assessedvalue AS assessedvalue,ra.taxable AS taxable,au.code AS actualuse_code,au.name AS actualuse_name,auc.objid AS actualuse_objid,auc.code AS actualuse_classcode,auc.name AS actualuse_classname,auc.orderno AS actualuse_orderno from ((((rpu r join propertyclassification dpc on((r.classification_objid = dpc.objid))) join rpu_assessment ra on((r.objid = ra.rpuid))) join planttreeassesslevel au on((ra.actualuse_objid = au.objid))) left join propertyclassification auc on((au.classification_objid = auc.objid))) union select r.objid AS objid,r.rputype AS rputype,dpc.objid AS dominantclass_objid,dpc.code AS dominantclass_code,dpc.name AS dominantclass_name,dpc.orderno AS dominantclass_orderno,ra.areasqm AS areasqm,ra.areaha AS areaha,ra.marketvalue AS marketvalue,ra.assesslevel AS assesslevel,ra.assessedvalue AS assessedvalue,ra.taxable AS taxable,au.code AS actualuse_code,au.name AS actualuse_name,auc.objid AS actualuse_objid,auc.code AS actualuse_classcode,auc.name AS actualuse_classname,auc.orderno AS actualuse_orderno from ((((rpu r join propertyclassification dpc on((r.classification_objid = dpc.objid))) join rpu_assessment ra on((r.objid = ra.rpuid))) join miscassesslevel au on((ra.actualuse_objid = au.objid))) left join propertyclassification auc on((au.classification_objid = auc.objid)))
go
CREATE VIEW vw_txn_log AS select distinct u.objid AS userid,u.name AS username,t.txndate AS txndate,t.ref AS ref,t.action AS action,1 AS cnt from (txnlog t join sys_user u on((t.userid = u.objid))) union select u.objid AS userid,u.name AS username,t.enddate AS txndate,'faas' AS ref,(case when (t.state like '%receiver%') then 'receive' when (t.state like '%examiner%') then 'examine' when (t.state like '%taxmapper_chief%') then 'approve taxmap' when (t.state like '%taxmapper%') then 'taxmap' when (t.state like '%appraiser%') then 'appraise' when (t.state like '%appraiser_chief%') then 'approve appraisal' when (t.state like '%recommender%') then 'recommend' when (t.state like '%approver%') then 'approve' else t.state end) AS action,1 AS cnt from (faas_task t join sys_user u on((t.actor_objid = u.objid))) where (not((t.state like '%assign%'))) union select u.objid AS userid,u.name AS username,t.enddate AS txndate,'subdivision' AS ref,(case when (t.state like '%receiver%') then 'receive' when (t.state like '%examiner%') then 'examine' when (t.state like '%taxmapper_chief%') then 'approve taxmap' when (t.state like '%taxmapper%') then 'taxmap' when (t.state like '%appraiser%') then 'appraise' when (t.state like '%appraiser_chief%') then 'approve appraisal' when (t.state like '%recommender%') then 'recommend' when (t.state like '%approver%') then 'approve' else t.state end) AS action,1 AS cnt from (subdivision_task t join sys_user u on((t.actor_objid = u.objid))) where (not((t.state like '%assign%'))) union select u.objid AS userid,u.name AS username,t.enddate AS txndate,'consolidation' AS ref,(case when (t.state like '%receiver%') then 'receive' when (t.state like '%examiner%') then 'examine' when (t.state like '%taxmapper_chief%') then 'approve taxmap' when (t.state like '%taxmapper%') then 'taxmap' when (t.state like '%appraiser%') then 'appraise' when (t.state like '%appraiser_chief%') then 'approve appraisal' when (t.state like '%recommender%') then 'recommend' when (t.state like '%approver%') then 'approve' else t.state end) AS action,1 AS cnt from (subdivision_task t join sys_user u on((t.actor_objid = u.objid))) where (not((t.state like '%consolidation%'))) union select u.objid AS userid,u.name AS username,t.enddate AS txndate,'cancelledfaas' AS ref,(case when (t.state like '%receiver%') then 'receive' when (t.state like '%examiner%') then 'examine' when (t.state like '%taxmapper_chief%') then 'approve taxmap' when (t.state like '%taxmapper%') then 'taxmap' when (t.state like '%appraiser%') then 'appraise' when (t.state like '%appraiser_chief%') then 'approve appraisal' when (t.state like '%recommender%') then 'recommend' when (t.state like '%approver%') then 'approve' else t.state end) AS action,1 AS cnt from (subdivision_task t join sys_user u on((t.actor_objid = u.objid))) where (not((t.state like '%cancelledfaas%')))
GO


