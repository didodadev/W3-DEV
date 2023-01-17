<cf_wrk_grid search_header = "#getLang('settings',132)#" table_name="SETUP_PARTNER_DEPARTMENT" sort_column="PARTNER_DEPARTMENT" u_id="PARTNER_DEPARTMENT_ID" datasource="#dsn#" search_areas = "PARTNER_DEPARTMENT,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="PARTNER_DEPARTMENT" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
