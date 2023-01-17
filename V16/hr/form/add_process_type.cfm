<cfsavecontent variable="message"><cf_get_lang dictionary_id="56885.Muayene Tipi"></cfsavecontent>
<cf_wrk_grid search_header = "#message#" table_name="SETUP_INSPECTION_TYPES" sort_column="INSPECTION_TYPE" u_id="INSPECTION_TYPE_ID" datasource="#dsn#" search_areas = "INSPECTION_TYPE">
    <cf_wrk_grid_column name="INSPECTION_TYPE_ID" header="ID" display="no" select="yes"/>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57480.Konu"></cfsavecontent>
    <cf_wrk_grid_column name="INSPECTION_TYPE" header="#message#" select="yes" display="yes"/>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57627.Kayıt Tarihi"></cfsavecontent>
	<cf_wrk_grid_column name="RECORD_DATE" header="#message#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="Güncelleme Tarihi" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>
