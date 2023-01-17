<cf_wrk_grid search_header = "#getLang('settings',237)#" table_name="SETUP_KNOWLEVEL" sort_column="KNOWLEVEL" u_id="KNOWLEVEL_ID" datasource="#dsn#" search_areas = "KNOWLEVEL">
    <cf_wrk_grid_column name="KNOWLEVEL_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="KNOWLEVEL" header="#getLang('main',68)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
