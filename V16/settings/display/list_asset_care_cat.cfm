<cfquery name="CARE_CATS" datasource="#DSN#">
	SELECT 
        ASSET_CARE_ID, 
        ASSET_CARE, 
        ASSETP_CAT, 
        DETAIL, 
        IS_YASAL, 
        RECORD_DATE,
        RECORD_EMP, 
        RECORD_IP,
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    ASSET_CARE_CAT 
    ORDER BY 
    	ASSET_CARE
</cfquery>	
<table width="200" cellpadding="0" cellspacing="0" border="0">

    <cfif care_cats.recordcount>
		<cfoutput query="CARE_CATS">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="200"><a href="#request.self#?fuseaction=settings.upd_asset_care_cat&asset_care_id=#asset_care_id#" >#asset_care#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="200"><font><cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
