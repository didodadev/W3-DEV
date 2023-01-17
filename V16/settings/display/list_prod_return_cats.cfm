<cfquery name="PROD_CATS" datasource="#dsn3#">
	SELECT 
	    RETURN_CAT_ID, 
        RETURN_CAT, 
        RECORD_EMP, 
        RECORD_IP, 
        RECORD_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        UPDATE_DATE 
    FROM 
    	SETUP_PROD_RETURN_CATS
</cfquery>		
<table width="200" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang dictionary_id='43185.Ürün İade Kategorisi'></td>
    </tr>
    <cfif PROD_CATS.recordcount>
		<cfoutput query="PROD_CATS">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_prod_return_cats&ID=#RETURN_CAT_ID#" class="tableyazi">#RETURN_CAT#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180"><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
