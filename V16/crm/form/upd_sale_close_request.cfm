<cfquery name="GET_SALES" datasource="#DSN#">
	SELECT 
    	SALE_CLOSE_REQUEST_ID, 
        COMPANY_ID, 
        BRANCH_ID, 
        PROCESS_CAT, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        IS_ACTIVE, 
        IS_SUBMIT 
    FROM 
    	COMPANY_SALE_CLOSE_REQUEST 
    WHERE 
	    SALE_CLOSE_REQUEST_ID = #attributes.sale_request_id#
</cfquery>
<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT 
		BRANCH.BRANCH_ID,
		BRANCH.BRANCH_NAME
	FROM
		BRANCH,
		COMPANY_BRANCH_RELATED
	WHERE
		COMPANY_BRANCH_RELATED.MUSTERIDURUM IS NOT NULL AND
		BRANCH.BRANCH_ID = COMPANY_BRANCH_RELATED.BRANCH_ID AND
		COMPANY_BRANCH_RELATED.COMPANY_ID = #get_sales.company_id# AND
		BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
</cfquery>
<cfquery name="GET_BRANCH_" dbtype="query">
	SELECT BRANCH_NAME FROM GET_BRANCH WHERE BRANCH_ID = #get_sales.branch_id#
</cfquery>
<cfquery name="GET_RELATED_BRANCH" dbtype="query">
	SELECT BRANCH_ID FROM GET_BRANCH WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
</cfquery>
<cfif attributes.fuseaction eq 'crm.list_sales_close_request'><cf_catalystHeader></cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<div class="col col-9 col-md-9 col-sm-12 col-xs-12">
		<cf_box title="#getLang('','Satışa Kapama Talebi','52001')#">
			<cfform name="upd_sale_req" method="post" action="#request.self#?fuseaction=crm.emptypopup_upd_company_sale_close_request">
				<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#get_sales.company_id#</cfoutput>">
				<input type="hidden" name="sale_request_id" id="sale_request_id" value="<cfoutput>#attributes.sale_request_id#</cfoutput>">
				<cfif isdefined("attributes.is_normal_form")><input type="hidden" name="is_normal_form" id="is_normal_form" value="<cfoutput>#attributes.is_normal_form#</cfoutput>"></cfif>
				<cf_box_elements>	
					<div class="col col-6 col-md-6 col-sm-12 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-is_active">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12">&nbsp</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<label><input type="checkbox" value="1" name="is_active" id="is_active" <cfif get_sales.is_active eq 1>checked</cfif>><cf_get_lang dictionary_id='57493.Aktif'></label>
							</div>
						</div>
						<div class="form-group" id="item-branch_name">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52056.Talep Eden Şube'> *</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="hidden" name="branch_id" id="branch_id" value="#get_sales.branch_id#">
								<cfinput type="text" readonly name="br_name" value="#get_branch_.branch_name#">
							</div>
						</div>
						<div class="form-group" id="item-consumer_id">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57457.Müşteri'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="text" readonly name="cust" value="#get_sales.company_id#">
							</div>
						</div>
						<div class="form-group" id="item-process_cat">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='58859.Süreç'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cf_workcube_process is_upd='0' select_value = '#get_sales.process_cat#' process_cat_width='193' is_detail='1'>
							</div>
						</div>
						<div class="form-group" id="item-fullname">
							<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='52057.Eczane Adı'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<cfinput type="hidden" name="fullname" id="fullname" value="#get_par_info(get_sales.company_id,1,1,0)#">
								<cfinput type="text" readonly name="ecz_name" value="#get_par_info(get_sales.company_id,1,1,0)#">
							</div>
						</div>
					</div>
				</cf_box_elements>
				<!--- Eczane Bilgileri -Ortak- --->
				<cf_seperator title="#getLang('','Eczane Bilgi Detayları','52326')#" id="eczane_bilgi_detaylari_">
				<div id="eczane_bilgi_detaylari_">
					<cfset attributes.consumer_id = get_sales.company_id>
					<cfinclude template="../display/display_customer_info.cfm">
					<cf_box_elements>
						<div class="col col-4 col-md-6 col-sm-12 col-xs-12" type="column" index="3" sort="true">
							<div class="form-group" id="item-detail">
								<label class="col col-4 col-md-4 col-sm-4 -col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'>*</label>
								<div class="col col-6 col-md-6 col-sm-6 col-xs-12"><textarea style="height:80px;" name="detail" id="detail" maxlength="1000" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);"></textarea></div>
							</div>
						</div>
					</cf_box_elements>
				</div>
				<cfset form_branch_id = get_sales.branch_id>
				<cfset form_company_id = get_sales.company_id>
				<cfinclude template="../display/dsp_member_branch_risk_info.cfm">
				<cf_box_footer>
				<div class="col col-12">
						<cfif get_sales.is_submit neq 1>
							<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0'>
							<cf_record_info query_name="GET_SALES">
						</cfif>
					</div>
				</cf_box_footer>
			</cfform>
		</cf_box>
	</div>
	<div class="col col-3 col-md-3 col-sm-12 col-xs-12">
		<!--- Notlar --->
		<cf_get_workcube_note action_section='SALE_CLOSE_REQUEST_ID' action_id='#attributes.sale_request_id#'>
		<!--- Varlıklar --->
		<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-9" module_id='52' action_section='SALE_CLOSE_REQUEST_ID' action_id='#attributes.sale_request_id#'>
		<cf_box id="member_frame" title="#getLang('','Genel Bilgiler','57980')#" box_page="#request.self#?fuseaction=crm.popup_dsp_risk_info&cpid=#get_sales.company_id#&iframe=1&branch_id=#get_related_branch.branch_id#"></cf_box>
	</div>
</div>


<script type="text/javascript">
function kontrol()
{
	if(document.upd_sale_req.detail.value == "")
	{
		alert("<cf_get_lang dictionary_id='31629.Lütfen Açıklama Giriniz'>!");
		return false;
	}
	return process_cat_control();
}
</script>
