<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.is_delete') and attributes.is_delete eq 1>
	<cfquery name="del_query" datasource="#dsn#">
		DELETE 
		FROM 
			INSURANCE_PAYMENT
		WHERE
			INS_PAY_ID = #attributes.INS_PAY_ID#
	</cfquery>
<cfelse>
	<cf_date tarih="attributes.startdate">
	<cf_date tarih="attributes.finishdate">
	<cfif year(attributes.startdate) neq year(attributes.finishdate)>
		<script type="text/javascript">
			alert("<cf_get_lang no='416.Girilen kaydın başlangıç ve bitiş tarihi aynı yıl içerisinde olmalıdır'>!");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfquery name="get_query" datasource="#dsn#">
		SELECT 
			INS_PAY_ID, 
			STARTDATE, 
			FINISHDATE, 
			MIN_PAYMENT, 
			MAX_PAYMENT, 
			MIN_GROSS_PAYMENT_NORMAL, 
			MIN_GROSS_PAYMENT_16, 
			SENIORITY_COMPANSATION_MAX, 
			UPDATE_DATE,
			UPDATE_IP, 
			UPDATE_EMP 
		FROM 
			INSURANCE_PAYMENT 
		WHERE 
			STARTDATE < #DATEADD("d",1,attributes.finishdate)# 
		AND 
			FINISHDATE > #DATEADD("d",-1,attributes.startdate)# AND INS_PAY_ID <> #attributes.INS_PAY_ID# 
	</cfquery>
	<cfif get_query.recordcount>
			<script type="text/javascript">
				alert('Varolan tarihe tekrar tanım giremezsiniz!');
				history.back();
			</script>
			<cfabort>
	</cfif>
	<cfquery name="UPD_QUERY" datasource="#dsn#">
		UPDATE INSURANCE_PAYMENT
		SET
			STARTDATE = #attributes.STARTDATE#,
			FINISHDATE = #attributes.FINISHDATE#,
			MIN_PAYMENT = #attributes.MINIMUM#,
			MAX_PAYMENT = #attributes.MAXIMUM#,
			MIN_GROSS_PAYMENT_NORMAL = #attributes.MIN_GROSS_PAYMENT_NORMAL#,
			MIN_GROSS_PAYMENT_16 = #attributes.MIN_GROSS_PAYMENT_16#,
			SENIORITY_COMPANSATION_MAX = #attributes.seniority_compansation_max#,
			UPDATE_IP = '#CGI.REMOTE_ADDR#',
			UPDATE_EMP = #SESSION.EP.USERID#,
			UPDATE_DATE = #NOW()#
		WHERE
			INS_PAY_ID = #attributes.INS_PAY_ID#
	</cfquery>
</cfif>

<cfset attributes.actionId = attributes.INS_PAY_ID>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelseif isdefined("attributes.draggable")>
		$('#payments_box .catalyst-refresh').click();
		closeBoxDraggable( 'upd_payment_box' );
	</cfif>
</script>