<cf_wrk_grid search_header = "#getLang('main',1297)#" table_name="SETUP_REQ_TYPE" sort_column="REQ_NAME" u_id="REQ_ID" datasource="#dsn#" search_areas = "REQ_NAME,REQ_DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="REQ_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="REQ_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="REQ_DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
		


