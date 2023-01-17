<cf_wrk_grid search_header = "Banknot Tipleri" dictionary_count="1" table_name="BANKNOTE_TYPES" sort_column="TYPE_MULTIPLIER" u_id="TYPE_ID" datasource="#dsn_dev#" search_areas = "TYPE_NAME">
    <cf_wrk_grid_column name="TYPE_ID" header="ID" display="no" width="150" select="yes"/>
    <cf_wrk_grid_column name="TYPE_NAME" header="Fiyat Tipi" select="yes" display="yes"/>
    <cf_wrk_grid_column name="TYPE_MULTIPLIER" header="Fiyat Çarpan" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="Kayıt" type="date" mask="date" width="150" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="Güncelleme" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
