<cfquery name="get_det_invoice" datasource="#DSN3#">
	SELECT * FROM SETUP_INVOICE_PURCHASE
</cfquery>
<cf_catalystHeader>
	<cfif not get_det_invoice.recordcount>
		<cfform action="#request.self#?fuseaction=invoice.emptypopup_setup_purchase_definition" name="cashes" method="post">
        <div class="row">
        	<div class="col col-12 uniqueRow">
            	<div class="row formContent">
                	<div class="row" type="row">
                    	<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        	<div class="form-group" id="item-a_disc">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57136.İskontolar'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                    	<cf_wrk_account_codes form_name='cashes' account_code="a_disc" is_sub_acc='0' is_multi_no = '1'>
										<input type="text" name="a_disc" id="a_disc" onkeyup="get_wrk_acc_code_1();" onFocus="AutoComplete_Create('a_disc','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','a_disc','','3','200');">
                                    	<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="pencere_ac('a_disc');"></span>
                                    </div>
                            	</div>
                            </div>
                            <div class="form-group" id="item-Perakende_S_I_F">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57824.Perakende Satış İade Faturası'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
                                    	<cf_wrk_account_codes form_name='cashes' account_code="Perakende_S_I_F" is_sub_acc='0' is_multi_no = '2'> 
										<input type="text" name="Perakende_S_I_F" id="Perakende_S_I_F" onkeyup="get_wrk_acc_code_2();" onFocus="AutoComplete_Create('Perakende_S_I_F','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','Perakende_S_I_F','','3','200');">
                                    	<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="pencere_ac('Perakende_S_I_F');"></span>
                                    </div>
                            	</div>
                            </div>
                            <div class="form-group" id="item-M_MAKBUZU">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57823.Müstahsil Makbuzu'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
										<cf_wrk_account_codes form_name='cashes' account_code="M_MAKBUZU" is_sub_acc='0' is_multi_no = '3'>
										<input type="text" name="M_MAKBUZU" id="M_MAKBUZU" onkeyup="get_wrk_acc_code_3();" onFocus="AutoComplete_Create('M_MAKBUZU','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','M_MAKBUZU','','3','200');">
                                    	<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="pencere_ac('M_MAKBUZU');"></span>
                                    </div>
                            	</div>
                            </div>
                            <div class="form-group" id="item-ALINAN_D_F">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57139.Demirbaş Alım Faturası'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
										<cf_wrk_account_codes form_name='cashes' account_code="ALINAN_D_F" is_sub_acc='0' is_multi_no = '4'>
										<input type="text" name="ALINAN_D_F" id="ALINAN_D_F" onkeyup="get_wrk_acc_code_4();" onFocus="AutoComplete_Create('ALINAN_D_F','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','ALINAN_D_F','','3','200');">
                                    	<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="pencere_ac('ALINAN_D_F');"></span>
                                    </div>
                            	</div>
                            </div>
                            <div class="form-group" id="item-YUVARLAMA_GELIR">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57304.Yuvarlama Gelir'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
										<cf_wrk_account_codes form_name='cashes' account_code="YUVARLAMA_GELIR" is_sub_acc='0' is_multi_no = '5'>
										<input type="text" name="YUVARLAMA_GELIR" id="YUVARLAMA_GELIR" onkeyup="get_wrk_acc_code_5();" onFocus="AutoComplete_Create('YUVARLAMA_GELIR','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','YUVARLAMA_GELIR','','3','200');">
                                    	<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="pencere_ac('YUVARLAMA_GELIR');"></span>
                                    </div>
                            	</div>
                            </div>
                            <div class="form-group" id="item-YUVARLAMA_GIDER">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57306.Yuvarlama Gider'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
										<cf_wrk_account_codes form_name='cashes' account_code="YUVARLAMA_GIDER" is_sub_acc='0' is_multi_no = '6'>
										<input type="text" name="YUVARLAMA_GIDER" id="YUVARLAMA_GIDER" onkeyup="get_wrk_acc_code_6();" onFocus="AutoComplete_Create('YUVARLAMA_GIDER','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','YUVARLAMA_GIDER','','3','200');">
                                    	<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="pencere_ac('YUVARLAMA_GIDER');"></span>
                                    </div>
                            	</div>
                            </div>
                            <div class="form-group" id="item-">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57243.Gelir Farkı'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
										<cf_wrk_account_codes form_name='cashes' account_code="FARK_GELIR" is_sub_acc='0' is_multi_no = '7'>
										<input type="text" name="FARK_GELIR" id="FARK_GELIR" onkeyup="get_wrk_acc_code_7();" onFocus="AutoComplete_Create('FARK_GELIR','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','FARK_GELIR','','3','200');">
                                    	<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="pencere_ac('FARK_GELIR');"></span>
                                    </div>
                            	</div>
                            </div>
                            <div class="form-group" id="item-FARK_GIDER">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57242.Gider Farkı'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
										<cf_wrk_account_codes form_name='cashes' account_code="FARK_GIDER" is_sub_acc='0' is_multi_no = '8'>
										<input type="text" name="FARK_GIDER" id="FARK_GIDER" onkeyup="get_wrk_acc_code_8();" onFocus="AutoComplete_Create('FARK_GIDER','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','FARK_GIDER','','3','200');">
                                    	<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="pencere_ac('FARK_GIDER');"></span>
                                    </div>
                            	</div>
                            </div>
                        </div>
          			</div>
                    <div class="row formContentFooter">
	                    <div class="col col-12">
	                        <cf_workcube_buttons type_format="1" is_upd='0'>
	                    </div>
                	</div>
        		</div>
        	</div>
        </div>
		</cfform> 
	<cfelse>
		<cfform name="cashes" action="#request.self#?fuseaction=invoice.emptypopup_setup_purchase_definition" method="post">
		<input type="hidden" name="UPD" id="UPD" value="1">
        <div class="row">
        	<div class="col col-12 uniqueRow">
            	<div class="row formContent">
                	<div class="row" type="row">
                    	<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                        	<div class="form-group" id="item-a_disc">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57136.İskontolar'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
										<cf_wrk_account_codes form_name='cashes' account_code="a_disc" is_sub_acc='0' is_multi_no = '1'>
										<input type="text" name="a_disc" id="a_disc" value="<cfoutput>#get_det_invoice.a_disc#</cfoutput>" onkeyup="get_wrk_acc_code_1();" onFocus="AutoComplete_Create('a_disc','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','a_disc','','3','200');">
                                    	<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="pencere_ac('a_disc');"></span>
                                    </div>
                            	</div>
                            </div>
                            <div class="form-group" id="item-Perakende_S_I_F">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57824.Perakende Satış İade Faturası'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
										<cf_wrk_account_codes form_name='cashes' account_code="Perakende_S_I_F" is_sub_acc='0' is_multi_no = '2'>
						 				<input type="text" name="Perakende_S_I_F" id="Perakende_S_I_F" value="<cfoutput>#get_det_invoice.Perakende_S_I_F#</cfoutput>" onkeyup="get_wrk_acc_code_2();" onFocus="AutoComplete_Create('Perakende_S_I_F','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','Perakende_S_I_F','','3','200');">
                                    	<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="pencere_ac('Perakende_S_I_F');"></span>
                                    </div>
                            	</div>
                            </div>
                            <div class="form-group" id="item-M_MAKBUZU">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57823.Müstahsil Makbuzu'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
										<cf_wrk_account_codes form_name='cashes' account_code="M_MAKBUZU" is_sub_acc='0' is_multi_no = '3'>
										<input type="text" name="M_MAKBUZU" id="M_MAKBUZU" value="<cfoutput>#get_det_invoice.m_makbuzu#</cfoutput>" onkeyup="get_wrk_acc_code_3();" onFocus="AutoComplete_Create('M_MAKBUZU','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','M_MAKBUZU','','3','200');">
                                    	<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="pencere_ac('M_MAKBUZU');"></span>
                                    </div>
                            	</div>
                            </div>
                            <div class="form-group" id="item-ALINAN_D_F">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57139.Demirbaş Alım Faturası'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
										<cf_wrk_account_codes form_name='cashes' account_code="ALINAN_D_F" is_sub_acc='0' is_multi_no = '4'>
										<input type="text" name="ALINAN_D_F" id="ALINAN_D_F" value="<cfoutput>#get_det_invoice.alinan_d_f#</cfoutput>" onkeyup="get_wrk_acc_code_4();" onFocus="AutoComplete_Create('ALINAN_D_F','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','ALINAN_D_F','','3','200');">
                                    	<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="pencere_ac('ALINAN_D_F');"></span>
                                    </div>
                            	</div>
                            </div>
                            <div class="form-group" id="item-YUVARLAMA_GELIR">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57304.Yuvarlama Gelir'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
										<cf_wrk_account_codes form_name='cashes' account_code="YUVARLAMA_GELIR" is_sub_acc='0' is_multi_no = '5'>
										<input type="text" name="YUVARLAMA_GELIR" id="YUVARLAMA_GELIR" value="<cfoutput>#get_det_invoice.yuvarlama_gelir#</cfoutput>" onkeyup="get_wrk_acc_code_5();" onFocus="AutoComplete_Create('YUVARLAMA_GELIR','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','YUVARLAMA_GELIR','','3','200');">
                                    	<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="pencere_ac('YUVARLAMA_GELIR');"></span>
                                    </div>
                            	</div>
                            </div>
                            <div class="form-group" id="item-YUVARLAMA_GIDER">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57306.Yuvarlama Gider'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
										<cf_wrk_account_codes form_name='cashes' account_code="YUVARLAMA_GIDER" is_sub_acc='0' is_multi_no = '6'>
										<input type="text" name="YUVARLAMA_GIDER" id="YUVARLAMA_GIDER" value="<cfoutput>#get_det_invoice.yuvarlama_gider#</cfoutput>" onkeyup="get_wrk_acc_code_6();" onFocus="AutoComplete_Create('YUVARLAMA_GIDER','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','YUVARLAMA_GIDER','','3','200');">
                                    	<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="pencere_ac('YUVARLAMA_GIDER');"></span>
                                    </div>
                            	</div>
                            </div>
                            <div class="form-group" id="item-FARK_GELIR">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57243.Gelir Farkı'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
										<cf_wrk_account_codes form_name='cashes' account_code="FARK_GELIR" is_sub_acc='0' is_multi_no = '7'>
										<input type="text" name="FARK_GELIR" id="FARK_GELIR" value="<cfoutput>#get_det_invoice.fark_gelir#</cfoutput>" onkeyup="get_wrk_acc_code_7();" onFocus="AutoComplete_Create('FARK_GELIR','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','FARK_GELIR','','3','200');">
                                    	<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="pencere_ac('FARK_GELIR');"></span>
                                    </div>
                            	</div>
                            </div>
                            <div class="form-group" id="item-FARK_GIDER">
                            	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57242.Gider Farkı'></label>
                                <div class="col col-8 col-xs-12">
                                	<div class="input-group">
										<cf_wrk_account_codes form_name='cashes' account_code="FARK_GIDER" is_sub_acc='0' is_multi_no = '8'>
										<input type="text" name="FARK_GIDER" id="FARK_GIDER" value="<cfoutput>#get_det_invoice.fark_gider#</cfoutput>" onkeyup="get_wrk_acc_code_8();" onFocus="AutoComplete_Create('FARK_GIDER','ACCOUNT_CODE','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','\'0\',0','ACCOUNT_CODE','FARK_GIDER','','3','200');">
                                    	<span class="input-group-addon icon-ellipsis btnPointer" title="" onclick="pencere_ac('FARK_GIDER');"></span>
                                    </div>
                            	</div>
                            </div>
                        </div>
        			</div>
                    <div class="row formContentFooter">
	                    <div class="col col-12">
	                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57461.Kaydet'></cfsavecontent><cf_workcube_buttons is_upd='0' type_format="1" insert_info='#message#' add_function='control_wrk()'>
	                    </div>
                	</div>
        		</div>
        	</div>
        </div>
		</cfform> 
	</cfif>
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
	Dizi_new[1]= new Array ('Perakende_S_I_F','<cf_get_lang dictionary_id="57824.Perakende Satış İade Faturası"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu">')
	Dizi_new[2]= new Array ('M_MAKBUZU','<cf_get_lang dictionary_id="57823.Müstahsil Makbuzu"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu">')
	Dizi_new[3]= new Array ('ALINAN_D_F','<cf_get_lang dictionary_id="57139.Demirbaş Alım Faturası"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu">')
	Dizi_new[4]= new Array ('YUVARLAMA_GELIR','<cf_get_lang dictionary_id="57304.Yuvarlama Gelir"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu">')
	Dizi_new[5]= new Array ('YUVARLAMA_GIDER','<cf_get_lang dictionary_id="57306.Yuvarlama Gider"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu">')
	Dizi_new[6]= new Array ('FARK_GELIR','<cf_get_lang dictionary_id="57243.Gelir Farkı"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu">')
	Dizi_new[7]= new Array ('FARK_GIDER','<cf_get_lang dictionary_id="57242.Gider Farkı"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu">')
	Dizi[0]= new Array ('a_disc','<cf_get_lang dictionary_id="57410.İskontolar Muhasebe Kodu"> <cf_get_lang dictionary_id="58981.Kayıtlı Değil">.')
	Dizi[1]= new Array ('Perakende_S_I_F','<cf_get_lang dictionary_id="57824.Perakende Satış İade Faturası"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu"> <cf_get_lang dictionary_id="58981.Kayıtlı Değil">.')
	Dizi[2]= new Array ('M_MAKBUZU','<cf_get_lang dictionary_id="57823.Müstahsil Makbuzu"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu"> <cf_get_lang dictionary_id="58981.Kayıtlı Değil">.')
	Dizi[3]= new Array ('ALINAN_D_F','<cf_get_lang dictionary_id="57139.Demirbaş Alım Faturası"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu"> <cf_get_lang dictionary_id="58981.Kayıtlı Değil">.')
	Dizi[4]= new Array ('YUVARLAMA_GELIR','<cf_get_lang dictionary_id="57304.Yuvarlama Gelir"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu"> <cf_get_lang dictionary_id="58981.Kayıtlı Değil">.')
	Dizi[5]= new Array ('YUVARLAMA_GIDER','<cf_get_lang dictionary_id="57306.Yuvarlama Gider"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu"> <cf_get_lang dictionary_id="58981.Kayıtlı Değil">.')
	Dizi[6]= new Array ('FARK_GELIR','<cf_get_lang dictionary_id="57243.Gelir Farkı"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu"> <cf_get_lang dictionary_id="58981.Kayıtlı Değil">.')
	Dizi[7]= new Array ('FARK_GIDER','<cf_get_lang dictionary_id="57242.Gider Farkı"> <cf_get_lang dictionary_id="58811.Muhasebe Kodu"> <cf_get_lang dictionary_id="58981.Kayıtlı Değil">.')
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
			alert('<cf_get_lang dictionary_id="57471.Eksik Veri">:'+Dizi_new[i][1]);
			return false;
		}
	}
	return true;
}
</script>
