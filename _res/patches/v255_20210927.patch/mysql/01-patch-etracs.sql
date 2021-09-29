
DROP TABLE report_bpdelinquency_item;
DROP TABLE report_bpdelinquency;

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
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
CREATE INDEX `ix_state` ON report_bpdelinquency (`state`);
CREATE INDEX `ix_dtfiled` ON report_bpdelinquency (`dtfiled`);
CREATE INDEX `ix_userid` ON report_bpdelinquency (`userid`);
CREATE INDEX `ix_billdate` ON report_bpdelinquency (`billdate`);
CREATE INDEX `ix_duedate` ON report_bpdelinquency (`duedate`);


CREATE TABLE `report_bpdelinquency_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `applicationid` varchar(50) NOT NULL,
  `tax` decimal(16,2) NOT NULL DEFAULT '0',
  `regfee` decimal(16,2) NOT NULL DEFAULT '0',
  `othercharge` decimal(16,2) NOT NULL DEFAULT '0',
  `surcharge` decimal(16,2) NOT NULL DEFAULT '0',
  `interest` decimal(16,2) NOT NULL DEFAULT '0',
  `total` decimal(16,2) NOT NULL DEFAULT '0',
  `duedate` date NULL,
  `year` int NOT NULL,
  `qtr` int NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
CREATE INDEX `ix_parentid` ON report_bpdelinquency_item (`parentid`); 
CREATE INDEX `ix_applicationid` ON report_bpdelinquency_item (`applicationid`); 
CREATE INDEX `ix_year` ON report_bpdelinquency_item (`year`); 
CREATE INDEX `ix_qtr` ON report_bpdelinquency_item (`qtr`); 
ALTER TABLE report_bpdelinquency_item ADD CONSTRAINT fk_report_bpdelinquency_item_parentid
  FOREIGN KEY (parentid) REFERENCES report_bpdelinquency (objid) 
; 

CREATE TABLE `report_bpdelinquency_app` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `applicationid` varchar(50) NOT NULL,
  `appdate` date not null,
  `appyear` int not null,
  `lockid` varchar(50) NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;
create unique index uix_parentid_applicationid on report_bpdelinquency_app (parentid, applicationid); 
CREATE INDEX `ix_parentid` ON report_bpdelinquency_app (`parentid`); 
CREATE INDEX `ix_applicationid` ON report_bpdelinquency_app (`applicationid`); 
CREATE INDEX `ix_appdate` ON report_bpdelinquency_app (`appdate`); 
CREATE INDEX `ix_appyear` ON report_bpdelinquency_app (`appyear`); 
CREATE INDEX `ix_lockid` ON report_bpdelinquency_app (`lockid`); 
ALTER TABLE report_bpdelinquency_app ADD CONSTRAINT fk_report_bpdelinquency_app_parentid
  FOREIGN KEY (parentid) REFERENCES report_bpdelinquency (objid) 
; 
