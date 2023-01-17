<cfquery name="GET_ASSETP_CAT" datasource="#DSN#">
	SELECT 
    	ASSETP_CATID, 
        ASSETP_CAT, 
        ASSETP_RESERVE, 
        LIBRARY, 
        IT_ASSET, 
        MOTORIZED_VEHICLE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    ASSET_P_CAT 
    ORDER BY 
    	ASSETP_CAT
</cfquery>
<table>
    <cfif get_assetp_cat.recordcount>
    	<cfoutput query="get_assetp_cat">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=#fusebox.circuit#.upd_assetp_cat&id=#assetp_catid#" class="tableyazi">#assetp_cat#</a></td>
            </tr>
        </cfoutput>
        <cfelse>
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
            </tr>
    </cfif>
</table>
