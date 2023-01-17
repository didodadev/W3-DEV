<cf_wrk_grid search_header = "#getLang('settings',1789)#" table_name="SETUP_BLACKLIST_INFO" sort_column="BLACKLIST_INFO_NAME" u_id="BLACKLIST_INFO_ID" datasource="#dsn#" search_areas = "BLACKLIST_INFO_NAME,BLACKLIST_INFO_DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="BLACKLIST_INFO_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="BLACKLIST_INFO_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="BLACKLIST_INFO_DETAIL" width="300" header="#getLang('main',217)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
