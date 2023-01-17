<cf_get_lang_set module_name="cheque">
<cfinclude template="../query/get_money2.cfm">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('cheque','Çek Ekle',50292)#" add_href="#request.self#?fuseaction=cheque.popup_add_self_cheque_list">
		<cfform name="add_cheque_entry" id="add_cheque_entry" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_self_cheque_list&self_cheque=1" method="post" onsubmit="return(unformat_fields());">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-company_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'> *</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="company_id" id="company_id" value="">
								<input type="hidden" name="consumer_id" id="consumer_id" value="">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='45308.Çari hesap Girmelisiniz !'></cfsavecontent>
								<cfinput type="text" name="company_name" value="" required="yes" message="#message#" style="width:285px;" readonly>
								<span class="input-group-addon icon-ellipsis" onclick="javascript:openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_member_name=add_cheque_entry.company_name&field_comp_id=add_cheque_entry.company_id&field_comp_name=add_cheque_entry.company_name&field_consumer=add_cheque_entry.consumer_id<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3</cfoutput>');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-get_cheque_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50342.Banka Hesap'> *</label>
						<div class="col col-8 col-xs-12">
							<cf_wrkBankAccounts width='285' control_status = '1' call_function='get_cheque_no'>
						</div>
					</div>
					<div class="form-group" id="item-cheque_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50220.Çek No'>*</label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='50214.Çek No Girmelisiniz !'></cfsavecontent>
							<cfinput type="text" name="cheque_no" onkeyup="isNumber(this);" onblur='isNumber(this);' required="yes" message="#message#" validate="integer" style="width:285px;">
						</div>
					</div>
					<div class="form-group" id="item-CHEQUE_VALUE">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50272.İşlem Para Br'>*</label>
						<div class="col col-5 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29535.Lutfen Tutar Giriniz'></cfsavecontent>
							<cfinput type="text" name="CHEQUE_VALUE" class="moneybox" onBlur="hesapla();" onKeyup="return(FormatCurrency(this,event));" required="yes" message="#message#" style="width:112px;">
						</div>
						<div class="col col-3 col-xs-12">
							<select name="cheque_currency" id="cheque_currency" style="width:55px;" onChange="currency_control(this.value);">
								<cfoutput query="get_money">
								<option value="#money#;#rate2#;#rate1#" <cfif money eq session.ep.money>selected</cfif>>#money#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="other_money" style="display:none;">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50263.Sistem Para Br'>*</label>
						<div class="col col-5 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='29535.Lutfen Tutar Giriniz'></cfsavecontent>
							<cfinput type="text" name="cheque_other_currency_value" onBlur="hesapla2();" onKeyup="return(FormatCurrency(this,event));" style="width:112px;" value="" class="moneybox" required="yes" message="#message#">
						</div>
						<div class="col col-3 col-xs-12">
							<cfoutput>#session.ep.money#</cfoutput>	
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-CHEQUE_DUEDATE">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57640.Vade'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='50203.Vade Girmelisiniz !'></cfsavecontent>
								<cfinput type="text" name="CHEQUE_DUEDATE" value="" required="yes" validate="#validate_style#" message="#message#" style="width:112px;">
								<span class="input-group-addon"><cf_wrk_date_image date_field="CHEQUE_DUEDATE"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-CHEQUE_CITY">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58181.Ödeme Yeri'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="CHEQUE_CITY" id="CHEQUE_CITY" value="" style="width:112px;">
						</div>
					</div>
					<div class="form-group" id="item-CHEQUE_CODE">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="CHEQUE_CODE" value="" maxlength="50" style="width:112px;">
						</div>
					</div>
					<div class="form-group" id="item-kur_say">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='50440.Döviz Kuru'></label>
						<cfoutput>
							<input type="hidden" name="kur_say" id="kur_say" value="#get_money.recordcount#">
							<cfif session.ep.rate_valid eq 1>
								<cfset readonly_info = "yes">
							<cfelse>
								<cfset readonly_info = "no">
							</cfif>
						
							<cfif len(session.ep.money2)>
								<cfset selected_money=session.ep.money2>
							<cfelse>
								<cfset selected_money=session.ep.money>
							</cfif>
							<cfloop query="get_money">
								<input type="hidden" name="other_money#currentrow#" id="other_money#currentrow#" value="#money#">
								<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
								<div class="col col-1 col-xs-12">
									#money# #TLFormat(rate1,0)#/
								</div>
								<div class="col col-1 col-xs-12">
									<input type="text" class="box" <cfif readonly_info>readonly</cfif> name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,'#session.ep.our_company_info.rate_round_num#')#" style="width:50px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla();" <cfif money is session.ep.money>readonly</cfif>>
								</div>
							</cfloop>
						</cfoutput>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' add_function="kontrol()">
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function unformat_fields()
	{
		document.add_cheque_entry.CHEQUE_VALUE.value=filterNum(document.add_cheque_entry.CHEQUE_VALUE.value);
		document.add_cheque_entry.cheque_other_currency_value.value=filterNum(document.add_cheque_entry.cheque_other_currency_value.value);
	}
	function kontrol()
	{		
		if(!acc_control()) return false;
		return true;
	}
	function get_cheque_no()
	{
		var get_cheque_no=wrk_safe_query('chq_get_cheque_no','dsn2',0,document.add_cheque_entry.account_id.value);
		if(get_cheque_no.recordcount > 0 && get_cheque_no.MAX_ID != '')
			new_cheque_no = parseFloat(get_cheque_no.MAX_ID) + 1;
		else
			new_cheque_no = 1;
		document.add_cheque_entry.cheque_no.value = new_cheque_no;
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
			var money_type=document.add_cheque_entry.cheque_currency[document.add_cheque_entry.cheque_currency.options.selectedIndex].value;
			for(s=1;s<=add_cheque_entry.kur_say.value;s++)
			{
				if(eval("document.add_cheque_entry.other_money"+s).value== list_getat(money_type,1,';'))
				{
					form_txt_rate2_ = eval("document.add_cheque_entry.txt_rate2_"+s);
				}
			}
			form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.add_cheque_entry.cheque_other_currency_value.value = commaSplit(parseFloat(temp_cheque_value)*parseFloat(form_txt_rate2_.value ));
			document.add_cheque_entry.CHEQUE_VALUE.value = commaSplit(temp_cheque_value);
			form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		else
			document.add_cheque_entry.cheque_other_currency_value.value =0;
	}
	function hesapla2()
	{
		if(document.add_cheque_entry.cheque_other_currency_value.value != '')
		{
			var temp_cheque_value = filterNum(document.add_cheque_entry.cheque_other_currency_value.value);
			var cheque_value = filterNum(document.add_cheque_entry.CHEQUE_VALUE.value);
			var money_type=document.add_cheque_entry.cheque_currency[document.add_cheque_entry.cheque_currency.options.selectedIndex].value;
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
			document.add_cheque_entry.cheque_other_currency_value.value =0;
	}
</script>
<cf_get_lang_set module_name="cheque">

