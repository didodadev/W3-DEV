<cfset plevne_levels = "Standart,Light,Dark">
<cf_wrk_grid search_header = "#getLang('','Güvenlik Şablonları',64276)#" table_name="WRK_PLEVNE_RULE" sort_column="RULE_ID" u_id="RULE_ID" datasource="#dsn#" search_areas = "PATTERN" dictionary_count="1">
    <cf_wrk_grid_column name="RULE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="PATTERN" header="#getLang('',"",271)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="SECURITY_LEVEL" header="#getLang('',"",270)#" select="yes" display="yes" type="select" listSource="plevne_levels"/>
    <cf_wrk_grid_column name="ACTIVE" header="#getLang('',"",57493)#" type="checkbox" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('main',215)#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('','Güncelleme Tarihi',55055)#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>