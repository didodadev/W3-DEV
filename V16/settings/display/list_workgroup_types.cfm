<cfquery name="WORKGROUP_TYPES" datasource="#dsn#">
	SELECT
       *
	FROM
		SETUP_WORKGROUP_TYPE
	ORDER BY
		WORKGROUP_TYPE_NAME
</cfquery>
<table width="200" border="0" cellpadding="0" cellspacing="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='965.İş Grubu Tipleri'></td>
    </tr>
    <cfif WORKGROUP_TYPES.recordcount>
		<cfoutput query="WORKGROUP_TYPES">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_workgroup_type&WORKGROUP_TYPE_ID=#WORKGROUP_TYPE_ID#" class="tableyazi">#WORKGROUP_TYPE_NAME#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180" valign="baseline"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>

