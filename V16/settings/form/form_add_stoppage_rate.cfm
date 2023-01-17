<cfinclude template="../../objects/query/tax_type_code.cfm">
<cfquery name="get_bank_codes" datasource="#dsn#">
	SELECT BANK_CODE, BANK_NAME FROM SETUP_BANK_TYPES
</cfquery>
<cfsavecontent variable="title"><cf_get_lang dictionary_id='43201.Stopaj Oranları'></cfsavecontent>
<cf_box title="#title#" closable="0" collapsed="0">
	<cfform name="add_stoppage_rate" method="post" action="#request.self#?fuseaction=settings.emptypopup_add_stoppage_rate">
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
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43409.Stopaj Oranı'>*</label>
					<div class="col col-8 col-xs-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='43192.Stopaj Oranı Girmelisiniz'></cfsavecontent>
						<cfinput type="text" name="stoppage_rate" size="30" value="" required="Yes" message="#message#" class="moneybox" onKeyUp="return(FormatCurrency(this,event,3));" validate="float" style="width:150px;">
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='43194.Muhasebe Hesabı'>*</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='43202.Muhasebe Hesabı Seçiniz!'></cfsavecontent>
						<input type="hidden" name="account_id" id="account_id" value="">
						<cfinput type="text" name="account_code_name" style="width:150px;" value="" message="#message#" required="yes" readonly="yes" onkeyup="isNumber(this);" range="0,1000">
						<span class="input-group-addon icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_account_plan&field_name=add_stoppage_rate.account_code_name&field_id=add_stoppage_rate.account_id</cfoutput>&account_code='+document.add_stoppage_rate.account_code_name.value,'list')"></a></span>
						</div>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57987.Bankalar'></label>
					<div class="col col-8 col-xs-12">
						<select name="setup_bank_type_id" id="setup_bank_type_id" style="width:150px;">
							<option value=""><cf_get_lang dictionary_id='59006.Banka Kodu'></option>
							<cfoutput query="get_bank_codes">
								<option value="#BANK_CODE#">#BANK_NAME#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30006.Vergi Kodu'> <cfif session.ep.our_company_info.is_efatura>*</cfif></label>
					<div class="col col-8 col-xs-12">
						<select name="tax_code" id="tax_code" style="width:150px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'> !</option>
							<cfoutput query="TAX_CODES">
								<option value="#TAX_CODE_ID#,#TAX_CODE_NAME#" title="#detail#">#TAX_CODE_NAME#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
					<div class="col col-8 col-xs-12"><textarea name="stoppage_rate_detail" id="stoppage_rate_detail" style="width:150px;height:40px;"></textarea></div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
		</cf_box_footer>
	</cfform>
</cf_box>

<script type="text/javascript">
	function kontrol()
	{
		<cfif session.ep.our_company_info.is_efatura>
		if(document.getElementById('tax_code').value == '')
		{
			alert('<cf_get_lang dictionary_id="60818.Vergi Kodu Seçiniz">!');
			return false;
		}
		</cfif>
		document.getElementById('stoppage_rate').value = filterNum(document.getElementById('stoppage_rate').value,4);
		return true;
	}
</script>