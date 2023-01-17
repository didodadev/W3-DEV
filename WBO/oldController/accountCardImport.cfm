<cf_get_lang_set module_name = "account">
<cfparam name="is_dsp_cari_member" default="0">
<cf_xml_page_edit fuseact="account.account_card_import">
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'add';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'account.account_card_import';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'account/form/account_card_import.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'account/query/account_card_import.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'account.list_cards';
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'accountCardImport';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ACCOUNT_CARD';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'period';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-1','item-2','item-3']";
</cfscript>
<script type="text/javascript">
	function control_member()
	{
		<cfif is_dsp_cari_member eq 1> //acılıs fişinde cari hesap gosterilmiyor
			var selected_ptype = document.acc_import.process_cat.options[document.acc_import.process_cat.selectedIndex].value;
			if(selected_ptype!='')
			{
				eval('var proc_control = document.acc_import.ct_process_type_'+selected_ptype+'.value');
				if(proc_control == 10)
					gizle(cari_hesap);
				else
					goster(cari_hesap);
			}
			else
				goster(cari_hesap);
		</cfif>
	}
	control_member();
	function kontrol()
	{
		if(!chk_process_cat('acc_import')) return false;
		if(!chk_period(acc_import.process_date,"İşlem")) return false;
		if(acc_import.muhasebe_file.value.length==0)
		{
			alert("<cf_get_lang no ='207.Belge Seçmelisiniz'>!");
			return false;
		}
		return true;
	}
</script>
