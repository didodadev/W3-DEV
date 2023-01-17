<cfscript>
	get_warehouse_tasks_action = createObject("component", "v16.stock.cfc.get_warehouse_tasks");
	get_warehouse_tasks_action.dsn3 = dsn3;
	get_warehouse_tasks_action.dsn_alias = dsn_alias;
	get_warehouse_task = get_warehouse_tasks_action.get_warehouse_task_fnc(
		 task_id : '#attributes.task_id#'
	);

 	get_warehouse_ups_action = createObject("component", "v16.stock.cfc.ups");
</cfscript>

<cfif len(get_warehouse_task.cargo_code)>
	<cfloop list="#get_warehouse_task.cargo_code#" index="t_number">
		<cfset p_ = "Yes">
		<cfscript>
			get_warehouse_ups_action.init
			(
				License : "9D6A3E5FAC2C5932",
				Account : "376RY4",
				UserId : "TTCChicago",
				Password: "Evegroup2800",
				Production : "#p_#"
			);
			
			result_ups = get_warehouse_ups_action.void
			(
				Identification : "#listfirst(get_warehouse_task.cargo_code)#",
				Tracking : "#t_number#"
			);
		</cfscript>
	</cfloop>
	<cfif result_ups is 'Successful'>
		<cfquery name="upd_" datasource="#dsn3#">
			UPDATE
				WAREHOUSE_TASKS
			SET
				CARGO_STATUS = '',
				CARGO_STATUS_NOTE = '',
				CARGO_CODE = '',
				CARGO_TYPE = ''
			WHERE
				TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">
		</cfquery>
		<script>
			alert('Void Success!');
			window.location.href='<cfoutput>#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#attributes.task_id#</cfoutput>';
		</script>
	<cfelse>
		<script>
			alert('Void Error!');
			window.location.href='<cfoutput>#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#attributes.task_id#</cfoutput>';
		</script>
	</cfif>
<cfelse>
	No Tracking Number.
</cfif>
