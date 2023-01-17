<cfcomponent extends="cfc.queryJSONConverter">

	<cfset dsn = application.systemParam.systemParam().dsn />
	<cfset dsn2 = "#dsn#_#session.ep.period_year#_#session.ep.company_id#" />
	<cfset dsn3 = "#dsn#_#session.ep.company_id#" />
	<cfset dsn1 = "#dsn#_product" />

	<cfsetting requesttimeout="2000">

	<cffunction name="saveParameter" access="public" returntype="any">
		<cfargument name = "parameterId" default="">
		<cfargument name = "groupId" default="">
		<cfargument name = "parameterName" default="">
		<cfargument name = "minLimit" default="">
		<cfargument name = "maxLimit" default="">
		<cfargument name = "parameterStatus" default="">
		<cfargument name = "parameterDeleted" default="">

		<cfquery name="UPD_PARAMETERS" datasource="#dsn#">
			<cfif len(arguments.parameterId)>
				<cfif arguments.parameterDeleted eq 0>
					UPDATE
						REFINERY_TEST_PARAMETERS
					SET
						PARAMETER_NAME = <cfif len(arguments.parameterName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parameterName#"><cfelse>NULL</cfif>,
						MIN_LIMIT = <cfif len(arguments.minLimit)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.minLimit#"><cfelse>NULL</cfif>,
						MAX_LIMIT = <cfif len(arguments.maxLimit)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.maxLimit#"><cfelse>NULL</cfif>,
						GROUP_ID = <cfif len(arguments.groupId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#"><cfelse>NULL</cfif>,
						PARAMETER_STATUS = <cfif len(arguments.parameterStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.parameterStatus#"><cfelse>NULL</cfif>,
						OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
					WHERE
						REFINERY_TEST_PARAMETER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parameterId#">
				<cfelse>
					DELETE FROM REFINERY_TEST_PARAMETERS WHERE REFINERY_TEST_PARAMETER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parameterId#">
				</cfif>
			<cfelse>
				INSERT INTO
					REFINERY_TEST_PARAMETERS
				(
					PARAMETER_NAME,
					MIN_LIMIT,
					MAX_LIMIT,
					GROUP_ID,
					PARAMETER_STATUS,
					OUR_COMPANY_ID
				)
				VALUES
				(
					<cfif len(arguments.parameterName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parameterName#"><cfelse>NULL</cfif>,
					<cfif len(arguments.minLimit)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.minLimit#"><cfelse>NULL</cfif>,
					<cfif len(arguments.maxLimit)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.maxLimit#"><cfelse>NULL</cfif>,
					<cfif len(arguments.groupId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#"><cfelse>NULL</cfif>,
					<cfif len(arguments.parameterStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.parameterStatus#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				)
			</cfif>
		</cfquery>
		<cfreturn 1>
	</cffunction>
	<cffunction name="delParameter" access="public" returntype="any">
		<cfargument name = "groupId" default="">
		<cfquery name="DEL_PARAMETERS" datasource="#dsn#">
			DELETE FROM REFINERY_TEST_PARAMETERS WHERE GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#">
		</cfquery>
	</cffunction>
	<cffunction name="saveMethod" access="public" returntype="any">
		<cfargument name = "methodId" default="">
		<cfargument name = "groupId" default="">
		<cfargument name = "parameterId" default="">
		<cfargument name = "methodName" default="">
		<cfargument name = "methodStatus" default="">
		<cfargument name = "methodDeleted" default="">

		<cfquery name="UPD_METHOD" datasource="#dsn#">
			<cfif len(arguments.methodId)>
				<cfif arguments.methodDeleted eq 0>
					UPDATE
						REFINERY_TEST_METHODS
					SET
						REFINERY_GROUP_ID = <cfif len(arguments.groupId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#"><cfelse>NULL</cfif>,
						REFINERY_TEST_PARAMETER_ID = <cfif len(arguments.parameterId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parameterId#"><cfelse>NULL</cfif>,
						TEST_METHOD_NAME = <cfif len(arguments.methodName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.methodName#"><cfelse>NULL</cfif>,
						TEST_METHOD_STATUS = <cfif len(arguments.methodStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.methodStatus#"><cfelse>NULL</cfif>,
						OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
					WHERE
						REFINERY_TEST_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.methodId#">
				<cfelse>
					DELETE FROM REFINERY_TEST_METHODS WHERE REFINERY_TEST_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.methodId#">
				</cfif>
			<cfelse>
				INSERT INTO
					REFINERY_TEST_METHODS
				(
					REFINERY_GROUP_ID,
					REFINERY_TEST_PARAMETER_ID,
					TEST_METHOD_NAME,
					TEST_METHOD_STATUS,
					OUR_COMPANY_ID
				)
				VALUES
				(
					<cfif len(arguments.groupId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#"><cfelse>NULL</cfif>,
					<cfif len(arguments.parameterId)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parameterId#"><cfelse>NULL</cfif>,
					<cfif len(arguments.methodName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.methodName#"><cfelse>NULL</cfif>,
					<cfif len(arguments.methodStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.methodStatus#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				)
			</cfif>
		</cfquery>
		<cfreturn 1>
	</cffunction>
	<cffunction name="delMethod" access="public" returntype="any">
		<cfargument name = "groupId" default="">
		<cfquery name="DEL_METHOD" datasource="#dsn#">
			DELETE FROM REFINERY_TEST_METHODS WHERE REFINERY_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#">
		</cfquery>
	</cffunction>
	<cffunction name="saveUnit" access="public" returntype="any">
		<cfargument name = "unitId" default="">
		<cfargument name = "unitName" default="">
		<cfargument name = "unitStatus" default="">
		<cfargument name = "unitDeleted" default="">

		<cfquery name="UPD_PARAMETERS" datasource="#dsn#">
			<cfif len(arguments.unitId)>
				<cfif arguments.unitDeleted eq 0>
					UPDATE
						REFINERY_TEST_UNITS
					SET
						UNIT_NAME = <cfif len(arguments.unitName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.unitName#"><cfelse>NULL</cfif>,
						UNIT_STATUS = <cfif len(arguments.unitStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.unitStatus#"><cfelse>NULL</cfif>,
						OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
					WHERE
						REFINERY_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.unitId#">
				<cfelse>
					DELETE FROM REFINERY_TEST_UNITS WHERE REFINERY_UNIT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.unitId#">
				</cfif>
			<cfelse>
				INSERT INTO
					REFINERY_TEST_UNITS
				(
					UNIT_NAME,
					UNIT_STATUS,
					OUR_COMPANY_ID
				)
				VALUES
				(
					<cfif len(arguments.unitName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.unitName#"><cfelse>NULL</cfif>,
					<cfif len(arguments.unitStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.unitStatus#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				)
			</cfif>
		</cfquery>
		<cfreturn 1>
	</cffunction>
	<cffunction name="saveAnalyzeCat" access="public" returntype="any">
		<cfargument name = "analyzeCatId" default="">
		<cfargument name = "analyzeCatName" default="">
		<cfargument name = "analyzeCatStatus" default="">
		<cfargument name = "analyzeCatDeleted" default="">

		<cfquery name="UPD_PARAMETERS" datasource="#dsn#">
			<cfif len(arguments.analyzeCatId)>
				<cfif arguments.analyzeCatDeleted eq 0>
					UPDATE
						REFINERY_ANALYZE_CAT
					SET
						ANALYZE_CAT_NAME = <cfif len(arguments.analyzeCatName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.analyzeCatName#"><cfelse>NULL</cfif>,
						ANALYZE_CAT_STATUS = <cfif len(arguments.analyzeCatStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.analyzeCatStatus#"><cfelse>NULL</cfif>,
						OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
					WHERE
						ANALYZE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.analyzeCatId#">
				<cfelse>
					DELETE FROM REFINERY_ANALYZE_CAT WHERE ANALYZE_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.analyzeCatId#">
				</cfif>
			<cfelse>
				INSERT INTO
					REFINERY_ANALYZE_CAT
				(
					ANALYZE_CAT_NAME,
					ANALYZE_CAT_STATUS,
					OUR_COMPANY_ID
				)
				VALUES
				(
					<cfif len(arguments.analyzeCatName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.analyzeCatName#"><cfelse>NULL</cfif>,
					<cfif len(arguments.analyzeCatStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.analyzeCatStatus#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				)
			</cfif>
		</cfquery>
		<cfreturn 1>
	</cffunction>
	<cffunction name="getAnalysisCat" access="public" returntype="any">
		<cfquery name="getAnalysisCat" datasource="#dsn#">
			SELECT * FROM REFINERY_ANALYZE_CAT WHERE OUR_COMPANY_ID = <cfqueryparam	cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		</cfquery>
		<cfreturn getAnalysisCat>
	</cffunction>
	<cffunction name="saveGroup" access="public" returntype="any">
		<cfargument name = "groupId" default="">
		<cfargument name = "groupName" default="">
		<cfargument name = "groupStatus" default="">
		<cfargument name = "groupDeleted" default="">

		<cfquery name="UPD_PARAMETERS" datasource="#dsn#">
			<cfif len(arguments.groupId)>
				<cfif arguments.groupDeleted eq 0>
					UPDATE
						REFINERY_GROUPS
					SET
						GROUP_NAME = <cfif len(arguments.groupName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupName#"><cfelse>NULL</cfif>,
						GROUP_STATUS = <cfif len(arguments.groupStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.groupStatus#"><cfelse>NULL</cfif>,
						OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
					WHERE
						REFINERY_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#">
				<cfelse>
					DELETE FROM REFINERY_GROUPS WHERE REFINERY_GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupId#">
				</cfif>
			<cfelse>
				INSERT INTO
					REFINERY_GROUPS
				(
					GROUP_NAME,
					GROUP_STATUS,
					OUR_COMPANY_ID
				)
				VALUES
				(
					<cfif len(arguments.groupName)><cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupName#"><cfelse>NULL</cfif>,
					<cfif len(arguments.groupStatus)><cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.groupStatus#"><cfelse>NULL</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
				)
			</cfif>
		</cfquery>
		<cfreturn 1>
	</cffunction>
	
	<cffunction name="getParameter" access="remote" returnformat="JSON">
        <cfargument name = "group_id" default="">
        <cfargument name = "parameter_id" default="">
        
        <cfquery name="get_query" datasource="#dsn#">
			SELECT * FROM REFINERY_TEST_PARAMETERS
			WHERE 
                <cfif len(arguments.group_id)>GROUP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.group_id#"></cfif>
                <cfif len(arguments.parameter_id)>REFINERY_TEST_PARAMETER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parameter_id#"></cfif>
                AND PARAMETER_STATUS = 1
			ORDER BY PARAMETER_NAME
        </cfquery>

        <cfif get_query.recordcount><cfreturn Replace(SerializeJson(this.returnData( Replace( SerializeJson( get_query ), "//", "" ))), "//", "") /><cfelse>[]</cfif>
    
    </cffunction>
    
    <cffunction name="getMethod" access="remote" returnformat="JSON">
        <cfargument name = "parameter_id" default="">
        
        <cfquery name="get_query" datasource="#DSN#">
            SELECT * FROM REFINERY_TEST_METHODS
            WHERE 
				1 = 1
                <cfif len(arguments.parameter_id)>
					AND REFINERY_TEST_PARAMETER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parameter_id#">
				</cfif>
                AND TEST_METHOD_STATUS = 1
            ORDER BY TEST_METHOD_NAME
        </cfquery>
        
        <cfif get_query.recordcount><cfreturn Replace(SerializeJson(this.returnData( Replace( SerializeJson( get_query ), "//", "" ))), "//", "") /><cfelse>[]</cfif>
    
    </cffunction>
</cfcomponent>