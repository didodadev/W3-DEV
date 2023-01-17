<cfsavecontent variable="header"><cf_get_lang dictionary_id="54813.Banka Tipleri"></cfsavecontent>
<cfsavecontent variable="bank_type_name"><cf_get_lang dictionary_id="57897.Adı"></cfsavecontent>
<cfsavecontent variable="bank_type_quata_rate"><cf_get_lang dictionary_id="39473.Yüzde"></cfsavecontent>
<cf_wrk_grid search_header = "#header#" table_name="SETUP_BANK_TYPE_GROUPS" sort_column="BANK_TYPE" u_id="BANK_TYPE_ID" datasource="#dsn#" search_areas = "BANK_TYPE,QUATA_RATE">
    <cf_wrk_grid_column name="BANK_TYPE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="BANK_TYPE" header="#bank_type_name#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="QUATA_RATE" header="#bank_type_quata_rate#" select="yes" display="yes"/>
</cf_wrk_grid>