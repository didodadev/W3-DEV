<script type="text/javascript">
<!--
	function substatus(){
		document.add_service.service_SUBSTATUS_ID.value=document.add_service.service_STATUS_ID.value;
	}
	function send_loc()
	{	
		document.add_service.city.value=document.add_service.SERVICE_CITY.value;
		document.add_service.county.value=document.add_service.SERVICE_COUNTY.value;
		str="<cfoutput>#request.self#?fuseaction=service.popup_add_task</cfoutput>&city="+document.add_service.SERVICE_CITY.value+"&county="+document.add_service.SERVICE_COUNTY.value;
	
		return str;
	}
//-->
</script>
<cfinclude template="../query/get_service_detail.cfm">
  <cfoutput>
    <cfset partner_id=get_service_detail.SERVICE_PARTNER_ID>
    <cfset consumer_id=get_service_detail.SERVICE_CONSUMER_ID>
    <cfset employee_id=get_service_detail.SERVICE_EMPLOYEE_ID>
    <cfset service_id=get_service_detail.service_ID>
    <cfinclude template="../query/get_service_task.cfm">
    <cfinclude template="../query/get_service_reply.cfm">
  </cfoutput>
<cfsavecontent variable="right">	
	<cfif not listfindnocase(denied_pages,'call.upd_service')>
		<a href="javascript://" onClick="window.opener.location.href='#request.self#?fuseaction=call.list_service&event=upd&service_id=#service_id#';self.close();"><img src="/images/refer.gif" alt="Detayları Gör" title="Detayları Gör" border="0"></a>
	</cfif>
</cfsavecontent>
<cf_popup_box title="#getLang('call',112)# #get_service_detail.service_HEAD#" right_images='#right#'>
	<table>
		<tr>
			<td width="100" class="txtbold">Başvuru No</td>
			<td width="150"><cfoutput>#get_service_detail.service_ID#</cfoutput> - 
				<cfif get_service_detail.SERVICE_ACTIVE eq 1><cf_get_lang no='81.Aktif'><cfelse><cf_get_lang no='82.Pasif'></cfif></td>
			<td width="75" class="txtbold"><cf_get_lang_main no='73.Öncelik'></td>
			<td width="150">
				<cfset attributes.PRIORITY_ID = get_service_detail.PRIORITY_ID>
				<cfinclude template="../query/get_priority.cfm">
				<cfoutput query="get_priority">#PRIORITY#</cfoutput>	
			</td>
		</tr>
		<tr>
			<td class="txtbold">Kayıt Yöntemi</td>
			<td>
				<cfset attributes.COMMETHOD_ID = get_service_detail.COMMETHOD_ID>
				<cfinclude template="../query/get_com_method.cfm">
				<cfoutput>#get_com_method.COMMETHOD#</cfoutput>
			</td>
			<td class="txtbold">Kategori</td>
			<td>
				<cfset attributes.SERVICECAT_ID = get_service_detail.SERVICECAT_ID>
				<cfinclude template="../query/get_service_appcat.cfm">
				<cfoutput query="get_service_appcat">#serviceCAT#</cfoutput>
			</td>
		</tr>
		<tr>
			<td class="txtbold"><cf_get_lang_main no='68.Başlık'></td>
			<td colspan="3"><cfoutput>#get_service_detail.service_HEAD#</cfoutput></td>
		</tr>
		<tr>
			<td colspan="4" class="txtbold"><cf_get_lang_main no='217.açıklam'></td>
		</tr>
		<tr>
			<td colspan="4"><cfoutput>#get_service_detail.service_DETAIL#</cfoutput></td>
		</tr>
	</table>
</cf_popup_box>

 
