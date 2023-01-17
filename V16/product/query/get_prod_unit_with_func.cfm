<cffunction name="GET_UNIT_NAME">
	<cfargument name="unit_id">
	<cfargument name="product_id">
	<cfif len(unit_id)>
		<cfquery  name="get_unit_n"datasource="#DSN3#">
			SELECT
				MAIN_UNIT
			FROM
				PRODUCT_UNIT
			WHERE
				PRODUCT_UNIT_ID =#unit_id#
			<cfif isDefined(product_id)>
				PRODUCT_ID=#product_id#
			</cfif>
		</cfquery>
		<cfif get_unit_n.recordcount>
			<cfreturn get_unit_n.MAIN_UNIT>
		<cfelse>
			<cfreturn "">
		</cfif>
	<cfelse>
		<cfreturn "">
	</cfif>
</cffunction>
