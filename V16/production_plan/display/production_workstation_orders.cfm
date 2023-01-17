
<!---
    File:V16\production_plan\display\production_workstation_orders.cfm
    Author:Fatma Zehra Dere
    Date: 2021-10-13
    Description:Operatorlerde İş Yapabileceğim İş İstasyonlarının listelendiği sayfadır
--->
<style>
	.ajax_list > thead tr th {
    border-bottom: 2px solid #51bbb4;
    font-size: 20px;
    color: #555;
    font-weight: bold;
    margin: 0;
    padding: 5px;
    outline: none!important;
    cursor: pointer!important;
    text-align: left;
    white-space: nowrap;
}
</style>
<cfquery name="get_workstation_all" datasource="#dsn3#">
	SELECT 
		W.STATION_ID,
		W.EMP_ID,
		W.STATION_NAME
	FROM 
		WORKSTATIONS W 
		LEFT JOIN PRODUCTION_ORDERS PO ON PO.STATION_ID = W.STATION_ID
	WHERE
		PO.STATION_ID IS NOT NULL AND 
		PO.IS_STAGE IS NOT NULL AND
		W.EMP_ID LIKE (<cfqueryparam cfsqltype="cf_sql_varchar" value=",%#session.ep.userid#%,">)
		GROUP BY W.STATION_ID,
		W.EMP_ID,
		W.STATION_NAME
</cfquery>
<cfparam name='attributes.totalrecords' default="#get_workstation_all.recordcount#">
<cfparam  name="attributes.page" default="1">
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
    <cfset attributes.maxrows = 10 />
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_box title="#getLang('','İş yapabileceğim',63770)# #getLang('','İş İstasyonları',36326)#" box_style="maxi"  scroll="0" collapsable="0" settings="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	
	<cf_flat_list>
		<thead>
			<tr>
				<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
				<th><cf_get_lang dictionary_id='36669.İstasyon Adı'></th>  
			</tr>
		</thead>
		<tbody>
			<cfif get_workstation_all.recordcount>
				<cfoutput query="get_workstation_all" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td>#STATION_NAME#</td>
						
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
		</tbody>
	</cf_flat_list>
	<cfset url_str = "">
        
	<cf_paging page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
	totalrecords="#attributes.totalrecords#" 
	startrow="#attributes.startrow#" 
	adres="production.popup_list_workstation#url_str#"
	isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
    </cf_box>  
	



