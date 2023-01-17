<cfquery name="GET_COMPANY_RISK" datasource="#DSN#">
	SELECT * FROM COMPANY_RISK_REQUEST WHERE REQUEST_ID = #attributes.request_id#
</cfquery>
<cfquery name="GET_MONEY_RATE" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #session.ep.period_id# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT BRANCH_ID, BRANCH_NAME FROM BRANCH WHERE BRANCH_ID = #get_company_risk.branch_id#
</cfquery>

<cfif attributes.fuseaction eq 'crm.list_risk_request'>
    <cf_catalystHeader>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<div class="col col-9">
		<cf_box title="#getLang('','Risk Yönetimi','51994')#">
			<cfform name="upd_comp_risk" method="post" action="#request.self#?fuseaction=crm.emptypopup_upd_company_risk">
				<cfinput type="hidden" name="cpid" id="cpid" value="#get_company_risk.company_id#">
				<cfinput type="hidden" name="request_id" id="request_id" value="#attributes.request_id#">
				<cfinput type="hidden" name="is_form" id="is_form" value="1">
				<cf_box_elements>
					<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-is_active">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12">&nbsp</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<label><input type="checkbox" value="1" name="is_active" id="is_active" <cfif get_company_risk.is_active eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'></label>
							</div>
						</div>
						<div class="form-group" id="item-branch_name">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52056.Talep Eden Şube'> *</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="hidden" name="branch_id" id="branch_id" value="#get_company_risk.branch_id#">
								<cfinput type="text" readonly name="branch_n" id="branch_n" value="#get_branch.branch_name#">
							</div>
						</div>
						<div class="form-group" id="item-consumer_id">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'><cf_get_lang dictionary_id='58527.ID'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" readonly name="cust_n" id="cust_n" value="#get_company_risk.company_id#">
							</div>
						</div>
						<div class="form-group" id="item-process_cat">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cf_workcube_process is_upd='0' select_value = '#get_company_risk.process_cat#' process_cat_width='193' is_detail='1'>
							</div>
						</div>
						<div class="form-group" id="item-fullname">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52057.Eczane Adı'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" name="fullname" id="fullname" value="#get_par_info(get_company_risk.company_id,1,1,0)#">
							</div>
						</div>
						<div class="form-group" id="item-risk_total">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52059.Yeni Risk Limiti'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<cfinput type="text" name="risk_total" id="risk_total" value="#tlformat(get_company_risk.risk_total)#" onkeyup="return(FormatCurrency(this,event));" class="moneybox">
									<span class="input-group-addon width">
										<select name="money_type" id="money_type">
											<cfoutput query="get_money_rate">
												<option value="#money#" <cfif get_company_risk.risk_money_currency eq money>selected</cfif>>#money#</option>
											</cfoutput>
										</select>
									</span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-valid_date">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<div class="input-group">
									<input type="text" name="valid_date" id="valid_date" value="<cfif len(get_company_risk.valid_date)><cfoutput>#DateFormat(get_company_risk.valid_date,dateformat_style)#</cfoutput></cfif>" maxlength="10">
									<input type="hidden" name="bugun" id="bugun" value="<cfoutput>#DateFormat(now(),dateformat_style)#</cfoutput>">
									<span class="input-group-addon">
										<cf_wrk_date_image date_field='valid_date'>
									</span>
								</div>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_seperator title="#getLang('','Eczane Bilgi Detayları','52326')#" id="eczane_bilgi_detaylari_">
				<div id="eczane_bilgi_detaylari_">
					<cfset attributes.consumer_id = get_company_risk.company_id>
					<cfinclude template="../display/display_customer_info.cfm">
					<cf_box_elements>
						<div class="col col-4 col-md-6 col-sm-12 col-xs-12" type="column" index="3" sort="true">
							<div class="form-group" id="item-detail">
								<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'>*</label>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12"><textarea style="height:80px;" name="detail" id="detail" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"></textarea></div>
							</div>
						</div>
					</cf_box_elements>
					<cfset form_branch_id = get_company_risk.branch_id>
					<cfset form_company_id = get_company_risk.company_id>
				</div>
				<cfinclude template="../display/dsp_member_branch_risk_info.cfm">
				
				<div class="col col-12">
					<cfif len(get_company_risk.is_submit) and (get_company_risk.is_submit eq 1)>
						<td>&nbsp;</td>
					<cfelse>
						<cfif not (len(get_company_risk.is_run) and (get_company_risk.is_run eq 1))>
							<cf_box_footer><cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0'></cf_box_footer>
						</cfif>
					</cfif>
				</div>
			</cfform>
		</cf_box>
	</div>
	<div class="col col-3">
		<!--- Notlar --->
		<cf_get_workcube_note action_section='REQUEST_ID' action_id='#attributes.request_id#'>
		<!--- Varliklar --->
		<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-9" module_id='52' action_section='REQUEST_ID' action_id='#attributes.request_id#'>
		<cf_box id="member_frame" title="#getLang('','Genel Bilgiler','57980')#" box_page="#request.self#?fuseaction=crm.popup_dsp_risk_info&cpid=#get_company_risk.company_id#&iframe=1&branch_id=#get_branch.branch_id#"></cf_box>
	</div>
</div>

		
<script type="text/javascript">
function kontrol()
{
	if(document.upd_comp_risk.risk_total.value == "")
	{
		alert("<cf_get_lang no='585.Lütfen Risk Limiti Giriniz'> !");
		return false;
	}
	if(document.upd_comp_risk.valid_date.value != "")
	{
		fark = datediff(document.upd_comp_risk.valid_date.value,document.upd_comp_risk.bugun.value,0);
		if(fark > 0)
		{
			alert("<cf_get_lang no ='878.Bugünden Büyük Bir Tarih Girmelisiniz'> !");
			return false;
		}
	}
	
	if(document.upd_comp_risk.detail.value == "")
	{
		alert("<cf_get_lang no='619.Lütfen Açıklama Giriniz'> !");
		return false;
	}
	upd_comp_risk.risk_total.value = filterNum(upd_comp_risk.risk_total.value);
	return process_cat_control();
}
</script>
