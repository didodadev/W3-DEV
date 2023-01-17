<cfquery name="GET_STAGE" datasource="#dsn#">
	SELECT 
    	VISIT_STAGE_ID, 
        VISIT_STAGE, 
        DETAIL, 
        RECORD_EMP, 
        RECORD_DATE,
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP 
    FROM 
    	SETUP_VISIT_STAGES 
    WHERE 
	    VISIT_STAGE_ID = #attributes.visit_stage_id#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
    <tr>
        <td  class="headbold"><cf_get_lang no='933.Ziyaret Aşamaları'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_visit_stages"><img src="/images/plus1.gif" border="0"></a></td>
    </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
    <tr class="color-row">
        <td width="200" valign="top"><cfinclude template="../display/list_visit_stages.cfm"></td>
        <td valign="top" >
            <table border="0">
                <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_visit_stage" method="post" name="pro_stage">
                <input type="hidden" name="visit_stage_id" id="visit_stage_id" value="<cfoutput>#attributes.visit_stage_id#</cfoutput>">
                    <tr>
                        <td width="100"><cf_get_lang no='672.Ziyaret Aşaması'><font color=black>*</font></td>
                        <td><cfsavecontent variable="message"><cf_get_lang no='41.Aşama Adı Girmelisiniz'> !</cfsavecontent>
                        <cfinput type="Text" name="visit_stage" style="width:200px;" value="#get_stage.visit_stage#" maxlength="50" required="Yes" message="#message#"></td>
                    </tr>
                    <tr>
                        <td><cf_get_lang_main no='217.Açıklama'></td>
                        <td><textarea name="detail" id="detail" style="width:200px;" value=""><cfoutput>#get_stage.detail#</cfoutput></textarea></td>
                    </tr>
                    <tr height="35">
                        <td>&nbsp;</td>
                        <td><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                    </tr>
                    <tr>
                        <td align="left" colspan="2">
							<cfoutput>
								<cfif len(get_stage.record_emp)>
                                	<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_stage.record_emp,0,0)# - #dateformat(get_stage.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(get_stage.update_emp)>
                                	<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_stage.update_emp,0,0)# - #dateformat(get_stage.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>	
