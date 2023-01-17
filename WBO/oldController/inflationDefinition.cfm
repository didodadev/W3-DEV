<cf_get_lang_set module_name="account">
<cfsavecontent variable="ay1"><cf_get_lang_main no='180.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang_main no='181.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang_main no='182.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang_main no='183.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang_main no='184.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang_main no='185.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang_main no='186.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang_main no='187.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang_main no='188.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang_main no='189.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang_main no='190.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang_main no='191.Aralık'></cfsavecontent>
<cfset ay_list = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cfif (isdefined("attributes.event") and attributes.event is "list") or not isdefined("attributes.event")>
    <cfinclude template="../account/query/get_inflation.cfm">
<cfelseif isdefined("attributes.event") and attributes.event is "add">
	<cfset MONTH_ = DATEPART("M",now())>
    <cfset YEAR_ = DATEPART("YYYY",now())>
<cfelseif isdefined("attributes.event") and attributes.event is "upd">
	<cfset xfa.del="account.emptypopup_del_inflation">
    <cfquery name="get_inf_detail" datasource="#DSN#">
        SELECT 
            * 
        FROM 
            INFLATION 
        WHERE 
            INF_ID = #attributes.INF_ID#
    </cfquery>
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.event") and (attributes.event is "add" or attributes.event is "upd")>
		function check()
		{
			if (document.inflation.bill2.value == "")
			{
				alert("<cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang no='128.Enflasyon Orani'>");
				return false;
			}
			
			if ((document.inflation.bill2.value< 0.01) || (document.inflation.bill2.value >100))
			{
				alert("<cf_get_lang no='227.Enflasyon 0.01 den büyük, 100 den küçük olmalıdır'>");
				return false;
			}
			return true;
		}
	</cfif>
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_inflation';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'account/display/list_inflation.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.popup_form_add_inflation';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'account/form/form_add_inflation.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'account/query/add_inflation.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.list_inflation';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'account.popup_form_upd_inflation';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'account/form/form_upd_inflation.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'account/query/upd_inflation.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'account.list_inflation';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'inf_id=##attributes.inf_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '';

	if(attributes.event is 'upd' or attributes.event is 'del')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#xfa.del#&inf_id=#attributes.inf_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'account/query/del_inflation.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'account/query/del_inflation.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'account.list_inflation';
	}
		
	if(attributes.event is 'upd')
	{
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['text'] = '#lang_array_main.item[170]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['onClick'] = "windowopen('#request.self#?fuseaction=account.list_inflation&event=add','small')";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['add']['target'] = "_blank";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>
