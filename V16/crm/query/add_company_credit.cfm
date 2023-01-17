<cfquery name="GET_CREDIT_LIMIT" datasource="#dsn#">
	SELECT 
		COMPANY_CREDIT_ID 
	FROM 
		COMPANY_CREDIT
	WHERE 
		COMPANY_ID = #ATTRIBUTES.COMPANY_ID# AND
		OUR_COMPANY_ID = #ATTRIBUTES.OUR_COMPANY_ID#
</cfquery>


<cfif get_credit_limit.recordcount eq 0>
	<cfif isdefined("form.OPEN_ACCOUNT_RISK_LIMIT") and len(form.OPEN_ACCOUNT_RISK_LIMIT)>
		<cfscript>
			StructInsert(form,"TOTAL_RISK_LIMIT","0");
			form.TOTAL_RISK_LIMIT = form.OPEN_ACCOUNT_RISK_LIMIT + FORWARD_SALE_LIMIT;			
		</cfscript>
		<cfquery name="ADD_COMPANY_CREDIT" datasource="#dsn#">
		INSERT INTO
			COMPANY_CREDIT
				(
					COMPANY_ID,
					OPEN_ACCOUNT_RISK_LIMIT,
					FORWARD_SALE_LIMIT,
					PAYMENT_BLOKAJ,
					STOK_MALIYET_BLOKAJ,
					LAST_PAYMENT_INTEREST,
					FIRST_PAYMENT_INTEREST,
					PAYMETHOD_ID,
					MONEY,
					TOTAL_RISK_LIMIT ,
					OUR_COMPANY_ID             
				)
			VALUES
				(
					#ATTRIBUTES.COMPANY_ID# ,
					<cfif LEN(FORM.OPEN_ACCOUNT_RISK_LIMIT)>#FORM.OPEN_ACCOUNT_RISK_LIMIT#,<cfelse>NULL,</cfif>
					<cfif LEN(FORM.FORWARD_SALE_LIMIT)>#FORM.FORWARD_SALE_LIMIT#,<cfelse>NULL,</cfif>
					<cfif LEN(FORM.PAYMENT_BLOKAJ)>#FORM.PAYMENT_BLOKAJ#,<cfelse>NULL,</cfif>
					<cfif LEN(FORM.STOK_MALIYET_BLOKAJ)>#FORM.STOK_MALIYET_BLOKAJ#,<cfelse>NULL,</cfif>
					<cfif LEN(FORM.LAST_PAYMENT_INTEREST)>#FORM.LAST_PAYMENT_INTEREST#,<cfelse>NULL,</cfif>
					<cfif LEN(FORM.FIRST_PAYMENT_INTEREST)>#FORM.FIRST_PAYMENT_INTEREST#,<cfelse>NULL,</cfif>
					<cfif LEN(FORM.PAYMETHOD_ID)>#FORM.PAYMETHOD_ID#,<cfelse>NULL,</cfif>
					<cfif LEN(FORM.MONEY)>'#FORM.MONEY#',<cfelse>NULL,</cfif>
					<cfif LEN(FORM.TOTAL_RISK_LIMIT)>#FORM.TOTAL_RISK_LIMIT#<cfelse>NULL</cfif>,
					#FORM.OUR_COMPANY_ID#
				)
		</cfquery>
	</cfif>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no ='986.Bir Üyeye Aynı Dönem İçin İki Farklı Risk Durumu Giremezsiniz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>
<script type="text/javascript">
 	wrk_opener_reload();
 	window.close();
</script>

 
