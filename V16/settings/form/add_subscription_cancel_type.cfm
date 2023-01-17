<cf_wrk_grid search_header = "#getLang('settings',945)#" table_name="SETUP_SUBSCRIPTION_CANCEL_TYPE" sort_column="SUBSCRIPTION_CANCEL_TYPE" u_id="SUBSCRIPTION_CANCEL_TYPE_ID" datasource="#dsn3#" search_areas = "HIGH_PART_NAME">
    <cf_wrk_grid_column name="SUBSCRIPTION_CANCEL_TYPE_ID" width="300" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="SUBSCRIPTION_CANCEL_TYPE" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_ACTIVE" header="#getLang('main',1103)#" type="boolean" mask="bit" width="150" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
