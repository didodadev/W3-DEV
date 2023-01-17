<cf_get_lang_set module_name="cheque"><!--- sayfanin en altinda kapanisi var --->
<cfinclude template="../query/get_cashes.cfm">
<cfinclude template="../query/get_money2.cfm">
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','settings',58008)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="upd_voucher_self" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.upd_voucher&row=#url.row#">
		<cf_box_elements>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<input type="hidden" name="voucher_id" id="voucher_id" value="">
				<input type="hidden" name="debtor_name" id="debtor_name" value="">
				<input type="hidden" name="acc_code" id="acc_code" value="">
			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57520.Kasa'></label>
				<div class="col col-8 col-md-6 col-xs-12">
					<select name="cash_id" id="cash_id"  onchange="setCurrency(this.id)">
						<cfoutput query="get_cashes">
							<option value="#cash_id#" <cfif cash_id eq attributes.cash_id>selected</cfif>>#cash_name#-#cash_currency_id#</option>
						</cfoutput>
					</select>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58502.Senet No'> *</label>
				<div class="col col-8 col-md-6 col-xs-12">
					<input type="text" name="voucher_no" id="voucher_no" value="" >
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58182.Portföy No'></label>
				<div class="col col-8 col-md-6 col-xs-12">
					<input type="text" name="portfoy_no" id="portfoy_no" value="" readonly="yes" >
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58181.Ödeme Yeri'></label>
				<div class="col col-8 col-md-6 col-xs-12">
					<input type="text" name="voucher_city" id="voucher_city" value="" >
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
				<div class="col col-8 col-md-6 col-xs-12">
					<input type="text" name="voucher_code" id="voucher_code" value="" >
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='35578.İşlem Para Br'> *</label>
				<div class="col col-8 col-md-6 col-xs-12">
					<div class="col col-9 col-md-9 col-xs-12">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='54493.Lutfen Tutar Giriniz'></cfsavecontent>
						<cfinput type="text" name="voucher_value" value="" required="yes" onBlur="hesapla();" onkeyup="return(FormatCurrency(this,event));" onFocus="if(this.value == '') this.value = 0;" message="#message#" style="width:88px;" class="moneybox">
					</div><div class="col col-3 col-md-3 col-xs-12">
						<select name="currency_id" id="currency_id" onChange="currency_control(this.value);">
						<cfoutput query="get_money">
                               <option value="#money#;#rate2#;#rate1#" <cfif money eq attributes.currency_id>selected</cfif>>#money#</option>
                        </cfoutput>
					</select>
				</div>
				</div>
			</div>
			<div class="form-group" id="other_money" style="display:none;">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='58177.Sistem Para Br'>*</label>
				<div class="col col-8 col-md-6 col-xs-12">
					<div class="input-group">
					<cfsavecontent variable="alert"><cf_get_lang dictionary_id='54493.Lutfen Tutar Giriniz'></cfsavecontent>
                    <cfinput type="text" name="voucher_system_currency_value" onBlur="hesapla2();" onKeyup="return(FormatCurrency(this,event));" style="width:85px;" value="" class="moneybox" required="yes" message="#alert#">
					<span class="input-group-addon">  
						 <cfoutput>#session.ep.money#</cfoutput>
					</span>
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="col col-4 col-md-6 col-xs-12"><cf_get_lang dictionary_id='57640.Vade'> *</label>
				<div class="col col-8 col-md-6 col-xs-12">
					<div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='54668.Vade Girmelisiniz !'></cfsavecontent>
						<cfinput value="" validate="#validate_style#" required="yes" message="#message#" type="text" name="voucher_duedate" style="width:90px;">
						<span class="input-group-addon"> 
						<cf_wrk_date_image date_field="voucher_duedate">
						</span>
				</div>
			</div>
			</div>
		</div>
		<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<cfif isDefined("attributes.kur_say") and len(attributes.kur_say)>
						<cfoutput>
							<input type="hidden" name="kur_say" id="kur_say" value="#attributes.kur_say#">
							<div class="form-group">
								<label class="col col-4 col-md-4 col-xs-12 bold padding-left-5"><cf_get_lang dictionary_id='50440.Döviz Kuru'></label>
							</div>
						<cfloop from="1" to="#attributes.kur_say#" index="j">
							<div class="form-group">					
								<div class="col col-3 col-md-3 col-xs-12"></div>
								<div class="col col-2 col-md-2 col-xs-12">
								<input type="text" name="other_money#j#" id="other_money#j#" class="boxtext" value="" readonly="yes">
							</div><div class="col col-3 col-md-3 col-xs-12 text-right">
								<input type="text" name="txt_rate1_#j#" id="txt_rate1_#j#" class="box" value="" readonly="yes">
							</div><div class="col col-1 col-md-1 col-xs-12">/</div>
							<div class="col col-3 col-md-3 col-xs-12">
								<input type="text" class="box" name="txt_rate2_#j#" id="txt_rate2_#j#" value="" readonly="yes"  onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla();">
							</div>
						</div>
						</cfloop>
						</cfoutput>
					<cfelse> 
						<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
						<div class="form-group">
							<label class="col col-4 col-md-4 col-xs-12 bold padding-left-5"><cf_get_lang dictionary_id='50440.Döviz Kuru'></label>
						</div>
						<cfoutput query="get_money">
							<div class="form-group">
							<input type="hidden" name="other_money#currentrow#" id="other_money#currentrow#" value="#money#">
							<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
							<div class="col col-3 col-md-3 col-xs-12"></div>
							<div class="col col-1 col-md-1 col-xs-12">
							#money#
						</div><div class="col col-1 col-md-1 col-xs-12 text-right">
							#TLFormat(rate1,0)#
						</div><div class="col col-1 col-md-1 col-xs-12">
							/
						</div><div class="col col-6 col-md-6 col-xs-12">
							<input type="text" class="box" readonly="yes" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,'#session.ep.our_company_info.rate_round_num#')#" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla();" <cfif money is session.ep.money>readonly</cfif>></td>
						</div>
						</div>
						</cfoutput>
					</cfif>
		</div>
		</cf_box_elements>
		<cf_box_footer>
			<input type="button" value="<cf_get_lang dictionary_id='57464.Güncelle'>"  onclick='kontrol()'>
			</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
$(document).ready(function(){
	document.getElementById('currency_id').disabled = true;
	setCurrency('cash_id');	
})
function kontrol()
{
	document.getElementById('currency_id').disabled = false;
	<cfoutput>#iif(isdefined("attributes.draggable"),DE("loadPopupBox('upd_voucher_self' , #attributes.modal_id#);"),DE(""))#</cfoutput>
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
function setCurrency(currencyType)
{
	document.getElementById('currency_id').disabled = false;
	currency = list_last($("#"+currencyType+' :selected').text(),'-');
	
	$("#currency_id option:selected").removeAttr('selected');
	$("#currency_id").find("option").each(function(index,element){
			if($(element).text() == currency)
			{
				$(element).attr('selected','selected');
			}
		})
	currency_control(document.getElementById('currency_id').value);
	document.getElementById('currency_id').disabled = true;
}
function hesapla()
{
	if(document.upd_voucher_self.voucher_value.value != '')
	{
		var temp_voucher_value = filterNum(document.upd_voucher_self.voucher_value.value);
		var money_type=document.upd_voucher_self.currency_id[document.upd_voucher_self.currency_id.options.selectedIndex].value;
		for(s=1;s<=upd_voucher_self.kur_say.value;s++)
		{
			if(eval("document.upd_voucher_self.other_money"+s).value== list_getat(money_type,1,';'))
			{
				form_txt_rate2_ = eval("document.upd_voucher_self.txt_rate2_"+s);
			}
		}
		form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.upd_voucher_self.voucher_system_currency_value.value = commaSplit(parseFloat(temp_voucher_value)*parseFloat(form_txt_rate2_.value ));
		document.upd_voucher_self.voucher_value.value = commaSplit(temp_voucher_value);
		form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	else
		document.upd_voucher_self.voucher_system_currency_value.value =0;
}
function hesapla2()
{
	if(document.upd_voucher_self.voucher_system_currency_value.value != '')
	{
		var temp_voucher_value = filterNum(document.upd_voucher_self.voucher_system_currency_value.value);
		var voucher_value = filterNum(document.upd_voucher_self.voucher_value.value);
		var money_type=document.upd_voucher_self.currency_id[document.upd_voucher_self.currency_id.options.selectedIndex].value;
		form_txt_rate2_ = commaSplit(parseFloat(temp_voucher_value)/parseFloat(voucher_value));
		form_txt_rate2_ = filterNum(form_txt_rate2_,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		for(s=1;s<=upd_voucher_self.kur_say.value;s++)
		{
			if(eval("document.upd_voucher_self.other_money"+s).value== list_getat(money_type,1,';'))
			{
				eval("document.upd_voucher_self.txt_rate2_"+s).value = commaSplit(form_txt_rate2_,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
		}
	}
	else
		document.upd_voucher_self.voucher_system_currency_value.value =0;
}
//form elemanları dolduruluyor
<cfoutput>
	document.upd_voucher_self.voucher_id.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_id'+#attributes.row#).value;
	document.upd_voucher_self.voucher_code.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_code'+#attributes.row#).value;
	document.upd_voucher_self.voucher_city.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_city'+#attributes.row#).value;
	document.upd_voucher_self.portfoy_no.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.portfoy_no'+#attributes.row#).value;
	document.upd_voucher_self.voucher_no.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_no'+#attributes.row#).value;
	document.upd_voucher_self.debtor_name.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.debtor_name'+#attributes.row#).value;
	document.upd_voucher_self.acc_code.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.acc_code'+#attributes.row#).value;
	document.upd_voucher_self.voucher_value.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_value'+#attributes.row#).value;
	document.upd_voucher_self.voucher_system_currency_value.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_system_currency_value'+#attributes.row#).value;
	document.upd_voucher_self.voucher_duedate.value = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.voucher_duedate'+#attributes.row#).value;
	if(document.upd_voucher_self.self_voucher_ != undefined)
		document.upd_voucher_self.self_voucher_.checked = true;
	money_list = eval('<cfif not isdefined("attributes.draggable")>window.opener.</cfif>document.all.money_list'+#attributes.row#).value;
	for(fff=1;fff <=list_getat(money_list,1,'-');fff++)
	{
		money = list_getat(money_list,fff+1,'-');
		eval('upd_voucher_self.other_money' + fff).value = list_getat(money,1,',');
		eval('upd_voucher_self.txt_rate1_' + fff).value = list_getat(money,2,',');
		eval('upd_voucher_self.txt_rate2_' + fff).value = commaSplit(list_getat(money,3,','),'#session.ep.our_company_info.rate_round_num#');
		if(eval('upd_voucher_self.other_money' + fff).value == '#session.ep.money#')
			eval('upd_voucher_self.txt_rate2_' + fff).readOnly = true;
	}
</cfoutput>
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
