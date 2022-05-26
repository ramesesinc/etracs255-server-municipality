use etracs255_tangalan;


-- ## patch-01

drop table if exists zpatch20181120_sys_usergroup_permission; 
drop table if exists zpatch20181120_sys_usergroup; 

CREATE TABLE `zpatch20181120_sys_usergroup` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(255) NULL,
  `domain` varchar(25) NULL,
  `userclass` varchar(25) NULL,
  `orgclass` varchar(50) NULL,
  `role` varchar(50) NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB 
;

CREATE TABLE `zpatch20181120_sys_usergroup_permission` (
  `objid` varchar(100) NOT NULL,
  `usergroup_objid` varchar(50) NULL,
  `object` varchar(25) NULL,
  `permission` varchar(25) NULL,
  `title` varchar(50) NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_usergroup_objid` (`usergroup_objid`),
  CONSTRAINT `fk_zpatch20181120_sys_usergroup_permission_parent` FOREIGN KEY (`usergroup_objid`) REFERENCES `zpatch20181120_sys_usergroup` (`objid`) 
) ENGINE=InnoDB 
;


INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('ADMIN.NOTIFICATION', 'SYSTEM ADMINISTRATOR', 'ADMIN', 'usergroup', NULL, 'NOTIFICATION');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('ADMIN.SYSADMIN', 'SYSTEM ADMINISTRATOR', 'ADMIN', 'usergroup', NULL, 'SYSADMIN');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('DEVELOPER.REPORT', 'SYSTEM ADMINISTRATOR', 'DEVELOPER', 'usergroup', NULL, 'REPORT');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('ENTERPRISE.MASTER', 'ENTERPRISE MASTER', 'ENTERPRISE', 'usergroup', NULL, 'MASTER');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('ENTITY.ADMIN', 'ENTITY ADMIN', 'ENTITY', 'usergroup', NULL, 'ADMIN');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('ENTITY.APPROVER', 'ENTITY APPROVER', 'ENTITY', 'usergroup', NULL, 'APPROVER');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('ENTITY.MASTER', 'ENTITY MASTER', 'ENTITY', 'usergroup', NULL, 'MASTER');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('FINANCIAL.ADMIN', 'FINANCIAL ADMIN', 'FINANCIAL', 'usergroup', NULL, 'ADMIN');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('FINANCIAL.COLLECTOR', 'FINANCIAL', 'FINANCIAL', 'usergroup', NULL, 'COLLECTOR');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('FINANCIAL.MASTER', 'FINANCIAL MASTER', 'FINANCIAL', 'usergroup', NULL, 'MASTER');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('FINANCIAL.REPORT', 'FINANCIAL REPORT', 'FINANCIAL', 'usergroup', NULL, 'REPORT');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('RULEMGMT.MASTER', 'RULEMGMT MASTER', 'RULEMGMT', 'usergroup', NULL, 'MASTER');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('TREASURY.ADMIN', 'TREASURY ADMIN', 'TREASURY', 'usergroup', NULL, 'ADMIN');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('TREASURY.AFO', 'ACCOUNTABLE FORM OFFICER', 'TREASURY', 'usergroup', NULL, 'AFO');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('TREASURY.APPROVER', 'TREASURY APPROVER', 'TREASURY', 'usergroup', NULL, 'APPROVER');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('TREASURY.CASHIER', 'CASHIER', 'TREASURY', 'usergroup', NULL, 'CASHIER');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('TREASURY.COLLECTOR', 'COLLECTOR', 'TREASURY', 'usergroup', NULL, 'COLLECTOR');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('TREASURY.DATA_CONTROLLER', 'TREASURY DATA CONTROLLER', 'TREASURY', 'usergroup', NULL, 'DATA_CONTROLLER');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('TREASURY.LIQUIDATING_OFFICER', 'LIQUIDATING OFFICER', 'TREASURY', 'usergroup', NULL, 'LIQUIDATING_OFFICER');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('TREASURY.MASTER', 'TREASURY MASTER', 'TREASURY', 'usergroup', NULL, 'MASTER');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('TREASURY.REPORT', 'TREASURY REPORT', 'TREASURY', 'usergroup', NULL, 'REPORT');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('TREASURY.RIS_APPROVER', 'TREASURY RIS_APPROVER', 'TREASURY', 'usergroup', NULL, 'RIS_APPROVER');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('TREASURY.RULE_AUTHOR', 'TREASURY RULE AUTHOR', 'TREASURY', 'usergroup', NULL, 'RULE_AUTHOR');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('TREASURY.SHARED', 'TREASURY SHARED', 'TREASURY', 'usergroup', NULL, 'SHARED');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('TREASURY.SUBCOLLECTOR', 'SUBCOLLECTOR', 'TREASURY', 'usergroup', NULL, 'SUBCOLLECTOR');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('WORKFLOW.ADMIN', 'WORKFLOW ADMIN', 'WORKFLOW', 'usergroup', NULL, 'ADMIN');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('WORKFLOW.MASTER', 'WORKFLOW MASTER', 'WORKFLOW', 'usergroup', NULL, 'MASTER');
INSERT INTO zpatch20181120_sys_usergroup (`objid`, `title`, `domain`, `userclass`, `orgclass`, `role`) VALUES ('EPAYMENT.MASTER', 'EPAYMENT MASTER', 'EPAYMENT', 'usergroup', NULL, 'MASTER');

INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('ENTITY-MASTER-createIndividual', 'ENTITY.MASTER', 'individualentity', 'create', 'Create');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('ENTITY-MASTER-createJuridical', 'ENTITY.MASTER', 'juridicalentity', 'create', 'Create');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('ENTITY-MASTER-createMultiple', 'ENTITY.MASTER', 'multipleentity', 'create', 'Create');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('ENTITY-MASTER-deleteIndividual', 'ENTITY.MASTER', 'individualentity', 'delete', 'Delete');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('ENTITY-MASTER-deleteJuridical', 'ENTITY.MASTER', 'juridicalentity', 'delete', 'Delete');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('ENTITY-MASTER-deleteMultiple', 'ENTITY.MASTER', 'multipleentity', 'delete', 'Delete');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('ENTITY-MASTER-editIndividual', 'ENTITY.MASTER', 'individualentity', 'edit', 'Edit');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('ENTITY-MASTER-editJuridical', 'ENTITY.MASTER', 'juridicalentity', 'edit', 'Edit');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('ENTITY-MASTER-editMultiple', 'ENTITY.MASTER', 'multipleentity', 'edit', 'Edit');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('ENTITY-MASTER-editname', 'ENTITY.MASTER', 'individualentity', 'editname', 'Edit Name');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('ENTITY-MASTER-openIndividual', 'ENTITY.MASTER', 'individualentity', 'open', 'Open');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('ENTITY-MASTER-openJuridical', 'ENTITY.MASTER', 'juridicalentity', 'open', 'Open');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('ENTITY-MASTER-openMultiple', 'ENTITY.MASTER', 'multipleentity', 'open', 'Open');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('SUBCOLLECTOR-DISAPPROVED', 'TREASURY.SUBCOLLECTOR', 'batchcapture', 'disapprove', 'disapprove');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('SUBCOLLECTOR-POST', 'TREASURY.SUBCOLLECTOR', 'batchcapture', 'post', 'post');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-ADMIN-receipt-void', 'TREASURY.ADMIN', 'receipt', 'void', 'Void Receipt');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-AFO-afserial-forward', 'TREASURY.AFO', 'afserial', 'forward', 'Forward');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-AFO-cashticket-forward', 'TREASURY.AFO', 'cashticket', 'forward', 'Forward');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-COLLECTOR', 'TREASURY.COLLECTOR', 'receipt', 'online', 'online');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-COLLECTOR-receipt-void', 'TREASURY.COLLECTOR', 'receipt', 'void', 'Void Receipt');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-DATA_CONTROLLER-batchcapture-manage', 'TREASURY.DATA_CONTROLLER', 'batchcapture', 'manage', 'Manage Batch Capture');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-LIQUIDATING_OFFICER', 'TREASURY.LIQUIDATING_OFFICER', 'cashbook', 'list', 'list');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-createbank', 'TREASURY.MASTER', 'bank', 'create', 'Create');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-createcashbook', 'TREASURY.MASTER', 'cashbook', 'create', 'Create');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-createcollectiongroup', 'TREASURY.MASTER', 'collectiongroup', 'create', 'Create');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-createcollectiontype', 'TREASURY.MASTER', 'collectiontype', 'create', 'Create');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-createFund', 'TREASURY.MASTER', 'fund', 'create', 'Create');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-createRevenueItem', 'TREASURY.MASTER', 'revenueitem', 'create', 'Create');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-createsreaccount', 'TREASURY.MASTER', 'sreaccount', 'create', 'Create');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-deletebank', 'TREASURY.MASTER', 'bank', 'delete', 'Delete');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-deletecashbook', 'TREASURY.MASTER', 'cashbook', 'delete', 'Delete');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-deletecollectiongroup', 'TREASURY.MASTER', 'collectiongroup', 'delete', 'Delete');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-deletecollectiontype', 'TREASURY.MASTER', 'collectiontype', 'delete', 'Delete');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-deleteFund', 'TREASURY.MASTER', 'fund', 'delete', 'Delete');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-deleteRevenueItem', 'TREASURY.MASTER', 'revenueitem', 'delete', 'Delete');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-deletesreaccount', 'TREASURY.MASTER', 'sreaccount', 'delete', 'Delete');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-editbank', 'TREASURY.MASTER', 'bank', 'edit', 'Edit');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-editcashbook', 'TREASURY.MASTER', 'cashbook', 'edit', 'Edit');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-editcollectiongroup', 'TREASURY.MASTER', 'collectiongroup', 'edit', 'Edit');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-editcollectiontype', 'TREASURY.MASTER', 'collectiontype', 'edit', 'Edit');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-editFund', 'TREASURY.MASTER', 'fund', 'edit', 'Edit');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-editRevenueItem', 'TREASURY.MASTER', 'revenueitem', 'edit', 'Edit');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-editsreaccount', 'TREASURY.MASTER', 'sreaccount', 'edit', 'Edit');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-openbank', 'TREASURY.MASTER', 'bank', 'open', 'Open');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-opencashbook', 'TREASURY.MASTER', 'cashbook', 'open', 'Open');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-opencollectiongroup', 'TREASURY.MASTER', 'collectiongroup', 'open', 'Open');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-opencollectiontype', 'TREASURY.MASTER', 'collectiontype', 'open', 'Open');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-openFund', 'TREASURY.MASTER', 'fund', 'open', 'Open');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-openRevenueItem', 'TREASURY.MASTER', 'revenueitem', 'open', 'Open');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-opensreaccount', 'TREASURY.MASTER', 'sreaccount', 'open', 'Open');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-viewbank', 'TREASURY.MASTER', 'bank', 'view', 'View');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-viewcashbook', 'TREASURY.MASTER', 'cashbook', 'view', 'View');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-viewcollectiongroup', 'TREASURY.MASTER', 'collectiongroup', 'view', 'View');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-viewcollectiontype', 'TREASURY.MASTER', 'collectiontype', 'view', 'View');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-viewFund', 'TREASURY.MASTER', 'fund', 'view', 'View');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-viewRevenueItem', 'TREASURY.MASTER', 'revenueitem', 'view', 'View');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-MASTER-viewsreaccount', 'TREASURY.MASTER', 'sreaccount', 'view', 'View');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-REPORT-collectionbyfund-viewreport', 'TREASURY.REPORT', 'collectionbyfund', 'viewreport', 'View Report');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-REPORT-directtocash-viewreport', 'TREASURY.REPORT', 'directtocash', 'viewreport', 'View Report');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-REPORT-srs-viewreport', 'TREASURY.REPORT', 'srs', 'viewreport', 'View Report');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-REPORT-statementofrevenue-viewreport', 'TREASURY.REPORT', 'statementofrevenue', 'viewreport', 'View Report');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-SHARED-bankdeposit-view', 'TREASURY.SHARED', 'bankdeposit', 'view', 'View List');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-SHARED-liquidation-view', 'TREASURY.SHARED', 'liquidation', 'view', 'View List');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-SHARED-remittance-view', 'TREASURY.SHARED', 'remittance', 'view', 'View List');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY-SUBCOLLECTOR-receipt-void', 'TREASURY.SUBCOLLECTOR', 'receipt', 'void', 'Void Receipt');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY.ADMIN.checkpayment_dishonored.view', 'TREASURY.ADMIN', 'checkpayment_dishonored', 'view', 'View Dishonored Checks');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY.CASHIER.checkpayment_dishonored.view', 'TREASURY.CASHIER', 'checkpayment_dishonored', 'view', 'View Dishonored Checks');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY.COLLECTOR.cashreceipt.convertCashToCheck', 'TREASURY.COLLECTOR', 'cashreceipt', 'convertCashToCheck', 'Convert Cash To Check');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY.COLLECTOR.cashreceipt.convertCheckToCash', 'TREASURY.COLLECTOR', 'cashreceipt', 'convertCheckToCash', 'Convert Check To Cash');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY.SHARED.checkpayment_dishonored.view', 'TREASURY.SHARED', 'checkpayment_dishonored', 'view', 'View Dishonored Checks');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY.SUBCOLLECTOR.cashreceipt.convertCashToCheck', 'TREASURY.SUBCOLLECTOR', 'cashreceipt', 'convertCashToCheck', 'Convert Cash To Check');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('TREASURY.SUBCOLLECTOR.cashreceipt.convertCheckToCash', 'TREASURY.SUBCOLLECTOR', 'cashreceipt', 'convertCheckToCash', 'Convert Check To Cash');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS-4bed8ed4:1679ca684b3:-7510', 'TREASURY.APPROVER', 'cashreceipt', 'approve_void', 'Void Cash Receipt');
INSERT INTO zpatch20181120_sys_usergroup_permission (`objid`, `usergroup_objid`, `object`, `permission`, `title`) VALUES ('USRGRPPERMS-4bed8ed4:1679ca684b3:-759f', 'TREASURY.APPROVER', 'cashreceipt', 'approve_reprint', 'Reprint Cash Receipt');


alter table sys_usergroup_permission modify objid varchar(100) not null 
; 
alter table sys_securitygroup modify objid varchar(100) not null 
;


insert ignore into sys_usergroup ( 
  objid, title, domain, userclass, orgclass, role 
) 
select 
  objid, title, domain, userclass, orgclass, role 
from zpatch20181120_sys_usergroup z 
where objid not in (select objid from sys_usergroup where objid = z.objid)
; 

insert ignore into sys_usergroup_permission ( 
  objid, usergroup_objid, object, permission, title 
) 
select 
  objid, usergroup_objid, object, permission, title 
from zpatch20181120_sys_usergroup_permission z 
where objid not in (select objid from sys_usergroup_permission where objid = z.objid) 
; 

update sys_usergroup_permission set object='entityindividual' where object = 'individualentity'; 
update sys_usergroup_permission set object='entityjuridical' where usergroup_objid = 'ENTITY.MASTER' and object like '%juridical%';
update sys_usergroup_permission set object='entitymultiple' where usergroup_objid = 'ENTITY.MASTER' and object like '%multiple%';

update sys_usergroup_member set usergroup_objid='FINANCIAL.MASTER' where usergroup_objid='ACCOUNTING.MASTER';
update sys_usergroup_member set usergroup_objid='FINANCIAL.REPORT' where usergroup_objid='ACCOUNTING.REPORT';

insert ignore into sys_usergroup_member ( 
  objid, state, usergroup_objid, user_objid, user_username, user_firstname, user_lastname, 
  org_objid, org_name, org_orgclass, securitygroup_objid, exclude, displayname, jobtitle 
) 
select * from ( 
  select 
    concat('UGM-', md5(concat('FINANCIAL.MASTER|', ugm.user_objid, '|', IFNULL(ugm.org_objid,'_')))) as objid, 
    null as state, 'FINANCIAL.MASTER' as usergroup_objid, ugm.user_objid, 
    ugm.user_username, ugm.user_firstname, ugm.user_lastname, 
    ugm.org_objid, ugm.org_name, ugm.org_orgclass, ugm.securitygroup_objid, 
    ugm.exclude, ugm.displayname, ugm.jobtitle 
  from sys_usergroup_member ugm 
  where ugm.usergroup_objid = 'TREASURY.MASTER'
)t1 
; 

drop table if exists zpatch20181120_sys_usergroup_permission; 
drop table if exists zpatch20181120_sys_usergroup; 

delete from sys_securitygroup where usergroup_objid like 'ACCOUNTING%';
delete from sys_usergroup_permission where usergroup_objid like 'ACCOUNTING%';
delete from sys_usergroup where objid like 'ACCOUNTING%';



-- ## patch-02

rename table af_inventory_return to z20181120_af_inventory_return ; 
rename table af_inventory_detail_cancelseries to z20181120_af_inventory_detail_cancelseries ; 
rename table af_inventory_detail to z20181120_af_inventory_detail ; 
rename table af_inventory to z20181120_af_inventory ; 


rename table ap_detail to z20181120_ap_detail ; 
rename table ap to z20181120_ap ; 
rename table ar_detail to z20181120_ar_detail ; 
rename table ar to z20181120_ar ; 


rename table bankaccount_entry to z20181120_bankaccount_entry ; 
rename table bankaccount_account to z20181120_bankaccount_account ; 


rename table bankdeposit_liquidation to z20181120_bankdeposit_liquidation ; 
rename table bankdeposit_entry_check to z20181120_bankdeposit_entry_check ; 
rename table bankdeposit_entry to z20181120_bankdeposit_entry ; 
rename table bankdeposit to z20181120_bankdeposit ; 


rename table cashbook_entry to z20181120_cashbook_entry ; 
rename table cashbook to z20181120_cashbook ; 


rename table directcash_collection_item to z20181120_directcash_collection_item ; 
rename table directcash_collection to z20181120_directcash_collection ; 


rename table liquidation_remittance to z20181120_liquidation_remittance ; 
rename table liquidation_noncashpayment to z20181120_liquidation_noncashpayment ; 
rename table liquidation_creditmemopayment to z20181120_liquidation_creditmemopayment ; 
rename table liquidation_cashier_fund to z20181120_liquidation_cashier_fund ; 
rename table liquidation to z20181120_liquidation ; 


rename table ngas_revenue_deposit to z20181120_ngas_revenue_deposit ; 
rename table ngas_revenue_remittance to z20181120_ngas_revenue_remittance ; 
rename table ngas_revenueitem to z20181120_ngas_revenueitem ; 
rename table ngas_revenue to z20181120_ngas_revenue ; 


rename table remittance_noncashpayment to z20181120_remittance_noncashpayment ; 
rename table remittance_creditmemopayment to z20181120_remittance_creditmemopayment ; 
rename table remittance_cashreceipt to z20181120_remittance_cashreceipt ; 


rename table stockissueitem to z20181120_stockissueitem ; 
rename table stockissue to z20181120_stockissue ; 

rename table stockreceiptitem to z20181120_stockreceiptitem ; 
rename table stockreceipt to z20181120_stockreceipt ; 

rename table stocksaleitem to z20181120_stocksaleitem ; 
rename table stocksale to z20181120_stocksale ; 

rename table stockrequestitem to z20181120_stockrequestitem ; 
rename table stockrequest to z20181120_stockrequest ; 

-- rename table stockreturn to z20181120_stockreturn ; 

rename table stockitem_unit to z20181120_stockitem_unit ; 
rename table stockitem to z20181120_stockitem ; 

rename table eor_paymentorder to z20181120_eor_paymentorder;
rename table payment_partner to z20181120_payment_partner; 

drop table if exists draft_remittance_cashreceipt; 
drop table if exists draft_remittance; 

rename table cashreceiptpayment_eor to z20181120_cashreceiptpayment_eor;

rename table account to z20181120_account;
rename table account_incometarget to z20181120_account_incometarget;



-- ## patch-03

drop table if exists account_incometarget;
drop table if exists account; 

CREATE TABLE `account_maingroup` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `version` int(11) NOT NULL,
  `reporttype` varchar(50) NULL,
  `role` varchar(50) NULL,
  `domain` varchar(50) NULL,
  `system` int(11) NULL,
  constraint pk_account_maingroup PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 
;

CREATE TABLE `account` (
  `objid` varchar(50) NOT NULL,
  `maingroupid` varchar(50) NULL,
  `code` varchar(100) NULL,
  `title` varchar(255) NULL,
  `groupid` varchar(50) NULL,
  `type` varchar(50) NULL,
  `leftindex` int(11) NULL,
  `rightindex` int(11) NULL,
  `level` int(11) NULL,
  constraint pk_account PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8 
;
create index `ix_maingroupid` on account (`maingroupid`) ; 
create index `ix_code` on account (`code`) ; 
create index `ix_title` on account (`title`) ; 
create index `ix_groupid` on account (`groupid`) ; 
create index `uix_account_code` on account (`maingroupid`,`code`) ; 


CREATE TABLE `account_item_mapping` (
  `objid` varchar(50) NOT NULL,
  `maingroupid` varchar(50) NULL,
  `acctid` varchar(50) NULL,
  `itemid` varchar(50) NULL,
  constraint pk_account_item_mapping PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8 
;
create index `ix_maingroupid` on account_item_mapping (`maingroupid`) ; 
create index `ix_acctid` on account_item_mapping (`acctid`) ; 
create index `ix_itemid` on account_item_mapping (`itemid`) ; 


create table account_incometarget (
  objid varchar(50) not null, 
  itemid varchar(50) not null, 
  year int not null, 
  target decimal(16,2) not null, 
  constraint pk_account_incometarget primary key (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 
; 
create index ix_itemid on account_incometarget (itemid); 
create index ix_year on account_incometarget (year); 


INSERT INTO `account_maingroup` (`objid`, `title`, `version`, `reporttype`, `role`, `domain`, `system`) VALUES ('NGAS', 'NGAS', '1', 'NGAS', NULL, NULL, NULL);
INSERT INTO `account_maingroup` (`objid`, `title`, `version`, `reporttype`, `role`, `domain`, `system`) VALUES ('PPSAS', 'PPSAS', '1', 'PPSAS', NULL, NULL, '0');
INSERT INTO `account_maingroup` (`objid`, `title`, `version`, `reporttype`, `role`, `domain`, `system`) VALUES ('SRE', 'SRE', '0', 'SRE', NULL, NULL, NULL);


INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-1', 'PPSAS', '1', 'Assets', 'root', '0', '673', '1', NULL);
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-2', 'PPSAS', '2', 'Liabilities', 'root', '674', '787', '1', NULL);
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-3', 'PPSAS', '3', 'Equity', 'root', '788', '815', '1', NULL);
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-4', 'PPSAS', '4', 'Income', 'root', '816', '1049', '1', NULL);
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-5', 'PPSAS', '5', 'Expenses', 'root', '1050', '1405', '1', NULL);
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-101', 'PPSAS', '101', 'Cash', 'group', '1', '20', '2', 'PPSAS-1');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-102', 'PPSAS', '102', 'Investments', 'group', '21', '76', '2', 'PPSAS-1');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-103', 'PPSAS', '103', 'Receivables', 'group', '77', '180', '2', 'PPSAS-1');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-104', 'PPSAS', '104', 'Inventories', 'group', '181', '246', '2', 'PPSAS-1');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-104040105', 'PPSAS', '104040105', 'Prepayments and Deferred Charges', 'item', '247', '248', '2', 'PPSAS-1');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-105', 'PPSAS', '105', 'Prepayments and Deferred Charges', 'group', '249', '268', '2', 'PPSAS-1');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-106', 'PPSAS', '106', 'Investment Property', 'group', '269', '284', '2', 'PPSAS-1');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-107', 'PPSAS', '107', 'Property, Plant and Equipment', 'group', '285', '634', '2', 'PPSAS-1');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-108', 'PPSAS', '108', 'Biological Assets', 'group', '635', '646', '2', 'PPSAS-1');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-109', 'PPSAS', '109', 'Intangible Assets', 'group', '647', '672', '2', 'PPSAS-1');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10101', 'PPSAS', '10101', 'Cash on Hand', 'group', '2', '7', '3', 'PPSAS-101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10102', 'PPSAS', '10102', 'Cash in Bank - Local Currency', 'group', '8', '13', '3', 'PPSAS-101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10103', 'PPSAS', '10103', 'Cash in Bank - Foreign Currency', 'group', '14', '19', '3', 'PPSAS-101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10101010', 'PPSAS', '10101010', 'Cash Local Treasury', 'item', '3', '4', '4', 'PPSAS-10101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10101020', 'PPSAS', '10101020', 'Petty Cash', 'item', '5', '6', '4', 'PPSAS-10101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10102010', 'PPSAS', '10102010', 'Cash in Bank - Local Currency, Current Account', 'item', '9', '10', '4', 'PPSAS-10102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10102020', 'PPSAS', '10102020', 'Cash in Bank - Local Currency, Savings Account', 'item', '11', '12', '4', 'PPSAS-10102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10103010', 'PPSAS', '10103010', 'Cash in Bank - Foreign Currency, Current Account', 'item', '15', '16', '4', 'PPSAS-10103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10103020', 'PPSAS', '10103020', 'Cash in Bank - Foreign Currency, Savings Account', 'item', '17', '18', '4', 'PPSAS-10103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10201', 'PPSAS', '10201', 'Investments in Time Deposits', 'group', '22', '29', '3', 'PPSAS-102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10202', 'PPSAS', '10202', 'Financial  Assets at Fair Value Through Surplus or Deficit', 'group', '30', '35', '3', 'PPSAS-102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10203', 'PPSAS', '10203', 'Financial Assets - Held to Maturity', 'group', '36', '45', '3', 'PPSAS-102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10204', 'PPSAS', '10204', 'Financial Assets - Available for Sale', 'group', '46', '51', '3', 'PPSAS-102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10205', 'PPSAS', '10205', 'Financial Assets - Others', 'group', '52', '65', '3', 'PPSAS-102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10206', 'PPSAS', '10206', 'Investments in Joint Venture', 'group', '66', '71', '3', 'PPSAS-102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10207', 'PPSAS', '10207', 'Sinking Fund', 'group', '72', '75', '3', 'PPSAS-102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10201010', 'PPSAS', '10201010', 'Cash in Bank -Local Currency, Time Deposits', 'item', '23', '24', '4', 'PPSAS-10201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10201020', 'PPSAS', '10201020', 'Cash in Bank - Foreign Currency, Time Deposits', 'item', '25', '26', '4', 'PPSAS-10201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10201030', 'PPSAS', '10201030', 'Treasury Bills', 'item', '27', '28', '4', 'PPSAS-10201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10202010', 'PPSAS', '10202010', 'Financial Assets Held for Trading', 'item', '31', '32', '4', 'PPSAS-10202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10202020', 'PPSAS', '10202020', 'Financial  Assets Designated at Fair Value Through Surplus or Deficit', 'item', '33', '34', '4', 'PPSAS-10202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10203010', 'PPSAS', '10203010', 'Investments in Treasury Bills - Local', 'item', '37', '38', '4', 'PPSAS-10203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10203011', 'PPSAS', '10203011', 'Allowance for Impairment - Investments in Treasury Bills - Local', 'item', '39', '40', '4', 'PPSAS-10203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10203020', 'PPSAS', '10203020', 'Investments in  Bonds-Local', 'item', '41', '42', '4', 'PPSAS-10203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10203021', 'PPSAS', '10203021', 'Allowance for Impairment - Investments in Bonds - Local', 'item', '43', '44', '4', 'PPSAS-10203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10204010', 'PPSAS', '10204010', 'Investments in Stocks', 'item', '47', '48', '4', 'PPSAS-10204');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10204020', 'PPSAS', '10204020', 'Investments in Bonds', 'item', '49', '50', '4', 'PPSAS-10204');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10205010', 'PPSAS', '10205010', 'Deposits on Letters of Credit', 'item', '53', '54', '4', 'PPSAS-10205');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10205011', 'PPSAS', '10205011', 'Allowance for Impairment - Deposits in Letters of Credit', 'item', '55', '56', '4', 'PPSAS-10205');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10205020', 'PPSAS', '10205020', 'Guaranty Deposits', 'item', '57', '58', '4', 'PPSAS-10205');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10205021', 'PPSAS', '10205021', 'Allowance for Impairment - Guaranty Deposits', 'item', '59', '60', '4', 'PPSAS-10205');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10205990', 'PPSAS', '10205990', 'Other Investments', 'item', '61', '62', '4', 'PPSAS-10205');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10205991', 'PPSAS', '10205991', 'Allowance for Impairment - Other Investments', 'item', '63', '64', '4', 'PPSAS-10205');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10206010', 'PPSAS', '10206010', 'Investments in Joint Venture', 'item', '67', '68', '4', 'PPSAS-10206');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10206011', 'PPSAS', '10206011', 'Allowance for Impairment - Investments in Joint Venture', 'item', '69', '70', '4', 'PPSAS-10206');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10207010', 'PPSAS', '10207010', 'Sinking Fund', 'item', '73', '74', '4', 'PPSAS-10207');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301', 'PPSAS', '10301', 'Loans and Receivable Accounts', 'group', '78', '115', '3', 'PPSAS-103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10302', 'PPSAS', '10302', 'Lease  Receivables', 'group', '116', '125', '3', 'PPSAS-103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10303', 'PPSAS', '10303', 'Inter-Agency Receivables', 'group', '126', '143', '3', 'PPSAS-103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10304', 'PPSAS', '10304', 'Intra-Agency Receivables', 'group', '144', '151', '3', 'PPSAS-103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10305', 'PPSAS', '10305', 'Advances', 'group', '152', '161', '3', 'PPSAS-103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10306', 'PPSAS', '10306', 'Other Receivables', 'group', '162', '179', '3', 'PPSAS-103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301010', 'PPSAS', '10301010', 'Accounts Receivable', 'item', '79', '80', '4', 'PPSAS-10301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301011', 'PPSAS', '10301011', 'Allowance for Impairment - Accounts Receivable', 'item', '81', '82', '4', 'PPSAS-10301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301020', 'PPSAS', '10301020', 'Real Property Tax Receivable', 'item', '83', '84', '4', 'PPSAS-10301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301021', 'PPSAS', '10301021', 'Allowance for Impairment - RPT Receivable', 'item', '85', '86', '4', 'PPSAS-10301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301030', 'PPSAS', '10301030', 'Special Education Tax Receivable', 'item', '87', '88', '4', 'PPSAS-10301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301031', 'PPSAS', '10301031', 'Allowance for Impairment - SET Receivable', 'item', '89', '90', '4', 'PPSAS-10301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301040', 'PPSAS', '10301040', 'Notes Receivable', 'item', '91', '92', '4', 'PPSAS-10301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301041', 'PPSAS', '10301041', 'Allowance for Impairment - Notes Receivable', 'item', '93', '94', '4', 'PPSAS-10301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301050', 'PPSAS', '10301050', 'Loans Receivable - Government-Owned and/or Controlled Corporations', 'item', '95', '96', '4', 'PPSAS-10301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301051', 'PPSAS', '10301051', 'Allowance for Impairment - Loans Receivable - Government-Owned and/or Controlled Corporations', 'item', '97', '98', '4', 'PPSAS-10301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301060', 'PPSAS', '10301060', 'Loans Receivable - Local Government Units', 'item', '99', '100', '4', 'PPSAS-10301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301061', 'PPSAS', '10301061', 'Allowance for Impairment  - Loans Receivable - Local Government Units', 'item', '101', '102', '4', 'PPSAS-10301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301070', 'PPSAS', '10301070', 'Interests Receivable', 'item', '103', '104', '4', 'PPSAS-10301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301071', 'PPSAS', '10301071', 'Allowance for Impairment - Interests Receivable', 'item', '105', '106', '4', 'PPSAS-10301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301080', 'PPSAS', '10301080', 'Dividends Receivable', 'item', '107', '108', '4', 'PPSAS-10301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301081', 'PPSAS', '10301081', 'Allowance for Impairment - Dividends Receivable', 'item', '109', '110', '4', 'PPSAS-10301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301990', 'PPSAS', '10301990', 'Loans Receivable - Others', 'item', '111', '112', '4', 'PPSAS-10301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10301991', 'PPSAS', '10301991', 'Allowance for Impairment - Loans Receivable - Others', 'item', '113', '114', '4', 'PPSAS-10301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10302010', 'PPSAS', '10302010', 'Operating Lease  Receivable', 'item', '117', '118', '4', 'PPSAS-10302');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10302011', 'PPSAS', '10302011', 'Allowance for Impairment - Operating Lease Receivable', 'item', '119', '120', '4', 'PPSAS-10302');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10302020', 'PPSAS', '10302020', 'Finance Lease Receivable', 'item', '121', '122', '4', 'PPSAS-10302');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10302021', 'PPSAS', '10302021', 'Allowance for Impairment - Finance Lease Receivable', 'item', '123', '124', '4', 'PPSAS-10302');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10303010', 'PPSAS', '10303010', 'Due from National Government Agencies', 'item', '127', '128', '4', 'PPSAS-10303');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10303011', 'PPSAS', '10303011', 'Allowance for Impairment - Due from National Government Agencies', 'item', '129', '130', '4', 'PPSAS-10303');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10303020', 'PPSAS', '10303020', 'Due from Government-Owned and/or Controlled Corporations', 'item', '131', '132', '4', 'PPSAS-10303');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10303021', 'PPSAS', '10303021', 'Allowance for Impairment - Due from GOCCs', 'item', '133', '134', '4', 'PPSAS-10303');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10303030', 'PPSAS', '10303030', 'Due from Local Government Units', 'item', '135', '136', '4', 'PPSAS-10303');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10303031', 'PPSAS', '10303031', 'Allowance for Impairment - Due from LGUs', 'item', '137', '138', '4', 'PPSAS-10303');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10303040', 'PPSAS', '10303040', 'Due from Joint Venture', 'item', '139', '140', '4', 'PPSAS-10303');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10303041', 'PPSAS', '10303041', 'Allowance for Impairment - Due from Joint Venture', 'item', '141', '142', '4', 'PPSAS-10303');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10304050', 'PPSAS', '10304050', 'Due from Other Funds', 'item', '145', '146', '4', 'PPSAS-10304');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10304060', 'PPSAS', '10304060', 'Due from Special Accounts', 'item', '147', '148', '4', 'PPSAS-10304');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10304070', 'PPSAS', '10304070', 'Due from Local Economic Enterprise', 'item', '149', '150', '4', 'PPSAS-10304');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10305010', 'PPSAS', '10305010', 'Advances for Operating Expenses', 'item', '153', '154', '4', 'PPSAS-10305');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10305020', 'PPSAS', '10305020', 'Advances for Payroll', 'item', '155', '156', '4', 'PPSAS-10305');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10305030', 'PPSAS', '10305030', 'Advances to Special Disbursing Officer', 'item', '157', '158', '4', 'PPSAS-10305');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10305040', 'PPSAS', '10305040', 'Advances for Officers and Employees', 'item', '159', '160', '4', 'PPSAS-10305');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10306010', 'PPSAS', '10306010', 'Receivables - Disallowances/Charges', 'item', '163', '164', '4', 'PPSAS-10306');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10306011', 'PPSAS', '10306011', 'Allowance for Impairment - Receivables- Disallowances/Charges', 'item', '165', '166', '4', 'PPSAS-10306');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10306020', 'PPSAS', '10306020', 'Due from Officers and Employees', 'item', '167', '168', '4', 'PPSAS-10306');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10306021', 'PPSAS', '10306021', 'Allowance for Impairment - Due from Officers and Employees', 'item', '169', '170', '4', 'PPSAS-10306');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10306030', 'PPSAS', '10306030', 'Due from Non-Government Organizations/People''s Organizations', 'item', '171', '172', '4', 'PPSAS-10306');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10306031', 'PPSAS', '10306031', 'Allowance for Impairment - Due from Non-Government Organizations/People''s Organizations', 'item', '173', '174', '4', 'PPSAS-10306');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10306990', 'PPSAS', '10306990', 'Other Receivables', 'item', '175', '176', '4', 'PPSAS-10306');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10306991', 'PPSAS', '10306991', 'Allowance for Impairment - Other Receivables', 'item', '177', '178', '4', 'PPSAS-10306');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10401', 'PPSAS', '10401', 'Inventory Held for Sale', 'group', '182', '185', '3', 'PPSAS-104');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10402', 'PPSAS', '10402', 'Inventory Held for Distribution', 'group', '186', '207', '3', 'PPSAS-104');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10403', 'PPSAS', '10403', 'Inventory Held for Manufacturing', 'group', '208', '215', '3', 'PPSAS-104');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10404', 'PPSAS', '10404', 'Inventory Held for Consumption', 'group', '216', '245', '3', 'PPSAS-104');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10401010', 'PPSAS', '10401010', 'Merchandise Inventory', 'item', '183', '184', '4', 'PPSAS-10401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10402010', 'PPSAS', '10402010', 'Food Supplies for Distribution', 'item', '187', '188', '4', 'PPSAS-10402');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10402020', 'PPSAS', '10402020', 'Welfare Goods for Distribution', 'item', '189', '190', '4', 'PPSAS-10402');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10402030', 'PPSAS', '10402030', 'Drugs and Medicines for Distribution', 'item', '191', '192', '4', 'PPSAS-10402');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10402040', 'PPSAS', '10402040', 'Medical, Dental and Laboratory Supplies for Distribution', 'item', '193', '194', '4', 'PPSAS-10402');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10402050', 'PPSAS', '10402050', 'Agricultural and Marine Supplies for Distribution', 'item', '195', '196', '4', 'PPSAS-10402');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10402060', 'PPSAS', '10402060', 'Agricultural Produce for Distribution', 'item', '197', '198', '4', 'PPSAS-10402');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10402070', 'PPSAS', '10402070', 'Textbooks and Instructional Materials for Distribution', 'item', '199', '200', '4', 'PPSAS-10402');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10402080', 'PPSAS', '10402080', 'Construction Materials for Distribution', 'item', '201', '202', '4', 'PPSAS-10402');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10402090', 'PPSAS', '10402090', 'Property and Equipment for Distribution', 'item', '203', '204', '4', 'PPSAS-10402');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10402990', 'PPSAS', '10402990', 'Other Supplies and Materials for Distribution', 'item', '205', '206', '4', 'PPSAS-10402');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10403010', 'PPSAS', '10403010', 'Raw Materials Inventory', 'item', '209', '210', '4', 'PPSAS-10403');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10403020', 'PPSAS', '10403020', 'Work-in-Process Inventory', 'item', '211', '212', '4', 'PPSAS-10403');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10403030', 'PPSAS', '10403030', 'Finished Goods Inventory', 'item', '213', '214', '4', 'PPSAS-10403');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10404010', 'PPSAS', '10404010', 'Office Supplies Inventory', 'item', '217', '218', '4', 'PPSAS-10404');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-104040100', 'PPSAS', '104040100', 'Textbooks and Instructional Materials Inventory', 'item', '219', '220', '4', 'PPSAS-10404');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-104040110', 'PPSAS', '104040110', 'Military, Police and Traffic Supplies Inventory', 'item', '221', '222', '4', 'PPSAS-10404');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-104040120', 'PPSAS', '104040120', 'Chemical and Filtering Supplies Inventory', 'item', '223', '224', '4', 'PPSAS-10404');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-104040130', 'PPSAS', '104040130', 'Construction Materials Inventory', 'item', '225', '226', '4', 'PPSAS-10404');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10404020', 'PPSAS', '10404020', 'Accountable Forms, Plates and Stickers', 'item', '227', '228', '4', 'PPSAS-10404');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10404030', 'PPSAS', '10404030', 'Non-Accountable Forms Inventory', 'item', '229', '230', '4', 'PPSAS-10404');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10404040', 'PPSAS', '10404040', 'Animal/Zoological Supplies Inventory', 'item', '231', '232', '4', 'PPSAS-10404');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10404050', 'PPSAS', '10404050', 'Food Supplies Inventory', 'item', '233', '234', '4', 'PPSAS-10404');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10404060', 'PPSAS', '10404060', 'Drugs and Medicines Inventory', 'item', '235', '236', '4', 'PPSAS-10404');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10404070', 'PPSAS', '10404070', 'Medical, Dental and Laboratory Supplies Inventory', 'item', '237', '238', '4', 'PPSAS-10404');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10404080', 'PPSAS', '10404080', 'Fuel, Oil and Lubricants Inventory', 'item', '239', '240', '4', 'PPSAS-10404');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10404090', 'PPSAS', '10404090', 'Agricultural and Marine Supplies Inventory', 'item', '241', '242', '4', 'PPSAS-10404');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-104040990', 'PPSAS', '104040990', 'Other Supplies and Materials Inventory', 'item', '243', '244', '4', 'PPSAS-10404');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10501', 'PPSAS', '10501', 'Prepayments', 'group', '250', '263', '3', 'PPSAS-105');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10502', 'PPSAS', '10502', 'Deferred Charges', 'group', '264', '267', '3', 'PPSAS-105');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10501010', 'PPSAS', '10501010', 'Advances to Contractors', 'item', '251', '252', '4', 'PPSAS-10501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10501020', 'PPSAS', '10501020', 'Prepaid Rent', 'item', '253', '254', '4', 'PPSAS-10501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10501030', 'PPSAS', '10501030', 'Prepaid Registration', 'item', '255', '256', '4', 'PPSAS-10501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10501040', 'PPSAS', '10501040', 'Prepaid Interest', 'item', '257', '258', '4', 'PPSAS-10501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10501050', 'PPSAS', '10501050', 'Prepaid Insurance', 'item', '259', '260', '4', 'PPSAS-10501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10501990', 'PPSAS', '10501990', 'Other Prepayments', 'item', '261', '262', '4', 'PPSAS-10501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10502010', 'PPSAS', '10502010', 'Discount on Advance Payments', 'item', '265', '266', '4', 'PPSAS-10502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10601', 'PPSAS', '10601', 'Land and Buildings', 'group', '270', '283', '3', 'PPSAS-106');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10601010', 'PPSAS', '10601010', 'Investment Property,  Land', 'item', '271', '272', '4', 'PPSAS-10601');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10601011', 'PPSAS', '10601011', 'Accumulated Impairment Losses - Investment Property,  Land', 'item', '273', '274', '4', 'PPSAS-10601');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10601020', 'PPSAS', '10601020', 'Investment Property, Buildings', 'item', '275', '276', '4', 'PPSAS-10601');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10601021', 'PPSAS', '10601021', 'Accumulated Depreciation - Investment Property, Buildings', 'item', '277', '278', '4', 'PPSAS-10601');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10601022', 'PPSAS', '10601022', 'Accumulated Impairment Losses - Investment Property,  Buildings', 'item', '279', '280', '4', 'PPSAS-10601');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10601030', 'PPSAS', '10601030', 'Construction in Progress - Investment Property, Buildings', 'item', '281', '282', '4', 'PPSAS-10601');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10701', 'PPSAS', '10701', 'Land', 'group', '286', '291', '3', 'PPSAS-107');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10702', 'PPSAS', '10702', 'Land Improvements', 'group', '292', '305', '3', 'PPSAS-107');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703', 'PPSAS', '10703', 'Infrastructure Assets', 'group', '306', '367', '3', 'PPSAS-107');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704', 'PPSAS', '10704', 'Buildings and Other Structures', 'group', '368', '411', '3', 'PPSAS-107');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705', 'PPSAS', '10705', 'Machinery  and Equipment', 'group', '412', '503', '3', 'PPSAS-107');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10706', 'PPSAS', '10706', 'Transportation Equipment', 'group', '504', '535', '3', 'PPSAS-107');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10707', 'PPSAS', '10707', 'Furniture, Fixtures and Books', 'group', '536', '549', '3', 'PPSAS-107');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10708', 'PPSAS', '10708', 'Leased Assets', 'group', '550', '579', '3', 'PPSAS-107');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10709', 'PPSAS', '10709', 'Leased Assets Improvements', 'group', '580', '599', '3', 'PPSAS-107');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10710', 'PPSAS', '10710', 'Construction in Progress', 'group', '600', '611', '3', 'PPSAS-107');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10711', 'PPSAS', '10711', 'Service Concession Assets', 'group', '612', '619', '3', 'PPSAS-107');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10799', 'PPSAS', '10799', 'Other Property, Plant and Equipment', 'group', '620', '633', '3', 'PPSAS-107');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-1070110', 'PPSAS', '1070110', 'Land', 'item', '287', '288', '4', 'PPSAS-10701');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-1070111', 'PPSAS', '1070111', 'Accumulated Impairment Losses - Land', 'item', '289', '290', '4', 'PPSAS-10701');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10702010', 'PPSAS', '10702010', 'Land Improvements,  Aquaculture Structures', 'item', '293', '294', '4', 'PPSAS-10702');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10702011', 'PPSAS', '10702011', 'Accumulated Depreciation - Land Improvements, Aquaculture Structures', 'item', '295', '296', '4', 'PPSAS-10702');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10702012', 'PPSAS', '10702012', 'Accumulated Impairment Losses - Land Improvements, Aquaculture Structures', 'item', '297', '298', '4', 'PPSAS-10702');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10702990', 'PPSAS', '10702990', 'Other Land Improvements', 'item', '299', '300', '4', 'PPSAS-10702');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10702991', 'PPSAS', '10702991', 'Accumulated Depreciation - Other Land Improvements', 'item', '301', '302', '4', 'PPSAS-10702');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10702992', 'PPSAS', '10702992', 'Accumulated Impairment Losses - Other Land Improvements', 'item', '303', '304', '4', 'PPSAS-10702');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703010', 'PPSAS', '10703010', 'Road Networks', 'item', '307', '308', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703011', 'PPSAS', '10703011', 'Accumulated Depreciation - Road Networks', 'item', '309', '310', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703012', 'PPSAS', '10703012', 'Accumulated Impairment Losses - Road Networks', 'item', '311', '312', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703020', 'PPSAS', '10703020', 'Flood Control Systems', 'item', '313', '314', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703021', 'PPSAS', '10703021', 'Accumulated Depreciation - Flood Control Systems', 'item', '315', '316', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703022', 'PPSAS', '10703022', 'Accumulated Impairment Losses - Flood Control Systems', 'item', '317', '318', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703030', 'PPSAS', '10703030', 'Sewer Systems', 'item', '319', '320', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703031', 'PPSAS', '10703031', 'Accumulated Depreciation - Sewer Systems', 'item', '321', '322', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703032', 'PPSAS', '10703032', 'Accumulated Impairment Losses - Sewer Systems', 'item', '323', '324', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703040', 'PPSAS', '10703040', 'Water Supply Systems', 'item', '325', '326', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703041', 'PPSAS', '10703041', 'Accumulated Depreciation - Water Supply Systems', 'item', '327', '328', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703042', 'PPSAS', '10703042', 'Accumulated Impairment Losses - Water Supply Systems', 'item', '329', '330', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703050', 'PPSAS', '10703050', 'Power Supply Systems', 'item', '331', '332', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703051', 'PPSAS', '10703051', 'Accumulated Depreciation - Power Supply Systems', 'item', '333', '334', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703052', 'PPSAS', '10703052', 'Accumulated Impairment Losses - Power Supply Systems', 'item', '335', '336', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703060', 'PPSAS', '10703060', 'Communication Networks', 'item', '337', '338', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703061', 'PPSAS', '10703061', 'Accumulated Depreciation - Communication Networks', 'item', '339', '340', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703062', 'PPSAS', '10703062', 'Accumulated Impairment Losses - Communication Networks', 'item', '341', '342', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703070', 'PPSAS', '10703070', 'Seaport Systems', 'item', '343', '344', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703071', 'PPSAS', '10703071', 'Accumulated Depreciation - Seaport Systems', 'item', '345', '346', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703072', 'PPSAS', '10703072', 'Accumulated Impairment Losses - Seaport Systems', 'item', '347', '348', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703080', 'PPSAS', '10703080', 'Airport Systems', 'item', '349', '350', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703081', 'PPSAS', '10703081', 'Accumulated Depreciation - Airport Systems', 'item', '351', '352', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703082', 'PPSAS', '10703082', 'Accumulated Impairment Losses - Airport Systems', 'item', '353', '354', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703090', 'PPSAS', '10703090', 'Parks, Plazas and Monuments', 'item', '355', '356', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703091', 'PPSAS', '10703091', 'Accumulated Depreciation - Parks, Plazas and Monuments', 'item', '357', '358', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703092', 'PPSAS', '10703092', 'Accumulated Impairment Losses - Parks, Plazas and Monuments', 'item', '359', '360', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703990', 'PPSAS', '10703990', 'Other Infrastructure Assets', 'item', '361', '362', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703991', 'PPSAS', '10703991', 'Accumulated Depreciation - Other Infrastructure Assets', 'item', '363', '364', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10703992', 'PPSAS', '10703992', 'Accumulated Impairment Losses - Other Infrastructure Assets', 'item', '365', '366', '4', 'PPSAS-10703');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704010', 'PPSAS', '10704010', 'Buildings', 'item', '369', '370', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704011', 'PPSAS', '10704011', 'Accumulated Depreciation - Buildings', 'item', '371', '372', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704012', 'PPSAS', '10704012', 'Accumulated Impairment Losses - Buildings', 'item', '373', '374', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704020', 'PPSAS', '10704020', 'School Buildings', 'item', '375', '376', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704021', 'PPSAS', '10704021', 'Accumulated Depreciation - School Buildings', 'item', '377', '378', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704022', 'PPSAS', '10704022', 'Accumulated Impairment Losses - School Buildings', 'item', '379', '380', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704030', 'PPSAS', '10704030', 'Hospitals and Health Centers', 'item', '381', '382', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704031', 'PPSAS', '10704031', 'Accumulated Depreciation - Hospitals and Health Centers', 'item', '383', '384', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704032', 'PPSAS', '10704032', 'Accumulated Impairment Losses - Hospitals and Health Centers', 'item', '385', '386', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704040', 'PPSAS', '10704040', 'Markets', 'item', '387', '388', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704041', 'PPSAS', '10704041', 'Accumulated Depreciation - Markets', 'item', '389', '390', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704042', 'PPSAS', '10704042', 'Accumulated Impairment Losses - Markets', 'item', '391', '392', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704050', 'PPSAS', '10704050', 'Slaughterhouses', 'item', '393', '394', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704051', 'PPSAS', '10704051', 'Accumulated Depreciation - Slaughterhouses', 'item', '395', '396', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704052', 'PPSAS', '10704052', 'Accumulated Impairment Losses- Slaughterhouses', 'item', '397', '398', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704060', 'PPSAS', '10704060', 'Hostels and Dormitories', 'item', '399', '400', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704061', 'PPSAS', '10704061', 'Accumulated Depreciation - Hostels and Dormitories', 'item', '401', '402', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704062', 'PPSAS', '10704062', 'Accumulated Impairment Losses - Hostels and Dormitories', 'item', '403', '404', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704990', 'PPSAS', '10704990', 'Other Structures', 'item', '405', '406', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704991', 'PPSAS', '10704991', 'Accumulated Depreciation - Other Structures', 'item', '407', '408', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10704992', 'PPSAS', '10704992', 'Accumulated Impairment Losses - Other Structures', 'item', '409', '410', '4', 'PPSAS-10704');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705010', 'PPSAS', '10705010', 'Machinery', 'item', '413', '414', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705011', 'PPSAS', '10705011', 'Accumulated Depreciation - Machinery', 'item', '415', '416', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705012', 'PPSAS', '10705012', 'Accumulated Impairment Losses - Machinery', 'item', '417', '418', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705020', 'PPSAS', '10705020', 'Office Equipment', 'item', '419', '420', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705021', 'PPSAS', '10705021', 'Accumulated Depreciation - Office Equipment', 'item', '421', '422', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705022', 'PPSAS', '10705022', 'Accumulated Impairment Losses - Office Equipment', 'item', '423', '424', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705030', 'PPSAS', '10705030', 'Information and Communication Technology  Equipment', 'item', '425', '426', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705031', 'PPSAS', '10705031', 'Accumulated Depreciation - Information and Communication Technology  Equipment', 'item', '427', '428', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705032', 'PPSAS', '10705032', 'Accumulated Impairment Losses - Information and Communication Technology  Equipment', 'item', '429', '430', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705040', 'PPSAS', '10705040', 'Agricultural and  Forestry Equipment', 'item', '431', '432', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705041', 'PPSAS', '10705041', 'Accumulated Depreciation - Agricultural  and Forestry Equipment', 'item', '433', '434', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705042', 'PPSAS', '10705042', 'Accumulated Impairment Losses - Agricultural  and Forestry Equipment', 'item', '435', '436', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705050', 'PPSAS', '10705050', 'Marine and Fishery Equipment', 'item', '437', '438', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705051', 'PPSAS', '10705051', 'Accumulated Depreciation - Marine and Fishery Equipment', 'item', '439', '440', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705052', 'PPSAS', '10705052', 'Accumulated Impairment Losses - Marine and Fishery Equipment', 'item', '441', '442', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705060', 'PPSAS', '10705060', 'Airport Equipment', 'item', '443', '444', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705061', 'PPSAS', '10705061', 'Accumulated Depreciation - Airport Equipment', 'item', '445', '446', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705062', 'PPSAS', '10705062', 'Accumulated Impairment Losses - Airport Equipment', 'item', '447', '448', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705070', 'PPSAS', '10705070', 'Communication Equipment', 'item', '449', '450', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705071', 'PPSAS', '10705071', 'Accumulated Depreciation - Communication Equipment', 'item', '451', '452', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705072', 'PPSAS', '10705072', 'Accumulated Impairment Losses - Communication Equipment', 'item', '453', '454', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705080', 'PPSAS', '10705080', 'Construction and Heavy Equipment', 'item', '455', '456', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705081', 'PPSAS', '10705081', 'Accumulated Depreciation - Construction and Heavy Equipment', 'item', '457', '458', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705082', 'PPSAS', '10705082', 'Accumulated Impairment Losses - Construction and Heavy Equipment', 'item', '459', '460', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705090', 'PPSAS', '10705090', 'Disaster Response and Rescue Equipment', 'item', '461', '462', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705091', 'PPSAS', '10705091', 'Accumulated Depreciation - Disaster Response and Rescue Equipment', 'item', '463', '464', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705092', 'PPSAS', '10705092', 'Accumulated Impairment Losses - Disaster Response and Rescue Equipment', 'item', '465', '466', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705100', 'PPSAS', '10705100', 'Military, Police and Security Equipment', 'item', '467', '468', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705101', 'PPSAS', '10705101', 'Accumulated Depreciation - Military, Police and Security Equipment', 'item', '469', '470', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705102', 'PPSAS', '10705102', 'Accumulated Impairment Losses - Military, Police and Security Equipment', 'item', '471', '472', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705110', 'PPSAS', '10705110', 'Medical Equipment', 'item', '473', '474', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705111', 'PPSAS', '10705111', 'Accumulated Depreciation - Medical Equipment', 'item', '475', '476', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705112', 'PPSAS', '10705112', 'Accumulated Impairment Losses - Medical Equipment', 'item', '477', '478', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705120', 'PPSAS', '10705120', 'Printing Equipment', 'item', '479', '480', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705121', 'PPSAS', '10705121', 'Accumulated Depreciation - Printing Equipment', 'item', '481', '482', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705122', 'PPSAS', '10705122', 'Accumulated Impairment Losses - Printing Equipment', 'item', '483', '484', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705130', 'PPSAS', '10705130', 'Sports Equipment', 'item', '485', '486', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705131', 'PPSAS', '10705131', 'Accumulated Depreciation - Sports Equipment', 'item', '487', '488', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705132', 'PPSAS', '10705132', 'Accumulated Impairment Losses - Sports Equipment', 'item', '489', '490', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705140', 'PPSAS', '10705140', 'Technical and Scientific  Equipment', 'item', '491', '492', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705141', 'PPSAS', '10705141', 'Accumulated Depreciation - Technical and Scientific  Equipment', 'item', '493', '494', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705142', 'PPSAS', '10705142', 'Accumulated Impairment Losses - Technical and Scientific  Equipment', 'item', '495', '496', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705990', 'PPSAS', '10705990', 'Other Machinery and Equipment', 'item', '497', '498', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705991', 'PPSAS', '10705991', 'Accumulated Depreciation - Other Machinery and Equipment', 'item', '499', '500', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10705992', 'PPSAS', '10705992', 'Accumulated Impairment Losses - Other Machinery and Equipment', 'item', '501', '502', '4', 'PPSAS-10705');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10706010', 'PPSAS', '10706010', 'Motor Vehicles', 'item', '505', '506', '4', 'PPSAS-10706');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10706011', 'PPSAS', '10706011', 'Accumulated Depreciation - Motor Vehicles', 'item', '507', '508', '4', 'PPSAS-10706');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10706012', 'PPSAS', '10706012', 'Accumulated Impairment Losses - Motor Vehicles', 'item', '509', '510', '4', 'PPSAS-10706');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10706020', 'PPSAS', '10706020', 'Trains', 'item', '511', '512', '4', 'PPSAS-10706');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10706021', 'PPSAS', '10706021', 'Accumulated Depreciation - Trains', 'item', '513', '514', '4', 'PPSAS-10706');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10706022', 'PPSAS', '10706022', 'Accumulated Impairment Losses - Trains', 'item', '515', '516', '4', 'PPSAS-10706');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10706030', 'PPSAS', '10706030', 'Aircrafts and Aircrafts Ground Equipment', 'item', '517', '518', '4', 'PPSAS-10706');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10706031', 'PPSAS', '10706031', 'Accumulated Depreciation - Aircrafts and Aircrafts Ground Equipment', 'item', '519', '520', '4', 'PPSAS-10706');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10706032', 'PPSAS', '10706032', 'Accumulated Impairment Losses - Aircrafts and Aircrafts Ground Equipment', 'item', '521', '522', '4', 'PPSAS-10706');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10706040', 'PPSAS', '10706040', 'Watercrafts', 'item', '523', '524', '4', 'PPSAS-10706');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10706042', 'PPSAS', '10706042', 'Accumulated Impairment Losses - Watercrafts', 'item', '525', '526', '4', 'PPSAS-10706');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10706990', 'PPSAS', '10706990', 'Other Transportation Equipment', 'item', '527', '528', '4', 'PPSAS-10706');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10706991', 'PPSAS', '10706991', 'Accumulated Depreciation - Other Transportation Equipment', 'item', '529', '530', '4', 'PPSAS-10706');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10706992', 'PPSAS', '10706992', 'Accumulated Impairment Losses - Other Transportation Equipment', 'item', '531', '532', '4', 'PPSAS-10706');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-41107060', 'PPSAS', '41107060', 'Accumulated Depreciation - Watercrafts', 'item', '533', '534', '4', 'PPSAS-10706');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10707010', 'PPSAS', '10707010', 'Furniture and Fixtures', 'item', '537', '538', '4', 'PPSAS-10707');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10707011', 'PPSAS', '10707011', 'Accumulated Depreciation - Furniture and Fixtures', 'item', '539', '540', '4', 'PPSAS-10707');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10707012', 'PPSAS', '10707012', 'Accumulated Impairment Losses - Furniture and Fixtures', 'item', '541', '542', '4', 'PPSAS-10707');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10707020', 'PPSAS', '10707020', 'Books', 'item', '543', '544', '4', 'PPSAS-10707');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10707021', 'PPSAS', '10707021', 'Accumulated Depreciation - Books', 'item', '545', '546', '4', 'PPSAS-10707');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10707022', 'PPSAS', '10707022', 'Accumulated Impairment Losses - Books', 'item', '547', '548', '4', 'PPSAS-10707');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10708010', 'PPSAS', '10708010', 'Leased Assets, Land', 'item', '551', '552', '4', 'PPSAS-10708');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10708011', 'PPSAS', '10708011', 'Accumulated Impairment Losses-Leased Assets, Land', 'item', '553', '554', '4', 'PPSAS-10708');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10708020', 'PPSAS', '10708020', 'Leased Assets,  Buildings and Other Structures', 'item', '555', '556', '4', 'PPSAS-10708');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10708021', 'PPSAS', '10708021', 'Accumulated Depreciation - Leased Assets,  Buildings and Other Structures', 'item', '557', '558', '4', 'PPSAS-10708');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10708022', 'PPSAS', '10708022', 'Accumulated Impairment Losses - Leased Assets, Buildings and Other Structures', 'item', '559', '560', '4', 'PPSAS-10708');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10708030', 'PPSAS', '10708030', 'Leased Assets,  Machinery and Equipment', 'item', '561', '562', '4', 'PPSAS-10708');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10708031', 'PPSAS', '10708031', 'Accumulated Depreciation - Leased Assets, Machinery and Equipment', 'item', '563', '564', '4', 'PPSAS-10708');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10708032', 'PPSAS', '10708032', 'Accumulated Impairment Losses - Leased Assets,  Machinery and Equipment', 'item', '565', '566', '4', 'PPSAS-10708');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10708040', 'PPSAS', '10708040', 'Leased Assets, Transportation Equipment', 'item', '567', '568', '4', 'PPSAS-10708');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10708041', 'PPSAS', '10708041', 'Accumulated Depreciation - Leased Assets, Transportation Equipment', 'item', '569', '570', '4', 'PPSAS-10708');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10708042', 'PPSAS', '10708042', 'Accumulated Impairment Losses - Leased Assets,  Transportation Equipment', 'item', '571', '572', '4', 'PPSAS-10708');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10708990', 'PPSAS', '10708990', 'Other Leased Assets', 'item', '573', '574', '4', 'PPSAS-10708');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10708991', 'PPSAS', '10708991', 'Accumulated Depreciation - Other Leased Assets', 'item', '575', '576', '4', 'PPSAS-10708');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10708992', 'PPSAS', '10708992', 'Accumulated Impairment Losses - Other Leased Assets', 'item', '577', '578', '4', 'PPSAS-10708');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10709010', 'PPSAS', '10709010', 'Leased Assets Improvements, Land', 'item', '581', '582', '4', 'PPSAS-10709');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10709011', 'PPSAS', '10709011', 'Accumulated Depreciation - Leased Assets Improvements, Land', 'item', '583', '584', '4', 'PPSAS-10709');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10709012', 'PPSAS', '10709012', 'Accumulated Impairment Losses - Leased Assets Improvements, Land', 'item', '585', '586', '4', 'PPSAS-10709');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10709020', 'PPSAS', '10709020', 'Leased Assets Improvements, Buildings', 'item', '587', '588', '4', 'PPSAS-10709');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10709021', 'PPSAS', '10709021', 'Accumulated Depreciation - Leased Assets Improvements, Buildings', 'item', '589', '590', '4', 'PPSAS-10709');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10709022', 'PPSAS', '10709022', 'Accumulated Impairment Losses - Leased Assets Improvements, Buildings', 'item', '591', '592', '4', 'PPSAS-10709');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10709990', 'PPSAS', '10709990', 'Other Leased Assets Improvements', 'item', '593', '594', '4', 'PPSAS-10709');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10709991', 'PPSAS', '10709991', 'Accumulated Depreciation - Other Leased Assets Improvements', 'item', '595', '596', '4', 'PPSAS-10709');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10709992', 'PPSAS', '10709992', 'Accumulated Impairment Losses - Other Leased Assets Improvements', 'item', '597', '598', '4', 'PPSAS-10709');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10710010', 'PPSAS', '10710010', 'Construction in Progress - Land Improvements', 'item', '601', '602', '4', 'PPSAS-10710');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10710020', 'PPSAS', '10710020', 'Construction in Progress - Infrastructure Assets', 'item', '603', '604', '4', 'PPSAS-10710');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10710030', 'PPSAS', '10710030', 'Construction in Progress - Buildings and Other Structures', 'item', '605', '606', '4', 'PPSAS-10710');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10710040', 'PPSAS', '10710040', 'Construction in Progress - Leased Assets', 'item', '607', '608', '4', 'PPSAS-10710');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10710050', 'PPSAS', '10710050', 'Construction in Progress - Leased Assets Improvements', 'item', '609', '610', '4', 'PPSAS-10710');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10711010', 'PPSAS', '10711010', 'Service Concession Assets', 'item', '613', '614', '4', 'PPSAS-10711');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10711011', 'PPSAS', '10711011', 'Accumulated Depreciation - Service Concession Assets', 'item', '615', '616', '4', 'PPSAS-10711');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10711012', 'PPSAS', '10711012', 'Accumulated Impairment Losses - Service Concession Assets', 'item', '617', '618', '4', 'PPSAS-10711');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10799010', 'PPSAS', '10799010', 'Work/Zoo Animals', 'item', '621', '622', '4', 'PPSAS-10799');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10799011', 'PPSAS', '10799011', 'Accumulated Depreciation - Work/Zoo Animals', 'item', '623', '624', '4', 'PPSAS-10799');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10799012', 'PPSAS', '10799012', 'Accumulated Impairment Losses - Work/Zoo Animals', 'item', '625', '626', '4', 'PPSAS-10799');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10799990', 'PPSAS', '10799990', 'Other Property, Plant and Equipment', 'item', '627', '628', '4', 'PPSAS-10799');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10799991', 'PPSAS', '10799991', 'Accumulated Depreciation - Other Property, Plant and Equipment', 'item', '629', '630', '4', 'PPSAS-10799');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10799992', 'PPSAS', '10799992', 'Accumulated Impairment Losses - Other Property, Plant and Equipment', 'item', '631', '632', '4', 'PPSAS-10799');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10801', 'PPSAS', '10801', 'Bearer Biological Assets', 'group', '636', '645', '3', 'PPSAS-108');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10801010', 'PPSAS', '10801010', 'Breeding Stocks', 'item', '637', '638', '4', 'PPSAS-10801');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10801020', 'PPSAS', '10801020', 'Plants and Trees', 'item', '639', '640', '4', 'PPSAS-10801');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10801030', 'PPSAS', '10801030', 'Aquaculture', 'item', '641', '642', '4', 'PPSAS-10801');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10801990', 'PPSAS', '10801990', 'Other Bearer Biological Assets', 'item', '643', '644', '4', 'PPSAS-10801');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10901', 'PPSAS', '10901', 'Intangible Assets', 'group', '648', '667', '3', 'PPSAS-109');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10902', 'PPSAS', '10902', 'Service Concession Assets - Intangible Assets', 'group', '668', '671', '3', 'PPSAS-109');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10901010', 'PPSAS', '10901010', 'Patents/Copyrights', 'item', '649', '650', '4', 'PPSAS-10901');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10901011', 'PPSAS', '10901011', 'Accumulated Amortization - Patents/Copyrights', 'item', '651', '652', '4', 'PPSAS-10901');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10901012', 'PPSAS', '10901012', 'Accumulated Impairment - Patents/Copyrights', 'item', '653', '654', '4', 'PPSAS-10901');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10901020', 'PPSAS', '10901020', 'Computer Software', 'item', '655', '656', '4', 'PPSAS-10901');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10901021', 'PPSAS', '10901021', 'Accumulated Amortization - Computer Software', 'item', '657', '658', '4', 'PPSAS-10901');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10901022', 'PPSAS', '10901022', 'Accumulated Impairment - Computer Software', 'item', '659', '660', '4', 'PPSAS-10901');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10901990', 'PPSAS', '10901990', 'Other Intangible Assets', 'item', '661', '662', '4', 'PPSAS-10901');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10901991', 'PPSAS', '10901991', 'Accumulated Amortization - Other Intangible Assets', 'item', '663', '664', '4', 'PPSAS-10901');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10901992', 'PPSAS', '10901992', 'Accumulated Impairment - Other Intangible Assets', 'item', '665', '666', '4', 'PPSAS-10901');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-10902010', 'PPSAS', '10902010', 'Service Concession Assets - Intangible Assets', 'item', '669', '670', '4', 'PPSAS-10902');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-201', 'PPSAS', '201', 'Financial Liabilities', 'group', '675', '712', '2', 'PPSAS-2');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-202', 'PPSAS', '202', 'Inter-Agency Payables', 'group', '713', '732', '2', 'PPSAS-2');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-203', 'PPSAS', '203', 'Intra-Agency Payables', 'group', '733', '742', '2', 'PPSAS-2');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-204', 'PPSAS', '204', 'Trust Liabilities', 'group', '743', '756', '2', 'PPSAS-2');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-205', 'PPSAS', '205', 'Deferred Credits/Unearned Income', 'group', '757', '772', '2', 'PPSAS-2');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-206', 'PPSAS', '206', 'Provisions', 'group', '773', '780', '2', 'PPSAS-2');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-299', 'PPSAS', '299', 'Other Payables', 'group', '781', '786', '2', 'PPSAS-2');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20101', 'PPSAS', '20101', 'Payables', 'group', '676', '699', '3', 'PPSAS-201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20102', 'PPSAS', '20102', 'Bills/Bonds/Loans Payable', 'group', '700', '711', '3', 'PPSAS-201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20101010', 'PPSAS', '20101010', 'Accounts Payable', 'item', '677', '678', '4', 'PPSAS-20101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20101020', 'PPSAS', '20101020', 'Due to Officers and Employees', 'item', '679', '680', '4', 'PPSAS-20101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20101040', 'PPSAS', '20101040', 'Notes Payable', 'item', '681', '682', '4', 'PPSAS-20101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20101050', 'PPSAS', '20101050', 'Interest Payable', 'item', '683', '684', '4', 'PPSAS-20101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20101060', 'PPSAS', '20101060', 'Operating Lease Payable', 'item', '685', '686', '4', 'PPSAS-20101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20101070', 'PPSAS', '20101070', 'Finance Lease Payable', 'item', '687', '688', '4', 'PPSAS-20101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20101080', 'PPSAS', '20101080', 'Awards and Rewards Payable', 'item', '689', '690', '4', 'PPSAS-20101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20101090', 'PPSAS', '20101090', 'Service Concession Arrangement Payable', 'item', '691', '692', '4', 'PPSAS-20101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20101100', 'PPSAS', '20101100', 'Pension Benefits Payable', 'item', '693', '694', '4', 'PPSAS-20101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20101110', 'PPSAS', '20101110', 'Leave Benefits Payable', 'item', '695', '696', '4', 'PPSAS-20101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20101120', 'PPSAS', '20101120', 'Retirement Gratuity Payable', 'item', '697', '698', '4', 'PPSAS-20101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20102020', 'PPSAS', '20102020', 'Bonds Payable - Domestic', 'item', '701', '702', '4', 'PPSAS-20102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20102021', 'PPSAS', '20102021', 'Discount on Bonds Payable - Domestic', 'item', '703', '704', '4', 'PPSAS-20102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20102022', 'PPSAS', '20102022', 'Premium on Bonds Payable - Domestic', 'item', '705', '706', '4', 'PPSAS-20102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20102040', 'PPSAS', '20102040', 'Loans Payable - Domestic', 'item', '707', '708', '4', 'PPSAS-20102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20102050', 'PPSAS', '20102050', 'Loans Payable - Foreign', 'item', '709', '710', '4', 'PPSAS-20102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20201', 'PPSAS', '20201', 'Inter-Agency Payables', 'group', '714', '731', '3', 'PPSAS-202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20201010', 'PPSAS', '20201010', 'Due to BIR', 'item', '715', '716', '4', 'PPSAS-20201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20201020', 'PPSAS', '20201020', 'Due to GSIS', 'item', '717', '718', '4', 'PPSAS-20201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20201030', 'PPSAS', '20201030', 'Due to Pag-IBIG', 'item', '719', '720', '4', 'PPSAS-20201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20201040', 'PPSAS', '20201040', 'Due to PhilHealth', 'item', '721', '722', '4', 'PPSAS-20201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20201050', 'PPSAS', '20201050', 'Due to NGAs', 'item', '723', '724', '4', 'PPSAS-20201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20201060', 'PPSAS', '20201060', 'Due to GOCCs', 'item', '725', '726', '4', 'PPSAS-20201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20201070', 'PPSAS', '20201070', 'Due to LGUs', 'item', '727', '728', '4', 'PPSAS-20201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20201080', 'PPSAS', '20201080', 'Due to Joint Venture', 'item', '729', '730', '4', 'PPSAS-20201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20301', 'PPSAS', '20301', 'Intra-Agency Payables', 'group', '734', '741', '3', 'PPSAS-203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20301010', 'PPSAS', '20301010', 'Due to Other Funds', 'item', '735', '736', '4', 'PPSAS-20301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20301020', 'PPSAS', '20301020', 'Due to Special Accounts', 'item', '737', '738', '4', 'PPSAS-20301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20301030', 'PPSAS', '20301030', 'Due to Local Economic Enterprises', 'item', '739', '740', '4', 'PPSAS-20301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20401', 'PPSAS', '20401', 'Trust Liabilities', 'group', '744', '755', '3', 'PPSAS-204');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20401010', 'PPSAS', '20401010', 'Trust Liabilities', 'item', '745', '746', '4', 'PPSAS-20401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20401020', 'PPSAS', '20401020', 'Trust Liabilities - Disaster Risk Reduction and Management Fund', 'item', '747', '748', '4', 'PPSAS-20401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20401030', 'PPSAS', '20401030', 'Bail Bonds Payable', 'item', '749', '750', '4', 'PPSAS-20401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20401040', 'PPSAS', '20401040', 'Guaranty/Security Deposits Payable', 'item', '751', '752', '4', 'PPSAS-20401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20401050', 'PPSAS', '20401050', 'Customers'' Deposits Payable', 'item', '753', '754', '4', 'PPSAS-20401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20501', 'PPSAS', '20501', 'Deferred Credits', 'group', '758', '771', '3', 'PPSAS-205');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20501010', 'PPSAS', '20501010', 'Deferred Real Property Tax', 'item', '759', '760', '4', 'PPSAS-20501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20501020', 'PPSAS', '20501020', 'Deferred Special Education Tax', 'item', '761', '762', '4', 'PPSAS-20501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20501030', 'PPSAS', '20501030', 'Deferred Finance Lease Revenue', 'item', '763', '764', '4', 'PPSAS-20501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20501040', 'PPSAS', '20501040', 'Deferred Service Concession Revenue', 'item', '765', '766', '4', 'PPSAS-20501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20501050', 'PPSAS', '20501050', 'Unearned Revenue - Investment Property', 'item', '767', '768', '4', 'PPSAS-20501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-205010990', 'PPSAS', '205010990', 'Other Deferred Credits', 'item', '769', '770', '4', 'PPSAS-20501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20601', 'PPSAS', '20601', 'Provisions', 'group', '774', '779', '3', 'PPSAS-206');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20601040', 'PPSAS', '20601040', 'Termination Benefits', 'item', '775', '776', '4', 'PPSAS-20601');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-20601990', 'PPSAS', '20601990', 'Other Provisions', 'item', '777', '778', '4', 'PPSAS-20601');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-29999', 'PPSAS', '29999', 'Other Payables', 'group', '782', '785', '3', 'PPSAS-299');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-29999990', 'PPSAS', '29999990', 'Other Payables', 'item', '783', '784', '4', 'PPSAS-29999');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-301', 'PPSAS', '301', 'Government Equity', 'group', '789', '796', '2', 'PPSAS-3');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-302', 'PPSAS', '302', 'Intermediate Accounts', 'group', '797', '802', '2', 'PPSAS-3');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-303', 'PPSAS', '303', 'Equity in Joint Venture', 'group', '803', '808', '2', 'PPSAS-3');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-304', 'PPSAS', '304', 'Unrealized Gain/(Loss)', 'group', '809', '814', '2', 'PPSAS-3');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-30101', 'PPSAS', '30101', 'Government Equity', 'group', '790', '795', '3', 'PPSAS-301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-30101010', 'PPSAS', '30101010', 'Government Equity', 'item', '791', '792', '4', 'PPSAS-30101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-30101020', 'PPSAS', '30101020', 'Prior Period Adjustment', 'item', '793', '794', '4', 'PPSAS-30101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-30201', 'PPSAS', '30201', 'Intermediate Accounts', 'group', '798', '801', '3', 'PPSAS-302');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-30201010', 'PPSAS', '30201010', 'Income and Expense Summary', 'item', '799', '800', '4', 'PPSAS-30201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-30301', 'PPSAS', '30301', 'Equity in Joint Venture', 'group', '804', '807', '3', 'PPSAS-303');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-30301010', 'PPSAS', '30301010', 'Equity in Joint Venture', 'item', '805', '806', '4', 'PPSAS-30301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-30401', 'PPSAS', '30401', 'Unrealized Gain/(Loss)', 'group', '810', '813', '3', 'PPSAS-304');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-30401010', 'PPSAS', '30401010', 'Unrealized Gain/(Loss) from Changes in the Fair Value of Financial Assets', 'item', '811', '812', '4', 'PPSAS-30401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-401', 'PPSAS', '401', 'Tax Revenue', 'group', '817', '880', '2', 'PPSAS-4');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-402', 'PPSAS', '402', 'Service and Business Income', 'group', '881', '968', '2', 'PPSAS-4');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-403', 'PPSAS', '403', 'Transfers, Assistance and Subsidy', 'group', '969', '990', '2', 'PPSAS-4');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-404', 'PPSAS', '404', 'Shares, Grants and Donations', 'group', '991', '1006', '2', 'PPSAS-4');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-405', 'PPSAS', '405', 'Gains', 'group', '1007', '1036', '2', 'PPSAS-4');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-406', 'PPSAS', '406', 'Miscellaneous Income', 'group', '1037', '1042', '2', 'PPSAS-4');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-407', 'PPSAS', '407', 'Other Non-Operating Income', 'group', '1043', '1048', '2', 'PPSAS-4');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40101', 'PPSAS', '40101', 'Tax Revenue - Individual and Corporation', 'group', '818', '823', '3', 'PPSAS-401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40102', 'PPSAS', '40102', 'Tax Revenue - Property', 'group', '824', '839', '3', 'PPSAS-401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40103', 'PPSAS', '40103', 'Tax Revenue - Goods and Services', 'group', '840', '853', '3', 'PPSAS-401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40104', 'PPSAS', '40104', 'Tax Revenue - Others', 'group', '854', '857', '3', 'PPSAS-401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40105', 'PPSAS', '40105', 'Tax Revenue - Fines and Penalties', 'group', '858', '867', '3', 'PPSAS-401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40106', 'PPSAS', '40106', 'Share from National Taxes', 'group', '868', '879', '3', 'PPSAS-401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40101020', 'PPSAS', '40101020', 'Professional Tax', 'item', '819', '820', '4', 'PPSAS-40101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40101050', 'PPSAS', '40101050', 'Community Tax', 'item', '821', '822', '4', 'PPSAS-40101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40102040', 'PPSAS', '40102040', 'Real Property Tax- Basic', 'item', '825', '826', '4', 'PPSAS-40102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40102041', 'PPSAS', '40102041', 'Discount on Real Property Tax- Basic', 'item', '827', '828', '4', 'PPSAS-40102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40102050', 'PPSAS', '40102050', 'Special Education Tax', 'item', '829', '830', '4', 'PPSAS-40102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40102051', 'PPSAS', '40102051', 'Discount on Special Education Tax', 'item', '831', '832', '4', 'PPSAS-40102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40102060', 'PPSAS', '40102060', 'Special Levy on Idle Lands', 'item', '833', '834', '4', 'PPSAS-40102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40102070', 'PPSAS', '40102070', 'Special Levy on Lands Benefited by Public Works Projects', 'item', '835', '836', '4', 'PPSAS-40102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40102080', 'PPSAS', '40102080', 'Real Property Transfer Tax', 'item', '837', '838', '4', 'PPSAS-40102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40103030', 'PPSAS', '40103030', 'Business Tax', 'item', '841', '842', '4', 'PPSAS-40103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40103040', 'PPSAS', '40103040', 'Tax on Sand, Gravel and Other Quarry Products', 'item', '843', '844', '4', 'PPSAS-40103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40103050', 'PPSAS', '40103050', 'Tax on Delivery  Trucks and Vans', 'item', '845', '846', '4', 'PPSAS-40103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40103060', 'PPSAS', '40103060', 'Amusement Tax', 'item', '847', '848', '4', 'PPSAS-40103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40103070', 'PPSAS', '40103070', 'Franchise Tax', 'item', '849', '850', '4', 'PPSAS-40103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40103080', 'PPSAS', '40103080', 'Printing and Publication Tax', 'item', '851', '852', '4', 'PPSAS-40103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40104990', 'PPSAS', '40104990', 'Other Taxes', 'item', '855', '856', '4', 'PPSAS-40104');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40105010', 'PPSAS', '40105010', 'Tax Revenue - Fines and Penalties - Taxes on Individual and Corporation', 'item', '859', '860', '4', 'PPSAS-40105');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40105020', 'PPSAS', '40105020', 'Tax Revenue - Fines and Penalties - Property Taxes', 'item', '861', '862', '4', 'PPSAS-40105');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40105030', 'PPSAS', '40105030', 'Tax Revenue - Fines and Penalties - Taxes on Goods and Services', 'item', '863', '864', '4', 'PPSAS-40105');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40105040', 'PPSAS', '40105040', 'Tax Revenue - Fines and Penalties - Other Taxes', 'item', '865', '866', '4', 'PPSAS-40105');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40106010', 'PPSAS', '40106010', 'Share from Internal Revenue Collections (IRA)', 'item', '869', '870', '4', 'PPSAS-40106');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40106020', 'PPSAS', '40106020', 'Share from Expanded Value Added Tax', 'item', '871', '872', '4', 'PPSAS-40106');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40106030', 'PPSAS', '40106030', 'Share from National Wealth', 'item', '873', '874', '4', 'PPSAS-40106');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40106040', 'PPSAS', '40106040', 'Share from Tobacco Excise Tax (RA 7171 and 8240)', 'item', '875', '876', '4', 'PPSAS-40106');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40106050', 'PPSAS', '40106050', 'Share from Economic Zones', 'item', '877', '878', '4', 'PPSAS-40106');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40201', 'PPSAS', '40201', 'Service Income', 'group', '882', '909', '3', 'PPSAS-402');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202', 'PPSAS', '40202', 'Business Income', 'group', '910', '967', '3', 'PPSAS-402');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40201010', 'PPSAS', '40201010', 'Permit Fees', 'item', '883', '884', '4', 'PPSAS-40201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40201020', 'PPSAS', '40201020', 'Registration Fees', 'item', '885', '886', '4', 'PPSAS-40201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40201030', 'PPSAS', '40201030', 'Registration Plates, Tags and Stickers Fees', 'item', '887', '888', '4', 'PPSAS-40201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40201040', 'PPSAS', '40201040', 'Clearance and Certification Fees', 'item', '889', '890', '4', 'PPSAS-40201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40201070', 'PPSAS', '40201070', 'Supervision and Regulation Enforcement Fees', 'item', '891', '892', '4', 'PPSAS-40201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40201100', 'PPSAS', '40201100', 'Inspection Fees', 'item', '893', '894', '4', 'PPSAS-40201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40201110', 'PPSAS', '40201110', 'Verification and Authentication Fees', 'item', '895', '896', '4', 'PPSAS-40201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40201130', 'PPSAS', '40201130', 'Processing Fees', 'item', '897', '898', '4', 'PPSAS-40201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40201140', 'PPSAS', '40201140', 'Occupation Fees', 'item', '899', '900', '4', 'PPSAS-40201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40201150', 'PPSAS', '40201150', 'Fishery Rentals, Fees and Charges', 'item', '901', '902', '4', 'PPSAS-40201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40201160', 'PPSAS', '40201160', 'Fees for Sealing  and Licensing of Weights and Measures', 'item', '903', '904', '4', 'PPSAS-40201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40201980', 'PPSAS', '40201980', 'Fines and Penalties - Service Income', 'item', '905', '906', '4', 'PPSAS-40201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40201990', 'PPSAS', '40201990', 'Other Service Income', 'item', '907', '908', '4', 'PPSAS-40201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202010', 'PPSAS', '40202010', 'School Fees', 'item', '911', '912', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202020', 'PPSAS', '40202020', 'Affiliation Fees', 'item', '913', '914', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202040', 'PPSAS', '40202040', 'Seminar/Training Fees', 'item', '915', '916', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202050', 'PPSAS', '40202050', 'Rent Income', 'item', '917', '918', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202060', 'PPSAS', '40202060', 'Communication Network Fees', 'item', '919', '920', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202070', 'PPSAS', '40202070', 'Transportation System Fees', 'item', '921', '922', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202080', 'PPSAS', '40202080', 'Road Network  Fees', 'item', '923', '924', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202090', 'PPSAS', '40202090', 'Waterworks System Fees', 'item', '925', '926', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202100', 'PPSAS', '40202100', 'Power Supply System Fees', 'item', '927', '928', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202110', 'PPSAS', '40202110', 'Seaport  System Fees', 'item', '929', '930', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202120', 'PPSAS', '40202120', 'Parking Fees', 'item', '931', '932', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202130', 'PPSAS', '40202130', 'Receipts  from Operation of Hostels/Dormitories and Other Like Facilities', 'item', '933', '934', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202140', 'PPSAS', '40202140', 'Receipts from Market Operations', 'item', '935', '936', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202150', 'PPSAS', '40202150', 'Receipts from Slaughterhouse Operation', 'item', '937', '938', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202160', 'PPSAS', '40202160', 'Receipts from Cemetery Operations', 'item', '939', '940', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202170', 'PPSAS', '40202170', 'Receipts from Printing and Publication', 'item', '941', '942', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202180', 'PPSAS', '40202180', 'Sales Revenue', 'item', '943', '944', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202181', 'PPSAS', '40202181', 'Sales Discounts', 'item', '945', '946', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202190', 'PPSAS', '40202190', 'Garbage Fees', 'item', '947', '948', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202200', 'PPSAS', '40202200', 'Hospital Fees', 'item', '949', '950', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202210', 'PPSAS', '40202210', 'Dividend Income', 'item', '951', '952', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202220', 'PPSAS', '40202220', 'Interest Income', 'item', '953', '954', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202230', 'PPSAS', '40202230', 'Service Concession Revenue', 'item', '955', '956', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202240', 'PPSAS', '40202240', 'Other Service Concession Revenue', 'item', '957', '958', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202250', 'PPSAS', '40202250', 'Lease Revenue', 'item', '959', '960', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202260', 'PPSAS', '40202260', 'Share in the Profit of Joint Venture', 'item', '961', '962', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202980', 'PPSAS', '40202980', 'Fines and Penalties - Business Income', 'item', '963', '964', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40202990', 'PPSAS', '40202990', 'Other Business Income', 'item', '965', '966', '4', 'PPSAS-40202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40301', 'PPSAS', '40301', 'Transfers, Assistance and Subsidy', 'group', '970', '983', '3', 'PPSAS-403');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40302', 'PPSAS', '40302', 'Transfers', 'group', '984', '989', '3', 'PPSAS-403');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40301010', 'PPSAS', '40301010', 'Subsidy from National Government', 'item', '971', '972', '4', 'PPSAS-40301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40301020', 'PPSAS', '40301020', 'Subsidy  from Local Government Units', 'item', '973', '974', '4', 'PPSAS-40301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40301030', 'PPSAS', '40301030', 'Subsidy from Government-Owned and/or Controlled Corporations', 'item', '975', '976', '4', 'PPSAS-40301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40301040', 'PPSAS', '40301040', 'Subsidy from Other Funds', 'item', '977', '978', '4', 'PPSAS-40301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40301050', 'PPSAS', '40301050', 'Subsidy from General Fund Proper/Other Special Accounts', 'item', '979', '980', '4', 'PPSAS-40301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40301060', 'PPSAS', '40301060', 'Subsidy from Other Local Economic Enterprise', 'item', '981', '982', '4', 'PPSAS-40301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40302010', 'PPSAS', '40302010', 'Transfers from General Fund of LGU Counterpart/Equity Share', 'item', '985', '986', '4', 'PPSAS-40302');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40302020', 'PPSAS', '40302020', 'Transfers from General Fund of Unspent DRRMF', 'item', '987', '988', '4', 'PPSAS-40302');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40401', 'PPSAS', '40401', 'Share', 'group', '992', '997', '3', 'PPSAS-404');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40402', 'PPSAS', '40402', 'Grants and Donations', 'group', '998', '1005', '3', 'PPSAS-404');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-404010', 'PPSAS', '404010', 'Share from PAGCOR', 'item', '993', '994', '4', 'PPSAS-40401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40401020', 'PPSAS', '40401020', 'Share from PCSO', 'item', '995', '996', '4', 'PPSAS-40401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40402010', 'PPSAS', '40402010', 'Grants and Donations in Cash', 'item', '999', '1000', '4', 'PPSAS-40402');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40402020', 'PPSAS', '40402020', 'Grants and Donations in Kind', 'item', '1001', '1002', '4', 'PPSAS-40402');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40402030', 'PPSAS', '40402030', 'Grants from Concessionary loans', 'item', '1003', '1004', '4', 'PPSAS-40402');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40501', 'PPSAS', '40501', 'Grains', 'group', '1008', '1035', '3', 'PPSAS-405');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40501010', 'PPSAS', '40501010', 'Gain from Changes in Fair Value of Financial Instruments', 'item', '1009', '1010', '4', 'PPSAS-40501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40501020', 'PPSAS', '40501020', 'Gain on Foreign Exchange (FOREX)', 'item', '1011', '1012', '4', 'PPSAS-40501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40501030', 'PPSAS', '40501030', 'Gain on Sale of Investments', 'item', '1013', '1014', '4', 'PPSAS-40501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40501040', 'PPSAS', '40501040', 'Gain on Sale of Investment Property', 'item', '1015', '1016', '4', 'PPSAS-40501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40501050', 'PPSAS', '40501050', 'Gain on Sale of Property, Plant and Equipment', 'item', '1017', '1018', '4', 'PPSAS-40501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40501060', 'PPSAS', '40501060', 'Gain on Initial Recognition of Biological Assets', 'item', '1019', '1020', '4', 'PPSAS-40501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40501070', 'PPSAS', '40501070', 'Gain on Sale of Biological Assets', 'item', '1021', '1022', '4', 'PPSAS-40501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40501080', 'PPSAS', '40501080', 'Gain from Changes in Fair Value  Less Cost to Sell of Biological Assets Due to Physical Change', 'item', '1023', '1024', '4', 'PPSAS-40501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40501090', 'PPSAS', '40501090', 'Gain from Changes in Fair Value  Less Cost to Sell of Biological Assets Due to Price Change', 'item', '1025', '1026', '4', 'PPSAS-40501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40501100', 'PPSAS', '40501100', 'Gain from Initial Recognition of Agricultural Produce', 'item', '1027', '1028', '4', 'PPSAS-40501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40501110', 'PPSAS', '40501110', 'Gain on Sale of Intangible Assets', 'item', '1029', '1030', '4', 'PPSAS-40501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40501120', 'PPSAS', '40501120', 'Reversal of Impairment Losses', 'item', '1031', '1032', '4', 'PPSAS-40501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40501990', 'PPSAS', '40501990', 'Other Gains', 'item', '1033', '1034', '4', 'PPSAS-40501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40601', 'PPSAS', '40601', 'Miscellaneous Income', 'group', '1038', '1041', '3', 'PPSAS-406');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40601010', 'PPSAS', '40601010', 'Miscellaneous Income', 'item', '1039', '1040', '4', 'PPSAS-40601');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40701', 'PPSAS', '40701', 'Sale of Assets', 'group', '1044', '1047', '3', 'PPSAS-407');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-40701010', 'PPSAS', '40701010', 'Sale of Garnished/Confiscated/Abandoned/Seized Goods and Properties', 'item', '1045', '1046', '4', 'PPSAS-40701');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-501', 'PPSAS', '501', 'Personnel Services', 'group', '1051', '1114', '2', 'PPSAS-5');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-502', 'PPSAS', '502', 'Maintenance and Other Operating Expenses', 'group', '1115', '1294', '2', 'PPSAS-5');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-503', 'PPSAS', '503', 'Financial Expenses', 'group', '1295', '1310', '2', 'PPSAS-5');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-504', 'PPSAS', '504', 'Direct Costs', 'group', '1311', '1324', '2', 'PPSAS-5');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-505', 'PPSAS', '505', 'Non-Cash Expenses', 'group', '1325', '1404', '2', 'PPSAS-5');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50101', 'PPSAS', '50101', 'Salaries and Wages', 'group', '1052', '1057', '3', 'PPSAS-501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50102', 'PPSAS', '50102', 'Other Compensation', 'group', '1058', '1091', '3', 'PPSAS-501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50103', 'PPSAS', '50103', 'Personnel Benefit Contributions', 'group', '1092', '1103', '3', 'PPSAS-501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50104', 'PPSAS', '50104', 'Other Personnel Benefits', 'group', '1104', '1113', '3', 'PPSAS-501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50101010', 'PPSAS', '50101010', 'Salaries and Wages - Regular', 'item', '1053', '1054', '4', 'PPSAS-50101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50101020', 'PPSAS', '50101020', 'Salaries and Wages - Casual/Contractual', 'item', '1055', '1056', '4', 'PPSAS-50101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50102010', 'PPSAS', '50102010', 'Personal Economic Relief Allowance (PERA)', 'item', '1059', '1060', '4', 'PPSAS-50102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50102020', 'PPSAS', '50102020', 'Representation Allowance (RA)', 'item', '1061', '1062', '4', 'PPSAS-50102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50102030', 'PPSAS', '50102030', 'Transportation Allowance (TA)', 'item', '1063', '1064', '4', 'PPSAS-50102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50102040', 'PPSAS', '50102040', 'Clothing/Uniform Allowance', 'item', '1065', '1066', '4', 'PPSAS-50102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50102050', 'PPSAS', '50102050', 'Subsistence Allowance', 'item', '1067', '1068', '4', 'PPSAS-50102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50102060', 'PPSAS', '50102060', 'Laundry  Allowance', 'item', '1069', '1070', '4', 'PPSAS-50102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50102070', 'PPSAS', '50102070', 'Quarters Allowance', 'item', '1071', '1072', '4', 'PPSAS-50102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50102080', 'PPSAS', '50102080', 'Productivity Incentive Allowance', 'item', '1073', '1074', '4', 'PPSAS-50102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50102090', 'PPSAS', '50102090', 'Overseas Allowance', 'item', '1075', '1076', '4', 'PPSAS-50102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50102100', 'PPSAS', '50102100', 'Honoraria', 'item', '1077', '1078', '4', 'PPSAS-50102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50102110', 'PPSAS', '50102110', 'Hazard Pay', 'item', '1079', '1080', '4', 'PPSAS-50102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50102120', 'PPSAS', '50102120', 'Longevity Pay', 'item', '1081', '1082', '4', 'PPSAS-50102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50102130', 'PPSAS', '50102130', 'Overtime and Night Pay', 'item', '1083', '1084', '4', 'PPSAS-50102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50102140', 'PPSAS', '50102140', 'Year End Bonus', 'item', '1085', '1086', '4', 'PPSAS-50102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50102150', 'PPSAS', '50102150', 'Cash Gift', 'item', '1087', '1088', '4', 'PPSAS-50102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50102990', 'PPSAS', '50102990', 'Other Bonuses and Allowances', 'item', '1089', '1090', '4', 'PPSAS-50102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50103010', 'PPSAS', '50103010', 'Retirement and Life Insurance Premiums', 'item', '1093', '1094', '4', 'PPSAS-50103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50103020', 'PPSAS', '50103020', 'Pag-IBIG Contributions', 'item', '1095', '1096', '4', 'PPSAS-50103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50103030', 'PPSAS', '50103030', 'PhilHealth Contributions', 'item', '1097', '1098', '4', 'PPSAS-50103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50103040', 'PPSAS', '50103040', 'Employees Compensation Insurance Premiums', 'item', '1099', '1100', '4', 'PPSAS-50103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50103050', 'PPSAS', '50103050', 'Provident/Welfare Fund Contributions', 'item', '1101', '1102', '4', 'PPSAS-50103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50104010', 'PPSAS', '50104010', 'Pension Benefits', 'item', '1105', '1106', '4', 'PPSAS-50104');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50104020', 'PPSAS', '50104020', 'Retirement Gratuity', 'item', '1107', '1108', '4', 'PPSAS-50104');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50104030', 'PPSAS', '50104030', 'Terminal Leave Benefits', 'item', '1109', '1110', '4', 'PPSAS-50104');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50104990', 'PPSAS', '50104990', 'Other Personnel Benefits', 'item', '1111', '1112', '4', 'PPSAS-50104');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50201', 'PPSAS', '50201', 'Traveling Expenses', 'group', '1116', '1121', '3', 'PPSAS-502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50202', 'PPSAS', '50202', 'Training and Scholarship Expenses', 'group', '1122', '1127', '3', 'PPSAS-502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50203', 'PPSAS', '50203', 'Supplies and Materials Expenses', 'group', '1128', '1157', '3', 'PPSAS-502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50204', 'PPSAS', '50204', 'Utility Expenses', 'group', '1158', '1163', '3', 'PPSAS-502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50205', 'PPSAS', '50205', 'Communication Expenses', 'group', '1164', '1173', '3', 'PPSAS-502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50206', 'PPSAS', '50206', 'Awards/Rewards and Prizes', 'group', '1174', '1179', '3', 'PPSAS-502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50207', 'PPSAS', '50207', 'Survey, Research, Exploration and Development Expenses', 'group', '1180', '1185', '3', 'PPSAS-502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50208', 'PPSAS', '50208', 'Demolition/Relocation and Desilting/Dredging Expenses', 'group', '1186', '1191', '3', 'PPSAS-502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50209', 'PPSAS', '50209', 'Generation, Transmission and Distribution Expenses', 'group', '1192', '1195', '3', 'PPSAS-502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50210', 'PPSAS', '50210', 'Confidential, Intelligence and Extraordinary Expenses', 'group', '1196', '1203', '3', 'PPSAS-502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50211', 'PPSAS', '50211', 'Professional Services', 'group', '1204', '1213', '3', 'PPSAS-502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50212', 'PPSAS', '50212', 'General Services', 'group', '1214', '1223', '3', 'PPSAS-502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50213', 'PPSAS', '50213', 'Repairs and Maintenance', 'group', '1224', '1245', '3', 'PPSAS-502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50214', 'PPSAS', '50214', 'Financial Assistance/Subsidy', 'group', '1246', '1259', '3', 'PPSAS-502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50215', 'PPSAS', '50215', 'Transfers', 'group', '1260', '1265', '3', 'PPSAS-502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50216', 'PPSAS', '50216', 'Taxes, Insurance Premiums and Other Fees', 'group', '1266', '1273', '3', 'PPSAS-502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50299', 'PPSAS', '50299', 'Other Maintenance and Operating Expenses', 'group', '1274', '1293', '3', 'PPSAS-502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50201010', 'PPSAS', '50201010', 'Traveling Expenses - Local', 'item', '1117', '1118', '4', 'PPSAS-50201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50201020', 'PPSAS', '50201020', 'Traveling Expenses - Foreign', 'item', '1119', '1120', '4', 'PPSAS-50201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50202010', 'PPSAS', '50202010', 'Training Expenses', 'item', '1123', '1124', '4', 'PPSAS-50202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50202020', 'PPSAS', '50202020', 'Scholarship Grants/Expenses', 'item', '1125', '1126', '4', 'PPSAS-50202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50203010', 'PPSAS', '50203010', 'Office Supplies Expenses', 'item', '1129', '1130', '4', 'PPSAS-50203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50203020', 'PPSAS', '50203020', 'Accountable Forms Expenses', 'item', '1131', '1132', '4', 'PPSAS-50203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50203030', 'PPSAS', '50203030', 'Non-Accountable Forms Expenses', 'item', '1133', '1134', '4', 'PPSAS-50203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50203040', 'PPSAS', '50203040', 'Animal/Zoological Supplies Expenses', 'item', '1135', '1136', '4', 'PPSAS-50203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50203050', 'PPSAS', '50203050', 'Food Supplies Expenses', 'item', '1137', '1138', '4', 'PPSAS-50203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50203060', 'PPSAS', '50203060', 'Welfare Goods Expenses', 'item', '1139', '1140', '4', 'PPSAS-50203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50203070', 'PPSAS', '50203070', 'Drugs and Medicines Expenses', 'item', '1141', '1142', '4', 'PPSAS-50203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50203080', 'PPSAS', '50203080', 'Medical, Dental and Laboratory Supplies Expenses', 'item', '1143', '1144', '4', 'PPSAS-50203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50203090', 'PPSAS', '50203090', 'Fuel, Oil and Lubricants Expenses', 'item', '1145', '1146', '4', 'PPSAS-50203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50203100', 'PPSAS', '50203100', 'Agricultural and Marine Supplies Expenses', 'item', '1147', '1148', '4', 'PPSAS-50203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50203110', 'PPSAS', '50203110', 'Textbooks and Instructional Materials Expenses', 'item', '1149', '1150', '4', 'PPSAS-50203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50203120', 'PPSAS', '50203120', 'Military, Police and Traffic Supplies Expenses', 'item', '1151', '1152', '4', 'PPSAS-50203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50203130', 'PPSAS', '50203130', 'Chemical and Filtering Supplies Expenses', 'item', '1153', '1154', '4', 'PPSAS-50203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50203990', 'PPSAS', '50203990', 'Other Supplies and Materials Expenses', 'item', '1155', '1156', '4', 'PPSAS-50203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50204010', 'PPSAS', '50204010', 'Water Expenses', 'item', '1159', '1160', '4', 'PPSAS-50204');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50204020', 'PPSAS', '50204020', 'Electricity Expenses', 'item', '1161', '1162', '4', 'PPSAS-50204');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50205010', 'PPSAS', '50205010', 'Postage and Courier Services', 'item', '1165', '1166', '4', 'PPSAS-50205');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50205020', 'PPSAS', '50205020', 'Telephone Expenses', 'item', '1167', '1168', '4', 'PPSAS-50205');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50205030', 'PPSAS', '50205030', 'Internet Subscription Expenses', 'item', '1169', '1170', '4', 'PPSAS-50205');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50205040', 'PPSAS', '50205040', 'Cable, Satellite, Telegraph and Radio Expenses', 'item', '1171', '1172', '4', 'PPSAS-50205');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50206010', 'PPSAS', '50206010', 'Awards/Rewards Expenses', 'item', '1175', '1176', '4', 'PPSAS-50206');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50206020', 'PPSAS', '50206020', 'Prizes', 'item', '1177', '1178', '4', 'PPSAS-50206');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50207010', 'PPSAS', '50207010', 'Survey Expenses', 'item', '1181', '1182', '4', 'PPSAS-50207');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50207020', 'PPSAS', '50207020', 'Research, Exploration and Development Expenses', 'item', '1183', '1184', '4', 'PPSAS-50207');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50208010', 'PPSAS', '50208010', 'Demolition and Relocation Expenses', 'item', '1187', '1188', '4', 'PPSAS-50208');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50208020', 'PPSAS', '50208020', 'Desilting and Dredging Expenses', 'item', '1189', '1190', '4', 'PPSAS-50208');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50209010', 'PPSAS', '50209010', 'Generation, Transmission and Distribution Expenses', 'item', '1193', '1194', '4', 'PPSAS-50209');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50210010', 'PPSAS', '50210010', 'Confidential Expenses', 'item', '1197', '1198', '4', 'PPSAS-50210');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50210020', 'PPSAS', '50210020', 'Intelligence Expenses', 'item', '1199', '1200', '4', 'PPSAS-50210');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50210030', 'PPSAS', '50210030', 'Extraordinary and Miscellaneous Expenses', 'item', '1201', '1202', '4', 'PPSAS-50210');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50211010', 'PPSAS', '50211010', 'Legal Services', 'item', '1205', '1206', '4', 'PPSAS-50211');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50211020', 'PPSAS', '50211020', 'Auditing Services', 'item', '1207', '1208', '4', 'PPSAS-50211');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50211030', 'PPSAS', '50211030', 'Consultancy Services', 'item', '1209', '1210', '4', 'PPSAS-50211');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50211990', 'PPSAS', '50211990', 'Other Professional Services', 'item', '1211', '1212', '4', 'PPSAS-50211');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50212010', 'PPSAS', '50212010', 'Environment/Sanitary Services', 'item', '1215', '1216', '4', 'PPSAS-50212');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50212020', 'PPSAS', '50212020', 'Janitorial Services', 'item', '1217', '1218', '4', 'PPSAS-50212');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50212030', 'PPSAS', '50212030', 'Security Services', 'item', '1219', '1220', '4', 'PPSAS-50212');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50212990', 'PPSAS', '50212990', 'Other General Services', 'item', '1221', '1222', '4', 'PPSAS-50212');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50213010', 'PPSAS', '50213010', 'Repairs and Maintenance - Investment Property', 'item', '1225', '1226', '4', 'PPSAS-50213');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50213020', 'PPSAS', '50213020', 'Repairs and Maintenance - Land Improvements', 'item', '1227', '1228', '4', 'PPSAS-50213');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50213030', 'PPSAS', '50213030', 'Repairs and Maintenance - Infrastructure Assets', 'item', '1229', '1230', '4', 'PPSAS-50213');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50213040', 'PPSAS', '50213040', 'Repairs and Maintenance - Buildings and Other Structures', 'item', '1231', '1232', '4', 'PPSAS-50213');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50213050', 'PPSAS', '50213050', 'Repairs and Maintenance - Machinery and Equipment', 'item', '1233', '1234', '4', 'PPSAS-50213');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50213060', 'PPSAS', '50213060', 'Repairs and Maintenance - Transportation Equipment', 'item', '1235', '1236', '4', 'PPSAS-50213');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50213070', 'PPSAS', '50213070', 'Repairs and Maintenance - Furniture and  Fixtures', 'item', '1237', '1238', '4', 'PPSAS-50213');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50213080', 'PPSAS', '50213080', 'Repairs and Maintenance - Leased Assets', 'item', '1239', '1240', '4', 'PPSAS-50213');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50213090', 'PPSAS', '50213090', 'Repairs and Maintenance - Leased Assets Improvements', 'item', '1241', '1242', '4', 'PPSAS-50213');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50213990', 'PPSAS', '50213990', 'Repairs and Maintenance - Other Property, Plant and Equipment', 'item', '1243', '1244', '4', 'PPSAS-50213');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50214020', 'PPSAS', '50214020', 'Subsidy to NGAs', 'item', '1247', '1248', '4', 'PPSAS-50214');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50214030', 'PPSAS', '50214030', 'Subsidy to Other Local Government Units', 'item', '1249', '1250', '4', 'PPSAS-50214');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50214060', 'PPSAS', '50214060', 'Subsidy to Other  Funds', 'item', '1251', '1252', '4', 'PPSAS-50214');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50214070', 'PPSAS', '50214070', 'Subsidy to General Fund Proper/Special Accounts', 'item', '1253', '1254', '4', 'PPSAS-50214');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50214080', 'PPSAS', '50214080', 'Subsidy to Local Economic Enterprises', 'item', '1255', '1256', '4', 'PPSAS-50214');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50214990', 'PPSAS', '50214990', 'Subsidies - Others', 'item', '1257', '1258', '4', 'PPSAS-50214');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50215010', 'PPSAS', '50215010', 'Transfers of Unspent Current Year DRRM Funds to the Trust Funds', 'item', '1261', '1262', '4', 'PPSAS-50215');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50215020', 'PPSAS', '50215020', 'Transfers for Project Equity Share /LGU Counterpart', 'item', '1263', '1264', '4', 'PPSAS-50215');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50216010', 'PPSAS', '50216010', 'Taxes, Duties and Licenses', 'item', '1267', '1268', '4', 'PPSAS-50216');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50216020', 'PPSAS', '50216020', 'Fidelity Bond Premiums', 'item', '1269', '1270', '4', 'PPSAS-50216');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50216030', 'PPSAS', '50216030', 'Insurance Expenses', 'item', '1271', '1272', '4', 'PPSAS-50216');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50299010', 'PPSAS', '50299010', 'Advertising Expenses', 'item', '1275', '1276', '4', 'PPSAS-50299');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50299020', 'PPSAS', '50299020', 'Printing and Publication Expenses', 'item', '1277', '1278', '4', 'PPSAS-50299');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50299030', 'PPSAS', '50299030', 'Representation Expenses', 'item', '1279', '1280', '4', 'PPSAS-50299');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50299040', 'PPSAS', '50299040', 'Transportation and Delivery Expenses', 'item', '1281', '1282', '4', 'PPSAS-50299');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50299050', 'PPSAS', '50299050', 'Rent Expenses', 'item', '1283', '1284', '4', 'PPSAS-50299');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50299060', 'PPSAS', '50299060', 'Membership Dues and Contributions to Organizations', 'item', '1285', '1286', '4', 'PPSAS-50299');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50299070', 'PPSAS', '50299070', 'Subscription Expenses', 'item', '1287', '1288', '4', 'PPSAS-50299');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50299080', 'PPSAS', '50299080', 'Donations', 'item', '1289', '1290', '4', 'PPSAS-50299');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-502990990', 'PPSAS', '502990990', 'Other Maintenance and Operating Expenses', 'item', '1291', '1292', '4', 'PPSAS-50299');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50301', 'PPSAS', '50301', 'Financial Expenses', 'group', '1296', '1309', '3', 'PPSAS-503');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50301010', 'PPSAS', '50301010', 'Management Supervision/Trusteeship Fees', 'item', '1297', '1298', '4', 'PPSAS-50301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50301020', 'PPSAS', '50301020', 'Interest Expenses', 'item', '1299', '1300', '4', 'PPSAS-50301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50301030', 'PPSAS', '50301030', 'Guarantee Fees', 'item', '1301', '1302', '4', 'PPSAS-50301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50301040', 'PPSAS', '50301040', 'Bank Charges', 'item', '1303', '1304', '4', 'PPSAS-50301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50301050', 'PPSAS', '50301050', 'Commitment Fees', 'item', '1305', '1306', '4', 'PPSAS-50301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50301990', 'PPSAS', '50301990', 'Other Financial Charges', 'item', '1307', '1308', '4', 'PPSAS-50301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50401', 'PPSAS', '50401', 'Cost of Goods Manufactured', 'group', '1312', '1319', '3', 'PPSAS-504');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50402', 'PPSAS', '50402', 'Cost of Sales', 'group', '1320', '1323', '3', 'PPSAS-504');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50401010', 'PPSAS', '50401010', 'Direct Materials', 'item', '1313', '1314', '4', 'PPSAS-50401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50401020', 'PPSAS', '50401020', 'Direct Labor', 'item', '1315', '1316', '4', 'PPSAS-50401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50401030', 'PPSAS', '50401030', 'Manufacturing Overhead', 'item', '1317', '1318', '4', 'PPSAS-50401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50402010', 'PPSAS', '50402010', 'Cost of Sales', 'item', '1321', '1322', '4', 'PPSAS-50402');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50501', 'PPSAS', '50501', 'Depreciation', 'group', '1326', '1349', '3', 'PPSAS-505');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50502', 'PPSAS', '50502', 'Amortization', 'group', '1350', '1353', '3', 'PPSAS-505');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50503', 'PPSAS', '50503', 'Impairment Loss', 'group', '1354', '1375', '3', 'PPSAS-505');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50504', 'PPSAS', '50504', 'Losses', 'group', '1376', '1399', '3', 'PPSAS-505');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50505', 'PPSAS', '50505', 'Grants', 'group', '1400', '1403', '3', 'PPSAS-505');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50501010', 'PPSAS', '50501010', 'Depreciation - Investment Property', 'item', '1327', '1328', '4', 'PPSAS-50501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50501020', 'PPSAS', '50501020', 'Depreciation - Land Improvements', 'item', '1329', '1330', '4', 'PPSAS-50501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50501030', 'PPSAS', '50501030', 'Depreciation - Infrastructure Assets', 'item', '1331', '1332', '4', 'PPSAS-50501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50501040', 'PPSAS', '50501040', 'Depreciation - Buildings and Other Structures', 'item', '1333', '1334', '4', 'PPSAS-50501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50501050', 'PPSAS', '50501050', 'Depreciation - Machinery  and Equipment', 'item', '1335', '1336', '4', 'PPSAS-50501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50501060', 'PPSAS', '50501060', 'Depreciation - Transportation Equipment', 'item', '1337', '1338', '4', 'PPSAS-50501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50501070', 'PPSAS', '50501070', 'Depreciation - Furniture, Fixtures and Books', 'item', '1339', '1340', '4', 'PPSAS-50501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50501080', 'PPSAS', '50501080', 'Depreciation - Leased Assets', 'item', '1341', '1342', '4', 'PPSAS-50501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50501090', 'PPSAS', '50501090', 'Depreciation - Leased Assets Improvements', 'item', '1343', '1344', '4', 'PPSAS-50501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50501100', 'PPSAS', '50501100', 'Depreciation -Service Concession Assets', 'item', '1345', '1346', '4', 'PPSAS-50501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50501990', 'PPSAS', '50501990', 'Depreciation - Other Property, Plant and Equipment', 'item', '1347', '1348', '4', 'PPSAS-50501');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50502010', 'PPSAS', '50502010', 'Amortization - Intangible Assets', 'item', '1351', '1352', '4', 'PPSAS-50502');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50503010', 'PPSAS', '50503010', 'Impairment Loss - Financial Assets Held to Maturity', 'item', '1355', '1356', '4', 'PPSAS-50503');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50503020', 'PPSAS', '50503020', 'Impairment Loss - Loans and  Receivables', 'item', '1357', '1358', '4', 'PPSAS-50503');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50503030', 'PPSAS', '50503030', 'Impairment Loss - Lease Receivables', 'item', '1359', '1360', '4', 'PPSAS-50503');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50503040', 'PPSAS', '50503040', 'Impairment Loss - Investments in GOCCs', 'item', '1361', '1362', '4', 'PPSAS-50503');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50503050', 'PPSAS', '50503050', 'Impairment Loss - Investments in Joint Venture', 'item', '1363', '1364', '4', 'PPSAS-50503');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50503060', 'PPSAS', '50503060', 'Impairment Loss - Other Receivables', 'item', '1365', '1366', '4', 'PPSAS-50503');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50503070', 'PPSAS', '50503070', 'Impairment Loss - Inventories', 'item', '1367', '1368', '4', 'PPSAS-50503');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50503080', 'PPSAS', '50503080', 'Impairment Loss - Investment Property', 'item', '1369', '1370', '4', 'PPSAS-50503');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50503090', 'PPSAS', '50503090', 'Impairment Loss - Property, Plant and Equipment', 'item', '1371', '1372', '4', 'PPSAS-50503');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50503100', 'PPSAS', '50503100', 'Impairment Loss - Intangible Assets', 'item', '1373', '1374', '4', 'PPSAS-50503');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50504010', 'PPSAS', '50504010', 'Loss on Foreign Exchange (FOREX)', 'item', '1377', '1378', '4', 'PPSAS-50504');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50504020', 'PPSAS', '50504020', 'Loss on Sale of Investments', 'item', '1379', '1380', '4', 'PPSAS-50504');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50504030', 'PPSAS', '50504030', 'Loss on Sale of Investment Property', 'item', '1381', '1382', '4', 'PPSAS-50504');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50504040', 'PPSAS', '50504040', 'Loss on Sale of Propery, Plant and Equipment', 'item', '1383', '1384', '4', 'PPSAS-50504');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50504050', 'PPSAS', '50504050', 'Loss on Sale of Biological Assets', 'item', '1385', '1386', '4', 'PPSAS-50504');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50504060', 'PPSAS', '50504060', 'Loss on Sale of Intangible Assets', 'item', '1387', '1388', '4', 'PPSAS-50504');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50504070', 'PPSAS', '50504070', 'Loss on Sale of Assets', 'item', '1389', '1390', '4', 'PPSAS-50504');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50504080', 'PPSAS', '50504080', 'Loss on Initial Recognition of Biological Assets', 'item', '1391', '1392', '4', 'PPSAS-50504');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50504090', 'PPSAS', '50504090', 'Loss of Assets', 'item', '1393', '1394', '4', 'PPSAS-50504');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50504100', 'PPSAS', '50504100', 'Loss on Guaranty', 'item', '1395', '1396', '4', 'PPSAS-50504');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50504990', 'PPSAS', '50504990', 'Other Losses', 'item', '1397', '1398', '4', 'PPSAS-50504');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('PPSAS-50505010', 'PPSAS', '50505010', 'Grants for Concessionary loans', 'item', '1401', '1402', '4', 'PPSAS-50505');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1', 'SRE', '1', 'RECEIPTS', 'root', '0', '285', '1', NULL);
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-2', 'SRE', '2', 'EXPENDITURES', 'root', '286', '287', '1', NULL);
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101', 'SRE', '101', 'LOCAL SOURCES', 'group', '1', '204', '2', 'SRE-1');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-102', 'SRE', '102', 'EXTERNAL SOURCES', 'group', '205', '266', '2', 'SRE-1');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-103', 'SRE', '103', 'TRUST FUND RECEIPTS', 'group', '267', '284', '2', 'SRE-1');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101', 'SRE', '10101', 'TAX REVENUE', 'group', '2', '81', '3', 'SRE-101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102', 'SRE', '10102', 'NON-TAX REVENUES', 'group', '82', '203', '3', 'SRE-101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1010101', 'SRE', '1010101', 'REAL PROPERTY TAX', 'group', '3', '32', '4', 'SRE-10101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1010102', 'SRE', '1010102', 'TAX ON BUSINESS', 'group', '33', '66', '4', 'SRE-10101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1010103', 'SRE', '1010103', 'OTHER TAXES', 'group', '67', '80', '4', 'SRE-10101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101010101', 'SRE', '101010101', 'Real Property Tax -Basic', 'group', '4', '13', '5', 'SRE-1010101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101010102', 'SRE', '101010102', 'Special Levy on Idle Lands', 'group', '14', '23', '5', 'SRE-1010101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101010103', 'SRE', '101010103', 'Special Levy on Land Benefited by Public Works Projects', 'group', '24', '31', '5', 'SRE-1010101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101010101', 'SRE', '10101010101', 'Current Year', 'item', '5', '6', '6', 'SRE-101010101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101010102', 'SRE', '10101010102', 'Fines and Penalties-Current Year', 'item', '7', '8', '6', 'SRE-101010101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101010103', 'SRE', '10101010103', 'Prior Year/s', 'item', '9', '10', '6', 'SRE-101010101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101010104', 'SRE', '10101010104', 'Fines and Penalties-Prior Year/s', 'item', '11', '12', '6', 'SRE-101010101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101010201', 'SRE', '10101010201', 'Current Year', 'item', '15', '16', '6', 'SRE-101010102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101010202', 'SRE', '10101010202', 'Fines and Penalties-Current Year', 'item', '17', '18', '6', 'SRE-101010102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101010203', 'SRE', '10101010203', 'Prior Year/s', 'item', '19', '20', '6', 'SRE-101010102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101010204', 'SRE', '10101010204', 'Fines and Penalties-Prior Year/s', 'item', '21', '22', '6', 'SRE-101010102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101010301', 'SRE', '10101010301', 'Current Year', 'item', '25', '26', '6', 'SRE-101010103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101010302', 'SRE', '10101010302', 'Fines and Penalties-Current Year', 'item', '27', '28', '6', 'SRE-101010103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101010303', 'SRE', '10101010303', 'Prior Year/s', 'item', '29', '30', '6', 'SRE-101010103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101010201', 'SRE', '101010201', 'Amusement Tax', 'item', '34', '35', '5', 'SRE-1010102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101010202', 'SRE', '101010202', 'Business Tax', 'group', '36', '57', '5', 'SRE-1010102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101010203', 'SRE', '101010203', 'Franchise Tax', 'item', '58', '59', '5', 'SRE-1010102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101010204', 'SRE', '101010204', 'Tax on Delivery Trucks and Vans', 'item', '60', '61', '5', 'SRE-1010102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101010205', 'SRE', '101010205', 'Tax on Sand, Gravel & Other Quarry Resources', 'item', '62', '63', '5', 'SRE-1010102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101010206', 'SRE', '101010206', 'Fines and Penalties-Business Taxes', 'item', '64', '65', '5', 'SRE-1010102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101020201', 'SRE', '10101020201', 'Manufacturers, Assemblers, etc.', 'item', '37', '38', '6', 'SRE-101010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101020202', 'SRE', '10101020202', 'Wholesalers, Distributors, etc.', 'item', '39', '40', '6', 'SRE-101010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101020203', 'SRE', '10101020203', 'Exporters, Manufacturers, Dealers, etc.', 'item', '41', '42', '6', 'SRE-101010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101020204', 'SRE', '10101020204', 'Retailers', 'item', '43', '44', '6', 'SRE-101010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101020205', 'SRE', '10101020205', 'Contractors and other Independent contractors', 'item', '45', '46', '6', 'SRE-101010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101020206', 'SRE', '10101020206', 'Banks & Other Financial Institutions', 'item', '47', '48', '6', 'SRE-101010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101020207', 'SRE', '10101020207', 'Peddlers', 'item', '49', '50', '6', 'SRE-101010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101020208', 'SRE', '10101020208', 'Printing & Publication Tax', 'item', '51', '52', '6', 'SRE-101010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101020209', 'SRE', '10101020209', 'Tax on Amusement Places', 'item', '53', '54', '6', 'SRE-101010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10101020210', 'SRE', '10101020210', 'Other Business Taxes', 'item', '55', '56', '6', 'SRE-101010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101010301', 'SRE', '101010301', 'Community Tax-Corporation', 'item', '68', '69', '5', 'SRE-1010103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101010302', 'SRE', '101010302', 'Community Tax-Individual', 'item', '70', '71', '5', 'SRE-1010103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101010303', 'SRE', '101010303', 'Professional Tax', 'item', '72', '73', '5', 'SRE-1010103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101010304', 'SRE', '101010304', 'Real Property Transfer Tax', 'item', '74', '75', '5', 'SRE-1010103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101010305', 'SRE', '101010305', 'Other Taxes', 'item', '76', '77', '5', 'SRE-1010103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101010306', 'SRE', '101010306', 'Fines and Penalties-Other Taxes', 'item', '78', '79', '5', 'SRE-1010103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1010201', 'SRE', '1010201', 'REGULATORY FEES (Permits and Licenses)', 'group', '83', '114', '4', 'SRE-10102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1010202', 'SRE', '1010202', 'SERVICE/USER CHARGES (Service Income)', 'group', '115', '150', '4', 'SRE-10102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1010203', 'SRE', '1010203', 'RECEIPTS FROM ECONOMIC ENTERPRISES (Business Income)', 'group', '151', '188', '4', 'SRE-10102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1010204', 'SRE', '1010204', 'OTHER INCOME/RECEIPTS (Other General Income)', 'group', '189', '202', '4', 'SRE-10102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101020101', 'SRE', '101020101', 'Permits and Licenses', 'group', '84', '103', '5', 'SRE-1010201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101020102', 'SRE', '101020102', 'Registration Fees', 'group', '104', '109', '5', 'SRE-1010201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101020103', 'SRE', '101020103', 'Inspection Fees', 'item', '110', '111', '5', 'SRE-1010201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101020104', 'SRE', '101020104', 'Fines and Penalties-Permits and Licenses', 'item', '112', '113', '5', 'SRE-1010201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102010101', 'SRE', '10102010101', 'Fees on Weights and Measures', 'item', '85', '86', '6', 'SRE-101020101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102010102', 'SRE', '10102010102', 'Fishery Rental Fees and Privilege Fees', 'item', '87', '88', '6', 'SRE-101020101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102010103', 'SRE', '10102010103', 'Franchising and Licensing Fees', 'item', '89', '90', '6', 'SRE-101020101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102010104', 'SRE', '10102010104', 'Business Permit Fees', 'item', '91', '92', '6', 'SRE-101020101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102010105', 'SRE', '10102010105', 'Building Permit Fees', 'item', '93', '94', '6', 'SRE-101020101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102010106', 'SRE', '10102010106', 'Zonal/Location Permit Fees', 'item', '95', '96', '6', 'SRE-101020101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102010107', 'SRE', '10102010107', 'Tricycle Operators Permit Fees', 'item', '97', '98', '6', 'SRE-101020101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102010108', 'SRE', '10102010108', 'Occupational Fees', 'item', '99', '100', '6', 'SRE-101020101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102010109', 'SRE', '10102010109', 'Other Permits & Licenses', 'item', '101', '102', '6', 'SRE-101020101');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102010201', 'SRE', '10102010201', 'Cattle/Animal Registration Fees', 'item', '105', '106', '6', 'SRE-101020102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102010202', 'SRE', '10102010202', 'Civil Registration Fees', 'item', '107', '108', '6', 'SRE-101020102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101020201', 'SRE', '101020201', 'Clearance and Certification Fees', 'group', '116', '125', '5', 'SRE-1010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101020202', 'SRE', '101020202', 'Other Fees', 'group', '126', '135', '5', 'SRE-1010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101020203', 'SRE', '101020203', 'Fines and Penalties-Service Income', 'item', '136', '137', '5', 'SRE-1010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101020204', 'SRE', '101020204', 'Landing and Aeronautical Fees', 'item', '138', '139', '5', 'SRE-1010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101020205', 'SRE', '101020205', 'Parking and Terminal Fees', 'item', '140', '141', '5', 'SRE-1010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101020206', 'SRE', '101020206', 'Hospital Fees', 'item', '142', '143', '5', 'SRE-1010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101020207', 'SRE', '101020207', 'Medical, Dental and Laboratory Fees', 'item', '144', '145', '5', 'SRE-1010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101020208', 'SRE', '101020208', 'Market & Slaughterhouse Fees', 'item', '146', '147', '5', 'SRE-1010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101020209', 'SRE', '101020209', 'Printing and Publication Fees', 'item', '148', '149', '5', 'SRE-1010202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102020101', 'SRE', '10102020101', 'Police Clearance', 'item', '117', '118', '6', 'SRE-101020201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102020102', 'SRE', '10102020102', 'Secretary''s Fees', 'item', '119', '120', '6', 'SRE-101020201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102020103', 'SRE', '10102020103', 'Health Certificate', 'item', '121', '122', '6', 'SRE-101020201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102020104', 'SRE', '10102020104', 'Other Clearance and Certification', 'item', '123', '124', '6', 'SRE-101020201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102020201', 'SRE', '10102020201', 'Garbage Fees', 'item', '127', '128', '6', 'SRE-101020202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102020202', 'SRE', '10102020202', 'Wharfage Fees', 'item', '129', '130', '6', 'SRE-101020202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102020203', 'SRE', '10102020203', 'Toll Fees', 'item', '131', '132', '6', 'SRE-101020202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102020204', 'SRE', '10102020204', 'Other Service Income', 'item', '133', '134', '6', 'SRE-101020202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101020301', 'SRE', '101020301', 'Receipts from Economic Enterprises (Business Income)', 'group', '152', '187', '5', 'SRE-1010203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102030101', 'SRE', '10102030101', 'School Operations', 'item', '153', '154', '6', 'SRE-101020301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102030102', 'SRE', '10102030102', 'Power Generation/Distribution', 'item', '155', '156', '6', 'SRE-101020301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102030103', 'SRE', '10102030103', 'Hospital Operations', 'item', '157', '158', '6', 'SRE-101020301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102030104', 'SRE', '10102030104', 'Canteen/Restaurant Operations', 'item', '159', '160', '6', 'SRE-101020301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102030105', 'SRE', '10102030105', 'Cemetery Operations', 'item', '161', '162', '6', 'SRE-101020301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102030106', 'SRE', '10102030106', 'Communication Facilities & Equipment Operations', 'item', '163', '164', '6', 'SRE-101020301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102030107', 'SRE', '10102030107', 'Dormitory Operations', 'item', '165', '166', '6', 'SRE-101020301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102030108', 'SRE', '10102030108', 'Market Operations', 'item', '167', '168', '6', 'SRE-101020301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102030109', 'SRE', '10102030109', 'Slaughterhouse Operations', 'item', '169', '170', '6', 'SRE-101020301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102030110', 'SRE', '10102030110', 'Transportation System Operations', 'item', '171', '172', '6', 'SRE-101020301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102030111', 'SRE', '10102030111', 'Waterworks System Operations', 'item', '173', '174', '6', 'SRE-101020301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102030112', 'SRE', '10102030112', 'Printing & Publication Operations', 'item', '175', '176', '6', 'SRE-101020301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102030113', 'SRE', '10102030113', 'Lease/Rental of Facilities', 'item', '177', '178', '6', 'SRE-101020301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102030114', 'SRE', '10102030114', 'Trading Business', 'item', '179', '180', '6', 'SRE-101020301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102030115', 'SRE', '10102030115', 'Other Economic Enterprises', 'item', '181', '182', '6', 'SRE-101020301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102030116', 'SRE', '10102030116', 'Fines and Penalties-Economic Enterprises', 'item', '183', '184', '6', 'SRE-101020301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102030117', 'SRE', '10102030117', 'Prepaid Income (Prepaid Rent)', 'item', '185', '186', '6', 'SRE-101020301');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101020401', 'SRE', '101020401', 'Interest Income', 'item', '190', '191', '5', 'SRE-1010204');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101020402', 'SRE', '101020402', 'Dividend Income', 'item', '192', '193', '5', 'SRE-1010204');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-101020403', 'SRE', '101020403', 'Other General Income (Miscellaneous)', 'group', '194', '201', '5', 'SRE-1010204');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102040301', 'SRE', '10102040301', 'Rebates on MMDA Contribution', 'item', '195', '196', '6', 'SRE-101020403');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102040302', 'SRE', '10102040302', 'Sales of Confiscated/Abandoned/Seized Goods & Properties', 'item', '197', '198', '6', 'SRE-101020403');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10102040303', 'SRE', '10102040303', 'Miscellaneous - Others', 'item', '199', '200', '6', 'SRE-101020403');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10201', 'SRE', '10201', 'INTERNAL REVENUE ALLOTMENT', 'group', '206', '211', '3', 'SRE-102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10202', 'SRE', '10202', 'OTHER SHARES FROM NATIONAL TAX COLLECTIONS', 'group', '212', '235', '3', 'SRE-102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10203', 'SRE', '10203', 'INTER-LOCAL TRANSFERS', 'group', '236', '241', '3', 'SRE-102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10204', 'SRE', '10204', 'EXTRAORDINARY RECEIPTS/GRANTS/DONATIONS/AIDS', 'group', '242', '265', '3', 'SRE-102');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1020101', 'SRE', '1020101', 'Current Year', 'item', '207', '208', '4', 'SRE-10201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1020102', 'SRE', '1020102', 'Prior Year', 'item', '209', '210', '4', 'SRE-10201');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1020201', 'SRE', '1020201', 'Share from Economic Zone (RA 7227)', 'item', '213', '214', '4', 'SRE-10202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1020202', 'SRE', '1020202', 'Share from EVAT', 'item', '215', '216', '4', 'SRE-10202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1020203', 'SRE', '1020203', 'Share from National Wealth', 'group', '217', '228', '4', 'SRE-10202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1020204', 'SRE', '1020204', 'Share from PAGCOR/PCSO/Lotto', 'item', '229', '230', '4', 'SRE-10202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1020205', 'SRE', '1020205', 'Share from Tobacco Excise Tax (RA 7171)', 'item', '231', '232', '4', 'SRE-10202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1020206', 'SRE', '1020206', 'Others', 'item', '233', '234', '4', 'SRE-10202');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-102020301', 'SRE', '102020301', 'Mining Taxes', 'item', '218', '219', '5', 'SRE-1020203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-102020302', 'SRE', '102020302', 'Utilization of hydrothermal, geothermal and other sources of energy', 'item', '220', '221', '5', 'SRE-1020203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-102020303', 'SRE', '102020303', 'Forestry Charges', 'item', '222', '223', '5', 'SRE-1020203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-102020304', 'SRE', '102020304', 'Mineral Reservations', 'item', '224', '225', '5', 'SRE-1020203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-102020305', 'SRE', '102020305', 'Others', 'item', '226', '227', '5', 'SRE-1020203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1020301', 'SRE', '1020301', 'Subsidy from LGUs', 'item', '237', '238', '4', 'SRE-10203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1020302', 'SRE', '1020302', 'Subsidy from Other Funds', 'item', '239', '240', '4', 'SRE-10203');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1020401', 'SRE', '1020401', 'Grants and Donations', 'group', '243', '248', '4', 'SRE-10204');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1020402', 'SRE', '1020402', 'Subsidy Income', 'group', '249', '254', '4', 'SRE-10204');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-1020403', 'SRE', '1020403', 'Extraordinary Gains and Premiums', 'group', '255', '264', '4', 'SRE-10204');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-102040101', 'SRE', '102040101', 'Domestic', 'item', '244', '245', '5', 'SRE-1020401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-102040102', 'SRE', '102040102', 'Foreign', 'item', '246', '247', '5', 'SRE-1020401');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-102040201', 'SRE', '102040201', 'Other Subsidy Income', 'item', '250', '251', '5', 'SRE-1020402');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-102040202', 'SRE', '102040202', 'Subsidy from GOCCs', 'item', '252', '253', '5', 'SRE-1020402');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-102040301', 'SRE', '102040301', 'Gain on FOREX', 'item', '256', '257', '5', 'SRE-1020403');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-102040302', 'SRE', '102040302', 'Gain on Sale of Assets', 'item', '258', '259', '5', 'SRE-1020403');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-102040303', 'SRE', '102040303', 'Premium on Bonds Payable', 'item', '260', '261', '5', 'SRE-1020403');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-102040304', 'SRE', '102040304', 'Gain on Sale of Investments', 'item', '262', '263', '5', 'SRE-1020403');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10301', 'SRE', '10301', 'General Public Services', 'item', '268', '269', '3', 'SRE-103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10302', 'SRE', '10302', 'Education, Culture & Sports/Manpower Development', 'item', '270', '271', '3', 'SRE-103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10303', 'SRE', '10303', 'Health, Nutrition & Population Control', 'item', '272', '273', '3', 'SRE-103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10304', 'SRE', '10304', 'Labor and Employment', 'item', '274', '275', '3', 'SRE-103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10305', 'SRE', '10305', 'Housing and Community Development', 'item', '276', '277', '3', 'SRE-103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10306', 'SRE', '10306', 'Social Services and Social Welfare', 'item', '278', '279', '3', 'SRE-103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10307', 'SRE', '10307', 'Economic Services', 'item', '280', '281', '3', 'SRE-103');
INSERT INTO `account` (`objid`, `maingroupid`, `code`, `title`, `type`, `leftindex`, `rightindex`, `level`, `groupid`) VALUES ('SRE-10308', 'SRE', '10308', 'Debt Service (FE) (Interest Expense & Other Charges)', 'item', '282', '283', '3', 'SRE-103');


alter table account add constraint fk_account_maingroupid 
  foreign key (maingroupid) references account_maingroup (objid) 
;
alter table account add constraint fk_account_groupid 
  foreign key (groupid) references account (objid) 
;


alter table account_item_mapping add constraint fk_account_item_mapping_maingroupid 
  foreign key (maingroupid) references account_maingroup (objid) 
;
alter table account_item_mapping add constraint fk_account_item_mapping_acctid  
  foreign key (acctid) references account (objid) 
;
alter table account_item_mapping add constraint fk_account_item_mapping_itemid  
  foreign key (itemid) references itemaccount (objid) 
;



-- ## patch-04

-- 
-- Insert data into account_maingroup 
-- 
insert into account_maingroup (
  objid, title, version, reporttype, role, domain, `system` 
)
select * 
from ( 
  select  
    'SRE-V254' as objid, 'SRE-V254' as title, 0 as version, 
    'SRE' as reporttype, NULL as role, NULL as domain, 0 as `system` 
)t1
where t1.objid not in (select objid from account_maingroup where objid = t1.objid)
;

-- 
-- Insert data into account 
-- 
insert into account ( 
  objid, maingroupid, code, title, groupid, 
  type, leftindex, rightindex, `level` 
) 
select * 
from ( 
  select 
    objid, 'SRE-V254' as maingroupid, code, title, parentid as groupid, 
    'root' as type, null as leftindex, null as rightindex, null as `level` 
  from sreaccount where parentid is null
  union all 
  select 
    a.objid, 'SRE-V254' as maingroupid, a.code, a.title, a.parentid as groupid, 
    'group' as type, null as leftindex, null as rightindex, null as `level` 
  from sreaccount a, sreaccount p  
  where a.parentid is not null 
    and a.parentid = p.objid 
    and a.type = 'group' 
  union all 
  select 
    a.objid, 'SRE-V254' as maingroupid, a.code, a.title, a.parentid as groupid, 
    'item' as type, null as leftindex, null as rightindex, null as `level` 
  from sreaccount a, sreaccount p  
  where a.parentid is not null 
    and a.parentid = p.objid 
    and a.type = 'detail' 
  union all 
  select 
    a.objid, 'SRE-V254' as maingroupid, a.code, a.title, a.parentid as groupid, 
    'detail' as type, null as leftindex, null as rightindex, null as `level` 
  from sreaccount a, sreaccount p  
  where a.parentid is not null 
    and a.parentid = p.objid 
    and a.type = 'subaccount'  
)t1 
where t1.objid not in (select objid from account where objid = t1.objid) 
;


-- 
-- Insert data into account_item_mapping 
-- 
insert into account_item_mapping ( 
  objid, maingroupid, acctid, itemid 
) 
select 
  rm.objid, a.maingroupid, 
  rm.acctid, rm.revenueitemid as itemid 
from sre_revenue_mapping rm 
  inner join account a on a.objid = rm.acctid 
  inner join itemaccount ia on ia.objid = rm.revenueitemid 
where rm.objid not in (select objid from account_item_mapping where objid = rm.objid)
;


-- 
-- Insert data into account_incometarget 
-- 
insert into account_incometarget (
  objid, itemid, year, target 
)
select * 
from (  
  select 
    concat('', convert(a.year, char), '|', a.objid) as objid, 
    a.objid as itemid, a.year, a.target 
  from sreaccount_incometarget a 
  where a.target is not null 
)t1 
where (select count(*) from account_incometarget where itemid = t1.itemid and year = t1.year) = 0 
order by t1.year, t1.objid 
;


-- 
-- TRANSFER NGAS ACCOUNTS 
--
-- 
-- Insert data into account_maingroup 
-- 
insert into account_maingroup (
  objid, title, version, reporttype, role, domain, `system` 
)
select * 
from ( 
  select  
    'NGAS' as objid, 'NGAS' as title, 0 as version, 
    'NGAS' as reporttype, NULL as role, NULL as domain, 0 as `system` 
)t1
where t1.objid not in (select objid from account_maingroup where objid = t1.objid)
;

-- 
-- Insert data into account 
-- 
alter table account drop foreign key fk_account_groupid
;

insert into account ( 
  objid, maingroupid, code, title, groupid, 
  type, leftindex, rightindex, `level` 
) 
select * 
from ( 
  select 
    objid, 'NGAS' as maingroupid, code, title, parentid as groupid, 
    'root' as type, null as leftindex, null as rightindex, null as `level` 
  from ngasaccount where parentid is null
  union all 
  select 
    a.objid, 'NGAS' as maingroupid, a.code, a.title, a.parentid as groupid, 
    'group' as type, null as leftindex, null as rightindex, null as `level` 
  from ngasaccount a, ngasaccount p  
  where a.parentid is not null 
    and a.parentid = p.objid 
    and a.type = 'group' 
  union all 
  select 
    a.objid, 'NGAS' as maingroupid, a.code, a.title, a.parentid as groupid, 
    'item' as type, null as leftindex, null as rightindex, null as `level` 
  from ngasaccount a, ngasaccount p  
  where a.parentid is not null 
    and a.parentid = p.objid 
    and a.type = 'detail' 
  union all 
  select 
    a.objid, 'NGAS' as maingroupid, a.code, a.title, a.parentid as groupid, 
    'detail' as type, null as leftindex, null as rightindex, null as `level` 
  from ngasaccount a, ngasaccount p  
  where a.parentid is not null 
    and a.parentid = p.objid 
    and a.type = 'subaccount'  
)t1 
where t1.objid not in (select objid from account where objid = t1.objid) 
;

alter table account add CONSTRAINT `fk_account_groupid` 
  FOREIGN KEY (`groupid`) REFERENCES `account` (`objid`)
; 

-- 
-- Insert data into account_item_mapping 
-- 
insert into account_item_mapping ( 
  objid, maingroupid, acctid, itemid 
) 
select 
  rm.objid, a.maingroupid, 
  rm.acctid, rm.revenueitemid as itemid 
from ngas_revenue_mapping rm 
  inner join account a on a.objid = rm.acctid 
  inner join itemaccount ia on ia.objid = rm.revenueitemid 
where rm.objid not in (select objid from account_item_mapping where objid = rm.objid)
;



-- ## patch-05

CREATE TABLE `afrequest` (
  `objid` varchar(50) NOT NULL,
  `reqno` varchar(20) NULL,
  `state` varchar(25) NOT NULL,
  `dtfiled` datetime NULL,
  `reqtype` varchar(10) NULL,
  `itemclass` varchar(50) NULL,
  `requester_objid` varchar(50) NULL,
  `requester_name` varchar(50) NULL,
  `requester_title` varchar(50) NULL,
  `org_objid` varchar(50) NULL,
  `org_name` varchar(50) NULL,
  `vendor` varchar(100) NULL,
  `respcenter_objid` varchar(50) NULL,
  `respcenter_name` varchar(100) NULL,
  `dtapproved` datetime NULL,
  `approvedby_objid` varchar(50) NULL,
  `approvedby_name` varchar(160) NULL,
  constraint pk_afrequest PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8 
;
create UNIQUE index `uix_reqno` on afrequest (`reqno`) ; 
create index `ix_dtfiled` on afrequest (`dtfiled`) ; 
create index `ix_org_objid` on afrequest (`org_objid`) ; 
create index `ix_requester_name` on afrequest (`requester_name`) ; 
create index `ix_requester_objid` on afrequest (`requester_objid`) ; 
create index `ix_state` on afrequest (`state`) ; 
create index `ix_dtapproved` on afrequest (`dtapproved`) ; 
create index `ix_approvedby_objid` on afrequest (`approvedby_objid`) ; 
create index `ix_approvedby_name` on afrequest (`approvedby_name`) ; 


CREATE TABLE `afrequestitem` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NULL,
  `item_objid` varchar(50) NULL,
  `item_code` varchar(50) NULL,
  `item_title` varchar(255) NULL,
  `unit` varchar(10) NULL,
  `qty` int(11) NULL,
  `qtyreceived` int(11) NULL,
  constraint pk_afrequestitem PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_parentid` on afrequestitem (`parentid`) ; 
create index `ix_item_objid` on afrequestitem (`item_objid`) ; 
alter table afrequestitem add CONSTRAINT `fk_afrequestitem_parentid` 
  FOREIGN KEY (`parentid`) REFERENCES `afrequest` (`objid`) ;


CREATE TABLE `aftxn_type` (
  `txntype` varchar(50) NOT NULL,
  `formtype` varchar(50) NULL,
  `poststate` varchar(50) NULL,
  `sortorder` int(11) NULL,
  constraint pk_aftxn_type PRIMARY KEY (`txntype`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

INSERT INTO `aftxn_type` (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('PURCHASE', 'PURCHASE_RECEIPT', 'OPEN', '0');
INSERT INTO `aftxn_type` (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('BEGIN', 'BEGIN_BALANCE', 'OPEN', '1');
INSERT INTO `aftxn_type` (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('FORWARD', 'FORWARD', 'ISSUED', '2');
INSERT INTO `aftxn_type` (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('COLLECTION', 'ISSUE', 'ISSUED', '3');
INSERT INTO `aftxn_type` (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('SALE', 'ISSUE', 'SOLD', '4');
INSERT INTO `aftxn_type` (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('TRANSFER_COLLECTION', 'TRANSFER', 'ISSUED', '5');
INSERT INTO `aftxn_type` (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('TRANSFER_SALE', 'TRANSFER', 'ISSUED', '6');
INSERT INTO `aftxn_type` (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('RETURN_COLLECTION', 'RETURN', 'OPEN', '7');
INSERT INTO `aftxn_type` (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('RETURN_SALE', 'RETURN', 'OPEN', '8');


CREATE TABLE `aftxn` (
  `objid` varchar(100) NOT NULL,
  `state` varchar(50) NULL,
  `request_objid` varchar(50) NULL,
  `request_reqno` varchar(50) NULL,
  `controlno` varchar(50) NULL,
  `dtfiled` datetime NULL,
  `user_objid` varchar(50) NULL,
  `user_name` varchar(100) NULL,
  `issueto_objid` varchar(50) NULL,
  `issueto_name` varchar(100) NULL,
  `issueto_title` varchar(50) NULL,
  `org_objid` varchar(50) NULL,
  `org_name` varchar(50) NULL,
  `respcenter_objid` varchar(50) NULL,
  `respcenter_name` varchar(100) NULL,
  `txndate` datetime NOT NULL,
  `cost` decimal(16,2) NULL,
  `txntype` varchar(50) NULL,
  `particulars` varchar(255) NULL,
  `issuefrom_objid` varchar(50) NULL,
  `issuefrom_name` varchar(150) NULL,
  `issuefrom_title` varchar(150) NULL,
  constraint pk_aftxn PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_issueno` on aftxn (`controlno`) ; 
create index `ix_dtfiled` on aftxn (`dtfiled`) ; 
create index `ix_issuefrom_name` on aftxn (`issuefrom_name`) ; 
create index `ix_issuefrom_objid` on aftxn (`issuefrom_objid`) ; 
create index `ix_issueto_objid` on aftxn (`issueto_objid`) ; 
create index `ix_org_objid` on aftxn (`org_objid`) ; 
create index `ix_request_objid` on aftxn (`request_objid`) ; 
create index `ix_request_reqno` on aftxn (`request_reqno`) ; 
create index `ix_user_objid` on aftxn (`user_objid`) ; 


CREATE TABLE `aftxnitem` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(100) NOT NULL,
  `item_objid` varchar(50) NULL,
  `item_code` varchar(50) NULL,
  `item_title` varchar(255) NULL,
  `unit` varchar(20) NULL,
  `qty` int(11) NULL,
  `qtyserved` int(11) NULL,
  `remarks` varchar(255) NULL,
  `txntype` varchar(50) NULL,
  `cost` decimal(16,2) NULL,
  constraint pk_aftxnitem PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_parentid` on aftxnitem (`parentid`) ; 
create index `ix_item_objid` on aftxnitem (`item_objid`) ; 
alter table aftxnitem add CONSTRAINT `fk_aftxnitem_parentid` 
  FOREIGN KEY (`parentid`) REFERENCES `aftxn` (`objid`) ; 


CREATE TABLE `afunit` (
  `objid` varchar(50) NOT NULL,
  `itemid` varchar(50) NOT NULL,
  `unit` varchar(10) NOT NULL,
  `qty` int(11) NULL,
  `saleprice` decimal(16,2) NOT NULL,
  `interval` int(11) DEFAULT '1',
  `cashreceiptprintout` varchar(255) NULL,
  `cashreceiptdetailprintout` varchar(255) NULL,
  constraint pk_afunit PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_itemid_unit` on afunit (`itemid`,`unit`) ; 
create index `ix_itemid` on afunit (`itemid`) ; 

alter table afunit modify itemid varchar(50) character set utf8 not null 
;
alter table afunit add CONSTRAINT `fk_afunit_itemid` 
  FOREIGN KEY (`itemid`) REFERENCES `af` (`objid`) ; 



CREATE TABLE `jev` (
  `objid` varchar(150) NOT NULL,
  `jevno` varchar(50) NULL,
  `jevdate` date NULL,
  `fundid` varchar(50) NULL,
  `dtposted` datetime NULL,
  `txntype` varchar(50) NULL,
  `refid` varchar(50) NULL,
  `refno` varchar(50) NULL,
  `reftype` varchar(50) NULL,
  `amount` decimal(16,4) NULL,
  `state` varchar(32) NULL,
  `postedby_objid` varchar(50) NULL,
  `postedby_name` varchar(255) NULL,
  `verifiedby_objid` varchar(50) NULL,
  `verifiedby_name` varchar(255) NULL,
  `dtverified` datetime NULL,
  `batchid` varchar(50) NULL,
  `refdate` date NULL,
  constraint pk_jev PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_batchid` on jev (`batchid`) ; 
create index `ix_dtposted` on jev (`dtposted`) ; 
create index `ix_dtverified` on jev (`dtverified`) ; 
create index `ix_fundid` on jev (`fundid`) ; 
create index `ix_jevdate` on jev (`jevdate`) ; 
create index `ix_jevno` on jev (`jevno`) ; 
create index `ix_postedby_objid` on jev (`postedby_objid`) ; 
create index `ix_refdate` on jev (`refdate`) ; 
create index `ix_refid` on jev (`refid`) ; 
create index `ix_refno` on jev (`refno`) ; 
create index `ix_reftype` on jev (`reftype`) ; 
create index `ix_verifiedby_objid` on jev (`verifiedby_objid`) ; 


CREATE TABLE `jevitem` (
  `objid` varchar(150) NOT NULL,
  `jevid` varchar(150) NULL,
  `accttype` varchar(50) NULL,
  `acctid` varchar(50) NULL,
  `acctcode` varchar(32) NULL,
  `acctname` varchar(255) NULL,
  `dr` decimal(16,4) NULL,
  `cr` decimal(16,4) NULL,
  `particulars` varchar(255) NULL,
  `itemrefid` varchar(255) NULL,
  constraint pk_jevitem PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_jevid` on jevitem (`jevid`) ; 
create index `ix_ledgertype` on jevitem (`accttype`) ; 
create index `ix_acctid` on jevitem (`acctid`) ; 
create index `ix_acctcode` on jevitem (`acctcode`) ; 
create index `ix_acctname` on jevitem (`acctname`) ; 
create index `ix_itemrefid` on jevitem (`itemrefid`) ; 
alter table jevitem add CONSTRAINT `fk_jevitem_jevid` 
  FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`) ; 


CREATE TABLE `bankaccount_ledger` (
  `objid` varchar(150) NOT NULL,
  `jevid` varchar(150) NOT NULL,
  `bankacctid` varchar(50) NOT NULL,
  `itemacctid` varchar(50) NOT NULL,
  `dr` decimal(16,4) NOT NULL,
  `cr` decimal(16,4) NOT NULL,
  constraint pk_bankaccount_ledger PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_jevid` on bankaccount_ledger (`jevid`) ; 
create index `ix_bankacctid` on bankaccount_ledger (`bankacctid`) ; 
create index `ix_itemacctid` on bankaccount_ledger (`itemacctid`) ; 
alter table bankaccount_ledger add CONSTRAINT `fk_bankaccount_ledger_jevid` 
  FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`) ; 


CREATE TABLE `business_application_task_lock` (
  `refid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  constraint pk_business_application_task_lock PRIMARY KEY (`refid`,`state`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_refid` on business_application_task_lock (`refid`) ; 
alter table business_application_task_lock 
  add CONSTRAINT `fk_business_application_task_lock_refid` 
  FOREIGN KEY (`refid`) REFERENCES `business_application` (`objid`)
;


CREATE TABLE `business_billitem_txntype` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(255) NULL,
  `category` varchar(50) NULL,
  `acctid` varchar(50) NULL,
  `feetype` varchar(50) NULL,
  `domain` varchar(100) NULL,
  `role` varchar(100) NULL,
  constraint pk_business_billitem_txntype PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_acctid` on business_billitem_txntype (`acctid`) ; 


CREATE TABLE `cashreceipt_reprint_log` (
  `objid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL,
  `approvedby_objid` varchar(50) NOT NULL,
  `approvedby_name` varchar(150) NOT NULL,
  `dtapproved` datetime NOT NULL,
  `reason` varchar(255) NOT NULL,
  constraint pk_cashreceipt_reprint_log PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_approvedby_name` on cashreceipt_reprint_log (`approvedby_name`) ; 
create index `ix_approvedby_objid` on cashreceipt_reprint_log (`approvedby_objid`) ; 
create index `ix_dtapproved` on cashreceipt_reprint_log (`dtapproved`) ; 
create index `ix_receiptid` on cashreceipt_reprint_log (`receiptid`) ; 
alter table cashreceipt_reprint_log 
  add CONSTRAINT `fk_cashreceipt_reprint_log_receiptid` 
  FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`) 
;


CREATE TABLE `cashreceipt_share` (
  `objid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL,
  `refitem_objid` varchar(50) NOT NULL,
  `payableitem_objid` varchar(50) NOT NULL,
  `amount` decimal(16,4) NOT NULL,
  `share` decimal(16,2) NULL,
  constraint pk_cashreceipt_share PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_receiptid` on cashreceipt_share (`receiptid`) ; 
create index `ix_refitem_objid` on cashreceipt_share (`refitem_objid`) ; 
create index `ix_payableitem_objid` on cashreceipt_share (`payableitem_objid`) ; 
alter table cashreceipt_share 
  add CONSTRAINT `fk_cashreceipt_share_receiptid` 
  FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`) 
;


CREATE TABLE `cash_treasury_ledger` (
  `objid` varchar(150) NOT NULL,
  `jevid` varchar(150) NULL,
  `itemacctid` varchar(50) NULL,
  `dr` decimal(16,4) NULL,
  `cr` decimal(16,4) NULL,
  constraint pk_cash_treasury_ledger PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_jevid` on cash_treasury_ledger (`jevid`) ; 
create index `ix_itemacctid` on cash_treasury_ledger (`itemacctid`) ; 
alter table cash_treasury_ledger 
  add CONSTRAINT `cash_treasury_ledger_jevid` 
  FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`) ; 


CREATE TABLE `depositvoucher` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `controlno` varchar(100) NOT NULL,
  `controldate` date NOT NULL,
  `dtcreated` datetime NOT NULL,
  `createdby_objid` varchar(50) NOT NULL,
  `createdby_name` varchar(255) NOT NULL,
  `amount` decimal(16,4) NOT NULL,
  `dtposted` datetime NULL,
  `postedby_objid` varchar(50) NULL,
  `postedby_name` varchar(255) NULL,
  constraint pk_depositvoucher PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_controlno` on depositvoucher (`controlno`) ; 
create index `ix_state` on depositvoucher (`state`) ; 
create index `ix_controldate` on depositvoucher (`controldate`) ; 
create index `ix_createdby_objid` on depositvoucher (`createdby_objid`) ; 
create index `ix_createdby_name` on depositvoucher (`createdby_name`) ; 
create index `ix_dtcreated` on depositvoucher (`dtcreated`) ; 
create index `ix_postedby_objid` on depositvoucher (`postedby_objid`) ; 
create index `ix_postedby_name` on depositvoucher (`postedby_name`) ; 
create index `ix_dtposted` on depositvoucher (`dtposted`) ; 

CREATE TABLE `depositvoucher_fund` (
  `objid` varchar(150) NOT NULL,
  `state` varchar(20) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `fundid` varchar(100) NOT NULL,
  `amount` decimal(16,4) NOT NULL,
  `amountdeposited` decimal(16,4) NOT NULL,
  `totaldr` decimal(16,4) NOT NULL,
  `totalcr` decimal(16,4) NOT NULL,
  `dtposted` datetime NULL,
  `postedby_objid` varchar(50) NULL,
  `postedby_name` varchar(255) NULL,
  `postedby_title` varchar(100) NULL,
  constraint pk_depositvoucher_fund PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_parentid_fundid` on depositvoucher_fund (`parentid`,`fundid`) ; 
create index `ix_state` on depositvoucher_fund (`state`) ; 
create index `ix_parentid` on depositvoucher_fund (`parentid`) ; 
create index `ix_fundid` on depositvoucher_fund (`fundid`) ; 
create index `ix_dtposted` on depositvoucher_fund (`dtposted`) ; 
create index `ix_postedby_objid` on depositvoucher_fund (`postedby_objid`) ; 
create index `ix_postedby_name` on depositvoucher_fund (`postedby_name`) ; 
alter table depositvoucher_fund 
  add CONSTRAINT `fk_depositvoucher_fund_fundid` 
  FOREIGN KEY (`fundid`) REFERENCES `fund` (`objid`) ; 
alter table depositvoucher_fund 
  add CONSTRAINT `fk_depositvoucher_fund_parentid` 
  FOREIGN KEY (`parentid`) REFERENCES `depositvoucher` (`objid`) ; 


CREATE TABLE `depositslip` (
  `objid` varchar(100) NOT NULL,
  `depositvoucherfundid` varchar(150) NULL,
  `createdby_objid` varchar(50) NULL,
  `createdby_name` varchar(255) NULL,
  `depositdate` date NULL,
  `dtcreated` datetime NULL,
  `bankacctid` varchar(50) NULL,
  `totalcash` decimal(16,4) NULL,
  `totalcheck` decimal(16,4) NULL,
  `amount` decimal(16,4) NULL,
  `validation_refno` varchar(50) NULL,
  `validation_refdate` date NULL,
  `cashbreakdown` longtext,
  `state` varchar(10) NULL,
  `deposittype` varchar(50) NULL,
  `checktype` varchar(50) NULL,
  constraint pk_depositslip PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_depositvoucherid` on depositslip (`depositvoucherfundid`) ; 
create index `ix_createdby_objid` on depositslip (`createdby_objid`) ; 
create index `ix_createdby_name` on depositslip (`createdby_name`) ; 
create index `ix_depositdate` on depositslip (`depositdate`) ; 
create index `ix_dtcreated` on depositslip (`dtcreated`) ; 
create index `ix_bankacctid` on depositslip (`bankacctid`) ; 
create index `ix_validation_refno` on depositslip (`validation_refno`) ; 
create index `ix_validation_refdate` on depositslip (`validation_refdate`) ; 
alter table depositslip 
  add CONSTRAINT `fk_depositslip_depositvoucherfundid` 
  FOREIGN KEY (`depositvoucherfundid`) REFERENCES `depositvoucher_fund` (`objid`) ;


CREATE TABLE `checkpayment` (
  `objid` varchar(50) NOT NULL,
  `bankid` varchar(50) NULL,
  `refno` varchar(50) NULL,
  `refdate` date NULL,
  `amount` decimal(16,4) NULL,
  `receiptid` varchar(50) NULL,
  `bank_name` varchar(255) NULL,
  `amtused` decimal(16,4) NULL,
  `receivedfrom` longtext,
  `state` varchar(50) NULL,
  `depositvoucherid` varchar(50) NULL,
  `fundid` varchar(100) NULL,
  `depositslipid` varchar(100) NULL,
  `split` int(11) NOT NULL,
  `external` int(11) NOT NULL DEFAULT '0',
  `collector_objid` varchar(50) NULL,
  `collector_name` varchar(255) NULL,
  `subcollector_objid` varchar(50) NULL,
  `subcollector_name` varchar(255) NULL,
  constraint pk_checkpayment PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_bankid` on checkpayment (`bankid`) ; 
create index `ix_collector_name` on checkpayment (`collector_name`) ; 
create index `ix_collectorid` on checkpayment (`collector_objid`) ; 
create index `ix_depositslipid` on checkpayment (`depositslipid`) ; 
create index `ix_depositvoucherid` on checkpayment (`depositvoucherid`) ; 
create index `ix_fundid` on checkpayment (`fundid`) ; 
create index `ix_receiptid` on checkpayment (`receiptid`) ; 
create index `ix_refdate` on checkpayment (`refdate`) ; 
create index `ix_refno` on checkpayment (`refno`) ; 
create index `ix_state` on checkpayment (`state`) ; 
create index `ix_subcollector_objid` on checkpayment (`subcollector_objid`) ; 
alter table checkpayment 
  add CONSTRAINT `fk_checkpayment_depositslipid` 
  FOREIGN KEY (`depositslipid`) REFERENCES `depositslip` (`objid`) ; 
alter table checkpayment 
  add CONSTRAINT `fk_paymentcheck_depositvoucher` 
  FOREIGN KEY (`depositvoucherid`) REFERENCES `depositvoucher` (`objid`) ; 
alter table checkpayment 
  add CONSTRAINT `fk_paymentcheck_fund` 
  FOREIGN KEY (`fundid`) REFERENCES `fund` (`objid`) ; 


CREATE TABLE `checkpayment_deadchecks` (
  `objid` varchar(50) NOT NULL,
  `bankid` varchar(50) NULL,
  `refno` varchar(50) NULL,
  `refdate` date NULL,
  `amount` decimal(16,4) NULL,
  `collector_objid` varchar(50) NULL,
  `bank_name` varchar(255) NULL,
  `amtused` decimal(16,4) NULL,
  `receivedfrom` varchar(255) NULL,
  `state` varchar(50) NULL,
  `depositvoucherid` varchar(50) NULL,
  `fundid` varchar(100) NULL,
  `depositslipid` varchar(100) NULL,
  `split` int(11) NOT NULL,
  `amtdeposited` decimal(16,4) NULL,
  `external` int(11) NULL,
  `collector_name` varchar(255) NULL,
  `subcollector_objid` varchar(50) NULL,
  `subcollector_name` varchar(255) NULL,
  `collectorid` varchar(50) NULL,
  constraint pk_checkpayment_deadchecks PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_bankid` on checkpayment_deadchecks (`bankid`) ; 
create index `ix_collector_name` on checkpayment_deadchecks (`collector_name`) ; 
create index `ix_collectorid` on checkpayment_deadchecks (`collector_objid`) ; 
create index `ix_collectorid_` on checkpayment_deadchecks (`collectorid`) ; 
create index `ix_depositslipid` on checkpayment_deadchecks (`depositslipid`) ; 
create index `ix_depositvoucherid` on checkpayment_deadchecks (`depositvoucherid`) ; 
create index `ix_fundid` on checkpayment_deadchecks (`fundid`) ; 
create index `ix_refdate` on checkpayment_deadchecks (`refdate`) ; 
create index `ix_refno` on checkpayment_deadchecks (`refno`) ; 
create index `ix_subcollector_objid` on checkpayment_deadchecks (`subcollector_objid`) ; 


CREATE TABLE `checkpayment_dishonored` (
  `objid` varchar(50) NOT NULL,
  `checkpaymentid` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `filedby_objid` varchar(50) NOT NULL,
  `filedby_name` varchar(150) NOT NULL,
  `remarks` varchar(255) NOT NULL,
  constraint pk_checkpayment_dishonored PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_checkpaymentid` on checkpayment_dishonored (`checkpaymentid`) ; 
create index `ix_dtfiled` on checkpayment_dishonored (`dtfiled`) ; 
create index `ix_filedby_objid` on checkpayment_dishonored (`filedby_objid`) ; 
create index `ix_filedby_name` on checkpayment_dishonored (`filedby_name`) ; 
alter table checkpayment_dishonored 
  add CONSTRAINT `fk_checkpayment_dishonored_checkpaymentid` 
  FOREIGN KEY (`checkpaymentid`) REFERENCES `checkpayment` (`objid`) ; 


CREATE TABLE `collectiongroup_org` (
  `objid` varchar(100) NOT NULL,
  `collectiongroupid` varchar(50) NOT NULL,
  `org_objid` varchar(50) NOT NULL,
  `org_name` varchar(255) NOT NULL,
  `org_type` varchar(50) NOT NULL,
  constraint pk_collectiongroup_org PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_collectiongroup_org` on collectiongroup_org (`collectiongroupid`,`org_objid`) ; 
create index `ix_collectiongroupid` on collectiongroup_org (`collectiongroupid`) ; 
create index `ix_org_objid` on collectiongroup_org (`org_objid`) ; 
alter table collectiongroup_org 
  add CONSTRAINT `fk_collectiongroup_org_parent` 
  FOREIGN KEY (`collectiongroupid`) REFERENCES `collectiongroup` (`objid`) ; 


CREATE TABLE `collectiontype_org` (
  `objid` varchar(100) NOT NULL,
  `collectiontypeid` varchar(50) NULL,
  `org_objid` varchar(50) NULL,
  `org_name` varchar(150) NULL,
  `org_type` varchar(50) NULL,
  constraint pk_collectiontype_org PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_collectiontype_org` on collectiontype_org (`collectiontypeid`,`org_objid`) ; 
create index `ix_collectiontypeid` on collectiontype_org (`collectiontypeid`) ; 
create index `ix_org_objid` on collectiontype_org (`org_objid`) ; 
create index `ix_org_name` on collectiontype_org (`org_name`) ; 
alter table collectiontype_org 
  add CONSTRAINT `fk_collectiontype_org_parent` 
  FOREIGN KEY (`collectiontypeid`) REFERENCES `collectiontype` (`objid`) ; 


CREATE TABLE `collectionvoucher` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `controlno` varchar(100) NOT NULL,
  `controldate` date NOT NULL,
  `dtposted` datetime NOT NULL,
  `liquidatingofficer_objid` varchar(50) NULL,
  `liquidatingofficer_name` varchar(100) NULL,
  `liquidatingofficer_title` varchar(50) NULL,
  `liquidatingofficer_signature` longtext,
  `amount` decimal(18,2) NULL,
  `totalcash` decimal(18,2) NULL,
  `totalcheck` decimal(16,4) NULL,
  `cashbreakdown` longtext,
  `totalcr` decimal(16,4) NULL,
  `depositvoucherid` varchar(50) NULL,
  constraint pk_collectionvoucher PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_controlno` on collectionvoucher (`controlno`) ; 
create index `ix_state` on collectionvoucher (`state`) ; 
create index `ix_controldate` on collectionvoucher (`controldate`) ; 
create index `ix_dtposted` on collectionvoucher (`dtposted`) ; 
create index `ix_liquidatingofficer_objid` on collectionvoucher (`liquidatingofficer_objid`) ; 
create index `ix_liquidatingofficer_name` on collectionvoucher (`liquidatingofficer_name`) ; 
create index `ix_depositvoucherid` on collectionvoucher (`depositvoucherid`) ; 
alter table collectionvoucher 
  add CONSTRAINT `fk_collectionvoucher_depositvoucherid` 
  FOREIGN KEY (`depositvoucherid`) REFERENCES `depositvoucher` (`objid`) ; 
alter table collectionvoucher 
  add CONSTRAINT `fk_collectionvoucher_liquidatingofficer` 
  FOREIGN KEY (`liquidatingofficer_objid`) REFERENCES `sys_user` (`objid`) ; 


CREATE TABLE `collectionvoucher_fund` (
  `objid` varchar(255) NOT NULL,
  `controlno` varchar(100) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `fund_objid` varchar(100) NOT NULL,
  `fund_title` varchar(100) NOT NULL,
  `amount` decimal(16,4) NOT NULL,
  `totalcash` decimal(16,4) NOT NULL,
  `totalcheck` decimal(16,4) NOT NULL,
  `totalcr` decimal(16,4) NOT NULL,
  `cashbreakdown` longtext,
  `depositvoucherid` varchar(50) NULL,
  constraint pk_collectionvoucher_fund PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_parentid_fund_objid` on collectionvoucher_fund (`parentid`,`fund_objid`) ; 
create index `ix_controlno` on collectionvoucher_fund (`controlno`) ; 
create index `ix_parentid` on collectionvoucher_fund (`parentid`) ; 
create index `ix_fund_objid` on collectionvoucher_fund (`fund_objid`) ; 
create index `ix_depositvoucherid` on collectionvoucher_fund (`depositvoucherid`) ; 
alter table collectionvoucher_fund 
  add CONSTRAINT `fk_collectionvoucher_fund_fund_objid` 
  FOREIGN KEY (`fund_objid`) REFERENCES `fund` (`objid`) ; 
alter table collectionvoucher_fund 
  add CONSTRAINT `fk_collectionvoucher_fund_parentid` 
  FOREIGN KEY (`parentid`) REFERENCES `collectionvoucher` (`objid`) ; 


CREATE TABLE `deposit_fund_transfer` (
  `objid` varchar(150) NOT NULL,
  `fromdepositvoucherfundid` varchar(150) NOT NULL,
  `todepositvoucherfundid` varchar(150) NOT NULL,
  `amount` decimal(16,4) NOT NULL,
  constraint pk_deposit_fund_transfer PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_fromfundid` on deposit_fund_transfer (`fromdepositvoucherfundid`) ; 
create index `ix_tofundid` on deposit_fund_transfer (`todepositvoucherfundid`) ; 
alter table deposit_fund_transfer 
  add CONSTRAINT `fk_deposit_fund_transfer_fromdepositvoucherfundid` 
  FOREIGN KEY (`fromdepositvoucherfundid`) REFERENCES `fund` (`objid`) ;
alter table deposit_fund_transfer 
  add CONSTRAINT `fk_deposit_fund_transfer_todepositvoucherfundid` 
  FOREIGN KEY (`todepositvoucherfundid`) REFERENCES `fund` (`objid`) ;


drop table if exists draftremittanceitem;
drop table if exists draftremittance; 

CREATE TABLE `draftremittance` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(20) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `remittancedate` datetime NOT NULL,
  `collector_objid` varchar(50) NOT NULL,
  `collector_name` varchar(255) NOT NULL,
  `collector_title` varchar(255) NOT NULL,
  `amount` decimal(18,2) NOT NULL,
  `totalcash` decimal(18,2) NOT NULL,
  `totalnoncash` decimal(18,2) NOT NULL,
  `txnmode` varchar(32) NOT NULL,
  `lockid` varchar(50) NULL,
  constraint pk_draftremittance PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_dtfiled` on draftremittance (`dtfiled`) ;
create index `ix_remittancedate` on draftremittance (`remittancedate`) ;
create index `ix_collector_objid` on draftremittance (`collector_objid`) ;


CREATE TABLE `draftremittanceitem` (
  `objid` varchar(50) NOT NULL,
  `remittanceid` varchar(50) NOT NULL,
  `controlid` varchar(50) NOT NULL,
  `batchid` varchar(50) NULL,
  `amount` decimal(18,2) NOT NULL,
  `totalcash` decimal(18,2) NOT NULL,
  `totalnoncash` decimal(18,2) NOT NULL,
  `voided` int(11) NOT NULL,
  `cancelled` int(11) NOT NULL,
  `lockid` varchar(50) NULL,
  constraint pk_draftremittanceitem PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_remittanceid` on draftremittanceitem (`remittanceid`) ; 
create index `ix_controlid` on draftremittanceitem (`controlid`) ; 
create index `ix_batchid` on draftremittanceitem (`batchid`) ; 


CREATE TABLE `eftpayment` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) NOT NULL,
  `refno` varchar(50) NOT NULL,
  `refdate` date NOT NULL,
  `amount` decimal(16,4) NOT NULL,
  `receivedfrom` varchar(255) NULL,
  `particulars` varchar(255) NULL,
  `bankacctid` varchar(50) NOT NULL,
  `fundid` varchar(100) NULL,
  `createdby_objid` varchar(50) NOT NULL,
  `createdby_name` varchar(255) NOT NULL,
  `receiptid` varchar(50) NULL,
  `receiptno` varchar(50) NULL,
  `payer_objid` varchar(50) NULL,
  `payer_name` varchar(255) NULL,
  `payer_address_objid` varchar(50) NULL,
  `payer_address_text` varchar(255) NULL,
  constraint pk_eftpayment PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_state` on eftpayment (`state`) ; 
create index `ix_refno` on eftpayment (`refno`) ; 
create index `ix_refdate` on eftpayment (`refdate`) ; 
create index `ix_bankacctid` on eftpayment (`bankacctid`) ; 
create index `ix_fundid` on eftpayment (`fundid`) ; 
create index `ix_createdby_objid` on eftpayment (`createdby_objid`) ; 
create index `ix_receiptid` on eftpayment (`receiptid`) ; 
create index `ix_payer_objid` on eftpayment (`payer_objid`) ; 
create index `ix_payer_address_objid` on eftpayment (`payer_address_objid`) ; 
alter table eftpayment 
  add CONSTRAINT `fk_eftpayment_bankacct` 
  FOREIGN KEY (`bankacctid`) REFERENCES `bankaccount` (`objid`) ; 
alter table eftpayment 
  add CONSTRAINT `fk_eftpayment_fund` 
  FOREIGN KEY (`fundid`) REFERENCES `fund` (`objid`) ; 


CREATE TABLE `entityprofile` (
  `objid` varchar(50) NOT NULL,
  `idno` varchar(50) NOT NULL,
  `lastname` varchar(60) NOT NULL,
  `firstname` varchar(60) NOT NULL,
  `middlename` varchar(60) NULL,
  `birthdate` date NULL,
  `gender` varchar(10) NULL,
  `address` longtext,
  `defaultentityid` varchar(50) NULL,
  constraint pk_entityprofile PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_defaultentityid` on entityprofile (`defaultentityid`) ; 
create index `ix_firstname` on entityprofile (`firstname`) ; 
create index `ix_idno` on entityprofile (`idno`) ; 
create index `ix_lastname` on entityprofile (`lastname`) ; 
create index `ix_lfname` on entityprofile (`lastname`,`firstname`) ; 


CREATE TABLE `entity_ctc` (
  `objid` varchar(50) NOT NULL,
  `entityid` varchar(50) NOT NULL,
  `nonresident` int(11) NOT NULL,
  `ctcno` varchar(50) NOT NULL,
  `dtissued` date NOT NULL,
  `placeissued` varchar(255) NOT NULL,
  `lgu_objid` varchar(50) NULL,
  `lgu_name` varchar(255) NULL,
  `barangay_objid` varchar(50) NULL,
  `barangay_name` varchar(255) NOT NULL,
  `createdby_objid` varchar(50) NOT NULL,
  `createdby_name` varchar(160) NOT NULL,
  `system` int(11) NOT NULL DEFAULT '0',
  constraint pk_entity_ctc PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_barangay_name` on entity_ctc (`barangay_name`) ; 
create index `ix_barangay_objid` on entity_ctc (`barangay_objid`) ; 
create index `ix_createdby_name` on entity_ctc (`createdby_name`) ; 
create index `ix_createdby_objid` on entity_ctc (`createdby_objid`) ; 
create index `ix_ctcno` on entity_ctc (`ctcno`) ; 
create index `ix_dtissued` on entity_ctc (`dtissued`) ; 
create index `ix_entityid` on entity_ctc (`entityid`) ; 
create index `ix_lgu_name` on entity_ctc (`lgu_name`) ; 
create index `ix_lgu_objid` on entity_ctc (`lgu_objid`) ; 
alter table entity_ctc 
  add CONSTRAINT `fk_entity_ctc_entityid` 
  FOREIGN KEY (`entityid`) REFERENCES `entity` (`objid`) ; 


CREATE TABLE `entity_fingerprint` (
  `objid` varchar(50) NOT NULL,
  `entityid` varchar(50) NULL,
  `dtfiled` datetime NULL,
  `fingertype` varchar(20) NULL,
  `data` longtext,
  `image` longtext,
  constraint pk_entity_fingerprint PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_entityid_fingertype` on entity_fingerprint (`entityid`,`fingertype`) ; 
create index `ix_dtfiled` on entity_fingerprint (`dtfiled`) ; 


CREATE TABLE `entity_reconciled` (
  `objid` varchar(50) NOT NULL,
  `info` longtext,
  `masterid` varchar(50) NULL,
  constraint pk_entity_reconciled PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `FK_entity_reconciled_entity` on entity_reconciled (`masterid`) ; 
alter table entity_reconciled 
  add CONSTRAINT `FK_entity_reconciled_entity` 
  FOREIGN KEY (`masterid`) REFERENCES `entity` (`objid`) ; 


CREATE TABLE `entity_reconciled_txn` (
  `objid` varchar(50) NOT NULL,
  `reftype` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `tag` char(1) NULL,
  constraint pk_entity_reconciled_txn PRIMARY KEY (`objid`,`reftype`,`refid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `entity_relation_type` (
  `objid` varchar(50) NOT NULL DEFAULT '',
  `gender` varchar(1) NULL,
  `inverse_any` varchar(50) NULL,
  `inverse_male` varchar(50) NULL,
  `inverse_female` varchar(50) NULL,
  constraint pk_entity_relation_type PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('AUNT', 'F', 'NEPHEW/NIECE', 'NEPHEW', 'NIECE');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('BROTHER', 'M', 'SIBLING', 'BROTHER', 'SISTER');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('COUSIN', NULL, 'COUSIN', 'COUSIN', 'COUSIN');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('DAUGHTER', 'F', 'PARENT', 'FATHER', 'MOTHER');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('FATHER', 'M', 'CHILD', 'SON', 'DAUGHTER');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('GRANDDAUGHTER', 'F', 'GRANDPARENT', 'GRANDFATHER', 'GRANDMOTHER');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('GRANDSON', 'M', 'GRANDPARENT', 'GRANDFATHER', 'GRANDMOTHER');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('HUSBAND', 'M', 'SPOUSE', 'SPOUSE', 'WIFE');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('MOTHER', 'F', 'CHILD', 'SON', 'DAUGHTER');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('NEPHEW', 'M', 'UNCLE/AUNT', 'UNCLE', 'AUNT');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('NIECE', 'F', 'UNCLE/AUNT', 'UNCLE', 'AUNT');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('SISTER', 'F', 'SIBLING', 'BROTHER', 'SISTER');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('SON', 'M', 'PARENT', 'FATHER', 'MOTHER');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('SPOUSE', NULL, 'SPOUSE', 'HUSBAND', 'WIFE');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('UNCLE', 'M', 'NEPHEW/NIECE', 'NEPHEW', 'NIECE');
INSERT INTO `entity_relation_type` (`objid`, `gender`, `inverse_any`, `inverse_male`, `inverse_female`) VALUES ('WIFE', 'F', 'SPOUSE', 'HUSBAND', 'SPOUSE');


drop table if exists entity_relation
;

CREATE TABLE `entity_relation` (
  `objid` varchar(50) NOT NULL,
  `entity_objid` varchar(50) NULL,
  `relateto_objid` varchar(50) NULL,
  `relation_objid` varchar(50) NULL,
  constraint pk_entity_relation PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_sender_receiver` on entity_relation (`entity_objid`,`relateto_objid`) ; 
create index `ix_entity_objid` on entity_relation (`entity_objid`) ; 
create index `ix_relateto_objid` on entity_relation (`relateto_objid`) ; 
create index `ix_relation_objid` on entity_relation (`relation_objid`) ; 
alter table entity_relation 
  add CONSTRAINT `fk_entity_relation_entity_objid` 
  FOREIGN KEY (`entity_objid`) REFERENCES `entity` (`objid`) ; 
alter table entity_relation 
  add CONSTRAINT `fk_entity_relation_relation_objid` 
  FOREIGN KEY (`relateto_objid`) REFERENCES `entity` (`objid`) ; 
alter table entity_relation 
  add CONSTRAINT `fk_entity_relation_relation` 
  FOREIGN KEY (`relation_objid`) REFERENCES `entity_relation_type` (`objid`) ; 


CREATE TABLE `fundgroup` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(100) NOT NULL,
  `indexno` int(11) NOT NULL,
  constraint pk_fundgroup PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create UNIQUE index `uix_title` on fundgroup (`title`) ; 


INSERT INTO `fundgroup` (`objid`, `title`, `indexno`) VALUES ('GENERAL', 'GENERAL', '0');
INSERT INTO `fundgroup` (`objid`, `title`, `indexno`) VALUES ('SEF', 'SEF', '1');
INSERT INTO `fundgroup` (`objid`, `title`, `indexno`) VALUES ('TRUST', 'TRUST', '2');


CREATE TABLE `income_ledger` (
  `objid` varchar(150) NOT NULL,
  `jevid` varchar(150) NULL,
  `itemacctid` varchar(50) NOT NULL,
  `dr` decimal(16,4) NOT NULL,
  `cr` decimal(16,4) NOT NULL,
  constraint pk_income_ledger PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_jevid` on income_ledger (`jevid`) ;
create index `ix_itemacctid` on income_ledger (`itemacctid`) ;
alter table income_ledger 
  add CONSTRAINT `fk_income_ledger_jevid` 
  FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`) ; 
alter table income_ledger 
  add CONSTRAINT `fk_income_ledger_itemacctid` 
  FOREIGN KEY (`itemacctid`) REFERENCES `itemaccount` (`objid`) ; 


CREATE TABLE `interfund_transfer_ledger` (
  `objid` varchar(150) NOT NULL,
  `jevid` varchar(150) NULL,
  `itemacctid` varchar(50) NULL,
  `dr` decimal(16,4) NULL,
  `cr` decimal(16,4) NULL,
  constraint pk_interfund_transfer_ledger PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_jevid` on interfund_transfer_ledger (`jevid`) ; 
create index `ix_itemacctid` on interfund_transfer_ledger (`itemacctid`) ; 
alter table interfund_transfer_ledger 
  add CONSTRAINT `fk_interfund_transfer_ledger_jevid` 
  FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`) ; 


drop table if exists paymentorder_type 
;

CREATE TABLE `paymentorder_type` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(150) NULL,
  `collectiontype_objid` varchar(50) NULL,
  `queuesection` varchar(50) NULL,
  constraint pk_paymentorder_type PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `fk_paymentorder_type_collectiontype` on paymentorder_type (`collectiontype_objid`) ; 
alter table paymentorder_type 
  add CONSTRAINT `paymentorder_type_ibfk_1` 
  FOREIGN KEY (`collectiontype_objid`) REFERENCES `collectiontype` (`objid`) ; 


CREATE TABLE `payable_ledger` (
  `objid` varchar(50) NOT NULL,
  `jevid` varchar(150) NULL,
  `refitemacctid` varchar(50) NULL,
  `itemacctid` varchar(50) NOT NULL,
  `dr` decimal(16,4) NULL,
  `cr` decimal(16,4) NULL,
  constraint pk_payable_ledger PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_jevid` on payable_ledger (`jevid`) ; 
create index `ix_itemacctid` on payable_ledger (`itemacctid`) ; 
create index `ix_refitemacctid` on payable_ledger (`refitemacctid`) ; 
alter table payable_ledger 
  add CONSTRAINT `fk_payable_ledger_jevid` 
  FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`) ; 


drop table if exists sys_report 
;

CREATE TABLE `sys_report` (
  `objid` varchar(50) NOT NULL,
  `folderid` varchar(50) NULL,
  `title` varchar(255) NULL,
  `filetype` varchar(25) NULL,
  `dtcreated` datetime NULL,
  `createdby_objid` varchar(50) NULL,
  `createdby_name` varchar(255) NULL,
  `datasetid` varchar(50) NULL,
  `template` mediumtext,
  `outputtype` varchar(50) NULL,
  `system` int(11) NULL,
  constraint pk_sys_report PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `FK_sys_report_dataset` on sys_report (`datasetid`) ; 
create index `FK_sys_report_entry_folder` on sys_report (`folderid`) ; 
alter table sys_report 
  add CONSTRAINT `sys_report_ibfk_1` 
  FOREIGN KEY (`datasetid`) REFERENCES `sys_dataset` (`objid`) ; 


CREATE TABLE `treasury_variableinfo` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) NOT NULL,
  `name` varchar(50) NOT NULL,
  `datatype` varchar(20) NOT NULL,
  `caption` varchar(50) NOT NULL,
  `description` varchar(100) NULL,
  `arrayvalues` longtext,
  `system` int(11) NULL,
  `sortorder` int(11) NULL,
  `category` varchar(100) NULL,
  `handler` varchar(50) NULL,
  constraint pk_treasury_variableinfo PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_name` on treasury_variableinfo (`name`) ; 


CREATE TABLE `cashbook_revolving_fund` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `filedby_objid` varchar(50) NOT NULL,
  `filedby_name` varchar(150) NOT NULL,
  `issueto_objid` varchar(50) NOT NULL,
  `issueto_name` varchar(150) NOT NULL,
  `controldate` date NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `remarks` varchar(255) NOT NULL,
  `fund_objid` varchar(100) NOT NULL,
  `fund_title` varchar(255) NOT NULL,
  constraint pk_cashbook_revolving_fund PRIMARY KEY (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_state` on cashbook_revolving_fund (`state`) ; 
create index `ix_dtfiled` on cashbook_revolving_fund (`dtfiled`) ; 
create index `ix_filedby_objid` on cashbook_revolving_fund (`filedby_objid`) ; 
create index `ix_filedby_name` on cashbook_revolving_fund (`filedby_name`) ; 
create index `ix_issueto_objid` on cashbook_revolving_fund (`issueto_objid`) ; 
create index `ix_issueto_name` on cashbook_revolving_fund (`issueto_name`) ; 
create index `ix_controldate` on cashbook_revolving_fund (`controldate`) ; 
create index `ix_fund_objid` on cashbook_revolving_fund (`fund_objid`) ; 
create index `ix_fund_title` on cashbook_revolving_fund (`fund_title`) ; 


CREATE TABLE `cashreceipt_changelog` (
  `objid` varchar(50) NOT NULL,
  `receiptid` varchar(50) NOT NULL,
  `dtfiled` datetime NOT NULL,
  `filedby_objid` varchar(50) NOT NULL,
  `filedby_name` varchar(150) NOT NULL,
  `action` varchar(255) NOT NULL,
  `remarks` varchar(255) NOT NULL,
  `oldvalue` text NOT NULL,
  `newvalue` text NOT NULL,
  constraint pk_cashreceipt_changelog PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_receiptid` on cashreceipt_changelog (`receiptid`) ; 
create index `ix_dtfiled` on cashreceipt_changelog (`dtfiled`) ; 
create index `ix_filedby_objid` on cashreceipt_changelog (`filedby_objid`) ; 
create index `ix_filedby_name` on cashreceipt_changelog (`filedby_name`) ; 
create index `ix_action` on cashreceipt_changelog (`action`) ; 
alter table cashreceipt_changelog 
  add CONSTRAINT `fk_cashreceipt_changelog_receiptid` 
  FOREIGN KEY (`receiptid`) REFERENCES `cashreceipt` (`objid`) ;


CREATE TABLE `psic` (
  `objid` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `parentid` varchar(50) NULL,
  constraint pk_psic PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_title` on psic (`title`) ; 
create index `ix_parentid` on psic (`parentid`) ; 
alter table psic 
  add CONSTRAINT `fk_psic_parentid` 
  FOREIGN KEY (`parentid`) REFERENCES `psic` (`objid`) ;


CREATE TABLE `af_control_detail` (
  `objid` varchar(150) NOT NULL,
  `state` int(11) NULL,
  `controlid` varchar(50) NOT NULL,
  `indexno` int(11) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `aftxnitemid` varchar(50) NULL,
  `refno` varchar(50) NOT NULL,
  `reftype` varchar(32) NOT NULL,
  `refdate` datetime NOT NULL,
  `txndate` datetime NOT NULL,
  `txntype` varchar(32) NOT NULL,
  `receivedstartseries` int(11) NULL,
  `receivedendseries` int(11) NULL,
  `beginstartseries` int(11) NULL,
  `beginendseries` int(11) NULL,
  `issuedstartseries` int(11) NULL,
  `issuedendseries` int(11) NULL,
  `endingstartseries` int(11) NULL,
  `endingendseries` int(11) NULL,
  `qtyreceived` int(11) NOT NULL,
  `qtybegin` int(11) NOT NULL,
  `qtyissued` int(11) NOT NULL,
  `qtyending` int(11) NOT NULL,
  `qtycancelled` int(11) NOT NULL,
  `remarks` varchar(255) NULL,
  `issuedto_objid` varchar(50) NULL,
  `issuedto_name` varchar(255) NULL,
  `respcenter_objid` varchar(50) NULL,
  `respcenter_name` varchar(255) NULL,
  `prevdetailid` varchar(150) NULL,
  `aftxnid` varchar(100) NULL,
  constraint pk_af_control_detail PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_aftxnid` on af_control_detail (`aftxnid`) ; 
create index `ix_aftxnitemid` on af_control_detail (`aftxnitemid`) ; 
create index `ix_controlid` on af_control_detail (`controlid`) ; 
create index `ix_issuedto_name` on af_control_detail (`issuedto_name`) ; 
create index `ix_issuedto_objid` on af_control_detail (`issuedto_objid`) ; 
create index `ix_prevdetailid` on af_control_detail (`prevdetailid`) ; 
create index `ix_refdate` on af_control_detail (`refdate`) ; 
create index `ix_refid` on af_control_detail (`refid`) ; 
create index `ix_refitemid` on af_control_detail (`aftxnitemid`) ; 
create index `ix_refno` on af_control_detail (`refno`) ; 
create index `ix_reftype` on af_control_detail (`reftype`) ; 
create index `ix_respcenter_name` on af_control_detail (`respcenter_name`) ; 
create index `ix_respcenter_objid` on af_control_detail (`respcenter_objid`) ; 
create index `ix_txndate` on af_control_detail (`txndate`) ; 
create index `ix_txntype` on af_control_detail (`txntype`) ; 
alter table af_control_detail 
  add CONSTRAINT `fk_af_control_detail_aftxnid` 
  FOREIGN KEY (`aftxnid`) REFERENCES `aftxn` (`objid`) ; 

alter table af_control_detail modify controlid varchar(50) character set utf8 not null 
; 
alter table af_control_detail 
  add CONSTRAINT `fk_af_control_detail_controlid` 
  FOREIGN KEY (`controlid`) REFERENCES `af_control` (`objid`) ; 


CREATE TABLE `holiday` (
  `objid` varchar(50) NOT NULL,
  `year` int(11) NULL,
  `month` int(11) NULL,
  `day` int(11) NULL,
  `week` int(11) NULL,
  `dow` int(11) NULL,
  `name` varchar(255) NULL,
  constraint pk_holiday PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


CREATE TABLE `af_allocation` (
  `objid` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `respcenter_objid` varchar(50) NULL,
  `respcenter_name` varchar(100) NULL,
  constraint pk_af_allocation PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_name` on af_allocation (`name`) ;
create index `ix_respcenter_objid` on af_allocation (`respcenter_objid`) ;
create index `ix_respcenter_name` on af_allocation (`respcenter_name`) ;


drop table if exists income_summary
;
CREATE TABLE `income_summary` (
  `refid` varchar(50) NOT NULL,
  `refdate` date NOT NULL,
  `refno` varchar(50) NULL,
  `reftype` varchar(50) NULL,
  `acctid` varchar(50) NOT NULL,
  `fundid` varchar(50) NOT NULL,
  `amount` decimal(16,4) NULL,
  `orgid` varchar(50) NOT NULL,
  `collectorid` varchar(50) NULL,
  `refyear` int(11) NULL,
  `refmonth` int(11) NULL,
  `refqtr` int(11) NULL,
  `remittanceid` varchar(50) NOT NULL DEFAULT '',
  `remittancedate` date NULL,
  `remittanceyear` int(11) NULL,
  `remittancemonth` int(11) NULL,
  `remittanceqtr` int(11) NULL,
  `liquidationid` varchar(50) NOT NULL DEFAULT '',
  `liquidationdate` date NULL,
  `liquidationyear` int(11) NULL,
  `liquidationmonth` int(11) NULL,
  `liquidationqtr` int(11) NULL,
  PRIMARY KEY (`refid`,`refdate`,`fundid`,`acctid`,`orgid`,`remittanceid`,`liquidationid`),
  KEY `ix_refdate` (`refdate`),
  KEY `ix_refno` (`refno`),
  KEY `ix_acctid` (`acctid`),
  KEY `ix_fundid` (`fundid`),
  KEY `ix_orgid` (`orgid`),
  KEY `ix_collectorid` (`collectorid`),
  KEY `ix_refyear` (`refyear`),
  KEY `ix_refmonth` (`refmonth`),
  KEY `ix_refqtr` (`refqtr`),
  KEY `ix_remittanceid` (`remittanceid`),
  KEY `ix_remittancedate` (`remittancedate`),
  KEY `ix_remittanceyear` (`remittanceyear`),
  KEY `ix_remittancemonth` (`remittancemonth`),
  KEY `ix_remittanceqtr` (`remittanceqtr`),
  KEY `ix_liquidationid` (`liquidationid`),
  KEY `ix_liquidationdate` (`liquidationdate`),
  KEY `ix_liquidationyear` (`liquidationyear`),
  KEY `ix_liquidationmonth` (`liquidationmonth`),
  KEY `ix_liquidationqtr` (`liquidationqtr`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;



-- ## patch-06

alter table af add ( 
  `baseunit` varchar(10) NULL,
  `defaultunit` varchar(10) NULL   
)
;

alter table af_control add ( 
  `dtfiled` date NULL,
  `state` varchar(50) NULL,
  `unit` varchar(25) NULL,
  `batchno` int NULL,
  `respcenter_objid` varchar(50) NULL,
  `respcenter_name` varchar(100) NULL,
  `cost` decimal(16,2) NULL,
  `currentindexno` int NULL,
  `currentdetailid` varchar(150) NULL,
  `batchref` varchar(50) NULL,
  `lockid` varchar(50) NULL,
  `allocid` varchar(50) NULL,
  `ukey` varchar(50) NOT NULL DEFAULT ''
)
;
create index ix_dtfiled on af_control (dtfiled) ; 
create index ix_state on af_control (state) ; 
create index ix_batchno on af_control (batchno) ; 
create index ix_respcenter_objid on af_control (respcenter_objid) ; 
create index ix_respcenter_name on af_control (respcenter_name) ; 
create index ix_currentdetailid on af_control (currentdetailid) ; 
create index ix_allocid on af_control (allocid) ; 
create index ix_ukey on af_control (ukey) ; 

alter table af_control modify afid varchar(50) not null ; 
alter table af_control modify startseries int not null ; 
alter table af_control modify currentseries int not null ; 
alter table af_control modify endseries int not null ; 

update af_control set ukey = md5( objid ); 
update af_control set prefix = '' where prefix is null; 
update af_control set suffix = '' where suffix is null; 

create unique index uix_af_control on af_control ( afid, startseries, prefix, suffix, ukey );  

alter table af_control modify prefix varchar(10) not null default ''; 
alter table af_control modify suffix varchar(10) not null default ''; 


update z20181120_af_inventory_detail set qtyreceived=0 where qtyreceived is null; 
update z20181120_af_inventory_detail set qtybegin=0 where qtybegin is null; 
update z20181120_af_inventory_detail set qtyissued=0 where qtyissued is null; 
update z20181120_af_inventory_detail set qtyending=0 where qtyending is null; 
update z20181120_af_inventory_detail set qtycancelled=0 where qtycancelled is null; 
update z20181120_af_inventory_detail set refno=refid where refdate is not null and refid is not null and refno is null 
;
insert into af_control_detail ( 
  objid, state, controlid, indexno, refid, refno, reftype, refdate, txndate, txntype, 
  receivedstartseries, receivedendseries, beginstartseries, beginendseries, 
  issuedstartseries, issuedendseries, endingstartseries, endingendseries, 
  qtyreceived, qtybegin, qtyissued, qtyending, qtycancelled, remarks, 
  issuedto_objid, issuedto_name
) 
select 
  d.objid, 1 as state, d.controlid, d.lineno, d.refid, d.refno, d.reftype, d.refdate, d.txndate, d.txntype, 
  d.receivedstartseries, d.receivedendseries, d.beginstartseries, d.beginendseries, 
  d.issuedstartseries, d.issuedendseries, d.endingstartseries, d.endingendseries, 
  d.qtyreceived, d.qtybegin, d.qtyissued, d.qtyending, d.qtycancelled, d.remarks, 
  a.owner_objid, a.owner_name 
from af_control a 
  inner join z20181120_af_inventory_detail d on d.controlid = a.objid 
where d.refdate is not null 
;
update af_control_detail set reftype='ISSUE', txntype='COLLECTION' where reftype='stockissue' and txntype in ('ISSUANCE-RECEIPT','ISSUE-RECEIPT') 
;
update af_control_detail set reftype='FORWARD', txntype='FORWARD' where reftype='SYSTEM' and txntype='ISSUANCE-RECEIPT'
; 
update af_control_detail set reftype='FORWARD', txntype='FORWARD' where reftype='SYSTEM' and txntype='COLLECTOR BEG.BAL.'
;
UPDATE af_control_detail set reftype=upper(reftype) where reftype = 'remittance' 
; 
update af_control_detail set reftype=upper(reftype), txntype='TRANSFER_COLLECTION' where reftype='TRANSFER'
; 


drop view if exists z20181120_vw_af_inventory_detail
;
create view z20181120_vw_af_inventory_detail as 
select 
  a.afid, a.respcenter_type, a.respcenter_objid, a.respcenter_name, 
  a.unit, a.startseries, a.endseries, a.cost as unitcost,  
  d.* 
from z20181120_af_inventory_detail d 
  inner join z20181120_af_inventory a on a.objid = d.controlid 
;
drop view if exists z20181120_vw_af_stockissuance
;
create view z20181120_vw_af_stockissuance as 
select 
  a.afid, a.respcenter_type, a.respcenter_objid, a.respcenter_name, 
  a.unit, a.startseries, a.endseries, a.cost as unitcost, 
  d.objid, d.lineno, d.controlid, d.refid, d.reftype, d.refno, d.refdate, 
  d.txntype, d.txndate, d.remarks, d.cost 
from z20181120_af_inventory_detail d 
  inner join z20181120_af_inventory a on a.objid = d.controlid 
where d.reftype = 'stockissue' 
  and d.txntype = 'ISSUANCE'
;
drop view if exists z20181120_vw_af_stockissuancereceipt
;
create view z20181120_vw_af_stockissuancereceipt as 
select 
  a.afid, a.respcenter_type, a.respcenter_objid, a.respcenter_name, 
  a.unit, a.startseries, a.endseries, a.cost as unitcost, 
  d.objid, d.lineno, d.controlid, d.refid, d.reftype, d.refno, d.refdate, 
  d.txntype, d.txndate, d.remarks, d.cost, 
  d.receivedstartseries, d.receivedendseries, d.qtyreceived 
from z20181120_af_inventory_detail d 
  inner join z20181120_af_inventory a on a.objid = d.controlid 
where d.reftype = 'stockissue' 
  and d.txntype = 'ISSUANCE-RECEIPT'
;
drop view if exists z20181120_vw_af_stockreceipt 
;
create view z20181120_vw_af_stockreceipt as 
select 
  a.afid, a.respcenter_type, a.respcenter_objid, a.respcenter_name, 
  a.unit, a.startseries, a.endseries, a.cost as unitcost, 
  d.objid, d.lineno, d.controlid, d.refid, d.reftype, d.refno, d.refdate, 
  d.txntype, d.txndate, d.remarks, d.cost 
from z20181120_af_inventory_detail d 
  inner join z20181120_af_inventory a on a.objid = d.controlid 
where d.reftype = 'stockreceipt' 
  and d.txntype = 'RECEIPT'
;

insert ignore into af_control_detail ( 
  objid, state, controlid, indexno, refid, refno, reftype, refdate, txndate, txntype, 
  receivedstartseries, receivedendseries, beginstartseries, beginendseries, 
  issuedstartseries, issuedendseries, endingstartseries, endingendseries, 
  qtyreceived, qtybegin, qtyissued, qtyending, qtycancelled, 
  remarks, issuedto_objid, issuedto_name 
) 
select distinct 
  concat(ir.controlid,'-00') as objid, 1 as state, ir.controlid, 0 as indexno, 
  r.refid, r.refno, 'PURCHASE_RECEIPT' as reftype, r.refdate, r.txndate, 'PURCHASE' as txntype, 
  ir.receivedstartseries, ir.receivedendseries, 
  null as beginstartseries, null as beginendseries, 
  null as issuedstartseries, null as issuedendseries, 
  ir.receivedstartseries as endingstartseries, ir.receivedendseries as endingendseries, 
  ir.qtyreceived, 0 as qtybegin, 0 as qtyissued, ir.qtyreceived as qtyending, 0 as qtycancelled, 
  convert(r.remarks, char(255)) as remarks, null as issuedto_objid, null as issuedto_name 
from ( 
  select ir.objid as issuancereceiptid,  
    (select objid from z20181120_vw_af_stockissuance where refid=ir.refid and afid=ir.afid order by lineno desc limit 1) as issuanceid 
  from z20181120_vw_af_stockissuancereceipt ir 
)t1 
  inner join z20181120_vw_af_stockissuancereceipt ir on ir.objid = t1.issuancereceiptid 
  inner join af_control afc on afc.objid = ir.controlid 
  inner join z20181120_vw_af_stockissuance i on i.objid = t1.issuanceid 
  inner join z20181120_vw_af_stockreceipt r on r.controlid = i.controlid 
; 
update af_control_detail set 
  beginstartseries = issuedstartseries, 
  beginendseries = ifnull(endingendseries, issuedendseries) 
where reftype='REMITTANCE' and txntype='REMITTANCE' 
; 

update 
  af_control_detail aa, ( 
    select d.objid, d.refid, r.collector_objid, r.collector_name 
    from af_control_detail d 
      inner join remittance r on r.objid = d.refid 
    where d.reftype='REMITTANCE' 
      and d.txntype='REMITTANCE' 
  )bb 
set 
  aa.issuedto_objid = bb.collector_objid, 
  aa.issuedto_name = bb.collector_name 
where aa.objid = bb.objid 
;

update 
  af_control aa, ( 
    select controlid, min(refdate) as refdate 
    from af_control_detail 
    group by controlid 
  )bb 
set aa.dtfiled = bb.refdate 
where aa.objid = bb.controlid 
  and aa.dtfiled is null 
; 

update af_control set state = 'ISSUED' where state is null 
;

update af_control aaa, ( 
    select d.controlid, d.indexno, d.objid 
    from ( 
      select a.objid, 
        (
          select objid from af_control_detail 
          where controlid=a.objid 
          order by refdate desc, txndate desc, indexno desc 
          limit 1 
        ) as lastdetailid 
      from af_control a 
    )t1, af_control_detail d 
    where d.objid = t1.lastdetailid 
  )bbb 
set 
  aaa.currentindexno = bbb.indexno, 
  aaa.currentdetailid = bbb.objid 
where aaa.objid = bbb.controlid 
; 

update 
  af_control aa, ( 
    select t1.*, d.indexno as currentindexno  
    from ( 
      select a.objid, 
        (select objid from af_control_detail where controlid = a.objid order by refdate desc, txndate desc limit 1) as currentdetailid 
      from af_control a 
      where a.currentdetailid is null 
    )t1, af_control_detail d 
    where d.objid = t1.currentdetailid 
  )bb 
set 
  aa.currentdetailid = bb.currentdetailid, 
  aa.currentindexno = bb.currentindexno 
where aa.objid = bb.objid 
;

update 
  af_control aa, ( 
    select afc.objid, ai.unit  
    from af_control afc, z20181120_af_inventory ai  
    where afc.objid = ai.objid 
      and afc.unit is null 
  )bb 
set aa.unit = bb.unit 
where aa.objid = bb.objid 
;

update 
  af_control aa, ( 
    select d.controlid, d.refno 
    from ( 
      select a.objid, 
        (
          select objid from af_control_detail 
          where controlid = a.objid and reftype in ('BEGIN_BALANCE','FORWARD','PURCHASE_RECEIPT','TRANSFER') 
          order by refdate, txndate, indexno desc limit 1 
        ) as detailid 
      from af_control a 
      where a.batchref is null 
    )t1, af_control_detail d 
    where d.objid = t1.detailid 
  )bb 
set aa.batchref = bb.refno, aa.batchno = 1  
where aa.objid = bb.controlid 
; 

update 
  af_control aa, ( 
    select afc.objid, 
      (select min(receiptdate) from cashreceipt where controlid = afc.objid) as receiptdate 
    from af_control afc 
    where afc.dtfiled is null
  )bb 
set aa.dtfiled = bb.receiptdate 
where aa.objid = bb.objid
; 

create table ztmp_afcontrol_no_dtfiled
select * from af_control where dtfiled is null 
; 
delete from af_control where objid in (
  select objid from ztmp_afcontrol_no_dtfiled 
  where objid = af_control.objid 
)
;

alter table af_control modify dtfiled date not null ; 
alter table af_control modify state varchar(50) not null ; 

update af_control_detail set 
  reftype='ISSUE', txntype='SALE' 
where reftype='stocksale' 
  and txntype='SALE-RECEIPT' 
;

INSERT INTO `af` (`objid`, `title`, `usetype`, `serieslength`, `system`, `denomination`, `formtype`, `baseunit`, `defaultunit`) VALUES ('907', 'COMMUNITY TAX(CORPORATE)', 'collection', '8', '1', '0.00', 'serial', NULL, NULL);

INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('0016-STUB', '0016', 'STUB', '50', '0.00', '1', 'cashreceipt-form:0016', NULL);
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('907-STUB', '907', 'STUB', '50', '0.00', '1', 'cashreceipt-form:907', NULL);
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('51-STUB', '51', 'STUB', '50', '0.00', '1', 'cashreceipt:printout:51', 'cashreceiptdetail:printout:51');
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('52-STUB', '52', 'STUB', '50', '0.00', '1', 'cashreceipt-form:52', NULL);
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('53-STUB', '53', 'STUB', '50', '0.00', '1', 'cashreceipt-form:53', NULL);
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('54-STUB', '54', 'STUB', '50', '0.00', '1', 'cashreceipt-form:54', NULL);
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('56-STUB', '56', 'STUB', '50', '0.00', '1', 'cashreceipt-form:56', 'cashreceiptdetail:printout:56');
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('57-STUB', '57', 'STUB', '50', '0.00', '1', 'cashreceipt-form:57', NULL);
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('58-STUB', '58', 'STUB', '50', '0.00', '1', 'cashreceipt-form:58', NULL);
-- INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('CT1-PAD', 'CT1', 'PAD', '2000', '0.00', '1', NULL, NULL);
-- INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('CT10-PAD', 'CT10', 'PAD', '2000', '0.00', '1', NULL, NULL);
-- INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('CT2-PAD', 'CT2', 'PAD', '2000', '0.00', '1', NULL, NULL);
INSERT INTO `afunit` (`objid`, `itemid`, `unit`, `qty`, `saleprice`, `interval`, `cashreceiptprintout`, `cashreceiptdetailprintout`) VALUES ('CT5-PAD', 'CT5', 'PAD', '2000', '0.00', '1', NULL, NULL);

update 
  af_control aa, ( 
    select afc.objid, 
      (select unit from afunit where itemid=afc.afid limit 1) as unit 
    from af_control afc 
    where afc.unit is null
  )bb 
set aa.unit = bb.unit 
where aa.objid = bb.objid
; 

alter table af_control modify unit varchar(25) not null ; 

insert into afrequest ( 
  objid, reqno, state, dtfiled, reqtype, itemclass, 
  requester_objid, requester_name, requester_title, 
  org_objid, org_name, vendor 
) 
select distinct 
  sr.objid, sr.reqno, sr.state, sr.dtfiled, 'COLLECTION' as reqtype, sr.itemclass, 
  sr.requester_objid, sr.requester_name, sr.requester_title, 
  sr.org_objid, sr.org_name, sr.vendor 
from ( 
  select refid, reftype, refno 
  from z20181120_vw_af_stockissuance
  group by refid, reftype, refno 
)t1
  inner join z20181120_stockissue si on si.objid = t1.refid 
  inner join z20181120_stockrequest sr on sr.objid = si.request_objid 
;

insert into afrequestitem ( 
  objid, parentid, item_objid, item_code, item_title, unit, qty, qtyreceived 
) 
select 
  sri.objid, sri.parentid, sri.item_objid, sri.item_code, sri.item_title, 
  sri.unit, sri.qty, sri.qtyreceived 
from afrequest req 
  inner join z20181120_stockrequestitem sri on sri.parentid = req.objid 
; 


insert into aftxn ( 
  objid, state, request_objid, request_reqno, controlno, dtfiled, 
  user_objid, user_name, issueto_objid, issueto_name, issueto_title, 
  org_objid, org_name, txndate, txntype, cost 
) 
select 
  si.objid, 'POSTED' as state, si.request_objid, si.request_reqno, si.issueno, si.dtfiled, 
  si.user_objid, si.user_name, si.issueto_objid, si.issueto_name, si.issueto_title, 
  si.org_objid, si.org_name, si.dtfiled, 'ISSUE' as txntype, null as cost 
from ( 
  select refid, reftype, refno 
  from z20181120_vw_af_stockissuance
  group by refid, reftype, refno 
)t1
  inner join z20181120_stockissue si on si.objid = t1.refid 
;

insert into aftxnitem ( 
  objid, parentid, item_objid, item_code, item_title, unit, 
  qty, qtyserved, remarks, txntype, cost 
) 
select 
  si.objid, si.parentid, si.item_objid, si.item_code, si.item_title, si.unit, 
  si.qtyrequested, si.qtyissued, si.remarks, 'COLLECTION' as txntype, 0 as cost 
from aftxn a 
  inner join z20181120_stockissueitem si on si.parentid = a.objid 
;



alter table bank add ( 
  `depositsliphandler` varchar(50) NULL, 
  `cashreport` varchar(255) NULL, 
  `checkreport` varchar(255) NULL 
)
;
alter table bank add _ukey varchar(50) not null default ''
;
update bank set _ukey=objid where _ukey=''
;
create UNIQUE index `ux_bank_code_branch` on bank (`code`,`branchname`,`_ukey`) ; 

create UNIQUE index `ux_bank_name_branch` on bank (`name`,`branchname`) ; 
create index ix_name on bank (name);
create index ix_state on bank (state);
create index ix_code on bank (code);


alter table bankaccount modify fund_objid varchar(100) null not null ;  
alter table bankaccount add acctid varchar(50) null ; 
create index ix_acctid on bankaccount (acctid) ;
alter table bankaccount 
  add constraint fk_bankaccount_acctid 
  foreign key (acctid) references itemaccount (objid) ; 


alter table batchcapture_collection_entry_item modify `item_title` varchar(255) NULL ;
alter table batchcapture_collection_entry_item modify `fund_objid` varchar(100) NULL ;


delete from business_recurringfee where objid='RECFEE687ce4b1:1689d2dfeea:-4cb7'
;
create UNIQUE index `uix_businessid_acctid` on business_recurringfee (`businessid`,`account_objid`) 
;

alter table cashreceipt modify payer_name varchar(800) null ;
alter table cashreceipt modify paidby varchar(800) not null ;
alter table cashreceipt add ( 
  remittanceid varchar(50) null, 
  subcollector_remittanceid varchar(50) null 
)
;
create index ix_remittanceid on cashreceipt (remittanceid); 
create index ix_subcollector_remittanceid on cashreceipt (subcollector_remittanceid); 

create index ix_paidby on cashreceipt (paidby) ; 
create index ix_payer_name on cashreceipt (payer_name) ; 
create index ix_formtype on cashreceipt (formtype) ; 


alter table cashreceiptitem modify receiptid varchar(50) not null ;

create table ztmp_cashreceiptitem_no_item_objid 
select * from cashreceiptitem where item_objid is null
;
delete from cashreceiptitem where objid in (
  select objid from ztmp_cashreceiptitem_no_item_objid 
  where objid = cashreceiptitem.objid 
)
;

alter table cashreceiptitem modify item_objid varchar(50) not null ;
alter table cashreceiptitem modify item_code varchar(100) not null ;
alter table cashreceiptitem modify item_title varchar(255) not null ;
alter table cashreceiptitem modify amount decimal(16,4) not null ;
create index `ix_item_code` on cashreceiptitem (`item_code`) ; 
create index `ix_item_title` on cashreceiptitem (`item_title`) ; 

alter table cashreceiptitem add sortorder int default '0';

alter table cashreceiptitem add item_fund_objid varchar(100) null ;
create index ix_item_fund_objid on cashreceiptitem (item_fund_objid) ;

update cashreceiptitem ci, itemaccount ia set 
  ci.item_fund_objid = ia.fund_objid 
where ci.item_objid = ia.objid 
;
update cashreceiptitem set item_fund_objid = 'GENERAL' where item_fund_objid is null 
; 
alter table cashreceiptitem modify item_fund_objid varchar(100) not null ;
alter table cashreceiptitem 
  add constraint fk_cashreceiptitem_item_fund_objid 
  foreign key (item_fund_objid) REFERENCES fund (objid) 
; 


alter table cashreceiptpayment_creditmemo modify account_fund_objid varchar(100) null ;


alter table cashreceiptpayment_noncash change bank _bank varchar(50) null ; 
alter table cashreceiptpayment_noncash drop foreign key cashreceiptpayment_noncash_ibfk_2; 
alter table cashreceiptpayment_noncash change bankid _bankid varchar(50) null ; 
alter table cashreceiptpayment_noncash change deposittype _deposittype varchar(50) null ; 
alter table cashreceiptpayment_noncash modify account_fund_objid varchar(100) null ; 

alter table cashreceiptpayment_noncash add ( 
  fund_objid varchar(100) null, 
  refid varchar(50) null, 
  checkid varchar(50) null, 
  voidamount decimal(16,4) null 
)
;
create index ix_fund_objid on cashreceiptpayment_noncash (fund_objid) ;
create index ix_refid on cashreceiptpayment_noncash (refid) ;
create index ix_checkid on cashreceiptpayment_noncash (checkid) ;

alter table cashreceiptpayment_noncash 
  modify fund_objid varchar(100) character set utf8 null 
; 
alter table cashreceiptpayment_noncash 
  add constraint fk_cashreceiptpayment_noncash_fund_objid 
  foreign key (fund_objid) references fund (objid) 
; 


create unique index uix_receiptid on cashreceipt_cancelseries (receiptid)
;

update cashreceipt set paidby = substring(paidby, 1, 800) ; 
update cashreceipt set payer_name = substring(payer_name, 1, 800) ; 

alter table cashreceipt modify paidby varchar(800) not null ; 
alter table cashreceipt modify payer_name varchar(800) null ; 

create table ztmp_duplicate_cashreceipt_void 
select t1.receiptid, (
    select objid from cashreceipt_void 
    where receiptid = t1.receiptid 
    order by txndate limit 1 
  )as validreceiptid 
from (
  select receiptid, count(*) as icount 
  from cashreceipt_void  
  group by receiptid
  having count(*) > 1 
)t1 
;
create index ix_receiptid on ztmp_duplicate_cashreceipt_void (receiptid);
create index ix_validreceiptid on ztmp_duplicate_cashreceipt_void (validreceiptid);

create table ztmp_duplicate_cashreceipt_void_for_deletion 
select v.objid  
from cashreceipt_void v 
  inner join ztmp_duplicate_cashreceipt_void z on (z.receiptid = v.receiptid and z.validreceiptid <> v.objid) 
;
delete from cashreceipt_void where objid in (select objid from ztmp_duplicate_cashreceipt_void_for_deletion) 
; 
drop table ztmp_duplicate_cashreceipt_void_for_deletion; 
drop table ztmp_duplicate_cashreceipt_void;

create unique index uix_receiptid on cashreceipt_void (receiptid) ;


create table z20181120_collectiongroup 
select * from collectiongroup 
; 

alter table collectiongroup drop column afno ; 
alter table collectiongroup drop column org_objid ; 
alter table collectiongroup drop column org_name ;


alter table collectiongroup_revenueitem drop foreign key collectiongroup_revenueitem_ibfk_1 ; 
alter table collectiongroup_revenueitem drop foreign key collectiongroup_revenueitem_ibfk_2 ; 

create index ix_collectiongroupid on collectiongroup_revenueitem (collectiongroupid) ; 
alter table collectiongroup_revenueitem change revenueitemid account_objid varchar(50) not null ; 
alter table collectiongroup_revenueitem change orderno sortorder int not null ; 

alter table collectiongroup_revenueitem add (
  `objid` varchar(100) NULL,
  `account_title` varchar(255) NULL,
  `tag` varchar(255) NULL 
)
;

update collectiongroup_revenueitem set objid = concat('CGA-', md5(concat(collectiongroupid,'|',account_objid))) ; 
update collectiongroup_revenueitem aa, itemaccount bb set aa.account_title = bb.title where aa.account_objid = bb.objid ; 

alter table collectiongroup_revenueitem drop primary key ; 
rename table collectiongroup_revenueitem to collectiongroup_account ; 

alter table collectiongroup_account modify objid varchar(50) not null ; 
alter table collectiongroup_account modify account_title varchar(255) not null ; 

alter table collectiongroup_account add constraint pk_collectiongroup_account primary key (objid) ; 
create unique index uix_collectiongroup_account on collectiongroup_account (collectiongroupid, account_objid) ; 

create table ztmp_collectiongroup_account_no_parent_reference
select * from collectiongroup_account where collectiongroupid not in (
  select objid from collectiongroup 
  where objid = collectiongroup_account.collectiongroupid 
) 
;
delete from collectiongroup_account where objid in (
  select objid from ztmp_collectiongroup_account_no_parent_reference 
  where objid = collectiongroup_account.objid 
)
;
alter table collectiongroup_account add constraint fk_collectiongroup_account_collectiongroupid 
  foreign key (collectiongroupid) references collectiongroup (objid) 
;
alter table collectiongroup_account add constraint fk_collectiongroup_account_account_objid 
  foreign key (account_objid) references itemaccount (objid) 
;


insert into collectiongroup_org ( 
  objid, collectiongroupid, org_objid, org_name, org_type 
) 
select * from ( 
  select 
    concat('CGO-',MD5(concat(g.objid,'|',g.org_objid))) as objid, g.objid as collectiongroupid, 
    o.objid as org_objid, o.name as org_name, o.orgclass as org_type 
  from z20181120_collectiongroup g, sys_org o 
  where g.org_objid = o.objid 
)t1 
; 


create index ix_state on collectiongroup (state) ;
update collectiongroup set state = 'ACTIVE' ; 


alter table collectiontype modify allowbatch int default '0' ; 
alter table collectiontype modify allowonline int default '0' ; 
alter table collectiontype modify allowoffline int default '0' ; 

alter table collectiontype add ( 
  `allowpaymentorder` int default '0',
  `allowkiosk` int default '0',
  `allowcreditmemo` int default '0', 
  `system` int default '0'  
)
; 

create table z20181120_collectiontype 
select * from collectiontype 
; 

create index ix_state on collectiontype (state) ; 
update collectiontype set state = 'ACTIVE' ; 

create index ix_collectiontypeid on collectiontype_account (collectiontypeid) ; 
alter table collectiontype_account add objid varchar(50) null ; 

update collectiontype_account set objid = concat('CTA-',MD5(concat(collectiontypeid,'|',account_objid))); 
alter table collectiontype_account modify objid varchar(50) not null ; 
alter table collectiontype_account drop primary key ; 
alter table collectiontype_account add constraint pk_collectiontype_account primary key (objid) ;
create unique index uix_collectiontype_account on collectiontype_account (collectiontypeid, account_objid) ;


insert into collectiontype_org ( 
  objid, collectiontypeid, org_objid, org_name, org_type 
) 
select * from ( 
  select 
    concat('CTO-',MD5(concat(a.objid,'|',o.objid))) as objid, a.objid as collectiontypeid, 
    o.objid as org_objid, o.name as org_name, o.orgclass as org_type 
  from z20181120_collectiontype a, sys_org o 
  where a.org_objid = o.objid 
)t1 
;  


alter table creditmemo add ( 
  `receiptdate` date NULL,
  `issuereceipt` int NULL,
  `type` varchar(25) NULL
)
; 
create index ix_receiptdate on creditmemo (receiptdate) ; 


alter table creditmemotype modify fund_objid varchar(100) null ; 
alter table creditmemotype 
  modify fund_objid varchar(100) character set utf8 null 
; 
alter table creditmemotype add constraint fk_creditmemotype_fund_objid 
  foreign key (fund_objid) references fund (objid) 
; 
alter table creditmemotype 
  change `HANDLER` `handler` varchar(50) null 
;



alter table entity modify entityname varchar(800) not null ; 
alter table entity modify email varchar(50) null ; 
alter table entity add state varchar(25) null ; 
create index ix_state on entity (state);
update entity set state = 'ACTIVE' where state is null; 


create unique index uix_idtype_idno on entityid (entityid, idtype, idno);
 
create table ztmp_invalid_entityid 
select id.objid 
from entityid id 
  left join entity e on e.objid = id.entityid 
where id.entityid is not null 
  and e.objid is null 
;
delete from entityid where objid in ( 
  select objid from  ztmp_invalid_entityid
)
;
drop table ztmp_invalid_entityid 
;

alter table entityid add constraint fk_entityid_entityid 
  foreign key (entityid) references entity (objid) 
;


alter table entityindividual modify lastname varchar(100) not null ; 
alter table entityindividual modify firstname varchar(100) not null ; 
alter table entityindividual modify tin varchar(50) null ; 
alter table entityindividual add profileid varchar(50) null; 
create index ix_profileid on entityindividual (profileid);


alter table entityjuridical modify tin varchar(50) null ;
alter table entityjuridical modify administrator_address varchar(255) null ;
alter table entityjuridical add ( 
  administrator_objid varchar(50) null, 
  administrator_address_objid varchar(50) null, 
  administrator_address_text varchar(255) null 
);
create index ix_dtregistered on entityjuridical (dtregistered);
create index ix_administrator_objid on entityjuridical (administrator_objid);
create index ix_administrator_name on entityjuridical (administrator_name);
create index ix_administrator_address_objid on entityjuridical (administrator_address_objid);

update entityjuridical set 
  administrator_address_text = administrator_address
where administrator_address_text is null 
;


-- alter table entitymember add member_address varchar(255) null ;
alter table entitymember modify member_name varchar(800) not null ;


alter table entity_address modify street varchar(255) null ;


alter table fund modify objid varchar(100) not null ; 

alter table fund add ( 
  `groupid` varchar(50) NULL,
  `depositoryfundid` varchar(100) NULL 
)
;
create index ix_groupid on fund (groupid) ; 
create index ix_depositoryfundid on fund (depositoryfundid) ; 

update fund set state = 'ACTIVE' 
; 
update fund set 
  groupid = objid, depositoryfundid = objid, system = 1, parentid = null  
where objid in ('GENERAL', 'SEF', 'TRUST') 
; 
update fund set depositoryfundid = objid where depositoryfundid is null 
;
update fund a, fund b set 
  a.groupid = b.objid 
where a.parentid = b.objid 
  and b.objid in ('GENERAL','SEF','TRUST') 
  and a.groupid is null 
;
update fund set system=0 where system is null 
;
update fund set groupid = 'GENERAL' where groupid is null 
;  


update fund set title='GENERAL PROPER' where objid='GENERAL';
update fund set title='SEF PROPER' where objid='SEF';
update fund set title='TRUST PROPER' where objid='TRUST';

update fund aa, ( select distinct fund_objid from bankaccount ) bb 
set aa.depositoryfundid = aa.objid 
where aa.objid = bb.fund_objid 
;


alter table itemaccount modify fund_objid varchar(100) null; 
alter table itemaccount add constraint fk_itemaccount_fund_objid 
  foreign key (fund_objid) references fund (objid)
;

alter table itemaccount add (
  `generic` int(11) DEFAULT '0',
  `sortorder` int(11) DEFAULT '0',
  `hidefromlookup` int(11) NOT NULL DEFAULT '0' 
)
;
create index `ix_state` on itemaccount (`state`) ; 
create index `ix_generic` on itemaccount (`generic`) ; 
create index `ix_type` on itemaccount (`type`) ; 

update itemaccount set state = 'ACTIVE' where state = 'APPROVED' ; 


alter table lob modify name varchar(255) not null ;
alter table lob add psic_objid varchar(50) null ; 
create index ix_psic_objid on lob (psic_objid) ;
  

alter table remittance_fund modify fund_objid varchar(100) not null; 

update remittance_fund set fund_objid='FUND6f3c344a:15ec5d50d11:-7bb7' where fund_objid='TRUST FUND - DOLE'
;
update remittance_fund set fund_objid='GENERAL' where fund_objid='GENERAL FUND'
;
alter table remittance_fund add constraint fk_remittance_fund_fund_objid 
  foreign key (fund_objid) references fund (objid)
;

alter table remittance change txnno controlno varchar(100) not null ; 
alter table remittance change totalnoncash totalcheck decimal(16,2) not null ; 
alter table remittance modify `liquidatingofficer_objid` varchar(50) NULL ; 
alter table remittance modify `liquidatingofficer_name` varchar(100) NULL ; 
alter table remittance modify `liquidatingofficer_title` varchar(50) NULL ; 

update remittance set remittancedate = dtposted where remittancedate is null ;
alter table remittance change remittancedate controldate datetime not null ; 

alter table remittance add ( 
  `totalcr` decimal(16,2) NULL,
  `collector_signature` longtext NULL,
  `liquidatingofficer_signature` longtext NULL,
  `collectionvoucherid` varchar(50) NULL 
)
;

alter table remittance add _ukey varchar(50) not null default '';
update remittance set _ukey = objid; 

create unique index uix_controlno on remittance (controlno,_ukey) ; 
create index ix_controldate on remittance (controldate) ; 
create index ix_collectionvoucherid on remittance (collectionvoucherid) ; 

update remittance set totalcr = 0.0 where totalcr is null ; 
alter table remittance modify totalcr decimal(16,2) not null ; 

alter table remittance 
  add constraint fk_remittance_collectionvoucherid 
  foreign key (collectionvoucherid) references collectionvoucher (objid) ;


alter table remittance_af add ( 
  `controlid` varchar(50) NULL,
  `receivedstartseries` int NULL,
  `receivedendseries` int NULL,
  `beginstartseries` int NULL,
  `beginendseries` int NULL,
  `issuedstartseries` int NULL,
  `issuedendseries` int NULL,
  `endingstartseries` int NULL,
  `endingendseries` int NULL,
  `qtyreceived` int NULL,
  `qtybegin` int NULL,
  `qtyissued` int NULL,
  `qtyending` int NULL,
  `qtycancelled` int NULL,
  `remarks` varchar(255) NULL 
)
;
create index ix_controlid on remittance_af (controlid) 
; 


alter table remittance_fund modify fund_objid varchar(100) not null ; 
alter table remittance_fund modify fund_title varchar(255) not null ; 
alter table remittance_fund add ( 
  `totalcash` decimal(16,4) NULL,
  `totalcheck` decimal(16,4) NULL,
  `totalcr` decimal(16,4) NULL,
  `cashbreakdown` longtext NULL,
  `controlno` varchar(100) NULL 
)
;

update remittance_fund set totalcash = amount where totalcash is null ; 
update remittance_fund set totalcheck = 0.0 where totalcheck is null ; 
update remittance_fund set totalcr = 0.0 where totalcr is null ; 

alter table remittance_fund modify amount decimal(16,4) not null ; 
alter table remittance_fund modify totalcash decimal(16,4) not null ; 
alter table remittance_fund modify totalcheck decimal(16,4) not null ; 
alter table remittance_fund modify totalcr decimal(16,4) not null ; 
alter table remittance_fund modify remittanceid varchar(50) not null ; 

create table ztmp_remittance_fund_duplicates
select rf.* 
from ( 
  select rf.remittanceid, rf.fund_objid, count(*) as icount 
  from remittance_fund rf 
  group by rf.remittanceid, rf.fund_objid 
  having count(*) > 1 
)t1, remittance_fund rf 
where rf.remittanceid = t1.remittanceid   
  and rf.fund_objid = t1.fund_objid 
;
delete from remittance_fund where objid in (
  select objid from ztmp_remittance_fund_duplicates 
  where objid = remittance_fund.objid 
)
;

create unique index uix_remittance_fund on remittance_fund (remittanceid, fund_objid) 
; 

insert into remittance_fund (
  objid, remittanceid, fund_objid, fund_title, 
  amount, totalcash, totalcheck, totalcr
)
select 
  concat('REMFUND-', MD5(concat(remittanceid, fund_objid))) as objid, remittanceid, fund_objid, 
  (select fund_title from ztmp_remittance_fund_duplicates where remittanceid = t1.remittanceid and fund_objid = t1.fund_objid limit 1) as fund_title, 
  amount, totalcash, totalcheck, totalcr 
from ( 
  select 
    rf.remittanceid, rf.fund_objid, 
    sum(rf.amount) as amount, sum(rf.totalcash) as totalcash, 
    sum(rf.totalcheck) as totalcheck, sum(rf.totalcr) as totalcr
  from ztmp_remittance_fund_duplicates rf 
  group by rf.remittanceid, rf.fund_objid 
)t1
;


alter table sys_org modify root int not null default '0' ; 

CREATE TABLE `sys_requirement_type` (
  `code` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `handler` varchar(50) DEFAULT NULL,
  `objid` varchar(50) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `system` int(11) DEFAULT NULL,
  `agency` varchar(50) DEFAULT NULL,
  `sortindex` int(11) NOT NULL,
  `verifier` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

alter table sys_rule add noloop int not NULL default '1' ; 
alter table sys_rule modify name varchar(255) not null ;

alter table sys_rule_actiondef_param modify objid varchar(255) not null; 

alter table sys_rule_action_param modify actiondefparam_objid varchar(255) NOT NULL; 

update sys_rule_condition set notexist=0 where notexist is null; 
alter table sys_rule_condition modify notexist int NOT NULL default '0';

alter table sys_rule_condition_constraint modify field_objid varchar(255) null; 

alter table sys_rule_fact_field modify objid varchar(255) not null ;

alter table sys_securitygroup modify objid varchar(100) not null; 

alter table sys_session add terminalid varchar(50) null; 
alter table sys_session_log add terminalid varchar(50) null; 

alter table sys_wf_node modify idx int not null; 
alter table sys_wf_node add ( 
  properties text NULL,
  ui text NULL,
  tracktime int null 
); 

alter table sys_wf_transition add ui text null ; 


alter table af_control modify fund_objid varchar(100) null ; 


CREATE TABLE `business_permit_lob` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `lobid` varchar(50) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `txndate` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_parentid` (`parentid`),
  KEY `ix_lobid` (`lobid`),
  KEY `ix_name` (`name`),
  CONSTRAINT `fk_business_permit_lob_lobid` FOREIGN KEY (`lobid`) REFERENCES `lob` (`objid`),
  CONSTRAINT `fk_business_permit_lob_parentid` FOREIGN KEY (`parentid`) REFERENCES `business_permit` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


insert ignore into business_permit_lob ( 
  objid, parentid, lobid, name, txndate 
) 
select 
  concat('PLOB-',MD5(concat(tmp2.parentid,'-',tmp2.lobid))) as objid, 
  tmp2.parentid, tmp2.lobid, lob.name, tmp2.txndate 
from ( 
  select 
    parentid, lobid, min(txndate) as txndate, sum(iflag) as iflag 
  from ( 
    select 
      p.objid as parentid, alob.lobid, a.txndate, 
      (case when alob.assessmenttype in ('NEW','RENEW') then 1 else -1 end) as iflag 
    from business_permit p 
      inner join business_application pa on p.applicationid=pa.objid 
      inner join business_application a on (a.business_objid=p.businessid and a.appyear=pa.appyear)
      inner join business_application_lob alob on alob.applicationid=a.objid 
    where p.state = 'ACTIVE' 
      and a.state = 'COMPLETED' 
      and a.txndate <= pa.txndate 
  )tmp1 
  group by parentid, lobid 
  having sum(iflag) > 0 
)tmp2 
  left join lob on lob.objid=tmp2.lobid 
order by tmp2.txndate 
;


drop table if exists ztmp_business_recurringfee_duplicates
;
create table ztmp_business_recurringfee_duplicates 
select rf.* 
from ( 
  select t1.*, 
    (
      select objid from business_recurringfee 
      where businessid=t1.businessid and account_objid=t1.account_objid 
      order by amount desc limit 1 
    ) as recfeeid 
  from ( 
    select businessid, account_objid, count(*) as icount 
    from business_recurringfee 
    group by businessid, account_objid 
    having count(*) > 1 
  )t1 
)t2, business_recurringfee rf 
where rf.businessid = t2.businessid 
  and rf.account_objid = t2.account_objid 
  and rf.objid <> t2.recfeeid 
;
delete from business_recurringfee where objid in ( 
  select objid from ztmp_business_recurringfee_duplicates 
)
;

update business_permit p, business_application a set 
  a.permit_objid = p.objid 
where p.applicationid = a.objid 
  and a.permit_objid is null 
;


alter table cashreceipt modify `paidbyaddress` varchar(800) NOT NULL ;

alter table cashreceipt 
  add constraint fk_cashreceipt_remittanceid 
  foreign key (remittanceid) references remittance (objid) ;

alter table cashreceipt 
  add constraint fk_cashreceipt_subcollector_remittanceid 
  foreign key (subcollector_remittanceid) references subcollector_remittance (objid) ;

update cashreceipt aa, z20181120_remittance_cashreceipt bb 
set aa.remittanceid = bb.remittanceid  
where aa.objid = bb.objid
;

update cashreceipt aa, subcollector_remittance_cashreceipt bb 
set aa.subcollector_remittanceid = bb.remittanceid  
where aa.objid = bb.objid 
;

alter table cashreceipt_share 
  add constraint fk_cashreceipt_share_refitem_objid 
  foreign key (refitem_objid) references itemaccount (objid) ; 

alter table cashreceipt_share 
  add constraint fk_cashreceipt_share_payableitem_objid 
  foreign key (payableitem_objid) references itemaccount (objid) ; 


create index ix_txnno on certification (txnno) ; 
create index ix_txndate on certification (txndate) ; 
create index ix_type on certification (type) ; 
create index ix_name on certification (name) ; 
create index ix_orno on certification (orno) ; 
create index ix_ordate on certification (ordate) ; 
create index ix_createdbyid on certification (createdbyid) ; 
create index ix_createdby on certification (createdby) ; 

alter table collectiontype modify fund_objid varchar(100) null ;
alter table collectiontype modify fund_title varchar(255) null ;

create index ix_account_title on collectiontype_account (account_title) ;

drop table if exists draftremittance_cashreceipt ;

create index `ix_entityname_state` on entity (`state`,`entityname`); 

alter table txnlog modify refid varchar(255) not null ; 
create index ix_refid on txnlog (refid); 



-- ## patch-07

insert into afunit ( 
  objid, itemid, unit, qty, saleprice, `interval` 
) 
select * from ( 
  select 
    concat(b.itemid,'-',b.unit) as objid, b.itemid, b.unit, b.qty, 0.0 as saleprice, 
    case when a.formtype = 'serial' then 1 else 0 end as `interval` 
  from af a, z20181120_stockitem_unit b 
  where a.objid = b.itemid 
)t1 
where t1.objid not in (select objid from afunit where objid = t1.objid)
;


INSERT IGNORE INTO aftxn_type (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('BEGIN', 'BEGIN_BALANCE', 'OPEN', '1');
INSERT IGNORE INTO aftxn_type (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('COLLECTION', 'ISSUE', 'ISSUED', '3');
INSERT IGNORE INTO aftxn_type (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('FORWARD', 'FORWARD', 'ISSUED', '2');
INSERT IGNORE INTO aftxn_type (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('RETURN_COLLECTION', 'RETURN', 'OPEN', '7');
INSERT IGNORE INTO aftxn_type (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('RETURN_SALE', 'RETURN', 'OPEN', '8');
INSERT IGNORE INTO aftxn_type (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('SALE', 'ISSUE', 'SOLD', '4');
INSERT IGNORE INTO aftxn_type (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('TRANSFER_COLLECTION', 'TRANSFER', 'ISSUED', '5');
INSERT IGNORE INTO aftxn_type (`txntype`, `formtype`, `poststate`, `sortorder`) VALUES ('TRANSFER_SALE', 'TRANSFER', 'ISSUED', '6');


update afunit a, af set 
  a.cashreceiptprintout = concat('cashreceipt-form:', a.itemid) 
where af.objid = a.itemid 
  and af.formtype = 'serial' 
  and a.cashreceiptprintout is null 
;


update afunit set 
  cashreceiptprintout = 'cashreceipt:printout:51', 
  cashreceiptdetailprintout = 'cashreceiptdetail:printout:51' 
where itemid = '51' and unit = 'STUB' 
; 


update afunit set 
  cashreceiptprintout = 'cashreceipt-form:56', 
  cashreceiptdetailprintout = 'cashreceiptdetail:printout:56' 
where itemid = '56' and unit = 'STUB' 
; 


update itemaccount set state = 'ACTIVE' where state = 'APPROVED' ;
update itemaccount set state = 'DRAFT' where state <> 'ACTIVE' ;


INSERT INTO itemaccount (`objid`, `state`, `code`, `title`, `type`, `generic`, `sortorder`) 
VALUES ('CASH_IN_TREASURY', 'ACTIVE', '-', 'CASH IN TREASURY', 'CASH_IN_TREASURY', 0, 0)
;


insert into itemaccount ( 
  objid, state, type, code, title,  fund_objid, fund_code, 
  fund_title, defaultvalue, valuetype, generic, sortorder 
) 
select * from ( 
  select 
    concat('CIB-', objid) as objid, 'ACTIVE' as state, 'CASH_IN_BANK' as type, '-' as code, 
    concat('CASH IN BANK - ', title) as title, objid as fund_objid, code as fund_code, 
    title as fund_title, 0.0 as defaultvalue, 'ANY' as valuetype, 0 as generic, 0 as sortorder 
  from fund 
  where state = 'ACTIVE' 
)t1 
where t1.objid not in (select objid from itemaccount where objid = t1.objid)
; 


update bankaccount ba, itemaccount ia 
set ba.acctid = ia.objid  
where ia.objid = concat('CIB-', ba.fund_objid) and ba.acctid is null 
; 


insert ignore into business_application_task_lock ( 
  refid, state 
) 
select bat.refid, bat.state  
from ( 
  select t1.*, 
    (
      select objid from business_application_task 
      where refid = t1.objid  
      order by startdate desc, enddate desc 
      limit 1 
    ) as currenttaskid 
  from ( select objid from business_application where state <> 'COMPLETED' )t1 
)t2, business_application_task bat 
where bat.objid = t2.currenttaskid 
; 


insert into collectionvoucher (
  objid, state, controlno, controldate, amount, totalcash, totalcheck, totalcr, cashbreakdown, 
  liquidatingofficer_objid, liquidatingofficer_name, liquidatingofficer_title, dtposted 
) 
select 
  objid, state, txnno as controlno, dtposted as controldate, 
  amount, totalcash, totalnoncash as totalcheck, 0.0 as totalcr, cashbreakdown, 
  liquidatingofficer_objid, liquidatingofficer_name, liquidatingofficer_title, 
  dtposted 
from z20181120_liquidation 
;


drop table if exists ztmp_collectionvoucher_fund
;
create table ztmp_collectionvoucher_fund 
select 
  lcf.objid, cv.objid as parentid, concat(cv.controlno,'-',fund.code) as controlno, 
  lcf.fund_objid, lcf.fund_title, lcf.amount, 
  case when lcf.totalcash is null then lcf.amount else lcf.totalcash end as totalcash, 
  case when lcf.totalnoncash is null then 0.0 else lcf.totalnoncash end as totalcheck, 
  0.0 as totalcr, 
  case when lcf.cashbreakdown is null then '[]' else lcf.cashbreakdown end as cashbreakdown 
from z20181120_liquidation_cashier_fund lcf 
  inner join collectionvoucher cv on cv.objid = lcf.liquidationid 
  inner join fund on fund.objid = lcf.fund_objid 
;
drop table if exists ztmp_collectionvoucher_fund_phase1
;
create table ztmp_collectionvoucher_fund_phase1 
select parentid, fund_objid, sum(amount) as amount, count(*) as icount  
from ztmp_collectionvoucher_fund 
group by parentid, fund_objid 
having count(*) > 1 
;
drop table if exists ztmp_collectionvoucher_fund_phase2
;
create table ztmp_collectionvoucher_fund_phase2 
select a.parentid, a.fund_objid, a.amount, min(b.objid) as objid 
from ztmp_collectionvoucher_fund_phase1 a, ztmp_collectionvoucher_fund b 
where a.parentid = b.parentid and a.fund_objid = b.fund_objid 
group by a.parentid, a.fund_objid, a.amount  
;
update ztmp_collectionvoucher_fund aa, ztmp_collectionvoucher_fund_phase2 bb 
set aa.amount = bb.amount  
where aa.objid = bb.objid
;
drop table if exists ztmp_collectionvoucher_fund_phase3
;
create table ztmp_collectionvoucher_fund_phase3 
select a.objid  
from ztmp_collectionvoucher_fund a, ztmp_collectionvoucher_fund_phase2 b 
where a.parentid = b.parentid 
  and a.fund_objid = b.fund_objid 
  and a.objid <> b.objid 
;
delete from ztmp_collectionvoucher_fund where objid in (
  select objid from ztmp_collectionvoucher_fund_phase3 
)
;
drop table if exists ztmp_collectionvoucher_fund_phase3 ; 
drop table if exists ztmp_collectionvoucher_fund_phase2 ; 
drop table if exists ztmp_collectionvoucher_fund_phase1 ; 

insert into collectionvoucher_fund (
  objid, parentid, controlno, fund_objid, fund_title, 
  amount, totalcash, totalcheck, totalcr, cashbreakdown 
) 
select 
  objid, parentid, controlno, fund_objid, fund_title, 
  amount, totalcash, totalcheck, totalcr, cashbreakdown 
from ztmp_collectionvoucher_fund 
;

drop table if exists ztmp_collectionvoucher_fund
;


drop table if exists ztmp_collectionvoucherdeposit
;
create table ztmp_collectionvoucherdeposit 
select distinct 
  cvf.parentid as collectionvoucherid, bdl.bankdepositid as depositvoucherid  
from z20181120_bankdeposit_liquidation bdl 
  inner join collectionvoucher_fund cvf on cvf.objid = bdl.objid 
;

insert into depositvoucher (
  objid, state, controlno, controldate, 
  dtcreated, createdby_objid, createdby_name, 
  amount, dtposted, postedby_objid, postedby_name 
) 
select 
  bd.objid, bd.state, bd.txnno as controlno, bd.dtposted as controldate, 
  bd.dtposted as dtcreated, cashier_objid as createdby_objid, cashier_name as createdby_name, 
  bd.amount, bd.dtposted, cashier_objid as postedby_objid, cashier_name as postedby_name  
from ( 
  select distinct depositvoucherid 
  from ztmp_collectionvoucherdeposit 
)t1, z20181120_bankdeposit bd 
where bd.objid = t1.depositvoucherid 
;

update  
  collectionvoucher aa, ( 
    select z.* 
    from depositvoucher dv, ztmp_collectionvoucherdeposit z 
    where dv.objid = z.depositvoucherid 
  )bb 
set aa.depositvoucherid = bb.depositvoucherid 
where aa.objid = bb.collectionvoucherid 
; 

update collectionvoucher set state='POSTED' where state='OPEN';  

update 
  remittance aa, ( 
    select z.* 
    from z20181120_liquidation_remittance z, collectionvoucher cv  
    where cv.objid = z.liquidationid 
  )bb 
set aa.collectionvoucherid = bb.liquidationid  
where aa.objid = bb.objid
;

update remittance set state = 'POSTED' where state in ('OPEN','APPROVED'); 

create table ztmp_depositvoucher_fund
select 
  concat(dv.objid,'|',ba.fund_objid) as objid, 'POSTED' as state, 
  dv.objid as parentid, ba.fund_objid as fundid, ze.amount, 
  ze.amount as amountdeposited, 0.0 as totaldr, 0.0 as totalcr 
from ( 
  select distinct depositvoucherid 
  from ztmp_collectionvoucherdeposit
)t1, depositvoucher dv, z20181120_bankdeposit_entry ze, bankaccount ba 
where dv.objid = t1.depositvoucherid 
  and ze.parentid = dv.objid 
  and ba.objid = ze.bankaccount_objid 
;

create table ztmp_depositvoucher_fund_fixed_duplicate
select 
  vf.parentid, vf.fundid, sum(vf.amount) as amount, 
  sum(vf.amountdeposited) as amountdeposited, 
  sum(vf.totaldr) as totaldr, sum(vf.totalcr) as totalcr 
from ( 
  select parentid, fundid, count(*) as icount 
  from ztmp_depositvoucher_fund 
  group by parentid, fundid 
  having count(*) > 1 
)t1, ztmp_depositvoucher_fund vf 
where vf.parentid = t1.parentid 
  and vf.fundid = t1.fundid 
group by vf.parentid, vf.fundid 
; 

delete from ztmp_depositvoucher_fund where (
  select count(*) from ztmp_depositvoucher_fund_fixed_duplicate 
  where parentid = ztmp_depositvoucher_fund.parentid 
    and fundid = ztmp_depositvoucher_fund.fundid 
) > 0 
;

insert into depositvoucher_fund ( 
  objid, state, parentid, fundid, amount, amountdeposited, totaldr, totalcr 
) 
select 
  concat(parentid,'|',fundid) as objid, 'POSTED' as state, 
  parentid, fundid, amount, amountdeposited, totaldr, totalcr 
from ztmp_depositvoucher_fund 
;

insert into depositvoucher_fund ( 
  objid, state, parentid, fundid, amount, amountdeposited, totaldr, totalcr 
) 
select 
  concat(parentid,'|',fundid) as objid, 'POSTED' as state, 
  parentid, fundid, amount, amountdeposited, totaldr, totalcr 
from ztmp_depositvoucher_fund_fixed_duplicate 
;

drop table ztmp_depositvoucher_fund_fixed_duplicate;
drop table ztmp_depositvoucher_fund;


alter table remittance_fund modify objid varchar(150) not null ;

alter table remittance_af modify objid varchar(150) not null ;


insert into checkpayment (
  objid, bankid, bank_name, refno, refdate, amount, amtused, receivedfrom, 
  collector_objid, collector_name, state, split, external 
) 
select 
  nc.objid, bank.objid as bankid, bank.name as bank_name, nc.refno, nc.refdate, 
  nc.amount, nc.amount as amtused, c.paidby as receivedfrom, 
  c.collector_objid, c.collector_name, 'PENDING' as state, 0 as split, 0 as `external` 
from cashreceiptpayment_noncash nc, cashreceipt c, bank 
where nc.receiptid = c.objid 
  and nc._bankid = bank.objid 
  and nc.reftype = 'CHECK' 
; 

update cashreceiptpayment_noncash nc, checkpayment p 
set nc.refid = p.objid, nc.checkid = p.objid 
where nc.objid = p.objid and nc.refid is null 
; 


insert into checkpayment_deadchecks (
  objid, refno, refdate, amount, amtused, 
  collector_objid, collectorid, bankid, bank_name, 
  receivedfrom, state, split, `external`   
) 
select 
  p.objid, p.refno, p.refdate, p.amount, p.amtused, 
  p.collector_objid, p.collector_objid, p.bankid, p.bank_name, 
  p.receivedfrom, p.state, p.split, p.`external` 
from cashreceipt_void v 
  inner join cashreceipt c on c.objid = v.receiptid 
  inner join cashreceiptpayment_noncash nc on nc.receiptid = c.objid 
  inner join checkpayment p on p.objid = nc.objid 
where nc.reftype = 'CHECK'
;


delete from checkpayment where objid in ( 
  select objid from checkpayment_deadchecks 
);


drop table if exists ztmp_depositedchecks
;
create table ztmp_depositedchecks  
select 
  nc.receiptid, nc.refid as checkid, c.remittanceid, r.collectionvoucherid, cv.depositvoucherid 
from cashreceipt c 
  inner join cashreceiptpayment_noncash nc on (nc.receiptid = c.objid and nc.reftype='CHECK')
  inner join remittance r on r.objid = c.remittanceid 
  inner join collectionvoucher cv on cv.objid = r.collectionvoucherid 
  inner join depositvoucher dv on dv.objid = cv.depositvoucherid 
  left join cashreceipt_void v on v.receiptid = c.objid 
where v.objid is null 
;

update checkpayment cp, ztmp_depositedchecks z 
set cp.depositvoucherid = z.depositvoucherid 
where cp.objid = z.checkid  
;


insert into depositslip (
  objid, state, depositvoucherfundid, depositdate, deposittype, checktype, 
  dtcreated, createdby_objid, createdby_name, 
  bankacctid, amount, totalcash, totalcheck, cashbreakdown, 
  validation_refno, validation_refdate 
) 
select 
  concat(ze.objid,'|CASH') as objid, ze.state, concat(dv.objid,'|',ba.fund_objid) as depositvoucherfundid, 
  dv.controldate as depositdate, 'CASH' as deposittype, null as checktype, 
  dv.dtcreated, dv.createdby_objid, dv.createdby_name, 
  ze.bankaccount_objid as bankacctid, ze.totalcash as amount, ze.totalcash, 0.0 as totalcheck, ze.cashbreakdown, 
  ze.validationno as validation_refno, ze.validationdate as validation_refdate 
from depositvoucher dv 
  inner join z20181120_bankdeposit_entry ze on ze.parentid = dv.objid 
  inner join bankaccount ba on ba.objid = ze.bankaccount_objid 
where ze.amount > 0 
  and ze.totalcash > 0 
;


insert into depositslip (
  objid, state, depositvoucherfundid, depositdate, deposittype, checktype, 
  dtcreated, createdby_objid, createdby_name, 
  bankacctid, amount, totalcash, totalcheck, cashbreakdown, 
  validation_refno, validation_refdate 
) 
select 
  concat(ze.objid,'|CHECK') as objid, ze.state, 
  concat(dv.objid,'|',ba.fund_objid) as depositvoucherfundid, 
  dv.controldate as depositdate, 'CHECK' as deposittype, bank.deposittype as checktype, 
  dv.dtcreated, dv.createdby_objid, dv.createdby_name, 
  ze.bankaccount_objid as bankacctid, ze.totalnoncash as amount, 0.0 as totalcash, 
  ze.totalnoncash as totalcheck, '[]' as cashbreakdown, 
  ze.validationno as validation_refno, ze.validationdate as validation_refdate 
from depositvoucher dv 
  inner join z20181120_bankdeposit_entry ze on ze.parentid = dv.objid 
  inner join bankaccount ba on ba.objid = ze.bankaccount_objid 
  inner join bank on bank.objid = ba.bank_objid 
where ze.amount > 0 
  and ze.totalnoncash > 0 
;

update 
  checkpayment aa, ( 
    select 
      zec.objid as checkpaymentid, 
      concat(ze.objid,'|CHECK') as depositslipid 
    from z20181120_bankdeposit_entry_check zec, z20181120_bankdeposit_entry ze 
    where ze.objid = zec.parentid
  )bb 
set aa.depositslipid = bb.depositslipid  
where aa.objid = bb.checkpaymentid
;

update depositslip set state='APPROVED' where validation_refno is null 
;
update depositslip set state='VALIDATED' where validation_refno is not null 
;

alter table collectiontype add queuesection varchar(50) NULL
;

-- alter table remittance
--  modify txnmode varchar(50) null
-- ;

alter table eftpayment 
  modify fundid varchar(100)
; 


-- ## patch-08

alter table af_control add constraint fk_af_control_afid 
  foreign key (afid) references af (objid) 
;

alter table collectiontype add constraint fk_collectiontype_fund_objid 
  foreign key (fund_objid) references fund (objid)
; 

alter table collectiontype_account 
  modify collectiontypeid varchar(50) character set utf8 not null 
;
alter table collectiontype_account add constraint fk_collectiontype_account_parentid 
  foreign key (collectiontypeid) references collectiontype (objid) 
; 

alter table collectiontype_account 
  modify account_objid varchar(50) character set utf8 not null 
;
alter table collectiontype_account add constraint fk_collectiontype_account_account_objid 
  foreign key (account_objid) references itemaccount (objid) 
; 

create index ix_parentid on entity_address (parentid)
;
create index ix_address_objid on entity (address_objid)
;
update entity e, entity_address a set a.parentid = e.objid where e.address_objid = a.objid 
;
delete from entity_address where parentid not in (select objid from entity where objid = entity_address.parentid) 
;
alter table entity_address modify parentid varchar(50) character set utf8 not null 
;
alter table entity_address add constraint fk_entity_address_parentid 
  foreign key (parentid) references entity (objid) 
; 

create index ix_entityid on entity_fingerprint (entityid)
;
alter table entity_fingerprint add constraint fk_entity_fingerprint_entityid 
  foreign key (entityid) references entity (objid) 
; 

create table z20181120_entityindividual_no_entity 
select e.* from entityindividual e 
where e.objid not in (select objid from entity where objid = e.objid) 
;
create index ix_objid on z20181120_entityindividual_no_entity (objid)
;
delete from entityindividual where objid in (select objid from z20181120_entityindividual_no_entity where objid = entityindividual.objid) 
; 
alter table entityindividual add constraint fk_entityindividual_objid 
  foreign key (objid) references entity (objid) 
; 

create table z20181120_entityjuridical_no_entity 
select e.* from entityjuridical e 
where e.objid not in (select objid from entity where objid = e.objid) 
;
create index ix_objid on z20181120_entityjuridical_no_entity (objid)
;
delete from entityjuridical where objid in (select objid from z20181120_entityjuridical_no_entity where objid = entityjuridical.objid) 
; 
alter table entityjuridical add constraint fk_entityjuridical_objid 
  foreign key (objid) references entity (objid) 
; 

alter table fund add constraint fk_fund_groupid 
  foreign key (groupid) references fundgroup (objid)
;


alter table sys_report add CONSTRAINT fk_sys_report_datasetid 
  FOREIGN KEY (datasetid) REFERENCES sys_dataset (objid)
; 



-- ## patch-09

drop view if exists sys_user_role
;
create view sys_user_role AS 
select 
  u.objid AS objid, 
  u.lastname AS lastname, 
  u.firstname AS firstname, 
  u.middlename AS middlename, 
  u.username AS username, 
  concat(u.lastname,', ',u.firstname,(case when isnull(u.middlename) then '' else concat(' ',u.middlename) end)) AS name, 
  ug.role AS role, 
  ug.domain AS domain, 
  ugm.org_objid AS orgid, 
  u.txncode AS txncode, 
  u.jobtitle AS jobtitle, 
  ugm.objid AS usergroupmemberid, 
  ugm.usergroup_objid AS usergroup_objid  
from sys_usergroup_member ugm 
  join sys_usergroup ug on ug.objid = ugm.usergroup_objid 
  join sys_user u on u.objid = ugm.user_objid 
; 

drop view if exists vw_af_control_detail 
; 
create view vw_af_control_detail AS 
select 
  afd.objid AS objid, 
  afd.state AS state, 
  afd.controlid AS controlid, 
  afd.indexno AS indexno, 
  afd.refid AS refid, 
  afd.aftxnitemid AS aftxnitemid, 
  afd.refno AS refno, 
  afd.reftype AS reftype, 
  afd.refdate AS refdate, 
  afd.txndate AS txndate, 
  afd.txntype AS txntype, 
  afd.receivedstartseries AS receivedstartseries, 
  afd.receivedendseries AS receivedendseries, 
  afd.beginstartseries AS beginstartseries, 
  afd.beginendseries AS beginendseries, 
  afd.issuedstartseries AS issuedstartseries, 
  afd.issuedendseries AS issuedendseries, 
  afd.endingstartseries AS endingstartseries, 
  afd.endingendseries AS endingendseries, 
  afd.qtyreceived AS qtyreceived, 
  afd.qtybegin AS qtybegin, 
  afd.qtyissued AS qtyissued, 
  afd.qtyending AS qtyending, 
  afd.qtycancelled AS qtycancelled, 
  afd.remarks AS remarks, 
  afd.issuedto_objid AS issuedto_objid, 
  afd.issuedto_name AS issuedto_name, 
  afd.respcenter_objid AS respcenter_objid, 
  afd.respcenter_name AS respcenter_name, 
  afd.prevdetailid AS prevdetailid, 
  afd.aftxnid AS aftxnid, 
  afc.afid AS afid, 
  afc.unit AS unit, 
  af.formtype AS formtype, 
  af.denomination AS denomination, 
  af.serieslength AS serieslength, 
  afu.qty AS qty, 
  afu.saleprice AS saleprice, 
  afc.startseries AS startseries, 
  afc.endseries AS endseries, 
  afc.currentseries AS currentseries, 
  afc.stubno AS stubno, 
  afc.prefix AS prefix, 
  afc.suffix AS suffix, 
  afc.cost AS cost, 
  afc.batchno AS batchno, 
  afc.state AS controlstate, 
  afd.qtyending AS qtybalance  
from af_control_detail afd 
  join af_control afc on afc.objid = afd.controlid 
  join af on af.objid = afc.afid 
  join afunit afu on (afu.itemid = af.objid and afu.unit = afc.unit) 
;

drop view if exists vw_af_inventory_summary
;
create view vw_af_inventory_summary AS 
select 
  af.objid AS objid, 
  af.title AS title, 
  u.unit AS unit, 
  (select count(0) from af_control where afid = af.objid and state = 'OPEN') AS countopen,
  (select count(0) from af_control where afid = af.objid and state = 'ISSUED') AS countissued,
  (select count(0) from af_control where afid = af.objid and state = 'CLOSED') AS countclosed,
  (select count(0) from af_control where afid = af.objid and state = 'SOLD') AS countsold,
  (select count(0) from af_control where afid = af.objid and state = 'PROCESSING') AS countprocessing 
from af 
  join afunit u on af.objid = u.itemid 
;

drop view if exists vw_afunit
;
create view vw_afunit AS 
select 
  u.objid AS objid, 
  af.title AS title, 
  af.usetype AS usetype, 
  af.serieslength AS serieslength, 
  af.system AS `system`, 
  af.denomination AS denomination, 
  af.formtype AS formtype, 
  u.itemid AS itemid, 
  u.unit AS unit, 
  u.qty AS qty, 
  u.saleprice AS saleprice, 
  u.interval AS `interval`, 
  u.cashreceiptprintout AS cashreceiptprintout, 
  u.cashreceiptdetailprintout AS cashreceiptdetailprintout  
from afunit u 
  join af on af.objid = u.itemid 
; 


drop view if exists vw_cashreceipt_itemaccount
;
create view vw_cashreceipt_itemaccount AS 
select 
  objid AS objid, 
  state AS state, 
  code AS code, 
  title AS title, 
  description AS description, 
  type AS type, 
  fund_objid AS fund_objid, 
  fund_code AS fund_code, 
  fund_title AS fund_title, 
  defaultvalue AS defaultvalue, 
  valuetype AS valuetype, 
  sortorder AS sortorder, 
  org_objid AS orgid, 
  hidefromlookup AS hidefromlookup 
from itemaccount 
where state = 'ACTIVE' 
  and type in ('REVENUE','NONREVENUE','PAYABLE') 
  and ifnull(generic, 0) = 0 
; 


drop view if exists vw_cashreceipt_itemaccount_collectiontype
;
create view vw_cashreceipt_itemaccount_collectiontype AS 
select 
  ia.objid AS objid, 
  ia.state AS state, 
  ia.code AS code, 
  ia.title AS title, 
  ia.description AS description, 
  ia.type AS type, 
  ia.fund_objid AS fund_objid, 
  ia.fund_code AS fund_code, 
  ia.fund_title AS fund_title, 
  ca.defaultvalue AS defaultvalue, 
  (case when ca.valuetype is null then 'ANY' else ca.valuetype end) AS valuetype, 
  (case when ca.sortorder is null then 0 else ca.sortorder end) AS sortorder, 
  NULL AS orgid, 
  ca.collectiontypeid AS collectiontypeid, 
  0 AS hasorg, 
  ia.hidefromlookup AS hidefromlookup   
from collectiontype ct 
  inner join collectiontype_account ca on ca.collectiontypeid = ct.objid 
  inner join itemaccount ia on ia.objid = ca.account_objid 
  left join collectiontype_org o on o.collectiontypeid = ca.objid 
where o.objid is null 
  and ia.state = 'ACTIVE' 
  and ia.type in ('REVENUE','NONREVENUE','PAYABLE') 
union all 
select 
  ia.objid AS objid, 
  ia.state AS state, 
  ia.code AS code, 
  ia.title AS title, 
  ia.description AS description, 
  ia.type AS type, 
  ia.fund_objid AS fund_objid, 
  ia.fund_code AS fund_code, 
  ia.fund_title AS fund_title, 
  ca.defaultvalue AS defaultvalue, 
  (case when ca.valuetype is null then 'ANY' else ca.valuetype end) AS valuetype, 
  (case when ca.sortorder is null then 0 else ca.sortorder end) AS sortorder, 
  o.org_objid AS orgid, 
  ca.collectiontypeid AS collectiontypeid, 
  1 AS hasorg, 
  ia.hidefromlookup AS hidefromlookup  
from collectiontype ct 
  inner join collectiontype_org o on o.collectiontypeid = ct.objid 
  inner join collectiontype_account ca on ca.collectiontypeid = ct.objid 
  inner join itemaccount ia on ia.objid = ca.account_objid 
where ia.state = 'ACTIVE' 
  and ia.type in ('REVENUE','NONREVENUE','PAYABLE') 
;


drop view if exists vw_cashreceiptpayment_noncash
;
create view vw_cashreceiptpayment_noncash AS 
select 
  nc.objid AS objid, 
  nc.receiptid AS receiptid, 
  nc.refno AS refno, 
  nc.refdate AS refdate, 
  nc.reftype AS reftype, 
  nc.amount AS amount, 
  nc.particulars AS particulars, 
  nc.account_objid AS account_objid, 
  nc.account_code AS account_code, 
  nc.account_name AS account_name, 
  nc.account_fund_objid AS account_fund_objid, 
  nc.account_fund_name AS account_fund_name, 
  nc.account_bank AS account_bank, 
  nc.fund_objid AS fund_objid, 
  nc.refid AS refid, 
  nc.checkid AS checkid, 
  nc.voidamount AS voidamount, 
  v.objid AS void_objid, 
  (case when v.objid is null then 0 else 1 end) AS voided, 
  c.receiptno AS receipt_receiptno, 
  c.receiptdate AS receipt_receiptdate, 
  c.amount AS receipt_amount, 
  c.collector_objid AS receipt_collector_objid, 
  c.collector_name AS receipt_collector_name, 
  c.remittanceid AS remittanceid, 
  rem.objid AS remittance_objid, 
  rem.controlno AS remittance_controlno, 
  rem.controldate AS remittance_controldate  
from cashreceiptpayment_noncash nc 
  inner join cashreceipt c on c.objid = nc.receiptid 
  left join cashreceipt_void v on v.receiptid = c.objid 
  left join remittance rem on rem.objid = c.remittanceid 
;


drop view if exists vw_cashreceiptpayment_noncash_liquidated
;
create view vw_cashreceiptpayment_noncash_liquidated AS 
select 
nc.objid AS objid, 
nc.receiptid AS receiptid, 
nc.refno AS refno, 
nc.refdate AS refdate, 
nc.reftype AS reftype, 
nc.amount AS amount, 
nc.particulars AS particulars, 
nc.account_objid AS account_objid, 
nc.account_code AS account_code, 
nc.account_name AS account_name, 
nc.account_fund_objid AS account_fund_objid, 
nc.account_fund_name AS account_fund_name, 
nc.account_bank AS account_bank, 
nc.fund_objid AS fund_objid, 
nc.refid AS refid, 
nc.checkid AS checkid, 
nc.voidamount AS voidamount, 
v.objid AS void_objid, 
(case when v.objid is null then 0 else 1 end) AS voided, 
c.receiptno AS receipt_receiptno, 
c.receiptdate AS receipt_receiptdate, 
c.amount AS receipt_amount, 
c.collector_objid AS receipt_collector_objid, 
c.collector_name AS receipt_collector_name, 
c.remittanceid AS remittanceid, 
r.objid AS remittance_objid, 
r.controlno AS remittance_controlno, 
r.controldate AS remittance_controldate, 
r.collectionvoucherid AS collectionvoucherid, 
cv.objid AS collectionvoucher_objid, 
cv.controlno AS collectionvoucher_controlno, 
cv.controldate AS collectionvoucher_controldate, 
cv.depositvoucherid AS depositvoucherid  
from collectionvoucher cv 
  inner join remittance r on r.collectionvoucherid = cv.objid 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptpayment_noncash nc on nc.receiptid = c.objid 
  left join cashreceipt_void v on v.receiptid = c.objid 
;


drop view if exists vw_collectiongroup
;
create view vw_collectiongroup AS 
select 
  cg.objid AS objid, 
  cg.name AS name, 
  cg.sharing AS sharing, 
  NULL AS orgid  
from collectiongroup cg 
  left join collectiongroup_org co on co.collectiongroupid = cg.objid 
where cg.state = 'ACTIVE' 
  and co.objid is null 
union 
select 
  cg.objid AS objid, 
  cg.name AS name, 
  cg.sharing AS sharing, 
  co.org_objid AS orgid  
from collectiongroup cg 
  inner join collectiongroup_org co on co.collectiongroupid = cg.objid 
where cg.state = 'ACTIVE' 
;


drop view if exists vw_collectiontype
;
create view vw_collectiontype AS 
select 
  c.objid AS objid, 
  c.state AS state, 
  c.name AS name, 
  c.title AS title, 
  c.formno AS formno, 
  c.handler AS `handler`, 
  c.allowbatch AS allowbatch, 
  c.barcodekey AS barcodekey, 
  c.allowonline AS allowonline, 
  c.allowoffline AS allowoffline, 
  c.sortorder AS sortorder, 
  o.org_objid AS orgid, 
  c.fund_objid AS fund_objid, 
  c.fund_title AS fund_title, 
  c.category AS category, 
  c.queuesection AS queuesection, 
  c.system AS `system`, 
  af.formtype AS af_formtype, 
  af.serieslength AS af_serieslength, 
  af.denomination AS af_denomination, 
  af.baseunit AS af_baseunit, 
  c.allowpaymentorder AS allowpaymentorder, 
  c.allowkiosk AS allowkiosk, 
  c.allowcreditmemo AS allowcreditmemo  
from collectiontype_org o 
  inner join collectiontype c on c.objid = o.collectiontypeid 
  inner join af on af.objid = c.formno 
where c.state = 'ACTIVE' 
union 
select 
  c.objid AS objid, 
  c.state AS state, 
  c.name AS name, 
  c.title AS title, 
  c.formno AS formno, 
  c.handler AS `handler`, 
  c.allowbatch AS allowbatch, 
  c.barcodekey AS barcodekey, 
  c.allowonline AS allowonline, 
  c.allowoffline AS allowoffline, 
  c.sortorder AS sortorder, 
  NULL AS orgid, 
  c.fund_objid AS fund_objid, 
  c.fund_title AS fund_title, 
  c.category AS category, 
  c.queuesection AS queuesection, 
  c.system AS `system`, 
  af.formtype AS af_formtype, 
  af.serieslength AS af_serieslength, 
  af.denomination AS af_denomination, 
  af.baseunit AS af_baseunit, 
  c.allowpaymentorder AS allowpaymentorder, 
  c.allowkiosk AS allowkiosk, 
  c.allowcreditmemo AS allowcreditmemo  
from collectiontype c 
  inner join af on af.objid = c.formno 
  left join collectiontype_org o on c.objid = o.collectiontypeid 
where c.state = 'ACTIVE' 
  and o.objid is null 
;


drop view if exists vw_collectiontype_account
;
create view vw_collectiontype_account AS 
select 
  ia.objid AS objid, 
  ia.code AS code, 
  ia.title AS title, 
  ia.fund_objid AS fund_objid, 
  fund.code AS fund_code, 
  fund.title AS fund_title, 
  cta.collectiontypeid AS collectiontypeid, 
  cta.tag AS tag, 
  cta.valuetype AS valuetype, 
  cta.defaultvalue AS defaultvalue  
from collectiontype_account cta 
  inner join itemaccount ia on ia.objid = cta.account_objid 
  inner join fund on fund.objid = ia.fund_objid 
;


drop view if exists vw_remittance_cashreceipt
;
create view vw_remittance_cashreceipt AS 
select 
  r.objid AS remittance_objid, 
  r.controldate AS remittance_controldate, 
  r.controlno AS remittance_controlno, 
  c.remittanceid AS remittanceid, 
  r.collectionvoucherid AS collectionvoucherid, 
  c.controlid AS controlid, 
  af.formtype AS formtype, 
  (case when (af.formtype = 'serial') then 0 else 1 end) AS formtypeindexno, 
  c.formno AS formno, 
  c.stub AS stubno, 
  c.series AS series, 
  c.receiptno AS receiptno, 
  c.receiptdate AS receiptdate, 
  c.amount AS amount, 
  c.totalnoncash AS totalnoncash,( 
    c.amount - c.totalnoncash) AS totalcash, 
  (case when v.objid is null then 0 else 1 end) AS voided, 
  (case when v.objid is null then 0 else c.amount end) AS voidamount, 
  c.paidby AS paidby, 
  c.paidbyaddress AS paidbyaddress, 
  c.payer_objid AS payer_objid, 
  c.payer_name AS payer_name, 
  c.collector_objid AS collector_objid, 
  c.collector_name AS collector_name, 
  c.collector_title AS collector_title, 
  c.objid AS receiptid, 
  c.collectiontype_objid AS collectiontype_objid, 
  c.org_objid AS org_objid 
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join af on af.objid = c.formno 
  left join cashreceipt_void v on v.receiptid = c.objid 
;


drop view if exists vw_remittance_cashreceipt_af
;
create view vw_remittance_cashreceipt_af AS 
select 
  cr.remittanceid AS remittanceid, 
  cr.collector_objid AS collector_objid, 
  cr.controlid AS controlid, 
  min(cr.receiptno) AS fromreceiptno, 
  max(cr.receiptno) AS toreceiptno, 
  min(cr.series) AS fromseries, 
  max(cr.series) AS toseries, 
  count(cr.objid) AS qty, 
  sum(cr.amount) AS amount, 
  0 AS qtyvoided, 
  0.0 AS voidamt, 
  0 AS qtycancelled, 
  0.0 AS cancelledamt, 
  af.formtype AS formtype, 
  af.serieslength AS serieslength, 
  af.denomination AS denomination, 
  cr.formno AS formno, 
  afc.stubno AS stubno, 
  afc.startseries AS startseries, 
  afc.endseries AS endseries, 
  afc.prefix AS prefix, 
  afc.suffix AS suffix  
from cashreceipt cr 
  inner join remittance rem on rem.objid = cr.remittanceid 
  inner join af_control afc on cr.controlid = afc.objid 
  inner join af on afc.afid = af.objid 
group by 
  cr.remittanceid,cr.collector_objid,cr.controlid,af.formtype,
  af.serieslength,af.denomination,cr.formno,afc.stubno,
  afc.startseries,afc.endseries,afc.prefix,afc.suffix 
union all 
select 
  cr.remittanceid AS remittanceid, 
  cr.collector_objid AS collector_objid, 
  cr.controlid AS controlid, 
  NULL AS fromreceiptno, 
  NULL AS toreceiptno, 
  NULL AS fromseries, 
  NULL AS toseries, 
  0 AS qty, 
  0.0 AS amount, 
  count(cr.objid) AS qtyvoided, 
  sum(cr.amount) AS voidamt, 
  0 AS qtycancelled, 
  0.0 AS cancelledamt, 
  af.formtype AS formtype, 
  af.serieslength AS serieslength, 
  af.denomination AS denomination, 
  cr.formno AS formno, 
  afc.stubno AS stubno, 
  afc.startseries AS startseries, 
  afc.endseries AS endseries, 
  afc.prefix AS prefix, 
  afc.suffix AS suffix  
from cashreceipt cr 
  inner join cashreceipt_void cv on cv.receiptid = cr.objid 
  inner join remittance rem on rem.objid = cr.remittanceid 
  inner join af_control afc on cr.controlid = afc.objid 
  inner join af on afc.afid = af.objid 
group by 
  cr.remittanceid,cr.collector_objid,cr.controlid,af.formtype,
  af.serieslength,af.denomination,cr.formno,afc.stubno,
  afc.startseries,afc.endseries,afc.prefix,afc.suffix 
union all 
select 
  cr.remittanceid AS remittanceid, 
  cr.collector_objid AS collector_objid, 
  cr.controlid AS controlid, 
  NULL AS fromreceiptno, 
  NULL AS toreceiptno, 
  NULL AS fromseries, 
  NULL AS toseries, 
  0 AS qty, 
  0.0 AS amount, 
  0 AS qtyvoided, 
  0.0 AS voidamt, 
  count(cr.objid) AS qtycancelled, 
  sum(cr.amount) AS cancelledamt, 
  af.formtype AS formtype, 
  af.serieslength AS serieslength, 
  af.denomination AS denomination, 
  cr.formno AS formno, 
  afc.stubno AS stubno, 
  afc.startseries AS startseries, 
  afc.endseries AS endseries, 
  afc.prefix AS prefix, 
  afc.suffix AS suffix  
from cashreceipt cr 
  inner join remittance rem on rem.objid = cr.remittanceid 
  inner join af_control afc on cr.controlid = afc.objid 
  inner join af on afc.afid = af.objid 
where cr.state = 'CANCELLED' 
group by 
  cr.remittanceid,cr.collector_objid,cr.controlid,af.formtype,
  af.serieslength,af.denomination,cr.formno,afc.stubno,
  afc.startseries,afc.endseries,afc.prefix,afc.suffix
;


drop view if exists vw_remittance_cashreceipt_afsummary
;
create view vw_remittance_cashreceipt_afsummary AS 
select 
  concat(v.remittanceid,'|',v.collector_objid,'|',v.controlid) AS objid, 
  v.remittanceid AS remittanceid, 
  v.collector_objid AS collector_objid, 
  v.controlid AS controlid, 
  min(v.fromreceiptno) AS fromreceiptno, 
  max(v.toreceiptno) AS toreceiptno, 
  min(v.fromseries) AS fromseries, 
  max(v.toseries) AS toseries, 
  sum(v.qty) AS qty, 
  sum(v.amount) AS amount, 
  sum(v.qtyvoided) AS qtyvoided, 
  sum(v.voidamt) AS voidamt, 
  sum(v.qtycancelled) AS qtycancelled, 
  sum(v.cancelledamt) AS cancelledamt, 
  v.formtype AS formtype, 
  v.serieslength AS serieslength, 
  v.denomination AS denomination, 
  v.formno AS formno, 
  v.stubno AS stubno, 
  v.startseries AS startseries, 
  v.endseries AS endseries, 
  v.prefix AS prefix, 
  v.suffix AS suffix  
from vw_remittance_cashreceipt_af v 
group by 
  v.remittanceid,v.collector_objid,v.controlid,v.formtype,
  v.serieslength,v.denomination,v.formno,v.stubno,
  v.startseries,v.endseries,v.prefix,v.suffix
;


drop view if exists vw_remittance_cashreceiptitem
;
create view vw_remittance_cashreceiptitem AS 
select 
  c.remittanceid AS remittanceid, 
  r.controldate AS remittance_controldate, 
  r.controlno AS remittance_controlno, 
  r.collectionvoucherid AS collectionvoucherid, 
  c.collectiontype_objid AS collectiontype_objid, 
  c.collectiontype_name AS collectiontype_name, 
  c.org_objid AS org_objid, 
  c.org_name AS org_name, 
  c.formtype AS formtype, 
  c.formno AS formno, 
  (case when (c.formtype = 'serial') then 0 else 1 end) AS formtypeindex, 
  cri.receiptid AS receiptid, 
  c.receiptdate AS receiptdate, 
  c.receiptno AS receiptno, 
  c.paidby AS paidby, 
  c.paidbyaddress AS paidbyaddress, 
  c.collector_objid AS collectorid, 
  c.collector_name AS collectorname, 
  c.collector_title AS collectortitle, 
  cri.item_fund_objid AS fundid, 
  cri.item_objid AS acctid, 
  cri.item_code AS acctcode, 
  cri.item_title AS acctname, 
  cri.remarks AS remarks, 
  (case when isnull(v.objid) then cri.amount else 0.0 end) AS amount, 
  (case when isnull(v.objid) then 0 else 1 end) AS voided, 
  (case when isnull(v.objid) then 0.0 else cri.amount end) AS voidamount  
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptitem cri on cri.receiptid = c.objid 
  left join cashreceipt_void v on v.receiptid = c.objid 
;


drop view if exists vw_remittance_cashreceiptpayment_noncash
; 
create view vw_remittance_cashreceiptpayment_noncash AS 
select 
  nc.objid AS objid, 
  nc.receiptid AS receiptid, 
  nc.refno AS refno, 
  nc.refdate AS refdate, 
  nc.reftype AS reftype, 
  nc.particulars AS particulars, 
  nc.refid AS refid, 
  nc.amount AS amount, 
  (case when v.objid is null then 0 else 1 end) AS voided, 
  (case when v.objid is null then 0.0 else nc.amount end) AS voidamount, 
  cp.bankid AS bankid, 
  cp.bank_name AS bank_name, 
  c.remittanceid AS remittanceid, 
  r.collectionvoucherid AS collectionvoucherid  
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptpayment_noncash nc on (nc.receiptid = c.objid and nc.reftype = 'CHECK') 
  inner join checkpayment cp on cp.objid = nc.refid 
  left join cashreceipt_void v on v.receiptid = c.objid 
union all 
select 
  nc.objid AS objid, 
  nc.receiptid AS receiptid, 
  nc.refno AS refno, 
  nc.refdate AS refdate, 
  'EFT' AS reftype, 
  nc.particulars AS particulars, 
  nc.refid AS refid, 
  nc.amount AS amount, 
  (case when v.objid is null then 0 else 1 end) AS voided, 
  (case when v.objid is null then 0.0 else nc.amount end) AS voidamount, 
  ba.bank_objid AS bankid, 
  ba.bank_name AS bank_name, 
  c.remittanceid AS remittanceid, 
  r.collectionvoucherid AS collectionvoucherid  
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceiptpayment_noncash nc on (nc.receiptid = c.objid and nc.reftype = 'EFT') 
  inner join eftpayment eft on eft.objid = nc.refid 
  inner join bankaccount ba on ba.objid = eft.bankacctid 
  left join cashreceipt_void v on v.receiptid = c.objid 
;


drop view if exists vw_remittance_cashreceiptshare
;
create view vw_remittance_cashreceiptshare AS 
select 
  c.remittanceid AS remittanceid, 
  r.controldate AS remittance_controldate, 
  r.controlno AS remittance_controlno, 
  r.collectionvoucherid AS collectionvoucherid, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  cs.receiptid AS receiptid, 
  c.receiptdate AS receiptdate, 
  c.receiptno AS receiptno, 
  c.paidby AS paidby, 
  c.paidbyaddress AS paidbyaddress, 
  c.org_objid AS org_objid, 
  c.org_name AS org_name, 
  c.collectiontype_objid AS collectiontype_objid, 
  c.collectiontype_name AS collectiontype_name, 
  c.collector_objid AS collectorid, 
  c.collector_name AS collectorname, 
  c.collector_title AS collectortitle, 
  cs.refitem_objid AS refacctid, 
  ia.fund_objid AS fundid, 
  ia.objid AS acctid, 
  ia.code AS acctcode, 
  ia.title AS acctname, 
  (case when v.objid is null then cs.amount else 0.0 end) AS amount, 
  (case when v.objid is null then 0 else 1 end) AS voided, 
  (case when v.objid is null then 0.0 else cs.amount end) AS voidamount  
from remittance r 
  inner join cashreceipt c on c.remittanceid = r.objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.payableitem_objid 
  left join cashreceipt_void v on v.receiptid = c.objid 
; 

drop view if exists vw_collectionvoucher_cashreceiptitem
;
create view vw_collectionvoucher_cashreceiptitem AS 
select 
  cv.controldate AS collectionvoucher_controldate, 
  cv.controlno AS collectionvoucher_controlno, 
  v.remittanceid AS remittanceid, 
  v.remittance_controldate AS remittance_controldate, 
  v.remittance_controlno AS remittance_controlno, 
  v.collectionvoucherid AS collectionvoucherid, 
  v.collectiontype_objid AS collectiontype_objid, 
  v.collectiontype_name AS collectiontype_name, 
  v.org_objid AS org_objid, 
  v.org_name AS org_name, 
  v.formtype AS formtype, 
  v.formno AS formno, 
  v.formtypeindex AS formtypeindex, 
  v.receiptid AS receiptid, 
  v.receiptdate AS receiptdate, 
  v.receiptno AS receiptno, 
  v.paidby AS paidby, 
  v.paidbyaddress AS paidbyaddress, 
  v.collectorid AS collectorid, 
  v.collectorname AS collectorname, 
  v.collectortitle AS collectortitle, 
  v.fundid AS fundid, 
  v.acctid AS acctid, 
  v.acctcode AS acctcode, 
  v.acctname AS acctname, 
  v.amount AS amount, 
  v.voided AS voided, 
  v.voidamount AS voidamount  
from collectionvoucher cv 
  inner join vw_remittance_cashreceiptitem v on v.collectionvoucherid = cv.objid 
;


drop view if exists vw_collectionvoucher_cashreceiptshare
;
create view vw_collectionvoucher_cashreceiptshare AS 
select 
  cv.controldate AS collectionvoucher_controldate, 
  cv.controlno AS collectionvoucher_controlno, 
  v.remittanceid AS remittanceid, 
  v.remittance_controldate AS remittance_controldate, 
  v.remittance_controlno AS remittance_controlno, 
  v.collectionvoucherid AS collectionvoucherid, 
  v.formno AS formno, 
  v.formtype AS formtype, 
  v.receiptid AS receiptid, 
  v.receiptdate AS receiptdate, 
  v.receiptno AS receiptno, 
  v.paidby AS paidby, 
  v.paidbyaddress AS paidbyaddress, 
  v.org_objid AS org_objid, 
  v.org_name AS org_name, 
  v.collectiontype_objid AS collectiontype_objid, 
  v.collectiontype_name AS collectiontype_name, 
  v.collectorid AS collectorid, 
  v.collectorname AS collectorname, 
  v.collectortitle AS collectortitle, 
  v.refacctid AS refacctid, 
  v.fundid AS fundid, 
  v.acctid AS acctid, 
  v.acctcode AS acctcode, 
  v.acctname AS acctname, 
  v.amount AS amount, 
  v.voided AS voided, 
  v.voidamount AS voidamount  
from collectionvoucher cv 
  inner join vw_remittance_cashreceiptshare v on v.collectionvoucherid = cv.objid 
; 


drop view if exists vw_deposit_fund_transfer
;
create view vw_deposit_fund_transfer AS 
select 
  dft.objid AS objid, 
  dft.amount AS amount, 
  dft.todepositvoucherfundid AS todepositvoucherfundid, 
  tof.objid AS todepositvoucherfund_fund_objid, 
  tof.code AS todepositvoucherfund_fund_code, 
  tof.title AS todepositvoucherfund_fund_title, 
  dft.fromdepositvoucherfundid AS fromdepositvoucherfundid, 
  fromf.objid AS fromdepositvoucherfund_fund_objid, 
  fromf.code AS fromdepositvoucherfund_fund_code, 
  fromf.title AS fromdepositvoucherfund_fund_title  
from deposit_fund_transfer dft 
  inner join depositvoucher_fund todv on dft.todepositvoucherfundid = todv.objid 
  inner join fund tof on todv.fundid = tof.objid 
  inner join depositvoucher_fund fromdv on dft.fromdepositvoucherfundid = fromdv.objid 
  inner join fund fromf on fromdv.fundid = fromf.objid 
; 


drop view if exists vw_entityindividual
;
create view vw_entityindividual AS 
select 
  ei.objid AS objid, 
  ei.lastname AS lastname, 
  ei.firstname AS firstname, 
  ei.middlename AS middlename, 
  ei.birthdate AS birthdate, 
  ei.birthplace AS birthplace, 
  ei.citizenship AS citizenship, 
  ei.gender AS gender, 
  ei.civilstatus AS civilstatus, 
  ei.profession AS profession, 
  ei.tin AS tin, 
  ei.sss AS sss, 
  ei.height AS height, 
  ei.weight AS weight, 
  ei.acr AS acr, 
  ei.religion AS religion, 
  ei.photo AS photo, 
  ei.thumbnail AS thumbnail, 
  ei.profileid AS profileid, 
  e.entityno AS entityno, 
  e.type AS type, 
  e.name AS name, 
  e.entityname AS entityname, 
  e.mobileno AS mobileno, 
  e.phoneno AS phoneno, 
  e.address_objid AS address_objid, 
  e.address_text AS address_text  
from entityindividual ei 
  inner join entity e on e.objid = ei.objid 
; 


drop view if exists vw_entity_relation
;
create view vw_entity_relation AS 
select 
  er.objid AS objid, 
  er.entity_objid AS ownerid, 
  ei.objid AS entityid, 
  ei.entityno AS entityno, 
  ei.name AS name, 
  ei.firstname AS firstname, 
  ei.lastname AS lastname, 
  ei.middlename AS middlename, 
  ei.birthdate AS birthdate, 
  ei.gender AS gender, 
  er.relation_objid AS relationship  
from entity_relation er 
  inner join vw_entityindividual ei on er.relateto_objid = ei.objid 
union all 
select 
  er.objid AS objid, 
  er.relateto_objid AS ownerid, 
  ei.objid AS entityid, 
  ei.entityno AS entityno, 
  ei.name AS name, 
  ei.firstname AS firstname, 
  ei.lastname AS lastname, 
  ei.middlename AS middlename, 
  ei.birthdate AS birthdate, 
  ei.gender AS gender, 
  (case 
    when (ei.gender = 'M') then et.inverse_male 
    when (ei.gender = 'F') then et.inverse_female 
    else et.inverse_any 
  end) AS relationship  
from entity_relation er 
  inner join vw_entityindividual ei on er.entity_objid = ei.objid 
  inner join entity_relation_type et on er.relation_objid = et.objid 
;


drop view if exists vw_entityindividual_lookup
;
create view vw_entityindividual_lookup AS 
select 
  e.objid AS objid, 
  e.entityno AS entityno, 
  e.name AS name, 
  e.address_text AS addresstext, 
  e.type AS type, 
  ei.lastname AS lastname, 
  ei.firstname AS firstname, 
  ei.middlename AS middlename, 
  ei.gender AS gender, 
  ei.birthdate AS birthdate, 
  e.mobileno AS mobileno, 
  e.phoneno AS phoneno  
from entity e 
  inner join entityindividual ei on ei.objid = e.objid 
;


drop view if exists vw_entityrelation_lookup
;
create view vw_entityrelation_lookup AS 
select 
  er.objid AS objid, 
  er.entity_objid AS entity_objid, 
  er.relateto_objid AS relateto_objid, 
  er.relation_objid AS relation_objid, 
  e.entityno AS entityno, 
  e.name AS name, 
  e.address_text AS addresstext, 
  e.type AS type, 
  ei.lastname AS lastname, 
  ei.firstname AS firstname, 
  ei.middlename AS middlename, 
  ei.gender AS gender, 
  ei.birthdate AS birthdate, 
  e.mobileno AS mobileno, 
  e.phoneno AS phoneno  
from entity_relation er 
  inner join entityindividual ei on ei.objid = er.relateto_objid 
  inner join entity e on e.objid = ei.objid 
;


drop view if exists vw_income_ledger
;
create view vw_income_ledger AS 
select 
  month(jev.jevdate) AS month, 
  year(jev.jevdate) AS year, 
  jev.fundid AS fundid, 
  il.itemacctid AS itemacctid, 
  il.cr AS amount  
from income_ledger il 
  inner join jev on jev.objid = il.jevid 
union 
select 
  month(jev.jevdate) AS month, 
  year(jev.jevdate) AS year, 
  jev.fundid AS fundid, 
  pl.refitemacctid AS refitemacctid, 
  (pl.cr - pl.dr) AS amount  
from payable_ledger pl 
  inner join jev on jev.objid = pl.jevid 
;


drop view if exists vw_afunit
;
create view vw_afunit AS 
select 
  u.objid AS objid, 
  af.title AS title, 
  af.usetype AS usetype, 
  af.serieslength AS serieslength, 
  af.system AS `system`, 
  af.denomination AS denomination, 
  af.formtype AS formtype, 
  u.itemid AS itemid, 
  u.unit AS unit, 
  u.qty AS qty, 
  u.saleprice AS saleprice, 
  u.`interval` AS `interval`, 
  u.cashreceiptprintout AS cashreceiptprintout, 
  u.cashreceiptdetailprintout AS cashreceiptdetailprintout  
from afunit u 
  inner join af on af.objid = u.itemid
;


DROP VIEW IF EXISTS vw_income_ledger
;
CREATE VIEW vw_income_ledger AS
SELECT 
  YEAR(jev.jevdate) AS year, MONTH(jev.jevdate) AS month, 
  jev.fundid, l.itemacctid, cr AS amount, l.jevid, l.objid  
FROM income_ledger l 
  INNER JOIN jev ON jev.objid = l.jevid
UNION ALL 
SELECT 
  YEAR(jev.jevdate) AS year, MONTH(jev.jevdate) AS month, 
  jev.fundid, l.refitemacctid as itemacctid, 
  (l.cr - l.dr) AS amount, l.jevid, l.objid  
FROM payable_ledger l  
  INNER JOIN jev ON jev.objid = l.jevid
;

drop view if exists vw_account_item_mapping 
;
create view vw_account_item_mapping as 
select 
  a.*, l.amount, l.fundid, l.year, l.month, 
  aim.itemid, ia.code as itemcode, ia.title as itemtitle 
from account_item_mapping aim 
  inner join account a on a.objid = aim.acctid 
  inner join itemaccount ia on ia.objid = aim.itemid 
  inner join vw_income_ledger l on l.itemacctid = aim.itemid 
;


drop view if exists vw_account_income_summary
; 
create view vw_account_income_summary as 
select a.*, 
  inc.amount, inc.acctid, inc.fundid, inc.collectorid, 
  inc.refdate, inc.remittancedate, inc.liquidationdate, 
  ia.type as accttype 
from account_item_mapping aim 
  inner join account a on a.objid = aim.acctid 
  inner join itemaccount ia on ia.objid = aim.itemid 
  inner join income_summary inc on inc.acctid = ia.objid 
;



drop view if exists vw_cashbook_cashreceipt
; 
CREATE VIEW vw_cashbook_cashreceipt AS select  
  c.objid AS objid, 
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno,'cashreceipt' AS reftype,
  concat(ct.name,' (',c.paidby,')') AS particulars, 
  ci.item_fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  ci.amount AS dr,0.0 AS cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  c.txndate AS sortdate, 
  c.receiptdate AS receiptdate, 
  c.objid AS receiptid 
from cashreceipt c 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid
  inner join cashreceiptitem ci on ci.receiptid = c.objid
;


drop view if exists vw_cashbook_cashreceipt_share
; 
CREATE VIEW vw_cashbook_cashreceipt_share AS 
select  
  c.objid AS objid, 
  c.txndate AS txndate,
  cast(c.receiptdate as date) AS refdate, 
  c.objid AS refid, 
  c.receiptno AS refno,'cashreceipt' AS reftype,
  concat(ct.name,' (',c.paidby,')') AS particulars, 
  ia.fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  cs.amount AS dr,0.0 AS cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  c.txndate AS sortdate, 
  c.receiptdate AS receiptdate, 
  c.objid AS receiptid, 
  cs.refitem_objid AS refitemid 
from cashreceipt c 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  inner join cashreceipt_share cs on cs.receiptid = c.objid 
  inner join itemaccount ia on ia.objid = cs.payableitem_objid 
;


drop view if exists vw_cashbook_cashreceiptvoid
; 
CREATE VIEW vw_cashbook_cashreceiptvoid AS 
select  
  v.objid AS objid, 
  v.txndate AS txndate,
  cast(v.txndate as date) AS refdate, 
  v.objid AS refid, 
  c.receiptno AS refno, 
  'cashreceipt:void' AS reftype,
  concat('VOID ',v.reason) AS particulars, 
  ci.item_fund_objid AS fundid, 
  c.collector_objid AS collectorid, 
  -ci.amount AS dr,
  (
  case 
    when r.liquidatingofficer_objid is null then 0.0 
    when v.txndate >= r.dtposted and cast(v.txndate as date) >= cast(r.controldate as date) then -ci.amount  
    else 0.0 
  end
  ) AS cr, 
  c.formno AS formno, 
  c.formtype AS formtype, 
  c.series AS series, 
  c.controlid AS controlid, 
  v.txndate AS sortdate 
from cashreceipt_void v 
  inner join cashreceipt c on c.objid = v.receiptid 
  inner join cashreceiptitem ci on ci.receiptid = c.objid 
  inner join collectiontype ct on ct.objid = c.collectiontype_objid 
  left join remittance r on r.objid = c.remittanceid 
;


drop view if exists vw_cashbook_remittance
;
CREATE VIEW vw_cashbook_remittance AS 
select  
  rem.objid AS objid, 
  rem.dtposted AS txndate, 
  rem.controldate AS refdate, 
  rem.objid AS refid, 
  rem.controlno AS refno, 
  'remittance' AS reftype, 
  'REMITTANCE' AS particulars, 
  remf.fund_objid AS fundid, 
  rem.collector_objid AS collectorid, 
  0.0 AS dr, 
  remf.amount AS cr, 
  'remittance' AS formno,
  'remittance' AS formtype,
  NULL AS series,
  NULL AS controlid, 
  rem.dtposted AS sortdate 
from remittance rem 
  inner join remittance_fund remf on remf.remittanceid = rem.objid 
;

drop view if exists vw_cashreceipt_itemaccount_collectiongroup
; 
CREATE VIEW vw_cashreceipt_itemaccount_collectiongroup AS 
select  
  ia.objid AS objid, 
  ia.state AS state, 
  ia.code AS code, 
  ia.title AS title, 
  ia.description AS description, 
  ia.type AS type, 
  ia.fund_objid AS fund_objid, 
  ia.fund_code AS fund_code, 
  ia.fund_title AS fund_title,
  (case when ca.defaultvalue = 0 then ia.defaultvalue else ca.defaultvalue end) AS defaultvalue,
  (case when ca.defaultvalue = 0 then ia.valuetype else ca.valuetype end) AS valuetype, 
  ca.sortorder AS sortorder, 
  ia.org_objid AS orgid, 
  ca.collectiongroupid AS collectiongroupid, 
  ia.generic AS generic 
from collectiongroup_account ca 
  inner join itemaccount ia on ia.objid = ca.account_objid 
;



-- ## patch-10

delete from income_summary;



-- ## patch-11

update itemaccount set state = 'INACTIVE' where state = 'DRAFT'
;


create table business_closure (
  objid varchar(50) not null, 
  businessid varchar(50) not null, 
  dtcreated datetime not null, 
  createdby_objid varchar(50) not null, 
  createdby_name varchar(150) not null, 
  dtceased date not null, 
  dtissued datetime not null, 
  remarks text null, 
  constraint pk_business_closure primary key (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index ix_businessid on business_closure (businessid) 
; 
create index ix_dtcreated on business_closure (dtcreated) 
; 
create index ix_createdby_objid on business_closure (createdby_objid) 
; 
create index ix_createdby_name on business_closure (createdby_name) 
; 
create index ix_dtceased on business_closure (dtceased) 
; 
create index ix_dtissued on business_closure (dtissued) 
; 

alter table business_closure add constraint fk_business_closure_businessid 
  foreign key (businessid) references business (objid) 
;


CREATE TABLE `report_bpdelinquency` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(25) NULL,
  `dtfiled` datetime NULL,
  `userid` varchar(50) NULL,
  `username` varchar(160) NULL,
  `totalcount` int(255) NULL,
  `processedcount` int(255) NULL,
  `billdate` date NULL,
  `duedate` date NULL,
  `lockid` varchar(50) NULL,
  constraint pk_report_bpdelinquency PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 
;
create index `ix_dtfiled` on report_bpdelinquency (`dtfiled`) 
;
create index `ix_state` on report_bpdelinquency (`state`) 
;
create index `ix_userid` on report_bpdelinquency (`userid`) 
;
create index `ix_duedate` on report_bpdelinquency (`duedate`) 
;
create index `ix_billdate` on report_bpdelinquency (`billdate`) 
;


CREATE TABLE `report_bpdelinquency_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NULL,
  `applicationid` varchar(50) NULL,
  `amount` decimal(16,2) NULL,
  `amtpaid` decimal(16,2) NULL,
  `surcharge` decimal(16,2) NULL,
  `interest` decimal(16,2) NULL,
  `balance` decimal(16,2) NULL,
  `total` decimal(16,2) NULL,
  constraint pk_report_bpdelinquency_item PRIMARY KEY (`objid`) 
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_parentid` on report_bpdelinquency_item (`parentid`) 
;
create index `ix_applicationid` on report_bpdelinquency_item (`applicationid`) 
;


CREATE TABLE `business_active_lob_history` (
  `objid` varchar(50) NOT NULL,
  `businessid` varchar(50) DEFAULT NULL,
  `activeyear` int(11) DEFAULT NULL,
  `lobid` varchar(50) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  constraint pk_business_active_lob_history PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create index `ix_businessid` on business_active_lob_history (`businessid`)
; 
create index `ix_activeyear` on business_active_lob_history (`activeyear`)
; 
create index `ix_lobid` on business_active_lob_history (`lobid`) 
; 
alter table business_active_lob_history 
  add CONSTRAINT `fk_business_active_lob_history_businessid` 
  FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`) 
;
alter table business_active_lob_history 
  add CONSTRAINT `fk_business_active_lob_history_lobid` 
  FOREIGN KEY (`lobid`) REFERENCES `lob` (`objid`) 
;



CREATE TABLE `business_active_lob_history_forprocess` (
  `businessid` varchar(50) NOT NULL,
  constraint pk_business_active_lob_history_forprocess PRIMARY KEY (`businessid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;



drop view if exists vw_business_application_lob_retire
;
create view vw_business_application_lob_retire AS 
select 
a.business_objid AS businessid, 
a.objid AS applicationid, 
a.appno AS appno, 
a.appyear AS appyear, 
a.dtfiled AS dtfiled, 
a.txndate AS txndate, 
a.tradename AS tradename, 
b.bin AS bin, 
alob.assessmenttype AS assessmenttype, 
alob.lobid AS lobid, 
alob.name AS lobname, 
a.objid AS refid, 
a.appno AS refno  
from business_application a 
  inner join business_application_lob alob on alob.applicationid = a.objid 
  inner join business b on b.objid = a.business_objid 
where alob.assessmenttype = 'RETIRE' 
  and a.state = 'COMPLETED' 
  and a.parentapplicationid is null 
union all 
select 
pa.business_objid AS businessid, 
pa.objid AS applicationid, 
pa.appno AS appno, 
pa.appyear AS appyear, 
pa.dtfiled AS dtfiled, 
pa.txndate AS txndate, 
pa.tradename AS tradename, 
b.bin AS bin, 
alob.assessmenttype AS assessmenttype, 
alob.lobid AS lobid, 
alob.name AS lobname, 
a.objid AS refid, 
a.appno AS refno  
from business_application a 
  inner join business_application pa on pa.objid = a.parentapplicationid 
  inner join business_application_lob alob on alob.applicationid = a.objid 
  inner join business b on b.objid = pa.business_objid 
where alob.assessmenttype = 'RETIRE' 
  and a.state = 'COMPLETED'
;



-- ## patch-12

create index `ix_assignee_objid` on af_control (`assignee_objid`); 
create index `ix_fund_objid` on af_control (`fund_objid`); 
create index `ix_owner_objid` on af_control (`owner_objid`); 
create index `ix_owner_name` on af_control (`owner_name`); 
create index `ix_afid` on af_control (`afid`); 

create index `ix_capturedby_objid` on batchcapture_collection (`capturedby_objid`); 
create index `ix_collectiontype_objid` on batchcapture_collection (`collectiontype_objid`); 
create index `ix_controlid` on batchcapture_collection (`controlid`); 
create index `ix_defaultreceiptdate` on batchcapture_collection (`defaultreceiptdate`); 
create index `ix_formno` on batchcapture_collection (`formno`); 
create index `ix_org_objid` on batchcapture_collection (`org_objid`); 
create index `ix_postedby_objid` on batchcapture_collection (`postedby_objid`); 
create index `ix_state` on batchcapture_collection (`state`); 

create index `ix_currentpermitid` on business (`currentpermitid`); 
create index `ix_owner_address_objid` on business (`owner_address_objid`); 
create index `ix_owner_name` on business (`owner_name`); 
create index `ix_owner_objid` on business (`owner_objid`); 
create index `ix_tradename` on business (`tradename`); 
create index `ix_yearstarted` on business (`yearstarted`); 

create index `ix_attribute_name` on business_active_info (`attribute_name`); 
create index `ix_attribute_objid` on business_active_info (`attribute_objid`); 
create index `ix_lob_name` on business_active_info (`lob_name`); 
create index `ix_lob_objid` on business_active_info (`lob_objid`); 


update business_active_info set lob_objid='LOB-54967967:148a543fb37:-5d24' where lob_objid='LOB-3337a8c7:14dd5a2daa3:-7fca';
update business_application_info set lob_objid='LOB-54967967:148a543fb37:-5d24' where lob_objid='LOB-3337a8c7:14dd5a2daa3:-7fca';
update business_active_lob set lobid='LOB-54967967:148a543fb37:-5d24' where lobid='LOB-3337a8c7:14dd5a2daa3:-7fca';
update business_application_lob set lobid='LOB-54967967:148a543fb37:-5d24' where lobid='LOB-3337a8c7:14dd5a2daa3:-7fca';
update business_receivable set lob_objid='LOB-54967967:148a543fb37:-5d24' where lob_objid='LOB-3337a8c7:14dd5a2daa3:-7fca';
update business_permit_lob set lobid='LOB-54967967:148a543fb37:-5d24' where lobid='LOB-3337a8c7:14dd5a2daa3:-7fca';

alter table business_active_info add CONSTRAINT `fk_business_active_info_lob_objid` 
  FOREIGN KEY (`lob_objid`) REFERENCES `lob` (`objid`)
; 

create index `ix_lobid` on business_active_lob (`lobid`); 
create index `ix_name` on business_active_lob (`name`); 

alter table business_active_lob add CONSTRAINT `fk_business_active_lob_lobid` 
  FOREIGN KEY (`lobid`) REFERENCES `lob` (`objid`)
; 

create index `ix_barangay_objid` on business_address (`barangay_objid`); 
create index `ix_businessid` on business_address (`businessid`); 
create index `ix_lessor_address_objid` on business_address (`lessor_address_objid`); 
create index `ix_lessor_objid` on business_address (`lessor_objid`); 

create index `ix_approver_objid` on business_application (`approver_objid`); 
create index `ix_appyear` on business_application (`appyear`); 
create index `ix_assessor_objid` on business_application (`assessor_objid`); 
create index `ix_businessaddress` on business_application (`businessaddress`); 
create index `ix_createdby_objid` on business_application (`createdby_objid`); 
create index `ix_dtfiled` on business_application (`dtfiled`); 
create index `ix_dtreleased` on business_application (`dtreleased`); 
create index `ix_nextbilldate` on business_application (`nextbilldate`); 
create index `ix_owneraddress` on business_application (`owneraddress`); 
create index `ix_ownername` on business_application (`ownername`); 
create index `ix_permit_objid` on business_application (`permit_objid`); 
create index `ix_state` on business_application (`state`); 
create index `ix_tradename` on business_application (`tradename`); 
create index `ix_txndate` on business_application (`txndate`); 

create index `ix_activeyear` on business_application_info (`activeyear`); 
create index `ix_attribute_objid` on business_application_info (`attribute_objid`); 
create index `ix_lob_objid` on business_application_info (`lob_objid`); 

update business_application_info set lob_objid='LOB-33c63bd2:14718cc3abd:-7fb8' where lob_objid='LOB-33c63bd2:14718cc3abd:-7fb8'; 
update business_active_info set lob_objid='LOB-33c63bd2:14718cc3abd:-7fb8' where lob_objid='LOB-33c63bd2:14718cc3abd:-7fb8'; 
update business_receivable set lob_objid='LOB-33c63bd2:14718cc3abd:-7fb8' where lob_objid='LOB-33c63bd2:14718cc3abd:-7fb8'; 
update business_application_lob set lobid='LOB-33c63bd2:14718cc3abd:-7fb8' where lobid='LOB-33c63bd2:14718cc3abd:-7fb8'; 
update business_active_lob set lobid='LOB-33c63bd2:14718cc3abd:-7fb8' where lobid='LOB-33c63bd2:14718cc3abd:-7fb8'; 

update business_application_info set lob_objid='LOB-33c63bd2:14718cc3abd:-7fb8' where lob_name='SARI-SARI STORE'; 
update business_active_info set lob_objid='LOB-33c63bd2:14718cc3abd:-7fb8' where lob_name='SARI-SARI STORE'; 
update business_receivable set lob_objid='LOB-33c63bd2:14718cc3abd:-7fb8' where lob_name='SARI-SARI STORE'; 
update business_application_lob set lobid='LOB-33c63bd2:14718cc3abd:-7fb8' where name='SARI-SARI STORE'; 
update business_active_lob set lobid='LOB-33c63bd2:14718cc3abd:-7fb8' where name='SARI-SARI STORE'; 

alter table business_application_info add CONSTRAINT `fk_business_info_business_lob_objid` 
  FOREIGN KEY (`lob_objid`) REFERENCES `lob` (`objid`)
; 

create index `ix_activeyear` on business_application_lob (`activeyear`); 
create index `ix_name` on business_application_lob (`name`); 
alter table business_application_lob add CONSTRAINT `fk_business_application_lob_lobid` 
  FOREIGN KEY (`lobid`) REFERENCES `lob` (`objid`)
; 

create index `ix_actor_objid` on business_application_task (`actor_objid`); 
create index `ix_assignee_objid` on business_application_task (`assignee_objid`); 
create index `ix_enddate` on business_application_task (`enddate`); 
create index `ix_parentprocessid` on business_application_task (`parentprocessid`); 
create index `ix_startdate` on business_application_task (`startdate`); 

create index `ix_actor_objid` on business_application_workitem (`actor_objid`); 
create index `ix_assignee_objid` on business_application_workitem (`assignee_objid`); 
create index `ix_enddate` on business_application_workitem (`enddate`); 
create index `ix_refid` on business_application_workitem (`refid`); 
create index `ix_startdate` on business_application_workitem (`startdate`); 
create index `ix_workitemid` on business_application_workitem (`workitemid`); 

create index `ix_barangay_objid` on business_lessor (`barangay_objid`); 
create index `ix_bldgname` on business_lessor (`bldgname`); 
create index `ix_bldgno` on business_lessor (`bldgno`); 
create index `ix_lessor_address_objid` on business_lessor (`lessor_address_objid`); 
create index `ix_lessor_objid` on business_lessor (`lessor_objid`); 

create index `ix_appyear` on business_payment (`appyear`); 
create index `ix_refdate` on business_payment (`refdate`); 
create index `ix_refno` on business_payment (`refno`); 
alter table business_payment 
  modify applicationid varchar(50) character set utf8 not null
;
alter table business_payment 
  modify businessid varchar(50) character set utf8 not null
;

create table ztmp_duplicate_business_payment 
select p.objid from business_payment p 
  left join business_application a on a.objid = p.applicationid 
where a.objid is null 
; 
delete from business_payment_item where parentid in ( 
  select objid from ztmp_duplicate_business_payment
);
delete from business_payment where objid in ( 
  select objid from ztmp_duplicate_business_payment
);
drop table if exists ztmp_duplicate_business_payment
; 

alter table business_payment add CONSTRAINT `fk_business_payment_application` 
  FOREIGN KEY (`applicationid`) REFERENCES `business_application` (`objid`) 
; 
alter table business_payment add CONSTRAINT `fk_business_payment_business` 
  FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`) 
; 


create index `ix_account_objid` on business_payment_item (`account_objid`); 
create index `ix_lob_objid` on business_payment_item (`lob_objid`); 

create table ztmp_invalid_business_payment_item 
select b.objid 
from business_payment_item b 
  left join business_payment p on p.objid = b.parentid 
where p.objid is null 
;
delete from business_payment_item where objid in ( 
  select objid from ztmp_invalid_business_payment_item 
);
drop table if exists ztmp_invalid_business_payment_item
;

alter table business_payment_item add CONSTRAINT `fk_business_payment_item_parent` 
  FOREIGN KEY (`parentid`) REFERENCES `business_payment` (`objid`)
;
alter table business_payment_item 
  change `PARTIAL` `partial` int null 
;

drop index uix_applicationid on business_permit 
;
create index `ix_activeyear` on business_permit (`activeyear`); 
create index `ix_applicationid` on business_permit (`applicationid`); 
create index `ix_businessid` on business_permit (`businessid`); 
create index `ix_dtissued` on business_permit (`dtissued`); 
create index `ix_expirydate` on business_permit (`expirydate`); 
create index `ix_issuedby_objid` on business_permit (`issuedby_objid`); 
create index `ix_plateno` on business_permit (`plateno`); 
alter table business_permit add CONSTRAINT `fk_business_permit_application` 
  FOREIGN KEY (`applicationid`) REFERENCES `business_application` (`objid`) 
; 
alter table business_permit add CONSTRAINT `fk_business_permit_business` 
  FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`) 
; 


create index `ix_account_objid` on business_receivable (`account_objid`); 
alter table business_receivable modify applicationid varchar(50) character set utf8 not null 
; 
alter table business_receivable modify businessid varchar(50) character set utf8 not null 
; 

create table ztmp_invalid_business_receivable
select r.objid 
from business_receivable r 
  left join business_application a on a.objid = r.applicationid 
where a.objid is null 
;
delete from business_receivable where objid in ( 
  select objid from ztmp_invalid_business_receivable
);
drop table if exists ztmp_invalid_business_receivable
;

alter table business_receivable add CONSTRAINT `fk_business_receivable_application` 
  FOREIGN KEY (`applicationid`) REFERENCES `business_application` (`objid`)
; 

alter table business_receivable add CONSTRAINT `fk_business_receivable_business` 
  FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`)
; 

create index `ix_account_objid` on business_recurringfee (`account_objid`); 

alter table business_redflag 
  modify businessid varchar(50) character set utf8 not null
; 
alter table business_redflag add CONSTRAINT `fk_business_redflag_business` 
  FOREIGN KEY (`businessid`) REFERENCES `business` (`objid`)
;


create index `ix_completedby_objid` on business_requirement (`completedby_objid`); 
create index `ix_dtcompleted` on business_requirement (`dtcompleted`); 
create index `ix_dtissued` on business_requirement (`dtissued`); 
create index `ix_refid` on business_requirement (`refid`); 
create index `ix_refno` on business_requirement (`refno`); 

create table ztmp_invalid_business_requirement
select r.objid 
from business_requirement r 
  left join business_application a on a.objid = r.applicationid 
where a.objid is null 
;
delete from business_requirement where objid in ( 
  select objid from ztmp_invalid_business_requirement
);
drop table if exists ztmp_invalid_business_requirement
;

alter table business_requirement add CONSTRAINT `fk_business_requirement_application` 
  FOREIGN KEY (`applicationid`) REFERENCES `business_application` (`objid`)
;

create UNIQUE index `uix_code` on businessrequirementtype (`code`) ;

update businessrequirementtype set title='POLICE_CLEARANCE' where objid='POL'; 
create UNIQUE index `uix_title` on businessrequirementtype (`title`) ;

create UNIQUE index `uix_name` on businessvariable (`name`); 

alter table cashreceipt add ukey varchar(50) not null default '';
create index ix_ukey on cashreceipt (ukey); 
update cashreceipt set ukey=MD5(objid);
create UNIQUE index `uix_receiptno` on cashreceipt (`receiptno`,`ukey`); 

create index `ix_formno` on cashreceipt (`formno`); 
create index `ix_org_objid` on cashreceipt (`org_objid`); 
create index `ix_payer_objid` on cashreceipt (`payer_objid`); 
create index `ix_receiptdate` on cashreceipt (`receiptdate`); 
create index `ix_user_objid` on cashreceipt (`user_objid`); 

alter table cashreceipt add CONSTRAINT `fk_cashreceipt_collector_objid` 
  FOREIGN KEY (`collector_objid`) REFERENCES `sys_user` (`objid`)
; 
alter table cashreceipt 
  modify controlid varchar(50) character set utf8 not null 
; 

set foreign_key_checks=0;
alter table cashreceipt add CONSTRAINT `fk_cashreceipt_controlid` 
  FOREIGN KEY (`controlid`) REFERENCES `af_control` (`objid`)
; 
set foreign_key_checks=1;

create index `ix_controlid` on cashreceipt_cancelseries (`controlid`); 
create index `ix_postedby_objid` on cashreceipt_cancelseries (`postedby_objid`); 
create index `ix_txndate` on cashreceipt_cancelseries (`txndate`); 


alter table cashreceipt_rpt drop foreign key cashreceipt_rpt_ibfk_1; 

create index `ix_acctid` on cashreceipt_slaughter (`acctid`); 
create index `ix_acctno` on cashreceipt_slaughter (`acctno`); 

create index `ix_postedby_objid` on cashreceipt_void (`postedby_objid`); 
create index `ix_txndate` on cashreceipt_void (`txndate`); 

create index `ix_account_fund_objid` on cashreceiptpayment_noncash (`account_fund_objid`); 
create index `ix_account_objid` on cashreceiptpayment_noncash (`account_objid`); 
create index `ix_refdate` on cashreceiptpayment_noncash (`refdate`); 
create index `ix_refno` on cashreceiptpayment_noncash (`refno`); 

create index `ix_formno` on collectiontype (`formno`); 
create index `ix_handler` on collectiontype (`handler`); 

alter table collectiontype_account drop foreign key fk_collectiontype_account_parentid; 

alter table creditmemo add ( 
  `payer_name` varchar(255) NULL,
  `payer_address_objid` varchar(50) NULL,
  `payer_address_text` varchar(50) NULL
); 
create index `ix_bankaccount_objid` on creditmemo (`bankaccount_objid`); 
create index `ix_controlno` on creditmemo (`controlno`); 
create index `ix_dtissued` on creditmemo (`dtissued`); 
create index `ix_issuedby_objid` on creditmemo (`issuedby_objid`); 
create index `ix_payer_objid` on creditmemo (`payer_objid`); 
create index `ix_receiptid` on creditmemo (`receiptid`); 
create index `ix_receiptno` on creditmemo (`receiptno`); 
create index `ix_refdate` on creditmemo (`refdate`); 
create index `ix_refno` on creditmemo (`refno`); 
create index `ix_state` on creditmemo (`state`); 
create index `ix_type_objid` on creditmemo (`type_objid`); 

alter table creditmemoitem drop foreign key creditmemoitem_ibfk_1;
alter table creditmemoitem drop foreign key FK_creditmemoitem_revenueitem;
alter table creditmemoitem drop foreign key FK_creditmemo_item;
alter table creditmemoitem add constraint `fk_creditmemoitem_parentid` 
  FOREIGN KEY (`parentid`) REFERENCES `creditmemo` (`objid`)
; 
alter table creditmemoitem add constraint `fk_creditmemoitem_item_objid` 
  FOREIGN KEY (`item_objid`) REFERENCES `itemaccount` (`objid`)
; 


create index ix_account_objid on creditmemotype_account (account_objid); 

create index ix_barangay_objid on entity_address (barangay_objid);
alter table entity_address drop foreign key entity_address_ibfk_1;

create index `ix_entityid` on entityid (`entityid`); 
create index `ix_idno` on entityid (`idno`); 


alter table entityindividual modify lastname varchar(50) not null; 
alter table entityindividual modify firstname varchar(50) not null; 
alter table entityindividual modify middlename varchar(50) null; 
alter table entityindividual modify birthdate date null; 
create index ix_lastname on entityindividual (lastname); 

alter table entityjuridical drop foreign key entityjuridical_ibfk_1;

create index ix_member_name on entitymember (member_name);

create index `ix_code` on fund (`code`); 
create index `ix_title` on fund (`title`); 
create index `ix_parentid` on fund (`parentid`); 
alter table fund add constraint fk_fund_depositoryfundid 
  foreign key (depositoryfundid) references fund (objid) 
; 



create index `ix_code` on itemaccount (`code`); 
create index `ix_title` on itemaccount (`title`); 
-- create index `ix_parentid` on itemaccount (`parentid`); 
alter table itemaccount drop foreign key itemaccount_ibfk_1;



alter table lob add ukey varchar(50) not null default ''; 
create index ix_ukey on lob (ukey); 
update lob set ukey=MD5(UUID()); 
create UNIQUE index `uix_name` on lob (`name`, `ukey`); 
create index `ix_name` on lob (`name`); 
create index `ix_psic` on lob (`psic`); 



create unique index `uix_name` on lobclassification (`name`); 

create unique index `uix_name` on lobattribute (`name`);


drop table if exists paymentorder; 

CREATE TABLE `paymentorder` (
  `txnid` varchar(50) NOT NULL,
  `txndate` datetime NULL,
  `payer_objid` varchar(50) NULL,
  `payer_name` longtext,
  `paidby` longtext,
  `paidbyaddress` varchar(150) NULL,
  `particulars` longtext,
  `amount` decimal(16,2) NULL,
  `txntypeid` varchar(50) NULL,
  `expirydate` date NULL,
  `refid` varchar(50) NULL,
  `refno` varchar(50) NULL,
  `info` longtext,
  PRIMARY KEY (`txnid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


alter table remittance modify controldate date not null ;


create index `ix_dtposted` on remittance (`dtposted`); 

alter table report_bpdelinquency modify totalcount int null; 
alter table report_bpdelinquency modify processedcount int null; 

drop table if exists sms_inbox; 
drop table if exists sms_inbox_pending; 
drop table if exists sms_outbox; 
drop table if exists sms_outbox_pending; 


create index `ix_txnno` on subcollector_remittance (`txnno`); 
create index `ix_state` on subcollector_remittance (`state`); 
create index `ix_dtposted` on subcollector_remittance (`dtposted`); 
create index `ix_collector_objid` on subcollector_remittance (`collector_objid`); 
create index `ix_subcollector_objid` on subcollector_remittance (`subcollector_objid`); 


drop table if exists sys_notification; 
drop table if exists sys_notification_group; 
drop table if exists sys_notification_user; 


alter table sys_report drop foreign key sys_report_ibfk_1;

create UNIQUE index `uix_ruleset_name` on sys_rule (`ruleset`,`name`); 

create index `ix_actiondef_objid` on sys_rule_action (`actiondef_objid`); 


alter table remittance modify controldate date not null ;

update remittance_fund set cashbreakdown='[]' where cashbreakdown is null; 


update 
  remittance_fund aa, ( 
    select rf.objid, concat(r.controlno,'-',fund.code) as controlno 
    from remittance_fund rf, remittance r, fund 
    where rf.remittanceid = r.objid 
      and rf.fund_objid = fund.objid 
  )bb 
set aa.controlno = bb.controlno  
where aa.objid = bb.objid
;



-- ## patch-14

INSERT IGNORE INTO `sys_ruleset` (`name`, `title`, `packagename`, `domain`, `role`, `permission`) VALUES ('revenuesharing', 'Revenue Sharing', 'revenuesharing', 'TREASURY', 'RULE_AUTHOR', NULL);

INSERT IGNORE INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('after-compute-share', 'revenuesharing', 'After Compute Share', '1');
INSERT IGNORE INTO `sys_rulegroup` (`name`, `ruleset`, `title`, `sortorder`) VALUES ('compute-share', 'revenuesharing', 'Compute Share', '0');

INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('com.rameses.rules.common.CurrentDate', 'com.rameses.rules.common.CurrentDate', 'Current Date', 'com.rameses.rules.common.CurrentDate', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'SYSTEM', NULL);
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('enterprise.facts.DateInfo', 'enterprise.facts.DateInfo', 'Date Info', 'enterprise.facts.DateInfo', '0', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ENTERPRISE', 'enterprise.facts.VariableInfo');
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('enterprise.facts.Org', 'enterprise.facts.Org', 'Org', 'enterprise.facts.Org', '1', NULL, 'ORG', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'ENTERPRISE', NULL);
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('treasury.facts.BillItem', 'treasury.facts.BillItem', 'Bill Item', 'treasury.facts.BillItem', '1', NULL, 'BILLITEM', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', 'treasury.facts.AbstractBillItem');
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('treasury.facts.CollectionGroup', 'treasury.facts.CollectionGroup', 'Collection Group', 'treasury.facts.CollectionGroup', '0', NULL, 'CG', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', NULL);
INSERT IGNORE INTO `sys_rule_fact` (`objid`, `name`, `title`, `factclass`, `sortorder`, `handler`, `defaultvarname`, `dynamic`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `dynamicfieldname`, `builtinconstraints`, `domain`, `factsuperclass`) VALUES ('treasury.facts.RevenueShare', 'treasury.facts.RevenueShare', 'Revenue Share', 'treasury.facts.RevenueShare', '1', NULL, 'RS', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'TREASURY', NULL);

INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('com.rameses.rules.common.CurrentDate.date', 'com.rameses.rules.common.CurrentDate', 'date', 'Date', 'date', '4', 'date', NULL, NULL, NULL, NULL, NULL, NULL, 'date', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('com.rameses.rules.common.CurrentDate.day', 'com.rameses.rules.common.CurrentDate', 'day', 'Day', 'integer', '5', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('com.rameses.rules.common.CurrentDate.month', 'com.rameses.rules.common.CurrentDate', 'month', 'Month', 'integer', '3', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('com.rameses.rules.common.CurrentDate.qtr', 'com.rameses.rules.common.CurrentDate', 'qtr', 'Qtr', 'integer', '1', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('com.rameses.rules.common.CurrentDate.year', 'com.rameses.rules.common.CurrentDate', 'year', 'Year', 'integer', '2', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('enterprise.facts.DateInfo.day', 'enterprise.facts.DateInfo', 'day', 'Day', 'integer', '4', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('enterprise.facts.DateInfo.month', 'enterprise.facts.DateInfo', 'month', 'Month', 'integer', '3', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('enterprise.facts.DateInfo.name', 'enterprise.facts.DateInfo', 'name', 'Name', 'string', '5', 'lookup', 'variableinfo_date:lookup', 'name', 'name', NULL, NULL, '1', 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('enterprise.facts.DateInfo.qtr', 'enterprise.facts.DateInfo', 'qtr', 'Qtr', 'integer', '1', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('enterprise.facts.DateInfo.value', 'enterprise.facts.DateInfo', 'value', 'Date', 'date', '6', 'date', NULL, NULL, NULL, NULL, NULL, '1', 'date', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('enterprise.facts.DateInfo.year', 'enterprise.facts.DateInfo', 'year', 'Year', 'integer', '2', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('enterprise.facts.Org.orgid', 'enterprise.facts.Org', 'orgid', 'Org ID', 'string', '1', 'lookup', 'org:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.account', 'treasury.facts.BillItem', 'account', 'Account', 'string', '3', 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL, NULL, 'object', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.account.objid', 'treasury.facts.BillItem', 'account.objid', 'Account ID', 'string', '2', 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.amount', 'treasury.facts.BillItem', 'amount', 'Amount', 'decimal', '1', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.billrefid', 'treasury.facts.BillItem', 'billrefid', 'Bill Ref ID', 'string', '7', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.discount', 'treasury.facts.BillItem', 'discount', 'Discount', 'decimal', '8', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.duedate', 'treasury.facts.BillItem', 'duedate', 'Due Date', 'date', '4', 'date', NULL, NULL, NULL, NULL, NULL, NULL, 'date', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.fromdate', 'treasury.facts.BillItem', 'fromdate', 'From Date', 'date', '14', 'date', NULL, NULL, NULL, NULL, NULL, NULL, 'date', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.interest', 'treasury.facts.BillItem', 'interest', 'Interest', 'decimal', '11', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.month', 'treasury.facts.BillItem', 'month', 'Month', 'integer', '13', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.org', 'treasury.facts.BillItem', 'org', 'Org', 'string', '10', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'enterprise.facts.Org', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.parentaccount', 'treasury.facts.BillItem', 'parentaccount', 'Parent Account', 'string', '9', 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL, NULL, 'object', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.paypriority', 'treasury.facts.BillItem', 'paypriority', 'Pay Priority', 'integer', '18', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.refid', 'treasury.facts.BillItem', 'refid', 'Ref ID', 'string', '16', 'var', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.remarks', 'treasury.facts.BillItem', 'remarks', 'Remarks', 'string', '17', 'string', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.sortorder', 'treasury.facts.BillItem', 'sortorder', 'Sort Order', 'integer', '19', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.surcharge', 'treasury.facts.BillItem', 'surcharge', 'Surcharge', 'decimal', '5', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.tag', 'treasury.facts.BillItem', 'tag', 'Tag', 'string', '20', 'string', NULL, NULL, NULL, NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.todate', 'treasury.facts.BillItem', 'todate', 'To Date', 'date', '15', 'date', NULL, NULL, NULL, NULL, NULL, NULL, 'date', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.txntype', 'treasury.facts.BillItem', 'txntype', 'Txn Type', 'string', '6', 'lookup', 'billitem_txntype:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.BillItem.year', 'treasury.facts.BillItem', 'year', 'Year', 'integer', '12', 'integer', NULL, NULL, NULL, NULL, NULL, NULL, 'integer', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.CollectionGroup.objid', 'treasury.facts.CollectionGroup', 'objid', 'Name', 'string', '1', 'lookup', 'collectiongroup:lookup', 'objid', 'name', NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.RevenueShare.amount', 'treasury.facts.RevenueShare', 'amount', 'Amount', 'decimal', '3', 'decimal', NULL, NULL, NULL, NULL, NULL, NULL, 'decimal', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.RevenueShare.payableaccount', 'treasury.facts.RevenueShare', 'payableaccount', 'Payable Account', 'string', '2', 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);
INSERT IGNORE INTO `sys_rule_fact_field` (`objid`, `parentid`, `name`, `title`, `datatype`, `sortorder`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `lookupdatatype`, `multivalued`, `required`, `vardatatype`, `lovname`) VALUES ('treasury.facts.RevenueShare.refaccount', 'treasury.facts.RevenueShare', 'refaccount', 'Reference Account', 'string', '1', 'lookup', 'revenueitem:lookup', 'objid', 'title', NULL, NULL, NULL, 'string', NULL);

INSERT IGNORE INTO `sys_rule_actiondef` (`objid`, `name`, `title`, `sortorder`, `actionname`, `domain`, `actionclass`) VALUES ('treasury.actions.AddRevenueShare', 'add-share', 'Add Revenue Share', '1', 'add-share', 'TREASURY', 'treasury.actions.AddRevenueShare');

INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddRevenueShareByOrg.amount', 'treasury.actions.AddRevenueShare', 'amount', '4', 'Amount', NULL, 'expression', NULL, NULL, NULL, NULL, NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddRevenueShareByOrg.org', 'treasury.actions.AddRevenueShare', 'org', '3', 'Org', NULL, 'var', NULL, NULL, NULL, 'enterprise.facts.Org', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddRevenueShareByOrg.payableaccount', 'treasury.actions.AddRevenueShare', 'payableaccount', '2', 'Payable Account', NULL, 'lookup', 'payableaccount:lookup', 'objid', 'title', 'string', NULL);
INSERT IGNORE INTO `sys_rule_actiondef_param` (`objid`, `parentid`, `name`, `sortorder`, `title`, `datatype`, `handler`, `lookuphandler`, `lookupkey`, `lookupvalue`, `vardatatype`, `lovname`) VALUES ('treasury.actions.AddRevenueShareByOrg.refitem', 'treasury.actions.AddRevenueShare', 'refitem', '1', 'Ref Item', NULL, 'var', 'revenueitem:lookup', 'objid', 'title', 'treasury.facts.AbstractBillItem', NULL);

INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('revenuesharing', 'com.rameses.rules.common.CurrentDate');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('revenuesharing', 'enterprise.facts.DateInfo');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('revenuesharing', 'enterprise.facts.Org');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('revenuesharing', 'treasury.facts.BillItem');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('revenuesharing', 'treasury.facts.CollectionGroup');
INSERT IGNORE INTO `sys_ruleset_fact` (`ruleset`, `rulefact`) VALUES ('revenuesharing', 'treasury.facts.RevenueShare');

INSERT IGNORE INTO `sys_ruleset_actiondef` (`ruleset`, `actiondef`) VALUES ('revenuesharing', 'treasury.actions.AddRevenueShare');
