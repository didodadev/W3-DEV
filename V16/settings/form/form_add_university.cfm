<cf_wrk_grid search_header = "#getLang('settings',1112)#" table_name="SETUP_UNIVERSITY" sort_column="UNIVERSITY_NAME" u_id="UNIVERSITY_ID" datasource="#dsn#" search_areas = "UNIVERSITY_NAME">
    <cf_wrk_grid_column name="UNIVERSITY_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="UNIVERSITY_NAME" header="#getLang('settings',1112)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
</cf_wrk_grid>
