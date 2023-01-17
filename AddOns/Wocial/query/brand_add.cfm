<cfinclude template="../wocial_app.cfm">

<cfset brand = createObject("component","AddOns/Wocial/Component/data/brand")>

<cfset result = brand.insert(
    platform_id: attributes.platform_id,
    brand_name: attributes.brand_name,
    social_media_url: attributes.social_media_url,
    website_url: (isdefined("attributes.website_url") and len(attributes.website_url)) ? attributes.website_url : '',
    brand_manager_id: attributes.brand_manager_id,
    brand_manager_name: attributes.brand_manager_name,
    brand_description: (isdefined("attributes.brand_description") and len(attributes.brand_description)) ? attributes.brand_description : '',
    brand_keyword: (isdefined("attributes.brand_keyword") and len(attributes.brand_keyword)) ? attributes.brand_keyword : '',
    brand_status: attributes.brand_status?:0
) />

<cfset attributes.actionid = result.identitycol />