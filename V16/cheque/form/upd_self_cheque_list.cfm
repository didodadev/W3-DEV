<cf_get_lang_set module_name="cheque">
<cfif isnumeric(url.id)>
	<cfquery name="GET_CHEQUE" datasource="#DSN2#">
		SELECT
			C.*
		FROM
			CHEQUE C
		<cfif session.ep.isBranchAuthorization>
			,CHEQUE_HISTORY
			,PAYROLL		
		</cfif>		
		WHERE
			C.CHEQUE_ID = #ATTRIBUTES.ID#
		<cfif session.ep.isBranchAuthorization>
			AND CHEQUE_HISTORY.PAYROLL_ID = PAYROLL.ACTION_ID
			AND C.CHEQUE_ID = CHEQUE_HISTORY.CHEQUE_ID 
			AND CHEQUE_HISTORY.HISTORY_ID = (SELECT MAX(HISTORY_ID) HISTORY_ID FROM CHEQUE_HISTORY WHERE CHEQUE_HISTORY.CHEQUE_ID = C.CHEQUE_ID AND CHEQUE_HISTORY.PAYROLL_ID IS NOT NULL)
			AND CHEQUE_HISTORY.PAYROLL_ID = PAYROLL.ACTION_ID
			AND PAYROLL.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(session.ep.user_location,2,"-")#">
		</cfif>
	</cfquery>
<cfelse>
	<cfset get_cheque.recordcount = 0>
</cfif>
<cfif not get_cheque.recordcount>
	<cfset hata  = 11>
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='57997.Şube Yetkiniz Uygun Değil'> <cf_get_lang dictionary_id='57998.Veya'> <cf_get_lang dictionary_id='58002.Böyle Bir Çek Bulunamadı'> !</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfquery name="GET_MONEY" datasource="#DSN2#">
		SELECT * FROM CHEQUE_MONEY WHERE ACTION_ID = #ATTRIBUTES.ID#
	</cfquery>
	<cfif not GET_MONEY.recordcount>
		<cfquery name="GET_MONEY" datasource="#DSN#">
			SELECT MONEY AS MONEY_TYPE,0 AS IS_SELECTED,* FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS=1
		</cfquery>
	</cfif>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#getLang('cheque','Çek Güncelle',50259)#" add_href="#request.self#?fuseaction=cheque.popup_add_self_cheque_list">
			<cfform name="upd_cheque_entry" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_self_cheque_list" onsubmit="return(unformat_fields());">
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-payroll_id">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58182.Portföy No'></label>
							<div class="col col-8 col-xs-12">
								<input type="hidden" name="cheque_id" id="cheque_id" value="<cfoutput>#get_cheque.cheque_id#</cfoutput>">
								<input type="hidden" name="payroll_id" id="payroll_id" value="<cfoutput>#get_cheque.cheque_payroll_id#</cfoutput>">
								<cfoutput><strong>#get_cheque.CHEQUE_PURSE_NO#</strong></cfoutput>
							</div>
						</div>
						<div class="form-group" id="item-bank_account">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50342.Banka Hesap'> *</label>
							<div class="col col-8 col-xs-12">
								<cf_wrkBankAccounts width='285' selected_value='#get_cheque.account_id#'>
							</div>
						</div>
						<div class="form-group" id="item-company_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfoutput>
										<input type="hidden" name="company_id" id="company_id" value="<cfif len(get_cheque.company_id)>#get_cheque.company_id#</cfif>">
										<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif len(get_cheque.consumer_id)>#get_cheque.consumer_id#</cfif>">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='38282.Firma Seçiniz'>!</cfsavecontent>
										<input type="text" name="company_name" id="company_name" value="<cfif len(get_cheque.company_id)>#get_par_info(get_cheque.company_id,1,1,0)#<cfelseif len(get_cheque.consumer_id)>#get_cons_info(get_cheque.consumer_id,0,0)# </cfif>" message="#message#" style="width:168px;" readonly="yes">
										<span class="input-group-addon icon-ellipsis" onclick="javascript:openBoxDraggable('#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=upd_cheque_entry.company_id&field_comp_name=upd_cheque_entry.company_name&field_consumer=upd_cheque_entry.consumer_id&field_member_name=upd_cheque_entry.company_name<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif>&select_list=2,3');"></span>
									</cfoutput> 
								</div>
							</div>
						</div>
						<div class="form-group" id="item-CHEQUE_NO">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50220.Çek No'> *</label>
							<div class="col col-8 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='50214.Çek No Girmelisiniz !'></cfsavecontent>
								<cfinput type="text" name="CHEQUE_NO" value="#get_cheque.CHEQUE_NO#" validate="integer" message="#message#" style="width:112px;">
							</div>
						</div>
						<div class="form-group" id="item-CHEQUE_VALUE">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50272.İşlem Para Br'> *</label>
							<div class="col col-5 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='50247.Çek Tutarını Giriniz !'></cfsavecontent>
								<cfinput type="text" name="CHEQUE_VALUE" value="#TLFormat(get_cheque.cheque_value)#" class="moneybox" required="yes" onBlur="hesapla();" onKeyup="return(FormatCurrency(this,event));" message="#message#" style="width:112px;">
							</div>
							<div class="col col-3 col-xs-12">
								<select name="cheque_currency" id="cheque_currency" style="width:55px;" onChange="currency_control(this.value);">
									<cfoutput query="get_money">
										<option value="#money_type#;#rate2#;#rate1#" <cfif money_type eq get_cheque.CURRENCY_ID>selected</cfif>>#money_type#</option>
									</cfoutput>
								</select>	
							</div>
						</div>
						<div class="form-group" id="other_money" <cfif get_cheque.CURRENCY_ID neq session.ep.money>style="display:'';"<cfelse> style="display:'none';"</cfif>>
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50263.Sistem Para Br.'> *</label>
							<div class="col col-5 col-xs-12">
								<cfinput type="text" name="cheque_other_currency_value" value="#TLFormat(get_cheque.other_money_value)#" onBlur="hesapla2();" onKeyup="return(FormatCurrency(this,event));" style="width:112px;" class="moneybox" required="yes" message="Tutar Giriniz!">
							</div>
							<div class="col col-3 col-xs-12">
								<cfoutput>#session.ep.money#</cfoutput>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-CHEQUE_DUEDATE">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57640.Vade'> *</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='50203.Vade Girmelisiniz !'></cfsavecontent>
									<cfinput type="text" name="CHEQUE_DUEDATE" value="#dateformat(get_cheque.cheque_duedate,dateformat_style)#" validate="#validate_style#" required="yes" message="#message#" style="width:112px;">
									<span class="input-group-addon"><cf_wrk_date_image date_field="CHEQUE_DUEDATE"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-CHEQUE_CITY">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58181.Ödeme Yeri'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="CHEQUE_CITY" id="CHEQUE_CITY" value="<cfoutput>#get_cheque.cheque_city#</cfoutput>" style="width:112px;">
							</div>
						</div>
						<div class="form-group" id="item-CHEQUE_CODE">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
							<div class="col col-8 col-xs-12">
								<input type="text" name="CHEQUE_CODE" id="CHEQUE_CODE" value="<cfoutput>#get_cheque.cheque_code#</cfoutput>" style="width:112px;">
							</div>
						</div>
						<div class="form-group" id="item-kur_say">
							<!--- <td rowspan="#get_money.recordcount#" valign="top" width="100"></td> --->
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='50440.Döviz Kuru'></label>
							<cfoutput>
								<input type="hidden" name="kur_say" id="kur_say" value="#get_money.recordcount#">
								<cfloop query="get_money">
									<input type="hidden" name="other_money#currentrow#" id="other_money#currentrow#" value="#money_type#">
									<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
									<cfif session.ep.rate_valid eq 1>
										<cfset readonly_info = "yes">
									<cfelse>
										<cfset readonly_info = "no">
									</cfif>
									<div class="col col-1 col-xs-12">
										#money_type# #TLFormat(rate1,0)#/
									</div>
									<div class="col col-1 col-xs-12">
										<input type="text" <cfif readonly_info>readonly</cfif> class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" value="#TLFormat(rate2,'#session.ep.our_company_info.rate_round_num#')#" style="width:50px;" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onBlur="hesapla();" <cfif money_type is session.ep.money>readonly</cfif>>
									</div>
								</cfloop>
							</cfoutput>
						</div>
						<div class="form-group" id="item-record_info">
							<label class="col col-4 col-xs-12"></label>
							<div class="col col-8 col-xs-12">
								<cfoutput>
									<cfif len(get_cheque.RECORD_EMP)><cf_get_lang dictionary_id='57483.Kayıt'>:
										<cfif get_cheque.RECORD_EMP eq 0><cf_get_lang dictionary_id='57702.Sistem Admin'><cfelse>#get_emp_info(get_cheque.RECORD_EMP,0,0)# #dateformat(get_cheque.RECORD_DATE,dateformat_style)# #timeformat(dateadd('h',session.ep.time_zone,get_cheque.RECORD_DATE),timeformat_style)#</cfif>
									</cfif>
									<cfif len(get_cheque.update_emp)><cf_get_lang dictionary_id='57703.Güncelleyen'>:
										<cfif get_cheque.update_emp eq 0><cf_get_lang dictionary_id='57702.Sistem Admin'>#dateformat(dateadd('h',session.ep.time_zone,get_cheque.update_date),dateformat_style)# #timeformat(dateadd('h',session.ep.time_zone,get_cheque.update_date),timeformat_style)#
										<cfelseif len(get_cheque.update_emp)>#get_emp_info(get_cheque.update_emp,0,0)# #dateformat(dateadd('h',session.ep.time_zone,get_cheque.update_date),dateformat_style)# #timeformat(dateadd('h',session.ep.time_zone,get_cheque.update_date),timeformat_style)#
										</cfif>
									</cfif>
								</cfoutput>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=cheque.del_self_cheque_list&id=#url.id#'>
				</cf_box_footer>
			</cfform>
		</cf_box>
	</div>
</cfif>
<script type="text/javascript">
	function unformat_fields()
	{
		document.upd_cheque_entry.CHEQUE_VALUE.value=filterNum(document.upd_cheque_entry.CHEQUE_VALUE.value);
		document.upd_cheque_entry.cheque_other_currency_value.value=filterNum(document.upd_cheque_entry.cheque_other_currency_value.value);
	}
	function kontrol()
	{
		if (document.upd_cheque_entry.company_id.value == '' && document.upd_cheque_entry.consumer_id.value == '')
		{
			alert("Cari Hesap Seçiniz");
			return false;
		}
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
		if(document.upd_cheque_entry.CHEQUE_VALUE.value != '')
		{
			var temp_cheque_value = filterNum(document.upd_cheque_entry.CHEQUE_VALUE.value);
			var money_type=document.upd_cheque_entry.cheque_currency[document.upd_cheque_entry.cheque_currency.options.selectedIndex].value;
			for(s=1;s<=upd_cheque_entry.kur_say.value;s++)
			{
				if(eval("document.upd_cheque_entry.other_money"+s).value== list_getat(money_type,1,';'))
				{
					form_txt_rate2_ = eval("document.upd_cheque_entry.txt_rate2_"+s);
				}
			}
			form_txt_rate2_.value = filterNum(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			document.upd_cheque_entry.cheque_other_currency_value.value = commaSplit(parseFloat(temp_cheque_value)*parseFloat(form_txt_rate2_.value ));
			document.upd_cheque_entry.CHEQUE_VALUE.value = commaSplit(temp_cheque_value);
			form_txt_rate2_.value = commaSplit(form_txt_rate2_.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		}
		else
			document.upd_cheque_entry.cheque_other_currency_value.value =0;
	}
	function hesapla2()
	{
		if(document.upd_cheque_entry.cheque_other_currency_value.value != '')
		{
			var temp_cheque_value = filterNum(document.upd_cheque_entry.cheque_other_currency_value.value);
			var cheque_value = filterNum(document.upd_cheque_entry.CHEQUE_VALUE.value);
			var money_type=document.upd_cheque_entry.cheque_currency[document.upd_cheque_entry.cheque_currency.options.selectedIndex].value;
			form_txt_rate2_ = commaSplit(parseFloat(temp_cheque_value)/parseFloat(cheque_value));
			form_txt_rate2_ = filterNum(form_txt_rate2_,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			for(s=1;s<=upd_cheque_entry.kur_say.value;s++)
			{
				if(eval("document.upd_cheque_entry.other_money"+s).value== list_getat(money_type,1,';'))
				{
					eval("document.upd_cheque_entry.txt_rate2_"+s).value = commaSplit(form_txt_rate2_,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				}
			}
		}
		else
			document.upd_cheque_entry.cheque_other_currency_value.value =0;
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
