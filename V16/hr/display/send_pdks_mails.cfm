<cfquery name="get_mail_warnings" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		SETUP_MAIL_WARNING
	ORDER BY
		MAIL_CAT
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('','PDKS Durumları','56556')#" uidrop="1" closable="1">
        <cfform name="send_" action="#request.self#?fuseaction=hr.emptypopup_send_pdks_mails">
            <cf_box_elements>
                <div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-file_format">
                        <cfif isdefined("attributes.employee_id")>
                            <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
                        <cfelse>
                            <input type="hidden" name="employee_id_list" id="employee_id_list" value="<cfoutput>#attributes.employee_id_list#</cfoutput>">
                        </cfif>
                    </div>      
                    <div class="form-group" id="item-aktif_gun">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55684.İlgili Tarih'></label>
                        <div class="col col-8 col-xs-12">
                            <input type="text" value="<cfoutput>#attributes.aktif_gun#</cfoutput>" name="aktif_gun" id="aktif_gun" readonly>
                        </div>
                    </div>  
                    <div class="form-group" id="item-message_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55721.Mesaj Tipi'></label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput>
                                <select name="message_type" id="message_type" onChange="make_action();">
                                    <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                                    <cfloop query="get_mail_warnings">
                                        <option value="#MAIL_CAT_ID#">#MAIL_CAT#</option>
                                    </cfloop>
                                </select>
                            </cfoutput>
                        </div>
                    </div> 
                    <div class="form-group" id="item-mail_warnings">
                        <label class="col col-4 col-xs-12 bold"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput query="get_mail_warnings">
                                <label id="alan_#MAIL_CAT_ID#" <cfif currentrow neq 1>style="display:none;"</cfif>>
                                    #DETAIL#
                                </label>
                            </cfoutput>
                        </div>
                    </div>  
                </div>                                 
            </cf_box_elements>
            <cf_box_footer>
                <cf_workcube_buttons is_upd='0'>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	function make_action()
	{
	<cfoutput query="get_mail_warnings">
		gizle(alan_#MAIL_CAT_ID#);
		goster(eval("alan_"+document.send_.message_type.value));
	</cfoutput>
	}
</script>
