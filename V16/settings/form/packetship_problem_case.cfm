<cf_wrk_grid search_header = "#getLang('settings',2779)#" table_name="PACKETSHIP_PROBLEM_CASE" sort_column="PROBLEM_CASE_NAME" u_id="PROBLEM_CASE_ID" datasource="#dsn#" search_areas = "PROBLEM_CASE_NAME">
    <cf_wrk_grid_column name="PROBLEM_CASE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="PROBLEM_CASE_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
