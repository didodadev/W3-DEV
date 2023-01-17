<!--- Yeni design yapisina gore thead,tbody eklenip class ozelligi degistirilmistir. E.Y 20120824 --->
<cfparam name="attributes.style" default="1"><!--- 1 : acik, 0 kapali --->

<cfparam name="attributes.design_id" default="1">
<cfparam name="attributes.is_popup" default="0">
<cfparam name="attributes.is_compare" default="0">

<cfset url_str = ''>
<cfif len(attributes.design_id)><cfset url_str =url_str&'&design_id=#attributes.design_id#'></cfif>
<cfif len(attributes.is_popup)><cfset url_str =url_str&'&is_popup=#attributes.is_popup#'></cfif>
<cfif len(attributes.is_compare)><cfset url_str =url_str&'&is_compare=#attributes.is_compare#'></cfif>
<cfif len(attributes.style)><cfset url_str =url_str&'&style=#attributes.style#'></cfif>
<cfif len(attributes.action_type)><cfset url_str =url_str&'&action_type=#attributes.action_type#'></cfif>
<cfif len(attributes.action_id)><cfset url_str =url_str&'&action_id=#attributes.action_id#'></cfif>

<cfsavecontent variable="title"><cf_get_lang dictionary_id='60817.İlişkili İşlemler'></cfsavecontent>
<cf_box id="get_related_process" title="#title#" collapsed="#iif(attributes.style,1,0)#" closable="0" box_page="#request.self#?fuseaction=objects.ajax_get_related_rows&#url_str#"></cf_box>

