<cf_wrk_grid search_header = "#getLang('settings',62)#" table_name="SETUP_ACTION_STAGES" sort_column="STAGE_NAME" u_id="STAGE_ID" datasource="#dsn#" search_areas = "STAGE_NAME,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="STAGE_ID" header="#getLang('main',1165)#" display="no" select="yes"/>
    <cf_wrk_grid_column name="STAGE_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" width="400" header="#getLang('main',217)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/>
</cf_wrk_grid>
