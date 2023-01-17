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
	<cfif len(arguments.maxrows)>
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
	<cfreturn get_expense_item_>
</cffunction>
