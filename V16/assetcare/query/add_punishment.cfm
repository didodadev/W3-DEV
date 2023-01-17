<cfif len(attributes.punishment_date)><cf_date tarih='attributes.punishment_date'></cfif>
<cfif len(attributes.last_payment_date)><cf_date tarih='attributes.last_payment_date'></cfif>
<cfif len(attributes.paid_date)><cf_date tarih='attributes.paid_date'></cfif>

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
			RECEIPT_NUM = '#attributes.receipt_num#'
	</cfquery>
	<cfif get_control.recordcount>
		<script type="text/javascript">
			alert("Plaka, Ceza Tarihi ve Makbuz Nosu Aynı Olan Bir Kayıt Var. Kontrol Ediniz !");
			history.back();
		</script>
		<cfabort>
	</cfif>
</cfif>

<cfquery name="ADD_PUNISHMENT" datasource="#DSN#">
	INSERT INTO
		ASSET_P_PUNISHMENT
	(
		ACCIDENT_ID,
		ASSETP_ID,
		EMPLOYEE_ID,
		DEPARTMENT_ID,
		RECEIPT_NUM,
		PUNISHMENT_TYPE_ID,
		PUNISHMENT_DATE,			
		PUNISHMENT_AMOUNT,
		PUNISHMENT_AMOUNT_CURRENCY,
		PAID_AMOUNT,
		PAID_AMOUNT_CURRENCY,
		LAST_PAYMENT_DATE,
		PAID_DATE,
		PAYER_ID,
		PUNISHED_LICENSE,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE,
		DETAIL
	)
	VALUES
	(
		<cfif len(attributes.accident_id)>#attributes.accident_id#<cfelse>NULL</cfif>,
		#attributes.assetp_id#,
		#attributes.employee_id#,
		#attributes.department_id#,
		<cfif len(attributes.receipt_num)>'#attributes.receipt_num#'<cfelse>NULL</cfif>,
		<cfif len(attributes.punishment_type_id)>#attributes.punishment_type_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.punishment_date)>#attributes.punishment_date#<cfelse>NULL</cfif>,
		<cfif len(attributes.punishment_amount)>#attributes.punishment_amount#<cfelse>0</cfif>,
		<cfif len(attributes.punishment_amount) and len(attributes.punishment_amount_currency)>'#attributes.punishment_amount_currency#'<cfelse>NULL</cfif>,
		<cfif len(attributes.paid_amount)>#attributes.paid_amount#<cfelse>NULL</cfif>,
		<cfif len(attributes.paid_amount) and len(attributes.paid_amount_currency)>'#attributes.paid_amount_currency#'<cfelse>NULL</cfif>,
		<cfif len(attributes.last_payment_date)>#attributes.last_payment_date#<cfelse>NULL</cfif>,
		<cfif len(attributes.paid_date)>#attributes.paid_date#<cfelse>NULL</cfif>,
		<cfif len(attributes.payer)>#attributes.payer#<cfelse>NULL</cfif>,
		<cfif len(attributes.punished_license)>#attributes.punished_license#<cfelse>NULL</cfif>,
		#session.ep.userid#,
		'#cgi.remote_addr#',
		#now()#,
		<cfif isDefined("attributes.detail") AND len(attributes.detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.detail#"><cfelse>NULL</cfif>
	)
</cfquery>
<script type="text/javascript">
<cfif isDefined("attributes.is_detail")>
   wrk_opener_reload();
   self.close();
<cfelse>
   	window.location.href = "<cfoutput>#request.self#?fuseaction=assetcare.form_add_punishment&assetp_id=#attributes.assetp_id#</cfoutput>"
</cfif>
</script>

