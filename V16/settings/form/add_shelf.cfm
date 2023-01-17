<cf_wrk_grid search_header = "#getLang('settings',174)#" table_name="SHELF" sort_column="SHELF_NAME" u_id="SHELF_MAIN_ID" datasource="#dsn#" search_areas = "SHELF_NAME" dictionary_count="2">
    <cf_wrk_grid_column name="SHELF_MAIN_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="SHELF_ID" header="#getLang('main',75)#" select="yes" type="numeric" display="yes"/>
    <cf_wrk_grid_column name="SHELF_NAME" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
