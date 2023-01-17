<!--- modified Emin Yasarturk 20130729 (Ajax yapisina cevrildi) --->
<cfparam name="attributes.style" default="1">
<cfset url_str = ''>
<cfif isdefined("attributes.action_id") and len(attributes.action_id)><cfset url_str =url_str&'&action_id=#attributes.action_id#'></cfif>
<cfif isdefined("attributes.action_id_2") and len(attributes.action_id_2)><cfset url_str =url_str&'&action_id_2=#attributes.action_id_2#'></cfif>
<!--- Finansal Ozet --->
<cf_box
	id="get_finance"
	title="#caller.getLang('main',673)#"
	collapsed="#iif(attributes.style,1,0)#"
	closable="0"
    box_page="#request.self#?fuseaction=objects.ajax_finance_summary&#url_str#"></cf_box>
