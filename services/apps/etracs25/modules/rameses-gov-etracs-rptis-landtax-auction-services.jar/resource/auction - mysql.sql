INSERT INTO sys_usergroup (objid, title, domain, userclass, orgclass, role) VALUES ('AUCTION.ADMIN', 'AUCTION ADMIN', 'AUCTION', NULL, NULL, 'ADMIN')
;
INSERT INTO sys_usergroup (objid, title, domain, userclass, orgclass, role) VALUES ('AUCTION.AUCTIONEER', 'AUCTION AUCTIONEER', 'AUCTION', NULL, NULL, 'AUCTIONEER')
;
INSERT INTO sys_usergroup (objid, title, domain, userclass, orgclass, role) VALUES ('AUCTION.REPORT', 'AUCTION REPORT', 'AUCTION', NULL, NULL, 'REPORT')
;
INSERT INTO sys_usergroup (objid, title, domain, userclass, orgclass, role) VALUES ('AUCTION.SHARED', 'AUCTION SHARED', 'AUCTION', NULL, NULL, 'SHARED')
;




CREATE TABLE propertyauction_step (
  objid varchar(50) NOT NULL,
  code varchar(10) NOT NULL,
  title varchar(255) NOT NULL,
  seqno int(11) NOT NULL,
  applicable int(255) NOT NULL,
  duration int(255) NOT NULL,
  report varchar(255) NOT NULL,
  PRIMARY KEY (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;

INSERT INTO propertyauction_step (objid, code, title, seqno, applicable, duration, report) VALUES ('FINALDEMAND', 'FD', 'Final Demand', '4', '1', '30', 'auctionnotice_final')
;
INSERT INTO propertyauction_step (objid, code, title, seqno, applicable, duration, report) VALUES ('NOD', 'NOD', 'Notice of Delinquency', '1', '1', '30', 'auctionnotice_nod')
;
INSERT INTO propertyauction_step (objid, code, title, seqno, applicable, duration, report) VALUES ('NOPAS', 'NOPAS', 'Notice of Public Auction Sale', '6', '1', '30', 'auctionnotice_nopas')
;
INSERT INTO propertyauction_step (objid, code, title, seqno, applicable, duration, report) VALUES ('TRACER1', 'TR1', 'First Tracer', '2', '1', '15', 'auctionnotice_tracer1')
;
INSERT INTO propertyauction_step (objid, code, title, seqno, applicable, duration, report) VALUES ('TRACER2', 'TR2', 'Second Tracer', '3', '1', '15', 'auctionnotice_tracer2')
;
INSERT INTO propertyauction_step (objid, code, title, seqno, applicable, duration, report) VALUES ('WOL', 'WOL', 'Warrant of Levy', '5', '1', '30', 'auctionnotice_warrant')
;




CREATE TABLE propertyauction (
  objid varchar(50) NOT NULL,
  state varchar(25) NOT NULL,
	txnno varchar(25) null,
  txndate date NULL,
	publicationdate1 date NULL,
  published1 int(255) NULL,
  publicationdate2 date NULL,
  published2 int(255) NULL,
  auctiondate date NULL,
  finalsaledate date NULL,
  createdby_name varchar(100) NULL,
  createdby_title varchar(100) NULL,
  approvedby_name varchar(100) DEFAULT NULL,
  approvedby_title varchar(100) DEFAULT NULL,
  closedby_name varchar(100) DEFAULT NULL,
  closedby_title varchar(100) DEFAULT NULL,
  location varchar(255) DEFAULT NULL,
  PRIMARY KEY (objid),
	KEY ux_state (state),
	KEY ux_txnno (txnno)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


create table propertyauction_bidder (
    objid varchar(50) not null,
    state varchar(25),
    parent_objid varchar(50),
    entity_objid varchar(50),
    bidderno varchar(25),
    bondamt decimal(16,2) default 0,
    primary key(objid),
    key ix_parent_objid (parent_objid),
    key ix_state (state),
    key fk_propertyauction_bidder_entity (entity_objid),
    constraint fk_propertyauction_bidder_entity foreign key (entity_objid)
        references entity(objid)
) engine=innodb default charset=utf8
;

CREATE TABLE propertyauction_notice (
  objid varchar(50) NOT NULL,
  state varchar(50) DEFAULT NULL,
  step_objid varchar(50) DEFAULT NULL,
  rptledger_objid varchar(50) DEFAULT NULL,
  txndate datetime DEFAULT NULL,
  txnno varchar(30) DEFAULT NULL,
  dtcomputed date DEFAULT NULL,
  validuntil date DEFAULT NULL,
  period varchar(50) DEFAULT NULL,
  fromyear int(255) DEFAULT NULL,
  fromqtr int(255) DEFAULT NULL,
  toyear int(255) DEFAULT NULL,
  toqtr int(255) DEFAULT NULL,
  basic decimal(16,2) DEFAULT NULL,
  basicint decimal(16,2) DEFAULT NULL,
  basicdisc decimal(16,2) DEFAULT NULL,
  sef decimal(16,2) DEFAULT NULL,
  sefint decimal(16,2) DEFAULT NULL,
  sefdisc decimal(16,2) DEFAULT NULL,
  basicidle decimal(16,2) DEFAULT NULL,
  basicidleint decimal(16,2) DEFAULT NULL,
  basicidledisc decimal(16,2) DEFAULT NULL,
  firecode decimal(16,2) DEFAULT NULL,
  amtdue decimal(16,2) DEFAULT NULL,
  createdby_name varchar(255) DEFAULT NULL,
  createdby_title varchar(100) DEFAULT NULL,
  verifiedby varchar(255) DEFAULT NULL,
  deliveredby varchar(255) DEFAULT NULL,
  receivedby varchar(255) DEFAULT NULL,
  dtreceived date DEFAULT NULL,
  treasurer_name varchar(255) DEFAULT NULL,
  treasurer_title varchar(50) DEFAULT NULL,
  notedby_name varchar(255) DEFAULT NULL,
  notedby_title varchar(50) DEFAULT NULL,
  remarks varchar(255) DEFAULT NULL,
  expirydate date DEFAULT NULL,
  prevnotice_objid varchar(50) DEFAULT NULL,
  auction_objid varchar(50) DEFAULT NULL,
  receipt_objid varchar(50) DEFAULT NULL,
  receipt_receiptno varchar(25) DEFAULT NULL,
  receipt_receiptdate date DEFAULT NULL,
  costofsale decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (objid),
  UNIQUE KEY ux_txnno (txnno),
  KEY fk_propertyauctionnotice_propertyauction (auction_objid),
  KEY fk_propertyauctionnotice_auctionstep (step_objid),
  KEY fk_propertyauctionnotice_rptledger (rptledger_objid),
  KEY fk_propertyauctionnotice_propertyauctionnotice (prevnotice_objid),
  KEY ix_state (state),
  CONSTRAINT fk_propertyauctionnotice_auctionstep FOREIGN KEY (step_objid) REFERENCES propertyauction_step (objid),
  CONSTRAINT fk_propertyauctionnotice_propertyauction FOREIGN KEY (auction_objid) REFERENCES propertyauction (objid),
  CONSTRAINT fk_propertyauctionnotice_propertyauctionnotice FOREIGN KEY (prevnotice_objid) REFERENCES propertyauction_notice (objid),
  CONSTRAINT fk_propertyauctionnotice_rptledger FOREIGN KEY (rptledger_objid) REFERENCES rptledger (objid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
;


create table propertyauction_property (
    objid varchar(50),
    state varchar(25),
    parent_objid varchar(50),
    rptledger_objid varchar(50),
    bidder_objid varchar(50),
    bidder_dtbid varchar(50),
    bidder_marriedto varchar(50),
    bidder_marriedtoaddress varchar(50),
    amtdue decimal(16,2) default 0,
    costofsale decimal(16,2) default 0,
    amtduepaid decimal(16,2) default 0,
    minbidamt decimal(16,2) default 0,
    bidamt decimal(16,2) default 0,
    balance decimal(16,2) default 0,
    redemptiondate date,
    redeemedby_objid varchar(50),
    redeemedamt decimal(16,2) default 0,
    primary key(objid),
    key ix_parent_objid (parent_objid),
    key ix_state (state),
    key fk_propertyauction_property_auction(parent_objid),
    key fk_propertyauction_property_bidder(bidder_objid),
    key fk_propertyauction_property_redeemer(redeemedby_objid),
    key fk_propertyauction_property_rptledger(rptledger_objid),
    constraint fk_propertyauction_property_auction foreign key (parent_objid)
        references propertyauction (objid),
    constraint fk_propertyauction_property_notice foreign key (objid)
        references propertyauction_notice (objid),
    constraint fk_propertyauction_property_bidder foreign key (bidder_objid)
        references propertyauction_bidder (objid),
    constraint fk_propertyauction_property_redeemer foreign key (redeemedby_objid)
        references entity (objid),
    constraint fk_propertyauction_property_rptledger foreign key (rptledger_objid)
        references rptledger (objid)
)engine=innodb default charset=utf8
;


create table propertyauction_bidding (
    objid varchar(50) not null,
    state varchar(50) not null,
    parent_objid varchar(50) not null,
    property_objid varchar(50) not null,
    dtstarted date ,
    dtclosed date ,
    createdby_name varchar(150) ,
    createdby_title varchar(50) ,
    bidder_objid varchar(50) ,
    bidamt decimal(16,2) default 0,
    lineno int(11),
    primary key(objid),
    key ix_parent_objid (parent_objid),
    key ix_state (state),
    key fk_propertyauction_bidding_property(property_objid),
    key fk_propertyauction_bidding_bidder(bidder_objid),
    constraint fk_propertyauction_bidding_property foreign key(property_objid)
        references propertyauction_property(objid),
    constraint fk_propertyauction_bidding_bidder foreign key(bidder_objid)
        references propertyauction_bidder(objid)
) engine=innodb default charset=utf8
;


create table propertyauction_bidder_property (
    objid varchar(50),
    parent_objid varchar(50),
    property_objid varchar(50),
    rptledger_objid varchar(50),
    tdno varchar(50),
    fullpin varchar(50),
    owner_name varchar(1000),
    totalmv decimal(16,2) default 0,
    totalav decimal(16,2) default 0,
    totalareaha decimal(16,6) default 0,
	primary key(objid),
    key ix_parent_objid (parent_objid),
    key ix_tdno (tdno),
    key fk_propertyauction_bidder_property_property(property_objid),
    key fk_propertyauction_bidder_property_rptledger(rptledger_objid),
    constraint fk_propertyauction_bidder_property_property foreign key (property_objid)
        references propertyauction_property (objid),
    constraint fk_propertyauction_bidder_property_rptledger foreign key (rptledger_objid)
        references rptledger (objid)
) engine=innodb default charset=utf8
;


create table propertyauction_bidding_call (
    objid varchar(50),
    parent_objid varchar(50),
    bidder_objid varchar(50),
    lineno int(11) not null,
    callno int(11) not null,
    amount decimal(16,2) default 0,
    primary key (objid),
    key ix_parent_objid (parent_objid),
    key fk_propertyauction_bidding_call_bidder (bidder_objid),
    constraint fk_propertyauction_bidding_call_bidder foreign key (bidder_objid)
        references propertyauction_bidder (objid)
) engine=innodb default charset=utf8
;

create table propertyauction_property_charge (
    objid varchar(50),
    parent_objid varchar(50),
    type varchar(50),
    item_objid varchar(50),
    amount decimal(16,2) default 0,
    receipt_objid varchar(50),
    receipt_receiptno varchar(50),
    receipt_receiptdate date,
    primary key (objid),
    key ix_parent_objid (parent_objid),
    key ix_receipt_objid (receipt_objid),
    key ix_receipt_receiptno (receipt_receiptno),
    key fk_propertyauction_property_charge_itemacount (item_objid),
    constraint fk_propertyauction_property_charge_itemacount foreign key (item_objid)
        references itemaccount (objid)
) engine=innodb default charset=utf8
;

create table propertyauction_property_credit (
    objid varchar(50),
    parent_objid varchar(50),
    mode varchar(50),
    refid varchar(50),
    refno varchar(50),
    refdate date,
    amount decimal(16,2) default 0,
    particulars varchar(255),
    primary key (objid),
    key ix_refid (refid),
    key fk_propertyauction_property_credit_property (parent_objid),
    constraint fk_propertyauction_property_credit_property foreign key (parent_objid)
        references propertyauction_property (objid)
) engine=innodb default charset=utf8
;


create table propertyauction_redeem (
    objid varchar(50),
    parent_objid varchar(50),
    rptledger_objid varchar(50),
    redeemedby_objid varchar(50),
    dtredeemed varchar(50),
    amtdue varchar(50),
    interest varchar(50),
    redeemamt varchar(50),
    receipt_objid varchar(50),
    primary key (objid),
    key ix_parent_objid (parent_objid),
    key fk_propertyauction_redeem_entity (redeemedby_objid),
    key fk_propertyauction_redeem_rptledger (rptledger_objid),
    key fk_propertyauction_redeem_cashreceipt (receipt_objid),
    constraint fk_propertyauction_redeem_entity foreign key (redeemedby_objid)
        references entity (objid),
    constraint fk_propertyauction_redeem_rptledger foreign key (rptledger_objid)
        references rptledger (objid),
    constraint fk_propertyauction_redeem_cashreceipt foreign key (receipt_objid)
        references cashreceipt (objid)
) engine=innodb default charset=utf8
;


drop view if exists vw_property_bidder
;

create view vw_property_bidder
as 
select 
	b.*,
	p.property_objid, 
	e.name as bidder_name,
	e.address_text as bidder_address
from propertyauction_bidder b 
inner join entity e on b.entity_objid = e.objid 
inner join propertyauction_bidder_property p on b.objid = p.parent_objid
;