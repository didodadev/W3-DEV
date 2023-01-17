<cfsetting showdebugoutput="no">
<cfif not isdefined("session_base")>
	<cfif isdefined("session.ep")>
        <cfset session_base = session.ep>
    <cfelseif isdefined("session.pp")>
        <cfset session_base = session.pp>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = session.ww>
    <cfelseif isdefined("session.cp")>
        <cfset session_base = session.cp>
    </cfif>
</cfif>
<cfset fusebox.is_special = false>
<cfif StructKeyExists(application.objects,'#attributes.fuseaction#') and len(application.objects['#attributes.fuseaction#']['LEGACY']) >
    <cfset isHolistic = application.objects['#attributes.fuseaction#']['LEGACY'] eq 2>
<cfelse>
    <cfset isHolistic = 0>
</cfif>
<cfif not isdefined("attributes.isAjax")>
	<cfif not (CGI.QUERY_STRING contains 'ajax_box_page')> <!--- Ajax sayfalarda tekrar yüklenmesine gerek yok --->
        <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
        <html xmlns="http://www.w3.org/1999/xhtml" lang="<cfoutput>#session.ep.language#</cfoutput>">
        <head>
            <meta http-equiv="Pragma" content="no-cache">
            <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
            <meta name="content-language" content="tr" />
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
            <meta name="mobile-web-app-capable" content="yes">
            <link rel="manifest" href="manifest.json">
    		<link rel="icon" type="image/png" href="/images/shortcut/shortcut-orange.png"/>
            
            <cfparam name="attributes.fuseaction" default="myhome.welcome">
            <cfif isdefined("session.ep.userid") and session.ep.language is 'arb'>
                <html dir="RTL">
            </cfif>
            <cfif attributes.fuseaction is not 'home.login' and attributes.fuseaction is not 'home.popup_clear_session' and attributes.fuseaction is not 'home.popup_send_password' and attributes.fuseaction is not 'home.popup_password_arrangement'>  
                <cf_workcube_websocket><!--- WebSocket : Sadece ajax isteği olmadığında yüklenir. Query sayfalarında kullanmak için dosyada yeniden kurulmalı --->
                <script  type="text/javascript" src="/JS/js_functions.js"></script>
                <script  type="text/javascript" src="/JS/js_functions_hr.js"></script>
                <script  type="text/javascript" src="<cfoutput>#request.self#?fuseaction=home.emptypopup_special_functions&this_fuseact=myhome.welcome</cfoutput>"></script>
                <script  type="text/javascript" src="/JS/js_calender/js/jscal2.js"></script>
                <script  type="text/javascript" src="<cfoutput>#request.self#?fuseaction=home.emptypopup_calender_functions</cfoutput>"></script>
                <script type="text/javascript" src="/JS/assets/lib/jquery/jquery-min.js"></script>
                <script src="/JS/assets/lib/jquery-ui/jquery-ui.js"></script>
				<script src="/JS/assets/lib/jquery-mobile/jquery.mobile.custom.js"></script>
                <script type="text/javascript" src="/JS/js_functions_all.js"></script>
                <cfif not isdefined("session.ep.userid") or (not isdefined("moneyformat_style")) or (isdefined("moneyformat_style") and moneyformat_style eq 0)>
                    <script type="text/javascript" src="/JS/js_functions_money_tr.js"></script>
                <cfelse>
                    <script type="text/javascript" src="/JS/js_functions_money.js"></script>
                </cfif>
                <script async type="text/javascript" src="/JS/ajax.js"></script>
                <script async type="text/javascript" src="/JS/autocomplete.js"></script>
                <script async type="text/javascript" src="/JS/jquery.json-2.4.min.js"></script>
                <!--- layout js --->
                <script  src="/JS/assets/custom/app.js?v=300320-2059" type="text/javascript"></script>
                <script src="/JS/assets/custom/script.js" type="text/javascript"></script>
                <!--- lib --->
                <link rel="stylesheet" href="/JS/assets/lib/jquery-ui/jquery-ui.css">
                <!--- Plugins --->
                <script  src="/JS/temp/Chart.js"></script>
                <!-- Slick -->
                <link rel="stylesheet" href="/JS/assets/plugins/owl-carousel/slick.css" />
                <script type="text/javascript" src="/JS/assets/plugins/owl-carousel/slick.min.js"></script>
                <!--- form Builder --->
                <link rel="stylesheet" href="/JS/assets/plugins/formBuilder/css/vendor.css" />
                <link rel="stylesheet" href="/JS/assets/plugins/formBuilder/css/formbuilder.css" />
                <script type="text/javascript" src="/JS/assets/plugins/formBuilder/js/main.js"></script>
                <!--- Print Js --->
                <script async src="/JS/assets/plugins/printThis.js"></script>
                <!--- Validate --->
                <script async type="text/javascript" src="JS/assets/plugins/validate/js/main.js"></script>
                <!--- Preloader --->
                <link rel="stylesheet" type="text/css" href="/JS/assets/plugins/preloader/css/preloader.css">
                <!--- Masonry Js --->
                
                <!-- TableSorter -->
                <script type="text/javascript" src="/JS/temp/tablesorter/jquery.tablesorter2.js"></script>

                <!--- Table Excel --->
                <script src='JS/tableToExcel.js'></script>
                <!--- DragTable --->
                <link rel="stylesheet" href="/css/assets/template/dragtable/dragtable.css" type="text/css">
                <script type="text/javascript" src="/JS/dragtable/jquery.dragtable.js"></script>

                <script async type="text/javascript" src="JS/assets/plugins/masonry.pkgd.min.js"></script>
                <cfif listfirst(attributes.fuseaction,'.') is 'dev'>
                    <script type="text/javascript" src="/JS/assets/lib/knockout-3.4.2/knockout.js"></script>
                    <script type="text/javascript" src="/JS/assets/lib/knockout-3.4.2/knockout.validation.min.js"></script>
                    <script type="text/javascript" src="/JS/assets/lib/dragula/dragula.js"></script>
                    <script type="text/javascript" src="/JS/assets/lib/knockout-3.4.2/knockout-dragula.js"></script>
                    <script type="text/javascript" src="/JS/assets/lib/ace/src-min-noconflict/ace.js"></script>
                    <script type="text/javascript" src="/JS/assets/lib/jsoneditor/jsoneditor.min.js"></script>
                    <link rel="stylesheet" href="/JS/assets/lib/jsoneditor/jsoneditor.min.css">
                    <link rel="stylesheet" href="/JS/assets/lib/dragula/dragula.css">
                    <link rel="stylesheet" href="/JS/assets/lib/alertifyjs/css/alertify.min.css">
                    <script type="text/javascript" src="/JS/assets/lib/alertifyjs/alertify.min.js"></script>
                </cfif>
                <script type="text/javascript" src="/JS/assets/lib/nano/nano.js"></script>
                <script type="text/javascript" src="/JS/assets/lib/fparse/fparser.js"></script>
                <script type="text/javascript" src="/JS/assets/lib/select2/select2.min.js"></script>
                <script type="text/javascript" src="/JS/assets/lib/sweetalert/sweetalert.min.js"></script>
                <script  type="text/javascript" src="/JS/AjaxControl/dist/build.js"></script><!--- AjaxControl --->
            </cfif>
            <!--- layout css --->            
            <cfif  StructKeyExists(application.objects,'#attributes.fuseaction#') and application.objects['#attributes.fuseaction#']['LEGACY'] eq 1>
                <link rel="stylesheet" href="/css/assets/template/w3_legacy.css" type="text/css" id="page_css">
            <cfelse>
                <!--- <link rel="stylesheet" href="/css/assets/template/win_ie.css" type="text/css"> --->
                <link rel="stylesheet" href="/css/assets/template/style.css" type="text/css" id="page_css">
            </cfif>

            <cfset version = "" />
            <cfset workcube_version = application.systemParam.systemParam().workcube_version />
            <cfif len(workcube_version) and workcube_version neq 'catalyst v1.0' and workcube_version neq 'dev' and workcube_version neq 'qa' and workcube_version neq 'beta'>
                <!--- Sürüm ve patch bilgilerini alır --->
                <cfset getComponent = createObject('component','V16.objects.cfc.upgrade_notes')>
                <cfset get_release_version = getComponent.GET_RELEASE_VERSION()>
                <cfset version = (isdefined("get_release_version.PATCH_NO") and len( get_release_version.PATCH_NO )) 
                                    ? get_release_version.PATCH_NO 
                                    : (isdefined("get_release_version.RELEASE_NO") and len( get_release_version.RELEASE_NO )) ? get_release_version.RELEASE_NO : "" />
                <cfset version = len( version ) ? "?v=" & version : "" />
            </cfif>

            <link rel="stylesheet" type="text/css" href="/JS/js_calender/css/jscal2.css">
            <link rel="stylesheet" type="text/css" href="/JS/js_calender/css/border-radius.css">
            <link rel="stylesheet" href="/css/assets/template/catalyst/catalyst.css<cfoutput>#version#</cfoutput>" type="text/css">
            <cfif isDefined("session.ep.userid")><link rel="stylesheet" href="/css/assets/template/catalyst/catalyst.cfc?method=theme&v=<cfoutput>#version#_#session.ep.design_color#</cfoutput>" type="text/css"></cfif>
            
            <link rel="stylesheet" href="/css/assets/icons/simple-line/simple-line-icons.css" type="text/css">
            <link rel="stylesheet" href="/css/assets/icons/icon-Set/icon-Set.css" type="text/css">
            <link rel="stylesheet" href="/css/assets/icons/fontello/fontello.css" type="text/css">    
            
             <!--- Svg Css --->
             <link rel="stylesheet" href="/css/assets/template/svg/svg.css" type="text/css">
            
            <link rel="stylesheet" href="/css/assets/template/gui_custom.css" type="text/css"><!--- düzenleme tamamlanınca css klasörüne alınacak --->
            <link rel="stylesheet" href="/css/assets/template/catalyst/upgrade.css" type="text/css">
            <link rel="stylesheet" href="/css/assets/template/sweetalert/sweetalert.min.css">
            <cfif (StructKeyExists(application.objects,'#attributes.fuseaction#') and application.objects['#attributes.fuseaction#']['TYPE'] eq 8)  or ListToArray(attributes.fuseaction , '.')[1] EQ 'report'>
                <link href="/css/assets/template/report/report.css" rel="stylesheet"> <!-- raporlar sayfası için özelleştirilmiş css'ler-->
            </cfif>
            <link rel="stylesheet" href="/css/assets/template/intranet/intranet.css" type="text/css"> 
            <link rel="stylesheet" href="/css/assets/template/select2/select2.min.css" type="text/css">
            <cfif attributes.fuseaction eq 'process.list_warnings' or attributes.fuseaction eq 'objects.workflowpages' or attributes.fuseaction eq 'objects.chatflow' or attributes.fuseaction eq 'objects.popup_page_warnings' or attributes.fuseaction eq 'objects.popup_print_files' or attributes.fuseaction eq 'production.order_operator'>
                <link rel="stylesheet" href="/css/assets/template/w3-wrkflowpages/warning-page.css" type="text/css">
                <link rel="stylesheet" href="/css/assets/template/w3-wrkflowpages/wrkflowpages.css" type="text/css">
            </cfif>
            <script> if(location.href.indexOf("workflow") == false){setTimeout(function() { $("#keyword, input[name=keyword]").focus() }, 500);}</script>
            <cfif attributes.fuseaction eq 'myhome.welcome' and isDefined("session.ep.userid") and cgi.server_port eq 443>
                <!--- for apple - ios --->
                <meta name="apple-mobile-web-app-capable" content="yes">
                <meta name="apple-mobile-web-app-title" content="Workcube">
                <link rel="apple-touch-icon" href="/images/shortcut/mobil/workcube-logo.png" >
                <link rel="apple-touch-icon" sizes="72x72" href="/images/shortcut/mobil/icon-72x72.png">
                <link rel="apple-touch-icon" sizes="96x96" href="/images/shortcut/mobil/icon-96x96.png">
                <link rel="apple-touch-icon" sizes="144x144" href="/images/shortcut/mobil/icon-144x144.png">
                <meta name="msapplication-starturl" content="<cfoutput>#fusebox.server_machine_list#</cfoutput>" />
                <!--- for apple - ios --->
                <script  type="text/javascript" src="/JS/progressiveWebControl.js"></script>
                <div class="add-to-homescreen-panel">
                    <div class="add-to-homescreen">
                        <img src="/images/shortcut/mobil/icon-72x72.png">
                        <h5>Workcube'ü telefonunuzun ana ekranına ekleyin!</h5>
                        <div class="add-to-homescreen-button-blok">
                            <button class = "add-to-homescreen-button accept">Ana Ekrana Ekle</button>
                        </div>
                        <div class="add-to-cancel-button-blok">
                            <button class = "add-to-homescreen-button dismiss">İptal Et</button>
                        </div>
                    </div>
                </div>
            </cfif>
        </head>
        <cfif not isdefined("attributes.maxrows") and isdefined('session.ep.maxrows')>
            <cfset attributes.maxrows = session.ep.maxrows>
        </cfif>
    </cfif>

    <cfif isDefined("pageDeniedThrowError") and pageDeniedThrowError>
        <cfif isdefined("hata") and (hata eq 5 or hata eq 6)>
            <cfinclude template="/V16/dsp_hata.cfm" >
            <cfabort>
        <cfelse>
            <cfthrow message = "#hata_mesaj#">
        </cfif>
    </cfif>
    
    <!--- Grid --->
    <cfif listFirst(attributes.fuseaction,'.') is 'objects2'>
        <cf_get_lang_set>
        <cfinclude template="../V16/objects2/fbx_Switch.cfm">
        <cfset fusebox.is_special = 2>
    <cfelseif listFirst(attributes.fuseaction,'.') is 'home'>
        <cf_get_lang_set>
        <cfinclude template="../fbx_Switch.cfm">
        <cfset fusebox.is_special = 2>
    </cfif>

    <cfif not fusebox.is_special>
        <!--- Holistik moda geçiyoruz! HY20190208 --->
        <cfif isDefined("attributes.md") and len(attributes.md)>
            <cfif attributes.md eq "catalyst">
                <cfset pageControllerName = application.objects['#attributes.fuseaction#']['CONTROLLER_FILE_PATH']>
                <cfset pageFriendlyUrl = application.objects['#attributes.fuseaction#']['FRIENDLY_URL']>
                <cfset attributes.tabMenuController = 0>
                <cfinclude template="../#application.objects['#attributes.fuseaction#']['CONTROLLER_FILE_PATH']#">
                <cfif not isdefined("attributes.event")>
                    <cfset attributes.event = WOStruct['#attributes.fuseaction#']['default']>
                </cfif>
                <cfset windowProp = WOStruct['#attributes.fuseaction#']['#attributes.event#']['window']>
                <cfset controlledFile = 1>
            <cfelseif attributes.md eq "holistic">
                <cfset pageControllerName = ''>
                <cfset pageFriendlyUrl = ''>
                <cfset windowProp = 'normal'>
                <cfset controlledFile = 0>
                <cfset isHolistic = 1>
            </cfif>
            <cfset mainDictId = application.objects['#attributes.fuseaction#']['DICTIONARY_ID']>

        <cfelseif StructKeyExists(application.objects,'#attributes.fuseaction#') and len(application.objects['#attributes.fuseaction#']['CONTROLLER_FILE_PATH'])>
            <cfset pageControllerName = application.objects['#attributes.fuseaction#']['CONTROLLER_FILE_PATH']>
            <cfset pageFriendlyUrl = application.objects['#attributes.fuseaction#']['FRIENDLY_URL']>
            <cfset attributes.tabMenuController = 0>
            <cfinclude template="../#application.objects['#attributes.fuseaction#']['CONTROLLER_FILE_PATH']#">
            <cfif not isdefined("attributes.event")>
                <cfset attributes.event = WOStruct['#attributes.fuseaction#']['default']>
            </cfif>
            <cfif StructKeyExists(WOStruct['#attributes.fuseaction#']['#attributes.event#'],'window')>
	            <cfset windowProp = WOStruct['#attributes.fuseaction#']['#attributes.event#']['window']>
            <cfelse>
            	<cfset windowProp = 'normal'>
            </cfif>
            <cfset controlledFile = 1> <!--- Bazı sayfalarda event kontrolleri mevcut. Fakat controller'ı olmayan bir event event değildir EY20160111 --->
            <cfset mainDictId = application.objects['#attributes.fuseaction#']['DICTIONARY_ID']>
        <cfelse>
            <cfset pageControllerName = ''>
            <cfset pageFriendlyUrl = ''>
            <cfset windowProp = 'normal'>
            <cfset controlledFile = 0>
            <cfset mainDictId = ''>
        </cfif>
        <body onkeydown="TusOku(event);">
          <div id="ui-overlay"></div>
         
          <div class="ui-cfmodal" style="z-index:100000003;" id="warning_modal"></div>
          <div style="display:none" class="ui-cfmodal ui-cfmodal__alert">
              <cf_box>
                <div class="ui-cfmodal-close">×</div>
                <ul class="required_list"></ul>
              </cf_box>
          </div>
	      <cfif not isdefined("attributes.autoComplete")>
                <div id="check_mail_div" class="pod_box" style="position:absolute; padding-left:3px; bottom:24px; width:400px; height:200px; right:0px; display:none;"></div>
            </cfif>
            <cfif not isdefined("attributes.autoComplete")><div class="container" id="wrk_main_layout"></cfif>
                <cfif not(attributes.fuseaction contains 'emptypopup' or (isdefined("attributes.isAjaxPage") and attributes.isAjaxPage eq 1) or isdefined("attributes.ajax_box_page") or (isdefined("attributes.popup_page") and attributes.popup_page eq 1))>
                    <cfinclude template="../loadingMessage.cfm">
                    <cfif not findnocase('popup',fusebox.fuseaction) and not windowProp is 'popup'>
                        <div class="header">
                            <script>
                                window.warningCounter = { chatCounter : 0, warningCounter : 0 };
                                function setWarningCounts( totalcount, warningCount, pageTitle ) {
                                    if( pageTitle.toLowerCase().includes('workflow') || pageTitle.toLowerCase().includes('chatflow') ){
                                        var warningCountString = "";
                                        $("#chat").find("i:first-child + span").remove();
                                        if( totalcount > 0 ){
                                            $("#chat").find("i:first-child").after('<span class="badge badgeCount">'+totalcount+'</span>');
                                            warningCountString = totalcount;
                                        }
                                        $("#workflow").find("i:first-child + span").remove();
                                        if( warningCount > 0 ){
                                            $("#workflow").find("i:first-child").after('<span class="badge badgeCount">'+warningCount+'</span>');
                                            warningCountString += (( totalcount > 0 ) ? '-' : '') +  warningCount;
                                        }
                                        $(document).prop("title", warningCountString + ' ' + pageTitle);
                                        window.warningCounter.chatCounter = totalcount;
                                        window.warningCounter.warningCounter = warningCount;
                                    }
                                }
                            </script>
                            <cfinclude template="../design/header.cfm">
                            <script>
                                <cfif totalMessageCount gt 0 or warningCount gt 0><!--- header.cfm den gelir || warningCount : Bildirim Sayısı, totalMessageCount : Mesaj Sayısı  --->
                                    setTimeout(function() {
                                        <cfoutput>setWarningCounts( #totalMessageCount#, #warningCount#, '' );</cfoutput>
                                    }, 1000);
                                </cfif>
                            </script>
                        </div>
                        <!---- Süreçte bildirim şifrelenmiş olarak gönderilmişse şifre istenir! ---->
                        <cfif ( IsDefined("attributes.wrkflow") and attributes.wrkflow eq 1 and StructKeyExists( application.deniedPages, attributes.fuseaction ) and StructKeyExists(application.deniedPages[attributes.fuseaction], "WARNING_PASSWORD") and len( application.deniedPages[attributes.fuseaction]["WARNING_PASSWORD"] ) )>
                            <cfif not isDefined("attributes.confirm_warning_password") or (isDefined("attributes.confirm_warning_password") and application.deniedPages[attributes.fuseaction]["WARNING_PASSWORD"] neq attributes.confirm_warning_password)>
                                <div class="col col-12 col-md-12">
                                    <div class = "col col-4 col-md-6 col-xs-12 col-offset-4 col-md-offset-3 col-xs-offset-0 mt-5">
                                        <cf_box title="#getLang('','',49039)#" collapsable="0" resize="0">
                                            <div class="ui-card">
                                                <div class="ui-card-item">
                                                    <cfif (isDefined("attributes.confirm_warning_password") and application.deniedPages[attributes.fuseaction]["WARNING_PASSWORD"] neq attributes.confirm_warning_password)>
                                                        <cf_get_lang dictionary_id = '61100.Hatalı şifre girişi yaptınız'>!
                                                    <cfelse>
                                                        <cf_get_lang dictionary_id = '61099.Bildirimi incelemek için şifrenizi giriniz'>!
                                                    </cfif>
                                                </div>
                                            </div>
                                            <cfform action="#cgi.http_url#" method="post">
                                                <div class="ui-form-list ui-form-block">
                                                    <div class="form-group mt-2">
                                                        <label class="col col-4 pdn-l-0"><cf_get_lang dictionary_id = '57552.Şifre'></label>
                                                        <div class="col col-8 pdn-r-0">
                                                            <input type="password" name="confirm_warning_password" id="confirm_warning_password" required>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="ui-form-list-btn">
                                                    <div>
                                                        <input type="submit" class="ui-btn ui-btn-success" value="<cf_get_lang dictionary_id = '58743.Gönder'>">
                                                    </div>
                                                </div>
                                            </cfform>
                                        </cf_box>
                                        <cfabort>
                                    </div>
                                </div>
                            </cfif>
                        </cfif>
                    </cfif>
                </cfif>
                <cfif not (findnocase('popup',fusebox.fuseaction) or attributes.fuseaction contains 'workflowpages' or attributes.fuseaction contains 'chatflow' or isdefined("attributes.ajax_box_page") or (isdefined("attributes.popup_page") and attributes.popup_page eq 1)) and not windowProp is 'popup'>
                    <cfinclude template="../design/sidebarLeft.cfm"> 	<!--- Sol Panel ---->
                    <div class="rightBar" id="rightBarDiv">
                        <div id="tab-container">
                            <div id="tab-head">
                                <ul class="tabNav">
                                    <li class="active"><a href="#tabSetting">SETTINGS</a></li>
                                    <cfif listFindNoCase(session.ep.USER_LEVEL,30)><li><a href="#tabBpm">BPM</a></li></cfif>
                                    <li><a href="#tabSystem">System</a></li>
                                </ul>
                            </div>
                            <div style="clear:both;"></div>
                            <div id="tab-content" class="scrollContent"></div>
						</div>
                    </div>
                </cfif>
                	<cfif not isdefined("attributes.ajax_box_page")>
						<cfif not isdefined("attributes.autoComplete")>
                            <section class="favoriteBar hide"><i class="fa fa-star bold pull-left title"></i><ul class="link-list"></ul></section>
                            <section class="page-bar" id="pageBar"></section>
                            <cfif isHolistic>
                                <cfinclude template="./holistic_menu_template.cfm">
                            </cfif>
                        </cfif>
                    </cfif>
                    <cfif isdefined("session.ep.userid")> 
                        <cfif isdefined("session.ep.worktips_open") and session.ep.worktips_open eq 1>
                            <cfform name="sessionObj" id="sessionObj">
                                <cfoutput>
                                    <input type="hidden" id="update_date" name="update_date" value="#now()#">
                                    <input type="hidden" id="update_ip" name="update_ip" value="#cgi.remote_addr#">
                                    <input type="hidden" id="update_emp" name="update_emp" value="#session.ep.userid#">
                                </cfoutput>
                            </cfform>
                        </cfif>                    
                        
                    </cfif>
                    <cfif not (isdefined("attributes.ajax_box_page") or findnocase('popup',fusebox.fuseaction) or (isdefined("attributes.popup_page") and attributes.popup_page eq 1)) and not windowProp is 'popup'>
                        <section id="wrk_main_layout_td" class="body">
                    <cfelseif not isdefined("attributes.autoComplete")>
                        <section>
                    </cfif>                        
                        <cfif not isdefined("attributes.autoComplete")><section class="pageBody hide <cfif windowProp is 'popup' or (isdefined("attributes.popup_page") and attributes.popup_page eq 1)> popup_wrapper <cfelseif not (findnocase('popup',fusebox.fuseaction) or (isdefined("attributes.spa") and attributes.spa eq 1) or isdefined("attributes.ajax_box_page"))></cfif>"></cfif>
                        <div class="formSetOpen"><i class="icon-cog" onClick="myPopup('formPanel');"></i></div>
                        <cfif attributes.fuseaction neq 'objects.popup_print_editor' and not listfindnocase(free_actions, attributes.fuseaction, ',') and ((listfindnocase(employee_url,'#cgi.http_host#',';') and not findnocase('popup_clear_session',fusebox.fuseaction) and findnocase('popup',fusebox.fuseaction) and not findnocase('inner',fusebox.fuseaction)) or windowProp is 'popup')>
                            <cfif not isdefined("attributes.autoComplete") and not isdefined("attributes.ajax_box_page")>
                                <form name="add_to_favorites" target="_blank" method="post" action="<cfoutput>#request.self#?fuseaction=myhome.popup_favorites</cfoutput>">
                                <input type="hidden" name="act" value="<cfoutput>#replace(CGI.QUERY_STRING,'fuseaction=','')#</cfoutput>"/>
                                </form>
                                <div id="wrk_bug_add_div">
                                    <cfif (not fusebox.fuseaction contains 'popup_content') and  (not fusebox.fuseaction contains 'popup_operate_action') and (not fusebox.fuseaction contains 'popup_send_print_action') and (not fusebox.fuseaction contains 'popup_basket') and (not fusebox.fuseaction contains 'popupflush_print_collected_barcodes') and (not fusebox.fuseaction contains 'popup_barcode') and (not fusebox.fuseaction contains 'popup_pd_edit') and (not isdefined("attributes.iframe")) and not (isdefined("attributes.print") and attributes.print) and not (attributes.fuseaction eq 'dev.workdev')>
                                        <style>
                                            div#xmlSettings span {
                                                position: absolute;
                                                top: 4px;
                                                left: 7px;     
                                                text-decoration: none;
                                                color: #2ab4c0;
                                                font-size: 15px;
                                                display: inline-block;
                                                cursor: pointer;
                                            }
                                            div#xmlSettings ul {
                                                display: inline;
                                                margin: 0;
                                                padding: 0;
                                            }
                                            div#xmlSettings ul li {display: inline-block;}
                                            div#xmlSettings ul li:hover ul {display: block;}
                                            div#xmlSettings ul li:hover ul {background-color: #e3e7ea;}
                                            div#xmlSettings ul li ul {
                                                background-color: #e3e7ea;
                                                padding:3px 2px 2px 0px;
                                                position: absolute;
                                                left: 22px;
                                                width: auto;
                                                display: none;
                                            }
                                            div#xmlSettings ul li ul li {
                                                float:left;
                                                margin-left:5px;
                                                font-size: 15px;
                                            }
                                            div#xmlSettings ul li ul li a {display:block !important;} 
                                        </style> 
                                    <div id="xmlSettings" style="position:absolute; width:140px; z-index:999;">
                                        <ul>
                                            <li>
                                                <span><i class="catalyst-settings" title="<cfoutput>#getLang('main',23)#</cfoutput>"></i></span>
                                                <ul>
                                                    <cfoutput>
                                                        <cfif  attributes.fuseaction is not 'report.popupflush_view_offtime_print' or attributes.fuseaction is not 'report.popup_report_ba_bs_print'><!--- E&Y icin eklendi. Kaldirmayiniz (work_id : 89884) 19062015 MAS --->
                                                            <cfsavecontent variable="wiki"><cf_get_lang dictionary_id='55064.Sorun Bildir'></cfsavecontent>
                                                            <cfif workcube_mode eq 0>
                                                                <li><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=help.popup_add_problem&help=#attributes.fuseaction#','project');"><i class="fa fa-question-circle" style="color:##00BCD4;" border="0" title="#wiki#" class="hideable"></i></a></li>
                                                            </cfif>
                                                            <li><a href="javascript://" onClick="window.open('#request.self#?fuseaction=objects.workflowpages&tab=3&action=#attributes.fuseaction#','Workflow')"><i class="fa fa-bell" style="color:##E91E63;" border="0" title="<cf_get_lang dictionary_id="57757">" class="hideable"></i></a></li>
                                                          
                                                            <cfif session.ep.admin and listFindNoCase(session.ep.USER_LEVEL,7)>
                                                                <cfif isdefined("attributes.event") and len(attributes.event) and isdefined("WOStruct")>
                                                                    <li><a href="javascript://" id="wrk_xml_pop_" onClick="cfmodal('#request.self#?fuseaction=objects.popup_xml_setup&event=#attributes.event#&fuseact=#WOStruct['#attributes.fuseaction#']['#attributes.event#']['fuseaction']#&main_fuseact=#attributes.fuseaction#','warning_modal');"><i class="fa fa-code" style="color:##2bc731;font-weight:bold;" border="0" title="#getLang('main',1969)#"></i></a></li>
                                                                <cfelse>
                                                                    <li><a href="javascript://" id="wrk_xml_pop_" onClick="cfmodal('#request.self#?fuseaction=objects.popup_xml_setup&event=list&fuseact=#attributes.fuseaction#&main_fuseact=#attributes.fuseaction#','warning_modal');"><i class="fa fa-code" style="color:##2bc731;font-weight:bold;" border="0" title="#getLang('main',1969)#" class="hideable"></i></a></li>
                                                                </cfif>
                                                                <cfif session.ep.admin and fusebox.is_special eq 1><img src="/images/add_options_mini.gif" title="Bu Sayfa Add Options'tan Çalışmaktadır." /></cfif>
                                                                <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1>
                                                                    <li><a href="javascript://" class="tableyazi" onclick="windowopen('index.cfm?fuseaction=settings.popup_page_lang_list','wide')"><i class="catalyst-book-open" style="color:##FF9800;font-weight:bold;" title="#getLang('main',520)#"></i></a></li>
                                                                </cfif>
                                                                <li><a href="javascript://"  onclick="myPopup('formPanel');"><i class="fa fa-pencil-square" title="<cf_get_lang dictionary_id='47755.Page Designer'>" style="color:##f58711"></i></a></li>
                                                                <cfquery name="get_woid" datasource="#dsn#">
                                                                    SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = <cfqueryparam value="#attributes.fuseaction#" cfsqltype="cf_sql_nvarchar">
                                                                </cfquery>
                                                                <li><a href="index.cfm?fuseaction=dev.wo&event=upd&fuseact=<cfoutput>#attributes.fuseaction#&woid=#get_woid.WRK_OBJECTS_ID#</cfoutput>" target="_blank"><i class="fa fa-globe" style="color:##3ba0e3" title="<cf_get_lang dictionary_id="52706.Workdev">"></i></a>
                                                                </li>
                                                            </cfif>
                                                            <cfset workcube_license = createObject("V16.settings.cfc.workcube_license").get_license_information() />
                                                            <li><a href="javascript://" id="wrk_workl_pop_" onClick="window.open('#workcube_license.implementation_project_domain#/index.cfm?fuseaction=project.works&work_detail_id=0&event=add&id=#workcube_license.implementation_project_id#&work_fuse=#attributes.fuseaction#','İş Ekle');"><i class="fa fa-gears" style="color:##8000ff;" border="0" title="#getLang('','',57933)#" class="hideable"></i></a></li>
                                                        </cfif>
                                                    </cfoutput>
                                                </ul>
                                            </li>
                                        </ul>
                                    </div>
                                    <cfinclude template="../loadingMessage.cfm">
                                    <script type="text/javascript">
                                        document.getElementById("working_div_main").style.display = "block";
                                        document.getElementsByTagName("body")[0].onload = function() {
                                            document.getElementById("working_div_main").style.display = "none";
                                        }
                                    </script>
                                    </cfif>
                                </div>
                            </cfif>
                        </cfif>
                        <cfif not fusebox.is_special>
                            <cfif StructKeyExists(application.objects,'#attributes.fuseaction#')>
                                <cfset pageTemplate = application.objects['#attributes.fuseaction#']['filePath']>
                                <cfset pageDictionaryId = application.objects['#attributes.fuseaction#']['DICTIONARY_ID']>
                            </cfif>
                            <div id="alertObjectContent"></div>
                            <!--- add-on oldugu durumda dil seti yapmaz diller dictinoryID üzerinden ilerler --->
                          <!---  and application.objects['#attributes.fuseaction#']['IS_ONLY_SHOW_PAGE'] eq 1--->
                            <cfif StructKeyExists(application.objects,'#attributes.fuseaction#')  and isdefined("attributes.event") and listFind('upd,det',attributes.event) >
                                <cf_page_control page_list='#attributes.fuseaction#'>
                            </cfif>

                            <cfif listFind('1,3',application.objects['#attributes.fuseaction#']['LICENCE'])>
                                <cf_get_lang_set>
                            </cfif>
                            <cfif len(pageControllerName)>
                                <cfinclude template="compositor.cfm">
                            <cfelseif isHolistic eq 1>
                                <cfinclude template="holistic_compositor.cfm">
                                <cfinclude template="./holistic_menu.cfm">
                            <cfelse>
								<script>
									<cfif LEN(pageDictionaryId) and pageDictionaryId neq 0>
										pageTitle("<cfoutput>#getLang(pageDictionaryId)#</cfoutput>");
									</cfif>
                                    $( "section[class*='pageBody']" ).removeClass('hide');
                                </script>
                                <cfif  StructKeyExists(application.objects,'#attributes.fuseaction#') and listFindNoCase('WDO,WBO,WMO,AddOns',listFirst(application.objects['#attributes.fuseaction#']['filePath'],'/'))>
                                    <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1>
                                        <cfset ArrayClear(request.pagelangList)>
                                    </cfif>
                                	<cfinclude template="../#pageTemplate#">
                                <cfelse>
                                    <cfif listFind('1,3',application.objects['#attributes.fuseaction#']['LICENCE'])><!--- ADD-ON oldugu durumda add_options switche girmez --->
                                        <cfinclude template="../V16/add_options/fbx_Switch.cfm">
                                    </cfif>
                                    <cfif fusebox.is_special eq 0>
                                        <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1>
                                            <cfset ArrayClear(request.pagelangList)>
                                        </cfif>
                                        <cfset extensions = createObject('component','WDO.development.cfc.extensions')>
                                        <cfset before_extensions = extensions.get_related_components(attributes.fuseaction, 1, 1, isDefined("attributes.event") ? attributes.event : "list")>
                                        <cfloop query="before_extensions">
                                            <cfinclude template="..#before_extensions.COMPONENT_FILE_PATH#">
                                        </cfloop>
                                        <cfinclude template="../V16/#pageTemplate#">
                                        <cfset after_extensions = extensions.get_related_components(attributes.fuseaction, 1, 2, isDefined("attributes.event") ? attributes.event : "list")>
                                        <cfloop query="after_extensions">
                                            <cfinclude template="..#after_extensions.COMPONENT_FILE_PATH#">
                                        </cfloop>
                                    </cfif>
                                </cfif>
                            </cfif>

                        <cfelseif fusebox.is_special eq 1>
                            <cfif isdefined("session.ep.admin") and session.ep.admin eq 1>
                                <script>
                                    $("#addOptionsWarning").css('display','block');
                                </script>
                            </cfif>
                        </cfif>
                        
                        <cfif not fusebox.is_special>
                            <cfif not isdefined("attributes.autoComplete")>
                                </section>
                            </section>
                            </cfif>
                        </cfif>
                        
				<!---<cfif not (findnocase('popup',fusebox.fuseaction) or isdefined("attributes.ajax_box_page") or (isdefined("attributes.popup_page") and attributes.popup_page eq 1)) and not windowProp is 'popup'>--->
                    <cfif not isdefined("attributes.ajax_box_page")>
                         <cfif isdefined("session.ep.lang_change_action") and session.ep.lang_change_action eq 1>
                            <form name="pagelanglist" method="post">
                                <input type="text" hidden name="langlist" id="langlist" value='<cfoutput>#replace(SerializeJSON(request.pagelangList),'//','')#</cfoutput>'/>
                            </form>
                        </cfif>
                        <cfinclude template="../design/systemModals.cfm"> <!--- Sistem Modalları ---->
                    </cfif>
                <!---</cfif>--->
                <cfif not (attributes.fuseaction contains 'emptypopup' or isdefined("attributes.ajax_box_page") or (isdefined("attributes.popup_page") and attributes.popup_page eq 1))>
                    <cfif not findnocase('popup',fusebox.fuseaction) and not windowProp is 'popup'>
                        <cfinclude template="../design/footer.cfm">
                    </cfif>
                </cfif>
            <cfif not fusebox.is_special>
                <cfif not isdefined("attributes.autoComplete")></div></cfif>
            </body>
            </cfif>
    </cfif>
	<!---  Popup sayfalarda hata veriyordu. header.cfm'den geçici bir süreliğine taşındı. Safe_query'lerde hata verdiği için buraya taşındı. --->
    <script type="text/javascript">
    <cfif isdefined("session.ep.worktips_open") and session.ep.worktips_open eq 1 and not(attributes.fuseaction contains 'help.worktips')>$('.help_tour_wrapper_pin').css("display","flex");<cfelse>$('.help_tour_pin_add').hide();$('.help_tour_wrapper_pin_item').hide();</cfif>
    var language = {
        
            diger			: "<cf_get_lang_main no="744.diğer">",
            gundem			: "<cf_get_lang_main no="1.gündem">",
            kolon			: "<cfoutput>#getLang('report',30)#</cfoutput>",           
            aktif			: "<cf_get_lang_main no="1103.Aktif/Pasif">",
            sadeceOkunur	: "<cfoutput>#getLang('settings',1750)#</cfoutput>",            
            zorunlu			: "<cfoutput>#getLang('settings',3073)#</cfoutput>",           
            kaydedildi		: "<cf_get_lang_main no="1478.Kaydedildi">",
            workcube_hata	: "<cf_get_lang_main no="779.WorkCube Hata">",
            kaydediliyor    : "<cf_get_lang_main no="1477.Kaydediliyor">",
            BuKolonDuzenlenemez : "<cfoutput>#getLang('settings',1751)#</cfoutput>",            
            tabMenu				: "<cfoutput>#getLang('settings',1752)#</cfoutput>",            
            belge_numarası      : "<cfoutput>#getLang('sales',156)#</cfoutput>",
            edit_basket_designer      : "<cfoutput>#getLang('','Bu alanı basket designer üzerinden düzenleyiniz.',64610)#</cfoutput>"
        }
    </script>
<cfelse>
    <cfif isDefined("pageDeniedThrowError") and pageDeniedThrowError>
        <cfthrow message = "#hata_mesaj#">
    </cfif>
    <!--- Holistik moda geçiyoruz! HY20190208 --->
    <cfif isDefined("attributes.md") and len(attributes.md)>
        <cfif attributes.md eq "catalyst">
            <cfset pageControllerName = application.objects['#attributes.fuseaction#']['CONTROLLER_FILE_PATH']>
            <cfset pageFriendlyUrl = application.objects['#attributes.fuseaction#']['FRIENDLY_URL']>
            <cfset attributes.tabMenuController = 0>
            <cfinclude template="../#application.objects['#attributes.fuseaction#']['CONTROLLER_FILE_PATH']#">
            <cfif not isdefined("attributes.event")>
                <cfset attributes.event = WOStruct['#attributes.fuseaction#']['default']>
            </cfif>
            <cfset windowProp = WOStruct['#attributes.fuseaction#']['#attributes.event#']['window']>
            <cfset controlledFile = 1>
        <cfelseif attributes.md eq "holistic">
            <cfset pageControllerName = ''>
            <cfset pageFriendlyUrl = ''>
            <cfset windowProp = 'normal'>
            <cfset controlledFile = 0>
            <cfset isHolistic = 1>
        </cfif>
	<cfelseif StructKeyExists(application.objects,'#attributes.fuseaction#') and len(application.objects['#attributes.fuseaction#']['CONTROLLER_FILE_PATH'])>
        <cfset pageControllerName = application.objects['#attributes.fuseaction#']['CONTROLLER_FILE_PATH']>
        <cfset pageFriendlyUrl = application.objects['#attributes.fuseaction#']['FRIENDLY_URL']>
        <cfset attributes.tabMenuController = 0>
        <cfinclude template="../#application.objects['#attributes.fuseaction#']['CONTROLLER_FILE_PATH']#">
        <cfif not isdefined("attributes.event")>
            <cfset attributes.event = WOStruct['#attributes.fuseaction#']['default']>
        </cfif>
        <cfset windowProp = WOStruct['#attributes.fuseaction#']['#attributes.event#']['window']>
        <cfset controlledFile = 1> <!--- Bazı sayfalarda event kontrolleri mevcut. Fakat controller'ı olmayan bir event event değildir EY20160111 --->
    <cfelse>
        <cfset pageControllerName = ''>
		<cfset pageFriendlyUrl = ''>
        <cfset windowProp = 'normal'>
        <cfset controlledFile = 0>
    </cfif>
    
    <cfif listFirst(attributes.fuseaction,'.') is 'objects2'>
        <cf_get_lang_set>
        <cfinclude template="../V16/objects2/fbx_Switch.cfm">
        <cfset fusebox.is_special = 2>
    <cfelseif listFirst(attributes.fuseaction,'.') is 'home'>
        <cf_get_lang_set>
        <cfinclude template="../V16/fbx_Switch.cfm">
        <cfset fusebox.is_special = 2>
    </cfif>
    <cfif not fusebox.is_special>
        <cfif isHolistic eq 1>
        <cf_get_lang_set module_name="main">
        <cfelse>
            <cfif listFind('1,3',application.objects['#attributes.fuseaction#']['LICENCE'])>
                <cf_get_lang_set>
            </cfif>
        </cfif>

        <cfif len(pageControllerName)>
        	<cfset pageDictionaryId = application.objects['#attributes.fuseaction#']['DICTIONARY_ID']>
            <cfinclude template="compositor.cfm">
        <cfelseif isHolistic eq 1>
            <cfinclude template="holistic_compositor_ajax.cfm">
        <cfelse>
            
        	<cfif not listFindNoCase('WDO,WBO,WMO,AddOns',listFirst(application.objects['#attributes.fuseaction#']['filePath'],'/'))>
            	<cfinclude template="../V16/#application.objects['#attributes.fuseaction#']['filePath']#">
            <cfelse>
				<cfinclude template="../#application.objects['#attributes.fuseaction#']['filePath']#">
            </cfif>
            
        </cfif>
    </cfif>
</cfif>