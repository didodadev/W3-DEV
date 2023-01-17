<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
	SELECT 
	    EXPENSE_ITEM_CODE 
	FROM 
	    EXPENSE_ITEMS 
	WHERE
	    <cfif len(expense_cat)>
			EXPENSE_ITEM_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#expense_cat#.#expense_item_code#">
		<cfelse>
			EXPENSE_ITEM_CODE= <cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.expense_item_code#'>
		</cfif>
</cfquery>	
<cfif GET_EXPENSE_ITEM.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='44854.Bu Kod Kullanılmakta; Başka Kod Kullanınız'> !");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cfquery name="GET_EXPENSE_CATID" datasource="#dsn2#">
	SELECT 
	    EXPENSE_CAT_ID 
	FROM 
	    EXPENSE_CATEGORY 
	WHERE
		EXPENSE_CAT_CODE= <cfqueryparam cfsqltype="cf_sql_varchar" value='#form.expense_cat#'>
</cfquery>
<!--- hierarcyi belirle --->
<cfif len(form.expense_cat)>
	<cfset yer = "#form.expense_cat#.#form.expense_item_code#">
<cfelse>
	<cfset yer = form.expense_item_code>
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
  <cftransaction>
	<cfquery name="ADD_EXPENSE_ITEMS" datasource="#dsn2#" result="MAX_ID">
		INSERT INTO 
			EXPENSE_ITEMS
		(
			IS_ACTIVE,
			EXPENSE_CATEGORY_ID,
			EXPENSE_ITEM_NAME,
			EXPENSE_ITEM_DETAIL,
            EXPENSE_ITEM_CODE,
			ACCOUNT_CODE,			
			INCOME_EXPENSE,
			IS_EXPENSE,
			TAX_CODE,
			TAX_CODE_NAME,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
		)
		VALUES
		(
			<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
			<cfif len(attributes.expense_cat)>#GET_EXPENSE_CATID.EXPENSE_CAT_ID#,<cfelse>-2,</cfif>
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_item_name#">,
			<cfif len(attributes.expense_item_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_item_detail#"><cfelse>NULL</cfif>,
			<cfif isdefined("attributes.expense_item_code") and len(attributes.expense_item_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#yer#"><cfelse>NULL</cfif>,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_id#">,
			<cfif isdefined("attributes.income_expense")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.is_expense")>1<cfelse>0</cfif>,
			<cfif isdefined("attributes.tax_code") and len(attributes.tax_code)>'#listfirst(attributes.tax_code,';')#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.tax_code") and len(attributes.tax_code)>'#listlast(attributes.tax_code,';')#'<cfelse>NULL</cfif>,
			#session.ep.userid#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			#now()#
		)
	</cfquery>
  </cftransaction>
</cflock>
<cfset attributes.actionId=MAX_ID.IDENTITYCOL />

<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=budget.list_expense_item</cfoutput>";
</script>


