<cf_wrk_grid search_header = "#getLang('settings',730)#" table_name="SERVICE_CARE_CAT" sort_column="SERVICE_CARE" u_id="SERVICE_CARECAT_ID" datasource="#dsn3#" search_areas = "SERVICE_CARE,DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="SERVICE_CARECAT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="SERVICE_CARE" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
	<cf_wrk_grid_column name="UPDATE_DATE" header="Güncelleme Tarihi" width="140" type="date" select="no" display="yes" mask="date"/>
</cf_wrk_grid>
