<cfquery name="get_task" datasource="#dsn3#">
	SELECT RELATED_TASK_ID,COMPANY_ID,PROJECT_ID,ACTION_DATE,COUNT_TYPE FROM WAREHOUSE_TASKS WHERE TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">
</cfquery>

<cfset attributes.company_id = get_task.COMPANY_ID>
<cfset attributes.project_id = get_task.project_id>
<cfset attributes.county_type = get_task.COUNT_TYPE>

<cfif not len(get_task.RELATED_TASK_ID)>
	<cfquery name="add_warehouse_task" datasource="#dsn3#" result="add_r">
		INSERT INTO
			WAREHOUSE_TASKS
			(
				IS_ACTIVE,
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
				SPECIAL_INS,
				FREIGHT,
				BL_NUMBER,			
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
			SELECT
				1,
				2,
				COMPANY_ID,
				PROJECT_ID,
				DEPARTMENT_ID,
				LOCATION_ID,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
				TASK_STAGE,
				ACTION_DATE,
				DETAIL,
				EXTRA_DETAIL,
				EXTRA_AMOUNT,
				CONTAINER,
				CARRIER_NAME,
				SPECIAL_INS,
				FREIGHT,
				NULL,
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
	<cfquery name="upd_warehouse_task" datasource="#dsn3#">
		UPDATE
			WAREHOUSE_TASKS
		SET
			RELATED_TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_task_id#">
		WHERE
			TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">
	</cfquery>
<cfelse>
	<cfset attributes.new_task_id = get_task.related_task_id>
	<cfquery name="upd_warehouse_task" datasource="#dsn3#">
		UPDATE
			WAREHOUSE_TASKS
		SET
			IS_ACTIVE = 1
		WHERE
			TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_task_id#">
	</cfquery>
</cfif>

<cfquery name="del_" datasource="#dsn3#">
	DELETE FROM WAREHOUSE_TASKS_PRODUCTS WHERE TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_task_id#">
</cfquery>

<cfquery name="get_products" datasource="#dsn3#">
	SELECT
		*,
		(STOCK_COUNT_IN - STOCK_COUNT_OUT) AS STOCK_COUNT,
		(PALLET_COUNT_IN - PALLET_COUNT_OUT) AS PALLET_COUNT
	FROM
		(
		SELECT 
			<cfif not len(attributes.project_id)>
			'' AS ACTION_NO,
			<cfelse>
			ACTION_NUMBERS.ACTION_NO,
			</cfif>
			PRODUCT_ID,
			PRODUCT_NAME,
			STOCK_ID,
			(SELECT PC.PRODUCT_CAT FROM PRODUCT_CAT PC WHERE PC.PRODUCT_CATID = STOCKS.PRODUCT_CATID) AS PRODUCT_CAT,
			ISNULL((SELECT SUM(WTP.AMOUNT) FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE <cfif len(attributes.project_id)>WTP.ACTION_NO = ACTION_NUMBERS.ACTION_NO AND</cfif> WT.IS_ACTIVE = 1 AND WT.TASK_ID = WTP.TASK_ID AND WTP.PRODUCT_ID = STOCKS.PRODUCT_ID AND WT.WAREHOUSE_IN_OUT IN (0,2)),0) AS STOCK_COUNT_IN,
			ISNULL((SELECT SUM(WTP.AMOUNT) FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE <cfif len(attributes.project_id)>WTP.ACTION_NO = ACTION_NUMBERS.ACTION_NO AND</cfif> WT.IS_ACTIVE = 1 AND WT.TASK_ID = WTP.TASK_ID AND WTP.PRODUCT_ID = STOCKS.PRODUCT_ID AND WT.WAREHOUSE_IN_OUT IN (1)),0)  AS STOCK_COUNT_OUT,
			ISNULL((SELECT SUM(CEILING(CAST(WTP.AMOUNT AS FLOAT) / WTP.PALLET_AMOUNT)) FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE <cfif len(attributes.project_id)>WTP.ACTION_NO = ACTION_NUMBERS.ACTION_NO AND</cfif> WTP.PALLET_AMOUNT <> 0 AND WT.IS_ACTIVE = 1 AND WTP.AMOUNT <> 0 AND WTP.TOTAL_UNIT_TYPE = 'Pallet' AND WT.TASK_ID = WTP.TASK_ID AND WTP.PRODUCT_ID = STOCKS.PRODUCT_ID AND WT.WAREHOUSE_IN_OUT IN (0,2)),0) AS PALLET_COUNT_IN,
			ISNULL((SELECT SUM(CEILING(CAST(WTP.AMOUNT AS FLOAT) / WTP.PALLET_AMOUNT)) FROM WAREHOUSE_TASKS_PRODUCTS WTP,WAREHOUSE_TASKS WT WHERE <cfif len(attributes.project_id)>WTP.ACTION_NO = ACTION_NUMBERS.ACTION_NO AND</cfif> WTP.PALLET_AMOUNT <> 0 AND WT.IS_ACTIVE = 1 AND WTP.AMOUNT <> 0 AND WTP.TOTAL_UNIT_TYPE = 'Pallet' AND WT.TASK_ID = WTP.TASK_ID AND WTP.PRODUCT_ID = STOCKS.PRODUCT_ID AND WT.WAREHOUSE_IN_OUT IN (1)),0)  AS PALLET_COUNT_OUT,
			ISNULL((SELECT MULTIPLIER FROM PRODUCT_UNIT WHERE ADD_UNIT = 'Pallet' AND MULTIPLIER IS NOT NULL AND MULTIPLIER <> '' AND PRODUCT_ID = STOCKS.PRODUCT_ID),1) AS PALLET_MIKTAR
		FROM 
			STOCKS
				<cfif len(attributes.project_id)>
				OUTER APPLY
					(
						SELECT DISTINCT
							WTP_MAIN.ACTION_NO
						FROM
							WAREHOUSE_TASKS_PRODUCTS WTP_MAIN,
							WAREHOUSE_TASKS WT_MAIN
						WHERE
							WTP_MAIN.PRODUCT_ID = STOCKS.PRODUCT_ID AND
							WTP_MAIN.TASK_ID = WT_MAIN.TASK_ID AND
							WT_MAIN.IS_ACTIVE = 1
					) AS ACTION_NUMBERS	
				</cfif>
		WHERE 
			COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			<cfif len(attributes.project_id)>
				AND PRODUCT_ID IN (SELECT DISTINCT PRODUCT_ID FROM #DSN1_ALIAS#.PRODUCT	WHERE PROJECT_ID IS NOT NULL AND PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">)
			</cfif>
		) AS T1
	WHERE
		<cfif attributes.county_type eq 1>
			PRODUCT_ID IN (SELECT DISTINCT PRODUCT_ID FROM WAREHOUSE_TASKS_PRODUCTS	WHERE TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.task_id#">) AND
		</cfif>
		(STOCK_COUNT_IN - STOCK_COUNT_OUT) <> 0
	ORDER BY
		PRODUCT_CAT ASC,
		PRODUCT_NAME
</cfquery>

<cfif attributes.county_type eq 0 or attributes.county_type eq 1>
	<cfoutput query="get_products">
		<cfif PALLET_COUNT eq 0>
			<cfset p_count_ = 0>
		<cfelse>
			<cfset p_count_ = abs(PALLET_COUNT)>
		</cfif>
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
				VALUES
				(
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_task_id#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#PRODUCT_ID#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#STOCK_ID#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#-1 * STOCK_COUNT#">,
				<cfif p_count_ gt 0><cfqueryparam cfsqltype="cf_sql_integer" value="#abs(STOCK_COUNT) / p_count_#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
				'',
				'Pallet',
				'',
				'',
				'',
				'',
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ACTION_NO#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(get_task.ACTION_DATE)#">
				)
		</cfquery>
	</cfoutput>
</cfif>

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
			TASK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.new_task_id#">
</cfquery>
<script>
	window.location.href = '<cfoutput>#request.self#?fuseaction=stock.list_warehouse_tasks&event=upd&task_id=#attributes.new_task_id#</cfoutput>';
</script>
<cfabort>