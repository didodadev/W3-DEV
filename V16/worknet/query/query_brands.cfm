<cfset cmp = createObject("component","V16.worknet.query.worknet_member") />
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
		<cffile action="UPLOAD" destination="#upload_folder#member#dir_seperator#" filefield="brand_logo_path" nameconflict="MAKEUNIQUE" accept="image/*">
		<cf_del_server_file output_file="member/#attributes.old_file_name#" output_server="#attributes.old_file_server_id#">
		
		<cfset brand_image_file_name = createUUID()>
		<cffile action="rename" source="#upload_folder#member#dir_seperator##cffile.serverfile#" destination="#upload_folder#member#dir_seperator##brand_image_file_name#.#cffile.serverfileext#">
		<cfset brand_logo_path = '#brand_image_file_name#.#cffile.serverfileext#'>		
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
	<cfset upload_folder = "#upload_folder##dir_seperator#member#dir_seperator#">
	<cffile action="UPLOAD" filefield="brand_logo_path" destination="#upload_folder#" mode="777" nameconflict="MAKEUNIQUE" accept="image/*">
	<cfset file_name = createUUID()>
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
	<cfset brand_logo_path = '#file_name#.#cffile.serverfileext#'>
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

