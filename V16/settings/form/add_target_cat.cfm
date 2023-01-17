<cf_wrk_grid search_header = "#getLang('settings',169)#" table_name="TARGET_CAT" sort_column="TARGETCAT_NAME" u_id="TARGETCAT_ID" datasource="#dsn#" search_areas = "TARGETCAT_NAME,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="TARGETCAT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="TARGETCAT_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="TARGETCAT_WEIGHT" header="#getLang('settings',1322)#" width="300" select="yes" display="yes"/>
	<cf_wrk_grid_column name="DETAIL" header="#getLang('main',1204)#" width="400" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
	<cf_wrk_grid_column name="IS_ACTIVE" header="Aktif" width="100" type="boolean" select="yes" display="yes"/>   
</cf_wrk_grid>
