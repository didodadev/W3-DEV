<cf_wrk_grid search_header = "#getLang('settings',263)#" table_name="SETUP_SUPPORT" sort_column="SUPPORT_CAT" u_id="SUPPORT_CAT_ID" datasource="#dsn#" search_areas = "SUPPORT_CAT">
    <cf_wrk_grid_column name="SUPPORT_CAT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="SUPPORT_CAT" header="#getLang('main',68)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
	<cf_wrk_grid_column name="UPDATE_DATE" header="Güncelleme Tarihi" width="130" type="date" select="no" display="yes" mask="date"/>
</cf_wrk_grid>
