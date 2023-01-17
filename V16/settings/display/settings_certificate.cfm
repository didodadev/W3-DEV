<!---
File: settings_certificate.cfm
Author: Gulbahar Inan
Company: Workcube 
Date: 10.11.2020
Description: Sertifikalar Ekleme/Güncelle sayfasıdır.
--->
<cf_wrk_grid search_header = "#getLang(dictionary_id : 29693)#" table_name="SETTINGS_CERTIFICATE" sort_column="CERTIFICATE_NAME" u_id="CERTIFICATE_ID" datasource="#dsn#" search_areas = "CERTIFICATE_NAME,CERTIFICATE_DETAIL">
    <cf_wrk_grid_column name="CERTIFICATE_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="CERTIFICATE_NAME" width="300" header="#getLang(dictionary_id : 46604)#" select="yes" display="yes"/>
    <cf_wrk_grid_column name="CERTIFICATE_PERIOD" header="#getLang(dictionary_id : 30966)#" width="500" select="yes" display="yes"/>
    <cf_wrk_grid_column name="CERTIFICATE_PERIOD_TYPE" header="#getLang(dictionary_id : 61121)#" width="400" select="yes" display="yes"/>
    <cf_wrk_grid_column name="CERTIFICATE_DETAIL" header="#getLang('main',217)#" width="600" select="yes" display="yes"/>
    <cf_wrk_grid_column name="IS_ACTIVE" header="#getLang(dictionary_id : 58515)#" type="boolean" width="100" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_EMP" header="#getLang('settings',1138)#" type="int"  width="100" select="no" display="yes"/>
</cf_wrk_grid>