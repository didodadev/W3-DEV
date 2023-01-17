<cfquery name="get_lang" datasource="#dsn#">
	SELECT
		ITEM,
		LANGUAGE
	FROM 
		SETUP_LANGUAGE_INFO
	WHERE
		UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#"> AND
		COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="EXPENSE_ITEM_NAME"> AND
		TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="EXPENSE_ITEMS"> AND
		LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
</cfquery>
<cfif get_lang.recordcount>
	<cfquery name="upd_" datasource="#dsn#">
    	UPDATE 
			SETUP_LANGUAGE_INFO 
		SET 
			ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_item_name#">
		WHERE 
			UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_item_id#"> AND
			COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="EXPENSE_ITEM_NAME"> AND
			TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="EXPENSE_ITEMS"> AND
			LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
    </cfquery>
</cfif>
<cfquery name="GET_EXPENSE_ITEM" datasource="#dsn2#">
	SELECT 
	    EXPENSE_ITEM_CODE 
	FROM 
	    EXPENSE_ITEMS 
	WHERE
		EXPENSE_ITEM_ID <> #attributes.expense_item_id#
	    <cfif len(attributes.expense_cat)>
			AND EXPENSE_ITEM_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_cat#.#attributes.expense_item_code#">
		<cfelse>
			AND EXPENSE_ITEM_CODE= <cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.expense_item_code#'>
		</cfif>
</cfquery>	
<cfif GET_EXPENSE_ITEM.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='44854.Bu Kod KullanÄ±lmakta; BaÅŸka Kod KullanÄ±nÄ±z'> !");
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
	<cfquery name="UPD_EXPENSE_ITEMS" datasource="#dsn2#">
		UPDATE 
			EXPENSE_ITEMS
		SET
			IS_ACTIVE = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
			EXPENSE_CATEGORY_ID = #GET_EXPENSE_CATID.EXPENSE_CAT_ID#,
			EXPENSE_ITEM_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_item_name#">,
			EXPENSE_ITEM_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_item_detail#">,
            EXPENSE_ITEM_CODE = <cfif isdefined("attributes.expense_item_code") and len(attributes.expense_item_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#yer#"><cfelse>NULL</cfif>,
			ACCOUNT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_id#">,
			INCOME_EXPENSE = <cfif isdefined("attributes.income_expense")>1<cfelse>0</cfif>,
			IS_EXPENSE = <cfif isdefined("attributes.is_expense")>1<cfelse>0</cfif>,
			TAX_CODE = <cfif isdefined("attributes.tax_code") and len(attributes.tax_code)>'#listfirst(attributes.tax_code,';')#'<cfelse>NULL</cfif>,
			TAX_CODE_NAME = <cfif isdefined("attributes.tax_code") and len(attributes.tax_code)>'#listlast(attributes.tax_code,';')#'<cfelse>NULL</cfif>,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			UPDATE_DATE = #now()#
		WHERE
			EXPENSE_ITEM_ID = #attributes.expense_item_id#	
	</cfquery>
  </cftransaction>
</cflock>

<cfset attributes.actionId=attributes.item_id/>

<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=budget.list_expense_item</cfoutput>";
</script>
