<cf_wrk_grid search_header = "#getLang('settings',1202)#" table_name="SETUP_PROD_RETURN_CATS" sort_column="RETURN_CAT" u_id="RETURN_CAT_ID" datasource="#dsn3#" search_areas = "RETURN_CAT">
    <cf_wrk_grid_column name="RETURN_CAT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="RETURN_CAT" header="#getLang('main',68)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
