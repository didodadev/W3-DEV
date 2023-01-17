<cfquery name="GET_EXPENSE_CAT" datasource="#dsn2#">
	SELECT 
	    EXPENSE_CAT_CODE 
	FROM 
	    EXPENSE_CATEGORY 
	WHERE
	    <cfif len(budget_cat_hierarchy)>
			EXPENSE_CAT_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#budget_cat_hierarchy#.#expense_cat_code#">
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
<cfif len(form.budget_cat_hierarchy)>
	<cfset yer = "#form.budget_cat_hierarchy#.#form.expense_cat_code#">
<cfelse>
	<cfset yer = form.expense_cat_code>
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
  <cftransaction>
	<cfquery name="ADD_EXPENSE_CAT" datasource="#dsn2#" result="MAX_ID">
		INSERT INTO 
			EXPENSE_CATEGORY
		(
			EXPENSE_CAT_NAME,
			IS_SUB_EXPENSE_CAT,
			EXPENSE_CAT_DETAIL,
            EXPENSE_CAT_CODE,
			EXPENCE_IS_HR,
			EXPENCE_IS_TRAINING,
			RECORD_EMP,
			RECORD_IP,
			RECORD_DATE
		)
		VALUES
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_cat_name#">,
			0,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.expense_cat_detail#">,
            <cfif isdefined("attributes.expense_cat_code") and len(attributes.expense_cat_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#yer#"><cfelse>NULL</cfif>,
			<cfif isDefined("attributes.expence_is_hr")>1,<cfelse>0,</cfif>
			<cfif isDefined("attributes.expence_is_training")>1,<cfelse>0,</cfif>
			#session.ep.userid#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			#now()#
		)
	</cfquery>
	<cfquery name="UPD_EXPENSE_CAT" datasource="#dsn2#">
		UPDATE 
			EXPENSE_CATEGORY 
		SET	
			IS_SUB_EXPENSE_CAT = 1,
			RECORD_EMP = #SESSION.EP.USERID#,
			RECORD_IP = '#CGI.REMOTE_ADDR#',
			RECORD_DATE = #now()#
		WHERE 
			EXPENSE_CAT_CODE = '#form.budget_cat_hierarchy#'
	</cfquery>
 </cftransaction>
</cflock>
<cfset attributes.actionId=MAX_ID.IDENTITYCOL/>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=budget.list_expense_cat&event=upd&cat_id=#attributes.actionId#</cfoutput>";
</script>
