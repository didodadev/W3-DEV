<cfset upload_folder = "#upload_folder#reserve_files#dir_seperator#">
<cftry>
	<cffile action="UPLOAD"
			filefield="fileToUpload"
			destination="#upload_folder#"
			mode="777"
			nameconflict="MAKEUNIQUE">
		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfset attributes.fileToUpload = '#file_name#.#cffile.serverfileext#'>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
</cftry>

<cftry>
	<cfpdf action="extracttext" source="#upload_folder##attributes.fileToUpload#" name="myXML"/>
	<cffile action="delete" file="#upload_folder##attributes.fileToUpload#">
	<cfset pdf_data = xmlparse(myXML)>
	
	
	<cfif attributes.pdf_type is 'SG'>
		<cfset pdf_page_count = arraylen(pdf_data.DocText.TextPerPage.Page)>

		<cfoutput>
		<cfloop from="1" to="#pdf_page_count#" index="row">
			<cfset pdf_page_data = htmlcodeformat(pdf_data.DocText.TextPerPage.Page[row].XmlText)>
			<cfset pdf_page_data = replace(pdf_page_data,'<PRE>','','all')>
			<cfset pdf_page_data = replace(pdf_page_data,'"','','all')>
			<cfset pdf_page_data = replace(pdf_page_data,'&amp;','','all')>
			<cfset pdf_page_data = replace(pdf_page_data,'quot;','','all')>	
			<cfset pdf_page_data = reReplace(pdf_page_data,"[^\x20-\x7E]","","ALL")>
			<cfset pdf_page_data = replace(pdf_page_data,'PRJCE / UNITS','PRICE / UNITS')>
			<cfset pdf_page_data = replace(pdf_page_data,'QUANTITY ITEM PRICE / UNITS','PRICE / UNITS QUANTITY ITEM')>
			
			<cfset order_sira = find('CONFIRMING',pdf_page_data)>
			<cfset order_no = left(pdf_page_data,(order_sira-1))>
			<cfset order_no = trim(replace(order_no,'PURCHASE ORDER :',''))>
			ORDER: #order_no#<br>
			
			<cfset project_sira1 = find('CUSTOMER :',pdf_page_data)>
			<cfset project_sira2 = find('STEPHEN GOULD CONT ACT',pdf_page_data)>
			<cfset project = mid(pdf_page_data,project_sira1,(project_sira2 - project_sira1))>
			<cfset project = trim(replace(project,'CUSTOMER :','','all'))>
			project: #project#<br>
			
			<cfset deliverdate_sira1 = find('DELIVERY DATE :',pdf_page_data)>
			<cfset deliverdate = mid(pdf_page_data,deliverdate_sira1,29)>
			<cfset deliverdate = trim(replace(deliverdate,'DELIVERY DATE :','','all'))>
			<cfset deliverdate = trim(replace(deliverdate,' ','','all'))>
			deliverdate: #deliverdate#<br>
			
			<cfset to_sira1 = find('TO :',pdf_page_data)>
			<cfset to_sira2 = find('CUSTOMER P.O',pdf_page_data)>
			<cfset to_ = mid(pdf_page_data,to_sira1,(to_sira2 - to_sira1))>
			<cfset to_ = trim(replace(to_,'TO :','','all'))>
			to_: #to_# <br>
			
			<cfset urun_alan_sira1 = find('PRICE / UNITS QUANTITY ITEM',pdf_page_data)>
			<cfset urun_alan_sira2 = find('MAIL ALL ORIGINAL INVOICES TO',pdf_page_data)>
			<cfset urun_alan = mid(pdf_page_data,urun_alan_sira1,(urun_alan_sira2 - urun_alan_sira1))>
			<cfset urun_alan = trim(replace(urun_alan,'PRICE / UNITS QUANTITY ITEM','','all'))>
			<cfset urun_alan = replace(urun_alan,'PIN','P / N')>
			<cfset urun_adedi = trim(listfirst(urun_alan,' '))>
			<cfset urun_full = trim(replace(urun_alan,'#urun_adedi#','','one'))>
			<cfset urun = left(urun_full,25)>
			urun_alan: #urun_alan# <br>
			urun adedi : #urun_adedi#<br>
			urun : #urun#<br>
			<hr>
		</cfloop>
		</cfoutput>
	<cfelse>
		File Type Error!
	</cfif>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("File Error!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
</cftry>