<cf_wrk_grid search_header = "Etiket Tipleri" dictionary_count="1" table_name="LABEL_TYPES" sort_column="TYPE_NAME" u_id="TYPE_ID" datasource="#dsn_dev#" search_areas = "TYPE_NAME,TYPE_CODE">
    <cf_wrk_grid_column name="TYPE_ID" header="ID" display="yes" width="150" select="yes"/>
    <cf_wrk_grid_column name="TYPE_CODE" header="İÇERİR" select="yes" width="150" display="yes"/>
    <cf_wrk_grid_column name="TYPE_CODE_OUT" header="İÇERMEZ" select="yes" width="150" display="yes"/>
    <cf_wrk_grid_column name="TYPE_NAME" header="Etiket Tipi" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_STANDART" header="Standart" select="yes" display="yes" type="boolean_click"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="Kayıt" type="date" mask="date" width="150" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="Güncelleme" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>