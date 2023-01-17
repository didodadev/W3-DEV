<cfquery name="GET_CONTRACT_CAT_ID" datasource="#DSN3#" maxrows="1">
	SELECT CONTRACT_CAT_ID FROM RELATED_CONTRACT WHERE CONTRACT_CAT_ID = #attributes.contract_cat_id#
</cfquery>
<cfquery name="CONTRACT_CAT" datasource="#DSN3#">
	SELECT 
	    CONTRACT_CAT_ID, 
        CONTRACT_CAT, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP 
    FROM 
    	CONTRACT_CAT 
    WHERE 
	    CONTRACT_CAT_ID = #attributes.contract_cat_id#
</cfquery>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
	<tr>
    	<td class="headbold"><cf_get_lang no='603.Anlaşma Kategorisi Güncelle'></td>
		<td align="right" style="text-align:right;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=settings.form_add_contract_cat"><img src="/images/plus1.gif" border="0" align="absmiddle" alt="<cf_get_lang no='343.Anlaşma Kategorisi Ekle'>"></a></td>
	</tr>
</table>
<table width="98%" border="0" align="center" cellpadding="2" cellspacing="1" class="color-border">
	<tr class="color-row">
  		<td width="200" valign="top"><cfinclude template="../display/list_contract_cat.cfm"></td>
 		<td valign="top">
            <table border="0">
                <cfform name="contract_cat" method="post" action="#request.self#?fuseaction=settings.emptypopup_contract_cat_upd">
                <input type="hidden" name="contract_cat_id" id="contract_cat_id" value="<cfoutput>#url.contract_cat_id#</cfoutput>">
                    <tr>
                        <td width="100"><cf_get_lang_main no='68.Başlık'>*</td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık girmelisiniz'></cfsavecontent>
                            <cfinput type="text" name="contract_cat" value="#contract_cat.contract_cat#" maxlength="50" required="Yes" message="#message#" style="width:150px;">
                        </td>
                    </tr>
        
                    <tr height="35">
                        <td></td>
                        <td colspan="2">
                            <cfif get_contract_cat_id.recordcount>
                                <cf_workcube_buttons is_upd='1' is_delete='0'>
                            <cfelse>
                                <cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_contract_cat_del&contract_cat_id=#url.contract_cat_id#'>
                            </cfif>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <cf_get_lang_main no='71.Kayıt'> :
                            <cfoutput>
                                <cfif len(contract_cat.record_emp)>#get_emp_info(contract_cat.record_emp,0,0)#</cfif>
                                <cfif len(contract_cat.record_date)>#dateformat(contract_cat.record_date,dateformat_style)#</cfif>
                            </cfoutput>
                        </td>
                    </tr>			
                </cfform>
            </table>
  		</td>
	</tr>
</table>
