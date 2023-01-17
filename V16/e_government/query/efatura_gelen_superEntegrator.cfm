<cfscript>
	get_einv_comp_tmp= createObject("component","V16.e_government.cfc.einvoice");
	get_einv_comp_tmp.dsn = dsn;
	get_einv_comp = get_einv_comp_tmp.get_our_company_fnc(company_id: session.ep.company_id);
</cfscript>

<cfloop query="GET_EINV_COMP">
	<cfquery name="GET_ADMIN" datasource="#DSN#">
        SELECT ADMIN_MAIL,COMPANY_NAME FROM OUR_COMPANY WHERE ADMIN_MAIL IS NOT NULL AND COMP_ID = #get_einv_comp.comp_id#
    </cfquery>
    <cfquery name="get_process_row" datasource="#dsn#">
        SELECT 
            PTR.PROCESS_ROW_ID 
        FROM 
            PROCESS_TYPE PT, 
            PROCESS_TYPE_ROWS PTR,
            PROCESS_TYPE_OUR_COMPANY PTO
        WHERE 
            PT.PROCESS_ID = PTO.PROCESS_ID AND
            PT.PROCESS_ID = PTR.PROCESS_ID AND
            PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_einv_comp.comp_id#">  AND
            PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%objects.popup_dsp_efatura_detail%"> AND 
            PTR.LINE_NUMBER = 1
    </cfquery>
    
    <cfif get_process_row.recordcount eq 0>
		<br /><cfoutput>(#get_admin.company_name#)</cfoutput> Şirketinde Gelen E-Fatura Süreçlerini Kontrol Ediniz. <cfabort>
    </cfif>

    <cfset directory_name = getDirectoryFromPath(getBaseTemplatePath()) & "documents/invoice_received">
    <cfif not isDefined("soap")>
        <cfobject name="soap" type="component" component="V16.e_government.cfc.super.einvoice.soap">
        <cfset soap.init()>
    </cfif>
    <cfif not isDefined("common")>
        <cfobject name="common" type="component" component="V16.e_government.cfc.super.einvoice.common">
    </cfif>

    <cfset received_invoices = soap.GetAvailableInvoices(company_id : get_einv_comp.comp_id)>

    <cfset directory_name = "#upload_folder#einvoice_received/#get_einv_comp.comp_id#/#year(now())#/#numberformat(month(now()),00)#">

    <cfloop array="#received_invoices.invoices#" index="invoice">
        <cftry>
            <cfif len(invoice.InvoiceID)>
                <cfif not DirectoryExists(directory_name)>
                    <cfdirectory action="create" directory="#directory_name#">
                </cfif>
                <cfquery name = "getPeriod" datasource = "#dsn#">
                    SELECT * FROM SETUP_PERIOD WHERE OUR_COMPANY_ID = #get_einv_comp.comp_id# AND '#listFirst(invoice.issuetime,'T')#' BETWEEN START_DATE AND FINISH_DATE
                </cfquery>
                <cfset dsn2 = '#dsn#_#getPeriod.period_year#_#get_einv_comp.comp_id#'>
                <cfset ubl_format = soap.getInvoicePDF(uuid: invoice.uuid, outputType: 'Ubl', direction: 'Incoming', ticket_req : 0)>

                <cffile action="write" file="#directory_name#/#invoice.uuid#.xml" output="#toString(tobinary(ubl_format.PDF_DATA))#" charset="utf-8" />

                <cfquery name="INVOICE_CONTROL" datasource="#DSN2#">
                    SELECT 1 FROM EINVOICE_RECEIVING_DETAIL WHERE UUID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#invoice.UUID#">
                </cfquery>

                <!--- IS_APPROVE alanı fatura Kaydet butonunun gelmesi icin düzenlendi--->
				<cfif not invoice_control.recordcount>
					<cfscript>
						add_invoice_receive_temp = CreateObject("component","V16.e_government.cfc.einvoice");
						add_invoice_receive_temp.dsn2 = dsn2;
						if(get_einv_comp.is_receiving_process eq 1) is_approve = 0; else is_approve = 1;
						add_invoice_receive_temp.add_received_invoices(service_result:'Successful',
																		uuid:invoice.uuid,
																		einvoice_id:invoice.invoiceid,
																		status_description:invoice.statusdescription,
																		status_code:invoice.statuscode,
																		error_code:0,
																		invoice_type_code:invoice.invoicetypecode,
																		sender_tax_id:invoice.sendertaxid,
																		receiver_tax_id:invoice.receivertaxid,
																		profile_id:invoice.profileid,
																		payable_amount:invoice.totalamount,
																		payable_amount_currency:invoice.currency,
																		issue_date:listFirst(invoice.issuetime,'T'),
																		party_name:invoice.partyname,
																		process_stage:get_process_row.process_row_id,
																		einvoice_type:5,
																		is_approve:is_approve,
																		company_id:get_einv_comp.comp_id);
						</cfscript>
				</cfif>
            </cfif>
            <cfcatch>
                <cfdump var="#cfcatch#">
                <cfdump var="#invoice#">
                <cfabort>
            </cfcatch>
        </cftry>
    </cfloop>
    <cfoutput>(#get_admin.company_name#)</cfoutput> gelen e-fatura raporu başarılı bir şekilde çalıştırıldı.<br />
</cfloop>