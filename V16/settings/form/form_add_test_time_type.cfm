<cf_wrk_grid search_header = "#getLang(dictionary_id:61263)#" table_name="EMPLOYEES_TEST_TIME_TYPE" sort_column="TEST_TIME_TYPE_NAME" u_id="EMPLOYEES_TEST_TIME_TYPE_ID" datasource="#dsn#" search_areas = "TEST_TIME_TYPE_NAME" dictionary_count="2">
    <cf_wrk_grid_column name="EMPLOYEES_TEST_TIME_TYPE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="TEST_TIME_TYPE_NAME" header="#getLang(dictionary_id : 38573)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>