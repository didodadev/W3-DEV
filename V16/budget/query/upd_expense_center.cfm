<cfif len(head_exp_code)>
	<cfset EXPENSE_CODE=head_exp_code & "." & exp_code >
<cfelse>
	<cfset EXPENSE_CODE= exp_code >
	<cfset head_exp_code="">
</cfif>
<cfset url_string = "">
<cfif isdefined("field_id")>
	<cfset url_string = "#url_string#&field_id=#field_id#">
</cfif>
<cfif isdefined("field_name")>
	<cfset url_string = "#url_string#&field_name=#field_name#">
</cfif>
<cfif isdefined("code")>
	<cfset url_string = "#url_string#&code=#code#">
</cfif>
<cfquery name="GET_EXPENSE" datasource="#iif(fusebox.use_period,'dsn2','dsn')#">
	SELECT EXPENSE_CODE FROM EXPENSE_CENTER WHERE EXPENSE_ID <> #attributes.expense_id# AND EXPENSE_CODE='#EXPENSE_CODE#'
</cfquery>	
<cfif GET_EXPENSE.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='20.Girdiğiniz Masraf/Gelir Merkezi Kodu Kullanılıyor'>");
		window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
	</script>
	<cfabort>
</cfif>
<cflock name="#CreateUUID()#" timeout="60">
  <cftransaction>
	<cfquery name="UPD_EXPENSE" datasource="#iif(fusebox.use_period,'dsn2','dsn')#">
		UPDATE
			EXPENSE_CENTER 
		SET
			EXPENSE_CODE = <cfif len(head_exp_code) or len(exp_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#EXPENSE_CODE#">,<cfelse>NULL,</cfif>
			EXPENSE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#EXPENSE_NAME#">,
			DETAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#DETAIL#">,
			RESPONSIBLE1 = <cfif len(pos_code_text1) and len(ATTRIBUTES.POS_CODE1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.POS_CODE1#">,<cfelse>NULL,</cfif>
			RESPONSIBLE2 = <cfif len(pos_code_text2) and len(ATTRIBUTES.POS_CODE2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.POS_CODE2#">,<cfelse>NULL,</cfif>
			RESPONSIBLE3 = <cfif len(pos_code_text3) and len(ATTRIBUTES.POS_CODE3)><cfqueryparam cfsqltype="cf_sql_varchar" value="#ATTRIBUTES.POS_CODE3#">,<cfelse>NULL,</cfif>
			EXPENSE_ACTIVE = <cfif isdefined("attributes.active") and attributes.active eq 1>1<cfelse>0</cfif>,
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_EMP_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
			UPDATE_DATE = #NOW()#,
			IS_PRODUCTION = <cfif isdefined("attributes.is_production")>1,<cfelse>0,</cfif>
			COMPANY_ID = <cfif len(attributes.company_id)>#attributes.company_id#,<cfelse>null,</cfif>
			ACTIVITY_ID = <cfif len(attributes.activity_id)>#attributes.activity_id#,<cfelse>null,</cfif>
			WORKGROUP_ID = <cfif len(attributes.workgroup_id)>#attributes.workgroup_id#,<cfelse>null,</cfif>
			EXPENSE_BRANCH_ID = <cfif len(attributes.branch)>#attributes.branch#<cfelse>null</cfif>,
			EXPENSE_DEPARTMENT_ID = <cfif len(attributes.department)>#attributes.department#<cfelse>null</cfif>,
			IS_GENERAL = <cfif isdefined('attributes.is_general')>1<cfelse>0</cfif>,
			IS_ACCOUNTING_BUDGET = <cfif isdefined("attributes.is_muhasebe_") and len(attributes.is_muhasebe_) >1<cfelseif isdefined("attributes.is_butce_") and len(attributes.is_butce_)>0<cfelse>null</cfif>
		WHERE
			EXPENSE_ID = #EXPENSE_ID#
	</cfquery>
	<cfif HIERARCHY eq 1>
		<cfset bas = len(form.old_expense)+1>
		<cfquery name="SUB_EXPENSES" datasource="#iif(fusebox.use_period,'dsn2','dsn')#">
			UPDATE
				EXPENSE_CENTER
			SET
				EXPENSE_CODE = #sql_unicode()#'#EXPENSE_CODE#.' + RIGHT(EXPENSE_CODE,LEN(EXPENSE_CODE)-#BAS#),
				EXPENSE_ACTIVE=<cfif isDefined("attributes.active") and attributes.active eq 1>1<cfelse>0</cfif>,
				UPDATE_EMP=#SESSION.EP.USERID#,
				UPDATE_EMP_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				UPDATE_DATE=#NOW()#	
			WHERE
				EXPENSE_CODE LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OLD_EXPENSE#.%">
		</cfquery>
	</cfif>
	<cfif len(head_exp_code)>
		<cfquery name="UPD_MAIN_EXPENSE" datasource="#iif(fusebox.use_period,'dsn2','dsn')#">
			UPDATE EXPENSE_CENTER SET HIERARCHY= 1 WHERE EXPENSE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#head_exp_code#">
		</cfquery>
	</cfif>
	<cfif isDefined("attributes.is_muhasebe_") or isDefined("attributes.is_butce_")>
		<cfquery name="DEL_EXPENSE_ROW" datasource="#dsn2#">
			DELETE FROM EXPENSE_CENTER_ROW WHERE EXPENSE_ID = #EXPENSE_ID#
		</cfquery>
		<cfif len(attributes.record_num) and attributes.record_num neq "">
			<cfloop from="1" to="#attributes.record_num#" index="i">
				<cfif isdefined("attributes.row_kontrol#i#") and evaluate("attributes.row_kontrol#i#")>
					<cfif (isDefined("attributes.is_muhasebe_") and len(evaluate("attributes.account_code#i#"))) or (isDefined("attributes.is_butce_") and len(evaluate("attributes.expense_item_name#i#")) and len(evaluate("attributes.account_code#i#")))>
						<cfquery name="ADD_EXPENSE_ROW" datasource="#dsn2#">
							INSERT 
							INTO 
								EXPENSE_CENTER_ROW 
								(
									EXPENSE_ID,
									EXPENSE_ITEM_ID,
									ACCOUNT_ID,
									ACCOUNT_CODE,
									RECORD_EMP,
									RECORD_DATE,
									RECORD_IP
								)		 
								VALUES 
								(
									#EXPENSE_ID#,
									<cfif isDefined("attributes.expense_item_name#i#") and len(evaluate("attributes.expense_item_name#i#"))>#evaluate("attributes.expense_item_id#i#")#<cfelse>NULL</cfif>,
									<cfif isDefined("attributes.account_id#i#") and len(evaluate("attributes.account_id#i#")) and len(evaluate("attributes.account_code#i#"))>'#wrk_eval("attributes.account_id#i#")#'<cfelse>NULL</cfif>,
									<cfif isDefined("attributes.account_code#i#") and len(evaluate("attributes.account_code#i#"))>'#wrk_eval("attributes.account_code#i#")#'<cfelse>NULL</cfif>,
									#session.ep.userid#,
									#now()#,
									'#cgi.REMOTE_ADDR#'
								)
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
	</cfif>	
 </cftransaction>
</cflock>
<script type="text/javascript">
	location.reload();
	wrk_opener_reload();
	window.close();
</script>
