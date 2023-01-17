<cfswitch expression="#attributes.operation_type#">
	<cfcase value="-1">
		<cfswitch expression="#attributes.target_pos#">
			<cfcase value="-1">
				<cfinclude template="import_stock_open_genius_1.cfm">
			</cfcase>
			<cfcase value="-2">
				<cfinclude template="import_stock_open_phl.cfm">
			</cfcase>
		</cfswitch>
	</cfcase>
	<cfcase value="-2">
		<cfinclude template="import_stock_open_genius_2.cfm">
	</cfcase>
	<cfcase value="-3">
		<cfinclude template="import_stock_open_genius_3.cfm">
	</cfcase>
</cfswitch>
