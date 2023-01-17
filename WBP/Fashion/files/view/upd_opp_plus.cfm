<cfinclude template="../query/get_commethod_cats.cfm">
<cfinclude template="../query/get_opp_plus.cfm">
<cf_xml_page_edit fuseact ="sales.popup_form_add_opp_plus">
<cfform name="upd_offer_meet" method="post" action="#request.self#?fuseaction=sales.emptypopup_upd_opp_plus">
<cf_popup_box title="#getLang('sales',114)#"><!---takip--->
	<input type="Hidden" name="clicked" id="clicked" value="">
	<input type="Hidden" name="opp_plus_id" id="opp_plus_id" value="<cfoutput>#opp_plus_id#</cfoutput>">
    <table>
        <cfoutput>
        <tr>
            <td width="60">E-Mail*</td>
            <td><input type="hidden" name="employee_id" id="employee_id" value="#get_opp_plus.employee_id#">
                <input type="text" name="employee_emails" id="employee_emails" style="width:270px;" value="#get_opp_plus.mail_sender#">
                <input type="hidden" name="employee_names" id="employee_names" value="">
                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_check_mail&mail_id=upd_offer_meet.employee_emails&names=upd_offer_meet.employee_names','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
                <cfsavecontent variable="alert"><cf_get_lang_main no ='330.Tarih'></cfsavecontent>
                <cfinput type="text" name="plus_date" style="width:70px;" value="#dateformat(get_opp_plus.plus_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#alert#">
                <cf_wrk_date_image date_field="plus_date">
                <select name="commethod_id" id="commethod_id" style="width:120px;">
                    <option value="0"><cf_get_lang_main no='678.İletişim Yöntemi'></option>
                    <cfloop query="get_commethod_cats">
                        <option value="#commethod_id#" <cfif get_opp_plus.commethod_id eq commethod_id>selected</cfif>>#commethod#</option>
                    </cfloop>
                </select>
            </td>
        </tr>
        <tr>
            <td>CC</td>
            <td>
                <input type="hidden" name="employee_id1" id="employee_id1" value="<cfif isdefined('attributes.contact_id') and Len(attributes.contact_id)>#attributes.contact_id#</cfif>">
                <input type="text" name="employee_emails1" id="employee_emails1" style="width:270px;" value="#get_opp_plus.mail_cc#">
                <input type="hidden" name="employee_names1" id="employee_names1" value="">
                <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_check_mail&mail_id=upd_offer_meet.employee_emails1&names=upd_offer_meet.employee_names1','list');"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
            </td>
        </tr>
        <tr>
            <td><cf_get_lang_main no='68.Başlık'></td>
            <td><input type="text" name="opp_head" id="opp_head" style="width:505px;"  value="#get_opp_plus.plus_subject#"></td>
        </tr>
        </cfoutput>	
        <tr>
            <cfset tr_topic = get_opp_plus.plus_content>
            <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
                <td colspan="2">
                <cfmodule
                    template="/fckeditor/fckeditor.cfm"
                    toolbarSet="WRKContent"
                    basePath="/fckeditor/"
                    instanceName="plus_content"
                    valign="top"
                    value="#tr_topic#"
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
                    width="555"
                    height="300">
                </td>
            </cfif>					
        </tr>
    </table>
	<cf_popup_box_footer>                
    	<cfsavecontent variable="message"><cf_get_lang no='10.Güncelle ve Mail Gönder'></cfsavecontent>
        <cf_workcube_buttons is_upd='0' insert_info='#message#' is_cancel='0' add_function="control()" insert_alert=''>
        <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=sales.emptypopup_del_opp_plus&opp_plus_id=#opp_plus_id#' add_function="fix_date(document.upd_offer_meet.plus_date, 'Tarih')">
    </cf_popup_box_footer>
    </cf_popup_box>
</cfform>
<script type="text/javascript">
	function control()
	{
		document.upd_offer_meet.clicked.value='&email=true';		 
		document.upd_offer_meet.action = document.upd_offer_meet.action + document.upd_offer_meet.clicked.value;
		var aaa = document.upd_offer_meet.employee_emails.value;		 
		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)) && (document.upd_offer_meet.clicked.value == '&email=true'))
		{ 
			alert("<cf_get_lang_main no='1072.Lütfen geçerli bir e-mail adresi giriniz'>");
			document.upd_offer_meet.action = "<cfoutput>#request.self#?fuseaction=sales.emptypopup_upd_opp_plus</cfoutput>";
			return false;
		}			  
		return true;
	}
</script>
