<cf_wrk_grid search_header = "#getLang('settings',1170)#" table_name="SETUP_DEPARTMENT_NAME" sort_column="DEPARTMENT_NAME" u_id="DEPARTMENT_NAME_ID" datasource="#dsn#" search_areas = "DEPARTMENT_NAME,DETAIL">
    <cf_wrk_grid_column name="DEPARTMENT_NAME_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="DEPARTMENT_NAME" width="300" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="600" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
