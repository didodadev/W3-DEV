<!--- 
    <!---
File: health_limb.cfm
Author: Workcube-Gulbahar Inan>
Date: 21.12.2019
Description: Uzuvlar/organlar Ekleme/Güncelle sayfasıdır...
--->
 --->
<cf_wrk_grid search_header = "#getLang('main',3811)#" table_name="SETUP_LIMB" left_menu="1" sort_column="LIMB_NAME" u_id="LIMB_ID" datasource="#dsn#" search_areas = "LIMB_NAME" dictionary_count="2">
    <cf_wrk_grid_column name="LIMB_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="LIMB_NAME" header="#getLang('main',3812)#" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_EMP" header="#getLang('settings',1138)#" type="int"  width="100" select="no" display="yes"/>
</cf_wrk_grid>
