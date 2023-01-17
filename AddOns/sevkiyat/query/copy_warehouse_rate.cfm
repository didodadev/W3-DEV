<cfquery name="add_" datasource="#dsn3#" result="add_r">
	INSERT INTO
		WAREHOUSE_RATES
		(
		ACTION_DATE,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
		)
		SELECT
			ACTION_DATE,
			#SESSION.EP.USERID#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
			#NOW()#
		FROM
			WAREHOUSE_RATES
		WHERE
			RATE_ID = #attributes.rate_id#
</cfquery>
<cfquery name="add_rows_" datasource="#dsn3#">
	INSERT INTO
		WAREHOUSE_RATES_ROWS
		(
		RATE_ID,
		WAREHOUSE_TASK_TYPE_ID,
		PRODUCT_ID,
		UNIT_ID,
		PRICE,
		PRICE_MONEY,
		IS_BILL,
		RATE1,
		RATE2,
		RATE_UNIT_ID,
		RATE_INFO
		)
		SELECT
			#add_r.identitycol#,
			WAREHOUSE_TASK_TYPE_ID,
			PRODUCT_ID,
			UNIT_ID,
			PRICE,
			PRICE_MONEY,
			IS_BILL,
			RATE1,
			RATE2,
			RATE_UNIT_ID,
			RATE_INFO
		FROM
			WAREHOUSE_RATES_ROWS
		WHERE
			RATE_ID = #attributes.rate_id#
</cfquery>

<cfquery name="add_rows_" datasource="#dsn3#">
	UPDATE
		WAREHOUSE_RATES_ROWS
	SET
		RATE_CODE = ROW_ID
	WHERE
		RATE_CODE IS NULL
</cfquery>
<cflocation url="#request.self#?fuseaction=settings.list_warehouse_rates&event=upd&rate_id=#add_r.identitycol#" addtoken="no">