<cfquery name="get_contract" datasource="#DSN#">
	SELECT
		EC.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	 FROM 
		EMPLOYEES_CONTRACT EC,
		EMPLOYEES E
	 WHERE 
		EC.EMPLOYEE_ID = E.EMPLOYEE_ID AND 
		EC.CONTRACT_ID = #attributes.cont_id#
</cfquery>
<cfparam name="attributes.draggable" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="29522.Sözleşme"></cfsavecontent>
<cf_box title="#message# : #get_contract.EMPLOYEE_NAME# #get_contract.EMPLOYEE_SURNAME#" print_href="#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.cont_id#&print_type=182" closable="0" scroll="1" collapsable="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="upd_contract" action="#request.self#?fuseaction=hr.emptypopup_upd_employee_contract&cont_id=#get_contract.contract_id#" method="POST">
		<cfinput type="hidden" value="#get_contract.contract_id#" name="contract_id" id="contract_id">
		<cfinput type="hidden" value="#get_contract.employee_id#" name="employee_id" id="employee_id">	
		<cfinclude template="../query/get_pursuit_templates.cfm">
		<cf_box_elements>
			<div class="col col-12 form-inline">
				<div class="form-group" id="item-pursuit_templates">
					<div class="input-group x-16">
						<select name="pursuit_templates" id="pursuit_templates" onChange="change_pursuit_templates();" style="vertical-align:middle;">
							<option value="-1"><cf_get_lang dictionary_id ='56619.Şablon Seçiniz'></option>
							<cfoutput query="GET_PURSUIT_TEMPLATES">
								<option value="#TEMPLATE_ID#"<cfif isDefined("attributes.pursuit_templates") and (attributes.pursuit_templates eq TEMPLATE_ID)>selected</cfif>>#TEMPLATE_HEAD#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-contract_date">
					<div class="input-group x-14">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfinput type="text" name="contract_date" style="width:70px;" placeholder="#getLang('main',641)#" validate="#validate_style#" message="#MESSAGE#" required="yes" value="#dateformat(get_contract.contract_date,dateformat_style)#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="contract_date"></span>
					</div>
				</div>	
				<div class="form-group" id="item-contract_finishdate">
					<div class="input-group x-14">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarih'></cfsavecontent>
						<cfinput type="text" name="contract_finishdate" style="width:70px;" placeholder="#getLang('main',288)#" validate="#validate_style#" message="#message#" required="yes" value="#dateformat(get_contract.contract_finishdate,dateformat_style)#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="contract_finishdate"></span>
					</div>
				</div>
				<div class="form-group" id="item-contract_job_id">
					<div class="input-group x-16">

							<cfif len(get_contract.CONTRACT_JOB)>
								<cfquery name="get_pos_cat" datasource="#dsn#">
									SELECT
										POSITION_CAT
									FROM
										SETUP_POSITION_CAT
									WHERE		
										POSITION_CAT_ID =#get_contract.CONTRACT_JOB#	
								</cfquery> 
							</cfif>
							<cfif isDefined("get_pos_cat.POSITION_CAT")>
								<cfset pos_cat = get_pos_cat.POSITION_CAT>
							<cfelse>
								<cfset pos_cat = "">
							</cfif>
							<input type="hidden" name="contract_job_id" id="contract_job_id" value="<cfoutput>#get_contract.CONTRACT_JOB#</cfoutput>"/>
							<cfinput type="text" name="contract_job" readonly="yes" placeholder="#getLang('','Pozisyon Tipi',59004)#" value="#pos_cat#" maxlength="100" style="width:150px;"> 
							<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_position_cats&field_cat_id=add_contract.contract_job_id&field_cat=add_contract.contract_job</cfoutput>','medium');"></span>
						</div>
					</div>	
				<div class="form-group" id="item-contract_no">
					<div class="input-group x-12">
						<cfinput type="text" name="contract_no" placeholder="#getLang('main',2247)#" value="#get_contract.contract_no#" maxlength="100" style="width:135px;">
					</div>
				</div>
				<div class="form-group" id="item-contract_head">
					<div class="input-group x-20">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57480.Konu'></cfsavecontent>
						<cfinput type="text" name="contract_head" placeholder="#getLang('main',68)#" value="#get_contract.contract_head#" required="Yes" message="#message#" maxlength="100"  style="width:500px">
					</div>	
				</div>
			</div>		
		</cf_box_elements>
			<div class="form-group" id="item-contract_detail">
				<cfmodule
				template="/fckeditor/fckeditor.cfm"
				toolbarSet="WRKContent"
				basePath="/fckeditor/"
				instanceName="contract_detail"
				valign="top"
				value="#get_contract.contract_detail#"
				width="500"
				height="250"> 
			</div>
		<cf_box_footer>
			<cf_record_info query_name="get_contract">
			<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=hr.emptypopup_del_employee_contract&contract_id=#get_contract.contract_id#' add_function="kontrol()">
		</cf_box_footer>	
	</cfform>		
</cf_box>
<cfif isdefined("attributes.pursuit_templates")>
	<cfinclude template="../query/get_pursuit_templates.cfm">
	<script type="text/javascript">
		document.upd_contract.contract_date.value = '<cfoutput>#dateformat(get_contract.contract_date,dateformat_style)#</cfoutput>';
		document.upd_contract.contract_finishdate.value = '<cfoutput>#attributes.contract_finishdate#</cfoutput>';
		document.upd_contract.contract_head.value = '<cfoutput>#get_contract.contract_head#</cfoutput>';
		<cfset attributes.pursuit_template_id = attributes.pursuit_templates>
		document.upd_contract.contract_detail.value = '<cfoutput>#GET_PURSUIT_TEMPLATES.TEMPLATE_CONTENT#</cfoutput>';
	</script>
</cfif>
<script>
	function kontrol(){
		<cfif isdefined("attributes.draggable")>
			loadPopupBox('upd_contract' , '<cfoutput>#attributes.modal_id#</cfoutput>')
		</cfif>
	}
	function change_pursuit_templates(){
		var pursuit_templates = document.getElementById("pursuit_templates");
		var selectedValue = pursuit_templates.options[pursuit_templates.selectedIndex].value;
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_add_employee_contract&employee_id=#attributes.employee_id#&pursuit_templates='+ selectedValue +'&contract_finishdate=#dateformat(now(),dateformat_style)#</cfoutput>','contract_box')
	}
</script>