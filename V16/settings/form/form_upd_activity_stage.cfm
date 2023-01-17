<cfquery name="SETUP_ACTIVITY_STAGES" datasource="#dsn#">
	SELECT 
    	ACTIVITY_STAGE_ID, 
        ACTIVITY_STAGE, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP,
        UPDATE_DATE, 
        UPDATE_EMP 
    FROM 
    	SETUP_ACTIVITY_STAGES 
    WHERE 
	    ACTIVITY_STAGE_ID = #attributes.activity_stage_id#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
    <tr>
        <td  class="headbold"><cf_get_lang no='1188.Etkinlik Aşaması'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_activity_stages"><img src="/images/plus1.gif" border="0"></a></td>
    </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
    <tr class="color-row">
        <td width="200" valign="top"><cfinclude template="../display/list_activity_stages.cfm"></td>
        <td valign="top" >
            <table border="0">
                <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_activity_stages" method="post" name="pro_stage">
                <input type="hidden" name="activity_stage_id" id="activity_stage_id" value="<cfoutput>#attributes.activity_stage_id#</cfoutput>">
                    <tr>
                        <td width="100"><cf_get_lang_main no='74.Kategori'><font color=black>*</font></td>
                        <td><cfsavecontent variable="message"><cf_get_lang no ='1187.Kategori Girmelisiniz'> !</cfsavecontent>
                        <cfinput type="Text" name="activity_stage" style="width:200px;" value="#SETUP_ACTIVITY_STAGES.ACTIVITY_STAGE#" maxlength="50" required="Yes" message="#message#"></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='217.Açıklama'></td>
                        <td><textarea name="detail" id="detail" style="width:200px;" value=""><cfoutput>#SETUP_ACTIVITY_STAGES.DETAIL#</cfoutput></textarea></td>
                    </tr>
                    <tr height="35">
                        <td>&nbsp;</td>
                        <td><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                    </tr>
                    <tr>
                        <td align="left" colspan="2">
							<cfoutput>
								<cfif len(SETUP_ACTIVITY_STAGES.record_emp)>
                                	<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(SETUP_ACTIVITY_STAGES.record_emp,0,0)# - #dateformat(SETUP_ACTIVITY_STAGES.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(SETUP_ACTIVITY_STAGES.update_emp)>
                                	<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(SETUP_ACTIVITY_STAGES.update_emp,0,0)# - #dateformat(SETUP_ACTIVITY_STAGES.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>
