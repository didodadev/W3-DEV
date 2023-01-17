<cfquery name="MONEYCATEGORIES" datasource="#dsn#">
	SELECT 
    	MONEY_ID, 
        MONEY, 
        RATE1, 
        RATE2, 
        MONEY_STATUS, 
        PERIOD_ID, 
        COMPANY_ID, 
        ACCOUNT_950, 
        PER_ACCOUNT, 
        RATE3, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        RATEPP2, 
        RATEPP3, 
        RATEWW2, 
        RATEWW3, 
        CURRENCY_CODE, 
        DSP_RATE_SALE, 
        DSP_RATE_PUR, 
        DSP_UPDATE_DATE, 
        EFFECTIVE_SALE, 
        EFFECTIVE_PUR, 
        MONEY_NAME, 
        MONEY_SYMBOL 
    FROM 
    	SETUP_MONEY
	WHERE 
	    PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.PERIOD_ID#"> AND MONEY_STATUS=1 
</cfquery>
<table>
	<cfif moneyCategories.recordcount>
		<cfoutput query="moneyCategories">
		<tr>
            <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
			<td width="380"><a href="#request.self#?fuseaction=settings.form_upd_money&ID=#money_ID#" class="tableyazi">#money#</a></td>
		</tr>
		</cfoutput>
	<cfelse>
		<tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
		</tr>
	</cfif>
</table>

