<cf_wrk_grid search_header = "Bütçe Kodları" dictionary_count="1" table_name="BUDGET_CODES" sort_column="CODE" u_id="CODE_ID" datasource="#dsn_dev#" search_areas = "CODE">
    <cf_wrk_grid_column name="CODE_ID" header="ID" display="yes" width="150" select="yes"/>
    <cf_wrk_grid_column name="CODE" header="Kod" select="yes" display="yes"/>
    <cf_wrk_grid_column name="CODE_NAME" header="Açıklama" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="Kayıt" type="date" mask="date" width="150" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="Güncelleme" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>