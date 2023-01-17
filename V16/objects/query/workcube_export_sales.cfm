<cf_date tarih="attributes.processdate">
<cfset main_table_datasource = '#dsn#_#year(attributes.processdate)#_#session.ep.company_id#'>
<cfset sub_table_datasource_list = '#dsn#_#year(attributes.processdate)#_#session.ep.company_id#'&','&'#dsn#_#year(attributes.processdate)#_#session.ep.company_id#'>
<cfset where_text = 'INVOICE_DATE = #attributes.processdate# AND DEPARTMENT_ID = #listfirst(attributes.department_id,'-')# AND DEPARTMENT_LOCATION = #listlast(attributes.department_id,'-')#'>

<cfoutput>
	attributes.main_table: #attributes.main_table# <br/>
	main_table_datasource : #main_table_datasource# <br/>
	query_where : #where_text# <br/>
	query_order : #attributes.query_order# <br/>
	main_table_related_columns : #attributes.main_table_related_columns# <br/>
	sub_table_list : #sub_table_list# <br/>
	sub_table_datasource_list : #sub_table_datasource_list# <br/>
	sub_table_related_columns_list : #attributes.sub_table_related_columns_list#<br/>
	sub_table_query_table_list : 'INVOICE_ROW'
	sub_table_query_list : '(SELECT BARCOD FROM STOCKS WHERE STOCK_ID = INVOICE_ROW.STOCK_ID) BARCOD'
</cfoutput>

<cfscript>
	//file_name = "#CreateUUID()#.XML";
	xml_doc = wrk_xml(
						main_table : attributes.main_table,
						main_table_datasource : main_table_datasource,
						query_where : where_text,
						query_order : attributes.query_order,
						main_table_related_columns : attributes.main_table_related_columns,
						sub_table_list : sub_table_list,
						sub_table_datasource_list : sub_table_datasource_list,
						sub_table_related_columns_list : attributes.sub_table_related_columns_list,
						sub_table_query_table_list :  'INVOICE_ROW',
						sub_table_query_list : '(SELECT BARCOD FROM #DSN1_ALIAS#.STOCKS STOCKS WHERE STOCK_ID = INVOICE_ROW.STOCK_ID) BARCOD'
					);
</cfscript>
<cfdump var="#xml_doc#">

<!--- <cfheader name="Expires" value="#Now()#">
<cfcontent type="text/vnd.plain;charset=UTF-8">
<cfheader name="Content-Disposition" value="attachment; filename=#file_name#"> 
<cfoutput>
#xml_doc#
</cfoutput> --->

<cffile action="write" file="#upload_folder#invoice.xml" output="#toString(xml_doc)#" charset="utf-8">
<cfheader name="Content-Disposition" value="attachment;filename=#DateFormat(CreateODBCDateTime(attributes.processdate), "yyyymmdd")#_#attributes.department_id#.xml">
<cfcontent file="#upload_folder#invoice.xml" type="application/octet-stream" deletefile="yes">
<!--- <script type="text/javascript">
	alert('Dosyanız Oluşturuldu !');
	window.close();
</script> --->
