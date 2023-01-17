<cfset a=0>
<cflock name="#CreateUUID()#" timeout="20">
  <cftransaction>
	<cfquery name="ADD_QUOTES" datasource="#dsn#" result="MAX_ID">
		INSERT INTO
			SALES_QUOTES_GROUP
		(
			SALES_ZONE_ID,
			QUOTE_YEAR,
			QUOTE_TYPE,
			QUOTE_DETAIL,
			QUOTE_MONEY,
			PLANNER_EMP_ID,
			TARGET_TYPE,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
		VALUES
		(
			#attributes.sales_zone_id#,
			#attributes.quote_year#,
			3,
			'#attributes.quote_detail#',
			'#attributes.money#',
			#attributes.employee_id#,
			#attributes.target_type#,
			#now()#,
			#session.ep.userid#,
			'#cgi.remote_addr#'
		)
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
				#MAX_ID.IDENTITYCOL#,
				#attributes.branch_id#,
				#i#,
				#evaluate("attributes.team_#Listgetat(attributes.team_ids,a)#_#k#_#i#")#,
				#evaluate("attributes.teammarket_#Listgetat(attributes.team_ids,a)#_#k#_#i#")#,
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
				#MAX_ID.IDENTITYCOL#,
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
