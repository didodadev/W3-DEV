<cf_xml_page_edit fuseact="cheque.popup_add_self_voucher">
<cf_get_lang_set module_name="cheque">
<cfinclude template="../query/get_cashes.cfm">
<cfinclude template="../query/get_money2.cfm">
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','settings',58008)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">           
	<cfform name="add_voucher_entry" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_voucher_session&self_voucher=1&close_syf=1" method="post">
		<cf_box_elements>
		<input type="hidden" name="voucher_id" id="voucher_id" value="">
		<input type="hidden" name="portfoy_no" id="portfoy_no" value="">
		<input type="hidden" name="bank_name" id="bank_name" value="">
		<input type="hidden" name="tax_place" id="tax_place" value="">
		<input type="hidden" name="tax_no" id="tax_no" value="">
		<input type="hidden" name="bank_branch_name" id="bank_branch_name" value="">
		<input type="hidden" name="account_no" id="account_no" value="">
		<input type="hidden" name="acc_code" id="acc_code" value="">
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57520.Kasa'></label>
				<div class="col col-8 col-md-8 col-xs-12">
					<select name="cash_id" id="cash_id" style="width:150px;" onchange="setCurrency(this.id)">
						<cfoutput query="get_cashes">
							<option value="#cash_id#">#cash_name#-#cash_currency_id#</option>
						</cfoutput>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58502.Senet No'> *</label>
				<div class="col col-8 col-md-8 col-xs-12">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='50332.Senet No Girmelisiniz'></cfsavecontent>
						<cfInput type="text" name="VOUCHER_NO" required="yes" message="#message#" style="width:150px;" onkeyup="isNumber(this);">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
				<div class="col col-8 col-md-8 col-xs-12">
					<Input type="text" name="VOUCHER_CODE" id="VOUCHER_CODE" value="" style="width:150px;">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58181.Ödeme Yeri'></label>
				<div class="col col-8 col-md-8 col-xs-12">
					<input type="text" name="VOUCHER_CITY" id="VOUCHER_CITY" value="" style="width:150px;">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='35578.İşlem Para Br'> *</label>
				<div class="col col-8 col-md-8 col-xs-12">
					<div class="col col-9 col-md-9 col-xs-12">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='54493.Lutfen Tutar Giriniz'></cfsavecontent>
					<cfinput type="text" name="VOUCHER_VALUE" onBlur="hesapla();" onkeyup="return(FormatCurrency(this,event));" required="yes" message="#message#" style="width:85px;" class="moneybox">
				</div><div class="col col-3 col-md-3 col-xs-12">
					<select name="CURRENCY_ID" id="CURRENCY_ID" style="width:60px;" onChange="currency_control(this.value);">
						<cfoutput query="get_money">
							<option value="#money#;#rate2#;#rate1#" <cfif money eq session.ep.money>selected</cfif>>#money#</option>
						</cfoutput>
					</select> 
				</div>
				</div>
			</div>
			<div class="form-group"  id="other_money" style="display:none;">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58177. Sistem Para Br'>*</label>
				<div class="col col-8 col-md-8 col-xs-12">
					<div class="input-group">
					<cfsavecontent variable="alert"><cf_get_lang dictionary_id='54493.Lutfen Tutar Giriniz'></cfsavecontent>
						<cfinput type="text" name="voucher_system_currency_value" onBlur="hesapla2();" onKeyup="return(FormatCurrency(this,event));" value="" class="moneybox" required="yes" message="#alert#">
						<span class="input-group-addon">
						<cfoutput>#session.ep.money#</cfoutput>
					</span>
				</div>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='57640.Vade'> *</label>
				<div class="col col-8 col-md-8 col-xs-12">
					<div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='50089.Vade Girmelisiniz !'></cfsavecontent>
						<cfinput value="" required="Yes" message="#message#" type="text" name="VOUCHER_DUEDATE"  validate="#validate_style#">
						<span class="input-group-addon">
						<cf_wrk_date_image date_field="VOUCHER_DUEDATE">
					</span>
					</div>
				</div>
			</div>
		<cfif x_is_copy_voucher eq 1>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='50490.Ardışık Senet Ekle'></label>
				<div class="col col-8 col-md-8 col-xs-12">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='50492.Eklenecek Senet Sayısı'></label>
				<div class="col col-8 col-md-8 col-xs-12">
					<input type="text" name="copy_voucher_count" id="copy_voucher_count" value="1"  onKeyUp="isNumber(this);" maxlength="3" class="moneybox">
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='48789.Vade Artışı'></label>
				<div class="col col-8 col-md-8 col-xs-12">
					<select name="due_option" id="due_option"  onChange="kontrol_due_option();">
						<option value="1"><cf_get_lang dictionary_id='58932.Aylık'></option>
						<option value="2"><cf_get_lang dictionary_id='58457.Günlük'></option>
					</select>
				</div>
			</div>
			<div class="form-group"  id="due_day_tr" style="display:none;">
				<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang dictionary_id='48790.Artış Günü'></label>
				<div class="col col-8 col-md-8 col-xs-12">
					<input type="text" name="due_day" id="due_day" onKeyUp="isNumber(this);" maxlength="3" class="moneybox">
				</div>
			</div>
		</cfif>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
			<div class="form-group">
				<label class="col col-4 col-md-4 col-sm-4 col-xs-12 bold padding-left-5"><cf_get_lang dictionary_id='50440.Döviz Kuru'></label>
				<label class="col col-8 col-md-8 col-sm-8 col-xs-12"></label>
			</div>
			<cfoutput>
				<input type="hidden" name="kur_say" id="kur_say" value="#get_money.recordcount#">
				<cfloop query="get_money">
				<div class="form-group">
					<input type="hidden" name="other_money#currentrow#" id="other_money#currentrow#" value="#money#">
					<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
					<cfif session.ep.rate_valid eq 1>
						<cfset readonly_info = "yes">
					<cfelse>
						<cfset readonly_info = "no">
					</cfif>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12"></div>
					<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
					#money#
					</div>
					<label class="col col-1 col-md-1 col-sm-1 col-xs-12 text-right">#TLFormat(rate1,0)#/</label>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<input type="text" <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,'#session.ep.our_company_info.rate_round_num#')#" style="width:50px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla();" <cfif money is session.ep.money>readonly</cfif>>
				        </div>
			    </div>
				</cfloop>
			</cfoutput>
		</div>
	</cf_box_elements>
		<cf_box_footer><input type="button" value="<cf_get_lang dictionary_id='50329.Senet Ekle'>" onclick='kontrol()'></cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	$(document).ready(function(){
		document.getElementById('CURRENCY_ID').disabled = true;
		setCurrency('cash_id');	
	})
	function kontrol()
	{
		if(document.add_voucher_entry.VOUCHER_NO.value==""){alert("<cf_get_lang dictionary_id='50332.Senet No Girmelisiniz'>!"); return false;}
		if(document.add_voucher_entry.VOUCHER_VALUE.value==""){alert("<cf_get_lang dictionary_id='29535.Lutfen Tutar Giriniz'>!"); return false;}
        if(document.add_voucher_entry.voucher_system_currency_value.value==""){alert("<cf_get_lang dictionary_id='29535.Lutfen Tutar Giriniz'>!"); return false;}
        if(document.add_voucher_entry.VOUCHER_DUEDATE.value==""){alert("<cf_get_lang dictionary_id='54668.Vade Girmelisiniz'>!"); return false;}    
		unformat_fields();
		document.getElementById('CURRENCY_ID').disabled = false;
		<cfoutput>#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_voucher_entry' , #attributes.modal_id#);"),DE(""))#</cfoutput>
		return false;
	}
	function kontrol_due_option()
	{
		if(document.add_voucher_entry.due_option.value == 2)
			due_day_tr.style.display='';
		else
			due_day_tr.style.display='none';
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
	function setCurrency(currencyType)
	{
		document.getElementById('CURRENCY_ID').disabled = false;
		currency = list_last($("#"+currencyType+' :selected').text(),'-');
		
		$("#CURRENCY_ID option:selected").removeAttr('selected');
		$("#CURRENCY_ID").find("option").each(function(index,element){
				if($(element).text() == currency)
				{
					$(element).attr('selected','selected');
				}
			})
		currency_control(document.getElementById('CURRENCY_ID').value);
		document.getElementById('CURRENCY_ID').disabled = true;
	}
	function hesapla()
	{
		if(document.add_voucher_entry.VOUCHER_VALUE.value != '')
		{
			var temp_voucher_value = filterNum(document.add_voucher_entry.VOUCHER_VALUE.value);
			var money_type=document.add_voucher_entry.CURRENCY_ID[document.add_voucher_entry.CURRENCY_ID.options.selectedIndex].value;
			for(s=1;s<=add_voucher_entry.kur_say.value;s++)
			{
				if(eval("document.add_voucher_entry.other_money"+s).value== list_getat(money_type,1,';'))
				{
					form_txt_rate2_ = eval("document.add_voucher_entry.txt_rate2_"+s);
				}
			}
			form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.add_voucher_entry.voucher_system_currency_value.value = commaSplit(parseFloat(temp_voucher_value)*parseFloat(form_txt_rate2_.value ));
			document.add_voucher_entry.VOUCHER_VALUE.value = commaSplit(temp_voucher_value);
			form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		else
			document.add_voucher_entry.voucher_system_currency_value.value =0;
	}
	function hesapla2()
	{
		if(document.add_voucher_entry.voucher_system_currency_value.value != '')
		{
			var temp_voucher_value = filterNum(document.add_voucher_entry.voucher_system_currency_value.value);
			var voucher_value = filterNum(document.add_voucher_entry.VOUCHER_VALUE.value);
			var money_type=document.add_voucher_entry.CURRENCY_ID[document.add_voucher_entry.CURRENCY_ID.options.selectedIndex].value;
			form_txt_rate2_ = commaSplit(parseFloat(temp_voucher_value)/parseFloat(voucher_value));
			form_txt_rate2_ = filterNum(form_txt_rate2_,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			for(s=1;s<=add_voucher_entry.kur_say.value;s++)
			{
				if(eval("document.add_voucher_entry.other_money"+s).value== list_getat(money_type,1,';'))
				{
					eval("document.add_voucher_entry.txt_rate2_"+s).value = commaSplit(form_txt_rate2_,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				}
			}
		}
		else
			document.add_voucher_entry.voucher_system_currency_value.value =0;
	}
	function unformat_fields()
	{
		document.add_voucher_entry.VOUCHER_VALUE.value=filterNum(document.add_voucher_entry.VOUCHER_VALUE.value);
		document.add_voucher_entry.voucher_system_currency_value.value=filterNum(document.add_voucher_entry.voucher_system_currency_value.value);
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
