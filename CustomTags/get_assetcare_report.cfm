<cfparam name="attributes.style" default="1"><!--- 1 : acik, 0 kapali --->
<cfparam name="attributes.is_special" default="0"><!--- 1 : checked, 0 unchecked --->
<cfparam name="attributes.action_type" default="0">
<cfparam name="attributes.is_delete" default="1">
<cfquery name="GET_CARE_STATES" datasource="#caller.dsn#">
	SELECT
    	CARE_REPORT_ID,
		ASSET_ID,
		CARE_DATE,
        CARE_TYPE,
		STATION_ID
	FROM
		ASSET_CARE_REPORT
	WHERE
    	<cfif attributes.care_id eq 0>
  			FAILURE_ID=#attributes.action_id#
        <cfelse>
        	CARE_ID=#attributes.action_id#
        </cfif>
	ORDER BY 
		RECORD_DATE
</cfquery>
<cfset url_str = ''>
<cfif isdefined("attributes.action_id") and len(attributes.action_id)><cfset url_str =url_str&'&action_id=#attributes.action_id#'></cfif>
<cfif len(attributes.is_delete)><cfset url_str =url_str&'&is_delete=#attributes.is_delete#'></cfif>
<cfif len(attributes.style)><cfset url_str =url_str&'&style=#attributes.style#'></cfif>
<cfif len(attributes.action_type)><cfset url_str =url_str&'&action_type=#attributes.action_type#'></cfif>
<cfif len(attributes.is_special)><cfset url_str =url_str&'&is_special=#attributes.is_special#'></cfif>
<cfif len(attributes.care_id)><cfset url_str =url_str&'&care_id=#attributes.care_id#'></cfif>
<cfif attributes.care_id eq 0>
	<cfset add_href="#request.self#?fuseaction=assetcare.list_asset_care&event=add&failure_id=#attributes.action_id#">
<cfelse>
	<cfset add_href="#request.self#?fuseaction=assetcare.list_asset_care&event=add&asset_id=#get_care_states.asset_id#&care_state_id=#get_care_states.care_type#&care_id=#attributes.action_id#">
</cfif>
<cf_box id="GET_CARE_REPORT" title="#attributes.head#" collapsed="#iif(attributes.style,1,0)#" closable="0" style="#attributes.width#" add_href="#add_href#" box_page="#request.self#?fuseaction=objects.ajax_get_assetcare_report&#url_str#"></cf_box>
