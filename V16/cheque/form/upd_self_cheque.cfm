<cf_xml_page_edit fuseact="cheque.popup_add_cheque">
	<cf_get_lang_set module_name="cheque">
	<cfinclude template="../query/get_money2.cfm">
	<cfparam name="attributes.modal_id" default="">
	<cfif isdefined("is_from_sale")><!--- Taksitli satıştan geliyorsa --->
		<cfset act = "#request.self#?fuseaction=cheque.upd_cheque&is_from_sale=1">
	<cfelse>
		<cfset act = "#request.self#?fuseaction=cheque.upd_cheque&row=#url.row#">
	</cfif>
<cf_box scroll="1" title="#getLang('','settings',58007)#" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfsavecontent variable="title1"><cf_get_lang dictionary_id='57771.Detay'></cfsavecontent>
	<cfsavecontent variable="title2"><cf_get_lang dictionary_id='57422.Notlar'></cfsavecontent>
		<cfsavecontent variable="title3"><cf_get_lang dictionary_id='57568.Belgeler'></cfsavecontent>
			<cfif len(attributes.cheque_id)>		
				<cf_tab divID = "sayfa_1,sayfa_2,sayfa_3" defaultOpen="sayfa_1" divLang = "#title1#;#title2#;#title3#" tabcolor = "fff">              
				</cfif>
			<div id = "unique_sayfa_1" class = "uniqueBox"><cfsavecontent variable="img"><strong><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=cheque.popup_add_self_cheque"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a></strong></cfsavecontent>
				<cfform name="add_cheque_entry" action="#act#" method="post">
					<cf_box_elements>
					<input type="hidden" name="cheque_id" id="cheque_id" value="">
					<input type="hidden" name="attributes.draggable" id="attributes.draggable" value="">
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<div class="form-group">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='25.Çek No'></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<input type="text" name="cheque_no" id="cheque_no" value="" style="width:150px;">
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='770.Portföy No'></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<input type="text" name="portfoy_no" id="portfoy_no" value="" readonly="yes" style="width:150px;">
								</div>
							</div>
							<div class="form-group">
								<cfif isDefined("self_cheque_info")>
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='1529.Subesi'><cfif x_is_branch eq 1>*</cfif></label>
								<div class="col col-8 col-md-6 col-xs-12"><input type="text" name="bank_branch_name" id="bank_branch_name" value="" style="width:150px;">
								</div>
							<cfelse>
								<input type="hidden" name="bank_branch_name" id="bank_branch_name" value="">
							</cfif>
							</div>
							<div class="form-group">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='1350.Vergi Dairesi'><cfif x_is_tax_place eq 1>*</cfif></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<input type="text" name="tax_place" id="tax_place" value="" style="width:150px;">
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='769.Ödeme Yeri'><cfif x_is_paycity eq 1>*</cfif> </label>
								<div class="col col-8 col-md-6 col-xs-12">
									<input type="text" name="cheque_city" id="cheque_city" value="" style="width:150px;">
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='377.Özel Kod'><cfif x_is_ozelkod eq 1>*</cfif></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<input type="text" name="cheque_code" id="cheque_code" value="" style="width:150px;">
								</div>
							</div>
							<cfif isDefined("self_cheque_info")>
							<div class="form-group">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='340.Vergi No'><cfif x_is_tax_no eq 1>*</cfif></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<input type="text" name="tax_no" id="tax_no" value="" style="width:150px;">
								</div>
							</div>
						<cfelse>
							<div class="form-group">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='766.Hesap No'><cfif x_is_account eq 1>*</cfif></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<input type="text" name="account_no" id="account_no" value="" style="width:150px;">
									<Input type="hidden" name="tax_no" id="tax_no" value="">
								</div>
							</div>
						</cfif>
							<div class="form-group">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='768.Borçlu'><cfif x_is_debtor_name eq 1>*</cfif></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<input type="text" name="debtor_name" id="debtor_name" value="" maxlength="150" style="width:150px;">
								</div>
							</div>
							<cfif isDefined("self_cheque_info")>
							<div class="form-group">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='766.Hesap No'><cfif x_is_account eq 1>*</cfif></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<input type="text" name="account_no" id="account_no" value="" style="width:150px;">
								</div>
							</div>
						</cfif>
							<div class="form-group">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='77.İşlem Para Br'></label>
										<div class="col col-6 col-md-6 col-xs-12">
									<cfsavecontent variable="message"><cf_get_lang no='52.Çek Tutarını Giriniz !'></cfsavecontent>
										<cfinput type="text" name="cheque_value" value="" class="moneybox" required="yes" onBlur="hesapla();" onKeyup="return(FormatCurrency(this,event));" message="#message#" style="width:90px;">                  
									</div><div class="col col-2 col-md-2 col-xs-12">
										<select name="CURRENCY_ID" id="CURRENCY_ID" style="width:60px;" onChange="currency_control(this.value);" disabled="disabled">
											<cfoutput query="get_money">
												<option value="#money#;#rate2#;#rate1#" <cfif money eq attributes.currency_id>selected</cfif>>#money#</option>
											</cfoutput>
										</select>
									</div>
							</div>
							<cfif isDefined("self_cheque_info")>
							<div class="form-group">
								<input type="hidden" name="account_id" id="account_id">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='109.Banka'><cfif x_is_bank eq 1>*</cfif></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<input type="text" name="bank_name" id="bank_name" value="" style="width:150px;">
								</div>
							</div>
						<cfelse>
							<div class="form-group">
								<input type="hidden" name="bank_name" id="bank_name" value="">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='42.Hesap No'></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<cfquery name="get_bank_account" datasource="#dsn3#">
										SELECT ACCOUNT_NAME FROM ACCOUNTS WHERE ACCOUNT_ID = #attributes.account_id#
									</cfquery>
									<input type="hidden" name="account_id" id="account_id" value="<cfoutput>#attributes.account_id#</cfoutput>">
									<cfoutput>#get_bank_account.ACCOUNT_NAME#</cfoutput>
								</div>
							</div>
						  </cfif>
							<div class="form-group"  id="other_money" <cfif attributes.currency_id neq session.ep.money>style="display:'';"<cfelse> style="display:'none';"</cfif>>
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='68. Sistem Para Br'>*</label>
								<div class="col col-8 col-md-6 col-xs-12" id="other_money2" <cfif attributes.currency_id neq session.ep.money>style="display:'';"<cfelse> style="display:'none';"</cfif>>
									<div class="input-group">
									<cfinput type="text" name="cheque_system_currency_value" onBlur="hesapla2();" onKeyup="return(FormatCurrency(this,event));" style="width:90px;" value="" class="moneybox" required="yes" message="Tutar Giriniz!">
								<span class="input-group-addon">
									<cfoutput>#session.ep.money#</cfoutput></span>	
								</div>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang_main no='228.Vade'></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang no='8.Vade Girmelisiniz !'></cfsavecontent>
										<cfinput type="text" name="cheque_duedate" value="" validate="#validate_style#" required="yes" message="#message#" style="width:90px;">                  
										<span class="input-group-addon"><cf_wrk_date_image date_field="cheque_duedate"></span>
										</div>
								</div>
							</div>
							<cfif isDefined("self_cheque_info") and not isdefined("is_from_sale")><!--- statusu 1 olanlar için --->
							<div class="form-group">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang no='105.Cari Hesap Çeki'></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<input type="checkbox" name="self_cheque_" id="self_cheque_" value="1"><cf_get_lang no='107.Cari hesap çeki değilse seçili değil'>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58970.Ciro Eden'></label>
								<div class="col col-8 col-md-6 col-xs-12">
									<input type="text" name="endorsement_member" id="endorsement_member" maxlength="150" style="width:150px;">
								</div>
							</div>
						</cfif>
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
									<!---
									Çek güncelleme ekraninda döviz kuru kısmını bozmaktadır kapatildi FA
									<td colspan="2"></td>--->
									<cfif not isdefined("is_from_sale")>
										<cfif isDefined("attributes.kur_say") and len(attributes.kur_say)>
											<cfoutput>
												<div class="form-group">
													<label class="col col-4 col-md-4 col-xs-12 bold padding-left-5"><cf_get_lang no='245.Döviz Kuru'></label>
												</div>
												<input type="hidden" name="kur_say" id="kur_say" value="#attributes.kur_say#">
												<cfloop from="1" to="#attributes.kur_say#" index="j">
											
														<div class="form-group">
														
															<div class="col col-3 col-md-3 col-xs-12"></div>
															<div class="col col-3 col-md-3 col-xs-12">
																<input type="text" name="other_money#j#" id="other_money#j#" class="boxtext" value="" readonly="yes" >
															</div>
															<div class="col col-2 col-md-2 col-xs-12 text-right">
																<input type="text" name="txt_rate1_#j#" id="txt_rate1_#j#" class="box" value="" readonly="yes" ></div><div class="col col-1 col-md-1 col-xs-12">/</div>
															<div class="col col-3 col-md-3 col-xs-12">
																<input type="text" class="box small" name="txt_rate2_#j#" id="txt_rate2_#j#" value="" readonly="yes"  onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla();">
															
															</div>
														</div>
												</cfloop>
											</cfoutput>
										<cfelse> 
											<td rowspan="<cfoutput>#get_money.recordcount#</cfoutput>" valign="top"><cf_get_lang no='245.Döviz Kuru'></td>
											<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
											<cfoutput query="get_money">
												<td colspan="2"></td>
												<td height="17">
													<input type="hidden" name="other_money#currentrow#" id="other_money#currentrow#" value="#money#">
													<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
													#money#
													#TLFormat(rate1,0)#/<input type="text" class="box" readonly="yes" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,'#session.ep.our_company_info.rate_round_num#')#" style="width:70px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla();" <cfif money is session.ep.money>readonly</cfif>></td>
												</td>
												</tr>
											</cfoutput>
										</cfif>
									</cfif>
						</div>
					</cf_box_elements>
							<cf_box_footer>
								<input type="button" value="<cf_get_lang dictionary_id='57464.Güncelle'>"  onclick='kontrol()'>
							</cf_box_footer>
					</cfform>
			</div>	<cfif len(attributes.cheque_id)>
			<div id = "unique_sayfa_2" class = "uniqueBox">
				<cf_get_workcube_note no_border="1" action_section='CHEQUE_ID' action_id='#attributes.cheque_id#' period_id='#session.ep.period_id#'><br/>			
				</div><div id = "unique_sayfa_3" class = "uniqueBox">
					<cf_get_workcube_asset no_border="1" company_id="#session.ep.company_id#" asset_cat_id="-17" module_id='16' action_section='CHEQUE_ID' action_id='#attributes.cheque_id#'><br/>
			</div></cfif>
		</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		<cfif x_is_paycity eq 1>
			if(document.add_cheque_entry.cheque_city.value == "")
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='769.Ödeme Yeri'>");
				return false;
			}
		</cfif>
		<cfif x_is_ozelkod eq 1>
			if(document.add_cheque_entry.cheque_code.value=="")
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='377.Özel Kod'>");
				return false;
			}
		</cfif>
		<cfif x_is_bank eq 1>
			if(document.add_cheque_entry.bank_name.value=="")
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='109.Banka'>");
				return false;
			}
		</cfif>
		<cfif x_is_branch eq 1>
			if(document.add_cheque_entry.bank_branch_name.value=="")
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1521.Banka Şubesi'>");
				return false;
			}
		</cfif>
		<cfif x_is_account eq 1>
			if(document.add_cheque_entry.account_no.value=="")
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='766.Hesap No'>");
				return false;
			}
		</cfif>
		<cfif x_is_debtor_name eq 1>
			if(document.add_cheque_entry.debtor_name.value=="")
				{
					alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='768.Borçlu'>");
					return false;
				}
		</cfif>
		<cfif x_is_tax_place eq 1>
			if(document.add_cheque_entry.tax_place.value=="")
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1350.Vergi Dairesi'>");
				return false;
			}
		</cfif>
		<cfif x_is_tax_no eq 1 and isDefined("self_cheque_info")>
			if(document.add_cheque_entry.tax_no.value=="")
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='340.Vergi No'>");
				return false;
			}
		</cfif>		
		if(document.add_cheque_entry.self_cheque_ != undefined && document.add_cheque_entry.self_cheque_.checked==false)
		{
			if(document.add_cheque_entry.endorsement_member.value=="")
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='1558.Ciro Eden'>");
				return false;
			}	
		}			
		document.add_cheque_entry.cheque_value.disabled = false;
		document.add_cheque_entry.CURRENCY_ID.disabled = false;
		<cfoutput>#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_cheque_entry' , #attributes.modal_id#);"),DE(""))#</cfoutput>
		return true;
	}
	function currency_control(currency_type)
	{
		var system_currency = '<cfoutput>#session.ep.money#</cfoutput>';
		if(list_getat(currency_type,1,';') != system_currency)
		{
			other_money.style.display='';
			other_money2.style.display='';
		}
		else
		{
			other_money.style.display='none';
			other_money2.style.display='none';
		}
		hesapla();
	}
	function hesapla()
	{
		if(document.add_cheque_entry.cheque_value.value != '')
		{
			var temp_cheque_value = filterNum(document.add_cheque_entry.cheque_value.value);
			var money_type=document.add_cheque_entry.CURRENCY_ID[document.add_cheque_entry.CURRENCY_ID.options.selectedIndex].value;
			for(s=1;s<=add_cheque_entry.kur_say.value;s++)
			{
				if(eval("document.add_cheque_entry.other_money"+s).value== list_getat(money_type,1,';'))
				{
					form_txt_rate2_ = eval("document.add_cheque_entry.txt_rate2_"+s);
					form_txt_rate1_ = eval("document.add_cheque_entry.txt_rate1_"+s);
				}
			}
			form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			form_txt_rate1_.value = filterNum(form_txt_rate1_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.add_cheque_entry.cheque_system_currency_value.value = commaSplit(parseFloat(temp_cheque_value)*parseFloat(form_txt_rate2_.value)/parseFloat(form_txt_rate1_.value));
			document.add_cheque_entry.cheque_value.value = commaSplit(temp_cheque_value);
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
			var cheque_value = filterNum(document.add_cheque_entry.cheque_value.value);
			var money_type=document.add_cheque_entry.CURRENCY_ID[document.add_cheque_entry.CURRENCY_ID.options.selectedIndex].value;
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
	//form elemanları dolduruluyor
	<cfif isdefined("is_from_sale")>
		<cfoutput>
			var get_cheque_detail = wrk_safe_query('chq_get_cheque_detail','dsn2',0,#attributes.cheque_id#);
			var get_cheque_money =  wrk_safe_query('chq_get_cheque_money','dsn2',0,#attributes.cheque_id#);
			money_list = get_cheque_money.recordcount +'& -';
			for(fff=1;fff<= get_cheque_money.recordcount;fff++)
			{
				money_list = money_list+'&'+get_cheque_money.MONEY_TYPE[fff] +'& , &'+get_cheque_money.RATE1[fff]+'& , &'+get_cheque_money.RATE2[fff]+' & -';
			}
			document.add_cheque_entry.cheque_id.value = get_cheque_detail.CHEQUE_ID;
			document.add_cheque_entry.portfoy_no.value = get_cheque_detail.CHEQUE_PURSE_NO;
			document.add_cheque_entry.bank_name.value = get_cheque_detail.BANK_NAME;
			document.add_cheque_entry.bank_branch_name.value = get_cheque_detail.BANK_BRANCH_NAME;
			document.add_cheque_entry.tax_place.value = get_cheque_detail.TAX_PLACE;
			document.add_cheque_entry.tax_no.value = get_cheque_detail.TAX_NO;
			document.add_cheque_entry.cheque_no.value = get_cheque_detail.CHEQUE_NO;
			document.add_cheque_entry.cheque_value.value = get_cheque_detail.CHEQUE_VALUE;
			document.add_cheque_entry.cheque_system_currency_value.value = get_cheque_detail.OTHER_MONEY_VALUE;
			document.add_cheque_entry.cheque_duedate.value = date_format(get_cheque_detail.CHEQUE_DUEDATE,dateformat_style);
			if(document.add_cheque_entry.cheque_city != undefined)
				document.add_cheque_entry.cheque_city.value = get_cheque_detail.CHEQUE_CITY;
			document.add_cheque_entry.cheque_code.value = get_cheque_detail.CHEQUE_CODE;
			document.add_cheque_entry.debtor_name.value = get_cheque_detail.DEBTOR_NAME;
			document.add_cheque_entry.account_no.value = get_cheque_detail.ACCOUNT_NO;
			document.add_cheque_entry.account_id.value = get_cheque_detail.ACCOUNT_ID;
			if(document.add_cheque_entry.endorsement_member != undefined)
				document.add_cheque_entry.endorsement_member.value =get_cheque_detail.ENDORSEMENT_MEMBER;
			if(document.add_cheque_entry.self_cheque_ != undefined && get_cheque_detail.SELF_CHEQUE == 1)
				document.add_cheque_entry.self_cheque_.checked = true;
			for(fff=1;fff <=list_getat(money_list,1,'-');fff++)
			{
				money = list_getat(money_list,fff+1,'-');
				eval('add_cheque_entry.other_money' + fff).value = list_getat(money,1,',');
				eval('add_cheque_entry.txt_rate1_' + fff).value = list_getat(money,2,',');
				eval('add_cheque_entry.txt_rate2_' + fff).value = commaSplit(list_getat(money,3,','),'#session.ep.our_company_info.rate_round_num#');
				if(eval('add_cheque_entry.other_money' + fff).value == '#session.ep.money#')
					eval('add_cheque_entry.txt_rate2_' + fff).readOnly = true;
			}
			document.add_cheque_entry.cheque_value.disabled = true;
			document.add_cheque_entry.CURRENCY_ID.disabled = true;
		</cfoutput>
	<cfelse>
		<cfoutput>
			document.add_cheque_entry.cheque_id.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_id'+#attributes.row#).value;
			document.add_cheque_entry.portfoy_no.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.portfoy_no'+#attributes.row#).value;
			document.add_cheque_entry.bank_name.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.bank_name'+#attributes.row#).value;
			document.add_cheque_entry.bank_branch_name.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.bank_branch_name'+#attributes.row#).value;
			document.add_cheque_entry.tax_place.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.tax_place'+#attributes.row#).value;
			document.add_cheque_entry.tax_no.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.tax_no'+#attributes.row#).value;
			document.add_cheque_entry.cheque_no.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_no'+#attributes.row#).value;
			document.add_cheque_entry.cheque_value.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_value'+#attributes.row#).value;
			document.add_cheque_entry.cheque_system_currency_value.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_system_currency_value'+#attributes.row#).value;
			document.add_cheque_entry.cheque_duedate.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_duedate'+#attributes.row#).value;
			if(document.add_cheque_entry.cheque_city != undefined)
				document.add_cheque_entry.cheque_city.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_city'+#attributes.row#).value;
			document.add_cheque_entry.cheque_code.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.cheque_code'+#attributes.row#).value;
			document.add_cheque_entry.debtor_name.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.debtor_name'+#attributes.row#).value;
			document.add_cheque_entry.account_no.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.account_no'+#attributes.row#).value;
			document.add_cheque_entry.account_id.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.account_id'+#attributes.row#).value;
			if(document.add_cheque_entry.endorsement_member != undefined)
				document.add_cheque_entry.endorsement_member.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.endorsement_member'+#attributes.row#).value;
			if(document.add_cheque_entry.self_cheque_ != undefined && eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.from_cheque_info'+#attributes.row#).value == 1)
				document.add_cheque_entry.self_cheque_.checked = true;
			money_list = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.money_list'+#attributes.row#).value;
			for(fff=1;fff <=list_getat(money_list,1,'-');fff++)
			{
				money = list_getat(money_list,fff+1,'-');
				eval('add_cheque_entry.other_money' + fff).value = list_getat(money,1,',');
				eval('add_cheque_entry.txt_rate1_' + fff).value =commaSplit(list_getat(money,2,','),0);
				eval('add_cheque_entry.txt_rate2_' + fff).value = commaSplit(list_getat(money,3,','),'#session.ep.our_company_info.rate_round_num#');
				if(eval('add_cheque_entry.other_money' + fff).value == '#session.ep.money#')
					eval('add_cheque_entry.txt_rate2_' + fff).readOnly = true;
			}
		</cfoutput>
	</cfif>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
