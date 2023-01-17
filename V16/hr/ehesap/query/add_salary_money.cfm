<cfinclude template="get_moneys.cfm">
<cftransaction>
	<cfoutput query="GET_MONEYS">
		<cfif IsDefined("attributes.MONEY_#MONEY#")>
			<cfquery name="ADD_SALARY_MONEY" datasource="#DSN#">
				DELETE FROM
					EMPLOYEES_SALARY_CHANGE
				WHERE	
					SALARY_YEAR=#attributes.salary_year# 
					AND SALARY_MONTH=#attributes.salary_month#
					AND MONEY='#Evaluate("attributes.money_#money#")#'
					AND COMPANY_ID = #session.ep.company_id#
			</cfquery>	
			<cfquery name="ADD_SALARY_MONEY" datasource="#DSN#">
			  INSERT INTO
				EMPLOYEES_SALARY_CHANGE
				(
					SALARY_YEAR,
					SALARY_MONTH,
					MONEY,
					WORTH,
					COMPANY_ID,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					ZONE_ID
				)
			  VALUES
				(
					#attributes.salary_year#,
					#attributes.salary_month#,
					'#Trim(Evaluate("attributes.money_#money#"))#',
					<cfif IsNumeric(Evaluate("attributes.worth_#money#"))>#Evaluate("attributes.worth_#money#")#<cfelse>NULL</cfif>,
					#session.ep.company_id#,
					#session.ep.userid#,
					'#cgi.remote_addr#',
					#now()#,
					<cfif isdefined('attributes.zone_id') and len(attributes.zone_id)>#attributes.zone_id#<cfelse>NULL</cfif>
				)
			</cfquery>	
		</cfif>
	</cfoutput>
</cftransaction>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
