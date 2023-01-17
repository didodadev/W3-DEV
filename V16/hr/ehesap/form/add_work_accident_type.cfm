<cfsavecontent variable="message"><cf_get_lang dictionary_id="53086.İş Kazası Çeşitleri"></cfsavecontent>
<cf_wrk_grid search_header = "#message#" table_name="EMPLOYEE_WORK_ACCIDENT_TYPE" left_menu="1" sort_column="ACCIDENT_TYPE" u_id="ACCIDENT_TYPE_ID" datasource="#dsn#" search_areas = "ACCIDENT_TYPE,ACCIDENT_DETAIL" dictionary_count="2">
    <cf_wrk_grid_column name="ACCIDENT_TYPE_ID" header="ID" display="no" select="yes"/>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57480.Konu"></cfsavecontent>
    <cf_wrk_grid_column name="ACCIDENT_TYPE" header="#message#" select="yes" display="yes"/>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57629.Açıklama"></cfsavecontent>
    <cf_wrk_grid_column name="ACCIDENT_DETAIL" header="#message#" width="400" select="yes" display="yes"/>
</cf_wrk_grid>
