<cfquery name="PERF_PERIOD" datasource="#dsn#">
	SELECT 
	    * 
    FROM 
    	SETUP_PERF_PERIOD
</cfquery>
<table width="200" cellpadding="0" cellspacing="0" border="0">
    <tr valign="top"> 
        <td class="txtbold" height="20" colspan="2" valign="top" >&nbsp;&nbsp;<cf_get_lang no='186.Kayıtlı Performans Peryodu'></td>
    </tr>
    <cfif PERF_PERIOD.recordcount>
		<cfoutput query="PERF_PERIOD">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_perf_period&ID=#PERF_PERIOD_ID#" class="tableyazi">
                <cfif PERF_PERIOD IS 1><cf_get_lang_main no='1603.Yıllık'><cfelseif PERF_PERIOD IS 2>6 <cf_get_lang_main no='1520.Aylık'></cfif></a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="180" class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
        </tr>
    </cfif>
</table>

