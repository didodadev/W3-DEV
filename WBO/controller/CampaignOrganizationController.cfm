<cfscript>
	if(attributes.tabMenuController eq 0)
	{
		// Switch //
		WOStruct = StructNew();
		
		WOStruct['#attributes.fuseaction#'] = structNew();	
		
		WOStruct['#attributes.fuseaction#']['default'] = 'list';
		if(not isdefined('attributes.event'))
			attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
		WOStruct['#attributes.fuseaction#']['list'] = structNew();
		WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'campaign.list_organization_agenda';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/campaign/display/list_organization_agenda.cfm';
		
		
	}
</cfscript>

<!---
zZORUNLU GİRİLMESİ GEREKEN ALANLAR

<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='1408.başlık'></cfsavecontent>
<cfsavecontent variable="message"> <cf_get_lang_main no='782.Zorunlu Alan'>:<cf_get_lang_main no ='641.başlangıç tarihi'></cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang_main no='288.bitis tarihi'></cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='783.tam sayı'></cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang_main no='65.hatalı veri'>:<cf_get_lang_main no='783.tam sayı'></cfsavecontent>--->