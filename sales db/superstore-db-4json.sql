CREATE DATABASE  IF NOT EXISTS `superstore_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `superstore_db`;
-- MySQL dump 10.13  Distrib 8.0.30, for Win64 (x86_64)
--
-- Host: localhost    Database: superstore_db
-- ------------------------------------------------------
-- Server version	8.0.30

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `items`
--

DROP TABLE IF EXISTS `items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `items` (
  `item_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `brand` varchar(45) DEFAULT NULL,
  `category` varchar(45) DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT '0.00',
  `properties` json DEFAULT NULL,
  PRIMARY KEY (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `items`
--

LOCK TABLES `items` WRITE;
/*!40000 ALTER TABLE `items` DISABLE KEYS */;
INSERT INTO `items` VALUES (10,'Regular Butter','Amul','Dairy',240.00,'{\"unit\": \"gram\", \"weight\": 500, \"is_salted\": 1}'),(11,'White Butter','Amul','Dairy',235.00,'{\"unit\": \"gram\", \"weight\": 500, \"is_salted\": 0}'),(12,'Butter ','Land O Lakes','Dairy',410.00,'{\"unit\": \"pound\", \"weight\": 1, \"is_salted\": 1}'),(13,'Methi Paratha','Patel Brothers','Bakery',415.00,'{\"Count\": 10, \"gluten_free\": 0}'),(14,'Millet Paratha','Patel Brothers','Bakery',380.00,'{\"Count\": 5, \"gluten_free\": 1}'),(15,'Wheat Bread','Arnold','Bakery',320.00,'{\"unit\": \"ounce\", \"flavor\": \"raisin\", \"weight\": 20}'),(16,'Wheat Bread','Arnold','Bakery',380.00,'{\"unit\": \"ounce\", \"flavor\": \"honey\", \"weight\": 20}'),(17,'T Shirt','Adidas','Clothes',800.00,'{\"size\": \"XL\", \"type\": \"sports\", \"color\": \"blue\"}'),(18,'T Shirt','Adidas','Clothes',810.00,'{\"size\": \"XL\", \"type\": \"sports\", \"color\": \"red\"}'),(19,'T Shirt','Adidas','Clothes',785.00,'{\"size\": \"S\", \"type\": \"sports\", \"color\": \"blue\"}'),(20,'T Shirt','FILA','Clothes',1200.00,'{\"size\": \"S\", \"type\": \"casual\", \"color\": \"blue\"}'),(21,'T Shirt','FILA','Clothes',1350.00,'{\"size\": \"M\", \"type\": \"business\", \"color\": \"white\"}'),(22,'T Shirt','FILA','Clothes',1410.00,'{\"size\": \"L\", \"type\": \"business\", \"color\": \"white\"}');
/*!40000 ALTER TABLE `items` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-09-15 13:57:46
