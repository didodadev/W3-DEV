<cfcomponent>
    <cffunction name="updateGrid" access="remote" returntype="string" returnFormat="plain">
        <cfargument name="data" required="yes" type="any">
        <cfargument name="tableName" required="yes" type="string">
        <cfargument name="IDENTITYNAME" required="yes" type="string">
	    <cfset dsn = application.systemParam.systemParam().dsn>
        <cfset workcube_mode = application.systemParam.systemParam().workcube_mode>
        <cftry>
			<cfset gridData = DeserializeJSON(URLDecode(arguments.data, "utf-8"))>
            <cfset elementList = structKeyList(gridData,',')>
            <cfset sira = listFindNoCase(application.langsAllList,session.ep.language,',')>
            <cfset nonEditableAreas = 'uid,RECORD_DATE,RECORD_EMP,RECORD_IP,UPDATE_DATE,UPDATE_EMP,UPDATE_IP,#listGetAt(application.langArray["main"]["1165"],sira,"█")#,undefined'>
            <cfset nonEditableAreas = listAppend(nonEditableAreas,arguments.IDENTITYNAME,',')>
        
			<cfif StructKeyExists(gridData,arguments.IDENTITYNAME)>
                <cfquery name="updateRelatedTable" datasource="#dsn#">
                    UPDATE
                        #arguments.dataSource#.#arguments.tableName#
                    SET
                        <cfloop index="ind" from="1" to="#structCount(gridData)#">
                            <cfif not listFindNoCase(nonEditableAreas,listGetAt(elementList,ind,','),',')>
                                <cfif not isNumeric(gridData['#listGetAt(elementList,ind,',')#'])>
                                    <cfif gridData['#listGetAt(elementList,ind,',')#'] is 'YES'><!--- Checkbox seçili --->
                                        #listGetAt(elementList,ind,',')# = 1
                                    <cfelseif gridData['#listGetAt(elementList,ind,',')#'] is 'NO'><!--- Checkbox seçili değil--->
                                        #listGetAt(elementList,ind,',')# = 0
                                    <cfelse>
                                        #listGetAt(elementList,ind,',')# = '#gridData['#listGetAt(elementList,ind,',')#']#'
                                    </cfif>
                                <cfelse>
                                    #listGetAt(elementList,ind,',')# = #gridData['#listGetAt(elementList,ind,',')#']#
                                </cfif>,
                            </cfif>
                        </cfloop>
                        UPDATE_DATE = #now()#,
                        UPDATE_EMP = #session.ep.userid#,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    WHERE
                        #arguments.IDENTITYNAME# = #gridData['#arguments.IDENTITYNAME#']#
                </cfquery>
                <cfset identity = gridData['#arguments.IDENTITYNAME#']>
            <cfelse>
                <cfquery name="updateRelatedTable" datasource="#dsn#" result="r">
                    INSERT INTO
                        #arguments.dataSource#.#arguments.tableName#
                    (
                        <cfloop index="ind" from="1" to="#structCount(gridData)#">
                            <cfif not listFindNoCase(nonEditableAreas,listGetAt(elementList,ind,','),',')>
                                <cfif not isNumeric(gridData['#listGetAt(elementList,ind,',')#'])>
                                    <cfif gridData['#listGetAt(elementList,ind,',')#'] is 'YES'><!--- Checkbox seçili --->
                                        #listGetAt(elementList,ind,',')#
                                    <cfelseif gridData['#listGetAt(elementList,ind,',')#'] is 'NO'><!--- Checkbox seçili değil--->
                                        #listGetAt(elementList,ind,',')#
                                    <cfelse>
                                        #listGetAt(elementList,ind,',')#
                                    </cfif>
                                <cfelse>
                                    #listGetAt(elementList,ind,',')#
                                </cfif>,
                            </cfif>
                        </cfloop>
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                    )
                    VALUES
                    (
                        <cfloop index="ind" from="1" to="#structCount(gridData)#">
                            <cfif not listFindNoCase(nonEditableAreas,listGetAt(elementList,ind,','),',')>
                                <cfif not isNumeric(gridData['#listGetAt(elementList,ind,',')#'])>
                                    <cfif gridData['#listGetAt(elementList,ind,',')#'] is 'YES'><!--- Checkbox seçili --->
                                        1
                                    <cfelseif gridData['#listGetAt(elementList,ind,',')#'] is 'NO'><!--- Checkbox seçili değil--->
                                        0
                                    <cfelse>
                                        '#gridData['#listGetAt(elementList,ind,',')#']#'
                                    </cfif>
                                <cfelse>
                                    #gridData['#listGetAt(elementList,ind,',')#']#
                                </cfif>,
                            </cfif>
                        </cfloop>
                        #now()#,
                        #session.ep.userid#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    )
                </cfquery>
                <cfset identity = r.IDENTITYCOL>
            </cfif>
        
            <cfquery name="getUpdatedRow" datasource="#dsn#">
                SELECT
                	<cfloop index="ind" from="1" to="#structCount(gridData)#">
						<cfif not listFindNoCase(nonEditableAreas,listGetAt(elementList,ind,','),',')>
                            #listGetAt(elementList,ind,',')#,
                        </cfif>
                    </cfloop>
                    CONVERT(NVARCHAR(10),UPDATE_DATE,104) AS UPDATE_DATE,
                    CONVERT(NVARCHAR(10),RECORD_DATE,104) AS RECORD_DATE,
                    #arguments.IDENTITYNAME#
                FROM
                    #arguments.dataSource#.#arguments.tableName#
                WHERE
                    #arguments.IDENTITYNAME# = #identity#
            </cfquery>
            <cfset getUpdatedRow = application.functions.serializeJQXFormat(getUpdatedRow)>
            <cfreturn getUpdatedRow>
        <cfcatch>
        	<cfif workcube_mode eq 0>
            	<cfdump var="#cfcatch#">
<!---            	<cfoutput>Hata : #cfcatch.cause.message#</cfoutput>--->
        	</cfif>
        <cfreturn false></cfcatch>
        </cftry>
    </cffunction>
	<!--- delete --->
    <cffunction name="delGrid" access="remote" returntype="any" returnformat="plain">
        <cfargument name="data" required="yes" type="any">
        <cfargument name="tableName" required="yes" type="string">
        <cfargument name="IDENTITYNAME" required="yes" type="string">

	    <cfset dsn = application.systemParam.systemParam().dsn>
        <cfset gridData = DeserializeJSON(URLDecode(arguments.data, "utf-8"))>
        <cftry>
            <cfquery name="deleteRow" datasource="#dsn#" result="r">
                DELETE FROM
                    #arguments.dataSource#.#arguments.tableName#
                WHERE
                    #arguments.IDENTITYNAME# = #gridData['#arguments.IDENTITYNAME#']#
            </cfquery>
        	<cfreturn 'delTrue'>
        <cfcatch><cfreturn 'delFalse'></cfcatch>
        </cftry>
    </cffunction>
    <cffunction name="getGridTableInfo" access="remote" returntype="query">
        <cfargument name="tableName" required="yes" type="string">
        <cfargument name="dataSource" required="yes" type="string">
	    <cfset dsn = application.systemParam.systemParam().dsn>
        
		<cfquery name="getTableInfo" datasource="#dsn#">
            SELECT 
                C.NAME AS COLUMN_NAME,
                EP.VALUE AS COLUMN_DESC,
                t.NAME AS DATA_TYPE,
                SLT.ITEM_#session.ep.language# AS LANG,
                C.IS_IDENTITY
            FROM 
                sys.OBJECTS  O 
                JOIN SYS.COLUMNS C 
                    ON O.object_id = C.object_id
                LEFT JOIN sys.extended_properties EP
                    ON EP.major_id = O.object_id and EP.minor_id = C.column_id
                JOIN sys.types t 
                    ON t.user_type_id = C.user_type_id
                 LEFT JOIN #dsn#.SETUP_LANGUAGE_TR AS SLT 
                    ON SLT.DICTIONARY_ID = CAST(EP.value AS NVARCHAR(100)) AND ISNUMERIC(CAST(EP.value AS NVARCHAR(100)))  = 1
                 JOIN sys.schemas ss
                    ON ss.schema_id = O.schema_id 
            WHERE
                O.TYPE = 'U' AND 
                O.NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tableName#"> AND 
                ss.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.dataSource#">
        </cfquery>
        <cfreturn getTableInfo>
    </cffunction>
    <cffunction name="getGridTable" access="remote" returntype="query">
    	<cfargument name="columnList" required="yes" type="string">
        <cfargument name="tableName" required="yes" type="string">
        <cfargument name="dataSource" required="yes" type="string">
        
		<cfquery name="getData" datasource="#arguments.dataSource#">
            SELECT
                #arguments.columnList#
            FROM
                #arguments.tableName#
        </cfquery>
        <cfreturn getData>
    </cffunction>
    <cffunction name="updateGridBasketExtra" access="remote" returntype="string" returnFormat="plain">
        <cfargument name="data" required="yes" type="any">
        <cfargument name="dataSource" required="yes" type="any">
	    <cfset dsn = application.systemParam.systemParam().dsn>
        <cfset workcube_mode = application.systemParam.systemParam().workcube_mode>
        <cftry>
			<cfset gridData = DeserializeJSON(URLDecode(arguments.data, "utf-8"))>
            <cfset realBasketIdList = ''>
            <cfloop index="ind" from="1" to="#listlen(gridData.BASKET_ID,',')#">
            	<cfset realBasketIdList = listAppend(realBasketIdList,listFirst(listgetat(gridData.BASKET_ID,ind,','),'-'),',')>
            </cfloop>
            
			<cfif len(gridData.BASKET_INFO_TYPE_ID)>
            	<cfquery name="UPDATE_GRID_BASKET_EXTRA" datasource="#arguments.dataSource#">
                	UPDATE
                    	SETUP_BASKET_INFO_TYPES
                    SET
                    	BASKET_INFO_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gridData.BASKET_INFO_TYPE#">,
                        BASKET_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gridData.BASKET_DETAIL#">,
                        BASKET_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#realBasketIdList#">,
                        UPDATE_DATE = #now()#,
                        UPDATE_EMP = #session.ep.userid#,
                        UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    WHERE
                    	BASKET_INFO_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gridData.BASKET_INFO_TYPE_ID#">
                </cfquery>
                <cfset identity = gridData.BASKET_INFO_TYPE_ID>
            <cfelse>
            	<cfquery name="INSERT_GRID_BASKET_EXTRA" datasource="#arguments.dataSource#" result="r">
                	INSERT INTO
                    	SETUP_BASKET_INFO_TYPES
                    (
                    	BASKET_INFO_TYPE,
                        BASKET_DETAIL,
                        BASKET_ID,
                        RECORD_EMP,
                        RECORD_DATE,
                        RECORD_IP
                    )
                    VALUES
                    (
	                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#gridData.BASKET_INFO_TYPE#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#gridData.BASKET_DETAIL#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#realBasketIdList#">,
                        #session.ep.userid#,
                        #now()#,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                    )
                </cfquery>
	            <cfset identity = r.IDENTITYCOL>
            </cfif>
            <cfquery name="getUpdatedRow" datasource="#arguments.dataSource#">
                SELECT
                	BASKET_INFO_TYPE_ID,
                	BASKET_INFO_TYPE,
                    BASKET_DETAIL,
                    '#gridData.BASKET_ID#' AS BASKET_ID
                FROM
                    SETUP_BASKET_INFO_TYPES
                WHERE
                    BASKET_INFO_TYPE_ID = #identity#
            </cfquery>
            <cfset getUpdatedRow = application.functions.serializeJQXFormat(getUpdatedRow)>
            <cfreturn getUpdatedRow>
        <cfcatch>
        	<cfif workcube_mode eq 0>
            	<cfoutput>Hata : #cfcatch.cause.message#</cfoutput>
        	</cfif>
        <cfreturn false></cfcatch>
        </cftry>
    </cffunction>
    <cffunction name="delGridBasketExtra" access="remote" returntype="any" returnformat="plain">
        <cfargument name="data" required="yes" type="any">
        <cfargument name="dataSource" required="yes" type="string">

	    <cfset dsn = application.systemParam.systemParam().dsn>
        <cfset gridData = DeserializeJSON(URLDecode(arguments.data, "utf-8"))>
        <cftry>
            <cfquery name="deleteRow" datasource="#arguments.dataSource#" result="r">
                DELETE FROM
                    SETUP_BASKET_INFO_TYPES
                WHERE
                    BASKET_INFO_TYPE_ID = #gridData.BASKET_INFO_TYPE_ID#
            </cfquery>
        	<cfreturn 'delTrueBasketExtra'>
        <cfcatch><cfreturn 'delFalseBasketExtra'></cfcatch>
        </cftry>
    </cffunction>
</cfcomponent>