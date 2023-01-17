<cfquery name="GET_AUTHORITY" datasource="#DSN#">
	SELECT 
    	AUTHORITY_ID, 
        AUTHORITY_NAME, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_PURCHASE_AUTHORITY 
    WHERE 
    	AUTHORITY_ID = #attributes.id#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td class="headbold"><cf_get_lang no='872.Mal Alımındaki Etkinlik Durumu'></td>
        <td width="80" align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_purchase_authority"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'></a></td>
    </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
    <tr>
        <td class="color-row" width="200" valign="top"><cfinclude template="../display/list_purchase_authority.cfm"></td>
        <td class="color-row" valign="top">
            <cfform name="upd_purchase_authority" action="#request.self#?fuseaction=settings.emptypopup_upd_purchase_authority" method="post">
            <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
                <table>
                    <tr>
                        <td width="80"><cf_get_lang no="25.Durum Adı">*</td>    
                        <td>
                        <cfsavecontent variable="message"><cf_get_lang no ='1127.Mal Alımındaki Etkinliği Girmelisiniz'> !</cfsavecontent>
                        <cfinput type="text" maxlength="100" name="authority_name" style="width=175;" required="yes" message="#message#" value="#get_authority.authority_name#"></td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                        <td><textarea style="width:175;height:40;" name="detail" id="detail"><cfoutput>#get_authority.detail#</cfoutput></textarea></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                    </tr>
                    <tr>
                        <td colspan="3"><p><br/>
							<cfoutput>
								<cfif len(get_authority.record_emp)>
                               		<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_authority.record_emp,0,0)# - #dateformat(get_authority.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(get_authority.update_emp)>
                                	<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_authority.update_emp,0,0)# - #dateformat(get_authority.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </table>
            </cfform>
        </td>
    </tr>
</table>
