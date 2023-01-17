<cfquery name="STOPPAGE_RATES" datasource="#dsn2#">
	SELECT 
        SSR.STOPPAGE_RATE_ID, 
        SSR.STOPPAGE_RATE, 
        SSR.STOPPAGE_ACCOUNT_CODE, 
        SSR.DETAIL, 
        SSR.SETUP_BANK_TYPE_ID,
        SBT.BANK_NAME,
        SSR.RECORD_IP, 
        SSR.RECORD_DATE, 
        SSR.RECORD_EMP, 
        SSR.UPDATE_DATE, 
        SSR.UPDATE_EMP, 
        SSR.UPDATE_IP  
    FROM 
        SETUP_STOPPAGE_RATES AS SSR
    LEFT JOIN #dsn_alias#.SETUP_BANK_TYPES AS SBT ON SSR.SETUP_BANK_TYPE_ID = SBT.BANK_CODE
</cfquery>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<cfif STOPPAGE_RATES.recordcount>
        <cfoutput query="STOPPAGE_RATES">
            <tr>
                <td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
                <td width="380"><a href="#request.self#?fuseaction=settings.form_upd_stoppage_rate&stoppage_rate_id=#STOPPAGE_RATE_ID#" class="tableyazi">#TLFormat(STOPPAGE_RATE)#</a> <cfif SETUP_BANK_TYPE_ID neq ''> ( #BANK_NAME# ) </cfif></td>
            </tr>
      </cfoutput>
    <cfelse>
        <tr>
            <td width="20" align="right" valign="baseline"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
        </tr>
    </cfif>
</table>

