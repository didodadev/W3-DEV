<cfinclude template="../../objects/query/tax_type_code.cfm">
<cfquery name="get_bank_codes" datasource="#dsn#">
	SELECT BANK_CODE, BANK_NAME FROM SETUP_BANK_TYPES
</cfquery>

<cf_box title="#getLang('settings',1682)#" closable="0" collapsed="0" add_href="#request.self#?fuseaction=settings.form_add_stoppage_rate"> <!--- Stopaj Oranı Güncelle --->
<!--- <cf_form_box title="#getLang('settings',1682)#" right_images="#img_#"> --->
	<cfform name="form" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_stoppage_rate&stoppage_rate_id=#URL.stoppage_rate_id#">
		
	<cf_box_elements>
		<div class="col col-3 col-xs-12">
			<div class="scrollbar" style="max-height:403px;overflow:auto;">
				<div id="cc">
				<cfinclude template="../display/list_stoppage_rates.cfm">
				</div>
			</div>
		</div>
		<div class="col col-4 col-xs-12">
			<div class="form-group">
				<input type="hidden" name="stoppage_rate_id" id="stoppage_rate_id" value="<cfoutput>#URL.stoppage_rate_id#</cfoutput>">
				<cfquery name="STOPPAGE_RATES" datasource="#dsn2#">
					SELECT 
						* 
					FROM 
						SETUP_STOPPAGE_RATES
					WHERE 
						STOPPAGE_RATE_ID = #URL.STOPPAGE_RATE_ID#
				</cfquery>
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43409.Stopaj Oranı'>*</label>
				<div class="col col-8 col-xs-12">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='43192.Stopaj Oranı Girmelisiniz'></cfsavecontent>
						<cfinput type="text" required="yes" message="Stopaj Oranı Giriniz" name="stoppage_rate" size="30" onKeyUp="return(FormatCurrency(this,event,3));" value="#tlFormat(STOPPAGE_RATES.STOPPAGE_RATE)#" class="moneybox" validate="float"></td>
				</div>
			</div>

			<div class="form-group">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43194.Muhasebe Hesabı'>*</label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<cfquery name="GET_ACC_1" datasource="#dsn2#">
							SELECT ACCOUNT_NAME FROM ACCOUNT_PLAN WHERE ACCOUNT_CODE = '#STOPPAGE_RATES.STOPPAGE_ACCOUNT_CODE#'
						</cfquery>
						<input type="hidden" name="account_id" id="account_id" value="<cfoutput>#STOPPAGE_RATES.STOPPAGE_ACCOUNT_CODE#</cfoutput>">
						<cfsavecontent variable="message"><cf_get_lang no='1857.Muhasebe Kodu Seçiniz'>!</cfsavecontent>
						<cfinput type="text" name="account_code_name"  value="#STOPPAGE_RATES.STOPPAGE_ACCOUNT_CODE# - #GET_ACC_1.ACCOUNT_NAME#" message="#message#" required="yes" readonly="yes">
						<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=form.account_code_name&field_id=form.account_id</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></span>
					</div>
				</div>
			</div>

			<div class="form-group">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57987.Bankalar'></label>
				<div class="col col-8 col-xs-12">
					<select name="setup_bank_type_id" id="setup_bank_type_id">
						<option value=""><cf_get_lang dictionary_id='59006.Banka Kodu'></option>
						<cfoutput query="get_bank_codes">
							<option value="#BANK_CODE#" <cfif BANK_CODE eq STOPPAGE_RATES.SETUP_BANK_TYPE_ID>selected</cfif>>#BANK_NAME#</option>
						</cfoutput>
					</select>
				</div>
			</div>

			<div class="form-group">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30006.Vergi Kodu'> <cfif session.ep.our_company_info.is_efatura>*</cfif></label>
				<div class="col col-8 col-xs-12">
					<select name="tax_code" id="tax_code" >
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> !</option>
						<cfoutput query="TAX_CODES">
							<option value="#TAX_CODE_ID#,#TAX_CODE_NAME#" title="#detail#" <cfif tax_codes.TAX_CODE_ID eq STOPPAGE_RATES.tax_code>selected="selected"</cfif>>#TAX_CODE_NAME#</option>
						</cfoutput>
					</select>
				</div>
			</div>

			<div class="form-group">
				<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
				<div class="col col-8 col-xs-12">
					<textarea name="stoppage_rate_detail" id="stoppage_rate_detail" style="width:150px;height:40px;"><cfoutput>#stoppage_rates.detail#</cfoutput></textarea>
				</div>
			</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_record_info query_name="stoppage_rates">
				<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_stoppage_rate&stoppage_rate_id=#url.stoppage_rate_id#&head=#STOPPAGE_RATES.STOPPAGE_ACCOUNT_CODE# - #GET_ACC_1.ACCOUNT_NAME#'>
		</cf_box_footer>
  	</cfform>
</cf_box>
<script type="text/javascript">

	function kontrol()
	{
		<cfif session.ep.our_company_info.is_efatura>
		if(document.getElementById('tax_code').value == '')
		{
			alert('Vergi Kodu Seçiniz !');
			return false;
		}
		</cfif>
		document.getElementById('stoppage_rate').value = filterNum(document.getElementById('stoppage_rate').value,4);
		return true;
	}
</script>