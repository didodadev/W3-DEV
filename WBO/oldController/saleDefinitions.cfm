<cf_get_lang_set module_name="invoice">
<cfquery name="GET_DET_INVOICE" datasource="#DSN3#">
	SELECT * FROM SETUP_INVOICE
</cfquery>
<script type="text/javascript">
	function pencere_ac(isim)
	{
		temp_account_code = eval('cashes.'+isim);
		if (temp_account_code.value.length != 0)
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=cashes.'+isim+'&account_code=' + temp_account_code.value, 'list');
		else
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=cashes.'+isim, 'list');
	}
	function control_wrk()
	{
		var Dizi = new Array();	
		var Dizi_new = new Array();	
		Dizi_new[0]= new Array ('a_disc','<cf_get_lang no="408.İskontolar Muhasebe Kodu">')
		Dizi_new[1]= new Array ('hizli_f','<cf_get_lang no="301.Perakende Fatura"> <cf_get_lang_main no="1399.Muhasebe Kodu">')
		Dizi_new[2]= new Array ('VERILEN_D_F','<cf_get_lang no="409.Demirbas Satis Faturasi"> <cf_get_lang_main no="1399.Muhasebe Kodu">')
		Dizi_new[3]= new Array ('FARK_GELIR','<cf_get_lang no="241.Gelir Farkı"> <cf_get_lang_main no="1399.Muhasebe Kodu">')
		Dizi_new[4]= new Array ('FARK_GIDER','<cf_get_lang no="240.Gider Farkı"> <cf_get_lang_main no="1399.Muhasebe Kodu">')
		Dizi_new[5]= new Array ('MONEY_CREDIT','Para Puan <cf_get_lang_main no="1399.Muhasebe Kodu">')
		Dizi_new[6]= new Array ('GIFT_CARD','Hediye Çeki <cf_get_lang_main no="1399.Muhasebe Kodu">')
		Dizi[0]= new Array ('a_disc','<cf_get_lang no="408.İskontolar Muhasebe Kodu"> <cf_get_lang_main no="1569.Kayıtlı Değil">.')
		Dizi[1]= new Array ('hizli_f','<cf_get_lang no="301.Perakende Fatura"> <cf_get_lang_main no="1399.Muhasebe Kodu"> <cf_get_lang_main no="1569.Kayıtlı Değil">.')
		Dizi[2]= new Array ('VERILEN_D_F','<cf_get_lang no="409.Demirbas Satis Faturasi"> <cf_get_lang_main no="1399.Muhasebe Kodu"> <cf_get_lang_main no="1569.Kayıtlı Değil">.')
		Dizi[3]= new Array ('FARK_GELIR','<cf_get_lang no="241.Gelir Farkı"> <cf_get_lang_main no="1399.Muhasebe Kodu"> <cf_get_lang_main no="1569.Kayıtlı Değil">.')
		Dizi[4]= new Array ('FARK_GIDER','<cf_get_lang no="240.Gider Farkı"> <cf_get_lang_main no="1399.Muhasebe Kodu"> <cf_get_lang_main no="1569.Kayıtlı Değil">.')
		Dizi[5]= new Array ('MONEY_CREDIT','Para Puan <cf_get_lang_main no="1399.Muhasebe Kodu"> <cf_get_lang_main no="1569.Kayıtlı Değil">.')
		Dizi[6]= new Array ('GIFT_CARD','Hediye Çeki <cf_get_lang_main no="1399.Muhasebe Kodu"> <cf_get_lang_main no="1569.Kayıtlı Değil">.')
		for(i=0;i<=6;i++)
		{
			var my_value = document.getElementById(Dizi[i][0]).value;
			if(my_value != "")
			{ 
				if(WrkAccountControl(my_value,Dizi[i][1]) == 0){
					return false;
					break;
				}	
			}
			else
			{
				alert('<cf_get_lang_main no="59.Eksik Veri">:'+Dizi_new[i][1]);
				return false;
			}
		}
		return true;
	}
</script>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'addUpd';
	
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['addUpd'] = structNew();
	WOStruct['#attributes.fuseaction#']['addUpd']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['addUpd']['fuseaction'] = 'invoice.sale_definition';
	WOStruct['#attributes.fuseaction#']['addUpd']['filePath'] = 'invoice/display/saledefinitions.cfm';
	WOStruct['#attributes.fuseaction#']['addUpd']['queryPath'] = 'invoice/query/add_sale_def.cfm';
	WOStruct['#attributes.fuseaction#']['addUpd']['nextEvent'] = 'invoice.sale_definition';
	WOStruct['#attributes.fuseaction#']['addUpd']['Identity'] = '';

</cfscript>
