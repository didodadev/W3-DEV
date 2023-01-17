<cf_wrk_grid search_header = "#getLang('settings',191)#" table_name="SETUP_RIVAL_PREFERENCE_REASONS" sort_column="PREFERENCE_REASON" u_id="PREFERENCE_REASON_ID" datasource="#dsn#" search_areas = "PREFERENCE_REASON,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="PREFERENCE_REASON_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="PREFERENCE_REASON" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>


