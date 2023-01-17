<cfif not isDefined("attributes.UPD")>
	<cfquery name="ADD_DEF" datasource="#DSN3#">
		INSERT INTO 
			SETUP_INVOICE
		(
			HIZLI_F,
			VERILEN_D_F,
			FARK_GIDER,
			FARK_GELIR,
			MONEY_CREDIT,
			GIFT_CARD,
			A_DISC
		)
		VALUES
		(
			'#attributes.hizli_f#',
			'#attributes.verilen_d_f#',
			'#attributes.FARK_GIDER#',
			'#attributes.FARK_GELIR#',
			<cfif len(attributes.MONEY_CREDIT)>'#attributes.MONEY_CREDIT#'<cfelse>NULL</cfif>,
			<cfif len(attributes.GIFT_CARD)>'#attributes.GIFT_CARD#'<cfelse>NULL</cfif>,
			<cfif len(attributes.A_DISC)>'#attributes.A_DISC#'<cfelse>NULL</cfif>
		)
	</cfquery>
<cfelse>
	<cfquery name="ADD_DEF" datasource="#DSN3#">
		UPDATE 
			SETUP_INVOICE
		SET
			HIZLI_F = '#attributes.hizli_f#',
			VERILEN_D_F = '#attributes.verilen_d_f#',
			FARK_GIDER = '#attributes.FARK_GIDER#',
			FARK_GELIR = '#attributes.FARK_GELIR#',
			A_DISC = <cfif len(attributes.A_DISC)>'#attributes.A_DISC#'<cfelse>NULL</cfif>,
			MONEY_CREDIT = <cfif len(attributes.MONEY_CREDIT)>'#attributes.MONEY_CREDIT#'<cfelse>NULL</cfif>,
			GIFT_CARD = <cfif len(attributes.GIFT_CARD)>'#attributes.GIFT_CARD#'<cfelse>NULL</cfif>
	</cfquery>
</cfif>
<script type="text/javascript">
	window.location.href="<cfoutput>#CGI.HTTP_REFERER#</cfoutput>";
</script>
