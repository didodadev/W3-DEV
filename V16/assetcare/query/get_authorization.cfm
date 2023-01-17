<cfquery name="get_authorization" datasource="#dsn#">
	SELECT 
		PTR.PROCESS_ROW_ID,
		PTR.LINE_NUMBER
	FROM
		PROCESS_TYPE PT,
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		ASSET_P_REQUEST_ROWS APR
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%assetcare.upd_vehicle_purchase_request%"> AND
		APR.REQUEST_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.request_row_id#"> AND
		APR.REQUEST_STATE = PTR.PROCESS_ROW_ID
</cfquery>
