<cflock name="#CreateUUID()#" timeout="20">
  <cftransaction>
	<cfif len(attributes.sz_ids)>
		<cfloop list="#attributes.sz_ids#" index="k">
			<cfquery name="ADD_QUOTES" datasource="#dsn#" result="MAX_ID">
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
						#listfirst(k,",")#,
						#attributes.QUOTE_YEAR#,
						1,
						'#attributes.QUOTE_DETAIL#',
						'#attributes.MONEY#',
						#attributes.employee_id#,
						#now()#,
						#session.ep.userid#,
						'#CGI.REMOTE_ADDR#'
					)
			</cfquery>
			<cfloop from="1" to="12" index="i">
				<cfquery name="ADD_SALES_QUOTES_ROW" datasource="#dsn#">
					INSERT INTO
						SALES_QUOTES_GROUP_ROWS
						(
							SALES_QUOTE_ID,
							BRANCH_ID,
							QUOTE_MONTH,
							SALES_INCOME,
							ROW_MONEY
						)
						VALUES
						(
							#MAX_ID.IDENTITYCOL#,
							#Listlast(k,'.')#,
							#i#,
							#evaluate("attributes.team_#ListFirst(k,'.')#_#i#")#,
							'#attributes.money#'
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
