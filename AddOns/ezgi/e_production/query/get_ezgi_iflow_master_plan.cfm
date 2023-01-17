<cfquery name="get_master_plan" datasource="#dsn3#">
	SELECT     	
    	MASTER_PLAN_ID, 
		MASTER_PLAN_START_DATE,
    	MASTER_PLAN_FINISH_DATE, 
		MASTER_PLAN_NAME, 
		MASTER_PLAN_NUMBER, 
		MASTER_PLAN_DETAIL, 
		MASTER_PLAN_STATUS, 
		MASTER_PLAN_STAGE,
      	MASTER_PLAN_PROCESS, 
		BRANCH_ID, 
		GROSSTOTAL, 
     	RECORD_EMP, 
		RECORD_IP, 
		RECORD_DATE,
		IS_PROCESS,
     	0 AS H_POINT,
     	0 AS G_POINT,
    	0 AS T_POINT,
        ISNULL((
                	SELECT        
                    	SUM(PO.QUANTITY) AS QUANTITY
					FROM            
                   		PRODUCTION_ORDERS AS PO INNER JOIN
                     	EZGI_IFLOW_PRODUCTION_ORDERS AS EP ON PO.LOT_NO = EP.LOT_NO
					WHERE        
                    	EP.MASTER_PLAN_ID = EZGI_IFLOW_MASTER_PLAN.MASTER_PLAN_ID
                ),0) AS TOPLAM_EMIR_SAYISI,
                ISNULL((
                		SELECT        
                        	SUM(TBL.AMOUNT) AS RESULT_AMOUNT
						FROM            
                        	PRODUCTION_ORDERS AS PO INNER JOIN
                       		(
                            	SELECT        
                                	POR.P_ORDER_ID, SUM(PORR.AMOUNT) AS AMOUNT
                               	FROM            
                               		PRODUCTION_ORDER_RESULTS AS POR INNER JOIN
                                 	PRODUCTION_ORDER_RESULTS_ROW AS PORR ON POR.PR_ORDER_ID = PORR.PR_ORDER_ID
                               	WHERE        
                                	POR.IS_STOCK_FIS = 1 AND 
                                    PORR.TYPE = 1
                            	GROUP BY 
                                	POR.P_ORDER_ID
                         	) AS TBL ON PO.P_ORDER_ID = TBL.P_ORDER_ID INNER JOIN
                     		EZGI_IFLOW_PRODUCTION_ORDERS AS EP ON PO.LOT_NO = EP.LOT_NO
						WHERE        
                        	EP.MASTER_PLAN_ID = EZGI_IFLOW_MASTER_PLAN.MASTER_PLAN_ID
                ),0) AS BITEN_EMIR_SAYISI
	FROM       	
    	EZGI_IFLOW_MASTER_PLAN
	WHERE		
    	1=1
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND
				(
					<cfif len(attributes.keyword) gt 3>
						MASTER_PLAN_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
					<cfelse>
						MASTER_PLAN_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
					</cfif> OR
					<cfif len(attributes.keyword) gt 3>
						MASTER_PLAN_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
					<cfelse>
						MASTER_PLAN_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
					</cfif> OR
					<cfif len(attributes.keyword) gt 3>
						MASTER_PLAN_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
					<cfelse>
						MASTER_PLAN_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%">
					</cfif>
				)
		</cfif>
        <cfif isdefined('attributes.master_plan_status') and len(attributes.master_plan_status)>
        	AND MASTER_PLAN_STATUS = #attributes.master_plan_status#
        </cfif>
		<cfif isDefined("attributes.paper_number") and len(attributes.paper_number)>
			AND MASTER_PLAN_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.paper_number#%">
		</cfif>
		<cfif len(attributes.date1)>
			AND MASTER_PLAN_START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.DATE1#">
		</cfif>
		<cfif len(attributes.date2)>
			AND MASTER_PLAN_START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.DATE2#">
		</cfif>
		<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id) and isdefined("attributes.record_emp_name") and len(attributes.record_emp_name)>
			AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp_id#">
		</cfif>
		<cfif isDefined("attributes.prod_order_stage") and len(attributes.prod_order_stage)>
			AND MASTER_PLAN_STAGE =#attributes.prod_order_stage#
		</cfif>
        <cfif len(attributes.record_date)>
			AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#">
		</cfif>
		<cfif len(attributes.record_date2)>
			AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date2#">
		</cfif>
        <cfif isdefined('attributes.shift_id') and len(attributes.shift_id)>
			AND MASTER_PLAN_CAT_ID = #attributes.shift_id#
		</cfif>
	ORDER BY 
		<cfif isDefined('attributes.oby') and attributes.oby eq 1>
			MASTER_PLAN_START_DATE DESC
		<cfelse>
			MASTER_PLAN_START_DATE 
		</cfif>
</cfquery>
