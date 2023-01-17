<cfquery name="GET_ASSET_P_CAT" datasource="#dsn#">
    SELECT ASSETP_CAT,ASSETP_CATID FROM ASSET_P_CAT ORDER BY ASSETP_CAT
</cfquery>
<cfquery name="ALL_ASSETP_SUB_CAT" datasource="#dsn#">
    SELECT ASSETP_SUB_CAT,ASSETP_SUB_CATID FROM ASSET_P_SUB_CAT ORDER BY ASSETP_SUB_CAT
</cfquery>		
<table>
    <cfif ALL_ASSETP_SUB_CAT.recordcount>
        <cfoutput query="ALL_ASSETP_SUB_CAT">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=#fusebox.circuit#.upd_assetp_sub_cat&sub_cat=#ASSETP_SUB_CATID#" class="tableyazi">#ASSETP_SUB_CAT#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</table>