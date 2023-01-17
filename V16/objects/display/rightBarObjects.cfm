<div id="tabSetting" class="content" style="display: block;">
    <ul class="rightmenu-content scrollContent acordionUl">
        <li class="menuItem menuAcordion">
            <a href="javascript://"><i class="catalyst-globe"></i><span class="title" onclick="rightMenuContent('dictionary','systemLanguage')"><cf_get_lang dictionary_id="58996.Dil"></span><span class="arrow"></span></a>
            <div class="acordionContent" id="systemLanguage"></div>
        </li>
        <li class="menuItem menuAcordion">
            <a href="javascript://"><i class="catalyst-calendar" ></i><span class="title" onclick="rightMenuContent('period','systemperiod')"><cf_get_lang dictionary_id="59012.Çalışma Dönemi"></span><span class="arrow"></span></a>
            <div class="acordionContent" id="systemperiod"></div>
        </li> 
        <li class="menuItem menuAcordion">
            <a href="javascript://"><i class="catalyst-pencil"></i><span class="title" onclick="rightMenuContent('userGroup','systemUserGroup')"><cf_get_lang dictionary_id='63213.Yetki ve Arayüz'></span></a>
            <div class="acordionContent" id="systemUserGroup"></div>
         </li>
        <li class="menuItem menuAcordion">
            <a href="javascript://"> <i class="catalyst-key"></i><span class="title" onclick="rightMenuContent('password','systemPassword')"><cf_get_lang dictionary_id="57552.Şifre"></span></a>
            <div class="acordionContent" id="systemPassword"></div>
         </li> 
        <li class="menuItem">
            <a href="javascript://" onclick="cfmodal('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_personal_agenda','warning_modal');"><i class="catalyst-screen-desktop"></i><span class="title"><cf_get_lang dictionary_id='57413.Gündem'></span></a>
        <!---Gündem Modal Begin--->
            <!--- <cfinclude template="../../myhome/display/list_personal_agenda.cfm">     --->         
        <!---Gündem Modal End--->            	
        </li>
        <!---
        <li class="menuItem menuAcordion">
            <a href="#"> <i class="catalyst-grid"></i><span class="title" onclick="rightMenuContent('thema','systemThema')"><cfoutput>#getLang('objects2',1313)#</cfoutput></span></a>
            <div class="acordionContent" id="systemThema">
            </div>
        </li>
        --->
        <li class="menuItem menuAcordion">
            <a href="javascript://"> <i class="catalyst-docs"></i><span class="title" onclick="rightMenuContent('documentSettings','systemDocumentSettings')"><cf_get_lang dictionary_id='31068.Belge No Ayarları'></span></a>
            <div class="acordionContent" id="systemDocumentSettings"></div>
        </li>
        <li class="menuItem menuAcordion">
            <a href="javascript://"> <i class="catalyst-star"></i><span class="title" onclick="rightMenuContent('favourites','systemFavourites','<cfoutput>#attributes.act#</cfoutput>')"><cf_get_lang dictionary_id='57424.Sık Kullanılanlar'></span></a>
            <div class="acordionContent" id="systemFavourites"></div>
        </li>
        <li class="menuItem menuAcordion">
            <a href="javascript://"> <i class="catalyst-bar-chart"></i><span class="title" onclick="rightMenuContent('reports','systemReports')"><cf_get_lang dictionary_id='57626.Raporlar'></span></a>
            <div class="acordionContent" id="systemReports"></div>
        </li>
        <li class="menuItem menuAcordion">
            <a href="javascript://"> <i class="catalyst-calendar"></i><span class="title" onclick="rightMenuContent('calendar','systemCalendar')"><cf_get_lang dictionary_id='57415.Ajanda'></span></a>
            <div class="acordionContent" id="systemCalendar"></div>
        </li> 
        <cfif isdefined('onesignal_appID') and len(onesignal_appID)>
            <li class="menuItem menuAcordion">
                <a href="javascript://"><i class="catalyst-bell"></i><span class="title" onclick="rightMenuContent('notification','systemNotification')"><cf_get_lang dictionary_id="30883.bildirimler"></span></a>
                <div class="acordionContent" id="systemNotification"></div>
          </li>    
        </cfif>    
        <li class="menuItem menuAcordion">
            <a href="javascript://"> <i class="catalyst-info"></i><span class="title" onclick="rightMenuContent('other','systemOther')"><cf_get_lang dictionary_id="58156.Diğer"></span></a>
            <div class="acordionContent" id="systemOther"></div>
        </li>
    </ul>
</div>
<div id="tabBpm" class="content" style="display: none;">
    <ul class="rightmenu-content scrollContent"> 
    <!--- controlledFile ifadesi wrkTemplate.cfm dosyasında tanımlanıyor. EY20160111 --->        
        <li class="menuItem"><cfoutput><a href="#request.self#?fuseaction=process.general_processes"><i class="catalyst-directions" ></i><span class="title"><cf_get_lang dictionary_id='36293.Ana Süreçler'></span><span class="arrow"></span></a></cfoutput></li>
        <li class="menuItem"><cfoutput><a href="#request.self#?fuseaction=process.list_process"><i class="catalyst-direction" ></i><span class="title"><cf_get_lang dictionary_id='43249.Süreçler'></span><span class="arrow"></span></a></cfoutput></li> 
        <li class="menuItem"><cfoutput><a href="#request.self#?fuseaction=process.list_process_groups"><i class="catalyst-shuffle" ></i><span class="title"><cf_get_lang dictionary_id='43250.Süreç Grupları'></span><span class="arrow"></span></a></cfoutput></li> 
        <li class="menuItem"><cfoutput><a href="#request.self#?fuseaction=settings.list_process_cats"><i class="catalyst-map" ></i><span class="title"><cf_get_lang dictionary_id='42160.İşlem Kategorileri'></span><span class="arrow"></span></a></cfoutput></li>
        <li class="menuItem"><cfoutput><a href="#request.self#?fuseaction=settings.form_add_main_process_cat"><i class="catalyst-wallet" ></i><span class="title"><cf_get_lang dictionary_id='43247.Ana İşlem Kategorileri'></span><span class="arrow"></span></a></cfoutput></li>
        <li class="menuItem"><cfoutput><a href="#request.self#?fuseaction=process.list_template"><i class="catalyst-doc" ></i><span class="title"><cf_get_lang dictionary_id='49330.Şablonlar'></span><span class="arrow"></span></a></cfoutput></li> 
        <li class="menuItem"><cfoutput><a href="#request.self#?fuseaction=settings.imp_dashboard"><i class="catalyst-note" ></i><span class="title"><cf_get_lang dictionary_id='44149.Step By Step Implementation'></span><span class="arrow"></span></a></cfoutput></li>
        <li class="menuItem"><cfoutput><a href="#request.self#?fuseaction=process.designer&event=list"><i class="catalyst-loop" ></i><span class="title"><cf_get_lang dictionary_id='31037.İş Akış Tasarımcısı'></span><span class="arrow"></span></a></cfoutput></li>
        <cfif get_module_user(30)><li class="menuItem"><cfoutput><a href="#request.self#?fuseaction=process.list_warnings"><i class="catalyst-bell" ></i><span class="title"><cf_get_lang dictionary_id='47578.Uyarı Ve Onaylar'></span><span class="arrow"></span></a></cfoutput></li></cfif>
        <li class="menuItem"><cfoutput><a href="#request.self#?fuseaction=process.qpic-r"><i class="fa fa-delicious" ></i><span class="title"><cf_get_lang dictionary_id='48909.Qpic_R'></span><span class="arrow"></span></a></cfoutput></li>
         <cfif structKeyExists(application['objects'],attributes.fuseact)>
        <!--- Sayfaların başında XML farklı bir sayfaya gidiyorsa sayfanın ana fuseaction'ı bozuluyor. --->
        	<cfset data = application['objects']['#attributes.fuseact#']['MODULE_NO']>
        <cfelse>
            <cfset data = listfirst(listFirst(attributes.act,'%26'),'.')>
            <cfquery name="get_module_id" datasource="#dsn#">
                select MODULE_ID from modules WHERE MODULE_SHORT_NAME = '#data#'
            </cfquery>
            <cfset data = get_module_id.MODULE_ID>
        </cfif>
        <cfif not len(data)>
            <cfset data = listfirst(listFirst(attributes.act,'%26'),'.')>
            <cfquery name="get_module_id" datasource="#dsn#">
                select MODULE_ID from modules WHERE MODULE_SHORT_NAME = '#data#'
            </cfquery>
            <cfset data = get_module_id.MODULE_ID>
        </cfif>
        <cfif get_module_power_user(data)>
            <li class="menuItem"><cfoutput><a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_denied_pages_lock&act=#replace(replace(urlDecode(attributes.act),'&','|','all'),'=','-','all')#');"><i class="fa fa-lock"></i><span class="title"><cf_get_lang dictionary_id='29982.Kayıt Kiliti'></span><span class="arrow"></span></a></cfoutput></li>         
        </cfif>
    </ul>
</div>
<div id="tabSystem" class="content" style="display: none;">
    <ul class="rightmenu-content scrollContent acordionUl"> 
        <cfoutput>
        	<cfif session.ep.admin and get_module_power_user(7)>
                <li xmlInfo class="menuItem">
                    <cfoutput>
                        <a href="javascript://" id="wrk_xml_pop_" onClick="cfmodal('#request.self#?fuseaction=objects.popup_xml_setup&fuseact=#attributes.XmlFuseaction#&main_fuseact=#attributes.fuseaction#','warning_modal');">
                            <i class="catalyst-layers" ></i>
                            <span class="title">
                                <cf_get_lang dictionary_id='61201.Page Settings'>
                            </span>
                            <span class="arrow"></span>
                        </a>
                    </cfoutput>
                </li>
            </cfif>
            <script>
                <!---
				Henuz tamamlanmadı bu nedenle kapatildi FA 
				<li class="menuItem">
                    <cfif isdefined("WOStruct") and isStruct(WOStruct) and StructKeyExists(WOStruct['#attributes.fuseaction#'],'print') and StructKeyExists(WOStruct['#attributes.fuseaction#']['print'],'cfcName')>
                        <a href="javascript://"  onclick="myPopup('printPanel','','<cfoutput>#WOStruct['#attributes.fuseaction#']['print']['cfcName']#</cfoutput>');"><i class="catalyst-printer"></i><span class="title">Print Ayarları</span></a>
                    <cfelse>
                        <a href="javascript://"  onclick="myPopup('printPanel');"><i class="catalyst-printer"></i><span class="title">Print Ayarları</span></a>
                    </cfif>
                </li>--->
                <cfif get_module_power_user(data)>
                    event = (typeof(document.getElementById('controllerEvents')) != 'undefined' && document.getElementById('controllerEvents') != null) ? document.getElementById('controllerEvents').value : '';
                    if(event != ""){
                        var el = '<li class="menuItem"><a id="page_designer_btn" href="javascript://"><i class="catalyst-settings"></i><span class="title"><cf_get_lang dictionary_id='47755.Page Designer'></span></a></li>';
                        $('##tabSystem').find('li').eq(0).after(el);
                    }
                </cfif>    
            </script>
            <cfif get_module_power_user(7)>
                <li class="menuItem">
                    <a href="#request.self#?fuseaction=settings.params"><i class="catalyst-equalizer"></i><span class="title"><cf_get_lang dictionary_id="57693.Parametreler"></span><span class="arrow"></span></a>
                </li>
            </cfif>
            <cfif session.ep.admin and get_module_power_user(7)>
                <li class="menuItem">
                    <a href="#request.self#?fuseaction=settings.management"><i class="catalyst-rocket"></i><span class="title"><cf_get_lang dictionary_id='44433.Genel Ayarlar'></span><span class="arrow"></span></a>
                </li>
			</cfif>
			<cfif get_module_user(44)>
                <li class="menuItem">
                    <a href="#request.self#?fuseaction=settings.utility"><i class="catalyst-puzzle"></i><span class="title"><cf_get_lang dictionary_id='60175.Utility'></span><span class="arrow"></span></a>
                </li>
			</cfif>
			<cfif get_module_user(83)>
                <li class="menuItem">
                    <a href="#request.self#?fuseaction=settings.security">
                        <i class="catalyst-shield" ></i><span class="title"><cf_get_lang dictionary_id="58151.Güvenlik"></span><span class="arrow"></span>
                    </a>
                </li>
            </cfif>
            <cfif get_module_user(84)>
                <li class="menuItem">
                    <a href="#request.self#?fuseaction=settings.system_transfers"><i class="catalyst-share-alt"></i><span class="title"><cf_get_lang dictionary_id='52718.İmport'></span><span class="arrow"></span></a>                       
                </li>
            </cfif>
            <cfif get_module_user(44)>
                <li class="menuItem">
                    <a href="#request.self#?fuseaction=settings.db_admin"><i class="catalyst-calendar"></i><span class="title"><cf_get_lang dictionary_id='43554.Dönem İşlemleri'></span><span class="arrow"></span></a>
                </li>
                <li class="menuItem">
                    <a href="#request.self#?fuseaction=settings.maintenance"><i class="catalyst-wrench"></i><span class="title"><cf_get_lang dictionary_id="44439.Bakım"></span><span class="arrow"></span></a>
                </li>
            </cfif>                    
            <cfif get_module_user(7)> 
                <li class="menuItem">
                    <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=settings.popup_list_lang_settings')">
                        <i class="catalyst-book-open" ></i><span class="title"><cf_get_lang dictionary_id="57932.Sözlük"></span><span class="arrow"></span>
                    </a>
                </li>
            </cfif>
            <li class="menuItem">
                <a href="javascript://" onclick="openBoxDraggable('#request.self#?fuseaction=objects.popup_list_currency_history')">
                    <i class="catalyst-graph" ></i><span class="title"><cf_get_lang dictionary_id="57648.KUR"></span><span class="arrow"></span>
                </a>
            </li>
            <cfif get_module_user(42)>
                <cfquery name="get_woid" datasource="#dsn#">
                    SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FULL_FUSEACTION = <cfqueryparam value="#attributes.fuseact#" cfsqltype="cf_sql_nvarchar">
                </cfquery>
                <li class="menuItem">
                    <a href="index.cfm?fuseaction=dev.wo&event=upd&fuseact=<cfoutput>#attributes.fuseact#&woid=#get_woid.WRK_OBJECTS_ID#</cfoutput>" target="_blank" <!---onclick="openModalStart()"--->><i class="catalyst-globe-alt"></i><span class="title"><cf_get_lang dictionary_id='47614.Dev'> <cf_get_lang dictionary_id='52734.WO'></span></a><!--- openModalStart(): design/systemModals.cfm altında tanımlı --->
                </li>
                <li class="menuItem">
                    <a href="index.cfm?fuseaction=dev.tools" target="_blank" <!---onclick="openModalStart()"--->><i class="catalyst-calculator"></i><span class="title"><cf_get_lang dictionary_id='47614.Dev'><cf_get_lang dictionary_id='60879.Tools'> </span></a><!--- openModalStart(): design/systemModals.cfm altında tanımlı --->
                </li>
                <li class="menuItem">
                    <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_session','medium')"><i class="catalyst-ghost"></i><span class="title"><cf_get_lang dictionary_id='60176.Variables'></span></a>                      	
                </li>
            </cfif>
        </cfoutput>
     </ul>
</div>

<script>
    $('#page_designer_btn').click(function(){
        $('.page_designer, .page_designer .portBox').show().css("visibility","visible");
        if( formObjects.column.pageType_screen == 'mobile' )
            ActionPDesigner('desktop');
    })
</script>