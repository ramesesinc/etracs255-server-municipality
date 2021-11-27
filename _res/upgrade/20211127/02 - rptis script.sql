

create view vw_faas_lookup
as 
SELECT 
f.*,
e.name as taxpayer_name, 
e.address_text as taxpayer_address,
pc.code AS classification_code, 
pc.code AS classcode, 
pc.name AS classification_name, 
pc.name AS classname, 
r.ry, r.rputype, r.totalmv, r.totalav,
r.totalareasqm, r.totalareaha, r.suffix, r.rpumasterid, 
rp.barangayid, rp.cadastrallotno, rp.blockno, rp.surveyno, rp.pintype, 
rp.section, rp.parcel, rp.stewardshipno, rp.pin, 
b.name AS barangay_name 
FROM faas f 
INNER JOIN faas_list fl on f.objid = fl.objid 
INNER JOIN rpu r ON f.rpuid = r.objid 
INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
INNER JOIN barangay b ON rp.barangayid = b.objid 
INNER JOIN entity e on f.taxpayer_objid = e.objid
go 

drop  view vw_rptpayment_item_detail
go 

create view vw_rptpayment_item_detail
as 
select
  rpi.objid,
  rpi.parentid,
  rp.refid as rptledgerid, 
  rpi.rptledgerfaasid,
  rpi.year,
  rpi.qtr,
  rpi.revperiod, 
  case when rpi.revtype = 'basic' then rpi.amount else 0 end as basic,
  case when rpi.revtype = 'basic' then rpi.interest else 0 end as basicint,
  case when rpi.revtype = 'basic' then rpi.discount else 0 end as basicdisc,
  case when rpi.revtype = 'basic' then rpi.interest - rpi.discount else 0 end as basicdp,
  case when rpi.revtype = 'basic' then rpi.amount + rpi.interest - rpi.discount else 0 end as basicnet,
  case when rpi.revtype = 'basicidle' then rpi.amount + rpi.interest - rpi.discount else 0 end as basicidle,
  case when rpi.revtype = 'basicidle' then rpi.interest else 0 end as basicidleint,
  case when rpi.revtype = 'basicidle' then rpi.discount else 0 end as basicidledisc,
  case when rpi.revtype = 'basicidle' then rpi.interest - rpi.discount else 0 end as basicidledp,
  case when rpi.revtype = 'sef' then rpi.amount else 0 end as sef,
  case when rpi.revtype = 'sef' then rpi.interest else 0 end as sefint,
  case when rpi.revtype = 'sef' then rpi.discount else 0 end as sefdisc,
  case when rpi.revtype = 'sef' then rpi.interest - rpi.discount else 0 end as sefdp,
  case when rpi.revtype = 'sef' then rpi.amount + rpi.interest - rpi.discount else 0 end as sefnet,
  case when rpi.revtype = 'firecode' then rpi.amount + rpi.interest - rpi.discount else 0 end as firecode,
  case when rpi.revtype = 'sh' then rpi.amount + rpi.interest - rpi.discount else 0 end as sh,
  case when rpi.revtype = 'sh' then rpi.interest else 0 end as shint,
  case when rpi.revtype = 'sh' then rpi.discount else 0 end as shdisc,
  case when rpi.revtype = 'sh' then rpi.interest - rpi.discount else 0 end as shdp,
  rpi.amount + rpi.interest - rpi.discount as amount,
  rpi.partialled as partialled,
  rp.voided 
from rptpayment_item rpi
inner join rptpayment rp on rpi.parentid = rp.objid

go 

drop view vw_rptpayment_item 
go 

create view vw_rptpayment_item 
as 
select 
    x.rptledgerid, 
    x.parentid,
    x.rptledgerfaasid,
    x.year,
    x.qtr,
    x.revperiod,
    sum(x.basic) as basic,
    sum(x.basicint) as basicint,
    sum(x.basicdisc) as basicdisc,
    sum(x.basicdp) as basicdp,
    sum(x.basicnet) as basicnet,
    sum(x.basicidle) as basicidle,
    sum(x.basicidleint) as basicidleint,
    sum(x.basicidledisc) as basicidledisc,
    sum(x.basicidledp) as basicidledp,
    sum(x.sef) as sef,
    sum(x.sefint) as sefint,
    sum(x.sefdisc) as sefdisc,
    sum(x.sefdp) as sefdp,
    sum(x.sefnet) as sefnet,
    sum(x.firecode) as firecode,
    sum(x.sh) as sh,
    sum(x.shint) as shint,
    sum(x.shdisc) as shdisc,
    sum(x.shdp) as shdp,
    sum(x.amount) as amount,
    max(x.partialled) as partialled,
    x.voided 
from vw_rptpayment_item_detail x
group by 
  x.rptledgerid, 
    x.parentid,
    x.rptledgerfaasid,
    x.year,
    x.qtr,
    x.revperiod,
    x.voided

go     




drop index faas.ix_canceldate 
go 

alter table faas drop constraint DF__faas__canceldate__2F2FFC0C
go 

alter table faas alter column canceldate date 
go 

create index ix_faas_canceldate on faas(canceldate)
go 


alter table machdetail alter column depreciation decimal(16,6)
go


/* 255-03001 */

-- create tables: resection and resection_item

if exists(select * from sysobjects where id = object_id('resectionaffectedrpu'))
begin 
	drop table resectionaffectedrpu
end 
go 


if exists(select * from sysobjects where id = object_id('resectionitem'))
begin 
	drop table resectionitem
end 
go 


if exists(select * from sysobjects where id = object_id('resection'))
begin 
	drop table resection
end 
go 


CREATE TABLE resection (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  txnno varchar(25) NOT NULL,
  txndate datetime NOT NULL,
  lgu_objid varchar(50) NOT NULL,
  barangay_objid varchar(50) NOT NULL,
  pintype varchar(3) NOT NULL,
  section varchar(3) NOT NULL,
  originlgu_objid varchar(50) NOT NULL,
  memoranda varchar(255) DEFAULT NULL,
  taskid varchar(50) DEFAULT NULL,
  taskstate varchar(50) DEFAULT NULL,
  assignee_objid varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 



create UNIQUE index ux_resection_txnno on resection(txnno)
go 

create index FK_resection_lgu_org on resection(lgu_objid)
go 
create index FK_resection_barangay_org on resection(barangay_objid)
go 
create index FK_resection_originlgu_org on resection(originlgu_objid)
go 
create index ix_resection_state on resection(state)
go 


  alter table resection 
    add CONSTRAINT FK_resection_barangay_org FOREIGN KEY (barangay_objid) 
    REFERENCES sys_org (objid)
go     
  alter table resection 
    add CONSTRAINT FK_resection_lgu_org FOREIGN KEY (lgu_objid) 
    REFERENCES sys_org (objid)
go     
  alter table resection 
    add CONSTRAINT FK_resection_originlgu_org FOREIGN KEY (originlgu_objid) 
    REFERENCES sys_org (objid)
go     




CREATE TABLE resection_item (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  faas_objid varchar(50) NOT NULL,
  faas_rputype varchar(15) NOT NULL,
  faas_pin varchar(25) NOT NULL,
  faas_suffix int NOT NULL,
  newfaas_objid varchar(50) DEFAULT NULL,
  newfaas_rpuid varchar(50) DEFAULT NULL,
  newfaas_rpid varchar(50) DEFAULT NULL,
  newfaas_section varchar(3) DEFAULT NULL,
  newfaas_parcel varchar(3) DEFAULT NULL,
  newfaas_suffix int DEFAULT NULL,
  newfaas_tdno varchar(25) DEFAULT NULL,
  newfaas_fullpin varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 

create UNIQUE index ux_resection_item_tdno on resection_item (newfaas_tdno)
go 

create index FK_resection_item_item on resection_item(parent_objid)
go   
create index FK_resection_item_faas on resection_item(faas_objid)
go   
create index FK_resection_item_newfaas on resection_item(newfaas_objid)
go   
create index ix_resection_item_fullpin on resection_item(newfaas_fullpin)
go   


alter table resection_item add CONSTRAINT FK_resection_item_faas FOREIGN KEY (faas_objid) 
  REFERENCES faas (objid)
go   
alter table resection_item add CONSTRAINT FK_resection_item_item FOREIGN KEY (parent_objid) 
  REFERENCES resection (objid)
go   
alter table resection_item add CONSTRAINT FK_resection_item_newfaas FOREIGN KEY (newfaas_objid) 
  REFERENCES faas (objid)
go     



CREATE TABLE resection_task (
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
  PRIMARY KEY (objid)
)
go 


create index  ix_assignee_objid on resection_task (assignee_objid)
go 
create index  ix_refid on resection_task (refid)
go 


delete from sys_wf_transition where processname ='resection'
go
delete from sys_wf_node where processname ='resection';

INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('appraiser', 'resection', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('appraiser_chief', 'resection', 'Appraisal Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('approver', 'resection', 'Province Approval', 'state', '90', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('assign-appraisal-chief', 'resection', 'For Appraisal Approval', 'state', '50', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('assign-appraiser', 'resection', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('assign-examiner', 'resection', 'For Examination', 'state', '10', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('assign-recommender', 'resection', 'For Recommending Approval', 'state', '70', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('assign-taxmapper', 'resection', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('assign-taxmapping-approval', 'resection', 'For Taxmapping Approval', 'state', '30', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('end', 'resection', 'End', 'end', '1000', NULL, 'RPT', NULL, NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('examiner', 'resection', 'Examination', 'state', '15', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('forapproval', 'resection', 'For Province Approval', 'state', '85', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('forprovapproval', 'resection', 'For Province Approval', 'state', '81', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('forprovsubmission', 'resection', 'For Province Submission', 'state', '80', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('provapprover', 'resection', 'Approved By Province', 'state', '96', NULL, 'RPT', 'APPROVER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('receiver', 'resection', 'Review and Verification', 'state', '5', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('recommender', 'resection', 'Recommending Approval', 'state', '75', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('start', 'resection', 'Start', 'start', '1', NULL, 'RPT', NULL, NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('taxmapper', 'resection', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL)
go
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [ui], [properties], [tracktime]) VALUES ('taxmapper_chief', 'resection', 'Taxmapping Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL)
go


INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('appraiser', 'resection', 'returnexaminer', 'examiner', '46', NULL, '[caption:''Return to Examiner'', confirm:''Return to examiner?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('appraiser', 'resection', 'returntaxmapper', 'taxmapper', '45', NULL, '[caption:''Return to Taxmapper'', confirm:''Return to taxmapper?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('appraiser', 'resection', 'submit', 'assign-recommender', '47', NULL, '[caption:''Submit for Recommending Approval'', confirm:''Submit?'', messagehandler:''rptmessage:create'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('approver', 'resection', '', 'processing-approval', '90', NULL, '[caption:''Manually Approve'', confirm:''Approve?'', messagehandler:''rptmessage:approval'']', '', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-appraiser', 'resection', '', 'appraiser', '40', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-examiner', 'resection', '', 'examiner', '10', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-recommender', 'resection', '', 'recommender', '70', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-taxmapper', 'resection', '', 'taxmapper', '20', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('examiner', 'resection', 'returnreceiver', 'receiver', '15', NULL, '[caption:''Return to Receiver'', confirm:''Return to receiver?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('examiner', 'resection', 'submit', 'assign-taxmapper', '16', NULL, '[caption:''Submit for Taxmapping'', confirm:''Submit?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('forprovsubmission', 'resection', 'completed', 'approver', '81', NULL, '[caption:''Completed'', visible:false]', '', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('forprovsubmission', 'resection', 'returnapprover', 'recommender', '80', NULL, '[caption:''Cancel Posting'', confirm:''Cancel posting record?'']', '', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provapprover', 'resection', 'backforprovapproval', 'approver', '95', '#{data != null && data.state != ''APROVED''}', '[caption:''Cancel Posting'', confirm:''Cancel posting record?'', visibleWhen=\"#{entity.state != ''APPROVED''}\"]', '', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provapprover', 'resection', 'completed', 'end', '100', NULL, '[caption:''Approved'', visible:false]', '', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('receiver', 'resection', 'delete', 'end', '6', NULL, '[caption:''Delete'', confirm:''Delete?'', closeonend:true]', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('receiver', 'resection', 'submit', 'assign-examiner', '5', NULL, '[caption:''Submit For Examination'', confirm:''Submit?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('recommender', 'resection', 'returnappraiser', 'appraiser', '77', NULL, '[caption:''Return to Appraiser'', confirm:''Return to appraiser?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('recommender', 'resection', 'returnexaminer', 'examiner', '75', NULL, '[caption:''Return to Examiner'', confirm:''Return to examiner?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('recommender', 'resection', 'returntaxmapper', 'taxmapper', '76', NULL, '[caption:''Return to Taxmapper'', confirm:''Return to taxmapper?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('recommender', 'resection', 'submit', 'forprovsubmission', '78', NULL, '[caption:''Submit to Province'', confirm:''Submit to Province?'', messagehandler:''rptmessage:create'']', '', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('start', 'resection', '', 'receiver', '1', NULL, NULL, NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('taxmapper', 'resection', 'returnexaminer', 'examiner', '26', NULL, '[caption:''Return to Examiner'', confirm:''Return to examiner?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('taxmapper', 'resection', 'returnreceiver', 'receiver', '25', NULL, '[caption:''Return to Receiver'', confirm:''Return to receiver?'', messagehandler:''default'']', '', NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('taxmapper', 'resection', 'submit', 'assign-appraiser', '26', NULL, '[caption:''Submit for Appraisal'', confirm:''Submit?'', messagehandler:''rptmessage:create'']', NULL, NULL, NULL)
go


/* 255-03001 */
alter table rptcertification add properties varchar(2000)
go 

	
alter table faas_signatory add reviewer_objid varchar(50)
go 
alter table faas_signatory add reviewer_name varchar(100)
go 
alter table faas_signatory add reviewer_title varchar(75)
go 
alter table faas_signatory add reviewer_dtsigned datetime
go 
alter table faas_signatory add reviewer_taskid varchar(50)
go 
alter table faas_signatory add assessor_name varchar(100)
go 
alter table faas_signatory add assessor_title varchar(100)
go 


alter table cancelledfaas_signatory add reviewer_objid varchar(50)
go 
alter table cancelledfaas_signatory add reviewer_name varchar(100)
go 
alter table cancelledfaas_signatory add reviewer_title varchar(75)
go 
alter table cancelledfaas_signatory add reviewer_dtsigned datetime
go 
alter table cancelledfaas_signatory add reviewer_taskid varchar(50)
go 
alter table cancelledfaas_signatory add assessor_name varchar(100)
go 
alter table cancelledfaas_signatory add assessor_title varchar(100)
go 



    

CREATE TABLE rptacknowledgement (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  txnno varchar(25) NOT NULL,
  txndate datetime DEFAULT NULL,
  taxpayer_objid varchar(50) DEFAULT NULL,
  txntype_objid varchar(50) DEFAULT NULL,
  releasedate datetime DEFAULT NULL,
  releasemode varchar(50) DEFAULT NULL,
  receivedby varchar(255) DEFAULT NULL,
  remarks varchar(255) DEFAULT NULL,
  pin varchar(25) DEFAULT NULL,
  createdby_objid varchar(25) DEFAULT NULL,
  createdby_name varchar(25) DEFAULT NULL,
  createdby_title varchar(25) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create UNIQUE index  ux_rptacknowledgement_txnno on rptacknowledgement(txnno)
go 
create index ix_rptacknowledgement_pin on rptacknowledgement(pin)
go 
create index ix_rptacknowledgement_taxpayerid on rptacknowledgement(taxpayer_objid)
go 


CREATE TABLE rptacknowledgement_item (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  trackingno varchar(25) NULL,
  faas_objid varchar(50) DEFAULT NULL,
  newfaas_objid varchar(50) DEFAULT NULL,
  remarks varchar(255) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 

alter table rptacknowledgement_item 
  add constraint fk_rptacknowledgement_item_rptacknowledgement
  foreign key (parent_objid) references rptacknowledgement(objid)
go 

create index ix_rptacknowledgement_parentid on rptacknowledgement_item(parent_objid)
go 

create unique index ux_rptacknowledgement_itemno on rptacknowledgement_item(trackingno)
go 

create index ix_rptacknowledgement_item_faasid  on rptacknowledgement_item(faas_objid)
go 

create index ix_rptacknowledgement_item_newfaasid on rptacknowledgement_item(newfaas_objid)
go 


    

drop  view vw_faas_lookup
go 

CREATE view vw_faas_lookup AS 
select 
  fl.objid AS objid,
  fl.state AS state,
  fl.rpuid AS rpuid,
  fl.utdno AS utdno,
  fl.tdno AS tdno,
  fl.txntype_objid AS txntype_objid,
  fl.effectivityyear AS effectivityyear,
  fl.effectivityqtr AS effectivityqtr,
  fl.taxpayer_objid AS taxpayer_objid,
  fl.owner_name AS owner_name,
  fl.owner_address AS owner_address,
  fl.prevtdno AS prevtdno,
  fl.cancelreason AS cancelreason,
  fl.cancelledbytdnos AS cancelledbytdnos,
  fl.lguid AS lguid,
  fl.realpropertyid AS realpropertyid,
  fl.displaypin AS fullpin,
  fl.originlguid AS originlguid,
  e.name AS taxpayer_name,
  e.address_text AS taxpayer_address,
  pc.code AS classification_code,
  pc.code AS classcode,
  pc.name AS classification_name,
  pc.name AS classname,
  fl.ry AS ry,
  fl.rputype AS rputype,
  fl.totalmv AS totalmv,
  fl.totalav AS totalav,
  fl.totalareasqm AS totalareasqm,
  fl.totalareaha AS totalareaha,
  fl.barangayid AS barangayid,
  fl.cadastrallotno AS cadastrallotno,
  fl.blockno AS blockno,
  fl.surveyno AS surveyno,
  fl.pin AS pin,
  fl.barangay AS barangay_name,
  fl.trackingno
from faas_list fl
left join propertyclassification pc on fl.classification_objid = pc.objid
left join entity e on fl.taxpayer_objid = e.objid
go 

drop index faas.ix_faas_prevtdno
go
alter table faas alter column prevtdno varchar(800)
go 
create index ix_faas_prevtdno on faas(prevtdno)
go

  
alter table faas_list alter column prevtdno varchar(800)
go 
alter table faas_list alter column owner_name varchar(2000)
go 
alter table faas_list alter column cadastrallotno varchar(500)
go 


create index ix_faaslist_prevtdno on faas_list(prevtdno)
go 
create index ix_faaslist_cadastrallotno on faas_list(cadastrallotno)
go 
create index ix_faaslist_owner_name on faas_list(owner_name)
go 
create index ix_faaslist_txntype_objid on faas_list(txntype_objid)
go 



alter table rptledger alter column prevtdno varchar(800)
go 
create index ix_rptledger_prevtdno on rptledger(prevtdno)
go 
create index ix_rptledgerfaas_tdno on rptledgerfaas(tdno)
go 

  
alter table rptledger alter column owner_name varchar(1500) not null
go 
create index ix_rptledger_owner_name on rptledger(owner_name)
go 



/* SUBLEDGER : add beneficiary info */

alter table rptledger add beneficiary_objid varchar(50)
go
create index ix_beneficiary_objid on rptledger(beneficiary_objid)
go


/* COMPROMISE UPDATE */
alter table rptcompromise_item add qtr int
go


/* 255-03012 */

/*=====================================
* LEDGER TAG
=====================================*/
CREATE TABLE rptledger_tag (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  tag varchar(255) NOT NULL,
  PRIMARY KEY (objid)
)
go 

create UNIQUE index ux_rptledger_tag on rptledger_tag(parent_objid,tag)
go 

create index FK_rptledgertag_rptledger on rptledger_tag(parent_objid)
go 
  
alter table rptledger_tag 
    add CONSTRAINT FK_rptledgertag_rptledger 
    FOREIGN KEY (parent_objid) REFERENCES rptledger (objid)
go     


/* 255-03013 */
alter table resection_item add newfaas_claimno varchar(25)
go
alter table resection_item add faas_claimno varchar(25)
go 


/* 255-03015 */

create table rptcertification_online (
  objid varchar(50) not null,
  state varchar(25) not null,
  reftype varchar(25) not null,
  refid varchar(50) not null,
  refno varchar(50) not null,
  refdate date not null,
  orno varchar(25) default null,
  ordate date default null,
  oramount decimal(16,2) default null,
  primary key (objid)
)
go 

alter table rptcertification_online 
	add constraint fk_rptcertification_online_rptcertification foreign key (objid) references rptcertification (objid)
go 
 
create index ix_state on rptcertification_online(state)
go 
 
create index ix_refid on rptcertification_online(refid)
go 
 
create index ix_refno on rptcertification_online(refno)
go 
 
create index ix_orno on rptcertification_online(orno)
go 
  



CREATE TABLE assessmentnotice_online (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  reftype varchar(25) NOT NULL,
  refid varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  refdate date NOT NULL,
  orno varchar(25) DEFAULT NULL,
  ordate date DEFAULT NULL,
  oramount decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create index ix_state on assessmentnotice_online (state)
go 
create index ix_refid on assessmentnotice_online (refid)
go 
create index ix_refno on assessmentnotice_online (refno)
go 
create index ix_orno on assessmentnotice_online (orno)
go 
  
alter table assessmentnotice_online 
  add CONSTRAINT fk_assessmentnotice_online_assessmentnotice 
  FOREIGN KEY (objid) REFERENCES assessmentnotice (objid)
go   



/*===============================================================
**
** FAAS ANNOTATION
**
===============================================================*/
CREATE TABLE faasannotation_faas (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  faas_objid varchar(50) NOT NULL,
  PRIMARY KEY (objid)
) 
go 


alter table faasannotation_faas 
add constraint fk_faasannotationfaas_faasannotation foreign key(parent_objid)
references faasannotation (objid)
go

alter table faasannotation_faas 
add constraint fk_faasannotationfaas_faas foreign key(faas_objid)
references faas (objid)
go

create index ix_parent_objid on faasannotation_faas(parent_objid)
go

create index ix_faas_objid on faasannotation_faas(faas_objid)
go


create unique index ux_parent_faas on faasannotation_faas(parent_objid, faas_objid)
go

alter table faasannotation alter column faasid varchar(50) null
go



-- insert annotated faas
insert into faasannotation_faas(
  objid, 
  parent_objid,
  faas_objid 
)
select 
  objid, 
  objid as parent_objid,
  faasid as faas_objid 
from faasannotation
go
  


/*============================================
*
*  LEDGER FAAS FACTS
*
=============================================*/
INSERT INTO sys_var ([name], [value], [description], [datatype], [category]) 
VALUES ('rptledger_rule_include_ledger_faases', '0', 'Include Ledger FAASes as rule facts', 'checkbox', 'LANDTAX')
go

INSERT INTO sys_var ([name], [value], [description], [datatype], [category]) 
VALUES ('rptledger_post_ledgerfaas_by_actualuse', '0', 'Post by Ledger FAAS by actual use', 'checkbox', 'LANDTAX')
go 


/* 255-03016 */

/*================================================================
*
* RPTLEDGER REDFLAG
*
================================================================*/

CREATE TABLE rptledger_redflag (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  caseno varchar(25) NULL,
  dtfiled datetime NULL,
  type varchar(25) NOT NULL,
  finding text,
  remarks text,
  blockaction varchar(25) DEFAULT NULL,
  filedby_objid varchar(50) DEFAULT NULL,
  filedby_name varchar(255) DEFAULT NULL,
  filedby_title varchar(50) DEFAULT NULL,
  resolvedby_objid varchar(50) DEFAULT NULL,
  resolvedby_name varchar(255) DEFAULT NULL,
  resolvedby_title varchar(50) DEFAULT NULL,
  dtresolved datetime NULL,
  PRIMARY KEY (objid)
) 
go

create index ix_parent_objid on rptledger_redflag(parent_objid)
go
create index ix_state on rptledger_redflag(state)
go
create unique index ux_caseno on rptledger_redflag(caseno)
go
create index ix_type on rptledger_redflag(type)
go
create index ix_filedby_objid on rptledger_redflag(filedby_objid)
go
create index ix_resolvedby_objid on rptledger_redflag(resolvedby_objid)
go

alter table rptledger_redflag 
add constraint fk_rptledger_redflag_rptledger foreign key (parent_objid)
references rptledger(objid)
go

alter table rptledger_redflag 
add constraint fk_rptledger_redflag_filedby foreign key (filedby_objid)
references sys_user(objid)
go

alter table rptledger_redflag 
add constraint fk_rptledger_redflag_resolvedby foreign key (resolvedby_objid)
references sys_user(objid)
go




/*==================================================
* RETURNED TASK 
==================================================*/
alter table faas_task add returnedby varchar(100)
go 
alter table subdivision_task add returnedby varchar(100)
go 
alter table consolidation_task add returnedby varchar(100)
go 
alter table cancelledfaas_task add returnedby varchar(100)
go 
alter table resection_task add returnedby varchar(100)
go 


/* 255-03016 */

/*================================================================
*
* LANDTAX SHARE POSTING
*
================================================================*/
alter table rptpayment_share add iscommon int
go 

alter table rptpayment_share add year int
go 

update rptpayment_share set iscommon = 0 where iscommon is null 
go 




CREATE TABLE cashreceipt_rpt_share_forposting (
  objid varchar(50) NOT NULL,
  receiptid varchar(50) NOT NULL,
  rptledgerid varchar(50) NOT NULL,
  txndate datetime,
  error int NOT NULL,
  msg text,
  PRIMARY KEY (objid)
) 
go 


create UNIQUE index ux_receiptid_rptledgerid on cashreceipt_rpt_share_forposting (receiptid,rptledgerid)
go 
create index fk_cashreceipt_rpt_share_forposing_rptledger on cashreceipt_rpt_share_forposting (rptledgerid)
go 
create index fk_cashreceipt_rpt_share_forposing_cashreceipt on cashreceipt_rpt_share_forposting (receiptid)
go 

alter table cashreceipt_rpt_share_forposting add CONSTRAINT fk_cashreceipt_rpt_share_forposing_rptledger 
FOREIGN KEY (rptledgerid) REFERENCES rptledger (objid)
go 
alter table cashreceipt_rpt_share_forposting add CONSTRAINT fk_cashreceipt_rpt_share_forposing_cashreceipt 
FOREIGN KEY (receiptid) REFERENCES cashreceipt (objid)
go 




/*==================================================
**
** BLDG DATE CONSTRUCTED SUPPORT 
**
===================================================*/

alter table bldgrpu add dtconstructed date
go 

delete from sys_wf_transition where processname = 'batchgr'
go
delete from sys_wf_node where processname = 'batchgr'
go

INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('start', 'batchgr', 'Start', 'start', '1', NULL, 'RPT', 'START', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-receiver', 'batchgr', 'For Review and Verification', 'state', '2', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('receiver', 'batchgr', 'Review and Verification', 'state', '5', NULL, 'RPT', 'RECEIVER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-examiner', 'batchgr', 'For Examination', 'state', '10', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('examiner', 'batchgr', 'Examination', 'state', '15', NULL, 'RPT', 'EXAMINER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-taxmapper', 'batchgr', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-provtaxmapper', 'batchgr', 'For Taxmapping', 'state', '20', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('taxmapper', 'batchgr', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('provtaxmapper', 'batchgr', 'Taxmapping', 'state', '25', NULL, 'RPT', 'TAXMAPPER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-taxmapping-approval', 'batchgr', 'For Taxmapping Approval', 'state', '30', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('taxmapper_chief', 'batchgr', 'Taxmapping Approval', 'state', '35', NULL, 'RPT', 'TAXMAPPER_CHIEF', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-appraiser', 'batchgr', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-provappraiser', 'batchgr', 'For Appraisal', 'state', '40', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('appraiser', 'batchgr', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('provappraiser', 'batchgr', 'Appraisal', 'state', '45', NULL, 'RPT', 'APPRAISER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-appraisal-chief', 'batchgr', 'For Appraisal Approval', 'state', '50', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('appraiser_chief', 'batchgr', 'Appraisal Approval', 'state', '55', NULL, 'RPT', 'APPRAISAL_CHIEF', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-recommender', 'batchgr', 'For Recommending Approval', 'state', '70', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('recommender', 'batchgr', 'Recommending Approval', 'state', '75', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('forprovsubmission', 'batchgr', 'For Province Submission', 'state', '80', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('forprovapproval', 'batchgr', 'For Province Approval', 'state', '81', NULL, 'RPT', 'RECOMMENDER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('forapproval', 'batchgr', 'Provincial Assessor Approval', 'state', '85', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('assign-approver', 'batchgr', 'For Provincial Assessor Approval', 'state', '90', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('approver', 'batchgr', 'Provincial Assessor Approval', 'state', '95', NULL, 'RPT', 'APPROVER,ASSESSOR', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('provapprover', 'batchgr', 'Approved By Province', 'state', '96', NULL, 'RPT', 'APPROVER', NULL, NULL, NULL)
go 
INSERT INTO sys_wf_node ([name], [processname], [title], [nodetype], [idx], [salience], [domain], [role], [properties], [ui], [tracktime]) VALUES ('end', 'batchgr', 'End', 'end', '1000', NULL, 'RPT', NULL, NULL, NULL, NULL)
go 

INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('start', 'batchgr', '', 'assign-receiver', '1', NULL, NULL, NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-receiver', 'batchgr', '', 'receiver', '2', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('receiver', 'batchgr', 'submit', 'assign-provtaxmapper', '5', NULL, '[caption:''Submit For Taxmapping'', confirm:''Submit?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-examiner', 'batchgr', '', 'examiner', '10', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('examiner', 'batchgr', 'returnreceiver', 'receiver', '15', NULL, '[caption:''Return to Receiver'', confirm:''Return to receiver?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('examiner', 'batchgr', 'submit', 'assign-provtaxmapper', '16', NULL, '[caption:''Submit for Approval'', confirm:''Submit?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-provtaxmapper', 'batchgr', '', 'provtaxmapper', '20', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provtaxmapper', 'batchgr', 'returnexaminer', 'examiner', '25', NULL, '[caption:''Return to Examiner'', confirm:''Return to examiner?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provtaxmapper', 'batchgr', 'submit', 'assign-provappraiser', '26', NULL, '[caption:''Submit for Approval'', confirm:''Submit?'', messagehandler:''rptmessage:sign'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-provappraiser', 'batchgr', '', 'provappraiser', '40', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provappraiser', 'batchgr', 'returntaxmapper', 'provtaxmapper', '45', NULL, '[caption:''Return to Taxmapper'', confirm:''Return to taxmapper?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provappraiser', 'batchgr', 'returnexaminer', 'examiner', '46', NULL, '[caption:''Return to Examiner'', confirm:''Return to examiner?'', messagehandler:''default'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provappraiser', 'batchgr', 'submit', 'assign-approver', '47', NULL, '[caption:''Submit for Approval'', confirm:''Submit?'', messagehandler:''rptmessage:sign'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('assign-approver', 'batchgr', '', 'approver', '70', NULL, '[caption:''Assign To Me'', confirm:''Assign task to you?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('approver', 'batchgr', 'approve', 'provapprover', '90', NULL, '[caption:''Approve'', confirm:''Approve record?'', messagehandler:''rptmessage:sign'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provapprover', 'batchgr', 'backforprovapproval', 'approver', '95', NULL, '[caption:''Cancel Posting'', confirm:''Cancel posting record?'']', NULL, NULL, NULL)
go
INSERT INTO sys_wf_transition ([parentid], [processname], [action], [to], [idx], [eval], [properties], [permission], [caption], [ui]) VALUES ('provapprover', 'batchgr', 'completed', 'end', '100', NULL, '[caption:''Approved'', visible:false]', NULL, NULL, NULL)
go

/* 255-03018 */

/*==================================================
**
** ONLINE BATCH GR 
**
===================================================*/
select * into zz_tmp_batchgr  from batchgr
go

select * into zz_tmp_batchgr_item  from batchgr_item
go


if exists(select * from sysobjects where id = object_id('vw_batchgr')) 
begin 
	drop view vw_batchgr
end 
go 


if exists(select * from sysobjects where id = object_id('batchgr_log')) 
begin 
	drop table batchgr_log
end 
go 

if exists(select * from sysobjects where id = object_id('batchgr_error')) 
begin 
	drop table batchgr_error
end 
go 

if exists(select * from sysobjects where id = object_id('batchgr_forprocess')) 
begin 
	drop table batchgr_forprocess
end 
go 

if exists(select * from sysobjects where id = object_id('batchgr_task')) 
begin 
	drop table batchgr_task
end 
go 


if exists(select * from sysobjects where id = object_id('batchgr_item')) 
begin 
	drop table batchgr_item
end 
go 


if exists(select * from sysobjects where id = object_id('batchgr')) 
begin 
	drop table batchgr
end 
go 



create table batchgr (
  objid varchar(50) not null,
  state varchar(50) not null,
  ry int not null,
  txntype_objid varchar(5) not null,
  txnno varchar(25) not null,
  txndate datetime not null,
  effectivityyear int not null,
  effectivityqtr int not null,
  memoranda varchar(255) not null,
  originlguid varchar(50) not null,
  lguid varchar(50) not null,
  barangayid varchar(50) not null,
  rputype varchar(15) default null,
  classificationid varchar(50) default null,
  section varchar(10) default null,
  primary key (objid)
)
go 

create index ix_state on batchgr(state)
go
create index ix_ry on batchgr(ry)
go
create index ix_txnno on batchgr(txnno)
go
create index ix_lguid on batchgr(lguid)
go
create index ix_barangayid on batchgr(barangayid)
go
create index ix_classificationid on batchgr(classificationid)
go
create index ix_section on batchgr(section)
go

alter table batchgr 
add constraint fk_batchgr_lguid foreign key(lguid) 
references sys_org(objid)
go

alter table batchgr 
add constraint fk_batchgr_barangayid foreign key(barangayid) 
references sys_org(objid)
go

alter table batchgr 
add constraint fk_batchgr_classificationid foreign key(classificationid) 
references propertyclassification(objid)
go


create table batchgr_item (
  objid varchar(50) not null,
  parent_objid varchar(50) not null,
  state varchar(50) not null,
  rputype varchar(15) not null,
  tdno varchar(50) not null,
  fullpin varchar(50) not null,
  pin varchar(50) not null,
  suffix int not null,
  subsuffix int null,
  newfaasid varchar(50) default null,
  error text,
  primary key (objid)
) 
go

create index ix_parent_objid on batchgr_item(parent_objid)
go
create index ix_tdno on batchgr_item(tdno)
go
create index ix_pin on batchgr_item(pin)
go
create index ix_newfaasid on batchgr_item(newfaasid)
go

alter table batchgr_item 
add constraint fk_batchgr_item_batchgr foreign key(parent_objid) 
references batchgr(objid)
go

alter table batchgr_item 
add constraint fk_batchgr_item_faas foreign key(newfaasid) 
references faas(objid)
go

create table batchgr_task (
  objid varchar(50) not null,
  refid varchar(50) default null,
  parentprocessid varchar(50) default null,
  state varchar(50) default null,
  startdate datetime default null,
  enddate datetime default null,
  assignee_objid varchar(50) default null,
  assignee_name varchar(100) default null,
  assignee_title varchar(80) default null,
  actor_objid varchar(50) default null,
  actor_name varchar(100) default null,
  actor_title varchar(80) default null,
  message varchar(255) default null,
  signature text,
  returnedby varchar(100) default null,
  primary key (objid)
)
go 

create index ix_assignee_objid on batchgr_task(assignee_objid)
go
create index ix_refid on batchgr_task(refid)
go

alter table batchgr_task 
add constraint fk_batchgr_task_batchgr foreign key(refid) 
references batchgr(objid)
go


create view vw_batchgr 
as 
select 
  bg.*,
  l.name as lgu_name,
  b.name as barangay_name,
  pc.name as classification_name,
  t.objid AS taskid,
  t.state AS taskstate,
  t.assignee_objid 
from batchgr bg
inner join sys_org l on bg.lguid = l.objid 
left join sys_org b on bg.barangayid = b.objid
left join propertyclassification pc on bg.classificationid = pc.objid 
left join batchgr_task t on bg.objid = t.refid  and t.enddate is null 
go






/*===========================================
*
*  ENTITY MAPPING (PROVINCE)
*
============================================*/
if exists(select * from sysobjects where id = object_id('entity_mapping')) 
begin 
  drop table entity_mapping
end 
go 

CREATE TABLE entity_mapping (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  org_objid varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go

if exists(select * from sysobjects where id = object_id('vw_entity_mapping')) 
begin 
  drop view vw_entity_mapping
end 
go 

create view vw_entity_mapping
as 
select 
  r.*,
  e.entityno,
  e.name, 
  e.address_text as address_text,
  a.province as address_province,
  a.municipality as address_municipality
from entity_mapping r 
inner join entity e on r.objid = e.objid 
left join entity_address a on e.address_objid = a.objid
left join sys_org b on a.barangay_objid = b.objid 
left join sys_org m on b.parent_objid = m.objid 
go



/*===========================================
*
*  CERTIFICATION UPDATES
*
============================================*/
if exists(select * from sysobjects where id = object_id('vw_rptcertification_item')) 
begin 
  drop view vw_rptcertification_item
end 
go 

create view vw_rptcertification_item
as 
SELECT 
  rci.rptcertificationid,
  f.objid as faasid,
  f.fullpin, 
  f.tdno,
  e.objid as taxpayerid,
  e.name as taxpayer_name, 
  f.owner_name, 
  f.administrator_name,
  f.titleno,  
  f.rpuid, 
  pc.code AS classcode, 
  pc.name AS classname,
  so.name AS lguname,
  b.name AS barangay, 
  r.rputype, 
  r.suffix,
  r.totalareaha AS totalareaha,
  r.totalareasqm AS totalareasqm,
  r.totalav,
  r.totalmv, 
  rp.street,
  rp.blockno,
  rp.cadastrallotno,
  rp.surveyno,
  r.taxable,
  f.effectivityyear,
  f.effectivityqtr
FROM rptcertificationitem rci 
  INNER JOIN faas f ON rci.refid = f.objid 
  INNER JOIN rpu r ON f.rpuid = r.objid 
  INNER JOIN propertyclassification pc ON r.classification_objid = pc.objid 
  INNER JOIN realproperty rp ON f.realpropertyid = rp.objid 
  INNER JOIN barangay b ON rp.barangayid = b.objid 
  INNER JOIN sys_org so on f.lguid = so.objid 
  INNER JOIN entity e on f.taxpayer_objid = e.objid 
go




/*===========================================
*
*  SUBDIVISION ASSISTANCE
*
============================================*/
if exists(select * from sysobjects where id = object_id('subdivision_assist_item')) 
begin 
  drop view subdivision_assist_item
end 
go 

if exists(select * from sysobjects where id = object_id('subdivision_assist')) 
begin 
  drop view subdivision_assist
end 
go 




CREATE TABLE subdivision_assist (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  taskstate varchar(50) NOT NULL,
  assignee_objid varchar(50) NOT NULL,
  PRIMARY KEY (objid)
)
go

alter table subdivision_assist 
add constraint fk_subdivision_assist_subdivision foreign key(parent_objid)
references subdivision(objid)
go

alter table subdivision_assist 
add constraint fk_subdivision_assist_user foreign key(assignee_objid)
references sys_user(objid)
go

create index ix_parent_objid on subdivision_assist(parent_objid)
go

create index ix_assignee_objid on subdivision_assist(assignee_objid)
go

create unique index ux_parent_assignee on subdivision_assist(parent_objid, taskstate, assignee_objid)
go


CREATE TABLE subdivision_assist_item (
  objid varchar(50) NOT NULL,
  subdivision_objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  pintype varchar(10) NOT NULL,
  section varchar(5) NOT NULL,
  startparcel int NOT NULL,
  endparcel int NOT NULL,
  parcelcount int NOT NULL,
  parcelcreated int NULL,
  PRIMARY KEY (objid)
)
go

alter table subdivision_assist_item 
add constraint fk_subdivision_assist_item_subdivision foreign key(subdivision_objid)
references subdivision(objid)
go

alter table subdivision_assist_item 
add constraint fk_subdivision_assist_item_subdivision_assist foreign key(parent_objid)
references subdivision_assist(objid)
go

create index ix_subdivision_objid on subdivision_assist_item(subdivision_objid)
go

create index ix_parent_objid on subdivision_assist_item(parent_objid)
go







/*==================================================
**
** REALTY TAX CREDIT
**
===================================================*/

if exists(select * from sysobjects where id = object_id('rpttaxcredit')) 
begin 
  drop view rpttaxcredit
end 
go 


CREATE TABLE rpttaxcredit (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  type varchar(25) NOT NULL,
  txnno varchar(25) DEFAULT NULL,
  txndate datetime DEFAULT NULL,
  reftype varchar(25) DEFAULT NULL,
  refid varchar(50) DEFAULT NULL,
  refno varchar(25) NOT NULL,
  refdate date NOT NULL,
  amount decimal(16,2) NOT NULL,
  amtapplied decimal(16,2) NOT NULL,
  rptledger_objid varchar(50) NOT NULL,
  srcledger_objid varchar(50) DEFAULT NULL,
  remarks varchar(255) DEFAULT NULL,
  approvedby_objid varchar(50) DEFAULT NULL,
  approvedby_name varchar(150) DEFAULT NULL,
  approvedby_title varchar(75) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go


create index ix_state on rpttaxcredit(state)
go

create index ix_type on rpttaxcredit(type)
go

create unique index ux_txnno on rpttaxcredit(txnno)
go

create index ix_reftype on rpttaxcredit(reftype)
go

create index ix_refid on rpttaxcredit(refid)
go

create index ix_refno on rpttaxcredit(refno)
go

create index ix_rptledger_objid on rpttaxcredit(rptledger_objid)
go

create index ix_srcledger_objid on rpttaxcredit(srcledger_objid)
go

alter table rpttaxcredit
add constraint fk_rpttaxcredit_rptledger foreign key (rptledger_objid)
references rptledger (objid)
go

alter table rpttaxcredit
add constraint fk_rpttaxcredit_srcledger foreign key (srcledger_objid)
references rptledger (objid)
go

alter table rpttaxcredit
add constraint fk_rpttaxcredit_sys_user foreign key (approvedby_objid)
references sys_user(objid)
go







/*==================================================
**
** MACHINE SMV
**
===================================================*/

CREATE TABLE machine_smv (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  machine_objid varchar(50) NOT NULL,
  expr varchar(255) NOT NULL,
  previd varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go

create index ix_parent_objid on machine_smv(parent_objid)
go
create index ix_machine_objid on machine_smv(machine_objid)
go
create index ix_previd on machine_smv(previd)
go
create unique index ux_parent_machine on machine_smv(parent_objid, machine_objid)
go



alter table machine_smv
add constraint fk_machinesmv_machrysetting foreign key (parent_objid)
references machrysetting (objid)
go

alter table machine_smv
add constraint fk_machinesmv_machine foreign key (machine_objid)
references machine(objid)
go


alter table machine_smv
add constraint fk_machinesmv_machinesmv foreign key (previd)
references machine_smv(objid)
go


create view vw_machine_smv 
as 
select 
  ms.*, 
  m.code,
  m.name
from machine_smv ms 
inner join machine m on ms.machine_objid = m.objid 
go


alter table machdetail add smvid varchar(50)
go 
alter table machdetail add params text
go

update machdetail set params = '[]' where params is null
go

create index ix_smvid on machdetail(smvid)
go


alter table machdetail 
add constraint fk_machdetail_machine_smv foreign key(smvid)
references machine_smv(objid)
go 





/*==================================================
**
** SUBDIVISION AFFECTED RPUS TXNTYPE (DP)
**
===================================================*/

INSERT INTO sys_var (name, value, description, datatype, category) 
VALUES ('faas_affected_rpu_txntype_dp', '0', 'Set affected improvements FAAS txntype to DP e.g. SD and CS', 'checkbox', 'ASSESSOR')
go




if exists(select * from sysobjects where id = OBJECT_ID('sync_data_forprocess'))
begin 
  drop table sync_data_forprocess
end 
go 

if exists(select * from sysobjects where id = OBJECT_ID('sync_data_pending'))
begin 
  drop table sync_data_pending
end 
go 


if exists(select * from sysobjects where id = OBJECT_ID('sync_data'))
begin 
  drop table sync_data
end 
go 



if exists(select * from sysobjects where id = OBJECT_ID('syncdata_pending'))
begin 
  drop table syncdata_pending
end 
go 

if exists(select * from sysobjects where id = OBJECT_ID('syncdata_forprocess'))
begin 
  drop table syncdata_forprocess
end 
go 

if exists(select * from sysobjects where id = OBJECT_ID('syncdata_item'))
begin 
  drop table syncdata_item
end 
go 

if exists(select * from sysobjects where id = OBJECT_ID('syncdata'))
begin 
  drop table syncdata
end 
go 

if exists(select * from sysobjects where id = OBJECT_ID('syncdata_forsync'))
begin 
  drop table syncdata_forsync
end 
go 



CREATE TABLE syncdata_forsync (
  objid varchar(50) NOT NULL,
  reftype varchar(100) NOT NULL,
  refno varchar(50) NOT NULL,
  action varchar(100) NOT NULL,
  orgid varchar(25) NOT NULL,
  dtfiled datetime NOT NULL,
  createdby_objid varchar(50) DEFAULT NULL,
  createdby_name varchar(255) DEFAULT NULL,
  createdby_title varchar(100) DEFAULT NULL,
  info text,
  PRIMARY KEY (objid)
) 
go

CREATE INDEX ix_dtfiled ON syncdata_forsync (dtfiled)
go
CREATE INDEX ix_createdbyid ON syncdata_forsync (createdby_objid)
go
CREATE INDEX ix_reftype ON syncdata_forsync (reftype) 
go
CREATE INDEX ix_refno ON syncdata_forsync (refno)
go


CREATE TABLE syncdata (
  objid varchar(50) NOT NULL,
  state varchar(50) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) DEFAULT NULL,
  action varchar(50) NOT NULL,
  dtfiled datetime NOT NULL,
  orgid varchar(50) DEFAULT NULL,
  remote_orgid varchar(50) DEFAULT NULL,
  remote_orgcode varchar(20) DEFAULT NULL,
  remote_orgclass varchar(20) DEFAULT NULL,
  sender_objid varchar(50) DEFAULT NULL,
  sender_name varchar(150) DEFAULT NULL,
  fileid varchar(255) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go

CREATE INDEX ix_reftype on syncdata (reftype)
go
CREATE INDEX ix_refno on syncdata (refno)
go
CREATE INDEX ix_orgid on syncdata (orgid)
go
CREATE INDEX ix_dtfiled on syncdata (dtfiled)
go
CREATE INDEX ix_fileid on syncdata (fileid)
go
CREATE INDEX ix_refid on syncdata (refid)
go


CREATE TABLE syncdata_item (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  state varchar(50) NOT NULL,
  refid varchar(50) NOT NULL,
  reftype varchar(255) NOT NULL,
  refno varchar(50) DEFAULT NULL,
  action varchar(100) NOT NULL,
  error text,
  idx int NOT NULL,
  info text,
  PRIMARY KEY (objid)
)
go

CREATE INDEX ix_parentid ON syncdata_item(parentid)
go
CREATE INDEX ix_refid ON syncdata_item(refid)
go
CREATE INDEX ix_refno ON syncdata_item(refno)
go


ALTER TABLE syncdata_item 
ADD CONSTRAINT fk_syncdataitem_syncdata 
FOREIGN KEY (parentid) REFERENCES syncdata (objid)
GO 



CREATE TABLE syncdata_forprocess (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  PRIMARY KEY (objid)
) 
go

CREATE INDEX ix_parentid ON syncdata_forprocess (parentid)
go 

ALTER TABLE syncdata_forprocess 
ADD CONSTRAINT fk_syncdata_forprocess_syncdata_item 
FOREIGN KEY (objid) REFERENCES syncdata_item (objid)
go


CREATE TABLE syncdata_pending (
  objid varchar(50) NOT NULL,
  error text,
  expirydate datetime DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go

CREATE INDEX ix_expirydate ON syncdata_pending(expirydate)
go 

ALTER TABLE syncdata_pending 
ADD CONSTRAINT fk_syncdata_pending_syncdata 
FOREIGN KEY (objid) REFERENCES syncdata (objid)
go



/* PREVTAXABILITY */
alter table faas_previous add prevtaxability varchar(10)
go


update pf set 
  pf.prevtaxability = case when r.taxable = 1 then 'TAXABLE' else 'EXEMPT' end 
from faas_previous pf, faas f, rpu r
where pf.prevfaasid = f.objid
and f.rpuid = r.objid 
and pf.prevtaxability is null 
go 



/* 255-03020 */

alter table syncdata_item add async int
go 
alter table syncdata_item add dependedaction varchar(100)
go


create index ix_state on syncdata(state)
go
create index ix_state on syncdata_item(state)
go


create table syncdata_offline_org (
	orgid varchar(50) not null,
	expirydate datetime not null,
	primary key(orgid)
)
go




/*=======================================
*
*  QRRPA: Mixed-Use Support
*
=======================================*/
if exists(select * from sysobjects where id = OBJECT_ID('vw_rpu_assessment'))
begin 
  drop table vw_rpu_assessment
end 
go 


create view vw_rpu_assessment as 
select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join landassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join bldgassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join machassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join planttreeassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid

union 

select 
	r.objid,
	r.rputype,
	dpc.objid as dominantclass_objid,
	dpc.code as dominantclass_code,
	dpc.name as dominantclass_name,
	dpc.orderno as dominantclass_orderno,
	ra.areasqm,
	ra.areaha,
	ra.marketvalue,
	ra.assesslevel,
	ra.assessedvalue,
	ra.taxable,
	au.code as actualuse_code, 
	au.name  as actualuse_name,
	auc.objid as actualuse_objid,
	auc.code as actualuse_classcode,
	auc.name as actualuse_classname,
	auc.orderno as actualuse_orderno
from rpu r 
inner join propertyclassification dpc on r.classification_objid = dpc.objid
inner join rpu_assessment ra on r.objid = ra.rpuid
inner join miscassesslevel au on ra.actualuse_objid = au.objid 
left join propertyclassification auc on au.classification_objid = auc.objid
go 



drop table syncdata_offline_org
go


CREATE TABLE syncdata_org (
  orgid varchar(50) NOT NULL,
  state varchar(50) NOT NULL,
  errorcount int,
  PRIMARY KEY (orgid)
) 
go

create index ix_state on syncdata_org(state)
;

insert into syncdata_org (
  orgid, 
  state, 
  errorcount
)
select 
  objid,
  'ACTIVE',
  0
from sys_org
where orgclass = 'province'
;


drop table syncdata_forprocess
go 

CREATE TABLE syncdata_forprocess (
  objid varchar(50) NOT NULL,
  PRIMARY KEY (objid)
) 
go




alter table rptledger_item add fromqtr int
go 
alter table rptledger_item add toqtr int
go 


CREATE TABLE batch_rpttaxcredit (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  txndate date NOT NULL,
  txnno varchar(25) NOT NULL,
  rate decimal(10,2) NOT NULL,
  paymentfrom date DEFAULT NULL,
  paymentto varchar(255) DEFAULT NULL,
  creditedyear int NOT NULL,
  reason varchar(255) NOT NULL,
  validity date NULL,
  PRIMARY KEY (objid)
) 
go

create index ix_state on batch_rpttaxcredit(state)
go
create index ix_txnno on batch_rpttaxcredit(txnno)
go

CREATE TABLE batch_rpttaxcredit_ledger (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  error varchar(255) NULL,
	barangayid varchar(50) not null, 
  PRIMARY KEY (objid)
) 
go


create index ix_parentid on batch_rpttaxcredit_ledger (parentid)
go
create index ix_state on batch_rpttaxcredit_ledger (state)
go
create index ix_barangayid on batch_rpttaxcredit_ledger (barangayid)
go

alter table batch_rpttaxcredit_ledger 
add constraint fk_rpttaxcredit_rptledger_parent foreign key(parentid) references batch_rpttaxcredit(objid)
go

alter table batch_rpttaxcredit_ledger 
add constraint fk_rpttaxcredit_rptledger_rptledger foreign key(objid) references rptledger(objid)
go




CREATE TABLE batch_rpttaxcredit_ledger_posted (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  barangayid varchar(50) NOT NULL,
  PRIMARY KEY (objid)
)
go

create index ix_parentid on batch_rpttaxcredit_ledger_posted(parentid)
go
create index ix_barangayid on batch_rpttaxcredit_ledger_posted(barangayid)
go

alter table batch_rpttaxcredit_ledger_posted 
add constraint fk_rpttaxcredit_rptledger_posted_parent foreign key(parentid) references batch_rpttaxcredit(objid)
go

alter table batch_rpttaxcredit_ledger_posted 
add constraint fk_rpttaxcredit_rptledger_posted_rptledger foreign key(objid) references rptledger(objid)
go

create view vw_batch_rpttaxcredit_error
as 
select br.*, rl.tdno
from batch_rpttaxcredit_ledger br 
inner join rptledger rl on br.objid = rl.objid 
where br.state = 'ERROR'
go

alter table rpttaxcredit add info text
go


alter table rpttaxcredit add discapplied decimal(16,2) not null
go

update rpttaxcredit set discapplied = 0 where discapplied is null 
go

CREATE TABLE rpt_syncdata_forsync (
  [objid] varchar(50) NOT NULL,
  [reftype] varchar(50) NOT NULL,
  [refno] varchar(50) NOT NULL,
  [action] varchar(50) NOT NULL,
  [orgid] varchar(50) NOT NULL,
  [dtfiled] datetime NOT NULL,
  [createdby_objid] varchar(50) DEFAULT NULL,
  [createdby_name] varchar(255) DEFAULT NULL,
  [createdby_title] varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 
create index ix_refno on rpt_syncdata_forsync (refno)
go
create index ix_orgid on rpt_syncdata_forsync (orgid)
go

CREATE TABLE rpt_syncdata (
  [objid] varchar(50) NOT NULL,
  [state] varchar(25) NOT NULL,
  [refid] varchar(50) NOT NULL,
  [reftype] varchar(50) NOT NULL,
  [refno] varchar(50) NOT NULL,
  [action] varchar(50) NOT NULL,
  [dtfiled] datetime NOT NULL,
  [orgid] varchar(50) NOT NULL,
  [remote_orgid] varchar(50) DEFAULT NULL,
  [remote_orgcode] varchar(5) DEFAULT NULL,
  [remote_orgclass] varchar(25) DEFAULT NULL,
  [sender_objid] varchar(50) DEFAULT NULL,
  [sender_name] varchar(255) DEFAULT NULL,
  [sender_title] varchar(80) DEFAULT NULL,
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
  add CONSTRAINT FK_parentid_rpt_syncdata 
  FOREIGN KEY (parentid) REFERENCES rpt_syncdata (objid)
go 

CREATE TABLE rpt_syncdata_error (
  [objid] varchar(50) NOT NULL,
  [filekey] varchar(1000) NOT NULL,
  [error] text,
  [refid] varchar(50) NOT NULL,
  [reftype] varchar(50) NOT NULL,
  [refno] varchar(50) NOT NULL,
  [action] varchar(50) NOT NULL,
  [idx] int NOT NULL,
  [info] text,
  [parent] text,
  [remote_orgid] varchar(50) DEFAULT NULL,
  [remote_orgcode] varchar(5) DEFAULT NULL,
  [remote_orgclass] varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 

create index ix_refid on rpt_syncdata_error (refid)
go
create index ix_refno on rpt_syncdata_error (refno)
go
create index ix_filekey on rpt_syncdata_error (filekey)
go
create index ix_remote_orgid on rpt_syncdata_error (remote_orgid)
go
create index ix_remote_orgcode on rpt_syncdata_error (remote_orgcode)
go

INSERT INTO sys_var ([name], [value], [description], [datatype], [category]) 
VALUES ('assesser_new_sync_lgus', NULL, 'List of LGUs using new sync facility', NULL, 'ASSESSOR')
go 





ALTER TABLE rpt_syncdata_forsync ADD remote_orgid VARCHAR(15)
go 

INSERT INTO sys_var ([name], [value], [description], [datatype], [category]) 
VALUES ('fileserver_upload_task_active', '0', 'Activate / Deactivate upload task', 'boolean', 'SYSTEM')
go 


INSERT INTO sys_var ([name], [value], [description], [datatype], [category]) 
VALUES ('fileserver_download_task_active', '0', 'Activate / Deactivate download task', 'boolean', 'SYSTEM')
go



CREATE TABLE rpt_syncdata_completed (
  [objid] varchar(255) NOT NULL,
  [idx] int DEFAULT NULL,
  [action] varchar(100) DEFAULT NULL,
  [refno] varchar(50) DEFAULT NULL,
  [refid] varchar(50) DEFAULT NULL,
  [reftype] varchar(50) DEFAULT NULL,
  [parent_orgid] varchar(50) DEFAULT NULL,
  [sender_name] varchar(255) DEFAULT NULL,
  [sender_title] varchar(255) DEFAULT NULL,
  [dtcreated] datetime DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 

CREATE INDEX ix_refno ON rpt_syncdata_completed (refno)
go
CREATE INDEX ix_refid ON rpt_syncdata_completed (refid)
go
CREATE INDEX ix_parent_orgid ON rpt_syncdata_completed (parent_orgid)
go

alter table rpt_syncdata_forsync add info text
go
alter table rpt_syncdata add info text
go




drop view vw_landtax_lgu_account_mapping
go

CREATE VIEW vw_landtax_lgu_account_mapping 
AS 
select 
    ia.org_objid AS org_objid,
    ia.org_name AS org_name,
    o.orgclass AS org_class,
    p.objid AS parent_objid,
    p.code AS parent_code,
    p.title AS parent_title,
    ia.objid AS item_objid,
    ia.code AS item_code,
    ia.title AS item_title,
    ia.fund_objid AS item_fund_objid,
    ia.fund_code AS item_fund_code,
    ia.fund_title AS item_fund_title,
    ia.type AS item_type,
    pt.tag AS item_tag 
from itemaccount ia 
    inner join itemaccount p on ia.parentid = p.objid 
    inner join itemaccount_tag pt on p.objid = pt.acctid 
    inner join sys_org o on ia.org_objid = o.objid 
where p.state = 'ACTIVE' 
  and ia.state = 'ACTIVE'
go


drop view vw_batchgr
go



create table cashreceipt_rpt_share_forposting_repost (
  rptpaymentid varchar(50) not null,
  receiptid varchar(50) not null,
  receiptdate date not null,
  rptledgerid varchar(50) not null
)
go 

create unique index ux_receiptid_rptledgerid on cashreceipt_rpt_share_forposting_repost(receiptid,rptledgerid)
go 

create index fk_rptshare_repost_rptledgerid on cashreceipt_rpt_share_forposting_repost(rptledgerid)
go 
create index fk_rptshare_repost_cashreceiptid on cashreceipt_rpt_share_forposting_repost(receiptid)
go 
alter table cashreceipt_rpt_share_forposting_repost 
    add constraint fk_rptshare_repost_cashreceipt foreign key (receiptid) 
    references cashreceipt (objid)
go 
alter table cashreceipt_rpt_share_forposting_repost 
    add constraint fk_rptshare_repost_rptledger foreign key (rptledgerid) 
    references rptledger (objid)
go 


alter table bldgrpu add occpermitno varchar(25)
go

alter table rpu add isonline int
go

update rpu set isonline = 0 where isonline is null 
go


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


DROP TABLE cashreceipt_rpt_share_forposting_repost
GO 

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





if exists(select * from sysobjects where id = object_id('batchgr_item'))
begin
  drop table batchgr_item
end 
go 
if exists(select * from sysobjects where id = object_id('batchgr_task'))
begin
  drop table batchgr_task
end 
go 
if exists(select * from sysobjects where id = object_id('batchgr'))
begin
  drop table batchgr
end 
go 


CREATE TABLE batchgr (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
  ry int NOT NULL,
  lgu_objid varchar(50) NOT NULL,
  barangay_objid varchar(50) NOT NULL,
  rputype varchar(15) DEFAULT NULL,
  classification_objid varchar(50) DEFAULT NULL,
  section varchar(10) DEFAULT NULL,
  memoranda varchar(100) DEFAULT NULL,
  txntype_objid varchar(50) DEFAULT NULL,
  txnno varchar(25) DEFAULT NULL,
  txndate datetime DEFAULT NULL,
  effectivityyear int DEFAULT NULL,
  effectivityqtr int DEFAULT NULL,
  originlgu_objid varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 

create index ix_barangay_objid on batchgr (barangay_objid)
go
create index ix_state on batchgr (state)
go
create index fk_lgu_objid on batchgr (lgu_objid)
go
create index ix_ry on batchgr (ry)
go
create index ix_txnno on batchgr (txnno)
go
create index ix_classificationid on batchgr (classification_objid)
go
create index ix_section on batchgr (section)
go


alter table batchgr add CONSTRAINT batchgr_ibfk_1 FOREIGN KEY (barangay_objid) REFERENCES sys_org (objid)
go 
alter table batchgr add CONSTRAINT batchgr_ibfk_2 FOREIGN KEY (classification_objid) REFERENCES propertyclassification (objid)
go 
alter table batchgr add CONSTRAINT batchgr_ibfk_3 FOREIGN KEY (lgu_objid) REFERENCES sys_org (objid)
go 
alter table batchgr add CONSTRAINT fk_batchgr_barangayid FOREIGN KEY (barangay_objid) REFERENCES sys_org (objid)
go 
alter table batchgr add CONSTRAINT fk_batchgr_classificationid FOREIGN KEY (classification_objid) REFERENCES propertyclassification (objid)
go 
alter table batchgr add CONSTRAINT fk_batchgr_lguid FOREIGN KEY (lgu_objid) REFERENCES sys_org (objid)
go 



CREATE TABLE batchgr_task (
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

create index ix_assignee_objid on batchgr_task (assignee_objid)
go 
create index ix_refid on batchgr_task (refid)
go 

alter table batchgr_task add CONSTRAINT fk_batchgr_task_batchgr FOREIGN KEY (refid) REFERENCES batchgr (objid)
go 

CREATE TABLE batchgr_item (
  objid varchar(50) NOT NULL,
  parent_objid varchar(50) NOT NULL,
  state varchar(50) NOT NULL,
  rputype varchar(15) NOT NULL,
  tdno varchar(50) NOT NULL,
  fullpin varchar(50) NOT NULL,
  pin varchar(50) NOT NULL,
  suffix int NOT NULL,
  newfaasid varchar(50) DEFAULT NULL,
  error text,
  subsuffix int DEFAULT NULL,
  PRIMARY KEY (objid)
)
go 

create index fk_batchgr_item_batchgr on batchgr_item (parent_objid)
go 
create index fk_batchgr_item_newfaasid on batchgr_item (newfaasid)
go 
create index fk_batchgr_item_tdno on batchgr_item (tdno)
go 
create index fk_batchgr_item_pin on batchgr_item (pin)
go 

alter table batchgr_item add CONSTRAINT batchgr_item_ibfk_1 FOREIGN KEY (parent_objid) REFERENCES batchgr (objid)
go 
alter table batchgr_item add CONSTRAINT batchgr_item_ibfk_2 FOREIGN KEY (objid) REFERENCES faas (objid)
go 
alter table batchgr_item add CONSTRAINT batchgr_item_ibfk_3 FOREIGN KEY (newfaasid) REFERENCES faas (objid)
go 
alter table batchgr_item add CONSTRAINT batchgr_item_ibfk_4 FOREIGN KEY (objid) REFERENCES faas (objid)
go 
alter table batchgr_item add CONSTRAINT fk_batchgr_item_faas FOREIGN KEY (objid) REFERENCES faas (objid)
go 


if exists(select * from sysobjects where id = object_id('rpt_syncdata_item'))
begin
  drop table rpt_syncdata_item
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_forsync'))
begin
  drop table rpt_syncdata_forsync
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_error'))
begin
  drop table rpt_syncdata_error
end 
go 
if exists(select * from sysobjects where id = object_id('rpt_syncdata_completed'))
begin
  drop table rpt_syncdata_completed
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

create index  ix_state on rpt_syncdata (state)
go 
create index  ix_refid on rpt_syncdata (refid)
go 
create index  ix_refno on rpt_syncdata (refno)
go 
create index  ix_orgid on rpt_syncdata (orgid)
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

alter table rpt_syncdata_item add CONSTRAINT FK_parentid_rpt_syncdata FOREIGN KEY (parentid) REFERENCES rpt_syncdata (objid)
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


CREATE TABLE rpt_syncdata_error (
  objid varchar(50) NOT NULL,
  filekey varchar(1000) NOT NULL,
  error text,
  refid varchar(50) NOT NULL,
  reftype varchar(50) NOT NULL,
  refno varchar(50) NOT NULL,
  action varchar(50) NOT NULL,
  idx int NOT NULL,
  info text,
  parent text,
  remote_orgid varchar(50) DEFAULT NULL,
  remote_orgcode varchar(5) DEFAULT NULL,
  remote_orgclass varchar(50) DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create index ix_refid on rpt_syncdata_error (refid)
go 
create index ix_refno on rpt_syncdata_error (refno)
go 
create index ix_filekey on rpt_syncdata_error (filekey)
go 
create index ix_remote_orgid on rpt_syncdata_error (remote_orgid)
go 
create index ix_remote_orgcode on rpt_syncdata_error (remote_orgcode)
go 


CREATE TABLE rpt_syncdata_completed (
  objid varchar(255) NOT NULL,
  idx int DEFAULT NULL,
  action varchar(100) DEFAULT NULL,
  refno varchar(50) DEFAULT NULL,
  refid varchar(50) DEFAULT NULL,
  reftype varchar(50) DEFAULT NULL,
  parent_orgid varchar(50) DEFAULT NULL,
  sender_name varchar(255) DEFAULT NULL,
  sender_title varchar(255) DEFAULT NULL,
  dtcreated datetime DEFAULT NULL,
  PRIMARY KEY (objid)
) 
go 

create index ix_refno on rpt_syncdata_completed (refno)
go 

create index ix_refid on rpt_syncdata_completed (refid)
go 

create index ix_parent_orgid on rpt_syncdata_completed (parent_orgid)
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

if exists(select * from sysobjects where id = object_id('vw_faas_lookup'))
begin
  drop view vw_faas_lookup
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

if exists(select * from sysobjects where id = object_id('vw_rptpayment_item_detail'))
begin
  drop view vw_rptpayment_item_detail
end
go 

if exists(select * from sysobjects where id = object_id('vw_rptpayment_item'))
begin
  drop view vw_rptpayment_item
end
go 

if exists(select * from sysobjects where id = object_id('vw_rpu_assessment'))
begin
  drop view vw_rpu_assessment
end
go 

if exists(select * from sysobjects where id = object_id('vw_txn_log'))
begin
  drop view vw_txn_log
end
go 




CREATE VIEW vw_assessment_notice_item AS select ni.objid AS objid,ni.assessmentnoticeid AS assessmentnoticeid,f.objid AS faasid,f.effectivityyear AS effectivityyear,f.effectivityqtr AS effectivityqtr,f.tdno AS tdno,f.taxpayer_objid AS taxpayer_objid,e.name AS taxpayer_name,e.address_text AS taxpayer_address,f.owner_name AS owner_name,f.owner_address AS owner_address,f.administrator_name AS administrator_name,f.administrator_address AS administrator_address,f.rpuid AS rpuid,f.lguid AS lguid,f.txntype_objid AS txntype_objid,ft.displaycode AS txntype_code,rpu.rputype AS rputype,rpu.ry AS ry,rpu.fullpin AS fullpin,rpu.taxable AS taxable,rpu.totalareaha AS totalareaha,rpu.totalareasqm AS totalareasqm,rpu.totalbmv AS totalbmv,rpu.totalmv AS totalmv,rpu.totalav AS totalav,rp.section AS section,rp.parcel AS parcel,rp.surveyno AS surveyno,rp.cadastrallotno AS cadastrallotno,rp.blockno AS blockno,rp.claimno AS claimno,rp.street AS street,o.name AS lguname,b.name AS barangay,pc.code AS classcode,pc.name AS classification from (((((((((assessmentnoticeitem ni join faas f on((ni.faasid = f.objid))) left join txnsignatory ts on(((ts.refid = f.objid) and (ts.type = 'APPROVER')))) join rpu on((f.rpuid = rpu.objid))) join propertyclassification pc on((rpu.classification_objid = pc.objid))) join realproperty rp on((f.realpropertyid = rp.objid))) join barangay b on((rp.barangayid = b.objid))) join sys_org o on((f.lguid = o.objid))) join entity e on((f.taxpayer_objid = e.objid))) join faas_txntype ft on((f.txntype_objid = ft.objid)));
CREATE VIEW vw_assessment_notice AS select a.objid AS objid,a.state AS state,a.txnno AS txnno,a.txndate AS txndate,a.taxpayerid AS taxpayerid,a.taxpayername AS taxpayername,a.taxpayeraddress AS taxpayeraddress,a.dtdelivered AS dtdelivered,a.receivedby AS receivedby,a.remarks AS remarks,a.assessmentyear AS assessmentyear,a.administrator_name AS administrator_name,a.administrator_address AS administrator_address,fl.tdno AS tdno,fl.displaypin AS fullpin,fl.cadastrallotno AS cadastrallotno,fl.titleno AS titleno from ((assessmentnotice a join assessmentnoticeitem i on((a.objid = i.assessmentnoticeid))) join faas_list fl on((i.faasid = fl.objid)));
CREATE VIEW vw_batch_rpttaxcredit_error AS select br.objid AS objid,br.parentid AS parentid,br.state AS state,br.error AS error,br.barangayid AS barangayid,rl.tdno AS tdno from (batch_rpttaxcredit_ledger br join rptledger rl on((br.objid = rl.objid))) where (br.state = 'ERROR');
CREATE VIEW vw_batchgr AS select bg.objid AS objid,bg.state AS state,bg.ry AS ry,bg.lgu_objid AS lgu_objid,bg.barangay_objid AS barangay_objid,bg.rputype AS rputype,bg.classification_objid AS classification_objid,bg.section AS section,bg.memoranda AS memoranda,bg.txntype_objid AS txntype_objid,bg.txnno AS txnno,bg.txndate AS txndate,bg.effectivityyear AS effectivityyear,bg.effectivityqtr AS effectivityqtr,bg.originlgu_objid AS originlgu_objid,l.name AS lgu_name,b.name AS barangay_name,b.pin AS barangay_pin,pc.name AS classification_name,t.objid AS taskid,t.state AS taskstate,t.assignee_objid AS assignee_objid from ((((batchgr bg join sys_org l on((bg.lgu_objid = l.objid))) left join barangay b on((bg.barangay_objid = b.objid))) left join propertyclassification pc on((bg.classification_objid = pc.objid))) left join batchgr_task t on(((bg.objid = t.refid) and t.enddate is null)));
CREATE VIEW vw_faas_lookup AS select fl.objid AS objid,fl.state AS state,fl.rpuid AS rpuid,fl.utdno AS utdno,fl.tdno AS tdno,fl.txntype_objid AS txntype_objid,fl.effectivityyear AS effectivityyear,fl.effectivityqtr AS effectivityqtr,fl.taxpayer_objid AS taxpayer_objid,fl.owner_name AS owner_name,fl.owner_address AS owner_address,fl.prevtdno AS prevtdno,fl.cancelreason AS cancelreason,fl.cancelledbytdnos AS cancelledbytdnos,fl.lguid AS lguid,fl.realpropertyid AS realpropertyid,fl.displaypin AS fullpin,fl.originlguid AS originlguid,e.name AS taxpayer_name,e.address_text AS taxpayer_address,pc.code AS classification_code,pc.code AS classcode,pc.name AS classification_name,pc.name AS classname,fl.ry AS ry,fl.rputype AS rputype,fl.totalmv AS totalmv,fl.totalav AS totalav,fl.totalareasqm AS totalareasqm,fl.totalareaha AS totalareaha,fl.barangayid AS barangayid,fl.cadastrallotno AS cadastrallotno,fl.blockno AS blockno,fl.surveyno AS surveyno,fl.pin AS pin,fl.barangay AS barangay_name,fl.trackingno AS trackingno from ((faas_list fl left join propertyclassification pc on((fl.classification_objid = pc.objid))) left join entity e on((fl.taxpayer_objid = e.objid)));
CREATE VIEW vw_landtax_lgu_account_mapping AS select ia.org_objid AS org_objid,ia.org_name AS org_name,o.orgclass AS org_class,p.objid AS parent_objid,p.code AS parent_code,p.title AS parent_title,ia.objid AS item_objid,ia.code AS item_code,ia.title AS item_title,ia.fund_objid AS item_fund_objid,ia.fund_code AS item_fund_code,ia.fund_title AS item_fund_title,ia.type AS item_type,pt.tag AS item_tag from (((itemaccount ia join itemaccount p on((ia.parentid = p.objid))) join itemaccount_tag pt on((p.objid = pt.acctid))) join sys_org o on((ia.org_objid = o.objid))) where (p.state = 'ACTIVE');
CREATE VIEW vw_landtax_report_rptdelinquency_detail AS select ri.objid AS objid,ri.rptledgerid AS rptledgerid,ri.barangayid AS barangayid,ri.year AS year,ri.qtr AS qtr,r.dtgenerated AS dtgenerated,r.dtcomputed AS dtcomputed,r.generatedby_name AS generatedby_name,r.generatedby_title AS generatedby_title,(case when (ri.revtype = 'basic') then ri.amount else 0 end) AS basic,(case when (ri.revtype = 'basic') then ri.interest else 0 end) AS basicint,(case when (ri.revtype = 'basic') then ri.discount else 0 end) AS basicdisc,(case when (ri.revtype = 'basic') then (ri.interest - ri.discount) else 0 end) AS basicdp,(case when (ri.revtype = 'basic') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS basicnet,(case when (ri.revtype = 'basicidle') then ri.amount else 0 end) AS basicidle,(case when (ri.revtype = 'basicidle') then ri.interest else 0 end) AS basicidleint,(case when (ri.revtype = 'basicidle') then ri.discount else 0 end) AS basicidledisc,(case when (ri.revtype = 'basicidle') then (ri.interest - ri.discount) else 0 end) AS basicidledp,(case when (ri.revtype = 'basicidle') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS basicidlenet,(case when (ri.revtype = 'sef') then ri.amount else 0 end) AS sef,(case when (ri.revtype = 'sef') then ri.interest else 0 end) AS sefint,(case when (ri.revtype = 'sef') then ri.discount else 0 end) AS sefdisc,(case when (ri.revtype = 'sef') then (ri.interest - ri.discount) else 0 end) AS sefdp,(case when (ri.revtype = 'sef') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS sefnet,(case when (ri.revtype = 'firecode') then ri.amount else 0 end) AS firecode,(case when (ri.revtype = 'firecode') then ri.interest else 0 end) AS firecodeint,(case when (ri.revtype = 'firecode') then ri.discount else 0 end) AS firecodedisc,(case when (ri.revtype = 'firecode') then (ri.interest - ri.discount) else 0 end) AS firecodedp,(case when (ri.revtype = 'firecode') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS firecodenet,(case when (ri.revtype = 'sh') then ri.amount else 0 end) AS sh,(case when (ri.revtype = 'sh') then ri.interest else 0 end) AS shint,(case when (ri.revtype = 'sh') then ri.discount else 0 end) AS shdisc,(case when (ri.revtype = 'sh') then (ri.interest - ri.discount) else 0 end) AS shdp,(case when (ri.revtype = 'sh') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS shnet,((ri.amount + ri.interest) - ri.discount) AS total from (report_rptdelinquency_item ri join report_rptdelinquency r on((ri.parentid = r.objid)));
CREATE VIEW vw_landtax_report_rptdelinquency AS select ri.objid AS objid,ri.rptledgerid AS rptledgerid,ri.barangayid AS barangayid,ri.year AS year,ri.qtr AS qtr,r.dtgenerated AS dtgenerated,r.dtcomputed AS dtcomputed,r.generatedby_name AS generatedby_name,r.generatedby_title AS generatedby_title,(case when (ri.revtype = 'basic') then ri.amount else 0 end) AS basic,(case when (ri.revtype = 'basic') then ri.interest else 0 end) AS basicint,(case when (ri.revtype = 'basic') then ri.discount else 0 end) AS basicdisc,(case when (ri.revtype = 'basic') then (ri.interest - ri.discount) else 0 end) AS basicdp,(case when (ri.revtype = 'basic') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS basicnet,(case when (ri.revtype = 'basicidle') then ri.amount else 0 end) AS basicidle,(case when (ri.revtype = 'basicidle') then ri.interest else 0 end) AS basicidleint,(case when (ri.revtype = 'basicidle') then ri.discount else 0 end) AS basicidledisc,(case when (ri.revtype = 'basicidle') then (ri.interest - ri.discount) else 0 end) AS basicidledp,(case when (ri.revtype = 'basicidle') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS basicidlenet,(case when (ri.revtype = 'sef') then ri.amount else 0 end) AS sef,(case when (ri.revtype = 'sef') then ri.interest else 0 end) AS sefint,(case when (ri.revtype = 'sef') then ri.discount else 0 end) AS sefdisc,(case when (ri.revtype = 'sef') then (ri.interest - ri.discount) else 0 end) AS sefdp,(case when (ri.revtype = 'sef') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS sefnet,(case when (ri.revtype = 'firecode') then ri.amount else 0 end) AS firecode,(case when (ri.revtype = 'firecode') then ri.interest else 0 end) AS firecodeint,(case when (ri.revtype = 'firecode') then ri.discount else 0 end) AS firecodedisc,(case when (ri.revtype = 'firecode') then (ri.interest - ri.discount) else 0 end) AS firecodedp,(case when (ri.revtype = 'firecode') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS firecodenet,(case when (ri.revtype = 'sh') then ri.amount else 0 end) AS sh,(case when (ri.revtype = 'sh') then ri.interest else 0 end) AS shint,(case when (ri.revtype = 'sh') then ri.discount else 0 end) AS shdisc,(case when (ri.revtype = 'sh') then (ri.interest - ri.discount) else 0 end) AS shdp,(case when (ri.revtype = 'sh') then ((ri.amount + ri.interest) - ri.discount) else 0 end) AS shnet,((ri.amount + ri.interest) - ri.discount) AS total from (report_rptdelinquency_item ri join report_rptdelinquency r on((ri.parentid = r.objid)));
CREATE VIEW vw_machine_smv AS select ms.objid AS objid,ms.parent_objid AS parent_objid,ms.machine_objid AS machine_objid,ms.expr AS expr,ms.previd AS previd,m.code AS code,m.name AS name from (machine_smv ms join machine m on((ms.machine_objid = m.objid)));
CREATE VIEW vw_real_property_payment AS select cv.controldate AS cv_controldate,rem.controldate AS rem_controldate,rl.owner_name AS owner_name,rl.tdno AS tdno,pc.name AS classification,(case when (rl.rputype = 'land') then 'LAND' when (rl.rputype = 'bldg') then 'BUILDING' when (rl.rputype = 'mach') then 'MACHINERY' when (rl.rputype = 'planttree') then 'PLANT/TREE' else 'MISCELLANEOUS' end) AS rputype,b.name AS barangay,((rpi.amount + rpi.interest) - rpi.discount) AS amount,(case when v.objid is null then 0 else 1 end) AS voided from ((((((((collectionvoucher cv join remittance rem on((cv.objid = rem.collectionvoucherid))) join cashreceipt cr on((rem.objid = cr.remittanceid))) join rptpayment rp on((cr.objid = rp.receiptid))) join rptpayment_item rpi on((rp.objid = rpi.parentid))) join rptledger rl on((rp.refid = rl.objid))) join barangay b on((rl.barangayid = b.objid))) join propertyclassification pc on((rl.classification_objid = pc.objid))) left join cashreceipt_void v on((cr.objid = v.receiptid)));
CREATE VIEW vw_report_orc AS select f.objid AS objid,f.state AS state,e.objid AS taxpayerid,e.name AS taxpayer_name,e.address_text AS taxpayer_address,o.name AS lgu_name,o.code AS lgu_indexno,f.dtapproved AS dtapproved,r.rputype AS rputype,pc.code AS classcode,pc.name AS classification,f.fullpin AS pin,f.titleno AS titleno,rp.cadastrallotno AS cadastrallotno,f.tdno AS tdno,'' AS arpno,f.prevowner AS prevowner,b.name AS location,r.totalareaha AS totalareaha,r.totalareasqm AS totalareasqm,r.totalmv AS totalmv,r.totalav AS totalav,(case when (f.state = 'CURRENT') then '' else 'CANCELLED' end) AS remarks from ((((((faas f join rpu r on((f.rpuid = r.objid))) join realproperty rp on((f.realpropertyid = rp.objid))) join propertyclassification pc on((r.classification_objid = pc.objid))) join entity e on((f.taxpayer_objid = e.objid))) join sys_org o on((rp.lguid = o.objid))) join barangay b on((rp.barangayid = b.objid))) where (f.state in ('CURRENT','CANCELLED'));
CREATE VIEW vw_rptcertification_item AS select rci.rptcertificationid AS rptcertificationid,f.objid AS faasid,f.fullpin AS fullpin,f.tdno AS tdno,e.objid AS taxpayerid,e.name AS taxpayer_name,f.owner_name AS owner_name,f.administrator_name AS administrator_name,f.titleno AS titleno,f.rpuid AS rpuid,pc.code AS classcode,pc.name AS classname,so.name AS lguname,b.name AS barangay,r.rputype AS rputype,r.suffix AS suffix,r.totalareaha AS totalareaha,r.totalareasqm AS totalareasqm,r.totalav AS totalav,r.totalmv AS totalmv,rp.street AS street,rp.blockno AS blockno,rp.cadastrallotno AS cadastrallotno,rp.surveyno AS surveyno,r.taxable AS taxable,f.effectivityyear AS effectivityyear,f.effectivityqtr AS effectivityqtr from (((((((rptcertificationitem rci join faas f on((rci.refid = f.objid))) join rpu r on((f.rpuid = r.objid))) join propertyclassification pc on((r.classification_objid = pc.objid))) join realproperty rp on((f.realpropertyid = rp.objid))) join barangay b on((rp.barangayid = b.objid))) join sys_org so on((f.lguid = so.objid))) join entity e on((f.taxpayer_objid = e.objid)));
CREATE VIEW vw_rptledger_avdifference AS select rlf.objid AS objid,'APPROVED' AS state,d.parent_objid AS rptledgerid,rl.faasid AS faasid,rl.tdno AS tdno,rlf.txntype_objid AS txntype_objid,rlf.classification_objid AS classification_objid,rlf.actualuse_objid AS actualuse_objid,rlf.taxable AS taxable,rlf.backtax AS backtax,d.year AS fromyear,1 AS fromqtr,d.year AS toyear,4 AS toqtr,d.av AS assessedvalue,1 AS systemcreated,rlf.reclassed AS reclassed,rlf.idleland AS idleland,1 AS taxdifference from ((rptledger_avdifference d join rptledgerfaas rlf on((d.rptledgerfaas_objid = rlf.objid))) join rptledger rl on((d.parent_objid = rl.objid)));
CREATE VIEW vw_rptpayment_item_detail AS select rpi.objid AS objid,rpi.parentid AS parentid,rpi.rptledgerfaasid AS rptledgerfaasid,rpi.year AS year,rpi.qtr AS qtr,rpi.revperiod AS revperiod,(case when (rpi.revtype = 'basic') then rpi.amount else 0 end) AS basic,(case when (rpi.revtype = 'basic') then rpi.interest else 0 end) AS basicint,(case when (rpi.revtype = 'basic') then rpi.discount else 0 end) AS basicdisc,(case when (rpi.revtype = 'basic') then (rpi.interest - rpi.discount) else 0 end) AS basicdp,(case when (rpi.revtype = 'basic') then ((rpi.amount + rpi.interest) - rpi.discount) else 0 end) AS basicnet,(case when (rpi.revtype = 'basicidle') then ((rpi.amount + rpi.interest) - rpi.discount) else 0 end) AS basicidle,(case when (rpi.revtype = 'basicidle') then rpi.interest else 0 end) AS basicidleint,(case when (rpi.revtype = 'basicidle') then rpi.discount else 0 end) AS basicidledisc,(case when (rpi.revtype = 'basicidle') then (rpi.interest - rpi.discount) else 0 end) AS basicidledp,(case when (rpi.revtype = 'sef') then rpi.amount else 0 end) AS sef,(case when (rpi.revtype = 'sef') then rpi.interest else 0 end) AS sefint,(case when (rpi.revtype = 'sef') then rpi.discount else 0 end) AS sefdisc,(case when (rpi.revtype = 'sef') then (rpi.interest - rpi.discount) else 0 end) AS sefdp,(case when (rpi.revtype = 'sef') then ((rpi.amount + rpi.interest) - rpi.discount) else 0 end) AS sefnet,(case when (rpi.revtype = 'firecode') then ((rpi.amount + rpi.interest) - rpi.discount) else 0 end) AS firecode,(case when (rpi.revtype = 'sh') then ((rpi.amount + rpi.interest) - rpi.discount) else 0 end) AS sh,(case when (rpi.revtype = 'sh') then rpi.interest else 0 end) AS shint,(case when (rpi.revtype = 'sh') then rpi.discount else 0 end) AS shdisc,(case when (rpi.revtype = 'sh') then (rpi.interest - rpi.discount) else 0 end) AS shdp,(case when (rpi.revtype = 'sh') then ((rpi.amount + rpi.interest) - rpi.discount) else 0 end) AS shnet,((rpi.amount + rpi.interest) - rpi.discount) AS amount,rpi.partialled AS partialled from rptpayment_item rpi;
CREATE VIEW vw_rptpayment_item AS select x.parentid AS parentid,x.rptledgerfaasid AS rptledgerfaasid,x.year AS year,x.qtr AS qtr,x.revperiod AS revperiod,sum(x.basic) AS basic,sum(x.basicint) AS basicint,sum(x.basicdisc) AS basicdisc,sum(x.basicdp) AS basicdp,sum(x.basicnet) AS basicnet,sum(x.basicidle) AS basicidle,sum(x.basicidleint) AS basicidleint,sum(x.basicidledisc) AS basicidledisc,sum(x.basicidledp) AS basicidledp,sum(x.sef) AS sef,sum(x.sefint) AS sefint,sum(x.sefdisc) AS sefdisc,sum(x.sefdp) AS sefdp,sum(x.sefnet) AS sefnet,sum(x.firecode) AS firecode,sum(x.sh) AS sh,sum(x.shint) AS shint,sum(x.shdisc) AS shdisc,sum(x.shdp) AS shdp,sum(x.amount) AS amount,max(x.partialled) AS partialled from vw_rptpayment_item_detail x group by x.parentid,x.rptledgerfaasid,x.year,x.qtr,x.revperiod;
CREATE VIEW vw_rpu_assessment AS select r.objid AS objid,r.rputype AS rputype,dpc.objid AS dominantclass_objid,dpc.code AS dominantclass_code,dpc.name AS dominantclass_name,dpc.orderno AS dominantclass_orderno,ra.areasqm AS areasqm,ra.areaha AS areaha,ra.marketvalue AS marketvalue,ra.assesslevel AS assesslevel,ra.assessedvalue AS assessedvalue,ra.taxable AS taxable,au.code AS actualuse_code,au.name AS actualuse_name,auc.objid AS actualuse_objid,auc.code AS actualuse_classcode,auc.name AS actualuse_classname,auc.orderno AS actualuse_orderno from ((((rpu r join propertyclassification dpc on((r.classification_objid = dpc.objid))) join rpu_assessment ra on((r.objid = ra.rpuid))) join landassesslevel au on((ra.actualuse_objid = au.objid))) left join propertyclassification auc on((au.classification_objid = auc.objid))) union select r.objid AS objid,r.rputype AS rputype,dpc.objid AS dominantclass_objid,dpc.code AS dominantclass_code,dpc.name AS dominantclass_name,dpc.orderno AS dominantclass_orderno,ra.areasqm AS areasqm,ra.areaha AS areaha,ra.marketvalue AS marketvalue,ra.assesslevel AS assesslevel,ra.assessedvalue AS assessedvalue,ra.taxable AS taxable,au.code AS actualuse_code,au.name AS actualuse_name,auc.objid AS actualuse_objid,auc.code AS actualuse_classcode,auc.name AS actualuse_classname,auc.orderno AS actualuse_orderno from ((((rpu r join propertyclassification dpc on((r.classification_objid = dpc.objid))) join rpu_assessment ra on((r.objid = ra.rpuid))) join bldgassesslevel au on((ra.actualuse_objid = au.objid))) left join propertyclassification auc on((au.classification_objid = auc.objid))) union select r.objid AS objid,r.rputype AS rputype,dpc.objid AS dominantclass_objid,dpc.code AS dominantclass_code,dpc.name AS dominantclass_name,dpc.orderno AS dominantclass_orderno,ra.areasqm AS areasqm,ra.areaha AS areaha,ra.marketvalue AS marketvalue,ra.assesslevel AS assesslevel,ra.assessedvalue AS assessedvalue,ra.taxable AS taxable,au.code AS actualuse_code,au.name AS actualuse_name,auc.objid AS actualuse_objid,auc.code AS actualuse_classcode,auc.name AS actualuse_classname,auc.orderno AS actualuse_orderno from ((((rpu r join propertyclassification dpc on((r.classification_objid = dpc.objid))) join rpu_assessment ra on((r.objid = ra.rpuid))) join machassesslevel au on((ra.actualuse_objid = au.objid))) left join propertyclassification auc on((au.classification_objid = auc.objid))) union select r.objid AS objid,r.rputype AS rputype,dpc.objid AS dominantclass_objid,dpc.code AS dominantclass_code,dpc.name AS dominantclass_name,dpc.orderno AS dominantclass_orderno,ra.areasqm AS areasqm,ra.areaha AS areaha,ra.marketvalue AS marketvalue,ra.assesslevel AS assesslevel,ra.assessedvalue AS assessedvalue,ra.taxable AS taxable,au.code AS actualuse_code,au.name AS actualuse_name,auc.objid AS actualuse_objid,auc.code AS actualuse_classcode,auc.name AS actualuse_classname,auc.orderno AS actualuse_orderno from ((((rpu r join propertyclassification dpc on((r.classification_objid = dpc.objid))) join rpu_assessment ra on((r.objid = ra.rpuid))) join planttreeassesslevel au on((ra.actualuse_objid = au.objid))) left join propertyclassification auc on((au.classification_objid = auc.objid))) union select r.objid AS objid,r.rputype AS rputype,dpc.objid AS dominantclass_objid,dpc.code AS dominantclass_code,dpc.name AS dominantclass_name,dpc.orderno AS dominantclass_orderno,ra.areasqm AS areasqm,ra.areaha AS areaha,ra.marketvalue AS marketvalue,ra.assesslevel AS assesslevel,ra.assessedvalue AS assessedvalue,ra.taxable AS taxable,au.code AS actualuse_code,au.name AS actualuse_name,auc.objid AS actualuse_objid,auc.code AS actualuse_classcode,auc.name AS actualuse_classname,auc.orderno AS actualuse_orderno from ((((rpu r join propertyclassification dpc on((r.classification_objid = dpc.objid))) join rpu_assessment ra on((r.objid = ra.rpuid))) join miscassesslevel au on((ra.actualuse_objid = au.objid))) left join propertyclassification auc on((au.classification_objid = auc.objid)));
CREATE VIEW vw_txn_log AS select distinct u.objid AS userid,u.name AS username,t.txndate AS txndate,t.ref AS ref,t.action AS action,1 AS cnt from (txnlog t join sys_user u on((t.userid = u.objid))) union select u.objid AS userid,u.name AS username,t.enddate AS txndate,'faas' AS ref,(case when (t.state like '%receiver%') then 'receive' when (t.state like '%examiner%') then 'examine' when (t.state like '%taxmapper_chief%') then 'approve taxmap' when (t.state like '%taxmapper%') then 'taxmap' when (t.state like '%appraiser%') then 'appraise' when (t.state like '%appraiser_chief%') then 'approve appraisal' when (t.state like '%recommender%') then 'recommend' when (t.state like '%approver%') then 'approve' else t.state end) AS action,1 AS cnt from (faas_task t join sys_user u on((t.actor_objid = u.objid))) where (not((t.state like '%assign%'))) union select u.objid AS userid,u.name AS username,t.enddate AS txndate,'subdivision' AS ref,(case when (t.state like '%receiver%') then 'receive' when (t.state like '%examiner%') then 'examine' when (t.state like '%taxmapper_chief%') then 'approve taxmap' when (t.state like '%taxmapper%') then 'taxmap' when (t.state like '%appraiser%') then 'appraise' when (t.state like '%appraiser_chief%') then 'approve appraisal' when (t.state like '%recommender%') then 'recommend' when (t.state like '%approver%') then 'approve' else t.state end) AS action,1 AS cnt from (subdivision_task t join sys_user u on((t.actor_objid = u.objid))) where (not((t.state like '%assign%'))) union select u.objid AS userid,u.name AS username,t.enddate AS txndate,'consolidation' AS ref,(case when (t.state like '%receiver%') then 'receive' when (t.state like '%examiner%') then 'examine' when (t.state like '%taxmapper_chief%') then 'approve taxmap' when (t.state like '%taxmapper%') then 'taxmap' when (t.state like '%appraiser%') then 'appraise' when (t.state like '%appraiser_chief%') then 'approve appraisal' when (t.state like '%recommender%') then 'recommend' when (t.state like '%approver%') then 'approve' else t.state end) AS action,1 AS cnt from (subdivision_task t join sys_user u on((t.actor_objid = u.objid))) where (not((t.state like '%consolidation%'))) union select u.objid AS userid,u.name AS username,t.enddate AS txndate,'cancelledfaas' AS ref,(case when (t.state like '%receiver%') then 'receive' when (t.state like '%examiner%') then 'examine' when (t.state like '%taxmapper_chief%') then 'approve taxmap' when (t.state like '%taxmapper%') then 'taxmap' when (t.state like '%appraiser%') then 'appraise' when (t.state like '%appraiser_chief%') then 'approve appraisal' when (t.state like '%recommender%') then 'recommend' when (t.state like '%approver%') then 'approve' else t.state end) AS action,1 AS cnt from (subdivision_task t join sys_user u on((t.actor_objid = u.objid))) where (not((t.state like '%cancelledfaas%')));




alter table rpu add stewardparentrpumasterid varchar(50)
go 

