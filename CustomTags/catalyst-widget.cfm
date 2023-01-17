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
<cfelseif isdefined("caller.caller.attributes.fuseaction")>
	<cfset this_act_ = caller.caller.attributes.fuseaction>
<cfelse>
	<cfset this_act_ = 'myhome.welcome'>
</cfif>

<cfset caller.last_box_id = attributes.id>

<cfparam name="attributes.dragDrop" default="0">
<cfparam name="attributes.class" default="">
<cfparam name="attributes.isWidget" default="0" type="integer">
<cfparam name="attributes.edit_href" default="">
<cfparam name="attributes.add_href" default="">
<cfparam name="attributes.add_href_2" default="">
<cfparam name="attributes.add_href_3" default="">
<cfparam name="attributes.add_href_2_size" default="wwide">
<cfparam name="attributes.add_href_3_size" default="list">
<cfparam name="attributes.add_href_size" default="list">
<cfparam name="attributes.add_href_title" default="#caller.getLang('main',170)#">
<cfparam name="attributes.add_href_2_title" default="#caller.getLang('main',170)#">
<cfparam name="attributes.collapsable" default="1" type="boolean">
<cfparam name="attributes.refresh" default="1" type="boolean">
<cfparam name="attributes.closable" default="1" type="boolean">
<cfparam name="attributes.type" default="box" type="string">
<cfparam name="attributes.box_page" default="">
<cfparam name="attributes.scroll" default="1">
<cfif isdefined("session.pda") and isDefined("session.pda.userid")>
	<cfparam name="attributes.collapse_href" default="javascript:gizle(#attributes.id#);">
	<cfparam name="attributes.close_href" default="javascript:gizle(#attributes.id#);">
<cfelse>
	<cfparam name="attributes.collapse_href" default="show_hide_box('#attributes.id#','#attributes.box_page#','#attributes.dragDrop#','#this_act_#');">
	<cfparam name="attributes.close_href" default="javascript:show_hide('#attributes.id#');gizle(#attributes.id#);">
</cfif>
<cfparam name="attributes.collapsed" default="0">
<cfparam name="attributes.body_height" default="">
<cfparam name="attributes.style" default="">
<cfparam name="attributes.header_style" default="">
<cfparam name="attributes.body_style" default="">
<cfparam name="attributes.title_style" default="font-weight:bold;">
<cfparam name="attributes.info_href" default="">
<cfparam name="attributes.info_href_2" default="">
<cfparam name="attributes.info_title_2" default="">
<cfparam name="attributes.info_title" default="#caller.getLang('main',153)#"> 
<cfparam name="attributes.call_function" default="">
<cfparam name="attributes.title" default="">
<cfparam name="attributes.unload_body" default="0">
<cfparam name="attributes.design_type" default="0">
<cfparam name="attributes.left_side" default="0">

<cfif attributes.info_title neq caller.getLang('main',497)>
	<cfset attributes.info_title = attributes.info_title>
</cfif>

<cfif attributes.unload_body eq 1>
	<cfset attributes.collapsed = 1>
</cfif>
<cfoutput>
<cfif thisTag.executionMode eq "start">
<div id="action_#attributes.id#" style="display:none; width:1px;"></div>
    <div id="homebox_#attributes.id#" <cfif len(attributes.class)>class="#attributes.class#"<cfelse> class="col col-12 portBox portWidget<cfif attributes.type eq "window" >pod_box_window</cfif>"</cfif> style="<cfif len(attributes.style)>#attributes.style#</cfif>;">
       <cfif isdefined("attributes.title") and len(attributes.title)>
           	<div id="header_#attributes.id#" class="portHead font-red-pink" style="<cfif len(attributes.header_style)>#attributes.header_style#</cfif>">	
           		  <span id="handle_#attributes.id#" <cfif attributes.dragDrop eq 1> style="cursor:pointer;"</cfif>><cfif attributes.dragDrop eq 1>#attributes.title#<cfelse><a href="javascript://" class="font-red-pink" onclick="#attributes.collapse_href#">#attributes.title#</a></cfif></span> 
                  <!--- DİKKAT: bu satır, Firefox hack'tir. Kalacak. --->
					<cfif attributes.closable eq 1>
						<span class="catalystClose pull-right"<cfif isdefined('attributes.call_function') and len(attributes.call_function)> onClick="#attributes.call_function#,#attributes.close_href#" <cfelse> onClick="#attributes.close_href#" </cfif> title="#caller.getLang('main',141)#">×</span>
					</cfif>
                    <cfif len(attributes.info_href)>
                        <span class="pull-righ catalyst-magnifiert" onclick="windowopen('#attributes.info_href#','list');" title="#attributes.info_title#"></span>
                    </cfif> 
                    <cfif len(attributes.info_href) and (attributes.info_href contains 'ajaxpageload' or attributes.info_href contains 'cfmodal' or attributes.info_href contains 'openBoxDraggable')>
                        <span class="pull-right catalyst-magnifier" onclick="#attributes.info_href#"></span>
                    <cfelseif len(attributes.info_href)>
                        <span class="pull-right catalyst-magnifier" onclick="windowopen('#attributes.info_href#','list');" title="#attributes.info_title#"></span>
                    </cfif>
                    <cfif len(attributes.add_href) and attributes.add_href contains 'javascript:'>
                        <span class="pull-right"><a href="javascript://" onclick="#attributes.add_href#" class="font-red-pink">4<i class="icons8-pin-3" title="#attributes.info_title#"></i></a></span>
                    <cfelseif len(attributes.add_href) and (attributes.add_href contains 'ajaxpageload' or attributes.add_href contains 'cfmodal' or attributes.add_href contains 'openBoxDraggable')>
                        <span class="pull-right"><a href="javascript://" onclick="#attributes.add_href#" class="font-red-pink">5<i class="icons8-pin-3" title="#attributes.info_title#"></i></a></span>
                    <cfelseif len(attributes.add_href) and not(attributes.add_href contains 'popup_' or attributes.add_href contains '_popup')>
                        <span class="pull-right"><a href="#attributes.add_href#" target="_blank" class="font-red-pink"><i class="catalyst-plus" title="#caller.getLang('main',170)#"></i></a></span>
                    <cfelseif len(attributes.add_href)>
                        <span class="pull-right catalyst-paper-clip" onclick="windowopen('#attributes.add_href#','#attributes.add_href_size#','#attributes.id#');" title="#attributes.info_title#"></span>
                    </cfif>
                    <cfif len(attributes.add_href_3) and (attributes.add_href_3 contains 'ajaxpageload' or attributes.add_href_3 contains 'cfmodal' or attributes.add_href_3 contains 'openBoxDraggable')>
                        <span class="pull-right catalyst-plus" title="#caller.getLang('main',170)#" onclick="#attributes.add_href_3#"></span>
                    <cfelseif len(attributes.add_href_3)>
                        <span class="pull-right catalyst-plus" title="#caller.getLang('main',170)#" onclick="windowopen('#attributes.add_href_3#','#attributes.add_href_3_size#','#attributes.id#');"></span>
                    </cfif>  
                    <cfif len(attributes.box_page) and attributes.refresh>
                        <span class="pull-right catalyst-refresh" onclick="refresh_box('#attributes.id#','#attributes.box_page#','#attributes.dragDrop#');" title="#caller.getLang('main',1667)#"></span>
                    </cfif>
                     <cfif attributes.collapsable>
                        <span class="pull-right catalyst-arrow-down" onclick="#attributes.collapse_href#"  title="#caller.getLang('bank',308)#/#caller.getLang('main',141)#"></span>
                    </cfif>  
						<span class="pull-right icons8-resize-diagonal" title="#caller.getLang('help',24)#" onclick="fs({id:'homebox_#attributes.id#'});"></span>
            </div> 
        </cfif>        
			<cfif attributes.design_type neq 0>
                <div class="portBody <cfif attributes.scroll eq 1>scrollContent scroll-x4</cfif>" id="body_#attributes.id#" style="#attributes.body_style#; <cfif attributes.unload_body eq 1>display:none;</cfif><cfif len(attributes.body_height)>height:50px; </cfif>">
            <cfelse>
                <div class="portBody <cfif attributes.scroll eq 1>scrollContent scroll-x4</cfif>" id="body_#attributes.id#" style="#attributes.body_style#; <cfif caller.browserDetect() contains 'MSIE 10'></cfif><cfif attributes.unload_body eq 1>display:none;</cfif><cfif len(attributes.body_height)></cfif>">
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
	<cfif len(attributes.box_page)>
        <script type="text/javascript">
            function reload_#attributes.id#()
            {
                AjaxPageLoad('#attributes.box_page#','body_#attributes.id#',1);
            }
            <cfif attributes.unload_body eq 0>
	                reload_#attributes.id#();
            </cfif>
        </script>
    </cfif>
</cfif>
</cfoutput>
