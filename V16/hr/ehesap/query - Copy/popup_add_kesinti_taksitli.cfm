<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfscript>
			kayit_sayisi = attributes.ins_period-1;
			ay_sayisi= attributes.sal_mon + attributes.ins_period;
			sonraki_yil = session.ep.period_year+1;
			ilk_ay = attributes.sal_mon;
			yil = attributes.term;
			ay=0;
			artim=0;
		</cfscript>
		<cfquery name="get_setup" datasource="#dsn#">
			SELECT 
    	        ODKES_ID, 
                COMMENT_PAY, 
                PERIOD_PAY, 
                METHOD_PAY,
                AMOUNT_PAY, 
                SSK, 
                TAX, 
                SHOW, 
                START_SAL_MON,
                END_SAL_MON, 
                CALC_DAYS, 
                IS_INST_AVANS, 
                FROM_SALARY, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_EMP,
                UPDATE_DATE, 
                UPDATE_IP, 
                IS_EHESAP, 
                COMPANY_ID, 
                ACCOUNT_CODE, 
                ACCOUNT_NAME, 
                CONSUMER_ID, 
                MONEY, 
                ACC_TYPE_ID,
				IS_NET_TO_GROSS
            FROM 
	            SETUP_PAYMENT_INTERRUPTION 
            WHERE 
            	ODKES_ID = #attributes.odkes_id#
		</cfquery>
		<cfloop from="0" to="#kayit_sayisi#" index="i">
			<cfset ay = ilk_ay + artim>
			<cfif ay gt 12>
				<cfset ay = 1>
				<cfset ilk_ay = 1>
				<cfset artim = 0>
				<cfset yil = yil + 1>
			</cfif>
			<cfif evaluate("attributes.amount_get#i#") gt 0>
				<cfquery name="add_row" datasource="#dsn#">
					INSERT INTO
						SALARYPARAM_GET
					(
						COMMENT_GET,
						AMOUNT_GET,
						TOTAL_GET,
						SHOW,
						METHOD_GET,
						PERIOD_GET, 
						START_SAL_MON,
						END_SAL_MON,
						EMPLOYEE_ID,
						TERM,
						CALC_DAYS,
						FROM_SALARY,
						IN_OUT_ID,
						IS_INST_AVANS,
						DETAIL,
						ACCOUNT_CODE,
						ACCOUNT_NAME,
						COMPANY_ID,
						CONSUMER_ID,
						MONEY,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP,
						ACC_TYPE_ID,
						IS_NET_TO_GROSS
					)
					VALUES
					(
						<cfif isDefined('attributes.comment_get') and len(attributes.comment_get)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.comment_get#"><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_float" value="#filternum(evaluate("attributes.amount_get#i#"))#">,
						<cfif isDefined('attributes.toplam_tutar') and len(attributes.toplam_tutar)><cfqueryparam cfsqltype="cf_sql_float" value="#filterNum(attributes.toplam_tutar)#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.show") and len(attributes.show)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.show#"><cfelse>0</cfif>,
						<cfif isdefined("attributes.method_get") and len(attributes.method_get)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.method_get#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.periyod_get") and len(attributes.periyod_get)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.periyod_get#"><cfelse>NULL</cfif>,
						<cfif isdefined("ay") and len(ay)><cfqueryparam cfsqltype="cf_sql_integer" value="#ay#"><cfelse>NULL</cfif>,
						<cfif isdefined("ay") and len(ay)><cfqueryparam cfsqltype="cf_sql_integer" value="#ay#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"><cfelse>NULL</cfif>,
						<cfif isdefined("yil") and len(yil)><cfqueryparam cfsqltype="cf_sql_integer" value="#yil#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.calc_days") and len(attributes.calc_days)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.calc_days#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.FROM_SALARY") and len(attributes.FROM_SALARY)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.FROM_SALARY#"><cfelse>0</cfif>,
						<cfif isdefined("attributes.in_out_id") and len(attributes.in_out_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.in_out_id#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.is_inst_avans") and len(attributes.is_inst_avans)><cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_inst_avans#"><cfelse>NULL</cfif>,
						<cfif isdefined("attributes.detail") and len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#detail#"><cfelse>NULL</cfif>,
					    <cfif isDefined("get_setup.account_code") and len(get_setup.account_code)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_setup.account_code#"><cfelse>NULL</cfif>,
					    <cfif isDefined("get_setup.account_name") and len(get_setup.account_name)><cfqueryparam cfsqltype="cf_sql_varchar" value="#get_setup.account_name#"><cfelse>NULL</cfif>,
					    <cfif isDefined("get_setup.company_id") and len(get_setup.company_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_setup.company_id#"><cfelse>NULL</cfif>,
					    <cfif isDefined("get_setup.consumer_id") and len(get_setup.consumer_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_setup.consumer_id#"><cfelse>NULL</cfif>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.money#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
					    <cfif isDefined("get_setup.ACC_TYPE_ID") and len(get_setup.ACC_TYPE_ID)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_setup.ACC_TYPE_ID#"><cfelse>NULL</cfif>,
						<cfif isDefined("get_setup.is_net_to_gross") and len(get_setup.is_net_to_gross) and get_setup.from_salary eq 1><cfqueryparam cfsqltype="cf_sql_bit" value="#get_setup.is_net_to_gross#"><cfelse>0</cfif>

					)
				</cfquery>
				<cfset artim=artim+1>
			</cfif>
		  </cfloop>
		</cftransaction>
	</cflock>
		  <script type="text/javascript">
			location.href = document.referrer;
		</script>
