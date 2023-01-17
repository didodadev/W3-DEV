<cfquery name = "get_organization_detail" datasource = "#dsn#">
	SELECT * FROM ORGANIZATION WHERE ORGANIZATION_ID = #attributes.organization_id#
</cfquery>

<cfinclude template="../query/get_com_method.cfm">
<cfparam name="attributes.partner_names" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.partner_id" default="">
<cfparam name="attributes.header" default="">
<cfparam name="attributes.commethod_id" default="">
<cfparam name="attributes.plus_date" default="">
<style>
.hide{
	display:none !important;	
	}
</style>
<cf_box title="#getLang('call',119)#" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
	<cfform name="add_organization_meet" method="post" action="#request.self#?fuseaction=campaign.emptypopup_add_organization_plus">
	<input type="hidden" name="organization_id" id="organization_id"  value="<cfoutput>#attributes.organization_id#</cfoutput>">
	<input type="hidden" name="plus_type" id="plus_type" value="<cfoutput>#attributes.plus_type#</cfoutput>">
	<input type="hidden" name="clicked" id="clicked" value="">
	<cfinput type="hidden" name="draggable" id="draggable" value="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_box_elements>
            <div class="col col-4 col-md-4 col-sm-4 col-xs-6" index="1">
                <div class="form-group" id="item-partner_names">
                    <label class="col col-3 col-md-3 col-xs-12"><cf_get_lang_main no='16.E-posta'>*</label>
                    <div class="col col-9 col-md-9 col-xs-12">
                        <div class="input-group">
							<input type="hidden" name="partner_emails" id="partner_emails" value="">
								<input type="hidden" name="partner_id" id="partner_id" value="">
								<input type="hidden" name="consumer_id" id="consumer_id" value="">
								<input type="text" name="partner_names" id="partner_names" value="" readonly>
							<cfif get_module_user(47)>
								<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_mail=add_organization_meet.partner_names&field_partner=add_organization_meet.partner_id&field_consumer=add_organization_meet.consumer_id&select_list=7,8','list','popup_list_all_pars');"></span>
							</cfif>
						</div>
					</div>
				</div>	
				<div class="form-group" id="item-plus_date">
                    <label class="col col-3 col-md-3 col-xs-12"><cf_get_lang_main no ='330.Tarih'></label>
                    <div class="col col-9 col-md-9 col-xs-12">
                        <div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang_main no ='330.Tarih'></cfsavecontent>
							<cfinput type="text" name="plus_date" id="plus_date" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#">
							<cfif get_module_user(47)>
								<span class="input-group-addon"><cf_wrk_date_image date_field="plus_date"></span>
							</cfif>
						</div>
					</div>
				</div>
			</div>
			<div class="col col-4 col-md-4 col-sm-4 col-xs-6" index="2">
                <div class="form-group" id="item-commethod_id">
                    <label class="col col-3 col-md-4 col-xs-12"><cfoutput>#getLang('main',731)#</cfoutput></label>
                    <div class="col col-9 col-md-8 col-xs-12">
						<select name="commethod_id" id="commethod_id" >
							<option value="0" selected><cf_get_lang_main no='731.İletişim'></option>
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
						TEMPLATE_MODULE = 15
				</cfquery>
				<div class="form-group" id="item-template_id">
                    <label class="col col-3 col-md-4 col-xs-12"><cfoutput>#getLang('main',1228)#</cfoutput></label>
                    <div class="col col-9 col-md-8 col-xs-12">
						<select name="template_id" id="template_id" onChange="document.add_organization_meet.action = ''; document.add_organization_meet.submit();">
							<option value="" selected><cf_get_lang_main no ='1228.Şablon'>
							<cfoutput query="get_module_temp">
								<option value="#template_id#"<cfif isDefined("attributes.template_id") and (attributes.template_id eq template_id)> selected</cfif>>#TEMPLATE_HEAD#</option>
							</cfoutput>
						</select>
					</div>
				</div>
			</div>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" index="3">
                <div class="form-group" id="item-header">
                    <label class="col col-1 col-md-1 col-sm-1 col-xs-12"><cfoutput>#getLang('main',68)#</cfoutput></label>
                    <div class="col col-7 col-md-7 col-sm-7 col-xs-12">
						<input type="text" name="header" id="header" placeholder="<cf_get_lang_main no='68.Konu'>*"  value="<cfif len(get_organization_detail.organization_head)><cfoutput>#get_organization_detail.organization_head#</cfoutput></cfif>">
					</div>
				</div>
			</div>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" index="4">
				<div class="form-group" id="item-plus_content">
					<cfmodule
					template="/fckeditor/fckeditor.cfm"
					toolbarSet="WRKContent"
					basePath="/fckeditor/"
					instanceName="plus_content"
					value=""
					width="100%"
					height="200">
				</div>
			</div>
		</cf_box_elements>	
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' insert_info='#getLang('','Güncelle ve Mail Gönder','49265')#' add_function='control(1)' is_cancel='0'>                    
			<cf_workcube_buttons type_format='1' is_upd='0' add_function='control(0)' >
		</cf_box_footer>
	</cfform>
</cf_box>

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
			alert("Konu Alanı Dolu Olmalıdır");
			document.getElementById('header').focus();
			return false;
		}
		
		document.add_organization_meet.action= document.add_organization_meet.action+ document.getElementById('clicked').value; 
		var aaa = document.getElementById('partner_names').value;

		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)) && (document.getElementById('clicked').value == '&email=true'))
		{ 
		   alert("<cf_get_lang_main no='59.eksik veri'>:<cf_get_lang_main no='16.E-mail'>!!");
		   document.add_organization_meet.action = "<cfoutput>#request.self#?fuseaction=call.emptypopup_add_organization_plus</cfoutput>";
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
			document.getElementById('partner_id').value = '<cfoutput>#attributes.partner_id#</cfoutput>';	
			document.getElementById('consumer_id').value = '<cfoutput>#attributes.consumer_id#</cfoutput>';
			document.getElementById('header').value = '<cfoutput>#attributes.header#</cfoutput>';
			document.getElementById('commethod_id').value = '<cfoutput>#attributes.commethod_id#</cfoutput>';
			document.getElementById('plus_date').value = '<cfoutput>#attributes.plus_date#</cfoutput>';
			document.getElementById('plus_content').value = '<cfoutput>#GET_MODULE_TEMP1.TEMPLATE_CONTENT#</cfoutput>';	
	</cfif>
</script>
