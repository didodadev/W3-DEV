
<cfif len(attributes.rent_start_date)><cf_date tarih='attributes.rent_start_date'></cfif>
<cfif len(attributes.rent_start_date)><cf_date tarih='attributes.rent_finish_date'></cfif>

<cfquery name="UPD_ASSETP_CONTRACT" datasource="#DSN#">
	UPDATE
		ASSET_P_RENT
	SET
		RENT_AMOUNT = <cfif len(attributes.rent_amount)>#attributes.rent_amount#<cfelse>NULL</cfif>,
		RENT_AMOUNT_CURRENCY = <cfif len(attributes.rent_amount) and len(attributes.rent_amount_currency)>'#attributes.rent_amount_currency#'<cfelse>NULL</cfif>,
		RENT_PAYMENT_PERIOD = <cfif len(attributes.rent_payment_period)>#attributes.rent_payment_period#<cfelse>NULL</cfif>,
		RENT_START_DATE = <cfif len(attributes.rent_start_date)>#attributes.rent_start_date#<cfelse>NULL</cfif>,
		RENT_FINISH_DATE = <cfif len(attributes.rent_finish_date)>#attributes.rent_finish_date#<cfelse>NULL</cfif>,
		<cfif attributes.property eq 2>
			FUEL_EXPENSE = <cfif len(attributes.is_fuel_added)>#attributes.is_fuel_added#<cfelse>NULL</cfif>,
			FUEL_AMOUNT = <cfif (attributes.is_fuel_added eq 1) and len(attributes.fuel_amount)>#attributes.fuel_amount#<cfelse>NULL</cfif>,
			FUEL_AMOUNT_CURRENCY = <cfif (attributes.is_fuel_added eq 1) and len(attributes.fuel_amount_currency)>'#attributes.fuel_amount_currency#'<cfelse>NULL</cfif>,
			CARE_EXPENSE = <cfif len(attributes.is_care_added)>#attributes.is_care_added#<cfelse>NULL</cfif>,
			CARE_AMOUNT = <cfif (attributes.is_care_added eq 1) and len(attributes.care_amount)>#attributes.care_amount#<cfelse>NULL</cfif>,
			CARE_AMOUNT_CURRENCY = <cfif (attributes.is_care_added eq 1) and len(attributes.care_amount)>'#attributes.care_amount_currency#'<cfelse>NULL</cfif>,
		</cfif>
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		ASSETP_ID = #attributes.asset_id#
</cfquery>
<script type="text/javascript">
	self.close();
</script>
