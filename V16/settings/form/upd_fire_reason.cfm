<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td height="35" class="headbold"><cf_get_lang no='1462.Şirket İçi Gerekçeler'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_fire_reason"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'></a></td>
    </tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2" align="center" class="color-border">
    <tr class="color-row">
        <td width="200" valign="top"><cfinclude template="../display/list_fire_reasons.cfm"></td>
        <td valign="top">
            <table>
                <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_fire_reason" method="post" name="title">
                <cfquery name="FIRE_REASON" datasource="#dsn#">
                	SELECT 
        	            REASON_ID, 
                        REASON, 
                        REASON_DETAIL, 
                        RECORD_EMP, 
                        RECORD_IP, 
                        RECORD_DATE, 
                        UPDATE_EMP, 
                        UPDATE_IP, 
                        UPDATE_DATE 
                    FROM 
    	                SETUP_EMPLOYEE_FIRE_REASONS 
                    WHERE 
	                    REASON_ID = #url.reason_id#
                </cfquery>
                <input type="Hidden" name="reason_id" id="reason_id" value="<cfoutput>#url.reason_id#</cfoutput>">
                    <tr>
                        <td width="75"><cf_get_lang_main no='68.Başlık'>*</td>
                        <td><cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
                        <cfinput type="Text" name="reason" value="#FIRE_REASON.REASON#" maxlength="200" required="Yes" message="#message#" style="width:200px;"></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='217.Açıklama'></td>
                        <td><textarea name="reason_detail" id="reason_detail" cols="75" style="width:200px;"><cfoutput>#FIRE_REASON.REASON_DETAIL#</cfoutput></textarea></td>
                    </tr>
                    <tr>
                        <td align="right" colspan="2" height="35" >
                        	<cf_workcube_buttons is_upd='1' is_delete='0'>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2"><cf_get_lang_main no='71.Kayıt'> :
							<cfoutput>#get_emp_info(FIRE_REASON.record_emp,0,0)# - #dateformat(FIRE_REASON.record_date,dateformat_style)#<br/>
								<cfif len(FIRE_REASON.update_emp)>
                                    <cf_get_lang_main no='479.Güncelleyen'> :
                                    #get_emp_info(FIRE_REASON.update_emp,0,0)# - #dateformat(FIRE_REASON.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>

