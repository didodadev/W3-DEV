<cfquery name="GET_QUALITY_CONTROL_ROW" datasource="#dsn3#">
    SELECT 
        QUALITY_CONTROL_ROW_ID, 
        QUALITY_CONTROL_ROW, 
        QUALITY_CONTROL_TYPE_ID, 
        QUALITY_VALUE, 
        TOLERANCE, 
        RECORD_DATE, 
        RECORD_IP, 
        RECORD_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        UPDATE_EMP 
    FROM 
        QUALITY_CONTROL_ROW 
    ORDER BY 
        QUALITY_CONTROL_ROW
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
	<cfif get_quality_control_row.recordcount>
		<cfoutput query="get_quality_control_row">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_quality_type_variation&quality_control_row_id=#QUALITY_CONTROL_ROW_ID#" class="tableyazi">#QUALITY_CONTROL_ROW#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</font></td>
        </tr>
    </cfif>
</table>

