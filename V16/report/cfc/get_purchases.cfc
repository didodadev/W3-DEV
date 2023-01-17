<cfinclude template="../../fbx_workcube_funcs.cfm">
<cffunction name="GET_SHIP_FIS_fnc" returntype="query">
	<cfargument name="cat" default="">
	<cfargument name="consumer_id" default=""/>
	<cfargument name="company_id" default=""/>
	<cfargument name="invoice_action" default=""/>
	<cfargument name="listing_type" default=""/>
	<cfargument name="record_date" default=""/>
	<cfargument name="date1" default=""/>
	<cfargument name="date2" default=""/>
	<cfargument name="department_id" default=""/>
	<cfargument name="department_out" default=""/>
	<cfargument name="module_name" default=""/>
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
	<cfargument name="delivered" default=""/>
	<cfargument name="deliver_emp" default=""/>
	<cfargument name="deliver_emp_id" default=""/>
	<cfargument name="company_id_2" default=""/>
	<cfargument name="member_name" default=""/>
	<cfargument name="consumer_id_2" default=""/>
	<cfargument name="employee_id_2" default=""/>
	<cfargument name="lot_no" default=""/>
	<cfargument name="oby" default=""/>
    <cfargument name="work_id" default=""/>
	<cfargument name="startrow" default="">
	<cfargument name="maxrows" default="">
	<cfargument name="disp_ship_state" default="">
	<cfargument name="record_emp_id" default="">
	<cfargument name="record_name" default="">
	<cfargument name="row_department_id" default="">
    <cfquery name="GET_MY_DEPARTMENT" datasource="#this.DSN#">
        SELECT DEPARTMENT_ID FROM #this.dsn_alias#.DEPARTMENT WHERE BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(session.ep.user_location,2,'-')#">
    </cfquery>
    <cfif len(arguments.cat)>
    	<cfset arguments.cat = ListDeleteDuplicates(arguments.cat)>
    </cfif>
    <cfset list1 = "70,71,72,73,74,75,76,77,78,79,80,81,811,82,83,84,88,761,85,86,140,141">
    <cfset list2 = "110,111,112,113,114,115,119,1131,118,1182">
    <cfset list3 = "116">
    <cfset list4 = "70,71,72,73,74,75,76,77,78,79,80,81,811,82,83,84,88,761,85,86,140,141,118,1182">
    <cfset list5 = "110,111,112,113,114,115,116,119,1131">
    <cfloop list="#arguments.cat#" index="cc">
    	<cfif listfind(list1,listfirst(cc,'-'))>
        	<cfset is_irs = 1>
        </cfif>
    </cfloop>
    <cfloop list="#arguments.cat#" index="cc">
    	<cfif listfind(list2,listfirst(cc,'-'))>
        	<cfset is_fis = 1>
        </cfif>
    </cfloop>
    <cfloop list="#arguments.cat#" index="cc">
    	<cfif listfind(list3,listfirst(cc,'-'))>
        	<cfset is_stock_virman = 1>
        </cfif>
    </cfloop>
    <cfloop list="#arguments.cat#" index="cc">
    	<cfif listfind(list4,listfirst(cc,'-'))>
        	<cfset is_case1 = 1>
        </cfif>
    </cfloop>
    <cfloop list="#arguments.cat#" index="cc">
    	<cfif listfind(list5,listfirst(cc,'-'))>
        	<cfset is_case2 = 1>
        </cfif>
    </cfloop>
    <cfset cat_list1 = "">
    <cfset cat_list2 = "">
    <cfif len(arguments.cat)>
        <cfloop list="#arguments.cat#" index="cc">
                <cfset cat_list1 = listappend(cat_list1,listfirst(cc,'-'))>
                <cfif listlast(cc,'-') neq 0>
                    <cfset cat_list2 = listappend(cat_list2,listlast(cc,'-'))>
                </cfif>
        </cfloop>
    </cfif>
    <cfif isdefined("is_case1") or not len (arguments.cat) or (not (len(arguments.consumer_id) or len(arguments.company_id) or len(arguments.invoice_action)) and isdefined("is_case2"))>
        <cfquery name="GET_SHIP_FIS" datasource="#this.DSN2#">
            WITH CTE1 AS (
			<cfif isdefined("is_irs") or not len(arguments.cat)>
                <cfif len(arguments.invoice_action)><!--- faturali mi veya faturasiz mi soruldugu icin INVOICE_SHIPS iliskisi her halukarda aranacak --->
                    SELECT
                        1 TABLE_TYPE,
                        SHIP.PROCESS_CAT PROCESS_CAT,
                        SHIP.PROJECT_ID,
                        (SELECT PROJECT_HEAD FROM #this.dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = SHIP.PROJECT_ID) PROJECT_HEAD,
						SHIP.PROJECT_ID_IN,
                        (SELECT PROJECT_HEAD FROM #this.dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = SHIP.PROJECT_ID_IN) PROJECT_HEAD_IN,
                    <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                        SHIP_ROW.NAME_PRODUCT,
                        STOCKS.STOCK_CODE,
                        SHIP_ROW.PRODUCT_ID,
                        SHIP_ROW.AMOUNT,
                        SHIP_ROW.PRICE,
                        NULL LOT_NO,
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
                        PRO_WORKS.WORK_HEAD
                    FROM 	
                        SHIP WITH (NOLOCK)
                            LEFT JOIN #this.dsn_alias#.PRO_WORKS ON SHIP.WORK_ID = PRO_WORKS.WORK_ID
                        <cfif arguments.invoice_action eq 1>
                            ,INVOICE_SHIPS WITH (NOLOCK)
                        </cfif>
                        <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                            ,SHIP_ROW WITH (NOLOCK)
                            ,#this.dsn3_alias#.STOCKS STOCKS WITH (NOLOCK)
                        </cfif>
                    WHERE 
                    <cfif arguments.invoice_action eq 1>
                        SHIP.SHIP_ID = INVOICE_SHIPS.SHIP_ID
                        AND INVOICE_SHIPS.SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">
                    <cfelse>
                        SHIP.SHIP_ID NOT IN (SELECT SHIP_ID FROM INVOICE_SHIPS WHERE SHIP_PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.period_id#">)
                    </cfif>
					<cfif isdefined('arguments.lot_no') and Len(arguments.lot_no)>
						<cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme --->
							AND 
                            (
								<cfset count_ = 0>
                                <cfloop list="#arguments.lot_no#" index="kk">
                                    (
                                        <cfset count_ = count_+1>
                                       SHIP_ROW.LOT_NO LIKE '<cfif len(arguments.lot_no) gt 3>%</cfif>#kk#%'
                                    )
                                <cfif count_ neq listlen(arguments.lot_no)>OR</cfif>           
                                </cfloop>
                            )
						<cfelse>
							AND 
                            	SHIP.SHIP_ID 
                                	IN (
                                            SELECT SHIP_ID FROM SHIP_ROW SFR WHERE SFR.SHIP_ID = SHIP.SHIP_ID 
                                            AND 
                                            	(
													<cfset count_ = 0>
                                                    <cfloop list="#arguments.lot_no#" index="kk">
                                                        (
                                                            <cfset count_ = count_+1>
                                                           SFR.LOT_NO LIKE '<cfif len(arguments.lot_no) gt 3>%</cfif>#kk#%'
                                                        )
                                                    <cfif count_ neq listlen(arguments.lot_no)>OR</cfif>           
                                                    </cfloop>
                                                )
                                        )
						</cfif>
					</cfif>
                    <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                        AND SHIP.SHIP_ID = SHIP_ROW.SHIP_ID
                        AND SHIP_ROW.STOCK_ID = STOCKS.STOCK_ID
                        AND SHIP_ROW.PRODUCT_ID = STOCKS.PRODUCT_ID
                        <cfif len(arguments.row_department_id)>
                        	AND (
                            <cfset sayac_ = 0>
                        	<cfloop list="#arguments.row_department_id#" index="kk">
                            	<cfset sayac_ = sayac_ + 1>
                            	(<cfif listlen(kk,'-') eq 1>
                                	SHIP_ROW.DELIVER_DEPT = #kk#
                                <cfelse>
                                	SHIP_ROW.DELIVER_DEPT = #listfirst(kk,'-')#
                                    AND SHIP_ROW.DELIVER_LOC = #listlast(kk,'-')#
                                </cfif> 
                               	)
                                <cfif listlen(arguments.row_department_id) neq sayac_>
                                	OR
                                </cfif>
                            </cfloop>
                            	)
                    </cfif>	
                    </cfif>
					<cfif len(cat_list1)>
                    	AND SHIP.SHIP_TYPE IN (#cat_list1#)
                    </cfif>
                    <cfif len(cat_list2)>
                        AND SHIP.PROCESS_CAT IN (#cat_list2#)
                    </cfif>
                    <cfif not len(arguments.cat)>
                        AND SHIP.SHIP_ID IS NOT NULL
                    </cfif>
                    <cfif isdate(arguments.record_date)>
                        AND SHIP.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.record_date#">
                        AND SHIP.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,arguments.record_date)#">
                    </cfif>
					<cfif isdefined('arguments.record_emp_id') and len(arguments.record_emp_id) and len(arguments.record_name)>
						AND SHIP.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_emp_id#">
					</cfif>
                    <cfif len(arguments.date1) and len(arguments.date2)>
                        AND SHIP.SHIP_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date2#">
                    </cfif>
                    <cfif len(arguments.department_id)>
                        AND (
                        <cfset sayac_ = 0>
                        <cfloop list="#arguments.department_id#" index="kk">
                            <cfset sayac_ = sayac_ + 1>
                            (<cfif listlen(kk,'-') eq 1>
                                SHIP.DEPARTMENT_IN = #kk#
                            <cfelse>
                                SHIP.DEPARTMENT_IN = #listfirst(kk,'-')#
                                AND SHIP.LOCATION_IN = #listlast(kk,'-')#
                            </cfif> 
                            )
                            <cfif listlen(arguments.department_id) neq sayac_>
                                OR
                            </cfif>
                        </cfloop>
                            )
                    </cfif>	
                    <cfif len(arguments.department_out)>
                        AND (
                        <cfset sayac_ = 0>
                        <cfloop list="#arguments.department_out#" index="kk">
                            <cfset sayac_ = sayac_ + 1>
                            (<cfif listlen(kk,'-') eq 1>
                                SHIP.DELIVER_STORE_ID = #kk#
                            <cfelse>
                                SHIP.DELIVER_STORE_ID = #listfirst(kk,'-')#
                                AND SHIP.LOCATION = #listlast(kk,'-')#
                            </cfif> 
                            )
                            <cfif listlen(arguments.department_out) neq sayac_>
                                OR
                            </cfif>
                        </cfloop>
                            )
                    </cfif>	
                    <cfif len(arguments.belge_no)>
                        AND
                        (
                            <cfset count_ = 0>
                            <cfloop list="#arguments.belge_no#" index="kk">
                                    <cfset count_ = count_+1>
                                   (
                                   (SHIP.SHIP_NUMBER LIKE '<cfif len(kk) gt 3>%</cfif>#kk#%')
                                   OR
                                   (SHIP.REF_NO LIKE '<cfif len(kk) gt 3>%</cfif>#kk#%')
                                   )
                            <cfif count_ neq listlen(arguments.belge_no)>OR</cfif>           
                            </cfloop>
                            )
                    </cfif>
                    <cfif len(arguments.project_id)>
                        AND SHIP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
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
                    <cfelseif len(arguments.company_id) and arguments.company_id gt 0>
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
                    <cfif len(arguments.product_cat_code)>
                        <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                            AND SHIP_ROW.PRODUCT_ID IN (
                            							SELECT PRODUCT_ID FROM #this.dsn1_alias#.PRODUCT P 
                                                        WHERE 
                                                        	<cfset sayac_ = 0>
                                                        	<cfloop list="#arguments.product_cat_code#" index="cc">
                                                            	<cfset sayac_ = sayac_ + 1>
                                                        		P.PRODUCT_CODE LIKE '#cc#.%'
                                                                <cfif sayac_ neq listlen(arguments.product_cat_code)> OR</cfif>
                                                            </cfloop>
                                                        )
                        <cfelse>
                            AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM SHIP_ROW SR, #this.dsn1_alias#.PRODUCT P WHERE P.PRODUCT_ID = SR.PRODUCT_ID AND 
                                (
                                	<cfset sayac_ = 0>
                                    <cfloop list="#arguments.product_cat_code#" index="cc">
                                        P.PRODUCT_CODE LIKE '#cc#.%'
                                      	<cfif sayac_ neq listlen(arguments.product_cat_code)> OR</cfif>
                                    </cfloop>
                                )
                            )
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
                    <cfif len(arguments.employee_id_2) and len(arguments.member_name)>
                       AND SHIP.DELIVER_EMP_ID = #arguments.employee_id_2#
                    <cfelseif len(arguments.consumer_id_2) and len(arguments.member_name)>
                        AND SHIP.DELIVER_CONS_ID = #arguments.consumer_id_2#
                    <cfelseif len(arguments.company_id_2) and len(arguments.member_name)>
                        AND SHIP.DELIVER_COMP_ID = #arguments.company_id_2#
                    </cfif>
                    <cfif len(arguments.work_id)>
                    	AND SHIP.WORK_ID = #arguments.work_id#
                    </cfif>
                <cfelse>
                    SELECT
                        1 TABLE_TYPE,
                        SHIP.PROCESS_CAT PROCESS_CAT,
                        SHIP.PROJECT_ID PROJECT_ID,
                        (SELECT PROJECT_HEAD FROM #this.dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = SHIP.PROJECT_ID) PROJECT_HEAD,
						SHIP.PROJECT_ID_IN,
                        (SELECT PROJECT_HEAD FROM #this.dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = SHIP.PROJECT_ID_IN) PROJECT_HEAD_IN,
                    <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                        SHIP_ROW.NAME_PRODUCT,
                        STOCKS.STOCK_CODE,
                        SHIP_ROW.PRODUCT_ID,
                        SHIP_ROW.AMOUNT,
                        SHIP_ROW.PRICE,
                        NULL LOT_NO,
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
                        PRO_WORKS.WORK_HEAD
                    FROM 	
                        SHIP WITH (NOLOCK)
                            LEFT JOIN #this.dsn_alias#.PRO_WORKS ON SHIP.WORK_ID = PRO_WORKS.WORK_ID
                    <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                        ,SHIP_ROW WITH (NOLOCK)
                        ,#this.dsn3_alias#.STOCKS STOCKS WITH (NOLOCK)
                    </cfif>
                    WHERE 
                    1= 1
                    <cfif len(cat_list1)>
                    	AND SHIP.SHIP_TYPE IN (#cat_list1#)
                    </cfif>
                    <cfif len(cat_list2)>
                        AND SHIP.PROCESS_CAT IN (#cat_list2#)
                    </cfif>
                    <cfif not len(arguments.cat)>
                        AND SHIP.SHIP_ID IS NOT NULL
                    </cfif>
					<cfif isdefined('arguments.lot_no') and len(arguments.lot_no)>
						<cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme --->
                                AND 
                                (
                                    <cfset count_ = 0>
                                    <cfloop list="#arguments.lot_no#" index="kk">
                                        (
                                            <cfset count_ = count_+1>
                                           SHIP_ROW.LOT_NO LIKE '<cfif len(arguments.lot_no) gt 3>%</cfif>#kk#%'
                                        )
                                    <cfif count_ neq listlen(arguments.lot_no)>OR</cfif>           
                                    </cfloop>
                                )
                            <cfelse>
                                AND 
                                    SHIP.SHIP_ID 
                                        IN (
                                                SELECT SHIP_ID FROM SHIP_ROW SFR WHERE SFR.SHIP_ID = SHIP.SHIP_ID 
                                                AND 
                                                    (
                                                        <cfset count_ = 0>
                                                        <cfloop list="#arguments.lot_no#" index="kk">
                                                            (
                                                                <cfset count_ = count_+1>
                                                               SFR.LOT_NO LIKE '<cfif len(arguments.lot_no) gt 3>%</cfif>#kk#%'
                                                            )
                                                        <cfif count_ neq listlen(arguments.lot_no)>OR</cfif>           
                                                        </cfloop>
                                                    )
                                            )
                            </cfif>
					</cfif>
                    <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                        AND SHIP.SHIP_ID = SHIP_ROW.SHIP_ID
                        AND SHIP_ROW.STOCK_ID = STOCKS.STOCK_ID
                        AND SHIP_ROW.PRODUCT_ID = STOCKS.PRODUCT_ID
                        <cfif len(arguments.row_department_id)>
                        	AND (
                            <cfset sayac_ = 0>
                        	<cfloop list="#arguments.row_department_id#" index="kk">
                            	<cfset sayac_ = sayac_ + 1>
                            	(<cfif listlen(kk,'-') eq 1>
                                	SHIP_ROW.DELIVER_DEPT = #kk#
                                <cfelse>
                                	SHIP_ROW.DELIVER_DEPT = #listfirst(kk,'-')#
                                    AND SHIP_ROW.DELIVER_LOC = #listlast(kk,'-')#
                                </cfif> 
                               	)
                                <cfif listlen(arguments.row_department_id) neq sayac_>
                                	OR
                                </cfif>
                            </cfloop>
                            	)
                        </cfif>	
                    </cfif>
                    <cfif isdate(arguments.record_date)>
                        AND SHIP.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.record_date#">
                        AND SHIP.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,arguments.record_date)#">
                    </cfif>
					<cfif isdefined('arguments.record_emp_id') and len(arguments.record_emp_id) and len(arguments.record_name)>
						AND SHIP.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_emp_id#">
					</cfif>
                    <cfif len(arguments.date1) and  len(arguments.date2)>
                        AND SHIP.SHIP_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date2#">
                    </cfif>
                    <cfif len(arguments.department_id)>
                        AND (
                        <cfset sayac_ = 0>
                        <cfloop list="#arguments.department_id#" index="kk">
                            <cfset sayac_ = sayac_ + 1>
                            (<cfif listlen(kk,'-') eq 1>
                                DEPARTMENT_IN = #kk#
                            <cfelse>
                                DEPARTMENT_IN = #listfirst(kk,'-')#
                                AND LOCATION_IN = #listlast(kk,'-')#
                            </cfif> 
                            )
                            <cfif listlen(arguments.department_id) neq sayac_>
                                OR
                            </cfif>
                        </cfloop>
                            )
                    </cfif>	
                    <cfif len(arguments.department_out)>
                        AND (
                        <cfset sayac_ = 0>
                        <cfloop list="#arguments.department_out#" index="kk">
                            <cfset sayac_ = sayac_ + 1>
                            (<cfif listlen(kk,'-') eq 1>
                                DELIVER_STORE_ID = #kk#
                            <cfelse>
                                DELIVER_STORE_ID = #listfirst(kk,'-')#
                                AND LOCATION = #listlast(kk,'-')#
                            </cfif> 
                            )
                            <cfif listlen(arguments.department_out) neq sayac_>
                                OR
                            </cfif>
                        </cfloop>
                            )
                    </cfif>	
                    <cfif len(arguments.belge_no)>
                        AND
                        (
                            <cfset count_ = 0>
                            <cfloop list="#arguments.belge_no#" index="kk">
                                    <cfset count_ = count_+1>
                                   (
                                   (SHIP.SHIP_NUMBER LIKE '<cfif len(kk) gt 3>%</cfif>#kk#%')
                                   OR
                                   (SHIP.REF_NO LIKE '<cfif len(kk) gt 3>%</cfif>#kk#%')
                                   )
                            <cfif count_ neq listlen(arguments.belge_no)>OR</cfif>           
                            </cfloop>
                            )
                    </cfif>
                    <cfif len(arguments.project_id)>
                        AND SHIP.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
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
                    <cfelseif len(arguments.company_id) and arguments.company_id gt 0>
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
                    <cfif len(arguments.product_cat_code)>
                        <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme --->
                            AND SHIP_ROW.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #this.dsn1_alias#.PRODUCT P WHERE 
								<cfset sayac_ = 0>
                                <cfloop list="#arguments.product_cat_code#" index="cc">
                                    <cfset sayac_ = sayac_ + 1>
                                    P.PRODUCT_CODE LIKE '#cc#.%'
                                    <cfif sayac_ neq listlen(arguments.product_cat_code)> OR</cfif>
                                </cfloop>
                            )
                        <cfelse>
                            AND SHIP.SHIP_ID IN (SELECT SHIP_ID FROM SHIP_ROW SR, #this.dsn1_alias#.PRODUCT P WHERE P.PRODUCT_ID = SR.PRODUCT_ID AND 
                                (
									<cfset sayac_ = 0>
                                    <cfloop list="#arguments.product_cat_code#" index="cc">
                                        <cfset sayac_ = sayac_ + 1>
                                        P.PRODUCT_CODE LIKE '#cc#.%'
                                        <cfif sayac_ neq listlen(arguments.product_cat_code)> OR</cfif>
                                    </cfloop>
                                )
                            )
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
                    <cfif len(arguments.employee_id_2) and len(arguments.member_name)>
                       AND SHIP.DELIVER_EMP_ID = #arguments.employee_id_2#
                    <cfelseif len(arguments.consumer_id_2) and len(arguments.member_name)>
                        AND SHIP.DELIVER_CONS_ID = #arguments.consumer_id_2#
                    <cfelseif len(arguments.company_id_2) and len(arguments.member_name)>
                        AND SHIP.DELIVER_COMP_ID = #arguments.company_id_2#
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
            <cfif not (len(arguments.consumer_id) or len(arguments.company_id) or len(arguments.invoice_action)) or arguments.iptal_stocks eq 1>
                <cfif not len(arguments.cat) or (len(arguments.cat) and isdefined("is_fis"))>
                UNION ALL
                </cfif>
               <cfif (len(arguments.cat) and isdefined("is_fis")) or not len(arguments.cat)>
                    SELECT
                        2 TABLE_TYPE,
                        STOCK_FIS.PROCESS_CAT PROCESS_CAT,
                        STOCK_FIS.PROJECT_ID PROJECT_ID,
                        (SELECT PROJECT_HEAD FROM #this.dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = STOCK_FIS.PROJECT_ID) PROJECT_HEAD,
						STOCK_FIS.PROJECT_ID_IN,
                        (SELECT PROJECT_HEAD FROM #this.dsn_alias#.PRO_PROJECTS WHERE PROJECT_ID = STOCK_FIS.PROJECT_ID_IN) PROJECT_HEAD_IN,
                    <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                        STOCKS.PRODUCT_NAME NAME_PRODUCT,
                        STOCKS.STOCK_CODE,
                        STOCKS.PRODUCT_ID,
                        STOCK_FIS_ROW.AMOUNT,
                        STOCK_FIS_ROW.PRICE,
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
                        PRO_WORKS.WORK_HEAD
                    FROM
                        STOCK_FIS WITH (NOLOCK)
                            LEFT JOIN #this.dsn_alias#.PRO_WORKS ON STOCK_FIS.WORK_ID = PRO_WORKS.WORK_ID
                    <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                        ,STOCK_FIS_ROW WITH (NOLOCK)
                        ,#this.dsn3_alias#.STOCKS STOCKS WITH (NOLOCK)
                    </cfif>
                    WHERE 
                    	1= 1
                    	<cfif len(cat_list1)>
                            AND STOCK_FIS.FIS_TYPE IN (#cat_list1#)
                        </cfif>
                        <cfif len(cat_list2)>
                            AND STOCK_FIS.PROCESS_CAT IN (#cat_list2#)
                        </cfif>
                        <cfif not len(arguments.cat)>
                            AND STOCK_FIS.FIS_ID IS NOT NULL
                        </cfif>
                        AND STOCK_FIS.FIS_ID IN(SELECT SRR.UPD_ID FROM STOCKS_ROW SRR WHERE SRR.PROCESS_TYPE = STOCK_FIS.FIS_TYPE)
                        <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme yapiliyorsa --->
                            AND STOCK_FIS.FIS_ID = STOCK_FIS_ROW.FIS_ID
                            AND STOCK_FIS_ROW.STOCK_ID = STOCKS.STOCK_ID
							<cfif len(arguments.row_department_id)>
								AND 1 = 0
							</cfif>	
                        </cfif>
                        <cfif isdefined('arguments.lot_no') and len(arguments.lot_no)>
                            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme --->
                                AND STOCK_FIS_ROW.LOT_NO LIKE '<cfif len(arguments.lot_no) gt 3>%</cfif>#arguments.lot_no#%'
                            <cfelse>
                                AND STOCK_FIS.FIS_ID IN (SELECT FIS_ID FROM STOCK_FIS_ROW SFR WHERE SFR.FIS_ID = STOCK_FIS.FIS_ID AND SFR.LOT_NO LIKE '<cfif len(arguments.lot_no) gt 3>%</cfif>#arguments.lot_no#%')
                            </cfif>
                        </cfif>
                        <cfif len(arguments.product_cat_code)>
                            <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Satir bazinda listeleme --->
                                AND STOCKS.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #this.dsn1_alias#.PRODUCT P WHERE 
									<cfset sayac_ = 0>
                                    <cfloop list="#arguments.product_cat_code#" index="cc">
                                        <cfset sayac_ = sayac_ + 1>
                                        P.PRODUCT_CODE LIKE '#cc#.%'
                                        <cfif sayac_ neq listlen(arguments.product_cat_code)> OR</cfif>
                                    </cfloop>
                                )
                            <cfelse>
                                AND STOCK_FIS.FIS_ID IN (SELECT FIS_ID FROM STOCK_FIS_ROW SFR, #this.dsn1_alias#.PRODUCT P, #this.dsn1_alias#.STOCKS S WHERE S.STOCK_ID = SFR.STOCK_ID AND P.PRODUCT_ID = S.PRODUCT_ID AND 
                                    (
										<cfset sayac_ = 0>
                                        <cfloop list="#arguments.product_cat_code#" index="cc">
                                            <cfset sayac_ = sayac_ + 1>
                                            P.PRODUCT_CODE LIKE '#cc#.%'
                                            <cfif sayac_ neq listlen(arguments.product_cat_code)> OR</cfif>
                                        </cfloop>
                                    )
                                )
                            </cfif>
                        </cfif>
                        <cfif len(arguments.record_date)>
                            AND STOCK_FIS.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.record_date#">
                            AND STOCK_FIS.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD('d',1,arguments.record_date)#">
                        </cfif>
						<cfif isdefined('arguments.record_emp_id') and len(arguments.record_emp_id) and len(arguments.record_name)>
							AND STOCK_FIS.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_emp_id#">
						</cfif>
                        <cfif len(arguments.date1) and len(arguments.date2)>
                            AND STOCK_FIS.FIS_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date2#">
                        </cfif>
                        <cfif len(arguments.department_id)>
                        	AND (
                            <cfset sayac_ = 0>
                        	<cfloop list="#arguments.department_id#" index="kk">
                            	<cfset sayac_ = sayac_ + 1>
                            	(<cfif listlen(kk,'-') eq 1>
                                	DEPARTMENT_IN = #kk#
                                <cfelse>
                                	DEPARTMENT_IN = #listfirst(kk,'-')#
                                    AND LOCATION_IN = #listlast(kk,'-')#
                                </cfif> 
                               	)
                                <cfif listlen(arguments.department_id) neq sayac_>
                                	OR
                                </cfif>
                            </cfloop>
                            	)
                        </cfif>	
                        <cfif len(arguments.department_out)>
                        	AND (
                            <cfset sayac_ = 0>
                        	<cfloop list="#arguments.department_out#" index="kk">
                            	<cfset sayac_ = sayac_ + 1>
                            	(<cfif listlen(kk,'-') eq 1>
                                	DEPARTMENT_OUT = #kk#
                                <cfelse>
                                	DEPARTMENT_OUT = #listfirst(kk,'-')#
                                    AND LOCATION_OUT = #listlast(kk,'-')#
                                </cfif> 
                               	)
                                <cfif listlen(arguments.department_out) neq sayac_>
                                	OR
                                </cfif>
                            </cfloop>
                            	)
                        </cfif>	
                        <cfif len(arguments.belge_no)>
                            AND
                            (
                                <cfset count_ = 0>
                                <cfloop list="#arguments.belge_no#" index="kk">
                                        <cfset count_ = count_+1>
                                       (
                                       (STOCK_FIS.FIS_NUMBER LIKE '<cfif len(kk) gt 3>%</cfif>#kk#%')
                                       OR
                                       (STOCK_FIS.REF_NO LIKE '<cfif len(kk) gt 3>%</cfif>#kk#%')
                                       )
                                <cfif count_ neq listlen(arguments.belge_no)>OR</cfif>           
                                </cfloop>
                                )
                        </cfif>		  
                        <cfif len(arguments.project_id)>
                            AND STOCK_FIS.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.project_id#">
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
                <cfif not len(arguments.cat) and not len(arguments.project_id) and not len(arguments.project_id_in) and not len(arguments.member_name) or (len(arguments.cat) and isdefined("is_stock_virman"))><!--- and kaldirdim_hata_veriyornot len(arguments.work_id)---><!--- FBS 20080407 proje,teslim alan STOCK_EXCHANGE de olmadigindan bu kosula girmemeli --->
                    UNION ALL
                </cfif>
                <cfif (len(arguments.cat) and isdefined("is_stock_virman"))  or not len(arguments.cat) and not len(arguments.project_id) and not len(arguments.project_id_in) and not len(arguments.member_name)><!--- FBS 20080407 proje,teslim alan STOCK_EXCHANGE de olmadigindan bu kosula girmemeli --->
                    SELECT
                        3 TABLE_TYPE,
                        STOCK_EXCHANGE.PROCESS_CAT PROCESS_CAT,
                        '' PROJECT_ID,
                        '' PROJECT_HEAD,
						'' PROJECT_ID_IN,
                        '' PROJECT_HEAD_IN,
                    <cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2><!--- Eger satir bazinda listeleme yapiliyorsa --->
                        '' NAME_PRODUCT,
                        '' STOCK_CODE,
                        0 PRODUCT_ID,
                        0 AMOUNT,
                        0 PRICE,
                        NULL LOT_NO,
                    </cfif>
                        -1 PURCHASE_SALES,
						'' DELIVER_EMP_ID,
                        STOCK_EXCHANGE_ID ISLEM_ID,
                        EXCHANGE_NUMBER BELGE_NO,
                        '' REFERANS,
                        PROCESS_TYPE ISLEM_TIPI,
                        PROCESS_DATE ISLEM_TARIHI,
                        PROCESS_DATE SEVK_TARIHI,
						0 COMPANY_ID,
                        0 CONSUMER_ID,
                        0 PARTNER_ID,
                        0 EMPLOYEE_ID,
                        DEPARTMENT_ID DEPARTMENT_ID,
                        LOCATION_ID LOCATION,
                        EXIT_DEPARTMENT_ID DEPARTMENT_ID_2,
                        EXIT_LOCATION_ID LOCATION_2,
                        '' INVOICE_NUMBER,
                        '' DELIVER_EMP,
                        RECORD_DATE,
						RECORD_EMP,
                        '' WORK_ID,
                        0 IS_STOCK_TRANSFER,
                        STOCK_EXCHANGE_TYPE,
    	                '' WORK_HEAD
                    FROM
                        STOCK_EXCHANGE WITH (NOLOCK)
                    WHERE 
                    1= 1 
                    <cfif len(cat_list1)>
                    	AND STOCK_EXCHANGE.PROCESS_TYPE IN (#cat_list1#)
                    </cfif>
                    <cfif len(cat_list2)>
                        AND STOCK_EXCHANGE.PROCESS_CAT IN (#cat_list2#)
                    </cfif>
                    <cfif not len(arguments.cat)>
                        AND STOCK_EXCHANGE.STOCK_EXCHANGE_ID IS NOT NULL
                    </cfif>
					<cfif isdefined('arguments.lot_no') and Len(arguments.lot_no)>
						AND 1 = 0
					</cfif>
					<cfif isdefined('arguments.listing_type') and arguments.listing_type eq 2 and len(arguments.row_department_id)>
						AND 1 = 0
					</cfif>
                    <cfif len(arguments.product_cat_code)>
                        AND STOCK_EXCHANGE.PRODUCT_ID IN (SELECT PRODUCT_ID FROM #this.dsn1_alias#.PRODUCT P WHERE 
								<cfset sayac_ = 0>
                                <cfloop list="#arguments.product_cat_code#" index="cc">
                                    <cfset sayac_ = sayac_ + 1>
                                    P.PRODUCT_CODE LIKE '#cc#.%'
                                    <cfif sayac_ neq listlen(arguments.product_cat_code)> OR</cfif>
                                </cfloop>
                            )
                    </cfif>
                    <cfif len(arguments.record_date)>
                        AND STOCK_EXCHANGE.RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.record_date#">
                        AND STOCK_EXCHANGE.RECORD_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DATEADD("d",1,arguments.record_date)#">
                    </cfif>
					<cfif isdefined('arguments.record_emp_id') and len(arguments.record_emp_id) and len(arguments.record_name)>
						AND STOCK_EXCHANGE.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.record_emp_id#">
					</cfif>
                    <cfif len(arguments.date1) and  len(arguments.date2)>
                        AND STOCK_EXCHANGE.PROCESS_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date1#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.date2#">
                    </cfif>
                    <cfif isdefined('arguments.subscription_id') and len(arguments.subscription_id) and isdefined('arguments.subscription_no') and len(arguments.subscription_no)>
                        AND STOCK_EXCHANGE.STOCK_EXCHANGE_ID = -1<!--- B�yle bir kayit olamaz, sisteme g�re filtrelediginde bu kayitlari getirmesn diye eklendi --->
                    </cfif>
                    <cfif len(arguments.department_id)>
                        AND (
                        <cfset sayac_ = 0>
                        <cfloop list="#arguments.department_id#" index="kk">
                            <cfset sayac_ = sayac_ + 1>
                            (<cfif listlen(kk,'-') eq 1>
                                DEPARTMENT_ID = #kk#
                            <cfelse>
                                DEPARTMENT_ID = #listfirst(kk,'-')#
                                AND LOCATION_ID = #listlast(kk,'-')#
                            </cfif> 
                            )
                            <cfif listlen(arguments.department_id) neq sayac_>
                                OR
                            </cfif>
                        </cfloop>
                            )
                    </cfif>	
                    <cfif len(arguments.department_out)>
                        AND (
                        <cfset sayac_ = 0>
                        <cfloop list="#arguments.department_out#" index="kk">
                            <cfset sayac_ = sayac_ + 1>
                            (<cfif listlen(kk,'-') eq 1>
                                EXIT_DEPARTMENT_ID = #kk#
                            <cfelse>
                                EXIT_DEPARTMENT_ID = #listfirst(kk,'-')#
                                AND EXIT_LOCATION_ID = #listlast(kk,'-')#
                            </cfif> 
                            )
                            <cfif listlen(arguments.department_out) neq sayac_>
                                OR
                            </cfif>
                        </cfloop>
                            )
                    </cfif>	
                    <cfif isDefined("arguments.belge_no") and len(arguments.belge_no)>
                        	AND
                            (
                            <cfset count_ = 0>
                            <cfloop list="#arguments.belge_no#" index="kk">
                                (
                                    <cfset count_ = count_+1>
                                   EXCHANGE_NUMBER LIKE '<cfif len(kk) gt 3>%</cfif>#kk#%'
                                )
                            <cfif count_ neq listlen(arguments.belge_no)>OR</cfif>           
                            </cfloop>
                            )
                    </cfif>  
                    <cfif len(arguments.stock_id) and len(arguments.product_name)>
                        AND STOCK_EXCHANGE.STOCK_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stock_id#">
                    </cfif>
                    <cfif len(arguments.delivered)>
                        AND 1 = 2
                    </cfif>	
                    <cfif (isdefined("arguments.deliver_emp_id") and len(arguments.deliver_emp_id)) and (isdefined("arguments.deliver_emp") and len(arguments.deliver_emp))>AND 1 = 0</cfif>
                </cfif>
            </cfif>
            )
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
                                                </cfif>	) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
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
