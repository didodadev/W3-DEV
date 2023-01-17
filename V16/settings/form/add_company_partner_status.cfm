<cf_wrk_grid search_header = "#getLang('settings',1279)#" table_name="COMPANY_PARTNER_STATUS" sort_column="STATUS_NAME" u_id="CPS_ID" datasource="#dsn#" search_areas = "STATUS_NAME">
    <cf_wrk_grid_column name="CPS_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="STATUS_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>	



