<cf_get_lang_set module_name="invoice">
<cfquery name="get_det_invoice" datasource="#DSN3#">
	SELECT * FROM SETUP_INVOICE_PURCHASE
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
		Dizi_new[1]= new Array ('Perakende_S_I_F','<cf_get_lang_main no="412.Perakende Satış İade Faturası"> <cf_get_lang_main no="1399.Muhasebe Kodu">')
		Dizi_new[2]= new Array ('M_MAKBUZU','<cf_get_lang_main no="411.Müstahsil Makbuzu"> <cf_get_lang_main no="1399.Muhasebe Kodu">')
		Dizi_new[3]= new Array ('ALINAN_D_F','<cf_get_lang no="137.Demirbaş Alım Faturası"> <cf_get_lang_main no="1399.Muhasebe Kodu">')
		Dizi_new[4]= new Array ('YUVARLAMA_GELIR','<cf_get_lang no="302.Yuvarlama Gelir"> <cf_get_lang_main no="1399.Muhasebe Kodu">')
		Dizi_new[5]= new Array ('YUVARLAMA_GIDER','<cf_get_lang no="304.Yuvarlama Gider"> <cf_get_lang_main no="1399.Muhasebe Kodu">')
		Dizi_new[6]= new Array ('FARK_GELIR','<cf_get_lang no="241.Gelir Farkı"> <cf_get_lang_main no="1399.Muhasebe Kodu">')
		Dizi_new[7]= new Array ('FARK_GIDER','<cf_get_lang no="240.Gider Farkı"> <cf_get_lang_main no="1399.Muhasebe Kodu">')
		Dizi[0]= new Array ('a_disc','<cf_get_lang no="408.İskontolar Muhasebe Kodu"> <cf_get_lang_main no="1569.Kayıtlı Değil">.')
		Dizi[1]= new Array ('Perakende_S_I_F','<cf_get_lang_main no="412.Perakende Satış İade Faturası"> <cf_get_lang_main no="1399.Muhasebe Kodu"> <cf_get_lang_main no="1569.Kayıtlı Değil">.')
		Dizi[2]= new Array ('M_MAKBUZU','<cf_get_lang_main no="411.Müstahsil Makbuzu"> <cf_get_lang_main no="1399.Muhasebe Kodu"> <cf_get_lang_main no="1569.Kayıtlı Değil">.')
		Dizi[3]= new Array ('ALINAN_D_F','<cf_get_lang no="137.Demirbaş Alım Faturası"> <cf_get_lang_main no="1399.Muhasebe Kodu"> <cf_get_lang_main no="1569.Kayıtlı Değil">.')
		Dizi[4]= new Array ('YUVARLAMA_GELIR','<cf_get_lang no="302.Yuvarlama Gelir"> <cf_get_lang_main no="1399.Muhasebe Kodu"> <cf_get_lang_main no="1569.Kayıtlı Değil">.')
		Dizi[5]= new Array ('YUVARLAMA_GIDER','<cf_get_lang no="304.Yuvarlama Gider"> <cf_get_lang_main no="1399.Muhasebe Kodu"> <cf_get_lang_main no="1569.Kayıtlı Değil">.')
		Dizi[6]= new Array ('FARK_GELIR','<cf_get_lang no="241.Gelir Farkı"> <cf_get_lang_main no="1399.Muhasebe Kodu"> <cf_get_lang_main no="1569.Kayıtlı Değil">.')
		Dizi[7]= new Array ('FARK_GIDER','<cf_get_lang no="240.Gider Farkı"> <cf_get_lang_main no="1399.Muhasebe Kodu"> <cf_get_lang_main no="1569.Kayıtlı Değil">.')
		for(i=0;i<=7;i++)
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
	WOStruct['#attributes.fuseaction#']['addUpd']['fuseaction'] = 'invoice.purchase_definition';
	WOStruct['#attributes.fuseaction#']['addUpd']['filePath'] = 'invoice/display/purchasedefinitions.cfm';
	WOStruct['#attributes.fuseaction#']['addUpd']['queryPath'] = 'invoice/query/add_purchase_def.cfm';
	WOStruct['#attributes.fuseaction#']['addUpd']['nextEvent'] = 'invoice.purchase_definition';
	WOStruct['#attributes.fuseaction#']['addUpd']['Identity'] = '';

</cfscript>
