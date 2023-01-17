<cf_wrk_grid search_header = "#getLang('','Üye Ziyaret Kategorileri',61294)#" table_name="SETUP_VISIT_CAT" sort_column="VISIT_CAT" u_id="VISIT_CAT_ID" datasource="#dsn#" search_areas = "VISIT_CAT,VISIT_CAT_DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="VISIT_CAT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="VISIT_CAT" width="300" header="#getLang('main',68,57480)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="VISIT_CAT_DETAIL" header="#getLang('main',217,57629)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_VISIT_PLAN" width="100" type="boolean" header="#getLang('','Ziyaret Planı',58422)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="200" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('','Güncelleme Tarihi',55055)#" type="date" mask="date" width="200" select="no" display="yes"/>
</cf_wrk_grid>
