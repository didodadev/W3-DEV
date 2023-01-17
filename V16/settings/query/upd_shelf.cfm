<cfif form.old_code neq form.shelf_no>
	<cfset attributes.control_id = form.shelf_no>
	<cfinclude template="get_shelf.cfm">
	<cfif get_shelf.recordcount>
		<script type="text/javascript">
			alert("<cf_get_lang no='711.Seçtiğiniz Raf Kod numarası Mevcut  Değiştiriniz '>");
			history.back(); 
		</script>
		<cfabort>
	</cfif>
</cfif>

<cfquery name="UPD_SHELF" datasource="#DSN#">
	UPDATE 
   		SHELF
	SET
		SHELF_ID = #form.shelf_no#,
		SHELF_NAME = '#form.shelf_name#',
		UPDATE_IP = '#cgi.remote_addr#',
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		SHELF_MAIN_ID = #attributes.se_id#
</cfquery>

<cflocation url="#request.self#?fuseaction=settings.form_add_shelf" addtoken="no">
