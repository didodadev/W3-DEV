<cf_wrk_grid search_header = "#getLang(dictionary_id:34930)#" table_name="SERVICE_SPARE_PART" sort_column="SPARE_PART" u_id="SPARE_PART_ID" datasource="#dsn3#" search_areas = "SPARE_PART" >
    <cf_wrk_grid_column name="SPARE_PART_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="SPARE_PART" header="#getLang('','Ürün Servis İşlem Tipi',43150)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('settings',1180)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
    

    
