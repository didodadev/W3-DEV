<cfquery name="GET_TARGET_PERIODS" datasource="#DSN#">
	SELECT 
    	TARGET_PERIOD_ID, 
        TARGET_PERIOD, 
        COEFFICIENT, 
        DETAIL, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE,
        UPDATE_EMP,
        UPDATE_IP 
    FROM 
	    SETUP_TARGET_PERIOD 
    ORDER BY 
    	TARGET_PERIOD
</cfquery>
<table cellpadding="0" cellspacing="0" border="0">
	<tr> 
    	<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cf_get_lang no='216.Dönemler'></td>
	</tr>
	<cfif get_target_periods.recordcount>
        <cfoutput query="get_target_periods">
            <tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
                <td width="200"><a href="#request.self#?fuseaction=settings.upd_target_period&id=#target_period_id#" class="tableyazi">#target_period#</a></td>
            </tr>
        </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
            <td width="115"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>
