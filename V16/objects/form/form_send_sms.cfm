<cfparam name="attributes.paper_type" default=""><!---1:order , 2: ship, 3:invoice --->
<cfparam name="attributes.paper_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_id" default="">
<cfparam name="attributes.is_spc" default="">
<cfparam name="attributes.modal_id" default="">
<cfquery name="GET_MSG_TEMP" datasource="#DSN#">
	SELECT
		SMS_TEMPLATE_ID,
    	SMS_TEMPLATE_NAME,
        SMS_TEMPLATE_BODY 
    FROM 
    	SMS_TEMPLATE
	WHERE
	<cfif database_type is 'DB2'>
    	','|| SMS_FUSEACTION ||',' LIKE '%,#attributes.sms_action#,%'
	<cfelse>
		','+SMS_FUSEACTION+',' LIKE '%,#attributes.sms_action#,%'
	</cfif>
</cfquery>
<cfif not get_msg_temp.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='33798.Uygun Sms Şablonu Tanımlanmamış'>");
		closeBoxDraggable("<cfoutput>#attributes.modal_id#</cfoutput>")
	</script>
	<cfabort>
</cfif>
<cf_box popup_box="1" title="#getLang('','SMS Gönder','58590')#">
    <cf_box_elements>
        <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
            <div class="form-group col col-12" id="item-temp">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12 margin-left-5"><cf_get_lang dictionary_id ='58640.Şablon'></label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <select name="sms_template" id="sms_template" onchange="sms_temp_change();">
                    <cfoutput query="get_msg_temp">
                        <option value="#sms_template_id#">#sms_template_name#</option>
                    </cfoutput>
                    </select>
                </div>
            </div>
            <div class="form-group col col-12" id="item-member">
                <label class="col col-4 col-md-4 col-sm-4 col-xs-12 margin-left-5"><cf_get_lang dictionary_id ='33843.Gönderilecek Kişi'></label>
                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                    <cfoutput>
                        <cfif attributes.member_type eq 'employee'>
                            #get_emp_info(attributes.member_id,0,1)#
                        <cfelseif attributes.member_type eq 'consumer'>
                            #get_cons_info(attributes.member_id,0,1)#
                        <cfelseif attributes.member_type eq 'partner'>
                            #get_par_info(attributes.member_id,0,0,1)#
                        <cfelseif attributes.member_type eq 'company'>
                            #get_par_info(attributes.member_id,1,0,1)#
                        </cfif>
                    </cfoutput>
                </div>
            </div>
            <div id="sms_msg_info"></div>
        </div>
    </cf_box_elements>
</cf_box>

<script type="text/javascript">
function sms_temp_change()
{
	AjaxPageLoad('<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_form_send_sms_info&is_spc=#attributes.is_spc#&member_type=#attributes.member_type#&member_id=#attributes.member_id#&draggable=1&paper_type=#attributes.paper_type#&paper_id=#attributes.paper_id#</cfoutput>&sms_template_id='+document.getElementById("sms_template").value,'sms_msg_info',1);
}
sms_temp_change();
</script>
