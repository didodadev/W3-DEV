<cfif attributes.amount gt 100>
  <script type="text/javascript">
    alert("<cf_get_lang dictionary_id='64120.BES Oranı % 100 den fazla olamaz, kontrol edin'>!");
    window.location.href = '<cfoutput>#request.self#?fuseaction=ehesap.list_bes</cfoutput>';
  </script>
  <cfabort>
</cfif>
<CFLOCK name="#CREATEUUID()#" timeout="20">
	<CFTRANSACTION>
		<cfquery name="upd_odenek" datasource="#dsn#">
			UPDATE 
				SETUP_PAYMENT_INTERRUPTION
			SET
				STATUS = <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
				COMMENT_PAY = '#FORM.comment#',
				AMOUNT_PAY = #FORM.AMOUNT#,
				START_SAL_MON = #FORM.start_sal_mon#,
				END_SAL_MON = #FORM.end_sal_mon#,
				IS_ODENEK = 0,
				UPDATE_EMP = #session.ep.userid#,
				UPDATE_DATE = #now()#,
				UPDATE_IP = '#cgi.REMOTE_ADDR#'
			WHERE
				ODKES_ID = #attributes.bes_id#
		</cfquery>
	</CFTRANSACTION>
</CFLOCK>
<script type="text/javascript">
   	window.location.href = '<cfoutput>#request.self#?fuseaction=ehesap.list_bes</cfoutput>';
</script>