<cfset a=0>
<cflock name="#CreateUUID()#" timeout="20">
  <cftransaction>
	<cfquery name="add_quotes" datasource="#dsn#" result="MAX_ID">
		INSERT INTO SALES_QUOTES_GROUP
			(
				SALES_ZONE_ID,
				QUOTE_YEAR,
				QUOTE_TYPE,
				QUOTE_DETAIL,
				QUOTE_MONEY,
				PLANNER_EMP_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				#attributes.SALES_ZONE_ID#,
				#attributes.QUOTE_YEAR#,
				4,
				'#attributes.QUOTE_DETAIL#',
				'#attributes.MONEY#',
				#attributes.employee_id#,
				#now()#,
				#session.ep.userid#,
				'#CGI.REMOTE_ADDR#'
			)
	</cfquery>
	<cfif len(attributes.position_codes) and len(attributes.team_ids)>
		<cfloop list="#attributes.position_codes#" index="k">
			<cfset a=a+1>
			<cfloop from="1" to="12" index="i">
				<cfquery name="ADD_SALES_QUOTES_ROW" datasource="#dsn#">
					INSERT INTO
						SALES_QUOTES_GROUP_ROWS
						(
							SALES_QUOTE_ID,
							BRANCH_ID,
							QUOTE_MONTH,
							SALES_INCOME,
							ROW_MONEY,
							POSITION_CODE,
							EMPLOYEE_TEAM_ID
						)
						VALUES
						(
							#MAX_ID.IDENTITYCOL#,
							#attributes.branch_id#,
							#i#,
							#evaluate("attributes.team_#Listgetat(attributes.team_ids,a)#_#k#_#i#")#,
							'#attributes.money#',
							#Listgetat(attributes.position_codes,a)#,
							#Listgetat(attributes.team_ids,a)#
						)
				</cfquery>
			</cfloop>
		</cfloop>
	</cfif>
</cftransaction>
</cflock>	
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
