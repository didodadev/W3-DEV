<cfquery name="get_bill_types" datasource="#dsn#">
	SELECT 
	    BILL_TYPE_ID, 
        BILL_TYPE, 
        DETAIL
    FROM 
    	BILL_TYPES
	ORDER BY
		BILL_TYPE
</cfquery>
<table cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;Fiş Belge Tipleri</td>
    </tr>
    <cfif get_bill_types.recordcount>
		<cfoutput query="get_bill_types">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td><a href="#request.self#?fuseaction=account.form_upd_bill_type&bill_type_id=#bill_type_id#" class="tableyazi">#bill_type#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
