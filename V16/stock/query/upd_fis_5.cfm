<cfinclude template="../../objects/functions/add_serial_no.cfm">
<cfquery name="del_guaranty" datasource="#dsn3#">
	DELETE FROM SERVICE_GUARANTY_NEW WHERE PROCESS_ID = #attributes.UPD_ID# AND PROCESS_TYPE = #attributes.fis_type# AND PERIOD_ID = #session.ep.period_id#
</cfquery>

<cfset temp_stock_ids = ''>
<cfloop from="1" to="#attributes.rows_#" index="i">
	<cfif isdefined("attributes.is_serial_no#i#")>
		<cfif len(evaluate('attributes.guaranty_purchasesales#i#')) and (evaluate('attributes.is_serial_no#i#') eq 1)>
			<cfscript>
				add_serial_no(
				session_row : i,
				process_id :attributes.UPD_ID,
				process_type : attributes.fis_type,
				process_number : '#LEFT(FIS_NO,50)#',
				dpt_id : attributes.DEPARTMENT_IN,
				loc_id : attributes.location_in
				);
			</cfscript>
			<cfset temp_stock_ids = listappend(temp_stock_ids,evaluate('attributes.stock_id#i#'),',')>
		</cfif>
	</cfif>
</cfloop> 
