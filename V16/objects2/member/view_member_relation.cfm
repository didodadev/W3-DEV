<cfif not isDefined("attributes.maxrows") and isDefined("session.pp")>
	<cfset attributes.maxrows = session.pp.maxrows>
</cfif>
<cfif not isDefined("attributes.company_id") and isDefined("session.pp")>
	<cfset attributes.company_id = session.pp.company_id>
</cfif>

<cfparam name="attributes.page" default='1'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
	function connectAjax(div_id,data)
	{
		if (div_id == 'list_company_help')//etkileşimler
			var page = '<cfoutput>#request.self#?fuseaction=objects2.popupajax_my_company_helps&cpid=#attributes.company_id#&maxrows=#attributes.maxrows#</cfoutput>';
		if (div_id == 'list_company_events')//Toplantı ve Ziyaretler
			var page = '<cfoutput>#request.self#?fuseaction=objects2.popupajax_my_company_events&cpid=#attributes.company_id#&maxrows=#attributes.maxrows#</cfoutput>';
		if (div_id == 'list_my_company_opportunuties')//Fırsatlar
			var page = '<cfoutput>#request.self#?fuseaction=objects2.popupajax_my_company_opportunities&cpid=#attributes.company_id#&maxrows=#attributes.maxrows#</cfoutput>';
		if (div_id == 'list_my_company_analys')//Analizler
			var page = '<cfoutput>#request.self#?fuseaction=objects2.popupajax_my_company_analyse&cpid=#attributes.company_id#&maxrows=#attributes.maxrows#</cfoutput>';
		AjaxPageLoad(page,''+div_id+'',0);
	}
</script>

<cfquery name="GET_ALT_MAN" datasource="#DSN#" maxrows="1">
	SELECT 
		CP.PARTNER_ID
	FROM 
		COMPANY_PARTNER CP, 
		COMPANY C
	WHERE 
		CP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND 
		CP.COMPANY_ID = C.COMPANY_ID AND
		COMPANY_PARTNER_STATUS=1
	ORDER BY
		CP.COMPANY_PARTNER_NAME
</cfquery>

<div class="table-responsive-lg">
	<table class="table">
		<!--- Etkilesimler --->
		<tr class="color-list" style="height:22px;">
			<td class="txtbold"><a href="javascript:gizle_goster(help_1);connectAjax('list_company_help');">&raquo; <cf_get_lang dictionary_id='58729.Etkileşimler'></a></td>
			<cfif isdefined('get_company_.manager_partner_id')>
				<cfset manager_partner_id = get_company_.manager_partner_id>
			<cfelse>
				<cfset manager_partner_id = ''>
			</cfif>
			<!--- <td  style="text-align:right;"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_add_service_help&company_id=#attributes.company_id#&<cfif len(manager_partner_id)>pid=#manager_partner_id#<cfelse>pid=#get_alt_man.partner_id#</cfif></cfoutput>','medium');"><img src="images/plus_list.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='170.Ekle'>" />		</a></td> --->
		</tr>
		<tr id="help_1" style="display:none">
			<td colspan="2"><div align="left" id="list_company_help"></div></td>
		</tr>
		<!--- toplantı-ziyaretler --->
		<tr class="color-list" style="height:22px;">
			<td class="txtbold"><a href="javascript:gizle_goster(events_1);connectAjax('list_company_events');">&raquo; <cf_get_lang dictionary_id='34889.Toplantılar'>/<cf_get_lang dictionary_id='57970.Ziyaretler'></a></td>
			<cfoutput>
				<!--- <td  style="text-align:right;"><a href="#request.self#?fuseaction=objects2.form_add_event"><img src="images/plus_list.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='170.Ekle'>" /></a></td> --->
			</cfoutput>
		</tr>
		<tr id="events_1" style="display:none">
			<td colspan="2"><div align="left" id="list_company_events"></div></td>
		</tr>
		<!--- fırsatlar --->
		<tr class="color-list" style="height:22px;">
			<td class="txtbold"><a href="javascript:gizle_goster(opportunities_1);connectAjax('list_my_company_opportunuties');">&raquo; <cf_get_lang dictionary_id='58694.Fırsatlar'></a> </td>	
			<!--- <td style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.form_add_opportunity&company_id=#attributes.company_id#"><img src="images/plus_list.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='170.Ekle'>" /></a></td>	  	 --->			  
		</tr>
		<tr id="opportunities_1" style="display:none">
			<td colspan="2"><div align="left" id="list_my_company_opportunuties"></div></td>
		</tr>
		<!--- analizler --->
		<tr class="color-list" style="height:22px;">
			<td class="txtbold" colspan="3"><a href="javascript:gizle_goster(list_my_analys);connectAjax('list_my_company_analys');">&raquo; <cf_get_lang dictionary_id ='58799.Analizler'></a></td>
		</tr>
		<tr id="list_my_analys" style="display:none">
			<td colspan="3"><div align="left" id="list_my_company_analys"></div></td>
		</tr> 
	</table>
</div>