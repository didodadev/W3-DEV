<cfquery name="GET_CUSTOMER_TYPES" datasource="#DSN#">
	SELECT 
    	CUSTOMER_TYPE_ID, 
        CUSTOMER_TYPE, 
        DETAIL, 
        IS_CONTROL, 
        CONTROL_RATE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_CUSTOMER_TYPE 
    ORDER BY 
    	CUSTOMER_TYPE
</cfquery>
<table cellpadding="0" cellspacing="0" border="0">
	<tr> 
    	<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='988.Tipler'></td>
	</tr>
	<cfif get_customer_types.recordcount>
        <cfoutput query="get_customer_types">
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="200"><a href="#request.self#?fuseaction=settings.upd_customer_type&id=#customer_type_id#" class="tableyazi">#customer_type#</a></td>
        </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
