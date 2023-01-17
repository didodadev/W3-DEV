<cfquery name="GET_GRADUATE" datasource="#DSN#">
	SELECT 
    	GRADUATE_ID, 
        GRADUATE_NAME, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP	 
    FROM 
    	SETUP_GRADUATE_LEVEL 
    WHERE 
	    GRADUATE_ID = #attributes.id#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td class="headbold"><cf_get_lang no='1669.Eğitim Durumu Ekle'></td>
        <td width="80" align="right" style="text-align:right;"><a href="<cfoutput>#request.self#?fuseaction=settings.form_add_graduate_level</cfoutput>"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
    </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
    <tr>
        <td class="color-row" width="200" valign="top"><cfinclude template="../display/list_graduate_level.cfm"></td>
        <td class="color-row" valign="top">
            <table>
                <cfform name="upd_graduate" method="post" action="#request.self#?fuseaction=settings.emptypopup_upd_graduate_level">
                <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
                    <tr>
                        <td width="80"><cf_get_lang no='25.Durum Adı'>*</td>    
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='324.Durum Adı Girmelisiniz'> !</cfsavecontent>
                            <cfinput type="text" name="graduate_name" maxlength="100" required="yes" message="#message#" value="#get_graduate.graduate_name#" style="width=175px;">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                        <td><textarea name="detail" id="detail" style="width:175px;height:40px;"><cfoutput>#get_graduate.detail#</cfoutput></textarea></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                    </tr>
                    <tr>
                        <td colspan="3"><p><br/>
							<cfoutput>
								<cfif len(get_graduate.record_emp)>
                                	<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_graduate.record_emp,0,0)# - #dateformat(get_graduate.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(get_graduate.update_emp)>
                                	<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_graduate.update_emp,0,0)# - #dateformat(get_graduate.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>
