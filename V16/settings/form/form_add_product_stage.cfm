<cf_wrk_grid search_header = "#getLang('settings',181)#" table_name="PRODUCT_STAGE" sort_column="PRODUCT_STAGE" u_id="PRODUCT_STAGE_ID" datasource="#dsn3#" search_areas = "PRODUCT_STAGE,PRODUCT_STAGE_DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="PRODUCT_STAGE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="PRODUCT_STAGE" header="#getLang('main',68)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="PRODUCT_STAGE_DETAIL" header="#getLang('main',217)#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
