<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.barcode") and listlen(attributes.barcode) gt 500>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='60017.500 lü gruptan fazla barcode ayni anda yazilamaz'>...\n\n <cf_get_lang dictionary_id='60018.Lütfen dosyanızı bölünüz'>!");
	</script>
	<cfabort>
</cfif>
<!---<cfif not isdefined("attributes.barcode")>
	<script type="text/javascript">
		alert('Barkod Se�meden Yazdiramazsiniz ! �nce Barkod Se�iniz !');
	</script>
	<script type="text/javascript">
alert("cccc");
</script><cfabort>
	
	<cflocation url="#request.self#?fuseaction=objects.popup_separated_lot" addtoken="no">
	<cfabort>
</cfif>
--->
<!---<cfinclude template="../functions/barcode.cfm">--->
<cfquery name="GET_FORM" datasource="#DSN3#">
	SELECT
		TEMPLATE_FILE,
		FORM_ID,
		PROCESS_TYPE
	FROM
		SETUP_PRINT_FILES
	WHERE
		FORM_ID = #attributes.form_type#
</cfquery>
<cfinclude template="#file_web_path#settings/#get_form.template_file#">
