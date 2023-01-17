<cfquery name="GET_XML_CONVERTER" datasource="#dsn#">
	SELECT * FROM SETUP_XML_CONVERTER WHERE XML_CONVERTER_ID=#attributes.converter_id# 
</cfquery>
<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
<cftry>
	<cffile action="delete" file="#upload_folder##XML_CONVERT_FILE#">
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang no ='2530.Dosyanız Silinemedi'> !");
		</script>
	</cfcatch>
</cftry>
<cftry>
	<cffile action="delete" file="#upload_folder##XML_CONVERT_FILE_2#">
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang no ='2530.Dosyanız Silinemedi'> !");
		</script>
	</cfcatch>
</cftry>
<cfquery name="DEL_XML_CONVERTER_ROW" datasource="#dsn#">
	DELETE FROM SETUP_XML_CONVERTER_ROW WHERE XML_CONVERTER_ID=#attributes.converter_id# 
</cfquery>
<cfquery name="DEL_XML_CONVERTER_ROW" datasource="#dsn#">
	DELETE FROM SETUP_XML_CONVERTER WHERE XML_CONVERTER_ID=#attributes.converter_id# 
</cfquery>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.form_add_xml_converter">
