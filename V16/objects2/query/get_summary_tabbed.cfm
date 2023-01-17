<cfsetting showdebugoutput="no">
<cfif attributes.type eq 1>
	<cfset attributes.is_body = 1>
	<cfset attributes.is_content_print = 0>
	<cfset attributes.is_content_webmail = 0>
	<cfset attributes.is_content_outhor = 0>
    <cfset attributes.is_content_type_id = ''>
	<cfinclude template="../product/product_detail_content.cfm">
<cfelseif attributes.type eq 2>
	<cfinclude template="../product/product_relation_image.cfm">
<cfelseif attributes.type eq 3>
	<cfinclude template="../product/product_relation_asset.cfm">
<cfelseif attributes.type eq 4>
	<cfinclude template="../product/view_product_comment.cfm">
<cfelseif attributes.type eq 5>
	<cfinclude template="../product/product_relation_product.cfm">
<cfelseif attributes.type eq 6>
	<cfinclude template="../product/product_property.cfm">
<cfelseif attributes.type eq 7>
	<cfinclude template="../product/product_relation_payments.cfm">
<cfelseif attributes.type eq 8>
	<cfinclude template="../product/product_tree.cfm">
<cfelseif attributes.type eq 9>
	<cfinclude template="../product/product_alternative_product.cfm">
<cfelse>
	<cfset attributes.is_body = 1>
	<cfset attributes.is_content_print = 0>
	<cfset attributes.is_content_webmail = 0>
	<cfset attributes.is_content_outhor = 0>
    <cfset attributes.is_content_type_id = ''>
	<cfinclude template="../product/product_detail_content.cfm">
</cfif>
