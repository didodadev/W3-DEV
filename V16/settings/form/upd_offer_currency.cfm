<cfquery name="GET_OFFER_CURRENCY" datasource="#DSN3#" maxrows="1">
	SELECT
		OFFER_CURRENCY
	FROM
		OFFER
	WHERE
		OFFER_CURRENCY=#URL.ID#
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
    <tr>
        <td class="headbold"><cf_get_lang no='631.Teklif Durumu Güncelle'></td>
        <td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_offer_currency"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
    </tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="100%" class="color-border" align="center">
    <tr valign="top" class="color-row">
        <td width="200"><cfinclude template="../display/list_offer_currency.cfm"></td>
        <td>
            <table border="0">
                <cfform action="#request.self#?fuseaction=settings.emptypopup_offer_currency_upd" method="post" name="offer">
                <input type="Hidden" ID="clicked" name="clicked" value="">
                <cfquery name="CATEGORY" datasource="#dsn3#">
                	SELECT 
        	            OFFER_CURRENCY_ID, 
                        OFFER_CURRENCY, 
                        RECORD_EMP, 
                        RECORD_DATE, 
                        RECORD_IP, 
                        UPDATE_EMP, 
                        UPDATE_DATE, 
                        UPDATE_IP 
                    FROM 
    	                OFFER_CURRENCY 
                    WHERE 
	                    OFFER_CURRENCY_ID=#URL.ID#
                </cfquery>
                <input type="Hidden" name="offer_currency_ID" id="offer_currency_ID" value="<cfoutput>#URL.ID#</cfoutput>">
                    <tr>
                        <td width="100"><cf_get_lang_main no='68.Başlık'>*</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
                            <cfinput type="Text" name="offer_currency" style="width:150px;" value="#category.offer_currency#" maxlength="20" required="Yes" message="#message#">
                        </td>
                    </tr>
                    <tr height="35">
                        <td colspan="2" align="right" style="text-align:right;">
							<cfif get_offer_currency.recordcount>
                            	<cf_workcube_buttons is_upd='1' is_delete='0'>
                            <cfelse>
								<cfif attributes.id>
                                    <cf_workcube_buttons is_upd='1' is_delete='0'>
                                <cfelse>
                                    <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_offer_currency_del&offer_currency_id=#URL.ID#'>
                                </cfif>
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3" align="left"><p><br/>
							<cfoutput>
								<cfif len(category.record_emp)>
                                	<cf_get_lang_main no='71.Kayıt'> : #get_emp_info(category.record_emp,0,0)# - #dateformat(category.record_date,dateformat_style)#
                                </cfif><br/>
                                <cfif len(category.update_emp)>
                                	<cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(category.update_emp,0,0)# - #dateformat(category.update_date,dateformat_style)#
                                </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </cfform>
            </table>
        </td>
    </tr>
</table>
