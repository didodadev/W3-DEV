<!---
	Autocomplete için yapıldı fiziki varlıkları listeler SM 20091028
--->
<cffunction name="get_assetp_autocomplete" access="public" returnType="query" output="no">
	<cfargument name="keyword" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="">
    <cfargument name="select_list" required="no" type="string" default=""><!---Fiziki Varlıklar,Araçlar ve It varlıklar ayıracı için--->
	<cfargument name="is_expense_control" required="no" type="string" default="0">
    <cfif len(arguments.select_list)>
        <cfquery name="get_catid" datasource="#dsn#">
            <cfloop from="1" to="#listlen(arguments.select_list)#" index="i">
                SELECT 
                    ASSETP_CATID 
                FROM 
                    ASSET_P_CAT 
                WHERE
                
				<cfif ListFind(arguments.select_list,1,',')><!---Fiziki Varlıklar --->
                    MOTORIZED_VEHICLE <>1 AND IT_ASSET<>1
                </cfif>
                <cfif ListFind(arguments.select_list,2,',')><!---Araçlar ---->
                    MOTORIZED_VEHICLE =1
                </cfif>
                <cfif ListFind(arguments.select_list,3,',')><!---IT varlıklar--->
                    IT_ASSET =1
                </cfif>
                <cfif i neq listlen(arguments.select_list)>
                    UNION ALL
                </cfif>
            </cfloop>
         </cfquery>
         <cfset list_catid=valuelist(get_catid.ASSETP_CATID,',')>
    </cfif>
	<cfif len(arguments.maxrows)>
		<cfquery name="get_Assetp" datasource="#dsn#" maxrows="#arguments.maxrows#">
			SELECT
				ASSET_P.ASSETP,
				ASSET_P.ASSETP_ID,			
				ASSET_P.DEPARTMENT_ID,
				ASSET_P.DEPARTMENT_ID2,
				ASSET_P.BRAND_TYPE_ID,
				ASSET_P.MAKE_YEAR,
				ASSET_P.FUEL_TYPE,
				ASSET_P.BRAND_TYPE_ID,
				EP.EMPLOYEE_NAME +' '+EP.EMPLOYEE_SURNAME EMP_NAME,
				EP.EMPLOYEE_ID,
				<cfif arguments.is_expense_control eq 1>
					EIOP.EXPENSE_CENTER_ID,
					EIOP.EXPENSE_CODE_NAME,
				</cfif>
                'employee' AS MEMBER_TYPE,
				'' AS COMPANY_NAME
			FROM
				EMPLOYEE_POSITIONS EP,
				<cfif arguments.is_expense_control eq 1>
					EMPLOYEES_IN_OUT EIO,
					EMPLOYEES_IN_OUT_PERIOD EIOP,
				</cfif>
				ASSET_P
			WHERE
				ASSET_P.POSITION_CODE = EP.POSITION_CODE AND
				<cfif arguments.is_expense_control eq 1>
					EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
					EIO.FINISH_DATE IS NULL AND 
					EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND
					EIOP.PERIOD_ID = #session.ep.period_id# AND
				</cfif>
				ASSET_P.STATUS = 1
				AND ASSET_P.DEPARTMENT_ID2 IN(
												SELECT
													D.DEPARTMENT_ID
												FROM
													DEPARTMENT D
												WHERE
													D.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) 
											)
				<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
					AND ASSET_P.ASSETP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%">
				</cfif>
                <cfif isdefined("list_catid") and len(list_catid)>
                	AND ASSET_P.ASSETP_CATID IN (#list_catid#)
                </cfif>
			ORDER BY
				ASSET_P.ASSETP
		</cfquery>
	<cfelse>
		<cfquery name="get_Assetp" datasource="#dsn#">
			SELECT
				ASSET_P.ASSETP,
				ASSET_P.ASSETP_ID,			
				ASSET_P.DEPARTMENT_ID,
				ASSET_P.DEPARTMENT_ID2,
				ASSET_P.BRAND_TYPE_ID,
				ASSET_P.MAKE_YEAR,
				ASSET_P.FUEL_TYPE,
				ASSET_P.BRAND_TYPE_ID,
				EP.EMPLOYEE_NAME +' '+EP.EMPLOYEE_SURNAME EMP_NAME,
				EP.EMPLOYEE_ID,
				<cfif arguments.is_expense_control eq 1>
					EIOP.EXPENSE_CENTER_ID,
					EIOP.EXPENSE_CODE_NAME,
				</cfif>
                'employee' AS MEMBER_TYPE,
				'' AS COMPANY_NAME
			FROM
				EMPLOYEE_POSITIONS EP,
				<cfif arguments.is_expense_control eq 1>
					EMPLOYEES_IN_OUT EIO,
					EMPLOYEES_IN_OUT_PERIOD EIOP,
				</cfif>
				ASSET_P
			WHERE			
				ASSET_P.POSITION_CODE = EP.POSITION_CODE AND
				<cfif arguments.is_expense_control eq 1>
					EIO.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
					EIO.FINISH_DATE IS NULL AND 
					EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND
					EIOP.PERIOD_ID = #session.ep.period_id# AND
				</cfif>
				ASSET_P.STATUS = 1
				AND ASSET_P.DEPARTMENT_ID2 IN(
												SELECT
													D.DEPARTMENT_ID
												FROM
													DEPARTMENT D
												WHERE
													D.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#) 
											)
				<cfif isDefined("arguments.keyword") and len(arguments.keyword)>
					AND ASSET_P.ASSETP LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.keyword#%">
				</cfif>
                <cfif isdefined("list_catid") and len(list_catid)>
                	AND ASSET_P.ASSETP_CATID IN (#list_catid#)
                </cfif>
			ORDER BY
				ASSET_P.ASSETP
		</cfquery>
	</cfif>
	<cfreturn get_Assetp>
</cffunction>

