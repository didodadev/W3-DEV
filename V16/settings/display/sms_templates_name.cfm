<cfquery name="get_sms_template" datasource="#dsn#">
	SELECT 
    	SMS_TEMPLATE_ID, 
        IS_ACTIVE, 
        IS_CHANGE, 
        IS_EDIT_SEND_DATE, 
        SMS_TEMPLATE_NAME, 
        SMS_TEMPLATE_BODY, 
        SMS_FUSEACTION, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP 
    FROM 
	    SMS_TEMPLATE 
    ORDER BY 
    	SMS_TEMPLATE_ID 
</cfquery>
<table>
    <cfif get_sms_template.recordcount>
		<cfoutput query="get_sms_template">
            <div>
                <ul class="ui-list">
                    <li>
                        <a href="#request.self#?fuseaction=settings.form_add_sms_template&event=upd&sms_template_id=#sms_template_id#" clasS="tableyazi"><div class="ui-list-left"><span class="ui-list-icon ctl-check-mark" ></span>#SMS_TEMPLATE_NAME#</div></a>
                    </li>
                </ul>
            </div>
        </cfoutput>
    <cfelse>
        <div>
            <ul class="ui-list">
                <li><i class="fa fa-cube"></i><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı">!</li>
            </ul>
        </div>
    </cfif>  
</table>
