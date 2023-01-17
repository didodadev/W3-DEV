<cfcomponent extends="WMO.functions">

    <cfset dsn = application.systemParam.systemParam().dsn>
    <cfset dsn1 = '#dsn#_product'>
    <cfset dsn2 = '#dsn#_#session.ep.period_year#_#session.ep.company_id#'>
    <cfset dsn3 = '#dsn#_#session.ep.company_id#'>

    <cffunction name="GET_PACKET_STAGE" returntype="any">
        <cfargument name="faction" required="true">
        <cfquery name="GET_PACKET_STAGE" datasource="#DSN#">
            SELECT
                PTR.STAGE,
                PTR.PROCESS_ROW_ID 
            FROM
                PROCESS_TYPE_ROWS PTR,
                PROCESS_TYPE_OUR_COMPANY PTO,
                PROCESS_TYPE PT
            WHERE
                PT.IS_ACTIVE = 1 AND
                PT.PROCESS_ID = PTR.PROCESS_ID AND
                PT.PROCESS_ID = PTO.PROCESS_ID AND
                PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.faction#%">
            ORDER BY
                PTR.LINE_NUMBER
        </cfquery>
        <cfreturn GET_PACKET_STAGE>
    </cffunction>

    <cffunction name="GET_PACKAGE_TYPE" returntype="any">
        <cfquery name="GET_PACKAGE_TYPE" datasource="#dsn#">
            SELECT PACKAGE_TYPE_ID, PACKAGE_TYPE FROM SETUP_PACKAGE_TYPE
        </cfquery>
        <cfreturn GET_PACKAGE_TYPE>
    </cffunction>

    <cffunction name="GET_MONEY" returntype="any">
        <cfquery name="GET_MONEY" datasource="#DSN#">
            SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
        </cfquery>
        <cfreturn GET_MONEY>
    </cffunction>

    <cffunction name="get_units_funcs" returntype="query">
        <cfquery name="get_units" datasource="#dsn#">
            SELECT 
                *
            FROM
                SETUP_UNIT
            ORDER BY
                UNIT ASC
        </cfquery>
        <cfreturn get_units>
    </cffunction>

    <cffunction name="get_package" returntype="any">
        <cfquery name="get_package" datasource="#dsn1#">
            SELECT PC.*, P.PROJECT_HEAD 
            FROM PACKETING AS PC LEFT JOIN #dsn#.PRO_PROJECTS AS P ON P.PROJECT_ID = PC.PROJECT_ID
            WHERE 1 = 1 
            <cfif isDefined("arguments.packet_id") and len(arguments.packet_id)>
                AND PC.PACKET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.packet_id#">
            </cfif>
        </cfquery>
        <cfreturn get_package>
    </cffunction>

    <cffunction name="GET_PACKETING" returntype="any">
        <cfquery name="GET_PACKETING" datasource="#dsn1#">
            SELECT 
                P.*,
                SPT.PACKAGE_TYPE,
                D.DEPARTMENT_HEAD AS D_HEAD,
                PR.PROJECT_HEAD
            FROM PACKETING AS P
            LEFT JOIN #dsn#.SETUP_PACKAGE_TYPE AS SPT ON P.PACKAGE_TYPE_ID = SPT.PACKAGE_TYPE_ID
            LEFT JOIN #dsn#.DEPARTMENT AS D ON D.DEPARTMENT_ID = P.DEPARTMENT_ID
            LEFT JOIN #dsn#.PRO_PROJECTS AS PR ON PR.PROJECT_ID = P.PROJECT_ID
            WHERE 1 = 1
            <cfif isdefined("arguments.process_stage_type") and len(arguments.process_stage_type)>
                AND P.PACKAGE_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage_type#">
            </cfif>
            <cfif isdefined("arguments.department_id") and len(arguments.department_id)>
                AND P.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
            </cfif> 
            <cfif isdefined("arguments.transport_comp_id") and len(arguments.transport_comp_id)>
                AND P.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.transport_comp_id#">
            </cfif> 
            <cfif isdefined("arguments.company_id") and len(arguments.company_id)>
                AND P.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
            </cfif>
            <cfif isdefined("arguments.consumer_id") and len(arguments.consumer_id)>
                AND P.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
            </cfif>
            <cfif isdefined("arguments.project_id") and len(arguments.project_id)>
                AND P.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
            </cfif>
            <cfif isdefined("arguments.package_type_id") and len(arguments.package_type_id)>
                AND P.PACKAGE_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.package_type_id#">
            </cfif>
            <cfif isdefined("arguments.paper_no") and len(arguments.paper_no)>
                AND P.PACKAGE_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.paper_no#">
            </cfif>
        </cfquery>
        <cfreturn GET_PACKETING>
    </cffunction>

    <cffunction name="get_order_detail" returntype="any">
        <cfquery name="get_order_detail" datasource="#DSN3#">
            SELECT ORDER_NUMBER, OTHER_MONEY FROM ORDERS WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#">
        </cfquery>
        <cfreturn get_order_detail>
    </cffunction>

    <cffunction name="get_pr_order_detail" returntype="any">
        <cfquery name="get_pr_order_detail" datasource="#DSN3#">
            SELECT RESULT_NO as ORDER_NUMBER, P_ORDER_ID FROM PRODUCTION_ORDER_RESULTS WHERE PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pr_order_id#">
        </cfquery>
        <cfreturn get_pr_order_detail>
    </cffunction>

    <cffunction name="get_warehouse_task_types_funcs" returntype="query">
        <cfquery name="get_warehouse_rates" datasource="#dsn#">
            SELECT 
                *
            FROM
                WAREHOUSE_TASK_TYPES
            ORDER BY
                WAREHOUSE_TASK_TYPE_ORDER ASC
        </cfquery>
        <cfreturn get_warehouse_rates>
    </cffunction>

    <cffunction name="get_package_tasks" returntype="any">
        <cfquery name="get_package_tasks" datasource="#dsn3#">
            SELECT * FROM PACKAGE_TASKS WHERE PACKAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.packet_id#">
        </cfquery>
        <cfreturn get_package_tasks>
    </cffunction>

    <cffunction name="add_packeting" returntype="any" returnformat="JSON">
        <cfset responseStruct = structNew()>
        <!--- <cfdump var="#arguments#" abort> --->
        <cftransaction>
            <cftry>
                <cf_date tarih='arguments.action_date'>
                <cfquery name="add_packeting" datasource="#DSN1#" result="MAX_ID">
                    INSERT INTO 
                        PACKETING(
                            PACKAGE_STAGE,
                            RELATED_TYPE,
                            ORDER_ID,
                            PROD_RESULT_ID,
                            PACKAGE_NO,
                            RELATED_PAPER_NO,
                            BARCOD,
                            RECORD_EMP,
                            RECORD_IP,
                            RECORD_DATE,
                            PACKAGE_TYPE_ID,
                            MAX_VOLUME,
                            MAX_WIDTH,
                            COMPANY_ID,
                            PARTNER_ID,
                            CONSUMER_ID,
                            PROJECT_ID,
                            DEPARTMENT_ID,
                            ACTION_DATE,
                            DESCRIPTION
                        )
                        VALUES(
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.associated_transaction#">,
                            <cfif isDefined("arguments.order_id") and len(arguments.order_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#"><cfelse>NULL</cfif>,
                            <cfif isDefined("arguments.pr_order_id") and len(arguments.pr_order_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pr_order_id#"><cfelse>NULL</cfif>,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.paper_no#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.associated_transaction_paper#">,
                            <cfif len(arguments.barcod)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.barcod#"><cfelse>NULL</cfif>,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#cgi.remote_addr#">,
                            #now()#,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.package_type_id#">,
                            <cfif len(arguments.max_vol)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_vol#"><cfelse>NULL</cfif>,
                            <cfif len(arguments.max_weight)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_weight#"><cfelse>NULL</cfif>,
                            <cfif len(arguments.company_id)>
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">,
                                <cfif len(arguments.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#"><cfelse>NULL</cfif>,
                                NULL,
                            <cfelseif len(arguments.consumer_id)>
                                NULL,
                                NULL,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">,
                            <cfelse>
                                NULL,
                                NULL,
                                NULL,			
                            </cfif>
                            <cfif len(arguments.project_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"><cfelse>NULL</cfif>,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">,
                            #arguments.action_date#,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.note#">
                        )
                </cfquery>
                <!--- Paket İçeriği --->
                <cfloop from="1" to="#arguments.rows_#" index="i">
                    <cfquery name="ADD_PACKETING_ROW" datasource="#dsn1#">
                        INSERT INTO
                            PACKETING_ROW(
                                STOCK_ID,
                                PRODUCT_ID,
                                UPD_ID,
                                ROW_IN,
                                ROW_OUT,
                                ORDER_ID,
                                P_RESULT_ID,
                                STORE,
                                AMOUNT2,
                                UNIT2,
                                UNIT,
                                UNIT_ID,
                                WRK_ROW_ID,
                                WIDTH_VALUE,
                                DEPTH_VALUE,
                                HEIGHT_VALUE
                            )
                        VALUES(
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.stock_id#i#")#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.product_id#i#")#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.amount#i#")#">,
                            0,
                            <cfif isDefined("arguments.order_id") and len(arguments.order_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#"><cfelse>NULL</cfif>,
                            <cfif isDefined("arguments.pr_order_id") and len(arguments.pr_order_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pr_order_id#"><cfelse>NULL</cfif>,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.department_id")#">,
                            <cfif isdefined('arguments.amount_other#i#') and len(evaluate('arguments.amount_other#i#'))>#evaluate('arguments.amount_other#i#')#<cfelse>NULL</cfif>,
			                <cfif isdefined('arguments.unit_other#i#') and len(evaluate('arguments.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('arguments.unit_other#i#')#"><cfelse>NULL</cfif>,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('arguments.unit#i#')#">,
				            #evaluate("arguments.unit_id#i#")#,
                            <cfif isdefined('arguments.wrk_row_id#i#') and len(evaluate('arguments.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('arguments.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.row_width#i#') and len(evaluate('arguments.row_width#i#'))>#evaluate('arguments.row_width#i#')#<cfelse>NULL</cfif>,
			                <cfif isdefined('arguments.row_depth#i#') and len(evaluate('arguments.row_depth#i#'))>#evaluate('arguments.row_depth#i#')#<cfelse>NULL</cfif>,
			                <cfif isdefined('arguments.row_height#i#') and len(evaluate('arguments.row_height#i#'))>#evaluate('arguments.row_height#i#')#<cfelse>NULL</cfif>
                        )
                    </cfquery>
                </cfloop>
                <!--- Paketleme İşlemleri --->
                <cfif isDefined("arguments.rowcount") and len(arguments.rowcount)>
                    <cfloop from="1" to="#arguments.rowcount#" index="i">
                        <cfquery name="ADD_PACKAGE_TASKS" datasource="#dsn1#">
                            INSERT INTO
                            #dsn3#.PACKAGE_TASKS(
                                TASK_TYPE,
                                AMOUNT,
                                UNIT,
                                PRICE,
                                MONEY,
                                PACKAGE_ID
                            )
                        VALUES(
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.warehouse_task_type_id_#i#")#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate("arguments.rate_info_#i#"))#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("arguments.unit_id_#i#")#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate("arguments.price_#i#"))#">,
                            <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('arguments.price_money_#i#')#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#MAX_ID.IDENTITYCOL#">
                        )
                        </cfquery>
                    </cfloop>
                </cfif>
                <cfset responseStruct.message = "İşlem Başarılı">
                <cfset responseStruct.status = true>
                <cfset responseStruct.error = {}>
                <cfset responseStruct.identity = MAX_ID.IDENTITYCOL>
                <cfcatch type="database">
                    <cftransaction action="rollback">
                    <cfset responseStruct.message = "İşlem Hatalı">
                    <cfset responseStruct.status = false>
                    <cfset responseStruct.error = cfcatch>
                </cfcatch>
            </cftry>
        </cftransaction>
        <cf_papers paper_type="package">
        <cfset system_paper_no=paper_code & '-' & paper_number>
        <cfset system_paper_no_add=paper_number>
        <cfif len(system_paper_no_add)>
            <cfquery name="UPD_GEN_PAP" datasource="#dsn#">
                UPDATE 
                    GENERAL_PAPERS_MAIN
                SET
                    PACKAGE_NUMBER = #system_paper_no_add#
                WHERE
                    PACKAGE_NUMBER IS NOT NULL
            </cfquery>
        </cfif>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="upd_packeting" returntype="any" returnformat="JSON">
        <cfset responseStruct = structNew()>
        <cftransaction>
            <cftry>
                <cf_date tarih='arguments.action_date'>
                <cfquery name="add_packeting" datasource="#DSN1#">
                    UPDATE PACKETING
                        SET
                            PACKAGE_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">,
                            PACKAGE_NO = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.paper_no#">,
                            BARCOD = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#arguments.barcod#">,
                            UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                            UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                            UPDATE_DATE = #now()#,
                            PACKAGE_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.package_type_id#">,
                            MAX_VOLUME = <cfif len(arguments.max_vol)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_vol#"><cfelse>NULL</cfif>,
                            MAX_WIDTH = <cfif len(arguments.max_weight)><cfqueryparam cfsqltype="cf_sql_float" value="#arguments.max_weight#"><cfelse>NULL</cfif>,
                            COMPANY_ID = <cfif len(arguments.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#"><cfelse>NULL</cfif>,
                            PARTNER_ID = <cfif len(arguments.partner_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.partner_id#"><cfelse>NULL</cfif>,
                            CONSUMER_ID = <cfif len(arguments.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#"><cfelse>NULL</cfif>,
                            PROJECT_ID = <cfif len(arguments.project_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"><cfelse>NULL</cfif>,
                            DEPARTMENT_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
                    WHERE PACKET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.packet_id#">
                </cfquery>

                <!--- Paketleme İşlemleri --->
                <cfquery name="DEL_PACKAGE_TASKS" datasource="#dsn1#">
                    DELETE FROM #dsn3#.PACKAGE_TASKS WHERE PACKAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.packet_id#">
                </cfquery>
                <cfif isDefined("arguments.rowcount") and len(arguments.rowcount)>
                    <cfloop from="1" to="#arguments.rowcount#" index="i">
                        <cfif isDefined("arguments.warehouse_task_type_id_#i#")>
                            <cfquery name="ADD_PACKAGE_TASKS" datasource="#dsn1#">
                                INSERT INTO
                                #dsn3#.PACKAGE_TASKS(
                                    TASK_TYPE,
                                    AMOUNT,
                                    UNIT,
                                    PRICE,
                                    MONEY,
                                    PACKAGE_ID
                                )
                            VALUES(
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.warehouse_task_type_id_#i#")#">,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate("arguments.rate_info_#i#"))#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate("arguments.unit_id_#i#")#">,
                                <cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(evaluate("arguments.price_#i#"))#">,
                                <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('arguments.price_money_#i#')#">,
                                <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.packet_id#">
                            )
                            </cfquery>
                        </cfif>
                    </cfloop>
                </cfif>

                 <!--- Paket İçeriği --->
                <cfquery name="DEL_PACKETING_ROW" datasource="#dsn1#">
                    DELETE FROM PACKETING_ROW WHERE UPD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.packet_id#">
                </cfquery>
                 <cfloop from="1" to="#arguments.rows_#" index="i">
                    <cfquery name="ADD_PACKETING_ROW" datasource="#dsn1#">
                        INSERT INTO
                            PACKETING_ROW(
                                STOCK_ID,
                                PRODUCT_ID,
                                UPD_ID,
                                ROW_IN,
                                ROW_OUT,
                                ORDER_ID,
                                P_RESULT_ID,
                                STORE,
                                AMOUNT2,
                                UNIT2,
                                UNIT,
                                UNIT_ID,
                                WRK_ROW_ID,
                                WIDTH_VALUE,
                                DEPTH_VALUE,
                                HEIGHT_VALUE
                            )
                        VALUES(
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.stock_id#i#")#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.product_id#i#")#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.packet_id#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#evaluate("arguments.amount#i#")#">,
                            0,
                            <cfif isDefined("arguments.order_id") and len(arguments.order_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.order_id#"><cfelse>NULL</cfif>,
                            <cfif isDefined("arguments.pr_order_id") and len(arguments.pr_order_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pr_order_id#"><cfelse>NULL</cfif>,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#evaluate("arguments.department_id")#">,
                            <cfif isdefined('arguments.amount_other#i#') and len(evaluate('arguments.amount_other#i#'))>#evaluate('arguments.amount_other#i#')#<cfelse>NULL</cfif>,
			                <cfif isdefined('arguments.unit_other#i#') and len(evaluate('arguments.unit_other#i#'))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('arguments.unit_other#i#')#"><cfelse>NULL</cfif>,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#evaluate('arguments.unit#i#')#">,
				            #evaluate("arguments.unit_id#i#")#,
                            <cfif isdefined('arguments.wrk_row_id#i#') and len(evaluate('arguments.wrk_row_id#i#'))><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#evaluate('arguments.wrk_row_id#i#')#"><cfelse>NULL</cfif>,
                            <cfif isdefined('arguments.row_width#i#') and len(evaluate('arguments.row_width#i#'))>#evaluate('arguments.row_width#i#')#<cfelse>NULL</cfif>,
			                <cfif isdefined('arguments.row_depth#i#') and len(evaluate('arguments.row_depth#i#'))>#evaluate('arguments.row_depth#i#')#<cfelse>NULL</cfif>,
			                <cfif isdefined('arguments.row_height#i#') and len(evaluate('arguments.row_height#i#'))>#evaluate('arguments.row_height#i#')#<cfelse>NULL</cfif>
                        )
                    </cfquery>
                </cfloop>

                <cfset responseStruct.message = "İşlem Başarılı">
                <cfset responseStruct.status = true>
                <cfset responseStruct.error = {}>
                <cfset responseStruct.identity = ''>
                <cfcatch type="database">
                    <cftransaction action="rollback">
                    <cfset responseStruct.message = "İşlem Hatalı">
                    <cfset responseStruct.status = false>
                    <cfset responseStruct.error = cfcatch>
                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn responseStruct>
    </cffunction>

    <cffunction name="del_packeting" returntype="any" returnformat="JSON">
        <cfset responseStruct = StructNew()>

        <cftransaction>
            <cftry>
                <cfquery name="delete_packet" datasource="#dsn1#">
                    DELETE FROM PACKETING WHERE PACKET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.packet_id#">
                </cfquery>

                <cfquery name="delete_packet" datasource="#dsn1#">
                    DELETE FROM PACKETING_ROW WHERE UPD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.packet_id#">
                </cfquery>

                <cfquery name="delete_packet" datasource="#dsn1#">
                    DELETE FROM #dsn3#.PACKAGE_TASKS WHERE PACKAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.packet_id#">
                </cfquery>

                <cfset responseStruct.message = "İşlem Başarılı">
                <cfset responseStruct.status = true>
                <cfset responseStruct.error = {}>
                <cfset responseStruct.identity = ''>
                <cfcatch type="database">
                    <cftransaction action="rollback">
                    <cfset responseStruct.message = "İşlem Hatalı">
                    <cfset responseStruct.status = false>
                    <cfset responseStruct.error = cfcatch>
                </cfcatch>
            </cftry>
        </cftransaction>
        <cfreturn responseStruct>
    </cffunction>
</cfcomponent>