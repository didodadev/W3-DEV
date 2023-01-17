<cfcomponent>
	<cffunction name="fncGetList">
		<cfquery name="qryGetList" datasource="#dsn#">
			SELECT 
            	STARTDATE
            FROM 
	            SETUP_PROGRAM_PARAMETERS 
            ORDER BY 
            	STARTDATE DESC
		</cfquery>
		<cfreturn qryGetList>
	</cffunction>
</cfcomponent>
