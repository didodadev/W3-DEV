<cfcomponent>
	<cfset dsn = application.systemParam.systemParam().dsn>
    <cffunction name="getCompenentFunction">
        <cfargument name="keyword" default="">
        <cfargument name="alfabetik" default="">
        <cfargument name="operation_code" default="">
        <cfargument name="siralama" default="">
		<cfargument name="other_parameters" default="">
		<cfif len(arguments.other_parameters)>
			<cfloop list="#arguments.other_parameters#" delimiters="█" index="opind">
				<cfset other_parameter_name1 = ListGetAt(opind,1,'§')>
				<cfset other_parameter_value1= ListGetAt(opind,2,'§')>
			</cfloop>
		</cfif>
        <cfquery name="getOperationTypes_" datasource="#dsn#_#session.ep.company_id#">
           SELECT
           OPERATION_TYPE_ID
            ,#dsn#.Get_Dynamic_Language(OPERATION_TYPES.OPERATION_TYPE_ID,'#session.ep.language#', 'OPERATION_TYPES', 'OPERATION_TYPE', NULL, NULL, OPERATION_TYPES.OPERATION_TYPE) AS OPERATION_TYPE
            ,OPERATION_TYPE
            ,O_HOUR
            ,O_MINUTE
            ,COMMENT
            ,COMMENT2
            ,FILE_NAME
            ,OPERATION_COST
            ,MONEY
            ,FILE_SERVER_ID
            ,OPERATION_CODE
            ,OPERATION_STATUS
            ,RECORD_DATE
            ,RECORD_EMP
            ,EZGI_H_SURE
            ,EZGI_FORMUL
            ,IS_VIRTUAL  
            FROM
                OPERATION_TYPES
            WHERE
                OPERATION_TYPE LIKE '%#arguments.keyword#%'
				<cfif isdefined("other_parameter_value1") and other_parameter_value1 eq 1>
					AND OPERATION_STATUS = 1
				</cfif>
           
            <cfif isdefined("arguments.alfabetik") and arguments.siralama eq "alfabetik">
                ORDER BY   OPERATION_TYPES.OPERATION_TYPE
					
            <cfelseif isdefined("arguments.operation_code") and arguments.siralama eq "operation_code">
                ORDER BY   OPERATION_CODE 
			</cfif>
          
        </cfquery>
        <cfreturn getOperationTypes_>
    </cffunction>
</cfcomponent>

