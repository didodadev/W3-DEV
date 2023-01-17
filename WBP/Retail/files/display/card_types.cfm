<cf_wrk_grid search_header = "Müşteri Kart Tipleri" dictionary_count="1" table_name="CARD_TYPES" sort_column="TYPE_NAME" u_id="TYPE_ID" datasource="#dsn_dev#" is_delete="1" search_areas = "TYPE_NAME">
    <cf_wrk_grid_column name="TYPE_ID" header="ID" display="no" width="150" select="yes"/>
    <cf_wrk_grid_column name="TYPE_STATUS" header="Durum" select="yes" display="yes" type="boolean_click" width="75"/>
    <cf_wrk_grid_column name="TYPE_NAME" header="Tip" select="yes" display="yes" width="150"/>
    <cf_wrk_grid_column name="TYPE_DETAIL" header="Açıklama" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="Kayıt" type="date" mask="date" width="150" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="Güncelleme" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
