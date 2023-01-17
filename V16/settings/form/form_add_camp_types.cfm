<cf_wrk_grid search_header = "#getLang('settings',918)#" table_name="CAMPAIGN_TYPES" sort_column="CAMP_TYPE" u_id="CAMP_TYPE_ID" datasource="#dsn3#" search_areas = "CAMP_TYPE">
    <cf_wrk_grid_column name="CAMP_TYPE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="CAMP_TYPE" header="#getLang('main',68)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
