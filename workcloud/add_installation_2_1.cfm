<cfif IsDefined("attributes.document_path") and len(attributes.document_path)>
    <cfif not DirectoryExists( attributes.document_path )>
        <cfdirectory action="create" directory="#attributes.document_path#" mode="777">
    </cfif>

    <cfset folders = ['account', 'agenda', 'asset', 'asset_preview', 'content', 'contract', 'correspondence', 'e_government', 'earchive_send', 'einvoice_received', 'einvoice_send', 'eshipment_received', 'eshipment_send', 'finance', 'hr', 'member', 'mockup_designer', 'personal_settings', 'product', 'project', 'report', 'salespur', 'settings', 'store', 'temp', 'templates', 'thumbnails', 'training', 'wex', 'woc'] />

    <cfloop from = "1" to = "#ArrayLen( folders )#" index = "i">
        <cfif not DirectoryExists( "#attributes.document_path##folders[i]#" )>
            <cfdirectory action="create" directory="#attributes.document_path##folders[i]#" mode="777">
        </cfif>
    </cfloop>

    <cfset parameter.setParameter("upload_folder",attributes.document_path) />
    <cfset parameter.setParameter("download_folder",attributes.download_path) />
    
    <cflocation url = "#installUrl#?installation_type=3" addToken = "no">

<cfelse>
	<script>
		alert("<cfoutput>You must set document path!</cfoutput>");
		location.href = "<cfoutput>#installUrl#?installation_type=2_1</cfoutput>";
	</script>
</cfif>