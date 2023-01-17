<cfquery name="GET_STUFF_DETAIL" datasource="#dsn#">
	SELECT 
    	STUFF_ID, 
        STUFF_NAME, 
        STUFF_DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_OFFICE_STUFF 
    WHERE 
    	STUFF_ID = #attributes.stuff_id#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
  <tr>
    <td align="left" class="headbold"><cf_get_lang no='917.Büro Yazılımları'></td>
  <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_office_stuff"><img src="/images/plus1.gif" border="0" align="absmiddle" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
  </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
    <tr class="color-row" valign="top">
        <td width="200"><cfinclude template="../display/list_office_stuff.cfm"></td>
        <td>
            <cfform name="upd_stuff" method="post" action="#request.self#?fuseaction=settings.emptypopup_office_stuff_upd">
            <input name="stuff_id" id="stuff_id" type="hidden" value="<cfoutput>#get_stuff_detail.stuff_id#</cfoutput>">
                <table>
                    <tr>
                        <td><cf_get_lang no='1146.Büro Yazılım Adı'>*</td>
                        <td><cfsavecontent variable="message"><cf_get_lang no='1144.Büro Yazılımı Girmelisiniz'> !</cfsavecontent>
                        <cfinput type="Text" name="stuff_name" style="width:200px;" value="#get_stuff_detail.stuff_name#" maxlength="50" required="Yes" message="#message#"></td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang no='1145.Büro Yazılım Detayı'></td>
                        <td><textarea name="stuff_detail" id="stuff_detail" style="width:200px;height:60"><cfoutput>#get_stuff_detail.stuff_detail#</cfoutput></textarea></td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                        <td height="35"><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                    </tr>
                    <tr>
                    <tr>
                        <td colspan="3"><p><br/>
							<cfoutput>
								<cfif len(get_stuff_detail.record_emp)>
                                	<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_stuff_detail.record_emp,0,0)# - #dateformat(get_stuff_detail.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(get_stuff_detail.update_emp)>
                                	<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_stuff_detail.update_emp,0,0)# - #dateformat(get_stuff_detail.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </table>
            </cfform>
        </td>
    </tr>
</table>
