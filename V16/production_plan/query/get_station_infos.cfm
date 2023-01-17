<cfif ISNUMERIC(GET_DET_PO.STATION_ID) and len(GET_DET_PO.STATION_ID) >
	<cfquery name="GET_W" datasource="#DSN3#">
		SELECT 
			STATION_NAME 
		FROM 
			WORKSTATIONS 
		WHERE 
			STATION_ID=#GET_DET_PO.STATION_ID#
	</cfquery>
</cfif>	
<!--- <cfif ISNUMERIC(GET_DET_PO.ROUTE_ID) and len(GET_DET_PO.ROUTE_ID) >
		<cfquery name="GET_R" datasource="#DSN3#">
			SELECT 
				ROUTE 
			FROM 
				ROUTE 
			WHERE 
				ROUTE_ID=#GET_DET_PO.ROUTE_ID#
		</cfquery>
</cfif>
<cfif ISNUMERIC(GET_DET_PO.PROSPECTUS_ID) and len(GET_DET_PO.PROSPECTUS_ID) >
	<cfquery name="GET_PRO" datasource="#DSN3#">
		SELECT 
			PROSPECTUS_NAME 
		FROM
			PROSPECTUS
		WHERE
			PROSPECTUS_ID=#GET_DET_PO.PROSPECTUS_ID#
	</cfquery>
</cfif> --->

