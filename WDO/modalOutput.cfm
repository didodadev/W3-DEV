<cfparam name="attributes.mode" default="">
<cfparam name="template_root_path" default="./catalogs/designers/printdesigner/">
<cftry>
	<cfswitch expression="#attributes.mode#">
		<cfcase value="form">
			<cfinclude template="#template_root_path#form.cfm">
		</cfcase>
		<cfcase value="save">
			<cfinclude template="#template_root_path#formupdate.cfm">
		</cfcase>
		<cfcase value="layout">
			<cfinclude template="#template_root_path#layout.cfm">
		</cfcase>
		<cfdefaultcase>
			<cfinclude template="#template_root_path#list.cfm">
		</cfdefaultcase>
	</cfswitch>
	<cfcatch type="any">
		<cfdump var="#cfcatch#" abort>
	</cfcatch>
</cftry>