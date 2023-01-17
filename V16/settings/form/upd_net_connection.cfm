<cfquery name="GET_NET_CONN" datasource="#DSN#">
	SELECT 
    	CONNECTION_ID, 
        CONNECTION_NAME, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_NET_CONNECTION 
    WHERE 
	    CONNECTION_ID = #attributes.id#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td class="headbold"><cf_get_lang no='1670.Internet Bağlantı Seçeneklerini Güncelle'></td>
        <td width="80" align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_net_connection"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
    </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
    <tr>
        <td class="color-row" width="200" valign="top"><cfinclude template="../display/list_net_connection.cfm"></td>
        <td class="color-row" valign="top">
            <cfform  name="add_connection" action="#request.self#?fuseaction=settings.emptypopup_upd_net_connection" method="post">
            <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
                <table>
                    <tr>
                        <td width="80"><cf_get_lang no='1671.Bağlantı Adı'>*</td>    
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang no='1177.Bağlantı Adı Girmelisiniz'>!</cfsavecontent>
                            <cfsavecontent variable="message"><cf_get_lang no='2645.Lütfen Görev Tipi Giriniz'></cfsavecontent>
                            <cfinput type="text" maxlength="100" name="connection_name" style="width=175;" required="yes" message="#message#" value="#get_net_conn.connection_name#">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                        <td><textarea style="width:175;height:40;" name="detail" id="detail"><cfoutput>#get_net_conn.detail#</cfoutput></textarea></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                    </tr>
                    <tr>
                        <td colspan="3"><p><br/>
							<cfoutput>
								<cfif len(get_net_conn.record_emp)>
                                	<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_net_conn.record_emp,0,0)# - #dateformat(get_net_conn.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(get_net_conn.update_emp)>
                                	<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_net_conn.update_emp,0,0)# - #dateformat(get_net_conn.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </table>
            </cfform>
        </td>
    </tr>
</table>
