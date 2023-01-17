<cfif form.active_period neq session.ep.period_id>
	<script type="text/javascript">
		alert("Sayfa diğer şirkette açıldığı için  için güncelleme işlemi yapılamaktadır !");
		window.location.href="<cfoutput>#request.self#?fuseaction=bank.list_bank_account</cfoutput>";
	</script>
	<cfabort>
</cfif>
<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		<cfif isdefined("attributes.is_civil")>
			<cfquery name="UPD_ACCOUNT2" datasource="#dsn3#"> <!--- Bu blok KAMU (IS_CIVIL) olarak secilmisse digerlerinin IS_CIVIL durumunu iptal eder. --->
				UPDATE ACCOUNTS SET IS_CIVIL = 0 WHERE ACCOUNT_ID  NOT IN (#attributes.id#)
			</cfquery>	
		</cfif> 
		<cfquery name="UPD_ACCOUNT" datasource="#dsn3#">
			UPDATE 
				ACCOUNTS
			SET
				ACCOUNT_STATUS = <cfif isdefined("attributes.status")>1<cfelse>0</cfif>,
				ACCOUNT_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_type#">,
				ACCOUNT_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_name#">,
				ACCOUNT_OWNER_CUSTOMER_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_owner_customer_no#">,
				ACCOUNT_CREDIT_LIMIT = <cfif len(account_credit_limit)><cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(account_credit_limit)#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
				<cfif isDefined('attributes.account_currency_id')>ACCOUNT_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_currency_id#">,</cfif>
				ACCOUNT_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_no#">,
				ACCOUNT_ACC_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#account_id#">,
				V_CHEQUE_ACC_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.v_account_id#">,
				CHEQUE_EXCHANGE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.exchange_code_id#">,
				VOUCHER_EXCHANGE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.v_exchange_code_id#">,
				ACCOUNT_BRANCH_ID = #ListFirst(attributes.account_branch_id,';')#,
				ACCOUNT_ORDER_CODE = <cfif isdefined("attributes.bank_order")><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.bank_order#">,<cfelse>NULL,</cfif>
				IS_INTERNET = <cfif isdefined("attributes.is_internet")>1<cfelse>0</cfif>,
				ACCOUNT_DETAIL = <cfif len(attributes.account_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_detail#"><cfelse>NULL</cfif>,	
				BANK_CODE = <cfif len(attributes.bank_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.bank_code#"><cfelse>NULL</cfif>,	
				BRANCH_CODE = <cfif len(attributes.branch_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_code#"><cfelse>NULL</cfif>,	
				CHEQUE_GUARANTY_CODE = <cfif len(attributes.guaranty_code_id) and len(attributes.guaranty_code_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.guaranty_code_id#"><cfelse>NULL</cfif>,
				VOUCHER_GUARANTY_CODE = <cfif len(attributes.v_guaranty_code_id) and len(attributes.v_guaranty_code_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.v_guaranty_code_id#"><cfelse>NULL</cfif>,
				IS_PARTNER = <cfif isdefined("attributes.is_partner")>1<cfelse>0</cfif>,
				IS_PUBLIC = <cfif isdefined("attributes.is_public")>1<cfelse>0</cfif>,
				IS_CIVIL = <cfif isdefined("attributes.is_civil")>1<cfelse>0</cfif>,
				UPDATE_DATE = #now()#,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_IP =	<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				PROTESTOLU_SENETLER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.protestolu_senetler_id#">,
				KARSILIKSIZ_CEKLER_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.karsiliksiz_cekler_id#">
			WHERE
				ACCOUNT_ID = #attributes.id#	
		</cfquery>
		<cfquery name="DEL_ACCOUNT_BRANCH" datasource="#dsn3#">
			DELETE FROM ACCOUNTS_BRANCH WHERE ACCOUNT_ID = #attributes.id#
		</cfquery>
		<cfloop from="1" to="#listlen(attributes.branch_id)#" index="brnch_index">
			<cfquery name="ADD_ACCOUNT_BRANCH" datasource="#dsn3#">
				INSERT INTO
					ACCOUNTS_BRANCH
					(
						ACCOUNT_ID,
						BRANCH_ID
					)
					VALUES
					(
						#attributes.id#,
						#listgetat(attributes.branch_id,brnch_index)#
					)
			</cfquery>
		</cfloop>
	</cftransaction>
</cflock>

<script type="text/javascript">
window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_account&event=upd&id=#attributes.id#</cfoutput>";
</script>