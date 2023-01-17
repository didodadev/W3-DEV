<cfset bordro_id = ''>
<cfset check_cash_id = ''>
<cfset portfoy_no = get_cheque_no(belge_tipi:'cheque')>
<cfquery name="GET_MONEY" datasource="#dsn2#">
	SELECT MONEY,RATE1,RATE2 FROM SETUP_MONEY WHERE MONEY_STATUS=1
</cfquery>
<cfset open_date = dateformat(session.ep.period_start_date,dateformat_style)>
<cf_date tarih='open_date'>
<cfloop from="1" to="15" index="i">
	<cfif isDefined('form.CHEQUE_NO#i#') and len(evaluate("form.CHEQUE_NO#i#")) and isnumeric(evaluate("form.CHEQUE_VALUE#i#")) and isdate(evaluate("form.CHEQUE_DUEDATE#i#")) and len(evaluate("form.hesap#i#"))>
		<cfif len(check_cash_id) and check_cash_id neq evaluate("form.hesap#i#")>
			<cfset bordro_id = ''>
		</cfif>
		<cfif not len(bordro_id)>
			<cfset check_cash_id = listfirst(evaluate("form.hesap#i#"),';')>
			<cfquery name="get_payroll_id" datasource="#dsn2#">
				SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE = 106 AND PAYROLL_CASH_ID = #check_cash_id# AND COMPANY_ID IS NULL AND CONSUMER_ID IS NULL
			</cfquery>
			<cfset bordro_id = get_payroll_id.ACTION_ID>
			<cfif not len(bordro_id)>
				<cftransaction>
					<cfquery name="ADD_PAYROLL" datasource="#dsn2#">
						INSERT INTO PAYROLL 
							(PAYROLL_NO,PAYROLL_TYPE,PAYROLL_CASH_ID,PAYROLL_RECORD_DATE,RECORD_EMP,RECORD_IP,RECORD_DATE)
							VALUES
							('-1',106,#check_cash_id#,#now()#,#session.ep.userid#,'#cgi.remote_addr#',#now()#)
					</cfquery>
					<cfquery name="get_payroll_id" datasource="#dsn2#">
						SELECT ACTION_ID FROM PAYROLL WHERE PAYROLL_TYPE = 106 AND PAYROLL_CASH_ID = #check_cash_id# AND COMPANY_ID IS NULL AND CONSUMER_ID IS NULL
					</cfquery>
					<cfset bordro_id = get_payroll_id.ACTION_ID>
				</cftransaction>
			</cfif>
		</cfif>
		<cf_date tarih = 'form.CHEQUE_DUEDATE#i#'>
		<cftransaction>
			<cfquery name="add_cheque" datasource="#dsn2#">
				INSERT INTO
				CHEQUE
				(
					CHEQUE_PAYROLL_ID,
					CHEQUE_NO,
					CHEQUE_STATUS_ID,
					DEBTOR_NAME,
					COMPANY_ID,
					CONSUMER_ID,
					OWNER_COMPANY_ID,
					OWNER_CONSUMER_ID,
					BANK_NAME,
					BANK_BRANCH_NAME,
					CURRENCY_ID,
					CHEQUE_VALUE,
					OTHER_MONEY,
					OTHER_MONEY_VALUE,
					OTHER_MONEY2,
					OTHER_MONEY_VALUE2,
					CHEQUE_DUEDATE,
					CHEQUE_PURSE_NO,
					CHEQUE_CODE,
					CASH_ID,
					RECORD_EMP,
					RECORD_IP,
					ENDORSEMENT_MEMBER,
					RECORD_DATE		
				)
				VALUES
				(
					#bordro_id#,
					'#wrk_eval("form.CHEQUE_NO#i#")#',
					<cfif isdefined('attributes.is_ciro_cheque')>4<cfelse>1</cfif>,
					<cfif len(evaluate("form.DEBTOR_NAME#i#"))>'#wrk_eval("form.DEBTOR_NAME#i#")#'<cfelse>NULL</cfif>,
					<cfif len(evaluate("form.COMPANY_ID#i#"))>#evaluate("form.COMPANY_ID#i#")#<cfelse>NULL</cfif>,
					<cfif len(evaluate("form.CONSUMER_ID#i#"))>#evaluate("form.CONSUMER_ID#i#")#<cfelse>NULL</cfif>,
					<cfif isdefined("attributes.is_ciro_cheque")>
						<cfif len(evaluate("form.OWNER_COMPANY_ID#i#"))>#evaluate("form.OWNER_COMPANY_ID#i#")#<cfelse>NULL</cfif>,
						<cfif len(evaluate("form.OWNER_CONSUMER_ID#i#"))>#evaluate("form.OWNER_CONSUMER_ID#i#")#<cfelse>NULL</cfif>,
					<cfelse>
						<cfif len(evaluate("form.COMPANY_ID#i#"))>#evaluate("form.COMPANY_ID#i#")#<cfelse>NULL</cfif>,
						<cfif len(evaluate("form.CONSUMER_ID#i#"))>#evaluate("form.CONSUMER_ID#i#")#<cfelse>NULL</cfif>,
					</cfif>
					<cfif isDefined("form.BANK_NAME#i#") and len(evaluate("form.BANK_NAME#i#"))>'#wrk_eval("form.BANK_NAME#i#")#',<cfelse>NULL,</cfif>
					<cfif isDefined("form.BANK_BRANCH_NAME#i#") and len(evaluate("form.BANK_BRANCH_NAME#i#"))>'#wrk_eval("form.BANK_BRANCH_NAME#i#")#',<cfelse>NULL,</cfif>
					'#listfirst(evaluate("form.CURRENCY_ID#i#"),';')#',
					#evaluate("form.CHEQUE_VALUE#i#")#,
					'#session.ep.money#',
					<cfif len(evaluate("form.SYSTEM_CHEQUE_VALUE#i#"))>#evaluate("form.SYSTEM_CHEQUE_VALUE#i#")#<cfelse>NULL</cfif>,
					'#session.ep.money2#',
					<cfif len(evaluate("form.CHEQUE_OTHER_MONEY_VALUE#i#"))>#evaluate("form.CHEQUE_OTHER_MONEY_VALUE#i#")#<cfelse>NULL</cfif>,
					#createodbcdatetime(evaluate("form.CHEQUE_DUEDATE#i#"))#,
					#portfoy_no#,
					<cfif len(evaluate("form.CHEQUE_CODE#i#"))>'#wrk_eval("form.CHEQUE_CODE#i#")#'<cfelse>NULL</cfif>,
					#listfirst(evaluate("form.hesap#i#"),';')#,
					#session.ep.userid#,
					'#cgi.remote_addr#',
					<cfif len(evaluate("attributes.endorsement_member#i#"))>'#evaluate("attributes.endorsement_member#i#")#',<cfelse>NULL,</cfif>
					#now()#					
				)
			</cfquery>
			<cfset portfoy_no = portfoy_no+1>
			<cfquery name="get_max_id" datasource="#dsn2#">
				SELECT MAX(CHEQUE_ID) AS CHEQUE_ID FROM CHEQUE
			</cfquery>
			<cfquery name="add_cheque_history" datasource="#dsn2#">
				INSERT INTO
				CHEQUE_HISTORY
				(
					CHEQUE_ID,
					PAYROLL_ID,
					STATUS,
					OTHER_MONEY,
					OTHER_MONEY_VALUE,
					OTHER_MONEY2,
					OTHER_MONEY_VALUE2,
					ACT_DATE,
					RECORD_EMP,
					RECORD_IP,
					RECORD_DATE
				)
				VALUES
				(
					#get_max_id.CHEQUE_ID#,
					#bordro_id#,
					<cfif isdefined('attributes.is_ciro_cheque')>4<cfelse>1</cfif>,
					'#session.ep.money#',
					<cfif len(evaluate("form.SYSTEM_CHEQUE_VALUE#i#"))>#evaluate("form.SYSTEM_CHEQUE_VALUE#i#")#<cfelse>NULL</cfif>,
					'#session.ep.money2#',
					<cfif len(evaluate("form.CHEQUE_OTHER_MONEY_VALUE#i#"))>#evaluate("form.CHEQUE_OTHER_MONEY_VALUE#i#")#<cfelse>NULL</cfif>,
					#open_date#,
					#session.ep.userid#,
					'#cgi.remote_addr#',
					#now()#
				)
			</cfquery>
			<cfset money_type = listfirst(evaluate("form.CURRENCY_ID#i#"),";")>
			<cfoutput query="get_money">
				<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
					INSERT INTO CHEQUE_MONEY 
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						#get_max_id.CHEQUE_ID#,
						'#get_money.money#',
						#get_money.rate2#,
						#get_money.rate1#,
						<cfif money_type is get_money.money>1<cfelse>0</cfif>
					)
				</cfquery>
				<cfquery name="ADD_MONEY_INFO2" datasource="#dsn2#">
					INSERT INTO CHEQUE_HISTORY_MONEY 
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						#get_max_id.CHEQUE_ID#,
						'#get_money.money#',
						#get_money.rate2#,
						#get_money.rate1#,
						<cfif money_type is get_money.money>1<cfelse>0</cfif>
					)
				</cfquery>
			</cfoutput>
		</cftransaction>
	</cfif>
</cfloop>
<cfset belge_no = get_cheque_no(belge_tipi:'cheque',belge_no:portfoy_no)>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=finance.form_add_cheque_exp</cfoutput>";
</script>
