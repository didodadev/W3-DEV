<cfcomponent>
    <cfset dsn = application.systemParam.systemParam().dsn>
	<cfset dsn3 = "#dsn#_#session.ep.company_id#">
	<cffunction name="getWashType">
	   <cfquery name="get_wash_type" datasource="#dsn#_#session.ep.company_id#">
		   SELECT * FROM TEXTILE_WASH_TYPE
	   </cfquery>
	   <cfreturn get_wash_type>   
   </cffunction>
    <cffunction name="list_washplan" access="public" returntype="query">
        <cfargument name="plan_id" type="any">
        <cfargument name="req_id" type="any">
		<cfargument name="wash_type" type="any">
		<cfargument name="wash_value_id" type="any">
        <cfquery name="query_list_washplan" datasource="#dsn3#">
            SELECT  [ROW_ID]
					,TEXTILE_WASH_DEMAND.WASH_TYPE
					,TEXTILE_WASH_TYPE.WASH_TYPE as DR
					,[WASH_VALUE]
					,[PLAN_ID]
					,[REQUEST_ID]
					,[PRICE]
					,TEXTILE_WASH_TYPE.WASH_ID
					,TEXTILE_WASH_TYPE.SUBJECT
					,TEXTILE_WASH_TYPE.WASH_DETAIL
					,TEXTILE_WASH_TYPE.A_PRICE
			FROM 
				[TEXTILE_WASH_DEMAND],
				TEXTILE_WASH_TYPE
		 where	
		 TEXTILE_WASH_DEMAND.WASH_TYPE=TEXTILE_WASH_TYPE.WASH_TYPE_ID
		 AND TEXTILE_WASH_DEMAND.WASH_VALUE=TEXTILE_WASH_TYPE.WASH_ID 
            <cfif isDefined("arguments.plan_id") and len(arguments.plan_id) and arguments.plan_id gt 0>
            AND PLAN_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.plan_id#'>
            </cfif>

            <cfif isDefined("arguments.req_id") and len(arguments.req_id) and arguments.req_id gt 0>
            AND REQUEST_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
            </cfif>

            <cfif isDefined("arguments.wash_type") and len(arguments.wash_type)>
            AND WASH_TYPE = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.wash_type#'>
            </cfif>
			<cfif isDefined("arguments.wash_value_id") and len(arguments.wash_value_id)>
				AND WASH_VALUE = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.wash_value_id#'>
            </cfif>
            ORDER BY TEXTILE_WASH_DEMAND.REQUEST_ID DESC

        </cfquery>
        <cfreturn query_list_washplan>
    </cffunction>
	 <cffunction name="del_washplan" access="public" returntype="any">
		<cfargument name="plan_id" type="any">
        <cfargument name="req_id" type="any">
		<cfargument name="wash_type" type="any">
			<cfquery name="query_add_washplan" datasource="#dsn3#" result="del_washplan">	
				DELETE TEXTILE_WASH_DEMAND 
					WHERE 
						PLAN_ID=#arguments.plan_id# AND 
						REQUEST_ID=#arguments.req_id# AND
						WASH_TYPE=#arguments.wash_type#
			</cfquery>
			   <cfreturn del_washplan>
	 </cffunction>
    <cffunction name="add_washplan" access="public" returntype="any">
		<cfargument name="plan_id" type="any">
        <cfargument name="req_id" type="any">
		<cfargument name="wash_type" type="any">
		<cfargument name="wash_value_id" type="any">
		<cfargument name="price" type="any">

        <cflock name="#createUUID()#" timeout="20">
        <cftransaction>
				<cfquery name="query_add_washplan" datasource="#dsn3#" result="add_washplan">
					INSERT INTO TEXTILE_WASH_DEMAND
							(
							[WASH_TYPE]
						   ,[WASH_VALUE]
						   ,[PLAN_ID]
						   ,[REQUEST_ID]
						   ,[PRICE]
						   ,RECORD_DATE
						   ,RECORD_EMP
						   )
					 VALUES
						   (
							#arguments.wash_type#
						   ,#arguments.wash_value_id#
						   ,#arguments.plan_id#
						   ,#arguments.req_id#
						   ,#arguments.price#
						    ,#now()#
							,#session.ep.userid#
						   )
               </cfquery>
        </cftransaction>
        </cflock>
        <cfreturn add_washplan>
    </cffunction>

    <cffunction name="update_washplan" access="public" returntype="any">
		<cfargument name="plan_id" type="any">
        <cfargument name="req_id" type="any">
		<cfargument name="wash_type" type="any">
		<cfargument name="wash_value_id" type="any">
		<cfargument name="price" type="any">
        <cflock name="#createUUID()#" timeout="20">
        <cftransaction>


        <cfquery name="query_update_washplan" datasource="#dsn3#" result="update_washplan">
            UPDATE TEXTILE_WASH_DEMAND
            SET 
                [REQUEST_ID]=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.req_id#'>
            <cfif isDefined("arguments.price") and len(arguments.price)>
               ,[PRICE]=<cfqueryparam cfsqltype='CF_SQL_FLOAT' value='#arguments.price#'>
            </cfif>
            <cfif isDefined("arguments.wash_value_id") and len(arguments.wash_value_id)>
               ,[WASH_VALUE]=<cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.wash_value_id#'>
            </cfif>
            ,UPDATE_DATE=#now()#
            ,UPDATE_EMP=#session.ep.userid#
            WHERE 
				PLAN_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.plan_id#'> 
        </cfquery>
        </cftransaction>
        </cflock>
        <cfreturn update_washplan>
    </cffunction>
	
	
	<cffunction name="upd_washtype" access="public" returntype="any">
		<cfargument name="wash_id">
        <cfargument name="subject">


        <cfquery name="query_update_washtype" datasource="#dsn3#" result="update_washtype">
            UPDATE TEXTILE_WASH_TYPE
            SET 
                SUBJECT=<cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#arguments.subject#'>
            WHERE 
				WASH_ID = <cfqueryparam cfsqltype='CF_SQL_INTEGER' value='#arguments.wash_id#'> 
        </cfquery>

        <cfreturn update_washtype>
    </cffunction>

</cfcomponent>