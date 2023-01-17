<!---
    File: add_efatura_xml.cfm
    Folder: V16\e_government\query\
	Controller: 
    Author:
    Date:
    Description:
        
    History:
		Gramoni-Mahmut mahmut.cifci@gramoni.com 2020-01-07 18:34:19
		Gelen efaturaya irsaliye ilişkilendirme düzenlemesi yapıldı

		Gramoni-Mahmut Çifçi mahmut.cifci@gramoni.com 2020-03-27 23:55:34
        E-government standart modüle taşındı
    To Do:

--->

<cfsetting showdebugoutput="no">
<!--- e-fatura tanimlarini getiriyor --->
<cfscript>
	get_einv_comp_tmp= createObject("component","V16.e_government.cfc.einvoice");
	get_einv_comp_tmp.dsn = dsn;
	get_einv_comp = get_einv_comp_tmp.get_our_company_fnc(company_id:session.ep.company_id);
</cfscript>
<cfif isdefined('attributes.associate') and attributes.associate eq 1><!--- belge iliskilendirmeden geliyor ise --->
	<!--- E-Fatura Onay islemi--->
	<cfif related_invoice_type is 'expense'>
		<cfset temp_expense_id = 1>
        <cfset max_id.identitycol = attributes.related_invoice_id>
    <cfelse>
    	<cfset get_invoice_id.max_id = attributes.related_invoice_id>
    </cfif>
    <cfinclude template="einvoice_approval.cfm" />
    
    <script>
		alert("<cf_get_lang dictionary_id='51250.Gelen E-Fatura Belge ile İlişkilendirilmiştir'> !");
		window.close();
	</script>
	<cfabort>
<cfelseif not isdefined("attributes.is_upd")>
	<cfset upload_folder_ = "#upload_folder#einvoice_received#dir_seperator##session.ep.company_id##dir_seperator##session.ep.period_year##dir_seperator##numberformat(month(now()),00)##dir_seperator#">
	<cfif not directoryexists("#upload_folder_#")>
		<cfdirectory action="create" directory="#upload_folder_#">
	</cfif>
	<cffile action = "upload" 
			fileField = "uploaded_file" 
			destination = "#upload_folder_#"
			nameConflict = "MakeUnique"  
			mode="777">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
	<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#">	
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset file_size = cffile.filesize>
	<cfset dosya_yolu = "#upload_folder_##file_name#">
	<cffile action="read" file="#dosya_yolu#" variable="inv_xml_data" charset="utf-8">
	<cftry>
		<cfscript>
			xml_doc = XmlParse(inv_xml_data);
			if(isdefined("xml_doc.Invoice.AccountingSupplierParty.Party.PartyName.Name.XmlText"))
				member_name_gelen = '#xml_doc.Invoice.AccountingSupplierParty.Party.PartyName.Name.XmlText#';
			else
				member_name_gelen = '';
					
			versiyon_no = '#xml_doc.Invoice.CustomizationID.XmlText#';
			invoice_type = '#xml_doc.Invoice.ProfileID.XmlText#';
			invoice_sale_type = '#xml_doc.Invoice.InvoiceTypeCode.XmlText#';
			invoice_number = '#xml_doc.Invoice.Id.XmlText#';
			invoice_date = '#xml_doc.Invoice.IssueDate.XmlText#';
			temp_UUID = '#xml_doc.Invoice.UUID.XmlText#';
			invoice_money = '#xml_doc.Invoice.LegalMonetaryTotal.LineExtensionAmount.XmlAttributes.currencyID#';
			pay_total = '#xml_doc.Invoice.LegalMonetaryTotal.PayableAmount.XmlText#';
			if(isdefined("xml_doc.Invoice.OrderReference.Id.XmlText"))
				order_no = '#xml_doc.Invoice.OrderReference.Id.XmlText#';
			else
				order_no = '';
		</cfscript>
		<cfcatch type="any">
			<script>
				alert('XML Dosyası Okunamadı , Lütfen XML Formatını Kontrol Ediniz !');
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
	<cfif isdefined("invoice_number")>
		<cfset AccountingSupplierParty	= xml_doc.Invoice.AccountingSupplierParty.Party.PartyIdentification />
		<cfloop from="1" to="#arraylen(AccountingSupplierParty)#" index="f">
			<cfset vkn_type = '#AccountingSupplierParty[f].Id.XmlAttributes.schemeID#' />
			<cfif vkn_type is 'VKN' or  vkn_type is 'TCKN'>                
				<cfset vkn = '#AccountingSupplierParty[f].Id.XmlText#' />
				<cfbreak>
			</cfif>
		</cfloop>
		<cfset AccountingCustomerParty	= xml_doc.Invoice.AccountingCustomerParty.Party.PartyIdentification />
		<cfloop from="1" to="#arraylen(AccountingCustomerParty)#" index="g">
			<cfset vkn_type = '#AccountingCustomerParty[g].Id.XmlAttributes.schemeID#'>
			<cfif vkn_type is 'VKN' or  vkn_type is 'TCKN'>
				<cfset receiver_tax_id = '#AccountingCustomerParty[g].Id.XmlText#' />
				<cfbreak>
			</cfif>
		</cfloop>
		<cfif not isdefined("vkn")>
			<script>
				alert('XML Dosyada Vergi No Bilgisi Bulunamadı, Lütfen XML Formatını Kontrol Ediniz !');
				history.back();
			</script>
			<cfabort>
		</cfif>
        <cfquery name="chk_tax_no" datasource="#dsn2#">
            SELECT TAX_NO FROM #dsn_alias#.OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND TAX_NO = '#receiver_tax_id#'
        </cfquery>
        <cfif not chk_tax_no.recordcount>
            <script>
		         alert("Eklemek İstediğiniz Belgedeki Vergi No Bulunduğunuz Sirket Vergi No ile Aynı Değil !");
				 history.back();
			</script>
			<cfabort>
		</cfif> 
		<cfquery name="control" datasource="#dsn2#">
			SELECT EINVOICE_ID FROM EINVOICE_RECEIVING_DETAIL WHERE EINVOICE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#invoice_number#"> AND SENDER_TAX_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#vkn#"> 
		</cfquery>
		<cfif control.recordcount>
			<script type="text/javascript">
				alert("Eklemek İstediğiniz Belge Daha Önce Eklenmiş , Lütfen Bilgileri Kontrol Ediniz !");
				history.back();
			</script>
			<cfabort>
		</cfif>
			<cflock name="#CREATEUUID()#" timeout="60">
				<cftransaction>
	        	<!--- Dosya adi UUID degerine gore tekrar olusturuluyor.--->
				<cffile action="rename" source="#dosya_yolu#" destination="#upload_folder_##temp_UUID#.xml">
				   <cfscript>
					//xml upload edilerek eklenen faturalarda branch_id olmaz!!! Gramoni-Mahmut 27.12.2019 14:02
					if(not isdefined("attributes.branch_id_"))
						attributes.branch_id_ = '';
					
					if(not isdefined("attributes.acc_department_id"))
						attributes.acc_department_id = '';
					
					add_invoice_receive_temp = CreateObject("component","V16.e_government.cfc.einvoice");
					add_invoice_receive_temp.dsn2 = dsn2;
					add_invoice_receive = add_invoice_receive_temp.add_received_invoices(service_result:'Successful',
																						 uuid:temp_UUID,
																						 einvoice_id:invoice_number,
																						 status_description:'ONAY BEKLİYOR',
																						 status_code:25,
																						 error_code:0,
																						 invoice_type_code:invoice_sale_type,
																						 sender_tax_id:vkn,
																						 receiver_tax_id:receiver_tax_id,
																						 profile_id:invoice_type,
																						 payable_amount:pay_total,
																						 payable_amount_currency:invoice_money,
																						 issue_date:invoice_date,
																						 party_name:member_name_gelen,
																						 order_number:order_no,
																						 is_process:0,
																						 process_stage:attributes.process_stage,
																						 is_manuel:1,
																						 einvoice_type:get_einv_comp.einvoice_type,
																						 company_id:session.ep.company_id,
																						 branch_id : attributes.branch_id_,
																						 department_id : attributes.acc_department_id
																						 );
            	 </cfscript>
			</cftransaction>
			</cflock>
			<cf_workcube_process 
				is_upd='1' 
				data_source='#dsn2#' 
				old_process_line='0'
				process_stage='#attributes.process_stage#' 
				record_member='#session.ep.userid#'
				record_date='#now()#' 
				action_table='EINVOICE_RECEIVING_DETAIL'
				action_column='RECEIVING_DETAIL_ID'
				action_id='#add_invoice_receive.identitycol#'
	            action_page='#request.self#?fuseaction=objects.popup_dsp_efatura_detail&action_id=#add_invoice_receive.identitycol#' 
				warning_description="#getLang('','Gelen E-Fatura',47112)# : #invoice_number#">
	</cfif>
	<script type="text/javascript">
		wrk_opener_reload();
		window.close();
	</script>
<cfelse><!--- güncellemeden geliyorsa süreç update edilecek --->
    <cfquery name="upd_inv" datasource="#dsn2#">
        UPDATE 
            EINVOICE_RECEIVING_DETAIL 
        SET 
            PROCESS_STAGE	= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">,
			BRANCH_ID		= <cfif isdefined("attributes.branch_id_") and len(attributes.branch_id_)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id_#"><cfelse>NULL</cfif>,
			DEPARTMENT_ID	= <cfif isdefined("attributes.acc_department_id") and len(attributes.acc_department_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.acc_department_id#"><cfelse>NULL</cfif>,
            DETAIL			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.note#">,
			SHIP_ID			= <cfif isdefined("attributes.ship_id") and Len(attributes.ship_no)><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#"><cfelse>NULL</cfif>,
            UPDATE_EMP =  #session.ep.userid#,
            UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			UPDATE_DATE = #now()#
			<cfif isdefined("attributes.invoice_type") and len(attributes.invoice_type)>,EINVOICE_TYPE =#attributes.invoice_type#</cfif>
			
        WHERE 
            RECEIVING_DETAIL_ID = #attributes.efatura_action_id#
    </cfquery>
     <cf_workcube_process 
            is_upd='1' 
            data_source='#dsn2#' 
            old_process_line='#attributes.old_process_line#' 
            process_stage='#attributes.process_stage#' 
            record_member='#session.ep.userid#' 
            record_date='#now()#' 
            action_table='EINVOICE_RECEIVING_DETAIL'
            action_column='RECEIVING_DETAIL_ID'
            action_id='#attributes.efatura_action_id#'
            action_page='#request.self#?fuseaction=objects.popup_dsp_efatura_detail&action_id=#attributes.efatura_action_id#' 
            warning_description="#getLang('','Gelen E-Fatura',47112)# : #attributes.efatura_id#">
    <script type="text/javascript">
	<cfif isdefined("attributes.CONTROLLERFILENAME") and len(attributes.CONTROLLERFILENAME)>
		window.location.href="<cfoutput>#request.self#?fuseaction=invoice.received_einvoices&event=det&receiving_detail_id=#attributes.efatura_action_id#&type=1</cfoutput>"; 
    <cfelse>
		window.location.href="<cfoutput>#request.self#?fuseaction=objects.popup_dsp_efatura_detail&receiving_detail_id=#attributes.efatura_action_id#&type=1</cfoutput>"; 
	</cfif>
	</script>
</cfif>