<cfquery name="GET_INTERNALDEMAND" datasource="#dsn3#">
	SELECT 
		I.*,
		IR.PRO_MATERIAL_ID
	FROM 
		INTERNALDEMAND I,
		INTERNALDEMAND_ROW IR
	WHERE
		I.INTERNAL_ID = IR.I_ID
		AND INTERNAL_ID=#attributes.id#
		<cfif is_demand eq 1>
			AND DEMAND_TYPE = 1
		<cfelse>
			AND ISNULL(DEMAND_TYPE,0) = 0
		</cfif>
	ORDER BY
		IR.I_ROW_ID
</cfquery>
