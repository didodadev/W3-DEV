<cfparam name="attributes.contract_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.contract_head" default="">
<cfparam name="attributes.draggable" default="">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="29522.Sözleşme"></cfsavecontent>
<cf_box title="#message# : #get_emp_info(attributes.employee_id,0,0)#" scroll="1" closable="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_contract" action="#request.self#?fuseaction=hr.emptypopup_add_employee_contract&employee_id=#attributes.employee_id#" method="post">
	<cfinclude template="../query/get_pursuit_templates.cfm">
	<cf_box_elements>
		<div class="col col-12 form-inline">
			<div class="form-group" id="item-pursuit_templates">
				<div class="input-group x-16">
					<select name="pursuit_templates" id="pursuit_templates" onChange="change_pursuit_templates();">
						<option value="-1"><cf_get_lang dictionary_id ='56619.Şablon Seçiniz'></option>
						<cfoutput query="GET_PURSUIT_TEMPLATES">
							<option value="#TEMPLATE_ID#"<cfif isDefined("attributes.pursuit_templates") and (attributes.pursuit_templates eq TEMPLATE_ID)> selected</cfif>>#TEMPLATE_HEAD#</option>
						</cfoutput>
					</select>
				</div>
			</div>
			<div class="form-group" id="item-contract_date">
				<div class="input-group x-14">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfinput type="text" name="contract_date" style="width:70px;" placeholder="#getLang('main',641)#" validate="#validate_style#" message="#MESSAGE#" required="yes">
						<span class="input-group-addon"><cf_wrk_date_image date_field="contract_date"></span>
					</div>
				</div>	
			<div class="form-group" id="item-contract_finishdate">
				<div class="input-group x-14">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57700.Bitiş Tarih'></cfsavecontent>
					<cfinput type="text" name="contract_finishdate" style="width:70px;" placeholder="#getLang('main',288)#" validate="#validate_style#" message="#message#" required="yes">
					<span class="input-group-addon"><cf_wrk_date_image date_field="contract_finishdate"></span>
				</div>
			</div>	
			<div class="form-group" id="item-contract_job_id">
				<div class="input-group x-16">
					<input type="hidden" name="contract_job_id" id="contract_job_id" value="" />
					<cfinput type="text" name="contract_job" readonly="yes" placeholder="#getLang('','Pozisyon Tipi',59004)#" value="" maxlength="100" style="width:150px;"> 
					<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_position_cats&field_cat_id=add_contract.contract_job_id&field_cat=add_contract.contract_job</cfoutput>','medium');"></span>
				</div>
			</div>	
			<div class="form-group" id="item-contract_no">
				<div class="input-group x-12">
						<cfinput type="text" name="contract_no" placeholder="#getLang('main',2247)#" value="" maxlength="100" style="width:135px;">
					</div>
				</div>	
			<div class="form-group" id="item-contract_head">
				<div class="input-group x-20">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='58194.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='57480.Konu'></cfsavecontent>
					<cfinput type="text" name="contract_head" placeholder="#getLang('main',68)#" value="" required="Yes" message="#message#" maxlength="100">
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
			value=""
			width="500"
			height="250"> 
		</div>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='#iif(isdefined("attributes.draggable"),DE("loadPopupBox('add_contract' , #attributes.modal_id#)"),DE(""))#'>
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	function change_pursuit_templates(){
		var pursuit_templates = document.getElementById("pursuit_templates");
		var selectedValue = pursuit_templates.options[pursuit_templates.selectedIndex].value;
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>');
		openBoxDraggable('<cfoutput>#request.self#?fuseaction=hr.popup_add_employee_contract&employee_id=#attributes.employee_id#&pursuit_templates='+ selectedValue +'&contract_finishdate=#dateformat(now(),dateformat_style)#</cfoutput>','contract_box','ui-draggable-box-large')
	}
	<cfif isdefined("attributes.pursuit_templates")>
		document.add_contract.contract_date.value = '<cfoutput>#attributes.contract_date#</cfoutput>';
		document.add_contract.contract_finishdate.value = '<cfoutput>#attributes.contract_finishdate#</cfoutput>';
		document.add_contract.contract_head.value = '<cfoutput>#attributes.contract_head#</cfoutput>';
		<cfset attributes.pursuit_template_id = attributes.pursuit_templates>
		<cfinclude template="../query/get_pursuit_templates.cfm">
		document.add_contract.contract_detail.value = '<cfoutput>#GET_PURSUIT_TEMPLATES.TEMPLATE_CONTENT#</cfoutput>';
	</cfif>
</script>
