<cf_get_lang_set module_name="prod">
<cf_xml_page_edit fuseact="prod.popup_add_quality_control_report">	
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<STYLE TYPE="text/css">
		.texttype{
		font-family: Geneva, tahoma, arial, Helvetica, sans-serif;
		}
    </style>
    <cfparam name="attributes.process_cat_id" default="">
    <cfparam name="attributes.quality_type" default="">
    <cfparam name="attributes.q_serial_no" default="">
    <cfparam name="attributes.project_id" default="">
    <cfparam name="attributes.project_head" default="">
    <cfparam name="attributes.controller_emp_id" default="">
    <cfparam name="attributes.controller_emp" default="">
     
    <cfif isdefined("attributes.from_add_contol_page")>
    	<cf_get_lang_set module_name="prod">
		<cfset sum_control_amount = 0>
        	<cfquery name="get_quality_list" datasource="#dsn3#">
				SELECT
					ORQ.OR_Q_ID,
					ORQ.Q_CONTROL_NO, 
					ORQ.SUCCESS_ID,
					ORQ.IS_REPROCESS,
					ORQ.IS_ALL_AMOUNT,
					ORQ.STOCK_ID,
					ORQ.PROCESS_ROW_ID,
					ORQ.CONTROL_AMOUNT,
					ORQ.CONTROL_DETAIL,
					ORQ.RECORD_DATE,
					PTR.STAGE					
				FROM 
					ORDER_RESULT_QUALITY ORQ 
					LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = ORQ.STAGE
				WHERE 
					ORQ.PROCESS_ID = #attributes.process_id_# AND
					(
						(ORQ.PROCESS_CAT IN (76,811,171) AND ORQ.SHIP_WRK_ROW_ID = '#attributes.ship_wrk_row_id_#') OR
						(ORQ.PROCESS_CAT NOT IN (76,811,171) AND ORQ.PROCESS_ROW_ID = #attributes.process_row_id_#)
					)
			</cfquery>
            <cfset succes_id_list = listdeleteduplicates(ValueList(get_quality_list.success_id,','))>
			<cfset kalan_ = 0>
			<cfif get_quality_list.recordcount>
            	<cfif ListLen(succes_id_list)>
					<cfquery name="get_succes_name" datasource="#dsn3#">
						SELECT SUCCESS,SUCCESS_ID,QUALITY_COLOR FROM QUALITY_SUCCESS WHERE SUCCESS_ID IN (#succes_id_list#)
					</cfquery>
					<cfif get_succes_name.recordcount>
						<cfscript>
							for(xi=1;xi lte get_succes_name.recordcount;xi=xi+1)
							{
								'success_#get_succes_name.SUCCESS_ID[xi]#' = get_succes_name.SUCCESS[xi];
								'success_color_#get_succes_name.SUCCESS_ID[xi]#' = get_succes_name.QUALITY_COLOR[xi];
							}
						</cfscript>
					</cfif>
				</cfif>
            </cfif>  
    <cfelse>
        <cf_xml_page_edit fuseact="prod.list_quality_controls">
        <cf_get_lang_set module_name="prod">
        <cfparam name="attributes.process_id" default="">
        <cfparam name="attributes.related_success_id" default="">
        <cfparam name="attributes.employee_id" default="">
        <cfparam name="attributes.employee" default="">
        <cfparam name="attributes.company_id" default="">
        <cfparam name="attributes.consumer_id" default="">
        <cfparam name="attributes.company" default="">
        <cfparam name="attributes.q_control_no" default="">
        <cfparam name="attributes.belge_no" default="">
        <cfparam name="attributes.group" default="">
        <cfparam name="attributes.date1" default="">
        <cfparam name="attributes.date2" default="">
        <cfparam name="attributes.stock_id" default="">
        <cfparam name="attributes.product_name" default="">
        <cfparam name="attributes.department_id" default="">
        <cfparam name="attributes.sort_type" default="">
        <cfparam name="attributes.process_stage" default="">
        <cfquery name="get_succes_names" datasource="#dsn3#">
            SELECT SUCCESS,SUCCESS_ID,QUALITY_COLOR FROM QUALITY_SUCCESS ORDER BY SUCCESS
        </cfquery>
        <cfquery name="get_process_stage" datasource="#dsn#">
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
                PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%prod.popup_add_quality_control_report%">
            ORDER BY
                PTR.LINE_NUMBER
        </cfquery>
        <cfif get_succes_names.recordcount>
            <cfscript>
                for(xi=1;xi lte get_succes_names.recordcount;xi=xi+1)
                {
                    'success_#get_succes_names.SUCCESS_ID[xi]#' = get_succes_names.SUCCESS[xi];
                    'success_color_#get_succes_names.SUCCESS_ID[xi]#' = get_succes_names.QUALITY_COLOR[xi];
                }
            </cfscript>
        </cfif>
        <cfif isdefined("attributes.date2") and isdate(attributes.date2)>
            <cf_date tarih="attributes.date2">
        <cfelse>
            <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
                <cfset attributes.date2=''>
            <cfelse>
                <cfset attributes.date2 = createodbcdatetime('#session.ep.period_year#-#month(now())#-#day(now())#')>
            </cfif>
        </cfif>
        <cfif isdefined("attributes.date1") and isdate(attributes.date1)>
            <cf_date tarih="attributes.date1">
        <cfelse>
            <cfif session.ep.our_company_info.UNCONDITIONAL_LIST>
                <cfset attributes.date1=''>
            <cfelse>
                <cfset attributes.date1 = date_add('ww',-1,attributes.date2)>
            </cfif>
        </cfif>
        <cfquery name="quality_control_type" datasource="#dsn3#">
            SELECT
                0 SORT_TYPE,
                '' AS RESULT_ID,
                TYPE_ID,
                QUALITY_CONTROL_TYPE
            FROM
                QUALITY_CONTROL_TYPE
            WHERE
                TYPE_ID IN ( SELECT QUALITY_CONTROL_TYPE_ID FROM QUALITY_CONTROL_ROW WHERE QUALITY_CONTROL_TYPE_ID IS NOT NULL) 
        UNION ALL
            SELECT
                1 SORT_TYPE,
                QUALITY_CONTROL_ROW.QUALITY_CONTROL_ROW_ID RESULT_ID,
                QUALITY_CONTROL_ROW.QUALITY_CONTROL_TYPE_ID TYPE_ID,
                QUALITY_CONTROL_ROW.QUALITY_CONTROL_ROW QUALITY_CONTROL_TYPE
            FROM
                QUALITY_CONTROL_ROW,QUALITY_CONTROL_TYPE
            WHERE
                QUALITY_CONTROL_ROW.QUALITY_CONTROL_TYPE_ID = QUALITY_CONTROL_TYPE.TYPE_ID	
        UNION ALL		
            SELECT
                0 SORT_TYPE,
                '' AS RESULT_ID,
                TYPE_ID,
                QUALITY_CONTROL_TYPE
            FROM
                QUALITY_CONTROL_TYPE
            WHERE
                TYPE_ID NOT IN ( SELECT QUALITY_CONTROL_TYPE_ID FROM QUALITY_CONTROL_ROW WHERE QUALITY_CONTROL_TYPE_ID IS NOT NULL) 
            ORDER BY
                TYPE_ID,SORT_TYPE 
        </cfquery>
        
        <cfif isdefined("attributes.is_filtre")>
            <cfquery name="GET_QUALITY_LIST" datasource="#dsn3#">
                SELECT
                    *
                FROM
                (
                    <cfif not Len(attributes.process_cat_id) or ListFind("76,811",attributes.process_cat_id)><!--- Mal Alım İrs. --->
                    SELECT
                        1 BLOCK_TYPE,
                        ORQ.OR_Q_ID,
                        ORQ.SUCCESS_ID,
                        ORQ.Q_CONTROL_NO,
                        ORQ.STAGE,
                        SUM(ISNULL(ORQ.CONTROL_AMOUNT,0)) AS CONTROL_AMOUNT,
                        TABLE1.AMOUNT QUANTITY,
                        '' LOT_NO,
                        TABLE1.STOCK_ID,
                        TABLE1.COMPANY_ID,
                        TABLE1.PARTNER_ID,
                        TABLE1.CONSUMER_ID,
                        TABLE1.LOCATION_IN LOCATION_IN,
                        TABLE1.DEPARTMENT_IN DEPARTMENT_IN,
                        TABLE1.LOCATION LOCATION_OUT,
                        TABLE1.DELIVER_STORE_ID DEPARTMENT_OUT,
                        TABLE1.SHIP_ID PROCESS_ID,
                        TABLE1.SHIP_NUMBER PROCESS_NUMBER,
                        TABLE1.SHIP_DATE PROCESS_DATE,
                        TABLE1.PROCESS_CAT PROCESS_CAT,
                        TABLE1.SHIP_ROW_ID AS PROCESS_ROW_ID,
                        TABLE1.WRK_ROW_ID AS SHIP_WRK_ROW_ID,
                        '' PR_ORDER_ROW_ID,
                        '' PR_ORDER_ID
                    FROM
                        (
                        SELECT
                            SHIP_ROW.STOCK_ID,
                            SHIP_ROW.AMOUNT,
                            SHIP.SHIP_ID,
                            SHIP.SHIP_NUMBER,
                            SHIP.SHIP_DATE,
                            SHIP.COMPANY_ID,
                            SHIP.PARTNER_ID,
                            SHIP.CONSUMER_ID,
                            SHIP.LOCATION_IN LOCATION_IN,
                            SHIP.DEPARTMENT_IN DEPARTMENT_IN,
                            SHIP.LOCATION,
                            SHIP.DELIVER_STORE_ID,
                            SHIP_ROW.SHIP_ROW_ID,
                            SHIP_ROW.WRK_ROW_ID,
                            ISNULL(SHIP.IS_SHIP_IPTAL,0) IS_SHIP_IPTAL,
                            SHIP.SHIP_DATE AS FINISH_DATE,
                            SHIP.SHIP_TYPE PROCESS_CAT
                        FROM
                            #dsn2_alias#.SHIP SHIP,
                            #dsn2_alias#.SHIP_ROW SHIP_ROW
                            LEFT JOIN STOCKS S ON S.STOCK_ID = SHIP_ROW.STOCK_ID
                            LEFT JOIN PRODUCT ON PRODUCT.PRODUCT_ID = S.PRODUCT_ID
                        WHERE
                            S.IS_QUALITY = 1 AND
                            SHIP.SHIP_ID = SHIP_ROW.SHIP_ID AND
                            SHIP.SHIP_STATUS = 1 AND
                            (PRODUCT.QUALITY_START_DATE IS NULL OR SHIP.SHIP_DATE >= PRODUCT.QUALITY_START_DATE)
                            <cfif len(attributes.process_cat_id)>
                                AND SHIP.SHIP_TYPE = #attributes.process_cat_id#
                            <cfelse>
                                AND SHIP.SHIP_TYPE IN (76,811)
                            </cfif>
                            <cfif len(attributes.stock_id) and len(attributes.product_name)>
                                AND SHIP_ROW.STOCK_ID = #attributes.stock_id#
                            </cfif>
                            <cfif isdefined("url.service_id")>
                                AND SHIP_ROW.SERVICE_ID = #url.service_id#
                            </cfif>
                            <cfif isDefined("attributes.process_id") and len(attributes.process_id)>
                                AND SHIP_ROW.SHIP_ID = #attributes.process_id#
                            </cfif>
                            <cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
                                AND SHIP.SHIP_NUMBER = '#attributes.belge_no#'
                            </cfif>
                            <cfif isdate(attributes.date1) and not Len(attributes.process_id)>
                                AND SHIP.SHIP_DATE >= #attributes.date1#
                            </cfif>
                            <cfif isdate(attributes.date2) and not Len(attributes.process_id)>
                                AND SHIP.SHIP_DATE <  #DATEADD("d",1,attributes.date2)#
                            </cfif>
                            <cfif isDefined("attributes.company_id") and len(attributes.company_id) and len(attributes.company)>
                                AND SHIP.COMPANY_ID = #attributes.company_id#
                            <cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.company)>
                                AND SHIP.CONSUMER_ID = #attributes.consumer_id#
                            </cfif>
                            <cfif len(attributes.project_id) and len(attributes.project_head)>
                                AND SHIP.PROJECT_ID = #attributes.project_id#
                            </cfif>
                            <cfif len(attributes.q_serial_no)>
                                AND SHIP.SHIP_ID IN (	SELECT 
                                                            PROCESS_ID
                                                        FROM
                                                            SERVICE_GUARANTY_NEW
                                                        WHERE
                                                            SERVICE_GUARANTY_NEW.PROCESS_CAT IN (<cfif not Len(attributes.process_cat_id)>76,811<cfelse>#attributes.process_cat_id#</cfif>) AND
                                                            SERVICE_GUARANTY_NEW.SERIAL_NO LIKE '%#attributes.q_serial_no#%'
                                                    )
                            </cfif>
                            <cfif len(attributes.department_id)>
                                <cfif listlen(attributes.department_id,'-') eq 1>
                                    AND ( SHIP.DEPARTMENT_IN = #attributes.department_id# OR SHIP.DELIVER_STORE_ID = #attributes.department_id#)
                                <cfelse>
                                    AND 
                                    (
                                        (SHIP.DEPARTMENT_IN = #listfirst(attributes.department_id,'-')# AND SHIP.LOCATION_IN = #listlast(attributes.department_id,'-')#) OR 			
                                        (SHIP.DELIVER_STORE_ID = #listfirst(attributes.department_id,'-')# AND SHIP.LOCATION = #listlast(attributes.department_id,'-')#)
                                    )	
                                </cfif>
                            </cfif>	
                        ) TABLE1
                        LEFT JOIN ORDER_RESULT_QUALITY ORQ ON ORQ.PROCESS_ID = TABLE1.SHIP_ID AND ORQ.SHIP_WRK_ROW_ID = TABLE1.WRK_ROW_ID AND ORQ.PROCESS_CAT IN (<cfif not Len(attributes.process_cat_id)>76,811<cfelse>#attributes.process_cat_id#</cfif>) AND ORQ.SHIP_PERIOD_ID = #session.ep.period_id#<!--- Sadece Mal Alımdan oluşanlar --->
                    WHERE
                        (	(TABLE1.IS_SHIP_IPTAL = 1 AND ORQ.SHIP_WRK_ROW_ID IS NOT NULL) OR TABLE1.IS_SHIP_IPTAL = 0	) <!--- Iptalse gelmesin ama islem yapmis olanlar gelsin --->
                        <cfif isDefined("attributes.no_result_quality")><!--- Sonuc Girilmemisler --->
                            AND ORQ.OR_Q_ID IS NULL
                        </cfif>
                        <cfif Len(attributes.process_stage)>
                            AND ORQ.STAGE = #get_process_stage.process_row_id#		
                        </cfif>
                        <cfif len(attributes.quality_type)>
                            AND OR_Q_ID IN (SELECT OR_Q_ID FROM ORDER_RESULT_QUALITY_ROW WHERE CONTROL_ROW_ID = #listfirst(attributes.quality_type,'-')#)
                        </cfif>
                        <cfif len(attributes.employee_id) and len(attributes.employee)>
                            AND ORQ.RECORD_EMP = #attributes.employee_id#
                        </cfif>
                        <cfif Len(attributes.q_control_no)>
                            AND ORQ.Q_CONTROL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.q_control_no#%">
                        </cfif>
                        <cfif len(attributes.related_success_id)>
                            AND ORQ.SUCCESS_ID = #attributes.related_success_id#
                        </cfif>
                        <cfif len(attributes.controller_emp_id) and len(attributes.controller_emp)>
                            AND ORQ.CONTROLLER_EMP_ID = #attributes.controller_emp_id#
                        </cfif>
                    GROUP BY
                        ORQ.SUCCESS_ID,
                        ORQ.OR_Q_ID,
                        ORQ.Q_CONTROL_NO,
                        ORQ.STAGE,
                        TABLE1.STOCK_ID,
                        TABLE1.AMOUNT,
                        TABLE1.COMPANY_ID,
                        TABLE1.PARTNER_ID,
                        TABLE1.CONSUMER_ID,
                        TABLE1.LOCATION_IN,
                        TABLE1.DEPARTMENT_IN,
                        TABLE1.LOCATION,
                        TABLE1.DELIVER_STORE_ID,
                        TABLE1.SHIP_ID,
                        TABLE1.SHIP_NUMBER,
                        TABLE1.SHIP_DATE,
                        TABLE1.PROCESS_CAT,
                        TABLE1.SHIP_ROW_ID,
                        TABLE1.WRK_ROW_ID
                    </cfif>
                    <cfif not Len(attributes.process_cat_id)>
                        UNION ALL
                    </cfif>
                    <cfif not Len(attributes.process_cat_id) or attributes.process_cat_id eq 171>
                    SELECT
                        3 BLOCK_TYPE, 
                        ORQ.OR_Q_ID,
                        ORQ.SUCCESS_ID,
                        ORQ.Q_CONTROL_NO,
                        ORQ.STAGE,
                        SUM(ISNULL(ORQ.CONTROL_AMOUNT,0)) AS CONTROL_AMOUNT,
                        TABLE1.AMOUNT QUANTITY,
                        TABLE1.LOT_NO,
                        TABLE1.STOCK_ID,
                        '' COMPANY_ID,
                        '' PARTNER_ID,
                        '' CONSUMER_ID,
                        TABLE1.LOCATION_IN,
                        TABLE1.DEPARTMENT_IN,
                        TABLE1.LOCATION_OUT,
                        TABLE1.DEPARTMENT_OUT,
                        TABLE1.P_ORDER_ID PROCESS_ID,
                        TABLE1.RESULT_NO PROCESS_NUMBER,
                        TABLE1.FINISH_DATE PROCESS_DATE,
                        171 PROCESS_CAT,
                        TABLE1.PR_ORDER_ROW_ID AS PROCESS_ROW_ID,
                        TABLE1.WRK_ROW_ID SHIP_WRK_ROW_ID,
                        TABLE1.PR_ORDER_ROW_ID PR_ORDER_ROW_ID,
                        TABLE1.PR_ORDER_ID AS PR_ORDER_ID
                    FROM
                        (
                        SELECT
                            PORR.STOCK_ID,
                            POR.P_ORDER_ID,
                            POR.PR_ORDER_ID,
                            PR_ORDER_ROW_ID,
                            RESULT_NO,
                            POR.FINISH_DATE,
                            PORR.AMOUNT,
                            POR.LOT_NO,
                            POR.ENTER_LOC_ID LOCATION_IN,
                            POR.ENTER_DEP_ID DEPARTMENT_IN,
                            POR.EXIT_LOC_ID LOCATION_OUT,
                            POR.EXIT_DEP_ID DEPARTMENT_OUT,
                            PORR.WRK_ROW_ID
                        FROM
                            PRODUCTION_ORDER_RESULTS POR,
                            PRODUCTION_ORDER_RESULTS_ROW PORR
                            LEFT JOIN STOCKS S ON S.STOCK_ID = PORR.STOCK_ID
                            LEFT JOIN PRODUCT ON PRODUCT.PRODUCT_ID = S.PRODUCT_ID
                        WHERE
                            S.IS_QUALITY = 1 AND
                            PORR.TYPE = 1
                            AND PORR.PR_ORDER_ID = POR.PR_ORDER_ID
                            AND POR.P_ORDER_ID NOT IN(SELECT P_ORDER_ID FROM PRODUCTION_ORDERS PO WHERE PO.IS_DEMONTAJ = 1)
                            AND (PRODUCT.QUALITY_START_DATE IS NULL OR PRODUCT.QUALITY_START_DATE <= POR.FINISH_DATE)
                            <cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
                                AND POR.RESULT_NO = '#attributes.belge_no#'
                            </cfif>
                            <cfif isDefined("attributes.process_id") and len(attributes.process_id)>
                                AND PO.PR_ORDER_ID = #attributes.process_id#
                            </cfif>
                            <cfif len(attributes.stock_id) and len(attributes.product_name)>
                                AND PORR.STOCK_ID = #attributes.stock_id#
                            </cfif>
                            <cfif isdate(attributes.date1) and not len(attributes.process_id)>
                                AND POR.START_DATE >= #attributes.date1#
                            </cfif>
                            <cfif isdate(attributes.date2) and not len(attributes.process_id)>
                                AND POR.START_DATE <  #DATEADD("d",1,attributes.date2)#
                            </cfif>
                            <cfif len(attributes.project_id) and len(attributes.project_head)>
                                AND POR.P_ORDER_ID IN 	(	SELECT 
                                                                P_ORDER_ID 
                                                            FROM 
                                                                PRODUCTION_ORDERS PO 
                                                            WHERE 
                                                                PO.P_ORDER_ID = POR.P_ORDER_ID AND
                                                                PO.PROJECT_ID =	#attributes.project_id#
                                                        )
                            </cfif>
                            <cfif len(attributes.q_serial_no)>
                                AND POR.PR_ORDER_ID IN 	(	SELECT 
                                                                PROCESS_ID
                                                            FROM
                                                                SERVICE_GUARANTY_NEW
                                                            WHERE
                                                                SERVICE_GUARANTY_NEW.PROCESS_CAT IN (<cfif not Len(attributes.process_cat_id)>171<cfelse>#attributes.process_cat_id#</cfif>) AND
                                                                SERVICE_GUARANTY_NEW.SERIAL_NO LIKE '%#attributes.q_serial_no#%'
                                                        )
                            </cfif>
                            <cfif len(attributes.department_id)>
                                <cfif listlen(attributes.department_id,'-') eq 1>
                                    AND ( POR.ENTER_DEP_ID = #attributes.department_id# OR POR.EXIT_DEP_ID = #attributes.department_id# )
                                <cfelse>
                                    AND 
                                    (
                                        (POR.ENTER_DEP_ID = #listfirst(attributes.department_id,'-')# AND POR.ENTER_LOC_ID = #listlast(attributes.department_id,'-')#) OR 			
                                        (POR.EXIT_DEP_ID = #listfirst(attributes.department_id,'-')# AND POR.EXIT_LOC_ID = #listlast(attributes.department_id,'-')#)
                                    )	
                                </cfif>
                            </cfif>			  
                        ) TABLE1
                        LEFT JOIN ORDER_RESULT_QUALITY ORQ ON ORQ.PROCESS_ID = TABLE1.P_ORDER_ID AND ORQ.SHIP_WRK_ROW_ID = TABLE1.WRK_ROW_ID AND ORQ.PROCESS_CAT = 171<!--- Sadece Üretimden oluşanlar --->
                    WHERE
                        1 = 1
                        AND ORQ.OR_Q_ID NOT IN (SELECT OR_Q_ID FROM ORDER_RESULT_QUALITY_ROW ORQR WHERE ORQR.OR_Q_ID = ORQ.OR_Q_ID AND IS_REPROCESS = 1) <!--- Yeniden Islemler Dikkate Alinmiyor --->
                        <cfif isDefined("attributes.no_result_quality")><!--- Sonuc Girilmemisler --->
                            AND ORQ.OR_Q_ID IS NULL
                        </cfif>
                        <cfif Len(attributes.process_stage)>
                            AND ORQ.STAGE = #get_process_stage.process_row_id#		
                        </cfif>
                        <cfif len(attributes.quality_type)>
                            AND ORQ.OR_Q_ID IN (SELECT OR_Q_ID FROM ORDER_RESULT_QUALITY_ROW WHERE CONTROL_ROW_ID = #listfirst(attributes.quality_type,'-')#)
                        </cfif>
                        <cfif len(attributes.employee_id) and len(attributes.employee)>
                            AND ORQ.RECORD_EMP = #attributes.employee_id#
                        </cfif>
                        <cfif len(attributes.q_control_no)>
                            AND ORQ.Q_CONTROL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.q_control_no#%">
                        </cfif>
                        <cfif len(attributes.related_success_id)>
                            AND ORQ.SUCCESS_ID = #attributes.related_success_id#
                        </cfif>
                        <cfif len(attributes.controller_emp_id) and len(attributes.controller_emp)>
                            AND ORQ.CONTROLLER_EMP_ID = #attributes.controller_emp_id#
                        </cfif>
                    GROUP BY
                        ORQ.SUCCESS_ID,
                        ORQ.OR_Q_ID,
                        ORQ.Q_CONTROL_NO,
                        ORQ.STAGE,
                        TABLE1.AMOUNT,
                        TABLE1.STOCK_ID,
                        TABLE1.P_ORDER_ID,
                        TABLE1.PR_ORDER_ID,
                        TABLE1.PR_ORDER_ROW_ID,
                        TABLE1.WRK_ROW_ID,
                        TABLE1.RESULT_NO,
                        TABLE1.FINISH_DATE,
                        TABLE1.LOCATION_IN,
                        TABLE1.DEPARTMENT_IN,
                        TABLE1.LOCATION_OUT,
                        TABLE1.DEPARTMENT_OUT,
                        TABLE1.LOT_NO
                    </cfif>
                    <cfif not Len(attributes.process_cat_id)>
                        UNION ALL
                    </cfif>
                    <cfif not Len(attributes.process_cat_id) or attributes.process_cat_id eq -1>
                        SELECT
                            2 BLOCK_TYPE, 
                            ORQ.OR_Q_ID,
                            ORQ.SUCCESS_ID,
                            ORQ.Q_CONTROL_NO,
                            ORQ.STAGE,
                            SUM(ISNULL(ORQ.CONTROL_AMOUNT,0)) AS CONTROL_AMOUNT,
                            TABLE1.AMOUNT QUANTITY,
                            '' LOT_NO,
                            TABLE1.STOCK_ID,
                            '' COMPANY_ID,
                            '' PARTNER_ID,
                            '' CONSUMER_ID,
                            TABLE1.LOCATION_IN,
                            TABLE1.DEPARTMENT_IN,
                            TABLE1.LOCATION_OUT,
                            TABLE1.DEPARTMENT_OUT,
                            TABLE1.P_ORDER_ID AS PROCESS_ID,
                            TABLE1.RESULT_NO AS PROCESS_NUMBER,
                            TABLE1.FINISH_DATE AS PROCESS_DATE,
                            -1 PROCESS_CAT,
                            TABLE1.PR_ORDER_ROW_ID AS PROCESS_ROW_ID,
                            '' SHIP_WRK_ROW_ID,
                            TABLE1.PR_ORDER_ROW_ID PR_ORDER_ROW_ID,
                            '' PR_ORDER_ID
                        FROM
                            (
                            SELECT
                                POS.STOCK_ID,
                                POS.P_ORDER_ID,
                                '' PROCESS_ID,
                                '' PR_ORDER_ID,
                                PO.P_OPERATION_ID PR_ORDER_ROW_ID,
                                POS.P_ORDER_NO RESULT_NO,
                                POS.FINISH_DATE,
                                PO.AMOUNT,
                                '' LOCATION_IN,
                                '' DEPARTMENT_IN,
                                '' LOCATION_OUT,
                                '' DEPARTMENT_OUT
                            FROM
                                PRODUCTION_OPERATION_RESULT POR,
                                PRODUCTION_OPERATION PO,
                                PRODUCTION_ORDERS POS
                                    LEFT JOIN STOCKS S ON S.STOCK_ID = POS.STOCK_ID
                                    LEFT JOIN PRODUCT ON PRODUCT.PRODUCT_ID = S.PRODUCT_ID
                            WHERE
                                S.IS_QUALITY = 1 AND
                                POR.P_ORDER_ID = POS.P_ORDER_ID AND
                                PO.P_OPERATION_ID = POR.OPERATION_ID AND
                                (PRODUCT.QUALITY_START_DATE IS NULL OR PRODUCT.QUALITY_START_DATE <= POS.FINISH_DATE)
                                <cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
                                    AND POS.P_ORDER_NO = '#attributes.belge_no#'
                                </cfif>
                                <cfif isDefined("attributes.process_id") and len(attributes.process_id)>
                                    AND POS.P_ORDER_ID = #attributes.process_id#
                                </cfif>
                                <cfif len(attributes.stock_id) and len(attributes.product_name)>
                                    AND POS.STOCK_ID = #attributes.stock_id#
                                </cfif>
                                <cfif isdate(attributes.date1) and not len(attributes.process_id)>
                                    AND POS.START_DATE >= #attributes.date1#
                                </cfif>
                                <cfif isdate(attributes.date2) and not len(attributes.process_id)>
                                    AND POS.START_DATE <  #DATEADD("d",1,attributes.date2)#
                                </cfif>
                                <cfif len(attributes.project_id) and len(attributes.project_head)>
                                    AND POS.P_ORDER_ID IN 	(	SELECT 
                                                                    P_ORDER_ID 
                                                                FROM 
                                                                    PRODUCTION_ORDERS PO 
                                                                WHERE 
                                                                    PO.P_ORDER_ID = POS.P_ORDER_ID AND
                                                                    PO.PROJECT_ID =	#attributes.project_id#
                                                            )
                                </cfif>
                            ) TABLE1
                                LEFT JOIN ORDER_RESULT_QUALITY ORQ ON ORQ.PROCESS_ID = TABLE1.P_ORDER_ID AND ORQ.PROCESS_ROW_ID = TABLE1.PR_ORDER_ROW_ID AND ORQ.PROCESS_CAT = -1<!--- Sadece Üretimden oluşanlar --->
                        WHERE
                            1 = 1
                            <cfif isDefined("attributes.no_result_quality")><!--- Sonuc Girilmemisler --->
                                AND ORQ.OR_Q_ID IS NULL
                            </cfif>
                            <cfif Len(attributes.process_stage)>
                                AND ORQ.STAGE = #get_process_stage.process_row_id#		
                            </cfif>
                            <cfif len(attributes.quality_type)>
                                AND ORQ.OR_Q_ID IN (SELECT OR_Q_ID FROM ORDER_RESULT_QUALITY_ROW WHERE CONTROL_ROW_ID = #listfirst(attributes.quality_type,'-')#)
                            </cfif>
                            <cfif len(attributes.employee_id) and len(attributes.employee)>
                                AND ORQ.RECORD_EMP = #attributes.employee_id#
                            </cfif>
                            <cfif len(attributes.q_control_no)>
                                AND ORQ.Q_CONTROL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.q_control_no#%">
                            </cfif>
                            <cfif len(attributes.related_success_id)>
                                AND ORQ.SUCCESS_ID = #attributes.related_success_id#
                            </cfif>
                            <cfif len(attributes.controller_emp_id) and len(attributes.controller_emp)>
                                AND ORQ.CONTROLLER_EMP_ID = #attributes.controller_emp_id#
                            </cfif>
                        GROUP BY
                            ORQ.SUCCESS_ID,
                            ORQ.OR_Q_ID,
                            ORQ.Q_CONTROL_NO,
                            ORQ.STAGE,
                            TABLE1.AMOUNT,
                            TABLE1.STOCK_ID,
                            TABLE1.PROCESS_ID,
                            TABLE1.P_ORDER_ID,
                            TABLE1.PR_ORDER_ID,
                            TABLE1.PR_ORDER_ROW_ID,
                            TABLE1.RESULT_NO,
                            TABLE1.FINISH_DATE,
                            TABLE1.LOCATION_IN,
                            TABLE1.DEPARTMENT_IN,
                            TABLE1.LOCATION_OUT,
                            TABLE1.DEPARTMENT_OUT
                    </cfif>
                    <cfif not Len(attributes.process_cat_id)>
                        UNION ALL
                    </cfif>
                    <cfif not Len(attributes.process_cat_id) or attributes.process_cat_id eq -2>
                    SELECT
                        2 BLOCK_TYPE, 
                        ORQ.OR_Q_ID,
                        ORQ.SUCCESS_ID,
                        ORQ.Q_CONTROL_NO,
                        ORQ.STAGE,
                        SUM(ISNULL(ORQ.CONTROL_AMOUNT,0)) AS CONTROL_AMOUNT,
                        '' QUANTITY,
                        '' LOT_NO,
                        TABLE1.STOCK_ID,
                        '' COMPANY_ID,
                        '' PARTNER_ID,
                        '' CONSUMER_ID,
                        TABLE1.LOCATION_IN,
                        TABLE1.DEPARTMENT_IN,
                        TABLE1.LOCATION_OUT,
                        TABLE1.DEPARTMENT_OUT,
                        TABLE1.SERVICE_ID AS PROCESS_ID,
                        TABLE1.RESULT_NO AS PROCESS_NUMBER,
                        TABLE1.APPLY_DATE AS PROCESS_DATE,
                        -2 PROCESS_CAT,
                        TABLE1.SERVICE_ID AS PROCESS_ROW_ID,
                        '' SHIP_WRK_ROW_ID,
                        '' PR_ORDER_ROW_ID,
                        '' AS PR_ORDER_ID
                    FROM
                        (
                        SELECT
                            SERVICE.STOCK_ID,
                            SERVICE.SERVICE_ID,
                            SERVICE.PRODUCT_NAME,
                            SERVICE.SERVICE_HEAD RESULT_NO,
                            SERVICE.APPLY_DATE,
                            '' PROCESS_ID,
                            '' PR_ORDER_ID,
                            '' LOCATION_IN,
                            '' DEPARTMENT_IN,
                            '' LOCATION_OUT,
                            '' DEPARTMENT_OUT
                        FROM 
                            SERVICE 
                            LEFT JOIN PRODUCT ON SERVICE.SERVICE_PRODUCT_ID = PRODUCT.PRODUCT_ID
                        WHERE
                            SERVICE.SERVICE_ACTIVE = 1 AND
                            (PRODUCT.QUALITY_START_DATE IS NULL OR PRODUCT.QUALITY_START_DATE <= SERVICE.APPLY_DATE) AND
                            <cfif isDefined("attributes.belge_no") and len(attributes.belge_no)>
                                SERVICE.SERVICE_NO = '#attributes.belge_no#' AND
                            </cfif>
                            <cfif len(attributes.stock_id) and len(attributes.product_name)>
                                SERVICE.STOCK_ID = #attributes.stock_id# AND
                            </cfif>
                            SERVICE.STOCK_ID IS NOT NULL
                        )TABLE1
                            LEFT JOIN ORDER_RESULT_QUALITY ORQ ON ORQ.PROCESS_ID = TABLE1.SERVICE_ID AND ORQ.PROCESS_CAT = -2<!--- Sadece Üretimden oluşanlar --->
                        WHERE
                            1 = 1
                            <cfif isDefined("attributes.no_result_quality")><!--- Sonuc Girilmemisler --->
                                AND ORQ.OR_Q_ID IS NULL
                            </cfif>
                            <cfif Len(attributes.process_stage)>
                                AND ORQ.STAGE = #get_process_stage.process_row_id#	
                            </cfif>
                            <cfif len(attributes.quality_type)>
                                AND ORQ.OR_Q_ID IN (SELECT OR_Q_ID FROM ORDER_RESULT_QUALITY_ROW WHERE CONTROL_ROW_ID = #listfirst(attributes.quality_type,'-')#)
                            </cfif>
                            <cfif len(attributes.employee_id) and len(attributes.employee)>
                                AND ORQ.RECORD_EMP = #attributes.employee_id#
                            </cfif>
                            <cfif len(attributes.q_control_no)>
                                AND ORQ.Q_CONTROL_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.q_control_no#%">
                            </cfif>
                            <cfif len(attributes.related_success_id)>
                                AND ORQ.SUCCESS_ID = #attributes.related_success_id#
                            </cfif>
                            <cfif len(attributes.controller_emp_id) and len(attributes.controller_emp)>
                                AND ORQ.CONTROLLER_EMP_ID = #attributes.controller_emp_id#
                            </cfif>
                        GROUP BY
                            ORQ.SUCCESS_ID,
                            ORQ.OR_Q_ID,
                            ORQ.Q_CONTROL_NO,
                            ORQ.STAGE,
                            TABLE1.STOCK_ID,
                            TABLE1.PROCESS_ID,
                            TABLE1.SERVICE_ID,
                            TABLE1.PR_ORDER_ID,
                            TABLE1.RESULT_NO,
                            TABLE1.APPLY_DATE,
                            TABLE1.LOCATION_IN,
                            TABLE1.DEPARTMENT_IN,
                            TABLE1.LOCATION_OUT,
                            TABLE1.DEPARTMENT_OUT 
                    </cfif>
                ) AS NEW_TABLE
                
                ORDER BY
                    <cfif attributes.sort_type eq 6>
                        (SELECT QS.SUCCESS FROM QUALITY_SUCCESS QS WHERE QS.SUCCESS_ID = NEW_TABLE.SUCCESS_ID) DESC,
                    <cfelseif attributes.sort_type eq 5>
                        (SELECT QS.SUCCESS FROM QUALITY_SUCCESS QS WHERE QS.SUCCESS_ID = NEW_TABLE.SUCCESS_ID),
                    <cfelseif attributes.sort_type eq 4>
                        Q_CONTROL_NO DESC,
                    <cfelseif attributes.sort_type eq 3>
                        Q_CONTROL_NO,
                    <cfelseif attributes.sort_type eq 2 and ListFind("171,-1",attributes.process_cat_id)>
                        NEW_TABLE.LOT_NO DESC,
                    <cfelseif attributes.sort_type eq 1 and ListFind("171,-1",attributes.process_cat_id)>
                        NEW_TABLE.LOT_NO,
                    </cfif>
                    <cfif ListFind("76,811",attributes.process_cat_id)>
                        NEW_TABLE.PROCESS_ROW_ID DESC,
                        <cfif not ListFind("3,4",attributes.sort_type)>
                            NEW_TABLE.Q_CONTROL_NO,
                        </cfif>
                    <cfelseif attributes.process_cat_id eq 171>
                        NEW_TABLE.PR_ORDER_ROW_ID DESC,
                    <cfelseif attributes.process_cat_id eq -1>
                        NEW_TABLE.PR_ORDER_ROW_ID DESC,
                    </cfif>
                    PROCESS_DATE DESC,
                    SUCCESS_ID
            </cfquery>
        <cfelse>
            <cfset GET_QUALITY_LIST.recordcount = 0>
        </cfif>
    <cfset adres="&is_filtre=1">
	<cfif len(attributes.process_cat_id)>
		<cfset adres = "#adres#&process_cat_id=#attributes.process_cat_id#">
	</cfif>
	<cfif isdefined("attributes.belge_no") and len(attributes.belge_no)>
		<cfset adres = "#adres#&belge_no=#attributes.belge_no#">
	</cfif>
	<cfif isdefined("attributes.sort_type") and len(attributes.sort_type)>
		<cfset adres = "#adres#&sort_type=#attributes.sort_type#">
	</cfif>
	<cfif isdefined("attributes.date1") and isdate(attributes.date1)>
		<cfset adres = "#adres#&date1=#dateformat(attributes.date1,'dd/mm/yyyy')#">
	</cfif>
	<cfif isdefined("attributes.date2") and isdate(attributes.date2)>
		<cfset adres = "#adres#&date2=#dateformat(attributes.date2,'dd/mm/yyyy')#">
	</cfif>
	<cfif isdefined("attributes.company_id") and len(attributes.company_id) and isdefined("attributes.company") and len(attributes.company)>
		<cfset adres = "#adres#&company_id=#attributes.company_id#&company=#attributes.company#">
	<cfelseif isdefined("attributes.consumer_id") and len(attributes.consumer_id) and isdefined("attributes.company") and len(attributes.company)>
		<cfset adres = "#adres#&consumer_id=#attributes.consumer_id#&company=#attributes.company#">
	</cfif>
	<cfif isdefined("attributes.employee_id") and len(attributes.employee_id) and len(attributes.employee)>
		<cfset adres = "#adres#&employee_id=#attributes.employee_id#&employee=#attributes.employee#">
	</cfif>
	<cfif isdefined("attributes.stock_id") and len(attributes.stock_id) and isdefined("attributes.product_name") AND len(attributes.product_name)>
		<cfset adres = "#adres#&stock_id=#attributes.stock_id#&product_name=#attributes.product_name#">
	</cfif>
	<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
		<cfset adres = "#adres#&department_id=#attributes.department_id#">
	</cfif>
	<cfif isdefined("attributes.controller_emp_id") and len(attributes.controller_emp_id) and isdefined("attributes.controller_emp") and len(attributes.controller_emp)>
		<cfset adres = "#adres#&controller_emp_id=#attributes.controller_emp_id#&controller_emp=#attributes.controller_emp#">
	</cfif>
	<cfif isDefined("attributes.no_result_quality")><cfset adres = "#adres#&no_result_quality=#attributes.no_result_quality#"></cfif>
	<cfif isdefined("attributes.process_stage") and Len(attributes.process_stage)>
	<cfset adres = "#adres#&process_stage=#attributes.process_stage#"></cfif>
    <cfif isdefined("attributes.related_success_id") and Len(attributes.related_success_id)>
	<cfset adres = "#adres#&related_success_id=#attributes.related_success_id#">
    </cfif>
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfparam name="attributes.totalrecords" default="#GET_QUALITY_LIST.recordCount#">
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
		SELECT 
			D.DEPARTMENT_HEAD,
			SL.DEPARTMENT_ID,
			SL.LOCATION_ID,
			SL.STATUS,
			SL.COMMENT
		FROM 
			STOCKS_LOCATION SL,
			DEPARTMENT D,
			BRANCH B
		WHERE
			D.IS_STORE <> 2 AND
			SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
			D.DEPARTMENT_STATUS = 1 AND
			D.BRANCH_ID = B.BRANCH_ID AND
			B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			<cfif fusebox.circuit is "store">
				AND B.BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#
			</cfif>
			<cfif isDefined("get_offer_detail.deliver_place") and len(get_offer_detail.deliver_place)>
				AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_offer_detail.deliver_place#">

			</cfif>
			<cfif isDefined("get_order_detail.ship_address") and len(get_order_detail.ship_address) and isnumeric(get_order_detail.ship_address)>
				AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_detail.ship_address#">
			</cfif>
		ORDER BY
			D.DEPARTMENT_HEAD,
			COMMENT
	</cfquery>
    <cfif GET_QUALITY_LIST.recordcount>
    	<cfset quality_stage_list = "">
			<cfset stock_list = ''>
			<cfset main_stock_list = ''>
			<cfset dept_id_list = ''>
			<cfset main_dept_id_list = ''>
			<cfset main_succes_id_list = listdeleteduplicates(ValueList(GET_QUALITY_LIST.SUCCESS_ID,','))>
			<cfoutput query="GET_QUALITY_LIST" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfset stock_list = listappend(stock_list,GET_QUALITY_LIST.stock_id,',')>
				<cfif isdefined("block_type") and  block_type neq 3>
					<cfset dept_= department_in>
					<cfset dept2_= department_out>
				<cfelse>
					<cfset dept_= listfirst(department_in,'-')>
					<cfset dept2_= listfirst(department_out,'-')>
				</cfif>
				<cfif len(dept_) and not listfind(dept_id_list,dept_)>
					<cfset dept_id_list=listappend(dept_id_list,dept_)>
				</cfif>
				<cfif len(dept2_) and  not listfind(dept_id_list,dept2_)>
					<cfset dept_id_list=listappend(dept_id_list,dept2_)>
				</cfif>
				<cfif Len(stage) and not ListFind(quality_stage_list,stage)>
					<cfset quality_stage_list = ListAppend(quality_stage_list,stage,",")>
				</cfif>
			</cfoutput>
			<cfset stock_list=listsort(stock_list,"numeric","ASC",",")>
			<cfquery name="GET_STOCK_INFO" datasource="#DSN3#">
				SELECT
					PRODUCT.PRODUCT_NAME,
					STOCKS.STOCK_CODE,
					STOCKS.BARCOD,
					STOCKS.STOCK_ID,
					PRODUCT.MANUFACT_CODE
				FROM
					PRODUCT,
					STOCKS 
				WHERE 
					STOCKS.PRODUCT_ID = PRODUCT.PRODUCT_ID AND
					STOCKS.STOCK_ID IN (#stock_list#)
				ORDER BY
					STOCKS.STOCK_ID
			</cfquery>
			<cfset main_stock_list = listsort(listdeleteduplicates(valuelist(get_stock_info.stock_id,',')),'numeric','ASC',',')>
			<cfif listlen(dept_id_list)>
				<cfset dept_id_list = listsort(dept_id_list,"numeric","ASC",",")>
				<cfquery name="GET_DEP_DETAIL" datasource="#DSN#" >
					SELECT DEPARTMENT_ID, DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID IN (#dept_id_list#) ORDER BY DEPARTMENT_ID
				</cfquery> 
				<cfset main_dept_id_list = listsort(listdeleteduplicates(valuelist(get_dep_detail.department_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif ListLen(quality_stage_list)>
				<cfquery name="get_quality_stage" datasource="#dsn#">
					SELECT PROCESS_ROW_ID,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#quality_stage_list#) ORDER BY PROCESS_ROW_ID
				</cfquery>
				<cfset quality_stage_list = ListSort(ListDeleteDuplicates(ValueList(get_quality_stage.process_row_id,',')),'numeric','ASC',',')>
			</cfif>           
    </cfif>
</cfif>
<cfelseif attributes.event is 'add'>
	<!--- Sayfa Kalite Konrol Yapmak için kullanılıyor,birçok yerden çağırılıyor,ama genel olarak 2 şekilde geliyor
	1.Üretim Sonuç'dan Kalite Kontrol(171) ve Mal Alım İrsaliyesinden(76).Bu gelen PROCESS_CAT'lara görede sayfayı şekillendiriyoruz..--->
	
	<!--- Belge No, Uretim ise Uretime Gore Ayri Gelir, Uretimin Kontrol No Bos ise Digeri Gelmeye Devam Eder --->
	<cfif attributes.process_cat eq 171><cfset paper_type_ = "PRODUCTION_QUALITY_CONTROL"><cf_papers paper_type="production_quality_control"></cfif>
	<cfif not isDefined("paper_number") or not Len(paper_number)><cfset paper_type_ = "QUALITY_CONTROL"><cf_papers paper_type="quality_control"></cfif>
	<!--- //Belge No, Uretim ise Uretime Gore Ayri Gelir, Uretimin Kontrol No Bos ise Digeri Gelmeye Devam Eder --->
	<cfparam name="attributes.brand_id" default="">
	<cfparam name="attributes.short_code_id" default="">
	<cfparam name="attributes.controller_emp_id" default="#session.ep.userid#">
	<cfparam name="attributes.controller_emp" default="#get_emp_info(session.ep.userid,0,0)#">
	<cfif not isdefined("attributes.ship_wrk_row_id")><cfset attributes.ship_wrk_row_id = ''></cfif>
    <cfquery name="get_order_no" datasource="#dsn3#">
        <cfif attributes.process_cat eq 171><!--- Üretim Sonucu --->
            SELECT
                ISNULL((SELECT AMOUNT FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = POR.PR_ORDER_ID AND TYPE=1 AND WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_wrk_row_id#">),0) AS QUANTITY, <!--- SADECE ANA ÜRÜN İÇİN ÜRETİM MİKTARI --->
                PO.P_ORDER_NO,
                POR.RESULT_NO,
                0 AS COMPANY_ID
            FROM 
                PRODUCTION_ORDERS PO,
                PRODUCTION_ORDER_RESULTS POR
            WHERE
                POR.P_ORDER_ID = PO.P_ORDER_ID AND
                POR.PR_ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pr_order_id#">
        <cfelseif attributes.process_cat eq 76 or attributes.process_cat eq 811><!--- Mal Alım İrsaliyesi,İthal Mal Girişi --->
            SELECT 
                SR.AMOUNT AS QUANTITY,
                S.SHIP_NUMBER AS P_ORDER_NO,
                S.SHIP_NUMBER AS RESULT_NO,
                ISNULL(S.COMPANY_ID,0) AS COMPANY_ID 
            FROM 
                #dsn2_alias#.SHIP S,
                #dsn2_alias#.SHIP_ROW SR
            WHERE 
                S.SHIP_ID = SR.SHIP_ID AND 
                S.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND 
                SR.SHIP_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#"> AND
                S.SHIP_TYPE IN(76,811)
        <cfelseif attributes.process_cat eq -1><!--- Operasyonlar --->
            SELECT
                ISNULL(PO.AMOUNT,0) AS QUANTITY,
                POS.P_ORDER_NO,
                POS.P_ORDER_NO AS RESULT_NO ,
                0 AS COMPANY_ID
            FROM
                PRODUCTION_OPERATION_RESULT POR,
                PRODUCTION_OPERATION PO,
                PRODUCTION_ORDERS POS
            WHERE
                POR.P_ORDER_ID = POS.P_ORDER_ID AND
                PO.P_OPERATION_ID = POR.OPERATION_ID AND
                POR.OPERATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">
        <cfelseif attributes.process_cat eq -2><!--- Servis --->
            SELECT
                1 QUANTITY,
                SERVICE_HEAD P_ORDER_NO,
                SERVICE_HEAD  AS RESULT_NO,
                0 AS COMPANY_ID
            FROM 
                SERVICE
            WHERE	
                SERVICE.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">
        </cfif>
    </cfquery>
    <cfquery name="get_quality_list" datasource="#dsn3#">
        SELECT
            ISNULL(SUM(CONTROL_AMOUNT),0) CONTROL_AMOUNT
        FROM 
            ORDER_RESULT_QUALITY ORQ 
        WHERE
            IS_REPROCESS = 0 AND
            PROCESS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_id#"> AND
            (
                (PROCESS_CAT IN(76,811,171) AND SHIP_WRK_ROW_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ship_wrk_row_id#">) OR
                (PROCESS_CAT NOT IN(76,811,171) AND PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_row_id#">)
            )
    </cfquery>
    <cfif len(attributes.stock_id)>
		<cfquery name="get_product_info" datasource="#dsn3#">
			SELECT PRODUCT_ID,PRODUCT_NAME,STOCK_CODE,PRODUCT_CATID FROM STOCKS WHERE STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
		</cfquery>
	</cfif>
	<cfparam name="process_cat" default="#attributes.process_cat#">
	<cfquery name="get_quality_type" datasource="#dsn3#">
		SELECT 
			CCT.QUALITY_CONTROL_TYPE,
			CCT.TYPE_ID,
			CCT.QUALITY_MEASURE,
			CCT.TYPE_DESCRIPTION,
			CCT.STANDART_VALUE,
			PQ.*
		FROM
			QUALITY_CONTROL_TYPE CCT,
			PRODUCT_QUALITY PQ
		WHERE 
			PQ.QUALITY_TYPE_ID = CCT.TYPE_ID AND
			<cfif isdefined("get_product_info.product_id") and len(get_product_info.product_id)>
				PQ.PRODUCT_ID IS NOT NULL AND
				PQ.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_info.product_id#"> AND
			<cfelse>
				1 = 0 AND	
			</cfif>
			PQ.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_cat#">
			<cfif isdefined("attributes.operation_type_id") and len(attributes.operation_type_id)>
				AND OPERATION_TYPE_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#operation_type_id#%">
			</cfif>
		ORDER BY
			PQ.PRODUCT_ID,
			PQ.PRODUCT_CAT_ID,
			PQ.ORDER_NO,
			PQ.QUALITY_TYPE_ID
	</cfquery>
	<cfif not get_quality_type.recordcount><!--- Urunde Yoksa Kategoriye Bakilir --->
		<cfquery name="get_quality_type" datasource="#dsn3#">
			SELECT 
				CCT.QUALITY_CONTROL_TYPE,
				CCT.TYPE_ID,
				CCT.QUALITY_MEASURE,
				CCT.TYPE_DESCRIPTION,
				CCT.STANDART_VALUE,
				PQ.*
			FROM
				QUALITY_CONTROL_TYPE CCT,
				PRODUCT_QUALITY PQ
			WHERE 
				PQ.QUALITY_TYPE_ID = CCT.TYPE_ID AND
				<cfif isdefined("get_product_info.product_id") and len(get_product_info.product_id)>
					PQ.PRODUCT_CAT_ID IS  NOT NULL AND PQ.PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_info.product_catid#"> AND
				<cfelse>
					1 = 0 AND	
				</cfif>
				PQ.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#process_cat#">
				<cfif isdefined("attributes.operation_type_id") and len(attributes.operation_type_id)>
					AND OPERATION_TYPE_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#operation_type_id#%">
				</cfif>
			ORDER BY
				PQ.PRODUCT_ID,
				PQ.PRODUCT_CAT_ID,
				PQ.ORDER_NO,
				PQ.QUALITY_TYPE_ID
		</cfquery>
	</cfif>
	<cfset record_date = wrk_get_today()>
	<cfif not isdefined("attributes.ship_wrk_row_id")><cfset attributes.ship_wrk_row_id = ''></cfif>
<cfelseif attributes.event is 'upd'>
	<cf_get_lang_set module_name="prod">
    <cf_xml_page_edit fuseact="prod.popup_add_quality_control_report">
    <cfquery name="get_quality_result" datasource="#dsn3#">
        SELECT * FROM ORDER_RESULT_QUALITY WHERE OR_Q_ID = #attributes.OR_Q_ID#
    </cfquery>
    <cfset attributes.process_cat = GET_QUALITY_RESULT.process_cat>
    <cfset attributes.process_id = GET_QUALITY_RESULT.process_id>
    <cfset attributes.process_row_id = GET_QUALITY_RESULT.process_row_id>
    <cfset attributes.ship_wrk_row_id = GET_QUALITY_RESULT.ship_wrk_row_id>
    <!--- Belge No, Uretim ise Uretime Gore Ayri Gelir, Uretimin Kontrol No Bos ise Digeri Gelmeye Devam Eder --->
    <cfif attributes.process_cat eq 171><cfset paper_type_ = "PRODUCTION_QUALITY_CONTROL"><cf_papers paper_type="production_quality_control"></cfif>
    <cfif not isDefined("paper_number") or not Len(paper_number)><cfset paper_type_ = "QUALITY_CONTROL"><cf_papers paper_type="quality_control"></cfif>
    <!--- //Belge No, Uretim ise Uretime Gore Ayri Gelir, Uretimin Kontrol No Bos ise Digeri Gelmeye Devam Eder --->
    <cfquery name="GET_ORDER_NO" datasource="#dsn3#">
        <cfif attributes.process_cat eq 171><!--- Üretim Sonucu --->
            SELECT
                (SELECT AMOUNT FROM PRODUCTION_ORDER_RESULTS_ROW WHERE PR_ORDER_ID = POR.PR_ORDER_ID AND TYPE=1 AND WRK_ROW_ID = '#attributes.ship_wrk_row_id#') AS QUANTITY,
                PO.P_ORDER_NO,
                POR.RESULT_NO,
                0 AS COMPANY_ID
            FROM 
                PRODUCTION_ORDERS PO,
                PRODUCTION_ORDER_RESULTS POR
            WHERE
                POR.P_ORDER_ID = PO.P_ORDER_ID AND
                PO.P_ORDER_ID = #attributes.process_id# AND
                POR.PR_ORDER_ID = (SELECT PR_ORDER_ID FROM PRODUCTION_ORDER_RESULTS_ROW WHERE WRK_ROW_ID = '#attributes.ship_wrk_row_id#')
        <cfelseif attributes.process_cat eq 76 or attributes.process_cat eq 811><!--- Mal Alım İrsaliyesi --->
            SELECT 
                SR.AMOUNT AS QUANTITY,
                S.SHIP_NUMBER AS P_ORDER_NO,
                S.SHIP_NUMBER AS RESULT_NO,
                S.COMPANY_ID AS COMPANY_ID
            FROM 
                #dsn2_alias#.SHIP S,#dsn2_alias#.SHIP_ROW SR
            WHERE 
                S.SHIP_ID = SR.SHIP_ID AND 
                S.SHIP_ID = #attributes.process_id# AND 
                SR.WRK_ROW_ID = '#attributes.ship_wrk_row_id#' AND
                S.SHIP_TYPE IN(76,811)
        <cfelseif attributes.process_cat eq -1><!--- Operasyonlar --->
            SELECT
                ISNULL(PO.AMOUNT,0) AS QUANTITY,
                POS.P_ORDER_NO,
                POS.P_ORDER_NO AS RESULT_NO ,
                0 AS COMPANY_ID
            FROM
                PRODUCTION_OPERATION_RESULT POR,
                PRODUCTION_OPERATION PO,
                PRODUCTION_ORDERS POS
            WHERE
                POR.P_ORDER_ID = POS.P_ORDER_ID AND
                PO.P_OPERATION_ID = POR.OPERATION_ID AND
                POR.OPERATION_ID = #attributes.process_row_id#
        <cfelseif attributes.process_cat eq -2><!--- Operasyonlar --->
            SELECT
                1 QUANTITY,
                SERVICE_HEAD P_ORDER_NO,
                SERVICE_HEAD  AS RESULT_NO,
                0 AS COMPANY_ID
            FROM 
                SERVICE 
            WHERE	
                SERVICE.SERVICE_ID = #attributes.process_row_id#
        </cfif>
    </cfquery>
    <cfif isdefined("GET_QUALITY_RESULT.stock_id") and len(GET_QUALITY_RESULT.stock_id)>
        <cfquery name="get_product_info" datasource="#dsn3#">
            SELECT PRODUCT_ID,PRODUCT_NAME,STOCK_CODE,PRODUCT_CATID FROM STOCKS WHERE STOCK_ID = #GET_QUALITY_RESULT.stock_id#
        </cfquery>
    </cfif>
    <cfquery name="get_quality_type" datasource="#dsn3#">
        SELECT 
            CCT.QUALITY_CONTROL_TYPE,
            CCT.TYPE_ID,
            CCT.QUALITY_MEASURE,
            CCT.TYPE_DESCRIPTION,
            CCT.STANDART_VALUE,
            PQ.*
        FROM
            QUALITY_CONTROL_TYPE CCT,
            PRODUCT_QUALITY PQ
        WHERE 
            PQ.QUALITY_TYPE_ID = CCT.TYPE_ID 
            <cfif isdefined("get_product_info.product_id") and len(get_product_info.product_id)>
                AND PQ.PRODUCT_ID IS NOT NULL 
                AND PQ.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_info.product_id#"> 
            <cfelse>
                AND 1 = 0 	
            </cfif>
            <cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
                AND PQ.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#">
            </cfif>
            <cfif isdefined("attributes.operation_type_id") and len(attributes.operation_type_id)>
                AND OPERATION_TYPE_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#operation_type_id#%">
            </cfif>
        ORDER BY
            PQ.PRODUCT_ID,
            PQ.PRODUCT_CAT_ID,
            PQ.ORDER_NO,
            PQ.QUALITY_TYPE_ID
    </cfquery>
    <cfif not get_quality_type.recordcount><!--- Urunde Yoksa Kategoriye Bakilir --->
        <cfquery name="get_quality_type" datasource="#dsn3#">
            SELECT 
                CCT.QUALITY_CONTROL_TYPE,
                CCT.TYPE_ID,
                CCT.QUALITY_MEASURE,
                CCT.TYPE_DESCRIPTION,
                CCT.STANDART_VALUE,
                PQ.*
            FROM
                QUALITY_CONTROL_TYPE CCT,
                PRODUCT_QUALITY PQ
            WHERE 
                PQ.QUALITY_TYPE_ID = CCT.TYPE_ID 
                <cfif isdefined("get_product_info.product_id") and len(get_product_info.product_id)>
                    AND PQ.PRODUCT_CAT_ID IS  NOT NULL AND PQ.PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_product_info.product_catid#"> 
                <cfelse>
                    AND 1 = 0 	
                </cfif>
                <cfif isdefined("attributes.process_cat") and len(attributes.process_cat)>
                    AND PQ.PROCESS_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_cat#">
                </cfif>
                <cfif isdefined("attributes.operation_type_id") and len(attributes.operation_type_id)>
                    AND OPERATION_TYPE_ID LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#operation_type_id#%">
                </cfif>
            ORDER BY
                PQ.PRODUCT_ID,
                PQ.PRODUCT_CAT_ID,
                PQ.ORDER_NO,
                PQ.QUALITY_TYPE_ID
        </cfquery>
    </cfif>
    <cfset record_date = wrk_get_today()>   
</cfif>  
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")> 
    <cfif not isdefined('attributes.from_add_contol_page')>
    	<script type="text/javascript">
			function input_control()
			{		
					return true;
			}
			function show_sort_type()
			{
				if(document.list_serial.process_cat_id.value == -1)
				{
					dept_id_2.style.display = 'none';
					seri_no.style.display = 'none';				
					seri_no2.style.display = 'none';
					dept_id_hidden.style.display = '';
				}
				else if(document.list_serial.process_cat_id.value == 171)
				{
						dept_id_2.style.display = '';
						seri_no.style.display = '';
						seri_no2.style.display = '';
						dept_id_hidden.style.display = 'none';
				}
				else
				{
					dept_id_2.style.display = '';
					seri_no.style.display = '';
					seri_no2.style.display = '';
					dept_id_hidden.style.display = 'none';			
				}	
			}
		</script>
    </cfif>
<cfelseif attributes.event is 'upd'>
	<script type="text/javascript">
		function unformat_fields()
		{	
			if (!process_cat_control()) return false;
			if(!form_warning('control_amount','Kontrol Miktarı Giriniz!')) return false;
			<cfif isDefined("xml_show_horizontal_quality_type") and xml_show_horizontal_quality_type eq 1>
				var control_amount_filter = document.getElementById('control_amount').value;
			<cfelse>
				var control_amount_filter = filterNum(document.getElementById('control_amount').value);
			</cfif>
			if(parseInt(control_amount_filter) > "<cfoutput>#GET_ORDER_NO.QUANTITY#</cfoutput>")
			{
				alert("<cf_get_lang no='393.Kontrol Miktarı İşlem Miktarından Büyük Olamaz'>!");
				return false;
			}		
			<cfif isDefined("xml_show_horizontal_quality_type") and xml_show_horizontal_quality_type eq 0>
				if(document.getElementById('success_id') != undefined && document.getElementById('success_id').value=='')
				{
					alert("<cf_get_lang no='366.Kontrol Tipi Girmelisiniz'>!");
					return false;
				}
				<cfif GET_QUALITY_TYPE.recordcount>
					<cfoutput query="GET_QUALITY_TYPE">
					{
						if(!form_warning('result_#TYPE_ID#',"<cf_get_lang no='370.Sonuç Giriniz'>")) 
							return false;
						if(document.getElementById('result_#TYPE_ID#') != undefined && document.getElementById('quality_rule__#TYPE_ID#') == 0)
							document.getElementById('result_#TYPE_ID#').value = filterNum(document.getElementById('result_#TYPE_ID#').value,4);
					}
					</cfoutput>
				<cfelse>
					{
						alert("<cf_get_lang no='373.Ürün İçin Tanımlı Kalite Kontrol Tipi Yok'>!");
						return false;
					}
				</cfif>
				//queryde filtreliyor buna gerek yok document.add_quality.control_amount.value = filterNum(document.add_quality.control_amount.value,3);
			</cfif>
			<cfif isDefined("xml_show_horizontal_quality_type") and xml_show_horizontal_quality_type eq 1>
			return calculate();
			</cfif>
			return true;
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
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_quality_controls';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'production_plan/display/list_quality_controls.cfm';
	WOStruct['#attributes.fuseaction#']['list']['default'] = 1;	
		
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_quality_controls';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'production_plan/form/add_quality_control_report.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'production_plan/query/add_quality_control_report.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_quality_controls';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'prod.popup_add_quality_control_report';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'production_plan/form/upd_quality_control_report_rows.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'production_plan/query/upd_quality_control_report_row.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_quality_controls';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'or_q_id=##attributes.OR_Q_ID##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.OR_Q_ID##';
	
	WOStruct['#attributes.fuseaction#']['del'] = structNew();
	WOStruct['#attributes.fuseaction#']['del']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = '#listgetat(attributes.fuseaction,1,'.')#.list_quality_controls';
	WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'production_plan/query/upd_quality_control_report_row.cfm';
	WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'production_plan/query/upd_quality_control_report_row.cfm';
	WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = '#listgetat(attributes.fuseaction,1,'.')#.list_quality_controls';
	WOStruct['#attributes.fuseaction#']['del']['parameters'] = 'or_q_id=##attributes.OR_Q_ID##&is_delete=1';
	WOStruct['#attributes.fuseaction#']['del']['Identity'] = '##attributes.OR_Q_ID##';
	
	
	 if(attributes.event is 'add')
	{			
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons'] = structNew();	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['add']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_type=#attributes.process_cat#&action_row_id=#attributes.process_row_id#&print_type=34','page','workcube_print')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	else if(attributes.event is 'upd'){
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'] = structNew();
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['text'] = '#lang_array_main.item[1966]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][0]['customTag'] = "<cf_get_workcube_related_acts period_id='#session.ep.period_id#' company_id='#session.ep.company_id#' asset_cat_id='-24' module_id='13' action_section='OR_Q_ID' action_id='#attributes.OR_Q_ID#'>";
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['text'] = '#lang_array.item[171]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['menus'][1]['onClick'] = "windowopen('#request.self#?fuseaction=stock.popup_form_upd_improper_products&quality_control_id=#attributes.OR_Q_ID#','small','popup_member_history')";
		
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons'] = structNew();	
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['text'] = '#lang_array_main.item[62]#';
		tabMenuStruct['#attributes.fuseaction#']['tabMenus']['upd']['icons']['print']['onClick'] = "windowopen('#request.self#?fuseaction=objects.popup_print_files&action_id=#attributes.OR_Q_ID#&action_type=#attributes.process_cat#&action_row_id=#attributes.process_row_id#&print_type=34','page','workcube_print')";
		tabMenuData = SerializeJSON(tabMenuStruct['#attributes.fuseaction#']['tabMenus']);
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'productQualityControlsController';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ORDER_RESULT_QUALITY';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['process_item']"; 
	
	
	//WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
//	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'productQualityControlsController';
//	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
//	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'ORDER_RESULT_QUALITY_ROW';
//	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'company';
//		WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['tr_control_amount','tr_control_success']"; 
//
//	
</cfscript>
