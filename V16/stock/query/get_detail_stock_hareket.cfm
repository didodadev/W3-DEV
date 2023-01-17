<cfquery name="GET_TOPLAM" datasource="#DSN2#">
	SELECT 
		ROUND(SUM(STOCK_IN),8) AS STOCK_IN,
		ROUND(SUM(STOCK_OUT),8) AS STOCK_OUT,
		UPD_ID,
		PROCESS_DATE,
		PROCESS_TYPE,        
    <cfif is_show_project eq 1>
    CASE
   		WHEN STOCKS_ROW.PROCESS_TYPE IN (70,71,72,78,85,141,73,74,75,76,77,84,86,87,88,140,81,811) 
  			THEN (SELECT S.PROJECT_ID FROM #dsn2_alias#.SHIP S WHERE S.SHIP_ID = STOCKS_ROW.UPD_ID) 
   		WHEN STOCKS_ROW.PROCESS_TYPE IN (110,111,112,113,114,115,119,1131)
  		    THEN (SELECT SF.PROJECT_ID FROM #dsn2_alias#.STOCK_FIS SF WHERE SF.FIS_ID = STOCKS_ROW.UPD_ID)
	ELSE 0 
	END AS PROJECT_ID,
    CASE
		WHEN STOCKS_ROW.PROCESS_TYPE IN (70,71,72,78,85,141,73,74,75,76,77,84,86,87,88,140,81,811) 
  			THEN (SELECT S.PROJECT_ID_IN FROM #dsn2_alias#.SHIP S WHERE S.SHIP_ID = STOCKS_ROW.UPD_ID) 
   		WHEN STOCKS_ROW.PROCESS_TYPE IN (110,111,112,113,114,115,119,1131)
  		    THEN (SELECT SF.PROJECT_ID_IN FROM #dsn2_alias#.STOCK_FIS SF WHERE SF.FIS_ID = STOCKS_ROW.UPD_ID)
	ELSE 0 
	END AS PROJECT_ID_IN,
    </cfif>       
	<cfif attributes.shelf_number eq 1>
		SHELF_NUMBER,
	</cfif>
	<cfif isDefined('attributes.stock_id') and isdefined('attributes.list_type') and attributes.list_type neq 0>
		STOCKS_ROW.STOCK_ID,
	</cfif>
    <cfif isdefined('attributes.list_type') and attributes.list_type eq 3>
		STOCKS_ROW.LOT_NO,
	</cfif>
	<cfif isdefined('attributes.list_type') and attributes.list_type neq 0>
		S.STOCK_CODE,
		S.PRODUCT_NAME,
		S.PROPERTY,
	</cfif>
	<cfif isdefined("attributes.instution") and attributes.instution eq 1>
		SL.DEPARTMENT_ID,
		SL.LOCATION_ID,
	</cfif>
		STOCKS_ROW.PRODUCT_ID
	<cfif isdefined('attributes.list_type') and attributes.list_type eq 2>
		,SPECT_VAR_ID
	</cfif>
	<cfif isdefined("is_dept_show") and is_dept_show eq 1>
		,STOCKS_ROW.STORE
		,STOCKS_ROW.STORE_LOCATION
	</cfif>
	FROM     
  		STOCKS_ROW    
	<cfif isdefined("attributes.instution") and attributes.instution eq 1>
		,#dsn_alias#.STOCKS_LOCATION SL
	</cfif>
	<cfif isdefined('attributes.list_type') and attributes.list_type neq 0>
		,#dsn3_alias#.STOCKS S
	</cfif>
	WHERE
   <!--- <cfif is_show_project eq 1> 
    	SG.STOCK_ID = S.STOCK_ID AND 
        SG.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
    </cfif>--->
	<cfif isDefined('attributes.stock_id') and len(attributes.stock_id) and isdefined('attributes.list_type') and attributes.list_type neq 0>
		STOCKS_ROW.STOCK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.stock_id#">
	<cfelse>
		STOCKS_ROW.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
	</cfif>
	<cfif isdefined("attributes.cat") and len(attributes.cat)>
		AND PROCESS_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat#">
	<cfelse>
		AND	PROCESS_TYPE IS NOT NULL
	</cfif>
	<cfif len(attributes.finishdate)>
		AND PROCESS_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
	</cfif>
     <cfif is_show_project eq 1> 
   		<cfif len(attributes.row_project_id)>
           AND
		(
		STOCKS_ROW.UPD_ID IN (
                                    SELECT
                                        SHIP_ID FROM SHIP S WHERE S.SHIP_TYPE = STOCKS_ROW.PROCESS_TYPE										 
										AND
                                       (PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_project_id#"> OR PROJECT_ID_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_project_id#">)
									   AND STOCKS_ROW.UPD_ID = S.SHIP_ID
                                    )
		OR
		STOCKS_ROW.UPD_ID IN ( 
									SELECT FIS_ID FROM STOCK_FIS SF  WHERE SF.FIS_TYPE=STOCKS_ROW.PROCESS_TYPE
										AND
                                       (PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_project_id#"> OR PROJECT_ID_IN = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.row_project_id#">)
									   AND STOCKS_ROW.UPD_ID = SF.FIS_ID
									)
								)
        </cfif>
   </cfif>
	<cfif isdefined("is_all_depts") and is_all_depts eq 1>
		<cfif len(attributes.department_id)>
			AND
			(
				(
					STOCK_IN > 0
					<cfif not len(attributes.location_id)>
						AND STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
					<cfelse>
						AND STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> AND STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">	
					</cfif>
				)
				OR (STOCK_IN = 0 AND STOCK_OUT > 0)
			)
			AND
			(
				(
					STOCK_OUT > 0
					<cfif not len(attributes.location_id)>
						AND STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
					<cfelse>
						AND STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#"> AND STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.location_id#">	
					</cfif>
				)
				OR (STOCK_OUT = 0 AND STOCK_IN > 0)
			)
		 </cfif>
	<cfelse>	
		<cfif len(attributes.department_id)>
			AND
			(
				(
					STOCK_IN > 0
					<cfif listlen(attributes.department_id,'-') eq 1>
						AND STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_id#">
					<cfelse>
						AND STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.department_id,'-')#"> AND STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.department_id,'-')#">	
					</cfif>
				)
				OR (STOCK_IN = 0 AND STOCK_OUT > 0)
			)
		 </cfif>	
		<cfif len(attributes.department_out)>
			AND
			(
				(
					STOCK_OUT > 0
					<cfif listlen(attributes.department_out,'-') eq 1>
						AND STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department_out#">
					<cfelse>
						AND STORE = <cfqueryparam cfsqltype="cf_sql_integer" value="#listfirst(attributes.department_out,'-')#"> AND STORE_LOCATION = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.department_out,'-')#">	
					</cfif>
				)
				OR (STOCK_OUT = 0 AND STOCK_IN > 0)
			)
		</cfif> 	
	</cfif>
	<cfif session.ep.isBranchAuthorization>
		AND STORE IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID IN(SELECT BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">))
	</cfif>
	<cfif isdefined("attributes.instution") and attributes.instution eq 1>
		AND STORE = SL.DEPARTMENT_ID
		AND STORE_LOCATION = SL.LOCATION_ID
		AND SL.BELONGTO_INSTITUTION = 0
	</cfif>
	<cfif isdefined('attributes.spec_main_id') and len(attributes.spec_name)>
		AND STOCKS_ROW.SPECT_VAR_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.spec_main_id#">
	</cfif>
	<cfif isdefined('attributes.list_type') and attributes.list_type neq 0>
		AND S.STOCK_ID = STOCKS_ROW.STOCK_ID
		AND S.PRODUCT_ID = STOCKS_ROW.PRODUCT_ID
	</cfif>
	GROUP BY
		UPD_ID,
	<cfif attributes.shelf_number eq 1>
		SHELF_NUMBER,
	</cfif>
	<cfif isDefined('attributes.stock_id') and isdefined('attributes.list_type') and attributes.list_type neq 0>
		STOCKS_ROW.STOCK_ID,
	</cfif>
	<cfif isdefined("attributes.instution") and attributes.instution eq 1>
		SL.DEPARTMENT_ID,
		SL.LOCATION_ID,
	</cfif>
	<cfif isdefined('attributes.list_type') and attributes.list_type neq 0>
		S.STOCK_CODE,
		S.PRODUCT_NAME,
		S.PROPERTY,
	</cfif>
		STOCKS_ROW.PRODUCT_ID,
		PROCESS_DATE,
		PROCESS_TYPE
	<cfif isdefined('attributes.list_type') and attributes.list_type eq 2>
		,SPECT_VAR_ID
	</cfif>
    <cfif isdefined('attributes.list_type') and attributes.list_type eq 3>
    	,LOT_NO
    </cfif>
	<cfif isdefined("is_dept_show") and is_dept_show eq 1>
		,STOCKS_ROW.STORE
		,STOCKS_ROW.STORE_LOCATION
	</cfif>
	ORDER BY    	
		PROCESS_DATE,
        STOCK_IN DESC,
        UPD_ID
</cfquery>

<cfquery name="GET_U" datasource="#dsn3#">
	SELECT
		MAIN_UNIT
	FROM
		PRODUCT_UNIT
	WHERE 
		PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
		PRODUCT_UNIT_STATUS = 1
</cfquery>
