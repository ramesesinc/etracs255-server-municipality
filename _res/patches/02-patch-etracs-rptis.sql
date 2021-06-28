
alter table bldgrpu add `occpermitno` varchar(25) NULL
; 

-- alter table cancelledfaas_task add `returnedby` varchar(100) NULL
-- ; 

-- alter table consolidation_task add `returnedby` varchar(100) NULL
-- ; 

-- alter table rptledger_compromise_item add (
--    `sh` decimal(16,2) NULL, 
--    `shpaid` decimal(16,2) NULL, 
--    `shint` decimal(16,2) NULL, 
--    `shintpaid` decimal(16,2) NULL
-- )
-- ;

-- alter table rptledger_compromise_item_credit add ( 
--    `sh` decimal(16,2) NULL, 
--    `shint` decimal(16,2) NULL 
-- )
-- ;

-- alter table rptledgeritem add ( 
--    `sh` decimal(16,2) NULL, 
--    `shdisc` decimal(16,2) NULL, 
--    `shpaid` decimal(16,2) NULL, 
--    `shint` decimal(16,2) NULL 
-- )
-- ; 

-- alter table rptledgeritem_qtrly add ( 
--    `sh` decimal(16,2) NULL, 
--    `shdisc` decimal(16,2) NULL, 
--    `shpaid` decimal(16,2) NULL, 
--    `shint` decimal(16,2) NULL 
-- )
-- ; 

alter table rpttaxcredit add ( 
   `info` text NULL, 
   `discapplied` decimal(16,2) NOT NULL 
)
;

alter table rpu add (
   `pin` varchar(50) NULL, 
   `isonline` int NULL 
)
; 

alter table structure add (
   `isprov` int NULL, 
   `xnewid` varchar(50) NULL 
)
;

-- alter table subdivision_task add `returnedby` varchar(100) NULL
-- ; 

-- 
-- CREATE TABLE `syncdata_forsync` ( 
--    `objid` varchar(50) NOT NULL, 
--    `reftype` varchar(100) NOT NULL, 
--    `refno` varchar(50) NOT NULL, 
--    `action` varchar(100) NOT NULL, 
--    `orgid` varchar(25) NOT NULL, 
--    `dtfiled` datetime NOT NULL, 
--    `createdby_objid` varchar(50) NULL, 
--    `createdby_name` varchar(255) NULL, 
--    `createdby_title` varchar(100) NULL, 
--    `info` text NULL,
--    CONSTRAINT `pk_syncdata_forsync` PRIMARY KEY (`objid`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8
-- ; 
-- 
-- CREATE INDEX `ix_createdbyid` ON `syncdata_forsync` (`createdby_objid`)
-- ;
-- CREATE INDEX `ix_dtfiled` ON `syncdata_forsync` (`dtfiled`)
-- ;
-- CREATE INDEX `ix_refno` ON `syncdata_forsync` (`refno`)
-- ;
-- CREATE INDEX `ix_reftype` ON `syncdata_forsync` (`reftype`)
-- ;


-- CREATE TABLE `syncdata_item` ( 
--    `objid` varchar(50) NOT NULL, 
--    `parentid` varchar(50) NOT NULL, 
--    `state` varchar(50) NOT NULL, 
--    `refid` varchar(50) NOT NULL, 
--    `reftype` varchar(255) NOT NULL, 
--    `refno` varchar(50) NULL, 
--    `action` varchar(100) NOT NULL, 
--    `error` text NULL, 
--    `idx` int NOT NULL, 
--    `info` text NULL, 
--    `async` int NULL, 
--    `dependedaction` varchar(100) NULL,
--    CONSTRAINT `pk_syncdata_item` PRIMARY KEY (`objid`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8
-- ; 
-- 
-- CREATE INDEX `ix_parentid` ON `syncdata_item` (`parentid`)
-- ;
-- CREATE INDEX `ix_refid` ON `syncdata_item` (`refid`)
-- ;
-- CREATE INDEX `ix_refno` ON `syncdata_item` (`refno`)
-- ;
-- CREATE INDEX `ix_state` ON `syncdata_item` (`state`)
-- ;


-- CREATE TABLE `syncdata_org` ( 
--    `orgid` varchar(50) NOT NULL, 
--    `state` varchar(50) NOT NULL, 
--    `errorcount` int NULL,
--    CONSTRAINT `pk_syncdata_org` PRIMARY KEY (`orgid`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8
-- ; 
-- 
-- CREATE INDEX `ix_state` ON `syncdata_org` (`state`)
-- ;


-- CREATE TABLE `syncdata_pending` ( 
--    `objid` varchar(50) NOT NULL, 
--    `error` text NULL, 
--    `expirydate` datetime NULL,
--    CONSTRAINT `pk_syncdata_pending` PRIMARY KEY (`objid`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8
-- ; 
-- 
-- CREATE INDEX `ix_expirydate` ON `syncdata_pending` (`expirydate`)
-- ;
