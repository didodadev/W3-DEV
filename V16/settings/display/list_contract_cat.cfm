<cfquery name="CONTRACT_CATS" datasource="#DSN3#">
	SELECT 
    	CONTRACT_CAT_ID, 
        CONTRACT_CAT, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP 
    FROM 
    	CONTRACT_CAT 
    ORDER BY 
	    CONTRACT_CAT
</cfquery>
<table width="200" cellpadding="0" cellspacing="0" border="0">
	<tr>
    	<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='148.Anlaşma Kategorileri'></td>
  	</tr>
	<cfif contract_cats.recordcount>
      <cfoutput query="contract_cats">
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_contract_cat&contract_cat_id=#contract_cat_id#" class="tableyazi">#contract_cat#</a></td>
        </tr>
      </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
