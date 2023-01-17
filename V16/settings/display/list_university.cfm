<cfquery name="get_university" datasource="#dsn#">
	SELECT 
    	UNIVERSITY_ID, 
        UNIVERSITY_NAME, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE,
        UPDATE_EMP, 
        UPDATE_IP, 
        SCHOOL_TYPE 
    FROM 
	    SETUP_UNIVERSITY 
    ORDER BY 
    	UNIVERSITY_NAME
</cfquery>
<table cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='912.Üniversiteler'></td>
    </tr>
    <cfif get_university.recordcount>
		<cfoutput query="get_university">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif"></td>
                <td><a href="#request.self#?fuseaction=settings.form_upd_university&u_id=#university_id#" class="tableyazi">#university_name#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif"></td>
            <td><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>

