
if object_id('dbo.report_bpdelinquency_item', 'U') IS NOT NULL 
  drop table dbo.report_bpdelinquency_item; 
go 
if object_id('dbo.report_bpdelinquency', 'U') IS NOT NULL 
  drop table dbo.report_bpdelinquency; 
go 


CREATE TABLE report_bpdelinquency (
  objid varchar(50) NOT NULL,
  state varchar(25) NULL,
  dtfiled datetime NULL,
  userid varchar(50) NULL,
  username varchar(160) NULL,
  totalcount int NULL,
  processedcount int NULL,
  billdate date NULL,
  duedate date NULL,
  lockid varchar(50) NULL,
  constraint pk_report_bpdelinquency PRIMARY KEY (objid)
) 
go 
CREATE INDEX ix_state ON report_bpdelinquency (state)
go
CREATE INDEX ix_dtfiled ON report_bpdelinquency (dtfiled)
go
CREATE INDEX ix_userid ON report_bpdelinquency (userid)
go
CREATE INDEX ix_billdate ON report_bpdelinquency (billdate)
go
CREATE INDEX ix_duedate ON report_bpdelinquency (duedate)
go


CREATE TABLE report_bpdelinquency_item (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  applicationid varchar(50) NOT NULL,
  tax decimal(16,2) NOT NULL DEFAULT 0.0,
  regfee decimal(16,2) NOT NULL DEFAULT 0.0,
  othercharge decimal(16,2) NOT NULL DEFAULT 0.0,
  surcharge decimal(16,2) NOT NULL DEFAULT 0.0,
  interest decimal(16,2) NOT NULL DEFAULT 0.0,
  total decimal(16,2) NOT NULL DEFAULT 0.0,
  duedate date NULL,
  year int NOT NULL,
  qtr int NOT NULL,
  constraint pk_report_bpdelinquency_item PRIMARY KEY (objid)
) 
go
CREATE INDEX ix_parentid ON report_bpdelinquency_item (parentid);
go
CREATE INDEX ix_applicationid ON report_bpdelinquency_item (applicationid);
go
CREATE INDEX ix_year ON report_bpdelinquency_item (year);
go
CREATE INDEX ix_qtr ON report_bpdelinquency_item (qtr);
go
ALTER TABLE report_bpdelinquency_item ADD CONSTRAINT fk_report_bpdelinquency_item_parentid
  FOREIGN KEY (parentid) REFERENCES report_bpdelinquency (objid) 
go

CREATE TABLE report_bpdelinquency_app (
  objid varchar(50) NOT NULL,
  parentid varchar(50) NOT NULL,
  applicationid varchar(50) NOT NULL,
  appdate date not null,
  appyear int not null,
  lockid varchar(50) NULL,
  constraint pk_report_bpdelinquency_app PRIMARY KEY (objid)
) 
go 
create unique index uix_parentid_applicationid on report_bpdelinquency_app (parentid, applicationid)
go 
CREATE INDEX ix_parentid ON report_bpdelinquency_app (parentid);
go
CREATE INDEX ix_applicationid ON report_bpdelinquency_app (applicationid);
go
CREATE INDEX ix_appdate ON report_bpdelinquency_app (appdate);
go
CREATE INDEX ix_appyear ON report_bpdelinquency_app (appyear);
go
CREATE INDEX ix_lockid ON report_bpdelinquency_app (lockid);
go
ALTER TABLE report_bpdelinquency_app ADD CONSTRAINT fk_report_bpdelinquency_app_parentid
  FOREIGN KEY (parentid) REFERENCES report_bpdelinquency (objid) 
go 
