<cf_get_lang_set module_name="cheque">
<cf_xml_page_edit fuseact="cheque.popup_add_self_cheque">
<cfparam name="attributes.modal_id" default="">
<cfinclude template="../query/get_money2.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','settings',58007)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfform name="add_cheque_entry" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_session&self_cheque=1&close_syf=1">
        	<cf_box_elements>
            	 <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50237.Banka Hesap No'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="hidden" name="portfoy_no" id="portfoy_no" value="">
                            <input type="hidden" name="cheque_id" id="cheque_id" value="">
                            <input type="hidden" name="acc_code" id="acc_code" value="">
                            <input type="hidden" name="tax_place" id="tax_place" value="">
                            <input type="hidden" name="tax_no" id="tax_no" value="">
                            <input type="hidden" name="BANK_NAME" id="BANK_NAME" value="">
                            <input type="hidden" name="BANK_BRANCH_NAME" id="BANK_BRANCH_NAME" value="">
                            <cf_wrkBankAccounts width='285' control_status = '1' call_function='get_cheque_no'>
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54490.Çek No'>*</label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='54614.Çek No Girmelisiniz !'></cfsavecontent>
                            <cfinput type="text" name="CHEQUE_NO" required="yes" validate="integer" onkeyup='isNumber(this);' message="#message#">
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='35578.İşlem Para Br'>*</label>
                        <div class="col col-6 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='29535.Lutfen Tutar Giriniz'></cfsavecontent>
                            <cfinput type="text" name="CHEQUE_VALUE" class="moneybox" onBlur='hesapla();' onKeyup='return(FormatCurrency(this,event));' required="yes" message="#message#">
                        </div>
                        <div class="col col-2 col-xs-12">
                            <select name="cheque_currency_id" id="cheque_currency_id" style="width:60px;" onChange="currency_control(this.value);" disabled="disabled">
                                <cfoutput query="get_money">
                                    <option value="#money#;#rate2#;#rate1#" <cfif money eq session.ep.money>selected</cfif>>#money#</option>
                                </cfoutput>
                            </select> 
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58177. Sistem Para Br'>*</label>
                        <div class="col col-8 col-xs-12">
                        	<div class="input-group">
                            <cfinput type="text" name="cheque_system_currency_value" onBlur='hesapla2();' onKeyup='return(FormatCurrency(this,event));' value="" class="moneybox" required="yes">
                            <span class="input-group-addon"><cfoutput>#session.ep.money#</cfoutput></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57640.Vade'> *</label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id='54668.Vade Girmelisiniz !'></cfsavecontent>
                                <cfinput type="text" name="CHEQUE_DUEDATE" value="" required="yes" validate="#validate_style#" message="#message#"style="width:150px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="CHEQUE_DUEDATE"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58181.Ödeme Yeri'></label>
                        <div class="col col-8 col-xs-12">
                        	<Input type="text" name="CHEQUE_CITY" id="CHEQUE_CITY" value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
                        <div class="col col-8 col-xs-12">
                        	<Input type="text" name="CHEQUE_CODE" id="CHEQUE_CODE" value="">
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58180.Borçlu'></label>
                        <div class="col col-8 col-xs-12">
                        	<input type="text" name="debtor_name" id="debtor_name" value="" maxlength="150">
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58178.Hesap No'></label>
                        <div class="col col-8 col-xs-12">
                        <input type="text" name="account_no" id="account_no" value="">
                        </div>
                    </div>
                    <cfif x_is_copy_cheque eq 1>
                        <div class="form-group" id="item-process_cat">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50472.Ardışık Çek Ekle'></label>
                        </div>
                    </cfif>
                     <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50474.Eklenecek Çek Sayısı'></label>
                        <div class="col col-8 col-xs-12">
                        	<input type="text" name="copy_cheque_count" id="copy_cheque_count" value="1" style="width:100px;" onKeyUp="isNumber(this);" maxlength="3" class="moneybox">
                        </div>
                    </div>
                    <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50475.Vade Artışı'></label>
                        <div class="col col-8 col-xs-12">
                            <select name="due_option" id="due_option" style="width:100px;" onChange="kontrol_due_option();">
                                <option value="1"><cf_get_lang dictionary_id='58932.Aylık'></option>
                                <option value="2"><cf_get_lang dictionary_id='58457.Günlük'></option>
                            </select>
                        </div>
                    </div>
                     <div class="form-group" id="item-process_cat">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50476.Artış Günü'></label>
                        <div class="col col-8 col-xs-12">
                        	<input type="text" name="due_day" id="due_day" style="width:100px;" onKeyUp="isNumber(this);" maxlength="3" class="moneybox">
                        </div>
                    </div>
                 </div>
                 <div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                	<div class="form-group">
                        <label class="col col-4 col-md-4 col-xs-12 bold padding-left-5"><cf_get_lang dictionary_id='50440.Döviz Kuru'> </label>
                    </div> 
                        <cfoutput>
                                <input type="hidden" name="kur_say" id="kur_say" value="#get_money.recordcount#">
                                <cfloop query="get_money">
                                    <input type="hidden" name="other_money#currentrow#" id="other_money#currentrow#" value="#money#">
                                    <input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
                                    <cfif session.ep.rate_valid eq 1>
                                     <cfset readonly_info = "yes">
                                    <cfelse>
                                     <cfset readonly_info = "no">
                                    </cfif>
                                    <div class="form-group">						
                                    <div class="col col-4 col-md-4 col-xs-12"></div>
                                    <div class="col col-2 col-md-2 col-xs-12">#money#</div>
                                    <div class="col col-1 col-md-1 col-xs-12"> #TLFormat(rate1,0)#</div>
                                    <div class="col col-1 col-md-1 col-xs-12"> /</div>
                                    <div class="col col-6 col-md-6 col-xs-12">
                                        <input type="text" class="box" <cfif readonly_info>readonly</cfif> name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,'#session.ep.our_company_info.rate_round_num#')#" style="width:100%;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla();" <cfif money is session.ep.money>readonly</cfif>>
                                   </div>      
                                </div>
                                </cfloop> 
                     </cfoutput>
                </div>
            </cf_box_elements>
            <cf_box_footer>
                <cfsavecontent variable="back_message"><cf_get_lang dictionary_id='51249.Yaptığınız Değişiklikleri Kaybedeceksiniz Emin misiniz'></cfsavecontent>
                <input type="button" value="<cf_get_lang dictionary_id='59031.Kaydet'>" onclick='control_currency()'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function kontrol_due_option()
	{
		if(document.add_cheque_entry.due_option.value == 2)
			due_day_tr.style.display='';
		else
			due_day_tr.style.display='none';
	}
	function get_cheque_no()
	{
		var get_cheque_no=wrk_safe_query('chq_get_cheque_no','dsn2',0,document.add_cheque_entry.account_id.value);
		if(get_cheque_no.recordcount > 0 && get_cheque_no.MAX_ID != '')
			new_cheque_no = parseFloat(get_cheque_no.MAX_ID) + 1;
		else
			new_cheque_no = 1;
		document.add_cheque_entry.CHEQUE_NO.value = new_cheque_no;
		<cfoutput query="get_money">
			if('#money#' == document.add_cheque_entry.currency_id.value)
				document.add_cheque_entry.cheque_currency_id[#currentrow-1#].selected = true;
		</cfoutput>
	}
	function control_currency()
	{   if(document.add_cheque_entry.CHEQUE_VALUE.value==""){alert("<cf_get_lang dictionary_id='29535.Lutfen Tutar Giriniz'>!"); return false;}
        if(document.add_cheque_entry.cheque_system_currency_value.value==""){alert("<cf_get_lang dictionary_id='29535.Lutfen Tutar Giriniz'>!"); return false;}
        if(document.add_cheque_entry.CHEQUE_DUEDATE.value==""){alert("<cf_get_lang dictionary_id='54668.Vade Girmelisiniz'>!"); return false;}    
		if(!acc_control()) return false;
		if(document.add_cheque_entry.account_id != undefined)
		{
			if(document.add_cheque_entry.currency_id.value != list_getat(document.add_cheque_entry.cheque_currency_id.value,1,';'))
			{
				alert("<cf_get_lang dictionary_id='50484.Banka ve Çekin Para Birimi Farklı'>!");
				return false;
			}
		}
		if(<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.order_money_type != undefined)
		{
			if(filterNum(document.add_cheque_entry.CHEQUE_VALUE.value) != <cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.order_amount.value)
			{
				alert("<cf_get_lang dictionary_id='50485.Çek Tutarı Ödeme Emrinin Tutarından Farklı Olamaz'> !");
				return false;
			}
		}
        unformat_fields();
        <cfoutput>#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_cheque_entry' , #attributes.modal_id#);"),DE(""))#</cfoutput>
        return false;
	}
	function unformat_fields()
	{
		document.add_cheque_entry.CHEQUE_VALUE.value = filterNum(document.add_cheque_entry.CHEQUE_VALUE.value);
		document.add_cheque_entry.cheque_system_currency_value.value = filterNum(document.add_cheque_entry.cheque_system_currency_value.value);
		document.getElementById('cheque_currency_id').disabled = false;
	}
	function currency_control(currency_type)
	{
		var system_currency = '<cfoutput>#session.ep.money#</cfoutput>';
		if(list_getat(currency_type,1,';') != system_currency)
			other_money.style.display='';
		else
			other_money.style.display='none';
		hesapla();
	}
	function hesapla()
	{
		if(document.add_cheque_entry.CHEQUE_VALUE.value != '')
		{
			var temp_cheque_value = filterNum(document.add_cheque_entry.CHEQUE_VALUE.value);
			var money_type=document.add_cheque_entry.cheque_currency_id.value;
			for(s=1;s<=add_cheque_entry.kur_say.value;s++)
			{
				if(eval("document.add_cheque_entry.other_money"+s).value== list_getat(money_type,1,';'))
				{
					form_txt_rate2_ = eval("document.add_cheque_entry.txt_rate2_"+s);
				}
			}
			form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.add_cheque_entry.cheque_system_currency_value.value = commaSplit(parseFloat(temp_cheque_value)*parseFloat(form_txt_rate2_.value ));
			document.add_cheque_entry.CHEQUE_VALUE.value = commaSplit(temp_cheque_value);
			form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		else
			document.add_cheque_entry.cheque_system_currency_value.value =0;
	}
	function hesapla2()
	{
		if(document.add_cheque_entry.cheque_system_currency_value.value != '')
		{
			var temp_cheque_value = filterNum(document.add_cheque_entry.cheque_system_currency_value.value);
			var cheque_value = filterNum(document.add_cheque_entry.CHEQUE_VALUE.value);
			var money_type=document.add_cheque_entry.cheque_currency_id.value;
			form_txt_rate2_ = commaSplit(parseFloat(temp_cheque_value)/parseFloat(cheque_value));
			form_txt_rate2_ = filterNum(form_txt_rate2_,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			for(s=1;s<=add_cheque_entry.kur_say.value;s++)
			{
				if(eval("document.add_cheque_entry.other_money"+s).value== list_getat(money_type,1,';'))
				{
					eval("document.add_cheque_entry.txt_rate2_"+s).value = commaSplit(form_txt_rate2_,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				}
			}
		}
		else
			document.add_cheque_entry.cheque_system_currency_value.value =0;
	}
	if(<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.order_money_type != undefined)
	{
		<cfoutput query="get_money">
			if('#money#' == <cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.order_money_type.value)
				document.add_cheque_entry.cheque_currency_id[#currentrow-1#].selected = true;
		</cfoutput>
		document.getElementById('cheque_currency_id').disabled = true;
		document.add_cheque_entry.CHEQUE_VALUE.value = commaSplit(<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.order_amount.value);
		hesapla();
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
