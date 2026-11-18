-- MySQL dump 10.13  Distrib 8.4.3, for Win64 (x86_64)
--
-- Host: localhost    Database: sima
-- ------------------------------------------------------
-- Server version	8.4.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `afiliacion`
--

DROP TABLE IF EXISTS `afiliacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `afiliacion` (
  `id_afiliacion` int unsigned NOT NULL AUTO_INCREMENT,
  `id_paciente` int unsigned NOT NULL,
  `id_plan` int unsigned NOT NULL,
  `nro_afiliado` varchar(30) NOT NULL,
  `vigente_desde` date NOT NULL,
  `vigente_hasta` date DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_afiliacion`),
  UNIQUE KEY `uq_afiliacion_plan_numero` (`id_plan`,`nro_afiliado`),
  KEY `fk_afiliacion_paciente` (`id_paciente`),
  CONSTRAINT `fk_afiliacion_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_afiliacion_plan` FOREIGN KEY (`id_plan`) REFERENCES `plan_cobertura` (`id_plan`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_afiliacion_vigencia` CHECK (((`vigente_hasta` is null) or (`vigente_hasta` >= `vigente_desde`)))
) ENGINE=InnoDB AUTO_INCREMENT=201 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `auditoria`
--

DROP TABLE IF EXISTS `auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auditoria` (
  `id_auditoria` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_usuario` int unsigned DEFAULT NULL,
  `tabla_afectada` varchar(64) NOT NULL,
  `id_registro` bigint unsigned NOT NULL,
  `operacion` enum('insert','update','baja_logica','validacion','anulacion') NOT NULL,
  `datos_anteriores` json DEFAULT NULL,
  `datos_nuevos` json DEFAULT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_auditoria`),
  KEY `fk_auditoria_usuario` (`id_usuario`),
  CONSTRAINT `fk_auditoria_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `autorizacion`
--

DROP TABLE IF EXISTS `autorizacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `autorizacion` (
  `id_autorizacion` int unsigned NOT NULL AUTO_INCREMENT,
  `id_orden` int unsigned NOT NULL,
  `id_afiliacion` int unsigned NOT NULL,
  `estado` enum('pendiente','aprobada','rechazada','vencida') NOT NULL DEFAULT 'pendiente',
  `nro_autorizacion` varchar(30) DEFAULT NULL,
  `fecha_solicitud` date NOT NULL DEFAULT (curdate()),
  `fecha_resolucion` date DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  `observaciones` varchar(255) DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_autorizacion`),
  UNIQUE KEY `uq_autorizacion_numero` (`nro_autorizacion`),
  KEY `fk_autorizacion_orden` (`id_orden`),
  KEY `fk_autorizacion_afiliacion` (`id_afiliacion`),
  CONSTRAINT `fk_autorizacion_afiliacion` FOREIGN KEY (`id_afiliacion`) REFERENCES `afiliacion` (`id_afiliacion`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_autorizacion_orden` FOREIGN KEY (`id_orden`) REFERENCES `orden_medica` (`id_orden`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `autorizacion_practica`
--

DROP TABLE IF EXISTS `autorizacion_practica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `autorizacion_practica` (
  `id_autorizacion` int unsigned NOT NULL,
  `id_practica` int unsigned NOT NULL,
  `cantidad_autorizada` tinyint unsigned NOT NULL DEFAULT '1',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_autorizacion`,`id_practica`),
  KEY `fk_autorizacion_practica_practica` (`id_practica`),
  CONSTRAINT `fk_autorizacion_practica_autorizacion` FOREIGN KEY (`id_autorizacion`) REFERENCES `autorizacion` (`id_autorizacion`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_autorizacion_practica_practica` FOREIGN KEY (`id_practica`) REFERENCES `practica` (`id_practica`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_autorizacion_cantidad` CHECK ((`cantidad_autorizada` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `contacto_autorizado`
--

DROP TABLE IF EXISTS `contacto_autorizado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contacto_autorizado` (
  `id_contacto` int unsigned NOT NULL AUTO_INCREMENT,
  `id_paciente` int unsigned NOT NULL,
  `nombre` varchar(60) NOT NULL,
  `apellido` varchar(60) NOT NULL,
  `parentesco` varchar(40) DEFAULT NULL,
  `telefono` varchar(30) NOT NULL,
  `puede_ver_resultados` tinyint(1) NOT NULL DEFAULT '0',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_contacto`),
  KEY `fk_contacto_paciente` (`id_paciente`),
  CONSTRAINT `fk_contacto_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dato_personal`
--

DROP TABLE IF EXISTS `dato_personal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dato_personal` (
  `id_dato_personal` int unsigned NOT NULL AUTO_INCREMENT,
  `dni` varchar(12) NOT NULL,
  `nombre` varchar(60) NOT NULL,
  `apellido` varchar(60) NOT NULL,
  `email` varchar(120) DEFAULT NULL,
  `telefono` varchar(30) DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_dato_personal`),
  UNIQUE KEY `uq_dato_personal_dni` (`dni`)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `disponibilidad_personal`
--

DROP TABLE IF EXISTS `disponibilidad_personal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `disponibilidad_personal` (
  `id_disponibilidad` int unsigned NOT NULL AUTO_INCREMENT,
  `id_personal` int unsigned NOT NULL,
  `dia_semana` tinyint unsigned NOT NULL,
  `hora_desde` time NOT NULL,
  `hora_hasta` time NOT NULL,
  `vigente_desde` date NOT NULL,
  `vigente_hasta` date DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_disponibilidad`),
  KEY `fk_disponibilidad_personal` (`id_personal`),
  CONSTRAINT `fk_disponibilidad_personal` FOREIGN KEY (`id_personal`) REFERENCES `personal` (`id_personal`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_disponibilidad_dia` CHECK ((`dia_semana` between 1 and 7)),
  CONSTRAINT `chk_disponibilidad_horas` CHECK ((`hora_hasta` > `hora_desde`)),
  CONSTRAINT `chk_disponibilidad_vigencia` CHECK (((`vigente_hasta` is null) or (`vigente_hasta` >= `vigente_desde`)))
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `documentacion_orden`
--

DROP TABLE IF EXISTS `documentacion_orden`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `documentacion_orden` (
  `id_documento` int unsigned NOT NULL AUTO_INCREMENT,
  `id_orden` int unsigned NOT NULL,
  `tipo_documento` varchar(50) NOT NULL,
  `referencia_archivo` varchar(255) NOT NULL,
  `estado_validacion` enum('pendiente','validada','rechazada') NOT NULL DEFAULT 'pendiente',
  `fecha_recepcion` date NOT NULL DEFAULT (curdate()),
  `id_usuario_valida` int unsigned DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_documento`),
  KEY `fk_documentacion_orden` (`id_orden`),
  KEY `fk_documentacion_usuario` (`id_usuario_valida`),
  CONSTRAINT `fk_documentacion_orden` FOREIGN KEY (`id_orden`) REFERENCES `orden_medica` (`id_orden`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_documentacion_usuario` FOREIGN KEY (`id_usuario_valida`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `domicilio`
--

DROP TABLE IF EXISTS `domicilio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `domicilio` (
  `id_domicilio` int unsigned NOT NULL AUTO_INCREMENT,
  `id_paciente` int unsigned DEFAULT NULL,
  `calle` varchar(100) NOT NULL,
  `numero` varchar(10) DEFAULT NULL,
  `piso_depto` varchar(10) DEFAULT NULL,
  `localidad` varchar(60) NOT NULL,
  `provincia` varchar(60) NOT NULL DEFAULT 'jujuy',
  `codigo_postal` varchar(10) DEFAULT NULL,
  `es_principal` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_domicilio`),
  KEY `fk_domicilio_paciente` (`id_paciente`),
  CONSTRAINT `fk_domicilio_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `entidad_cobertura`
--

DROP TABLE IF EXISTS `entidad_cobertura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `entidad_cobertura` (
  `id_entidad` int unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `tipo` enum('obra_social','prepaga','otra') NOT NULL,
  `cuit` varchar(13) DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_entidad`),
  UNIQUE KEY `uq_entidad_nombre` (`nombre`),
  UNIQUE KEY `uq_entidad_cuit` (`cuit`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `equipo`
--

DROP TABLE IF EXISTS `equipo`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipo` (
  `id_equipo` int unsigned NOT NULL AUTO_INCREMENT,
  `id_modalidad` smallint unsigned NOT NULL,
  `codigo_inventario` varchar(30) NOT NULL,
  `nro_serie` varchar(50) DEFAULT NULL,
  `nombre` varchar(80) NOT NULL,
  `marca` varchar(60) DEFAULT NULL,
  `modelo` varchar(60) DEFAULT NULL,
  `ubicacion` varchar(120) NOT NULL,
  `estado` enum('operativo','en_mantenimiento','fuera_de_servicio') NOT NULL DEFAULT 'operativo',
  `fecha_alta` date NOT NULL DEFAULT (curdate()),
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_equipo`),
  UNIQUE KEY `uq_equipo_codigo` (`codigo_inventario`),
  UNIQUE KEY `uq_equipo_serie` (`nro_serie`),
  KEY `fk_equipo_modalidad` (`id_modalidad`),
  CONSTRAINT `fk_equipo_modalidad` FOREIGN KEY (`id_modalidad`) REFERENCES `modalidad` (`id_modalidad`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `equipo_practica`
--

DROP TABLE IF EXISTS `equipo_practica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `equipo_practica` (
  `id_equipo` int unsigned NOT NULL,
  `id_practica` int unsigned NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_equipo`,`id_practica`),
  KEY `fk_equipo_practica_practica` (`id_practica`),
  CONSTRAINT `fk_equipo_practica_equipo` FOREIGN KEY (`id_equipo`) REFERENCES `equipo` (`id_equipo`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_equipo_practica_practica` FOREIGN KEY (`id_practica`) REFERENCES `practica` (`id_practica`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `especialidad`
--

DROP TABLE IF EXISTS `especialidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `especialidad` (
  `id_especialidad` smallint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(80) NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_especialidad`),
  UNIQUE KEY `uq_especialidad_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `estudio_realizado`
--

DROP TABLE IF EXISTS `estudio_realizado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estudio_realizado` (
  `id_estudio` int unsigned NOT NULL AUTO_INCREMENT,
  `id_turno` int unsigned NOT NULL,
  `id_practica_realizada` int unsigned NOT NULL,
  `id_personal_responsable` int unsigned NOT NULL,
  `estado` enum('pendiente','en_curso','realizado','pendiente_de_informe','finalizado') NOT NULL DEFAULT 'pendiente',
  `fecha_hora_inicio` datetime DEFAULT NULL,
  `fecha_hora_fin` datetime DEFAULT NULL,
  `observaciones` varchar(255) DEFAULT NULL,
  `creado_por` int unsigned NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_estudio`),
  UNIQUE KEY `uq_estudio_turno` (`id_turno`),
  KEY `fk_estudio_practica` (`id_practica_realizada`),
  KEY `fk_estudio_personal` (`id_personal_responsable`),
  KEY `fk_estudio_creado_por` (`creado_por`),
  CONSTRAINT `fk_estudio_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_estudio_personal` FOREIGN KEY (`id_personal_responsable`) REFERENCES `personal` (`id_personal`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_estudio_practica` FOREIGN KEY (`id_practica_realizada`) REFERENCES `practica` (`id_practica`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_estudio_turno` FOREIGN KEY (`id_turno`) REFERENCES `turno` (`id_turno`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_estudio_fechas` CHECK (((`fecha_hora_fin` is null) or (`fecha_hora_inicio` is null) or (`fecha_hora_fin` >= `fecha_hora_inicio`)))
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `factura`
--

DROP TABLE IF EXISTS `factura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `factura` (
  `id_factura` int unsigned NOT NULL AUTO_INCREMENT,
  `nro_comprobante` varchar(30) NOT NULL,
  `tipo_comprobante` enum('factura','nota_credito','comprobante_interno') NOT NULL,
  `id_factura_origen` int unsigned DEFAULT NULL,
  `id_paciente` int unsigned DEFAULT NULL,
  `id_entidad` int unsigned DEFAULT NULL,
  `fecha_emision` date NOT NULL DEFAULT (curdate()),
  `total` decimal(12,2) NOT NULL,
  `anulada` tinyint(1) NOT NULL DEFAULT '0',
  `creado_por` int unsigned NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_factura`),
  UNIQUE KEY `uq_factura_comprobante` (`nro_comprobante`),
  KEY `fk_factura_origen` (`id_factura_origen`),
  KEY `fk_factura_paciente` (`id_paciente`),
  KEY `fk_factura_entidad` (`id_entidad`),
  KEY `fk_factura_creado_por` (`creado_por`),
  CONSTRAINT `fk_factura_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_factura_entidad` FOREIGN KEY (`id_entidad`) REFERENCES `entidad_cobertura` (`id_entidad`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_factura_origen` FOREIGN KEY (`id_factura_origen`) REFERENCES `factura` (`id_factura`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_factura_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_factura_destinatario` CHECK ((((`id_paciente` is not null) and (`id_entidad` is null)) or ((`id_paciente` is null) and (`id_entidad` is not null)))),
  CONSTRAINT `chk_factura_origen` CHECK ((((`tipo_comprobante` = _utf8mb4'nota_credito') and (`id_factura_origen` is not null)) or ((`tipo_comprobante` <> _utf8mb4'nota_credito') and (`id_factura_origen` is null)))),
  CONSTRAINT `chk_factura_total` CHECK ((`total` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `factura_detalle`
--

DROP TABLE IF EXISTS `factura_detalle`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `factura_detalle` (
  `id_detalle` int unsigned NOT NULL AUTO_INCREMENT,
  `id_factura` int unsigned NOT NULL,
  `id_prestacion` int unsigned NOT NULL,
  `importe` decimal(12,2) NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_detalle`),
  UNIQUE KEY `uq_factura_prestacion` (`id_factura`,`id_prestacion`),
  KEY `fk_detalle_prestacion` (`id_prestacion`),
  CONSTRAINT `fk_detalle_factura` FOREIGN KEY (`id_factura`) REFERENCES `factura` (`id_factura`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_detalle_prestacion` FOREIGN KEY (`id_prestacion`) REFERENCES `prestacion` (`id_prestacion`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_factura_detalle_importe` CHECK ((`importe` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `incidencia_estudio`
--

DROP TABLE IF EXISTS `incidencia_estudio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incidencia_estudio` (
  `id_incidencia` int unsigned NOT NULL AUTO_INCREMENT,
  `id_estudio` int unsigned NOT NULL,
  `tipo` enum('falla_equipo','paciente_no_apto','falta_preparacion','otra') NOT NULL,
  `descripcion` varchar(255) NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `id_usuario` int unsigned NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_incidencia`),
  KEY `fk_incidencia_estudio` (`id_estudio`),
  KEY `fk_incidencia_usuario` (`id_usuario`),
  CONSTRAINT `fk_incidencia_estudio` FOREIGN KEY (`id_estudio`) REFERENCES `estudio_realizado` (`id_estudio`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_incidencia_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `incidente_tecnico`
--

DROP TABLE IF EXISTS `incidente_tecnico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `incidente_tecnico` (
  `id_incidente` int unsigned NOT NULL AUTO_INCREMENT,
  `id_equipo` int unsigned NOT NULL,
  `id_mantenimiento` int unsigned DEFAULT NULL,
  `fecha_hora` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `descripcion` varchar(255) NOT NULL,
  `gravedad` enum('baja','media','alta') NOT NULL DEFAULT 'media',
  `resuelto` tinyint(1) NOT NULL DEFAULT '0',
  `id_usuario` int unsigned NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_incidente`),
  KEY `fk_incidente_equipo` (`id_equipo`),
  KEY `fk_incidente_mantenimiento` (`id_mantenimiento`),
  KEY `fk_incidente_usuario` (`id_usuario`),
  CONSTRAINT `fk_incidente_equipo` FOREIGN KEY (`id_equipo`) REFERENCES `equipo` (`id_equipo`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_incidente_mantenimiento` FOREIGN KEY (`id_mantenimiento`) REFERENCES `mantenimiento` (`id_mantenimiento`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_incidente_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `informe`
--

DROP TABLE IF EXISTS `informe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `informe` (
  `id_informe` int unsigned NOT NULL AUTO_INCREMENT,
  `id_estudio` int unsigned NOT NULL,
  `estado` enum('pendiente','en_elaboracion','validado','disponible') NOT NULL DEFAULT 'pendiente',
  `id_personal_elabora` int unsigned NOT NULL,
  `id_personal_valida` int unsigned DEFAULT NULL,
  `fecha_elaboracion` datetime DEFAULT NULL,
  `fecha_validacion` datetime DEFAULT NULL,
  `fecha_disponible` datetime DEFAULT NULL,
  `creado_por` int unsigned NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_informe`),
  UNIQUE KEY `uq_informe_estudio` (`id_estudio`),
  KEY `fk_informe_elabora` (`id_personal_elabora`),
  KEY `fk_informe_valida` (`id_personal_valida`),
  KEY `fk_informe_creado_por` (`creado_por`),
  CONSTRAINT `fk_informe_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_informe_elabora` FOREIGN KEY (`id_personal_elabora`) REFERENCES `personal` (`id_personal`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_informe_estudio` FOREIGN KEY (`id_estudio`) REFERENCES `estudio_realizado` (`id_estudio`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_informe_valida` FOREIGN KEY (`id_personal_valida`) REFERENCES `personal` (`id_personal`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `informe_version`
--

DROP TABLE IF EXISTS `informe_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `informe_version` (
  `id_version` int unsigned NOT NULL AUTO_INCREMENT,
  `id_informe` int unsigned NOT NULL,
  `nro_version` smallint unsigned NOT NULL,
  `contenido` text NOT NULL,
  `motivo_correccion` varchar(255) DEFAULT NULL,
  `referencia_archivo` varchar(255) DEFAULT NULL,
  `validada` tinyint(1) NOT NULL DEFAULT '0',
  `id_usuario` int unsigned NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_version`),
  UNIQUE KEY `uq_informe_version_numero` (`id_informe`,`nro_version`),
  KEY `fk_version_usuario` (`id_usuario`),
  CONSTRAINT `fk_version_informe` FOREIGN KEY (`id_informe`) REFERENCES `informe` (`id_informe`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_version_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `liquidacion`
--

DROP TABLE IF EXISTS `liquidacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `liquidacion` (
  `id_liquidacion` int unsigned NOT NULL AUTO_INCREMENT,
  `id_entidad` int unsigned NOT NULL,
  `periodo_desde` date NOT NULL,
  `periodo_hasta` date NOT NULL,
  `fecha` date NOT NULL DEFAULT (curdate()),
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_liquidacion`),
  UNIQUE KEY `uq_liquidacion_periodo` (`id_entidad`,`periodo_desde`,`periodo_hasta`),
  CONSTRAINT `fk_liquidacion_entidad` FOREIGN KEY (`id_entidad`) REFERENCES `entidad_cobertura` (`id_entidad`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_liquidacion_periodo` CHECK ((`periodo_hasta` >= `periodo_desde`))
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `mantenimiento`
--

DROP TABLE IF EXISTS `mantenimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mantenimiento` (
  `id_mantenimiento` int unsigned NOT NULL AUTO_INCREMENT,
  `id_equipo` int unsigned NOT NULL,
  `tipo` enum('preventivo','correctivo') NOT NULL,
  `fecha_inicio` datetime NOT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `descripcion` varchar(255) DEFAULT NULL,
  `id_usuario` int unsigned NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_mantenimiento`),
  KEY `fk_mantenimiento_equipo` (`id_equipo`),
  KEY `fk_mantenimiento_usuario` (`id_usuario`),
  CONSTRAINT `fk_mantenimiento_equipo` FOREIGN KEY (`id_equipo`) REFERENCES `equipo` (`id_equipo`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_mantenimiento_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_mantenimiento_fechas` CHECK (((`fecha_fin` is null) or (`fecha_fin` >= `fecha_inicio`)))
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `modalidad`
--

DROP TABLE IF EXISTS `modalidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `modalidad` (
  `id_modalidad` smallint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(60) NOT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_modalidad`),
  UNIQUE KEY `uq_modalidad_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orden_medica`
--

DROP TABLE IF EXISTS `orden_medica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orden_medica` (
  `id_orden` int unsigned NOT NULL AUTO_INCREMENT,
  `id_paciente` int unsigned NOT NULL,
  `id_personal_derivante` int unsigned NOT NULL,
  `id_afiliacion` int unsigned DEFAULT NULL,
  `fecha_solicitud` date NOT NULL,
  `vigente_hasta` date DEFAULT NULL,
  `observaciones_admin` varchar(255) DEFAULT NULL,
  `creado_por` int unsigned NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_orden`),
  KEY `fk_orden_paciente` (`id_paciente`),
  KEY `fk_orden_derivante` (`id_personal_derivante`),
  KEY `fk_orden_afiliacion` (`id_afiliacion`),
  KEY `fk_orden_creado_por` (`creado_por`),
  CONSTRAINT `fk_orden_afiliacion` FOREIGN KEY (`id_afiliacion`) REFERENCES `afiliacion` (`id_afiliacion`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_orden_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_orden_derivante` FOREIGN KEY (`id_personal_derivante`) REFERENCES `personal` (`id_personal`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_orden_paciente` FOREIGN KEY (`id_paciente`) REFERENCES `paciente` (`id_paciente`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_orden_vigencia` CHECK (((`vigente_hasta` is null) or (`vigente_hasta` >= `fecha_solicitud`)))
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orden_practica`
--

DROP TABLE IF EXISTS `orden_practica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orden_practica` (
  `id_orden_practica` int unsigned NOT NULL AUTO_INCREMENT,
  `id_orden` int unsigned NOT NULL,
  `id_practica` int unsigned NOT NULL,
  `cantidad` tinyint unsigned NOT NULL DEFAULT '1',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_orden_practica`),
  UNIQUE KEY `uq_orden_practica` (`id_orden`,`id_practica`),
  KEY `fk_orden_practica_practica` (`id_practica`),
  CONSTRAINT `fk_orden_practica_orden` FOREIGN KEY (`id_orden`) REFERENCES `orden_medica` (`id_orden`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_orden_practica_practica` FOREIGN KEY (`id_practica`) REFERENCES `practica` (`id_practica`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_orden_practica_cantidad` CHECK ((`cantidad` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `paciente`
--

DROP TABLE IF EXISTS `paciente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `paciente` (
  `id_paciente` int unsigned NOT NULL AUTO_INCREMENT,
  `id_dato_personal` int unsigned NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `creado_por` int unsigned NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_paciente`),
  UNIQUE KEY `uq_paciente_dato_personal` (`id_dato_personal`),
  KEY `fk_paciente_creado_por` (`creado_por`),
  CONSTRAINT `fk_paciente_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_paciente_dato_personal` FOREIGN KEY (`id_dato_personal`) REFERENCES `dato_personal` (`id_dato_personal`)
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `pago`
--

DROP TABLE IF EXISTS `pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pago` (
  `id_pago` int unsigned NOT NULL AUTO_INCREMENT,
  `id_factura` int unsigned NOT NULL,
  `medio_pago` enum('efectivo','transferencia','tarjeta','otro') NOT NULL,
  `fecha_pago` date NOT NULL DEFAULT (curdate()),
  `monto` decimal(12,2) NOT NULL,
  `referencia` varchar(60) DEFAULT NULL,
  `creado_por` int unsigned NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_pago`),
  KEY `fk_pago_factura` (`id_factura`),
  KEY `fk_pago_usuario` (`creado_por`),
  CONSTRAINT `fk_pago_factura` FOREIGN KEY (`id_factura`) REFERENCES `factura` (`id_factura`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_pago_usuario` FOREIGN KEY (`creado_por`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_pago_monto` CHECK ((`monto` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `personal`
--

DROP TABLE IF EXISTS `personal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal` (
  `id_personal` int unsigned NOT NULL AUTO_INCREMENT,
  `id_dato_personal` int unsigned NOT NULL,
  `id_domicilio` int unsigned NOT NULL,
  `tipo` enum('derivante','informante','tecnico','administrativo','responsable_operativo') NOT NULL,
  `id_especialidad` smallint unsigned DEFAULT NULL,
  `matricula` varchar(20) DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_personal`),
  UNIQUE KEY `uq_personal_dato_personal` (`id_dato_personal`),
  UNIQUE KEY `uq_personal_domicilio` (`id_domicilio`),
  UNIQUE KEY `uq_personal_matricula` (`matricula`),
  KEY `fk_personal_especialidad` (`id_especialidad`),
  CONSTRAINT `fk_personal_dato_personal` FOREIGN KEY (`id_dato_personal`) REFERENCES `dato_personal` (`id_dato_personal`),
  CONSTRAINT `fk_personal_domicilio` FOREIGN KEY (`id_domicilio`) REFERENCES `domicilio` (`id_domicilio`),
  CONSTRAINT `fk_personal_especialidad` FOREIGN KEY (`id_especialidad`) REFERENCES `especialidad` (`id_especialidad`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `personal_modalidad`
--

DROP TABLE IF EXISTS `personal_modalidad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal_modalidad` (
  `id_personal` int unsigned NOT NULL,
  `id_modalidad` smallint unsigned NOT NULL,
  `puede_realizar` tinyint(1) NOT NULL DEFAULT '0',
  `puede_informar` tinyint(1) NOT NULL DEFAULT '0',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_personal`,`id_modalidad`),
  KEY `fk_personal_modalidad_modalidad` (`id_modalidad`),
  CONSTRAINT `fk_personal_modalidad_modalidad` FOREIGN KEY (`id_modalidad`) REFERENCES `modalidad` (`id_modalidad`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_personal_modalidad_personal` FOREIGN KEY (`id_personal`) REFERENCES `personal` (`id_personal`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_personal_modalidad_capacidad` CHECK (((`puede_realizar` = 1) or (`puede_informar` = 1)))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `plan_cobertura`
--

DROP TABLE IF EXISTS `plan_cobertura`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `plan_cobertura` (
  `id_plan` int unsigned NOT NULL AUTO_INCREMENT,
  `id_entidad` int unsigned NOT NULL,
  `nombre` varchar(80) NOT NULL,
  `condiciones` text,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_plan`),
  UNIQUE KEY `uq_plan_entidad_nombre` (`id_entidad`,`nombre`),
  CONSTRAINT `fk_plan_entidad` FOREIGN KEY (`id_entidad`) REFERENCES `entidad_cobertura` (`id_entidad`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `practica`
--

DROP TABLE IF EXISTS `practica`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `practica` (
  `id_practica` int unsigned NOT NULL AUTO_INCREMENT,
  `codigo` varchar(20) NOT NULL,
  `id_modalidad` smallint unsigned NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `descripcion` text,
  `duracion_min` smallint unsigned NOT NULL,
  `preparacion` text,
  `requiere_autorizacion` tinyint(1) NOT NULL DEFAULT '0',
  `precio_referencia` decimal(12,2) NOT NULL,
  `disponible` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_practica`),
  UNIQUE KEY `uq_practica_codigo` (`codigo`),
  KEY `fk_practica_modalidad` (`id_modalidad`),
  CONSTRAINT `fk_practica_modalidad` FOREIGN KEY (`id_modalidad`) REFERENCES `modalidad` (`id_modalidad`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_practica_duracion` CHECK ((`duracion_min` > 0)),
  CONSTRAINT `chk_practica_precio` CHECK ((`precio_referencia` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prestacion`
--

DROP TABLE IF EXISTS `prestacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prestacion` (
  `id_prestacion` int unsigned NOT NULL AUTO_INCREMENT,
  `id_estudio` int unsigned NOT NULL,
  `id_afiliacion` int unsigned DEFAULT NULL,
  `id_autorizacion` int unsigned DEFAULT NULL,
  `importe` decimal(12,2) NOT NULL,
  `estado` enum('pendiente_facturacion','facturada','liquidada','anulada') NOT NULL DEFAULT 'pendiente_facturacion',
  `id_liquidacion` int unsigned DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_prestacion`),
  UNIQUE KEY `uq_prestacion_estudio` (`id_estudio`),
  KEY `fk_prestacion_afiliacion` (`id_afiliacion`),
  KEY `fk_prestacion_autorizacion` (`id_autorizacion`),
  KEY `fk_prestacion_liquidacion` (`id_liquidacion`),
  CONSTRAINT `fk_prestacion_afiliacion` FOREIGN KEY (`id_afiliacion`) REFERENCES `afiliacion` (`id_afiliacion`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_prestacion_autorizacion` FOREIGN KEY (`id_autorizacion`) REFERENCES `autorizacion` (`id_autorizacion`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_prestacion_estudio` FOREIGN KEY (`id_estudio`) REFERENCES `estudio_realizado` (`id_estudio`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_prestacion_liquidacion` FOREIGN KEY (`id_liquidacion`) REFERENCES `liquidacion` (`id_liquidacion`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_prestacion_autorizacion` CHECK (((`id_autorizacion` is null) or (`id_afiliacion` is not null))),
  CONSTRAINT `chk_prestacion_importe` CHECK ((`importe` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `registro_acceso`
--

DROP TABLE IF EXISTS `registro_acceso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `registro_acceso` (
  `id_acceso` bigint unsigned NOT NULL AUTO_INCREMENT,
  `id_usuario` int unsigned DEFAULT NULL,
  `tipo_evento` enum('login_ok','login_fallido','logout','consulta_informe','modificacion_informe','validacion_informe','entrega_resultado') NOT NULL,
  `canal` enum('presencial','correo','portal') DEFAULT NULL,
  `id_informe` int unsigned DEFAULT NULL,
  `ip_origen` varchar(45) DEFAULT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_acceso`),
  KEY `fk_acceso_usuario` (`id_usuario`),
  KEY `fk_acceso_informe` (`id_informe`),
  CONSTRAINT `fk_acceso_informe` FOREIGN KEY (`id_informe`) REFERENCES `informe` (`id_informe`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_acceso_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `rol`
--

DROP TABLE IF EXISTS `rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rol` (
  `id_rol` tinyint unsigned NOT NULL AUTO_INCREMENT,
  `nombre` varchar(40) NOT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_rol`),
  UNIQUE KEY `uq_rol_nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `turno`
--

DROP TABLE IF EXISTS `turno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `turno` (
  `id_turno` int unsigned NOT NULL AUTO_INCREMENT,
  `id_orden_practica` int unsigned NOT NULL,
  `id_equipo` int unsigned NOT NULL,
  `id_personal` int unsigned NOT NULL,
  `estado` enum('solicitado','confirmado','atendido','cancelado','ausente','reprogramado') NOT NULL DEFAULT 'solicitado',
  `fecha_hora_inicio` datetime NOT NULL,
  `duracion_min` smallint unsigned NOT NULL,
  `fecha_hora_fin` datetime GENERATED ALWAYS AS ((`fecha_hora_inicio` + interval `duracion_min` minute)) STORED,
  `fecha_cancelacion` datetime DEFAULT NULL,
  `motivo_cancelacion` enum('paciente','profesional','falla_tecnica','cobertura','otro') DEFAULT NULL,
  `id_incidente` int unsigned DEFAULT NULL,
  `creado_por` int unsigned NOT NULL,
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_turno`),
  KEY `fk_turno_orden_practica` (`id_orden_practica`),
  KEY `fk_turno_equipo` (`id_equipo`),
  KEY `fk_turno_personal` (`id_personal`),
  KEY `fk_turno_incidente` (`id_incidente`),
  KEY `fk_turno_creado_por` (`creado_por`),
  CONSTRAINT `fk_turno_creado_por` FOREIGN KEY (`creado_por`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_turno_equipo` FOREIGN KEY (`id_equipo`) REFERENCES `equipo` (`id_equipo`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_turno_incidente` FOREIGN KEY (`id_incidente`) REFERENCES `incidente_tecnico` (`id_incidente`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_turno_orden_practica` FOREIGN KEY (`id_orden_practica`) REFERENCES `orden_practica` (`id_orden_practica`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_turno_personal` FOREIGN KEY (`id_personal`) REFERENCES `personal` (`id_personal`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chk_turno_cancelacion` CHECK ((((`fecha_cancelacion` is null) and (`motivo_cancelacion` is null)) or ((`fecha_cancelacion` is not null) and (`motivo_cancelacion` is not null)))),
  CONSTRAINT `chk_turno_duracion` CHECK ((`duracion_min` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `turno_reprogramacion`
--

DROP TABLE IF EXISTS `turno_reprogramacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `turno_reprogramacion` (
  `id_reprogramacion` int unsigned NOT NULL AUTO_INCREMENT,
  `id_turno` int unsigned NOT NULL,
  `inicio_anterior` datetime NOT NULL,
  `inicio_nuevo` datetime NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `motivo` varchar(200) NOT NULL,
  `id_usuario` int unsigned NOT NULL,
  PRIMARY KEY (`id_reprogramacion`),
  KEY `fk_reprogramacion_turno` (`id_turno`),
  KEY `fk_reprogramacion_usuario` (`id_usuario`),
  CONSTRAINT `fk_reprogramacion_turno` FOREIGN KEY (`id_turno`) REFERENCES `turno` (`id_turno`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_reprogramacion_usuario` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `id_usuario` int unsigned NOT NULL AUTO_INCREMENT,
  `id_personal` int unsigned NOT NULL,
  `id_rol` tinyint unsigned NOT NULL,
  `nombre_usuario` varchar(50) NOT NULL,
  `email` varchar(120) NOT NULL,
  `hash_contrasena` varchar(255) NOT NULL,
  `ultimo_acceso` datetime DEFAULT NULL,
  `intentos_fallidos` tinyint unsigned NOT NULL DEFAULT '0',
  `bloqueado` tinyint(1) NOT NULL DEFAULT '0',
  `fecha_creacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_modificacion` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `fecha_baja` datetime DEFAULT NULL,
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `uq_usuario_personal` (`id_personal`),
  UNIQUE KEY `uq_usuario_nombre` (`nombre_usuario`),
  UNIQUE KEY `uq_usuario_email` (`email`),
  KEY `fk_usuario_rol` (`id_rol`),
  CONSTRAINT `fk_usuario_personal` FOREIGN KEY (`id_personal`) REFERENCES `personal` (`id_personal`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_usuario_rol` FOREIGN KEY (`id_rol`) REFERENCES `rol` (`id_rol`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-11-18 20:14:26
