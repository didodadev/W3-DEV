<cfquery name="upd_quotes" datasource="#dsn#">
	UPDATE SALES_QUOTES_GROUP SET 
		QUOTE_YEAR = #attributes.QUOTE_YEAR#,
		QUOTE_TYPE = 2,
		QUOTE_DETAIL = '#attributes.QUOTE_DETAIL#',
		QUOTE_MONEY = '#attributes.MONEY#',
		PLANNER_EMP_ID = #attributes.employee_id#,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#CGI.REMOTE_ADDR#'
	WHERE
		SALES_QUOTE_ID = #attributes.SALES_QUOTE_ID#
</cfquery>

<cfquery name="del_quotes" datasource="#dsn#">
	DELETE FROM SALES_QUOTES_GROUP_ROWS WHERE SALES_QUOTE_ID = #attributes.SALES_QUOTE_ID#
</cfquery>
	<cfif len(attributes.team_ids)>
		<cfloop list="#attributes.team_ids#" index="k">
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
							TEAM_ID<!--- ,
							IMS_TEAM_ID --->
						)
						VALUES
						(
							#attributes.SALES_QUOTE_ID#,
							#attributes.branch_id#,
							#i#,
							#evaluate("attributes.team_#k#_#i#")#,
							'#attributes.money#',
							#k#
						)
				</cfquery>
			</cfloop>
		</cfloop>
	</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
