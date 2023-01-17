<cf_wrk_grid search_header = "Rakip Fiyat Tipleri" dictionary_count="1" table_name="RIVAL_PRICE_TYPES" sort_column="TYPE_NAME" u_id="TYPE_ID" datasource="#dsn_dev#" search_areas = "TYPE_NAME,TYPE_CODE">
    <cf_wrk_grid_column name="TYPE_ID" header="ID" display="no" width="150" select="yes"/>
    <cf_wrk_grid_column name="TYPE_CODE" header="Tip Kodu" select="yes" width="150" display="yes"/>
    <cf_wrk_grid_column name="TYPE_NAME" header="Rakip Fiyat Tipi" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="Kayıt" type="date" mask="date" width="150" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="Güncelleme" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
