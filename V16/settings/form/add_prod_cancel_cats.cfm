<cf_wrk_grid search_header = "#getLang('settings',529)#" table_name="SETUP_PROD_CANCEL_CATS" sort_column="CANCEL_CAT" u_id="CANCEL_CAT_ID" datasource="#dsn3#" search_areas = "CANCEL_CAT">
    <cf_wrk_grid_column name="CANCEL_CAT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="CANCEL_CAT" header="#getLang('main',68)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
