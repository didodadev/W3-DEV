<cf_wrk_grid search_header = "#getLang('settings',1156)#" table_name="SETUP_FAULT_RATIO" sort_column="FAULT_RATIO_NAME" u_id="FAULT_RATIO_ID" datasource="#dsn#" search_areas = "FAULT_RATIO_NAME">
    <cf_wrk_grid_column name="FAULT_RATIO_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="FAULT_RATIO_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
