
<cfif x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
	<cfinclude template="/member/query/get_ims_control.cfm">
</cfif>
<cfif isdefined("attributes.start_date") and len(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>

<cfquery name="GET_SAMPLE_REQ" datasource="#DSN3#">
	SELECT
	
		SAMPLE_REQ.REQ_NO,
		SAMPLE_REQ.PROJECT_ID,
		SAMPLE_REQ.REQ_CURRENCY_ID,
		SAMPLE_REQ.CONSUMER_ID,
		SAMPLE_REQ.PARTNER_ID,
		SAMPLE_REQ.REQ_HEAD,
		SAMPLE_REQ.REQ_DATE,
		SAMPLE_REQ.INVOICE_DATE,
		SAMPLE_REQ.PROBABILITY,
		SAMPLE_REQ.INCOME,
		SAMPLE_REQ.MONEY,
		SAMPLE_REQ.SHORT_CODE,
		SAMPLE_REQ.SALES_EMP_ID,
		SAMPLE_REQ.SALES_PARTNER_ID,
		SAMPLE_REQ.SALES_CONSUMER_ID,
		SAMPLE_REQ.RECORD_DATE,
		SAMPLE_REQ.REQ_ID,
		SAMPLE_REQ.STOCK_ID,
		P.PRODUCT_NAME,
		SAMPLE_REQ.PRODUCT_CAT_ID,
		SAMPLE_REQ.COMPANY_ID,
		SAMPLE_REQ.REQ_TYPE_ID,
		SAMPLE_REQ.ACTIVITY_TIME,
		SAMPLE_REQ.COST,
		SAMPLE_REQ.MONEY2,
		SAMPLE_REQ.SALE_ADD_OPTION_ID,
		SAMPLE_REQ.UPDATE_DATE,
        SAMPLE_REQ.REQ_STAGE,
		SAMPLE_REQ.REQ_STATUS,
		SAMPLE_REQ.REQ_DETAIL,
		SAMPLE_REQ.DESING_EMP_ID,
        SAMPLE_REQ.PRODUCT_ID,
		SAMPLE_REQ.COMPANY_ORDER_NO,
		<cfif (database_type is 'MSSQL')>
            CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME PARTNER_NAME_SURNAME,
        <cfelseif (database_type is 'DB2')>
            CP.COMPANY_PARTNER_NAME || ' ' || CP.COMPANY_PARTNER_SURNAME PARTNER_NAME_SURNAME,
        </cfif>        
        CP.TITLE,
        C.FULLNAME,
        CON.CONSUMER_NAME + ' ' + CON.CONSUMER_SURNAME CONSUMER_NAME,
        E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME EMPLOYEES_NAME,
		ED.EMPLOYEE_NAME + ' ' + ED.EMPLOYEE_SURNAME DESING_EMPLOYEES_NAME,
        PP.PROJECT_HEAD,
        SOT.OPPORTUNITY_TYPE AS OPPORTUNITY_TYPE,
        SOT.OPPORTUNITY_TYPE_ID AS OPPORTUNITY_TYPE_ID,
        PTR.STAGE,
		ASSET.ASSET_ID,
		ASSET.ASSETCAT_ID,
		ASSET.ASSET_FILE_NAME
		<!--- ,
		(STUFF((SELECT ',' + CONVERT(NVARCHAR, ORDER_ID) FROM TEXTILE_PRODUCTION_OPERATION_MAIN WHERE IS_SEND = 1 AND REQUEST_ID = SAMPLE_REQ.REQ_ID FOR XML PATH('')), 1, 1, '')) AS ORDER_ID,
		(STUFF((SELECT ',' + convert(nvarchar, SSORW.PRODUCT_ID) FROM TEXTILE_PRODUCTION_OPERATION_MAIN SSPOM INNER JOIN ORDER_ROW SSORW ON SSPOM.ORDER_ID = SSORW.ORDER_ID WHERE SSPOM.REQUEST_ID = SAMPLE_REQ.REQ_ID AND SSPOM.IS_SEND = 1 AND SSORW.RELATED_ACTION_TABLE='TEXTILE_SAMPLE_REQUEST' AND SSORW.ORDER_ROW_CURRENCY = -5 GROUP BY SSORW.PRODUCT_ID), 1, 1, '')) AS PRODUCT_ID,
		(SELECT SUM(MARJ) FROM TEXTILE_PRODUCTION_OPERATION_MAIN WHERE IS_SEND = 1 AND REQUEST_ID = SAMPLE_REQ.REQ_ID) AS MARJ --->
	<cfif isdefined("attributes.is_detail_stage")>
		,
			STAGES.FABRIC_STAGE,
			STAGES.ACCESSORY_STAGE,
			STAGES.PATTERN_STAGE,
			STAGES.WORKSHIP_STAGE,
			STAGES.WASH_STAGE,
			STAGES.MOLD_STAGE,
			STAGES.MARKER_STAGE
			
		</cfif>
			
	FROM
        TEXTILE_SAMPLE_REQUEST as SAMPLE_REQ WITH (NOLOCK) 
		OUTER APPLY(
						select
							TOP 1 
							ASSET_ID,
							ASSETCAT_ID,
							ASSET_FILE_NAME
						FROM
							#DSN_ALIAS#.ASSET
							where
								ACTION_SECTION='REQ_ID' AND 
								ACTION_ID=SAMPLE_REQ.REQ_ID AND
								IS_IMAGE=1 AND
								MODULE_NAME='textile'
								ORDER BY ASSET_ID
					) ASSET
        LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON PP.PROJECT_ID = SAMPLE_REQ.PROJECT_ID
		LEFT JOIN #dsn1_alias#.PRODUCT P ON P.PRODUCT_ID = SAMPLE_REQ.PRODUCT_ID
        LEFT JOIN #dsn_alias#.EMPLOYEES E ON E.EMPLOYEE_ID = SAMPLE_REQ.SALES_EMP_ID
		LEFT JOIN #dsn_alias#.EMPLOYEES ED ON ED.EMPLOYEE_ID = SAMPLE_REQ.DESING_EMP_ID
        LEFT JOIN #dsn_alias#.COMPANY_PARTNER CP ON SAMPLE_REQ.PARTNER_ID = CP.PARTNER_ID
        LEFT JOIN #dsn_alias#.COMPANY C ON CP.COMPANY_ID = C.COMPANY_ID
        LEFT JOIN #dsn_alias#.CONSUMER CON ON SAMPLE_REQ.CONSUMER_ID = CON.CONSUMER_ID
        LEFT JOIN #dsn3_alias#.SETUP_OPPORTUNITY_TYPE SOT ON SAMPLE_REQ.REQ_TYPE_ID = SOT.OPPORTUNITY_TYPE_ID
        LEFT JOIN #dsn_alias#.PROCESS_TYPE_ROWS PTR ON SAMPLE_REQ.REQ_STAGE = PTR.PROCESS_ROW_ID
		<cfif isDefined("attributes.is_detail_stage")>
			LEFT JOIN (
			SELECT REQUEST_ID, [2] AS FABRIC_STAGE, [3] AS ACCESSORY_STAGE, [4] AS PATTERN_STAGE, [5] AS WORKSHIP_STAGE, [7] AS WASH_STAGE, [8] AS MOLD_STAGE, [9] AS MARKER_STAGE
			FROM (
				SELECT PLAN_TYPE_ID, STAGE_ID, REQUEST_ID FROM TEXTILE_PRODUCT_PLAN
			) TSTAGES
			PIVOT (
				MAX(STAGE_ID) FOR PLAN_TYPE_ID IN ([2], [3], [4], [5], [7], [8], [9])
			) PSTAGES
		) STAGES ON SAMPLE_REQ.REQ_ID = STAGES.REQUEST_ID
		</cfif>
     WHERE
		SAMPLE_REQ.REQ_ID IS NOT NULL
		<cfif len(attributes.keyword)>
			AND 
				(
					SAMPLE_REQ.REQ_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(attributes.keyword)#%">
					OR
					SAMPLE_REQ.REQ_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(attributes.keyword)#%">
				)
		</cfif>
        <cfif len(attributes.keyword_detail)>
			AND SAMPLE_REQ.REQ_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(attributes.keyword_detail)#%">
		</cfif>
        <cfif len(attributes.keyword_oppno)>
			AND SAMPLE_REQ.REQ_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(attributes.keyword_oppno)#%">
		</cfif>
		<cfif len(attributes.start_date)>AND SAMPLE_REQ.REQ_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"></cfif>
		<cfif len(attributes.finish_date)>AND SAMPLE_REQ.REQ_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#"></cfif>
		<cfif isdefined("attributes.opp_status") and len(attributes.opp_status)>AND SAMPLE_REQ.REQ_STATUS = <cfqueryparam cfsqltype="cf_sql_smallint" value="#attributes.opp_status#"></cfif>
		<cfif len(attributes.ordertype) and attributes.ordertype eq 4> <!--- Takip Kaydına Göre --->
			AND SAMPLE_REQ.REQ_ID IN (SELECT OPPORTUNITIES_PLUS.REQ_ID FROM OPPORTUNITIES_PLUS,OPPORTUNITIES WHERE SAMPLE_REQ.REQ_ID = OPPORTUNITIES_PLUS.REQ_ID)
		</cfif> 
		<cfif len(attributes.member_type) and (attributes.member_type is 'partner') and len(attributes.member_name) and len(attributes.company_id)>
			AND SAMPLE_REQ.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
		</cfif>
		<cfif len(attributes.member_type) and (attributes.member_type is 'consumer') and len(attributes.member_name) and len(attributes.consumer_id)>
			AND SAMPLE_REQ.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.consumer_id#">
		</cfif>
		<cfif len(attributes.sales_emp_id) and len(attributes.sales_emp)>
			AND SAMPLE_REQ.SALES_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_emp_id#">
		</cfif>
		<cfif len(attributes.sales_member_type) and (attributes.sales_member_type is 'partner') and len(attributes.sales_member_id) and len(attributes.sales_member_name)>
			AND SAMPLE_REQ.SALES_PARTNER_ID IN (SELECT PARTNER_ID FROM #dsn_alias#.COMPANY_PARTNER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_member_id#">)
		</cfif>
		<cfif len(attributes.sales_member_type) and (attributes.sales_member_type is 'consumer') and len(attributes.sales_member_id) and len(attributes.sales_member_name)>
			AND SAMPLE_REQ.SALES_CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_member_id#">
		</cfif>
		<cfif len(attributes.record_employee_id) and len(attributes.record_employee)>
			AND SAMPLE_REQ.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_employee_id#">
		</cfif>
		<cfif listlen(attributes.process_stage)>
			AND SAMPLE_REQ.REQ_STAGE IN (#attributes.process_stage#)
		</cfif>
		<cfif listlen(attributes.opportunity_type_id)>
			AND SAMPLE_REQ.REQ_TYPE_ID IN (#attributes.opportunity_type_id#)
		</cfif>
		<cfif len(attributes.product_cat_id) and len(attributes.product_cat)>
			AND SAMPLE_REQ.PRODUCT_CAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_cat_id#">
		</cfif>
		<cfif len(attributes.stock_name) and len(attributes.stock_id)>
			AND SAMPLE_REQ.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
		</cfif>
		<cfif len(attributes.sale_add_option)> 
			AND SAMPLE_REQ.SALE_ADD_OPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sale_add_option#">
		</cfif>
		<cfif len(attributes.probability)>
			AND SAMPLE_REQ.PROBABILITY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.probability#">
		</cfif>
		<cfif len(attributes.opp_currency_id)>
			AND SAMPLE_REQ.REQ_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opp_currency_id#">
		</cfif>
		<cfif isdefined("attributes.project_head") and len(attributes.project_head) and isdefined("attributes.project_id") and len(attributes.project_id)>
			AND SAMPLE_REQ.PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.project_id#">
		</cfif>
		<cfif x_control_ims eq 1 and session.ep.our_company_info.sales_zone_followup eq 1>
			AND
				(
				( SAMPLE_REQ.CONSUMER_ID IS NULL AND SAMPLE_REQ.COMPANY_ID IS NULL ) 
				OR (SAMPLE_REQ.COMPANY_ID IN (#PreserveSingleQuotes(my_ims_comp_list)#) )
				OR (SAMPLE_REQ.CONSUMER_ID IN (#PreserveSingleQuotes(my_ims_cons_list)#) )
				)
		</cfif>	
			<cfif isDefined("attributes.order_no") and len(attributes.order_no)>
					AND SAMPLE_REQ.COMPANY_ORDER_NO='#attributes.order_no#'
			</cfif>		
		<cfif isDefined("attributes.model_no") and len(attributes.model_no)>
			AND COMPANY_MODEL_NO LIKE <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='%#attributes.model_no#%'>
		</cfif>
	<cfif len(attributes.ordertype)>
	ORDER BY	
		<cfif attributes.ordertype eq 1>
			SAMPLE_REQ.REQ_DATE 
		<cfelseif attributes.ordertype eq 2>
			SAMPLE_REQ.REQ_DATE DESC
		<cfelseif attributes.ordertype eq 3>
			SAMPLE_REQ.UPDATE_DATE DESC
		<cfelseif attributes.ordertype eq 4>
			PLUS_DATE DESC
		<cfelseif attributes.ordertype eq 5>
			EMPLOYEES.EMPLOYEE_NAME +' '+ EMPLOYEES.EMPLOYEE_SURNAME ASC
		<cfelseif attributes.ordertype eq 6>
			EMPLOYEES.EMPLOYEE_NAME +' '+ EMPLOYEES.EMPLOYEE_SURNAME DESC
		<cfelseif attributes.ordertype eq 7>
			PP.PROJECT_HEAD ASC
		<cfelseif attributes.ordertype eq 8>
			PP.PROJECT_HEAD DESC
		<cfelseif attributes.ordertype eq 9>
			SAMPLE_REQ.REQ_NO 
		<cfelseif attributes.ordertype eq 10>
			SAMPLE_REQ.REQ_NO DESC
		<cfelseif attributes.ordertype eq 11>
			E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME ASC
		<cfelseif attributes.ordertype eq 12>
			E.EMPLOYEE_NAME +' '+ E.EMPLOYEE_SURNAME DESC
		<cfelse>
			SAMPLE_REQ.OPP_ID DESC
		</cfif>
	</cfif>
</cfquery>