<cfset cmp = createObject("component","V16.worknet.cfc.watalogyProductExport")>
<cfparam name="attributes.is_login" default="1">
<cfparam name="attributes.desciription" default="">
<cfinclude template="../form/product_export_xml_data.cfm">
<cfset file_path="#upload_folder#wex_files\">
<cfset attributes.period_id = session.ep.period_id>
<cfinclude template="product_export_add_xml_inner.cfm">

<cfset add_r = cmp.add_file_info_f(
	file_path:file_path,
	desciription:attributes.desciription,
	root:attributes.root,
	item:attributes.item,
	money_type:attributes.money_type
)>

<cfif attributes.print_type eq 1>
	<cfset file_name = "autofile_#attributes.documentation_main_tag#_#add_r.identitycol#.xml">
	<cffile action="write" file="#upload_folder#\wex_files\#file_name#" output="#product_list#" charset="utf-8">
<cfelseif attributes.print_type eq 2>
	<cfset file_name = "autofile_#attributes.documentation_main_tag#_#add_r.identitycol#.json">
	<cfset fileWrite("#upload_folder#\wex_files\#file_name#",serializeJSON(mainJson),"utf-8")/>
</cfif>

<cfset upd_file_info = cmp.upd_file_info_f(
	file_name:file_name,
	xml_id:add_r.identitycol
)>

<cfloop from="1" to="#listlen(text_name_list,'*')#" index="i">
	<cfset text_id_ = trim(listgetat(id_list,i,'*'))>
	<cfif isdefined("attributes.#text_id_#")>			
		<cfset text_name_ = evaluate("attributes.#text_id_#_text")>
		<cfset add_rows = cmp.add_rows_f(
			xml_id:add_r.identitycol,
			text_id:text_id_,
			text_name:text_name_
		)>
	</cfif>
</cfloop>

<script type="text/javascript">
	<cfoutput>
		window.location.href = '#request.self#?fuseaction=worknet.productexportwex&event=add';
	</cfoutput>
	/* wrk_opener_reload();
	window.close(); */
</script>