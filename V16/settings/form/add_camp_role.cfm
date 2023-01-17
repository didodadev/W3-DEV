<cf_wrk_grid search_header = "#getLang('settings',31)#" table_name="SETUP_CAMPAIGN_ROLES" sort_column="CAMPAIGN_ROLE" u_id="CAMPAIGN_ROLE_ID" datasource="#dsn3#" search_areas = "CAMPAIGN_ROLE,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="CAMPAIGN_ROLE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="CAMPAIGN_ROLE" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
