<cfif isDefined( "attributes.boxparams" )>
    <cfloop array="#structKeyArray(attributes.boxparams)#" index="boxkey">
        <cfif attributes.boxparams[boxkey] eq "true">
            <cfset evaluate( "attributes.#boxkey# = 1" )>
        <cfelseif attributes.boxparams[boxkey] eq "false">
            <cfset evaluate( "attributes.#boxkey# = 0" )>            
        <cfelse>
            <cfset evaluate( "attributes.#boxkey# = '#attributes.boxparams[boxkey]#'" )>
        </cfif>
    </cfloop>
</cfif>
<cfif isdefined("url.ajax") and url.ajax eq 1><!--- Ajax ile çağrılan sayfalarda bu parametre 1 olarak geliyor. --->
	<cfset ajax_page = 1>
<cfelseif isdefined("attributes.id") and attributes.id is 'get_analysis_list'><!--- Analizler Custom Tag'inin kendi icinde select'e gore ajax yapisi mevcut --->
	<cfset ajax_page = 1>
<cfelse>
	<cfset ajax_page = 0>
</cfif>
<cfset Randomize(round(rand()*1000000))/>
<cfparam name="attributes.id" default="box_#round(rand()*10000000)#">
<cfparam name="attributes.default_body" default=""> <!--- 1: sayfa xml'e bagli olmadan surekli kapali gelsin. 0: sayfa xml'e bagli olmadan surekli acik gelsin. Default: sayfa xml'e bagli calissin. EY20131007 --->
<cfif not isdefined("caller.lang_array_main")>
	<!--- <cfset caller = caller.caller> --->
</cfif>
<cfif not len(attributes.default_body)>
	<cfif isdefined("caller.xml_unload_body_#attributes.id#")>
        <cfset attributes.unload_body = evaluate("caller.xml_unload_body_#attributes.id#")>
        <cfset attributes.collapsed = attributes.unload_body>
    <cfelseif isdefined("caller.caller.xml_unload_body_#attributes.id#")>
        <cfset attributes.unload_body = evaluate("caller.caller.xml_unload_body_#attributes.id#")>
        <cfset attributes.collapsed = attributes.unload_body>
    </cfif>
<cfelse>
	<cfset attributes.unload_body = attributes.default_body>
	<cfset attributes.collapsed = attributes.unload_body>
</cfif>

<cfif isdefined("caller.attributes.fuseaction")>
	<cfset this_act_ = caller.attributes.fuseaction>
<cfelseif isdefined("caller.caller.attributes.fuseaction")>
	<cfset this_act_ = caller.caller.attributes.fuseaction>
<cfelse>
	<cfset this_act_ = 'myhome.welcome'>
</cfif>

<cfset caller.last_box_id = attributes.id>
<cfparam name="attributes.resize" default="1">
<cfparam name="attributes.export" default="">
<cfparam name="attributes.hide_table_column" default="">
<cfparam name="attributes.uidrop" default="">
<cfparam name="attributes.dragDrop" default="0">
<cfparam name="attributes.draggable" default="0">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.isWidget" default="0" type="integer">
<cfparam name="attributes.edit_href" default="">
<cfparam name="attributes.edit_href_title" default="">
<cfparam name="attributes.add_href" default="">
<cfparam name="attributes.add_href_2" default="">
<cfparam name="attributes.add_href_2_size" default="wwide">
<cfparam name="attributes.add_href_size" default="list">
<cfparam name="attributes.add_href_title" default="#caller.getLang('main',170)#">
<cfparam name="attributes.add_href_2_title" default="#caller.getLang('main',52)#">
<cfparam name="attributes.list_href" default="">
<cfparam name="attributes.list_href_title" default="#caller.getLang('sales',154)#">
<cfparam name="attributes.lock_href" default="">
<cfparam name="attributes.lock_href_title" default="#caller.getLang('hr',865)#">
<cfparam name="attributes.unlock_href" default="">
<cfparam name="attributes.unlock_href_title" default="#caller.getLang('hr',866)#">
<cfparam name="attributes.collapsable" default="1" type="boolean">
<cfparam name="attributes.refresh" default="1" type="boolean">
<cfparam name="attributes.closable" default="0" type="boolean">
<cfparam name="attributes.type" default="box" type="string">
<cfparam name="attributes.is_blank" default="1" type="string"><!--- Yeni sekmede açılması isteniyorsa --->
<cfparam name="attributes.widget_load" default="">
<cfparam name="attributes.widget_parameters" default="">
<cfparam name="attributes.box_page" default="">
<cfif len( attributes.widget_load )><cfset attributes.box_page = "/widgetloader?widget_load=#attributes.widget_load##len(attributes.widget_parameters) ? '&' & attributes.widget_parameters : '' #" /></cfif>
<cfif isdefined("session.pda") and isDefined("session.pda.userid")>
	<cfparam name="attributes.collapse_href" default="javascript:gizle(#attributes.id#);">
	<cfparam name="attributes.close_href" default="javascript:gizle(#attributes.id#);">
    <cfelse>
	<cfparam name="attributes.collapse_href" default="show_hide_box('#attributes.id#','#attributes.box_page#','#attributes.dragDrop#','#this_act_#');">
	<cfparam name="attributes.close_href" default="javascript:show_hide('#attributes.id#');gizle(#attributes.id#);">
</cfif>
<cfparam name="attributes.collapsed" default="0">
<cfparam name="attributes.body_height" default="">
<cfparam name="attributes.style" default=""><!--- box-shadow:0px 1px 15px 1px rgba(39, 39, 39, 0.08) --->
<cfparam name="attributes.header_style" default="">
<cfparam name="attributes.body_style" default="">
<cfparam name="attributes.title_style" default="font-weight:bold;">
<cfparam name="attributes.info_href" default="">
<cfparam name="attributes.info_href_id" default="">
<cfparam name="attributes.info_href_2" default="">
<cfparam name="attributes.info_href_3" default="">
<cfparam name="attributes.info_title_2" default="">
<cfparam name="attributes.info_title" default="#caller.getLang('main',170)#"> 
<cfparam name="attributes.info_title_3" default="#caller.getLang('main',153)#"> 
<cfparam name="attributes.info_title_4" default="#caller.getLang('main',497)#">
<cfparam name="attributes.info_href_5" default="">
<cfparam name="attributes.info_title_5" default="#caller.getLang('main',1457)# #caller.getLang('call',25)#">
<cfparam name="attributes.copyrow_href" default="">
<cfparam name="attributes.copyrow_title" default="">
<cfparam name="attributes.copyrow_size" default="list">
<cfparam name="attributes.write_info" default="">
<cfparam name="attributes.call_function" default="">
<cfparam name="attributes.call_resize_function" default=""><!---Ekranı kaplama fonksiyonuna ek fonksiyon 31032020ERU---->
<cfparam name="attributes.title" default="">
<cfparam name="attributes.unload_body" default="0">
<cfparam name="attributes.design_type" default="0">
<cfparam name="attributes.left_side" default="0">
<cfparam name="attributes.scroll" default="1">
<cfparam name="attributes.print_href" default="">
<cfparam name="attributes.right_images" default="">
<cfparam name="attributes.bill_href" default="">
<cfparam name="attributes.history_href" default="">
<cfparam name="attributes.history_title" default="#caller.getLang('','','57473.Tarihçe')#">
<cfparam name="attributes.bill_title" default="#caller.getLang('main',2596)#">
<cfparam name="attributes.print_title" default="#caller.getLang('main',62)#">
<cfparam name="attributes.uniquebox_height" default="">
<cfparam name="attributes.woc_setting" type = "struct" default="#structNew()#">
<cfparam name="attributes.popup_box" default="0">
<cfif attributes.popup_box eq 1>
    <cfset attributes.closable = 1>
    <cfset attributes.draggable = 1>
    <cfset attributes.close_href = "javascript:closeBoxDraggable('#attributes.modal_id#');">
</cfif>
<cfif attributes.info_title neq caller.getLang('main',497)>
	<cfset attributes.info_title = attributes.info_title>
</cfif>
<cfif attributes.unload_body eq 1>
	<cfset attributes.collapsed = 1>
</cfif>
<cfoutput>
    <!--- *BOX START --->  <cfif thisTag.executionMode eq "start">
        <div class="card mb-3 card-#(len(attributes.class))?attributes.class:'standart'#">
            <cfif isdefined("attributes.title") and len(attributes.title)><!---- Başlık varsa gelir ---->
                <div class="card-header" id="handle_#attributes.id#">
                    <span class="card-title">
                        <span class="card-label">#attributes.title#</span>
                    </span>                    
                    <div class="card-toolbar portHeadLightMenu">
                        <ul>
                            <cfif attributes.closable>
                                <li><a class="catalystClose" href="#attributes.close_href#" <cfif isdefined('attributes.call_function') and len(attributes.call_function)>onClick="#attributes.call_function#"</cfif>><i class="fas fa-times"></i></a></li>
                            </cfif>
                        </ul>
                    </div>
                </div>
            </cfif>
            <div class="card-body" id="body_#attributes.id#">
                <!--- *BOX ELSE ---> <cfelse>   
            </div>
        </div>
    <!--- *BOX END ---> </cfif>
</cfoutput>