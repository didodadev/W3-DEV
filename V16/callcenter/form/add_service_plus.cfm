<cf_xml_page_edit>
<cfinclude template="../query/get_service_detail.cfm">
<cfinclude template="../query/get_com_method.cfm">
<cfparam name="attributes.partner_names" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.header" default="">
<cfparam name="attributes.commethod_id" default="">
<cfparam name="attributes.plus_date" default="">
<cfparam name="attributes.employee_id" default="">
<style>
.hide{
	display:none !important;	
	}
</style>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfform name="add_service_meet" method="post" action="#request.self#?fuseaction=call.emptypopup_add_service_plus">
		<cfsavecontent  variable="head"><cf_get_lang dictionary_id='49309.Takip'></cfsavecontent>
		<cf_box title="#head#">
			<input type="hidden" name="service_id" id="service_id" value="<cfoutput>#attributes.service_id#</cfoutput>">
			<input type="hidden" name="plus_type" id="plus_type" value="<cfoutput>#attributes.plus_type#</cfoutput>">
			<input type="hidden" name="url" id="url" value="<cfif isdefined("attributes.url") and len(attributes.url)><cfoutput>#attributes.url#</cfoutput></cfif>">
			<input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
			<input type="hidden" name="x_subs_team_mail_takip" id="x_subs_team_mail_takip" value="<cfoutput>#x_subs_team_mail_takip#</cfoutput>">
			<input type="hidden" name="clicked" id="clicked" value="">
			<cf_box_elements vertical="1">
				<div class="col col-5 col-md-5 col-sm-5 col-xs-12 padding-0" index="1">
					<div class="form-group" id="item-partner_names">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57428.E-posta'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="partner_emails" id="partner_emails" value="">
								<!--- Kaydeden Maili geldiğinde --->
									<cfif len(get_service_detail.NOTIFY_EMPLOYEE_ID)>
										<cfquery name="GET_RECORD_MAIL" datasource="#DSN#">
											SELECT EMPLOYEE_EMAIL RECORD_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.NOTIFY_EMPLOYEE_ID#">
										</cfquery>
									<cfelseif len(get_service_detail.NOTIFY_PARTNER_ID)>
										<cfquery name="GET_RECORD_MAIL" datasource="#DSN#">
											SELECT COMPANY_PARTNER_EMAIL RECORD_EMAIL FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.NOTIFY_PARTNER_ID#">
										</cfquery>
									<cfelseif len(get_service_detail.NOTIFY_CONSUMER_ID)>
										<cfquery name="GET_RECORD_MAIL" datasource="#DSN#">
											SELECT CONSUMER_EMAIL RECORD_EMAIL FROM CONSUMER WHERE CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.NOTIFY_CONSUMER_ID#">
										</cfquery>
									</cfif>
									<!--- Başvuru Yapan Maili geldiğinde --->
									<cfif len(get_service_detail.service_partner_id)>
										<cfquery name="GET_RECORD_MAIL2" datasource="#DSN#">
											SELECT COMPANY_PARTNER_EMAIL RECORD_EMAIL FROM COMPANY_PARTNER WHERE PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.service_partner_id#">
										</cfquery>
									<cfelseif len(get_service_detail.service_consumer_id)>
										<cfquery name="GET_RECORD_MAIL2" datasource="#DSN#">
											SELECT CONSUMER_EMAIL RECORD_EMAIL FROM CONSUMER WHERE CONSUMER_ID =<cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.service_consumer_id#">
										</cfquery>
									<cfelseif len(get_service_detail.service_employee_id)>
										<cfquery name="GET_RECORD_MAIL2" datasource="#DSN#">
											SELECT EMPLOYEE_EMAIL RECORD_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.service_employee_id#">
										</cfquery>
									</cfif>
										<input type="hidden" name="employee_id" id="employee_id" value="<cfif x_default_record_mail eq 1><cfoutput>#get_service_detail.record_member#</cfoutput><cfelse><cfoutput>#get_service_detail.service_employee_id#</cfoutput></cfif>">
										<input type="hidden" name="partner_id" id="partner_id" value="<cfif x_default_record_mail eq 1><cfoutput>#get_service_detail.record_par#</cfoutput><cfelse><cfoutput>#get_service_detail.service_partner_id#</cfoutput></cfif>">
										<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif x_default_record_mail eq 1><cfoutput>#get_service_detail.record_cons#</cfoutput><cfelse><cfoutput>#get_service_detail.service_consumer_id#</cfoutput></cfif>">
										<input type="text" name="partner_names" id="partner_names" value="<cfif isdefined("get_record_mail.record_email")><cfoutput>#get_record_mail.record_email#</cfoutput></cfif><cfif isdefined("get_record_mail2.record_email")><cfoutput>,#get_record_mail2.record_email#</cfoutput></cfif>">
								<cfif get_module_user(47)>
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_mail&mail_id=add_service_meet.partner_emails&names=add_service_meet.partner_names','list');"></span>
									<!--- <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0&field_mail=add_service_meet.partner_names&field_partner=add_service_meet.partner_id&field_consumer=add_service_meet.consumer_id&field_emp_id=add_service_meet.employee_id&select_list=7,8,9','list','popup_list_all_pars');"></span> --->
								</cfif>

							</div>
						</div>
					</div>
					<div class="form-group" id="item-plus_date">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='57742.Tarih'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='57742.Tarih'></cfsavecontent>
								<cfinput type="text" name="plus_date" id="plus_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
								<cfif get_module_user(47)>
									<span class="input-group-addon"><cf_wrk_date_image date_field="plus_date"></span>
								</cfif>
							</div>
						</div>
					</div>
				</div>
				<div class="col col-5 col-md-5 col-sm-5 col-xs-12 padding-0" index="2">
					<div class="form-group" id="item-commethod_id">
						<label class="col col-3 col-md-4 col-xs-12"><cf_get_lang dictionary_id='58143.İletişim'></label>
						<div class="col col-9 col-md-8 col-xs-12">
							<select name="commethod_id" id="commethod_id" >
								<option value="0" selected><cf_get_lang dictionary_id='58143.İletişim'></option>
								<cfoutput query="get_com_method">
									<option value="#commethod_id#">#commethod#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<cfquery name="GET_MODULE_TEMP" datasource="#DSN#">
						SELECT
							TEMPLATE_ID,
							TEMPLATE_HEAD,
							TEMPLATE_CONTENT
						FROM
							TEMPLATE_FORMS
						WHERE
							TEMPLATE_MODULE = 27
					</cfquery>
					<div class="form-group" id="item-template_id">
						<label class="col col-3 col-md-4 col-xs-12"><cf_get_lang dictionary_id ='58640.Şablon'></label>
						<div class="col col-9 col-md-8 col-xs-12">
							<select name="template_id" id="template_id" onChange="document.add_service_meet.action = ''; document.add_service_meet.submit();">
								<option value="" selected><cf_get_lang dictionary_id ='58640.Şablon'></option>
								<cfoutput query="get_module_temp">
									<option value="#template_id#"<cfif isDefined("attributes.template_id") and (attributes.template_id eq template_id)> selected</cfif>>#TEMPLATE_HEAD#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-2 col-md-2 col-sm-2 col-xs-12 padding-0" index="2">
					<a href="<cfoutput>#request.self#?fuseaction=help.wiki</cfoutput>" target="_blank" class="ui-btn ui-btn-gray2 pull-right" style="background:#FF9800;color:#fff"><cf_get_lang dictionary_id="60721.WIKI"></a>
				</div>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" index="3">
					<div class="form-group" id="item-header">
						<label><cf_get_lang dictionary_id='57480.Konu'></label>
						<input type="text" name="header" id="header" placeholder="<cf_get_lang dictionary_id='57480.Konu'>*"  value="<cfif len(get_service_detail.service_head)><cfoutput>#urlDecode(get_service_detail.service_head)#</cfoutput></cfif>">
					</div>
				</div>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12 padding-top-5" index="4">
					<cfmodule
					template="/fckeditor/fckeditor.cfm"
					toolbarSet="WRKContent"
					basePath="/fckeditor/"
					instanceName="plus_content"
					value=""
					width="100%"
					height="200">
				</div>
				<div class="col col-12 col-md-12 col-sm-12 col-xs-12" index="5">
					<div class="form-group" id="item-tip">
						<label><cf_get_lang dictionary_id='61785.Worktips olarak kaydet'><input type="checkbox" id="is_worktips" name="is_worktips"></label>
					</div>
				</div>
			</cf_box_elements>	
			<div class="ui-form-list-btn flex-end">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='49310.Kaydet ve Mail Gönder'></cfsavecontent>
				<cf_workcube_buttons is_upd='0' insert_info='#message#' add_function='control(1)' is_cancel='0'>                    
				<cf_workcube_buttons type_format='1' is_upd='0' add_function='control(0)' >
			</div>
		</cf_box>
	</cfform>
</div>
<script type="text/javascript">
$(document).ready(function(){

    $( "#partner_emails" ).focus();

});
	function control(type_)
	{
		if(type_ == 1)
			document.getElementById('clicked').value='&email=true';

		if(document.getElementById('header').value == '')
		{
			alert("<cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='57480.Konu'>");
			document.getElementById('header').focus();
			return false;
		}
		
		document.add_service_meet.action= document.add_service_meet.action+ document.getElementById('clicked').value; 
		var aaa = document.getElementById('partner_names').value;

		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)) && (document.getElementById('clicked').value == '&email=true'))
		{ 
		   alert("<cf_get_lang dictionary_id='57471.eksik veri'>:<cf_get_lang dictionary_id='57428.E-mail'>!!");
		   document.add_service_meet.action = "<cfoutput>#request.self#?fuseaction=call.emptypopup_add_service_plus</cfoutput>"; 
		   // GA 20120403 kaldirdi document.add_service_meet.action = "<cfoutput>#request.self#?fuseaction=service.emptypopup_add_service_plus</cfoutput>"; 
		   document.getElementById('clicked').value = '';
		   return false;
		}			  	
		return true;
	}	
	<cfif isdefined("attributes.template_id")>
			<cfquery name="GET_MODULE_TEMP1" datasource="#DSN#">
					SELECT
                        TEMPLATE_CONTENT
                    FROM
                    	TEMPLATE_FORMS
                    WHERE
                    	TEMPLATE_MODULE = 27
                        <cfif isDefined("attributes.template_id") and len(attributes.template_id)>		
                            AND TEMPLATE_ID = #attributes.template_id#
                        </cfif>	
				</cfquery>
			document.getElementById('partner_names').value = '<cfoutput>#attributes.partner_names#</cfoutput>';
			document.getElementById('employee_id').value = '<cfoutput>#attributes.employee_id#</cfoutput>';		
			document.getElementById('partner_id').value = '<cfoutput>#attributes.partner_id#</cfoutput>';	
			document.getElementById('consumer_id').value = '<cfoutput>#attributes.consumer_id#</cfoutput>';
			document.getElementById('header').value = '<cfoutput>#attributes.header#</cfoutput>';
			document.getElementById('commethod_id').value = '<cfoutput>#attributes.commethod_id#</cfoutput>';
			document.getElementById('plus_date').value = '<cfoutput>#attributes.plus_date#</cfoutput>';
			document.getElementById('plus_content').value = '<cfoutput>#GET_MODULE_TEMP1.TEMPLATE_CONTENT#</cfoutput>';	
	</cfif>
</script>
