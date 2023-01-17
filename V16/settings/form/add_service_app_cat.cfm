<cf_wrk_grid search_header = "#getLang('settings',178)#" table_name="SERVICE_APPCAT" sort_column="SERVICECAT" u_id="SERVICECAT_ID" datasource="#dsn3#" search_areas = "SERVICECAT">
    <cf_wrk_grid_column name="SERVICECAT_ID" header="#getLang('main',1165)#" display="no" select="yes"/>
    <cf_wrk_grid_column name="IS_INTERNET" width="150" type="boolean" header="#getLang('settings',1673)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="SERVICECAT" header="#getLang('settings',20)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/> 
</cf_wrk_grid>

<cfquery name="get_data_type" datasource="#dsn3#">
    SELECT  DISTINCT
        SAC.IS_IDENTITY,
        ISC.DATA_TYPE,
        ISC.COLUMN_NAME,
        ISC.CHARACTER_MAXIMUM_LENGTH
    FROM
        INFORMATION_SCHEMA.COLUMNS ISC,
        SYS.all_columns SAC,
        SYS.tables ST
    WHERE
        ISC.TABLE_NAME = 'SERVICE_APPCAT' AND
        SAC.name = ISC.COLUMN_NAME AND
        SAC.object_id = ST.object_id AND
        ST.name = ISC.TABLE_NAME
</cfquery>