<cfcomponent>
    <cffunction name="GET_SHIP_FIS_fnc" returntype="query" access="public">
        <cfargument name="cat" default="">
        <cfargument name="consumer_id" default=""/>
        <cfargument name="company" default=""/>
        <cfargument name="company_id" default=""/>
        <cfargument name="invoice_action" default=""/>
        <cfargument name="listing_type" default=""/>
        <cfargument name="record_date" default=""/>
        <cfargument name="date1" default=""/>
        <cfargument name="date2" default=""/>
        <cfargument name="department_id" default=""/>
        <cfargument name="department_out" default=""/>
        <cfargument name="location_id" default=""/>
        <cfargument name="location_out" default=""/>
        <cfargument name="belge_no" default=""/>
        <cfargument name="project_id" default=""/>
        <cfargument name="project_id_in" default=""/>
        <cfargument name="subscription_id" default=""/>
        <cfargument name="subscription_no" default=""/>
        <cfargument name="employee_id" default=""/>
        <cfargument name="iptal_stocks" default=""/>
        <cfargument name="stock_id" default=""/>
        <cfargument name="product_name" default=""/>
        <cfargument name="product_cat_code" default=""/>
        <cfargument name="product_cat_name" default=""/>
        <cfargument name="delivered" default=""/>
        <cfargument name="deliver_emp" default=""/>
        <cfargument name="deliver_emp_id" default=""/>
        <cfargument name="company_id_2" default=""/>
        <cfargument name="member_name" default=""/>
        <cfargument name="consumer_id_2" default=""/>
        <cfargument name="employee_id_2" default=""/>
        <cfargument name="partner_id_2" default=""/>
        <cfargument name="lot_no" default=""/>
        <cfargument name="oby" default=""/>
        <cfargument name="work_id" default=""/>
        <cfargument name="startrow" default="">
        <cfargument name="maxrows" default="">
        <cfargument name="disp_ship_state" default="">
        <cfargument name="record_emp_id" default="">
        <cfargument name="record_name" default="">
        <cfargument name="row_department_id" default="">
        <cfargument name="row_location_id" default="">
        <cfargument name="xml_department_filter" default="">
        <cfargument name="xml_project_filter" default="">
        <cfargument name="row_project_id" default="">
        <cfargument name="row_project_head" default="">
        <cfargument name="EMPO_ID" default="">
        <cfargument name="EMP_PARTNER_NAMEO" default="">
        <cfargument name="process_stage" default="">
        <cfargument name="eshipment_type" default="">
        <cfargument name="spect_var_id" default="">
        <cfquery name="GET_MY_DEPARTMENT" datasource="#this.DSN#">
            SELECT DEPARTMENT_ID FROM #this.dsn_alias#.DEPARTMENT WHERE BRANCH_ID IN ((SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#))
        </cfquery>
        <cfif (listFind("70,71,72,73,74,75,76,77,78,79,80,81,87,811,82,83,84,88,761,85,86,140,141,118,1182",listfirst(arguments.cat,'-'))) or not len (arguments.cat) or (not (len(arguments.consumer_id) or (len(arguments.company) and len(arguments.company_id)) or len(arguments.invoice_action)) and listFind("110,111,112,113,114,115,116,119,1131",listfirst(arguments.cat,'-')))>
            <cfquery name="GET_SHIP_FIS" datasource="#this.DSN2#">
                WITH CTE1 AS (
                <cfif (len(arguments.cat) and listFind("70,71,72,73,74,75,76,77,78,79,80,81,811,82,83,84,87,88,761,85,86,140,141",listfirst(arguments.cat,'-'))) or not len(arguments.cat)>
                    <cfif len(arguments.invoice_action)><!--- faturali mi veya faturasiz mi soruldugu icin INVOICE_SHIPS iliskisi her halukarda aranacak --->
                        SELECT
                            1 TABLE_TYPE,
                            SHIP.IS_WITH_SHIP,
                            SHIP.PROCESS_CAT PROCESS_CAT,
                            SHIP.PROJECT_ID,
                            (SELECT PROJECT_HEAD FROM #this.dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = SHIP.PROJECT_ID) PROJECT_HEAD,
                            SHIP.PROJECT_ID_IN,
                            (SELECT PROJECT_HEAD FROM #this.dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = SHIP.PROJECT_ID_IN) PROJECT_HEAD_IN,
                        <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                            SHIP_ROW.NAME_PRODUCT,
                            (SELECT TOP 1 STOCK_CODE FROM #this.dsn3_alias#.STOCKS STOCKS WITH (NOLOCK) WHERE STOCK_ID = SHIP_ROW.STOCK_ID) AS STOCK_CODE,
                            SHIP_ROW.PRODUCT_ID,
                            SHIP_ROW.AMOUNT,
                            SHIP_ROW.PRICE, 
                            SHIP_ROW.NETTOTAL AS NETTOTAL,                       
                            SHIP_ROW.LOT_NO,
                        </cfif>
                            SHIP.PURCHASE_SALES,
                            SHIP.DELIVER_EMP_ID,
                            SHIP.SHIP_ID ISLEM_ID,
                            SHIP.SHIP_NUMBER BELGE_NO,
                            SHIP.REF_NO REFERANS,
                            SHIP.SHIP_TYPE ISLEM_TIPI,
                            SHIP.SHIP_DATE ISLEM_TARIHI,
                            SHIP.DELIVER_DATE SEVK_TARIHI,
                            SHIP.COMPANY_ID,
                            SHIP.CONSUMER_ID,
                            SHIP.PARTNER_ID,
                            SHIP.EMPLOYEE_ID,
                            SHIP.DEPARTMENT_IN DEPARTMENT_ID,
                            SHIP.LOCATION_IN LOCATION,
                            SHIP.DELIVER_STORE_ID DEPARTMENT_ID_2,
                            SHIP.LOCATION LOCATION_2,
                        <cfif arguments.invoice_action eq 2>
                            NULL INVOICE_NUMBER,
                        <cfelse>
                            INVOICE_SHIPS.INVOICE_NUMBER AS INVOICE_NUMBER,
                        </cfif>
                            SHIP.DELIVER_EMP,
                            SHIP.RECORD_DATE,
                            SHIP.RECORD_EMP,
                            SHIP.WORK_ID,
                            0 IS_STOCK_TRANSFER,
                            0 STOCK_EXCHANGE_TYPE,
                            PRO_WORKS.WORK_HEAD,
                            (SELECT DEPARTMENT_HEAD FROM  #this.dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = SHIP.DEPARTMENT_IN) DEPT_IN,
                            (SELECT COMMENT FROM  #this.dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID = SHIP.DEPARTMENT_IN AND LOCATION_ID = SHIP.LOCATION_IN) LOC_IN,
                            (SELECT DEPARTMENT_HEAD FROM  #this.dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = SHIP.DELIVER_STORE_ID) DEPT_OUT,
                            (SELECT COMMENT FROM  #this.dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID = SHIP.DELIVER_STORE_ID AND LOCATION_ID = SHIP.LOCATION) LOC_OUT,   
                            (SELECT STAGE FROM #this.dsn_alias#.PROCESS_TYPE_ROWS PTR WHERE PROCESS_ROW_ID = SHIP.PROCESS_STAGE ) as STAGE,
                            SHIP.PROCESS_STAGE                                       
                        FROM 	
                            SHIP WITH (NOLOCK)
                                LEFT JOIN #this.dsn_alias#.PRO_WORKS ON SHIP.WORK_ID = PRO_WORKS.WORK_ID
                                <cfif session.ep.our_company_info.is_eshipment>
                                    LEFT JOIN ESHIPMENT_RELATION ER ON ER.ACTION_ID = SHIP.SHIP_ID
                                    LEFT JOIN ESHIPMENT_RECEIVING_DETAIL ERD ON ERD.SHIP_ID = SHIP.SHIP_ID
                                </cfif>
                            <cfif arguments.invoice_action eq 1>
                                ,INVOICE_SHIPS WITH (NOLOCK)
                                <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2>
                                ,INVOICE_ROW IRR 
                                </cfif>
                            </cfif>
                            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                                ,SHIP_ROW WITH (NOLOCK)
                            </cfif>
                        WHERE 
                        <cfif arguments.invoice_action eq 1>
                            SHIP.SHIP_ID = INVOICE_SHIPS.SHIP_ID
                            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2>
                                AND IRR.WRK_ROW_RELATION_ID = SHIP_ROW.WRK_ROW_ID
                            </cfif>
                            AND INVOICE_SHIPS.SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                        <cfelseif arguments.invoice_action eq 2>
                            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2>
                                SHIP_ROW.WRK_ROW_ID NOT IN (SELECT WRK_ROW_RELATION_ID FROM INVOICE_ROW WHERE WRK_ROW_RELATION_ID IS NOT NULL)
                                AND SHIP.IS_WITH_SHIP =0
                            <cfelse> 
                                SHIP.SHIP_ID NOT IN (SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
                            </cfif>
                        </cfif>
                        <cfif isdefined('arguments.lot_no') and Len(arguments.lot_no)>
                            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme --->
                                AND SHIP_ROW.LOT_NO LIKE '<cfif len(arguments.lot_no) gt 3>%</cfif>#arguments.lot_no#%'
                            <cfelse>
                                AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM SHIP_ROW SFR WHERE SFR.SHIP_ID = SHIP.SHIP_ID AND SFR.LOT_NO LIKE '<cfif len(arguments.lot_no) gt 3>%</cfif>#arguments.lot_no#%')
                            </cfif>
                        </cfif>
                        <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                            AND SHIP.SHIP_ID = SHIP_ROW.SHIP_ID
                            <cfif len(arguments.row_department_id)>
                                AND SHIP_ROW.DELIVER_DEPT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.row_department_id#">
                                <cfif len(arguments.row_location_id)>
                                    AND SHIP_ROW.DELIVER_DEPT =  #arguments.row_department_id# AND SHIP_ROW.DELIVER_LOC = #arguments.row_location_id#	
                                </cfif>
                            </cfif>	
                            <cfif len(arguments.row_project_id) and len(arguments.row_project_head)>
                                AND SHIP_ROW.ROW_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.row_project_id#">
                            </cfif>
                            <cfif isDefined("arguments.spect_var_id") and len(arguments.spect_var_id)>
                                AND SHIP_ROW.SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spect_var_id#">
                            </cfif>
                        </cfif>
                        <cfif len(arguments.cat) and listlast(arguments.cat,'-') eq 0>
                            AND SHIP.SHIP_TYPE = #listfirst(arguments.cat,'-')#
                        <cfelseif len(arguments.cat) and listlast(arguments.cat,'-') neq 0>
                            AND SHIP.PROCESS_CAT = #listlast(arguments.cat,'-')#
                        <cfelse>
                            AND SHIP.SHIP_ID IS NOT NULL
                        </cfif>
                        <cfif isdate(arguments.record_date)>
                            AND SHIP.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('h',-session.ep.time_zone,arguments.record_date)#">
                            AND SHIP.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,DATEADD('h',-session.ep.time_zone,arguments.record_date))#">
                        </cfif>
                        <cfif isdefined('arguments.process_stage') and len(arguments.process_stage)>
                            AND SHIP.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
                        </cfif>
                        <cfif isdefined('arguments.record_emp_id') and len(arguments.record_emp_id) and len(arguments.record_name)>
                            AND SHIP.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_emp_id#">
                        </cfif>
                        <cfif len(arguments.date1)>
                            AND SHIP.SHIP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date1#">
                        </cfif>
                        <cfif len(arguments.date2)>
                            AND SHIP.SHIP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date2#">
                        </cfif>
                        <cfif len(arguments.department_id)>
                            AND SHIP.DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
                            <cfif len(arguments.location_id)>
                                AND SHIP.LOCATION_IN = #arguments.location_id#
                            </cfif>
                        <cfelseif session.ep.isBranchAuthorization and (isDefined("arguments.cat") and len(arguments.cat) and listFind("73,74,75,76,77,80,81,82,84,761",listfirst(arguments.cat,'-'))) or not(isDefined("arguments.cat") and len(arguments.cat))>
                            AND 
                            (
                                SHIP.DEPARTMENT_IN IN (#valuelist(get_my_department.department_id)#) OR 
                                SHIP.DELIVER_STORE_ID IN (#valuelist(get_my_department.department_id)#)
                            )	
                        </cfif>	
                        <cfif len(arguments.department_out)>
                            <cfif xml_department_filter neq 1>
                                AND (
                                    SHIP.DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_out#"> 
                                    OR SHIP.DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_out#">
                                    )
                                <cfif len(arguments.location_out)>
                                    AND (SHIP.LOCATION_IN = #arguments.location_out# OR SHIP.LOCATION = #arguments.location_out#)
                                </cfif>
                            <cfelse>	
                                AND SHIP.DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_out#">
                                <cfif len(arguments.location_out)>
                                    SHIP.LOCATION_IN = #arguments.location_out#	
                                </cfif>
                            </cfif>
                        <cfelseif session.ep.isBranchAuthorization and (isDefined("arguments.cat") and len(arguments.cat) and listFind("70,71,72,78,79,83,87,88",listfirst(arguments.cat,'-'))) or not(isDefined("arguments.cat") and len(arguments.cat))>
                            AND 
                            (
                                SHIP.DELIVER_STORE_ID IN (#valuelist(get_my_department.department_id)#) OR 
                                SHIP.DEPARTMENT_IN IN (#valuelist(get_my_department.department_id)#)
                            )
                        </cfif> 	
                        <cfif len(arguments.belge_no)>
                            AND ((SHIP.SHIP_NUMBER LIKE '<cfif len(arguments.belge_no) gt 3>%</cfif>#arguments.belge_no#%') OR
                                (SHIP.REF_NO LIKE '<cfif len(arguments.belge_no) gt 3>%</cfif>#arguments.belge_no#%'))
                        </cfif>
                        <cfif len(arguments.project_id)>
                            <cfif xml_project_filter neq 1>
                                AND (SHIP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"> OR SHIP.PROJECT_ID_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">)
                            <cfelse>	
                                AND SHIP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
                            </cfif>
                        </cfif>
                        <cfif len(arguments.project_id_in)>
                            AND SHIP.PROJECT_ID_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id_in#">
                        </cfif>
                        <cfif isdefined('arguments.subscription_id') and len(arguments.subscription_id) and isdefined('arguments.subscription_no') and len(arguments.subscription_no)>
                            AND SHIP.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#">
                        </cfif>
                        <cfif len(arguments.employee_id) and arguments.employee_id gt 0>
                            AND SHIP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                        <cfelseif len(arguments.consumer_id) and arguments.consumer_id gt 0>
                            AND SHIP.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                        <cfelseif isdefined('arguments.company') and len(arguments.company) and len(arguments.company_id) and arguments.company_id gt 0>
                            AND SHIP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                        </cfif>
                        <cfif len(arguments.iptal_stocks)>
                            AND ISNULL(SHIP.IS_SHIP_IPTAL,0) = #arguments.iptal_stocks#
                        </cfif>
                        <cfif len(arguments.stock_id) and len(arguments.product_name)>
                            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                                AND SHIP_ROW.STOCK_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
                            <cfelse>
                                AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM SHIP_ROW WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">)
                            </cfif>
                        </cfif>
                        <cfif len(arguments.product_cat_code) and len(arguments.product_cat_name)>
                            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                                AND SHIP_ROW.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #this.dsn1_alias#.PRODUCT P WHERE P.PRODUCT_CODE LIKE '#arguments.product_cat_code#.%')
                            <cfelse>
                                AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM SHIP_ROW SR, #this.dsn1_alias#.PRODUCT P WHERE P.PRODUCT_ID = SR.PRODUCT_ID AND P.PRODUCT_CODE LIKE '#arguments.product_cat_code#.%')
                            </cfif>
                        </cfif>
                        <cfif len(arguments.delivered) and arguments.delivered eq 1>
                            AND SHIP.IS_DELIVERED = 1
                        <cfelseif len(arguments.delivered) and arguments.delivered eq 0>
                            AND ( SHIP.IS_DELIVERED = 0 OR SHIP.IS_DELIVERED IS NULL )
                            AND SHIP.SHIP_TYPE IN (81,811)
                        </cfif>
                        <cfif (isdefined('arguments.deliver_emp') and len(arguments.deliver_emp)) or (isdefined('arguments.deliver_emp_id') and len(arguments.deliver_emp_id))>
                            AND(
                                <cfif isdefined('arguments.deliver_emp') and len(arguments.deliver_emp)>
                                    (SHIP.PURCHASE_SALES = 1 AND SHIP.DELIVER_EMP LIKE '<cfif len(arguments.deliver_emp) gt 3>%</cfif>#arguments.deliver_emp#%')
                                </cfif>
                                <cfif isdefined('arguments.deliver_emp_id') and len(arguments.deliver_emp_id)>
                                    <cfif len(arguments.deliver_emp)>OR</cfif>(SHIP.PURCHASE_SALES = 0 AND (SHIP.DELIVER_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.deliver_emp_id#">))
                                </cfif>
                            )
                        </cfif>
                        <cfif len(arguments.member_name) >
                            AND SHIP.DELIVER_EMP LIKE '%#arguments.member_name#%'
                        </cfif>
                        <cfif len(arguments.work_id)>
                            AND SHIP.WORK_ID = #arguments.work_id#
                        </cfif>
                        <cfif isdefined('arguments.EMPO_ID') and len(arguments.EMPO_ID) and len(arguments.EMP_PARTNER_NAMEO)>
                            AND SHIP.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMPO_ID#">
                        </cfif>
                        <cfif len(arguments.eshipment_type)>
                            AND SHIP.SHIP_TYPE IN (70,71,72,78,79,81,82,83,85,88,761)
                            AND ( SHIP.IS_WITH_SHIP = 0 OR SHIP.IS_WITH_SHIP IS NULL )
                            <cfif arguments.eshipment_type eq 1>
                                AND 
                                ( 
                                    (SELECT COUNT(SENDING_DETAIL_ID) FROM ESHIPMENT_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = SHIP.SHIP_ID and ( ESD.ACTION_TYPE = 'SHIP' OR ESD.ACTION_TYPE = 'SHIP_SEVK' ) AND STATUS_CODE = 1 ) = 0 
                                )
                            <cfelseif arguments.eshipment_type eq 2>
                                AND 
                                ( 
                                    (SELECT COUNT(SENDING_DETAIL_ID) FROM ESHIPMENT_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = SHIP.SHIP_ID and ( ESD.ACTION_TYPE = 'SHIP' OR ESD.ACTION_TYPE = 'SHIP_SEVK' ) AND STATUS_CODE = 1 ) > 0 
                                    AND ( ER.STATUS_CODE <> 1 OR ER.STATUS_CODE IS NULL)
                                )
                            <cfelseif arguments.eshipment_type eq 3>
                                AND 
                                (
                                    (SELECT COUNT(SENDING_DETAIL_ID) FROM ESHIPMENT_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = SHIP.SHIP_ID AND ( ESD.ACTION_TYPE = 'SHIP' OR ESD.ACTION_TYPE = 'SHIP_SEVK' ) AND STATUS_CODE = 1) > 0 
                                    AND ER.PATH IS NOT NULL
                                    AND ER.STATUS_CODE = 1
                                )
                            </cfif>
                        </cfif>
                    <cfelse>
                        SELECT
                            1 TABLE_TYPE,
                            SHIP.IS_WITH_SHIP,
                            SHIP.PROCESS_CAT PROCESS_CAT,
                            SHIP.PROJECT_ID PROJECT_ID,
                            (SELECT PROJECT_HEAD FROM #this.dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = SHIP.PROJECT_ID) PROJECT_HEAD,
                            SHIP.PROJECT_ID_IN,
                            (SELECT PROJECT_HEAD FROM #this.dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = SHIP.PROJECT_ID_IN) PROJECT_HEAD_IN,
                        <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                            SHIP_ROW.NAME_PRODUCT,
                            (SELECT TOP 1 STOCK_CODE FROM #this.dsn3_alias#.STOCKS STOCKS WITH (NOLOCK) WHERE STOCK_ID = SHIP_ROW.STOCK_ID) AS STOCK_CODE,
                            SHIP_ROW.PRODUCT_ID,
                            SHIP_ROW.AMOUNT,
                            SHIP_ROW.PRICE,
                            SHIP_ROW.NETTOTAL AS NETTOTAL,
                            SHIP_ROW.LOT_NO,
                        </cfif>
                            SHIP.PURCHASE_SALES ,
                            SHIP.DELIVER_EMP_ID,
                            SHIP.SHIP_ID ISLEM_ID,
                            SHIP_NUMBER BELGE_NO,
                            SHIP.REF_NO REFERANS,
                            SHIP_TYPE ISLEM_TIPI,
                            SHIP.SHIP_DATE ISLEM_TARIHI,
                            SHIP.DELIVER_DATE SEVK_TARIHI,
                            SHIP.COMPANY_ID,
                            SHIP.CONSUMER_ID,
                            SHIP.PARTNER_ID,
                            SHIP.EMPLOYEE_ID,
                            DEPARTMENT_IN DEPARTMENT_ID,
                            LOCATION_IN LOCATION,
                            DELIVER_STORE_ID DEPARTMENT_ID_2,
                            LOCATION LOCATION_2,
                            NULL INVOICE_NUMBER, 
                            DELIVER_EMP,
                            SHIP.RECORD_DATE,
                            SHIP.RECORD_EMP,
                            SHIP.WORK_ID,
                            0 IS_STOCK_TRANSFER,
                            0 STOCK_EXCHANGE_TYPE,
                            PRO_WORKS.WORK_HEAD,
                            (select DEPARTMENT_HEAD FROM  #this.dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = SHIP.DEPARTMENT_IN) DEPT_IN,
                            (SELECT COMMENT FROM  #this.dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID = SHIP.DEPARTMENT_IN AND LOCATION_ID = SHIP.LOCATION_IN) LOC_IN,
                            (SELECT DEPARTMENT_HEAD FROM  #this.dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = SHIP.DELIVER_STORE_ID) DEPT_OUT,
                            (SELECT COMMENT FROM  #this.dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID = SHIP.DELIVER_STORE_ID AND LOCATION_ID = SHIP.LOCATION) LOC_OUT,
                            (SELECT STAGE FROM #this.dsn_alias#.PROCESS_TYPE_ROWS  WHERE PROCESS_ROW_ID = SHIP.PROCESS_STAGE ) as STAGE,
                            SHIP.PROCESS_STAGE                                                                                   
                        FROM 	
                            SHIP WITH (NOLOCK)
                                LEFT JOIN #this.dsn_alias#.PRO_WORKS ON SHIP.WORK_ID = PRO_WORKS.WORK_ID
                            <cfif session.ep.our_company_info.is_eshipment>
                                LEFT JOIN ESHIPMENT_RELATION ER ON ER.ACTION_ID = SHIP.SHIP_ID
                                LEFT JOIN ESHIPMENT_RECEIVING_DETAIL ERD ON ERD.SHIP_ID = SHIP.SHIP_ID
                            </cfif>
                        <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                            ,SHIP_ROW WITH (NOLOCK)
                        </cfif>
                        WHERE 
                        <cfif len(arguments.cat) and listlast(arguments.cat,'-') eq 0>
                            SHIP.SHIP_TYPE = #listfirst(arguments.cat,'-')#
                        <cfelseif len(arguments.cat) and listlast(arguments.cat,'-') neq 0>
                            SHIP.PROCESS_CAT = #listlast(arguments.cat,'-')#
                        <cfelse>
                            SHIP.SHIP_ID IS NOT NULL
                        </cfif>
                        <cfif isdefined('arguments.lot_no') and len(arguments.lot_no)>
                            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme --->
                                AND SHIP_ROW.LOT_NO LIKE '<cfif len(arguments.lot_no) gt 3>%</cfif>#arguments.lot_no#%'
                            <cfelse>
                                AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM SHIP_ROW SFR WHERE SFR.SHIP_ID = SHIP.SHIP_ID AND SFR.LOT_NO LIKE '<cfif len(arguments.lot_no) gt 3>%</cfif>#arguments.lot_no#%')
                            </cfif>
                        </cfif>
                        <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                            AND SHIP.SHIP_ID = SHIP_ROW.SHIP_ID
                            <cfif len(arguments.row_department_id)>
                                AND SHIP_ROW.DELIVER_DEPT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.row_department_id#">
                                <cfif len(arguments.row_location_id)>
                                    AND SHIP_ROW.DELIVER_LOC = #arguments.row_location_id#	
                                </cfif>
                            </cfif>	
                            <cfif len(arguments.row_project_id) and len(arguments.row_project_head)>
                                AND SHIP_ROW.ROW_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.row_project_id#">
                            </cfif>
                            <cfif isDefined("arguments.spect_var_id") and len(arguments.spect_var_id)>
                                AND SHIP_ROW.SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spect_var_id#">
                            </cfif>
                        </cfif>
                        <cfif isdate(arguments.record_date)>
                            AND SHIP.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('h',-session.ep.time_zone,arguments.record_date)#">
                            AND SHIP.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,DATEADD('h',-session.ep.time_zone,arguments.record_date))#">
                        </cfif>
                        <cfif isdefined('arguments.process_stage') and len(arguments.process_stage)>
                            AND SHIP.PROCESS_STAGE = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
                        </cfif>
                        <cfif isdefined('arguments.record_emp_id') and len(arguments.record_emp_id) and len(arguments.record_name)>
                            AND SHIP.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_emp_id#">
                        </cfif>
                        <cfif isdefined('arguments.EMPO_ID') and len(arguments.EMPO_ID) and len(arguments.EMP_PARTNER_NAMEO)>
                            AND SHIP.SALE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.EMPO_ID#">
                        </cfif>
                        <cfif len(arguments.date1)>
                            AND SHIP.SHIP_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date1#">
                        </cfif>
                        <cfif len(arguments.date2)>
                            AND SHIP.SHIP_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date2#">
                        </cfif>
                        <cfif len(arguments.department_id)>
                            AND DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
                            <cfif len(arguments.location_id)>
                                AND LOCATION_IN = #arguments.location_id#
                            </cfif>
                        <cfelseif session.ep.isBranchAuthorization and (isDefined("arguments.cat") and len(arguments.cat) and listFind("73,74,75,76,77,80,81,82,84,761,811",listfirst(arguments.cat,'-'))) or not(isDefined("arguments.cat") and len(arguments.cat))>
                            AND 
                            (
                                SHIP.DEPARTMENT_IN IN (#valuelist(get_my_department.department_id)#) OR
                                SHIP.DELIVER_STORE_ID IN (#valuelist(get_my_department.department_id)#)
                            )	
                        </cfif>
                        <cfif len(arguments.department_out)>
                            <cfif xml_department_filter neq 1>
                                AND (SHIP.DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_out#"> OR SHIP.DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_out#">)
                                <cfif len(arguments.location_out)>
                                    AND (SHIP.LOCATION_IN = #arguments.location_out# OR SHIP.LOCATION = #arguments.location_out#)
                                </cfif>
                            <cfelse>	
                                AND SHIP.DELIVER_STORE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_out#">
                                <cfif len(arguments.location_out)>
                                    AND SHIP.LOCATION = #arguments.location_out#	
                                </cfif>
                            </cfif>
                        <cfelseif session.ep.isBranchAuthorization and (isDefined("arguments.cat") and len(arguments.cat) and listFind("70,71,72,78,79,83,87,88",listfirst(arguments.cat,'-'))) or not(isDefined("arguments.cat") and len(arguments.cat))>
                            AND 
                            (
                                SHIP.DELIVER_STORE_ID IN (#valuelist(get_my_department.department_id)#) OR 
                                SHIP.DEPARTMENT_IN IN (#valuelist(get_my_department.department_id)#)
                            )
                        </cfif> 	
                        <cfif len(arguments.eshipment_type)>
                            AND SHIP.SHIP_TYPE IN (70,71,72,78,79,81,82,83,85,88,761)
                            AND ( SHIP.IS_WITH_SHIP = 0 OR SHIP.IS_WITH_SHIP IS NULL )
                            <cfif arguments.eshipment_type eq 1>
                                AND 
                                ( 
                                    (SELECT COUNT(SENDING_DETAIL_ID) FROM ESHIPMENT_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = SHIP.SHIP_ID and ( ESD.ACTION_TYPE = 'SHIP' OR ESD.ACTION_TYPE = 'SHIP_SEVK' ) AND STATUS_CODE = 1 ) = 0 
                                )
                            <cfelseif arguments.eshipment_type eq 2>
                                AND 
                                ( 
                                    (SELECT COUNT(SENDING_DETAIL_ID) FROM ESHIPMENT_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = SHIP.SHIP_ID and ( ESD.ACTION_TYPE = 'SHIP' OR ESD.ACTION_TYPE = 'SHIP_SEVK' ) AND STATUS_CODE = 1 ) > 0 
                                    AND ( ER.STATUS_CODE <> 1 OR ER.STATUS_CODE IS NULL)
                                )
                            <cfelseif arguments.eshipment_type eq 3>
                                AND 
                                (
                                    (SELECT COUNT(SENDING_DETAIL_ID) FROM ESHIPMENT_SENDING_DETAIL ESD WHERE ESD.ACTION_ID = SHIP.SHIP_ID AND ( ESD.ACTION_TYPE = 'SHIP' OR ESD.ACTION_TYPE = 'SHIP_SEVK' ) AND STATUS_CODE = 1) > 0 
                                    AND ER.PATH IS NOT NULL
                                    AND ER.STATUS_CODE = 1
                                )
                            </cfif>
                        </cfif>
                        <cfif len(arguments.belge_no)>
                            AND ((SHIP.SHIP_NUMBER LIKE '<cfif len(arguments.belge_no) gt 3>%</cfif>#arguments.belge_no#%') OR
                                (SHIP.REF_NO LIKE '<cfif len(arguments.belge_no) gt 3>%</cfif>#arguments.belge_no#%'))
                        </cfif>
                        <cfif len(arguments.project_id)>
                            <cfif xml_project_filter neq 1>
                                AND (SHIP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"> OR SHIP.PROJECT_ID_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">)
                            <cfelse>	
                                AND SHIP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
                            </cfif>
                        </cfif>
                        <cfif len(arguments.project_id_in)>
                            AND SHIP.PROJECT_ID_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id_in#">
                        </cfif>
                        <cfif isdefined('arguments.subscription_id') and len(arguments.subscription_id) and isdefined('arguments.subscription_no') and len(arguments.subscription_no)>
                            AND SHIP.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#">
                        </cfif>
                        <cfif len(arguments.employee_id) and arguments.employee_id gt 0>
                            AND SHIP.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.employee_id#">
                        <cfelseif len(arguments.consumer_id) and arguments.consumer_id gt 0>
                            AND SHIP.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.consumer_id#">
                        <cfelseif isdefined('arguments.company') and len(arguments.company) and len(arguments.company_id) and arguments.company_id gt 0>
                            AND SHIP.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.company_id#">
                        </cfif>
                        <cfif len(arguments.iptal_stocks)>
                            AND ISNULL(SHIP.IS_SHIP_IPTAL,0) = #arguments.iptal_stocks#
                        </cfif>
                        <cfif len(arguments.stock_id) and len(arguments.product_name)>
                            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2>
                                AND SHIP_ROW.STOCK_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
                            <cfelse>
                                AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM SHIP_ROW WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">)
                            </cfif>
                        </cfif>
                        <cfif len(arguments.product_cat_code) and len(arguments.product_cat_name)>
                            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme --->
                                AND SHIP_ROW.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #this.dsn1_alias#.PRODUCT P WHERE P.PRODUCT_CODE LIKE '#arguments.product_cat_code#.%')
                            <cfelse>
                                AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM SHIP_ROW SR, #this.dsn1_alias#.PRODUCT P WHERE P.PRODUCT_ID = SR.PRODUCT_ID AND P.PRODUCT_CODE LIKE '#arguments.product_cat_code#.%')
                            </cfif>
                        </cfif>
                        <cfif len(arguments.delivered) and arguments.delivered eq 1>
                            AND SHIP.IS_DELIVERED = 1
                        <cfelseif  len(arguments.delivered) and arguments.delivered eq 0>
                            AND (
                                SHIP.IS_DELIVERED = 0 
                                OR SHIP.IS_DELIVERED IS NULL
                            )
                            AND SHIP.SHIP_TYPE IN (81,811)
                        </cfif>
                        <cfif (isdefined("arguments.deliver_emp") and len(arguments.deliver_emp))>
                            AND(
                            <cfif len(arguments.deliver_emp)>
                                (SHIP.PURCHASE_SALES = 1 AND SHIP.DELIVER_EMP LIKE '<cfif len(arguments.deliver_emp) gt 3>%</cfif>#arguments.deliver_emp#%')
                            </cfif>
                            <cfif len(arguments.deliver_emp_id)>
                            <cfif len(arguments.deliver_emp)>OR</cfif>(SHIP.PURCHASE_SALES = 0 AND (SHIP.DELIVER_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.deliver_emp_id#">))
                            </cfif>
                            )
                        </cfif>
                        <cfif len(arguments.member_name) >
                            AND SHIP.DELIVER_EMP LIKE '%#arguments.member_name#%'
                        </cfif>
                        <cfif len(arguments.work_id)>
                            AND SHIP.WORK_ID = #arguments.work_id#
                        </cfif>
                        <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2 and listfirst(arguments.cat,'-') eq 76>
                            <cfif len(arguments.disp_ship_state) and arguments.disp_ship_state eq 1><!--- işlem görmemiş --->
                                AND SHIP_ROW.WRK_ROW_ID NOT IN (SELECT
                                                                    SHIP_ROW.WRK_ROW_ID
                                                                FROM 	
                                                                    SHIP WITH (NOLOCK)
                                                                    ,SHIP_ROW WITH (NOLOCK)
                                                                WHERE 
                                                                    SHIP.SHIP_TYPE = 76 
                                                                    AND SHIP.SHIP_ID = SHIP_ROW.SHIP_ID
                                                                    AND SHIP_ROW.DELIVER_DEPT IS NOT NULL
                                                                    AND SHIP_ROW.WRK_ROW_ID IN (SELECT SHR.WRK_ROW_RELATION_ID FROM SHIP_ROW SHR,SHIP SH WHERE SHR.SHIP_ID=SH.SHIP_ID AND SH.SHIP_TYPE = 81))
                            <cfelseif len(arguments.disp_ship_state) and arguments.disp_ship_state eq 2><!--- işlem tamamlanmamış --->
                                AND SHIP_ROW.WRK_ROW_ID IN (SELECT SHR.WRK_ROW_RELATION_ID FROM SHIP_ROW SHR,SHIP SH WHERE SHR.SHIP_ID=SH.SHIP_ID AND SH.SHIP_TYPE = 81)	
                                AND SHIP_ROW.AMOUNT > (ISNULL((SELECT SUM(SHIP_ROW_.AMOUNT) FROM SHIP_ROW SHIP_ROW_ WHERE SHIP_ROW.WRK_ROW_ID IN (SHIP_ROW_.WRK_ROW_RELATION_ID)),0))	
                            <cfelseif len(arguments.disp_ship_state) and arguments.disp_ship_state eq 3><!--- işlem tamamlanmış // ilişkili irsaliyelerin toplamı mal alım irsaliyesinden büyük veya eşit--->
                                AND SHIP_ROW.WRK_ROW_ID IN (SELECT SHR.WRK_ROW_RELATION_ID FROM SHIP_ROW SHR,SHIP SH WHERE SHR.SHIP_ID=SH.SHIP_ID AND SH.SHIP_TYPE = 81)	
                                AND SHIP_ROW.AMOUNT <= (ISNULL((SELECT SUM(SHIP_ROW_.AMOUNT) FROM SHIP_ROW SHIP_ROW_ WHERE SHIP_ROW.WRK_ROW_ID IN (SHIP_ROW_.WRK_ROW_RELATION_ID)),0))	
                            </cfif>
                        </cfif>
                    </cfif>
                </cfif>
                <cfif ( not (len(arguments.company) and (len(arguments.consumer_id) or len(arguments.company_id)) ) or len(arguments.invoice_action) or len(arguments.EMP_PARTNER_NAMEO) or len(arguments.eshipment_type))>
                    <cfif not len(arguments.cat)>
                    UNION ALL
                    </cfif>
                    <cfif (len(arguments.cat) and listFind("110,111,112,113,114,115,119,1131,118,1182",listfirst(arguments.cat,'-'))) or not len(arguments.cat)>
                        SELECT
                            2 TABLE_TYPE,
                            '' IS_WITH_SHIP,
                            STOCK_FIS.PROCESS_CAT PROCESS_CAT,
                            STOCK_FIS.PROJECT_ID PROJECT_ID,
                            (SELECT PROJECT_HEAD FROM #this.dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = STOCK_FIS.PROJECT_ID) PROJECT_HEAD,
                            STOCK_FIS.PROJECT_ID_IN,
                            (SELECT PROJECT_HEAD FROM #this.dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = STOCK_FIS.PROJECT_ID_IN) PROJECT_HEAD_IN,
                        <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                            (SELECT TOP 1 PRODUCT_NAME FROM #this.dsn3_alias#.STOCKS STOCKS WITH (NOLOCK) WHERE STOCK_ID = STOCK_FIS_ROW.STOCK_ID) AS NAME_PRODUCT,
                            (SELECT TOP 1 STOCK_CODE FROM #this.dsn3_alias#.STOCKS STOCKS WITH (NOLOCK) WHERE STOCK_ID = STOCK_FIS_ROW.STOCK_ID) AS STOCK_CODE,
                            (SELECT TOP 1 PRODUCT_ID FROM #this.dsn3_alias#.STOCKS STOCKS WITH (NOLOCK) WHERE STOCK_ID = STOCK_FIS_ROW.STOCK_ID) AS PRODUCT_ID,
                            STOCK_FIS_ROW.AMOUNT,
                            STOCK_FIS_ROW.PRICE,
                            STOCK_FIS_ROW.NET_TOTAL AS NETTOTAL,                        
                            STOCK_FIS_ROW.LOT_NO LOT_NO,
                        </cfif>
                            -1 PURCHASE_SALES,
                            STOCK_FIS.EMPLOYEE_ID DELIVER_EMP_ID,
                            STOCK_FIS.FIS_ID ISLEM_ID,
                            STOCK_FIS.FIS_NUMBER BELGE_NO,
                            STOCK_FIS.REF_NO REFERANS,
                            FIS_TYPE ISLEM_TIPI,
                            FIS_DATE ISLEM_TARIHI,
                            STOCK_FIS.DELIVER_DATE SEVK_TARIHI,
                            STOCK_FIS.COMPANY_ID ,
                            STOCK_FIS.CONSUMER_ID,
                            STOCK_FIS.PARTNER_ID,
                            STOCK_FIS.EMPLOYEE_ID,
                            DEPARTMENT_IN DEPARTMENT_ID,
                            LOCATION_IN LOCATION,
                            DEPARTMENT_OUT DEPARTMENT_ID_2,
                            LOCATION_OUT LOCATION_2,
                            '' INVOICE_NUMBER,
                            '' DELIVER_EMP,
                            STOCK_FIS.RECORD_DATE,
                            STOCK_FIS.RECORD_EMP,
                            STOCK_FIS.WORK_ID,
                            IS_STOCK_TRANSFER,
                            0 STOCK_EXCHANGE_TYPE,
                            PRO_WORKS.WORK_HEAD,
                            (select DEPARTMENT_HEAD FROM  #this.dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = STOCK_FIS.DEPARTMENT_IN) DEPT_IN,
                            (SELECT COMMENT FROM  #this.dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID = STOCK_FIS.DEPARTMENT_IN AND LOCATION_ID = STOCK_FIS.LOCATION_IN) LOC_IN,
                            (SELECT DEPARTMENT_HEAD FROM  #this.dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = STOCK_FIS.DEPARTMENT_OUT) DEPT_OUT,
                            (SELECT COMMENT FROM  #this.dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID = STOCK_FIS.DEPARTMENT_OUT AND LOCATION_ID = STOCK_FIS.LOCATION_OUT) LOC_OUT,
                            (SELECT STAGE FROM #this.dsn_alias#.PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = STOCK_FIS.PROCESS_STAGE ) as STAGE,
                            STOCK_FIS.PROCESS_STAGE                                                                                                                               
                        FROM
                            STOCK_FIS WITH (NOLOCK)
                                LEFT JOIN #this.dsn_alias#.PRO_WORKS ON STOCK_FIS.WORK_ID = PRO_WORKS.WORK_ID
                        <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                            ,STOCK_FIS_ROW WITH (NOLOCK)
                        </cfif>
                        WHERE 
                            <cfif  arguments.iptal_stocks eq 1>
                                1=0 AND
                            <cfelse>
                                1=1 AND                 
                            </cfif>
                            <cfif len(arguments.cat) and listlast(arguments.cat,'-') eq 0>
                                STOCK_FIS.FIS_TYPE = #listfirst(arguments.cat,'-')#
                            <cfelseif len(arguments.cat) and listlast(arguments.cat,'-') neq 0>
                                STOCK_FIS.PROCESS_CAT = #listlast(arguments.cat,'-')#
                            <cfelse>
                                STOCK_FIS.FIS_ID IS NOT NULL
                            </cfif>
                        <!--- AND STOCK_FIS.FIS_ID IN(SELECT SRR.UPD_ID FROM STOCKS_ROW SRR WHERE SRR.PROCESS_TYPE = STOCK_FIS.FIS_TYPE) ****stok hareketi yapma zorunluluğu irsaliyede yok ama fişler için eklenmiş kapatıyorum PY 0515--->
                            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                                AND STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID
                                <cfif len(arguments.row_department_id)>
                                    AND 1 = 0
                                </cfif>	
                                <cfif len(arguments.row_project_id) and len(arguments.row_project_head)>
                                    AND STOCK_FIS_ROW.ROW_PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.row_project_id#">
                                </cfif>
                                <cfif isDefined("arguments.spect_var_id") and len(arguments.spect_var_id)>
                                    AND STOCK_FIS_ROW.SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.spect_var_id#">
                                </cfif>
                            </cfif>
                            <cfif isdefined('arguments.lot_no') and len(arguments.lot_no)>
                                <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme --->
                                    AND STOCK_FIS_ROW.LOT_NO LIKE '<cfif len(arguments.lot_no) gt 3>%</cfif>#arguments.lot_no#%'
                                <cfelse>
                                    AND STOCK_FIS.FIS_ID IN (SELECT FIS_ID FROM STOCK_FIS_ROW SFR WHERE SFR.FIS_ID = STOCK_FIS.FIS_ID AND SFR.LOT_NO LIKE '<cfif len(arguments.lot_no) gt 3>%</cfif>#arguments.lot_no#%')
                                </cfif>
                            </cfif>
                            <cfif len(arguments.product_cat_code) and len(arguments.product_cat_name)>
                                <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme --->
                                    AND STOCK_FIS_ROW.STOCK_ID IN (SELECT STOCK_ID FROM #this.dsn3_alias#.STOCKS P WHERE P.PRODUCT_CODE LIKE '#arguments.product_cat_code#.%')
                                <cfelse>
                                    AND STOCK_FIS.FIS_ID IN (SELECT FIS_ID FROM STOCK_FIS_ROW SFR, #this.dsn1_alias#.PRODUCT P, #this.dsn1_alias#.STOCKS S WHERE S.STOCK_ID = SFR.STOCK_ID AND P.PRODUCT_ID = S.PRODUCT_ID AND P.PRODUCT_CODE LIKE '#arguments.product_cat_code#.%')
                                </cfif>
                            </cfif>
                            <cfif len(arguments.record_date)>
                                AND STOCK_FIS.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('h',-session.ep.time_zone,arguments.record_date)#">
                                AND STOCK_FIS.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,DATEADD('h',-session.ep.time_zone,arguments.record_date))#">
                            </cfif>
                            <cfif isdefined('arguments.process_stage') and len(arguments.process_stage)>
                                AND STOCK_FIS.PROCESS_STAGE  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
                            </cfif>
                            <cfif isdefined('arguments.record_emp_id') and len(arguments.record_emp_id) and len(arguments.record_name)>
                                AND STOCK_FIS.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_emp_id#">
                            </cfif>
                            <cfif len(arguments.date1)>
                                AND STOCK_FIS.FIS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date1#">
                            </cfif>
                            <cfif len(arguments.date2)>
                                AND STOCK_FIS.FIS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date2#">
                            </cfif>
                            <cfif len(arguments.department_id)>
                                AND DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
                                <cfif len(arguments.location_id)>
                                    AND LOCATION_IN = #arguments.location_id#
                                </cfif>
                            <cfelseif session.ep.isBranchAuthorization>
                                AND 
                                (
                                    DEPARTMENT_IN IN (#valuelist(get_my_department.department_id)#) OR DEPARTMENT_IN IS NULL
                                )		
                            </cfif>	
                            <cfif len(arguments.department_out)>
                                <cfif xml_department_filter neq 1>
                                    AND (DEPARTMENT_OUT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_out#"> OR DEPARTMENT_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_out#">)
                                    <cfif len(arguments.location_out)>
                                        AND (LOCATION_IN = #arguments.location_out# OR LOCATION_OUT = #arguments.location_out#)	
                                    </cfif>
                                <cfelse>	
                                    AND DEPARTMENT_OUT = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_out#">
                                    <cfif len(arguments.location_out)>
                                        AND LOCATION_OUT = #arguments.location_out#	
                                    </cfif>
                                </cfif>
                            <cfelseif session.ep.isBranchAuthorization>
                                AND 
                                (
                                    DEPARTMENT_OUT IN (#valuelist(get_my_department.department_id)#) OR DEPARTMENT_OUT IS NULL
                                )	
                            </cfif>		  
                            <cfif len(arguments.belge_no)>
                                AND ((STOCK_FIS.FIS_NUMBER LIKE '<cfif len(arguments.belge_no) gt 3>%</cfif>#arguments.belge_no#%') OR
                                (STOCK_FIS.REF_NO LIKE '<cfif len(arguments.belge_no) gt 3>%</cfif>#arguments.belge_no#%'))
                            </cfif>
                            <cfif len(arguments.project_id)>
                                <cfif xml_project_filter neq 1>
                                    AND (STOCK_FIS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#"> OR STOCK_FIS.PROJECT_ID_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">)
                                <cfelse>	
                                    AND STOCK_FIS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
                                </cfif>
                            </cfif>
                            <cfif len(arguments.project_id_in)>
                                AND STOCK_FIS.PROJECT_ID_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id_in#">
                            </cfif>
                            <cfif isdefined('arguments.subscription_id') and len(arguments.subscription_id) and isdefined('arguments.subscription_no') and len(arguments.subscription_no)>
                                AND STOCK_FIS.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscription_id#">
                            </cfif>
                            <cfif len(arguments.stock_id) and len(arguments.product_name)>
                                <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2>
                                    AND STOCK_FIS_ROW.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
                                <cfelse>
                                    AND STOCK_FIS.FIS_ID IN (SELECT FIS_ID FROM STOCK_FIS_ROW WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">)
                                </cfif>
                            </cfif> 
                            <cfif len(arguments.employee_id_2) and len(arguments.member_name)>
                            AND STOCK_FIS.EMPLOYEE_ID = #arguments.employee_id_2#
                            <cfelseif len(arguments.consumer_id_2) and len(arguments.member_name)>
                                AND STOCK_FIS.CONSUMER_ID = #arguments.consumer_id_2#
                            <cfelseif len(arguments.company_id_2) and len(arguments.member_name)>
                                AND STOCK_FIS.COMPANY_ID = #arguments.company_id_2#
                            </cfif>
                            
                            <cfif len(arguments.delivered)>
                                AND 1 = 2
                            </cfif>
                            <cfif len(arguments.work_id)>
                                AND STOCK_FIS.WORK_ID = #arguments.work_id#
                            </cfif>
                    </cfif>
                    <cfif not len(arguments.cat) and not len(arguments.project_id) and not len(arguments.project_id_in) and not len(arguments.member_name)><!--- and kaldirdim_hata_veriyornot len(arguments.work_id)---><!--- FBS 20080407 proje,teslim alan STOCK_EXCHANGE de olmadigindan bu kosula girmemeli --->
                        UNION ALL
                    </cfif>
                    <cfif (len(arguments.cat) and listFind("116",listfirst(arguments.cat,'-'))) or not len(arguments.cat) and not len(arguments.project_id) and not len(arguments.project_id_in) and not len(arguments.member_name)><!--- FBS 20080407 proje,teslim alan STOCK_EXCHANGE de olmadigindan bu kosula girmemeli --->
                        SELECT DISTINCT
                            3 TABLE_TYPE,
                            '' IS_WITH_SHIP,
                            STOCK_EXCHANGE.PROCESS_CAT PROCESS_CAT,
                            '' PROJECT_ID,
                            '' PROJECT_HEAD,
                            '' PROJECT_ID_IN,
                            '' PROJECT_HEAD_IN,
                            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Eger satir bazinda listeleme yapiliyorsa --->
                                (SELECT TOP 1 PRODUCT_NAME FROM #this.dsn3_alias#.STOCKS STOCKS WITH (NOLOCK) WHERE STOCK_ID = STOCK_EXCHANGE.STOCK_ID) AS NAME_PRODUCT,
                                (SELECT TOP 1 STOCK_CODE FROM #this.dsn3_alias#.STOCKS STOCKS WITH (NOLOCK) WHERE STOCK_ID = STOCK_EXCHANGE.STOCK_ID) AS STOCK_CODE,
                                STOCK_EXCHANGE.PRODUCT_ID PRODUCT_ID,
                                STOCK_EXCHANGE.AMOUNT,
                                0 PRICE,
                            0 NETTOTAL,
                                STOCK_EXCHANGE.LOT_NO,
                            </cfif>
                            -1 PURCHASE_SALES,
                            '' DELIVER_EMP_ID,
                            (SELECT TOP 1 SS.STOCK_EXCHANGE_ID FROM STOCK_EXCHANGE SS WHERE SS.EXCHANGE_NUMBER = STOCK_EXCHANGE.EXCHANGE_NUMBER) ISLEM_ID,
                            STOCK_EXCHANGE.EXCHANGE_NUMBER BELGE_NO,
                            '' REFERANS,
                            STOCK_EXCHANGE.PROCESS_TYPE ISLEM_TIPI,
                            STOCK_EXCHANGE.PROCESS_DATE ISLEM_TARIHI,
                            STOCK_EXCHANGE.PROCESS_DATE SEVK_TARIHI,
                            0 COMPANY_ID,
                            0 CONSUMER_ID,
                            0 PARTNER_ID,
                            0 EMPLOYEE_ID,
                            STOCK_EXCHANGE.DEPARTMENT_ID DEPARTMENT_ID,
                            STOCK_EXCHANGE.LOCATION_ID LOCATION,
                            0 DEPARTMENT_ID_2,
                            0 LOCATION_2,
                            '' INVOICE_NUMBER,
                            '' DELIVER_EMP,
                            STOCK_EXCHANGE.RECORD_DATE,
                            STOCK_EXCHANGE.RECORD_EMP,
                            '' WORK_ID,
                            0 IS_STOCK_TRANSFER,
                            STOCK_EXCHANGE.STOCK_EXCHANGE_TYPE,
                            '' WORK_HEAD,
                            (select DEPARTMENT_HEAD FROM  #this.dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = STOCK_EXCHANGE.DEPARTMENT_ID) DEPT_IN,                       
                            (SELECT COMMENT FROM  #this.dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID = STOCK_EXCHANGE.DEPARTMENT_ID AND LOCATION_ID = STOCK_EXCHANGE.LOCATION_ID) LOC_IN,
                            (SELECT DEPARTMENT_HEAD FROM  #this.dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = 0) DEPT_OUT,
                            (SELECT COMMENT FROM  #this.dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID = 0 AND LOCATION_ID = 0) LOC_OUT,
                            (SELECT STAGE FROM #this.dsn_alias#.PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = STOCK_EXCHANGE.PROCESS_STAGE ) as STAGE,
                            STOCK_EXCHANGE.PROCESS_STAGE                                                                                                                                                                                                        
                        FROM
                            STOCK_EXCHANGE WITH (NOLOCK)
                        WHERE                     
                        <cfif len(arguments.cat) and listlast(arguments.cat,'-') eq 0>
                            STOCK_EXCHANGE.PROCESS_TYPE = #listfirst(arguments.cat,'-')#
                        <cfelseif len(arguments.cat) and listlast(arguments.cat,'-') neq 0>
                            STOCK_EXCHANGE.PROCESS_CAT = #listlast(arguments.cat,'-')#
                        <cfelse>
                            STOCK_EXCHANGE.STOCK_EXCHANGE_ID IS NOT NULL
                        </cfif>
                        <cfif isdefined('arguments.lot_no') and Len(arguments.lot_no)>
                            AND 1 = 0
                        </cfif>
                        <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2 and len(arguments.row_department_id)>
                            AND 1 = 0
                        </cfif>
                        <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2 and len(arguments.row_project_id)>
                            AND 1 = 0
                        </cfif>
                        <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2 and isDefined("arguments.spect_var_id") and len(arguments.spect_var_id)>
                            AND 1 = 0
                        </cfif>
                        <cfif len(arguments.product_cat_code) and len(arguments.product_cat_name)>
                            AND STOCK_EXCHANGE.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #this.dsn1_alias#.PRODUCT P WHERE P.PRODUCT_CODE LIKE '#arguments.product_cat_code#.%')
                        </cfif>
                        <cfif len(arguments.record_date)>
                            AND STOCK_EXCHANGE.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('h',-session.ep.time_zone,arguments.record_date)#">
                            AND STOCK_EXCHANGE.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,DATEADD('h',-session.ep.time_zone,arguments.record_date))#">
                        </cfif>
                        <cfif isdefined('arguments.process_stage') and len(arguments.process_stage)>
                            AND STOCK_EXCHANGE.PROCESS_STAGE  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
                        </cfif>
                        <cfif isdefined('arguments.record_emp_id') and len(arguments.record_emp_id) and len(arguments.record_name)>
                            AND STOCK_EXCHANGE.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_emp_id#">
                        </cfif>
                        <cfif len(arguments.date1)>
                            AND STOCK_EXCHANGE.PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date1#">
                        </cfif>
                        <cfif len(arguments.date2)>
                            AND STOCK_EXCHANGE.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date2#">
                        </cfif>
                        <cfif isdefined('arguments.subscription_id') and len(arguments.subscription_id) and isdefined('arguments.subscription_no') and len(arguments.subscription_no)>
                            AND STOCK_EXCHANGE.STOCK_EXCHANGE_ID = -1
                        </cfif>
                        <cfif len(arguments.department_id)>
                                AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
                            <cfif len(arguments.location_id)>
                                AND DEPARTMENT_ID =  #arguments.department_id# AND LOCATION_ID = #arguments.location_id#
                            </cfif>
                        <cfelseif session.ep.isBranchAuthorization>
                            AND DEPARTMENT_ID IN (#valuelist(get_my_department.department_id)#)
                        </cfif>	
                        <cfif len(arguments.department_out)>
                            <cfif xml_department_filter neq 1>
                                AND (EXIT_DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_out#"> OR DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_out#">)
                                <cfif len(arguments.location_out)>
                                    AND (LOCATION_ID = #arguments.location_out# OR EXIT_LOCATION_ID = #arguments.location_out#)	
                                </cfif>
                            <cfelse>	
                                AND EXIT_DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_out#">
                                <cfif len(arguments.location_out)>
                                    AND EXIT_LOCATION_ID = #arguments.location_out#	
                                </cfif>
                            </cfif>
                        <cfelseif session.ep.isBranchAuthorization>
                            AND EXIT_DEPARTMENT_ID IN (#valuelist(get_my_department.department_id)#)
                        </cfif>	
                        <cfif len(arguments.belge_no)>
                            AND (EXCHANGE_NUMBER LIKE '<cfif len(arguments.belge_no) gt 3>%</cfif>#arguments.belge_no#%')
                        </cfif>
                        <cfif len(arguments.stock_id) and len(arguments.product_name)>
                            AND 
                            (
                                <cfif not (isdefined('arguments.listing_type') and arguments.listing_type eq 2)>
                                    STOCK_EXCHANGE.EXIT_STOCK_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#"> OR
                                </cfif>
                                STOCK_EXCHANGE.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
                            )
                        </cfif>
                        <cfif len(arguments.delivered)>
                            AND 1 = 2
                        </cfif>	
                        <cfif (isdefined("arguments.deliver_emp_id") and len(arguments.deliver_emp_id)) and (isdefined("arguments.deliver_emp") and len(arguments.deliver_emp))>AND 1 = 0</cfif>
                        <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2 and not len(arguments.spect_var_id)><!--- Satir bazinda listeleme yapiliyorsa  *cikis*--->
                            UNION ALL
                            SELECT
                                3 TABLE_TYPE,
                                '' IS_WITH_SHIP,
                                STOCK_EXCHANGE.PROCESS_CAT PROCESS_CAT,
                                '' PROJECT_ID,
                                '' PROJECT_HEAD,
                                '' PROJECT_ID_IN,
                                '' PROJECT_HEAD_IN,
                                <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Eger satir bazinda listeleme yapiliyorsa --->
                                    (SELECT TOP 1 PRODUCT_NAME FROM #this.dsn3_alias#.STOCKS STOCKS WITH (NOLOCK) WHERE STOCK_ID = STOCK_EXCHANGE.EXIT_STOCK_ID) AS NAME_PRODUCT,
                                    (SELECT TOP 1 STOCK_CODE FROM #this.dsn3_alias#.STOCKS STOCKS WITH (NOLOCK) WHERE STOCK_ID = STOCK_EXCHANGE.EXIT_STOCK_ID) AS STOCK_CODE,
                                    STOCK_EXCHANGE.PRODUCT_ID PRODUCT_ID,
                                    STOCK_EXCHANGE.EXIT_AMOUNT AMOUNT,
                                    0 PRICE,
                                    0 NETTOTAL,
                                    STOCK_EXCHANGE.EXIT_LOT_NO LOT_NO,
                                </cfif>
                                -1 PURCHASE_SALES,
                                '' DELIVER_EMP_ID,
                                STOCK_EXCHANGE.STOCK_EXCHANGE_ID ISLEM_ID,
                                STOCK_EXCHANGE.EXCHANGE_NUMBER BELGE_NO,
                                '' REFERANS,
                                STOCK_EXCHANGE.PROCESS_TYPE ISLEM_TIPI,
                                STOCK_EXCHANGE.PROCESS_DATE ISLEM_TARIHI,
                                STOCK_EXCHANGE.PROCESS_DATE SEVK_TARIHI,
                                0 COMPANY_ID,
                                0 CONSUMER_ID,
                                0 PARTNER_ID,
                                0 EMPLOYEE_ID,
                                0 DEPARTMENT_ID,
                                0 LOCATION,
                                STOCK_EXCHANGE.EXIT_DEPARTMENT_ID DEPARTMENT_ID_2,
                                STOCK_EXCHANGE.EXIT_LOCATION_ID LOCATION_2,
                                '' INVOICE_NUMBER,
                                '' DELIVER_EMP,
                                STOCK_EXCHANGE.RECORD_DATE,
                                STOCK_EXCHANGE.RECORD_EMP,
                                '' WORK_ID,
                                0 IS_STOCK_TRANSFER,
                                STOCK_EXCHANGE.STOCK_EXCHANGE_TYPE,
                                '' WORK_HEAD,
                                (select DEPARTMENT_HEAD FROM  #this.dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = STOCK_EXCHANGE.DEPARTMENT_ID) DEPT_IN,                       
                                (SELECT COMMENT FROM  #this.dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID = STOCK_EXCHANGE.DEPARTMENT_ID AND LOCATION_ID = STOCK_EXCHANGE.LOCATION_ID) LOC_IN,
                                (SELECT DEPARTMENT_HEAD FROM  #this.dsn_alias#.DEPARTMENT WHERE DEPARTMENT_ID = STOCK_EXCHANGE.EXIT_DEPARTMENT_ID) DEPT_OUT,
                                (SELECT COMMENT FROM  #this.dsn_alias#.STOCKS_LOCATION WHERE DEPARTMENT_ID = STOCK_EXCHANGE.EXIT_DEPARTMENT_ID AND LOCATION_ID = STOCK_EXCHANGE.EXIT_LOCATION_ID) LOC_OUT,
                                (SELECT STAGE FROM #this.dsn_alias#.PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = STOCK_EXCHANGE.PROCESS_STAGE ) as STAGE,
                                STOCK_EXCHANGE.PROCESS_STAGE                                                                                                                                                                                                                                                                                            
                            FROM
                                STOCK_EXCHANGE WITH (NOLOCK)
                            WHERE 
                            <cfif len(arguments.cat) and listlast(arguments.cat,'-') eq 0>
                                STOCK_EXCHANGE.PROCESS_TYPE = #listfirst(arguments.cat,'-')#
                            <cfelseif len(arguments.cat) and listlast(arguments.cat,'-') neq 0>
                                STOCK_EXCHANGE.PROCESS_CAT = #listlast(arguments.cat,'-')#
                            <cfelse>
                                STOCK_EXCHANGE.STOCK_EXCHANGE_ID IS NOT NULL
                            </cfif>
                            <cfif isdefined('arguments.lot_no') and Len(arguments.lot_no)>
                                AND 1 = 0
                            </cfif>
                            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2 and len(arguments.row_department_id)>
                                AND 1 = 0
                            </cfif>
                            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2 and len(arguments.row_project_id)>
                                AND 1 = 0
                            </cfif>
                            <cfif len(arguments.product_cat_code) and len(arguments.product_cat_name)>
                                AND STOCK_EXCHANGE.EXIT_PRODUCT_ID IN (SELECT PRODUCT_ID FROM #this.dsn1_alias#.PRODUCT P WHERE P.PRODUCT_CODE LIKE '#arguments.product_cat_code#.%')
                            </cfif>
                            <cfif len(arguments.record_date)>
                                AND STOCK_EXCHANGE.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('h',-session.ep.time_zone,arguments.record_date)#">
                                AND STOCK_EXCHANGE.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,DATEADD('h',-session.ep.time_zone,arguments.record_date))#">
                            </cfif>
                            <cfif isdefined('arguments.process_stage') and len(arguments.process_stage)>
                                AND STOCK_EXCHANGE.PROCESS_STAGE  = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.process_stage#">
                            </cfif>
                            <cfif isdefined('arguments.record_emp_id') and len(arguments.record_emp_id) and len(arguments.record_name)>
                                AND STOCK_EXCHANGE.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_emp_id#">
                            </cfif>
                            <cfif len(arguments.date1)>
                                AND STOCK_EXCHANGE.PROCESS_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date1#">
                            </cfif>
                            <cfif len(arguments.date2)>
                                AND STOCK_EXCHANGE.PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date2#">
                            </cfif>
                            <cfif isdefined('arguments.subscription_id') and len(arguments.subscription_id) and isdefined('arguments.subscription_no') and len(arguments.subscription_no)>
                                AND STOCK_EXCHANGE.STOCK_EXCHANGE_ID = -1
                            </cfif>
                            <cfif isdefined('arguments.subscription_id') and len(arguments.subscription_id) and isdefined('arguments.subscription_no') and len(arguments.subscription_no)>
                                AND STOCK_EXCHANGE.STOCK_EXCHANGE_ID = -1<!--- Boyle bir kayit olamaz, sisteme gore filtrelediginde bu kayitlari getirmesn diye eklendi --->
                            </cfif>
                            <cfif len(arguments.department_id)>
                                AND DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_id#">
                                <cfif len(arguments.location_id)>
                                    AND LOCATION_ID = #arguments.location_id#
                                </cfif>
                            <cfelseif session.ep.isBranchAuthorization>
                                AND DEPARTMENT_ID IN (#valuelist(get_my_department.department_id)#)
                            </cfif>	
                            <cfif len(arguments.department_out)>
                                <cfif xml_department_filter neq 1>
                                    AND (EXIT_DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_out#"> OR DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_out#">)
                                    <cfif len(arguments.location_out)>
                                        AND (LOCATION_ID = #arguments.location_out# OR EXIT_LOCATION_ID = #arguments.location_out#)
                                    </cfif>
                                <cfelse>	
                                    AND EXIT_DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.department_out#">
                                    <cfif len(arguments.location_out)>
                                        AND EXIT_LOCATION_ID = #arguments.location_out#	
                                    </cfif>
                                </cfif>
                            <cfelseif session.ep.isBranchAuthorization>
                                AND EXIT_DEPARTMENT_ID IN (#valuelist(get_my_department.department_id)#)
                            </cfif>	
                            <cfif len(arguments.belge_no)>
                                AND (EXCHANGE_NUMBER LIKE '<cfif len(arguments.belge_no) gt 3>%</cfif>#arguments.belge_no#%')
                            </cfif>
                            <cfif len(arguments.stock_id) and len(arguments.product_name)>
                                AND STOCK_EXCHANGE.EXIT_STOCK_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
                            </cfif>
                            <cfif len(arguments.delivered)>
                                AND 1 = 2
                            </cfif>	
                            <cfif (isdefined("arguments.deliver_emp_id") and len(arguments.deliver_emp_id)) and (isdefined("arguments.deliver_emp") and len(arguments.deliver_emp))>AND 1 = 0</cfif>
                        </cfif>
                    </cfif>
                </cfif>)
                ,CTE2 AS (
                    SELECT
                        CTE1.*,
                        ROW_NUMBER() OVER (
                                            <cfif arguments.oby eq 2>
                                                ORDER BY ISLEM_TARIHI
                                            <cfelseif arguments.oby eq 3>
                                                ORDER BY BELGE_NO
                                            <cfelseif arguments.oby eq 4>
                                                ORDER BY BELGE_NO DESC
                                            <cfelseif arguments.oby eq 5>
                                                ORDER BY STOCK_CODE ASC
                                            <cfelseif arguments.oby eq 6>
                                                ORDER BY STOCK_CODE DESC
                                            <cfelse>
                                                ORDER BY ISLEM_TARIHI DESC
                                            </cfif>
                                            <cfif (len(arguments.cat) and listFind("116",listfirst(arguments.cat,'-'))) or not len(arguments.cat) and not len(arguments.project_id) and not len(arguments.project_id_in) and not len(arguments.member_name)><!--- FBS 20080407 proje,teslim alan STOCK_EXCHANGE de olmadigindan bu kosula girmemeli --->
                                                ,ISLEM_ID
                                            </cfif>
                                            ) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
                    FROM
                        CTE1
                )
                SELECT
                    CTE2.*
                FROM
                    CTE2
                WHERE
                    RowNum BETWEEN #startrow# and #startrow#+(#maxrows#-1)
            </cfquery> 
                
        <cfelse>
            <cfscript>
                get_ship_fis = QueryNew("QUERY_COUNT","VarChar");
            </cfscript>
        </cfif>
        <cfreturn GET_SHIP_FIS/>
    </cffunction>
</cfcomponent>
