<cfquery name="get_lang_name" datasource="#dsn#">
	SELECT
		ITEM,
		LANGUAGE
	FROM 
		SETUP_LANGUAGE_INFO
	WHERE
		UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#"> AND
		COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="EXPENSE_CAT_NAME"> AND
		TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="EXPENSE_CATEGORY"> AND
        LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
</cfquery>
<cfif get_lang_name.recordcount>
	<cfquery name="upd_" datasource="#dsn#">
    	UPDATE 
			SETUP_LANGUAGE_INFO 
		SET 
			ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_cat_name#"> 
		WHERE 
			UNIQUE_COLUMN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cat_id#"> AND 	
			COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="EXPENSE_CAT_NAME"> AND
			TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="EXPENSE_CATEGORY"> AND
			LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">
    </cfquery>
</cfif>
<cfquery name="GET_EXPENSE_CAT" datasource="#dsn2#">
	SELECT 
		EXPENSE_CAT_CODE 
	FROM 
		EXPENSE_CATEGORY 
	WHERE 
		EXPENSE_CAT_ID <> #attributes.expense_cat_id# AND  
		<cfif isdefined('form.budget_cat_hierarchy') and len(form.budget_cat_hierarchy)>
			EXPENSE_CAT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.budget_cat_hierarchy#.#expense_cat_code#">
		<cfelse>
			EXPENSE_CAT_CODE= <cfqueryparam cfsqltype="cf_sql_varchar" value='#attributes.expense_cat_code#'>
		</cfif>
</cfquery>	
<cfif GET_EXPENSE_CAT.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='44854.Bu Kod Kullanılmakta; Başka Kod Kullanınız'> !");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>
</cfif>
<!--- hierarcyi belirle --->
<cfif isdefined('form.budget_cat_hierarchy') and len(form.budget_cat_hierarchy)>
	<cfset yer = "#form.budget_cat_hierarchy#.#form.expense_cat_code#">
<cfelse>
	<cfset yer = form.expense_cat_code>
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
  <cftransaction>
	<cfquery name="GET_ALT_CODE" datasource="#dsn2#">
		SELECT 
			EXPENSE_CAT_CODE 
		FROM 
			EXPENSE_CATEGORY 
		WHERE 
		EXPENSE_CAT_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#yer#.%"> COLLATE SQL_Latin1_General_CP1_CI_AI
	</cfquery>
	<cfquery name="UPD_EXPENSE_CAT" datasource="#dsn2#">
		UPDATE
			EXPENSE_CATEGORY
		SET
			EXPENSE_CAT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_cat_name#">,
			EXPENSE_CAT_DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_cat_detail#">,
			IS_SUB_EXPENSE_CAT = <cfif GET_ALT_CODE.recordCount>1<cfelse>0</cfif>,
            EXPENSE_CAT_CODE = <cfif isdefined("attributes.expense_cat_code") and len(attributes.expense_cat_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#yer#"><cfelse>NULL</cfif>,
			EXPENCE_IS_HR = <cfif isDefined("attributes.expence_is_hr")>1,<cfelse>0,</cfif>
			EXPENCE_IS_TRAINING = <cfif isDefined("attributes.expence_is_training")>1,<cfelse>0,</cfif>
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			UPDATE_DATE = #now()#
		WHERE
			EXPENSE_CAT_ID = #attributes.expense_cat_id#
	</cfquery>	
	<cfif isdefined('form.budget_cat_hierarchy') and len(form.budget_cat_hierarchy)>
	<cfquery name="UPD_EXPENSE_CAT" datasource="#dsn2#">
		UPDATE 
			EXPENSE_CATEGORY 
		SET	
			IS_SUB_EXPENSE_CAT = 1,
			RECORD_EMP = #SESSION.EP.USERID#,
			RECORD_IP = '#CGI.REMOTE_ADDR#',
			RECORD_DATE = #now()#
		WHERE 
			EXPENSE_CAT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.budget_cat_hierarchy#">
	</cfquery>
	</cfif>
  </cftransaction>
</cflock>
<cfset attributes.actionId=attributes.cat_id/>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=budget.list_expense_cat&event=upd&cat_id=#attributes.expense_cat_id#</cfoutput>";
</script>

