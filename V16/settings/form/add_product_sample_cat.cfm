<cf_wrk_grid search_header = "#getLang(dictionary_id:63458)#" table_name="PRODUCT_SAMPLE_CAT" sort_column="PRODUCT_SAMPLE_CAT" u_id="PRODUCT_SAMPLE_CAT_ID" datasource="#dsn3#" search_areas = "PRODUCT_SAMPLE_CAT,PRODUCT_SAMPLE_CAT_DETAILS" >
    <cf_wrk_grid_column name="PRODUCT_SAMPLE_CAT_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="PRODUCT_SAMPLE_CAT" header="#getLang('','numune ',62603)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="PRODUCT_SAMPLE_CAT_DETAILS" header="#getLang('','numune ','62603')##getLang('','açıklama ','36199')#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>