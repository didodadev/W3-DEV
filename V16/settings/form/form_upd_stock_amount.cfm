<cfquery name="GET_STOCK" datasource="#DSN#">
	SELECT 
    	STOCK_ID, 
        STOCK_NAME, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_STOCK_AMOUNT 
    WHERE 
    	STOCK_ID = #attributes.stock_id# ORDER BY STOCK_ID
</cfquery>
<table border="0" cellspacing="0" cellpadding="0" width="98%" align="center" height="35">
	<tr>
    	<td class="headbold"><cf_get_lang no="1113.Stok ve Raf Durumu Şeçenekleri"></td>
		<td width="80" align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_stock_amount"><img src="/images/plus1.gif" border="0" alt="<cf_get_lang_main no='170.Ekle'>"></a></td>
	</tr>
</table>
<table border="0" cellspacing="1" cellpadding="2" width="98%" class="color-border" align="center">
	<tr>
		<td class="color-row" width="200" valign="top"><cfinclude template="../display/list_stock_amount.cfm"></td>
		<td class="color-row" valign="top">
            <cfform name="add_stock" action="#request.self#?fuseaction=settings.emptypopup_upd_stock_amount" method="post">
            <input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#attributes.stock_id#</cfoutput>">
                <table>
                    <tr>
                        <td width="150"><cf_get_lang no='57.Stok ve Raf Durumu'>*</td>    
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang no='1115.Stok ve Raf Durumu Girmelisiniz'>!</cfsavecontent>
                            <cfinput type="text" maxlength="100" name="stock_name" value="#get_stock.stock_name#" style="width=175;" required="yes" message="#message#">
                        </td>
                    </tr>
                    <tr>
                        <td valign="top"><cf_get_lang_main no='217.Açıklama'></td>
                        <td><textarea style="width:175;height:40;" name="detail" id="detail"><cfoutput>#get_stock.detail#</cfoutput></textarea></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td><cf_workcube_buttons is_upd='1' is_delete='0'></td>
                    </tr>
                    <tr>
                        <td colspan="3"><p><br/>
                            <cfoutput>
                            <cfif len(get_stock.record_emp)>
                                <cf_get_lang_main no='71.Kayıt'> : #get_emp_info(get_stock.record_emp,0,0)# - #dateformat(get_stock.record_date,dateformat_style)#
                            </cfif><br/>
                            <cfif len(get_stock.update_emp)>
                                <cf_get_lang_main no='291.Son Güncelleme'> : #get_emp_info(get_stock.update_emp,0,0)# - #dateformat(get_stock.update_date,dateformat_style)#
                            </cfif>
                            </cfoutput>
                        </td>
                    </tr>
                </table>
            </cfform>
		</td>
	</tr>
</table>
