<cfset mail_address = "">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33688.Takip'></cfsavecontent>
<cf_popup_box title="#message#">
<cfform name="add_order_meet" method="post" action="#request.self#?fuseaction=objects.emptypopup_add_pursuits_documents_plus">
	<input type="hidden" name="action_id" id="action_id" value="<cfoutput>#action_id#</cfoutput>">
	<input type="hidden" name="pursuit_type" id="pursuit_type" value="<cfoutput>#attributes.pursuit_type#</cfoutput>">
	<input type="hidden" name="clicked" id="clicked" value="">
    <div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
                	<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1">
                    	<div class="form-group" id="item-member_emails">
                        	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57428.E-posta'></label>
                            <div class="col col-9 col-xs-12">
                            	<div class="input-group">
                                	<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)>
                                        <cfquery name="get_mail_address" datasource="#dsn#">
                                            SELECT EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = #attributes.employee_id#
                                        </cfquery>
                                        <cfset mail_address = get_mail_address.employee_email>
                                    <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
                                        <cfquery name="get_mail_address" datasource="#dsn#">
                                            SELECT CONSUMER_EMAIL FROM CONSUMER WHERE CONSUMER_ID = #attributes.consumer_id#
                                        </cfquery>
                                        <cfset mail_address = get_mail_address.consumer_email>
                                    <cfelseif isdefined("attributes.partner_id") and len(attributes.partner_id)>
                                        <cfquery name="get_mail_address" datasource="#dsn#">
                                            SELECT COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER WHERE PARTNER_ID = #attributes.partner_id#
                                        </cfquery>
                                        <cfset mail_address = get_mail_address.company_partner_email>
                                    </cfif>
                                    <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("attributes.employee_id")><cfoutput>#attributes.employee_id#</cfoutput></cfif>">
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                                    <input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.partner_id")><cfoutput>#attributes.partner_id#</cfoutput></cfif>">
                                    <input type="hidden" name="member_names" id="member_names" style="width:188px;" value="">
                                    <input type="text" name="member_emails" id="member_emails" style="width:188px;" value="<cfif isdefined("attributes.contact_mail")><cfoutput>#attributes.contact_mail#</cfoutput><cfelseif len(mail_address)><cfoutput>#mail_address#</cfoutput></cfif>">
									<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_mail&mail_id=add_order_meet.member_emails&names=add_order_meet.member_names','list');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-opp_head">
                        	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık'></label>
                            <div class="col col-9 col-xs-12">
                            	<cfquery name="get_pursuit_templates" datasource="#dsn#">
                                    SELECT 
                                        * 
                                    FROM 
                                        TEMPLATE_FORMS
                                    WHERE
                                        IS_PURSUIT_TEMPLATE = 1	
                                        <cfif isDefined("attributes.pursuit_template_id")>		
                                            AND TEMPLATE_ID = #attributes.pursuit_template_id#
                                        </cfif>			
                                    ORDER BY 
                                        TEMPLATE_HEAD	
                                </cfquery>
                                <input type="text" name="opp_head" id="opp_head" style="width:270px;" value="">
                            </div>
                        </div>
                    </div>
                    <cfquery name="get_commethod_cats" datasource="#dsn#">
                        SELECT * FROM SETUP_COMMETHOD ORDER BY COMMETHOD
                    </cfquery>
                    <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2">
                    	<div class="form-group" id="item-plus_date">
                        	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                            <div class="col col-9 col-xs-12">
                            	<div class="input-group">
                                    <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='57782.Tarih Değerinizi Kontrol Ediniz'></cfsavecontent>
                                    <cfinput type="text" name="plus_date" style="width:65px;" value="#dateformat(now(),dateformat_style)#" validate="#validate_style#" message="#alert#">
									<span class="input-group-addon"><cf_wrk_date_image date_field="plus_date"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-commethod_id">
                        	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='57475.Mail Gönder'></label>
                            <div class="col col-9 col-xs-12">
                            	<select name="commethod_id" id="commethod_id" style="width:113px;">
                                    <option value="0"><cf_get_lang dictionary_id='57475.Mail Gönder'></option>
                                    <cfoutput query="get_commethod_cats">
                                        <option value="#commethod_id#">#commethod#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group" id="item-pursuit_templates">
                        	<label class="col col-3 col-xs-12"><cf_get_lang dictionary_id='58640.Şablon'></label>
                            <div class="col col-9 col-xs-12">
                            	<select name="pursuit_templates" id="pursuit_templates" style="width:113px;" onchange="document.add_order_meet.action = '';document.add_order_meet.submit();">
                                    <option value="-1"><cf_get_lang dictionary_id='58640.Şablon'></option>
                                    <cfoutput query="get_pursuit_templates">
                                        <option value="#template_id#"<cfif isDefined("attributes.pursuit_templates") and (attributes.pursuit_templates eq template_id)> selected</cfif>>#template_head#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </div>
                </div>
				<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>                
                <div class="row" type="row">
                     <cfmodule
                        template="/fckeditor/fckeditor.cfm"
                        toolbarset="WRKContent"
                        basepath="/fckeditor/"
                        instancename="plus_content"
                        valign="top"
                        value=""
                        width="660"
                        height="250">
                 </div>
				<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>  
                <div class="row" type="row">
                     <cfmodule
                        template="/fckeditor/fckeditor.cfm"
                        toolbarset="WRKContent"
                        basepath="/fckeditor/"
                        instancename="plus_content"
                        valign="top"
                        value=""
                        width="575"
                        height="400">
                 </div>
                 </cfif>	
                </div>
                <div class="row formContentFooter">
                	<div class="col col-12">
                    	<cfsavecontent variable="message"><cf_get_lang dictionary_id='33689.Kaydet ve Mail Gönder'></cfsavecontent>
                    	<cf_workcube_buttons 
                        is_upd='0'
                        insert_info='#message#'
                        is_cancel='0'
                        add_function="control()" 
                        insert_alert=''>
                         <cf_workcube_buttons
                    	is_upd='0'>
                    </div>
                </div>
            </div>
        </div>
    </div>
</cfform>
</cf_popup_box>
<script type="text/javascript">
document.add_order_meet.opp_head.value = window.opener.<cfoutput>#header#</cfoutput>.value;
function control()
{	 
	document.add_order_meet.clicked.value='&email=true';
	document.add_order_meet.action = "<cfoutput>#request.self#?fuseaction=objects.emptypopup_add_pursuits_documents_plus</cfoutput>" + document.add_order_meet.clicked.value;
	
	var aaa = document.add_order_meet.member_emails.value;
	if (((aaa != '') && ((aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6))) && (document.add_order_meet.clicked.value == '&email=true'))
	{ 
		alert("<cf_get_lang dictionary_id ='58484.Lütfen mail alanına geçerli bir mail giriniz'>!!");
		document.add_order_meet.action = "<cfoutput>#request.self#?fuseaction=objects.emptypopup_add_pursuits_documents_plus</cfoutput>"; 
		return false;
	}			  
	
	return true;
}	 
	 
	<cfset attributes.pursuit_template_id = -1>
	<cfif isDefined("attributes.pursuit_templates")>
		<cfset attributes.pursuit_template_id = attributes.pursuit_templates>
	</cfif>
	<cfquery name="get_pursuit_templates" datasource="#dsn#">
		SELECT 
			 * 
		FROM 
			TEMPLATE_FORMS
		WHERE
			IS_PURSUIT_TEMPLATE = 1	
		<cfif isDefined("attributes.pursuit_template_id")>		
		AND
			TEMPLATE_ID = #attributes.pursuit_template_id#
		</cfif>			
		ORDER BY 
			TEMPLATE_HEAD	
	</cfquery>
	document.all.plus_content.value = '<cfoutput>#get_pursuit_templates.template_content#</cfoutput>';	 
</script>
