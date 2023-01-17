<cfsavecontent  variable="header"><cf_get_lang dictionary_id="60107.İstisnalar">
</cfsavecontent>
<cfsavecontent  variable="kod"><cf_get_lang dictionary_id="58585.Kod">
</cfsavecontent>
<cfsavecontent  variable="madde"><cf_get_lang dictionary_id="60108.madde">
</cfsavecontent>
<cfsavecontent  variable="aciklama"><cf_get_lang dictionary_id="36199.aciklama">
</cfsavecontent>
<cf_wrk_grid search_header = "#header#" table_name="VAT_EXCEPTION" sort_column="VAT_EXCEPTION_CODE"  u_id="VAT_EXCEPTION_ID" datasource="#dsn#" search_areas = "VAT_EXCEPTION_CODE,VAT_EXCEPTION_ARTICLE" dictionary_count="2">
    <cf_wrk_grid_column name="VAT_EXCEPTION_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="VAT_EXCEPTION_CODE" header="#kod#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="VAT_EXCEPTION_ARTICLE" header="#madde#" width="400" select="yes" display="yes"/>
    <cf_wrk_grid_column name="VAT_EXCEPTION_DETAIL" header="#aciklama#" width="100" select="yes" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="date"  select="yes" display="no"/>
    <cf_wrk_grid_column name="RECORD_EMP" header="emp"  select="yes" display="no"/>
    <cf_wrk_grid_column name="RECORD_IP" header="ip" select="yes" display="no"/>
    <cf_wrk_grid_column name="EXCEPTION_GROUP_CODE" header="groupcode" select="yes" display="no"/>
</cf_wrk_grid>
