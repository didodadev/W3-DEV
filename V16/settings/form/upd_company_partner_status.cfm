<cfquery name="GET_partner_sta" datasource="#DSN#" maxrows="1">
	SELECT
		CP_STATUS_ID
	FROM
		COMPANY_PARTNER
	WHERE
		CP_STATUS_ID = #attributes.cps_id#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0" >
    <tr>
        <td  class="headbold"><cf_get_lang no='1279.Şirket Çalışan Durumu'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_company_partner_status"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
    </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
    <tr class="color-row">
        <td width="200" valign="top">
            <cfquery name="GET_COMPANY_P" datasource="#dsn#">
                SELECT 
    	            CPS_ID, 
                    STATUS_NAME, 
                    RECORD_DATE, 
                    RECORD_EMP, 
                    RECORD_IP, 
                    UPDATE_DATE, 
                    UPDATE_EMP, 
                    UPDATE_IP 
                FROM 
	                COMPANY_PARTNER_STATUS
            </cfquery>
            <table width="200" cellpadding="0" cellspacing="0" border="0">
                <tr> 
                	<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='1279.Şirket Çalışan Durumu'></td>
                </tr>
                <cfif GET_COMPANY_P.recordcount>
					<cfoutput query="GET_COMPANY_P">
                        <tr>
                            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                            <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_company_partner_status&cps_id=#CPS_ID#" class="tableyazi">#STATUS_NAME#</a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                        <td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
                    </tr>
                </cfif>
            </table>
        </td>
        <td valign="top" >
            <table border="0">
                <cfform action="#request.self#?fuseaction=settings.emptypopup_upd_partner_status" method="post" name="upd_company_status">
                    <cfquery name="CAT" dbtype="query">
                        SELECT *  FROM GET_COMPANY_P WHERE CPS_ID = #attributes.cps_id#
                    </cfquery>
                    <input type="Hidden" name="cps_id" id="cps_id" value="<cfoutput>#attributes.cps_id#</cfoutput>">
                    <tr>
                        <td width="100"><cf_get_lang_main no='68.Başlık'>*</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
                            <cfinput type="Text" name="status_name" style="width:150px;" value="#cat.status_name#" maxlength="255" required="Yes" message="#message#">
                        </td>
                    </tr>
                    <tr height="35">
                        <td></td>
                        <td>
                            <cfif GET_partner_sta.recordcount>
                                <cf_workcube_buttons is_upd='1' is_delete='0'>
                            <cfelse>
                                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_cpstatus&cps_id=#attributes.cps_id#'>
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <cf_get_lang_main no='71.Kayıt'> :
                            <cfoutput>
                                <cfif len(cat.record_emp)>#get_emp_info(cat.record_emp,0,0)#</cfif>
                                <cfif len(cat.record_date)>#dateformat(cat.record_date,dateformat_style)# - #timeformat(date_add('h','#session.ep.time_zone#',cat.record_date),timeformat_style)#</cfif>
                            </cfoutput>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <cf_get_lang_main no='291.Güncelleme'> :
                            <cfoutput>
                                <cfif len(cat.update_emp)>#get_emp_info(cat.update_emp,0,0)#</cfif>
                                <cfif len(cat.update_date)>#dateformat(cat.update_date,dateformat_style)# - #timeformat(date_add('h','#session.ep.time_zone#',cat.update_date),timeformat_style)#</cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>
