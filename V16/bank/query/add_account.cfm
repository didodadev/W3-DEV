<cflock name="#createUUID()#" timeout="20">
	<cftransaction>
		
		<cfquery name="ADD_ACCOUNT" datasource="#DSN3#" result="MAX_ID">
			INSERT INTO
				ACCOUNTS
			(
				ACCOUNT_STATUS,
				ACCOUNT_TYPE,
				ACCOUNT_NAME,
				ACCOUNT_BRANCH_ID,
				<cfif isDefined("attributes.account_owner_customer_no") and len(attributes.account_owner_customer_no)>
					ACCOUNT_OWNER_CUSTOMER_NO,
				</cfif>
				ACCOUNT_CREDIT_LIMIT,
				ACCOUNT_CURRENCY_ID,
				ACCOUNT_NO,
				ACCOUNT_ACC_CODE,
				V_CHEQUE_ACC_CODE,
				CHEQUE_EXCHANGE_CODE,
				VOUCHER_EXCHANGE_CODE,
				CHEQUE_GUARANTY_CODE,
				VOUCHER_GUARANTY_CODE,
				ACCOUNT_ORDER_CODE,
				ISOPEN,
				IS_INTERNET,
				ACCOUNT_DETAIL,
				BANK_CODE,
				BRANCH_CODE,
				IS_PARTNER,
				IS_PUBLIC,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				PROTESTOLU_SENETLER_CODE,
				KARSILIKSIZ_CEKLER_CODE,
				IS_CIVIL	
			)
			VALUES
			( 
				<cfif isdefined("attributes.status")>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_type#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_name#">,
				#ListFirst(attributes.account_branch_id,';')#,
				<cfif isDefined("attributes.account_owner_customer_no") and len(attributes.account_owner_customer_no)>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_owner_customer_no#">,
				</cfif>
				<cfif len(attributes.account_credit_limit)><cfqueryparam cfsqltype="cf_sql_integer" value="#filterNum(attributes.account_credit_limit)#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="0"></cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_currency_id#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_no#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_id#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.v_account_id#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.exchange_code_id#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.v_exchange_code_id#">,
				<cfif len(attributes.guaranty_code_id) and len(attributes.guaranty_code_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.guaranty_code_id#"><cfelse>NULL</cfif>,
				<cfif len(attributes.v_guaranty_code_id) and len(attributes.v_guaranty_code_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.v_guaranty_code_id#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.bank_order") and len(attributes.bank_order)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.bank_order#">,<cfelse>NULL,</cfif>
				0,
				<cfif isdefined("attributes.internet")>1<cfelse>0</cfif>,
				<cfif len(attributes.account_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.account_detail#"><cfelse>NULL</cfif>,
				<cfif len(attributes.bank_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.bank_code#"><cfelse>NULL</cfif>,
				<cfif len(attributes.branch_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_code#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_partner")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_public")>1<cfelse>0</cfif>,
				#now()#,
				#session.ep.userid#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.protestolu_senetler_id#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.karsiliksiz_cekler_id#">,
				<cfif isdefined("attributes.is_civil")>1<cfelse>0</cfif>			
			)
		</cfquery>
		<cfquery name="ADD_ACCOUNT_CONTROL" datasource="#DSN3#">
			INSERT INTO
				ACCOUNTS_OPEN_CONTROL
				(
					ACCOUNT_ID,
					IS_OPEN,
					PERIOD_ID
				)
				VALUES
				(
					#MAX_ID.IDENTITYCOL#,
					0,
					#session.ep.period_id#
				)
		</cfquery>
		<cfloop from="1" to="#listlen(attributes.branch_id)#" index="brnch_index">
			<cfquery name="ADD_ACCOUNT_BRANCH" datasource="#DSN3#">
				INSERT INTO
					ACCOUNTS_BRANCH
					(
						ACCOUNT_ID,
						BRANCH_ID
					)
					VALUES
					(
						#MAX_ID.IDENTITYCOL#,
						#listgetat(attributes.branch_id,brnch_index)#
					)
			</cfquery>
		</cfloop>

		<cfif isdefined("attributes.is_civil")>
			<cfquery name="UPD_ACCOUNT2" datasource="#dsn3#"> <!--- Bu blok KAMU (IS_CIVIL) olarak secilmisse digerlerinin IS_CIVIL durumunu iptal eder. --->
				UPDATE ACCOUNTS SET IS_CIVIL = 0 WHERE ACCOUNT_ID  NOT IN (#MAX_ID.IDENTITYCOL#)
			</cfquery>	
		</cfif>
	</cftransaction>
</cflock>
<cfset attributes.action=MAX_ID.IDENTITYCOL>
<script type="text/javascript">
  window.location.href="<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_bank_account&event=upd&id=#MAX_ID.IDENTITYCOL#</cfoutput>";
</script>