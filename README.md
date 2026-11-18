# SIMA - Sistema Integral de Gestión Médica

## Base de datos MySQL

### 1. Descripción del proyecto

SIMA (Sistema Integral de Gestión Médica) es un sistema diseñado para administrar y organizar la información de un establecimiento de salud.

La base de datos permite centralizar la información de pacientes, personal, turnos, órdenes médicas, prácticas, estudios, informes y facturación, manteniendo relaciones entre las distintas entidades mediante claves primarias y foráneas.

El proyecto utiliza MySQL como sistema gestor de bases de datos y el motor de almacenamiento InnoDB para garantizar la integridad referencial y la consistencia de las operaciones.

### 2. Tecnologías utilizadas

- **Gestor de base de datos:** MySQL 8.4.
- **Motor de almacenamiento:** InnoDB.
- **Entorno de desarrollo:** Laragon.
- **Administración:** MySQL Workbench.
- **Lenguaje de consultas:** SQL.
- **Codificación:** UTF-8 (utf8mb4).

### 3. Estructura de la base de datos

La base de datos se denomina `sima` y está organizada mediante un modelo relacional.

Sus principales áreas funcionales son:

| Área | Descripción |
|---|---|
| datos_personales | Administración de datos personales. |
| Pacientes | Registro de pacientes del establecimiento. |
| Personal | Administración de profesionales y empleados. |
| Usuarios | Gestión de cuentas y acceso al sistema. |
| Turnos | Organización de agendas y reservas. |
| Órdenes | Gestión de órdenes médicas. |
| Prácticas | Registro de prestaciones y procedimientos. |
| Estudios | Administración de estudios realizados. |
| Informes | Registro de resultados e informes médicos. |
| Facturación | Gestión de comprobantes y movimientos administrativos. |
| Recursos | Administración de equipos y recursos del establecimiento. |
| Auditoría | Seguimiento de operaciones y actividades. |

La estructura contempla relaciones entre las entidades para evitar la duplicación innecesaria de información y mantener la integridad de los registros.

### 4. Modelo de datos

El diseño utiliza claves primarias (PRIMARY KEY), claves foráneas (FOREIGN KEY), restricciones UNIQUE, CHECK y valores predeterminados (DEFAULT), según las necesidades de cada entidad.

Se utiliza una entidad centralizada de datos personales (`dato_personal`), relacionada con los registros de pacientes y personal.

Esta organización permite mantener los datos de identificación en un único lugar y relacionarlos con las entidades correspondientes.

### 5. Instalación de la base de datos

Para instalar la base de datos se necesita tener MySQL instalado y funcionando.

**Paso 1. Crear la base de datos**

```sql
CREATE DATABASE sima CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
```

**Paso 2. Seleccionar la base de datos**

```sql
USE sima;
```

**Paso 3. Importar la estructura**

Desde la terminal:

```bash
mysql -u root -p sima < estructura_sima.sql
```

**Paso 4. Importar los datos de prueba**

Si se dispone de un archivo independiente con los registros:

```bash
mysql -u root -p sima < datos_sima.sql
```

Los archivos SQL deben encontrarse en el directorio desde el cual se ejecutan los comandos o indicar su ruta completa.

### 6. Usuarios y permisos

Para el funcionamiento del sistema se recomienda utilizar cuentas específicas de MySQL, evitando el uso de `root` en las conexiones habituales de la aplicación.

Se contempla la separación de privilegios según las responsabilidades de cada perfil:

- Administrador.
- Personal administrativo.
- Profesional de salud.
- Operador.

Se aplica el principio de mínimo privilegio, limitando el acceso a las operaciones necesarias para cada función.

### 7. Seguridad e integridad

La base de datos contempla diferentes mecanismos para proteger la información:

- Claves primarias para identificar registros.
- Claves foráneas para mantener las relaciones.
- Restricciones UNIQUE para evitar duplicaciones.
- Restricciones CHECK para validar determinados valores.
- Índices para optimizar consultas.
- Motor InnoDB para soportar transacciones e integridad referencial.

A nivel de aplicación se deben complementar estas medidas con autenticación, autorización, hash seguro de contraseñas y consultas preparadas.

El tratamiento de datos personales debe respetar la Ley Nacional N.º 25.326 de Protección de los Datos Personales.

### 8. Respaldo y restauración

Se utiliza `mysqldump` para generar copias de seguridad de la base de datos.

**Exportar estructura y registros:**

```bash
mysqldump -u sima_usuario -p --no-tablespaces sima > sima_completa.sql
```

**Exportar solamente la estructura:**

```bash
mysqldump -u sima_usuario -p --no-data --no-tablespaces sima > estructura_sima.sql
```

**Exportar solamente los registros:**

```bash
mysqldump -u sima_usuario -p --no-create-info --no-tablespaces sima > datos_sima.sql
```

**Restaurar una copia:**

```bash
mysql -u sima_usuario -p sima < sima_completa.sql
```

Se recomienda realizar respaldos periódicos y conservar copias en ubicaciones independientes del servidor principal.

### 9. Verificación

Para comprobar que la instalación se realizó correctamente se pueden ejecutar las siguientes consultas:

```sql
SHOW TABLES;
```

```sql
SELECT VERSION();
```

```sql
SELECT COUNT(*) FROM dato_personal;
```

```sql
SELECT COUNT(*) FROM paciente;
```

```sql
SELECT COUNT(*) FROM personal;
```

También se pueden verificar las relaciones:

```sql
SELECT TABLE_NAME,COLUMN_NAME,REFERENCED_TABLE_NAME,REFERENCED_COLUMN_NAME
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA='sima'
AND REFERENCED_TABLE_NAME IS NOT NULL;
```

### 10. Objetivo académico

El desarrollo de la base de datos SIMA tiene como finalidad aplicar los conocimientos adquiridos en el desarrollo y administración de bases de datos relacionales.

Durante el proyecto se trabajan conceptos de:

- Modelado entidad-relación.
- Normalización de bases de datos.
- Integridad referencial.
- Restricciones y validaciones.
- Índices y optimización.
- Administración de usuarios y privilegios.
- Auditoría.
- Respaldo y recuperación.
- Seguridad de la información.

### 11. Estado del proyecto

Proyecto académico en desarrollo.

La base de datos constituye el componente central para la futura integración con la aplicación de gestión médica SIMA.

---

**SIMA - Sistema Integral de Gestión Médica**  
Proyecto de Base de Datos.