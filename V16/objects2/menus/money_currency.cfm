<cfquery name="GET_CURRENCY" datasource="#DSN#">
	SELECT
		SM.MONEY,
		SM.RECORD_DATE,
		<cfif isdefined("session.pp.userid")>
			RATEPP2 AS RATE2,
			RATEPP3 AS RATE3
		<cfelse>
			RATEWW2 AS RATE2,
			RATEWW3 AS RATE3
		</cfif>
	FROM
		SETUP_MONEY AS SM
	WHERE
		MONEY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.money#"> AND
		<cfif isdefined("session.pp.userid")>
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#"> AND
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#">
		<cfelse>
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#"> AND
			PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#">
		</cfif>
	ORDER BY
		SM.RECORD_DATE DESC
</cfquery>
<!--- background="../../objects2/image/borsa.gif" --->
<table border="0" cellpadding="0" cellspacing="0" align="center" style="width:100%;">
	<cfoutput query="get_currency">
		<tr style="height:18px;">
			<td class="txtbold" style="width:75px;">#get_currency.money#</td>
			<td  class="txtbold" style="text-align:right;">#TLFormat(rate2,4)#</td>
		</tr>
	</cfoutput>
</table>

