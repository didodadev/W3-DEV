<cfcomponent output="no">
	<cfset dsn = application.systemParam.systemParam().dsn>
    
    <!--- Test --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "Area Designer component is accessible.">
	</cffunction>
    
    <!--- Get Dictionary --->
    <cffunction name="getDictionary" access="remote" returntype="array" output="no">
    	<cfargument name="lang" type="string" required="yes">
        <cfargument name="word_set" type="string" required="yes">
    
    	<cfset lang_component = CreateObject("component", "language")>
		<cfreturn lang_component.getLanguageSet(arguments.lang, arguments.word_set)>
    </cffunction>
    
    <!--- Get Data --->
    <cffunction name="getData" access="remote" returntype="struct" output="no">
        <cfargument name="data_type" type="any" required="yes">
        <cfargument name="filter_id" type="any" required="no" default="">
        
        <cfset result = StructNew()>
        <cfset result["type"] = arguments.data_type>
        
        <cfif arguments.data_type eq 0>			<!-- Company -->
        	<cfquery name="get_data" datasource="#dsn#">
                SELECT COMP_ID AS data, NICK_NAME AS label FROM OUR_COMPANY ORDER BY label
            </cfquery>
        <cfelseif arguments.data_type eq 1>		<!-- Branch -->
        	<cfquery name="get_data" datasource="#dsn#">
                SELECT BRANCH_ID AS data, BRANCH_NAME AS label FROM BRANCH WHERE BRANCH_STATUS = 1 AND COMPANY_ID = #arguments.filter_id# ORDER BY label
            </cfquery>
        <cfelseif arguments.data_type eq 2>		<!-- Department -->
        	<cfquery name="get_data" datasource="#dsn#">
                SELECT DEPARTMENT_ID AS data, DEPARTMENT_HEAD AS label FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = #arguments.filter_id# ORDER BY label
            </cfquery>
        <cfelseif arguments.data_type eq 3>		<!-- Location -->
        	<cfquery name="get_data" datasource="#dsn#">
                SELECT LOCATION_ID AS data, COMMENT AS label FROM STOCKS_LOCATION WHERE STATUS = 1 AND DEPARTMENT_ID = #arguments.filter_id# ORDER BY label
            </cfquery>
        </cfif>
        <cfif isDefined("get_data")><cfset result["data"] = get_data></cfif>
        
        <cfreturn result>
    </cffunction>
    
    <!--- Load Design --->
    <cffunction name="loadDesign" access="remote" returntype="any" output="no">
    	<cfargument name="department_id" type="any" required="yes">
        <cfargument name="location_id" type="any" required="yes">
        
        <cfset result = StructNew()>
        <cfset result["info"] = StructNew()>
        
        <!-- Design info -->
        <cfquery name="get_design" datasource="#dsn#">
        	SELECT
            	DESIGN_ID		AS id,
                DIMENSIONS		AS dimensions
			FROM
            	STOCK_LOCATION_DESIGN
            WHERE
            	DEPARTMENT_ID = #arguments.department_id# AND
                LOCATION_ID = #arguments.location_id#
        </cfquery>
        
        <!-- Design items -->
        <cfif get_design.recordCount>
        	<cfquery name="get_design_items" datasource="#dsn#">
            	SELECT
                	ITEM_ID		AS id,
                    PARENT_ID	AS parentID,
                    TYPE		AS type,
                    COORDS		AS coordinates,
                    DIMENSIONS	AS dimensions,
                    TITLE		AS title,
                    TEXT		AS text,
                    OPTIONS		AS options
				FROM
                	STOCK_LOCATION_DESIGN_ITEMS
				WHERE
                	DESIGN_ID = #get_design.id#
                ORDER BY
                	id
            </cfquery>
            
            <cfset result.info["id"] = get_design.id>
            <cfset result.info["dimensions"] = get_design.dimensions>
            <cfset result["items"] = get_design_items>
        </cfif>
        
        <cfreturn result>
    </cffunction>
    
    <!--- Save Design --->
    <cffunction name="saveDesign" access="remote" returntype="any" output="no">
        <cfargument name="department_id" type="any" required="yes">
        <cfargument name="location_id" type="any" required="yes">
        <cfargument name="emp_id" type="any" required="yes">
        <cfargument name="info" type="any" required="yes">
        <cfargument name="items" type="any" required="yes">
        
        <cfset result = StructNew()>
        
        <cftry>
        	<!-- Save design -->
			<cfif isDefined("arguments.info.id") and len(arguments.info.id)>
                <cfquery name="update_design" datasource="#dsn#">        
                    UPDATE
                        STOCK_LOCATION_DESIGN
                    SET
                        DIMENSIONS = '#arguments.info.dimensions#',
                        UPDATE_EMP = #arguments.emp_id#,
                        UPDATE_DATE = #now()#,
                        UPDATE_IP = '#cgi.REMOTE_ADDR#'
                    WHERE
                        DESIGN_ID = #arguments.info.id#
                </cfquery>
            <cfelse>
                <cfquery name="save_design" datasource="#dsn#" result="queryResult">
                    INSERT INTO
                        STOCK_LOCATION_DESIGN
                        (
                        	DEPARTMENT_ID,
                            LOCATION_ID,
                            DIMENSIONS,
                            RECORD_EMP,
                            RECORD_DATE,
                            RECORD_IP
                        )
                        VALUES
                        (
	                        #arguments.department_id#,
                            #arguments.location_id#,
                            '#arguments.info.dimensions#',
                            #arguments.emp_id#,
                            #now()#,
                            '#cgi.REMOTE_ADDR#'
                        )
                </cfquery>
                <cfset arguments.info.id = queryResult.identityCol>
            </cfif>
            
            <!-- Save design item -->
            <cfset savedItems = "">
            <cfset newItems = ArrayNew(1)>
            <cfloop from="1" to="#ArrayLen(arguments.items)#" index="i">
                <cfset item = arguments.items[i]>
            
                <cfif isDefined("item.id") and len(item.id)>
                    <cfquery name="update_design_item" datasource="#dsn#">        
                        UPDATE
                            STOCK_LOCATION_DESIGN_ITEMS
                        SET
                        	<cfif isDefined("item.parentID") and len(item.parentID)>PARENT_ID = #item.parentID#,</cfif>
                            TYPE = #item.type#,
                            COORDS = '#item.coordinates#',
                            DIMENSIONS = '#item.dimensions#',
                            TITLE = '#item.title#',
                            TEXT = '#item.text#',
                            OPTIONS = '#item.options#'
                        WHERE
                            ITEM_ID = #item.id#
                    </cfquery>
                <cfelse>
                    <cfquery name="save_design_item" datasource="#dsn#" result="queryResult">
                        INSERT INTO
                            STOCK_LOCATION_DESIGN_ITEMS
                            (
	                            <cfif isDefined("item.parentID") and len(item.parentID)>PARENT_ID,</cfif>
                                DESIGN_ID,
                                TYPE,
                                COORDS,
                                DIMENSIONS,
                                TITLE,
                                TEXT,
                                OPTIONS
                            )
                            VALUES
                            (
                            	<cfif isDefined("item.parentID") and len(item.parentID)>#item.parentID#,</cfif>
                                #arguments.info.id#,
                                #item.type#,
                                '#item.coordinates#',
                                '#item.dimensions#',
                                '#item.title#',
                                '#item.text#',
                                '#item.options#'
                            )
                    </cfquery>
                    <cfset arguments.items[i].id = queryResult.identityCol>
                    <cfset newItems[ArrayLen(newItems) + 1] = arguments.items[i]>
                </cfif>
                
                <cfset savedItems = listAppend(savedItems, arguments.items[i].id, ",")>
            </cfloop>
            
            <!-- Update parent id fields -->
            <cfloop condition="ArrayLen(newItems) gt 0">
            	<cfloop from="1" to="#ArrayLen(newItems)#" index="i">
                	<cfset item = newItems[i]>
                	<cfif isDefined("item.parentGUID") and len(item.parentGUID)>
						<cfset parentItem = getItemByGUID(target_list: arguments.items, target_guid: item.parentGUID)>
                        <cfif isDefined("parentItem.id")>
                            <cfquery name="update_parent_id" datasource="#dsn#">
                                UPDATE STOCK_LOCATION_DESIGN_ITEMS SET PARENT_ID = #parentItem.id# WHERE ITEM_ID = #item.id#
                            </cfquery>
                            <cfset ArrayDeleteAt(newItems, i)>
                        </cfif>
                    <cfelse>
						<cfset ArrayDeleteAt(newItems, i)>
                    </cfif>
                    <cfif i gte ArrayLen(newItems)><cfbreak></cfif>
                </cfloop>
            </cfloop>
            
            <!-- Clear delete items -->
            <cfquery name="clear_deleted_items" datasource="#dsn#">
                DELETE FROM STOCK_LOCATION_DESIGN_ITEMS WHERE DESIGN_ID = #arguments.info.id# <cfif len(savedItems)> AND ITEM_ID NOT IN (#savedItems#)</cfif>
            </cfquery>
            
            <cfset result["info"] = arguments.info>
            <cfset result["items"] = arguments.items>

            <cfcatch>
            	<cfset cfcatchLine = cfcatch.tagcontext[1].raw_trace>
				<cfset cfcatchLine = right(cfcatchLine, len(listlast(cfcatchLine, ':')))>
                <cfset cfcatchLine = left(cfcatchLine, len(cfcatchLine) - 1)>
            	<cfthrow message="#cfcatch.Message#. Detail: #cfcatch.Detail#. Line: #cfcatchLine#">
            </cfcatch>
        </cftry>
        
        <cfreturn result>
	</cffunction>
    
    <!--- Get Item By GUID --->
    <cffunction name="getItemByGUID" access="private" returntype="any" output="no">
    	<cfargument name="target_list" type="any" required="yes">
    	<cfargument name="target_guid" type="any" required="yes">
        
        <cfloop from="1" to="#ArrayLen(arguments.target_list)#" index="n">
        	<cfif arguments.target_list[n].guid eq arguments.target_guid><cfreturn arguments.target_list[n]></cfif>
        </cfloop>
        
        <cfreturn StructNew()>
    </cffunction>
</cfcomponent>
