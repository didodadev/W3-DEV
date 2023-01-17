<cf_date tarih='attributes.accident_date'>
<cfquery name="insert_accs" datasource="#dsn#"> 
	INSERT 
	INTO 
		ASSET_P_ACCIDENT
		(
			ACCIDENT_ID,
			ASSETP_ID,
			EMPLOYEE_ID,
			INSURANCE_STATUS,
			ACCIDENT_DATE,
			DOCUMENT_NUM,
			FAULT_RATIO,
			PENALTY_ITEM,
			DESCRIPTION, 
			EXPENSE_TAX,
			INSURANCE_PAYMENT, 
			EXPENSE_MONEY,
			RECORD_EMP,
			RECORD_DATE,
			RECORD_IP
		) 
		VALUES 
		(
			#attributes.accident_id#,
			#attributes.assetp_id#,
			<cfif len(attributes.employee_id)>#attributes.employee_id#,<cfelse>NULL,</cfif>
			<cfif len(attributes.insurance_status)>'#attributes.insurance_status#',<cfelse>NULL,</cfif>
			<cfif len(attributes.accident_date)>#attributes.accident_date#,<cfelse>NULL,</cfif>
			<cfif len(attributes.document_num)>'#attributes.document_num#',<cfelse>NULL,</cfif>
			<cfif len(attributes.fault_ratio)>'#attributes.fault_ratio#',<cfelse>NULL,</cfif>
			<cfif len(attributes.penalty_item)>'#attributes.penalty_item#',<cfelse>NULL,</cfif>
			<cfif len(attributes.description)>'#attributes.description#',<cfelse>NULL,</cfif>
			<cfif len(attributes.expense_tax)>#attributes.expense_tax#,<cfelse>NULL,</cfif>
			<cfif isDefined('insurance_payment')>#attributes.insurance_payment#,<cfelse>0,</cfif>
			'#attributes.expense_money#',
			#session.ep.userid#,
			#now()#,
			'#cgi.remote_addr#'
		)
</cfquery>
<cfif attributes.is_detail neq 1>
	<script type="text/javascript">
		window.parent.kaza_liste.location.reload();
		window.parent.addform.location.href='<cfoutput>#request.self#?fuseaction=assetcare.popup_add_kaza</cfoutput>&iframe=1';
	</script>
<cfelse>
	<script type="text/javascript">
		wrk_opener_reload(); 
		self.close();
	</script>
</cfif>

