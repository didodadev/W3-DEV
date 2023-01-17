<cfquery name="CHECK_IMPORTED" datasource="#DSN2#">
	SELECT I_ID,SOURCE_SYSTEM,FILE_NAME FROM FILE_IMPORTS WHERE IMPORTED = 1 AND I_ID = #attributes.file_id#
</cfquery>
<cfif check_imported.recordcount>
	<script type="text/javascript">
		alert('Bu Dosya İmport Edilmiş, Tekrar İmport Edilemez !');
		wrk_opener_reload();
		window.close;
	</script>
	<cfabort>
</cfif>
<cfquery name="IMPORT_FILE" datasource="#DSN2#">
	SELECT I_ID,SOURCE_SYSTEM,FILE_NAME,DEPARTMENT_ID,DEPARTMENT_LOCATION FROM FILE_IMPORTS WHERE I_ID = #attributes.file_id#
</cfquery>
Aktarım İşlemi Başladı, Lütfen Bekleyiniz...<br/>
<cfset xml_import=1><!--- bu değşiken fatura ve diğer dosyaların takıldığında abort veya history back ile geri dönmelerini engellemektedir --->
<cfif IMPORT_FILE.SOURCE_SYSTEM eq -50>
	<cfinclude template="xml_import_invoice.cfm">
<cfelseif IMPORT_FILE.SOURCE_SYSTEM eq -51>
	<cfinclude template="xml_import_payment.cfm">
<cfelseif IMPORT_FILE.SOURCE_SYSTEM eq -52>
	<cfinclude template="xml_import_order.cfm">
<cfelseif IMPORT_FILE.SOURCE_SYSTEM eq -53>
	<cfinclude template="xml_import_stocks_row.cfm"><!--- objects2 ürünler icin --->
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
</script>

