<cfset comp    = createObject("component","workdata.get_special_definition_type") />
<cfset getComponentFunction = comp.getComponentFunction()>
<cfset iysList=valuelist(getComponentFunction.SPECIAL_DEFINITION_TYPE_ID)>
<cfset iysList_text=valuelist(getComponentFunction.SPECIAL_DEFINITION_NAME)>
<cf_wrk_grid search_header = "#getLang('','','44786')#" table_name="SETUP_SPECIAL_DEFINITION" sort_column="SPECIAL_DEFINITION_TYPE" u_id="SPECIAL_DEFINITION_ID" datasource="#dsn#" search_areas = "SPECIAL_DEFINITION_TYPE,SPECIAL_DEFINITION">
    <cf_wrk_grid_column name="SPECIAL_DEFINITION_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="SPECIAL_DEFINITION_TYPE" header="#getLang('','tip','59088')#" type="select" listsource="iysList" listsource_text="iysList_text"  select="yes" display="yes" 
    />
    <cf_wrk_grid_column name="SPECIAL_DEFINITION" header="#getLang('','özel tanım','44786')#" width="300" select="yes" display="yes"/>
	<cf_wrk_grid_column name="SPECIAL_DEFINITION_DETAIL" header="#getLang('','açıklama ','36199')#" width="300" select="yes" display="yes"/>
	<cf_wrk_grid_column name="RECORD_DATE" header="#getLang('','kayıt tarih ','57627')#" type="date" mask="date" width="100" select="no" display="yes"/>
    <cf_wrk_grid_column name="UPDATE_DATE" header="#getLang('','güncelleme tarih ','55055')#" type="date" mask="date" width="150" select="no" display="yes"/>
</cf_wrk_grid>


