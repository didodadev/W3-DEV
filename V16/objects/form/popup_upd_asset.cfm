<cfset attributes.assetcat_id = attributes.asset_cat_id>
<cf_get_lang_set module_name="asset">
	<cfinclude template="../../asset/form/form_upd_asset.cfm">
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">

