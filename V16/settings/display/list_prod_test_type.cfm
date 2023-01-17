<cfquery name="get_test_types" datasource="#dsn3#">
    SELECT 
        * 
    FROM 
        SETUP_PROD_TEST_TYPE
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang dictionary_id='42163.Test Tipleri'></td>
    </tr>
    <cfif get_test_types.recordcount>
		<cfoutput query="get_test_types">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="115"><a href="#request.self#?fuseaction=settings.upd_prod_test_type&id=#prod_test_type_id#" class="tableyazi">#PROD_TEST_TYPE#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>

