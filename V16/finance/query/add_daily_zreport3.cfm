<cfif isdefined("form.is_cash") and (form.is_cash eq 1)><!--- kasa seçili ise --->
	<cfloop from="1" to="#kur_say#" index="k">
	  <cfif isdefined("kasa#k#") and isdefined("cash_amount#k#") and (evaluate('cash_amount#k#') gt 0)>
		<cfquery name="get_cash_code" datasource="#dsn2#">
			SELECT CASH_ACC_CODE,BRANCH_ID FROM CASH WHERE CASH_ID=#evaluate("kasa#k#")#
		</cfquery>
		<cfif len(get_cash_code.BRANCH_ID)> <!--- carici ve muhasebecide kullanılıyor --->
			<cfset cash_branch_id = get_cash_code.BRANCH_ID>
		<cfelse>
			<cfset cash_branch_id = ''>
		</cfif>
		<cfquery name="ADD_CASH_ACTION" datasource="#dsn2#">
			INSERT INTO 
				CASH_ACTIONS
			(
				CASH_ACTION_TO_CASH_ID,
				ACTION_TYPE,
				ACTION_TYPE_ID,
				BILL_ID,
				CASH_ACTION_VALUE,
				CASH_ACTION_CURRENCY_ID,				
				ACTION_DATE,
				ACTION_DETAIL,
				IS_PROCESSED,
				PAPER_NO,
				IS_ACCOUNT,
				IS_ACCOUNT_TYPE,
				RECORD_EMP,
				RECORD_IP,
				RECORD_DATE,
				PROCESS_CAT,
				ACTION_VALUE,
				ACTION_CURRENCY_ID
			<cfif len(session.ep.money2)>
				,ACTION_VALUE_2
				,ACTION_CURRENCY_ID_2
			</cfif>
			)
			VALUES
			(
				#evaluate("kasa#k#")#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="Z RAPORU KAPAMA İŞLEMİ">,
				69,
				#get_invoice_id.max_id#,
				#evaluate('cash_amount#k#')#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#wrk_eval('currency_type#k#')#">,
				#attributes.invoice_date#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="Z RAPORU KAPAMA İŞLEMİ">,
				<cfif is_account>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.INVOICE_NUMBER#">,
				<cfif is_account eq 1>
					1,
					11,
				<cfelse>
					0,
					11,
				</cfif>
				#SESSION.EP.USERID#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
				#NOW()#,
				0,
				#evaluate('system_cash_amount#k#')#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money#">
				<cfif len(session.ep.money2)>
					,#wrk_round(evaluate('system_cash_amount#k#')/attributes.currency_multiplier,4)#
					,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.money2#">
				</cfif>
			)
		</cfquery>
		<cfquery name="GET_ACT_ID" datasource="#dsn2#">
			SELECT MAX(ACTION_ID) AS ACT_ID	FROM CASH_ACTIONS
		</cfquery>
		<cfset act_id=get_act_id.ACT_ID>
		<cfquery name="UPD_INVOICE_CASH" datasource="#dsn2#">
			INSERT INTO INVOICE_CASH_POS
				(
				INVOICE_ID,
				CASH_ID,
				KASA_ID
				)
			VALUES
				(
				#get_invoice_id.max_id#,
				#ACT_ID#,
				#evaluate("kasa#k#")#
				)
		</cfquery>
	 </cfif>
	</cfloop>
	<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
		UPDATE INVOICE SET IS_ACCOUNTED=#is_account# WHERE INVOICE_ID=#get_invoice_id.max_id#
	</cfquery> 
<cfelse>
	<cfquery name="UPD_INVOICE_ACC" datasource="#dsn2#">
		UPDATE INVOICE SET IS_ACCOUNTED=0 WHERE INVOICE_ID=#get_invoice_id.max_id#
	</cfquery>
</cfif>
