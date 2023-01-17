<cfquery name="GET_SETUP_WARNING_RESULT_" datasource="#dsn#">
	SELECT 
    	SETUP_WARNING_RESULT_ID, 
        SETUP_WARNING_RESULT, 
        DETAIL, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP 
    FROM 
    	SETUP_WARNING_RESULT 
    WHERE 
	    SETUP_WARNING_RESULT_ID = #attributes.SETUP_WARNING_RESULT_ID#
</cfquery>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
        <td height="35" class="headbold"><cf_get_lang no='792.Uyarı Onay Cevap Kategorisi Güncelle'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_approval_warnings_answer_types"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
    </tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
    <tr class="color-row">
        <td width="200" valign="top"><cfinclude template="../display/list_warning_approval_answer_types.cfm">
        </td>
        <td valign="top">
            <table border="0">
                <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_approval_warnings_answer_types" method="post" name="position">
                <input type="hidden" name="SETUP_WARNING_RESULT_ID" id="SETUP_WARNING_RESULT_ID" value="<cfoutput>#url.SETUP_WARNING_RESULT_ID#</cfoutput>">
                    <tr>
                        <td width="120"><cf_get_lang_main no='74.kategori'>* </td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='1143.kategori girmelisiniz'></cfsavecontent>
                            <cfinput type="Text" name="setup_warning" style="width:200px;" value="#get_setup_warning_result_.setup_warning_result#" maxlength="50" required="Yes" message="#message#">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                        <td><textarea name="detail" id="detail" style="width:200px;height:60px;"><cfif len(get_setup_warning_result_.detail)><cfoutput>#get_setup_warning_result_.detail#</cfoutput></cfif></textarea></td>
                    </tr>
                    <tr>
                        <td height="35" colspan="2" align="right" style="text-align:right;">
                        	<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_approval_warnings_answer_types&SETUP_WARNING_RESULT_ID=#url.SETUP_WARNING_RESULT_ID#'>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" align="left"><p><br/>
							<cfoutput>
								<cfif len(get_setup_warning_result_.record_emp)>
                                	<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_setup_warning_result_.record_emp,0,0)# - #dateformat(get_setup_warning_result_.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(get_setup_warning_result_.update_emp)>
                                	<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_setup_warning_result_.update_emp,0,0)# - #dateformat(get_setup_warning_result_.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>
