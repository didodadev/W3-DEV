<cfquery name="GET_SERIAL_INFO" datasource="#DSN3#">
	SELECT
		SG.GUARANTY_ID,
		SG.LOT_NO,
		SG.IN_OUT,
		SG.SERIAL_NO,
		SG.STOCK_ID,
        SG.PROCESS_ID,
		SG.UNIT_TYPE UNIT,
        <cfif isDefined('session.ep.userid')>
            E.EMPLOYEE_NAME,
            E.EMPLOYEE_SURNAME,
        </cfif>
		SG.PROCESS_CAT AS PROCESS_CAT
	FROM
		SERVICE_GUARANTY_NEW AS SG
		<cfif isDefined('session.ep.userid')>
        	,#dsn_alias#.EMPLOYEES E
		</cfif>
    WHERE
    	<cfif isDefined('session.ep.userid')>
            E.EMPLOYEE_ID = SG.RECORD_EMP AND
        </cfif>
		<cfif attributes.process_cat eq 1190>
			SG.PROCESS_NO = '#PROCESS_NUMBER#' AND
		<cfelse>
			<cfif isdefined("attributes.wrk_row_id") and len(attributes.wrk_row_id)>
				SG.WRK_ROW_ID = '#attributes.wrk_row_id#' AND	
			<cfelseif len(attributes.process_id) and attributes.process_id neq 0>
				SG.PROCESS_ID = #attributes.process_id# AND
			</cfif>
		</cfif>
		SG.PROCESS_CAT = #attributes.process_cat# AND
		SG.STOCK_ID = #attributes.STOCK_ID#
        <cfif not listfind('171,1193,1194',attributes.process_cat)>
			AND SG.PERIOD_ID = #session.ep.period_id#
        </cfif>
		<cfif isdefined("attributes.spect_id") and len(attributes.spect_id)>
			AND SG.SPECT_ID = #attributes.SPECT_ID#
		</cfif>
		<cfif not isdefined("attributes.main_stock_id") or not len(attributes.main_stock_id)>
			AND SG.MAIN_STOCK_ID IS NULL
		<cfelse>
			AND SG.MAIN_STOCK_ID=#attributes.main_stock_id#
		</cfif>
        <cfif attributes.process_cat eq 116>
        	AND SG.IN_OUT = 1
        </cfif>
	ORDER BY 
		SG.SERIAL_NO ASC
</cfquery>

