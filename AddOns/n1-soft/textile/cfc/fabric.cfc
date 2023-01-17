<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3 = "#dsn#_#session.ep.company_id#">
	   <cfset dsn2="#dsn#_#session.ep.period_year#_#session.ep.company_id#">
    <cffunction name="list_fabric" access="public" returntype="query">
        <cfargument name="stretching_test_id" type="any">
        <cfargument name="project_id" type="any">
        <cfargument name="purchasing_id" type="any">
        <cfquery name="query_list_fabric" datasource="#dsn3#">
            SELECT * FROM 
				 #dsn2#.SHIP_ROW 
				JOIN TEXTILE_STRETCHING_TEST ON TEXTILE_STRETCHING_TEST.PURCHASING_ID=SHIP_ROW.SHIP_ID
				LEFT JOIN TEXTILE_FABRIC on TEXTILE_FABRIC.STRETCHING_TEST_ID=TEXTILE_STRETCHING_TEST.STRETCHING_TEST_ID
            WHERE 1=1
            
            <cfif isDefined("arguments.stretching_test_id") and len(arguments.stretching_test_id) and arguments.stretching_test_id gt 0>
            AND TEXTILE_STRETCHING_TEST.STRETCHING_TEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stretching_test_id#'>
            </cfif>

            <cfif isDefined("arguments.project_id") and len(arguments.project_id) and arguments.project_id gt 0>
            AND PROJECT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.project_id#'>
            </cfif>

            <cfif isDefined("arguments.purchasing_id") and len(arguments.purchasing_id) and arguments.purchasing_id gt 0>
            AND PURCHASING_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.purchasing_id#'>
            </cfif>
        </cfquery>
        <cfreturn query_list_fabric>
    </cffunction>

    <cffunction name="add_fabric" access="public" returntype="any">
        <cfargument name="stretching_test_id" type="any">
        <cfargument name="project_id" type="any">
        <cfargument name="opportunity_id" type="any">
        <cfargument name="purchasing_id" type="any">
        <cfargument name="roll_nr" type="string">
        <cfargument name="metering" type="numeric">
        <cfargument name="height_shrinkage" type="numeric">
        <cfargument name="width_shringkage" type="numeric">
        <cfargument name="smooth" type="string">
        <cfargument name="color" type="string">
        <cfargument name="height_color" type="numeric">
        <cfargument name="width_color" type="numeric">
        <cfargument name="is_shrinkage_request" type="any">
		<cfargument name="fabric_width" type="any">
        <cflock name="#createUUID()#" timeout="20">
        <cftransaction>
        <cfquery name="query_add_fabric" datasource="#dsn3#" result="add_fabric">
            INSERT INTO TEXTILE_FABRIC
            (STRETCHING_TEST_ID
            ,PROJECT_ID
            ,OPPORTUNITY_ID
            ,PURCHASING_ID
            ,ROLL_NR
            ,METERING
            ,HEIGHT_SHRINKAGE
            ,WIDTH_SHRINKAGE
            ,SMOOTH
            ,COLOR
            ,HEIGHT_COLOR
            ,WIDTH_COLOR
            ,IS_SHRINKAGE_REQUEST
			,FABRIC_WIDTH
			)
                VALUES
            (
            <cfif isDefined("arguments.stretching_test_id") and len(arguments.stretching_test_id)>
            <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stretching_test_id#'>
            <cfelse>
            <cfqueryparam cfsqltype='CF_SQL_INTEGER' null="yes">
            </cfif>

            <cfif isDefined("arguments.project_id") and len(arguments.project_id)>
            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.project_id#'>
            <cfelse>
            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' null="yes">
            </cfif>

            <cfif isDefined("arguments.opportunity_id") and len(arguments.opportunity_id)>
            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.opportunity_id#'>
            <cfelse>
            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' null="yes">
            </cfif>

            <cfif isDefined("arguments.purchasing_id") and len(arguments.purchasing_id)>
            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.purchasing_id#'>
            <cfelse>
            ,<cfqueryparam cfsqltype='CF_SQL_INTEGER' null="yes">
            </cfif>

            ,<cfif isdefined("arguments.roll_nr") and len(arguments.roll_nr)><cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.roll_nr#'><cfelse>NULL</cfif>
            ,<cfif isdefined("arguments.metering") and len(arguments.metering)><cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.metering#'><cfelse>NULL</cfif>
            ,<cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.height_shrinkage#'>
            ,<cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.width_shringkage#'>
            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.smooth#'>
            ,<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.color#'>
            ,<cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.height_color#'>
            ,<cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.width_color#'>
            ,<cfif isdefined("arguments.is_shrinkage_request") and len(arguments.is_shrinkage_request)><cfqueryparam cfsqltype='CF_SQL_SMALLINT' value='#arguments.is_shrinkage_request#'><cfelse>0</cfif>
			,<cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.fabric_width#'>
            )
        </cfquery>
        </cftransaction>
        </cflock>
        <cfreturn add_fabric>
    </cffunction>

	 <cffunction name="delete_fabric" access="public" returntype="any">
		<cfargument name="stretching_test_id" type="any">
		<cfquery name="del_" datasource="#dsn3#" result="del_fabric">
			DELETE TEXTILE_FABRIC
			where STRETCHING_TEST_ID=#arguments.stretching_test_id#
		</cfquery>
	 
	 <cfreturn del_fabric>
    </cffunction>
	
    <cffunction name="update_fabric" access="public" returntype="any">
        <cfargument name="fabric_id" type="numeric">
        <cfargument name="project_id" type="any">
        <cfargument name="opportunity_id" type="any">
        <cfargument name="stretching_test_id" type="any">
        <cfargument name="purchasing_id" type="any">
        <cfargument name="roll_nr" type="any">
        <cfargument name="metering" type="any">
        <cfargument name="height_shrinkage" type="any">
        <cfargument name="width_shringkage" type="any">
        <cfargument name="smooth" type="any">
        <cfargument name="color" type="any">
        <cfargument name="height_color" type="any">
        <cfargument name="width_color" type="any">
        <cfargument name="is_shrinkage_request" type="any">
		<cfargument name="fabric_width" type="any">
        <cflock name="#createUUID()#" timeout="20">
        <cftransaction>
        <cfquery name="query_update_fabric" datasource="#dsn3#" result="update_fabric">
            UPDATE TEXTILE_FABRIC
            SET 
                
                <cfif isDefined("arguments.project_id") and len(arguments.project_id)>
                PROJECT_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.project_id#'>
                <cfelse>
                PROJECT_ID = PROJECT_ID
                </cfif>

                <cfif isDefined("arguments.opportunity_id") and len(arguments.opportunity_id)>
                ,OPPORTUNITY_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.opportunity_id#'>
                </cfif>

                <cfif isDefined("arguments.stretching_test_id") and len(arguments.stretching_test_id)>
                ,STRETCHING_TEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.stretching_test_id#'>
                </cfif>

                <cfif isDefined("arguments.purchasing_id") and len(arguments.purchasing_id)>
                ,PURCHASING_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.purchasing_id#'>
                </cfif>

                <cfif isDefined("arguments.roll_nr") and len(arguments.roll_nr)>
                ,ROLL_NR = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.roll_nr#'>
                </cfif>

                <cfif isDefined("arguments.metering") and len(arguments.metering)>
                ,METERING = <cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.metering#'>
                </cfif>

                <cfif isDefined("arguments.height_shrinkage") and len(arguments.height_shrinkage)>
                ,HEIGHT_SHRINKAGE = <cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.height_shrinkage#'>
                </cfif>

                <cfif isDefined("arguments.width_shringkage") and len(arguments.width_shringkage)>
                ,WIDTH_SHRINKAGE = <cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.width_shringkage#'>
                </cfif>

                <cfif isDefined("arguments.smooth") and len(arguments.smooth)>
                ,SMOOTH = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.smooth#'>
                </cfif>

                <cfif isDefined("arguments.color") and len(arguments.color)>
                ,COLOR = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.color#'>
                </cfif>

                <cfif isDefined("arguments.height_color") and len(arguments.height_color)>
                ,HEIGHT_COLOR = <cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.height_color#'>
                </cfif>

                <cfif isDefined("arguments.width_color") and len(arguments.width_color)>
                ,WIDTH_COLOR = <cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.width_color#'>
                </cfif>

                <cfif isDefined("arguments.is_shrinkage_request") and len(arguments.is_shrinkage_request)>
                ,IS_SHRINKAGE_REQUEST = <cfqueryparam cfsqltype='CF_SQL_SMALLINT' value='#arguments.is_shrinkage_request#'>
                </cfif>
                <cfif isDefined("arguments.fabric_width") and len(arguments.fabric_width)>
				,FABRIC_WIDTH=<cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.fabric_width#'>
				</cfif>
            WHERE FABRIC_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.fabric_id#'>
        </cfquery>
        </cftransaction>
        </cflock>
        <cfreturn update_fabric>
    </cffunction>

</cfcomponent>