<cfsavecontent  variable="header">
    <cf_get_lang dictionary_id='60800.Sağlık Fiyat Protokolleri'>
</cfsavecontent>
<cfsavecontent  variable="title">
    <cf_get_lang dictionary_id='34700.Fiyat Protokolü'>
</cfsavecontent>
<cf_wrk_grid search_header = "#header#" table_name="HEALTH_PRICE_PROTOCOL" sort_column="PROTOCOL_NAME" u_id="PROTOCOL_ID" datasource="#dsn#" user_id="#session.ep.userid#" search_areas="PROTOCOL_ID,PROTOCOL_NAME">
    <cf_wrk_grid_column name="PROTOCOL_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="PROTOCOL_NAME" header="#title#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_EMP" header="#getLang('main',487)#" type="int" select="no" display="yes"/>
    <cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>