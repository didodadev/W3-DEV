<cf_wrk_grid search_header = "#getLang('settings',710)#" table_name="SETUP_REFERENCE_TYPE" sort_column="REFERENCE_TYPE" u_id="REFERENCE_TYPE_ID" datasource="#dsn#" search_areas = "REFERENCE_TYPE">
    <cf_wrk_grid_column name="REFERENCE_TYPE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="REFERENCE_TYPE" header="#getLang('main',68)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
