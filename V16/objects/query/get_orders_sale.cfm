<cfquery name="GET_ORDER_LIST" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
	SELECT DISTINCT
		O.ORDER_NUMBER,
		O.ORDER_HEAD,
		O.PARTNER_ID,
		PP.PROJECT_HEAD,
		O.COMPANY_ID,
		O.CONSUMER_ID,
		O.RECORD_EMP,
		O.PRIORITY_ID,
		O.ORDER_ZONE,
		O.PURCHASE_SALES,
		O.RECORD_DATE,
		O.ORDER_DATE,
		O.DELIVERDATE,
		O.ORDER_CURRENCY,
		O.ORDER_EMPLOYEE_ID,
		O.SALES_PARTNER_ID,
		O.SALES_CONSUMER_ID,
		O.REF_PARTNER_ID,
		O.REF_COMPANY_ID,
		O.REF_CONSUMER_ID,
		O.NETTOTAL,
		O.TAXTOTAL,		
		<cfif isdefined('attributes.order_list_type') and attributes.order_list_type eq 1>
			ISNULL(ORR.DELIVER_DATE,O.DELIVERDATE) DELIVERDATE,
			ISNULL(ORR.DELIVER_DEPT,O.DELIVER_DEPT_ID) DELIVER_DEPT,
			ORR.DELIVER_DEPT ROW_DEPT_ID,
			ORR.DELIVER_DATE,
			ORR.WIDTH_VALUE,
			ORR.DEPTH_VALUE,
			ORR.HEIGHT_VALUE,
			ORR.ORDER_ROW_ID,
			ORR.ORDER_ROW_CURRENCY,
			ORR.PRODUCT_ID,
			ORR.STOCK_ID,
			ORR.SPECT_VAR_ID,
			ORR.QUANTITY,
			ORR.UNIT2,
			ISNULL(ORR.CANCEL_AMOUNT,0) AS CANCEL_AMOUNT,
			ORR.SPECT_VAR_NAME,
			ORR.RESERVE_TYPE,
			ISNULL(ORR.DELIVER_DATE,O.DELIVERDATE) AS SATIR_TESLIM,
			ORR.WRK_ROW_ID,
			ORR.PRODUCT_NAME,
			ORR.NETTOTAL ROW_NETTOTAL,
			S.MANUFACT_CODE PRODUCT_MANUFACT_CODE,
			S.PRODUCT_CODE AS STOCK_CODE,
			S.PRODUCT_CODE_2,
			ORR.PRODUCT_NAME2,
		<cfelse>
			O.DELIVERDATE,
			O.DELIVER_DEPT_ID DELIVER_DEPT,	
		</cfif>
			ORR.ORDER_ID
	FROM 
		ORDERS O
		LEFT JOIN #dsn_alias#.PRO_PROJECTS PP ON O.PROJECT_ID  = PP.PROJECT_ID,
		ORDER_ROW ORR,
		STOCKS S
	WHERE 
		ORR.STOCK_ID = S.STOCK_ID AND
		ORR.ORDER_ID = O.ORDER_ID AND
		O.ORDER_STATUS = 1
		<cfif not isdefined("attributes.is_return") or (isdefined("attributes.is_return") and attributes.is_return eq 0)>
			AND(
				( ORR.ORDER_ROW_CURRENCY IN (-6,-7) AND O.IS_PROCESSED = 1 ) OR
				( ORR.ORDER_ROW_CURRENCY = -6 AND O.IS_PROCESSED = 0 )
			)
		<cfelseif (isdefined("attributes.is_return") and attributes.is_return eq 1)>
			AND ORR.ORDER_ROW_CURRENCY IN (-10,-7,-8,-3)
		</cfif>
		AND 
		(
			(O.PURCHASE_SALES = 1 AND O.ORDER_ZONE = 0) OR<!--- ep den kaydedilmis --->
			(O.PURCHASE_SALES = 0 AND O.ORDER_ZONE = 1)<!--- pp den kaydedilmis--->
		)
		<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
			AND ( ORR.DELIVER_DEPT = #attributes.department_id# OR O.DELIVER_DEPT_ID=#attributes.department_id# )
		</cfif>
		<cfif isdefined("attributes.company_id") and len(attributes.company_id)>
			AND O.COMPANY_ID=#attributes.company_id#
		</cfif>
		<cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			AND O.CONSUMER_ID=#attributes.consumer_id#
		</cfif>
		<cfif isdefined("attributes.project_id") and len(attributes.project_id) and  isdefined("attributes.project_head") and len(attributes.project_head)>
			 AND O.PROJECT_ID=#attributes.project_id#
		</cfif>
		<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id) and  isdefined("attributes.subscription_no") and len(attributes.subscription_no)>
			 AND O.SUBSCRIPTION_ID=#attributes.subscription_id#
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
			(
				O.ORDER_NUMBER LIKE '%#attributes.keyword#%' OR
				O.ORDER_HEAD LIKE '%#attributes.keyword#%' OR
				ORR.PRODUCT_NAME LIKE '%#attributes.keyword#%' OR
				S.STOCK_CODE LIKE '%#attributes.keyword#%' OR
				S.PRODUCT_CODE LIKE '%#attributes.keyword#%' OR
				S.PRODUCT_CODE_2 LIKE '%#attributes.keyword#%' OR
				S.MANUFACT_CODE LIKE '%#attributes.keyword#%'
			)
		</cfif>
		<cfif isDefined("attributes.product_name") and len(attributes.product_name) and isDefined("attributes.product_id") and len(attributes.product_id)>
			 AND ORR.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#">
		</cfif>
		<cfif attributes.list_type eq 2>
			<cfif isdefined("attributes.order_detail") and len(attributes.order_detail)>
				AND ORR.PRODUCT_NAME2 LIKE '%#attributes.order_detail#%'
			</cfif>
		</cfif>
		<cfif isdefined("attributes.start_date") and isdate(attributes.start_date) and isdate(attributes.finish_date)>
			AND O.ORDER_DATE BETWEEN #attributes.start_date# AND #attributes.finish_date#
		<cfelseif isdefined("attributes.start_date") and isdate(attributes.start_date)>
			AND O.ORDER_DATE >= #attributes.start_date#
		<cfelseif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
			AND O.ORDER_DATE <= #attributes.finish_date#
		</cfif>
		<cfif isdefined('attributes.spect_main_id') and isdefined('attributes.spect_name') and len(attributes.spect_name)>
			AND ORR.SPECT_VAR_ID IN(SELECT SPECT_VAR_ID FROM SPECTS WHERE SPECT_MAIN_ID = #attributes.spect_main_id#)
		</cfif>
	 ORDER BY
	 	<cfif attributes.sort_type eq 1>
			<cfif isdefined('attributes.order_list_type') and attributes.order_list_type eq 1>
				ISNULL(ORR.DELIVER_DATE,O.DELIVERDATE) ASC,
			<cfelse>
				O.DELIVERDATE ASC,
			</cfif>
		<cfelseif attributes.sort_type eq 2>
			<cfif isdefined('attributes.order_list_type') and attributes.order_list_type eq 1>
				ISNULL(ORR.DELIVER_DATE,O.DELIVERDATE) DESC,
			<cfelse>
				O.DELIVERDATE DESC,
			</cfif>
		<cfelseif attributes.sort_type eq 3>
			O.ORDER_DATE ASC,
		<cfelseif attributes.sort_type eq 4>
			O.ORDER_DATE DESC,
		</cfif>
	 	ORR.ORDER_ID
		<cfif isdefined('attributes.order_list_type') and attributes.order_list_type eq 1>
			,ORR.DELIVER_DEPT
		</cfif>
</cfquery>
