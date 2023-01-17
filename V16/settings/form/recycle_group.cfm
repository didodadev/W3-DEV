<cfquery name="get_gekap_list" datasource="#dsn#">
	SELECT RECYCLE_GROUP_ID, RECYCLE_GROUP FROM RECYCLE_GROUP
</cfquery>
<cfset gekap_idlist=valuelist(get_gekap_list.RECYCLE_GROUP_ID)>
<cfset gekap_name=valuelist(get_gekap_list.RECYCLE_GROUP)>

<cf_wrk_grid search_header = "#getLang(dictionary_id:999)#" table_name="RECYCLE_SUB_GROUP" sort_column="RECYCLE_SUB_GROUP" u_id="RECYCLE_SUB_GROUP_ID" datasource="#dsn#" search_areas = "RECYCLE_SUB_GROUP" >
    <cf_wrk_grid_column name="RECYCLE_SUB_GROUP_ID" header="ID" display="no" select="yes"/>
    <cf_wrk_grid_column name="RECYCLE_SUB_GROUP" header="#getLang('','Geri Dönüşüm Grubu ',1000)#" select="yes" width="150" display="yes"/>
	<cf_wrk_grid_column name="RECYCLE_SUB_GROUP_CODE" header="#getLang('','Kod',58585)#" display="yes" select="yes" is_empty="1"/>
	<cf_wrk_grid_column name="KG_PRICE" header="#getLang('','Adet-Geri Kazanım Payı',1003)#" display="yes" select="yes" type="float"/>
	<cf_wrk_grid_column name="NUMBER_PRICE" header="#getLang('','Kg-Geri Kazanım Payı',65329)#" display="yes" select="yes" type="float"/>
	<cf_wrk_grid_column name="RECYCLE_GROUP_ID" header="#getLang('','Ana Grup',61641)#" display="yes" select="yes" type="select" listsource="gekap_idlist" listsource_text="gekap_name" />
</cf_wrk_grid>


