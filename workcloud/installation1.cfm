<cfif StructKeyExists(application, "systemParam")><cfset StructDelete(application, "systemParam") /></cfif>
<link href="../css/assets/icons/simple-line/simple-line-icons.css" rel="stylesheet" type="text/css">

<cfparam name="attributes.domain_address" default="">
<cfparam name="attributes.license_code" default="">
<cfparam name="attributes.git_username" default="">
<cfparam name="attributes.git_password" default="">

<cfhttp url="https://networg.workcube.com/web_services/webserviceforrelease.cfc?method=GET_UPGRADE_NOTES" result="response" charset="utf-8">
    <cfhttpparam name="api_key" type="formfield" value="201118kSm20">
    <cfhttpparam name="session_ep_language" type="formfield" value="tr">
	<cfhttpparam name="get_last_release" type="formfield" value="1">
</cfhttp>

<cfif response.Statuscode eq '200 OK'>
	<cfset responseData =  Replace(response.filecontent,"//","") /> 
	<cfset lastRelease = DeserializeJSON( responseData ) />
	<cfform name="installation_1" id="installation_1" type="formControl" action="#installUrl#" method="post">
		<input type="hidden" name="installation_type" id="installation_type" value="install_1" />
		<div class="ui-form-list">
			<div class="col-md-10 paddingLess">
				<div class="col-md-6 col-xs-12 paddingLess">
					<div class="form-group">
						<label>Domain Address <font color="red">*</font></label>
						<div class="col-md-12 pdnl">
							<input required class="form-control" message="Enter Domain Address"  name="domain_address" id="domain_address" type="text" value="<cfoutput>#attributes.domain_address#</cfoutput>" />
						</div>
					</div>
					<div class="form-group">
						<label>Workcube Licence Code <font color="red">*</font></label>
						<div class="col-md-12 pdnl">
							<input required class="form-control" message="Enter Workcube License Code"  name="license_code" id="license_code" type="text" value="<cfoutput>#attributes.license_code#</cfoutput>" />
						</div>
					</div>
					<div class="form-group">
						<label>Git Username <font color="red">*</font></label>
						<div class="col-md-12 pdnl">
							<input required class="form-control" message="Enter Git Username"  name="git_username" id="git_username" type="text" value="<cfoutput>#attributes.git_username#</cfoutput>" />
						</div>
					</div>
					<div class="form-group">
						<label>Git Password <font color="red">*</font></label>
						<div class="col-md-12 pdnl">
							<input required class="form-control" message="Enter Git Password"  name="git_password" id="git_password" type="password" value="<cfoutput>#attributes.git_password#</cfoutput>" />
						</div>
					</div>
				</div>
				<div class="col-md-6 col-xs-12 paddingLess">
					<div class="form-group">
						<label>Last Release <font color="red">*</font></label>
						<div class="col-md-12 pdnl pdnr">
							<cfinput required class="form-control" name="release_no" id="release_no" type="text" value="#lastRelease.RELEASE[1].RELEASE#" readonly />
						</div>
					</div>
					<div class="form-group">
						<label>Last Release Date <font color="red">*</font></label>
						<div class="col-md-12 pdnl pdnr">
							<cfinput required class="form-control" name="release_date" id="release_date" type="text" value="#dateformat(lastRelease.RELEASE[1].NOTE_DATE,'dd/mm/yyyy')#" readonly />
						</div>
					</div>
					<cfif len(lastRelease.RELEASE[1].PATCH_INFO)>
						<cfscript> lastPatch = arrayFilter(deserializeJSON( lastRelease.RELEASE[1].PATCH_INFO ), function( el ){ return el.patch_status; })[1]?:''; </cfscript>
						<cfif isStruct(lastPatch)>
							<div class="form-group">
								<label>Last Patch <font color="red">*</font></label>
								<div class="col-md-12 pdnl pdnr">
									<cfinput required class="form-control" name="patch_no" id="patch_no" type="text" value="#lastPatch.PATCH_NO#" readonly />
								</div>
							</div>
							<div class="form-group">
								<label>Last Patch Date<font color="red">*</font></label>
								<div class="col-md-12 pdnl pdnr">
									<cfinput required class="form-control" name="patch_date" id="patch_date" type="text" value="#lastPatch.PATCH_DATE#" readonly />
								</div>
							</div>
						</cfif>
					</cfif>
					<cfif not isDefined("attributes.from_workcloud")>
						<div class="form-group">
							<div class="col-md-12 pdnl">
								<cf_wrk_recaptcha submit_id="check_license" recaptcha="0">
							</div>
						</div>
					</cfif>
				</div>
			</div>
		</div>
		<div class="ui-form-list-btn">
			<div class="col-md-10 paddingLess">
				<div class="form-group button-panel">
					<input  class="btn btn-info" id="check_license" type="submit" value="Next Step">
				</div>
			</div>
		</div>
	</cfform>
	<cfif isDefined("attributes.from_workcloud")>
		<script>
			$(function(){
				$("form[name = installation_1]").submit();
			});
		</script>
	</cfif>
<cfelse>
	<script>
		alert('There is an error when getting last release informations from Workcube!\nPlese check your internet connection settings!');
	</script>
</cfif>