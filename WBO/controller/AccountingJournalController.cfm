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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_account_card';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/account/display/list_account_card.cfm';	
		
		
	}
</cfscript>

<!---
<cfsavecontent variable="message1"><cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang_main no='641.Başlangıç Tarihi !'></cfsavecontent>
<cfsavecontent variable="message2"><cf_get_lang_main no='59.Eksik veri'>:<cf_get_lang_main no='288.Bitiş Tarihi !'></cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang_main no ='499.Çalıştır'></cfsavecontent>
--->
