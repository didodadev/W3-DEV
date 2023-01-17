<cfinclude template="../query/get_probability_rate.cfm">
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td align="left" class="headbold"><cf_get_lang no ='437.Olasılık Oranı Güncelle'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_probability_rate"><img border="0" align="absmiddle" src="/images/plus1.gif" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
    </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
    <tr class="color-row" valign="top">
        <td width="200"><cfinclude template="../display/list_probability_rate.cfm"></td>
        <td>
            <table border="0">
            <cfquery name="get_probability_rates" datasource="#DSN3#">
            	SELECT 
                    PROBABILITY_RATE_ID, 
                    PROBABILITY_RATE, 
                    PROBABILITY_NAME,
                    RECORD_EMP, 
                    RECORD_DATE, 
                    RECORD_IP, 
                    UPDATE_EMP, 
                    UPDATE_DATE, 
                    UPDATE_IP 
                FROM 
    	            SETUP_PROBABILITY_RATE 
                WHERE 
	                PROBABILITY_RATE_ID = #attributes.probability_rate_id#
            </cfquery>
                <cfform name="upd_probability_rate" method="post" action="#request.self#?fuseaction=settings.emptypopup_probability_rate_upd">
                <input type="hidden" name="probability_rate_id" id="probability_rate_id" value="<cfoutput>#probability_rate_id#</cfoutput>">
                    <tr>
                        <td><cf_get_lang_main no ='1408.Başlık'> *</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="PROBABILITY_NAME" value="#get_probability_rates.probability_name#" required="yes" message="#message#" style="width:150px;" maxlength="50"> 
                        </td>
                    </tr>
                    <tr>
                        <td width="100"><cf_get_lang no ='435.Değer'> *</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no ='1177.Değer Girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="probability_rate" value="#get_probability_rates.probability_rate#" required="Yes" message="#message#" maxlength="20" style="width:150px;">
                        </td>
                    </tr>
                    <tr height="35">
                        <td></td>
                        <td>
                        	<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_probability_rate_del&probability_rate_id=#probability_rate_id#'>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" align="left"><p><br/>
							<cfoutput>
								<cfif len(get_probability_rates.record_emp)>
                                	<cf_get_lang_main no='71.Kayit'> : #get_emp_info(get_probability_rates.record_emp,0,0)# - #dateformat(get_probability_rates.record_date,dateformat_style)#
                                </cfif>
                                <cfif len(get_probability_rates.update_emp)>
                                	<br/><cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_probability_rates.update_emp,0,0)# - #dateformat(get_probability_rates.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>
