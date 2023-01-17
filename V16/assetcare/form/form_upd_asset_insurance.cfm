<cfquery name="ASSET_INSURANCE" datasource="#DSN#">
	SELECT
        ASSET_P_INSURANCE.INSURANCE_ID,
        ASSET_P_INSURANCE.ASSETP_ID,
	    ASSET_P_INSURANCE.INSURANCE_NAME_ID,
        ASSET_P_INSURANCE.POLICY_NO,
        ASSET_P_INSURANCE.INSURANCE_COMPANY,
        ASSET_P_INSURANCE.INSURANCE_START_DATE,
        ASSET_P_INSURANCE.INSURANCE_FINISH_DATE,
        ASSET_P_INSURANCE.INSURANCE_COMPANY,
        ASSET_P_INSURANCE.DETAIL,
        ASSET_P_INSURANCE.RECORD_DATE,
        ASSET_P_INSURANCE.RECORD_EMP,
        ASSET_P_INSURANCE.UPDATE_EMP,
        ASSET_P_INSURANCE.UPDATE_DATE,
		ASSET_P_INSURANCE.INSURANCE_TOTAL,
        COMPANY.FULLNAME,
        ASSET_CARE_CAT.ASSET_CARE
    FROM
        COMPANY,
        ASSET_CARE_CAT,
        ASSET_P_INSURANCE
    WHERE
	    ASSET_CARE_CAT.ASSET_CARE_ID = ASSET_P_INSURANCE.INSURANCE_NAME_ID AND
    	COMPANY.COMPANY_ID = ASSET_P_INSURANCE.INSURANCE_COMPANY AND
    	ASSET_P_INSURANCE.INSURANCE_ID = #attributes.insurance_id#
</cfquery>
<cf_date tarih='attributes.insurance_start_date'>
<cf_date tarih='attributes.insurance_finish_date'>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('assetcare',63)#"popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="asset_care" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_asset_ins&insurance_id=#attributes.insurance_id#">
			<input type="hidden" name="assetp_id" id="assetp_id" value="<cfif isdefined("attributes.assetp_id") and len(attributes.assetp_id)><cfoutput>#attributes.assetp_id#</cfoutput></cfif>">
			<cf_box_elements>
				<div class="col col-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-insurance_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47920.Sigorta Adı'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="insurance_name_id" id="insurance_name_id" value="<cfif isdefined("asset_insurance.insurance_name_id") and len(asset_insurance.insurance_name_id)><cfoutput>#asset_insurance.insurance_name_id#</cfoutput></cfif>">
								<input type="text" name="insurance_name" readonly="readonly" id="insurance_name" value="<cfif len(asset_insurance.asset_care)><cfoutput>#asset_insurance.asset_care#</cfoutput></cfif>" >
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_care_type&field_id=asset_care.insurance_name_id&field_name=asset_care.insurance_name&asset_id=' + <cfoutput>#attributes.assetp_id#</cfoutput>);"></span>
							</div>
						</div>
					</div>

					<div class="form-group" id="item-policy_no">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='47922.Poliçe Numarası'></label>
						<div class="col col-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.Zorunlu Alan'> :<cf_get_lang dictionary_id='47922.Poliçe Numarası'></cfsavecontent>
							<cfinput type="text" name="policy_no" id="policy_no" value="#asset_insurance.policy_no#" required="yes" message="#message#">
						</div>
					</div>

					<div class="form-group" id="item-member_name">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='48380.Sigorta Şirketi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#asset_insurance.insurance_company#</cfoutput>">
								<input type="hidden" name="member_type" id="member_type" value="">
								<input name="member_name" type="text" id="member_name" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1,2\'','COMPANY_ID,MEMBER_TYPE','company_id,member_type','','3','250');" value="<cfoutput>#asset_insurance.fullname#</cfoutput>" autocomplete="off">
								<cfset str_linke_ait="&field_comp_id=asset_care.company_id&field_member_name=asset_care.member_name&field_type=asset_care.member_type">
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#</cfoutput>&select_list=7,8&keyword='+encodeURIComponent(document.asset_care.member_name.value));"></span>
							</div>
						</div>
					</div>
					
					<div class="form-group" id="item-insurance_total">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57673.Tutar'></label>
						<div class="col col-8 col-xs-12">
							<cfinput type="text" name="insurance_total"  value="#TLformat(ASSET_INSURANCE.INSURANCE_TOTAL)#" onkeyup="return(FormatCurrency(this,event));">
						</div>
					</div>
				</div>

				<div class="col col-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-insurance_start_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang_main no='370.Tarih Değerinizi Kontrol Ediniz'> !</cfsavecontent>
								<cfinput type="text" name="insurance_start_date" id="insurance_start_date" value="#dateformat(asset_insurance.insurance_start_date,dateformat_style)#" onChange="add_year();" validate="#validate_style#" maxlength="10" required="yes" message="#message#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="insurance_start_date"></span> 
							</div>
						</div>
					</div>

					<div class="form-group" id="item-insurance_finish_date">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message1"><cf_get_lang_main no='370.Tarih Değerinizi Kontrol Ediniz'> !</cfsavecontent>
								<cfinput type="text" name="insurance_finish_date" id="insurance_finish_date" value="#dateformat(asset_insurance.insurance_finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message1#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="insurance_finish_date"></span> 
							</div>
						</div>
					</div>
					<div class="form-group">
						<label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'></label>
						<div class="col col-8 col-xs-12">
							<textarea name="detail" id="detail"><cfoutput query="ASSET_INSURANCE">#detail#</cfoutput></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="ASSET_INSURANCE">
				<cf_workcube_buttons is_upd='1' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_asset_insurance&insurance_id=#attributes.insurance_id#'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function kontrol()
	{
		if($('#insurance_name_id').val() == "" && $('#insurance_name').val() == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='47920.Sigorta Adı'>");
			return false;
		}

		if($('#company_id').val() == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='48380.Sigorta Şirketi'>");
			return false;
		}
		if($('#insurance_total').val() == "")
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57673.Tutar'>");
			return false;
		}
		document.getElementById('insurance_total').value = filterNum(document.getElementById('insurance_total').value);
		return true;
	}
	function add_year()
	{
		tr = document.getElementById('insurance_start_date').value;
		js_yil = parseInt(tr.substr(6,10))
		xx = js_yil+1;
		document.getElementById('insurance_finish_date').value = tr.replace(js_yil,xx);
	}
</script>
