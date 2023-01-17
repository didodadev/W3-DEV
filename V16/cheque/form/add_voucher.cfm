<cf_xml_page_edit fuseact="cheque.popup_add_voucher">
<cf_get_lang_set module_name="cheque">
	<cfparam name="attributes.modal_id" default="">
<cfinclude template="../query/get_money2.cfm">
<cf_box title="#getLang('','settings',58008)#"  scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">	<!---senet ekle--->
	<cfform name="add_voucher_entry" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_voucher_session&close_syf=1" method="post">
		<cf_box_elements>
		<input type="hidden" name="voucher_id" id="voucher_id" value="">
		<input type="hidden" name="portfoy_no" id="portfoy_no" value="">
		<input type="hidden" name="bank_name" id="bank_name" value="">
		<input type="hidden" name="tax_place" id="tax_place" value="">
		<input type="hidden" name="tax_no" id="tax_no" value="">
		<input type="hidden" name="bank_branch_name" id="bank_branch_name" value="">
		<input type="hidden" name="account_no" id="account_no" value="">
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<cfif x_is_add_pay_term eq 1>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"></label>
					<div class="col col-8 col-md-8 col-xs-12">
						<input type="checkbox" name="is_pay_term" id="is_pay_term" value="1"><cf_get_lang_main no='2148.Ödeme Sözü'>
					</div>
				</div>
			</cfif>
			<div class="form-group">
				<label class="col col-4 col-md-4 col-xs-12"></label>
				<div class="col col-8 col-md-8 col-xs-12">
					<input type="checkbox" name="self_voucher_" id="self_voucher_" value="1" checked><cf_get_lang no='296.Müşteri Senedi İse Seçili Değil'>
				</div>
			</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no='1090.Senet No'>*</label>
						<div class="col col-8 col-md-8 col-xs-12">
						<cfinput type="text" name="VOUCHER_NO" style="width:150px;" onkeyup="isNumber(this);" onblur='isNumber(this);'>
					</div>
				</div>
				<cfif x_is_account_code eq 1>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-xs-12"> <cf_get_lang no='101.Muhasebe Hesabı'> *</label>
							<div class="col col-8 col-md-8 col-xs-12">
							<div class="input-group">
							<input type="hidden" name="acc_code" id="acc_code" value="">
							<cfinput type="text" style="width:150px;" name="acc_name" required="yes" message="<cf_get_lang no='101.Muhasebe Hesabı'>" readonly>
							<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_id=add_voucher_entry.acc_code</cfoutput>&field_name=add_voucher_entry.acc_name' , 'list');">
							</span> 				  
							</div>
						</div>
					</div>
				</cfif>
				<div class="form-group">	
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no='769.Ödeme Yeri'> <cfif x_is_voucher_city eq 1> *</cfif> </label>
					<div class="col col-8 col-md-8 col-xs-12">	
					<input type="text" name="VOUCHER_CITY" id="VOUCHER_CITY" style="width:150px;">
				 	</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no='768.Borçlu'> <cfif x_is_debtor_name eq 1> *</cfif> </label>
					<div class="col col-8 col-md-8 col-xs-12">
					<Input type="text" name="DEBTOR_NAME" id="DEBTOR_NAME" value="" style="width:150px;">			  
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no='377.Özel Kod'><cfif x_is_voucher_code eq 1> *</cfif> </label>
					<div class="col col-8 col-md-8 col-xs-12"><input type="text" name="voucher_code" id="voucher_code" value="" style="width:150px;">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang no ='77.İşlem Para Br'> *</label>
						<div class="col col-8 col-md-8 col-xs-12">
						<div class="col col-9 col-md-9 col-xs-12">
						<cfinput type="text" name="VOUCHER_VALUE" class="moneybox" onBlur="hesapla();" onkeyup="return(FormatCurrency(this,event));" onFocus="if(this.value == '') this.value = 0;" style="width:97px;" >
						</div><div class="col col-3 col-md-3 col-xs-12">
						<select name="CURRENCY_ID" id="CURRENCY_ID" style="width:50px;" onChange="currency_control(this.value);">
						<cfoutput query="get_money">
						<option value="#money#;#rate2#;#rate1#" <cfif money eq session.ep.money>selected</cfif>>#money#</option>
						</cfoutput>
						</select>
					</div>
				</div>
				</div>
				<div class="form-group" id="other_money" style="display:none;">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang no='68. Sistem Para Br'>*
					</label><div class="col col-8 col-md-8 col-xs-12">
						<div class="col col-9 col-md-9 col-xs-12">
						<cfinput type="text" name="voucher_system_currency_value" onBlur="hesapla2();" onKeyup="return(FormatCurrency(this,event));" style="width:100px;" value="" class="moneybox" required="yes" message="Tutar Giriniz!">
					</div><div class="col col-3 col-md-3 col-xs-12"><cfoutput>#session.ep.money#</cfoutput>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no='228.Vade'>*</label>
					<div class="col col-8 col-md-8 col-xs-12">
						<div class="input-group">
					<cfinput value="" type="text" name="VOUCHER_DUEDATE" style="width:97px;" validate="#validate_style#">
					<span class="input-group-addon btnPointer">
					<cf_wrk_date_image date_field="VOUCHER_DUEDATE">
					</span>
					</div>
					</div>
				</div>
				<cfif x_is_copy_voucher eq 1>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang no='295.Ardışık Senet Ekle'></label>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang no='297.Eklenecek Senet Sayısı'></label>
							<div class="col col-8 col-md-8 col-xs-12">							
								<input type="text" name="copy_voucher_count" id="copy_voucher_count" value="1" style="width:100px;" onKeyUp="isNumber(this);" maxlength="3" class="moneybox">
							</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang no='280.Vade Artışı'></label>
							<div class="col col-8 col-md-8 col-xs-12">	
							<select name="due_option" id="due_option" style="width:100px;" onChange="kontrol_due_option();">
								<option value="1"><cf_get_lang_main no='1520.Aylık'></option>
								<option value="2"><cf_get_lang_main no='1045.Günlük'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="due_day_tr" style="display:none;">
						<td><cf_get_lang no='281.Artış Günü'></td>
						<td>
							<input type="text" name="due_day" id="due_day" style="width:100px;" onKeyUp="isNumber(this);" maxlength="3" class="moneybox">
						</td>
					</div>	
				</cfif>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<cfoutput>
						<div class="form-group">
						<label class="col col-4 col-md-4 col-xs-12 bold padding-left-5" ><cf_get_lang no='245.Döviz Kuru'></label>
						<label class="col col-8 col-md-8 col-xs-12" ></label>
						</div>
						<input type="hidden" name="kur_say" id="kur_say" value="#get_money.recordcount#">
						<cfif len(session.ep.money2)>
							<cfset selected_money=session.ep.money2>
						<cfelse>
							<cfset selected_money=session.ep.money>
						</cfif>
						<cfloop query="get_money">
							<div class="form-group"> 
								<label class="col col-4 col-md-4 col-xs-12"></label>
								<div class="col col-8 col-md-8 col-xs-12">
								<cfif session.ep.rate_valid eq 1>
									<cfset readonly_info = "yes">
								<cfelse>
									<cfset readonly_info = "no">
								</cfif>
								<input type="hidden" name="other_money#currentrow#" id="other_money#currentrow#" value="#money#">
								<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
								<div class="col col-2 col-md-2 col-xs-12">#money#</div>
								<div class="col col-2 col-md-2 col-xs-12">#TLFormat(rate1,0)#</div>
								<div class="col col-1 col-md-1 col-xs-12">/</div>
								<div class="col col-7 col-md-7 col-xs-12">
									<input type="text" class="box" <cfif readonly_info>readonly</cfif> name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,'#session.ep.our_company_info.rate_round_num#')#" style="width:50px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla();" <cfif money is session.ep.money>readonly</cfif>>
								</div>
							</div>
							</div>
						</cfloop>
					</cfoutput>

		</div>
	</cf_box_elements>
	<cf_box_footer>
		<cf_workcube_buttons type_format="1" is_upd='0' add_function='kontrol_add()'>
	</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	function kontrol_due_option()
	{
		if(document.add_voucher_entry.due_option.value == 2)
			due_day_tr.style.display='';
		else
			due_day_tr.style.display='none';
	}
	function kontrol_add()
	{
		<cfif x_is_account_code eq 1>
			if(document.add_voucher_entry.acc_code.value == "")
			{
				alert("<cf_get_lang dictionary_id='43202.Muhasebe Hesabı Seçiniz'> !");
				return false;
			}
		</cfif>
		if(document.add_voucher_entry.VOUCHER_NO.value == "")
		{
			alert("<cf_get_lang no='137.Senet No Girmelisiniz'> !");
			return false;
		}
		if(document.add_voucher_entry.VOUCHER_VALUE.value == "")
		{
			alert("<cf_get_lang_main no='1738.Lutfen Tutar Giriniz'>");
			return false;
		}
		if(document.add_voucher_entry.VOUCHER_DUEDATE.value == "")
		{
			alert("<cf_get_lang no='8.Vade Girmelisiniz !'>");
			return false;
		}
		<cfif x_is_voucher_city eq 1>
			if(document.add_voucher_entry.VOUCHER_CITY.value=="")
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='769.Ödeme Yeri'>");
				return false;
			}
		</cfif> 
		<cfif x_is_debtor_name eq 1>
			if(document.add_voucher_entry.DEBTOR_NAME.value=="")
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='768.Borçlu'>");
				return false;
			}
		</cfif>
		<cfif x_is_voucher_code eq 1>
			if(document.add_voucher_entry.voucher_code.value=="")
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='377.Özel Kod'>");
				return false;
			}
		</cfif>
		document.add_voucher_entry.VOUCHER_VALUE.value=filterNum(document.add_voucher_entry.VOUCHER_VALUE.value);
		document.add_voucher_entry.voucher_system_currency_value.value=filterNum(document.add_voucher_entry.voucher_system_currency_value.value);
		document.getElementById('CURRENCY_ID').disabled = false;
		<cfoutput>#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_voucher_entry' , #attributes.modal_id#);"),DE(""))#</cfoutput>
		return false; 
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
		if(document.add_voucher_entry.VOUCHER_VALUE.value != '')
		{
			var temp_voucher_value = filterNum(document.add_voucher_entry.VOUCHER_VALUE.value);
			var money_type=document.add_voucher_entry.CURRENCY_ID[document.add_voucher_entry.CURRENCY_ID.options.selectedIndex].value;
			for(s=1;s<=add_voucher_entry.kur_say.value;s++)
			{
				if(eval("document.add_voucher_entry.other_money"+s).value== list_getat(money_type,1,';'))
				{
					form_txt_rate2_ = eval("document.add_voucher_entry.txt_rate2_"+s);
					form_txt_rate1_ = eval("document.add_voucher_entry.txt_rate1_"+s);
				}
			}
			form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			form_txt_rate1_.value = filterNum(form_txt_rate1_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.add_voucher_entry.voucher_system_currency_value.value = commaSplit(parseFloat(temp_voucher_value)*parseFloat(form_txt_rate2_.value)/parseFloat(form_txt_rate1_.value));
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
			var money_type=document.add_voucher_entry.CURRENCY_ID[document.add_voucher_entry.CURRENCY_ID.options.selectedIndex].value;
			for(s=1;s<=add_voucher_entry.kur_say.value;s++)
			{
				if(eval("document.add_voucher_entry.other_money"+s).value== list_getat(money_type,1,';'))
				{
					form_txt_rate2_ = eval("document.add_voucher_entry.txt_rate2_"+s);
					form_txt_rate1_ = eval("document.add_voucher_entry.txt_rate1_"+s);
				}
			}
			form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			form_txt_rate1_.value = filterNum(form_txt_rate1_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.add_voucher_entry.VOUCHER_VALUE.value = commaSplit(parseFloat(temp_voucher_value)*parseFloat(form_txt_rate1_.value)/parseFloat(form_txt_rate2_.value));
			document.add_voucher_entry.voucher_system_currency_value.value = commaSplit(temp_voucher_value);
			form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		else
			document.add_voucher_entry.VOUCHER_VALUE.value = "";
	}
	if(<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cash_id != undefined)
	{
		<cfoutput query="get_money">
			if('#money#' == list_getat(<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cash_id.value,3,';'))
				document.add_voucher_entry.CURRENCY_ID[#currentrow-1#].selected = true;
		</cfoutput>
		document.getElementById('CURRENCY_ID').disabled = true;
		currency_control(document.getElementById('CURRENCY_ID').value);
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

