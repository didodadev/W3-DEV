<cfquery name="GET_CREDIT_LIMIT" datasource="#dsn#">
	SELECT 
		COMPANY_CREDIT_ID 
	FROM 
		COMPANY_CREDIT
	WHERE 
		COMPANY_ID = #ATTRIBUTES.COMPANY_ID# AND
		OUR_COMPANY_ID = #ATTRIBUTES.OUR_COMPANY_ID# AND
		COMPANY_CREDIT_ID <> #ATTRIBUTES.COMPANY_CREDIT_ID#
</cfquery>


<cfif get_credit_limit.recordcount eq 0>
	<cfif isdefined("form.OPEN_ACCOUNT_RISK_LIMIT") and len(form.OPEN_ACCOUNT_RISK_LIMIT)>
		<cfscript>
			StructInsert(form,"TOTAL_RISK_LIMIT","0");
			form.TOTAL_RISK_LIMIT = form.OPEN_ACCOUNT_RISK_LIMIT + FORWARD_SALE_LIMIT;			
		</cfscript>
		<cfquery name="UPD_COMPANY_CREDIT" datasource="#dsn#">
		UPDATE
			COMPANY_CREDIT
				SET
				COMPANY_ID=#FORM.COMPANY_ID#,
				OPEN_ACCOUNT_RISK_LIMIT=<cfif LEN(FORM.OPEN_ACCOUNT_RISK_LIMIT)>#FORM.OPEN_ACCOUNT_RISK_LIMIT#<cfelse>NULL</cfif> ,
				FORWARD_SALE_LIMIT=<cfif LEN(FORM.FORWARD_SALE_LIMIT)>#FORM.FORWARD_SALE_LIMIT#<cfelse>NULL</cfif>,
				LAST_PAYMENT_INTEREST=<cfif LEN(FORM.LAST_PAYMENT_INTEREST)>#FORM.LAST_PAYMENT_INTEREST#<cfelse>NULL</cfif>,
				PAYMENT_BLOKAJ = <cfif LEN(FORM.PAYMENT_BLOKAJ)>#FORM.PAYMENT_BLOKAJ#<cfelse>NULL</cfif>,
				STOK_MALIYET_BLOKAJ = <cfif LEN(FORM.STOK_MALIYET_BLOKAJ)>#FORM.STOK_MALIYET_BLOKAJ#<cfelse>NULL</cfif>,
				FIRST_PAYMENT_INTEREST=<cfif LEN(FORM.FIRST_PAYMENT_INTEREST)>#FORM.FIRST_PAYMENT_INTEREST#<cfelse>NULL</cfif>,
				PAYMETHOD_ID=<cfif LEN(FORM.PAYMETHOD_ID)>#FORM.PAYMETHOD_ID#<cfelse>NULL</cfif>,
				MONEY=<cfif LEN(FORM.MONEY)>'#FORM.MONEY#'<cfelse>NULL</cfif>,
				TOTAL_RISK_LIMIT=<cfif LEN(FORM.TOTAL_RISK_LIMIT)>#FORM.TOTAL_RISK_LIMIT#<cfelse>NULL</cfif>,
				OUR_COMPANY_ID = #FORM.OUR_COMPANY_ID#
			WHERE 
				COMPANY_CREDIT_ID = #ATTRIBUTES.COMPANY_CREDIT_ID#
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

