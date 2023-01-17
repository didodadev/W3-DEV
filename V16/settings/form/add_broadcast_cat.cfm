<cf_wrk_grid search_header = "#getLang('settings',562)#" table_name="BROADCAST_CAT" sort_column="BROADCAST_CAT_NAME" u_id="CAT_ID" datasource="#dsn#" search_areas = "BROADCAST_CAT_NAME,BROADCAST_CAT_DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="CAT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="BROADCAST_CAT_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="BROADCAST_CAT_DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
