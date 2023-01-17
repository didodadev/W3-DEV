<cf_wrk_grid search_header = "#getLang('settings',1235)#" table_name="SETUP_ACTIVITY" sort_column="ACTIVITY_NAME" u_id="ACTIVITY_ID" datasource="#dsn#" search_areas = "ACTIVITY_NAME">
	<cf_wrk_grid_column name="ACTIVITY_ID" header="#getLang('main',1165)#" display="no" select="yes"/>
    <cf_wrk_grid_column name="ACTIVITY_STATUS" width="50" type="boolean" header="#getLang('main',81)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="ACTIVITY_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="400" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/> 
</cf_wrk_grid>
