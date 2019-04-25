DROP PROCEDURE DROPEXISTINGTABLE;;
CREATE PROCEDURE DROPEXISTINGTABLE
( 	IN TABLENAME VARCHAR(50),
	IN SCHEMANAME VARCHAR(50)
) LANGUAGE SQLSCRIPT AS MYROWID INTEGER;
BEGIN
MYROWID := 0;
SELECT COUNT(*) INTO MYROWID FROM TABLES WHERE SCHEMA_NAME =:SCHEMANAME and TABLE_NAME=:TABLENAME;
IF (:MYROWID > 0 ) THEN
	EXEC 'DROP TABLE '||:SCHEMANAME||'."'||:TABLENAME||'"';
END IF;
END;;

DROP PROCEDURE DROPEXISTINGPROCEDURE;;
CREATE PROCEDURE DROPEXISTINGPROCEDURE
( 	IN PROCEDURENAME VARCHAR(50),
	IN SCHEMANAME VARCHAR(50)
) LANGUAGE SQLSCRIPT AS MYROWID INTEGER;
BEGIN
MYROWID := 0;
SELECT COUNT(*) INTO MYROWID FROM PROCEDURES WHERE SCHEMA_NAME =:SCHEMANAME and PROCEDURE_NAME=:PROCEDURENAME;
IF (:MYROWID > 0 ) THEN
	EXEC 'DROP PROCEDURE '||:SCHEMANAME||'."'||:PROCEDURENAME||'"';
END IF;
END;;

DROP PROCEDURE DROPEXISTINGFUNCTION;;
CREATE PROCEDURE DROPEXISTINGFUNCTION
( 	IN FUNCTIONNAME VARCHAR(50),
	IN SCHEMANAME VARCHAR(50)
) LANGUAGE SQLSCRIPT AS MYROWID INTEGER;
BEGIN
MYROWID := 0;
SELECT COUNT(*) INTO MYROWID FROM FUNCTIONS WHERE SCHEMA_NAME =:SCHEMANAME and FUNCTION_NAME=:FUNCTIONNAME;
IF (:MYROWID > 0 ) THEN
	EXEC 'DROP FUNCTION '||:SCHEMANAME||'."'||:FUNCTIONNAME||'"';
END IF;
END;;

DROP PROCEDURE DROPEXISTINGVIEW;;
CREATE PROCEDURE DROPEXISTINGVIEW
( 	IN VIEWNAME VARCHAR(50),
	IN SCHEMANAME VARCHAR(50)
) LANGUAGE SQLSCRIPT AS MYROWID INTEGER;
BEGIN
MYROWID := 0;
SELECT COUNT(*) INTO MYROWID FROM VIEWS WHERE SCHEMA_NAME =:SCHEMANAME and VIEW_NAME=:VIEWNAME;
IF (:MYROWID > 0 ) THEN
	EXEC 'DROP VIEW '||:SCHEMANAME||'."'||:VIEWNAME||'"';
END IF;
END;;

DROP PROCEDURE DROPCONSTRAINTFROMTABLE;;
CREATE PROCEDURE DROPCONSTRAINTFROMTABLE
( 	IN TABLENAME VARCHAR(50),
	IN CONSTRAINTNAME VARCHAR(100),
	IN SCHEMANAME VARCHAR(50)
) LANGUAGE SQLSCRIPT AS MYROWID INTEGER;
BEGIN
MYROWID := 0;
SELECT COUNT(*) INTO MYROWID FROM TABLES WHERE SCHEMA_NAME =:SCHEMANAME and TABLE_NAME=:TABLENAME;
IF (:MYROWID > 0 ) THEN
	EXEC 'ALTER TABLE '||:SCHEMANAME||'."'||:TABLENAME||'" DROP CONSTRAINT "' || :CONSTRAINTNAME ||'"';
END IF;
END;;


CALL DROPEXISTINGTABLE('InheritanceParent', CURRENT_SCHEMA);;

CREATE TABLE "InheritanceParent"
(
	"InheritanceParentId" INTEGER        NOT NULL,
	"TypeDiscriminator"   INTEGER            NULL,
	"Name"                NVARCHAR(50)       NULL,

	PRIMARY KEY ("InheritanceParentId")
);;

CALL DROPEXISTINGTABLE('InheritanceChild', CURRENT_SCHEMA);;

CREATE TABLE "InheritanceChild"
(
	"InheritanceChildId"  INTEGER       NOT NULL,
	"InheritanceParentId" INTEGER       NOT NULL,
	"TypeDiscriminator"   INTEGER           NULL,
	"Name"                NVARCHAR(50)      NULL,

	PRIMARY KEY ("InheritanceChildId")
);;


CALL DROPEXISTINGTABLE('Doctor', CURRENT_SCHEMA);;
CALL DROPEXISTINGTABLE('Patient', CURRENT_SCHEMA);;
CALL DROPEXISTINGTABLE('Person', CURRENT_SCHEMA);;

CREATE COLUMN TABLE "Person" (
	"PersonID" INTEGER CS_INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	 "FirstName" NVARCHAR(50) NOT NULL ,
	 "LastName" NVARCHAR(50) NOT NULL ,
	 "MiddleName" NVARCHAR(50) NULL ,
	 "Gender" CHAR(1) NOT NULL ,
	 PRIMARY KEY ("PersonID")
);;

INSERT INTO "Person"("FirstName","LastName","Gender") VALUES ('John',   'Pupkin',    'M');;
INSERT INTO "Person"("FirstName","LastName","Gender") VALUES ('Tester', 'Testerson', 'M');;
INSERT INTO "Person"("FirstName","LastName","Gender") VALUES ('Jane',   'Doe',       'F');;
INSERT INTO "Person"("FirstName","LastName","MiddleName","Gender") VALUES ('Jürgen', 'König', 'Ko', 'M');;


CREATE COLUMN TABLE "Doctor"
(
	"PersonID" INTEGER NOT NULL,
	"Taxonomy" nvarchar(50) NOT NULL,
	PRIMARY KEY ("PersonID")
);;
ALTER TABLE "Doctor" ADD CONSTRAINT "FK_Doctor_Person" FOREIGN KEY ("PersonID") REFERENCES "Person" ("PersonID") ON UPDATE CASCADE ON DELETE CASCADE;;

INSERT INTO "Doctor" ("PersonID", "Taxonomy") VALUES (1, 'Psychiatry');;

CREATE COLUMN TABLE "Patient"
(
	"PersonID" INTEGER NOT NULL,
	"Diagnosis" NVARCHAR(256) NOT NULL,
	PRIMARY KEY ("PersonID")
);;
ALTER TABLE "Patient" ADD CONSTRAINT "FK_Patient_Person" FOREIGN KEY ("PersonID") REFERENCES "Person" ("PersonID") ON UPDATE CASCADE ON DELETE CASCADE;;

INSERT INTO "Patient" ("PersonID", "Diagnosis") VALUES (2, 'Hallucination with Paranoid Bugs'' Delirium of Persecution');;


CALL DROPEXISTINGPROCEDURE('Person_SelectByKey', CURRENT_SCHEMA);;

CREATE PROCEDURE "Person_SelectByKey"
( IN ID INTEGER
) LANGUAGE SQLSCRIPT AS
BEGIN
	SELECT * FROM "Person" WHERE "PersonID" = :ID;
END;;

CALL DROPEXISTINGPROCEDURE('Person_SelectAll', CURRENT_SCHEMA);;

CREATE PROCEDURE "Person_SelectAll"
(
) LANGUAGE SQLSCRIPT AS
BEGIN
	SELECT * FROM "Person";
END;;

CALL DROPEXISTINGPROCEDURE('Person_SelectByName', CURRENT_SCHEMA);;

CREATE PROCEDURE "Person_SelectByName"
(
	IN FirstName NVARCHAR(50),
	IN LastName NVARCHAR(50)
) LANGUAGE SQLSCRIPT AS
BEGIN
	SELECT * FROM "Person" WHERE "FirstName" = :FirstName AND "LastName" = :LastName;
END;;

CALL DROPEXISTINGPROCEDURE('Person_SelectListByName', CURRENT_SCHEMA);;

CREATE PROCEDURE "Person_SelectListByName"
(
	IN FirstName NVARCHAR(50),
	IN LastName NVARCHAR(50)
) LANGUAGE SQLSCRIPT AS
BEGIN
	SELECT * FROM "Person" WHERE "FirstName" LIKE :FirstName AND "LastName" LIKE :LastName;
END;;

CALL DROPEXISTINGPROCEDURE('Person_Insert', CURRENT_SCHEMA);;

CREATE PROCEDURE "Person_Insert"
(
	IN FirstName NVARCHAR(50),
	IN LastName NVARCHAR(50),
	IN MiddleName NVARCHAR(50),
	IN Gender CHAR(1)
) LANGUAGE SQLSCRIPT AS
BEGIN
	INSERT INTO "Person"("LastName", "FirstName", "MiddleName", "Gender")
	VALUES (:LastName, :FirstName, :MiddleName, :Gender);
END;;

CALL DROPEXISTINGPROCEDURE('Person_Insert_OutputParameter', CURRENT_SCHEMA);;

CREATE PROCEDURE "Person_Insert_OutputParameter"
(
	IN FirstName NVARCHAR(50),
	IN LastName NVARCHAR(50),
	IN MiddleName NVARCHAR(50),
	IN Gender CHAR(1),
	OUT PersonID INTEGER
) LANGUAGE SQLSCRIPT AS
BEGIN
	INSERT INTO "Person"("LastName", "FirstName", "MiddleName", "Gender")
	VALUES (:LastName, :FirstName, :MiddleName, :Gender);

	SELECT MAX("PersonID") INTO PersonID FROM "Person";
END;;

CALL DROPEXISTINGPROCEDURE('Person_Update', CURRENT_SCHEMA);;

CREATE PROCEDURE "Person_Update"
(	IN PersonID INTEGER,
	IN FirstName NVARCHAR(50),
	IN LastName NVARCHAR(50),
	IN MiddleName NVARCHAR(50),
	IN Gender CHAR(1)
) LANGUAGE SQLSCRIPT AS
BEGIN
	UPDATE "Person"
	SET
		"FirstName" = :FirstName,
		"LastName" = :LastName,
		"MiddleName" = :MiddleName,
		"Gender" = :Gender
	WHERE
		"PersonID" = :PersonID;
END;;

CALL DROPEXISTINGPROCEDURE('Person_Delete', CURRENT_SCHEMA);;

CREATE PROCEDURE "Person_Delete"
(	IN PersonID INTEGER
) LANGUAGE SQLSCRIPT AS
BEGIN
	DELETE FROM "Person" WHERE "PersonID" = :PersonID;
END;;


CALL DROPEXISTINGPROCEDURE('Patient_SelectAll', CURRENT_SCHEMA);;

CREATE PROCEDURE "Patient_SelectAll"
(
) LANGUAGE SQLSCRIPT AS
BEGIN
	SELECT "Person".*, "Patient"."Diagnosis"
	FROM "Person", "Patient"
	WHERE
		"Person"."PersonID" = "Patient"."PersonID";
END;;

CALL DROPEXISTINGPROCEDURE('Patient_SelectByName', CURRENT_SCHEMA);;

CREATE PROCEDURE "Patient_SelectByName"
(
	IN FirstName NVARCHAR(50),
	IN LastName NVARCHAR(50)
) LANGUAGE SQLSCRIPT AS
BEGIN
	SELECT "Person".*, "Patient"."Diagnosis"
	FROM "Person", "Patient"
	WHERE
		"Person"."PersonID" = "Patient"."PersonID"
		AND "FirstName" = :FirstName AND "LastName" = :LastName;
END;;


CALL DROPEXISTINGPROCEDURE('OutRefTest', CURRENT_SCHEMA);;

CREATE PROCEDURE "OutRefTest"
(
	IN	ID             INTEGER,
	OUT	outputID       INTEGER,
	INOUT	inputOutputID  INTEGER,
	IN str            VARCHAR(50),
	OUT outputStr      VARCHAR(50),
	INOUT inputOutputStr VARCHAR(50)
) LANGUAGE SQLSCRIPT AS
BEGIN
	outputID := ID;
	inputOutputID := ID + inputOutputID;
	outputStr := str;
	inputOutputStr := str || inputOutputStr;
END;;

CALL DROPEXISTINGPROCEDURE('OutRefEnumTest', CURRENT_SCHEMA);;

CREATE PROCEDURE "OutRefEnumTest"
(
	IN str            VARCHAR(50),
	OUT outputStr      VARCHAR(50),
	INOUT inputOutputStr VARCHAR(50)
) LANGUAGE SQLSCRIPT AS
BEGIN
	outputStr := str;
	inputOutputStr := str || inputOutputStr;
END;;

CALL DROPEXISTINGTABLE('AllTypes', CURRENT_SCHEMA);;

CREATE COLUMN TABLE "AllTypes"
(
	ID INTEGER CS_INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	"bigintDataType" BIGINT NULL,
	"smallintDataType" SMALLINT NULL,
	"decimalDataType" DECIMAL NULL,
	"smalldecimalDataType" SMALLDECIMAL NULL,
	"intDataType" INTEGER NULL,
	"tinyintDataType" TINYINT NULL,
	"floatDataType" FLOAT NULL,
	"realDataType" REAL NULL,

	"dateDataType" DATE NULL,
	"timeDataType" TIME NULL,
	"seconddateDataType" SECONDDATE NULL,
	"timestampDataType" TIMESTAMP NULL,

	"charDataType" CHAR(1) NULL,
	"char20DataType" CHAR(20) NULL,
	"varcharDataType" VARCHAR(20) NULL,
	"textDataType" TEXT NULL,
	"shorttextDataType" SHORTTEXT(20) NULL,
	"ncharDataType" NCHAR(1) NULL,
	"nchar20DataType" NCHAR(20) NULL,
	"nvarcharDataType" NVARCHAR(20) NULL,
	"alphanumDataType" ALPHANUM(20) NULL,

	"binaryDataType" BINARY(10) NULL,
	"varbinaryDataType" VARBINARY(10) NULL,

	"blobDataType" BLOB NULL,
	"clobDataType" CLOB NULL,
	"nclobDataType" NCLOB NULL,
	PRIMARY KEY ("ID")
);;


INSERT INTO "AllTypes"
(
	"bigintDataType", "smallintDataType", "decimalDataType", "smalldecimalDataType", "intDataType", "tinyintDataType", "floatDataType", "realDataType",
	"dateDataType", "timeDataType", "seconddateDataType", "timestampDataType",
	"charDataType", "varcharDataType", "textDataType", "shorttextDataType", "ncharDataType", "nvarcharDataType", "alphanumDataType",
	"binaryDataType", "varbinaryDataType",
	"blobDataType", "clobDataType", "nclobDataType"
) VALUES(
	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL,
	NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	NULL, NULL,
	NULL, NULL,  NULL);;

INSERT INTO "AllTypes"
(
	"bigintDataType", "smallintDataType", "decimalDataType", "smalldecimalDataType", "intDataType", "tinyintDataType", "floatDataType", "realDataType",
	"dateDataType", "timeDataType", "seconddateDataType", "timestampDataType",
	"charDataType", "varcharDataType", "textDataType", "shorttextDataType", "ncharDataType", "nvarcharDataType", "alphanumDataType",
	"binaryDataType", "varbinaryDataType",
	"blobDataType", "clobDataType", "nclobDataType"
) VALUES(
	123456789123456789, 12345, 1234.567, 123.456, 123456789, 123, 1234.567, 1234.567,
	'2012-12-12', '12:12:12', '2012-12-12 12:12:12', '2012-12-12 12:12:12.123',
	'1', 'bcd', 'abcdefgh', 'def', 'ą',  'ąčęėįš', 'qwert123QWE',
	CAST( 'abcdefgh' AS BINARY), CAST( 'abcdefgh' AS VARBINARY),
	'abcdefgh', 'qwertyuiop', 'ąčęėįšqwerty123456' );;

CALL DROPEXISTINGTABLE('AllTypesGeo', CURRENT_SCHEMA);;

CREATE COLUMN TABLE "AllTypesGeo"
(
	ID INTEGER CS_INT NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	"dataType" varchar(20) NULL,
	"stgeometryDataType" ST_GEOMETRY NULL,
	PRIMARY KEY ("ID")
);;

INSERT INTO "AllTypesGeo" ("dataType", "stgeometryDataType")
VALUES (NULL, NULL);;
INSERT INTO "AllTypesGeo" ("dataType", "stgeometryDataType")
VALUES ('POINT', NEW ST_POINT('POINT(0.0 0.0)'));;
INSERT INTO "AllTypesGeo" ("dataType", "stgeometryDataType")
VALUES ('POLYGON', NEW ST_POLYGON('POLYGON((6.0 7.0, 10.0 3.0, 10.0 10.0, 6.0 7.0))'));;
INSERT INTO "AllTypesGeo" ("dataType", "stgeometryDataType")
VALUES ('LINESTRING', NEW ST_LINESTRING('LINESTRING(3.0 3.0, 5.0 4.0, 6.0 3.0)'));;
INSERT INTO "AllTypesGeo" ("dataType", "stgeometryDataType")
VALUES ('MULTIPOINT', NEW ST_MULTIPOINT('MultiPoint ((10 10), (12 12), (14 10))'));;
INSERT INTO "AllTypesGeo" ("dataType", "stgeometryDataType")
VALUES ('MULTIPOLYGON', NEW ST_MultiPolygon('MultiPolygon (((-5 -5, 5 -5, 0 5, -5 -5), (-2 -2, -2 0, 2 0, 2 -2, -2 -2)), ((10 -5, 15 5, 5 5, 10 -5)))'));;
INSERT INTO "AllTypesGeo" ("dataType", "stgeometryDataType")
VALUES ('MULTILINESTRING', NEW ST_MultiLineString('MultiLineString ((10 10, 12 12), (14 10, 16 12))'));;

CALL DROPEXISTINGTABLE('Parent',CURRENT_SCHEMA);;
CALL DROPEXISTINGTABLE('Child',CURRENT_SCHEMA);;
CALL DROPEXISTINGTABLE('GrandChild',CURRENT_SCHEMA);;

CREATE COLUMN TABLE "Parent" (
	"ParentID" INTEGER,
	"Value1" INTEGER
);;

CREATE COLUMN TABLE "Child" (
	"ParentID" INTEGER,
	"ChildID" INTEGER
);;

CREATE COLUMN TABLE "GrandChild" (
	"ParentID" INTEGER,
	"ChildID" INTEGER,
	"GrandChildID" INTEGER
);;

CALL DROPEXISTINGFUNCTION('GetParentByID', CURRENT_SCHEMA);;

CREATE FUNCTION "GetParentByID"
(
	id INTEGER
)
RETURNS TABLE(
	"ParentID" INTEGER,
	"Value1" INTEGER
)
LANGUAGE SQLSCRIPT
SQL SECURITY INVOKER AS
BEGIN
	RETURN
	SELECT * FROM "Parent" WHERE "ParentID" = :id;
END;;

CALL DROPEXISTINGVIEW('ParentView', CURRENT_SCHEMA);;

CREATE VIEW "ParentView"
AS
	SELECT * FROM "Parent";;

CALL DROPEXISTINGVIEW('ParentChildView', CURRENT_SCHEMA);;

CREATE VIEW "ParentChildView"
AS
	SELECT
		p."ParentID",
		p."Value1",
		ch."ChildID"
	FROM "Parent" p
		LEFT JOIN "Child" ch ON p."ParentID" = ch."ParentID";;

CALL DROPEXISTINGPROCEDURE('SelectImplicitColumn', CURRENT_SCHEMA);;

CREATE PROCEDURE "SelectImplicitColumn"
(
) LANGUAGE SQLSCRIPT AS
BEGIN
	SELECT 123 FROM DUMMY;
END;;

CALL DROPEXISTINGTABLE('LinqDataTypes', CURRENT_SCHEMA);;

CREATE COLUMN TABLE "LinqDataTypes"
(
	"ID" INTEGER,
	"MoneyValue" DECIMAL(10,4),
	"DateTimeValue" TIMESTAMP,
	"DateTimeValue2" TIMESTAMP,
	"BoolValue" TINYINT,
	"GuidValue" VARCHAR(36),
	"BinaryValue" VARBINARY(5000) NULL,
	"SmallIntValue" SMALLINT,
	"IntValue" INTEGER NULL,
	"BigIntValue" BIGINT NULL,
	"StringValue" NVARCHAR(50) NULL
);;

CALL DROPEXISTINGTABLE('BulkInsertLowerCaseColumns', CURRENT_SCHEMA);;

CREATE COLUMN TABLE "BulkInsertLowerCaseColumns"
(
	"ID" INTEGER,
	"MoneyValue" DECIMAL(10,4),
	"DateTimeValue" TIMESTAMP,
	"BoolValue" TINYINT,
	"GuidValue" VARCHAR(36),
	"BinaryValue" VARBINARY(5000) NULL,
	"SmallIntValue" SMALLINT,
	"IntValue" INTEGER NULL,
	"BigIntValue" BIGINT NULL
);;

CALL DROPEXISTINGTABLE('BulkInsertUpperCaseColumns', CURRENT_SCHEMA);;

CREATE COLUMN TABLE "BulkInsertUpperCaseColumns"
(
	"ID" INTEGER,
	"MONEYVALUE" DECIMAL(10,4),
	"DATETIMEVALUE" TIMESTAMP,
	"BOOLVALUE" TINYINT,
	"GUIDVALUE" VARCHAR(36),
	"BINARYVALUE" VARBINARY(5000) NULL,
	"SMALLINTVALUE" SMALLINT,
	"INTVALUE" INTEGER NULL,
	"BIGINTVALUE" BIGINT NULL
);;

CALL DROPEXISTINGPROCEDURE('DuplicateColumnNames', CURRENT_SCHEMA);;

CREATE PROCEDURE "DuplicateColumnNames"
(
) LANGUAGE SQLSCRIPT AS
BEGIN
	SELECT 123 as "id", '456' as "id" FROM DUMMY;
END;;

CALL DROPEXISTINGTABLE('TestIdentity',CURRENT_SCHEMA);;

CREATE COLUMN TABLE "TestIdentity" (
	"ID" INTEGER NOT NULL GENERATED BY DEFAULT AS IDENTITY,
	PRIMARY KEY ("ID")
);;


CALL DROPCONSTRAINTFROMTABLE('IndexTable2', 'FK_Patient2_IndexTable', CURRENT_SCHEMA);;
CALL DROPEXISTINGTABLE('IndexTable',CURRENT_SCHEMA);;


CREATE COLUMN TABLE "IndexTable" (
	"PKField1" INTEGER NOT NULL,
	"PKField2" INTEGER NOT NULL,
	"UniqueField" INTEGER NOT NULL,
	"IndexField" INTEGER NOT NULL,
	PRIMARY KEY ("PKField1", "PKField2")
);;
CREATE UNIQUE INDEX "IX_IndexTable" ON "IndexTable"("UniqueField");;

CALL DROPEXISTINGTABLE('IndexTable2',CURRENT_SCHEMA);;

CREATE COLUMN TABLE "IndexTable2" (
	"PKField1" INTEGER NOT NULL,
	"PKField2" INTEGER NOT NULL,
	PRIMARY KEY ("PKField1", "PKField2")
);;
ALTER TABLE "IndexTable2" ADD CONSTRAINT "FK_Patient2_IndexTable" FOREIGN KEY ("PKField1", "PKField2") REFERENCES "IndexTable" ("PKField1", "PKField2") ON UPDATE CASCADE ON DELETE CASCADE;;

CALL DROPEXISTINGTABLE('TestMerge1', CURRENT_SCHEMA);;

CALL DROPEXISTINGTABLE('TestMerge2', CURRENT_SCHEMA);;

CREATE TABLE "TestMerge1"
(
	"Id"       INTEGER        NOT NULL,
	"Field1"   INTEGER            NULL,
	"Field2"   INTEGER            NULL,
	"Field3"   INTEGER            NULL,
	"Field4"   INTEGER            NULL,
	"Field5"   INTEGER            NULL,

	"FieldInt64"      BIGINT            NULL,
	"FieldBoolean"    TINYINT           NULL,
	"FieldString"     VARCHAR(20)       NULL,
	"FieldNString"    NVARCHAR(20)      NULL,
	"FieldChar"       CHAR(1)           NULL,
	"FieldNChar"      NCHAR(1)          NULL,
	"FieldFloat"      FLOAT(24)         NULL,
	"FieldDouble"     FLOAT(53)         NULL,
	"FieldDateTime"   DATETIME          NULL,
	"FieldBinary"     VARBINARY(20)     NULL,
	"FieldGuid"       CHAR(36)          NULL,
	"FieldDecimal"    DECIMAL(24, 10)   NULL,
	"FieldDate"       DATE              NULL,
	"FieldTime"       TIME              NULL,
	"FieldEnumString" VARCHAR(20)       NULL,
	"FieldEnumNumber" INT               NULL,

	PRIMARY KEY ("Id")
);;

CREATE TABLE "TestMerge2"
(
	"Id"       INTEGER        NOT NULL,
	"Field1"   INTEGER            NULL,
	"Field2"   INTEGER            NULL,
	"Field3"   INTEGER            NULL,
	"Field4"   INTEGER            NULL,
	"Field5"   INTEGER            NULL,

	"FieldInt64"      BIGINT            NULL,
	"FieldBoolean"    TINYINT           NULL,
	"FieldString"     VARCHAR(20)       NULL,
	"FieldNString"    NVARCHAR(20)      NULL,
	"FieldChar"       CHAR(1)           NULL,
	"FieldNChar"      NCHAR(1)          NULL,
	"FieldFloat"      FLOAT(24)         NULL,
	"FieldDouble"     FLOAT(53)         NULL,
	"FieldDateTime"   DATETIME          NULL,
	"FieldBinary"     VARBINARY(20)     NULL,
	"FieldGuid"       CHAR(36)          NULL,
	"FieldDecimal"    DECIMAL(24, 10)   NULL,
	"FieldDate"       DATE              NULL,
	"FieldTime"       TIME              NULL,
	"FieldEnumString" VARCHAR(20)       NULL,
	"FieldEnumNumber" INT               NULL,

	PRIMARY KEY ("Id")
);;

CALL DROPEXISTINGPROCEDURE('AddIssue792Record', CURRENT_SCHEMA);;

CREATE PROCEDURE "AddIssue792Record"()
LANGUAGE SQLSCRIPT AS
BEGIN
	INSERT INTO "AllTypes"("char20DataType") VALUES('issue792');
END;;

CALL DROPEXISTINGTABLE('prd.global.ecc/CV_MARA', CURRENT_SCHEMA);;

CREATE TABLE "prd.global.ecc/CV_MARA"
(
	"Id" INTEGER        NOT NULL,

	PRIMARY KEY ("Id")
);;

CALL DROPEXISTINGPROCEDURE('prd.global.ecc/CV_MARAproc', CURRENT_SCHEMA);;

CREATE PROCEDURE "prd.global.ecc/CV_MARAproc"()
LANGUAGE SQLSCRIPT AS
BEGIN
	SELECT 123 as "id", '456' as "id" FROM DUMMY;
END;;
