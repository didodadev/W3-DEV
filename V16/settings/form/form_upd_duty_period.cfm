<cfquery name="DUTY_PERIOD" datasource="#DSN#">
	SELECT 
    	PERIOD_ID, 
        PERIOD_NAME, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_DUTY_PERIOD 
    WHERE 
	    PERIOD_ID = #attributes.id#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td class="headbold"><cf_get_lang no='1666.Müşteri Nöbet Şeçenekleri'></td>
        <td width="80" align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_duty_period"><img src="/images/plus1.gif" border="0" alt=<cf_get_lang_main no='170.Ekle'>></a></td>
    </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
    <tr>
        <td class="color-row" width="200" valign="top"><cfinclude template="../display/list_duty_period.cfm"></td>
        <td class="color-row" valign="top">
            <cfform  name="add_perriod" action="#request.self#?fuseaction=settings.emptypopup_upd_duty_period" method="post">
            <input type="hidden" name="id" id="id" value="<cfoutput>#attributes.id#</cfoutput>">
                <table>
                    <tr>
                        <td width="80"><cf_get_lang no='1117.Nöbet Durumu'>*</td>    
                        <td>
                        <cfsavecontent variable="message"><cf_get_lang no ='1118.Nöbet Durumu Girmelisiniz'> !</cfsavecontent>
                        <cfinput type="text" maxlength="100" name="period_name" style="width=175;" required="yes" value="#DUTY_PERIOD.period_name#"></td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                        <td><textarea style="width:175;height:40;" name="detail" id="detail"><cfoutput>#DUTY_PERIOD.detail#</cfoutput></textarea></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                    </tr>
                    <tr>
                        <td colspan="3"><p><br/>
							<cfoutput>
								<cfif len(duty_period.record_emp)>
                                	<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(duty_period.record_emp,0,0)# - #dateformat(duty_period.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(duty_period.update_emp)>
                                	<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(duty_period.update_emp,0,0)# - #dateformat(duty_period.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </table>
            </cfform>
        </td>
    </tr>
</table>
