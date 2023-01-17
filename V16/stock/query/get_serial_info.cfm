<cfquery name="GET_SERIAL_INFO" datasource="#DSN3#">
	SELECT
		SG.LOT_NO,
		SG.SERIAL_NO,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		SERVICE_GUARANTY_NEW AS SG,
		#dsn_alias#.EMPLOYEES E
	WHERE
		E.EMPLOYEE_ID = SG.RECORD_EMP AND
		STOCK_ID = #attributes.STOCK_ID# AND
		PROCESS_ID = #attributes.process_id# AND
		PROCESS_CAT = #attributes.process_cat#
        <cfif not listfind('171,1193,1194',attributes.process_cat)>
		AND SG.PERIOD_ID = #session.ep.period_id#
        </cfif>
		AND SG.SPECT_ID = #attributes.spect_id#
		<cfif not isdefined("attributes.main_stock_id") or not len(attributes.main_stock_id)>
		AND SG.MAIN_STOCK_ID IS NULL
		<cfelse>
		AND SG.MAIN_STOCK_ID=#attributes.main_stock_id#
		</cfif>
</cfquery>
