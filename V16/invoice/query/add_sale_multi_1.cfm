<cfif is_account><!--- muhasebe hareketi yapılacaksa uye muhasebe kodu kontrol ediliyor --->
	<cfif len(GET_BILLED_INFO.INVOICE_COMPANY_ID)>
		<cfquery name="get_company_info" datasource="#dsn2#">
			SELECT MEMBER_CODE,NICKNAME FROM #dsn_alias#.COMPANY WHERE COMPANY_ID = #GET_BILLED_INFO.INVOICE_COMPANY_ID#
		</cfquery>
		<cfset member_code_info = get_company_info.MEMBER_CODE & ' ' & get_company_info.NICKNAME>
		<cfset acc = GET_COMPANY_PERIOD(GET_BILLED_INFO.INVOICE_COMPANY_ID)>
		<cfif invoice_cat eq 52 and not len(acc)>
			<cfset acc=GET_NO_.HIZLI_F>
		</cfif>
		<cfif not len(acc)>
			<script type="text/javascript">
				alert("<cf_get_lang no='100.Seçilen Sirketin Muhasebe Kodu Belirtilmemis'>");
				history.back();
			</script>
			<cfabort>
		</cfif>
	<cfelseif len(GET_BILLED_INFO.INVOICE_CONSUMER_ID)>
		<cfquery name="get_company_info" datasource="#dsn2#">
			SELECT MEMBER_CODE,CONSUMER_NAME,CONSUMER_SURNAME FROM #dsn_alias#.CONSUMER WHERE CONSUMER_ID = #GET_BILLED_INFO.INVOICE_CONSUMER_ID#
		</cfquery>
		<cfset member_code_info = get_company_info.MEMBER_CODE & ' ' & get_company_info.CONSUMER_NAME & ' ' & get_company_info.CONSUMER_SURNAME>
		<cfset acc = GET_CONSUMER_PERIOD(GET_BILLED_INFO.INVOICE_CONSUMER_ID)>
		<cfif invoice_cat eq 52 and not len(acc)>
			<cfset acc=GET_NO_.HIZLI_F>
		</cfif>
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
<cfquery name="get_taxes" datasource="#dsn2#">
	SELECT * FROM SETUP_TAX
</cfquery>
<cfquery name="get_otv" datasource="#dsn2#">
	SELECT OTV_ID,TAX,ACCOUNT_CODE FROM #dsn3_alias#.SETUP_OTV WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# ORDER BY TAX
</cfquery>
<cfquery name="get_bsmv" datasource="#dsn2#">
	SELECT BSMV_ID,TAX,ACCOUNT_CODE,ISNULL(DIRECT_EXPENSE_CODE,0) DIRECT_EXPENSE_CODE FROM #dsn3_alias#.SETUP_BSMV WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# ORDER BY TAX
</cfquery>
<cfquery name="get_oiv" datasource="#dsn2#">
	SELECT OIV_ID,TAX,ACCOUNT_CODE FROM #dsn3_alias#.SETUP_OIV WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# ORDER BY TAX
</cfquery>
