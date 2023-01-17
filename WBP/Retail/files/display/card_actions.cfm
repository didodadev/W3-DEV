<!---

<cfquery name="GET_GEN" datasource="#DSN_GEN#">
	SELECT TOP 10 * FROM CUSTOMER ORDER BY ID DESC
</cfquery>
<CFDUMP var="#GET_GEN#">
<cfquery name="get_data_type" datasource="#DSN_GEN#">
SELECT
    SAC.IS_IDENTITY,
    SAC.MAX_LENGTH,
    ISC.DATA_TYPE,
    ISC.COLUMN_NAME
FROM
    INFORMATION_SCHEMA.COLUMNS ISC,
    SYS.all_columns SAC,
    SYS.tables ST
WHERE
    ISC.TABLE_NAME = 'CUSTOMER' AND
    SAC.name = ISC.COLUMN_NAME AND
    SAC.object_id = ST.object_id AND
    ST.name = ISC.TABLE_NAME
</cfquery>
<cfdump var="#get_data_type#">



<cfquery name="GET_GEN" datasource="#DSN_GEN#">
	SELECT TOP 10 * FROM CUSTOMER_EXTENSION ORDER BY CREATE_DATE DESC
</cfquery>
<CFDUMP var="#GET_GEN#">
--->

<cfquery name="get_data_type" datasource="#DSN_GEN#">
SELECT
    SAC.IS_IDENTITY,
    SAC.MAX_LENGTH,
    ISC.DATA_TYPE,
    ISC.COLUMN_NAME
FROM
    INFORMATION_SCHEMA.COLUMNS ISC,
    SYS.all_columns SAC,
    SYS.tables ST
WHERE
    ISC.TABLE_NAME = 'CARD' AND
    SAC.name = ISC.COLUMN_NAME AND
    SAC.object_id = ST.object_id AND
    ST.name = ISC.TABLE_NAME
</cfquery>
<cfdump var="#get_data_type#">

<cfquery name="GET_GEN" datasource="#DSN_GEN#">
	SELECT TOP 100 * FROM CARD ORDER BY ID DESC
</cfquery>
<CFDUMP var="#GET_GEN#">