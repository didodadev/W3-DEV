<cfquery name="get_sales_imports" datasource="#DSN2#">
	DELETE
	FROM
		SAYIMLAR
	WHERE
		GIRIS_ID = #attributes.file_id#
</cfquery>
<cfoutput>
	<script language="JavaScript" type="text/javascript">
		window.location='#request.self#?fuseaction=pos.list_sayim'
	</script>
</cfoutput>
