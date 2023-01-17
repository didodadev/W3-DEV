<cf_wrk_grid search_header = "#getLang('settings',615)#" table_name="SETUP_MAIN_LOCATION_CAT" sort_column="MAIN_LOCATION_CAT" u_id="MAIN_LOCATION_CAT_ID" datasource="#dsn#" search_areas = "MAIN_LOCATION_CAT,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="MAIN_LOCATION_CAT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="MAIN_LOCATION_CAT" width="300" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
