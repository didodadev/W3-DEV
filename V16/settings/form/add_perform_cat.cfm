<cf_wrk_grid search_header = "#getLang('settings',942)#" table_name="SETUP_PERFORM_CATS" sort_column="PERFORM_CAT" u_id="PERFORM_CAT_ID" datasource="#dsn#" search_areas = "PERFORM_CAT">
    <cf_wrk_grid_column name="PERFORM_CAT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="PERFORM_CAT" header="#getLang('main',68)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>





