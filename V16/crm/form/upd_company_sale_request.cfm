<cfquery name="GET_SALES" datasource="#DSN#">
	SELECT 
    	SALE_REQUEST_ID, 
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
    	COMPANY_SALE_REQUEST 
    WHERE 
	    SALE_REQUEST_ID = #attributes.sale_request_id#
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
<div class="col col-12 col-xs-12">
	<div class="col col-9 col-xs-12">  
		<cf_box title="#getLang('','Satışa Açma Talebi',52000)#" info_href="javascript:openBoxDraggable('#request.self#?fuseaction=crm.popup_list_securefund_info&cpid=#get_sales.company_id#')" info_title_3="#getLang('','Müşteri Teminatları','52294')#">
			<cfform name="upd_sale_req" method="post" action="#request.self#?fuseaction=crm.emptypopup_upd_company_sale_request">
				<input type="hidden" name="cpid" id="cpid" value="<cfoutput>#get_sales.company_id#</cfoutput>">
				<input type="hidden" name="sale_request_id" id="sale_request_id" value="<cfoutput>#attributes.sale_request_id#</cfoutput>">
				<cfif isdefined("attributes.is_normal_form")><input type="hidden" name="is_normal_form" id="is_normal_form" value="<cfoutput>#attributes.is_normal_form#</cfoutput>"></cfif>
				<cf_box_elements>
					<cfoutput>
						<div class="col col-6 col-xs-12"  type="column" index="1" sort="true">
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='57493.Aktif'></label>
								<div class="col col-8 col-xs-12">
									<input type="checkbox" value="1" name="is_active" id="is_active" <cfif get_sales.is_active eq 1>checked</cfif>>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='57457.Müşteri'></label>
								<div class="col col-8 col-xs-12">
									#get_sales.company_id#
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='52057.Eczane Adı'></label>
								<div class="col col-8 col-xs-12">
									<input type="hidden" name="fullname" id="fullname" value="#get_par_info(get_sales.company_id,1,1,0)#">#get_par_info(get_sales.company_id,1,1,0)#
								</div>
							</div>
						</div>
						<div class="col col-6 col-xs-12"  type="column" index="2" sort="true">
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='52056.Talep Eden Şube'></label>
								<div class="col col-8 col-xs-12">
									<input type="hidden" name="branch_id" id="branch_id" value="#get_sales.branch_id#">
										#get_branch_.branch_name#
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='58859.Süreç'></label>
								<div class="col col-8 col-xs-12">
									<cf_workcube_process is_upd='0' select_value = '#get_sales.process_cat#' process_cat_width='193' is_detail='1'>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-4"><cf_get_lang dictionary_id='57629.Açıklama'></label>
								<div class="col col-8 col-xs-12">
									<textarea name="detail" id="detail">#get_sales.detail#</textarea>
								</div>
							</div>
						</div>
					</cfoutput>
				</cf_box_elements>	
				<cf_box_footer>
					<cf_record_info query_name="get_sales">
					<cf_workcube_buttons is_upd='1' add_function='kontrol()' is_delete='0'>
				</cf_box_footer>
				<!--- Eczane Bilgileri -Ortak- --->
				<cfset attributes.consumer_id = get_sales.company_id>
				<cfinclude template="../display/display_customer_info.cfm">
				<!--- Sube Risk Bilgilerini Icerir --->
				<cfset form_branch_id = get_sales.branch_id>
				<cfset form_company_id = get_sales.company_id>
				<cfinclude template="../display/dsp_member_branch_risk_info.cfm">
			</cfform>
		</cf_box>
	</div>
	<div class="col col-3 col-md-3 col-sm-12 col-xs-12">
		<!--- Notlar --->
		<cf_get_workcube_note action_section='SALE_REQUEST_ID' action_id='#attributes.sale_request_id#'><br/>
		<!--- Varlıklar --->
		<cf_get_workcube_asset company_id="#session.ep.company_id#" asset_cat_id="-9" module_id='52' action_section='SALE_REQUEST_ID' action_id='#attributes.sale_request_id#'>
		<div id="general">
			<cf_box id="member_frame" title="#getLang('','Genel Bilgiler','57980')#" box_page="#request.self#?fuseaction=crm.popup_dsp_risk_info&cpid=#get_sales.company_id#&iframe=1&branch_id=#get_related_branch.branch_id#"></cf_box>
		</div>
	</div>
</div>
<script type="text/javascript">
	function kontrol()
	{
		/* BK 120 gun sonra siline 20070608
		x = document.upd_sale_req.branch_id.selectedIndex;
		if (document.upd_sale_req.branch_id[x].value == "")
		{ 
			alert ("Lütfen Şube Seçiniz !");
			upd_sale_req.branch_id.focus();
			return false;
		}*/
		if(document.upd_sale_req.detail.value == "")
		{
			alert("<cf_get_lang no='619.Lütfen Açıklama Giriniz'> !");
			return false;
		}
		// BK 120 gun sonra siline 20070608 upd_sale_req.branch_id.disabled=false;
		return process_cat_control();
	}
	/*BK 120 gun sonra siline 20070608
	function degistir()
	{
		deger_branch_id = document.upd_sale_req.branch_id.value;
		if(deger_branch_id != "")
		{
			deger_branch_id_ilk = deger_branch_id;
		}
		else
		{
			deger_branch_id_ilk = "";
		}
		document.member_frame.location.href='<cfoutput>#request.self#?fuseaction=crm.popup_dsp_risk_info&cpid=#get_sales.company_id#&iframe=1</cfoutput>&branch_id=' + deger_branch_id_ilk;
	}*/
</script>
