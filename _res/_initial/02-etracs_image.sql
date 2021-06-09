CREATE DATABASE `etracs_image` CHARACTER SET utf8;

USE `etracs_image`;

--
-- TABLE STRUCTURES 
--

CREATE TABLE `image_chunk` ( 
   `objid` varchar(50) NOT NULL, 
   `parentid` varchar(50) NOT NULL, 
   `fileno` int NOT NULL, 
   `byte` longblob NOT NULL,
   CONSTRAINT `pk_image_chunk` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 


CREATE TABLE `image_header` ( 
   `objid` varchar(50) NOT NULL, 
   `refid` varchar(50) NOT NULL, 
   `title` varchar(255) NOT NULL, 
   `filesize` int NULL, 
   `extension` varchar(255) NULL, 
   `parentid` varchar(50) NULL,
   CONSTRAINT `pk_image_header` PRIMARY KEY (`objid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
; 
