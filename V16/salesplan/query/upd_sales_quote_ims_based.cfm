<cfset a=0>
<cflock name="#CreateUUID()#" timeout="20">
  <cftransaction>
	<cfquery name="UPD_QUOTES" datasource="#DSN#">
		UPDATE
			SALES_QUOTES_GROUP
		SET 
			QUOTE_YEAR = #attributes.quote_year#,
			QUOTE_TYPE = 3,
			QUOTE_DETAIL = '#attributes.quote_detail#',
			QUOTE_MONEY = '#attributes.money#',
			PLANNER_EMP_ID = #attributes.employee_id#,
			TARGET_TYPE = #attributes.target_type#,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.remote_addr#'
		WHERE
			SALES_QUOTE_ID = #attributes.sales_quote_id#
	</cfquery>
	
	<cfquery name="DEL_QUOTES_ROW" datasource="#DSN#">
		DELETE FROM
			SALES_QUOTES_GROUP_ROWS
		WHERE
			SALES_QUOTE_ID = #attributes.sales_quote_id#
	</cfquery>
	
	<cfif len(attributes.ims_ids) and len(attributes.team_ids)>
	  <cfloop list="#attributes.ims_ids#" index="k">
		<cfset a=a+1>
		<cfloop from="1" to="12" index="i">
		  <cfquery name="ADD_SALES_QUOTES_ROW" datasource="#DSN#">
				INSERT INTO
					SALES_QUOTES_GROUP_ROWS
				(
					SALES_QUOTE_ID,
					BRANCH_ID,
					QUOTE_MONTH,
					SALES_INCOME,
					TOTAL_MARKET,
					ROW_MONEY,
					IMS_ID,
					IMS_CODE,
					IMS_TEAM_ID
				)
				VALUES
				(
					#attributes.sales_quote_id#,
					#attributes.branch_id#,
					#i#,
					#evaluate("attributes.team_#listgetat(attributes.team_ids,a)#_#k#_#i#")#,
					#evaluate("attributes.teammarket_#listgetat(attributes.team_ids,a)#_#k#_#i#")#,
					'#attributes.money#',
					#k#,
					'#Listgetat(attributes.ims_codes,a)#',
					#Listgetat(attributes.team_ids,a)#
				)
		  </cfquery>
		</cfloop>
	  </cfloop>
	</cfif>
	<cfloop from="1" to="12" index="i">
		<cfquery name="ADD_SALES_QUOTES_ROW" datasource="#DSN#">
			INSERT INTO
				SALES_QUOTES_GROUP_ROWS
			(
				SALES_QUOTE_ID,
				BRANCH_ID,
				QUOTE_MONTH,
				SALES_INCOME,
				TOTAL_MARKET,
				ROW_MONEY,
				IMS_ID,
				IMS_CODE,
				IMS_TEAM_ID
			)
			VALUES
			(
				#attributes.sales_quote_id#,
				#attributes.branch_id#,
				#i#,
				#evaluate("attributes.team_#attributes.ims_team_id#_YY_#i#")#,
				#evaluate("attributes.teammarket_#attributes.ims_team_id#_YY_#i#")#,
				'#attributes.money#',
				NULL,
				NULL,
				#attributes.ims_team_id#		
			)
		</cfquery>
	</cfloop>
  </cftransaction>
</cflock>	
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
