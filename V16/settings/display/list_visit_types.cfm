<cfquery name="GET_VISIT_TYPES" datasource="#dsn#">
	SELECT 
    	VISIT_TYPE_ID, 
        VISIT_TYPE, 
        DETAIL, 
        RECORD_IP, 
        RECORD_DATE, 
        RECORD_EMP, 
        UPDATE_IP, 
        UPDATE_DATE, 
        UPDATE_EMP 
    FROM 
	    SETUP_VISIT_TYPES
</cfquery>
<table width="200" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='932.Ziyaret Nedenleri'></td>
    </tr>
	<cfif get_visit_types.recordcount>
        <cfoutput query="get_visit_types">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_visit_types&visit_type_id=#visit_type_id#" class="tableyazi">#visit_type#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180" align="left"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
