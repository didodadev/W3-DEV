<cf_wrk_grid search_header = "#lang_array.item[33]#" table_name="SETUP_PURCHASE_AUTHORITY" sort_column="AUTHORITY_NAME" u_id="AUTHORITY_ID" datasource="#dsn#" search_areas = "AUTHORITY_NAME,DETAIL" dictionary_count="2" left_menu="1">
    <cf_wrk_grid_column name="AUTHORITY_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="AUTHORITY_NAME" header="#lang_array_main.item[68]#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="DETAIL" header="#lang_array_main.item[217]#" width="500" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#lang_array_main.item[215]#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#lang_array.item[930]#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>


