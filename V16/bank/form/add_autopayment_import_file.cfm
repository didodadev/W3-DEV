<cf_xml_page_edit fuseact ="bank.popup_open_multi_prov_file">
<!---<cf_popup_box title="#getLang('bank',256)#">--->
<cfparam name="attributes.source" default="1">
<cfparam name="attributes.bank" default="">
<cfquery name="get_bank_names" datasource="#dsn#">
	SELECT BANK_ID,BANK_NAME FROM SETUP_BANK_TYPES ORDER BY BANK_NAME
</cfquery>
<cf_box title="#getLang('','',48875)#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="autopayment_import_file" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=bank.emptypopup_add_autopayment_import_file#xml_str#">
        <cf_box_elements>
            <cfinput type="hidden" name="modal_id" id="modal_id" value="#attributes.modal_id#">
            <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-source">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='48799.Kaynak'></label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="source" id="source" onchange="display_();">
                            <option value="1"><cf_get_lang no="139.Sistem Ödeme Planı"></option>
                            <option value="2"><cf_get_lang no="140.Fatura Ödeme Planı"></option>
                        </select>
                    </div> 
                </div> 
                <div class="form-group" id="bank_sistem" <cfif attributes.source eq 2>style="display:none;"</cfif>>
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57521.Banka'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="bank_type" id="bank_type" style="width:200px;">
                            <option value=""><cf_get_lang dictionary_id="57521.Banka"> <cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                            <option value="37"><cf_get_lang dictionary_id="48737.Akbank"></option>
                            <option value="41"><cf_get_lang dictionary_id="48739.Denizbank"></option>
                            <option value="31"><cf_get_lang dictionary_id="48765.Finansbank"></option>
                            <option value="42"><cf_get_lang dictionary_id="48776.Fortis"></option>
                            <option value="33"><cf_get_lang dictionary_id="48725.Garanti"></option>
                            <option value="30"><cf_get_lang dictionary_id="48720.HSBC"></option>
                            <option value="32"><cf_get_lang dictionary_id="48730.İşBankası"></option>
                            <option value="34"><cf_get_lang dictionary_id="48766.OyakBank"></option>
                            <option value="38"><cf_get_lang dictionary_id="48771.PTT"></option>
                            <option value="40"><cf_get_lang dictionary_id="48802.PTT Kapıda Ödeme"></option>
                            <option value="43"><cf_get_lang dictionary_id="48803.Yurtiçi Kapıda Ödeme"></option>
                            <option value="35"><cf_get_lang dictionary_id="48729.TEB"></option>
                            <option value="43"><cf_get_lang dictionary_id="48760.Vakıf Bank"></option>
                            <option value="36"><cf_get_lang dictionary_id="48784.YKB"></option>
                            <option value="39"><cf_get_lang dictionary_id="48774.Ziraat"></option>
                            <option value="44"><cf_get_lang dictionary_id="42726.Halkbank"></option>
                            <option value="45"><cf_get_lang dictionary_id="51519.Odeabank"></option>
                            <option value="46"><cf_get_lang dictionary_id="51551.Şekerbank"></option>
                        </select>	
                    </div>
                </div>         
                <div class="form-group" id="bank_fatura" <cfif attributes.source eq 1>style="display:none;"</cfif>>
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id="57521.Banka"> *</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <select name="bank" id="bank">
                            <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                            <cfoutput query="get_bank_names">
                                <option value="#bank_id#" <cfif attributes.bank eq bank_id>selected</cfif>>#bank_name#</option>
                            </cfoutput>
                        </select>				 
                    </div> 
                </div> 
                <div class="form-group" id="item-process_date">
                    <label  class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'>*</label>
                    <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <div class="input-group">
                            <!---<cfsavecontent variable="message">Tarih girmelisiniz</cfsavecontent>--->
                            <cfinput value="#dateformat(now(),dateformat_style)#" required="Yes" type="text" name="process_date" style="width:65px;" validate="#validate_style#" maxlength="10">
                            <span class="input-group-addon"><cf_wrk_date_image date_field="process_date"></span>				 
                        </div>
                    </div> 
                </div> 
                <div class="form-group" id="item-uploaded_file">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'> *</label>
                    <div  class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="file" name="uploaded_file" id="uploaded_file">
                    </div>
                </div> 
                <cfif is_encrypt_file eq 1><!--- xml den şifreleme yapılsn --->
                <div class="form-group" id="item-key_type">
                    <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='48918.Anahtar'>*</label>
                    <div  class="col col-8 col-md-8 col-sm-8 col-xs-12">
                        <input type="password" name="key_type" id="key_type" autocomplete="off" style="width:200px;">
                    </div>
                </div> 
                </cfif>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-12">
                <cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol()&&#iif(isdefined("attributes.draggable"),DE("loadPopupBox('autopayment_import_file' , #attributes.modal_id#)"),DE(""))#'>                        
            </div>  
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		<cfif is_encrypt_file eq 1>//xml den şifreleme yapılsn
			if(autopayment_import_file.key_type.value == "")
			{
				alert('<cfoutput>#getLang('bank',303)#</cfoutput>');
				return false;
			}
		</cfif>
		//Sistem Odeme Plani Secili Ise
		if(autopayment_import_file.source.value == 1 && autopayment_import_file.bank_type.value == "")
		{
			alert('<cfoutput>#getLang('bank',88)#</cfoutput>');
			return false;
		}
		//Fatura Odeme Plani Secili Ise
		if(autopayment_import_file.source.value==2 && autopayment_import_file.bank.value=="")
		{
			alert('<cfoutput>#getLang('bank',88)#</cfoutput>');
			return false;
		}
		return true;
	}
	/* Kaynak: Sistem Odeme Plani veya Fatura Odeme Plani */
	function display_()
	{
		if (autopayment_import_file.source.value == 1)
		{
			gizle(bank_fatura);
			goster(bank_sistem);
		}
		else
		{
			gizle(bank_sistem);
			goster(bank_fatura);
		}
	}
</script>
