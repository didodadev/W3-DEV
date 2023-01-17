<cf_wrk_grid search_header = "#getLang('settings',1473)#" table_name="SETUP_STOCKBOND_TYPE" sort_column="STOCKBOND_TYPE" u_id="STOCKBOND_TYPE_ID" datasource="#dsn#" search_areas = "STOCKBOND_TYPE,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="STOCKBOND_TYPE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="STOCKBOND_TYPE" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
