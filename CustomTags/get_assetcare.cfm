<cfparam name="attributes.style" default="1"><!--- 1 : acik, 0 kapali --->
<cfparam name="attributes.is_special" default="0"><!--- 1 : checked, 0 unchecked --->
<cfparam name="attributes.action_type" default="0">
<cfparam name="attributes.is_delete" default="1">
<cfset url_str = ''>
<cfif isdefined("attributes.action_id") and len(attributes.action_id)><cfset url_str =url_str&'&action_id=#attributes.action_id#'></cfif>
<cfif len(attributes.is_delete)><cfset url_str =url_str&'&is_delete=#attributes.is_delete#'></cfif>
<cfif len(attributes.style)><cfset url_str =url_str&'&style=#attributes.style#'></cfif>
<cfif len(attributes.action_type)><cfset url_str =url_str&'&action_type=#attributes.action_type#'></cfif>
<cfif len(attributes.is_special)><cfset url_str =url_str&'&is_special=#attributes.is_special#'></cfif>
<cf_box id="GET_CARE_STATE" title="#attributes.head#" collapsed="#iif(attributes.style,1,0)#" closable="0" add_href="#request.self#?fuseaction=assetcare.list_assetp_period&event=add&failure_id=#attributes.action_id#" box_page="#request.self#?fuseaction=objects.ajax_get_assetcare&#url_str#"></cf_box>
