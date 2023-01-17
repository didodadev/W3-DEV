<cf_xml_page_edit fuseact="cheque.popup_add_voucher">
<cf_get_lang_set module_name="cheque">
<cfparam name="attributes.modal_id" default="">
<cfinclude template="../query/get_money2.cfm">
<cf_box title="#getLang('','settings',58008)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#"><!--- senet guncelle --->
<cfform name="add_voucher_entry" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_voucher&row=#url.row#">
	<cf_box_elements>
	<input type="hidden" name="voucher_id" id="voucher_id" value="">
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-12"></label>
			<div class="col col-8 col-md-8 col-xs-12">
				<cfif x_is_add_pay_term eq 1>
					<input type="checkbox" name="is_pay_term" id="is_pay_term" value="1"><cf_get_lang_main no='2148.Ödeme Sözü'>
				</cfif>
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-12"></label>
			<div class="col col-8 col-md-8 col-xs-12">
				<input type="checkbox" name="self_voucher_" id="self_voucher_" value="1"><cf_get_lang no='107.Cari hesap çeki değilse seçili değil'>
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no='1090.Senet No'> *</label>
			<div class="col col-8 col-md-8 col-xs-12">
				<input type="text" name="voucher_no" id="voucher_no" value="" style="width:150px;">
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no='377.Özel Kod'></label>
			<div class="col col-8 col-md-8 col-xs-12">
				<input type="text" name="voucher_code" id="voucher_code" value="" style="width:150px;">
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no='768.Borçlu'></label>
			<div class="col col-8 col-md-8 col-xs-12">
				<Input type="text" name="debtor_name" id="debtor_name" value="" style="width:150px;">
			</div>
		</div>
		<cfif x_is_account_code eq 1>
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang no='101.Muhasebe Hesabı'> *</label>
			<div class="col col-8 col-md-8 col-xs-12">
				<div class="input-group">
				<input type="hidden" name="acc_code" id="acc_code" value="">
				<cfinput type="text" style="width:150px;" name="acc_name" required="yes" message="Muhasebe Hesabı Seçiniz!" readonly>
				<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_id=add_voucher_entry.acc_code</cfoutput>&field_name=add_voucher_entry.acc_name' , 'list');">
				</span> 
			</div>
			</div>
		</div>
	</cfif>
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang no ='77.İşlem Para Br'> *</label>
			<div class="col col-8 col-md-8 col-xs-12">
				<div class="col col-9 col-md-9 col-xs-12">				
					<cfsavecontent variable="message"><cf_get_lang_main no='1738.Lutfen Tutar Giriniz'></cfsavecontent>
					<cfinput type="text" name="voucher_value" value="" required="yes" onBlur="hesapla();" onkeyup="return(FormatCurrency(this,event));" onFocus="if(this.value == '') this.value = 0;" message="#message#" style="width:88px;" class="moneybox">
				</div>
					<div class="col col-3 col-md-3 col-xs-12">
				<select name="currency_id" id="currency_id" style="width:60px;" onChange="currency_control(this.value);">
					<cfoutput query="get_money">
						<option value="#money#;#rate2#;#rate1#" <cfif money eq attributes.currency_id>selected</cfif>>#money#</option>
					</cfoutput>
				</select>
			</div>
		</div>
		</div>
		<div class="form-group" id="other_money" <cfif attributes.currency_id neq session.ep.money>style="display:'';"<cfelse> style="display:'none';"</cfif>>
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang no='68. Sistem Para Br'>*</label>
			<div class="col col-8 col-md-8 col-xs-12" id="other_money2" <cfif attributes.currency_id neq session.ep.money>style="display:'';"<cfelse> style="display:'none';"</cfif>>
			<div class="input-group">
				<cfinput type="text" name="voucher_system_currency_value" onBlur="hesapla2();" onKeyup="return(FormatCurrency(this,event));" style="width:88px;" value="" class="moneybox" required="yes" message="Tutar Giriniz!">
				<span class="input-group-addon btnPointer"><cfoutput>#session.ep.money#</cfoutput></span>	
			</div>
		</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no='770.Portföy No'></label>
			<div class="col col-8 col-md-8 col-xs-12">
				<input type="text" name="portfoy_no" id="portfoy_no" value="" readonly="yes" style="width:150px;">
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no='769.Ödeme Yeri'></label>
			<div class="col col-8 col-md-8 col-xs-12">
				<input type="text" name="voucher_city" id="voucher_city" value="" style="width:150px;">
			</div>
		</div>
		<div class="form-group">
			<label class="col col-4 col-md-4 col-xs-12"><cf_get_lang_main no='228.Vade'> *</label>
			<div class="col col-8 col-md-8 col-xs-12">
				<div class="input-group">
				<cfsavecontent variable="message"><cf_get_lang no='8.Vade Girmelisiniz !'></cfsavecontent>
					<cfinput value="" validate="#validate_style#" required="yes" message="#message#" type="text" name="voucher_duedate" style="width:90px;">
				<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="voucher_duedate"></span>	
			</div>
			</div>
		</div>
	</div>
	<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<cfif isDefined("attributes.kur_say") and len(attributes.kur_say)>
					<cfoutput>
					<div class="form-group">
						<label class="col col-4 col-md-4 col-xs-12 bold padding-left-5" ><cf_get_lang no='245.Döviz Kuru'></label>
						<label class="col col-8 col-md-8 col-xs-12" ></label>
					</div>
					<input type="hidden" name="kur_say" id="kur_say" value="#attributes.kur_say#">
					<cfloop from="1" to="#attributes.kur_say#" index="j">
						<div class="form-group">
							<label class="col col-4 col-md-4 col-xs-12" ></label>
							<div class="col col-8 col-md-8 col-xs-12">
							<div class="col col-3 col-md-3 col-xs-12">
								<input type="text" name="other_money#j#" id="other_money#j#" class="boxtext" value="" readonly="yes" style="width:50px;">
							</div>
							<div class="col col-3 col-md-3 col-xs-12">
								<input type="text" name="txt_rate1_#j#" id="txt_rate1_#j#" class="box" value="" readonly="yes" style="width:30px;">
							</div><label></label><label class="col col-1 col-md-1 col-xs-12">/
							</label>
							<div class="col col-5 col-md-5 col-xs-12">
								<input type="text" class="box" name="txt_rate2_#j#" id="txt_rate2_#j#" value="" readonly="yes" style="width:70px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla();">
							</div>	
						</div>	
						</div>				
					</cfloop>
					</cfoutput>
				<cfelse> 
					<td rowspan="<cfoutput>#get_money.recordcount#</cfoutput>" valign="top" width="100">Döviz Kuru</td>
					<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
					<cfoutput query="get_money">
						<td height="17">
						<input type="hidden" name="other_money#currentrow#" id="other_money#currentrow#" value="#money#">
						<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
						#money#
						#TLFormat(rate1,0)#/<input type="text" class="box" readonly="yes" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,'#session.ep.our_company_info.rate_round_num#')#" style="width:50px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla();" <cfif money is session.ep.money>readonly</cfif>></td>
						</td>
						</tr>
					</cfoutput>
				</cfif>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='1' is_delete="0" add_function='kontrol_upd()'>
		</cf_box_footer>
</cfform>
</cf_box>
<script type="text/javascript">
	function kontrol_upd()
	{
		document.getElementById('currency_id').disabled = false;
		<cfoutput>#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_voucher_entry' , #attributes.modal_id#);"),DE(""))#</cfoutput>
		return false; 
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
		if(document.add_voucher_entry.voucher_value.value != '')
		{
			var temp_voucher_value = filterNum(document.add_voucher_entry.voucher_value.value);
			var money_type=document.add_voucher_entry.currency_id[document.add_voucher_entry.currency_id.options.selectedIndex].value;
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
			document.add_voucher_entry.voucher_value.value = commaSplit(temp_voucher_value);
			form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			form_txt_rate1_.value = commaSplit(form_txt_rate1_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		else
			document.add_voucher_entry.voucher_system_currency_value.value =0;
	}
	function hesapla2()
	{
		if(document.add_voucher_entry.voucher_system_currency_value.value != '')
		{
			var temp_voucher_value = filterNum(document.add_voucher_entry.voucher_system_currency_value.value);
			var voucher_value = filterNum(document.add_voucher_entry.voucher_value.value);
			var money_type=document.add_voucher_entry.currency_id[document.add_voucher_entry.currency_id.options.selectedIndex].value;
			form_txt_rate2_ = commaSplit(parseFloat(temp_voucher_value)/parseFloat(voucher_value));
			form_txt_rate2_ = filterNum(form_txt_rate2_,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			for(s=1;s<=add_voucher_entry.kur_say.value;s++)
			{
				if(eval("document.add_voucher_entry.other_money"+s).value== list_getat(money_type,1,';'))
				{
					form_txt_rate1_ = filterNum(eval("document.add_voucher_entry.txt_rate1_"+s).value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
					eval("document.add_voucher_entry.txt_rate2_"+s).value = commaSplit(form_txt_rate2_,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				}
			}
		}
		else
			document.add_voucher_entry.voucher_system_currency_value.value =0;
	}
	//form elemanları dolduruluyor
	<cfoutput>
		document.add_voucher_entry.voucher_id.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_id'+#attributes.row#).value;
		document.add_voucher_entry.voucher_code.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_code'+#attributes.row#).value;
		document.add_voucher_entry.voucher_city.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_city'+#attributes.row#).value;
		document.add_voucher_entry.portfoy_no.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.portfoy_no'+#attributes.row#).value;
		document.add_voucher_entry.voucher_no.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_no'+#attributes.row#).value;
		document.add_voucher_entry.debtor_name.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.debtor_name'+#attributes.row#).value;
		<cfif x_is_account_code eq 1>
			document.add_voucher_entry.acc_code.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.acc_code'+#attributes.row#).value;
			document.add_voucher_entry.acc_name.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.acc_code'+#attributes.row#).value;
		</cfif>
		document.add_voucher_entry.voucher_value.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_value'+#attributes.row#).value;
		document.add_voucher_entry.voucher_system_currency_value.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_system_currency_value'+#attributes.row#).value;
		document.add_voucher_entry.voucher_duedate.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_duedate'+#attributes.row#).value;
		if(document.add_voucher_entry.self_voucher_ != undefined && eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.from_voucher_info'+#attributes.row#).value == 1)
			document.add_voucher_entry.self_voucher_.checked = true;
		if(document.add_voucher_entry.is_pay_term != undefined && eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.is_pay_term'+#attributes.row#).value == 1)
			document.add_voucher_entry.is_pay_term.checked = true;
		money_list = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.money_list'+#attributes.row#).value;
		for(fff=1;fff <=list_getat(money_list,1,'-');fff++)
		{
			money = list_getat(money_list,fff+1,'-');
			eval('add_voucher_entry.other_money' + fff).value = list_getat(money,1,',');
			eval('add_voucher_entry.txt_rate1_' + fff).value = commaSplit(list_getat(money,2,','),'#session.ep.our_company_info.rate_round_num#');
			eval('add_voucher_entry.txt_rate2_' + fff).value = commaSplit(list_getat(money,3,','),'#session.ep.our_company_info.rate_round_num#');
			if(eval('add_voucher_entry.other_money' + fff).value == '#session.ep.money#')
				eval('add_voucher_entry.txt_rate2_' + fff).readOnly = true;
		}
		document.getElementById('currency_id').disabled = true;
	</cfoutput>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

