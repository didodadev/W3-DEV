<cf_wrk_grid search_header = "#getLang('settings',66)#" table_name="ASSET_STATE" sort_column="ASSET_STATE" u_id="ASSET_STATE_ID" datasource="#dsn#" search_areas = "ASSET_STATE,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="ASSET_STATE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="ASSET_STATE" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="400" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
