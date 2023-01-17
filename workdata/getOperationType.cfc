<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompenentFunction">
        <cfargument name="keyword" default="">
		<cfargument name="other_parameters" default="">
		<cfif len(arguments.other_parameters)>
			<cfloop list="#arguments.other_parameters#" delimiters="█" index="opind">
				<cfset other_parameter_name1 = ListGetAt(opind,1,'§')>
				<cfset other_parameter_value1= ListGetAt(opind,2,'§')>
			</cfloop>
		</cfif>
        <cfquery name="getOperationTypes_" datasource="#dsn#_#session.ep.company_id#">
           SELECT
                *  
            FROM
                OPERATION_TYPES
            WHERE
                OPERATION_TYPE LIKE '%#arguments.keyword#%'
				<cfif isdefined("other_parameter_value1") and other_parameter_value1 eq 1>
					AND OPERATION_STATUS = 1
				</cfif>
            ORDER BY 
				OPERATION_TYPE
        </cfquery>
        <cfreturn getOperationTypes_>
    </cffunction>
</cfcomponent>

