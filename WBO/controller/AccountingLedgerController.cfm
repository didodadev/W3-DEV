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
		WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'account.list_kebir';
		WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'V16/account/display/list_kebir.cfm';	
		
		
	}
</cfscript>

<!---
<cfsavecontent variable="message"><cf_get_lang no ='212.Tarih Hatalı'></cfsavecontent>
<cfsavecontent variable="message"><cf_get_lang no ='212.Tarih Hatalı'></cfsavecontent>


<cf_wrk_multi_account_code form_name='list_kebir' placeholder="<cf_get_lang_main no='1399.Muhasebe Kodu'>*" acc_code1_1='#attributes.acc_code1_1#' acc_code2_1='#attributes.acc_code2_1#' acc_code1_2='#attributes.acc_code1_2#' acc_code2_2='#attributes.acc_code2_2#' acc_code1_3='#attributes.acc_code1_3#' acc_code2_3='#attributes.acc_code2_3#' acc_code1_4='#attributes.acc_code1_4#' acc_code2_4='#attributes.acc_code2_4#' acc_code1_5='#attributes.acc_code1_5#' acc_code2_5='#attributes.acc_code2_5#' is_multi='#is_select_multi_acc_code#'>
MUHASEBE KODU KISMINDAKİ MULTİ FORM BU ŞEKİLDE EKLENDİ

--->