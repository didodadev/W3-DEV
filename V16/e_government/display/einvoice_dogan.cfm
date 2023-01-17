<cfset soap = createObject("Component","V16.e_government.cfc.dogan.efatura.soap")>
<cfset soap.init()>
<cfset common = createObject("Component","V16.e_government.cfc.dogan.efatura.common")>

<cfinclude template="create_ubltr.cfm" />
<!--- XML dosya olusturuluyor --->
<cffile action="write" file="#directory_name##dir_seperator##invoice_number#.xml" output="#trim(invoice_data)#" charset="utf-8" />

<cfif get_our_company.is_template_code eq 1>
	<cfif not len(invoice_prefix)>
		Lütfen seri alanına geçerli bir ön ek giriniz.
		<cfabort>
	</cfif>
</cfif>

<!--- Fatura önizleme sayfasından geliyor ise çalışmayı durduruyoruz --->
<cfif attributes.fuseaction Neq 'invoice.popup_preview_invoice'>
	<cfset save_folder		= "#upload_folder#e_government#dir_seperator#xml" />

	<cfif get_our_company.is_template_code eq 1>
		<cfset sendInvoice = soap.sendInvoiceData(ubl : invoice_data, directory_name : directory_name, invoice_number : invoice_number, invoice_prefix : invoice_prefix)>
	<cfelse>
		<cfset sendInvoice = soap.sendInvoiceData(ubl : invoice_data, directory_name : directory_name, invoice_number : invoice_number, invoice_prefix : left(invoice_number,3))>
	</cfif>

	<cfif sendInvoice.statuscode neq 0>
		<cfset status_code = sendInvoice.invoices[1].status_code>
		<cfset new_invoice_number = sendInvoice.invoices[1].einvoiceid>
	<cfelse>
		<cfset status_code = 0>
	</cfif>
</cfif>
