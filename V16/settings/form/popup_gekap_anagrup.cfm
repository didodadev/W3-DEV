<cf_wrk_grid search_header = "#getLang(dictionary_id:1001)#" table_name="RECYCLE_GROUP" sort_column="RECYCLE_GROUP" u_id="RECYCLE_GROUP_ID" datasource="#dsn#" search_areas = "RECYCLE_GROUP" >
    <cf_wrk_grid_column name="RECYCLE_GROUP_ID" header="ID" display="no" select="yes" type="numeric"/>
    <cf_wrk_grid_column name="RECYCLE_GROUP" header="#getLang('','Tanım',58233)#" select="yes" width="150" display="yes"/>
    <cf_wrk_grid_column name="RECYCLE_MAIN_GROUP_CODE" header="#getLang('','Kod',58585)#" select="yes" width="150" display="yes" is_empty="1"/>
</cf_wrk_grid>
