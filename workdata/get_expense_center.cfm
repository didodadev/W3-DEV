<!--- 
	amac            : gelen expense_center_name parametresine göre EXPENSE_ID,EXPENSE bilgisini getirmek
	parametre adi   : expense_center_name
	kullanim        : get_expense_center('iletisim') 
	Yazan           : B.Kuz
	Tarih           : 20080422
	Not				: Gerekirse subelerde kullanimi farklilasabilir. Parametre gonderilmeli o zaman
 --->
<cffunction name="get_expense_center" access="public" returnType="query" output="no">
	<cfargument name="expense_center_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="-1">
	<cfargument name="is_store_module" required="no" type="string" default="0">
	<cfargument name="x_authorized_branch_department" required="no" type="string" default=""><!--- Şube yetkisine göre masraf merkezi gelsin mk 02122019 --->
	<cfargument name="xml_expense_center_hierarchy" required="no" type="string" default=""><!--- XML'e bağlı olarak Üst masraf merkezi gelsin mk 04032021 --->

	<!--- <cfif len(arguments.maxrows)> --->
		<cfquery name="get_hierarcy" datasource="#dsn2#">
			SELECT 
				D.HIERARCHY_DEP_ID 
			FROM 
				#dsn_alias#.DEPARTMENT D,
				#dsn_alias#.EMPLOYEE_POSITIONS EP 
			WHERE 
				EP.DEPARTMENT_ID = D.DEPARTMENT_ID
				AND POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
		</cfquery>
		<cfif get_hierarcy.recordcount and listlen(get_hierarcy.HIERARCHY_DEP_ID,'.') gt 1>
			<cfset hierarcy_id_list = valuelist(get_hierarcy.HIERARCHY_DEP_ID,',')>
			<cfset up_dep=ListGetAt(hierarcy_id_list,evaluate("#listlen(hierarcy_id_list,".")#-1"),".") >	
		</cfif>
		<cfquery name="GET_EXPENSE_CENTER" datasource="#DSN2#" maxrows="#arguments.maxrows#">
			SELECT
				EXPENSE_ID,
				EXPENSE_CODE,
				EXPENSE
			FROM
				EXPENSE_CENTER
			WHERE
            	EXPENSE_ACTIVE=1 AND
				<cfif isdefined("arguments.xml_expense_center_hierarchy") and arguments.xml_expense_center_hierarchy eq 0>
					HIERARCHY IS NULL AND
				</cfif>		
				<cfif arguments.x_authorized_branch_department eq 1>
					(EXPENSE_BRANCH_ID IN(SELECT EP.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">) OR (EXPENSE_BRANCH_ID = -1))
					<cfif get_hierarcy.recordcount and listlen(get_hierarcy.HIERARCHY_DEP_ID,'.') gt 1>
						AND (EXPENSE_DEPARTMENT_ID IN 
							(	
								SELECT EP.DEPARTMENT_ID FROM #dsn_alias#.EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
								UNION ALL 
									SELECT 
										DEPARTMENT_ID 
									FROM
										#dsn_alias#.DEPARTMENT
									WHERE 
										DEPARTMENT_ID = #up_dep#
							) 
							OR ( EXPENSE_DEPARTMENT_ID = -1)
						)
					</cfif>
					AND
				<cfelseif arguments.is_store_module eq 1>
                    (EXPENSE_BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")# OR EXPENSE_BRANCH_ID IS NULL) AND
				</cfif>	
			(
				EXPENSE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_center_name#%"> OR
				EXPENSE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_center_name#%">
			)
			ORDER BY
				EXPENSE
		</cfquery>
	<!--- <cfelse>
		<cfquery name="GET_EXPENSE_CENTER" datasource="#DSN2#">
			SELECT
				EXPENSE_ID,
				EXPENSE_CODE,
				EXPENSE
			FROM
				EXPENSE_CENTER
			WHERE
			EXPENSE_ACTIVE=1 AND
			<cfif arguments.is_store_module eq 1>
                 EXPENSE_BRANCH_ID =#ListGetAt(session.ep.user_location,2,"-")# AND
            </cfif>
			(
				EXPENSE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_center_name#%"> OR
				EXPENSE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_center_name#%">
			)
			ORDER BY
				EXPENSE
		</cfquery>
	</cfif> --->
	<cfreturn get_expense_center>
</cffunction>
