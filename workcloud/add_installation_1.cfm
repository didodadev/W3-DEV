<cfhttp url="https://networg.workcube.com/web_services/uhtil854o2018.cfc?method=CHECK_LICENSE_CODE" result="response" charset="utf-8">
	<cfhttpparam name="api_key" type="formfield" value="20180911HjPo356h">
	<cfhttpparam name="domain_address" type="formfield" value="#attributes.domain_address#">
	<cfhttpparam name="license_code" type="formfield" value="#attributes.license_code#">
</cfhttp>
<cfset gitUrl = 'https://bitbucket.org/workcube/devcatalyst.git' />
<cfif response.Statuscode eq '200 OK'>
	<cfset responseData = response.filecontent> 
	<cfset cfData = DeserializeJSON(responseData)>
	<cfif cfData.STATUS>
		<cfhttp url="https://networg.workcube.com/web_services/webserviceforrelease.cfc?method=CHECK_GIT_CODE" result="responseGitCode" charset="utf-8">
			<cfhttpparam name="api_key" type="formfield" value="201118kSm20">
			<cfhttpparam name="release_no" type="formfield" value="#attributes.release_no#">
			<cfhttpparam name="git_username" type="formfield" value="#attributes.git_username#">
			<cfhttpparam name="git_password" type="formfield" value="#attributes.git_password#">
		</cfhttp>

		<cfif responseGitCode.Statuscode eq '200 OK'>
			<cfset checkGitCode =  DeserializeJSON(Replace(responseGitCode.filecontent,"//",""))>
			<cfif checkGitCode.status>
				<cfset parameter.setParameter("employee_url",attributes.domain_address) />
				<cfset parameter.setParameter("license_code",attributes.license_code) />
				<cfset parameter.setParameter("release_no",attributes.release_no) />
				<cfset parameter.setParameter("release_date",attributes.release_date) />
				<cfset parameter.setParameter("patch_no",attributes.patch_no?:'') />
				<cfset parameter.setParameter("patch_date",attributes.patch_date?:'') />
				<cfset parameter.setParameter("dsn","PROD_#cfData.COMPANY_ID#_#listLast(attributes.license_code,'-')#") />
				<cfset parameter.setParameter("fusebox", {
					fusebox:{ server_machine_list: site_url }
				}) />
				<cfscript>

					parameter.setParameter("git", {
						git:{
							git_dir: index_folder,
							git_url: gitUrl,
							git_username: attributes.git_username,
							git_password: attributes.git_password
						}
					});
					
					cfGit = createObject( "component", "cfc/cfGit" );
					cfGit.init( 
						argGit_path : "git", 
						argGit_folder : index_folder,
						argGit_url : gitUrl,
						argGit_username : attributes.git_username,
						argGit_password : attributes.git_password
					);
					fetchResponse = cfGit.fetch( option : { workTreeMode:true } ); ///Öncesinde fetch işlemi yapılır!
					if( fetchResponse.status || findNoCase( "From", fetchResponse.result ) ){
						response = cfGit.checkout( checkoutBranchName : "releases/#attributes.release_no#", option : { workTreeMode:true } );
						if( 
							response.status || (findNoCase( "Switched to branch", response.result ) || findNoCase( "Switched to a new branch", response.result ) || findNoCase( "Already on", response.result ))
						) {
							location( url = "#installUrl#?installation_type=2", addToken = "no" );
						}else{
							WriteOutput("There is an error!");
							writeDump(response);
						}
					}else{
						WriteOutput("There is an error!");
						writeDump(fetchResponse);
					}
				</cfscript>
			<cfelse>
				<script>
					alert("<cfoutput>#checkGitCode.MESSAGE#</cfoutput>");
					location.href = "<cfoutput>#installUrl#</cfoutput>";
				</script>
			</cfif>
		<cfelse>
			<script>
				alert("Git verification failed");
				location.href = "<cfoutput>#installUrl#</cfoutput>";
			</script>
		</cfif>
	<cfelse>
		<script>
			alert("<cfoutput>#cfData.MESSAGE#</cfoutput>");
			location.href = "<cfoutput>#installUrl#</cfoutput>";
		</script>
	</cfif>
<cfelse>
	<script>
		alert("License verification failed");
		location.href = "<cfoutput>#installUrl#</cfoutput>";
	</script>
</cfif>