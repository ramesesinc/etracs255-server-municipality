-- MySQL dump 10.13  Distrib 5.5.59, for Win64 (AMD64)
--
-- Host: localhost    Database: eor
-- ------------------------------------------------------
-- Server version	5.5.59

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `eor`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `eor` /*!40100 DEFAULT CHARACTER SET utf8 */;

USE `eor`;

--
-- Table structure for table `eor`
--

DROP TABLE IF EXISTS `eor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eor` (
  `objid` varchar(50) NOT NULL,
  `receiptno` varchar(50) DEFAULT NULL,
  `receiptdate` date DEFAULT NULL,
  `txndate` datetime DEFAULT NULL,
  `state` varchar(10) DEFAULT NULL,
  `partnerid` varchar(50) DEFAULT NULL,
  `txntype` varchar(20) DEFAULT NULL,
  `traceid` varchar(50) DEFAULT NULL,
  `tracedate` datetime DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `paidby` varchar(255) DEFAULT NULL,
  `paidbyaddress` varchar(255) DEFAULT NULL,
  `payer_objid` varchar(50) DEFAULT NULL,
  `paymethod` varchar(20) DEFAULT NULL,
  `paymentrefid` varchar(50) DEFAULT NULL,
  `remittanceid` varchar(50) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `lockid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_eor_receiptno` (`receiptno`),
  KEY `ix_receiptdate` (`receiptdate`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_partnerid` (`partnerid`),
  KEY `ix_traceid` (`traceid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_paidby` (`paidby`),
  KEY `ix_payer_objid` (`payer_objid`),
  KEY `ix_paymentrefid` (`paymentrefid`),
  KEY `ix_remittanceid` (`remittanceid`),
  KEY `ix_lockid` (`lockid`),
  CONSTRAINT `fk_eor_remittanceid` FOREIGN KEY (`remittanceid`) REFERENCES `eor_remittance` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eor`
--

LOCK TABLES `eor` WRITE;
/*!40000 ALTER TABLE `eor` DISABLE KEYS */;
/*!40000 ALTER TABLE `eor` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eor_for_email`
--

DROP TABLE IF EXISTS `eor_for_email`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eor_for_email` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mobileno` varchar(50) DEFAULT NULL,
  `state` int(11) DEFAULT NULL,
  `dtsent` datetime DEFAULT NULL,
  `errmsg` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eor_for_email`
--

LOCK TABLES `eor_for_email` WRITE;
/*!40000 ALTER TABLE `eor_for_email` DISABLE KEYS */;
/*!40000 ALTER TABLE `eor_for_email` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eor_item`
--

DROP TABLE IF EXISTS `eor_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eor_item` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) DEFAULT NULL,
  `item_objid` varchar(50) DEFAULT NULL,
  `item_code` varchar(100) DEFAULT NULL,
  `item_title` varchar(100) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `remarks` varchar(255) DEFAULT NULL,
  `item_fund_objid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_eoritem_eor` (`parentid`),
  KEY `ix_item_objid` (`item_objid`),
  KEY `ix_item_fund_objid` (`item_fund_objid`),
  CONSTRAINT `fk_eoritem_eor` FOREIGN KEY (`parentid`) REFERENCES `eor` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eor_item`
--

LOCK TABLES `eor_item` WRITE;
/*!40000 ALTER TABLE `eor_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `eor_item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eor_manual_post`
--

DROP TABLE IF EXISTS `eor_manual_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eor_manual_post` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(10) DEFAULT NULL,
  `paymentorderno` varchar(50) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `txntype` varchar(50) DEFAULT NULL,
  `paymentpartnerid` varchar(50) DEFAULT NULL,
  `traceid` varchar(50) DEFAULT NULL,
  `tracedate` datetime DEFAULT NULL,
  `reason` tinytext,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `uix_eor_manual_post_paymentorderno` (`paymentorderno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eor_manual_post`
--

LOCK TABLES `eor_manual_post` WRITE;
/*!40000 ALTER TABLE `eor_manual_post` DISABLE KEYS */;
/*!40000 ALTER TABLE `eor_manual_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eor_number`
--

DROP TABLE IF EXISTS `eor_number`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eor_number` (
  `objid` varchar(255) NOT NULL,
  `currentno` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eor_number`
--

LOCK TABLES `eor_number` WRITE;
/*!40000 ALTER TABLE `eor_number` DISABLE KEYS */;
/*!40000 ALTER TABLE `eor_number` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eor_payment_error`
--

DROP TABLE IF EXISTS `eor_payment_error`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eor_payment_error` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime NOT NULL,
  `paymentrefid` varchar(50) NOT NULL,
  `errmsg` longtext NOT NULL,
  `errdetail` longtext,
  `errcode` int(1) DEFAULT NULL,
  `laststate` int(1) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ix_paymentrefid` (`paymentrefid`),
  KEY `ix_txndate` (`txndate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eor_payment_error`
--

LOCK TABLES `eor_payment_error` WRITE;
/*!40000 ALTER TABLE `eor_payment_error` DISABLE KEYS */;
/*!40000 ALTER TABLE `eor_payment_error` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eor_paymentorder`
--

DROP TABLE IF EXISTS `eor_paymentorder`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eor_paymentorder` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime DEFAULT NULL,
  `txntype` varchar(50) DEFAULT NULL,
  `txntypename` varchar(100) DEFAULT NULL,
  `payer_objid` varchar(50) DEFAULT NULL,
  `payer_name` text,
  `paidby` text,
  `paidbyaddress` varchar(150) DEFAULT NULL,
  `particulars` varchar(500) DEFAULT NULL,
  `amount` decimal(16,2) DEFAULT NULL,
  `expirydate` date DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `info` text,
  `origin` varchar(100) DEFAULT NULL,
  `controlno` varchar(50) DEFAULT NULL,
  `locationid` varchar(25) DEFAULT NULL,
  `items` mediumtext,
  `state` varchar(32) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mobileno` varchar(25) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_state` (`state`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eor_paymentorder`
--

LOCK TABLES `eor_paymentorder` WRITE;
/*!40000 ALTER TABLE `eor_paymentorder` DISABLE KEYS */;
/*!40000 ALTER TABLE `eor_paymentorder` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eor_paymentorder_cancelled`
--

DROP TABLE IF EXISTS `eor_paymentorder_cancelled`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eor_paymentorder_cancelled` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime DEFAULT NULL,
  `txntype` varchar(50) DEFAULT NULL,
  `txntypename` varchar(100) DEFAULT NULL,
  `payer_objid` varchar(50) DEFAULT NULL,
  `payer_name` longtext,
  `paidby` longtext,
  `paidbyaddress` varchar(150) DEFAULT NULL,
  `particulars` text,
  `amount` decimal(16,2) DEFAULT NULL,
  `expirydate` date DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `info` longtext,
  `origin` varchar(100) DEFAULT NULL,
  `controlno` varchar(50) DEFAULT NULL,
  `locationid` varchar(25) DEFAULT NULL,
  `items` longtext,
  `state` varchar(10) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mobileno` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_txntype` (`txntype`),
  KEY `ix_payer_objid` (`payer_objid`),
  KEY `ix_payer_name` (`payer_name`(255)),
  KEY `ix_expirydate` (`expirydate`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_controlno` (`controlno`),
  KEY `ix_locationid` (`locationid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eor_paymentorder_cancelled`
--

LOCK TABLES `eor_paymentorder_cancelled` WRITE;
/*!40000 ALTER TABLE `eor_paymentorder_cancelled` DISABLE KEYS */;
/*!40000 ALTER TABLE `eor_paymentorder_cancelled` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eor_paymentorder_paid`
--

DROP TABLE IF EXISTS `eor_paymentorder_paid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eor_paymentorder_paid` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime DEFAULT NULL,
  `txntype` varchar(50) DEFAULT NULL,
  `txntypename` varchar(100) DEFAULT NULL,
  `payer_objid` varchar(50) DEFAULT NULL,
  `payer_name` longtext,
  `paidby` longtext,
  `paidbyaddress` varchar(150) DEFAULT NULL,
  `particulars` text,
  `amount` decimal(16,2) DEFAULT NULL,
  `expirydate` date DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `info` longtext,
  `origin` varchar(100) DEFAULT NULL,
  `controlno` varchar(50) DEFAULT NULL,
  `locationid` varchar(25) DEFAULT NULL,
  `items` longtext,
  `state` varchar(10) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mobileno` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_txntype` (`txntype`),
  KEY `ix_payer_objid` (`payer_objid`),
  KEY `ix_payer_name` (`payer_name`(255)),
  KEY `ix_expirydate` (`expirydate`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_controlno` (`controlno`),
  KEY `ix_locationid` (`locationid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eor_paymentorder_paid`
--

LOCK TABLES `eor_paymentorder_paid` WRITE;
/*!40000 ALTER TABLE `eor_paymentorder_paid` DISABLE KEYS */;
/*!40000 ALTER TABLE `eor_paymentorder_paid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eor_remittance`
--

DROP TABLE IF EXISTS `eor_remittance`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eor_remittance` (
  `objid` varchar(50) NOT NULL,
  `state` varchar(50) DEFAULT NULL,
  `controlno` varchar(50) DEFAULT NULL,
  `partnerid` varchar(50) DEFAULT NULL,
  `controldate` date DEFAULT NULL,
  `dtcreated` datetime DEFAULT NULL,
  `createdby_objid` varchar(50) DEFAULT NULL,
  `createdby_name` varchar(255) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `dtposted` datetime DEFAULT NULL,
  `postedby_objid` varchar(50) DEFAULT NULL,
  `postedby_name` varchar(255) DEFAULT NULL,
  `lockid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eor_remittance`
--

LOCK TABLES `eor_remittance` WRITE;
/*!40000 ALTER TABLE `eor_remittance` DISABLE KEYS */;
/*!40000 ALTER TABLE `eor_remittance` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eor_remittance_fund`
--

DROP TABLE IF EXISTS `eor_remittance_fund`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eor_remittance_fund` (
  `objid` varchar(100) NOT NULL,
  `remittanceid` varchar(50) DEFAULT NULL,
  `fund_objid` varchar(50) DEFAULT NULL,
  `fund_code` varchar(50) DEFAULT NULL,
  `fund_title` varchar(255) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `bankaccount_objid` varchar(50) DEFAULT NULL,
  `bankaccount_title` varchar(255) DEFAULT NULL,
  `bankaccount_bank_name` varchar(255) DEFAULT NULL,
  `validation_refno` varchar(50) DEFAULT NULL,
  `validation_refdate` date DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `fk_eor_remittance_fund_remittance` (`remittanceid`),
  CONSTRAINT `fk_eor_remittance_fund_remittance` FOREIGN KEY (`remittanceid`) REFERENCES `eor_remittance` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eor_remittance_fund`
--

LOCK TABLES `eor_remittance_fund` WRITE;
/*!40000 ALTER TABLE `eor_remittance_fund` DISABLE KEYS */;
/*!40000 ALTER TABLE `eor_remittance_fund` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `eor_share`
--

DROP TABLE IF EXISTS `eor_share`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eor_share` (
  `objid` varchar(50) NOT NULL,
  `parentid` varchar(50) NOT NULL,
  `refitem_objid` varchar(50) DEFAULT NULL,
  `refitem_code` varchar(25) DEFAULT NULL,
  `refitem_title` varchar(255) DEFAULT NULL,
  `payableitem_objid` varchar(50) DEFAULT NULL,
  `payableitem_code` varchar(25) DEFAULT NULL,
  `payableitem_title` varchar(255) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `share` decimal(16,2) DEFAULT NULL,
  `receiptitemid` varchar(50) DEFAULT NULL,
  `refitem_fund_objid` varchar(100) DEFAULT NULL,
  `payableitem_fund_objid` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refitem_fund_objid` (`refitem_fund_objid`),
  KEY `ix_payableitem_fund_objid` (`payableitem_fund_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eor_share`
--

LOCK TABLES `eor_share` WRITE;
/*!40000 ALTER TABLE `eor_share` DISABLE KEYS */;
/*!40000 ALTER TABLE `eor_share` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `epayment_plugin`
--

DROP TABLE IF EXISTS `epayment_plugin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `epayment_plugin` (
  `objid` varchar(50) NOT NULL,
  `connection` varchar(50) DEFAULT NULL,
  `servicename` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `epayment_plugin`
--

LOCK TABLES `epayment_plugin` WRITE;
/*!40000 ALTER TABLE `epayment_plugin` DISABLE KEYS */;
INSERT INTO `epayment_plugin` VALUES ('bpls','bpls','OnlineBusinessBillingService'),('rptcol','rpt','OnlineLandTaxBillingService'),('rpttaxclearance','landtax','OnlineRealtyTaxClearanceService');
/*!40000 ALTER TABLE `epayment_plugin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fund`
--

DROP TABLE IF EXISTS `fund`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `fund` (
  `objid` varchar(100) NOT NULL,
  `state` varchar(10) DEFAULT NULL,
  `code` varchar(50) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `type` varchar(20) DEFAULT NULL,
  `special` int(11) DEFAULT NULL,
  `system` int(11) DEFAULT NULL,
  `depositoryfundid` varchar(100) DEFAULT NULL,
  `group_objid` varchar(50) DEFAULT NULL,
  `group_title` varchar(255) DEFAULT NULL,
  `group_indexno` int(11) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_code` (`code`),
  KEY `ix_title` (`title`),
  KEY `ix_group_objid` (`group_objid`),
  KEY `ix_depositoryfundid` (`depositoryfundid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fund`
--

LOCK TABLES `fund` WRITE;
/*!40000 ALTER TABLE `fund` DISABLE KEYS */;
/*!40000 ALTER TABLE `fund` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jev`
--

DROP TABLE IF EXISTS `jev`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jev` (
  `objid` varchar(150) NOT NULL,
  `jevno` varchar(50) DEFAULT NULL,
  `jevdate` date DEFAULT NULL,
  `fundid` varchar(50) DEFAULT NULL,
  `dtposted` datetime DEFAULT NULL,
  `txntype` varchar(50) DEFAULT NULL,
  `refid` varchar(50) DEFAULT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `reftype` varchar(50) DEFAULT NULL,
  `amount` decimal(16,4) DEFAULT NULL,
  `state` varchar(32) DEFAULT NULL,
  `postedby_objid` varchar(50) DEFAULT NULL,
  `postedby_name` varchar(255) DEFAULT NULL,
  `verifiedby_objid` varchar(50) DEFAULT NULL,
  `verifiedby_name` varchar(255) DEFAULT NULL,
  `dtverified` datetime DEFAULT NULL,
  `batchid` varchar(50) DEFAULT NULL,
  `refdate` date DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_batchid` (`batchid`),
  KEY `ix_dtposted` (`dtposted`),
  KEY `ix_dtverified` (`dtverified`),
  KEY `ix_fundid` (`fundid`),
  KEY `ix_jevdate` (`jevdate`),
  KEY `ix_jevno` (`jevno`),
  KEY `ix_postedby_objid` (`postedby_objid`),
  KEY `ix_refdate` (`refdate`),
  KEY `ix_refid` (`refid`),
  KEY `ix_refno` (`refno`),
  KEY `ix_reftype` (`reftype`),
  KEY `ix_verifiedby_objid` (`verifiedby_objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jev`
--

LOCK TABLES `jev` WRITE;
/*!40000 ALTER TABLE `jev` DISABLE KEYS */;
/*!40000 ALTER TABLE `jev` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `jevitem`
--

DROP TABLE IF EXISTS `jevitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jevitem` (
  `objid` varchar(150) NOT NULL,
  `jevid` varchar(150) DEFAULT NULL,
  `accttype` varchar(50) DEFAULT NULL,
  `acctid` varchar(50) DEFAULT NULL,
  `acctcode` varchar(32) DEFAULT NULL,
  `acctname` varchar(255) DEFAULT NULL,
  `dr` decimal(16,4) DEFAULT NULL,
  `cr` decimal(16,4) DEFAULT NULL,
  `particulars` varchar(255) DEFAULT NULL,
  `itemrefid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_jevid` (`jevid`),
  KEY `ix_ledgertype` (`accttype`),
  KEY `ix_acctid` (`acctid`),
  KEY `ix_acctcode` (`acctcode`),
  KEY `ix_acctname` (`acctname`),
  KEY `ix_itemrefid` (`itemrefid`),
  CONSTRAINT `fk_jevitem_jevid` FOREIGN KEY (`jevid`) REFERENCES `jev` (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `jevitem`
--

LOCK TABLES `jevitem` WRITE;
/*!40000 ALTER TABLE `jevitem` DISABLE KEYS */;
/*!40000 ALTER TABLE `jevitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `paymentpartner`
--

DROP TABLE IF EXISTS `paymentpartner`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `paymentpartner` (
  `objid` varchar(50) NOT NULL,
  `code` varchar(50) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `branch` varchar(255) DEFAULT NULL,
  `contact` varchar(255) DEFAULT NULL,
  `mobileno` varchar(32) DEFAULT NULL,
  `phoneno` varchar(32) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `indexno` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `paymentpartner`
--

LOCK TABLES `paymentpartner` WRITE;
/*!40000 ALTER TABLE `paymentpartner` DISABLE KEYS */;
INSERT INTO `paymentpartner` VALUES ('DBP','101','DEVELOPMENT BANK OF THE PHILIPPINES',NULL,NULL,NULL,NULL,NULL,'101'),('GCASH','104','GCASH',NULL,NULL,NULL,NULL,NULL,'104'),('LBP','102','LAND BANK OF THE PHILIPPINES',NULL,NULL,NULL,NULL,NULL,'102'),('PAYMAYA','103','PAYMAYA',NULL,NULL,NULL,NULL,NULL,'103');
/*!40000 ALTER TABLE `paymentpartner` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_email_queue`
--

DROP TABLE IF EXISTS `sys_email_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_email_queue` (
  `objid` varchar(50) NOT NULL,
  `refid` varchar(50) NOT NULL,
  `state` int(11) NOT NULL,
  `reportid` varchar(50) DEFAULT NULL,
  `dtsent` datetime NOT NULL,
  `to` varchar(255) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `errmsg` longtext,
  `connection` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`objid`),
  KEY `ix_refid` (`refid`),
  KEY `ix_state` (`state`),
  KEY `ix_reportid` (`reportid`),
  KEY `ix_dtsent` (`dtsent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_email_queue`
--

LOCK TABLES `sys_email_queue` WRITE;
/*!40000 ALTER TABLE `sys_email_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `sys_email_queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sys_email_template`
--

DROP TABLE IF EXISTS `sys_email_template`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sys_email_template` (
  `objid` varchar(50) NOT NULL,
  `subject` varchar(255) NOT NULL,
  `message` longtext NOT NULL,
  PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sys_email_template`
--

LOCK TABLES `sys_email_template` WRITE;
/*!40000 ALTER TABLE `sys_email_template` DISABLE KEYS */;
INSERT INTO `sys_email_template` VALUES ('eor','EOR No ${receiptno}','Dear valued customer <br>Please see attached Electronic OR. This is an electronic transaction. Do not reply');
/*!40000 ALTER TABLE `sys_email_template` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unpostedpayment`
--

DROP TABLE IF EXISTS `unpostedpayment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unpostedpayment` (
  `objid` varchar(50) NOT NULL,
  `txndate` datetime NOT NULL,
  `txntype` varchar(50) NOT NULL,
  `txntypename` varchar(150) NOT NULL,
  `paymentrefid` varchar(50) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `orgcode` varchar(20) NOT NULL,
  `partnerid` varchar(50) NOT NULL,
  `traceid` varchar(100) NOT NULL,
  `tracedate` datetime NOT NULL,
  `refno` varchar(50) DEFAULT NULL,
  `origin` varchar(50) DEFAULT NULL,
  `paymentorder` longtext,
  `errmsg` text NOT NULL,
  `errdetail` longtext,
  PRIMARY KEY (`objid`),
  UNIQUE KEY `ix_paymentrefid` (`paymentrefid`),
  KEY `ix_txndate` (`txndate`),
  KEY `ix_txntype` (`txntype`),
  KEY `ix_partnerid` (`partnerid`),
  KEY `ix_traceid` (`traceid`),
  KEY `ix_tracedate` (`tracedate`),
  KEY `ix_refno` (`refno`),
  KEY `ix_origin` (`origin`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unpostedpayment`
--

LOCK TABLES `unpostedpayment` WRITE;
/*!40000 ALTER TABLE `unpostedpayment` DISABLE KEYS */;
/*!40000 ALTER TABLE `unpostedpayment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `vw_remittance_eor_item`
--

DROP TABLE IF EXISTS `vw_remittance_eor_item`;
/*!50001 DROP VIEW IF EXISTS `vw_remittance_eor_item`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vw_remittance_eor_item` (
  `remittanceid` tinyint NOT NULL,
  `remittance_controldate` tinyint NOT NULL,
  `remittance_controlno` tinyint NOT NULL,
  `receiptid` tinyint NOT NULL,
  `receiptdate` tinyint NOT NULL,
  `receiptno` tinyint NOT NULL,
  `paidby` tinyint NOT NULL,
  `paidbyaddress` tinyint NOT NULL,
  `fundid` tinyint NOT NULL,
  `acctid` tinyint NOT NULL,
  `acctcode` tinyint NOT NULL,
  `acctname` tinyint NOT NULL,
  `remarks` tinyint NOT NULL,
  `amount` tinyint NOT NULL,
  `txntype` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Temporary table structure for view `vw_remittance_eor_share`
--

DROP TABLE IF EXISTS `vw_remittance_eor_share`;
/*!50001 DROP VIEW IF EXISTS `vw_remittance_eor_share`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE TABLE `vw_remittance_eor_share` (
  `remittanceid` tinyint NOT NULL,
  `remittance_controldate` tinyint NOT NULL,
  `remittance_controlno` tinyint NOT NULL,
  `receiptid` tinyint NOT NULL,
  `receiptdate` tinyint NOT NULL,
  `receiptno` tinyint NOT NULL,
  `paidby` tinyint NOT NULL,
  `paidbyaddress` tinyint NOT NULL,
  `refacctid` tinyint NOT NULL,
  `refacctcode` tinyint NOT NULL,
  `refaccttitle` tinyint NOT NULL,
  `reffundid` tinyint NOT NULL,
  `acctid` tinyint NOT NULL,
  `acctcode` tinyint NOT NULL,
  `acctname` tinyint NOT NULL,
  `fundid` tinyint NOT NULL,
  `amount` tinyint NOT NULL,
  `txntype` tinyint NOT NULL
) ENGINE=MyISAM */;
SET character_set_client = @saved_cs_client;

--
-- Current Database: `eor`
--

USE `eor`;

--
-- Final view structure for view `vw_remittance_eor_item`
--

/*!50001 DROP TABLE IF EXISTS `vw_remittance_eor_item`*/;
/*!50001 DROP VIEW IF EXISTS `vw_remittance_eor_item`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_remittance_eor_item` AS select `c`.`remittanceid` AS `remittanceid`,`r`.`controldate` AS `remittance_controldate`,`r`.`controlno` AS `remittance_controlno`,`cri`.`parentid` AS `receiptid`,`c`.`receiptdate` AS `receiptdate`,`c`.`receiptno` AS `receiptno`,`c`.`paidby` AS `paidby`,`c`.`paidbyaddress` AS `paidbyaddress`,`cri`.`item_fund_objid` AS `fundid`,`cri`.`item_objid` AS `acctid`,`cri`.`item_code` AS `acctcode`,`cri`.`item_title` AS `acctname`,`cri`.`remarks` AS `remarks`,`cri`.`amount` AS `amount`,`c`.`txntype` AS `txntype` from ((`eor_remittance` `r` join `eor` `c` on((`c`.`remittanceid` = `r`.`objid`))) join `eor_item` `cri` on((`cri`.`parentid` = `c`.`objid`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `vw_remittance_eor_share`
--

/*!50001 DROP TABLE IF EXISTS `vw_remittance_eor_share`*/;
/*!50001 DROP VIEW IF EXISTS `vw_remittance_eor_share`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `vw_remittance_eor_share` AS select `c`.`remittanceid` AS `remittanceid`,`r`.`controldate` AS `remittance_controldate`,`r`.`controlno` AS `remittance_controlno`,`cri`.`parentid` AS `receiptid`,`c`.`receiptdate` AS `receiptdate`,`c`.`receiptno` AS `receiptno`,`c`.`paidby` AS `paidby`,`c`.`paidbyaddress` AS `paidbyaddress`,`cri`.`refitem_objid` AS `refacctid`,`cri`.`refitem_code` AS `refacctcode`,`cri`.`refitem_title` AS `refaccttitle`,`cri`.`refitem_fund_objid` AS `reffundid`,`cri`.`payableitem_objid` AS `acctid`,`cri`.`payableitem_code` AS `acctcode`,`cri`.`payableitem_title` AS `acctname`,`cri`.`payableitem_fund_objid` AS `fundid`,`cri`.`amount` AS `amount`,`c`.`txntype` AS `txntype` from ((`eor_remittance` `r` join `eor` `c` on((`c`.`remittanceid` = `r`.`objid`))) join `eor_share` `cri` on((`cri`.`parentid` = `c`.`objid`))) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-06-15 10:20:18
