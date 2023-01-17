<cf_wrk_grid search_header = "#getLang('settings',1573)#" table_name="SETUP_COST_TYPE" sort_column="COST_TYPE_NAME" u_id="COST_TYPE_ID" datasource="#dsn#" search_areas = "COST_TYPE_NAME,COST_TYPE_DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="COST_TYPE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="COST_TYPE_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="COST_TYPE_DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
