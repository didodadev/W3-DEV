<!---
Description :   
    Document Template 
Parameters :
    module_id       .-.- > module id from MODULES table           'required
    action_section  .-.- > table name used in the action id       'required
    action_id       .-.- > action id for every record in a module 'required
	design_id       .-.- > design type for use area  'not required
	is_add			.-.- > manage files (add,update,delete)
	action_type      .-.- > verinin numeric mi nvarchar mı oldugunu belirtir 0:numeric 1:nvarchar 
	company_id      .-.- > sadece o şirkette görünmesini sağlar..diğer şirketlerden giriş yapanlar göremez bu değeri yollamazsanız eklediğiniz varlığı tüm şirketler görür. Kullanımı : company_id="#session.ep.company_id#"
	is_image      .-.- > verinin imaj olup olmadigini belirtir
	style	'not required : default assetler gorunmuyor, gorunmesi icin parametre 1 olarak verilmeli
Syntax :
	<cf_get_workcube_asset_popup asset_cat_id="<module asset category id>" module_id='<integer value>' action_section='<table name>' action_id='<integer value>' design_id='<integer value>'>
Sample :
	<cf_get_workcube_asset_popup asset_cat_id="-7" module_id='2' action_section='CONTENT' action_id='#attributes.cntid#' design_id='0'>	
	
	created SM 20091021
	
	ilişkili not ve belgeleri gösteren popup açıyor
 --->
<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<cfparam name="attributes.action_type" default="0">
<cfparam name="attributes.is_image" default="0">
<cfparam name="attributes.style" default="1">
<cfparam name="attributes.design_id" default="1">
<cfparam name="attributes.is_add" default="1">
<cfparam name="attributes.period_id" default="">
<cfparam name="attributes.is_special" default="0">
<cfif isdefined("caller.tabMenuData")>
    <cfif StructKeyExists(caller.tabMenuStruct['#caller.attributes.fuseaction#']['tabMenus']['#caller.attributes.event#']['icons'],'archive')>
        <cfset caller.iconInfo = StructNew()>
        <cfset caller.iconInfo.info = StructNew()>
        <cfset caller.iconInfo.info.text = 'fa fa-archive'>
        <cfset caller.iconInfo.info.js = "openBoxDraggable('#request.self#?fuseaction=objects.popup_list_related_actions&period_id=#attributes.period_id#&module_name_info=finance&is_special=#attributes.is_special#&is_add=#attributes.is_add#&design_id=#attributes.design_id#&style=#attributes.style#&is_image=#attributes.is_image#&action_type=#attributes.action_type#&action_section=#attributes.action_section#&&action_id=#attributes.action_id#&asset_cat_id=#attributes.asset_cat_id#&module_id=#attributes.module_id#');">
    <cfelse>
        <cfoutput>openBoxDraggable('#request.self#?fuseaction=objects.popup_list_related_actions&period_id=#attributes.period_id#&module_name_info=finance&is_special=#attributes.is_special#&is_add=#attributes.is_add#&design_id=#attributes.design_id#&style=#attributes.style#&is_image=#attributes.is_image#&action_type=#attributes.action_type#&action_section=#attributes.action_section#&&action_id=#attributes.action_id#&asset_cat_id=#attributes.asset_cat_id#&module_id=#attributes.module_id#');</cfoutput>
    </cfif>
   
<cfelse>
	<cfoutput>
        <a href="javascript://" onclick="open_assets();"><img src="/images/content_plus.gif" align="top" alt="<cfoutput>#caller.getLang('main',1966)#</cfoutput>" title="<cfoutput>#caller.getLang('main',1966)#</cfoutput>" border="0"></a>
        <script type="text/javascript">
            function open_assets()
            {
                openBoxDraggable('#request.self#?fuseaction=objects.popup_list_related_actions&period_id=#attributes.period_id#&module_name_info=finance&is_special=#attributes.is_special#&is_add=#attributes.is_add#&design_id=#attributes.design_id#&style=#attributes.style#&is_image=#attributes.is_image#&action_type=#attributes.action_type#&action_section=#attributes.action_section#&&action_id=#attributes.action_id#&asset_cat_id=#attributes.asset_cat_id#&module_id=#attributes.module_id#');
                return false;
            }
        </script>
    </cfoutput>
</cfif>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">

