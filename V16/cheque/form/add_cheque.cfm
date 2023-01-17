<cf_xml_page_edit fuseact="cheque.popup_add_cheque">
<cf_get_lang_set module_name="cheque">
	<cfparam name="attributes.modal_id" default="">
<cfinclude template="../query/get_money2.cfm">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','settings',58007)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"><!--- cek ekle --->
		<cfform name="add_cheque_entry" method="post" target="_blank" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_add_session&close_syf=1">
			<cf_box_elements>
				<input type="hidden" name="portfoy_no" id="portfoy_no" value="">
				<input type="hidden" name="cheque_id" id="cheque_id" value="">
				<input type="hidden" name="acc_code" id="acc_code" value="">
				<input type="hidden" name="payroll_entry" id="payroll_entry" value="1">
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="1" type="column" sort="true">
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='40910.Çek No'> *</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfinput type="text" name="CHEQUE_NO">
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57521.Banka'><cfif x_is_bank eq 1>*</cfif></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif x_is_select_bank eq 1>
								<cf_wrkBankNames
									form_name="add_cheque_entry"
									width="150"
									boxwidth="340"
									boxheight="250" 
									draggable="1">
							<cfelse>
								<input type="text" name="bank_name" id="bank_name">	
							</cfif>
						</div>					
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58941.Subesi'> <cfif x_is_branch eq 1>*</cfif></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfif x_is_select_bank eq 1>
								<cf_wrkBankBranch
									kontrol_bank_name="1"
									form_name="add_cheque_entry"
									width="150"
									boxwidth="340"
									boxheight="250"
									draggable="1">
							<cfelse>
								<input type="text" name="bank_branch_name" id="bank_branch_name">	
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='35578.İşlem Para Br'> *</label>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<cfinput type="text" name="CHEQUE_VALUE" class="moneybox" onBlur="hesapla();" onKeyup="(FormatCurrency(this,event));">
						</div>
						<div class="col col-2 col-md-2 col-sm-2 col-xs-12">
							<select name="cheque_currency_id" id="cheque_currency_id" onChange="currency_control(this.value);">
								<cfoutput query="get_money">
									<option value="#money#;#rate2#;#rate1#" <cfif money eq session.ep.money>selected</cfif>>#money#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="other_money" style="display:none;">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='54901. Sistem Para Br'> *</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
							<cfinput type="text" name="cheque_system_currency_value" onBlur="hesapla2();" onKeyup="return(FormatCurrency(this,event));" value="" class="moneybox" required="yes">
							<span class="input-group-addon"><cfoutput>#session.ep.money#</cfoutput></span>
						</div></div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57881.Vade Tarihi'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57782.Tarih Değerini Kontrol Ediniz'>!</cfsavecontent>
							<div class="input-group">
								<cfinput type="text" name="CHEQUE_DUEDATE" id="CHEQUE_DUEDATE" value="" validate="#validate_style#" message="#message#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="CHEQUE_DUEDATE">
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58178.Hesap No'> <cfif x_is_account eq 1>*</cfif></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="ACCOUNT_NO" id="ACCOUNT_NO">
							<input type="hidden" name="account_id" id="account_id">
						</div>
					</div>
				</div>
				<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="2" type="column" sort="true">
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58181.Ödeme Yeri'> <cfif x_is_paycity eq 1>*</cfif></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="CHEQUE_CITY" id="CHEQUE_CITY"></div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58180.Borçlu'> <cfif x_is_debtor_name eq 1>*</cfif></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="DEBTOR_NAME" id="DEBTOR_NAME" maxlength="150" value=""></div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'> <cfif x_is_ozelkod eq 1>*</cfif></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="CHEQUE_CODE" id="CHEQUE_CODE"> </div>	
					</div>
					<div class="form-group">	  
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58762.Vergi Dairesi'><cfif x_is_tax_place eq 1>*</cfif></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="TAX_PLACE" id="TAX_PLACE"></div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='59211.Cari Hesap Çeki'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="checkbox" name="self_cheque_" id="self_cheque_" value="1" checked> (<cf_get_lang dictionary_id='50302.Müşteri çeki değilse seçili değil'>)</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57752.Vergi No'> <cfif x_is_tax_no eq 1>*</cfif></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="TAX_NO" id="TAX_NO"></div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58970.Ciro Eden'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="endorsement_member" id="endorsement_member" maxlength="150"></div>
					</div>
				</div>
				<cfoutput>					
					<cfif x_is_copy_cheque eq 1>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="3" type="column" sort="true">
							<div class="form-group">
								<label class="col col-12 col-md-12 col-sm-12 col-xs-12 bold"><cf_get_lang dictionary_id='50472.Ardışık Çek Ekle'></label>
							</div>
								<div class="form-group">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50474.Eklenecek Çek Sayısı'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<input type="text" name="copy_cheque_count" id="copy_cheque_count" value="1" onKeyUp="isNumber(this);" maxlength="3" class="moneybox">
									</div>
								</div>
								<div class="form-group">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50475.Vade Artışı'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<select name="due_option" id="due_option" onChange="kontrol_due_option();">
											<option value="1"><cf_get_lang dictionary_id='58932.Aylık'></option>
											<option value="2"><cf_get_lang dictionary_id='58457.Günlük'></option>
										</select>
									</div>
								</div>
								<div class="form-group" id="due_day_tr" style="display:none;">
									<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='50476.Artış Günü'></label>
									<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
										<input type="text" name="due_day" id="due_day" onKeyUp="isNumber(this);" maxlength="3" class="moneybox">
									</div>
								</div>	
							</div>
					</cfif>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12" index="4" type="column" sort="true">
						<div class="form-group">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12 bold padding-left-5"></label>
							<label class="col col-8 col-md-8 col-sm-8 col-xs-12 bold padding-left-5"><cf_get_lang dictionary_id='50440.Döviz Kuru'></label>
						</div>
						<input type="hidden" name="kur_say" id="kur_say" value="#get_money.recordcount#">
						<cfloop query="get_money">
							<div class="form-group">
								<cfif session.ep.rate_valid eq 1>
									<cfset readonly_info = "yes">
								<cfelse>
									<cfset readonly_info = "no">
								</cfif>
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12"></div>
								<div class="col col-3 col-md-3 col-sm-3 col-xs-12">
									<input type="text" name="other_money#currentrow#" id="other_money#currentrow#" class="boxtext" value="#money#">
								</div>
								<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
								<label class="col col-1 col-md-1 col-sm-1 col-xs-12 text-right">#TLFormat(rate1,0)#/</label>
								<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="text" <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,'#session.ep.our_company_info.rate_round_num#')#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla();" <cfif money is session.ep.money>readonly</cfif>></div>
							</div>
						</cfloop>
					</div>
				</cfoutput>
			</cf_box_elements>
			<cf_box_footer>
				<input type="button" value="<cf_get_lang dictionary_id='57461.Kaydet'>"  onclick='kontrol2()'>
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
	function kontrol2()
	{	
		if(document.add_cheque_entry.CHEQUE_NO.value == "")
		{
			alert("<cf_get_lang dictionary_id='54614.Çek No Girmelisiniz'>");
			return false;
		}
		if(document.add_cheque_entry.CHEQUE_VALUE.value == "")
		{
			alert("<cf_get_lang dictionary_id='63618.Lütfen İşlem Para Birimi Giriniz'>");
			return false;
		}
		if(document.add_cheque_entry.CHEQUE_DUEDATE.value == "")
		{
			alert("<cf_get_lang dictionary_id='54668.Vade Girmelisiniz'>");
			return false;
		}
		<cfif x_is_paycity eq 1>
			if(document.add_cheque_entry.CHEQUE_CITY.value == "")
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58181.Ödeme Yeri'>");
				return false;
			}
		</cfif>
		<cfif x_is_ozelkod eq 1>
			if(document.add_cheque_entry.CHEQUE_CODE.value=="")
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57789.Özel Kod'>");
				return false;
			}
		</cfif>
		<cfif x_is_bank eq 1>
			if(document.add_cheque_entry.bank_name.value=="")
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57521.Banka'>");
				return false;
			}
		</cfif>
		<cfif x_is_branch eq 1>
			if(document.add_cheque_entry.bank_branch_name.value=="")
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58933.Banka Şubesi'>");
				return false;
			}
		</cfif>
		<cfif x_is_account eq 1>
			if(document.add_cheque_entry.ACCOUNT_NO.value=="")
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58178.Hesap No'>");
				return false;
			}
		</cfif>
		<cfif x_is_debtor_name eq 1>
			if(document.add_cheque_entry.DEBTOR_NAME.value=="")
				{
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58180.Borçlu'>");
					return false;
				}
		</cfif>
		<cfif x_is_tax_place eq 1>
			if(document.add_cheque_entry.TAX_PLACE.value=="")
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58762.Vergi Dairesi'>");
				return false;
			}
		</cfif>
		<cfif x_is_tax_no eq 1>
			if(document.add_cheque_entry.TAX_NO.value=="")
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57752.Vergi No'>");
				return false;
			}
		</cfif>		
		if(document.add_cheque_entry.self_cheque_.checked==false)
		{
			if(document.add_cheque_entry.endorsement_member.value=="")
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='58970.Ciro Eden'>");
				return false;
			}	
		}			
		document.add_cheque_entry.CHEQUE_VALUE.value=filterNum(document.add_cheque_entry.CHEQUE_VALUE.value);
		document.add_cheque_entry.cheque_system_currency_value.value=filterNum(document.add_cheque_entry.cheque_system_currency_value.value);
		document.getElementById('cheque_currency_id').disabled = false;
		<cfoutput>#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_cheque_entry' , #attributes.modal_id#);"),DE(""))#</cfoutput>
		return true; 

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
					form_txt_rate1_ = eval("document.add_cheque_entry.txt_rate1_"+s);
				}
			}
			rate2_value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>')/filterNum(form_txt_rate1_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.add_cheque_entry.cheque_system_currency_value.value = commaSplit(parseFloat(temp_cheque_value)*rate2_value);
			document.add_cheque_entry.CHEQUE_VALUE.value = commaSplit(temp_cheque_value);
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
					form_txt_rate1_ = filterNum(eval("document.add_cheque_entry.txt_rate1_"+s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					eval("document.add_cheque_entry.txt_rate2_"+s).value = commaSplit(form_txt_rate2_*form_txt_rate1_,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				}
			}
		}
		else
			document.add_cheque_entry.cheque_system_currency_value.value =0;
	}
	for(fff=1;fff <=<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.kur_say.value;fff++)
	{
		eval('add_cheque_entry.other_money' + fff).value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.hidden_rd_money_' + fff).value;
		eval('add_cheque_entry.txt_rate1_' + fff).value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.txt_rate1_' + fff).value;
		eval('add_cheque_entry.txt_rate2_' + fff).value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.txt_rate2_' + fff).value;
	}
	if(<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.getElementById('cash_id') != undefined)
	{
		<cfoutput query="get_money">
			if('#money#' == list_getat(<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.getElementById('cash_id').value,3,';'))
				document.add_cheque_entry.cheque_currency_id[#currentrow-1#].selected = true;
		</cfoutput>
		document.getElementById('cheque_currency_id').disabled = true;
		currency_control(document.getElementById('cheque_currency_id').value);
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
