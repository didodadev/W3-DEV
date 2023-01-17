<cfif (isdefined("attributes.event") and listFindNoCase('list,excel',attributes.event)) or not isdefined("attributes.event")>    
    <cfsetting showdebugoutput="yes">
    <cfparam name="deep_level_max" default="1">
    <cf_xml_page_edit default_value="1" fuseact='prod.list_materials_total'>
    <cfset stock_id_list_info1 = ''>
    <cfset stock_id_list_info2 = ''>
    <cfset department_id_list = ''>
    <cfset location_id_list = ''>
    <cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
        <cfif attributes.row_demand_all neq 0>
            <cfset gun_ = now()>
            <cfset wrk_id = 'WRK' & dateformat(now(),'YYYYMMDD')& timeformat(now(),'HHmmssL') & '_#session.ep.userid#_' &round(rand()*100)>
            <cfset row_demand_array = listtoarray(attributes.row_demand_all)>
            <cfquery name="del_olds" datasource="#dsn#">
                DELETE FROM TEMP_BLOCK_VALUES WHERE RECORD_DATE < #createodbcdatetime(createdate(year(gun_),month(gun_),day(gun_)))# OR RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
            </cfquery>
            <cfloop from="1" to="#arraylen(row_demand_array)#" index="ccc">
                <cfquery name="add_" datasource="#dsn#">
                    INSERT INTO 
                        TEMP_BLOCK_VALUES
                    (
                        WRK_ROW_ID,
                        TEMP_COLUMN,
                        TEMP_VALUE,
                        RECORD_DATE,
                        RECORD_EMP
                    )
                    VALUES
                    (
                        '#wrk_id#',
                        'P_ORDER_ID_FROM_ROW_DEMAND',
                        '#row_demand_array[ccc]#',
                        #now()#,
                        #session.ep.userid#
                    )
                </cfquery>
            </cfloop>
        </cfif>
        <cfquery name="get_demand_min_max_date" datasource="#dsn3#">
            SELECT 
                MIN(START_DATE) AS START_DATE,
                MAX(FINISH_DATE) AS FINISH_DATE 
            FROM 
                PRODUCTION_ORDERS
            WHERE 
                P_ORDER_ID IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
        </cfquery>
        <cfquery name="get_demand_no" datasource="#dsn3#">
            SELECT 
                P_ORDER_NO
            FROM 
                PRODUCTION_ORDERS
            WHERE 
                P_ORDER_ID IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
        </cfquery>
        <cfset attributes.production_order_no = valuelist(get_demand_no.p_order_no)>
        <cfset attributes.start_date = DateFormat(date_add("d",-1,get_demand_min_max_date.START_DATE),"DD/MM/YYYY")>
        <cfset attributes.finish_date = DateFormat(date_add("d",1,get_demand_min_max_date.FINISH_DATE),"DD/MM/YYYY")>
    <cfelseif isdefined("attributes.production_order_no") and len(attributes.production_order_no)>
         <cfset production_order_no_list=''>
         <cfloop list="#attributes.production_order_no#" index="kk">
             <cfif len(kk) and not listfind(production_order_no_list,kk)>
                 <cfset production_order_no_list=listappend(production_order_no_list,"'#kk#'")>
             </cfif>
         </cfloop>
        <cfquery name="get_demand_min_max_date" datasource="#dsn3#">
            SELECT 
                MIN(START_DATE) AS START_DATE,
                MAX(FINISH_DATE) AS FINISH_DATE 
            FROM 
                PRODUCTION_ORDERS
            WHERE 
                P_ORDER_NO IN (#PreserveSingleQuotes(production_order_no_list)#)
        </cfquery>
        <cfif len(get_demand_min_max_date.START_DATE)>
            <cfset attributes.start_date = DateFormat(date_add("d",-1,get_demand_min_max_date.START_DATE),"DD/MM/YYYY")>
        </cfif>
        <cfif len(get_demand_min_max_date.FINISH_DATE)>
            <cfset attributes.finish_date = DateFormat(date_add("d",1,get_demand_min_max_date.FINISH_DATE),"DD/MM/YYYY")>
        </cfif>
    </cfif>
    <cfparam name="attributes.production_order_no" default="">
    <cfparam name="attributes.station_id" default="">
    <cfparam name="attributes.demand_no" default="">
    <cfparam name="attributes.department_id" default="">
    <cfparam name="attributes.product_code" default="">
    <cfparam name="attributes.COMPANY" default="">
    <cfparam name="attributes.company_id" default="">
    <cfparam name="attributes.PRODUCT_NAME" default="">
    <cfparam name="attributes.PRODUCT_ID" default="">
    <cfparam name="attributes.price_cat" default="">
    <cfparam name="attributes.product_code" default="">
    <cfparam name="attributes.sort_type" default="">
    <cfparam name="attributes.list_type" default="">
    <cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
        <cf_date tarih = "attributes.start_date">
    <cfelse>
        <cfset attributes.start_date = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
    </cfif>
    <cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
      <cf_date tarih = "attributes.finish_date">
    <cfelse>
      <cfset attributes.finish_date = date_add('d',1,attributes.start_date)>
    </cfif>
    <cfquery name="GET_DEPARTMENT" datasource="#DSN#">
        SELECT
            DEPARTMENT_ID,
            DEPARTMENT_HEAD
        FROM
            BRANCH B,
            DEPARTMENT D 
        WHERE
            B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
            B.BRANCH_ID = D.BRANCH_ID AND
            D.IS_STORE <> 2 AND
            D.DEPARTMENT_STATUS = 1 AND
            B.BRANCH_ID IN(SELECT BRANCH_ID FROM  EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
    </cfquery>
    <cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
        SELECT DEPARTMENT_ID,LOCATION_ID,COMMENT FROM STOCKS_LOCATION <cfif x_is_dept_location eq 0>WHERE STATUS = 1</cfif>
    </cfquery>						
    <cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
        SELECT 
            PRODUCT_CAT.PRODUCT_CATID, 
            PRODUCT_CAT.HIERARCHY,
            PRODUCT_CAT.PRODUCT_CAT
        FROM 
            PRODUCT_CAT,
            PRODUCT_CAT_OUR_COMPANY PCO
        WHERE 
            PRODUCT_CAT.PRODUCT_CATID = PCO.PRODUCT_CATID AND
            PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
        ORDER BY 
            HIERARCHY
    </cfquery>
    <cfquery name="GET_W" datasource="#dsn#">
        SELECT 
            STATION_ID,
            STATION_NAME,
            '' UP_STATION
        FROM 
            #dsn3_alias#.WORKSTATIONS 
        WHERE 
            ACTIVE = <cfqueryparam cfsqltype="cf_sql_smallint" value="1"> AND
            DEPARTMENT IN (SELECT DEPARTMENT.DEPARTMENT_ID FROM DEPARTMENT,EMPLOYEE_POSITION_BRANCHES WHERE DEPARTMENT.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) 
        ORDER BY STATION_NAME ASC
    </cfquery>
    <cfif not len(attributes.price_cat)><cfset attributes.price_cat = -1></cfif>
    <cfif isdefined("attributes.is_submitted")>
        <cfif isdefined("attributes.list_type") and len(attributes.list_type) and attributes.list_type eq 2>
            <cfinclude template="../production_plan/query/get_order_detail_for_material_from_file.cfm">
        <cfelse>
            <cfinclude template="../production_plan/query/get_order_detail_for_material.cfm">
        </cfif>
        <cfparam name="attributes.totalrecords" default="#get_metarials.recordcount#">
    <cfelse>
        <cfset get_metarials.recordcount = 0>
        <cfparam name="attributes.totalrecords" default="0">	
    </cfif>
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1>
    <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
        <cfset filename = "#createuuid()#">
        <cfheader name="Expires" value="#Now()#">
        <cfcontent type="application/vnd.msexcel;charset=utf-8">
        <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    </cfif>
    <cfoutput query="get_department">
        <cfset 'department_name_#DEPARTMENT_ID#'='#DEPARTMENT_HEAD#'>
    </cfoutput>
    <cfoutput query="GET_ALL_LOCATION">
        <cfset 'location_name_#DEPARTMENT_ID#_#LOCATION_ID#' = COMMENT>
    </cfoutput>
    <cfif x_is_alternative_stock eq 1>
        <cfset colspan_ =ListLen(attributes.department_id,',')*4+19>
    <cfelse>
        <cfset colspan_ =ListLen(attributes.department_id,',')*3+19>
    </cfif>
    <cfif get_metarials.recordcount>
        	<cfif ListLen(attributes.DEPARTMENT_ID,',')>
                <cfloop list="#attributes.DEPARTMENT_ID#" index="_depID_" delimiters=",">
                	<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1 and _depID_ contains '-'>
                    	<cfset department_id_list = listappend(department_id_list,listfirst(_depID_,'-'),',')>
						<cfset department_id_list_ = listdeleteduplicates(department_id_list)>
						<cfset location_id_list = listdeleteduplicates(listappend(location_id_list,_depID_,','))>
                    <cfelse>
                    	<cfset department_id_list = listappend(department_id_list,_depID_,',')>
                    	<cfset department_id_list_ = listdeleteduplicates(department_id_list)>
                    </cfif>
                </cfloop>
            </cfif>
    </cfif>
    <cfif isdefined("attributes.is_submitted")>
    <cfquery name="GET_MONEY" datasource="#DSN2#">
        SELECT * FROM SETUP_MONEY
    </cfquery>
    <cfif get_metarials.recordcount>
			<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
                <cfset attributes.startrow=1>
                <cfset attributes.maxrows=get_metarials.recordcount>
            </cfif>
	        <cfset stock_id_list = ''>
			<cfset spec_main_id_list = ''>
            <cfoutput query="get_metarials" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfset stock_id_list = ListAppend(stock_id_list,STOCK_ID,',')>
				<cfset spec_main_id_list = ListAppend(spec_main_id_list,SPECT_MAIN_ID,',')>
			</cfoutput>
        	<cfif ListLen(attributes.DEPARTMENT_ID,',')><!--- DEPO SEÇİLİ İSE --->
                <cfset stock_id_list = listdeleteduplicates(stock_id_list)>
				<cfset spec_main_id_list = listdeleteduplicates(spec_main_id_list)>
                <cfquery name="GET_STOCKS_ALL" datasource="#DSN2#">
					SELECT 
						SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_STOCK,
						SR.STOCK_ID,
						SR.STORE AS DEPARTMENT_ID
                        <cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,SR.STORE_LOCATION AS LOCATION_ID</cfif>
					FROM 
						STOCKS_ROW SR
					WHERE
						<cfif not((isdefined('attributes.is_excel') and attributes.is_excel eq 1) and get_metarials.recordcount gt 5000)>
							SR.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND 
						</cfif>
                        SR.STORE_LOCATION NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID =SR.STORE) AND
						<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
                           ( <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                (SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
                                <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                            </cfloop>  )
                        <cfelse>
                            SR.STORE IN (#attributes.DEPARTMENT_ID#)
                        </cfif>
					GROUP BY
						SR.STOCK_ID,
						SR.STORE
                        <cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,SR.STORE_LOCATION</cfif>
					<cfif len(spec_main_id_list)>
						UNION ALL
						SELECT 
							SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_STOCK,
							SR.STOCK_ID,
							SR.STORE AS DEPARTMENT_ID
                            <cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,SR.STORE_LOCATION AS LOCATION_ID</cfif>
						FROM 
							STOCKS_ROW SR
						WHERE
							<cfif not((isdefined('attributes.is_excel') and attributes.is_excel eq 1) and get_metarials.recordcount gt 5000)>
                            	SR.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND 
                            </cfif>
                            SR.STORE_LOCATION NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID =SR.STORE) AND
							SR.SPECT_VAR_ID IN (#spec_main_id_list#) AND
                            <cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
                               ( <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                    (SR.STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND SR.STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
                                    <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                </cfloop>  )
                            <cfelse>
                                SR.STORE IN (#attributes.DEPARTMENT_ID#)
                            </cfif>
						GROUP BY
							SR.STOCK_ID,
							SR.STORE
                        	<cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,SR.STORE_LOCATION</cfif>
					</cfif>
                </cfquery>
                <cfif GET_STOCKS_ALL.recordcount>
                    <cfscript>
                        for(s_ind=1;s_ind lte GET_STOCKS_ALL.recordcount;s_ind=s_ind+1)
						{
							if(isdefined("x_is_dept_location") and x_is_dept_location eq 1)
                            	'dep_stock_status_#GET_STOCKS_ALL.DEPARTMENT_ID[s_ind]#_#GET_STOCKS_ALL.LOCATION_ID[s_ind]#_#GET_STOCKS_ALL.STOCK_ID[s_ind]#' = GET_STOCKS_ALL.PRODUCT_STOCK[s_ind];
							else
                            	'dep_stock_status_#GET_STOCKS_ALL.DEPARTMENT_ID[s_ind]#_#GET_STOCKS_ALL.STOCK_ID[s_ind]#' = GET_STOCKS_ALL.PRODUCT_STOCK[s_ind];
						}
                    </cfscript>
                </cfif>
				<!--- DEPOLAR BAZINDA GERÇEK STOKLAR BİTTİ--->
                
                <!--- DEPOLARA GÖRE ÜRETİM EMİRLERİ REZERVELER --->
                <cfquery name="get_product_rezerv_dep" datasource="#dsn3#">
                    SELECT
                        SUM(STOCK_ARTIR) STOCK_ARTIR,
                        SUM(STOCK_AZALT) STOCK_AZALT,
                        S.STOCK_ID,
                         ISNULL((SELECT TOP 1 SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID),''),
                        S.PRODUCT_ID,
                        T1.SPECT_MAIN_ID,
                        EXIT_DEP_ID AS DEPARTMENT_ID
                        <cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,EXIT_LOC_ID AS LOCATION_ID</cfif>
                    FROM
                        (
                       SELECT
							(QUANTITY) AS STOCK_ARTIR,
							0 AS STOCK_AZALT,
							PRODUCTION_ORDERS.STOCK_ID,
                            ISNULL(PRODUCTION_ORDERS.SPEC_MAIN_ID,0) SPECT_MAIN_ID,
							PRODUCTION_ORDERS.EXIT_DEP_ID
                            <cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,PRODUCTION_ORDERS.EXIT_LOC_ID</cfif>
						FROM
							PRODUCTION_ORDERS
						WHERE
                        	PRODUCTION_ORDERS.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND 
							IS_STOCK_RESERVED = 1 AND
							IS_DEMONTAJ=0 AND
							SPEC_MAIN_ID IS NOT NULL
                            <cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
                                AND
                                (
                                <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                    (EXIT_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND EXIT_LOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
                                    <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                </cfloop>  
                                )
                            <cfelse>
                                AND EXIT_DEP_ID IN (#attributes.DEPARTMENT_ID#)
                            </cfif>
							<!--- <cfif len(spec_main_id_list)>AND SPEC_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECT_MAIN_ROW WHERE RELATED_MAIN_SPECT_ID IN (#spec_main_id_list#))</cfif> --->
							<cfif ListLen(attributes.production_order_no,',')>
								AND
								(
									<cfset c_ = 0>
									<cfloop from="1" to="#p_o_no_list_count_#" index="ccc">
										<cfset c_ = c_ + 1>
										PRODUCTION_ORDERS.P_ORDER_NO NOT IN (#evaluate("p_no_list_#ccc#")#) <cfif c_ neq p_o_no_list_count_>AND</cfif>
									</cfloop>
								)
							</cfif>
							<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
								AND P_ORDER_ID NOT IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
							</cfif>
                        UNION ALL
                            SELECT
                                0 AS STOCK_ARTIR,
                                (QUANTITY) AS STOCK_AZALT,
                                PRODUCTION_ORDERS.STOCK_ID,
                            	ISNULL(PRODUCTION_ORDERS.SPEC_MAIN_ID,0) SPECT_MAIN_ID,
                                PRODUCTION_ORDERS.EXIT_DEP_ID
                                <cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,PRODUCTION_ORDERS.EXIT_LOC_ID</cfif>
                            FROM
                                PRODUCTION_ORDERS
                            WHERE
                            	PRODUCTION_ORDERS.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND 
                                IS_STOCK_RESERVED = 1 AND
                                IS_DEMONTAJ=1 AND
                                SPEC_MAIN_ID IS NOT NULL
                                <cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
                                    AND
                                    (
                                    <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (EXIT_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND EXIT_LOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                    </cfloop>  
                                    )
                                <cfelse>
                                    AND EXIT_DEP_ID IN (#attributes.DEPARTMENT_ID#)
                                </cfif>
								<!--- <cfif len(spec_main_id_list)>AND SPEC_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECT_MAIN_ROW WHERE RELATED_MAIN_SPECT_ID IN (#spec_main_id_list#))</cfif> --->
								<cfif ListLen(attributes.production_order_no,',')>
									AND
									(
										<cfset c_ = 0>
										<cfloop from="1" to="#p_o_no_list_count_#" index="ccc">
											<cfset c_ = c_ + 1>
											PRODUCTION_ORDERS.P_ORDER_NO NOT IN (#evaluate("p_no_list_#ccc#")#) <cfif c_ neq p_o_no_list_count_>AND</cfif>
										</cfloop>
									)
								</cfif>
								<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
									AND P_ORDER_ID NOT IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
								</cfif>
                        UNION ALL
                            SELECT
                                0 AS STOCK_ARTIR,
                                CASE WHEN ISNULL((SELECT
											SUM(POR_.AMOUNT)
										FROM
											PRODUCTION_ORDER_RESULTS_ROW POR_,
											PRODUCTION_ORDER_RESULTS POO
										WHERE
											POR_.PR_ORDER_ID = POO.PR_ORDER_ID
											AND POO.P_ORDER_ID = PO.P_ORDER_ID
											AND POR_.STOCK_ID = POS.STOCK_ID
											AND POO.IS_STOCK_FIS = 1
										),0) > (ISNULL(PO.RESULT_AMOUNT,0))
										--- ISNULL(PO.RESULT_AMOUNT,0)) 
						THEN
						 (
											(
                                            	SELECT 
														SUM(AMOUNT) AMOUNT
													FROM
														PRODUCTION_ORDERS_STOCKS
													WHERE
													P_ORDER_ID = PO.P_ORDER_ID AND STOCK_ID = POS.STOCK_ID
											)
											/
											(
												SELECT 
													QUANTITY 
												FROM 
													PRODUCTION_ORDERS
												WHERE
													P_ORDER_ID = PO.P_ORDER_ID
											)										
										)*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0))
						 ELSE 									
                         (POS.AMOUNT - ISNULL((SELECT
											SUM(POR_.AMOUNT)
										FROM
											PRODUCTION_ORDER_RESULTS_ROW POR_,
											PRODUCTION_ORDER_RESULTS POO
										WHERE
											POR_.PR_ORDER_ID = POO.PR_ORDER_ID
											AND POO.P_ORDER_ID = PO.P_ORDER_ID
											AND POR_.STOCK_ID = POS.STOCK_ID
											AND POO.IS_STOCK_FIS = 1
										),0)) END AS STOCK_AZALT,
                                POS.STOCK_ID,
                            	ISNULL(POS.SPECT_MAIN_ID,0) SPECT_MAIN_ID,
                                EXIT_DEP_ID
                                <cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,EXIT_LOC_ID</cfif>
                            FROM
                                PRODUCTION_ORDERS PO,
								PRODUCTION_ORDERS_STOCKS POS
                            WHERE
                                POS.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND 
                                PO.IS_STOCK_RESERVED = 1 AND
                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                PO.IS_DEMONTAJ=0 AND
                                ISNULL(POS.STOCK_ID,0)>0 AND
                                POS.IS_SEVK <> 1 AND
								ISNULL(IS_FREE_AMOUNT,0) = 0
                               <cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
                                    AND
                                    (
                                    <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (EXIT_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND EXIT_LOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                    </cfloop>  
                                    )
                                <cfelse>
                                    AND EXIT_DEP_ID IN (#attributes.DEPARTMENT_ID#)
                                </cfif>
								<!--- <cfif len(spec_main_id_list)>AND POS.SPECT_MAIN_ID IN (#spec_main_id_list#)</cfif> --->
								<cfif ListLen(attributes.production_order_no,',')>
									AND
									(
										<cfset c_ = 0>
										<cfloop from="1" to="#p_o_no_list_count_#" index="ccc">
											<cfset c_ = c_ + 1>
											PO.P_ORDER_NO NOT IN (#evaluate("p_no_list_#ccc#")#) <cfif c_ neq p_o_no_list_count_>AND</cfif>
										</cfloop>
									)
								</cfif>
								<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
									AND PO.P_ORDER_ID NOT IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
								</cfif>
                        UNION ALL
                            SELECT
                                POS.AMOUNT AS STOCK_ARTIR,
                                0 AS STOCK_AZALT,
                                POS.STOCK_ID,
                            	ISNULL(POS.SPECT_MAIN_ID,0) SPECT_MAIN_ID,
                                EXIT_DEP_ID
                                <cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,EXIT_LOC_ID</cfif>
                            FROM
                                PRODUCTION_ORDERS PO,
								PRODUCTION_ORDERS_STOCKS POS
                            WHERE
                                POS.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND 
                                PO.IS_STOCK_RESERVED = 1 AND
                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                PO.IS_DEMONTAJ=1 AND
                                ISNULL(POS.STOCK_ID,0)>0 AND
                                POS.IS_SEVK <> 1 AND
								ISNULL(IS_FREE_AMOUNT,0) = 0
                                <cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
                                    AND
                                    (
                                    <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (EXIT_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND EXIT_LOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                    </cfloop>  
                                    )
                                <cfelse>
                                    AND EXIT_DEP_ID IN (#attributes.DEPARTMENT_ID#)
                                </cfif>
								<!--- <cfif len(spec_main_id_list)>AND POS.SPECT_MAIN_ID IN (#spec_main_id_list#)</cfif> --->
								<cfif ListLen(attributes.production_order_no,',')>
									AND
									(
										<cfset c_ = 0>
										<cfloop from="1" to="#p_o_no_list_count_#" index="ccc">
											<cfset c_ = c_ + 1>
											PO.P_ORDER_NO NOT IN (#evaluate("p_no_list_#ccc#")#) <cfif c_ neq p_o_no_list_count_>AND</cfif>
										</cfloop>
									)
								</cfif>
								<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
									AND PO.P_ORDER_ID NOT IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
								</cfif>
                        UNION ALL
                            SELECT
                                (P_ORD_R_R.AMOUNT)*-1 AS  STOCK_ARTIR,
                                0 AS STOCK_AZALT,
                                P_ORD.STOCK_ID,
                            	ISNULL(P_ORD_R_R.SPEC_MAIN_ID,0) SPECT_MAIN_ID,
                                P_ORD_R.EXIT_DEP_ID
                                <cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,P_ORD_R.EXIT_LOC_ID</cfif>
                            FROM
                                PRODUCTION_ORDER_RESULTS P_ORD_R,
                                PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
                                PRODUCTION_ORDERS P_ORD
                            WHERE
                                P_ORD_R_R.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND 
                                P_ORD.IS_STOCK_RESERVED=1 AND
                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                P_ORD_R_R.TYPE=1 AND
                                P_ORD_R.IS_STOCK_FIS=1 AND
                                P_ORD_R_R.IS_SEVKIYAT IS NULL
                                <cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>
                                    AND
                                    (
                                    <cfloop list="#attributes.department_id#" delimiters="," index="dept_i">
                                        (P_ORD_R.EXIT_DEP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(dept_i,'-')#"> AND P_ORD_R.EXIT_LOC_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(dept_i,'-')#">)
                                        <cfif dept_i neq listlast(attributes.department_id,',') and listlen(attributes.department_id,',') gte 1> OR</cfif>
                                    </cfloop>  
                                    )
                                <cfelse>
                                    AND P_ORD_R.EXIT_DEP_ID IN (#attributes.DEPARTMENT_ID#)
                                </cfif>
								<!--- <cfif len(spec_main_id_list)>AND P_ORD.SPEC_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECT_MAIN_ROW WHERE RELATED_MAIN_SPECT_ID IN (#spec_main_id_list#))</cfif> --->
                    ) T1,
                    #dsn1_alias#.STOCKS S
                    WHERE
                        S.STOCK_ID=T1.STOCK_ID AND
                        T1.EXIT_DEP_ID IS NOT NULL
                    GROUP BY 
                        S.STOCK_ID,
                        S.PRODUCT_ID,
                        T1.SPECT_MAIN_ID,
                        T1.EXIT_DEP_ID
                        <cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,T1.EXIT_LOC_ID</cfif>
                </cfquery>
                <cfif get_product_rezerv_dep.RECORDCOUNT>
                    <cfscript>
                        for(prod_jj=1;prod_jj lte get_product_rezerv_dep.recordcount; prod_jj=prod_jj+1)
						{
							if(isdefined("x_is_dept_location") and x_is_dept_location eq 1)
 								'stock_prod_rezerve_#get_product_rezerv_dep.DEPARTMENT_ID[prod_jj]#_#GET_STOCKS_ALL.LOCATION_ID[prod_jj]#_#get_product_rezerv_dep.STOCK_ID[prod_jj]#_#get_product_rezerv_dep.SPECT_MAIN_ID[prod_jj]#' = get_product_rezerv_dep.STOCK_AZALT[prod_jj];
							else	
								'stock_prod_rezerve_#get_product_rezerv_dep.DEPARTMENT_ID[prod_jj]#_#get_product_rezerv_dep.STOCK_ID[prod_jj]#_#get_product_rezerv_dep.SPECT_MAIN_ID[prod_jj]#' = get_product_rezerv_dep.STOCK_AZALT[prod_jj];
						}
                    </cfscript>
                </cfif>
				<!--- DEPOLARA GÖRE ÜRETİM EMİRLERİ REZERVELER BİTTİ--->
				
                <!--- DEPOLARA GÖRE STRATEJİLERDEN MIN STOCK --->
                <cfquery name="GET_STOCT_STR_DEP" datasource="#DSN3#">
					SELECT 
                    	DEPARTMENT_ID,
                        MINIMUM_STOCK,
                        STOCK_STRATEGY.STOCK_ID 
					FROM 
                    	STOCK_STRATEGY 
					WHERE 
                    	 STOCK_STRATEGY.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND
                         DEPARTMENT_ID IN (#attributes.DEPARTMENT_ID#)
                </cfquery>
                <cfif GET_STOCT_STR_DEP.RECORDCOUNT>
                    <cfscript>
                        for(prod_yy=1;prod_yy lte GET_STOCT_STR_DEP.recordcount; prod_yy=prod_yy+1)
                            'dep_min_stock_#GET_STOCT_STR_DEP.DEPARTMENT_ID[prod_yy]#_#GET_STOCT_STR_DEP.STOCK_ID[prod_yy]#' = GET_STOCT_STR_DEP.MINIMUM_STOCK[prod_yy];
                    </cfscript>
                </cfif>
				<cfif isdefined("demand_department_id") and len(demand_department_id)>
					<cfquery name="GET_STOCK_DEMAND" datasource="#DSN3#">
						SELECT
							SUM(AMOUNT) AS TOTAL_AMOUNT,
							STOCK_ID
						FROM
							(
								SELECT
									SUM(QUANTITY) AS AMOUNT,
									IR.STOCK_ID
								FROM
									INTERNALDEMAND_ROW IR ,
									INTERNALDEMAND I
								WHERE
									IR.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND
                                    I.INTERNAL_ID= IR.I_ID
									AND I.IS_ACTIVE=1
									AND I.DEPARTMENT_OUT = #demand_department_id#
								GROUP BY
									IR.STOCK_ID
								UNION ALL
								SELECT
									-1*SUM(PR.AMOUNT)  AMOUNT,
									PR.STOCK_ID
								FROM
									INTERNALDEMAND_ROW IR,
									INTERNALDEMAND_RELATION_ROW PR,
									INTERNALDEMAND I
								WHERE
									PR.INTERNALDEMAND_ID = I.INTERNAL_ID
									AND PR.STOCK_ID = IR.STOCK_ID
									AND PR.STOCK_ID IN(#stock_id_list#)
									AND IR.STOCK_ID IN(#stock_id_list#)
									AND I.INTERNAL_ID= IR.I_ID
									AND I.IS_ACTIVE=1
									AND I.DEPARTMENT_OUT = #demand_department_id#
									AND PR.TO_SHIP_ID IS NOT NULL
								GROUP BY
									PR.STOCK_ID
							) AS A1
						GROUP BY
							STOCK_ID
					</cfquery>
					<cfif GET_STOCK_DEMAND.RECORDCOUNT>
						<cfscript>
							for(prod_yy=1;prod_yy lte GET_STOCK_DEMAND.recordcount; prod_yy=prod_yy+1)
								'dept_demand_stock_#GET_STOCK_DEMAND.STOCK_ID[prod_yy]#' = GET_STOCK_DEMAND.TOTAL_AMOUNT[prod_yy];
						</cfscript>
					</cfif>
				</cfif>
				<cfquery name="get_alternative_stocks" datasource="#dsn3#">
					SELECT 
						SUM(GS.SALEABLE_STOCK) STOCK_AMOUNT,
						S2.STOCK_ID,
						GS.DEPARTMENT_ID
                        <cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,GS.LOCATION_ID</cfif>
					FROM
						ALTERNATIVE_PRODUCTS AP,
						STOCKS S,
						STOCKS S2
                        LEFT JOIN ####get_metarials_get_order_#session.ep.userid# XXX ON S2.STOCK_ID = XXX.STOCK_ID,
						#dsn2_alias#.GET_STOCK_LAST_LOCATION GS
					WHERE 
						S.PRODUCT_ID = AP.ALTERNATIVE_PRODUCT_ID AND
						AP.STOCK_ID IS NOT NULL AND
						S.STOCK_ID = GS.STOCK_ID AND
						S2.PRODUCT_ID = AP.PRODUCT_ID AND
						GS.DEPARTMENT_ID > 0
					GROUP BY
						S2.STOCK_ID,
						GS.DEPARTMENT_ID
                        <cfif isdefined("x_is_dept_location") and x_is_dept_location eq 1>,GS.LOCATION_ID</cfif>
				</cfquery>
				<cfif get_alternative_stocks.RECORDCOUNT>
					<cfscript>
						for(prod_yy=1;prod_yy lte get_alternative_stocks.recordcount; prod_yy=prod_yy+1)
						{
							if(isdefined("x_is_dept_location") and x_is_dept_location eq 1)
								'alternative_amount_#get_alternative_stocks.DEPARTMENT_ID[prod_yy]#_#get_alternative_stocks.LOCATION_ID[prod_yy]#_#get_alternative_stocks.STOCK_ID[prod_yy]#' = get_alternative_stocks.STOCK_AMOUNT[prod_yy];
							else
								'alternative_amount_#get_alternative_stocks.DEPARTMENT_ID[prod_yy]#_#get_alternative_stocks.STOCK_ID[prod_yy]#' = get_alternative_stocks.STOCK_AMOUNT[prod_yy];
						}
					</cfscript>
				</cfif>
			<cfelse><!---       depo seçili değilse        --->
				<cfset stock_id_list = listdeleteduplicates(stock_id_list)>
				<cfset spec_main_id_list = listdeleteduplicates(spec_main_id_list)>
                <cfquery name="GET_STOCKS_ALL" datasource="#DSN2#">
                    SELECT 
                        SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_STOCK,
                        SR.STOCK_ID
                    FROM 
                        STOCKS_ROW SR
                    WHERE
                     <cfif not((isdefined('attributes.is_excel') and attributes.is_excel eq 1) and get_metarials.recordcount gt 5000)>
                    	SR.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND
                     </cfif>   
						SR.STORE_LOCATION NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID =SR.STORE)
					GROUP BY
						SR.STOCK_ID
					<cfif len(spec_main_id_list)>
						UNION ALL
						SELECT 
							SUM(SR.STOCK_IN-SR.STOCK_OUT) PRODUCT_STOCK,
							SR.STOCK_ID
						FROM 
							STOCKS_ROW SR
                            
						WHERE
                        	<cfif not((isdefined('attributes.is_excel') and attributes.is_excel eq 1) and get_metarials.recordcount gt 5000)>
							 	SR.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND
							</cfif>
							SR.SPECT_VAR_ID IN (#spec_main_id_list#) AND
							SR.STORE_LOCATION NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID =SR.STORE)
						GROUP BY
							SR.STOCK_ID
					</cfif>
                </cfquery>
                <cfif GET_STOCKS_ALL.recordcount>
                    <cfscript>
                        for(s_ind=1;s_ind lte GET_STOCKS_ALL.recordcount;s_ind=s_ind+1)
                            'dep_stock_status_#GET_STOCKS_ALL.STOCK_ID[s_ind]#' = GET_STOCKS_ALL.PRODUCT_STOCK[s_ind];
                    </cfscript>
                </cfif>
				<!--- GERÇEK STOKLAR BİTTİ--->
				<!--- ÜRETİM EMİRLERİ REZERVELER --->
                <cfquery name="get_product_rezerv_dep" datasource="#dsn3#">
                    SELECT
                        SUM(STOCK_ARTIR) STOCK_ARTIR,
                        SUM(STOCK_AZALT) STOCK_AZALT,
                        S.STOCK_ID,
                         ISNULL((SELECT TOP 1 SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID),''),
                        S.PRODUCT_ID,
                        T1.SPECT_MAIN_ID
                    FROM
                        (
                       SELECT
							(QUANTITY) AS STOCK_ARTIR,
							0 AS STOCK_AZALT,
							PRODUCTION_ORDERS.STOCK_ID,
                            ISNULL(PRODUCTION_ORDERS.SPEC_MAIN_ID,0) SPECT_MAIN_ID
						FROM
							PRODUCTION_ORDERS
						WHERE
                        	PRODUCTION_ORDERS.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND
							IS_STOCK_RESERVED = 1 AND
							IS_DEMONTAJ=0 AND
							SPEC_MAIN_ID IS NOT NULL
							--AND EXIT_DEP_ID IS NOT NULL
							AND EXIT_LOC_ID NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID =EXIT_DEP_ID)
							<!--- <cfif len(spec_main_id_list)>AND SPEC_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECT_MAIN_ROW WHERE RELATED_MAIN_SPECT_ID IN (#spec_main_id_list#))</cfif> --->
							<cfif ListLen(attributes.production_order_no,',')>
								AND
								(
									<cfset c_ = 0>
									<cfloop from="1" to="#p_o_no_list_count_#" index="ccc">
										<cfset c_ = c_ + 1>
										PRODUCTION_ORDERS.P_ORDER_NO NOT IN (#evaluate("p_no_list_#ccc#")#) <cfif c_ neq p_o_no_list_count_>AND</cfif>
									</cfloop>
								)
							</cfif>
							<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
								AND P_ORDER_ID NOT IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
							</cfif>
                        UNION ALL
                            SELECT
                                0 AS STOCK_ARTIR,
                                (QUANTITY) AS STOCK_AZALT,
                                PRODUCTION_ORDERS.STOCK_ID,
                                ISNULL(PRODUCTION_ORDERS.SPEC_MAIN_ID,0) SPECT_MAIN_ID
                            FROM
                                PRODUCTION_ORDERS
                            WHERE
                            	PRODUCTION_ORDERS.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND
                                IS_STOCK_RESERVED = 1 AND
                                IS_DEMONTAJ=1 AND
                                SPEC_MAIN_ID IS NOT NULL
                                --AND EXIT_DEP_ID IS NOT NULL
								AND EXIT_LOC_ID NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID =EXIT_DEP_ID)
								<!--- <cfif len(spec_main_id_list)>AND SPEC_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECT_MAIN_ROW WHERE RELATED_MAIN_SPECT_ID IN (#spec_main_id_list#))</cfif> --->
								<cfif ListLen(attributes.production_order_no,',')>
									AND
									(
										<cfset c_ = 0>
										<cfloop from="1" to="#p_o_no_list_count_#" index="ccc">
											<cfset c_ = c_ + 1>
											PRODUCTION_ORDERS.P_ORDER_NO NOT IN (#evaluate("p_no_list_#ccc#")#) <cfif c_ neq p_o_no_list_count_>AND</cfif>
										</cfloop>
									)
								</cfif>
								<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
									AND P_ORDER_ID NOT IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
								</cfif>
                        UNION ALL
                            SELECT
                                0 AS STOCK_ARTIR,
                                CASE WHEN ISNULL((SELECT
											SUM(POR_.AMOUNT)
										FROM
											PRODUCTION_ORDER_RESULTS_ROW POR_,
											PRODUCTION_ORDER_RESULTS POO
										WHERE
											POR_.PR_ORDER_ID = POO.PR_ORDER_ID
											AND POO.P_ORDER_ID = PO.P_ORDER_ID
											AND POR_.STOCK_ID = POS.STOCK_ID
											AND POO.IS_STOCK_FIS = 1
										),0) > (ISNULL(PO.RESULT_AMOUNT,0))
										--- ISNULL(PO.RESULT_AMOUNT,0)) 
						THEN
						 (
											(
                                            	SELECT 
														SUM(AMOUNT) AMOUNT
													FROM
														PRODUCTION_ORDERS_STOCKS
													WHERE
													P_ORDER_ID = PO.P_ORDER_ID AND STOCK_ID = POS.STOCK_ID
											)
											/
											(
												SELECT 
													QUANTITY 
												FROM 
													PRODUCTION_ORDERS
												WHERE
													P_ORDER_ID = PO.P_ORDER_ID
											)										
										)*(ISNULL(PO.QUANTITY,0) - ISNULL(PO.RESULT_AMOUNT,0))
						 ELSE 									
                         (POS.AMOUNT - ISNULL((SELECT
											SUM(POR_.AMOUNT)
										FROM
											PRODUCTION_ORDER_RESULTS_ROW POR_,
											PRODUCTION_ORDER_RESULTS POO
										WHERE
											POR_.PR_ORDER_ID = POO.PR_ORDER_ID
											AND POO.P_ORDER_ID = PO.P_ORDER_ID
											AND POR_.STOCK_ID = POS.STOCK_ID
											AND POO.IS_STOCK_FIS = 1
										),0)) END AS STOCK_AZALT,
                                POS.STOCK_ID,
                                ISNULL(POS.SPECT_MAIN_ID,0) SPECT_MAIN_ID
                            FROM
                                PRODUCTION_ORDERS PO,
                                PRODUCTION_ORDERS_STOCKS POS
                            WHERE
                                POS.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND
                                PO.IS_STOCK_RESERVED = 1 AND
                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                PO.IS_DEMONTAJ=0 AND
                                ISNULL(POS.STOCK_ID,0)>0 AND
                                POS.IS_SEVK <> 1
                               -- AND EXIT_DEP_ID IS NOT NULL
								AND EXIT_LOC_ID NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID = EXIT_DEP_ID)
								<!--- <cfif len(spec_main_id_list)>AND POS.SPECT_MAIN_ID IN (#spec_main_id_list#)</cfif> --->
								<cfif ListLen(attributes.production_order_no,',')>
									AND
									(
										<cfset c_ = 0>
										<cfloop from="1" to="#p_o_no_list_count_#" index="ccc">
											<cfset c_ = c_ + 1>
											PO.P_ORDER_NO NOT IN (#evaluate("p_no_list_#ccc#")#) <cfif c_ neq p_o_no_list_count_>AND</cfif>
										</cfloop>
									)
								</cfif>
								<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
									AND PO.P_ORDER_ID NOT IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
								</cfif>
                        UNION ALL
                            SELECT
                                POS.AMOUNT AS STOCK_ARTIR,
                                0 AS STOCK_AZALT,
                                POS.STOCK_ID,
                                ISNULL(POS.SPECT_MAIN_ID,0) SPECT_MAIN_ID
                            FROM
                                PRODUCTION_ORDERS PO,
                                PRODUCTION_ORDERS_STOCKS POS
                            WHERE
                            	POS.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND
                                PO.IS_STOCK_RESERVED = 1 AND
                                PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                PO.IS_DEMONTAJ=1 AND
                                ISNULL(POS.STOCK_ID,0)>0 AND
                                POS.IS_SEVK <> 1
                                --AND EXIT_DEP_ID IS NOT NULL
								AND EXIT_LOC_ID NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID = EXIT_DEP_ID)
								<!--- <cfif len(spec_main_id_list)>AND POS.SPECT_MAIN_ID IN (#spec_main_id_list#)</cfif> --->
								<cfif ListLen(attributes.production_order_no,',')>
									AND
									(
										<cfset c_ = 0>
										<cfloop from="1" to="#p_o_no_list_count_#" index="ccc">
											<cfset c_ = c_ + 1>
											PO.P_ORDER_NO NOT IN (#evaluate("p_no_list_#ccc#")#) <cfif c_ neq p_o_no_list_count_>AND</cfif>
										</cfloop>
									)
								</cfif>
								<cfif isdefined("attributes.row_demand_all") and len(attributes.row_demand_all)>
									AND PO.P_ORDER_ID NOT IN (SELECT TEMP_VALUE FROM #dsn_alias#.TEMP_BLOCK_VALUES WHERE TEMP_COLUMN = 'P_ORDER_ID_FROM_ROW_DEMAND' AND RECORD_EMP = #session.ep.userid#)
								</cfif>
                        UNION ALL
                            SELECT
                                (P_ORD_R_R.AMOUNT)*-1 AS  STOCK_ARTIR,
                                0 AS STOCK_AZALT,
                                P_ORD_R_R.STOCK_ID,
                                ISNULL(P_ORD_R_R.SPEC_MAIN_ID,0) SPECT_MAIN_ID
                            FROM
                                PRODUCTION_ORDER_RESULTS P_ORD_R,
                                PRODUCTION_ORDER_RESULTS_ROW P_ORD_R_R,
                                PRODUCTION_ORDERS P_ORD
                            WHERE
                            	P_ORD_R_R.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) AND
                                P_ORD.IS_STOCK_RESERVED=1 AND
                                P_ORD.SPEC_MAIN_ID IS NOT NULL AND
                                P_ORD.P_ORDER_ID = P_ORD_R.P_ORDER_ID AND
                                P_ORD_R_R.PR_ORDER_ID=P_ORD_R.PR_ORDER_ID AND
                                P_ORD_R_R.TYPE=1 AND
                                P_ORD_R.IS_STOCK_FIS=1 AND
                                P_ORD_R_R.IS_SEVKIYAT IS NULL
                                AND P_ORD_R.EXIT_DEP_ID IS NOT NULL
								AND P_ORD_R.EXIT_LOC_ID NOT IN (SELECT SL.LOCATION_ID FROM #dsn_alias#.STOCKS_LOCATION SL WHERE SL.IS_SCRAP = 1 AND SL.DEPARTMENT_ID = P_ORD_R.EXIT_DEP_ID)
                 				<!--- <cfif len(spec_main_id_list)>AND P_ORD.SPEC_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECT_MAIN_ROW WHERE RELATED_MAIN_SPECT_ID IN (#spec_main_id_list#))</cfif> --->
				    ) T1,
                    #dsn1_alias#.STOCKS S
                    WHERE
                        S.STOCK_ID=T1.STOCK_ID
                      
                    GROUP BY 
                        S.STOCK_ID,
                        S.PRODUCT_ID,
                        T1.SPECT_MAIN_ID
                </cfquery>
                <cfif get_product_rezerv_dep.RECORDCOUNT>
                    <cfscript>
                        for(prod_jj=1;prod_jj lte get_product_rezerv_dep.recordcount; prod_jj=prod_jj+1)
                            'stock_prod_rezerve_#get_product_rezerv_dep.STOCK_ID[prod_jj]#_#get_product_rezerv_dep.SPECT_MAIN_ID[prod_jj]#' = get_product_rezerv_dep.STOCK_AZALT[prod_jj];
                    </cfscript>
                </cfif>
				<!--- ÜRETİM EMİRLERİ REZERVELER BİTTİ--->
				<!--- STRATEJİLERDEN MIN STOCK --->
				<cfquery name="GET_STOCT_STR_DEP" datasource="#DSN3#">
					SELECT 
                        SUM(ISNULL(MINIMUM_STOCK,0)) MINIMUM_STOCK,
                        STOCK_ID 
					FROM 
                    	STOCK_STRATEGY 
					WHERE 
                    	STOCK_ID IN (#stock_id_list#)
					GROUP BY
						STOCK_ID
                </cfquery>
                <cfif GET_STOCT_STR_DEP.RECORDCOUNT>
                    <cfscript>
                        for(prod_yy=1;prod_yy lte GET_STOCT_STR_DEP.recordcount; prod_yy=prod_yy+1)
                            'dep_min_stock_#GET_STOCT_STR_DEP.STOCK_ID[prod_yy]#' = GET_STOCT_STR_DEP.MINIMUM_STOCK[prod_yy];
                    </cfscript>
                </cfif>
				<!--- STRATEJİLERDEN MIN STOCK BİTTİ--->
				<cfquery name="get_alternative_stocks" datasource="#dsn3#">
					SELECT 
						SUM(GS.SALEABLE_STOCK) STOCK_AMOUNT,
						S2.STOCK_ID
					FROM
						ALTERNATIVE_PRODUCTS AP,
						STOCKS S,
						STOCKS S2  
                        LEFT JOIN ####get_metarials_get_order_#session.ep.userid# XXX ON S2.STOCK_ID = XXX.STOCK_ID,
						#dsn2_alias#.GET_STOCK_LAST GS
					WHERE 
						S.PRODUCT_ID = AP.ALTERNATIVE_PRODUCT_ID AND
						AP.STOCK_ID IS NOT NULL AND
						S.STOCK_ID = GS.STOCK_ID AND
						S2.PRODUCT_ID = AP.PRODUCT_ID
					GROUP BY
						S2.STOCK_ID
				</cfquery>
				<cfif get_alternative_stocks.RECORDCOUNT>
					<cfscript>
						for(prod_yy=1;prod_yy lte get_alternative_stocks.recordcount; prod_yy=prod_yy+1)
							'alternative_amount_#get_alternative_stocks.STOCK_ID[prod_yy]#' = get_alternative_stocks.STOCK_AMOUNT[prod_yy];
					</cfscript>
				</cfif>
			</cfif>
            <cfif len(stock_id_list)>
				<!--- ÜRETİM BEKLENEN --->
				<cfquery name="GET_STOCK_PROD_BEKLENEN" datasource="#dsn3#">
					SELECT
						SUM(STOCK_ARTIR) AS ARTAN,
						GET_PRODUCTION_RESERVED.STOCK_ID
					FROM
						GET_PRODUCTION_RESERVED
					WHERE 
                    	GET_PRODUCTION_RESERVED.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#) 
                    GROUP BY 
                        GET_PRODUCTION_RESERVED.STOCK_ID
					<cfif len(spec_main_id_list)>
						UNION ALL
						SELECT
							SUM(STOCK_ARTIR) AS ARTAN,
							GET_PRODUCTION_RESERVED_SPECT.STOCK_ID
						FROM
							GET_PRODUCTION_RESERVED_SPECT
						WHERE						
							GET_PRODUCTION_RESERVED_SPECT.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#)  AND 
                            GET_PRODUCTION_RESERVED_SPECT.SPECT_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECT_MAIN_ROW WHERE RELATED_MAIN_SPECT_ID IN (#spec_main_id_list#))
						GROUP BY 
							GET_PRODUCTION_RESERVED_SPECT.STOCK_ID
					</cfif>
				</cfquery>  
				<cfif GET_STOCK_PROD_BEKLENEN.RECORDCOUNT>
                    <cfscript>
                        for(prod_rr=1;prod_rr lte GET_STOCK_PROD_BEKLENEN.recordcount; prod_rr=prod_rr+1){
                            'prod_bekleyen_#GET_STOCK_PROD_BEKLENEN.STOCK_ID[prod_rr]#' = GET_STOCK_PROD_BEKLENEN.ARTAN[prod_rr];
						}
                    </cfscript>
                </cfif>              
                <!--- ÜRÜN FİYATLAR --->
                <cfquery name="GET_PRICE" datasource="#DSN3#">
                    SELECT
                        P.MONEY,
                        P.PRICE,
                        S.STOCK_ID
                    FROM
						<cfif attributes.price_cat eq -1>
							PRICE_STANDART P,
						<cfelse>
							PRICE P,
						</cfif>
                        STOCKS S 
                    WHERE
                    	S.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#)  AND 
                    	S.PRODUCT_ID = P.PRODUCT_ID AND
						<cfif attributes.price_cat eq -1>
							P.PRICESTANDART_STATUS = 1 AND
							P.PURCHASESALES = 0
						<cfelse>
							ISNULL(P.STOCK_ID,0)=0 AND
							ISNULL(P.SPECT_VAR_ID,0)=0 AND
							P.STARTDATE <= #now()# AND
							(P.FINISHDATE >= #now()# OR P.FINISHDATE IS NULL) AND
							P.PRICE_CATID = #attributes.price_cat#
						</cfif>
                </cfquery>
                <cfif GET_PRICE.RECORDCOUNT>
                    <cfscript>
                        for(prod_xx=1;prod_xx lte GET_PRICE.recordcount; prod_xx=prod_xx+1){
                            'product_price_#GET_PRICE.STOCK_ID[prod_xx]#' = GET_PRICE.PRICE[prod_xx];
							'product_money_#GET_PRICE.STOCK_ID[prod_xx]#' = GET_PRICE.MONEY[prod_xx];
						}
                    </cfscript>
                </cfif>
                <!---<cfset spec_id_list = ''>
            <cfoutput query="get_metarials" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfset spec_id_list = ListAppend(spec_id_list,SPECT_MAIN_ID,',')>
			</cfoutput>
                <cfquery name="GET_SPECT_NAME" datasource="#dsn3#">
                SELECT  
					 (SELECT TOP 1 SPECT_MAIN_NAME FROM SPECT_MAIN SM WHERE SM.STOCK_ID = S.STOCK_ID) SPECT_MAIN_NAME
				FROM 
					PRODUCTION_ORDERS_STOCKS POS,
					STOCKS S
				WHERE
                    POS.STOCK_ID = S.STOCK_ID AND 
                    SPECT_MAIN_ID IN(7094,7103,0) AND
                    TYPE = 2
					GROUP BY
					POS.SPECT_MAIN_ID,
					--SM.SPECT_MAIN_NAME,
					S.STOCK_ID
                </cfquery>--->
                <!---<cfset spec_name_list = ''>
            <cfoutput query="GET_SPECT_NAME" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfset spec_name_list = ListAppend(spec_name_list,SPECT_MAIN_NAME,',')>
			</cfoutput> --->           
                <!--- ÜRÜN FİYATLAR BİTTİ --->
                <!--- SATIALMA SİPARİŞ REZERVELER --->
                <cfquery name="GET_STOCK_RESERVED" datasource="#DSN3#"><!--- siparisler stoktan dusulecek veya eklenecekse toplamını alalım--->
                    SELECT
                    	GET_STOCK_RESERVED.STOCK_ID,
                        SUM(STOCK_ARTIR) AS ARTAN
                    FROM
                        GET_STOCK_RESERVED
                        <cfif not((isdefined('attributes.is_excel') and attributes.is_excel eq 1) and get_metarials.recordcount gt 5000)>
                        	WHERE 
                            GET_STOCK_RESERVED.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#)   
                        </cfif>
                    GROUP BY GET_STOCK_RESERVED.STOCK_ID  
					<cfif len(spec_main_id_list)>
						UNION ALL
						SELECT
							GET_STOCK_RESERVED_SPECT.STOCK_ID,
							SUM(STOCK_ARTIR) AS ARTAN
						FROM
							GET_STOCK_RESERVED_SPECT
                            <cfif not((isdefined('attributes.is_excel') and attributes.is_excel eq 1) and get_metarials.recordcount gt 5000)>
							    WHERE 
                                 GET_STOCK_RESERVED_SPECT.STOCK_ID IN (SELECT STOCK_ID FROM ####get_metarials_get_order_#session.ep.userid#)
							     AND GET_STOCK_RESERVED_SPECT.SPECT_MAIN_ID IN (SELECT SPECT_MAIN_ID FROM SPECT_MAIN_ROW WHERE RELATED_MAIN_SPECT_ID IN (#spec_main_id_list#))
							</cfif>
						GROUP BY GET_STOCK_RESERVED_SPECT.STOCK_ID  
					</cfif>
                </cfquery>
                <cfif GET_STOCK_RESERVED.RECORDCOUNT>
                    <cfscript>
                        for(prod_rr=1;prod_rr lte GET_STOCK_RESERVED.recordcount; prod_rr=prod_rr+1){
                            'stock_order_res_#GET_STOCK_RESERVED.STOCK_ID[prod_rr]#' = GET_STOCK_RESERVED.ARTAN[prod_rr];
						}
                    </cfscript>
                </cfif>
                <!--- SATIALMA SİPARİŞ REZERVELER BİTTİ--->
            </cfif>
    </cfif>
    </cfif>
</cfif>  
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")> 
   <script type="text/javascript">
	   $( document ).ready(function() {
			document.getElementById('demand_no').focus();
		});
		
		function connectAjax()
		{
			if(DISPLAY_ORDER_STOCK_INFO.style.display == 'none')
			{
				DISPLAY_ORDER_STOCK_INFO.style.display = '';
				<cfif (isdefined("stock_id_list_info1") and len(stock_id_list_info1)) or (isdefined("stock_id_list_info2") and len(stock_id_list_info2))>
					AjaxPageLoad('<cfoutput>#request.self#?fuseaction=prod.emptypopup_list_materials_stock_info&stock_id_list_info1=#stock_id_list_info1#&stock_id_list_info2=#stock_id_list_info2#</cfoutput>','DISPLAY_ORDER_STOCK_INFO',1);
				</cfif>
			}
			else
			{
				DISPLAY_ORDER_STOCK_INFO.style.display = 'none'
			}
		}
		function connectAjax2(crtrow,stock_id)
		{
			var bb = '<cfoutput>#request.self#?fuseaction=prod.emptypopup_ajax_alternative_stock_info&deep_level_max=1&tree_stock_status=1</cfoutput>&crtrow='+crtrow+'&sid='+ stock_id;
			AjaxPageLoad(bb,'DISPLAY_MATERIAL_STOCK_INFO'+crtrow,1);
		}
		function open_file()
		{
			document.getElementById('material_file').style.display='';
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=prod.popup_add_material_file','material_file',1);
			return false;
		}
		function hesapla(stock_id)
		{
			document.getElementById('row_price_'+stock_id+'').value = commaSplit(parseFloat(document.getElementById('row_price_unit_'+stock_id+'').value*filterNum(document.getElementById('row_total_need_'+stock_id+'').value)));
		}
		function convert_to_excel()
		{
			document.list_meterials.is_excel.value = 1;
			list_meterials.action='<cfoutput>#request.self#?fuseaction=prod.list_materials_total&event=excel</cfoutput>';
			list_meterials.submit();
			document.list_meterials.is_excel.value = 0;
			list_meterials.action='<cfoutput>#request.self#?fuseaction=prod.list_materials_total</cfoutput>';
			return true;
		}
		function show_rezerved_orders_detail(row_id,stock_id)
		{
			document.getElementById('show_rezerved_orders_detail'+row_id+'').style.display='';
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_reserved_orders&taken=0&sid='+stock_id+'&row_id='+row_id+'','show_rezerved_orders_detail'+row_id+'',1);
		}
		function show_stock_detail(row_id,stock_id,department_id)
		{
			document.getElementById('stock_detail'+row_id+'').style.display='';
			AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_stock_detail&taken=0&sid='+stock_id+'&row_id='+row_id+'&department_id='+department_id+'','stock_detail'+row_id+'',1);
		}
		function kota_kontrol(type)
			/*
			___Type__
			1:Sevk İrsaliyesi
			2:Ambar Fişi
			3:Satın Alma Talebi
			*/
		{
			 var convert_list ="";
			 var convert_list_amount ="";
			 var convert_list_price ="";
			 var convert_list_price_other="";
			 var convert_list_money ="";
			 //
			 var count=0;
			 <cfif isdefined("attributes.is_submitted")>
				 <cfoutput query="get_metarials" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				 count++;
				
					 if(document.getElementById('_conversion_product_'+count).checked == true && filterNum(document.getElementById('row_total_need_#stock_id#').value) > 0)
					 {
						convert_list += "#stock_id#,";
						convert_list_amount += filterNum(document.getElementById('row_total_need_#stock_id#').value,3)+',';
						convert_list_price_other += filterNum(document.getElementById('row_price_unit_#stock_id#').value,3)+',';
						convert_list_price += list_getat(document.getElementById('row_stock_money_#stock_id#').value,2,',')*filterNum(document.getElementById('row_price_unit_#stock_id#').value,8)+',';
						convert_list_money += list_getat(document.getElementById('row_stock_money_#stock_id#').value,1,',')+',';
					 }
				 </cfoutput>
			</cfif>
			document.getElementById('convert_stocks_id').value=convert_list;
			document.getElementById('convert_amount_stocks_id').value=convert_list_amount;
			document.getElementById('convert_price').value=convert_list_price;
			document.getElementById('convert_price_other').value=convert_list_price_other;
			document.getElementById('convert_money').value=convert_list_money;
			if(convert_list)//Ürün Seçili ise
			{
				 windowopen('','wide','cc_paym');
				 if(type==1)
				 {
					 aktar_form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=stock.add_ship_dispatch&type=convert";
					 document.getElementById('sevk_irsaliyesi').disabled=true;
				 }
				 if(type==2)
				 {
					 aktar_form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=stock.form_add_fis&type=convert";
					 document.getElementById('ambar_fisi').disabled=true;
				 }
				 if(type==3)
				 {
					  aktar_form.action="<cfoutput>#request.self#</cfoutput>?fuseaction=purchase.list_internaldemand&event=add&type=convert&ref_no="+encodeURIComponent(document.getElementById('production_order_no').value);
					  document.getElementById('satin_alma_talebi').disabled=true;
				 }
				 aktar_form.target='cc_paym';
				 aktar_form.submit();
			 }
			 else
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no ='245.Ürün'>.");
		}
	function wrk_select_all2(all_conv_product,_conversion_product_,number,strttw)
	{
		for(var cl_ind=strttw; cl_ind <= number; cl_ind++)
		{
			if(document.getElementById(all_conv_product).checked == true)
			{
				if(document.getElementById('_conversion_product_'+cl_ind) != undefined && document.getElementById('_conversion_product_'+cl_ind).checked == false)
					document.getElementById('_conversion_product_'+cl_ind).checked = true;
			}
			else
			{
				if(document.getElementById('_conversion_product_'+cl_ind) != undefined && document.getElementById('_conversion_product_'+cl_ind).checked == true)
					document.getElementById('_conversion_product_'+cl_ind).checked = false;
			}
		}
	}
	</script>
</cfif>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();	
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'prod.list_materials_total';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production_plan/display/list_materials_total.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;		
	
	WOStruct['#attributes.fuseaction#']['excel'] = structNew();
	WOStruct['#attributes.fuseaction#']['excel']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['excel']['fuseaction'] = 'prod.list_materials_total';
	WOStruct['#attributes.fuseaction#']['excel']['filePath'] = 'production_plan/display/list_materials_total.cfm';
	WOStruct['#attributes.fuseaction#']['excel']['queryPath'] = 'production_plan/display/list_materials_total.cfm';
	
</cfscript>
