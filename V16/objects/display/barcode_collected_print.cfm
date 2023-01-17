<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.barcode") and listlen(attributes.barcode) gt 500>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='60017.500 lü gruptan fazla barcode aynı anda yazılamaz'>.. <cf_get_lang dictionary_id='60018.Lütfen dosyanızı bölünüz'>!");
	</script>
	<cfabort>
</cfif>
<cfif not isdefined("attributes.barcode")>
	<script type="text/javascript">
		alert('<cf_get_lang dictionary_id="60019.Barkod Seçmeden Yazdıramazsınız"> ! <cf_get_lang dictionary_id="60020.Önce Barkod Seçiniz"> !');
	</script>
	<cflocation url="#request.self#?fuseaction=objects.popup_collected_barcode" addtoken="no">
	<cfabort>
</cfif>
<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
	<cfset attributes.startdate = date_add('h', attributes.start_hour, attributes.startdate)>
	<cfset attributes.startdate = date_add('n', attributes.start_min, attributes.startdate)>
</cfif>
<cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
	<cfset attributes.finishdate = date_add('h', attributes.finish_hour, attributes.finishdate)>
	<cfset attributes.finishdate = date_add('n', attributes.finish_min, attributes.finishdate)>
</cfif>
<cfinclude template="../functions/barcode.cfm">
<cfquery name="GET_FORM" datasource="#DSN3#">
	SELECT
		IS_STANDART,
		TEMPLATE_FILE,
		FORM_ID,
		PROCESS_TYPE
	FROM
		SETUP_PRINT_FILES
	WHERE
		FORM_ID = #attributes.form_type#
</cfquery>
<cfif get_form.is_standart eq 1>
	<cfinclude template="../../../#get_form.template_file#">
<cfelse>
	<cfinclude template="#file_web_path#settings/#get_form.template_file#">
</cfif>

