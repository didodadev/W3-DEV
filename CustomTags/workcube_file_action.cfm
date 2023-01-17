<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="Yes">
<!---
Description :   
			standardize pdf,document,print,fax and mail actions 
Parameters :
			pdf    --> For pdf action    'optional
			print  --> For print action  'optional
			doc    --> For doc action    'optional
			mail   --> For mail action   'optional
			extra_parameters --> for extra properties 'optional
			flash_paper   --> For flash_paper action   'optional	
			width --> for width of pdf / flashpaper
			hegiht --> for height of pdf / flashpaper		
			trail  --> to show logo and address or not
			show_datetime --> tarih saat gosterimi

Syntax :
<cf_workcube_file_action pdf='1' print='1' doc='1' mail='1' flash_paper='1'>
created Ömür Camcı 20030704
modified ÖC20030708 - 20041104 -20041228
modified YO20050620  alt='#caller.lang_array_main.item[1065]#'
--->
<cfparam name="attributes.trail" default="1">
<cfparam name="attributes.is_logo" default="0">
<cfparam name="attributes.show_datetime" default="0">
<cfparam name="attributes.print_type" default="">
<cfparam name="attributes.action_id" default="">
<cfparam name="attributes.search_buttons" default="">
<cfparam name="attributes.is_print_req" default="0">
<cfparam name="attributes.icon_text" default="">
<cfparam name="attributes.simple" default="0"><!--- yeni arayüzde right_images parametresinin içine gömdüğümüzde td eklenmesin diye konuldu --->
<cfif isdefined("attributes.tag_module")>
	<cfset my_tag_module = attributes.tag_module>
<cfelse>
	<cfif isdefined("caller.fusebox.circuit")>
    	<cfset my_tag_module = caller.fusebox.circuit>
    <cfelse>
    	<cfset my_tag_module = caller.caller.fusebox.circuit>
    </cfif>
</cfif>
<cfparam name="attributes.is_ajax" default="0">
<cfif not isdefined("caller.attibutes.close_file_action_buttons") or attributes.is_print_req eq 1>
    <cfif isdefined("caller.tabMenuData")>
    	<cfset caller.iconSet = StructNew()>
			<cfif isDefined('attributes.flash_paper') and attributes.flash_paper>
            	<cfset caller.iconSet.flash = StructNew()>
                <cfset url_str = ''>
                <cfif isdefined("attributes.extra_parameters")>
                	<cfset url_str = url_str&'&extra_parameters=#attributes.extra_parameters#'>
                </cfif>
                <cfif isdefined("attributes.height")>
                	<cfset url_str = url_str&'&page_height=#attributes.height#'>
                </cfif>
                <cfif isdefined("attributes.width")>
                	<cfset url_str = url_str&'&page_width=#attributes.width#'>
                </cfif>
                <cfif isdefined("attributes.tag_module")>
                	<cfset url_str = url_str&'&special_module=1'>
                </cfif>
                <cfif attributes.is_ajax eq 1>
                	<cfset url_str = url_str&'&is_ajax=1'>
                </cfif>
                <cfset caller.iconSet.flash.text = 'file-video-o'>
                <cfset caller.iconSet.flash.js = "windowopen('#request.self#?fuseaction=objects.popup_convertpdf&module=#my_tag_module#&trail=#attributes.trail#&iframe=1&ispdf=0&#url_str#','small','popup_documenter');">
            </cfif>
            <cfif isDefined('attributes.doc') and attributes.doc>
            	<cfset caller.iconSet.doc = StructNew()>
                <cfset url_str = ''>
                <cfif isdefined("attributes.extra_parameters")>
                	<cfset url_str = url_str&'&extra_parameters=#attributes.extra_parameters#'>
                </cfif>
                <cfif isdefined("attributes.tag_module")>
                	<cfset url_str = url_str&'&special_module=1'>
                </cfif>
                <cfif attributes.is_ajax eq 1>
                	<cfset url_str = url_str&'&is_ajax=1'>
                </cfif>
                <cfif isdefined("attributes.noShow")>
                	<cfset url_str = url_str&'&noShow=#attributes.noShow#'>
                </cfif>
                <cfif isdefined("attributes.isAjaxPage") and attributes.isAjaxPage eq 1>
                	<cfset url_str = url_str&'&isAjaxPage=1'>
                </cfif>
                <cfset caller.iconSet.doc.text = 'save'>
                <cfset caller.iconSet.doc.js = "windowopen('#request.self#?fuseaction=objects.popup_documenter&module=#my_tag_module#&#url_str#','small','popup_documenter');">
            </cfif>
            <cfif isDefined('attributes.pdf') and attributes.pdf>
            	<cfset caller.iconSet.pdf = StructNew()>
                <cfset url_str = ''>
                <cfif isdefined("attributes.extra_parameters")>
                	<cfset url_str = url_str&'&extra_parameters=#attributes.extra_parameters#'>
                </cfif>
                <cfif isdefined("attributes.height")>
                	<cfset url_str = url_str&'&page_height=#attributes.height#'>
                </cfif>
                <cfif isdefined("attributes.width")>
                	<cfset url_str = url_str&'&page_width=#attributes.width#'>
                </cfif>
                <cfif isdefined("attributes.tag_module")>
                	<cfset url_str = url_str&'&special_module=1'>
                </cfif>
                <cfif attributes.is_ajax eq 1>
                	<cfset url_str = url_str&'&is_ajax=1'>
                </cfif>
                <cfif isdefined("attributes.noShow")>
                	<cfset url_str = url_str&'&noShow=#attributes.noShow#'>
                </cfif>
                <cfif isdefined("attributes.isAjaxPage") and attributes.isAjaxPage eq 1>
                	<cfset url_str = url_str&'&isAjaxPage=1'>
                </cfif>
                <cfset caller.iconSet.pdf.text = 'file-pdf-o'>
                <cfset caller.iconSet.pdf.js = "windowopen('#request.self#?fuseaction=objects.popup_convertpdf&module=#my_tag_module#&ispdf=1&#url_str#','medium','popup_convertpdf');">
            </cfif>
            <cfif isDefined('attributes.mail') and attributes.mail>
            	<cfset caller.iconSet.mail = StructNew()>
                <cfset url_str = ''>
                <cfif isdefined("attributes.extra_parameters")>
                	<cfset url_str = url_str&'&extra_parameters=#attributes.extra_parameters#'>
                </cfif>
                <cfif isdefined("attributes.tag_module")>
                	<cfset url_str = url_str&'&special_module=1'>
                </cfif>
                <cfif attributes.is_ajax eq 1>
                	<cfset url_str = url_str&'&is_ajax=1'>
                </cfif>
                <cfif  len(attributes.print_type)>
                	<cfset url_str = url_str&'&print_type=#attributes.print_type#'>
                </cfif>
                <cfif len(attributes.action_id)>
                	<cfset url_str = url_str&'&action_id=#attributes.action_id#'>
                </cfif>
                <cfif isdefined("attributes.noShow")>
                	<cfset url_str = url_str&'&noShow=#attributes.noShow#'>
                </cfif>
                <cfif isdefined("attributes.isAjaxPage") and attributes.isAjaxPage eq 1>
                	<cfset url_str = url_str&'&isAjaxPage=1'>
                </cfif>
                <cfset caller.iconSet.mail.text = 'envelope-o'>
                <cfset caller.iconSet.mail.js = "windowopen('#request.self#?fuseaction=objects.popup_mail&module=#my_tag_module#&trail=#attributes.trail#&#url_str#','list','popup_mail');">
            </cfif>
            <cfif isDefined('attributes.print') and attributes.print>
            	<cfset caller.iconSet.print = StructNew()>
                <cfset url_str = ''>
                <cfif isdefined("attributes.extra_parameters")>
                	<cfset url_str = url_str&'&extra_parameters=#attributes.extra_parameters#'>
                </cfif>
                <cfif isdefined("attributes.tag_module")>
                	<cfset url_str = url_str&'&special_module=1'>
                </cfif>
                <cfif attributes.is_ajax eq 1>
                	<cfset url_str = url_str&'&is_ajax=1'>
                </cfif>
                <cfif isdefined("attributes.no_display")>
                	<cfset url_str = url_str&'&no_display=1'>
                </cfif>
                <cfif isdefined("attributes.noShow")>
                	<cfset url_str = url_str&'&noShow=#attributes.noShow#'>
                </cfif>
                <cfif isdefined("attributes.isAjaxPage") and attributes.isAjaxPage eq 1>
                	<cfset url_str = url_str&'&isAjaxPage=1'>
                </cfif>
                <cfset caller.iconSet.print.text = 'print'>
                <cfset caller.iconSet.print.js = "printSa()">
            </cfif>
    <cfelse>
		<cfoutput>
            <cfif isDefined("attributes.box")>
                <cfif isDefined('attributes.flash_paper') and attributes.flash_paper>
                    <li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_convertpdf&module=#my_tag_module#&trail=#attributes.trail#<cfif isdefined("attributes.extra_parameters")>&extra_parameters=#attributes.extra_parameters#</cfif><cfif isdefined("attributes.height")>&page_height=#attributes.height#</cfif><cfif isdefined("attributes.width")>&page_width=#attributes.width#</cfif><cfif isdefined("attributes.tag_module")>&special_module=1</cfif>&iframe=1&ispdf=0<cfif attributes.is_ajax eq 1>&is_ajax=1</cfif>','small','popup_convertpdf')" class=" <cfif len(attributes.icon_text)>ui-wrk-btn-addon-left</cfif> <cfif len(attributes.search_buttons)>search-buttons</cfif>">
                        <i class="icon-file-video-o" title="Flash" id="list_flash_paper_button"></i><cfif len(attributes.icon_text)>Flash</cfif>
                    </a>  </li>
                </cfif>
                <cfif isDefined('attributes.doc') and attributes.doc>
                    <li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_documenter&module=#my_tag_module#<cfif isdefined("attributes.extra_parameters")>&extra_parameters=#attributes.extra_parameters#</cfif><cfif isdefined("attributes.tag_module")>&special_module=1</cfif><cfif attributes.is_ajax eq 1>&is_ajax=1</cfif><cfif isdefined("attributes.noShow")>&noShow=#attributes.noShow#</cfif><cfif isdefined("attributes.isAjaxPage") and attributes.isAjaxPage eq 1>&isAjaxPage=1</cfif>','small','popup_documenter')" class="<cfif len(attributes.icon_text)>ui-wrk-btn-addon-left</cfif> <cfif len(attributes.search_buttons)>search-buttons</cfif>">
                        <i class="fa fa-save" title="#caller.getLang('main',49)#" id="list_save_button"></i><cfif len(attributes.icon_text)>Kaydet</cfif>
                    </a>  </li>
                </cfif>	
                <cfif isDefined('attributes.pdf') and attributes.pdf>
                    <li> <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_convertpdf&module=#my_tag_module#&ispdf=1<cfif isdefined("attributes.extra_parameters")>&extra_parameters=#attributes.extra_parameters#</cfif><cfif isdefined("attributes.height")>&page_height=#attributes.height#</cfif><cfif isdefined("attributes.width")>&page_width=#attributes.width#</cfif><cfif isdefined("attributes.tag_module")>&special_module=1</cfif><cfif attributes.is_ajax eq 1>&is_ajax=1</cfif><cfif isdefined("attributes.noShow")>&noShow=#attributes.noShow#</cfif><cfif isdefined("attributes.isAjaxPage") and attributes.isAjaxPage eq 1>&isAjaxPage=1</cfif>','medium','popup_convertpdf')" class="<cfif len(attributes.icon_text)>ui-wrk-btn-addon-left</cfif> <cfif len(attributes.search_buttons)>search-buttons</cfif>">
                        <i class="fa fa-file-pdf-o" title="PDF" id="list_pdf_button"></i><cfif len(attributes.icon_text)>PDF</cfif>
                    </a>  </li>
                </cfif>
                <cfif isDefined('attributes.mail') and attributes.mail>
                    <li> <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_mail&module=#my_tag_module#&trail=#attributes.trail#<cfif isdefined("attributes.extra_parameters")>&extra_parameters=#attributes.extra_parameters#</cfif><cfif isdefined("attributes.tag_module")>&special_module=1</cfif><cfif attributes.is_ajax eq 1>&is_ajax=1</cfif><cfif len(attributes.print_type)>&print_type=#attributes.print_type#</cfif><cfif len(attributes.action_id)>&action_id=#attributes.action_id#</cfif><cfif isdefined("attributes.noShow")>&noShow=#attributes.noShow#</cfif><cfif isdefined("attributes.isAjaxPage") and attributes.isAjaxPage eq 1>&isAjaxPage=1</cfif>','list','popup_mail')" class=" <cfif len(attributes.icon_text)>ui-wrk-btn-addon-left</cfif> <cfif len(attributes.search_buttons)>search-buttons</cfif>">
                        <i class="fa fa-envelope-o" title="#caller.getLang('main',1666)#" id="list_mail_button"></i><cfif len(attributes.icon_text)>Mail</cfif>
                    </a>  </li>
                </cfif>
                <cfif isDefined('attributes.print') and attributes.print>
                    <!---<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_send_print&module=#my_tag_module#&trail=#attributes.trail#&is_logo=#attributes.is_logo#&show_datetime=#attributes.show_datetime#<cfif isdefined("attributes.extra_parameters")>&extra_parameters=#attributes.extra_parameters#</cfif><cfif isdefined("attributes.tag_module")>&special_module=1</cfif><cfif isdefined("attributes.no_display")>&no_display=1</cfif>&iframe=1<cfif attributes.is_ajax eq 1>&is_ajax=1</cfif><cfif isdefined("attributes.noShow")>&noShow=#attributes.noShow#</cfif><cfif isdefined("attributes.isAjaxPage") and attributes.isAjaxPage eq 1>&isAjaxPage=1</cfif>','small','popup_send_print')">
                        <i class="icon-print" title="#caller.getLang('main',62)#" id="list_print_button"></i>
                    </a>---><li>
                    <a href="javascript://" onClick="printSa();" class=" <cfif len(attributes.icon_text)>ui-wrk-btn-addon-left</cfif> <cfif len(attributes.search_buttons)>search-buttons</cfif>">
                        <i class="fa fa-print" title="#caller.getLang('main',62)#" id="list_print_button"></i><cfif len(attributes.icon_text)>Print</cfif>
                    </a>
                </li>
                </cfif>
            <cfelse>
            <span>
                <cfif isDefined('attributes.flash_paper') and attributes.flash_paper>
                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_convertpdf&module=#my_tag_module#&trail=#attributes.trail#<cfif isdefined("attributes.extra_parameters")>&extra_parameters=#attributes.extra_parameters#</cfif><cfif isdefined("attributes.height")>&page_height=#attributes.height#</cfif><cfif isdefined("attributes.width")>&page_width=#attributes.width#</cfif><cfif isdefined("attributes.tag_module")>&special_module=1</cfif>&iframe=1&ispdf=0<cfif attributes.is_ajax eq 1>&is_ajax=1</cfif>','small','popup_convertpdf')" class="ui-wrk-btn ui-wrk-btn-success <cfif len(attributes.icon_text)>ui-wrk-btn-addon-left</cfif> <cfif len(attributes.search_buttons)>search-buttons</cfif>">
                        <i class="icon-file-video-o" title="Flash" id="list_flash_paper_button"></i><cfif len(attributes.icon_text)>Flash</cfif>
                    </a>
                </cfif>
                <cfif isDefined('attributes.doc') and attributes.doc>
                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_documenter&module=#my_tag_module#<cfif isdefined("attributes.extra_parameters")>&extra_parameters=#attributes.extra_parameters#</cfif><cfif isdefined("attributes.tag_module")>&special_module=1</cfif><cfif attributes.is_ajax eq 1>&is_ajax=1</cfif><cfif isdefined("attributes.noShow")>&noShow=#attributes.noShow#</cfif><cfif isdefined("attributes.isAjaxPage") and attributes.isAjaxPage eq 1>&isAjaxPage=1</cfif>','small','popup_documenter')" class="ui-wrk-btn ui-wrk-btn-warning <cfif len(attributes.icon_text)>ui-wrk-btn-addon-left</cfif> <cfif len(attributes.search_buttons)>search-buttons</cfif>">
                        <i class="fa fa-save" title="#caller.getLang('main',49)#" id="list_save_button"></i><cfif len(attributes.icon_text)>Kaydet</cfif>
                    </a>
                </cfif>	
                <cfif isDefined('attributes.pdf') and attributes.pdf>
                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_convertpdf&module=#my_tag_module#&ispdf=1<cfif isdefined("attributes.extra_parameters")>&extra_parameters=#attributes.extra_parameters#</cfif><cfif isdefined("attributes.height")>&page_height=#attributes.height#</cfif><cfif isdefined("attributes.width")>&page_width=#attributes.width#</cfif><cfif isdefined("attributes.tag_module")>&special_module=1</cfif><cfif attributes.is_ajax eq 1>&is_ajax=1</cfif><cfif isdefined("attributes.noShow")>&noShow=#attributes.noShow#</cfif><cfif isdefined("attributes.isAjaxPage") and attributes.isAjaxPage eq 1>&isAjaxPage=1</cfif>','medium','popup_convertpdf')" class="ui-wrk-btn ui-wrk-btn-red <cfif len(attributes.icon_text)>ui-wrk-btn-addon-left</cfif> <cfif len(attributes.search_buttons)>search-buttons</cfif>">
                        <i class="fa fa-file-pdf-o" title="PDF" id="list_pdf_button"></i><cfif len(attributes.icon_text)>PDF</cfif>
                    </a>
                </cfif>
                <cfif isDefined('attributes.mail') and attributes.mail>
                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_mail&module=#my_tag_module#&trail=#attributes.trail#<cfif isdefined("attributes.extra_parameters")>&extra_parameters=#attributes.extra_parameters#</cfif><cfif isdefined("attributes.tag_module")>&special_module=1</cfif><cfif attributes.is_ajax eq 1>&is_ajax=1</cfif><cfif len(attributes.print_type)>&print_type=#attributes.print_type#</cfif><cfif len(attributes.action_id)>&action_id=#attributes.action_id#</cfif><cfif isdefined("attributes.noShow")>&noShow=#attributes.noShow#</cfif><cfif isdefined("attributes.isAjaxPage") and attributes.isAjaxPage eq 1>&isAjaxPage=1</cfif>','list','popup_mail')" class="ui-wrk-btn ui-wrk-btn-extra <cfif len(attributes.icon_text)>ui-wrk-btn-addon-left</cfif> <cfif len(attributes.search_buttons)>search-buttons</cfif>">
                        <i class="fa fa-envelope-o" title="#caller.getLang('main',1666)#" id="list_mail_button"></i><cfif len(attributes.icon_text)>Mail</cfif>
                    </a>
                </cfif>
                <cfif isDefined('attributes.print') and attributes.print>
                    <!---<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_send_print&module=#my_tag_module#&trail=#attributes.trail#&is_logo=#attributes.is_logo#&show_datetime=#attributes.show_datetime#<cfif isdefined("attributes.extra_parameters")>&extra_parameters=#attributes.extra_parameters#</cfif><cfif isdefined("attributes.tag_module")>&special_module=1</cfif><cfif isdefined("attributes.no_display")>&no_display=1</cfif>&iframe=1<cfif attributes.is_ajax eq 1>&is_ajax=1</cfif><cfif isdefined("attributes.noShow")>&noShow=#attributes.noShow#</cfif><cfif isdefined("attributes.isAjaxPage") and attributes.isAjaxPage eq 1>&isAjaxPage=1</cfif>','small','popup_send_print')">
                        <i class="icon-print" title="#caller.getLang('main',62)#" id="list_print_button"></i>
                    </a>--->
                    <a href="javascript://" onClick="printSa();" class="ui-wrk-btn ui-wrk-btn-info <cfif len(attributes.icon_text)>ui-wrk-btn-addon-left</cfif> <cfif len(attributes.search_buttons)>search-buttons</cfif>">
                        <i class="fa fa-print" title="#caller.getLang('main',62)#" id="list_print_button"></i><cfif len(attributes.icon_text)>Print</cfif>
                    </a>
                </cfif>
            </span>
        </cfif>
        </cfoutput>    
    </cfif>
</cfif>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
