<!--- Grup risk limiti (grup_risk_limit) ve tahmini ciro (guess_endorsement) icin guncelleme sayfasi --->
<cfquery name="update_company" datasource="#dsn#">
	UPDATE
		COMPANY
	SET
		<cfif attributes.deger is 'guess_endor'>
			GUESS_ENDORSEMENT = <cfif len(attributes.guess_endorsement)>#attributes.guess_endorsement#<cfelse>0</cfif>,
			GUESS_ENDORSEMENT_MONEY = '#attributes.guess_endorsement_money#'
		<cfelseif attributes.deger is 'risk_limit'>
			GRUP_RISK_LIMIT = <cfif len(attributes.group_risk_limit)>#attributes.group_risk_limit#<cfelse>0</cfif>,
			MONEY_CURRENCY = '#attributes.money_cat_expense#'
		</cfif>
	WHERE
		COMPANY_ID = #attributes.cpid#
</cfquery>
<script type="text/javascript">
	<cfif attributes.deger is 'risk_limit'>
		alert("<cf_get_lang no ='1015.Grup Risk Limiti Değeri Güncellendi'>!");
	<cfelseif attributes.deger is 'guess_endor'>
		alert("<cf_get_lang no ='1016.Toplam Ciro Değeri Güncellendi'>!");
	</cfif>
	window.location.href='<cfoutput>#request.self#?fuseaction=crm.popup_general_info&cpid=#attributes.cpid#&iframe=1</cfoutput>';
</script>

