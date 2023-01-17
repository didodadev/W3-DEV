<cf_wrk_grid search_header = "#getLang('settings',111)#" table_name="SETUP_MOBILCAT" sort_column="MOBILCAT" u_id="MOBILCAT_ID" datasource="#dsn#" search_areas = "MOBILCAT">
    <cf_wrk_grid_column name="MOBILCAT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="MOBILCAT" header="#getLang('settings',386)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
