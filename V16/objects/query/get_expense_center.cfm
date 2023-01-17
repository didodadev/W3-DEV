<cfif not isdefined("attributes.position_code") or (isdefined("attributes.position_code") and  not len(attributes.position_code)) or (isdefined("attributes.position_code") and  attributes.position_code eq 0)>
	<cfset attributes.position_code = session.ep.position_code>
</cfif>
<cfquery name="get_hierarcy" datasource="#iif(fusebox.use_period,"dsn2","dsn")#">
	SELECT 
		D.HIERARCHY_DEP_ID ,
		D.BRANCH_ID,
		EP.EMPLOYEE_ID
	FROM 
		#dsn_alias#.DEPARTMENT D,
		#dsn_alias#.EMPLOYEE_POSITIONS EP 
	WHERE 
		EP.DEPARTMENT_ID = D.DEPARTMENT_ID
		AND POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
</cfquery>
<cfif get_hierarcy.recordcount and listlen(get_hierarcy.HIERARCHY_DEP_ID,'.') gt 1>
	<cfset hierarcy_id_list = valuelist(get_hierarcy.HIERARCHY_DEP_ID,',')>
	<cfset up_dep=ListGetAt(hierarcy_id_list,evaluate("#listlen(hierarcy_id_list,".")#-1"),".") >	
</cfif>
<cfif isdefined("attributes.from_health") and isdefined("xml_get_expense_center") and xml_get_expense_center eq 0>
		<cfset allowance_expense_cmp = createObject("component","V16.myhome.cfc.allowance_expense") />
		<cfset get_in_out_id  = allowance_expense_cmp.GET_IN_OUT_ID(get_hierarcy.EMPLOYEE_ID)>
		<!---Çalışanın grup id'si varsa program akış parametrelerine gönderilir.---->
		<cfif len(get_in_out_id.PUANTAJ_GROUP_IDS)>
				<cfset attributes.group_id = get_in_out_id.PUANTAJ_GROUP_IDS>
		</cfif>
		<cfset attributes.sal_mon = month(now())>
		<cfset attributes.sal_year = year(now())>
		<CFSET attributes.branch_id =get_hierarcy.BRANCH_ID>
		<cfinclude template="/V16/hr/ehesap/query/get_program_parameter.cfm">
		<cfif isdefined("get_program_parameters.EXPENSE_CENTER_ID") and len(get_program_parameters.EXPENSE_CENTER_ID)>
			<cfset exp_id = get_program_parameters.EXPENSE_CENTER_ID>
		</cfif>
	<cfquery name="EXPENSE_CENTER" datasource="#iif(fusebox.use_period,"dsn2","dsn")#">
		SELECT
			*
		FROM
			EXPENSE_CENTER
		WHERE
			<cfif isdefined("exp_id") and len(exp_id)>
				 EXPENSE_ID =  #exp_id#
			<cfelse>
				1 = 0
			</cfif>
		ORDER BY
			EXPENSE_CODE
	</cfquery>
<cfelse>
	<cfquery name="EXPENSE_CENTER" datasource="#iif(fusebox.use_period,"dsn2","dsn")#">
		SELECT
			*
		FROM
			EXPENSE_CENTER
		WHERE
			1 = 1 AND
			EXPENSE_ACTIVE=1 
			<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
			AND (EXPENSE LIKE '%#attributes.keyword#%' OR EXPENSE_CODE LIKE '%#attributes.keyword#%')
			</cfif>
			<cfif isDefined("attributes.code") and len(attributes.code)>
			AND EXPENSE_CODE LIKE '#attributes.code#%'
			</cfif>
			<cfif isdefined("attributes.is_store_module") and len(attributes.is_store_module)>
			AND EXPENSE_BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
			</cfif>
			<cfif isdefined("xml_expense_center_hierarchy") and xml_expense_center_hierarchy eq 0>
				AND HIERARCHY IS NULL
			</cfif>
			<cfif isdefined("x_authorized_branch_department") and x_authorized_branch_department eq 1>
			AND (EXPENSE_BRANCH_ID IN (SELECT EP.BRANCH_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">) OR (EXPENSE_BRANCH_ID = -1))
			<cfif get_hierarcy.recordcount and listlen(get_hierarcy.HIERARCHY_DEP_ID,'.') gt 1>
				AND (EXPENSE_DEPARTMENT_ID IN 
					(	
						SELECT EP.DEPARTMENT_ID FROM #dsn_alias#.EMPLOYEE_POSITIONS EP WHERE EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.position_code#">
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
			</cfif>	
		ORDER BY
			EXPENSE_CODE
	</cfquery>
</cfif>