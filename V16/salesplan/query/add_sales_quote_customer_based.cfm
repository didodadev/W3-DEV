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
				5,
				'#attributes.QUOTE_DETAIL#',
				'#attributes.MONEY#',
				#attributes.employee_id#,
				#now()#,
				#session.ep.userid#,
				'#CGI.REMOTE_ADDR#'
			)
	</cfquery>
	<cfif len(attributes.customer_ids) and len(attributes.team_ids)>
		<cfloop list="#attributes.customer_ids#" index="k">
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
							CUSTOMER_COMP_ID,
							CUSTOMER_TEAM_ID
						)
						VALUES
						(
							#MAX_ID.IDENTITYCOL#,
							#attributes.branch_id#,
							#i#,
							#evaluate("attributes.team_#attributes.team_ids#_#k#_#i#")#,
							'#attributes.money#',
							#k#,
							#attributes.team_ids#
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
