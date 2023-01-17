<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';		
		
        WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'finance.securefund_extension_of_time';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/member/display/list_securefund_extension_of_time.cfm';

		WOStruct['#attributes.fuseaction#']['add'] = structNew();
		WOStruct['#attributes.fuseaction#']['add']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'finance.securefund_extension_of_time';
		WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'V16/member/form/add_securefund_extension_of_time.cfm';
		WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'V16/member/query/add_securefund_extension_of_time.cfm';

        if(isdefined("attributes.extension_securefund_id")){

			WOStruct['#attributes.fuseaction#']['upd'] = structNew();
			WOStruct['#attributes.fuseaction#']['upd']['window'] = 'normal';
			WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'finance.securefund_extension_of_time';
			WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'V16/member/form/upd_securefund_extension_of_time.cfm';
			WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'V16/member/query/upd_securefund_extension_of_time.cfm';

			WOStruct['#attributes.fuseaction#']['del'] = structNew();
			WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
			WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'V16/member/cfc/securefund_extension_time.cfc';
			WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'V16/member/form/upd_securefund_extension_of_time.cfm';
			WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'V16/member/cfc/securefund_extension_time.cfc';
		}
		
	}
</cfscript>