<cfif isdefined("attributes.is_inst_avans") and (attributes.is_inst_avans eq 1) and isdefined("attributes.METHOD") and listfindnocase('2,3,4',attributes.METHOD)>
	<script type="text/javascript">
		alert("Taksitlendirmede yuzde yontemi  kullanilmaz kontrol edin !");
		history.back();
    </script>
    <cfabort>
</cfif>
<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>
		<cfquery name="get_max_id" datasource="#dsn#">
		   SELECT MAX(ODKES_ID) AS MAX_ID FROM SETUP_PAYMENT_INTERRUPTION
		</cfquery>
		<cfquery name="ADD_ODENEK" datasource="#DSN#">
			INSERT INTO
					SETUP_PAYMENT_INTERRUPTION
					(
						STATUS,
						IS_DEMAND,
						ODKES_ID,
						COMMENT_PAY,
						PERIOD_PAY,
						METHOD_PAY,
						AMOUNT_PAY,
						SHOW,
						CALC_DAYS,
						IS_INST_AVANS,
						START_SAL_MON,
						END_SAL_MON,
						IS_ODENEK,
						FROM_SALARY,
						ACCOUNT_CODE,
						ACCOUNT_NAME,
						COMPANY_ID,
						CONSUMER_ID,
						ACC_TYPE_ID,
						MONEY,
						TAX,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP,
						IS_DISCIPLINARY_PUNISHMENT,
						IS_UNION_INFORMATION,
						UNION_INFORMATION_NAME,
						UNION_INFORMATION_ADDRESS,
						UNION_INFORMATION_BANK_NAME,
						UNION_INFORMATION_BRANCH_NAME,
						UNION_INFORMATION_ACCOUNT_NAME,
						IS_NET_TO_GROSS
				)
				VALUES
				(
					<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.is_demand")>1<cfelse>0</cfif>,
					<cfif len(get_max_id.MAX_ID)>
						#get_max_id.MAX_ID#+1,
					<cfelse>
						1,
					</cfif>
					'#form.comment#',
					#form.PERIOD#,
					#form.METHOD#,
					#FORM.AMOUNT#,
					<cfif isDefined("FORM.show")>1<cfelse>0</cfif>,
					#FORM.calc_days#,
					<cfif isDefined("FORM.is_inst_avans")>1<cfelse>0</cfif>,
					#form.start_sal_mon#,
					#form.end_sal_mon#,
					0,
					#form.from_salary#,
						<cfif isDefined("attributes.account_code") and len(attributes.account_code)>'#attributes.account_code#'<cfelse>NULL</cfif>,
					<cfif isDefined("attributes.account_name") and len(attributes.account_name)>'#attributes.account_name#'<cfelse>NULL</cfif>,
					<cfif isDefined("attributes.company_id") and len(attributes.company_id) and len(attributes.member_name)>#attributes.company_id#<cfelse>NULL</cfif>,
					<cfif isDefined("attributes.consumer_id") and len(attributes.consumer_id) and len(attributes.member_name)>#attributes.consumer_id#<cfelse>NULL</cfif>,
					<cfif isDefined("attributes.acc_type_id") and len(attributes.acc_type_id)>#attributes.acc_type_id#<cfelse>NULL</cfif>,
					'#attributes.money#',
					#attributes.tax#,
					#NOW()#,
					#SESSION.EP.USERID#,
					'#CGI.REMOTE_ADDR#',
					<cfif isDefined("attributes.is_disciplinary_punishment") and len(attributes.is_disciplinary_punishment)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_disciplinary_punishment#"><cfelse>0</cfif>,
					<cfif isDefined("attributes.is_union_information") and len(attributes.is_union_information)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_union_information#"><cfelse>0</cfif>,
					<cfif isDefined("attributes.union_information_name") and len(attributes.union_information_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.union_information_name#"><cfelse>NULL</cfif>,
					<cfif isDefined("attributes.union_information_address") and len(attributes.union_information_address)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.union_information_address#"><cfelse>NULL</cfif>,
					<cfif isDefined("attributes.union_information_bank_name") and len(attributes.union_information_bank_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.union_information_bank_name#"><cfelse>NULL</cfif>,
					<cfif isDefined("attributes.union_information_branch_name") and len(attributes.union_information_branch_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.union_information_branch_name#"><cfelse>NULL</cfif>,
					<cfif isDefined("attributes.union_information_account_name") and len(attributes.union_information_account_name)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.union_information_account_name#"><cfelse>NULL</cfif>,
					<cfif isDefined("attributes.is_net_to_gross") and len(attributes.is_net_to_gross) and attributes.from_salary eq 1><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_net_to_gross#"><cfelse>0</cfif>
				)
		</cfquery>
		
		<cfset odkes_id_ = get_max_id.MAX_ID + 1 >
	</CFTRANSACTION>
</CFLOCK>
<script type="text/javascript">
	window.location.href ="<cfoutput>#request.self#?fuseaction=ehesap.list_kesinti&event=upd&odkes_id=#odkes_id_#</cfoutput>";
</script>
