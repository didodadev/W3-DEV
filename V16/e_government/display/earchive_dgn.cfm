<cfset soap = createObject("Component","V16.e_government.cfc.dogan.earsiv.soap")>
<cfset soap.init()>
<cfset common = createObject("Component","V16.e_government.cfc.dogan.earsiv.common")>

<cfif not ArrayLen(xml_error_codes)><!--- İlgili XML oluşumunda eksiklik ve Hata yok ise --->
	<cfinclude template="create_ubltr_earchive.cfm" />
    <cfset directory_name_xml	= "#upload_folder#earchive_send#dir_seperator##session.ep.company_id##dir_seperator##year(now())##dir_seperator##numberformat(month(now()),00)##dir_seperator#xml" />
	<cfset directory_name_zip	= "#upload_folder#earchive_send#dir_seperator##session.ep.company_id##dir_seperator##year(now())##dir_seperator##numberformat(month(now()),00)##dir_seperator#zip" />
	<cfset preview_invoice_xml	= "documents/earchive_send/#session.ep.company_id#/#year(now())#/#numberformat(month(now()),00)#/xml/#invoice_number#.xml" />
    <cfif not DirectoryExists(directory_name_xml)>
        <cfdirectory action="create" directory="#directory_name_xml#">
    </cfif>
    <cfif not DirectoryExists(directory_name_zip)>
        <cfdirectory action="create" directory="#directory_name_zip#">
    </cfif>
    <cfscript>
    	earchive_tmp = CreateObject("component","V16.e_government.cfc.earchieve");
    	earchive_tmp.dsn = dsn;
        earchive_tmp.dsn2 = dsn2;
        zip_filename = "#dateformat(now(),'YYYYMMDD')&timeformat(now(),'HHmmss')#_#createuuid()#.zip";
    </cfscript>
    
    <!--- E-Arşiv Fatura XML'i dosyaya yazılıyor. --->
    <cffile action="write" file="#directory_name_xml##dir_seperator##invoice_number#.xml" output="#trim(invoice_data)#" charset="utf-8" />

    <!--- Fatura önizleme sayfasından geliyor ise çalışmayı durduruyoruz --->
    <cfif attributes.fuseaction Neq 'invoice.popup_preview_invoice'>
        <cfzip source="#directory_name_xml##dir_seperator##invoice_number#.xml" action="zip" file="#directory_name_zip##dir_seperator##zip_filename#" />

        <cfif get_our_company.is_template_code eq 1>
            <cfset sendInvoice = soap.sendInvoiceData(sending_type: get_invoice.EARCHIVE_SENDING_TYPE, email : listFirst(invoice_emails,';'), ubl : invoice_data, directory_name : directory_name, invoice_number : invoice_number, zip_filename : zip_filename, invoice_prefix : invoice_prefix)>
        <cfelse>
            <cfset sendInvoice = soap.sendInvoiceData(sending_type: get_invoice.EARCHIVE_SENDING_TYPE, email : listFirst(invoice_emails,';'),ubl : invoice_data, directory_name : directory_name, invoice_number : invoice_number, zip_filename : zip_filename, invoice_prefix : left(invoice_number,3))>
        </cfif>

        <cfif sendInvoice.statuscode neq 0>
            <cfset status_code = sendInvoice.invoices[1].status_code>
            <cfset new_invoice_number = sendInvoice.invoices[1].earchiveid>
        <cfelse>
            <cfset status_code = 0>
        </cfif>
    </cfif>
<cfelse>
	<ul>
        <cfloop array="#xml_error_codes#" index="error_code">
            <cfoutput>
                <li style="list-style-image:url(/images/caution_small.gif);margin-top:5px;">#error_code#</li>
            </cfoutput>
        </cfloop>
    </ul>
    <cfabort>
</cfif>