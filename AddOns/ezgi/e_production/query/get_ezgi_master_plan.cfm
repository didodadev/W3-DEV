<cfquery name="get_default" datasource="#dsn3#">
	SELECT       
    	POINT_METHOD,
     	FABRIC_CAT,
     	CONTROL_METHOD
	FROM            
    	EZGI_MASTER_PLAN_DEFAULTS
	WHERE        
    	SHIFT_ID IN 
                 	(
                     	SELECT        
                     		SHIFT_ID
						FROM            
                        	#dsn_alias#.SETUP_SHIFTS
						WHERE        
                        	DEPARTMENT_ID IN (#attributes.department_id#)
             		)
</cfquery>
<cfquery name="get_actions" datasource="#dsn3#">
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
		MONEY,
		IS_PROCESS,
    	ISNULL((
                        SELECT     
                            SUM(PLAN_POINT) PLAN_POINT
                        FROM         
                            EZGI_MASTER_ALT_PLAN
                        WHERE     
                            MASTER_PLAN_ID = EZGI_MASTER_PLAN.MASTER_PLAN_ID
      	),0) AS H_POINT,
         <cfif get_default.POINT_METHOD eq 1>
            ISNULL((	
                            SELECT     
                                SUM(PO.QUANTITY) AS P_POINT
                            FROM         
                                EZGI_MASTER_PLAN_RELATIONS AS EMPR INNER JOIN
                                PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID INNER JOIN
                                EZGI_MASTER_ALT_PLAN AS EMAP ON EMPR.MASTER_ALT_PLAN_ID = EMAP.MASTER_ALT_PLAN_ID INNER JOIN
                                EZGI_MASTER_PLAN_SABLON AS EMAS ON EMAP.PROCESS_ID = EMAS.PROCESS_ID
                            WHERE     
                                EMPR.MASTER_PLAN_ID = EZGI_MASTER_PLAN.MASTER_PLAN_ID AND 
                                EMAS.SIRA = 1 AND 
                                    PO.IS_STAGE = 2
            ),0) AS G_POINT,
            ISNULL((	
                            SELECT     
                                SUM(PO.QUANTITY) AS P_POINT
                            FROM         
                                EZGI_MASTER_PLAN_RELATIONS AS EMPR INNER JOIN
                                PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID INNER JOIN
                                EZGI_MASTER_ALT_PLAN AS EMAP ON EMPR.MASTER_ALT_PLAN_ID = EMAP.MASTER_ALT_PLAN_ID INNER JOIN
                                EZGI_MASTER_PLAN_SABLON AS EMAS ON EMAP.PROCESS_ID = EMAS.PROCESS_ID
                            WHERE     
                                EMPR.MASTER_PLAN_ID = EZGI_MASTER_PLAN.MASTER_PLAN_ID AND 
                                EMAS.SIRA = 1
            ),0) AS T_POINT 
        <cfelseif get_default.POINT_METHOD eq 2>   
        	ISNULL(
                	(	
            		SELECT     
                        	SUM(PO.QUANTITY * ISNULL(PTIP.PROPERTY2, 0)) AS P_POINT
						FROM         
                        	EZGI_MASTER_PLAN_RELATIONS AS EMPR INNER JOIN
                          	PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID INNER JOIN
                          	EZGI_MASTER_ALT_PLAN AS EMAP ON EMPR.MASTER_ALT_PLAN_ID = EMAP.MASTER_ALT_PLAN_ID INNER JOIN
                          	EZGI_MASTER_PLAN_SABLON AS EMAS ON EMAP.PROCESS_ID = EMAS.PROCESS_ID LEFT OUTER JOIN
                          	PRODUCT_TREE_INFO_PLUS AS PTIP ON PO.STOCK_ID = PTIP.STOCK_ID
						WHERE     
                        	EMPR.MASTER_PLAN_ID = EZGI_MASTER_PLAN.MASTER_PLAN_ID AND 
                            EMAS.SIRA = 1 AND 
                            PO.IS_STAGE = 2
      				),0) AS G_POINT,
            ISNULL(
                	(	
            		SELECT     
                        	SUM(PO.QUANTITY * ISNULL(PTIP.PROPERTY2, 0)) AS P_POINT
						FROM         
                        	EZGI_MASTER_PLAN_RELATIONS AS EMPR INNER JOIN
                      		PRODUCTION_ORDERS AS PO ON EMPR.P_ORDER_ID = PO.P_ORDER_ID INNER JOIN
                      		EZGI_MASTER_ALT_PLAN AS EMAP ON EMPR.MASTER_ALT_PLAN_ID = EMAP.MASTER_ALT_PLAN_ID INNER JOIN
                      		EZGI_MASTER_PLAN_SABLON AS EMAS ON EMAP.PROCESS_ID = EMAS.PROCESS_ID LEFT OUTER JOIN
                      		PRODUCT_TREE_INFO_PLUS AS PTIP ON PO.STOCK_ID = PTIP.STOCK_ID
						WHERE     
                        	EMPR.MASTER_PLAN_ID = EZGI_MASTER_PLAN.MASTER_PLAN_ID AND 
                            EMAS.SIRA = 1
      		),0) AS T_POINT
      	<cfelse>
        	0 AS G_POINT,
        	0 AS T_POINT
        </cfif>
	FROM       	
    	EZGI_MASTER_PLAN
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
		<cfif isDefined("attributes.paper_number") and len(attributes.paper_number)>
			AND MASTER_PLAN_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.paper_number#%">
		</cfif>
		<cfif len(attributes.date1)>
			AND MASTER_PLAN_START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.DATE1#">
		</cfif>
		<cfif len(attributes.date2)>
			AND MASTER_PLAN_START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.DATE2#">
		</cfif>
		<cfif isdate(attributes.record_date) and not isdate(attributes.record_date2)>
			AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#">
		<cfelseif isdate(attributes.record_date2) and not isdate(attributes.record_date)>
			AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("d",1,attributes.record_date2)#">
		<cfelseif isdate(attributes.record_date) and  isdate(attributes.record_date2)>
			AND RECORD_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.record_date#"> AND RECORD_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#dateadd("d",1,attributes.record_date2)#">
		</cfif>
		<cfif isdefined("attributes.record_emp_id") and len(attributes.record_emp_id) and isdefined("attributes.record_emp_name") and len(attributes.record_emp_name)>
			AND RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.record_emp_id#">
		</cfif>
		<cfif isDefined("attributes.oil_stage") and len(attributes.oil_stage)>
			AND MASTER_PLAN_STAGE =#attributes.oil_stage#
		</cfif>
		<cfif isDefined("attributes.account_status") and len(attributes.account_status)>
			AND MASTER_PLAN_PROCESS =#attributes.account_status#
		</cfif>
   		<cfif isdefined('attributes.department_id') AND len (attributes.department_id)>
        	AND MASTER_PLAN_CAT_ID IN 
                    						(
                                            SELECT        
                                            	SHIFT_ID
											FROM            
                                            	#dsn_alias#.SETUP_SHIFTS
											WHERE        
                                            	DEPARTMENT_ID IN (#attributes.department_id#)
                                            )
                	
     	</cfif>
     	<cfif isdefined('attributes.branch_id') AND len (attributes.branch_id)>
      		AND MASTER_PLAN_CAT_ID IN 
                    						(
                                            SELECT        
                                            	SHIFT_ID
											FROM            
                                            	#dsn_alias#.SETUP_SHIFTS
											WHERE        
                                            	BRANCH_ID IN (#attributes.branch_id#)
                                            )
                	
     	</cfif>
	ORDER BY 
		<cfif isDefined('attributes.oby') and attributes.oby eq 1>
			MASTER_PLAN_START_DATE DESC
		<cfelse>
			MASTER_PLAN_START_DATE 
		</cfif>
</cfquery>
