<cfquery name="upd" datasource="#dsn3#">
    alter table POS_EQUIPMENT
    add EQUIPMENT_CODE nvarchar(100)

    alter table POS_EQUIPMENT
    add PATH nvarchar(200)

    alter table POS_EQUIPMENT
    add OFFLINE_PATH nvarchar(200)

    alter table POS_EQUIPMENT
    add FILENAME nvarchar(200)

    alter table POS_EQUIPMENT
    add TYPE nvarchar(200)

    alter table POS_EQUIPMENT
    add SERIAL_NUMBER nvarchar(200)

    alter table POS_EQUIPMENT
    add MALI_NO nvarchar(200)
</cfquery>
<cfinclude template="../fbx_workcube_funcs.cfm">
<cfsetting requesttimeout="1000">
<cfparam name="attributes.main_dsn" default = "" />
<cfset attributes.dsn = dsn>
<cfquery name="addLogin" datasource="_#attributes.dsn#">
    CREATE LOGIN #attributes.dsn#_retail WITH PASSWORD = '#attributes.password#' 
</cfquery>
<cfquery name="addSchema" datasource="#attributes.dsn#">
    CREATE SCHEMA #attributes.dsn#_retail
</cfquery>
<cfquery name="addUser" datasource="#attributes.dsn#">
    CREATE USER [#attributes.dsn#_retail] FOR LOGIN [#attributes.dsn#_retail] WITH DEFAULT_SCHEMA=[#attributes.dsn#_retail]
    ALTER ROLE [db_owner] ADD MEMBER [#attributes.dsn#_retail]
</cfquery>
<cfset new_dsn = ( len( attributes.main_dsn ) ) ? attributes.main_dsn : attributes.dsn />
<cf_add_dsn_mssql dsn="#attributes.dsn#_retail" db="#new_dsn#" host="#attributes.host#" username="#attributes.dsn#_retail" password="#attributes.password#">
