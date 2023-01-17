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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_account_card_rows';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/account/display/list_account_card_rows.cfm';	
		
		
	}
</cfscript>

<!---
muavin_pdf_ac(); FONKSİYONU TANIMLI DEĞİL
--->
