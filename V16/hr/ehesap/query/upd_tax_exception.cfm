<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>
		<cfquery name="UPD_TAX_EXC" datasource="#DSN#">
			UPDATE 
				TAX_EXCEPTION
			SET
				STATUS = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
				TAX_EXCEPTION = '#tax_exc_head#',
				START_MONTH = #START_MONTH#,
				FINISH_MONTH = #FINISH_MONTH#,
				EXCEPTION_TYPE = <cfif len(attributes.exception_type)>#attributes.exception_type#<cfelse>NULL</cfif>,
				AMOUNT = <cfif len(AMOUNT)>#AMOUNT#<cfelse>NULL</cfif>,
				CALC_DAYS = <cfif isdefined("form.calc_days")>1<cfelse>0</cfif>,
				IS_ISVEREN = <cfif isdefined("form.is_isveren")>1<cfelse>0</cfif>,
				IS_ALL_PAY = <cfif isdefined("form.is_all_pay")>1<cfelse>0</cfif>,
				IS_SSK = <cfif isdefined("form.is_ssk")>1<cfelse>0</cfif>,
				MONEY_ID = #MONEY_ID#,
				DETAIL = '#DETAIL#',
				YUZDE_SINIR = #YUZDE_SINIR#,
		   		UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#cgi.REMOTE_ADDR#'
			WHERE
				TAX_EXCEPTION_ID = #attributes.ID#
		</cfquery>
	</CFTRANSACTION>
</CFLOCK>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
