<!--- <cfquery name="GET_ASSETP_CAT" datasource="#DSN#">
	SELECT * FROM SETUP_***_CAT ORDER BY ***_CAT
</cfquery> --->
<cfquery name="GET_MAIN_LOCATION_CAT" datasource="#DSN#">
	SELECT 
        MAIN_LOCATION_CAT_ID, 
        MAIN_LOCATION_CAT, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP,
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
	    SETUP_MAIN_LOCATION_CAT 
    ORDER BY 
    	MAIN_LOCATION_CAT
</cfquery>
<table cellpadding="0" cellspacing="0" border="0">
	<tr> 
    	<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang_main no='725.Kategoriler'></td>
	</tr>
	<cfif get_main_location_cat.recordcount>
        <cfoutput query="get_main_location_cat">
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="200"><a href="#request.self#?fuseaction=settings.upd_aaa&id=#assetp_catid#" class="tableyazi"><!--- settings.upd_assetp_cat&id=#assetp_catid# ---><!--- #***_cat##assetp_cat# ---></a></td>
        </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
