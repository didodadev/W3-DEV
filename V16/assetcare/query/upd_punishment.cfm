<cfif len(attributes.punishment_date)><cf_date tarih='attributes.punishment_date'></cfif>
<cfif len(attributes.last_payment_date)><cf_date tarih='attributes.last_payment_date'></cfif>
<cfif len(attributes.paid_date)><cf_date tarih='attributes.paid_date'></cfif>
<!--- <cfdump var="#attributes#" abort> --->
<!--- BK 20090612 xml deki kontrol icin duzenlendi --->
<cfif isdefined("attributes.x_control") and attributes.x_control eq 1>
	<cfquery name="GET_CONTROL" datasource="#DSN#">
		SELECT 
			ASSETP_ID
		FROM
			ASSET_P_PUNISHMENT
		WHERE
			ASSETP_ID = #attributes.assetp_id# AND
			PUNISHMENT_DATE = #attributes.punishment_date# AND
			RECEIPT_NUM = '#attributes.receipt_num#' AND
			PUNISHMENT_ID <> #attributes.punishment_id#
	</cfquery>
	<cfif get_control.recordcount>
		<script type="text/javascript">
			alert("Plaka, Ceza Tarihi ve Makbuz Nosu Aynı Olan Bir Kayıt Var. Kontrol Ediniz !");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>

<cfquery name="UPD_PUNISHMENT" datasource="#DSN#">
	UPDATE
		ASSET_P_PUNISHMENT
	SET
		ACCIDENT_ID = <cfif len(attributes.accident_id)>#attributes.accident_id#<cfelse>NULL</cfif>,
		ASSETP_ID = #attributes.assetp_id#,
		EMPLOYEE_ID = #attributes.employee_id#,
		DEPARTMENT_ID = #attributes.department_id#,
		RECEIPT_NUM = <cfif len(attributes.receipt_num)>'#attributes.receipt_num#'<cfelse>NULL</cfif>,
		PUNISHMENT_TYPE_ID = <cfif len(attributes.punishment_type_id)>#attributes.punishment_type_id#<cfelse>NULL</cfif>,
		PUNISHMENT_DATE = <cfif len(attributes.punishment_date)>#attributes.punishment_date#<cfelse>NULL</cfif>,
		PUNISHMENT_AMOUNT = <cfif len(attributes.punishment_amount)>#attributes.punishment_amount#<cfelse>NULL</cfif>,
		PUNISHMENT_AMOUNT_CURRENCY = <cfif len(attributes.punishment_amount)and len(attributes.punishment_amount_currency)>'#attributes.punishment_amount_currency#'<cfelse>NULL</cfif>,
		PAID_AMOUNT = <cfif len(attributes.paid_amount)>#attributes.paid_amount#<cfelse>NULL</cfif>,
		PAID_AMOUNT_CURRENCY = <cfif len(attributes.paid_amount) and len(attributes.paid_amount_currency)>'#attributes.paid_amount_currency#'<cfelse>NULL</cfif>,
		LAST_PAYMENT_DATE = <cfif len(attributes.last_payment_date)>#attributes.last_payment_date#<cfelse>NULL</cfif>,
		PAID_DATE= <cfif len(attributes.paid_date)>#attributes.paid_date#<cfelse>NULL</cfif>,
		PAYER_ID = <cfif len(attributes.payer)>#attributes.payer#<cfelse>NULL</cfif>,
		PUNISHED_LICENSE = <cfif len(attributes.punished_license)>#attributes.punished_license#<cfelse>NULL</cfif>,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		DETAIL = <cfif isDefined("attributes.detail") AND len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>
	WHERE
		PUNISHMENT_ID = #attributes.punishment_id#
</cfquery>
<cfif isdefined("attributes.is_detail")>
	<script type="text/javascript">
		// wrk_opener_reload(); 
		window.location.href = "<cfoutput>#request.self#?fuseaction=assetcare.form_search_punishment</cfoutput>"
		<cfif not isdefined("attributes.draggable")>self.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
	</script>
<cfelse>
	<script type="text/javascript">
		 window.location.href = "<cfoutput>#request.self#?fuseaction=assetcare.form_add_punishment&assetp_id=#attributes.assetp_id#</cfoutput>"
	</script>
</cfif>
