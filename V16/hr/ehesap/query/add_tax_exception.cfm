<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>
		<cfquery name="add_tax_exception" datasource="#dsn#" result="MAX_ID">
			INSERT INTO
				TAX_EXCEPTION
				(
					STATUS,
					TAX_EXCEPTION,
					START_MONTH,
					FINISH_MONTH,
					AMOUNT,
					CALC_DAYS,
					IS_ALL_PAY,
					<cfif LEN(DETAIL)>DETAIL,</cfif>
					MONEY_ID,
					IS_ISVEREN,
					YUZDE_SINIR,
					IS_SSK,
					EXCEPTION_TYPE,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
			VALUES
				(
					<cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
					'#tax_exc_head#',
					#START_MONTH#,
					#FINISH_MONTH#,
					<cfif len(attributes.amount)>#amount#<cfelse>NULL</cfif>,
					<cfif isdefined("form.calc_days")>1<cfelse>0</cfif>,
					<cfif isdefined("form.is_all_pay")>1<cfelse>0</cfif>,
					<cfif LEN(DETAIL)>'#DETAIL#',</cfif>
					#MONEY_ID#,
					<cfif isdefined("form.is_isveren")>1<cfelse>0</cfif>,
					#YUZDE_SINIR#,
					<cfif isdefined("form.is_ssk")>1<cfelse>0</cfif>,
					<cfif len(attributes.exception_type)>#attributes.exception_type#<cfelse>NULL</cfif>,
					#NOW()#,
				   #SESSION.EP.USERID#,
				   '#CGI.REMOTE_ADDR#'
				)
		</cfquery>
	</CFTRANSACTION>
</CFLOCK>
<script type="text/javascript">
  wrk_opener_reload();
  window.close();
</script>
