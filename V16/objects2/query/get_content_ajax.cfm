<cfsetting showdebugoutput="no">
<cfquery name="get_content_" DATASOURCE="#dsn#" maxrows="1">
	SELECT 
		CONT_HEAD,
		CONT_BODY, 
		CONTENT_ID,
		CONT_SUMMARY,
		C.USER_FRIENDLY_URL
	FROM  
		CONTENT C
	WHERE 
		C.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#">
</cfquery>

<cfquery name="GET_IMAGE_CONT" datasource="#dsn#" maxrows="1">
	SELECT * FROM CONTENT_IMAGE WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cid#"> AND IMAGE_SIZE = 0
</cfquery>
<cfoutput>
	<cfset mystr = '<table border="0" width="100%">'>
		<cfif get_content_.recordcount>
			<cfset mystr = mystr & '<tr>'>
				<cfset mystr = mystr & '<td>'>
					<cfset mystr = mystr & '<table>'>
						<cfif attributes.is_content_summary eq 0>
							<cfset mystr = mystr & '<tr>'>
								<cfset mystr = mystr & '<td>'>
									<cfset mystr = mystr & '#get_content_.CONT_BODY#' >
								<cfset mystr = mystr & '</td>'>
							<cfset mystr = mystr & '</tr>'>
						<cfelse>
							<cfif GET_IMAGE_CONT.RECORDCOUNT>
								<cfset small_image_server = listgetat(fusebox.server_machine_list,get_image_cont.IMAGE_SERVER_ID,';')>
								<cfset mystr = mystr & '<tr>'>
									<cfset mystr = mystr & '<td valing="top" rowspan="4" width="80">'>
										<cfset mystr = mystr & '<img src="http://#cgi.http_host#/documents/content/#get_image_cont.contimage_small#" border="0" width="75" height="75">' >
									<cfset mystr = mystr & '</td>'>
								<cfset mystr = mystr & '</tr>'>
							</cfif>
							<cfset mystr = mystr & '<tr>'>
								<cfset mystr = mystr & '<td class="headbold">'>
									<cfset mystr = mystr & '<a href="#url_friendly_request('objects2.detail_content&cid=#get_content_.content_id#','#get_content_.USER_FRIENDLY_URL#')#" class="headbold">#get_content_.CONT_HEAD#</a>' >
								<cfset mystr = mystr & '</td>'>
							<cfset mystr = mystr & '</tr>'>
							<cfset mystr = mystr & '<tr>'>
								<cfset mystr = mystr & '<td>'>
									<cfset mystr = mystr & '<br/>&nbsp;#get_content_.CONT_SUMMARY#' >
								<cfset mystr = mystr & '</td>'>
							<cfset mystr = mystr & '</tr>'>
							<cfset mystr = mystr & '<tr>'>
								<cfset mystr = mystr & '<td>'>
									<cfset mystr = mystr & ' <br/><a href="#url_friendly_request('objects2.detail_content&cid=#get_content_.content_id#','#get_content_.USER_FRIENDLY_URL#')#" class="tableyazi">Devam</a>' >
								<cfset mystr = mystr & '</td>'>
							<cfset mystr = mystr & '</tr>'>
						</cfif>
					<cfset mystr = mystr & '</table>'>
				<cfset mystr = mystr & '</td>'>
			<cfset mystr = mystr & '</tr>'>
		<cfelse>
			<cfset mystr = mystr & '<tr>'>
				<cfset mystr = mystr & '<td>'>
					<cfset mystr = mystr & 'Kayit Yok!' >
				<cfset mystr = mystr & '</td>'>
			<cfset mystr = mystr & '</tr>'>
		</cfif>
	<cfset mystr = mystr & '</table>'>
</cfoutput>
<cfoutput>#mystr#</cfoutput>

