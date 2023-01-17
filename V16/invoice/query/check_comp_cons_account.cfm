<cfinclude template = "../../objects/query/session_base.cfm">
<cfif isDefined("attributes.company_id") and len(attributes.company_id) and isDefined("attributes.comp_name") and len(attributes.comp_name)>
	<cfif not isdefined("new_period_id")><cfset new_period_id = session_base.period_id></cfif>
	<cfset acc = GET_COMPANY_PERIOD(company_id:attributes.company_id,period_id:new_period_id,acc_type_id:len(is_account_type_id) ? is_account_type_id : "")>
	<cfif invoice_cat eq 52 and not len(acc)>
		<cfset acc=GET_NO_.HIZLI_F>
	</cfif>
	<cfif invoice_cat eq 5311>
		<cfset attributes.acc_type_id = -9>
		<cfset acc_export= GET_COMPANY_PERIOD(company_id:attributes.company_id,acc_type_id:attributes.acc_type_id)>
		<cfif not len(acc_export)>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='61249.Seçilen Üyenin İhraç Kayıtlı Satış Muhasebe Kodu Belirtilmemis'>");
				window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
			</script>
			<cfabort>
		</cfif>
	</cfif>
	<cfif not len(acc)>
		<cfif not isdefined('xml_import')>
			<script type="text/javascript">
				alert("<cf_get_lang no='100.Seçilen Sirketin Muhasebe Kodu Belirtilmemis'>");
				window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
				//history.back();
			</script>
			<cfabort>
		<cfelse>
			<cfoutput>#attributes.invoice_number#</cfoutput> <cf_get_lang no='100.Seçilen Sirketin Muhasebe Kodu Belirtilmemis'><br/>
			<cfset error_flag =1>
		</cfif>
	</cfif>
<cfelseif isDefined("attributes.consumer_id") and len(attributes.consumer_id)>
	<cfset acc = GET_CONSUMER_PERIOD(consumer_id:attributes.consumer_id,acc_type_id:len(is_account_type_id) ? is_account_type_id : "")>
	<cfif invoice_cat eq 52 and not len(acc)>
		<cfset acc=GET_NO_.HIZLI_F>
	</cfif>
	<cfif invoice_cat eq 5311>
		<cfset attributes.acc_type_id = -9>
		<cfset acc_export= GET_CONSUMER_PERIOD(consumer_id:attributes.consumer_id,acc_type_id:attributes.acc_type_id)>
		<cfif not len(acc_export)>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='61249.Seçilen Üyenin İhraç Kayıtlı Satış Muhasebe Kodu Belirtilmemis'>");
				window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
			</script>
			<cfabort>
		</cfif>
	</cfif>
	<cfif not len(acc)>
		<cfif not isdefined('xml_import')>
			<script type="text/javascript">
				alert("<cf_get_lang no='76.Seçilen Müsterinin Muhasebe Kodu Belirtilmemis !'>");
				window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
				//history.back();
			</script>
			<cfabort>
		<cfelse>
			<cfoutput>#attributes.invoice_number#</cfoutput> <cf_get_lang no='76.Seçilen Müsterinin Muhasebe Kodu Belirtilmemis !'><br/>
			<cfset error_flag =1>
		</cfif>
	</cfif>
<cfelseif isDefined("attributes.employee_id") and len(attributes.employee_id) and not isDefined('is_from_zreport')>
	<cfif not isdefined("attributes.acc_type_id")><cfset attributes.acc_type_id = len(is_account_type_id) ? is_account_type_id : ""></cfif>
	<cfset acc = GET_EMPLOYEE_PERIOD(attributes.employee_id,attributes.acc_type_id)>
	<cfif invoice_cat eq 52 and not len(acc)>
		<cfset acc=GET_NO_.HIZLI_F>
	</cfif>
	<cfif not len(acc)>
		<cfif not isdefined('xml_import')>
			<script type="text/javascript">
				alert("<cf_get_lang no='76.Seçilen Müsterinin Muhasebe Kodu Belirtilmemis !'>");
				window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
				//history.back();
			</script>
			<cfabort>
		<cfelse>
			<cfoutput>#attributes.invoice_number#</cfoutput> <cf_get_lang no='76.Seçilen Müsterinin Muhasebe Kodu Belirtilmemis !'><br/>
			<cfset error_flag =1>
		</cfif>
	</cfif>
<cfelseif invoice_cat eq 52><!--- hizli fatura muhasebe hesabı --->
	<cfset acc=GET_NO_.HIZLI_F>
	<cfif not len(acc)>
		<cfif not isdefined('xml_import')>
			<script type="text/javascript">
				alert("Muhasebe Kodu Belirtilmemis");
				window.location.href='<cfoutput>#cgi.referer#</cfoutput>';
				//history.back();
			</script>
			<cfabort>
		<cfelse>
			<cfoutput>#attributes.invoice_number#</cfoutput> <cf_get_lang no="26.Muhasebe Kodu Belirtilmemis"> <br/>
			<cfset error_flag =1>
		</cfif>
	</cfif>
</cfif>
