<cfcomponent>
    <cffunction name="sessionParam" access="remote" returntype="struct">
    	<cfargument name="dataBaseType" required="yes" default="">
        <cfargument name="dsn" required="yes" default="">
        <cfargument name="dsn1" required="yes" default="">
        <cfargument name="periodYear" required="yes" default="">
        <cfargument name="companyID" required="yes" default="">
        <cfscript>
			var sessionParam = StructNew();
				var sessionParam.dsn2='#arguments.dsn#_#arguments.periodYear#_#arguments.companyID#';
				var sessionParam.dsn3='#arguments.dsn#_#arguments.companyID#';
				var sessionParam.dsn_alias='#arguments.dsn#';
				var sessionParam.dsn1_alias='#arguments.dsn1#';
				var sessionParam.dsn_report_alias='#arguments.dsn#_report';
				var sessionParam.dsn2_alias='#sessionParam.dsn2#';
				var sessionParam.dsn3_alias='#sessionParam.dsn3#';
        </cfscript>
		<cfreturn sessionParam>
    </cffunction>
</cfcomponent>
