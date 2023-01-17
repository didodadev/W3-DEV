<cf_wrk_grid search_header = "#getLang('','CV Kaynağı',59127)#" dictionary_count="1" table_name="SETUP_CV_SOURCE" sort_column="SOURCE_HEAD" u_id="CV_SOURCE_ID" datasource="#dsn#" search_areas = "SOURCE_HEAD">
	<cf_wrk_grid_column name="CV_SOURCE_ID" header="ID" display="no" select="yes"/>
	<cf_wrk_grid_column name="IS_ACTIVE" header="#getLang('main',81,57493)#" type="boolean" width="100" select="yes" display="yes"/>
	<cf_wrk_grid_column name="SOURCE_HEAD" header="#getLang('main',68,57480)#" width="200" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215,57627)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180,43163)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
