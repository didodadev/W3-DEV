<cfset bordro_id = ''>
<cfset voucher_cash_id = ''>
<cfset portfoy_no = get_cheque_no(belge_tipi:'voucher')>
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT
		MONEY,
		RATE1,
		RATE2
	FROM
		SETUP_MONEY
	WHERE
		PERIOD_ID = #SESSION.EP.PERIOD_ID# AND
		MONEY_STATUS=1
</cfquery>
<cfset open_date = dateformat(session.ep.period_start_date,dateformat_style)>
<cf_date tarih='open_date'>
<cfloop from="1" to="15" index="i">
	<cfif isDefined('form.VOUCHER_NO#i#') and len(evaluate("form.VOUCHER_NO#i#")) and isnumeric(evaluate("form.VOUCHER_VALUE#i#")) and isdate(evaluate("form.VOUCHER_DUEDATE#i#")) and isdefined("form.hesap#i#") and len(listfirst(evaluate("form.hesap#i#"),';'))>
		<cfif len(voucher_cash_id) and voucher_cash_id neq listfirst(evaluate("form.hesap#i#"),';')>
			<cfset bordro_id = ''>
		</cfif>
		<cfif not len(bordro_id)>
			<cfset voucher_cash_id = listfirst(evaluate("form.hesap#i#"),';')>
			<cfquery name="get_payroll_id" datasource="#dsn2#">
				SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107 AND PAYROLL_CASH_ID = #voucher_cash_id# AND COMPANY_ID IS NULL AND CONSUMER_ID IS NULL
			</cfquery>
			<cfset bordro_id = get_payroll_id.ACTION_ID>
			<cfif not len(bordro_id)>
				<cftransaction>
					<cfquery name="ADD_PAYROLL" datasource="#dsn2#">
						INSERT INTO VOUCHER_PAYROLL 
							(PAYROLL_NO,PAYROLL_TYPE,PAYROLL_CASH_ID,PAYROLL_RECORD_DATE,RECORD_EMP,RECORD_IP,RECORD_DATE)
							VALUES
							('-1',107,#voucher_cash_id#,#now()#,#session.ep.userid#,'#cgi.remote_addr#',#now()#)
					</cfquery>
					<cfquery name="get_payroll_id" datasource="#dsn2#">
						SELECT ACTION_ID FROM VOUCHER_PAYROLL WHERE PAYROLL_TYPE = 107 AND PAYROLL_CASH_ID = #voucher_cash_id# AND COMPANY_ID IS NULL AND CONSUMER_ID IS NULL
					</cfquery>
					<cfset bordro_id = get_payroll_id.ACTION_ID>
				</cftransaction>
			</cfif>
		</cfif>
		<cf_date tarih = 'form.VOUCHER_DUEDATE#i#'>
		<cftransaction>
			<cfquery name="add" datasource="#dsn2#">
				INSERT INTO
				VOUCHER
				(
					VOUCHER_PAYROLL_ID,
					COMPANY_ID,
					VOUCHER_NO,
					VOUCHER_STATUS_ID,
					DEBTOR_NAME,
					CURRENCY_ID,
					VOUCHER_VALUE,
					OTHER_MONEY,
					OTHER_MONEY_VALUE,
					OTHER_MONEY2,
					OTHER_MONEY_VALUE2,
					VOUCHER_DUEDATE,
					VOUCHER_PURSE_NO,
					VOUCHER_CODE,
					CASH_ID,
					RECORD_DATE
				)
				VALUES
				(
					#bordro_id#,
					#evaluate("form.COMPANY_ID#i#")#,
					'#wrk_eval("form.VOUCHER_NO#i#")#',
					6,
					'#session.ep.company#',
					'#listfirst(evaluate("form.CURRENCY_ID#i#"),";")#',
					#evaluate("form.VOUCHER_VALUE#i#")#,
					'#session.ep.money#',
					#evaluate("form.SYSTEM_VOUCHER_VALUE#i#")#,
					'#session.ep.money2#',
					<cfif len(evaluate("form.VOUCHER_OTHER_MONEY_VALUE#i#"))>#evaluate("form.VOUCHER_OTHER_MONEY_VALUE#i#")#<cfelse>NULL</cfif>,
					#createodbcdatetime(evaluate("form.VOUCHER_DUEDATE#i#"))#,
					#portfoy_no#,
					'#wrk_eval("form.VOUCHER_CODE#i#")#',
					<cfif isdefined("voucher_cash_id") and len(voucher_cash_id)>#voucher_cash_id#<cfelse>NULL</cfif>,
					#now()#
				)
			</cfquery>
			<cfset portfoy_no = portfoy_no+1>
			<cfquery name="get_max_id" datasource="#dsn2#">
				SELECT MAX(VOUCHER_ID) AS VOUCHER_ID FROM VOUCHER
			</cfquery>
			<cfquery name="add_voucher_history" datasource="#dsn2#">
				INSERT INTO
				VOUCHER_HISTORY
				(
					VOUCHER_ID,
					COMPANY_ID,
					PAYROLL_ID,
					STATUS,
					OTHER_MONEY,
					OTHER_MONEY_VALUE,
					OTHER_MONEY2,
					OTHER_MONEY_VALUE2,
					ACT_DATE,
					RECORD_DATE
				)
				VALUES
				(
					#get_max_id.VOUCHER_ID#,
					#evaluate("form.COMPANY_ID#i#")#,
					#bordro_id#,
					6,
					'#session.ep.money#',
					#evaluate("form.SYSTEM_VOUCHER_VALUE#i#")#,
					'#session.ep.money2#',
					<cfif len(evaluate("form.VOUCHER_OTHER_MONEY_VALUE#i#"))>#evaluate("form.VOUCHER_OTHER_MONEY_VALUE#i#")#<cfelse>NULL</cfif>,
					#open_date#,
					#now()#		
				)
			</cfquery>
			<cfset money_type = listfirst(evaluate("form.CURRENCY_ID#i#"),";")>
			<cfoutput query="get_money">
				<cfquery name="ADD_MONEY_INFO" datasource="#dsn2#">
					INSERT INTO VOUCHER_MONEY 
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						#get_max_id.VOUCHER_ID#,
						'#get_money.money#',
						#get_money.rate2#,
						#get_money.rate1#,
						<cfif money_type is get_money.money>1<cfelse>0</cfif>
					)
				</cfquery>
				<cfquery name="ADD_MONEY_INFO2" datasource="#dsn2#">
					INSERT INTO VOUCHER_HISTORY_MONEY 
					(
						ACTION_ID,
						MONEY_TYPE,
						RATE2,
						RATE1,
						IS_SELECTED
					)
					VALUES
					(
						#get_max_id.VOUCHER_ID#,
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
<cfset belge_no = get_cheque_no(belge_tipi:'voucher',belge_no:portfoy_no)>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=finance.form_add_voucher_exp</cfoutput>";
</script>
