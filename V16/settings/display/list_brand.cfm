<cfquery name="GET_BRAND" datasource="#DSN#">
	SELECT 
    	BRAND_ID, 
        BRAND_NAME, 
        IT_ASSET, 
        MOTORIZED_VEHICLE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_BRAND 
    ORDER BY 
    	BRAND_NAME
</cfquery>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
    <cfif get_brand.recordcount>
		<cfoutput query="get_brand">
            <tr>
                <td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.upd_brand&brand_id=#brand_id#" class="tableyazi">#brand_name#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
