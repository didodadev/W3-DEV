﻿<cf_wrk_grid search_header = "#getLang('settings',1416)#" table_name="SERVICE_APPCAT_SUB" sort_column="SERVICECAT_SUB" u_id="SERVICECAT_SUB_ID" datasource="#dsn3#" search_areas = "SERVICECAT_SUB" dictionary_count="2">
    <cf_wrk_grid_column name="SERVICECAT_SUB_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="SERVICECAT_SUB" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="SERVICECAT_ID" header="#getLang('main',1939)#" width="200" select="yes" display="yes"/>
	<cf_wrk_grid_column name="IS_INTERNET" header="#getLang('main',1673)# " width="200" type="boolean" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
	<cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('','Güncelleme Tarihi',55055)#" width="130" type="date" select="no" display="yes" mask="date"/>
</cf_wrk_grid>	
