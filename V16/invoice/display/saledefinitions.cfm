<cfquery name="GET_DET_INVOICE" datasource="#DSN3#">
	SELECT * FROM SETUP_INVOICE
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="57165.Standart Satış Tanımları"></cfsavecontent>
<cfset pageHead ="#message#" >
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">

<cf_box title="#getLang('','Satış Fatura Muhasebe Tanımları','47201')#" >
<cfform name="cashes"  method="post" action="#request.self#?fuseaction=invoice.emptypopup_setup_sale_definition">
    <cfif get_det_invoice.recordcount eq 0>
        <cf_box_elements>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                <div class="form-group" id="item-a_disc">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57136.İskontolar'></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cf_wrk_account_codes form_name='cashes' account_code="a_disc" is_sub_acc='0' is_multi_no = '1'>
                            <input type="text"  name="a_disc" id="a_disc" onkeyup="get_wrk_acc_code_1();" onFocus="AutoComplete_Create('a_disc','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','a_disc','','3','200');">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('a_disc');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-hizli_f">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57303.Perakende Fatura'></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cf_wrk_account_codes form_name='cashes' account_code="hizli_f" is_sub_acc='0' is_multi_no = '2'>
                            <input type="text" name="hizli_f" id="hizli_f" onkeyup="get_wrk_acc_code_2();" onFocus="AutoComplete_Create('hizli_f','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','hizli_f','','3','200');">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('hizli_f');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-VERILEN_D_F">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29575.Demirbas Satis Faturasi'></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cf_wrk_account_codes form_name='cashes' account_code="VERILEN_D_F" is_sub_acc='0' is_multi_no = '3'>
                            <input type="text" name="VERILEN_D_F" id="VERILEN_D_F" value="<cfoutput>#get_det_invoice.verilen_d_f#</cfoutput>" onkeyup="get_wrk_acc_code_3();" onFocus="AutoComplete_Create('VERILEN_D_F','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','VERILEN_D_F','','3','200');">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('VERILEN_D_F');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-FARK_GELIR">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57243.Gelir Farkı'></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cf_wrk_account_codes form_name='cashes' account_code="FARK_GELIR" is_sub_acc='0' is_multi_no = '4'>
                            <input type="text" name="FARK_GELIR" id="FARK_GELIR" value="" onkeyup="get_wrk_acc_code_4();" onFocus="AutoComplete_Create('FARK_GELIR','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','FARK_GELIR','','3','200');">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('FARK_GELIR');"></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" sort="true" index="2">
                <div class="form-group" id="item-FARK_GIDER">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57242.Gider Farkı'></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cf_wrk_account_codes form_name='cashes' account_code="FARK_GIDER" is_sub_acc='0' is_multi_no = '5'>
                            <input type="text" name="FARK_GIDER" id="FARK_GIDER" value="" onkeyup="get_wrk_acc_code_5();" onFocus="AutoComplete_Create('FARK_GIDER','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','FARK_GIDER','','3','200');">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('FARK_GIDER');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-MONEY_CREDIT">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57022.Para Puan Hesabi"></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cf_wrk_account_codes form_name='cashes' account_code="MONEY_CREDIT" is_sub_acc='0' is_multi_no = '6'>
                            <input type="text" name="MONEY_CREDIT" id="MONEY_CREDIT" value="" onkeyup="get_wrk_acc_code_6();" onFocus="AutoComplete_Create('MONEY_CREDIT','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','MONEY_CREDIT','','3','200');">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('MONEY_CREDIT');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-GIFT_CARD">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57023.Hediye Çeki Hesabı"></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cf_wrk_account_codes form_name='cashes' account_code="GIFT_CARD" is_sub_acc='0' is_multi_no = '7'>
                            <input type="text" name="GIFT_CARD" id="GIFT_CARD" value="" onkeyup="get_wrk_acc_code_7();" onFocus="AutoComplete_Create('GIFT_CARD','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','GIFT_CARD','','3','200');">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('GIFT_CARD');"></span>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <cf_workcube_buttons type_format="1" is_upd='0'>
        </cf_box_footer>
    <cfelse>
        <cf_box_elements>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                <input type="hidden" name="UPD" id="UPD" value="1">
                <div class="form-group" id="item-a_disc">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57136.İskontolar'></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cf_wrk_account_codes form_name='cashes' account_code="a_disc" is_sub_acc='0' is_multi_no = '1'>
                            <input type="text" name="a_disc" id="a_disc" value="<cfoutput>#get_det_invoice.a_disc#</cfoutput>" onkeyup="get_wrk_acc_code_1();" onFocus="AutoComplete_Create('a_disc','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','a_disc','','3','200');">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('a_disc');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-hizli_f">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57303.Perakende Fatura'></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cf_wrk_account_codes form_name='cashes' account_code="hizli_f" is_sub_acc='0' is_multi_no = '2'>
                            <input type="text" name="hizli_f" id="hizli_f" value="<cfoutput>#get_det_invoice.hizli_f#</cfoutput>" onkeyup="get_wrk_acc_code_2();" onFocus="AutoComplete_Create('hizli_f','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','hizli_f','','3','200');">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('hizli_f');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-VERILEN_D_F">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='29575.Demirbas Satis Faturasi'></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cf_wrk_account_codes form_name='cashes' account_code="VERILEN_D_F" is_sub_acc='0' is_multi_no = '3'>
                            <input type="text" name="VERILEN_D_F" id="VERILEN_D_F" value="<cfoutput>#get_det_invoice.verilen_d_f#</cfoutput>" onkeyup="get_wrk_acc_code_3();" onFocus="AutoComplete_Create('VERILEN_D_F','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','VERILEN_D_F','','3','200');">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('VERILEN_D_F');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-FARK_GELIR">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57243.Gelir Farkı'></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cf_wrk_account_codes form_name='cashes' account_code="FARK_GELIR" is_sub_acc='0' is_multi_no = '4'>
                            <input type="text" name="FARK_GELIR" id="FARK_GELIR" value="<cfoutput>#get_det_invoice.fark_gelir#</cfoutput>" onkeyup="get_wrk_acc_code_4();" onFocus="AutoComplete_Create('FARK_GELIR','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','FARK_GELIR','','3','200');">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('FARK_GELIR');"></span>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" sort="true" index="1">
                <div class="form-group" id="item-FARK_GIDER">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57242.Gider Farkı'></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cf_wrk_account_codes form_name='cashes' account_code="FARK_GIDER" is_sub_acc='0' is_multi_no = '5'>
                            <input type="text" name="FARK_GIDER" id="FARK_GIDER" value="<cfoutput>#get_det_invoice.fark_gider#</cfoutput>" onkeyup="get_wrk_acc_code_5();" onFocus="AutoComplete_Create('FARK_GIDER','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','FARK_GIDER','','3','200');">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('FARK_GIDER');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-MONEY_CREDIT">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57022.Para Puan Hesabi"></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cf_wrk_account_codes form_name='cashes' account_code="MONEY_CREDIT" is_sub_acc='0' is_multi_no = '6'>
                            <input type="text" name="MONEY_CREDIT" id="MONEY_CREDIT" value="<cfoutput>#get_det_invoice.MONEY_CREDIT#</cfoutput>" onkeyup="get_wrk_acc_code_6();" onFocus="AutoComplete_Create('MONEY_CREDIT','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','MONEY_CREDIT','','3','200');">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('MONEY_CREDIT');"></span>
                        </div>
                    </div>
                </div>
                <div class="form-group" id="item-GIFT_CARD">
                    <label class="col col-3 col-xs-12"><cf_get_lang dictionary_id="57023.Hediye Çeki Hesabı"></label>
                    <div class="col col-9 col-xs-12">
                        <div class="input-group">
                            <cf_wrk_account_codes form_name='cashes' account_code="GIFT_CARD" is_sub_acc='0' is_multi_no = '7'>
                            <input type="text" name="GIFT_CARD" id="GIFT_CARD" value="<cfoutput>#get_det_invoice.GIFT_CARD#</cfoutput>" onkeyup="get_wrk_acc_code_7();" onFocus="AutoComplete_Create('GIFT_CARD','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','GIFT_CARD','','3','200');">
                            <span class="input-group-addon btnPointer icon-ellipsis" onclick="pencere_ac('GIFT_CARD');"></span>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57461.Kaydet'></cfsavecontent><cf_workcube_buttons is_upd='0' type_format="1" insert_info='#message#' add_function='control_wrk()'>
        </cf_box_footer>
    </cfif>
</cfform>
</cf_box>
</div>
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
	Dizi_new[0]= new Array ('a_disc','<cf_get_lang dictionary_id="57410.İskontolar Muhasebe Kodu">')
	Dizi_new[1]= new Array ('hizli_f','<cf_get_lang dictionary_id="57303.Perakende Fatura"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu">')
	Dizi_new[2]= new Array ('VERILEN_D_F','<cf_get_lang dictionary_id="57411.Demirbas Satis Faturasi"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu">')
	Dizi_new[3]= new Array ('FARK_GELIR','<cf_get_lang dictionary_id="57243.Gelir Farkı"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu">')
	Dizi_new[4]= new Array ('FARK_GIDER','<cf_get_lang dictionary_id="57242.Gider Farkı"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu">')
	Dizi_new[5]= new Array ('MONEY_CREDIT','<cf_get_lang dictionary_id='34380.Para Puan'> <cf_get_lang dictionary_id="58811.Muhasebe Kodu">')
	Dizi_new[6]= new Array ('GIFT_CARD','<cf_get_lang dictionary_id='54885.Hediye Çeki'> <cf_get_lang dictionary_id="58811.Muhasebe Kodu">')
	Dizi[0]= new Array ('a_disc','<cf_get_lang dictionary_id="57410.İskontolar Muhasebe Kodu"> <cf_get_lang dictionary_id="58981.Kayıtlı Değil">.')
	Dizi[1]= new Array ('hizli_f','<cf_get_lang dictionary_id="57303.Perakende Fatura"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu"> <cf_get_lang dictionary_id="58981.Kayıtlı Değil">.')
	Dizi[2]= new Array ('VERILEN_D_F','<cf_get_lang dictionary_id="57411.Demirbas Satis Faturasi"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu"> <cf_get_lang dictionary_id="58981.Kayıtlı Değil">.')
	Dizi[3]= new Array ('FARK_GELIR','<cf_get_lang dictionary_id="57243.Gelir Farkı"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu"> <cf_get_lang dictionary_id="58981.Kayıtlı Değil">.')
	Dizi[4]= new Array ('FARK_GIDER','<cf_get_lang dictionary_id="57242.Gider Farkı"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu"> <cf_get_lang dictionary_id="58981.Kayıtlı Değil">.')
	Dizi[5]= new Array ('MONEY_CREDIT','<cf_get_lang dictionary_id='34380.Para Puan'> <cf_get_lang dictionary_id="58811.Muhasebe Kodu"> <cf_get_lang dictionary_id="58981.Kayıtlı Değil">.')
	Dizi[6]= new Array ('GIFT_CARD','<cf_get_lang dictionary_id='54885.Hediye Çeki'> <cf_get_lang dictionary_id="58811.Muhasebe Kodu"> <cf_get_lang dictionary_id="58981.Kayıtlı Değil">.')
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
			alert('<cf_get_lang dictionary_id="57471.Eksik Veri">:'+Dizi_new[i][1]);
			return false;
		}
	}
	return true;
}
</script>
