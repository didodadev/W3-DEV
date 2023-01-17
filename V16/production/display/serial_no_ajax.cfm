<cfsetting showdebugoutput="no">
<cfif type eq 1>
	<cfquery name="get_operations__" datasource="#dsn3#">
		SELECT * FROM PRODUCTION_ORDER_OPERATIONS WHERE P_ORDER_ID = #attributes.p_order_id#
	</cfquery>
	<cfif get_operations__.recordcount>
		<cfquery name="get_serial_count__" dbtype="query">
			SELECT DISTINCT
				COUNT(SERIAL_NO),
				EMPLOYEE_ID,
				ASSET_ID,
				AMOUNT,
				SERIAL_NO
			FROM 
				get_operations__ 
			WHERE
				WRK_ROW_ID = '#attributes.wrk_row_id#'
			GROUP BY 
				SERIAL_NO,
				EMPLOYEE_ID,
				ASSET_ID,
				AMOUNT,
				SERIAL_NO
		</cfquery>
	<cfelse>
		<cfset get_serial_count__.recordcount = 0>
	</cfif>
	<cfif get_serial_count__.recordcount>
		<select name="serial_no<cfoutput>#attributes.row_#</cfoutput>" id="serial_no<cfoutput>#attributes.row_#</cfoutput>" disabled="disabled" style="width:200px;height:25px;font-size:18px">
			<cfloop query="get_serial_count__">
				<option value="<cfoutput>#serial_no#</cfoutput>" <cfif serial_no eq get_serial_count__.serial_no>selected</cfif>><cfoutput>#SERIAL_NO#</cfoutput></option>
			</cfloop>
		</select>
	</cfif>
<cfelse>
	<cfquery name="get_serial_no_" datasource="#dsn3#">
		SELECT 
			SERIAL_NO,GUARANTY_ID 
		FROM 
			SERVICE_GUARANTY_NEW 
		WHERE 
			PROCESS_ID = #attributes.p_order_id#  AND
			PROCESS_CAT = 1194 AND
			PROCESS_NO = '#attributes.p_order_no#' AND
			SERIAL_NO NOT IN (SELECT SERIAL_NO FROM PRODUCTION_ORDER_OPERATIONS WHERE P_ORDER_ID = SERVICE_GUARANTY_NEW.PROCESS_ID)
	</cfquery>
	<select name="serial_no<cfoutput>#attributes.row_#</cfoutput>" id="serial_no<cfoutput>#attributes.row_#</cfoutput>" onchange="serialno_control(<cfoutput>#attributes.row_#</cfoutput>);" style="width:200px;height:25px;font-size:18px">
		<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
		<cfloop query="get_serial_no_">
			<cfoutput><option value="#serial_no#">#SERIAL_NO#</option></cfoutput>
		</cfloop>
	</select>
</cfif>
