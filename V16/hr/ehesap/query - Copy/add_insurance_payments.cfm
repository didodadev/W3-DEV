<cf_date tarih="attributes.startdate">
<cf_date tarih="attributes.finishdate">
<cfif year(attributes.startdate) neq year(attributes.finishdate)>
	<script type="text/javascript">
		alert("<cf_get_lang no='416.Girilen kaydın başlangıç ve bitiş tarihi aynı yıl içerisinde olmalıdır'>!");
		<cfif not isdefined("attributes.draggable")>
			history.back();
		<cfelseif isdefined("attributes.draggable")>
			$('#payments_box .catalyst-refresh').click();
			closeBoxDraggable( 'add_payment_box' );
		</cfif>
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
         RECORD_DATE, 
         RECORD_IP, 
         RECORD_EMP, 
         MIN_GROSS_PAYMENT_NORMAL,
         MIN_GROSS_PAYMENT_16, 
         SENIORITY_COMPANSATION_MAX, 
         UPDATE_DATE, 
         UPDATE_IP, 
         UPDATE_EMP 
     FROM 
	     INSURANCE_PAYMENT 
     WHERE 
     	STARTDATE < #DATEADD("d",1,attributes.finishdate)# AND FINISHDATE > #DATEADD("d",-1,attributes.startdate)# 
</cfquery>
<cfif get_query.recordcount>
		<script type="text/javascript">
			alert('Varolan tarihe tekrar tanım giremezsiniz!');
			<cfif not isdefined("attributes.draggable")>
				history.back();
			<cfelseif isdefined("attributes.draggable")>
				$('#payments_box .catalyst-refresh').click();
				closeBoxDraggable( 'add_payment_box' );
			</cfif>
		</script>
		<cfabort>
</cfif>
<cfquery name="add_query" datasource="#dsn#">
	INSERT INTO INSURANCE_PAYMENT
		(
		STARTDATE,
		FINISHDATE,
		MIN_PAYMENT,
		MAX_PAYMENT,
		MIN_GROSS_PAYMENT_NORMAL,
		MIN_GROSS_PAYMENT_16,
		SENIORITY_COMPANSATION_MAX,
		RECORD_IP,
		RECORD_EMP,
		RECORD_DATE
		)
	VALUES
		(
		#attributes.STARTDATE#,
		#attributes.FINISHDATE#,
		#attributes.MINIMUM#,
		#attributes.MAXIMUM#,
		#attributes.MIN_GROSS_PAYMENT_NORMAL#,
		#attributes.MIN_GROSS_PAYMENT_16#,
		#attributes.seniority_compansation_max#,
		'#CGI.REMOTE_ADDR#',
		#SESSION.EP.USERID#,
		#NOW()#
		)
</cfquery>
<cfquery name="get_max" datasource="#dsn#">
	SELECT 
    	MAX(INS_PAY_ID) AS ID
    FROM
    	INSURANCE_PAYMENT
</cfquery>
<cfset attributes.actionId = get_max.ID>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		wrk_opener_reload();
		window.close();
	<cfelseif isdefined("attributes.draggable")>
		$('#payments_box .catalyst-refresh').click();
		closeBoxDraggable( 'add_payment_box' );
	</cfif>
</script>