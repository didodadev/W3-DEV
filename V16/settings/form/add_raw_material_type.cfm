<cf_wrk_grid search_header = "İmalat Malzemesi" table_name="SETUP_RAW_MATERIAL" sort_column="RAW_MATERIAL_NAME" u_id="RAW_MATERIAL_ID" datasource="#dsn#" search_areas = "RAW_MATERIAL_NAME,RAW_MATERIAL_DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="RAW_MATERIAL_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="RAW_MATERIAL_NAME" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RAW_MATERIAL_DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="100" select="no" display="yes"/>
</cf_wrk_grid>
