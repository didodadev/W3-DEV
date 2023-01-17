<cfquery name="GET_SETUP_BLACKLIST_INFO" datasource="#DSN#">
	SELECT 
    	BLACKLIST_INFO_ID, 
        BLACKLIST_INFO_NAME, 
        BLACKLIST_INFO_DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_BLACKLIST_INFO 
    WHERE 
	    BLACKLIST_INFO_ID = #attributes.id#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td class="headbold"><cf_get_lang no='1789.Kara Listeye Alınma Nedenleri'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_setup_blacklist_info"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
    </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
    <tr>
        <td class="color-row" width="200" valign="top"><cfinclude template="../display/list_setup_blacklist_info.cfm"></td>
        <td class="color-row" valign="top">
            <cfform  name="add_blacklist" action="#request.self#?fuseaction=settings.emptypopup_form_upd_setup_blacklist_info" method="post">
            <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
                <table>
                    <tr>
                        <td width="80"><cf_get_lang_main no='68.başlık'>*</td>    
                        <td>
                        <cfsavecontent variable="message"><cf_get_lang_main no='647.başlık girmelisiniz'>!</cfsavecontent>
                        <cfinput type="text" maxlength="40" name="BLACKLIST_INFO_NAME" style="width:175px;" required="yes" message="#message#" value="#GET_SETUP_BLACKLIST_INFO.BLACKLIST_INFO_NAME#"></td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                        <td><textarea style="width:175;height:40;" name="BLACKLIST_INFO_DETAIL" id="BLACKLIST_INFO_DETAIL"><cfoutput>#GET_SETUP_BLACKLIST_INFO.BLACKLIST_INFO_DETAIL#</cfoutput></textarea></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td colspan="2"><cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_setup_blacklist_info&id=#attributes.id#'></td>
                    </tr>
                    <tr>
                        <td colspan="3"><p><br/>
                        <cfoutput>
							<cfif len(GET_SETUP_BLACKLIST_INFO.record_emp)>
                                <cf_get_lang_main no='71.Kayıt'>:
                            <cfoutput>#get_emp_info(GET_SETUP_BLACKLIST_INFO.record_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,GET_SETUP_BLACKLIST_INFO.record_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,GET_SETUP_BLACKLIST_INFO.record_date),timeformat_style)#)</cfoutput>
                            </cfif><br/>
                            <cfif len(GET_SETUP_BLACKLIST_INFO.update_emp)>
                                <cf_get_lang_main no='291.Güncelleme'>:
                            <cfoutput>#get_emp_info(GET_SETUP_BLACKLIST_INFO.update_emp,0,0)# - #dateformat(date_add('h',session.ep.time_zone,GET_SETUP_BLACKLIST_INFO.update_date),dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,GET_SETUP_BLACKLIST_INFO.update_date),timeformat_style)#)</cfoutput>
                            </cfif>
                        </cfoutput>
                        </td>
                    </tr>
                </table>
            </cfform>
        </td>
    </tr>
</table>
