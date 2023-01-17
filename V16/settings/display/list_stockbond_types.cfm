<cfquery name="STOCKBOND_TYPES" datasource="#dsn#">
	SELECT 
	    STOCKBOND_TYPE_ID, 
        STOCKBOND_TYPE, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE,
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	SETUP_STOCKBOND_TYPE
</cfquery>
<table width="135" cellpadding="0" cellspacing="0" border="0">
    <tr> 
        <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='1473.Menkul Kıymet Tipleri'></td>
    </tr>
    <cfif STOCKBOND_TYPES.recordcount>
		<cfoutput query="STOCKBOND_TYPES">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="115"><a href="#request.self#?fuseaction=settings.form_upd_stockbond_type&stockbond_type_id=#STOCKBOND_TYPE_ID#" class="tableyazi">#STOCKBOND_TYPE#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
