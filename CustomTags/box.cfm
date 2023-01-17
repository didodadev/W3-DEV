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
	<cfset caller = caller.caller>
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
    <cfset this_act_event = caller.attributes.event?:'' />
<cfelseif isdefined("caller.caller.attributes.fuseaction")>
	<cfset this_act_ = caller.caller.attributes.fuseaction>
    <cfset this_act_event = caller.caller.attributes.event?:'' />
<cfelse>
	<cfset this_act_ = 'myhome.welcome'>
    <cfset this_act_event = '' />
</cfif>

<cfset caller.last_box_id = attributes.id>
<cfparam name="attributes.resize" default="1">
<cfparam name="attributes.export" default="">
<cfparam name="attributes.hide_table_column" default="">
<cfparam name="attributes.responsive_table" default="">
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
<cfparam name="attributes.wiki" default="">
<cfparam name="attributes.collapsable" default="1" type="boolean">
<cfparam name="attributes.refresh" default="1" type="boolean">
<cfparam name="attributes.closable" default="0" type="boolean">
<cfparam name="attributes.type" default="box" type="string">
<cfparam name="attributes.is_blank" default="1" type="string"><!--- Yeni sekmede açılması isteniyorsa --->
<cfparam name="attributes.widget_load" default="">
<cfparam name="attributes.widget_parameters" default="">
<cfparam name="attributes.box_page" default="">
<cfparam name="attributes.sms_href" default="">
<cfparam name="attributes.sms_title" default="">
<cfparam name="attributes.pure" default="0">

<!--- Sayfa draggable'sa ve box'ta yeni bir dragabble açılmak isteniliyorsa --->
<cfparam name="attributes.draggable_href" default="">
<cfparam name="attributes.draggable_icon" default="">
<cfparam name="attributes.draggable_size" default="ui-draggable-box-large">
<cfparam name="attributes.draggable_href_title" default="">
<cfparam name="attributes.box_modal_id" default="">

<cfif len( attributes.widget_load )>
    <cfset attributes.box_page = "#request.self#?fuseaction=objects.widget_loader&widget_load=#attributes.widget_load##len(attributes.widget_parameters) ? '&' & attributes.widget_parameters : '' #" />
    <cfquery name = "get_widget" datasource = "#caller.dsn#">
        SELECT WW.WIDGET_FUSEACTION, WO.WRK_OBJECTS_ID FROM WRK_WIDGET AS WW JOIN WRK_OBJECTS AS WO ON WW.WIDGET_FUSEACTION = WO.FULL_FUSEACTION WHERE WW.WIDGET_FRIENDLY_NAME = <cfqueryparam cfsqltype='CF_SQL_NVARCHAR' value='#ListFirst(ListFirst(attributes.widget_load,"?"),"&")#'>
    </cfquery>
</cfif>
<cfif isdefined("session.pda") and isDefined("session.pda.userid")>
	<cfparam name="attributes.collapse_href" default="javascript:gizle(#attributes.id#);">
	<cfparam name="attributes.close_href" default="javascript:gizle(#attributes.id#);">
    <cfelse>
	<cfparam name="attributes.collapse_href" default="show_hide_box('#attributes.id#','#attributes.box_page#','#attributes.dragDrop#','#this_act_#');">
	<cfparam name="attributes.close_href" default="javascript:show_hide('#attributes.id#');gizle(#attributes.id#);">
</cfif>
<cfparam name="attributes.collapsed" default="0">
<cfparam name="attributes.body_height" default="">
<cfparam name="attributes.style" default="box-shadow:0px 1px 15px 1px rgba(39, 39, 39, 0.08)">
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
<cfparam name="attributes.info_href_6" default="">
<cfparam name="attributes.info_title_6" default="">
<cfparam name="attributes.info_href_7" default="">
<cfparam name="attributes.info_title_7" default="">
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
<cfparam name="attributes.chatroom_settings" type = "struct" default="#structNew()#">
<cfparam name="attributes.popup_box" default="0">
<cfparam name="attributes.settings" default="1">
<cfparam name="attributes.modal_id" default="#caller.attributes.modal_id?:''#">
<cfparam  name="attributes.box_style" default="">
<cfparam  name="attributes.is_basket" default="0">
<cfif attributes.popup_box eq 1>
    <cfset attributes.closable = 1>
    <cfset attributes.draggable = 1>
    <cfset attributes.close_href = "javascript://">
    <cfset attributes.call_function = "$('.DynarchCalendar-topCont').hide();closeBoxDraggable('#attributes.modal_id#');">
</cfif>
<cfif attributes.info_title neq caller.getLang('main',497)>
	<cfset attributes.info_title = attributes.info_title>
</cfif>
<cfif attributes.unload_body eq 1>
	<cfset attributes.collapsed = 1>
</cfif>
<cfoutput>
<cfif isdefined("session.pp")>
	<cfset session_base = evaluate('session.pp')>
<cfelseif isdefined("session.ep")>
	<cfset session_base = evaluate('session.ep')>
<cfelseif isdefined("session.ww")>
	<cfset session_base = evaluate('session.ww')>
<cfelseif isdefined("session.wp")>
	<cfset session_base = evaluate('session.wp')>
</cfif>
<cfif thisTag.executionMode eq "start">
<div class="boxRow uniqueBox <cfif attributes.draggable eq 1>draggable_cf_box <cfif len(attributes.box_style)>#attributes.box_style#</cfif></cfif>" id="unique_#attributes.id#" <cfif isdefined("attributes.uniquebox_height") and len(attributes.uniquebox_height)>style="height:#attributes.uniquebox_height#"</cfif>>
<div id="action_#attributes.id#" style="display:none; width:1px;"></div>
    <div <cfif attributes.dragDrop eq 1>id="homebox_#attributes.id#" <cfelse>id="#attributes.id#"</cfif> <cfif len(attributes.class)>class="#attributes.class#"<cfelse> class="portBox portBottom<cfif attributes.type eq "window" >pod_box_window</cfif>"</cfif> style="<cfif len(attributes.style)>#attributes.style#</cfif>" data-reload="reload_#attributes.id#" data-basket="#attributes.is_basket#">
       <cfif isdefined("attributes.title") and len(attributes.title)>
           	<div id="header_#attributes.id#" class="portHeadLight" style="<cfif len(attributes.header_style)>#attributes.header_style#</cfif>">	
                <!-- del -->
                <div class="portHeadLightTitle">
                    <span id="handle_#attributes.id#" <cfif attributes.dragDrop eq 1> style="cursor:pointer;"</cfif>><cfif attributes.dragDrop eq 1>#attributes.title#<cfelse><a <cfif isdefined("attributes.data_bind")>data-bind="text:#attributes.data_bind#"</cfif> href="javascript://" onclick="#attributes.collapse_href#">#attributes.title#</a></cfif></span> 
                </div>
                 <!-- del -->
                <div class="portHeadLightMenu">
                    <!-- del -->
                    <ul>
                        <cfif IsDefined("session_base.SCREEN_WIDTH") and session_base.SCREEN_WIDTH lt 767>     
                            <!--- DİKKAT: bu satır, Firefox hack'tir. Kalacak. --->
                            <cfif len(attributes.right_images)>
                                <cfoutput>#attributes.right_images#</cfoutput>
                            </cfif>
                            <li class="ui-dropdown">
                                <a href="javascript://"><i class="fa fa-ellipsis-v"></i></a>
                                <ul>     
                                    <cfif len(attributes.wiki)>
                                        <li><a href="#attributes.wiki#"  id="wiki_#attributes.id#" title="#attributes.edit_href_title#"title="<cf_get_lang dictionary_id='61078.Wiki ile ilişkilendr'>" alt="<cf_get_lang dictionary_id='61078.Wiki ile ilişkilendr'>" target="_blank" style="font-size:16px;"><cf_get_lang dictionary_id='60721.Wiki'></a></li>
                                    </cfif>
                                    <cfif len(attributes.edit_href)>
                                        <li><a href="#attributes.edit_href#" id="edit_#attributes.id#" <cfif len(attributes.edit_href_title)>title="#attributes.edit_href_title#"</cfif>><i class="catalyst-note"></i>#caller.getLang('main',1306)#</a></li>
                                    </cfif>    
                                    <cfif len(attributes.print_href)>
                                        <li><a href="javascript://" onclick="windowopen('#attributes.print_href#');"><i class="catalyst-printer"></i>#attributes.print_title#</a></li>
                                    </cfif>
                                    <cfif len(attributes.bill_href)>
                                       <li><a href="#attributes.bill_href#" title="#attributes.bill_title#"><i class="icon-CMS"></i></a></li>
                                    </cfif>
                                    <cfif len(attributes.history_href)>
                                        <li><a href="javascript://" onclick="windowopen('#attributes.history_href#','list');"><i class="fa fa-history"></i>#attributes.history_title#</a></li>
                                    </cfif>
                                    <cfif len(attributes.info_href_3)>
                                        <li><a href="javascript://" onclick="windowopen('#attributes.info_href_3#','list');"><i class="catalyst-link"></i>#attributes.info_title_4#</a></li>
                                    </cfif>
                                    <cfif len(attributes.add_href_2) and attributes.add_href_2 contains 'javascript:'>
                                        <li><a href="javascript://" onclick="#attributes.add_href_2#"><i class="catalyst-note"></i>#attributes.add_href_2_title#</a></li>
                                    <cfelseif len(attributes.add_href_2) and attributes.add_href_2 contains 'ajaxpageload'>
                                        <li><a href="javascript://" onclick="#attributes.add_href_2#"></a><i class="catalyst-note"></i>#attributes.add_href_2_title#</a></li>
                                    <cfelseif len(attributes.add_href_2) and not(attributes.add_href_2 contains 'popup_' or attributes.add_href_2 contains '_popup')>
                                        <li><a href="#attributes.add_href_2#" target="_blank"><i class="catalyst-note"></i>#attributes.add_href_2_title#</a></li>
                                    <cfelseif len(attributes.add_href_2)>
                                        <li><a href="javascript://" onclick="windowopen('#attributes.add_href_2#','#attributes.add_href_2_size#');"><i class="catalyst-note"></i>#attributes.add_href_2_title#</a></li>
                                    </cfif>
                                    <cfif len(attributes.draggable_icon) and len(attributes.draggable_href) and len(attributes.draggable_size) and len(attributes.draggable_href_title)>
                                        <li><a href="javascript://" onclick="openDraggable('#attributes.draggable_href#','#attributes.draggable_size#')" title="#attributes.draggable_href_title#"><i class="#attributes.draggable_icon#"></i></a></li>
                                    </cfif>
                                    <cfif len(attributes.info_href_2)>
                                        <li><a href="javascript://" onclick="windowopen('#attributes.info_href_2#','list');"><i class="catalyst-note"></i>#attributes.info_title_2#</a></li>
                                    </cfif>
                                    <cfif len(attributes.info_href_5)>
                                        <li><a href="javascript://" onclick="windowopen('#attributes.info_href_5#','list');"><i class="fa fa-calendar-plus-o"></i>#attributes.info_title_5#</a></li>
                                    </cfif>
                                    <cfif len(attributes.info_href_6) and (attributes.add_href contains 'cfmodal' or attributes.add_href contains 'openBoxDraggable')>
                                        <li><a href="javascript://" onclick="#attributes.info_href_6#" class="font-red-pink"><i class="fa fa-tags"></i>#attributes.info_title_6#</a></li>
                                    <cfelseif len(attributes.info_href_6)>
                                        <li><a href="javascript://" onclick="windowopen('#attributes.info_href_6#','list');"><i class="fa fa-tags"></i>#attributes.info_title_6#</a></li>
                                    </cfif>
                                    <cfif len(attributes.info_href_7)>
                                        <li><a href="javascript://" onclick="windowopen('#attributes.info_href_7#','list');"><i class="fa fa-cubes"></i>#attributes.info_title_7#</a></li>
                                    </cfif>
                                    <cfif len(attributes.copyrow_href) and attributes.copyrow_href contains 'javascript:'>
                                        <li><a href="javascript://" onclick="#attributes.copyrow_href#" title="#attributes.copyrow_title#"><i class="catalyst-docs"></i></a></li>
                                    <cfelseif len(attributes.copyrow_href)>
                                        <li><a href="javascript://" onclick="windowopen('#attributes.copyrow_href#','#attributes.copyrow_size#');"><i class="catalyst-docs"></i>#attributes.copyrow_href#</a></li>
                                    </cfif>
                                    <cfif len(attributes.list_href)>
                                        <cfif attributes.list_href contains 'javascript:'>
                                            <li><a href="javascript://" onclick="#attributes.list_href#" class="font-red-pink"><i class="catalyst-list" title="#attributes.list_href_title#"></i></a></li>
                                        <cfelse>
                                            <li><a href="#attributes.list_href#" target="#iif(attributes.is_blank eq 1,DE('_blank'),DE(''))#" class="font-red-pink"><i class="catalyst-list"></i>#attributes.list_href_title#</a></li>
                                        </cfif>
                                    </cfif>
                                    <cfif len(attributes.lock_href)>
                                        <li><a href="javascript://" onclick="#attributes.lock_href#;" class="font-red-pink"><i class="catalyst-lock"></i>#attributes.lock_href_title#</a></li>
                                    </cfif>
                                    <cfif len(attributes.unlock_href)>
                                        <li><a href="javascript://" onclick="#attributes.unlock_href#;" class="font-red-pink"><i class="catalyst-lock-open"></i>#attributes.unlock_href_title#</a></li>
                                    </cfif>                    
                                    <cfif len(attributes.write_info)>
                                        <li class="headHelper"><cfoutput>#attributes.write_info#</cfoutput></li>
                                    </cfif>
                                    <cfif structCount(attributes.chatroom_settings)>
                                        <li><a href="javascript://" title="#caller.getLang('','Chatflow odası oluştur',62253)#" onclick="window.open('#request.self#?fuseaction=objects.workflowpages&tab=1&subtab=3&action_wo=#attributes.chatroom_settings.action_wo#&action_wo_event=#attributes.chatroom_settings.action_wo_event#&action_parameter=#attributes.chatroom_settings.action_parameter#&action_id=#attributes.chatroom_settings.action_id#','ChatFlow')"><i class="catalyst-bubbles"></i></a></li>
                                    </cfif>
                                    <cfif attributes.draggable eq 1 or len( attributes.widget_load )><!--- draggable olarak açıldıysa ya da widget loader ile yüklenmek isteniyorsa box ayarları görüntülenir --->
                                        <cfif (not this_act_ contains 'popup_xml_setup') and (not this_act_ contains 'popup_content') and  (not this_act_ contains 'popup_operate_action') and (not this_act_ contains 'popup_send_print_action') and (not this_act_ contains 'popup_basket') and (not this_act_ contains 'popupflush_print_collected_barcodes') and (not this_act_ contains 'popup_barcode') and (not this_act_ contains 'popup_pd_edit') and (not isdefined("caller.attributes.iframe")) and not (isdefined("caller.attributes.print") and caller.attributes.print) and not (this_act_ eq 'dev.workdev')>
                                            <cfoutput>
                                            <li>
                                                <cfif len(attributes.settings) and attributes.settings eq 1><a href="javascript://"><i class="catalyst-settings"></i>#caller.getLang('','Ayarlar',57435)#</a></cfif>
                                                <ul>
                                                    <cfif not len( attributes.widget_load )>
                                                        <li><a href="javascript://" onClick="copyToClipboard()" title="<cf_get_lang dictionary_id='57476.Kopyala'>"><i class="catalyst-globe-alt fa-2x"></i>#this_act_#</a><input type="text" value="#this_act_#" name="copyToClipboardInput" id="copyToClipboardInput" style="display:none;"></li>
                                                        <cfif IsDefined("caller.workcube_mode") and caller.workcube_mode eq 0>
                                                            <li><a href="javascript://" onClick="window.open('index.cfm?fuseaction=help.popup_add_problem&help=#this_act_#','<cf_get_lang dictionary_id='60908.Destek Başvuru'>');"><i class="fa fa-question-circle fa-2x"></i><cf_get_lang dictionary_id='55064.Sorun Bildir'></a></li>
                                                        </cfif>
                                                        <li><a href="javascript://" onClick="window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#this_act_#','Workflow')"><i class="fa fa-bell fa-2x"></i><cf_get_lang dictionary_id="57757.Uyarılar"></a></li>
                                                        <cfif session_base.admin and listFindNoCase(session_base.USER_LEVEL,7)>
                                                            <cfif len(this_act_event) and isdefined("caller.WOStruct")>
                                                                <li><a href="javascript://" id="wrk_xml_pop_" onClick="cfmodal('#request.self#?fuseaction=objects.popup_xml_setup&fuseact=#caller.WOStruct['#this_act_#']['#this_act_event#']['fuseaction']#&main_fuseact=#this_act_#','warning_modal');"><i class="fa fa-code fa-2x" ></i><cf_get_lang dictionary_id='61201.Page Settings'></a></li>
                                                            <cfelse>
                                                                <li><a href="javascript://" id="wrk_xml_pop_" onClick="cfmodal('#request.self#?fuseaction=objects.popup_xml_setup&fuseact=#this_act_#&main_fuseact=#this_act_#','warning_modal');"><i class="fa fa-code fa-2x"></i><cf_get_lang dictionary_id='61201.Page Settings'></a></li>
                                                            </cfif>
                                                            <cfif session_base.admin and caller.fusebox.is_special eq 1><img src="/images/add_options_mini.gif" title="Bu Sayfa Add Options'tan Çalışmaktadır." /></cfif>
                                                            <cfif isdefined("session_base.lang_change_action") and session_base.lang_change_action eq 1>
                                                                <li><a href="javascript://" class="tableyazi" onclick="windowopen('index.cfm?fuseaction=settings.popup_page_lang_list','wide')"><i class="catalyst-book-open fa-2x"></i>#caller.getLang('main',520)#</a></li>
                                                            </cfif>
                                                            <li><a href="javascript://"  onclick="myPopup('formPanel');"><i class="fa fa-pencil-square fa-2x"></i><cf_get_lang dictionary_id='47755.Page Designer'></a></li>
                                                            <cfquery name="get_woid" datasource="#caller.dsn#">
                                                                SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = <cfqueryparam value="#this_act_#" cfsqltype="cf_sql_nvarchar">
                                                            </cfquery>
                                                            <li><a href="index.cfm?fuseaction=dev.wo&event=upd&fuseact=<cfoutput>#this_act_#&woid=#get_woid.WRK_OBJECTS_ID#</cfoutput>" target="_blank"><i class="fa fa-globe fa-2x"></i><cf_get_lang dictionary_id="52706.Workdev"></a></li>
                                                        </cfif>
                                                        <cfset workcube_license = createObject("V16.settings.cfc.workcube_license").get_license_information() />
                                                        <li><a href="javascript://" id="wrk_workl_pop_" onClick="window.open('#workcube_license.implementation_project_domain#/index.cfm?fuseaction=project.works&work_detail_id=0&event=add&id=#workcube_license.implementation_project_id#&work_fuse=#this_act_#','İş Ekle');"><i class="fa fa-gears fa-2x"></i>#caller.getLang('','',57933)#</a></li>
                                                    <cfelseif get_widget.recordcount>
                                                        <li><a href="index.cfm?fuseaction=dev.wo&event=upd&fuseact=<cfoutput>#get_widget.WIDGET_FUSEACTION#&woid=#get_widget.WRK_OBJECTS_ID#</cfoutput>" target="_blank"><i class="fa fa-globe fa-2x"></i><cf_get_lang dictionary_id="52706.Workdev"></a></li>
                                                        <cfif session_base.admin and listFindNoCase(session_base.USER_LEVEL,7)>
                                                            <cfif len(this_act_event) and isdefined("caller.WOStruct")>
                                                                <li><a href="javascript://" id="wrk_xml_pop_" onClick="cfmodal('#request.self#?fuseaction=objects.popup_xml_setup&fuseact=#caller.WOStruct['#this_act_#']['#this_act_event#']['fuseaction']#&main_fuseact=#this_act_#&friendly_url=#attributes.widget_load#','warning_modal');"><i class="fa fa-code fa-2x" ></i><cf_get_lang dictionary_id='61201.Page Settings'></a></li>
                                                            <cfelse>
                                                                <li><a href="javascript://" id="wrk_xml_pop_" onClick="cfmodal('#request.self#?fuseaction=objects.popup_xml_setup&fuseact=#this_act_#&main_fuseact=#this_act_#&friendly_url=#attributes.widget_load#','warning_modal');"><i class="fa fa-code fa-2x"></i><cf_get_lang dictionary_id='61201.Page Settings'></a></li>
                                                            </cfif>
                                                        </cfif>
                                                    </cfif>
                                                </ul>
                                            </li>
                                            </cfoutput>
                                        </cfif>
                                    </cfif>
                                </ul>
                            </li> 

                            <cfif len(attributes.hide_table_column)>
                                <li>
                                    <a class="table_column_list" href="javascript://"><i class="catalyst-eye"></i></a>
                                    <ul class="design2" id="table_list_container"></ul>
                                </li>       
                            </cfif>

                            <cfif len(attributes.responsive_table)>
                                <li><a id="card" href="javascript://"><i class="catalyst-grid"></i></a></li>
                            </cfif>

                            <cfif len(attributes.uidrop)>
                                <li id="lis">
                                    <a href="javascript://"><i class="catalyst-share-alt"></i></a>
                                    <ul>
                                        <li>               		
                                            <a href="javascript://" onclick="sendToGoogleSpreadSheet(this);"><i class="icon-file-text-o fa-2x"></i><div id="sheetAlert"><cf_get_lang dictionary_id='63757.Google Tablolar'><cf_get_lang dictionary_id='30022.ile'><cf_get_lang dictionary_id='48969.Aç'></div></a>
                                        </li>
                                        <li>               		
                                            <a href="javascript://" onclick="return (PROCTest(this,1));"><i class="fa fa-file-excel-o fa-2x"></i><cf_get_lang dictionary_id='29737.Excel Üret'></a>
                                        </li>
                                        <li>                   
                                            <a href="javascript://" onclick="return (PROCTest(this,2));"><i class="fa fa-file-word-o fa-2x"></i><cf_get_lang dictionary_id='29738.Word Üret'></a>
                                        </li>
                                        <li>                   
                                            <a href="javascript://"  onclick="return (PROCTest(this,3));"><i class="fa fa-file-pdf-o fa-2x"></i><cf_get_lang dictionary_id='29739.PDF Üret'></a>
                                        </li>           
                                        <li> 
                                            <a href="javascript://" onclick="return (PROCTest(this,4));"><i class="fa fa-envelope-o fa-2x"></i><cf_get_lang dictionary_id='57475.Mail Gönder'></a>       
                                        </li>
                                        <li>
                                            <a href="javascript://" onclick="printSa();"><i class="fa fa-print fa-2x "></i><cf_get_lang dictionary_id='29740.Yazıcıya Gönder'></a>
                                        </li>
                                        <cfif structCount( attributes.woc_setting )>
                                        <li>
                                            <a href="javascript://" id = "sendWoc"><i class="fa fa-clipboard fa-2x "></i><cf_get_lang dictionary_id="64050.Seçilenleri WOC a gönder"></a>
                                        </li>
                                        </cfif>
                                    </ul>
                                </li>
                            </cfif>

                            <cfif len(attributes.info_href) and attributes.info_href contains 'javascript:'>
                                <li><a href="javascript://" onclick="#attributes.info_href#" title="#attributes.info_title_3#"><i class="catalyst-magnifier"></i></a></li>
                            <cfelseif len(attributes.info_href) and attributes.is_blank eq 1>
                                <li><a href="#attributes.info_href#" target="_blank" title="#attributes.info_title_3#" <cfif len(attributes.info_href_id)>id="#attributes.info_href_id#"</cfif>><i class="catalyst-magnifier"></i></a></li>
                            <cfelseif len(attributes.info_href)>
                                <li><a href="javascript://" onclick="windowopen('#attributes.info_href#','list');" title="#attributes.info_title_3#"><i class="catalyst-magnifier"></i></a></li>
                            </cfif>
                            <cfif len(attributes.add_href) and attributes.add_href contains 'javascript:'>
                                <li><a href="javascript://" onclick="#attributes.add_href#" class="font-red-pink" title="#attributes.info_title#"><i class="catalyst-plus"></i></a></li>
                            <cfelseif len(attributes.add_href) and attributes.add_href contains 'ajaxpageload'>
                                <li><a href="javascript://" onclick="#attributes.add_href#" class="font-red-pink" title="#attributes.info_title#"><i class="catalyst-plus"></i></a></li>
                            <cfelseif len(attributes.add_href) and (attributes.add_href contains 'cfmodal' or attributes.add_href contains 'openBoxDraggable')>
                                <li><a href="javascript://" onclick="#attributes.add_href#" class="font-red-pink" title="#attributes.info_title#"><i class="catalyst-plus"></i></a></li>
                            <cfelseif len(attributes.add_href) and not(attributes.add_href contains 'popup_' or attributes.add_href contains '_popup')>
                                <li>
                                    <cfif attributes.is_blank eq 1>
                                        <a href="#attributes.add_href#" target="_blank" class="font-red-pink" title="#attributes.info_title#"><i class="catalyst-plus"></i></a>
                                    <cfelse>
                                        <a href="#attributes.add_href#" class="font-red-pink" title="#attributes.info_title#"><i class="catalyst-plus"></i></a>
                                    </cfif>
                                </li>
                            <cfelseif len(attributes.add_href)>
                                <li><a href="javascript://" onclick="windowopen('#attributes.add_href#','#attributes.add_href_size#','#attributes.id#');" class="font-red-pink" title="#attributes.add_href_title#"><i class="catalyst-plus"></i></a></li>
                            </cfif>
                            <cfif len(attributes.box_page) and attributes.refresh>
                                <li><a href="javascript://" onclick="refresh_box('#attributes.id#','#attributes.box_page#','#attributes.dragDrop#');" title="#caller.getLang('main',1667)#"><i class="catalyst-refresh"></i></a></li>
                            </cfif>
                            <cfif attributes.collapsable>
                                <li><a title="#caller.getLang('bank',308)#/#caller.getLang('main',141)#" href="javascript://" onclick="#attributes.collapse_href#"><i class="catalyst-arrow-down"></i></a></li>
                            </cfif> 
                            <cfif attributes.resize>
                                <li><a title="#caller.getLang('help',24)#" href="javascript://" onclick="fs({id:'<cfif attributes.dragDrop eq 1>homebox_#attributes.id#<cfelse>#attributes.id#</cfif>'});<cfif len(attributes.call_resize_function)>#attributes.call_resize_function#;</cfif>"><i class="icons8-resize-diagonal"></i></a></li>
                            </cfif>
                            <cfif attributes.closable>
                                <li><a class="catalystClose" href="#attributes.close_href#" <cfif isdefined('attributes.call_function') and len(attributes.call_function)>onClick="#attributes.call_function#"</cfif> title="#caller.getLang('main',141)#">×</a></li>
                            </cfif>

                            
                        
                        <cfelseif IsDefined("session_base.SCREEN_WIDTH") and session_base.SCREEN_WIDTH gt 767> 
                            <cfif len(attributes.right_images)>
                                <cfoutput>#attributes.right_images#</cfoutput>
                            </cfif> 
                            <cfif len(attributes.uidrop)>
                                <li id="lis">
                                    <a href="javascript://"><i class="catalyst-share-alt"></i></a>
                                    <ul>                                        
                                        <li>               		
                                            <a href="javascript://" onclick="sendToGoogleSpreadSheet(this);"><i class="icon-file-text-o fa-2x"></i><div id="sheetAlert"><cf_get_lang dictionary_id='63757.Google Tablolar'><cf_get_lang dictionary_id='30022.ile'><cf_get_lang dictionary_id='48969.Aç'></div></a>
                                        </li>
                                        <li>               		
                                            <a id="li_excel" href="javascript://" onclick="return (PROCTest(this,1));"><i class="fa fa-file-excel-o fa-2x"></i><cf_get_lang dictionary_id='29737.Excel Üret'></a>
                                        </li>
                                        <li>                   
                                            <a href="javascript://" onclick="return (PROCTest(this,2));"><i class="fa fa-file-word-o fa-2x"></i><cf_get_lang dictionary_id='29738.Word Üret'></a>
                                        </li>
                                        <li>                   
                                            <a href="javascript://"  onclick="return (PROCTest(this,3));"><i class="fa fa-file-pdf-o fa-2x"></i><cf_get_lang dictionary_id='29739.PDF Üret'></a>
                                        </li>           
                                        <li> 
                                            <a href="javascript://" onclick="return (PROCTest(this,4));"><i class="fa fa-envelope-o fa-2x"></i><cf_get_lang dictionary_id='57475.Mail Gönder'></a>       
                                        </li>
                                        <li>
                                            <a href="javascript://"onclick="printSa();"><i class="fa fa-print fa-2x "></i><cf_get_lang dictionary_id='29740.Yazıcıya Gönder'></a>
                                        </li>
                                        <cfif isDefined('attributes.module') and len(attributes.module)>
                                            <li>
                                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_documenter&module=#attributes.module#','small','popup_documenter')">
                                                    <i class="icon-save" id="list_save_button"></i>#caller.getLang('main','Kaydet',57461)#
                                                </a>
                                            </li>
                                        </cfif>
                                        <cfif structCount( attributes.woc_setting )>
                                            <li>
                                                <a href="javascript://" id = "sendWoc"><i class="fa fa-clipboard fa-2x "></i><cf_get_lang dictionary_id='64050.Seçilenleri WOC a gönder'></a>
                                            </li>
                                        </cfif>
                                    </ul>
                                </li>
                            </cfif> 
                            <cfif len(attributes.wiki)>
                                <li><a href="#attributes.wiki#"  id="wiki_#attributes.id#" title="#attributes.edit_href_title#"title="<cf_get_lang dictionary_id='61078.Wiki ile ilişkilendr'>" alt="<cf_get_lang dictionary_id='61078.Wiki ile ilişkilendr'>" target="_blank" style="font-size:16px;">W</a></li>
                            </cfif>
                                <cfif len(attributes.edit_href)>
                                    <li><a href="#attributes.edit_href#" id="edit_#attributes.id#" <cfif len(attributes.edit_href_title)>title="#attributes.edit_href_title#"<cfelse>title="#caller.getLang('main',1306)#"</cfif>><i class="catalyst-note"></i></a></li>
                                </cfif>    
                                <cfif len(attributes.print_href)>
                                    <li><a href="javascript://" onclick="window.open('#attributes.print_href#');" title="#attributes.print_title#"><i class="catalyst-printer"></i></a></li>
                                </cfif>
                                <cfif len(attributes.bill_href)>
                                    <li><a href="#attributes.bill_href#" title="#attributes.bill_title#"><i class="icon-CMS"></i></a></li>
                                </cfif>
                                <cfif len(attributes.history_href) and attributes.history_href contains 'javascript:'>
                                    <li><a href="javascript://" onclick="#attributes.history_href#" title="#attributes.history_title#"><i class="fa fa-history"></i></a></li>
                                <cfelseif len(attributes.history_href) and attributes.history_href contains 'ajaxpageload'>
                                    <li><a href="javascript://" onclick="#attributes.history_href#" title="#attributes.history_title#"><i class="fa fa-history"></i></a></li>
                                <cfelseif len(attributes.history_href) and (attributes.history_href contains 'cfmodal' or attributes.history_href contains 'openBoxDraggable')>
                                    <li><a href="javascript://" onclick="#attributes.history_href#" title="#attributes.history_title#"><i class="fa fa-history"></i></a></li>
                                <cfelseif len(attributes.history_href) and not(attributes.history_href contains 'popup_' or attributes.history_href contains '_popup')>
                                    <li>
                                        <cfif attributes.is_blank eq 1>
                                            <a href="#attributes.history_href#" target="_blank"><i class="fa fa-history"></i>#attributes.history_title#</a>
                                        <cfelse>
                                            <a href="#attributes.history_href#"><i class="fa fa-history"></i>#attributes.history_title#</a>
                                        </cfif>
                                    </li>
                                <cfelseif len(attributes.history_href)>
                                    <li><a href="javascript://" onclick="windowopen('#attributes.history_href#','#attributes.history_href#','#attributes.id#');" title="#attributes.history_title#"><i class="fa fa-history"></i></a></li>
                                </cfif> 
                                <cfif len(attributes.sms_href) and attributes.sms_href contains 'javascript:' and isdefined("session_base.our_company_info.sms") and session_base.our_company_info.sms eq 1>
                                    <li><a href="javascript://" id="sms_link" onclick="#attributes.sms_href#" title="#attributes.sms_title#"><i class="fa fa-tablet"></i></a></li>
                                <cfelseif len(attributes.sms_href)>
                                    <li><a href="javascript://" id="sms_link" onclick="window.open('#attributes.sms_href#');" title="#attributes.sms_title#"><i class="fa fa-tablet"></i></a></li>
                                </cfif>
                                <cfif len(attributes.info_href) and attributes.info_href contains 'javascript:'>
                                    <li><a href="javascript://" onclick="#attributes.info_href#" title="#attributes.info_title_3#"><i class="catalyst-magnifier"></i></a></li>
                                <cfelseif len(attributes.info_href) and attributes.is_blank eq 1>
                                    <li><a href="#attributes.info_href#" target="_blank" title="#attributes.info_title_3#" <cfif len(attributes.info_href_id)>id="#attributes.info_href_id#"</cfif>><i class="catalyst-magnifier"></i></a></li>
                                <cfelseif len(attributes.info_href)>
                                    <li><a href="javascript://" onclick="windowopen('#attributes.info_href#','list');" title="#attributes.info_title_3#"><i class="catalyst-magnifier"></i></a></li>
                                </cfif>
                                <cfif len(attributes.info_href_3)>
                                    <li><a href="javascript://" onclick="windowopen('#attributes.info_href_3#&popup_page=1','list');" title="#attributes.info_title_4#"><i class="catalyst-link"></i></a></li>
                                </cfif>
                                <cfif len(attributes.add_href_2) and attributes.add_href_2 contains 'javascript:'>
                                    <li><a href="javascript://" onclick="#attributes.add_href_2#" title="#attributes.add_href_2_title#"><i class="catalyst-note"></i></a></li>
                                <cfelseif len(attributes.add_href_2) and attributes.add_href_2 contains 'ajaxpageload'>
                                    <li><a href="javascript://" onclick="#attributes.add_href_2#" title="#attributes.add_href_2_title#"><i class="catalyst-note"></i></a></li>
                                <cfelseif len(attributes.add_href_2) and not(attributes.add_href_2 contains 'popup_' or attributes.add_href_2 contains '_popup')>
                                    <li><a href="#attributes.add_href_2#" target="_blank" title="#attributes.add_href_2_title#"><i class="catalyst-note"></i></a></li>
                                <cfelseif len(attributes.add_href_2)>
                                    <li><a href="javascript://" onclick="windowopen('#attributes.add_href_2#','#attributes.add_href_2_size#');" title="#attributes.add_href_2_title#"><i class="catalyst-note"></i></a></li>
                                </cfif>
                                <cfif len(attributes.info_href_2)>
                                    <li><a href="javascript://" onclick="windowopen('#attributes.info_href_2#','list');" title="#attributes.info_title_2#"><i class="catalyst-note"></i></a></li>
                                </cfif>
                                <cfif len(attributes.info_href_5)>
                                    <li><a href="javascript://" onclick="windowopen('#attributes.info_href_5#','list');" title="#attributes.info_title_5#"><i class="fa fa-calendar-plus-o"></i></a></li>
                                </cfif>
                                <cfif len(attributes.info_href_6) and (attributes.add_href contains 'cfmodal' or attributes.add_href contains 'openBoxDraggable')>
                                    <li><a href="javascript://" onclick="#attributes.info_href_6#" class="font-red-pink" title="#attributes.info_title_6#"><i class="fa fa-tags"></i></a></li>
                                <cfelseif len(attributes.info_href_6)>
                                    <li><a href="javascript://" onclick="windowopen('#attributes.info_href_6#','list');"><i class="fa fa-tags"></i>#attributes.info_title_6#</a></li>
                                </cfif>
                                <cfif len(attributes.info_href_7)>
                                    <li><a href="javascript://" onclick="windowopen('#attributes.info_href_7#','list');" title="#attributes.info_title_7#"><i class="fa fa-cubes"></i></a></li>
                                </cfif>
                                <cfif len(attributes.copyrow_href) and attributes.copyrow_href contains 'javascript:'>
                                    <li><a href="javascript://" onclick="#attributes.copyrow_href#" title="#attributes.copyrow_title#"><i class="catalyst-docs"></i></a></li>
                                <cfelseif len(attributes.copyrow_href)>
                                    <li><a href="javascript://" onclick="windowopen('#attributes.copyrow_href#','#attributes.copyrow_size#');" title="#attributes.copyrow_href#"><i class="catalyst-docs"></i></a></li>
                                </cfif>
                                <cfif len(attributes.add_href) and attributes.add_href contains 'javascript:'>
                                    <li><a href="javascript://" onclick="#attributes.add_href#" class="font-red-pink" title="#attributes.info_title#"><i class="catalyst-plus"></i></a></li>
                                <cfelseif len(attributes.add_href) and attributes.add_href contains 'ajaxpageload'>
                                    <li><a href="javascript://" onclick="#attributes.add_href#" class="font-red-pink" title="#attributes.info_title#"><i class="catalyst-plus"></i></a></li>
                                <cfelseif len(attributes.add_href) and (attributes.add_href contains 'cfmodal' or attributes.add_href contains 'openBoxDraggable')>
                                    <li><a href="javascript://" onclick="#attributes.add_href#" class="font-red-pink" title="#attributes.info_title#"><i class="catalyst-plus"></i></a></li>
                                <cfelseif len(attributes.add_href) and not(attributes.add_href contains 'popup_' or attributes.add_href contains '_popup')>
                                    <li>
                                        <cfif attributes.is_blank eq 1>
                                            <a href="#attributes.add_href#" target="_blank" class="font-red-pink" title="#attributes.info_title#"><i class="catalyst-plus"></i></a>
                                        <cfelse>
                                            <a href="#attributes.add_href#" class="font-red-pink" title="#attributes.info_title#"><i class="catalyst-plus"></i></a>
                                        </cfif>
                                    </li>
                                <cfelseif len(attributes.add_href)>
                                    <li><a href="javascript://" onclick="windowopen('#attributes.add_href#','#attributes.add_href_size#','#attributes.id#');" class="font-red-pink" title="#attributes.add_href_title#"><i class="catalyst-plus"></i></a></li>
                                </cfif> 
                                <cfif len(attributes.draggable_icon) and len(attributes.draggable_href) and len(attributes.draggable_size) and len(attributes.draggable_href_title) and len(attributes.box_modal_id)>
                                    <li><a href="javascript://" onclick="openDraggable('#attributes.draggable_href#','#attributes.draggable_size#')" title="#attributes.draggable_href_title#"><i class="#attributes.draggable_icon#"></i></a></li>
                                </cfif>
                                <cfif len(attributes.list_href)>
                                    <cfif attributes.list_href contains 'javascript:'>
                                        <li><a href="javascript://" onclick="#attributes.list_href#" class="font-red-pink"><i class="catalyst-list" title="#attributes.list_href_title#"></i></a></li>
                                    <cfelse>
                                        <li><a href="#attributes.list_href#" target="#iif(attributes.is_blank eq 1,DE('_blank'),DE(''))#" class="font-red-pink" title="#attributes.list_href_title#"><i class="catalyst-list"></i></a></li>
                                    </cfif>
                                </cfif>
                                <cfif len(attributes.lock_href)>
                                    <li><a href="javascript://" onclick="#attributes.lock_href#;" class="font-red-pink" title="#attributes.lock_href_title#"><i class="catalyst-lock"></i></a></li>
                                </cfif>
                                <cfif len(attributes.unlock_href)>
                                    <li><a href="javascript://" onclick="#attributes.unlock_href#;" class="font-red-pink" title="#attributes.unlock_href_title#"><i class="catalyst-lock-open"></i></a></li>
                                </cfif>
                                <cfif len(attributes.box_page) and attributes.refresh>
                                    <li><a href="javascript://" onclick="refresh_box('#attributes.id#','#attributes.box_page#','#attributes.dragDrop#');" title="#caller.getLang('main',1667)#"><i class="catalyst-refresh"></i></a></li>
                                </cfif>                      
                                <cfif len(attributes.write_info)>
                                    <li><cfoutput>#attributes.write_info#</cfoutput></li>
                                </cfif> 
                                <cfif len(attributes.hide_table_column)>
                                    <li>
                                        <a class="table_column_list" href="javascript://"><i class="catalyst-eye"></i></a>
                                        <ul class="design2" id="table_list_container"></ul>
                                    </li>
                                </cfif> 
                                <cfif attributes.collapsable>
                                    <li><a href="javascript://" onclick="#attributes.collapse_href#" title="#caller.getLang('bank',308)#/#caller.getLang('main',141)#"><i class="catalyst-arrow-down"></i></a></li>
                                </cfif>  
                                <cfif attributes.resize>
                                    <li><a href="javascript://" title="#caller.getLang('help',24)#" onclick="fs({id:'<cfif attributes.dragDrop eq 1>homebox_#attributes.id#<cfelse>#attributes.id#</cfif>'});<cfif len(attributes.call_resize_function)>#attributes.call_resize_function#;</cfif>"><i class="icons8-resize-diagonal"></i></a></li>
                                </cfif>
                                <cfif structCount(attributes.chatroom_settings)>
                                    <li><a href="javascript://" title="#caller.getLang('','Chatflow odası oluştur',62253)#" onclick="window.open('#request.self#?fuseaction=objects.workflowpages&tab=1&subtab=3&action_wo=#attributes.chatroom_settings.action_wo#&action_wo_event=#attributes.chatroom_settings.action_wo_event#&action_parameter=#attributes.chatroom_settings.action_parameter#&action_id=#attributes.chatroom_settings.action_id#','ChatFlow')"><i class="catalyst-bubbles"></i></a></li>
                                </cfif>
                                <cfif attributes.draggable eq 1 or len( attributes.widget_load )><!--- draggable olarak açıldıysa ya da widget loader ile yüklenmek isteniyorsa box ayarları görüntülenir --->
                                    <cfif (not this_act_ contains 'popup_xml_setup') and (not this_act_ contains 'popup_content') and  (not this_act_ contains 'popup_operate_action') and (not this_act_ contains 'popup_send_print_action') and (not this_act_ contains 'popup_basket') and (not this_act_ contains 'popupflush_print_collected_barcodes') and (not this_act_ contains 'popup_barcode') and (not this_act_ contains 'popup_pd_edit') and (not isdefined("caller.attributes.iframe")) and not (isdefined("caller.attributes.print") and caller.attributes.print) and not (this_act_ eq 'dev.workdev')>
                                        <cfoutput>
                                        <li>
                                            <cfif len(attributes.settings) and attributes.settings eq 1><a href="javascript://" title="#caller.getLang('','Ayarlar',57435)#"><i class="catalyst-settings"></i></a></cfif>
                                            <ul>
                                                <cfif not len( attributes.widget_load )>
                                                    <li><a href="javascript://" onClick="copyToClipboard()" title="<cf_get_lang dictionary_id='57476.Kopyala'>"><i class="catalyst-globe-alt fa-2x"></i>#this_act_#</a><input type="text" value="#this_act_#" name="copyToClipboardInput" id="copyToClipboardInput" style="display:none;"></li>
                                                    <cfif IsDefined("caller.workcube_mode") and caller.workcube_mode eq 0>
                                                        <li><a href="javascript://" onClick="window.open('index.cfm?fuseaction=help.popup_add_problem&help=#this_act_#','<cf_get_lang dictionary_id='60908.Destek Başvuru'>');"><i class="fa fa-question-circle fa-2x"></i><cf_get_lang dictionary_id='55064.Sorun Bildir'></a></li>
                                                    </cfif>
                                                    <li><a href="javascript://" onClick="window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#this_act_#','Workflow')"><i class="fa fa-bell fa-2x"></i><cf_get_lang dictionary_id="57757.Uyarılar"></a></li>
                                                    <cfif session_base.admin and listFindNoCase(session_base.USER_LEVEL,7)>
                                                        <cfif len(this_act_event) and isdefined("caller.WOStruct")>
                                                            <li><a href="javascript://" id="wrk_xml_pop_" onClick="cfmodal('#request.self#?fuseaction=objects.popup_xml_setup&fuseact=#caller.WOStruct['#this_act_#']['#this_act_event#']['fuseaction']#&main_fuseact=#this_act_#','warning_modal');"><i class="fa fa-code fa-2x" ></i><cf_get_lang dictionary_id='61201.Page Settings'></a></li>
                                                        <cfelse>
                                                            <li><a href="javascript://" id="wrk_xml_pop_" onClick="cfmodal('#request.self#?fuseaction=objects.popup_xml_setup&fuseact=#this_act_#&main_fuseact=#this_act_#','warning_modal');"><i class="fa fa-code fa-2x"></i><cf_get_lang dictionary_id='61201.Page Settings'></a></li>
                                                        </cfif>
                                                        <cfif session_base.admin and isdefined("caller.fusebox.is_special") and caller.fusebox.is_special eq 1><img src="/images/add_options_mini.gif" title="Bu Sayfa Add Options'tan Çalışmaktadır." /></cfif>
                                                        <cfif isdefined("session_base.lang_change_action") and session_base.lang_change_action eq 1>
                                                            <li><a href="javascript://" class="tableyazi" onclick="windowopen('index.cfm?fuseaction=settings.popup_page_lang_list','wide')"><i class="catalyst-book-open fa-2x"></i>#caller.getLang('main',520)#</a></li>
                                                        </cfif>
                                                        <li><a href="javascript://"  onclick="myPopup('formPanel');"><i class="fa fa-pencil-square fa-2x"></i><cf_get_lang dictionary_id='47755.Page Designer'></a></li>
                                                        <cfquery name="get_woid" datasource="#caller.dsn#">
                                                            SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = <cfqueryparam value="#this_act_#" cfsqltype="cf_sql_nvarchar">
                                                        </cfquery>
                                                        <li><a href="index.cfm?fuseaction=dev.wo&event=upd&fuseact=<cfoutput>#this_act_#&woid=#get_woid.WRK_OBJECTS_ID#</cfoutput>" target="_blank"><i class="fa fa-globe fa-2x"></i><cf_get_lang dictionary_id="52706.Workdev"></a></li>
                                                    </cfif>
                                                    <cfset workcube_license = createObject("V16.settings.cfc.workcube_license").get_license_information() />
                                                    <li><a href="javascript://" id="wrk_workl_pop_" onClick="window.open('#workcube_license.implementation_project_domain#/index.cfm?fuseaction=project.works&work_detail_id=0&event=add&id=#workcube_license.implementation_project_id#&work_fuse=#this_act_#','İş Ekle');"><i class="fa fa-gears fa-2x"></i>#caller.getLang('','',57933)#</a></li>
                                                <cfelseif get_widget.recordcount>
                                                    <li><a href="index.cfm?fuseaction=dev.wo&event=upd&fuseact=<cfoutput>#get_widget.WIDGET_FUSEACTION#&woid=#get_widget.WRK_OBJECTS_ID#</cfoutput>" target="_blank"><i class="fa fa-globe fa-2x"></i><cf_get_lang dictionary_id="52706.Workdev"></a></li>
                                                    <cfif session_base.admin and listFindNoCase(session_base.USER_LEVEL,7)>
                                                        <cfif len(this_act_event) and isdefined("caller.WOStruct")>
                                                            <li><a href="javascript://" id="wrk_xml_pop_" onClick="cfmodal('#request.self#?fuseaction=objects.popup_xml_setup&fuseact=#caller.WOStruct['#this_act_#']['#this_act_event#']['fuseaction']#&main_fuseact=#this_act_#&friendly_url=#attributes.widget_load#','warning_modal');"><i class="fa fa-code fa-2x" ></i><cf_get_lang dictionary_id='61201.Page Settings'></a></li>
                                                        <cfelse>
                                                            <li><a href="javascript://" id="wrk_xml_pop_" onClick="cfmodal('#request.self#?fuseaction=objects.popup_xml_setup&fuseact=#this_act_#&main_fuseact=#this_act_#&friendly_url=#attributes.widget_load#','warning_modal');"><i class="fa fa-code fa-2x"></i><cf_get_lang dictionary_id='61201.Page Settings'></a></li>
                                                        </cfif>
                                                    </cfif>
                                                </cfif>
                                            </ul>
                                        </li>
                                        </cfoutput>
                                    </cfif>
                                </cfif>
                                <cfif attributes.closable>
                                    <li><a class="catalystClose" href="#attributes.close_href#" <cfif isdefined('attributes.call_function') and len(attributes.call_function)>onClick="#attributes.call_function#"</cfif> title="#caller.getLang('main',141)#">×</a></li>
                                </cfif>
                                   
                        </cfif>	
                    </ul>
                    <!-- del -->
                </div>		                 
            </div> 
        </cfif>
        <div class="portBoxBodyStandart <cfif attributes.scroll neq 0> scrollContent </cfif> " <cfif isdefined("attributes.uniquebox_height") and len(attributes.uniquebox_height)>style="height:#attributes.uniquebox_height#"</cfif>>

			<cfif attributes.design_type neq 0>
                <div id="body_#attributes.id#" style="#attributes.body_style#<cfif attributes.collapsed eq 1>display:none;</cfif><cfif len(attributes.body_height)>height:50px; overflow:scroll;</cfif>">
            <cfelse>
                <div id="body_#attributes.id#" style="#attributes.body_style#;<cfif caller.browserDetect() contains 'MSIE 10'>width:100%;<cfelseif caller.browserDetect() contains 'MSIE'>width:100%;<cfelse>width:100%;</cfif><cfif attributes.collapsed eq 1>display:none;</cfif><cfif len(attributes.body_height)>height:#attributes.body_height#;</cfif>">
            </cfif>
            <cfelse>
            <cfif isdefined("attributes.source")>
                <cfinclude template="#attributes.source#" />
            </cfif>
            <cfif isdefined("caller.form_box_count") and caller.form_box_count neq 0>
                </div>
                <cfset caller.form_box_count = 0>
            </cfif>
            <cfif attributes.design_type neq 0>
                </div>
            <cfelse>
                </div>
            </cfif>
            <cfif isdefined("caller.attributes.box_footer_#attributes.id#")>
              <div id="footer_#attributes.id#" class="footer">
                <cfoutput>#evaluate("caller.attributes.box_footer_#attributes.id#")#</cfoutput>
              </div> 
            </cfif>
        </div>
    </div>
	<cfif len(attributes.box_page)>
        <script type="text/javascript">
     
            function reload_#attributes.id#(vparams)
            {
                var addition = "";
                if (vparams !== undefined && vparams !== null && vparams !== '') {
                    addition += '&' + vparams;
                }
                AjaxPageLoad('#attributes.box_page#'+addition,'body_#attributes.id#',1);
           //     console.log('box_id:#attributes.title#   id:body_#attributes.id#  box_page:#attributes.box_page#');
            }
            <cfif attributes.unload_body eq 0>
	                reload_#attributes.id#();
            </cfif>
        </script>
    </cfif>
</div>
<cfif (not this_act_ contains 'popup_xml_setup') and (not this_act_ contains 'popup_content') and  (not this_act_ contains 'popup_operate_action') and (not this_act_ contains 'popup_send_print_action') and (not this_act_ contains 'popup_basket') and (not this_act_ contains 'popupflush_print_collected_barcodes') and (not this_act_ contains 'popup_barcode') and (not this_act_ contains 'popup_pd_edit') and (not isdefined("caller.attributes.iframe")) and not (isdefined("caller.attributes.print") and caller.attributes.print) and not (this_act_ eq 'dev.workdev') and not(this_act_ eq 'objects.chatflow') and not(this_act_ eq 'objects.workflowpages') and (not attributes.pure) and (not this_act_ contains 'report.') or not len(attributes.widget_load)>
    <script type="text/javascript">
        $( ".draggable_cf_box" ).draggable({
            handle: ".portHeadLight"
        });
        if(($(".pageMainLayout .boxRow").length > 2) || <cfoutput>#attributes.popup_box#</cfoutput> == 1){
            $('.catalystClose').click(function(){
                $(this).closest(".boxRow").hide();
            });
           $('.portHeadLightMenu').delegate('> ul > li > a','click',function(){
                $('.portHeadLightMenu > ul > li > ul').stop().fadeOut();
                $(this).parent().find("> ul").stop().fadeToggle();
            }); 
        }       
    </script>
</cfif>
<script src="https://apis.google.com/js/api.js?onload=onLoad" async defer></script> <!--- Google özellikleri için eklendi. --->
<script>
    <cfif attributes.responsive_table eq 1>
        var counter = 0;
        $('##card').click(function(){
            if(counter == 0){
                $('table').eq(1).hide();
                $('table').eq(0).show();
                counter = 1;
            }
            else{
                $('table').eq(0).hide();
                $('table').eq(1).show();
                counter = 0;
            }
        })
    </cfif>

    <cfif attributes.uidrop eq 1>
        $(window).load(function(){
            var  __div = $('div##buttons');
            var __buttons = __div.html();
            $('.wrkFileACtions').appendTo('##listIcon');      
                __div.remove();
            <cfif not len(attributes.export)>
                $('##listIcon').append( __buttons )
            </cfif>
            
        });//windows load

        function myTrim(x) {
            return x.replace(/^\s+|\s+$/gm,'');
        }

        function sendToGoogleSpreadSheet(form_){
            <cfset googleapi = createObject("component","WEX.google.cfc.google_api")>
            <cfset get_api_key = googleapi.get_api_key()>
            if(#len(get_api_key.GOOGLE_API_KEY)# > 10 && #len(get_api_key.GOOGLE_CLIENT_ID)# > 10 && #len(get_api_key.GOOGLE_CLIENT_SECRET)# > 10){
                var CLIENT_ID = '#get_api_key.GOOGLE_CLIENT_ID#';
                var CLIENT_SECRET = '#get_api_key.GOOGLE_CLIENT_SECRET#';
                var API_KEY = '#get_api_key.GOOGLE_API_KEY#';

                // Array of API discovery doc URLs for APIs used by the quickstart
                var DISCOVERY_DOCS = ["https://sheets.googleapis.com/$discovery/rest?version=v4"];
                var GoogleAuth;
                // Authorization scopes required by the API; multiple scopes can be
                // included, separated by spaces.
                var SCOPES = "https://www.googleapis.com/auth/spreadsheets https://www.googleapis.com/auth/spreadsheets.readonly https://www.googleapis.com/auth/drive https://www.googleapis.com/auth/drive.file https://www.googleapis.com/auth/drive.readonly";

                /**
                *  On load, called to load the auth2 library and API client library.
                */
                function handleClientLoad() {
                    gapi.load('client:auth2', initClient);
                }

                /**
                *  Initializes the API client library and sets up sign-in state
                *  listeners.
                */
                function initClient() {
                    gapi.client.init({
                    apiKey: API_KEY,
                    clientId: CLIENT_ID,
                    clientSecret: CLIENT_SECRET,
                    discoveryDocs: DISCOVERY_DOCS,
                    scope: SCOPES
                    }).then(function () {
                        GoogleAuth = gapi.auth2.getAuthInstance();
                        // Giriş aşaması
                        GoogleAuth.isSignedIn.listen(updateSigninStatus);
                        updateSigninStatus(GoogleAuth.isSignedIn.get());
                        if (GoogleAuth.isSignedIn.get() == false){
                            GoogleAuth.signIn();
                        }
                        
                    }, function(error) {
                        /* console.log(error.details); */
                        alert("<cf_get_lang dictionary_id='29917.Hata Oluştu'>");
                    });
                }

                function updateSigninStatus(isSignedIn) {
                    if (isSignedIn) {
                        var user = GoogleAuth.currentUser.get();
                        var isAuthorized = user.hasGrantedScopes(SCOPES);
                        if(isAuthorized){
                            $("##sheetAlert").html("<cf_get_lang dictionary_id='64121.Dosya açılıyor'>");
                            createSheet("#attributes.title#",form_);
                            return false;
                        }else{
                            GoogleAuth.signOut();
                        }
                    } else {
                        alert("<cf_get_lang dictionary_id='64111.Google Hesabınızla Giriş Yapmalısınız!'>");
                    }
                }

                handleClientLoad();
            }else{
                alert("<cf_get_lang dictionary_id='61524.API Key'>, <cf_get_lang dictionary_id='64109.CLIENT_ID'>, <cf_get_lang dictionary_id='64110.CLIENT_SECRET'> bilgilerinin girilmesi gerekiyor.");
                return false;
            }       
        }

        function createSheet(title, form_){
            gapi.client.sheets.spreadsheets.create({
                properties: {
                    title: title
                }
            }).then((response) => {
                // [START_EXCLUDE silent]
                /* console.log('Spreadsheet ID: ' + response.result.spreadsheetId); */
                var sheetId = response.result.sheets[0].properties.sheetId;
                window.open("https://docs.google.com/spreadsheets/d/"+response.result.spreadsheetId+"/edit##gid=0");
                $("##sheetAlert").html('<cf_get_lang dictionary_id='63757.Google Tablolar'><cf_get_lang dictionary_id='30022.ile'><cf_get_lang dictionary_id='48969.Aç'>');
                syncToSheet(response.result.spreadsheetId, form_, sheetId);
            });
        }

        
        function syncToSheet(spreadsheetId, form_, sheetId_) {
            /* TABLO İÇERİĞİ ALINIYOR */
            var table = $(form_).parents('.portBox').find('> .portBoxBodyStandart table');
            var tableTr = $(form_).parents('.portBox').find('> .portBoxBodyStandart table tr');

            var tableTdContent = [];
            var tableTrContent = [];

            // Kolonlar
            table.each(function() {
                var trContents = [];
                var tableRows = $(this).find('tr');
                if (tableRows.length > 0) {
                    tableRows.each(function() { trContents.push($(this).text()); });
                    tableTrContent.push(trContents);
                }
            });

            // Tablo içeriği
            tableTr.each(function() {
                var trContents = [];
                var tableRows = $(this).find('tr');
                if (tableRows.length > 0) {
                    tableRows.each(function() { trContents.push($(this).text().trim()); });
                    tableTrContent.push(trContents);
                }
                var tdContents = [];
                var tableData = $(this).find('td');
                if (tableData.length > 0) {
                    tableData.each(function() { tdContents.push(myTrim($(this).text())); });
                    tableTdContent.push(tdContents);
                }
            });
            
            var columnNames = [myTrim(tableTrContent[0][0]).split("\n")];
            /* //TABLO İÇERİĞİ ALINIYOR */

            var cellsToAdd = columnNames.concat(tableTdContent);
            
            var params = {
                spreadsheetId: spreadsheetId, // yeni oluşan spreadsheet id'si
                range: 'A1',
                valueInputOption: 'USER_ENTERED',
            };

        
            var valueRangeBody = { // yeni oluşan spreadsheet içine yazılacak bilgiler
                "values": cellsToAdd
            };

            var request = gapi.client.sheets.spreadsheets.values.update(params, valueRangeBody);
            request.then(function(response) {
                /* console.log(response.result); */
            }, function(reason) {
                /* console.error('error: ' + reason.result.error.message); */
            });

            var headerRowFormat = { // başlık satırını kalın yapıyor ve boyutunu ayarlıyor
                "repeatCell": {
                    "range": {
                        "sheetId": sheetId_, // tablonun ilk sayfası - Sayfa1 için 0 (sıfır) değeri girilmeli
                        "startRowIndex": 0, // düzenlemenin uygulamaya başlanacağı satır
                        "endRowIndex": 1 // düzenlemenin biteceği satır - 1 ise, 1 dahil DEĞİL demektir.
                    },
                    "cell": {
                        "userEnteredFormat": {
                            "horizontalAlignment" : "CENTER",
                            "textFormat": {
                                "fontSize": 11,
                                "bold": true
                            }
                        }
                    },
                    "fields": "userEnteredFormat(textFormat,horizontalAlignment)"
                }
            };

            getSpreadSheet(spreadsheetId, headerRowFormat);

            var cellWidth = { // hücre genişliklerini, veriye göre otomatik ayarlıyor
                "autoResizeDimensions": {
                    "dimensions": {
                        "dimension": "COLUMNS"
                    }
                }
            };

            getSpreadSheet(spreadsheetId, cellWidth);

        }

        function getSpreadSheet(spreadsheetId, req_){
            var requests = [];
            // Oluşturulan tabloda düzenleme yapılıyor
            requests.push( req_ );
            // Find and replace text.
            requests.push({
                findReplace: {
                    find: "*",
                    replacement: "*",
                    allSheets: true
                }
            });

            var batchUpdateRequest = {requests: requests}

            gapi.client.sheets.spreadsheets.batchUpdate({
            spreadsheetId: spreadsheetId,
            resource: batchUpdateRequest
            }).then((response) => {
                var findReplaceResponse = response.result.replies[1].findReplace;
                /* console.log("Başarılı!");
                console.log(findReplaceResponse); */
            });
        }
	

        function PROCTest(form_,type_id)
        {
            exForm = form_;
            var table = $(form_).parents('.portBox').find('> .portBoxBodyStandart table'), dataAll = '';
            if(table.length > 1){ /* tek tablo olan yerlerde mükerrer kayıt atıyordu. */
                /* console.log(form_); */ 
                exForm = form_;
                var table = $(form_).parents('.portBox').find('> .portBoxBodyStandart table'), dataAll = '';

                /* console.log(table); */

                if(type_id == 0)
                {
                    form_ = $("##listIcon").closest('form');	
                    if(form_.length == 0)
                        form_ = $(exForm).closest('form');
                    if(eval('_CF_check'+$(form_).attr('name')+'('+$(form_).attr('name')+')'))
                    {
                        <cfif isdefined("caller.WOStruct")>
                            console.log(validate().check());
                            if(validate().check())
                            {
                                goster(working_div_main);
                                $(form_).submit();
                                $(form_).find(':input[id="is_excel"]').each(function(){
                                    if($(this).prop('checked')){
                                    $("##working_div_main").hide();
                                    }
                                });
                            }
                            else
                            {
                                gizle(working_div_main);
                                return false;
                            }
                        <cfelse>
                            goster(working_div_main);
                            $(form_).submit();
                        </cfif>
                    }
                }
                else
                {
                    try{
                        table.each(function(){
                            $(this).html($(this).html().replace(/<!-- del -->/g,''));
                            
                            $(this).find('th:hidden').each(function(index,element){

                                $(element).before('<!-- del -->');
                                $(element).after('<!-- del -->');

                            });

                            $(this).find('td:hidden').each(function(index,element){

                                $(element).before('<!-- del -->');
                                $(element).after('<!-- del -->');

                            });

                            $(this).find('input').each(function(index,element){

                                if($(element).attr('type')=='text'){

                                    inputName = $(element).attr("name");
                                    val_ = $(element).val();
                                    $('##'+ inputName +'_span_export').remove();
                                    $(element).after('<span id="'+ inputName +'_span_export" style="display:none;">'+val_+'</span>');

                                }
                            });

                            dataAll += '<!-- sil --><table>'+$(this).html().replace(/\n/g,'').replace(/\t/g,'')+'</table><!-- sil -->';

                            $(this).find('span').each(function(index,element){
                                if(!element.hasClass("ui-stage")){
                                    $(element).remove();
                                }
                            });
                        }); 
                    }catch(e){
                        table.each(function(){
                            if($(this).html($(this).html())){
                                try{
                                    $(this).html($(this).html().replace(/<!-- del -->/g,''));
                                    $(this).find('th:hidden').each(function(index,element){
                                        $(element).before('<!-- del -->');
                                        $(element).after('<!-- del -->');
                                    });
                                    $(this).find('td:hidden').each(function(index,element){
                                        $(element).before('<!-- del -->');
                                        $(element).after('<!-- del -->');
                                    });
                                    dataAll += '<!-- sil --><table>'+$(this).html().replace(/\n/g,'').replace(/\t/g,'')+'</table><!-- sil -->';
                                    }catch(e){
                                        $(this).html($(this).html().replace(/<!-- del -->/g,''));
                                        $(this).find('th:hidden').each(function(index,element){
                                            $(element).before('<!-- del -->');
                                            $(element).after('<!-- del -->');
                                        });
                                        $(this).find('td:hidden').each(function(index,element){
                                            $(element).before('<!-- del -->');
                                            $(element).after('<!-- del -->');
                                        });
                                        dataAll += '<!-- sil --><table>'+$(this).html().replace(/\n/g,'').replace(/\t/g,'')+'</table><!-- sil -->';
                                    }
                            }else{
                                $(this).html($(this).html().replace(/<!-- del -->/g,''));
                                $(this).find('th:hidden').each(function(index,element){
                                    $(element).before('<!-- del -->');
                                    $(element).after('<!-- del -->');
                                });
                                $(this).find('td:hidden').each(function(index,element){
                                    $(element).before('<!-- del -->');
                                    $(element).after('<!-- del -->');
                                });
                                dataAll += '<!-- sil --><table>'+$(this).html().replace(/\n/g,'').replace(/\t/g,'')+'</table><!-- sil -->';	
                            }
                        });
                    }
                    dataAll = JSON.stringify(encodeURIComponent(dataAll));
                    goster(working_div_main);
                    dark_mode = '<cfoutput>#listfirst(session.dark_mode,":")#</cfoutput>';
                    dark_mode = dark_mode.trim();
                    dark_mode_value = '<cfoutput>#listlast(session.dark_mode,":")#</cfoutput>';
                    dark_mode_value = dark_mode_value.trim();
                    callURL("<cfoutput>#request.self#?fuseaction=objects.docExport&ajax=1&ajax_box_page=1&xmlhttp=1&_cf_nodebug=true&action_type=</cfoutput>"+type_id,handlerPost,{ data: $.toJSON(dataAll),"<cfoutput>#listfirst(session.dark_mode,":")#</cfoutput>" : dark_mode_value});
                }
            }else{
                /* console.log(form_); */ 
                exForm = form_;

                var table = $(form_).parents('.portBox').find('> .portBoxBodyStandart table');

                /* console.log(table); */

                if(type_id == 0)
                {
                    form_ = $("##listIcon").closest('form');	
                    if(form_.length == 0)
                        form_ = $(exForm).closest('form');
                    if(eval('_CF_check'+$(form_).attr('name')+'('+$(form_).attr('name')+')'))
                    {
                        <cfif isdefined("caller.WOStruct")>
                            console.log(validate().check());
                            if(validate().check())
                            {
                                goster(working_div_main);
                                $(form_).submit();
                                $(form_).find(':input[id="is_excel"]').each(function(){
                                    if($(this).prop('checked')){
                                    $("##working_div_main").hide();
                                    }
                                });
                            }
                            else
                            {
                                gizle(working_div_main);
                                return false;
                            }
                        <cfelse>
                            goster(working_div_main);
                            $(form_).submit();
                        </cfif>
                    }
                }
                else
                {
                    try{
                            $(table).html($(table).html().replace(/<!-- del -->/g,''));
                            
                            $(table).find('th:hidden').each(function(index,element){

                                $(element).before('<!-- del -->');

                                $(element).after('<!-- del -->');

                                })

                            $(table).find('td:hidden').each(function(index,element){

                                $(element).before('<!-- del -->');

                                $(element).after('<!-- del -->');

                                })

                            $(table).find('input').each(function(index,element){

                                    if($(element).attr('type')=='text'){

                                        inputName = $(element).attr("name");
                                        val_ = $(element).val();
                                        $('##'+ inputName +'_span_export').remove();
                                        $(element).after('<span id="'+ inputName +'_span_export" style="display:none;">'+val_+'</span>');

                                    }
                            });

                            $(table).find('.gdpr_alert,.el_hidden').each(function(){
                                $(this).remove();
                            });
                            var dataAll = JSON.stringify(encodeURIComponent('<!-- sil --><table>'+$(table).html().replace(/\n/g,'').replace(/\t/g,'')+'</table><!-- sil -->'));

                            $(table).find('span').each(function(index,element){

                                    if(!element.hasClass("ui-stage")){
                                        $(element).remove();
                                    }
                                    

                                });
                            }
                    catch(e)
                    {
                        if($(table).html($(table).html())){
                            try{
                                $(table).html($(table).html().replace(/<!-- del -->/g,''));
                                $(table).find('th:hidden').each(function(index,element){
                                    $(element).before('<!-- del -->');
                                    $(element).after('<!-- del -->');
                                    })
                                $(table).find('td:hidden').each(function(index,element){
                                    $(element).before('<!-- del -->');
                                    $(element).after('<!-- del -->');
                                    })
                                var dataAll = JSON.stringify(encodeURIComponent('<!-- sil --><table>'+$(table).html().replace(/\n/g,'').replace(/\t/g,'')+'</table><!-- sil -->'));
                                }catch(e){
                                    $(table).html($(table).html().replace(/<!-- del -->/g,''));
                                    $(table).find('th:hidden').each(function(index,element){
                                        $(element).before('<!-- del -->');
                                        $(element).after('<!-- del -->');
                                        })
                                    $(table).find('td:hidden').each(function(index,element){
                                        $(element).before('<!-- del -->');
                                        $(element).after('<!-- del -->');
                                        })
                                    var dataAll = JSON.stringify(encodeURIComponent('<!-- sil --><table>'+$(table).html().replace(/\n/g,'').replace(/\t/g,'')+'</table><!-- sil -->'));
                                }
                        }else{
                            $(table).html($(table).html().replace(/<!-- del -->/g,''));
                            $(table).find('th:hidden').each(function(index,element){
                                $(element).before('<!-- del -->');
                                $(element).after('<!-- del -->');
                                })
                            $(table).find('td:hidden').each(function(index,element){
                                $(element).before('<!-- del -->');
                                $(element).after('<!-- del -->');
                                })
                            var dataAll = JSON.stringify(encodeURIComponent('<!-- sil --><table>'+$(table).html().replace(/\n/g,'').replace(/\t/g,'')+'</table><!-- sil -->'));	
                        }
                    }
                    goster(working_div_main);
                    dark_mode = '<cfoutput>#listfirst(session.dark_mode,":")#</cfoutput>';
                    dark_mode = dark_mode.trim();
                    dark_mode_value = '<cfoutput>#listlast(session.dark_mode,":")#</cfoutput>';
                    dark_mode_value = dark_mode_value.trim();
                    callURL("<cfoutput>#request.self#?fuseaction=objects.docExport&ajax=1&ajax_box_page=1&xmlhttp=1&_cf_nodebug=true&action_type=</cfoutput>"+type_id,handlerPost,{ data: $.toJSON(dataAll),"<cfoutput>#listfirst(session.dark_mode,":")#</cfoutput>" : dark_mode_value});
                }
            }
            
        }
        if($('##wrk_search_button').length==0){
            function callURL(url, callback, data, target, async)
            {   
                var method = (data != null) ? "POST": "GET";
                $.ajax({
                    async: async != null ? async: true,
                    url: url,
                    type: method,
                    data: data,
                    success: function(responseData, status, jqXHR)
                    { 
                        callback(target, responseData, status, jqXHR); 
                    }
                });
            }
        }

        <cfif structCount( attributes.woc_setting )>
        $("##sendWoc").click(function(){
            var wocList = [], action_type = [];
            $("input[ name = #attributes.woc_setting.checkbox_name# ]:checked").each(function(){
                wocList.push($(this).val());
                if( $(this).attr("data-action-type") != undefined && $(this).attr("data-action-type") != '' ) action_type.push($(this).attr("data-action-type"));
            });
            
            if( wocList.length == 0 ) alert('<cf_get_lang dictionary_id = "30942.Listeden Satır Seçmelisiniz">!');
            else window.open('#request.self#?fuseaction=objects.popup_print_files&action=#this_act_#&woc_action_type='+action_type+'<cfif isDefined("attributes.woc_setting.print_type")>&print_type=#attributes.woc_setting.print_type#</cfif>&woc_list='+wocList+'','WOC');
        });
        </cfif>
    </cfif>
    function copyToClipboard() {
        var copyText = document.getElementById("copyToClipboardInput");
        copyText.select();
        copyText.setSelectionRange(0, 99999); /* For mobile devices */
        navigator.clipboard.writeText(copyText.value);
        alert("<cf_get_lang dictionary_id='65132.Kopyalandı'>: " + copyText.value);
    }
    <cfif len(attributes.draggable_icon) and len(attributes.draggable_href) and len(attributes.draggable_size) and len(attributes.draggable_href_title) and len(attributes.box_modal_id)>
        function openDraggable(href_,size)
        {
            openBoxDraggable(href_,'',size);
            closeBoxDraggable('<cfoutput>#attributes.box_modal_id#</cfoutput>');
        }
    </cfif>
</script>
</cfif>
</cfoutput>