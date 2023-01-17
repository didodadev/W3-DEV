<cf_wrk_grid search_header = "#getLang('settings',957)#" table_name="SETUP_SUBSCRIPTION_ADD_OPTIONS" sort_column="SUBSCRIPTION_ADD_OPTION_NAME" u_id="SUBSCRIPTION_ADD_OPTION_ID" datasource="#dsn3#" search_areas = "SUBSCRIPTION_ADD_OPTION_NAME,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="SUBSCRIPTION_ADD_OPTION_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="SUBSCRIPTION_ADD_OPTION_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
