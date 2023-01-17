<cfquery name="get_corp"  datasource="#dsn#"> 
	SELECT 
    	CORPORATION_ID, 
        CORPORATION_CODE, 
        CORPORATION_NAME, 
        CORPORATION_DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_CORPORATIONS 
    WHERE 
	    CORPORATION_ID = #attributes.c_id#
</cfquery>
<table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border" align="center">
    <tr class="color-list" valign="middle">
        <td height="35">
            <table width="98%" align="center">
                <tr>
                    <td width="48%" valign="bottom" class="headbold"><cf_get_lang no='155.Çalışılan Kurumlar'></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr class="color-row" valign="top">
        <td>
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
                <tr>
                    <td colspan="2">
                        <table>
                            <cfform name="upd_corp" method="post" action="#request.self#?fuseaction=settings.emptypopup_corp_upd">
                            <input type="hidden" name="c_id" id="c_id" value="<cfoutput>#get_corp.corporation_id#</cfoutput>">
                                <tr>
                                    <td width="75"><cf_get_lang no='1122.Kurum Kodu'> *</td>
                                    <td><cfsavecontent variable="message1"><cf_get_lang no='1369.Kurum Kodu Girmelisiniz!'> </cfsavecontent>
                                    	<cfinput type="Text" name="corp_code" style="width:200px;" value="#get_corp.corporation_code#" maxlength="50" required="Yes" message="#message1#">
                                    </td>
                                </tr>
                                <tr>
                                    <td><cf_get_lang no='1122.Kurum Kodu'><cf_get_lang no='1123.Kurum Adı'> *</td>
                                    <td><cfsavecontent variable="message2"><cf_get_lang no='1371.Kurum Adı Girmelisiniz !'></cfsavecontent>
                                    <cfinput type="Text" name="corp_name" style="width:200px;" value="#get_corp.corporation_name#" maxlength="50" required="Yes" message="#message2#"></td>
                                </tr>
                                <tr>
                                    <td><cf_get_lang_main no='359.Detay'></td>
                                    <td><textarea name="corp_detail" id="corp_detail" style="width:200px;height:60"><cfoutput>#get_corp.corporation_detail#</cfoutput></textarea></td>
                                </tr>
                                <tr height="35">
                                    <td>&nbsp;</td>
                                    <td><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                                </tr>
                                <tr>
                                    <td colspan="3"><p><br/>
										<cfoutput>
											<cfif len(get_corp.record_emp)>
                                            	<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_corp.record_emp,0,0)# - #dateformat(get_corp.record_date,dateformat_style)#
                                            </cfif><br/>
                                            <cfif len(get_corp.update_emp)>
                                            	<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_corp.update_emp,0,0)# - #dateformat(get_corp.update_date,dateformat_style)#
                                            </cfif>
                                        </cfoutput>
                                    </td>
                                </tr>
                            </cfform>
                        </table>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
