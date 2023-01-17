<cfset add_mail_recipient = createObject("component", "V16.settings.cfc.mail_company_settings")>
<cfset Insert = add_mail_recipient.InsertMailRecipientList(
    list_name : attributes.list_name,
    list_file : attributes.list_file
)/>
<cfif isDefined("form.commandment_file") and len(form.commandment_file)>
	<cftry>
		<cffile
			action="UPLOAD" 
			filefield="commandment_file" 
			destination="#upload_folder#" 
			mode="777" 
			nameconflict="MAKEUNIQUE"
			>
			
			<cfset file_name = 'icra_#max_id#'>
			<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
			<cfset attributes.file_ = '#file_name#.#cffile.serverfileext#'>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
			</script>
			<cfset attributes.file_ = ''>
		</cfcatch>  
	</cftry>
<cfelse>
	<cfset attributes.file_ = ''>
</cfif>

<script type="text/javascript">
    <cfoutput>
        window.location.href = 'index.cfm?fuseaction=settings.list_mail_companies&event=listMailList'
    </cfoutput>
</script>