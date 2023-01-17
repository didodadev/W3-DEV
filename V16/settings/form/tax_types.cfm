
<!---
File: tax_types.cfm.cfm
Author: Workcube-Melek KOCABEY>
Date:04.04.2021
Description: Vergi Türleri Ekleme/Güncelle sayfasıdır...
--->
<cf_wrk_grid search_header = "#getLang('','',62505)#" table_name="TAX_TYPE" sort_column="TAX_TYPE" u_id="TAX_TYPE_ID" datasource="#dsn3#" search_areas = "TAX_TYPE,TAX_FORMULA" dictionary_count="2">
    <cf_wrk_grid_column name="TAX_TYPE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="TAX_TYPE" header="#getLang('','',62506)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="TAX_DETAIL" header="#getLang('','',57771)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="CALCULATION_TYPE" header="#getLang('','',62507)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="TAX_FORMULA" header="#getLang('','',58028)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_EMP" header="#getLang('settings',1138)#" type="int"  width="100" select="no" display="yes"/>
</cf_wrk_grid>