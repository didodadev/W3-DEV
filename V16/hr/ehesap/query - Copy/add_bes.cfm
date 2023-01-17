<cfif attributes.amount gt 100>
  <script type="text/javascript">
    alert("Oran % 100 den fazla olamaz, kontrol edin !");
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
					IS_BES,
                    STATUS,
					ODKES_ID,
					COMMENT_PAY,
					AMOUNT_PAY,
					SHOW,
					START_SAL_MON,
					END_SAL_MON,
					IS_ODENEK,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
			  )
			VALUES
			  (
			  	   1,
				   <cfif isdefined("attributes.is_active")>1<cfelse>0</cfif>,
				   <cfif len(get_max_id.MAX_ID)>#get_max_id.MAX_ID#+1,<cfelse>1,</cfif>
				   '#form.comment#',
				   #attributes.amount#,
				   0,
				   #form.start_sal_mon#,
				   #form.end_sal_mon#,
				   0,
				   #NOW()#,
				   #SESSION.EP.USERID#,
				   '#CGI.REMOTE_ADDR#'
			  )
		</cfquery>
	</CFTRANSACTION>
</CFLOCK>
<script type="text/javascript">
	<cfif isDefined("attributes.draggable")>
		closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);
	<cfelse>
		self.close();
	</cfif>
	window.location.href = '<cfoutput>#request.self#?fuseaction=ehesap.list_bes</cfoutput>';
</script>