<cfset getBrand = cmp.getBrand(member_id:attributes.cpid)>
<cfparam name="attributes.style" default="1"><!--- 1 : acik, 0 kapali --->
<cfsavecontent variable="title"><cf_get_lang_main no='1225.Logo'></cfsavecontent>
<cf_box 
    id="relation_assets_logo" 
    title="#title#" 
    closable="0" 
    style="width:98%;" 
    box_page="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['det-relation-logo']['fuseaction']#&cpid=#attributes.cpid#">
</cf_box>

<cf_get_workcube_note action_section='COMPANY_ID' action_id='#attributes.cpid#' style="1">

<cfsavecontent variable="text"><cf_get_lang_main no='156.Belgeler'></cfsavecontent>

<cf_box id="relation_assets" title="#text#" closable="0" style="width:98%;" box_page="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['list-relation-asset']['fuseaction']#&action_id=#attributes.cpid#&action_section=COMPANY_ID&asset_cat_id=-9"
	add_href="AjaxPageLoad('#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['add-relation-asset']['fuseaction']#&action_id=#attributes.cpid#&action_section=COMPANY_ID&asset_cat_id=-9','body_relation_assets',0,'Loading..')">
</cf_box>

<cfsavecontent variable="text"><cf_get_lang no='2.Markalarım'></cfsavecontent>

<cf_box id="brands" title="#text#" closable="0" collapsable="1" style="width:98%;" box_page="#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['list-brands']['fuseaction']#&cpid=#attributes.cpid#"
	add_href="AjaxPageLoad('#request.self#?fuseaction=#WOStruct['#attributes.fuseaction#']['add-brands']['fuseaction']#&cpid=#attributes.cpid#','body_brands',0,'Loading..')">
</cf_box>

<cf_get_workcube_content action_type ='COMPANY_ID' action_type_id ='#attributes.cpid#' style='0' design='0'>
