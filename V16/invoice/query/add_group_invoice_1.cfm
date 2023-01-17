<cfif is_account><!--- muhasebe hareketi yapılacaksa uye muhasebe kodu kontrol ediliyor --->
	<cfif len(invoice_comp_id)>
		<cfquery name="get_company_info" datasource="#dsn2#">
			SELECT PROFILE_ID,MEMBER_CODE,NICKNAME FROM #dsn_alias#.COMPANY WHERE COMPANY_ID = #invoice_comp_id#
		</cfquery>
		<cfif len(get_company_info.profile_id)><cfset inv_profile_id = get_company_info.profile_id></cfif>
		<cfset member_code_info = get_company_info.MEMBER_CODE & ' ' & get_company_info.NICKNAME>
		<cfset acc = GET_COMPANY_PERIOD(invoice_comp_id)>
		<cfif not len(acc)>
			<script type="text/javascript">
				alert("<cf_get_lang no='100.Seçilen Sirketin Muhasebe Kodu Belirtilmemis'>");
				history.back();
			</script>
			<cfabort>
		</cfif>
	<cfelseif len(invoice_cons_id)>
		<cfquery name="get_company_info" datasource="#dsn2#">
			SELECT PROFILE_ID,MEMBER_CODE,CONSUMER_NAME,CONSUMER_SURNAME FROM #dsn_alias#.CONSUMER WHERE CONSUMER_ID = #invoice_cons_id#
		</cfquery>
		<cfif len(get_company_info.profile_id)><cfset inv_profile_id = get_company_info.profile_id></cfif>
		<cfset member_code_info = get_company_info.MEMBER_CODE & ' ' & get_company_info.CONSUMER_NAME & ' ' & get_company_info.CONSUMER_SURNAME>
		<cfset acc = GET_CONSUMER_PERIOD(invoice_cons_id)>
		<cfif not len(acc)>
			<script type="text/javascript">
				alert("<cf_get_lang no='76.Seçilen Müsterinin Muhasebe Kodu Belirtilmemis !'>");
				history.back();
			</script>
			<cfabort>
		</cfif>
	</cfif>
</cfif>

<cfif len(GET_BILLED_INFO.MONEY_TYPE_)>
	<cfset invoice_other_money = GET_BILLED_INFO.MONEY_TYPE_>
<cfelse>
	<cfset invoice_other_money = session.ep.money>
</cfif>

<!--- vergi tanımları yapılmış mı kontrolü --->
<cfset inventory_product_exists = 0 >
<cfif GET_BILLED_INFO.IS_INVENTORY eq 1>
	<cfset inventory_product_exists = 1>
</cfif>
