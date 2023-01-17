<cfinclude template="../wocial_app.cfm">

<cfset brand = createObject("component","AddOns/Wocial/Component/data/brand")>

<cfset result = brand.update(
    brand_id: attributes.brand_id,
    brand_name: attributes.brand_name,
    social_media_url: attributes.social_media_url,
    website_url: attributes.website_url,
    brand_manager_id: attributes.brand_manager_id,
    brand_manager_name : attributes.brand_manager_name,
    brand_description: attributes.brand_description,
    brand_keyword: attributes.brand_keyword,
    brand_status: IsDefined("attributes.brand_status") ? attributes.brand_status : ''
) />

<cfset attributes.actionid = attributes.brand_id />