<cfinclude template="../../config.cfm">
<cfset cmp = objectResolver.resolveByRequest("#addonNS#.components.companies.member") />
<cfset fileHelper = objectResolver.resolveByTransient("#addonNS#.components.common.filehelper")>
<cfif (isdefined('attributes.is_del') and attributes.is_del eq 1) and (isdefined('attributes.brand_id') and len(attributes.brand_id))>
	<cfset getBrand = cmp.getBrand(brand_id:attributes.brand_id)>
	<cfif getBrand.recordcount>
		<cfif FileExists("#upload_folder#member#dir_seperator##getBrand.brand_logo_path#")>
			<cf_del_server_file output_file="member/#getBrand.brand_logo_path#" output_server="#getBrand.brand_logo_path_server_id#">
		</cfif>
		<cfset delBrand = cmp.delBrand(brand_id:attributes.brand_id)>
	</cfif>
<cfelseif isdefined('attributes.brand_id') and len(attributes.brand_id)>
	<cfif isDefined("attributes.brand_logo_path") and len(attributes.brand_logo_path)>
		<cftry>
			<cfset brand_logo_path = fileHelper.save_uploaded_file("brand_logo_path", "#upload_folder#member#dir_seperator#")>
			<cfcatch>
				<script type="text/javascript">
					alert('<cfoutput>#cfcatch#</cfoutput>');
				</script>
				<cfabort>
			</cfcatch>
		</cftry>	
	<cfelse>
		<cfset brand_logo_path = ''>
	</cfif>
	<cfif not isdefined("attributes.my_production")><cfset myproduction=0><cfelse><cfset myproduction=1></cfif>
	<cfset cmp.updBrand(
			brand_id:attributes.brand_id,
			brand_name:attributes.brand_name,
			brand_logo_path:brand_logo_path,
			my_production:myproduction,
			brand_detail:attributes.brand_detail
		) />
<cfelse>
	<cfset upload_folder = "#upload_folder#member#dir_seperator#">
	<cftry>
		<cfset brand_logo_path = fileHelper.save_uploaded_file("brand_logo_path", "#upload_folder#")>
		<cfcatch>
			<script type="text/javascript">
				alert('<cfoutput>#cfcatch#</cfoutput>');
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
	<cfif not isdefined("attributes.my_production")><cfset myproduction=0><cfelse><cfset myproduction=1></cfif>
	<cfset cmp.addBrand(
			member_id:attributes.member_id,
			brand_name:attributes.brand_name,
			brand_logo_path:brand_logo_path,
			my_production:myproduction,
			brand_detail:attributes.brand_detail
		) />	
</cfif>

<script type="text/javascript">
	window.top.reload_this_page();
</script>