<cf_wrk_grid search_header = "#getLang('settings',112)#" table_name="MAILLIST_CAT" sort_column="MAILLIST_CAT" u_id="MAILLIST_CAT_ID" datasource="#dsn#" search_areas = "MAILLIST_CAT">
    <cf_wrk_grid_column name="MAILLIST_CAT_ID" header="#getLang('main',1165)#" display="no" select="yes"/>
    <cf_wrk_grid_column name="MAILLIST_CAT_STATUS" width="100" type="boolean" header="#getLang('main',344)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="MAILLIST_CAT" header="#getLang('settings',20)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/> 
</cf_wrk_grid>
