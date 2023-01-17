 <!---
File: ProfarmaPuantajController.cfm
Description: Profarma Puantaj Controller Sayfasıdır.
--->
<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.proforma_puantaj';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = '/V16/hr/ehesap/display/proforma_puantaj.cfm';
		
		WOStruct['#attributes.fuseaction#']['employee_rows'] = structNew();
		WOStruct['#attributes.fuseaction#']['employee_rows']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['employee_rows']['fuseaction'] = 'ehesap.proforma_puantaj';
		WOStruct['#attributes.fuseaction#']['employee_rows']['filePath'] = '/V16/hr/ehesap/display/proforma_puantaj_employee_rows.cfm';
		
		WOStruct['#attributes.fuseaction#']['warnings'] = structNew();
		WOStruct['#attributes.fuseaction#']['warnings']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['warnings']['fuseaction'] = 'ehesap.proforma_puantaj';
		WOStruct['#attributes.fuseaction#']['warnings']['filePath'] = '/V16/hr/ehesap/display/proforma_puantaj_warnings.cfm';
		
		WOStruct['#attributes.fuseaction#']['employee_infos'] = structNew();
		WOStruct['#attributes.fuseaction#']['employee_infos']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['employee_infos']['fuseaction'] = 'ehesap.proforma_puantaj';
		WOStruct['#attributes.fuseaction#']['employee_infos']['filePath'] = '/V16/hr/ehesap/display/proforma_puantaj_employee_infos.cfm';
		
		WOStruct['#attributes.fuseaction#']['employee_rows_ext'] = structNew();
		WOStruct['#attributes.fuseaction#']['employee_rows_ext']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['employee_rows_ext']['fuseaction'] = 'ehesap.proforma_puantaj';
		WOStruct['#attributes.fuseaction#']['employee_rows_ext']['filePath'] = '/V16/hr/ehesap/display/proforma_puantaj_employee_rows_ext.cfm';
		
		WOStruct['#attributes.fuseaction#']['avans_listesi'] = structNew();
		WOStruct['#attributes.fuseaction#']['avans_listesi']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['avans_listesi']['fuseaction'] = 'ehesap.proforma_puantaj';
		WOStruct['#attributes.fuseaction#']['avans_listesi']['filePath'] = '/V16/hr/ehesap/display/proforma_puantaj_avans_listesi.cfm';
		
		WOStruct['#attributes.fuseaction#']['net'] = structNew();
		WOStruct['#attributes.fuseaction#']['net']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['net']['fuseaction'] = 'ehesap.proforma_puantaj';
		WOStruct['#attributes.fuseaction#']['net']['filePath'] = '/V16/hr/ehesap/display/proforma_puantaj_net.cfm';
		
		WOStruct['#attributes.fuseaction#']['tazminat'] = structNew();
		WOStruct['#attributes.fuseaction#']['tazminat']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['tazminat']['fuseaction'] = 'ehesap.proforma_puantaj';
		WOStruct['#attributes.fuseaction#']['tazminat']['filePath'] = '/V16/hr/ehesap/display/proforma_puantaj_tazminat.cfm';
		
		WOStruct['#attributes.fuseaction#']['tazminat2'] = structNew();
		WOStruct['#attributes.fuseaction#']['tazminat2']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['tazminat2']['fuseaction'] = 'ehesap.proforma_puantaj';
		WOStruct['#attributes.fuseaction#']['tazminat2']['filePath'] = '/V16/hr/ehesap/display/proforma_puantaj_tazminat2.cfm';
		
		WOStruct['#attributes.fuseaction#']['employee_rows_hour'] = structNew();
		WOStruct['#attributes.fuseaction#']['employee_rows_hour']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['employee_rows_hour']['fuseaction'] = 'ehesap.proforma_puantaj';
		WOStruct['#attributes.fuseaction#']['employee_rows_hour']['filePath'] = '/V16/hr/ehesap/display/proforma_puantaj_employee_rows_hour.cfm';
		
		WOStruct['#attributes.fuseaction#']['puantaj'] = structNew();
		WOStruct['#attributes.fuseaction#']['puantaj']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['puantaj']['fuseaction'] = 'ehesap.proforma_puantaj';
		WOStruct['#attributes.fuseaction#']['puantaj']['filePath'] = '/V16/hr/ehesap/display/proforma_puantaj_puantaj.cfm';
		
		WOStruct['#attributes.fuseaction#']['must_bes'] = structNew();
		WOStruct['#attributes.fuseaction#']['must_bes']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['must_bes']['fuseaction'] = 'ehesap.proforma_puantaj';
		WOStruct['#attributes.fuseaction#']['must_bes']['filePath'] = '/V16/hr/ehesap/display/proforma_puantaj_bes.cfm';
		
		WOStruct['#attributes.fuseaction#']['employee_rows_interruption'] = structNew();
		WOStruct['#attributes.fuseaction#']['employee_rows_interruption']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['employee_rows_interruption']['fuseaction'] = 'ehesap.proforma_puantaj';
		WOStruct['#attributes.fuseaction#']['employee_rows_interruption']['filePath'] = '/V16/hr/ehesap/display/proforma_puantaj_employee_rows_interruption.cfm';
	}
	else
	{
		fuseactController = caller.attributes.fuseaction;
		getLang = caller.getLang;
		
		tabMenuStruct = StructNew();
		tabMenuStruct['#fuseactController#'] = structNew();
		tabMenuStruct['#fuseactController#']['tabMenus'] = structNew();

		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
</cfscript>