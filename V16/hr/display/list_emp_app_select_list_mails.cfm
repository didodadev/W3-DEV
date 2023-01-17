<table cellspacing="0" cellpadding="0" width="350" border="0" align="center">
    <tr class="color-border">
        <td>
            <table cellspacing="1" cellpadding="2" width="100%" border="0">
                <tr class="color-header" height="22">
                    <td width="100%" class="form-title"><cf_get_lang dictionary_id='57459.Yazışmalar'></td>
                    <td><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_app_add_mail&list_id=#attributes.list_id#</cfoutput>','large');"><img src="/images/plus_square.gif" title="<cf_get_lang no='225.Mail Ekle'>" border="0"></a></td>
                </tr>
                <tr class="color-row" height="20" >
                	<td colspan="2">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <cfquery name="GET_EMPAPP_MAIL" datasource="#DSN#">
                                SELECT 
                                    *
                                FROM
                                	EMPLOYEES_APP_MAILS 
                                WHERE 
                                	LIST_ID=#attributes.list_id#
                            </cfquery> 
                            <cfif isDefined("GET_EMPAPP_MAIL") and GET_EMPAPP_MAIL.recordcount>
								<cfoutput query="GET_EMPAPP_MAIL">
                                    <tr>
                                        <td>#GET_EMPAPP_MAIL.MAIL_HEAD#</td>
                                        <td width="15"  style="text-align:right;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_app_upd_mail&emp_app_mail_id=#get_empapp_mail.emp_app_mail_id#&empapp_id=#get_empapp_mail.empapp_id#','medium');"><img src="/images/update_list.gif" border="0"></a></td>
                                    </tr>
                                </cfoutput>
                            </cfif>
                            <cfif isDefined("GET_EMPAPP_MAIL") and (GET_EMPAPP_MAIL.recordcount eq 0)>
                                <tr>
                                	<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>.</td>
                                </tr>
                            </cfif>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
