/*
SQLyog Community v13.1.9 (64 bit)
MySQL - 10.4.24-MariaDB : Database - Project_Paris
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`Project_Paris` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

USE `Project_Paris`;

/*Table structure for table `article` */

DROP TABLE IF EXISTS `article`;

CREATE TABLE `article` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `regDate` DATETIME NOT NULL,
  `updateDate` DATETIME NOT NULL,
  `memberID` INT(10) UNSIGNED NOT NULL,
  `boardId` INT(10) UNSIGNED NOT NULL,
  `title` CHAR(100) DEFAULT NULL,
  `body` TEXT NOT NULL,
  `hitCount` INT(10) UNSIGNED NOT NULL DEFAULT 0,
  `goodReactionPoint` INT(10) UNSIGNED NOT NULL DEFAULT 0,
  `badReactionPoint` INT(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=INNODB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4;

/*Data for the table `article` */

INSERT  INTO `article`(`id`,`regDate`,`updateDate`,`memberID`,`boardId`,`title`,`body`,`hitCount`,`goodReactionPoint`,`badReactionPoint`) VALUES 
(1,'2023-01-09 20:35:02','2023-01-09 20:35:02',2,1,'제목1','내용1',0,1,2),
(2,'2023-01-09 20:35:02','2023-01-09 20:35:02',2,1,'제목2','내용2',0,3,0),
(3,'2023-01-09 20:35:02','2023-01-09 20:35:02',2,2,'제목3','내용3',0,0,0);

/*Table structure for table `attr` */

DROP TABLE IF EXISTS `attr`;

CREATE TABLE `attr` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `regDate` DATETIME NOT NULL,
  `updateDate` DATETIME NOT NULL,
  `relTypeCode` CHAR(20) NOT NULL,
  `relId` INT(10) UNSIGNED NOT NULL,
  `typeCode` CHAR(30) NOT NULL,
  `type2Code` CHAR(70) NOT NULL,
  `value` TEXT NOT NULL,
  `expireDate` DATETIME DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `relTypeCode` (`relTypeCode`,`relId`,`typeCode`,`type2Code`),
  KEY `relTypeCode_2` (`relTypeCode`,`typeCode`,`type2Code`)
) ENGINE=INNODB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

/*Data for the table `attr` */

INSERT  INTO `attr`(`id`,`regDate`,`updateDate`,`relTypeCode`,`relId`,`typeCode`,`type2Code`,`value`,`expireDate`) VALUES 
(1,'2023-01-09 20:39:44','2023-01-09 20:39:44','member',2,'extra','memberModifyAuthKey','gzkflgfat7','2023-01-09 20:44:44');

/*Table structure for table `board` */

DROP TABLE IF EXISTS `board`;

CREATE TABLE `board` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `regDate` DATETIME NOT NULL,
  `updateDate` DATETIME NOT NULL,
  `code` CHAR(50) NOT NULL COMMENT 'notice(공지사항), free1(자유게시판1), free2(자유게시판2),...',
  `name` CHAR(50) NOT NULL COMMENT '게시판 이름',
  `delStatus` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '삭제여부(0=탈퇴전, 1=탈퇴)',
  `delDate` DATETIME DEFAULT NULL COMMENT '삭제날짜',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  UNIQUE KEY `name` (`name`)
) ENGINE=INNODB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

/*Data for the table `board` */

INSERT  INTO `board`(`id`,`regDate`,`updateDate`,`code`,`name`,`delStatus`,`delDate`) VALUES 
(1,'2023-01-09 20:35:21','2023-01-09 20:35:21','notice','공지사항',0,NULL),
(2,'2023-01-09 20:35:21','2023-01-09 20:35:21','free1','자유',0,NULL);

/*Table structure for table `genFile` */

DROP TABLE IF EXISTS `genFile`;

CREATE TABLE `genFile` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `regDate` DATETIME DEFAULT NULL,
  `updateDate` DATETIME DEFAULT NULL,
  `delDate` DATETIME DEFAULT NULL,
  `delStatus` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
  `relTypeCode` CHAR(50) NOT NULL,
  `relId` INT(10) UNSIGNED NOT NULL,
  `originFileName` VARCHAR(100) NOT NULL,
  `fileExt` CHAR(10) NOT NULL,
  `typeCode` CHAR(20) NOT NULL,
  `type2Code` CHAR(20) NOT NULL,
  `fileSize` INT(10) UNSIGNED NOT NULL,
  `fileExtTypeCode` CHAR(10) NOT NULL,
  `fileExtType2Code` CHAR(10) NOT NULL,
  `fileNo` SMALLINT(2) UNSIGNED NOT NULL,
  `fileDir` CHAR(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `relId` (`relTypeCode`,`relId`,`typeCode`,`type2Code`,`fileNo`)
) ENGINE=INNODB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4;

/*Data for the table `genFile` */

INSERT  INTO `genFile`(`id`,`regDate`,`updateDate`,`delDate`,`delStatus`,`relTypeCode`,`relId`,`originFileName`,`fileExt`,`typeCode`,`type2Code`,`fileSize`,`fileExtTypeCode`,`fileExtType2Code`,`fileNo`,`fileDir`) VALUES 
(1,'2023-01-09 20:39:14','2023-01-09 20:39:14',NULL,0,'member',4,'프로필 1.jpg','jpg','extra','profileImg',27528,'img','jpg',1,'2023_01'),
(2,'2023-01-09 20:39:54','2023-01-09 20:39:54',NULL,0,'member',2,'프로필 1.jpg','jpg','extra','profileImg',27528,'img','jpg',1,'2023_01');

/*Table structure for table `member` */

DROP TABLE IF EXISTS `member`;

CREATE TABLE `member` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `regDate` DATETIME NOT NULL,
  `updateDate` DATETIME NOT NULL,
  `loginId` CHAR(20) NOT NULL,
  `loginPw` VARCHAR(100) NOT NULL,
  `authLevel` SMALLINT(2) UNSIGNED DEFAULT 3 COMMENT '권한레벨(3=일반, 7=관리자)',
  `name` CHAR(20) NOT NULL,
  `nickname` CHAR(20) NOT NULL,
  `cellphoneNo` CHAR(20) NOT NULL,
  `email` CHAR(50) NOT NULL,
  `delStatus` TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '탈퇴여부(0=탈퇴전, 1=탈퇴)',
  `delDate` DATETIME DEFAULT NULL COMMENT '탈퇴날짜',
  PRIMARY KEY (`id`)
) ENGINE=INNODB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4;

/*Data for the table `member` */

INSERT  INTO `member`(`id`,`regDate`,`updateDate`,`loginId`,`loginPw`,`authLevel`,`name`,`nickname`,`cellphoneNo`,`email`,`delStatus`,`delDate`) VALUES 
(1,'2023-01-09 20:35:11','2023-01-09 20:35:11','admin','8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918',7,'관리자','관리자','01012340000','admin@gmail.com',0,NULL),
(2,'2023-01-09 20:35:11','2023-01-09 20:39:54','user1','0a041b9462caa4a31bac3567e0b6e6fd9100787db2ab433d96f6d178cabfce90',3,'사용자1','사용자1','01012340001','user1@gmail.com',0,NULL),
(3,'2023-01-09 20:35:11','2023-01-09 20:35:11','user2','6025d18fe48abd45168528f18a82e265dd98d421a7084aa09f61b341703901a3',3,'사용자2','사용자2','01012340002','user2@gmail.com',0,NULL),
(4,'2023-01-09 20:39:14','2023-01-09 20:39:14','user11','81115e31e22a5801b197750ec12d7a51ad693aa017ecc8bca033cbd500a928b6',3,'user11','user11','01012340003','qkrehgusqkrehgus@gmail.com',0,NULL);

/*Table structure for table `reactionPoint` */

DROP TABLE IF EXISTS `reactionPoint`;

CREATE TABLE `reactionPoint` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `regDate` DATETIME NOT NULL,
  `updateDate` DATETIME NOT NULL,
  `memberId` INT(10) UNSIGNED NOT NULL,
  `relTypeCode` CHAR(30) NOT NULL COMMENT '관련데이터타입코드',
  `relId` INT(10) UNSIGNED NOT NULL COMMENT '관련데이터번호',
  `point` SMALLINT(2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=INNODB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

/*Data for the table `reactionPoint` */

INSERT  INTO `reactionPoint`(`id`,`regDate`,`updateDate`,`memberId`,`relTypeCode`,`relId`,`point`) VALUES 
(1,'2023-01-09 20:35:45','2023-01-09 20:35:45',1,'article',1,-1),
(2,'2023-01-09 20:35:47','2023-01-09 20:35:47',1,'article',2,1),
(3,'2023-01-09 20:35:49','2023-01-09 20:35:49',1,'article',2,1),
(4,'2023-01-09 20:35:53','2023-01-09 20:35:53',2,'article',1,-1),
(5,'2023-01-09 20:35:57','2023-01-09 20:35:57',2,'article',2,1),
(6,'2023-01-09 20:36:00','2023-01-09 20:36:00',3,'article',1,1);

/*Table structure for table `reply` */

DROP TABLE IF EXISTS `reply`;

CREATE TABLE `reply` (
  `id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `regDate` DATETIME NOT NULL,
  `updateDate` DATETIME NOT NULL,
  `memberId` INT(10) UNSIGNED NOT NULL,
  `relTypeCode` CHAR(30) NOT NULL COMMENT '관련데이터타입코드',
  `relId` INT(10) UNSIGNED NOT NULL COMMENT '관련데이터번호',
  `body` TEXT NOT NULL,
  `goodReactionPoint` INT(10) UNSIGNED NOT NULL DEFAULT 0,
  `badReactionPoint` INT(10) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `relTypeCode` (`relTypeCode`,`relId`)
) ENGINE=INNODB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4;

/*Data for the table `reply` */

INSERT  INTO `reply`(`id`,`regDate`,`updateDate`,`memberId`,`relTypeCode`,`relId`,`body`,`goodReactionPoint`,`badReactionPoint`) VALUES 
(1,'2023-01-09 20:36:14','2023-01-09 20:36:14',1,'article',1,'댓글 1',0,0),
(2,'2023-01-09 20:36:16','2023-01-09 20:36:16',1,'article',1,'댓글 2',0,0),
(3,'2023-01-09 20:36:21','2023-01-09 20:36:21',1,'article',1,'댓글 2',0,0),
(4,'2023-01-09 20:36:23','2023-01-09 20:36:23',2,'article',1,'댓글 3',0,0),
(5,'2023-01-09 20:36:27','2023-01-09 20:36:27',3,'article',2,'댓글 4',0,0);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;


