<cfquery name="get_membership_stages" datasource="#dsn#">
	SELECT 
    	TR_ID, 
        TR_NAME, 
        TR_DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_MEMBERSHIP_STAGES 
    WHERE 
    	TR_ID = #attributes.tr_id#
</cfquery>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="header"><cf_get_lang dictionary_id='43425.Durum Güncelle'></cfsavecontent>
    <cf_box title="#header#">
        <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_membership_stages" method="post" name="add_stages">
            <cf_box_elements>
                <input name="tr_id" id="tr_id" type="hidden" value="<cfoutput>#attributes.tr_id#</cfoutput>">
                <div class="form-group">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57480.Başlık '>*</label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz!'></cfsavecontent>
                        <cfinput type="Text" name="tr_name" style="width:250px;" value="#get_membership_stages.tr_name#" maxlength="50" required="Yes" message="#message#">
                    </div>
                </div>
                <div class="form-group">
                    <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
                    <div class="col col-8 col-xs-12">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz!'></cfsavecontent>
                        <textarea name="tr_detail" id="tr_detail" style="width:250px;height:100px;"><cfoutput>#get_membership_stages.tr_detail#</cfoutput></textarea>
                    </div>
                </div>
                
            </cf_box_elements>
            <cf_box_footer>
                    <cf_workcube_buttons is_upd='1' is_delete='0'>
                        <table cellpadding="0" cellspacing="0" border="0" width="99%" height="30" align="center">
                            <tr>
                                <td colspan="3"><p><br/>
                                    <cfoutput>
                                        <cfif len(get_membership_stages.record_emp)>
                                            <cf_get_lang dictionary_id='57483.Kayıt'> : #get_emp_info(get_membership_stages.record_emp,0,0)# - #dateformat(get_membership_stages.record_date,dateformat_style)#
                                        </cfif><br/>
                                        <cfif len(get_membership_stages.update_emp)>
                                            <cf_get_lang dictionary_id='57703.Son Güncelleme'> : #get_emp_info(get_membership_stages.update_emp,0,0)# - #dateformat(get_membership_stages.update_date,dateformat_style)#
                                        </cfif>
                                    </cfoutput>
                                </td>
                            </tr>
                        </table>
            </cf_box_footer>
        </cfform>
    </cf_box>
</div>

