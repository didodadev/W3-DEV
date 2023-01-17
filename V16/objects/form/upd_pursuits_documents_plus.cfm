<cfif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_sale_order">
	<cfquery name="get_pursuit_plus" datasource="#dsn3#">
		SELECT * FROM ORDER_PLUS WHERE ORDER_PLUS_ID = #action_plus_id#
	</cfquery>
<cfelseif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_sale_invoice">
	<cfquery name="get_pursuit_plus" datasource="#dsn2#">
		SELECT * FROM INVOICE_PURSUIT_PLUS WHERE INVOICE_PLUS_ID = #action_plus_id#
	</cfquery>
<cfelseif isdefined("attributes.pursuit_type") and attributes.pursuit_type is "is_service_application">
	<cfquery name="get_pursuit_plus" datasource="#dsn3#">
		SELECT *,SUBJECT PLUS_SUBJECT FROM SERVICE_PLUS WHERE SERVICE_PLUS_ID = #action_plus_id#
	</cfquery>
</cfif>

<cfset tr_topic = get_pursuit_plus.plus_content>
<cfset mail_address = "">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='33688.Takip'></cfsavecontent>
<cf_popup_box title="#message#">
<cfform name="upd_order_meet" method="post" action="#request.self#?fuseaction=objects.emptypopup_upd_pursuits_documents_plus">
    <input type="hidden" name="clicked" id="clicked" value="">
    <input type="Hidden" name="action_plus_id" id="action_plus_id" value="<cfoutput>#action_plus_id#</cfoutput>">
    <input type="hidden" name="pursuit_type" id="pursuit_type" value="<cfoutput>#attributes.pursuit_type#</cfoutput>">
        <table>
            <tr>
                <td width="90"><cf_get_lang dictionary_id='57428.E-posta'></td>
                <td><cfif isdefined("get_pursuit_plus.employee_id") and len(get_pursuit_plus.employee_id)>
                        <cfquery name="get_mail_address" datasource="#dsn#">
                            SELECT EMPLOYEE_EMAIL FROM EMPLOYEES WHERE EMPLOYEE_ID = #get_pursuit_plus.employee_id#
                        </cfquery>
                        <cfset mail_address = get_mail_address.employee_email>
                    <cfelseif isdefined("get_pursuit_plus.consumer_id") and len(get_pursuit_plus.consumer_id)>
                        <cfquery name="get_mail_address" datasource="#dsn#">
                            SELECT CONSUMER_EMAIL FROM CONSUMER WHERE CONSUMER_ID = #get_pursuit_plus.consumer_id#
                        </cfquery>
                        <cfset mail_address = get_mail_address.consumer_email>
                    <cfelseif isdefined("get_pursuit_plus.partner_id") and len(get_pursuit_plus.partner_id)>
                        <cfquery name="get_mail_address" datasource="#dsn#">
                            SELECT COMPANY_PARTNER_EMAIL FROM COMPANY_PARTNER WHERE PARTNER_ID = #get_pursuit_plus.partner_id#
                        </cfquery>
                        <cfset mail_address = get_mail_address.company_partner_email>
                    </cfif>
                    <input type="hidden" name="employee_id" id="employee_id" value="<cfif isdefined("get_pursuit_plus.employee_id") and len(get_pursuit_plus.employee_id)><cfoutput>#get_pursuit_plus.employee_id#</cfoutput></cfif>">
                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("get_pursuit_plus.consumer_id") and len(get_pursuit_plus.consumer_id)><cfoutput>#get_pursuit_plus.consumer_id#</cfoutput></cfif>">
                    <input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("get_pursuit_plus.partner_id") and len(get_pursuit_plus.partner_id)><cfoutput>#get_pursuit_plus.partner_id#</cfoutput></cfif>">
                    <input type="hidden" name="member_names" id="member_names" style="width:188px;" value="">
                    <input type="text" name="member_emails" id="member_emails" style="width:188px;" value="<cfif isdefined("get_pursuit_plus.mail_sender")><cfoutput>#get_pursuit_plus.mail_sender#</cfoutput><cfelseif len(mail_address)><cfoutput>#mail_address#</cfoutput></cfif>">
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_check_mail&mail_id=upd_order_meet.member_emails&names=upd_order_meet.member_names','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
                    <cfsavecontent variable="alert"><cf_get_lang dictionary_id='57739.Bitis Tarihi Girmelisiniz'></cfsavecontent>
                    <cfinput type="text" name="plus_date" style="width:65px;" value="#dateformat(get_pursuit_plus.plus_date,dateformat_style)#" validate="#validate_style#" message=" !">
                    <cf_wrk_date_image date_field="plus_date">

                    <cfquery name="get_commethod_cats" datasource="#dsn#">
                        SELECT * FROM SETUP_COMMETHOD ORDER BY COMMETHOD
                    </cfquery>
                    <select name="commethod_id" id="commethod_id"  style="width:113px;">
                        <option value="0"><cf_get_lang dictionary_id='57475.Mail Gönder'></option>
                        <cfoutput query="get_commethod_cats">
                            <option value="#commethod_id#" <cfif get_pursuit_plus.commethod_id eq commethod_id>selected</cfif>>#commethod#</option>
                        </cfoutput>
                    </select>
                </td>
            </tr>
            <tr>
                <td width="90"><cf_get_lang dictionary_id='57480.Başlık'></td>
                <td><input type="text" name="opp_head" id="opp_head" style="width:410px;" value="<cfoutput>#get_pursuit_plus.plus_subject#</cfoutput>"></td>
            </tr>
            <tr>
                <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
                    <td colspan="2">
             <cfmodule
                template="/fckeditor/fckeditor.cfm"
                toolbarSet="WRKContent"
                basePath="/fckeditor/"
                instanceName="plus_content"
                valign="top"
                value="#tr_topic#"
                width="575"
                height="300">
                    </td>
                <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>  
                    <td colspan="2">
             <cfmodule
                template="/fckeditor/fckeditor.cfm"
                toolbarSet="WRKContent"
                basePath="/fckeditor/"
                instanceName="plus_content"
                valign="top"
                value="#tr_topic#"
                width="575"
                height="300">
                    </td>
                </cfif>			  
            </tr>
		</table>
	<cf_popup_box_footer>
        <cf_record_info query_name="get_pursuit_plus">
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='33689.Kaydet ve Mail Gönder'></cfsavecontent>
        <cf_workcube_buttons 
            is_upd='0'
            insert_info='#message#'
            is_cancel='0'
            add_function="control()" 
            insert_alert=''>
        <cf_workcube_buttons 
            is_upd='1' 
            delete_page_url='#request.self#?fuseaction=objects.emptypopup_del_pursuits_documents_plus&action_plus_id=#action_plus_id#&pursuit_type=#attributes.pursuit_type#'>
    </cf_popup_box_footer>
</cfform>
</cf_popup_box>
  
<script type="text/javascript">
	 function control()
	 {
	 	 document.upd_order_meet.clicked.value='&email=true';
		 document.upd_order_meet.action = "<cfoutput>#request.self#?fuseaction=objects.emptypopup_upd_pursuits_documents_plus</cfoutput>" + document.upd_order_meet.clicked.value;
		 var aaa = document.upd_order_meet.member_emails.value;		 
		 if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)) && (document.upd_order_meet.action.value += '&email=true'))
		 { 
				   alert("<cf_get_lang dictionary_id='58484.Lütfen mail alanına geçerli bir mail giriniz'>!!");
				   document.upd_order_meet.action = "<cfoutput>#request.self#?fuseaction=objects.emptypopup_upd_pursuits_documents_plus</cfoutput>";
				   return false;
		 }			  
		 return true;
	 }	 
</script>
