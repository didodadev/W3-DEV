﻿<cf_wrk_grid search_header = "#getLang('settings',1487)#" table_name="SETUP_MAIL_WARNING" sort_column="MAIL_CAT" u_id="MAIL_CAT_ID" datasource="#dsn#" search_areas = "MAIL_CAT,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="MAIL_CAT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="MAIL_CAT" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>	