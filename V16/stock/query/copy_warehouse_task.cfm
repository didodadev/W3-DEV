<cfquery name="add_warehouse_task" datasource="#dsn3#" result="add_r">
	INSERT INTO
		WAREHOUSE_TASKS
		(
			WAREHOUSE_IN_OUT,
			COMPANY_ID,
			PROJECT_ID,
			DEPARTMENT_ID,
			LOCATION_ID,
			EMPLOYEE_ID,
			TASK_STAGE,
			ACTION_DATE,
			DETAIL,
			EXTRA_DETAIL,
			EXTRA_AMOUNT,
			CONTAINER,
			CARRIER_NAME,
            IS_ACTIVE,
			SPECIAL_INS,
			FREIGHT,
			BL_NUMBER,			
			CARGO_MYCOMPANY,
			CARGO_MYNAME,
			CARGO_MYADDRESS,
			CARGO_MYPHONE,
			CARGO_MYPOSTCODE,
			CARGO_MYCOUNTY,
			CARGO_MYCITY,
			CARGO_SHIP_RELATED_NUMBER,	
			CARGO_SHIP_RELATED_POSTCODE,			
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
		SELECT
			WAREHOUSE_IN_OUT,
			COMPANY_ID,
			PROJECT_ID,
			DEPARTMENT_ID,
			LOCATION_ID,
			#session.ep.userid#,
			TASK_STAGE,
			ACTION_DATE,
			DETAIL,
			EXTRA_DETAIL,
			EXTRA_AMOUNT,
			CONTAINER,
			CARRIER_NAME,
            0,
			SPECIAL_INS,
			FREIGHT,
			NULL,			
			CARGO_MYCOMPANY,
			CARGO_MYNAME,
			CARGO_MYADDRESS,
			CARGO_MYPHONE,
			CARGO_MYPOSTCODE,
			CARGO_MYCOUNTY,
			CARGO_MYCITY,	
			CARGO_SHIP_RELATED_NUMBER,	
			CARGO_SHIP_RELATED_POSTCODE,
			#now()#,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
		FROM
			WAREHOUSE_TASKS
		WHERE
			TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">
</cfquery>

<cfset attributes.new_task_id = add_r.identitycol>

<cfquery name="upd_warehouse_task" datasource="#dsn3#">
	UPDATE
		WAREHOUSE_TASKS
	SET
		TASK_NO = TASK_ID
	WHERE
		TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_task_id#">
</cfquery>

<cfquery name="add_" datasource="#dsn3#">
	INSERT INTO
		WAREHOUSE_TASKS_ROWS
		(
		TASK_ID,
		WAREHOUSE_TASK_TYPE_ID,
		RATE_CODE,
		ROW_AMOUNT
		)
		SELECT
        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_task_id#">,
			WAREHOUSE_TASK_TYPE_ID,
			RATE_CODE,
			ROW_AMOUNT
		FROM
			WAREHOUSE_TASKS_ROWS
		WHERE
			TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">
</cfquery>

<cfquery name="add_" datasource="#dsn3#">
	INSERT INTO
		WAREHOUSE_TASKS_ACTIONS
		(
		TASK_ID,
		ACTION_PERIOD_ID,
		ACTION_NO,
		ACTION_DATE
		)
		SELECT
        <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_task_id#">,
			ACTION_PERIOD_ID,
			ACTION_NO,
			ACTION_DATE
		FROM
			WAREHOUSE_TASKS_ACTIONS
		WHERE
			TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">
</cfquery>


<cfquery name="add_" datasource="#dsn3#">
	INSERT INTO
		WAREHOUSE_TASKS_PRODUCTS
		(
		TASK_ID,
		PRODUCT_ID,
		STOCK_ID,
		AMOUNT,
		PALLET_AMOUNT,
		PRODUCT_INFO,
		TOTAL_UNIT_TYPE,
		BOX_STYLE,
		SIZE_STYLE,
		WEIGHT,
		DIMENSION,
		ACTION_PERIOD_ID,
		ACTION_NO,
		ACTION_DATE
		)
		SELECT
			 <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_task_id#">,
			PRODUCT_ID,
			STOCK_ID,
			AMOUNT,
			PALLET_AMOUNT,
			PRODUCT_INFO,
			TOTAL_UNIT_TYPE,
			BOX_STYLE,
			SIZE_STYLE,			
			WEIGHT,
			DIMENSION,
			ACTION_PERIOD_ID,
			ACTION_NO,
			ACTION_DATE
		FROM
			WAREHOUSE_TASKS_PRODUCTS
		WHERE
			TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">
</cfquery>

<script>
	window.location.href = '<cfoutput>#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#attributes.new_task_id#</cfoutput>';
</script>
<cfabort>