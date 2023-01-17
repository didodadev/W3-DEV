<cf_xml_page_edit fuseact="settings.muhasebe_devir">
<cf_get_lang_set module_name = "settings">
<cfquery name="get_period" datasource="#dsn#">
	SELECT PERIOD_ID, PERIOD FROM SETUP_PERIOD WHERE PERIOD_YEAR <= #year(now())+1#
</cfquery>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'settings.form_muhasebe_devir';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'settings/form/muhasebe_devir.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'settings/query/muhasebe_devir.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'settings.form_muhasebe_devir';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'accountOpeningCard';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ACCOUNT_CARD';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-1','item-6']"; 
</cfscript>
<script type="text/javascript">
	function pencere_ac(str_alan)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan_all&field_id=' + str_alan + '&field_id2=' + str_alan + '&keyword=' + eval(str_alan + ".value"),'list');
	}

	function kontrol()
	{
		if(document.close_ch.period.value == '')
		{
			alert("<cf_get_lang no='1291.Dönem Seçmelisiniz'>!");
			return false;
		}
		if((document.close_ch.is_from_donem.checked == false) && (document.close_ch.muhasebe_file.value == ''))
		{
			alert("<cf_get_lang no='1291.Dönem Seçmelisiniz'>!");
			return false;
		}
		if (confirm("<cf_get_lang no='1295.Seçtiğiniz dönemdeki muhasebe hesaplarını yeni döneme aktarmak üzeresiniz.'>")) 
			return true; 
		else 
			return false;
	}
</script>
