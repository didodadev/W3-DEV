<cfsavecontent variable="message"><cf_get_lang dictionary_id="53091.İş Kazası Güvenlik Maddeleri"></cfsavecontent>
<cf_wrk_grid search_header = "#message#" table_name="EMPLOYEE_ACCIDENT_SECURITY" left_menu="1" sort_column="ACCIDENT_SECURITY" u_id="ACCIDENT_SECURITY_ID" datasource="#dsn#" search_areas = "ACCIDENT_SECURITY,ACCIDENT_DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="ACCIDENT_SECURITY_ID" header="ID" display="no" select="yes"/>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57480.Konu"></cfsavecontent>
    <cf_wrk_grid_column name="ACCIDENT_SECURITY" header="#message#" select="yes" display="yes"/>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57629.Açıklama"></cfsavecontent>
    <cf_wrk_grid_column name="ACCIDENT_DETAIL" header="#message#" width="400" select="yes" display="yes"/>
</cf_wrk_grid>
