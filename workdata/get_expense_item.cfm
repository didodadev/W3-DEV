<!--- 
	amac            : gelen expense_item_name parametresine göre EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME bilgisini getirmek
	parametre adi   : expense_item_name
	kullanim        : get_expense_item('işlemci') 
	Yazan           : B.Kuz
	Tarih           : 20080206
	
	Denizt20150824 where koşunda ACCOUNT_CODE alanına göre arama yapılması sağlandı
 --->
<cffunction name="get_expense_item" access="public" returnType="query" output="no">
	<cfargument name="expense_item_name" required="yes" type="string">
	<cfargument name="maxrows" required="yes" type="string" default="">
	<cfargument name="is_income" required="no" type="string" default="">
	<cfargument name="xml_expense_center_budget_item" required="no" type="string" default="">
	<cfargument name="expense_center_id" required="no" type="string" default="">	
		<cfif len(arguments.maxrows)>
			<cfif arguments.xml_expense_center_budget_item eq 1>
				<cfset is_accounting_budget = "">
				<cfset expense_item_id_list = "0">
				<cfset account_code_list = "0">
				<cfquery name="EXPENSE_ROW" datasource="#dsn2#">
					SELECT 
						EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID,
						EXPENSE_CENTER_ROW.ACCOUNT_ID,
						EXPENSE_CENTER_ROW.ACCOUNT_CODE,
						EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
						EXPENSE_CENTER.IS_ACCOUNTING_BUDGET
					FROM 
						EXPENSE_CENTER,
						EXPENSE_CENTER_ROW
						LEFT JOIN EXPENSE_ITEMS ON EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID = EXPENSE_ITEMS.EXPENSE_ITEM_ID
					WHERE 
						EXPENSE_CENTER.EXPENSE_ID = EXPENSE_CENTER_ROW.EXPENSE_ID AND 
						EXPENSE_CENTER_ROW.EXPENSE_ID = #arguments.expense_center_id#
					GROUP BY
						EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID,
						EXPENSE_CENTER_ROW.ACCOUNT_ID,
						EXPENSE_CENTER_ROW.ACCOUNT_CODE,
						EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
						EXPENSE_CENTER.IS_ACCOUNTING_BUDGET					
				</cfquery>
				<cfif EXPENSE_ROW.recordcount and len(EXPENSE_ROW.IS_ACCOUNTING_BUDGET)>
					<cfset is_accounting_budget = EXPENSE_ROW.IS_ACCOUNTING_BUDGET>
					<cfset expense_item_id_list = valuelist(EXPENSE_ROW.EXPENSE_ITEM_ID,',')>
					<cfset account_code_list = valuelist(EXPENSE_ROW.ACCOUNT_CODE,',')>
				</cfif>
				<cfquery name="GET_EXPENSE_ITEM_" datasource="#DSN2#" maxrows="#arguments.maxrows#">
					SELECT
						EXPENSE_ITEM_ID,
						EXPENSE_ITEM_NAME,
						ACCOUNT_CODE,
						EXPENSE_CAT_NAME,
						EXPENSE_CAT_ID,
						TAX_CODE				
					FROM
						EXPENSE_ITEMS
						LEFT JOIN EXPENSE_CATEGORY ON EXPENSE_CATEGORY.EXPENSE_CAT_ID = EXPENSE_ITEMS.EXPENSE_CATEGORY_ID
					WHERE
						IS_ACTIVE=1
						<cfif len(is_accounting_budget)>
							<cfif is_accounting_budget eq 0>
								<cfif len(expense_item_id_list)>
									AND EXPENSE_ITEM_ID IN (#expense_item_id_list#)
									AND EXPENSE_ITEM_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_item_name#%">
								</cfif>
							<cfelseif is_accounting_budget eq 1>
								<cfif len(account_code_list)>
									AND (
										<cfloop list="#account_code_list#" delimiters="," index="_account_code_">					
											(
												EI.ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#_account_code_#"> OR EI.ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#_account_code_#.%">
											)
											<cfif _account_code_ neq listlast(account_code_list,',') and listlen(account_code_list,',') gte 1> OR </cfif>
										</cfloop>
										)
								</cfif>
							</cfif>
						<cfelse>
							AND 1 = 2
						</cfif>
						ORDER BY
							EXPENSE_ITEM_NAME
				</cfquery>
			<cfelse>
				<cfquery name="GET_EXPENSE_ITEM_" datasource="#DSN2#" maxrows="#arguments.maxrows#">
					SELECT
						EXPENSE_ITEM_ID,
						EXPENSE_ITEM_NAME,
						ACCOUNT_CODE,
						EXPENSE_CAT_NAME,
						EXPENSE_CAT_ID,
						TAX_CODE			
					FROM
						EXPENSE_ITEMS
						LEFT JOIN EXPENSE_CATEGORY ON EXPENSE_CATEGORY.EXPENSE_CAT_ID = EXPENSE_ITEMS.EXPENSE_CATEGORY_ID
					WHERE
						IS_ACTIVE=1 AND
					<cfif isDefined("arguments.is_income") and arguments.is_income eq 1>
						INCOME_EXPENSE = 1 AND
					<cfelseif isDefined("arguments.is_income") and arguments.is_income eq 0>
						IS_EXPENSE = 1 AND
					<cfelse>
						EXPENSE_ITEM_ID IS NOT NULL AND
					</cfif>		
						EXPENSE_ITEM_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_item_name#%"> OR 
						ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_item_name#%">
					ORDER BY
						EXPENSE_ITEM_NAME
				</cfquery>
			</cfif>
		<cfelse>
			<cfif arguments.xml_expense_center_budget_item eq 1>
				<cfset is_accounting_budget = "">
				<cfset expense_item_id_list = "0">
				<cfset account_code_list = "0">
				<cfquery name="EXPENSE_ROW" datasource="#dsn2#">
					SELECT 
						EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID,
						EXPENSE_CENTER_ROW.ACCOUNT_ID,
						EXPENSE_CENTER_ROW.ACCOUNT_CODE,
						EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
						EXPENSE_CENTER.IS_ACCOUNTING_BUDGET
					FROM 
						EXPENSE_CENTER,
						EXPENSE_CENTER_ROW
						LEFT JOIN EXPENSE_ITEMS ON EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID = EXPENSE_ITEMS.EXPENSE_ITEM_ID
					WHERE 
						EXPENSE_CENTER.EXPENSE_ID = EXPENSE_CENTER_ROW.EXPENSE_ID AND 
						EXPENSE_CENTER_ROW.EXPENSE_ID = #arguments.expense_center_id#
					GROUP BY
						EXPENSE_CENTER_ROW.EXPENSE_ITEM_ID,
						EXPENSE_CENTER_ROW.ACCOUNT_ID,
						EXPENSE_CENTER_ROW.ACCOUNT_CODE,
						EXPENSE_ITEMS.EXPENSE_ITEM_NAME,
						EXPENSE_CENTER.IS_ACCOUNTING_BUDGET					
				</cfquery>
				<cfif EXPENSE_ROW.recordcount and len(EXPENSE_ROW.IS_ACCOUNTING_BUDGET)>
					<cfset is_accounting_budget = EXPENSE_ROW.IS_ACCOUNTING_BUDGET>
					<cfset expense_item_id_list = valuelist(EXPENSE_ROW.EXPENSE_ITEM_ID,',')>
					<cfset account_code_list = valuelist(EXPENSE_ROW.ACCOUNT_CODE,',')>
				</cfif>
				<cfquery name="GET_EXPENSE_ITEM_" datasource="#DSN2#" maxrows="#arguments.maxrows#">
					SELECT
						EXPENSE_ITEM_ID,
						EXPENSE_ITEM_NAME,
						ACCOUNT_CODE,
						EXPENSE_CAT_NAME,
						EXPENSE_CAT_ID,
						TAX_CODE				
					FROM
						EXPENSE_ITEMS
						LEFT JOIN EXPENSE_CATEGORY ON EXPENSE_CATEGORY.EXPENSE_CAT_ID = EXPENSE_ITEMS.EXPENSE_CATEGORY_ID
					WHERE
						IS_ACTIVE=1
						<cfif len(is_accounting_budget)>
							<cfif is_accounting_budget eq 0>
								<cfif len(expense_item_id_list)>
									AND EXPENSE_ITEM_ID IN (#expense_item_id_list#)
									AND EXPENSE_ITEM_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_item_name#%">
								</cfif>
							<cfelseif is_accounting_budget eq 1>
								<cfif len(account_code_list)>
									AND (
										<cfloop list="#account_code_list#" delimiters="," index="_account_code_">					
											(
												EI.ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#_account_code_#"> OR EI.ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#_account_code_#.%">
											)
											<cfif _account_code_ neq listlast(account_code_list,',') and listlen(account_code_list,',') gte 1> OR </cfif>
										</cfloop>
										)
								</cfif>
							</cfif>
						<cfelse>
							AND 1 = 2
						</cfif>
						ORDER BY
							EXPENSE_ITEM_NAME
				</cfquery>
			<cfelse>
				<cfquery name="GET_EXPENSE_ITEM_" datasource="#DSN2#">
					SELECT
						EXPENSE_ITEM_ID,
						EXPENSE_ITEM_NAME,
						ACCOUNT_CODE,
						EXPENSE_CAT_NAME,
						EXPENSE_CAT_ID,
						TAX_CODE				
					FROM
						EXPENSE_ITEMS
						LEFT JOIN EXPENSE_CATEGORY ON EXPENSE_CATEGORY.EXPENSE_CAT_ID = EXPENSE_ITEMS.EXPENSE_CATEGORY_ID
					WHERE
						IS_ACTIVE=1 AND
					<cfif isDefined("arguments.is_income") and arguments.is_income eq 1>
						INCOME_EXPENSE = 1 AND
					<cfelseif isDefined("arguments.is_income") and arguments.is_income eq 0>
						IS_EXPENSE = 1 AND
					<cfelse>
						EXPENSE_ITEM_ID IS NOT NULL AND
					</cfif>		
						EXPENSE_ITEM_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_item_name#%"> OR
						ACCOUNT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.expense_item_name#%">
					ORDER BY
						EXPENSE_ITEM_NAME
				</cfquery>
			</cfif>
		</cfif>
	<cfreturn get_expense_item_>
</cffunction>
