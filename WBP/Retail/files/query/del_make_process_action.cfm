<cfif not isdefined("attributes.row_id") or not len(attributes.row_id)>
<script>
	alert('<cf_get_lang dictionary_id='62688.Silinecek Satır Seçmediniz'>!');
	window.close();
</script>
<cfabort>
</cfif>


<cfquery name="upd_" datasource="#dsn_Dev#">
	DELETE FROM PROCESS_ROWS
    WHERE
    	ROW_ID IN (#attributes.row_id#)
</cfquery>

<cfquery name="upd_" datasource="#dsn_Dev#">
	DELETE FROM PROCESS_ROWS_CATS
    WHERE
    	ROW_ID IN (#attributes.row_id#)
</cfquery>

<script>
	window.location.href="<cfoutput>#request.self#?fuseaction=retail.popup_make_process_action</cfoutput>";
</script>