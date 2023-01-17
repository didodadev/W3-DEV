<cfif isdefined('attributes.del_id')>
	<cflock timeout="60">
	  <cftransaction>
		<cfquery name="DEL_SCEN_EXPENSE_PERIOD" datasource="#DSN3#">
			DELETE FROM
				SCEN_EXPENSE_PERIOD
			WHERE
				PERIOD_ID = #attributes.id#
		</cfquery>
		<cfquery name="DEL_OLD_ROWS" datasource="#DSN3#">
			DELETE FROM
				SCEN_EXPENSE_PERIOD_ROWS
			WHERE
				PERIOD_ID = #attributes.id#
		</cfquery>
		<cf_add_log log_type="-1" action_id="#attributes.id#" action_name="#attributes.pageHead#" data_source="#dsn3#">
	  </cftransaction>
	</cflock>	
	<script type="text/javascript">
		location.href = document.referrer;
		<cfif not isdefined("attributes.draggable")>
			window.close();
		</cfif>
		wrk_opener_reload();		
	</script>
	<cfabort>
</cfif>
<cf_date tarih='attributes.startdate'>
<cflock timeout="60">
  <cftransaction>
	<cfquery name="UPD_SCEN_EXPENSE" datasource="#DSN3#">
		UPDATE
			SCEN_EXPENSE_PERIOD
		SET
			PERIOD_VALUE = #PERIOD_VALUE#,
			START_DATE = #attributes.startdate#,
			PERIOD_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DETAIL#">,
			PERIOD_CURRENCY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CURRENCY#">,
			PERIOD_TYPE = #PERIOD_TYPE#,
			PERIOD_REPITITION = <cfif len(REPITITION)>#REPITITION#<cfelse>NULL</cfif>,
			TYPE = #EXTYPE#,
			SCEN_EXPENSE_STATUS = <cfif isdefined("attributes.scen_expense_status")>1<cfelse>0</cfif>,
			SCENARIO_TYPE_ID=<cfif len(attributes.SCENARIO_TYPE)>#attributes.SCENARIO_TYPE#<cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_MEMBER = #session.ep.userid#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		WHERE
			PERIOD_ID = #attributes.id#		
	</cfquery>
	<cfquery name="DEL_OLD_ROWS" datasource="#dsn3#">
		DELETE FROM
			SCEN_EXPENSE_PERIOD_ROWS
		WHERE	
			PERIOD_ID=#attributes.ID#
	</cfquery>
	<cfswitch expression="#period_type#">
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
	<cfset sdate=date_add("d",0,attributes.startdate)>
	<cfloop from="1" to="#repitition#" index="i">
		<cfquery name="ADD_PERIOD_ROWS" datasource="#dsn3#">
			INSERT INTO
				SCEN_EXPENSE_PERIOD_ROWS
				(
					PERIOD_ID,
					START_DATE,
					PERIOD_VALUE,
					PERIOD_CURRENCY,
					TYPE,
					PERIOD_DETAIL,
					SCEN_EXPENSE_STATUS,
					SCENARIO_TYPE_ID,
					PROJECT_ID
				)
				VALUES
				(
					#attributes.ID#,
					#sdate#,
					#PERIOD_VALUE#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#CURRENCY#">,
					#EXTYPE#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#DETAIL#">,
					<cfif isdefined("attributes.scen_expense_status")>1,<cfelse>0,</cfif>
					<cfif len(attributes.SCENARIO_TYPE)>#attributes.SCENARIO_TYPE#<cfelse>NULL</cfif>,
					<cfif len(attributes.project_name)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#"><cfelse>NULL</cfif>
				)
		</cfquery>
		<cfset sdate=date_add(type,number,sdate)>
	</cfloop>
  </cftransaction>
</cflock>	
<script type="text/javascript">
	location.href = document.referrer;
	<cfif not isdefined("attributes.draggable")>
		window.close();
	</cfif>
</script>
