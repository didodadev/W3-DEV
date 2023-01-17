<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE COUNTRY_ID=1
</cfquery>
<cf_box title="#getLang('assetcare',667)#">
	<cfform name="insurance_form" method="post" action="#request.self#?fuseaction=assetcare.emtypopup_add_insurance_info&accident_id=#attributes.accident_id#">
	<input type="hidden" name="accident_id" id="accident_id" value="<cfoutput>#attributes.accident_id#</cfoutput>">
<cf_box_elements>
	<!--- First Col --->
	<div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="1" type="column" sort="true">
		<div class="form-group" id="denounce_date">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='52999.İhbar Tarihi'>*</label>
			<div class="col col-8 col-xs-12">
				<div class="input-group">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='63587.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id ='57742.Tarih'>!</cfsavecontent>
						<cfinput name="denounce_date" type="text" maxlength="10"style="width:140px;" required="yes" validate="#validate_style#" message="#message#"> 
						<span class="input-group-addon"><cf_wrk_date_image date_field="denounce_date"></span>
				</div>
			</div>
		</div>

		<div class="form-group" id="damage_currency">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48540.Tahmini Hasar'>*</label>
			
				<div class="col col-5 col-xs-12">
					<input name="approximate_damage" id="approximate_damage" type="text" class="moneybox" style="width:90px;" onKeyup="return(FormatCurrency(this,event));">
				</div>
				<div class="col col-3 col-xs-12">
					<span>
						<select name="damage_currency" id="damage_currency" style="width:45;">
							<cfinclude template="../query/get_money.cfm">
							<cfoutput query="get_money">
								<option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
							</cfoutput>
						</select>
					</span>
				</div>

		</div>

		
		<div class="form-group" id="payment_date">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58851.Ödeme Tarihi'></label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
						<input name="payment_date" id="payment_date" type="text" value="" maxlength="10"style="width:140px;"> 
							<span class="input-group-addon"><cf_wrk_date_image date_field="payment_date">
							</span>

					</div>
				</div>

		</div>
		<div class="form-group" id="payment_currency">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48543.Ödeme Tutarı'></label>
			
				<div class="col col-5 col-xs-12">
					<cfinput name="payment_total" type="text" class="moneybox" style="width:90px;" onKeyup="return(FormatCurrency(this,event));">
				</div>
				<div class="col col-3 col-xs-12">
					<span>
						<select name="payment_currency" id="payment_currency" style="width:45;">
							<cfinclude template="../query/get_money.cfm">
							<cfoutput query="get_money">
								<option value="#money#"<cfif money eq session.ep.money>selected</cfif>>#money#</option>
							</cfoutput>
						</select>
					</span>
				</div>

		</div>
		<div class="form-group" id="is_payment">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48544.Ödeme Alındı'></label>
				<div class="col col-8 col-xs-12">
					<input type="checkbox" name="is_payment" id="is_payment">
				</div>

		</div>


	</div>
	<!--- Second Col --->
	<div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="1" type="column" sort="true">
		<div class="form-group" id="is_payment">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57434.rapor'>/<cf_get_lang dictionary_id="47991.Beyan"></label>
				<div class="col col-8 col-xs-12">
					<select name="report" id="repor" style="width:140px">
						<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
						<option value="1"><cf_get_lang dictionary_id='57434.rapor'></option>
						<option value="0"><cf_get_lang dictionary_id="47991.Beyan"></option>
					</select>
				</div>

		</div>
		<div class="form-group" id="expert">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="47995.Eksper">/<cf_get_lang dictionary_id='57441.fatura'></label>
				<div class="col col-8 col-xs-12">
					<select name="expert" id="expert" style="width:140px">
						<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
						<option value="1"><cf_get_lang dictionary_id="47995.Eksper"></option>
						<option value="0"><cf_get_lang dictionary_id='57441.fatura'></option>
					</select>
				</div>

		</div>

		<div class="form-group" id="expert_name">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="47995.Eksper"> <cf_get_lang dictionary_id="57897.Adı"></label>
				<div class="col col-8 col-xs-12">
					<input type="text" name="expert_name" id="expert_name" maxlength="50" value="" style="width:140px"/>
				</div>

		</div>
		<div class="form-group" id="file_no">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57691.Dosya"> <cf_get_lang dictionary_id="57487.No"></label>
				<div class="col col-8 col-xs-12">
					<input type="text" name="file_no" id="file_number" maxlength="20" value="" style="width:140px"/>

				</div>
		</div>
		<div class="form-group" id="policy_no">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="48113.Poliçe No"></label>
				<div class="col col-8 col-xs-12">
					<input type="text" name="policy_no" id="policy_no" maxlength="20" value="" style="width:140px"/>
				</div>
		</div>


	</div>
	<!--- Third Col --->
	<div class="col col-4 col-md-4 col-sm-4 col-xs-12" index="1" type="column" sort="true">

		<div class="form-group" id="service_company">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48545.Servis Adı(Tamir)'></label>
				<div class="col col-8 col-xs-12">
					<div class="input-group">
					<input type="hidden" name="service_company_id" id="service_company_id" value=""> 
					<input type="text" name="service_company" id="service_company" value="" style="width:140px;" readonly> 
					<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_name=insurance_form.service_company&field_comp_id=insurance_form.service_company_id&is_buyer_seller=1&select_list=7','list','popup_list_pars');"></span>

					</div>
				</div>
		</div>

		<div class="form-group" id="service_num">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='36428.Servis Tel'></label>
				<div class="col col-8 col-xs-12">
					<cfinput type="text" name="service_num" maxlength="15" style="width:140px;">
				</div>
		</div>

		<div class="form-group" id="service_fax">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="47997.Servis Faks"></label>
				<div class="col col-8 col-xs-12">
					<input type="text" name="service_fax" id="service_fax" maxlength="15" value="" style="width:140px"/>
				</div>
		</div>

		<div class="form-group" id="service_city">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="47999.Servis İli"></label>
				<div class="col col-8 col-xs-12">
					<select name="service_city" id=" service_city" style="width:140px">
						<option value=""><cf_get_lang dictionary_id='57734.seçiniz'></option>
						<cfoutput query="get_city">
							<option value="#city_id#">#city_name#</option>
						</cfoutput>
					</select>
				</div>
		</div>

		<div class="form-group" id="service_city">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57467.Not'></label>
				<div class="col col-8 col-xs-12">
				<textarea name="insurance_detail" id="insurance_detail" style="width:140px;height:45px;"></textarea>
				</div>
		</div>


	</div>


	</cf_box_elements>

		<cf_popup_box_footer><cf_workcube_buttons type_format='1' is_upd='0' add_function='unformat_fields()'></cf_popup_box_footer>
	
		</cfform>
</cf_box>
<script type="text/javascript">
	function unformat_fields()
	{
		document.insurance_form.approximate_damage.value = filterNum(document.insurance_form.approximate_damage.value);
		document.insurance_form.payment_total.value = filterNum(document.insurance_form.payment_total.value);
		if(document.insurance_form.approximate_damage.value == "")
		{
			alert("<cf_get_lang dictionary_id='782.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='670.Hasar Miktarı'>!");
			return false;		
		}
	}
</script>
