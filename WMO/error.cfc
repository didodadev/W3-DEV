<cfcomponent>
	<cfsetting requesttimeout="2000">
    <cffunction name="workcubeError" access="remote" returntype="string">
        <cfargument name="exception" type="string" required="yes">
        <cfif arguments.exception contains 'undefined in a CFML structure referenced as part of an expression.'><!--- Fuseaction eksiktir, modül yoktur. --->
        	<cfset session.ep.errorType = 1>
        	<cfset session.ep.error = 2347>
        <cfelseif arguments.exception contains 'for CFSQLTYPE CF_SQL_INTEGER.'> <!--- URL'deki ID değeri integer sınırlarını aşmıştır.  --->
        	<cfset session.ep.errorType = 2>
        	<cfset session.ep.error = 2177>
        <cfelseif arguments.exception contains 'Element CIRCUITS is undefined in FUSEBOX.'> <!--- URL'deki ID değeri integer sınırlarını aşmıştır.  --->
        	<cfset session.ep.errorType = 3>
        	<cfset session.ep.error = 136>
        <cfelseif arguments.exception contains 'is undefined in ATTRIBUTES.'> <!--- Eksik Parametre Tanımı  --->
        	<cfset session.ep.errorType = 4>
        	<cfset session.ep.error = 2348>
        <cfelseif arguments.exception contains 'is undefined in FORM.'> <!--- Eksik Parametre Tanımı  --->
        	<cfset session.ep.errorType = 4>
        	<cfset session.ep.error = 2348>
        <cfelseif arguments.exception contains 'Your connection was terminated.' or arguments.exception contains 'Connection reset by peer: socket write error'> <!--- DB bağlantısı kurulamadı.--->
        	<cfset session.ep.errorType = 5>
        	<cfset session.ep.error = 2349>
        <cfelseif arguments.exception contains 'Variable' and arguments.exception contains 'is undefined.'>
        	<cfset session.ep.errorType = 6>
        	<cfset session.ep.error = 1531>
		<cfelse>
			<cfset session.ep.errorType = 15>
        	<cfset session.ep.error = 2141>
        </cfif>
		<cfreturn session.ep.error>
    </cffunction>
</cfcomponent>
