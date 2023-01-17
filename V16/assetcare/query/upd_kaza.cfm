<cf_date tarih='attributes.accident_date'>
<cfquery name="upd_kaza" datasource="#dsn#">
	UPDATE 
		ASSET_P_ACCIDENT
	SET
		ASSETP_ID = #attributes.assetp_id#,
		ACCIDENT_ID = #attributes.accident_id#,
		EMPLOYEE_ID = #attributes.employee_id#,
		INSURANCE_STATUS = <cfif len(attributes.insurance_status)>'#attributes.insurance_status#',<cfelse>NULL,</cfif>
		ACCIDENT_DATE = <cfif len(attributes.accident_date)>#attributes.accident_date#,<cfelse>NULL,</cfif>
		DOCUMENT_NUM = <cfif len(attributes.document_num)>'#attributes.document_num#',<cfelse>NULL,</cfif>
		FAULT_RATIO = <cfif len(attributes.fault_ratio)>'#attributes.fault_ratio#',<cfelse>NULL,</cfif>
		PENALTY_ITEM = <cfif len(attributes.penalty_item)>'#attributes.penalty_item#',<cfelse>NULL,</cfif>
		DESCRIPTION = <cfif len(attributes.description)>'#attributes.description#',<cfelse>NULL,</cfif>
		EXPENSE_TAX = <cfif len(attributes.expense_tax)>#attributes.expense_tax#,<cfelse>NULL,</cfif>
		EXPENSE_MONEY = <cfif len(attributes.expense_money)>'#attributes.expense_money#',<cfelse>NULL,</cfif>
		<cfif isDefined('attributes.insurance_payment')>INSURANCE_PAYMENT = #attributes.insurance_payment#<cfelse>INSURANCE_PAYMENT= 0</cfif>,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#
	WHERE
		ACC_ID = #attributes.acc_id#
</cfquery>
<cfif attributes.is_detail neq 1>
	<script type="text/javascript">
		window.parent.kaza_liste.location.reload();
		window.parent.addform.location.href='<cfoutput>#request.self#?fuseaction=assetcare.popup_add_kaza</cfoutput>&iframe=1';
	</script>
<cfelse>
	<script type="text/javascript">
		self.close();
		wrk_opener_reload(); 
	</script>
</cfif>
