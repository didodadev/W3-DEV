<cfswitch expression="#attributes.wrk_data_type#">
	<cfcase value="1">
		<cfinclude template="wrk_data_service_ship.cfm">
	</cfcase>
	<cfcase value="2">
		<cfinclude template="wrk_data_service_stock.cfm">
	</cfcase>
	<cfdefaultcase>
		Hatalı istek
	</cfdefaultcase>
</cfswitch>
