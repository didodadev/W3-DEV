<!---e.a select ifadeleri düzenlendi 23072012--->
<cf_xml_page_edit fuseact ="bank.popup_add_autopayment_export">
<cfif isdefined("attributes.i_id")>
	<cfquery name="get_is_dbs" datasource="#dsn2#">
		SELECT IS_DBS FROM FILE_IMPORTS WHERE I_ID = #attributes.i_id#
	</cfquery>
<cfelse>
	<cfset get_is_dbs.recordcount = 0>
</cfif>
<cfquery name="GET_ACCOUNTS" datasource="#DSN3#">
	SELECT
		ACCOUNTS.ACCOUNT_ID,
		ACCOUNTS.ACCOUNT_NAME,
		<cfif session.ep.period_year lt 2009>
			CASE WHEN(ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL') THEN 'YTL' ELSE ACCOUNTS.ACCOUNT_CURRENCY_ID END AS  ACCOUNT_CURRENCY_ID
		<cfelse>
			ACCOUNTS.ACCOUNT_CURRENCY_ID
		</cfif> 
	FROM
		ACCOUNTS,
		BANK_BRANCH
	WHERE
		ACCOUNTS.ACCOUNT_BRANCH_ID = BANK_BRANCH.BANK_BRANCH_ID AND
		ACCOUNTS.ACCOUNT_STATUS = 1
		<cfif isdefined("attributes.money_type") and len(attributes.money_type)>
			AND ACCOUNTS.ACCOUNT_CURRENCY_ID = '#attributes.money_type#'
		</cfif>
		<cfif not (isdefined("get_is_dbs.is_dbs") and get_is_dbs.is_dbs eq 1)>
			<cfif not isDefined("attributes.bank_order_type")>
				<cfif session.ep.period_year lt 2009>
					AND ACCOUNTS.ACCOUNT_CURRENCY_ID = 'TL'<!--- bankadan gelen dosyalarda sadece ytl işlemler yapıldıgı için --->
				<cfelse>
					AND ACCOUNTS.ACCOUNT_CURRENCY_ID = '#session.ep.money#'<!--- bankadan gelen dosyalarda sadece ytl işlemler yapıldıgı için --->
				</cfif>
			</cfif>
		</cfif>
	ORDER BY
		BANK_NAME,
		ACCOUNT_NAME
</cfquery>
<cfquery name="get_money_rate" datasource="#dsn2#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS=1 ORDER BY MONEY_ID
</cfquery>
<cfparam name="attributes.prov_period" default="">
<cfsavecontent variable="head_">
	<cfif isDefined("attributes.account_id_info") and len(attributes.account_id_info)><cf_get_lang no='111.Toplu Havale Oluştur'><cfelse><cf_get_lang no ='377.Otomatik Ödeme Import'></cfif>
</cfsavecontent>

<cf_box title="#getLang('','',48875)# #getLang('','',58641)#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="autopayment_import" enctype="multipart/form-data" method="post" action="#request.self#?fuseaction=bank.emptypopupflush_add_autopayment_import#xml_str#" onsubmit="return control();">
		<cfoutput>
        	<input type="hidden" name="is_encrypt_file" id="is_encrypt_file" value="#is_encrypt_file#">
        	<input type="hidden" name="modal_id" id="modal_id" value="#attributes.modal_id#">
			<cfif isDefined("attributes.i_id")><input type="hidden" name="i_id" id="i_id" value="#attributes.i_id#"></cfif><!--- banka talimatları listesinden toplu havale olusturda kullanılsin diye --->
			<cfif isDefined("attributes.bank_order_type")><!--- toplu havale oluşturda,gidenmi gelenmi talimat olduğunu tutuyor --->
				<input type="hidden" name="bank_order_type" id="bank_order_type" value="#attributes.bank_order_type#">
				<input type="hidden" name="checked_value" id="checked_value" value="<cfif isdefined("checked_value")>#checked_value#</cfif>">
			</cfif>
		</cfoutput>
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-process_cat">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='61806.İşlem Tipi'>*</label>
					<div class="col col-8 col-xs-12">
						<cfif get_is_dbs.recordcount and get_is_dbs.is_dbs eq 1>
							<cf_workcube_process_cat slct_width="225" process_type_info="24">
						<cfelse>
							<cf_workcube_process_cat slct_width="225">
						</cfif>
					</div>
				</div>
				<div class="form-group" id="item-action_to_account_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48706.Banka/Hesap'></label>
					<div class="col col-8 col-xs-12">
						<select name="action_to_account_id" id="action_to_account_id" <cfif isDefined("attributes.account_id_info") and len(attributes.account_id_info)>disabled</cfif>>
							<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
							<cfoutput query="get_accounts">
								<option value="#account_id#;#account_currency_id#;#listgetat(session.ep.user_location,2,'-')#" <cfif isDefined("attributes.account_id_info") and len(attributes.account_id_info) and listfirst(attributes.account_id_info,';') eq account_id>selected</cfif>>#account_name#&nbsp;#account_currency_id#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<cfif is_encrypt_file eq 1 and isDefined("attributes.i_id")><!--- xml den şifreleme yapılsn --->
					<div class="form-group" id="item-key_type">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57552.Şifre'>*</label>
						<div class="col col-8 col-xs-12">
							<input name="key_type" id="key_type" type="password" autocomplete="off" style="width:225px;">
						</div>
					</div>
				</cfif>
				<cfif (session.ep.admin or get_module_power_user()) and is_show_related_inv_period eq 1 and isDefined("attributes.i_id")><!--- sadece yıl sonunda ve pronet için uzman bilgisinde yapılması gerektigi icin admine bağlanmıstır...Aysenur20060614 .. xml le yeni kontroller eklenmiştir.--->
					<div class="form-group" id="item-prov_period">
						<label class="col col-4 col-xs-12"><cf_get_lang no ='295.İlişkili Fatura Dönemi'></label>
						<div class="col col-8 col-xs-12">
							<cfquery name="GET_PERIODS" datasource="#DSN#">
								SELECT PERIOD_ID,PERIOD,PERIOD_YEAR FROM SETUP_PERIOD ORDER BY OUR_COMPANY_ID,PERIOD_YEAR
							</cfquery>
							<select name="prov_period" id="prov_period" style="width:225px;">
								<cfoutput query="get_periods">
									<option value="#period_id#" <cfif attributes.prov_period eq period_id> selected<cfelseif period_id eq session.ep.period_id> selected</cfif>>#period# - (#period_year#)</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</cfif>
				<div class="form-group" id="item-process_date">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57879.İşlem Tarihi'>*</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='56283.Tarih girmelisiniz'>!</cfsavecontent>
							<cfif isDefined("attributes.bank_order_type")>
								<cfinput required="yes" value="#dateformat(now(),dateformat_style)#" message="#message#" type="text" name="process_date" id="process_date" style="width:65px;" validate="#validate_style#" maxlength="10" onBlur="change_money_info('autopayment_import','process_date');">
								<span class="input-group-addon"><cf_wrk_date_image date_field="process_date" call_function="change_money_info"></span>
							<cfelse>
								<cfinput required="yes" value="#dateformat(now(),dateformat_style)#" message="#message#" type="text" name="process_date" id="process_date" style="width:65px;" validate="#validate_style#" maxlength="10">
								<span class="input-group-addon"><cf_wrk_date_image date_field="process_date"></span>
							</cfif>
						</div>
					</div>
				</div>
			
				<cfif isDefined("attributes.bank_order_type")>
					<div class="ui-row">
						<div id="sepetim_total" class="padding-0">
							<div class="col col-3 col-md-3 col-sm-3 col-xs-12"type="column" index="3" sort="false">
								<div class="totalBox">
									<div class="totalBoxHead font-grey-mint">
										<span class="headText"><cf_get_lang dictionary_id='50360.Dövizler'> </span>
										<div class="collapse">
											<span class="icon-minus"></span>
										</div>
									</div>
									<div class="row">
										<div class="col col-12" class="totalBoxBody">
											<table>
												<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money_rate.recordcount#</cfoutput>">
												<cfoutput query="get_money_rate">
													<tr>
														<td height="17">
															<input type="hidden" name="hidden_rd_money_#currentrow#" id="hidden_rd_money_#currentrow#" value="#money#">
															<input type="hidden" name="txt_rate1_#currentrow#" id="txt_rate1_#currentrow#" value="#rate1#">
															<input type="radio" name="rd_money" id="rd_money" value="#money#,#currentrow#,#rate1#,#rate2#" <cfif money eq session.ep.money2>checked</cfif>>#money#
														</td>
														<td>#TLFormat(rate1,0)#/<input type="text" class="box" name="txt_rate2_#currentrow#" id="txt_rate2_#currentrow#" <cfif money eq session.ep.money>readonly="yes"</cfif> value="#TLFormat(rate2,4)#" style="width:50px;" onKeyUp="return(FormatCurrency(this,event,4));" onBlur="if(filterNum(this.value) <=0) this.value=commaSplit(1);"></td>
													</tr>
												</cfoutput>
											</table>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</cfif>
			</div>
		
		</cf_box_elements>		
		<cf_box_footer>
			<div class="col col-12">
				<cf_workcube_buttons type_format="1" is_upd='0' add_function='control()&&#iif(isdefined("attributes.draggable"),DE("loadPopupBox('autopayment_import' , #attributes.modal_id#)"),DE(""))#'>
			</div>
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	if(autopayment_import.key_type != undefined)
		autopayment_import.key_type.focus();
	function control()
	{
		if (!chk_process_cat('autopayment_import')) return false;
		if (!check_display_files('autopayment_import')) return false;
		if (!chk_period(document.autopayment_import.process_date, 'İşlem')) return false;
		var selected_ptype = document.autopayment_import.process_cat.options[document.autopayment_import.process_cat.selectedIndex].value;
		eval('var proc_control = document.autopayment_import.ct_process_type_'+selected_ptype+'.value');
		if(proc_control == 25)//giden havale
		{
			<cfif isDefined("attributes.bank_order_type") and attributes.bank_order_type eq 0>//otomatik havale ekranından gelen banka talimatları için yapıldysa,gelen havale seçmeli
				alert ("Gelen Havale İşlem Tipi Seçiniz!");
				return false;
			<cfelseif not isDefined("attributes.bank_order_type")>//otomatik ödeme sayfasndan yapıldıgı durumda,sadece gelen havale yapıyor çünkü
				alert ("Gelen Havale İşlem Tipi Seçiniz!");
				return false;
			</cfif>
		}
		else if(proc_control == 24)//gelen havale
		{
			<cfif isDefined("attributes.bank_order_type") and attributes.bank_order_type eq 1>//otomtk havale ekranından giden banka talimatı seçildğnde işlem tipi de giden havale seçilmeli
				alert ("Giden Havale İşlem Tipi Seçiniz!");
				return false;
			</cfif>
		}
		<cfif not isDefined("attributes.bank_order_type") or not get_is_dbs.recordcount>
			x = document.autopayment_import.action_to_account_id.selectedIndex;
			if (document.autopayment_import.action_to_account_id[x].value == "")
			{ 
				alert ("<cf_get_lang no ='347.Hesap Seçiniz'>!");
				return false;
			}
		</cfif>
		<cfif isDefined("attributes.i_id") and is_encrypt_file eq 1>// xml den şifreleme yapılsn
			if(autopayment_import.key_type.value == "")
			{
				alert("<cf_get_lang no ='378.Şifre Giriniz'>!");
				return false;
			}
		</cfif>
		<cfif not get_is_dbs.recordcount>
			if(document.getElementById('action_to_account_id').disabled == true)
				document.getElementById('action_to_account_id').disabled = false;
		</cfif>
		return true;
	}
</script>
