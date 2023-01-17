<cf_wrk_grid search_header = "#getLang('settings',925)#" table_name="SETUP_ALLOCATE_REASON" sort_column="ALLOCATE_REASON" u_id="REASON_ID" datasource="#dsn#" search_areas = "ALLOCATE_REASON,ALLOCATE_REASON_DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="REASON_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="ALLOCATE_REASON" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="ALLOCATE_REASON_DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
