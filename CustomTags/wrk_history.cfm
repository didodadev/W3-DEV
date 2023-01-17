<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!--- 
Description : history tablolarının ortak olarak gösterildiği sayfa

Parameters :
	act_type : required
Syntax :
	<cf_wrk_history act_type='1' act_id='123' boxwidth='300' boxheight='250'>
created :
	SM20090814
	act_id = Gösterilecek kaydı id si
	action_type = varsa gösterilecek işlemin tipi
	boxwidth = div genişliği
	boxheight = div yüksekliği
	act_type lar eklenen sayfalara göre oluşturulmalı. bu değere göre include sayfa açılıyor
	act_type= 1 ----- Satış takibi
	act_type= 2 ----- Ödeme talebi
--->
<cfparam name="attributes.boxwidth" default="450">
<cfparam name="attributes.boxheight" default="250">
<cfparam name="attributes.action_type" default="">
<cfparam name="attributes.no_box_page" default="0">
<cfparam name="attributes.id" default="wrk_hist_#round(rand()*10000000)#">
<cfset margin_info = -(attributes.boxwidth+20)>
<cfif isdefined("caller.tabMenuData")>
	<cfif StructKeyExists(caller.tabMenuStruct['#caller.attributes.fuseaction#']['tabMenus']['#caller.attributes.event#']['icons'],'history')>
        <cfset caller.IconHistory = StructNew()>
        <cfset caller.IconHistory.hist = StructNew()>
        <cfset caller.IconHistory.hist.text = 'fa fa-history'>
        <cfset caller.IconHistory.hist.js = "openBoxDraggable('#request.self#?fuseaction=objects.popup_view_history_act&action_type=#attributes.action_type#&act_type=#attributes.act_type#&act_id=#attributes.act_id#&boxwidth=#attributes.boxwidth#&boxheight=#attributes.boxheight#&id=#attributes.id#&no_box_page=#attributes.no_box_page#')">
	<cfelse>
		<cfoutput>openBoxDraggable('#request.self#?fuseaction=objects.popup_view_history_act&action_type=#attributes.action_type#&act_type=#attributes.act_type#&act_id=#attributes.act_id#&id=#attributes.id#&no_box_page=#attributes.no_box_page#')</cfoutput>
	</cfif>
<cfelse>
	<cfoutput>
        <a href="javascript://" onclick="open_history_div();"><img src="/images/history.gif" alt="#caller.getLang('main',61)#" title="#caller.getLang('main',61)#" border="0"></a>
        <div id="#attributes.id#" style="margin-left:#margin_info#px; position:absolute;display:none; visibility:visible;z-index:999999999px!important;"></div>
        <script type="text/javascript">
            function open_history_div()
            {
                document.getElementById('#attributes.id#').style.display='';
                AjaxPageLoad('#request.self#?fuseaction=objects.popup_view_history_act&action_type=#attributes.action_type#&act_type=#attributes.act_type#&act_id=#attributes.act_id#&boxwidth=#attributes.boxwidth#&boxheight=#attributes.boxheight#&id=#attributes.id#&no_box_page=#attributes.no_box_page#','#attributes.id#',1);
                return false;
            }
        </script>
    </cfoutput>
</cfif>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">

