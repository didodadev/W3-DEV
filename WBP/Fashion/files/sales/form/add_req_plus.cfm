<cfinclude template="/V16/sales/query/get_commethod_cats.cfm">
<cf_xml_page_edit fuseact ="sales.popup_form_add_opp_plus">
<cf_get_lang_set module_name="sales">
<cf_popup_box title="#getLang('textile',15)#"><!---.takip--->

<cfif isdefined('session.ep.userid')>
    <cfquery name="GET_MAILFROM" datasource="#DSN#">
        SELECT
            EMPLOYEE_ID,EMPLOYEE_EMAIL,EMPLOYEE_NAME NAME_,EMPLOYEE_SURNAME SURNAME_
        FROM		
            EMPLOYEE_POSITIONS	
        WHERE
            EMPLOYEE_ID = #session.ep.USERID#
    </cfquery>
    <cfif GET_MAILFROM.RECORDCOUNT>
        <cfset cc_mails = "#GET_MAILFROM.NAME_# #GET_MAILFROM.SURNAME_#<#GET_MAILFROM.EMPLOYEE_EMAIL#>">
        <cfset cc_mails_name = '#GET_MAILFROM.NAME_# #GET_MAILFROM.SURNAME_#'>
        <cfset cc_mails_id = GET_MAILFROM.employee_id>
    </cfif>
<cfelse>
	<cfset cc_mails = ''>
    <cfset cc_mails_name = ''>
    <cfset cc_mails_id = ''>
</cfif>

<cfform name="add_offer_meet" method="post" action="#request.self#?fuseaction=textile.emptypopup_add_req_plus">
	<input type="Hidden" id="clicked" name="clicked" value="">
	<input type="Hidden" name="req_id" id="req_id" value="<cfoutput>#req_id#</cfoutput>">
     <cfoutput>
       <div class="row form-inline">
    
            <div class="form-group" id="item-plus_date">
            	<label class=><cf_get_lang_main no='330.Tarih'>*</label>
             <div class="input-group x-12">
                <input type="text" name="plus_date" id="plus_date"  value="<cfif isdefined('attributes.plus_date')>#attributes.plus_date#<cfelse>#dateformat(now(),dateformat_style)#</cfif>">
                <span class="input-group-addon"><cf_wrk_date_image date_field="plus_date"></span>
              </div> 
           </div>
		   <div class="form-group" id="item-critics">
            <div class="input-group x-18">
                <select name="critics" id="critics">
                    <option value="0">İşçilik Tipi Seçiniz</option>
					<option value="1">Yıkama</option>
					<option value="2">Dikim</option>
					<option value="3">Kesme</option>
					<option value="4">Boyama</option>
                </select>
             </div> 
           </div>
      </div>
         
     </div>
</div> 
       <div class="row form-inline">
            <div class="col col-12 form-inline">
        <div class="form-group" id="item-opp_head">
            <label class=><cf_get_lang_main no='68.Başlık'>*</label>&nbsp;&nbsp;&nbsp;&nbsp;
            <div class="input-group x-18">
            <input type="text" name="opp_head" id="opp_head" value="">
                <cfinclude template="/V16/sales/query/get_pursuit_templates.cfm">
              </div>
         </div>  
</div>
	
</cfoutput>	
        <cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
                <div class="colspan=2">
                    <cfmodule
                        template="/fckeditor/fckeditor.cfm"
                        toolbarset="Basic"
                        basepath="/fckeditor/"
                        instancename="plus_content"
                        valign="top"
                        value=""
                        width="750"
                        height="250">
                </div>
            <cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
                <div class="colspan=2">
                    <cfmodule
                        template="/fckeditor/fckeditor.cfm"
                        toolbarset="WRKContent"
                        basepath="/fckeditor/"
                        instancename="plus_content"
                        valign="top"
                        value=""
                        width="750"
                        height="250">
                </div>
            </cfif>				
    <div class="form-group">
	<cf_popup_box_footer>
    	<cfsavecontent variable="message"><cf_get_lang no='9.Kaydet ve Mail Gönder'></cfsavecontent>
    	<cf_workcube_buttons is_upd='0' insert_info='#message#' is_cancel='0' add_function="control()" insert_alert=''>
		<cf_workcube_buttons is_upd='0'>
    </cf_popup_box_footer>
</cfform>
</cf_popup_box>
      </div>  
<script type="text/javascript">
	document.add_offer_meet.opp_head.value = window.opener.<cfoutput>#attributes.header#</cfoutput>.value;
	function control()
	{
		document.add_offer_meet.clicked.value='&email=true';
		document.add_offer_meet.action = "<cfoutput>#request.self#</cfoutput>?fuseaction=sales.emptypopup_add_opp_plus" + document.add_offer_meet.clicked.value;
		var aaa = document.add_offer_meet.employee_emails.value;
		if (((aaa == '') || (aaa.indexOf('@') == -1) || (aaa.indexOf('.') == -1) || (aaa.length < 6)) && (document.add_offer_meet.clicked.value == '&email=true'))
		{ 
			alert("<cf_get_lang_main no='1072.Lütfen geçerli bir e-mail adresi giriniz'>");
			document.add_offer_meet.action = "<cfoutput>#request.self#</cfoutput>?fuseaction=sales.emptypopup_add_opp_plus";
			return false;
		}			  
		return true;
	}
	<cfset attributes.pursuit_template_id = -1>
	<cfif isDefined("attributes.pursuit_templates")>
		<cfset attributes.pursuit_template_id = attributes.pursuit_templates>
	</cfif>
	<cfinclude template="/V16/sales/query/get_pursuit_templates.cfm">	
	document.all.plus_content.value = '<cfoutput>#GET_PURSUIT_TEMPLATES.TEMPLATE_CONTENT#</cfoutput>'; 
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->