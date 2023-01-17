<cfset wrk_id = dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')&'_#session.ep.userid#_'&round(rand()*100)>
<cflock timeout="60">
	<cftransaction>
		<cfloop from="1" to="#attributes.record_num#" index="i">
			<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#") eq 1>
				<cfset period_value_ = filterNum(evaluate('attributes.period_value_#i#'))>
				<cfset detail_ = evaluate('attributes.detail_#i#')>
				<cfset currency_ = evaluate('attributes.currency_#i#')>
				<cfset period_type_ = evaluate('attributes.period_type_#i#')>
				<cfset repitition = evaluate('attributes.repitition#i#')>
				<cfset extype_ = evaluate('attributes.extype_#i#')>
				<cfset scenario_type_ = evaluate('attributes.scenario_type_#i#')>
				<cfset exp_date_ = evaluate("attributes.expense_date#i#")>
				<cfset project_id = evaluate("attributes.project_id#i#")>
				<cfset project_name = evaluate("attributes.project_name#i#")>
				<cf_date tarih='exp_date_'>
				<cfquery name="ADD_SCEN_EXPENSE" datasource="#DSN3#">
					INSERT INTO
						SCEN_EXPENSE_PERIOD
					(
						PERIOD_VALUE,
						START_DATE,
						PERIOD_DETAIL,
						PERIOD_CURRENCY,
						PERIOD_TYPE,
						PERIOD_REPITITION,
						RECORD_DATE,
						RECORD_MEMBER,
						RECORD_IP,
						TYPE,
						SCENARIO_TYPE_ID,
						SCEN_EXPENSE_STATUS
					)
					VALUES
					(
						
						#period_value_#,
						#exp_date_#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#detail_#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#currency_#">,
						#period_type_#,
						#repitition#,
						#NOW()#,
						#SESSION.EP.USERID#,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
						#extype_#,
						#scenario_type_#,
						1
					)
				</cfquery>
				<cfquery name="GET_LAST_RECORD" datasource="#DSN3#">
					SELECT MAX(PERIOD_ID) PERIOD_ID FROM SCEN_EXPENSE_PERIOD	
				</cfquery>
				<cfswitch expression="#period_type_#">
					<cfcase value="1">
						<cfset type="ww">
						<cfset number=1>
					</cfcase>
					<cfcase value="2">
						<cfset type="m">
						<cfset number=1>
					</cfcase>
					<cfcase value="6">
						<cfset type="m">
						<cfset number=2>
					</cfcase>
					<cfcase value="3">
						<cfset type="q">
						<cfset number=1>
					</cfcase>
					<cfcase value="4">
						<cfset type="m">
						<cfset number=6>
					</cfcase>
					<cfcase value="5">
						<cfset type="yyyy">
						<cfset number=1>
					</cfcase>
				</cfswitch>
				<cfset new_startdate="">
				<cfset attributes.startdate_ = evaluate("attributes.expense_date#i#")>
				<cf_date tarih='attributes.startdate_'>
				<cfset new_startdate = attributes.startdate_>
				<cfloop from="1" to="#repitition#" index="j">
					<cfset period_value_ = filterNum(evaluate('attributes.period_value_#i#'))>
					<cfset detail_ = evaluate('attributes.detail_#i#')>
					<cfset currency_ = evaluate('attributes.currency_#i#')>
					<cfset period_type_ = evaluate('attributes.period_type_#i#')>
					<cfset repitition = evaluate('attributes.repitition#i#')>
					<cfset extype_ = evaluate('attributes.extype_#i#')>
					<cfset scenario_type_ = evaluate('attributes.scenario_type_#i#')>
					<cfquery name="ADD_PERIOD_ROWS" datasource="#DSN3#">
						INSERT INTO
							SCEN_EXPENSE_PERIOD_ROWS
						(
							PERIOD_ID,
							START_DATE,
							PERIOD_VALUE,
							PERIOD_CURRENCY,
							TYPE,
							PERIOD_DETAIL,
							SCENARIO_TYPE_ID,
							SCEN_EXPENSE_STATUS,
							PROJECT_ID
						)
						VALUES
						(
							#GET_LAST_RECORD.PERIOD_ID#,
							#new_startdate#,
							#period_value_#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#currency_#">,
							#extype_#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#detail_#">,
							#scenario_type_#,
							1,
							<cfif len(project_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#"><cfelse>NULL</cfif>
						)
					</cfquery>
					<cfset new_startdate=date_add(type,number,new_startdate)>
				</cfloop>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>
<cflocation url="#request.self#?fuseaction=finance.list_scen_expense" addtoken="no">
