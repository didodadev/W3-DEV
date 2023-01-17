<cfparam name="attributes.assetcat_id" default="" />
<cfinclude template="../../asset/query/get_asset_cats.cfm">
<cf_box title="Kategoriler">
<div style="width:300px;">
	<ul>
	<cfoutput>
		<li><cfif attributes.assetcat_id neq ""><a href="#request.self#?fuseaction=objects2.list_all_videos"><cfelse><strong></cfif><cf_get_lang_main no='296.Tümü'><cfif attributes.assetcat_id neq ""></a><cfelse></strong></cfif></li></cfoutput>
	<cfoutput query="get_asset_cats">
		<li><cfif attributes.assetcat_id neq "#assetcat_id#"><a href="#request.self#?fuseaction=objects2.list_all_videos&assetcat_id=#assetcat_id#"><cfelse><strong></cfif>#assetcat#<cfif attributes.assetcat_id neq "#assetcat_id#"></a><cfelse></strong></cfif></li>
	</cfoutput>
	</ul>
</div>
</cf_box>
