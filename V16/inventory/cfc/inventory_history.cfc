<!--- demirbasa ait history kaydi islemleri yapilir --->
<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
	<cfif isdefined('session.ep')>
		<cfset dsn3 = '#dsn#_#session.ep.company_id#'>
		<cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
	</cfif>
	<cfset dsn3_alias= '#dsn3#'>
	<!--- ADD HISTORY --->
	<cffunction name="add_inventory_history" access="public" returntype="string">	
		<cfargument name="inventory_id" type="numeric" required="yes">
		<cfargument name="action_id" type="any" required="no" default="">
		<cfargument name="action_type" type="any" required="no" default="">
		<cfargument name="action_date" type="any" required="no" default="">
		<cfargument name="project_id" type="any" required="no" default="">
		<cfargument name="expense_center_id" type="any" required="no" default="">
		<cfargument name="expense_item_id" type="any" required="no" default="">
		<cfargument name="claim_account_code" type="string" required="no" default="">
		<cfargument name="debt_account_code" type="string" required="no" default="">
		<cfargument name="account_code" type="string" required="no" default="">
		<cfargument name="inventory_duration" type="any" required="no" default="">
		<cfargument name="inventory_duration_ifrs" type="any" required="no" default="">
		<cfargument name="amortization_rate" type="any" required="no" default="">
		<cfargument name="ifrs_inventory_duration" type="any" required="no" default="">
		<cfargument name="activity_id" type="any" required="no" default="">
	
		<cfquery name="add_inventory_history" datasource="#DSN2#">
			INSERT INTO
				#dsn3_alias#.INVENTORY_HISTORY
				(
					INVENTORY_ID,
					ACTION_ID,
					ACTION_TYPE,
					ACTION_DATE,
					PROJECT_ID,
					EXPENSE_CENTER_ID,
					EXPENSE_ITEM_ID,
					CLAIM_ACCOUNT_CODE,
					DEBT_ACCOUNT_CODE,
					ACCOUNT_CODE,
					INVENTORY_DURATION,
					AMORTIZATION_RATE,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE,
					INVENTORY_DURATION_IFRS,
					ACTIVITY_ID
				)
				VALUES
				(
					#arguments.inventory_id#,
					<cfif len(arguments.action_id)>#arguments.action_id#<cfelse>NULL</cfif>,
					<cfif len(arguments.action_type)>#arguments.action_type#<cfelse>NULL</cfif>,
					<cfif len(arguments.action_date)>#arguments.action_date#<cfelse>NULL</cfif>,
					<cfif len(arguments.project_id)>#arguments.project_id#<cfelse>NULL</cfif>,
					<cfif len(arguments.expense_center_id)>#arguments.expense_center_id#<cfelse>NULL</cfif>,
					<cfif len(arguments.expense_item_id)>#arguments.expense_item_id#<cfelse>NULL</cfif>,
					<cfif len(arguments.claim_account_code)>'#arguments.claim_account_code#'<cfelse>NULL</cfif>,
					<cfif len(arguments.debt_account_code)>'#arguments.debt_account_code#'<cfelse>NULL</cfif>,
					<cfif len(arguments.account_code)>'#arguments.account_code#'<cfelse>NULL</cfif>,
					<cfif len(arguments.inventory_duration)>#arguments.inventory_duration#<cfelse>NULL</cfif>,
					<cfif len(arguments.amortization_rate)>#arguments.amortization_rate#<cfelse>NULL</cfif>,
					#session.ep.userid#,
					'#cgi.remote_addr#',
					#now()#,
					<cfif len(arguments.ifrs_inventory_duration)>#arguments.ifrs_inventory_duration#<cfelse>NULL</cfif>,
					<cfif len(arguments.activity_id)>#arguments.activity_id#<cfelse>NULL</cfif>
				)
		</cfquery>
	</cffunction>
</cfcomponent>

