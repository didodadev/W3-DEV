<cfquery name="GET_CUSTOMER_POSITIONS" datasource="#DSN#">
	SELECT 
    	POSITION_ID, 
        POSITION_NAME, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_CUSTOMER_POSITION 
    WHERE 
	    POSITION_ID = #attributes.id#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td class="headbold"><cf_get_lang no='1119.Müşteri Genel Konumları'></td>
        <td width="80" align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_customer_position"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
    </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
    <tr>
        <td class="color-row" width="200" valign="top"><cfinclude template="../display/list_customer_position.cfm"></td>
        <td class="color-row" valign="top">
            <cfform  name="add_connection" action="#request.self#?fuseaction=settings.emptypopup_upd_customer_position" method="post">
            <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
                <table>
                    <tr>
                        <td width="80"><cf_get_lang no='1120.Konum Adı '>*</td>    
                        <td>
                        <cfsavecontent variable="message"><cf_get_lang no='1121.Konum Adı Girmelisiniz '>!</cfsavecontent>
                        <cfinput type="text" maxlength="100" name="position_name" style="width=175;" required="yes" message="#message#"value="#get_customer_positions.position_name#"></td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                        <td><textarea style="width:175;height:40;" name="detail" id="detail"><cfoutput>#get_customer_positions.detail#</cfoutput></textarea></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                    </tr>
                    <tr>
                        <td colspan="3"><p><br/>
							<cfoutput>
								<cfif len(get_customer_position.record_emp)>
                                    <cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_customer_position.record_emp,0,0)# - #dateformat(get_customer_position.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(get_customer_position.update_emp)>
                                    <cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_customer_position.update_emp,0,0)# - #dateformat(get_customer_position.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </table>
            </cfform>
        </td>
    </tr>
</table>
<script type="text/javascript">
	function chk_form()
	{
		if(add_connection.position_name.value=="")
		{
			alert("<cf_get_lang no ='1121.Konum Adı Girmelisiniz'>!..");
			return false;
		}
	}
</script>

