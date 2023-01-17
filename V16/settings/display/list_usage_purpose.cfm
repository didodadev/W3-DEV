<cfquery name="USAGE_PURPOSE" datasource="#dsn#">
	SELECT 
    	USAGE_PURPOSE_ID, 
        USAGE_PURPOSE, 
        DETAIL, 
        ASSETP_RESERVE, 
        IT_ASSET, 
        MOTORIZED_VEHICLE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE,
        UPDATE_EMP, 
        UPDATE_IP 
    FROM
    	SETUP_USAGE_PURPOSE 
    ORDER BY
	    USAGE_PURPOSE
</cfquery>
<table>
    <cfif usage_purpose.recordcount>
		<cfoutput query="USAGE_PURPOSE">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.form_upd_usage_purpose&usage_purpose_id=#USAGE_PURPOSE_ID#">#usage_purpose#</a></td>
            </tr>
		</cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</table>

