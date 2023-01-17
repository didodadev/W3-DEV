<cffile action="read" file="#attributes.asset#" variable="xmldosyam" charset = "UTF-8">
<cfset my_doc = XmlParse(xmldosyam)>
<cfset xml_dizi = my_doc.report_tables.XmlChildren >
<cfset d_boyut = ArrayLen(xml_dizi)>
<cfloop index="i" from = "1" to = #d_boyut#>
	<cfquery name="UPD_REPORT" datasource="#DSN#">
		UPDATE	REPORT_TABLES
		SET
			TABLE_INREPORT = <cfif len(trim(my_doc.report_tables.XmlChildren[i].TABLE_INREPORT.XmlText))>#my_doc.report_tables.XmlChildren[i].TABLE_INREPORT.XmlText#<cfelse>NULL</cfif>,
			IS_MAIN = <cfif len(trim(my_doc.report_tables.XmlChildren[i].IS_MAIN.XmlText))>#my_doc.report_tables.XmlChildren[i].IS_MAIN.XmlText#<cfelse>NULL</cfif>,
			NICK_NAME_TR = '#my_doc.report_tables.XmlChildren[i].NICK_NAME_TR.XmlText#',
			NICK_NAME_EN = '#my_doc.report_tables.XmlChildren[i].NICK_NAME_EN.XmlText#',  
			PERIOD_YEAR = <cfif len(trim(my_doc.report_tables.XmlChildren[i].PERIOD_YEAR.XmlText))>#my_doc.report_tables.XmlChildren[i].PERIOD_YEAR.XmlText#<cfelse>NULL</cfif>,
			COMPANY_ID = <cfif len(trim(my_doc.report_tables.XmlChildren[i].COMPANY_ID.XmlText))>#my_doc.report_tables.XmlChildren[i].COMPANY_ID.XmlText#<cfelse>NULL</cfif>, 
			DETAIL = '#my_doc.report_tables.XmlChildren[i].DETAIL.XmlText#'
		WHERE
			TABLE_NAME = '#my_doc.report_tables.XmlChildren[i].TABLE_NAME.XmlText#'
	</cfquery>
</cfloop>

<script type="text/javascript">
	window.close();
</script>
