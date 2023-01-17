<cfcomponent output="no" extends = "paramsControl">

    <cfset dsn = this.getdsn()>

    <cfset specer =  CreateObject("component", "/cfc/mmFunctions")>
    <cfset specer = specer.specer>
    
    <cfset treeListForSave = ArrayNew(1)>
    <cfset savedIndices = "">
    <cfset savedTreeIndices = "">
    
    <!--- TEST --->
	<cffunction name="test" access="remote" returntype="string">
		<cfreturn "Product Tree component is accessible.">
	</cffunction>
    
    <!--- GET LANGUAGE SET --->
    <cffunction name="getLangSet" access="remote" returntype="array" output="no">
    	<cfargument name="lang" type="string" required="yes">
        <cfargument name="numbers" type="string" required="yes">
    
    	<cftry>
	    	<cfset lang_component = CreateObject("component", "language")>
			<cfset result = lang_component.getLanguageSet(arguments.lang, arguments.numbers)>
            
	        <cfcatch type="any">
                <cfset cfcatchLine = cfcatch.tagcontext[1].raw_trace>
                <cfset cfcatchLine = right(cfcatchLine, len(listlast(cfcatchLine, ':')))>
                <cfset cfcatchLine = left(cfcatchLine, len(cfcatchLine) - 1)>
                <cfthrow message="#cfcatch.Message#\n\n#cfcatch.Detail#\n\nLine: #cfcatchLine#">
            </cfcatch>
        </cftry>
        
        <cfreturn result>
    </cffunction>
    
    <!--- GET COMMON INFORMATIONS --->
    <cffunction name="getCommonInformations" access="remote" returntype="any" output="no">
    	<cfargument name="position_code" type="any" required="yes">
        <cfargument name="company_id" type="any" required="yes">
    
    	<cfset result = StructNew()>
        <cfset result["stages"] = getAuthorizedStages(position_code: arguments.position_code, company_id: arguments.company_id)>
        <cfset result["questions"] = getAlternativeQuestions()>
        
        <cfreturn result>
    </cffunction>
    
    <!--- GET ALTERNATIVE QUESTIONS --->
    <cffunction name="getAlternativeQuestions" access="remote" returntype="any" output="no">
    	<cfquery name="get_alternative_questions" datasource="#dsn#">
        	SELECT QUESTION_ID AS id, QUESTION_NAME AS name FROM SETUP_ALTERNATIVE_QUESTIONS ORDER BY name
        </cfquery>
        
        <cfreturn get_alternative_questions>
    </cffunction>
    
    <!--- GET AUTHORIZED STAGES --->
    <cffunction name="getAuthorizedStages" access="remote" returntype="any" output="no">
    	<cfargument name="position_code" type="any" required="yes">
        <cfargument name="company_id" type="any" required="yes">
        
        <cfquery name="get_authorized_stages" datasource="#dsn#">
            SELECT 
                DISTINCT
                    PROCESS_TYPE_ROWS.PROCESS_ROW_ID AS id,
                    PROCESS_TYPE_ROWS.STAGE AS name,
                    PROCESS_TYPE_ROWS.LINE_NUMBER LINE_NUMBER,
                    PROCESS_TYPE_ROWS.DISPLAY_FILE_NAME
                FROM
                    PROCESS_TYPE PROCESS_TYPE,
                    PROCESS_TYPE_ROWS PROCESS_TYPE_ROWS,
                    PROCESS_TYPE_ROWS_POSID PROCESS_TYPE_ROWS_POSID,
                    EMPLOYEE_POSITIONS EMPLOYEE_POSITIONS,
					PROCESS_TYPE_OUR_COMPANY
                WHERE
                    PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID AND                  
                    CAST(PROCESS_TYPE.FACTION AS NVARCHAR(2500))+',' LIKE '%prod.add_product_tree,%' AND
                    EMPLOYEE_POSITIONS.POSITION_CODE = #arguments.position_code# AND 
                    PROCESS_TYPE_ROWS_POSID.PROCESS_ROW_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID AND
                    EMPLOYEE_POSITIONS.POSITION_ID = PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID AND
                    PROCESS_TYPE_ROWS.IS_EMPLOYEE = 0 AND
					PROCESS_TYPE_OUR_COMPANY.PROCESS_ID = PROCESS_TYPE.PROCESS_ID AND
					PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = #arguments.company_id#
            UNION
            
            SELECT 
                DISTINCT
                    PROCESS_TYPE_ROWS.PROCESS_ROW_ID AS id,
                    PROCESS_TYPE_ROWS.STAGE AS name,
                    PROCESS_TYPE_ROWS.LINE_NUMBER LINE_NUMBER,
                    PROCESS_TYPE_ROWS.DISPLAY_FILE_NAME
                FROM
                    PROCESS_TYPE PROCESS_TYPE,
                    PROCESS_TYPE_ROWS PROCESS_TYPE_ROWS,
					PROCESS_TYPE_OUR_COMPANY
                WHERE
                    PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID AND                  
                    CAST(PROCESS_TYPE.FACTION AS NVARCHAR(2500))+',' LIKE '%prod.add_product_tree,%' AND
                    PROCESS_TYPE_ROWS.IS_EMPLOYEE = 1 AND
					PROCESS_TYPE_OUR_COMPANY.PROCESS_ID = PROCESS_TYPE.PROCESS_ID AND
					PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = #arguments.company_id#
            UNION
                SELECT 
                    DISTINCT
                    PROCESS_TYPE_ROWS.PROCESS_ROW_ID AS id,
                    PROCESS_TYPE_ROWS.STAGE AS name,
                    PROCESS_TYPE_ROWS.LINE_NUMBER LINE_NUMBER,
                    PROCESS_TYPE_ROWS.DISPLAY_FILE_NAME
                FROM 	
                    PROCESS_TYPE PROCESS_TYPE,
                    PROCESS_TYPE_ROWS PROCESS_TYPE_ROWS,
                    PROCESS_TYPE_ROWS_WORKGRUOP PROCESS_TYPE_ROWS_WORKGRUOP,
                    PROCESS_TYPE_ROWS_POSID PROCESS_TYPE_ROWS_POSID,
					PROCESS_TYPE_OUR_COMPANY
                WHERE 
                    PROCESS_TYPE_ROWS.PROCESS_ID = PROCESS_TYPE.PROCESS_ID AND                    
                    CAST(PROCESS_TYPE.FACTION AS NVARCHAR(2500))+',' LIKE '%prod.add_product_tree,%' AND
                    PROCESS_TYPE_ROWS_WORKGRUOP.PROCESS_ROW_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID  AND 
                    PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID IS NOT NULL AND 
                    PROCESS_TYPE_ROWS_WORKGRUOP.MAINWORKGROUP_ID = PROCESS_TYPE_ROWS_POSID.WORKGROUP_ID AND 
                    PROCESS_TYPE_ROWS_POSID.PRO_POSITION_ID IN (#arguments.position_code#) AND
					PROCESS_TYPE_OUR_COMPANY.PROCESS_ID = PROCESS_TYPE.PROCESS_ID AND
					PROCESS_TYPE_OUR_COMPANY.OUR_COMPANY_ID = #arguments.company_id#
                ORDER BY 
                    LINE_NUMBER
        </cfquery>
        
        <cfreturn get_authorized_stages>
    </cffunction>
    
	<!--- GET DATA --->
    <cffunction name="getData" access="remote" returntype="any" output="no">
    	<cfargument name="company_id" type="any" required="yes">
	    <cfargument name="type" type="any" required="yes">
        <cfargument name="filter" type="any" required="no" default="">
        <cfargument name="stock_id" type="any" required="no" default="">
        <cfargument name="trans_id" type="any" required="no" default="">
        <cfargument name="spec_main_id" type="any" required="no" default="">
        
        <cfif arguments.type is "stocks">
            <cfquery name="get_data" datasource="#dsn#_#arguments.company_id#">
				SELECT
                    STOCKS.STOCK_ID 				AS stockID,
                    STOCKS.PRODUCT_ID 				AS productID,
                    STOCKS.STOCK_CODE				AS stockCode,
                    STOCKS.STOCK_CODE_2				AS stockCode2,
                    STOCKS.PRODUCT_NAME				AS productName,
                    (CASE WHEN (SELECT TOP (2) COUNT(STOCK_ID) FROM STOCKS WHERE PRODUCT_ID = PRODUCT_UNIT.PRODUCT_ID) <= 1 THEN ISNULL(ISNULL(STOCKS.PRODUCT_DETAIL2, STOCKS.PRODUCT_DETAIL), '') ELSE ISNULL(ISNULL(STOCKS.PROPERTY, STOCKS.PRODUCT_DETAIL2), '') END) AS productDetail, -- get product detail if sub stocks under 2, otherwise sub stocks's detail
                    STOCKS.PROPERTY					AS property,
                    STOCKS.IS_PROTOTYPE				AS isConfigure,
                    STOCKS.IS_PRODUCTION			AS isInProduction,
                    PRODUCT_UNIT.PRODUCT_UNIT_ID	AS productUnitID,
                    PRODUCT_UNIT.ADD_UNIT			AS unit,
                    (SELECT COUNT(WP.STOCK_ID) FROM WORKSTATIONS_PRODUCTS WP, PRODUCT_TREE PT WHERE PT.STOCK_ID = STOCKS.STOCK_ID AND (WP.STOCK_ID = PT.RELATED_ID OR WP.STOCK_ID = PT.STOCK_ID)) AS wsCount
				FROM 
                    STOCKS, 
                    PRODUCT_UNIT
				WHERE
                	STOCKS.PRODUCT_STATUS = 1 AND
                    PRODUCT_UNIT.PRODUCT_ID = STOCKS.PRODUCT_ID AND
                    PRODUCT_UNIT.IS_MAIN = 1
                    <cfif len(arguments.filter)>
	                    AND ( STOCKS.PRODUCT_NAME LIKE '%#arguments.filter#%' OR STOCKS.STOCK_CODE_2 LIKE '%#arguments.filter#%' OR STOCKS.STOCK_CODE LIKE '%#arguments.filter#%' )
					<cfelseif len(arguments.stock_id)>
                    	AND STOCKS.STOCK_ID = #arguments.stock_id#
                    </cfif>
				ORDER BY
                	STOCKS.PRODUCT_NAME
            </cfquery>
			<cfscript>
                QueryAddColumn(get_data, 'specMainID', 'VarChar', ArrayNew(1));
				QueryAddColumn(get_data, 'specMainName', 'VarChar', ArrayNew(1));
				QueryAddColumn(get_data, 'hasTree', 'Integer', ArrayNew(1));
            </cfscript>
            <cfloop query="get_data">
            	<cfif len(arguments.filter) or len(arguments.stock_id)>
                    <cfquery name="get_product_spec" datasource="#dsn#_#arguments.company_id#">
                        SELECT 
                            SM.SPECT_MAIN_ID,
                            SM.SPECT_MAIN_NAME,
                            T1.STOCK_ID 
                        FROM 
                                (SELECT 
                                    STOCK_ID,
                                    MAX(RECORD_DATE) AS RECORD_DATE
                                FROM 
                                    SPECT_MAIN SM 
                                WHERE 
                                     STOCK_ID IN (#get_data.stockID#)
                                GROUP BY  
                                    STOCK_ID
                                )
                            T1,
                            SPECT_MAIN SM
                        WHERE 
                            SM.STOCK_ID = T1.STOCK_ID 
                            AND (SM.RECORD_DATE = T1.RECORD_DATE OR SM.UPDATE_DATE = T1.RECORD_DATE)
                    </cfquery>
                    <cfset get_data.specMainID = get_product_spec.SPECT_MAIN_ID>
                    <cfset get_data.specMainName = get_product_spec.SPECT_MAIN_NAME>
				</cfif>
                
                <cfquery name="get_subs" datasource="#dsn#_#arguments.company_id#" maxrows="1">
                    SELECT PRODUCT_TREE_ID FROM PRODUCT_TREE WHERE STOCK_ID = #get_data.stockID#
                </cfquery>
				<cfif get_subs.recordcount>
                    <cfset get_data.hasTree = 1>
                <cfelse>
                    <cfset get_data.hasTree = 0>
                </cfif>
            </cfloop>               
		<cfelseif arguments.type is "transactions">
        	<cfquery name="get_data" datasource="#dsn#_#arguments.company_id#">
                SELECT
                    O.OPERATION_TYPE_ID 		AS transID,
                    O.OPERATION_TYPE 			AS transName,
                    O.O_HOUR					AS transHour,
                    O.O_MINUTE					AS transMinute,
                    0 AS wsCount /* performans sorunundan dolayı kapatıldı (SELECT COUNT(WP.OPERATION_TYPE_ID) FROM WORKSTATIONS_PRODUCTS WP, PRODUCT_TREE PT WHERE WP.OPERATION_TYPE_ID = PT.OPERATION_TYPE_ID AND WP.OPERATION_TYPE_ID = O.OPERATION_TYPE_ID) AS wsCount */
                FROM
                    OPERATION_TYPES O
                WHERE
                	1 = 1
                    <cfif len(arguments.filter)>
	                    AND O.OPERATION_TYPE LIKE '%#arguments.filter#%'
					<cfelseif len(arguments.trans_id)>
                    	AND O.OPERATION_TYPE_ID = #arguments.trans_id#
                    </cfif> 
            </cfquery>
        </cfif>
        
        <cfreturn get_data>
    </cffunction>
    
    <!--- GET SPEC LIST --->
    <cffunction name="getSpecList" access="remote" returntype="any" output="no">
    	<cfargument name="company_id" type="any" required="yes">
        <cfargument name="product_id" type="any" required="yes">
        
        <cfquery name="get_specs" datasource="#dsn#_#arguments.company_id#">
        	SELECT SPECT_MAIN_ID AS specMainID, SPECT_MAIN_NAME AS specMainName FROM SPECT_MAIN WHERE PRODUCT_ID = #arguments.product_id# ORDER BY SPECT_MAIN_ID
        </cfquery>
        
        <cfreturn get_specs>
    </cffunction>
    
    <!--- GET PRODUCT TREE --->
    <cffunction name="getTree" access="remote" returntype="any" output="yes">
        <cfargument name="company_id" type="any" required="yes">
        <cfargument name="stock_id" type="any" required="yes">
        
        <cfscript>
			tree = StructNew();           
            tree["subs"] = StructNew();
			tree["amount"] = 1;
            getSubItems(target_tree: tree["subs"], company_id: arguments.company_id, stock_id: arguments.stock_id);
		</cfscript>
        
        <cfreturn tree>
    </cffunction>
    
    <!--- GET SUB ITEMS --->
    <cffunction name="getSubItems" access="remote" returntype="any" output="yes">
        <cfargument name="target_tree" type="any" required="yes">
        <cfargument name="company_id" type="any" required="yes">
        <cfargument name="stock_id" type="any" required="no" default="">
        <cfargument name="product_tree_id" type="any" required="no" default="">
        
        <cfif len(arguments.stock_id) or len(arguments.product_tree_id)>
            <cfquery name="get_sub_items" datasource="#dsn#_#arguments.company_id#">
                SELECT
                    PT.PRODUCT_TREE_ID AS TREE_ID,
                    PT.RELATED_PRODUCT_TREE_ID,
                    PT.RELATED_ID,
                    PT.SPECT_MAIN_ID,
                    (
                        SELECT TOP (1)
                            SM.SPECT_MAIN_NAME
                        FROM 
                                (SELECT 
                                    STOCK_ID,
                                    MAX(RECORD_DATE) AS RECORD_DATE
                                FROM 
                                    SPECT_MAIN SM 
                                WHERE 
                                     PT.STOCK_ID IS NOT NULL AND STOCK_ID IN (PT.STOCK_ID) OR PT.RELATED_ID IS NOT NULL AND STOCK_ID IN (PT.RELATED_ID)
                                GROUP BY  
                                    STOCK_ID
                                )
                            T1,
                            SPECT_MAIN SM
                        WHERE 
                            SM.STOCK_ID = T1.STOCK_ID 
                            AND (SM.RECORD_DATE = T1.RECORD_DATE OR SM.UPDATE_DATE = T1.RECORD_DATE)
                    ) AS SPECT_MAIN_NAME,
                    PT.STOCK_ID,
                    (SELECT COUNT(STOCK_ID) FROM WORKSTATIONS_PRODUCTS WHERE STOCK_ID = PT.RELATED_ID OR STOCK_ID = PT.STOCK_ID) AS STOCK_WS_COUNT,
                    PT.OPERATION_TYPE_ID,
                    PT.OPERATION_DURATION,
                    (SELECT COUNT(OPERATION_TYPE_ID) FROM WORKSTATIONS_PRODUCTS WHERE OPERATION_TYPE_ID = PT.OPERATION_TYPE_ID) AS OPERATION_WS_COUNT,
                    PT.AMOUNT,
                    PT.LINE_NUMBER,
                    PT.FIRE_AMOUNT,
                    PT.FIRE_RATE,
                    PT.DETAIL,
                    PT.QUESTION_ID,
                    PT.IS_SEVK,
                    PT.IS_PHANTOM,
                    PT.IS_FREE_AMOUNT
                FROM
                    PRODUCT_TREE PT
                WHERE
                	1 = 1
                    <cfif len(arguments.stock_id)>
                    	AND PT.STOCK_ID = #arguments.stock_id#
					<cfelseif len(arguments.product_tree_id)>
                    	AND PT.RELATED_PRODUCT_TREE_ID = #arguments.product_tree_id#
					</cfif>
				ORDER BY
                	PT.PRODUCT_TREE_ID
            </cfquery>
            <cfif isDefined("get_sub_items")>
            	<cfloop query="get_sub_items">            
                <cfscript>
					// If an item has related id, it means that item is a stock. Otherwise it is a transaction (operation)
					if (len(RELATED_ID))
					{
	                    info = getData(company_id: arguments.company_id, type: "stocks", stock_id: RELATED_ID, spec_main_id: SPECT_MAIN_ID);
					} else if (len(OPERATION_TYPE_ID)){
						info = getData(company_id: arguments.company_id, type: "transactions", trans_id: OPERATION_TYPE_ID);
					}
					
					if (isDefined('info'))
					{
						item = StructNew();
						arguments.target_tree["sub_#currentrow#"] = item;
						
						if (len(RELATED_ID))
						{
							item["type"] = "stocks";
							item["stockID"] = info.stockID;
							item["productID"] = info.productID;
							item["stockCode"] = info.stockCode;
							item["stockCode2"] = info.stockCode2;
							item["productUnitID"] = info.productUnitID;
							item["productName"] = info.productName;
							item["productDetail"] = info.productDetail;
							item["property"] = info.property;
							item["isConfigure"] = info.isConfigure;
							item["isInProduction"] = info.isInProduction;
							item["specMainID"] = SPECT_MAIN_ID;
							item["specMainName"] = SPECT_MAIN_NAME;
							item["amount"] = AMOUNT;
							item["unit"] = info.unit;
							item["hasTree"] = info.hasTree;
							item["productTreeID"] = TREE_ID;
							item["wsCount"] = STOCK_WS_COUNT;
							item["lineNumber"] = LINE_NUMBER;
							item["wastageRate"] = FIRE_RATE;
							item["wastageAmount"] = FIRE_AMOUNT;
							item["description"] = DETAIL;
							item["questionID"] = QUESTION_ID;
							item["combineDuringForwarding"] = IS_SEVK;
							item["isAmountFree"] = IS_FREE_AMOUNT;
							item["isPhantom"] = IS_PHANTOM;
						} else if (len(OPERATION_TYPE_ID)){
							item["type"] = "transactions";
							item["transID"] = info.transID;
							item["transName"] = info.transName;
							item["transDuration"] = OPERATION_DURATION;
							item["productTreeID"] = TREE_ID;
							item["hasTree"] = 0;
							item["wsCount"] = OPERATION_WS_COUNT;
							item["lineNumber"] = LINE_NUMBER;
							item["description"] = DETAIL;
						}
						
						if (isDefined('item.type') and len(item.type))
						{
							item["subs"] = StructNew();
							if (len(RELATED_ID))
							{
								getSubItems(target_tree: item["subs"], company_id: arguments.company_id, stock_id: RELATED_ID);
							} else if (len(OPERATION_TYPE_ID)){
								getSubItems(target_tree: item["subs"], company_id: arguments.company_id, product_tree_id: TREE_ID);
							}
						}
					}
                </cfscript>
            </cfloop>
            </cfif>
        </cfif>
        
        <cfreturn arguments.target_tree>
    </cffunction>
        
    <!--- SAVE TREE --->
    <cffunction name="saveTree" access="remote" returntype="any" output="no">
    	<cfargument name="company_id" type="any" required="yes">
        <cfargument name="tree_list" type="array" required="yes">
        <cfargument name="delete_list" type="array" required="yes">
        <cfargument name="params" type="any" required="yes">
        
        <cftransaction>
			<cfset savedIndices = "">
            <cfset treeListForSave = tree_list>
            
            <cfset result = StructNew()>
            <cftry>
            	<cfloop from="1" to="#ArrayLen(delete_list)#" index="i">
                	<cfquery name="delete_item" datasource="#dsn#_#arguments.company_id#">
                        DELETE FROM PRODUCT_TREE WHERE PRODUCT_TREE_ID = #delete_list[i]#
                    </cfquery>
                </cfloop>
                <cfloop from="1" to="#ArrayLen(tree_list)#" index="i">
                    <cfscript>
                        tree = tree_list[i];
                        tree_list[i] = saveItem(company_id: arguments.company_id, item_data: tree, item_is_tree: 1, params: arguments.params, tree_list_index: i);
                    </cfscript>
                </cfloop>
                <cfcatch type="any">
                	<cfset result["error"] = "#cfcatch.Message#\n\nDetail: #cfcatch.Detail#\n\nRaw Trace: #cfcatch.tagcontext[1].raw_trace#">
                </cfcatch>
            </cftry>
            <cfset result["tree"] = tree_list>
        </cftransaction>
        
    	<cfreturn result>
    </cffunction>
    
    <!--- SAVE ITEM --->
    <cffunction name="saveItem" access="private" returntype="any" output="no">
    	<cfargument name="company_id" type="any" required="yes">
    	<cfargument name="item_data" type="any" required="yes">
        <cfargument name="item_is_tree" type="boolean" required="yes">
        <cfargument name="stock_id" type="any" required="no" default="">
        <cfargument name="params" type="any" required="yes">
        <cfargument name="tree_list_index" type="any" required="no" default="-1">
    
        <cfif not isDefined('item_data.amount') or not len(item_data.amount)><cfset item_data.amount = 1></cfif>
        <!---
		<cfif not isDefined('item_data.isConfigure') or not len(item_data.isConfigure)>
            <cfset item_data.isConfigure = 0>
        <cfelse>
            <cfif item_data.isConfigure is "true"><cfset item_data.isConfigure = 1><cfelse><cfset item_data.isConfigure = 0></cfif>
        </cfif>
        --->
        <!-- Make isConfigure value zero as default -->
        <cfset item_data.isConfigure = 0>
        <cfif not isDefined('item_data.isInProduction') or not len(item_data.isInProduction)>
            <cfset item_data.isInProduction = 0>
        <cfelse>
            <cfif item_data.isInProduction is "true"><cfset item_data.isInProduction = 1><cfelse><cfset item_data.isInProduction = 0></cfif>
        </cfif>
        
        <!-- Reset relatedProductTreeID property under transactions against the probability of the item can be moved. Because this property would already saved when sub items of the transaction are saving -->
        <!---<cfif item_data.type neq "transactions" and isDefined("item_data.productTreeID") and len(item_data.productTreeID)>--->
        <cfif isDefined("item_data.productTreeID") and len(item_data.productTreeID)>
        	<cfquery name="reset_item_transaction_relation" datasource="#dsn#_#arguments.company_id#">
                UPDATE PRODUCT_TREE SET RELATED_PRODUCT_TREE_ID = NULL WHERE PRODUCT_TREE_ID = #item_data.productTreeID#
            </cfquery>
		</cfif>
        
        <cfset itemIndex = ListFind(savedIndices, item_data.listIndex, ',')>
        <cfif itemIndex eq 0> 
        	<cfset savedIndices = ListAppend(savedIndices, item_data.listIndex, ',')>
			<cfset savedTreeIndices = ListAppend(savedTreeIndices, tree_list_index, ',')>
                       
            <cfif item_is_tree eq 1>
            	<cfloop from="1" to="#ArrayLen(item_data.subs)#" index="s">
                    <cfscript>
						if (isDefined('item_data.stockID') and len(item_data.stockID))
						{
                        	item_data.subs[s] = saveItem(company_id: arguments.company_id, item_data: item_data.subs[s], item_is_tree: 0, stock_id: item_data.stockID, params: arguments.params);
						} else {
							item_data.subs[s] = saveItem(company_id: arguments.company_id, item_data: item_data.subs[s], item_is_tree: 0, params: arguments.params);
						}
                    </cfscript>
                </cfloop>
                <cfif isDefined('item_data.orderList')>
                    <cfloop from="1" to="#ArrayLen(item_data.orderList)#" index="t">
                        <cfscript>
							orderItemIndex = ListFind(savedIndices, item_data.orderList[t].listIndex, ',');
                            if (item_data.orderList[t].type is "stocks" and item_data.orderList[t].hasTree eq 1 and orderItemIndex neq 0)
							{
								item_data.orderList[t]["specMainID"] = treeListForSave[listgetat(savedTreeIndices, orderItemIndex, ",")].specMainID;
							} 
                        </cfscript>
                    </cfloop>
				</cfif>
                
                <cfif item_data.type eq "stocks" and item_data.isInProduction eq 1 and item_data.locked neq 1>
	                <cfset new_spec = createMainSpec(target_company_id: arguments.company_id, target_item_data: item_data, params: arguments.params)>
                    <cfset item_data["specMainID"] = new_spec>
                </cfif>
			<cfelseif item_is_tree eq 0>
            	<cfset item_data["productTreeID"] = pushToProductTree(company_id: arguments.company_id, item: item_data, item_is_tree: item_data.hasTree, stock_id: arguments.stock_id, product_tree_id: item_data.productTreeID)>
			</cfif>
		<cfelse>
	        <cfset savedItemBefore = treeListForSave[listgetat(savedTreeIndices, itemIndex, ",")]>
            <cfset item_data["productTreeID"] = pushToProductTree(company_id: arguments.company_id, item: item_data, item_is_tree: item_data.hasTree, stock_id: arguments.stock_id, product_tree_id: item_data.productTreeID)>
            
            <cfif item_data.hasTree eq 1 and item_data.type is "stocks">
            	<cfset item_data["specMainID"] = savedItemBefore.specMainID>
                <cfif isDefined('item_data.specMainID') and len(item_data.specMainID) and isDefined('item_data.productTreeID') and len(item_data.productTreeID)>
                    <cfquery name="update_item" datasource="#dsn#_#arguments.company_id#">
                        UPDATE PRODUCT_TREE SET SPECT_MAIN_ID = #item_data.specMainID# WHERE PRODUCT_TREE_ID = #item_data.productTreeID#
                    </cfquery>
                </cfif>
			</cfif>
            
			<cfif item_data.type is "transactions">
                <cfloop from="1" to="#ArrayLen(savedItemBefore.subs)#" index="s">
                    <cfquery name="update_sub_item" datasource="#dsn#_#arguments.company_id#">
                    	UPDATE PRODUCT_TREE SET RELATED_PRODUCT_TREE_ID = #item_data.productTreeID# WHERE PRODUCT_TREE_ID = #savedItemBefore.subs[s].productTreeID#
                    </cfquery>
                </cfloop>
            </cfif>
        </cfif>
        
    	<cfreturn item_data>
    </cffunction>
    
    <!--- PUSH ITEM TO PRODUCT TREE --->
    <cffunction name="pushToProductTree" access="private" returntype="any" output="no">
    	<cfargument name="company_id" type="any" required="yes">
        <cfargument name="item" type="any" required="yes">
        <cfargument name="item_is_tree" type="any" required="yes">
        <cfargument name="stock_id" type="any" required="no" default="NULL">
        <cfargument name="product_tree_id" type="any" required="no" default="">
        
        <cfif isDefined('arguments.product_tree_id') and len(arguments.product_tree_id)>
            <cfquery name="update_item" datasource="#dsn#_#arguments.company_id#">
            	UPDATE
                	PRODUCT_TREE
				SET
                	IS_TREE = #item_is_tree#,
                    STOCK_ID = '#arguments.stock_id#',
                    <cfif item.type is "stocks">PRODUCT_ID = #item.productID#,</cfif>
                    <cfif item.type is "stocks">RELATED_ID = #item.stockID#,</cfif>
                    <cfif item.type is "stocks" and isDefined('item.specMainID') and len(item.specMainID)>SPECT_MAIN_ID = #item.specMainID#,</cfif>
                    <cfif item.type is "transactions">OPERATION_TYPE_ID = #item.transID#,</cfif>
                    <cfif item.type is "transactions">OPERATION_DURATION = '#item.transDuration#',</cfif>
                    <cfif isDefined('item.productUnitID') and len(item.productUnitID)>UNIT_ID = #item.productUnitID#,</cfif>
                    <cfif isDefined('item.mainStockID') and len(item.mainStockID)>MAIN_STOCK_ID = #item.mainStockID#,</cfif>
                    <cfif isDefined('item.processStage') and len(item.processStage)>PROCESS_STAGE = #item.processStage#,</cfif>
                    <cfif isDefined('item.lineNumber') and len(item.lineNumber)>LINE_NUMBER = #item.lineNumber#,</cfif>
					<cfif isDefined('item.wastageAmount') and len(item.wastageAmount)>FIRE_AMOUNT = #item.wastageAmount#,<cfelseif isDefined('item.wastageAmount') and not len(item.wastageAmount)>FIRE_AMOUNT = NULL,</cfif>
                    <cfif isDefined('item.wastageRate') and len(item.wastageRate)>FIRE_RATE = #item.wastageRate#,<cfelseif isDefined('item.wastageRate') and not len(item.wastageRate)>FIRE_RATE = NULL,</cfif>
                    <cfif isDefined('item.description') and len(item.description)>DETAIL = '#item.description#',</cfif>
                    <cfif isDefined('item.questionID') and len(item.questionID)>QUESTION_ID = #item.questionID#,</cfif>
                    <cfif isDefined('item.isAmountFree') and len(item.isAmountFree)>IS_FREE_AMOUNT = #item.isAmountFree#,</cfif>
                    <cfif isDefined('item.combineDuringForwarding') and len(item.combineDuringForwarding)>IS_SEVK = #item.combineDuringForwarding#,</cfif>
                    <cfif isDefined('item.isPhantom') and len(item.isPhantom)>IS_PHANTOM = #item.isPhantom#,</cfif>
                    IS_CONFIGURE = #item.isConfigure#,
                    AMOUNT = #item.amount#
				WHERE
                	PRODUCT_TREE_ID = #arguments.product_tree_id#
            </cfquery>
        <cfelse>
        	<cfquery name="push_item" datasource="#dsn#_#arguments.company_id#">			
                INSERT INTO
                    PRODUCT_TREE
                    (
                        IS_TREE,
                        STOCK_ID,
                        <cfif item.type is "stocks">PRODUCT_ID,</cfif>
                        <cfif item.type is "stocks">RELATED_ID,</cfif>
                        <cfif item.type is "stocks" and isDefined('item.specMainID') and len(item.specMainID)>SPECT_MAIN_ID,</cfif>
                        <cfif item.type is "transactions">OPERATION_TYPE_ID,</cfif>
                        <cfif item.type is "transactions">OPERATION_DURATION,</cfif>
                        <cfif isDefined('item.productUnitID') and len(item.productUnitID)>UNIT_ID,</cfif>
                        <cfif isDefined('item.mainStockID') and len(item.mainStockID)>MAIN_STOCK_ID,</cfif>
                        <cfif isDefined('item.processStage') and len(item.processStage)>PROCESS_STAGE,</cfif>
                        <cfif isDefined('item.lineNumber') and len(item.lineNumber)>LINE_NUMBER,</cfif>
						<cfif isDefined('item.wastageAmount')>FIRE_AMOUNT,</cfif>
                        <cfif isDefined('item.wastageRate')>FIRE_RATE,</cfif>
                        <cfif isDefined('item.description') and len(item.description)>DETAIL,</cfif>
                        <cfif isDefined('item.questionID') and len(item.questionID)>QUESTION_ID,</cfif>
                        <cfif isDefined('item.isAmountFree') and len(item.isAmountFree)>IS_FREE_AMOUNT,</cfif>
                        <cfif isDefined('item.combineDuringForwarding') and len(item.combineDuringForwarding)>IS_SEVK,</cfif>
                        <cfif isDefined('item.isPhantom') and len(item.isPhantom)>IS_PHANTOM,</cfif>
                        IS_CONFIGURE,
                        AMOUNT
                    )
                    VALUES
                    (
                        #item_is_tree#,
                        '#arguments.stock_id#',
                        <cfif item.type is "stocks">#item.productID#,</cfif>
                        <cfif item.type is "stocks">#item.stockID#,</cfif>
                        <cfif item.type is "stocks" and isDefined('item.specMainID') and len(item.specMainID)>#item.specMainID#,</cfif>
                        <cfif item.type is "transactions">#item.transID#,</cfif>
                        <cfif item.type is "transactions">'#item.transDuration#',</cfif>
                        <cfif isDefined('item.productUnitID') and len(item.productUnitID)>#item.productUnitID#,</cfif>
                        <cfif isDefined('item.mainStockID') and len(item.mainStockID)>#item.mainStockID#,</cfif>
                        <cfif isDefined('item.processStage') and len(item.processStage)>#item.processStage#,</cfif>
                        <cfif isDefined('item.lineNumber') and len(item.lineNumber)>#item.lineNumber#,</cfif>
						<cfif isDefined('item.wastageAmount') and len(item.wastageAmount)>#item.wastageAmount#,<cfelseif isDefined('item.wastageAmount') and not len(item.wastageAmount)>NULL,</cfif>
	                    <cfif isDefined('item.wastageRate') and len(item.wastageRate)>#item.wastageRate#,<cfelseif isDefined('item.wastageRate') and not len(item.wastageRate)>NULL,</cfif>
                        <cfif isDefined('item.description') and len(item.description)>'#item.description#',</cfif>
                        <cfif isDefined('item.questionID') and len(item.questionID)>#item.questionID#,</cfif>
                        <cfif isDefined('item.isAmountFree') and len(item.isAmountFree)>#item.isAmountFree#,</cfif>
                        <cfif isDefined('item.combineDuringForwarding') and len(item.combineDuringForwarding)>#item.combineDuringForwarding#,</cfif>
                        <cfif isDefined('item.isPhantom') and len(item.isPhantom)>#item.isPhantom#,</cfif>
                        #item.isConfigure#,
                        #item.amount#
                    )
            </cfquery>
            <cfquery name="get_last_saved" datasource="#dsn#_#arguments.company_id#">
                SELECT MAX(PRODUCT_TREE_ID) AS TREE_ID FROM PRODUCT_TREE
            </cfquery>
            <cfset arguments.product_tree_id = get_last_saved.TREE_ID>
		</cfif>
        
        <cfreturn arguments.product_tree_id>
    </cffunction>
    
    <!--- CREATE MAIN SPEC --->
    <!-- Mahmut 'un yaptigi objects/query/add_spect_main_ver.cfm 'den alinti ve uyarlama fonksiyon -->
    <cffunction name="createMainSpec" access="private" returntype="any" output="no">
    	<cfargument name="target_company_id" type="any" required="yes">
        <cfargument name="target_item_data" type="any" required="yes">
        <cfargument name="params" type="any" required="yes">
        
        <cfset dsn1_alias = "#dsn#_product">
        <cfset dsn2_alias = "#dsn#_#arguments.params.period_year#_#arguments.target_company_id#">
        <cfset dsn3 = "#dsn#_#arguments.target_company_id#">
        <cfset dsn3_alias = "#dsn3#">
        <cfset attributes.fuseaction = "flash">
        <cfset session.ep.userid = arguments.params.userID>
        <cfset session.ep.money = arguments.params.money>
  		<cfset session.ep.money2 = arguments.params.money2>
  		<cfset session_base.money = session.ep.money>
  		<cfset session_base.money2 = session.ep.money2>
  		<cfset session_base.userid = arguments.params.userid>
  		<cfset session_base.company_id = arguments.target_company_id>
		<cfset session_base.period_id = arguments.params.period_id>
        
        <cfquery name="GET_MAIN_PROD" datasource="#dsn#_#arguments.target_company_id#">
        	SELECT 
                STOCKS.PRODUCT_ID,
                STOCKS.PRODUCT_NAME,
                STOCKS.PROPERTY
            FROM 
                STOCKS
            WHERE 
                STOCK_ID = #target_item_data.stockID#
        </cfquery>
		
        <cfscript>
			target_list = ArrayNew(1);
			
			for (i = 1; i lte ArrayLen(target_item_data.subs); i++)
			{
				if (target_item_data.subs[i].type eq "stocks")
				{
					target_item_data.subs[i].propertyType = 0;	
				} else if (target_item_data.subs[i].type eq "transactions"){
					target_item_data.subs[i].propertyType = 3;
				}
				
				ArrayAppend(target_list, target_item_data.subs[i]);
			}
			
			if (isDefined('target_item_data.orderList'))
			{
				for (i = 1; i lte ArrayLen(target_item_data.orderList); i++)
				{
					target_item_data.orderList[i].propertyType = 4;
					ArrayAppend(target_list, target_item_data.orderList[i]);
				}	
			}
		
			main_stock_id = target_item_data.stockID;
			main_product_id = GET_MAIN_PROD.PRODUCT_ID;
			spec_name = '#GET_MAIN_PROD.PRODUCT_NAME# #GET_MAIN_PROD.PROPERTY#';
			row_count = ArrayLen(target_list);
			stock_id_list = "";
			related_tree_id_list = '';
			operation_type_id_list = '';
			product_id_list = "";
			product_name_list= "";
			amount_list = "";
			sevk_list = "";
			configure_list = "";
			is_property_list = "";
			property_id_list = "";
			variation_id_list = "";
			total_min_list = "";
			total_max_list = "";
			tolerance_list = "";
			line_number_list = "";
			related_spect_main_id_list = "";
			wastage_amount_list = "";
			wastage_rate_list = "";
			description_list = "";
			question_list = "";
			amount_free_list = "";
			phantom_list = "";
			
			for(i = 1; i lte row_count; i = i + 1)
			{
				sub_item = target_list[i];
				if (sub_item.type eq "stocks")
				{
				
					if (sub_item.stockID gt 0) stock_id_list = listappend(stock_id_list, sub_item.stockID, ',');
					if (sub_item.productID gt 0) product_id_list = listappend(product_id_list, sub_item.productID, ',');
					if (isDefined('sub_item.amount') and sub_item.amount gt 0)
					{
						amount_list = listappend(amount_list, sub_item.amount, ',');
					} else {
						amount_list = listappend(amount_list, 1, ',');
					}
					if (isDefined('sub_item.property') and len(sub_item.property))
					{
						product_name_list = listappend(product_name_list, '#sub_item.productName# #sub_item.property#', '@');
					} else {
						product_name_list = listappend(product_name_list, '#sub_item.productName#', '@');
					}
					
					if (isDefined("sub_item.combineDuringForwarding") and len(sub_item.combineDuringForwarding))
					{
						sevk_list = listappend(sevk_list, sub_item.combineDuringForwarding, ',');
					} else {
						sevk_list = listappend(sevk_list, 0, ',');
					}
					
					/*if (GET_TREE_STOCKS.IS_CONFIGURE[i] eq 1)
						configure_list = listappend(configure_list,1,',');
					else
						configure_list = listappend(configure_list,0,',');*/
					configure_list = listappend(configure_list, 0, ',');
					if (isDefined('sub_item.specMainID') and len(sub_item.specMainID) and sub_item.specMainID gt 0)
					{
						related_spect_main_id_list = ListAppend(related_spect_main_id_list, sub_item.specMainID, ',');
					} else {
						related_spect_main_id_list = ListAppend(related_spect_main_id_list, 0, ',');
					}
					is_property_list = listappend(is_property_list, sub_item.propertyType, ',');
					property_id_list = listappend(property_id_list, 0, ',');
					variation_id_list = listappend(variation_id_list, 0, ',');
					total_min_list = listappend(total_min_list, '-', ',');
					total_max_list = listappend(total_max_list, '-', ',');
					tolerance_list = listappend(tolerance_list, '-', ',');
					//related_tree_id_list = listappend(related_tree_id_list, 0, ',');
					operation_type_id_list = listappend(operation_type_id_list, 0, ',');
					if (isDefined('sub_item.productTreeID'))
					{
						related_tree_id_list = listappend(related_tree_id_list, sub_item.productTreeID, ',');
					} else {
						related_tree_id_list = listappend(related_tree_id_list, 0, ',');
					}
					/*if(isdefined('arguments.is_show_line_number') and arguments.is_show_line_number eq 1 and len(GET_TREE_STOCKS.LINE_NUMBER[i]))
						line_number_list = listappend(line_number_list,GET_TREE_STOCKS.LINE_NUMBER[i],',');
					else
						line_number_list = listappend(line_number_list,0,',');*/
						
					if (isDefined("sub_item.lineNumber") and len(sub_item.lineNumber))
					{
						line_number_list = listappend(line_number_list, sub_item.lineNumber, ',');
					} else {
						line_number_list = listappend(line_number_list, 0, ',');
					}
					
					if (isDefined("sub_item.wastageAmount") and len(sub_item.wastageAmount))
					{
						wastage_amount_list = listappend(wastage_amount_list, sub_item.wastageAmount, ',');
					} else {
						wastage_amount_list = listappend(wastage_amount_list, 0, ',');
					}
					
					if (isDefined("sub_item.wastageRate") and len(sub_item.wastageRate))
					{
						wastage_rate_list = listappend(wastage_rate_list, sub_item.wastageRate, ',');
					} else {
						wastage_rate_list = listappend(wastage_rate_list, 0, ',');
					}
					
					if (isDefined("sub_item.description") and len(sub_item.description))
					{
						description_list = listappend(description_list, sub_item.description, ',');
					} else {
						description_list = listappend(description_list, 0, ',');
					}
					
					if (isDefined("sub_item.questionID") and len(sub_item.questionID))
					{
						question_list = listappend(question_list, sub_item.questionID, ',');
					} else {
						question_list = listappend(question_list, 0, ',');
					}
					
					if (isDefined("sub_item.isAmountFree") and len(sub_item.isAmountFree))
					{
						amount_free_list = listappend(amount_free_list, sub_item.isAmountFree, ',');
					} else {
						amount_free_list = listappend(amount_free_list, 0, ',');
					}
					
					if (isDefined("sub_item.isPhantom") and len(sub_item.isPhantom))
					{
						phantom_list = listappend(phantom_list, sub_item.isPhantom, ',');
					} else {
						phantom_list = listappend(phantom_list, 0, ',');
					}
				} else if (sub_item.type eq "transactions"){
					stock_id_list = listappend(stock_id_list, 0, ',');
					product_id_list = listappend(product_id_list, 0, ',');
					amount_list = listappend(amount_list, 1, ',');
					product_name_list = listappend(product_name_list, '#sub_item.transName#', '@');
					sevk_list = listappend(sevk_list, 0, ',');
					configure_list = listappend(configure_list, 1, ',');
					related_spect_main_id_list = ListAppend(related_spect_main_id_list, 0, ',');
					is_property_list = listappend(is_property_list, sub_item.propertyType, ',');	//0 ise sarf 1 ise özellik 2 ise fire 3 ise operasyon, 4 ise operasyonun altındaki bileşenler..
					property_id_list = listappend(property_id_list, 0, ',');
					variation_id_list = listappend(variation_id_list, 0, ',');
					total_min_list = listappend(total_min_list, '-', ',');
					total_max_list = listappend(total_max_list, '-', ',');
					tolerance_list = listappend(tolerance_list, '-', ',');
					//related_tree_id_list = listappend(related_tree_id_list, sub_item.transID, ',');
					operation_type_id_list = listappend(operation_type_id_list, sub_item.transID, ',');
					if (isDefined('sub_item.productTreeID'))
					{
						related_tree_id_list = listappend(related_tree_id_list, sub_item.productTreeID, ',');
					} else {
						related_tree_id_list = listappend(related_tree_id_list, 0, ',');
					}
					/*if(isdefined('arguments.is_show_line_number') and arguments.is_show_line_number eq 1 and len(GET_TREE_OPERATIONS.LINE_NUMBER[j]))
						line_number_list = listappend(line_number_list, GET_TREE_OPERATIONS.LINE_NUMBER[j], ',');
					else
						line_number_list = listappend(line_number_list, 0, ',');*/
					line_number_list = listappend(line_number_list, 0, ',');
					wastage_amount_list = listappend(wastage_amount_list, 0, ',');
					wastage_rate_list = listappend(wastage_rate_list, 0, ',');
					description_list = listappend(description_list, 0, ',');
					question_list = listappend(question_list, 0, ',');
					amount_free_list = listappend(amount_free_list, 0, ',');
					phantom_list = listappend(phantom_list, 0, ',');
				}
			}
		</cfscript>
        
		<cfscript>
        new_spec_cre = specer(
                dsn_type: dsn3,
                spec_type: 1,
                spec_is_tree: 1,
                only_main_spec: 1,
                main_stock_id: main_stock_id,
                main_product_id: main_product_id,
                spec_name: spec_name,
                spec_row_count: row_count,
                stock_id_list: stock_id_list,
                product_id_list: product_id_list,
                product_name_list: product_name_list,
                amount_list: amount_list,
                is_sevk_list: sevk_list,	
                is_configure_list: configure_list,
                is_property_list: is_property_list,
                property_id_list: property_id_list,
                variation_id_list: variation_id_list,
                total_min_list: total_min_list,
                total_max_list : total_max_list,
                tolerance_list : tolerance_list,
                related_spect_id_list : related_spect_main_id_list,
                line_number_list : line_number_list,
                upd_spec_main_row:1,
                related_tree_id_list : related_tree_id_list,
                operation_type_id_list: operation_type_id_list,
				fire_amount_list: wastage_amount_list,
				fire_rate_list: wastage_rate_list,
				detail_list: description_list,
				question_id_list: question_list,
				is_free_amount_list: amount_free_list,
				is_phantom_list: phantom_list,
				is_add_same_name_spect: (params.allow_same_name_for_specs == true ? 1: 0),
				is_control_spect_name: (params.allow_same_name_for_specs == true ? 1: 0)
            );
        new_cre_main_spec_id = ListGetAt(new_spec_cre, 1, ',');	
        </cfscript>
        
        <!--- add spect information into SPECTS and SPECTS_ROW tables via specer function --->
        <cfscript>
			specer(
                dsn_type: dsn3,
                spec_type: 1,
                spec_is_tree: 1,
				main_spec_id: new_cre_main_spec_id,	// difference from the code above
                only_main_spec: 0,					// difference from the code above
                main_stock_id: main_stock_id,
                main_product_id: main_product_id,
                spec_name: spec_name,
                spec_row_count: row_count,
                stock_id_list: stock_id_list,
                product_id_list: product_id_list,
                product_name_list: product_name_list,
                amount_list: amount_list,
                is_sevk_list: sevk_list,	
                is_configure_list: configure_list,
                is_property_list: is_property_list,
                property_id_list: property_id_list,
                variation_id_list: variation_id_list,
                total_min_list: total_min_list,
                total_max_list : total_max_list,
                tolerance_list : tolerance_list,
                related_spect_id_list : related_spect_main_id_list,
                line_number_list : line_number_list,
                upd_spec_main_row:1,
                related_tree_id_list : related_tree_id_list,
                operation_type_id_list: operation_type_id_list,
				fire_amount_list: wastage_amount_list,
				fire_rate_list: wastage_rate_list,
				detail_list: description_list,
				question_id_list: question_list,
				is_free_amount_list: amount_free_list,
				is_phantom_list: phantom_list,
				is_add_same_name_spect: (params.allow_same_name_for_specs == true ? 1: 0),
				is_control_spect_name: (params.allow_same_name_for_specs == true ? 1: 0)
            );
		</cfscript>
        
        <cfreturn new_cre_main_spec_id>
    </cffunction>
</cfcomponent>