<cfquery name="ASSETP_GROUP" datasource="#dsn#">
	SELECT 
    	GROUP_ID, 
        GROUP_NAME, 
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
	    SETUP_ASSETP_GROUP 
    ORDER BY 
    	GROUP_NAME
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td class="txtbold" height="20" colspan="2"><cf_get_lang no='876.Fiziki Varlık Grupları'></td>
    </tr>
	<cfif assetp_group.recordCount>
		<cfoutput query="ASSETP_GROUP">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif"></td>
                <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_assetp_group&assetp_group_id=#GROUP_ID#" class="tableyazi">#group_name#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
