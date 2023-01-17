<div id="tab-container">
    <div id="tab-head">
        <ul class="tabNav">
            <li class="active"><a href="#tabSetting">Setting</a></li>
            <li><a href="#tabBpm">BPM</a></li>
            <li><a href="#tabSystem">System</a></li>
        </ul>
    </div>
    <div style="clear:both;"></div>
    <div id="tab-content"> 
        <div id="tabSetting" class="content">
            <ul class="rightmenu-content scrollContent acordionUl">
                <li class="menuItem menuAcordion">
                    <a href="#"><i class="catalyst-globe"></i><span class="title" onclick="rightMenuContent('dictionary','systemLanguage')"><cf_get_lang_main no="1584.Dil"></span><span class="arrow"></span></a>
                    <div class="acordionContent" id="systemLanguage" style="display: none;"></div>
                </li>
                <li class="menuItem menuAcordion">
                    <a href="#"><i class="catalyst-calendar" ></i><span class="title" onclick="rightMenuContent('period','systemperiod')"><cf_get_lang_main no="2559.Çalışma Dönemi"></span><span class="arrow"></span></a>
                    <div class="acordionContent" id="systemperiod" style="display: none;"></div>
                </li> 
                <li class="menuItem menuAcordion">
                    <a href="#"><i class="fa fa-users fa-lg btnPointer"></i><span class="title" onclick="rightMenuContent('userGroup','systemUserGroup')"><cf_get_lang_main dictionary_id="40077.Yetki Grubu"></span></a>
                    <div class="acordionContent" id="systemUserGroup" style="display: none;"></div>
                 </li>            
                <li class="menuItem menuAcordion">
                    <a href="#"> <i class="catalyst-key"></i><span class="title" onclick="rightMenuContent('password','systemPassword')"><cf_get_lang_main no="140.Şifre"></span></a>
                    <div class="acordionContent" id="systemPassword" style="display: none;"></div>
                 </li> 
                <li class="menuItem">
                    <a href="javascript://" onclick="cfmodal('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_personal_agenda','warning_modal');"><i class="catalyst-screen-desktop"></i><span class="title"><cf_get_lang_main no='1.Gündem'></span></a>
                <!---Gündem Modal Begin--->
                    <!--- <cfinclude template="../V16/myhome/display/list_personal_agenda.cfm">  --->                 
                <!---Gündem Modal End--->            	
                </li>
                <li class="menuItem menuAcordion">
                    <a href="#"> <i class="catalyst-grid"></i><span class="title" onclick="rightMenuContent('thema','systemThema')"><cfoutput>#getLang('objects2',1313)#</cfoutput></span></a>
                    <div class="acordionContent" id="systemThema" style="display: none;">
                    </div>
                </li>
                <li class="menuItem menuAcordion">
                    <a href="#"> <i class="catalyst-layers"></i><span class="title" onclick="rightMenuContent('menus','systemMenus')"><cfoutput>#getLang('objects',1100)#</cfoutput></span></a>
                    <div class="acordionContent" id="systemMenus" style="display: none;"></div>
                </li> 
                <li class="menuItem menuAcordion">
                    <a href="#"> <i class="catalyst-docs"></i><span class="title" onclick="rightMenuContent('documentSettings','systemDocumentSettings')"><cf_get_lang no='311.Belge No Ayarları'></span></a>
                    <div class="acordionContent" id="systemDocumentSettings" style="display: none;"></div>
                </li>
                <li class="menuItem menuAcordion">
                    <a href="#"> <i class="catalyst-star"></i><span class="title" onclick="rightMenuContent('favourites','systemFavourites')"><cf_get_lang_main no='12.Sık Kullanılanlar'></span></a>
                    <div class="acordionContent" id="systemFavourites" style="display: none;"></div>
                </li>
                <li class="menuItem menuAcordion">
                    <a href="#"> <i class="catalyst-bar-chart"></i><span class="title" onclick="rightMenuContent('reports','systemReports')"><cf_get_lang_main no='214.Raporlar'></span></a>
                    <div class="acordionContent" id="systemReports" style="display: none;"></div>
                </li>
                <li class="menuItem menuAcordion">
                    <a href="#"> <i class="catalyst-calendar"></i><span class="title" onclick="rightMenuContent('calendar','systemCalendar')"><cf_get_lang_main no='3.Ajanda'></span></a>
                    <div class="acordionContent" id="systemCalendar" style="display:none;"></div>
                </li>    
                <li class="menuItem menuAcordion">
                    <a href="#"> <i class="catalyst-formatStyle"></i><span class="title" onclick="rightMenuContent('formatStyle','systemFormatStyle')"> Format </span></a>
                    <div class="acordionContent" id="systemFormatStyle" style="display:none;"></div>
                </li>            
                <li class="menuItem menuAcordion">
                    <a href="#"> <i class="catalyst-info"></i><span class="title" onclick="rightMenuContent('other','systemOther')"><cf_get_lang_main no="744.Diğer"></span></a>
                    <div class="acordionContent" id="systemOther" style="display:none;"></div>
                </li>
            </ul>
        </div>
        <div id="tabBpm" class="content">
            <ul class="rightmenu-content scrollContent"> 
            <!--- controlledFile ifadesi wrkTemplate.cfm dosyasında tanımlanıyor. EY20160111 --->
                <li xmlInfo class="menuItem">
                    <cfoutput>
                        <cfif isdefined("attributes.event") and len(attributes.event) and controlledFile eq 1>
                            <a href="javascript://" id="wrk_xml_pop_" onClick="cfmodal('#request.self#?fuseaction=objects.popup_xml_setup&event=#attributes.event#&fuseact=#WOStruct['#attributes.fuseaction#']['#attributes.event#']['fuseaction']#&main_fuseact=#attributes.fuseaction#','warning_modal');">
                                <i class="catalyst-layers" ></i>
                                <span class="title">
                                    <cf_get_lang dictionary_id='61201.Page Settings'>
                                </span>
                                <span class="arrow"></span>
                            </a>
                        <cfelse>
                            <a href="javascript://" id="wrk_xml_pop_" onClick="cfmodal('#request.self#?fuseaction=objects.popup_xml_setup&event=list&fuseact=#attributes.fuseaction#&main_fuseact=#attributes.fuseaction#','warning_modal');">
                                <i class="catalyst-layers" ></i>
                                <span class="title">
                                    <cf_get_lang dictionary_id='61201.Page Settings'>
                                </span>
                                <span class="arrow"></span>
                            </a>
                        </cfif>
                    </cfoutput>
                </li>
                <li class="menuItem"><cfoutput><a href="#request.self#?fuseaction=process.general_processes"><i class="catalyst-directions" ></i><span class="title"><cf_get_lang_main dictionary_id='36293.Ana Süreçler'></span><span class="arrow"></span></a></cfoutput></li>
                <li class="menuItem"><cfoutput><a href="#request.self#?fuseaction=process.list_process"><i class="catalyst-direction" ></i><span class="title"><cf_get_lang_main dictionary_id='43249.Süreçler'></span><span class="arrow"></span></a></cfoutput></li> 
                <li class="menuItem"><cfoutput><a href="#request.self#?fuseaction=process.list_process_groups"><i class="catalyst-shuffle" ></i><span class="title"><cf_get_lang_main dictionary_id='43250.Süreç Grupları'></span><span class="arrow"></span></a></cfoutput></li> 
            	<li class="menuItem"><cfoutput><a href="#request.self#?fuseaction=settings.list_process_cats"><i class="catalyst-directions" ></i><span class="title">#getLang('main',177)#</span><span class="arrow"></span></a></cfoutput></li>
				<li class="menuItem"><cfoutput><a href="#request.self#?fuseaction=settings.form_add_main_process_cat"><i class="catalyst-directions" ></i><span class="title">#getLang('main',1264)#</span><span class="arrow"></span></a></cfoutput></li>
				<li class="menuItem"><cfoutput><a href="#request.self#?fuseaction=process.list_template"><i class="catalyst-doc" ></i><span class="title"><cf_get_lang_main dictionary_id='49330.Şablonlar'></span><span class="arrow"></span></a></cfoutput></li> 
                <li class="menuItem"><cfoutput><a href="#request.self#?fuseaction=process.list_process&event=add"><i class="catalyst-loop" ></i><span class="title"><cf_get_lang_main dictionary_id='31037.İş Akış Tasarımcısı'></span><span class="arrow"></span></a></cfoutput></li>   
                <li class="menuItem"><cfoutput><a href="#request.self#?fuseaction=process.list_warnings"><i class="catalyst-fire" ></i><span class="title"><cf_get_lang_main dictionary_id='47578.Uyarı Ve Onaylar'></span><span class="arrow"></span></a></cfoutput></li>         
                <li class="menuItem"><cfoutput><a href="javascript://" onclick="windowopen('','medium','lock_window');add_to_favorites.action='#request.self#?fuseaction=objects.popup_denied_pages_lock';add_to_favorites.target='lock_window';add_to_favorites.submit();"><i class="fa fa-lock"></i><span class="title"><cf_get_lang_main no='2185.Kayıt Kiliti'></span><span class="arrow"></span></a></cfoutput></li>         
			</ul>
        </div>
        <div id="tabSystem" class="content">
            <ul class="rightmenu-content scrollContent acordionUl"> 
                <cfoutput>
                    <li class="menuItem">
                        <a href="#request.self#?fuseaction=settings.welcome&type=1"><i class="catalyst-equalizer"></i><span class="title">Parametreler</span><span class="arrow"></span></a>
                    </li> 
                    <li class="menuItem">
                        <a href="#request.self#?fuseaction=settings.welcome&type=1"><i class="catalyst-rocket"></i><span class="title">Genel Ayarlar</span><span class="arrow"></span></a>
                    </li>
                    <li class="menuItem">
                        <a href="#request.self#?fuseaction=settings.welcome&type=2"><i class="catalyst-share-alt"></i><span class="title">İmport</span><span class="arrow"></span></a>                       
                    </li>
                    <li class="menuItem">
                        <a href="#request.self#?fuseaction=settings.welcome&type=3"><i class="catalyst-calendar"></i><span class="title">Dönem İşlmeleri</span><span class="arrow"></span></a>
                    </li>
                    <li class="menuItem">
                        <a href="#request.self#?fuseaction=settings.welcome&type=5"><i class="catalyst-wrench"></i><span class="title">Bakım</span><span class="arrow"></span></a>
                    </li> 
                    <li class="menuItem">
                        <a href="#request.self#?fuseaction=settings.welcome&type=6"><i class="catalyst-puzzle"></i><span class="title">Utilities</span><span class="arrow"></span></a>
                    </li> 
                    <li class="menuItem">
                        <a href="#request.self#?fuseaction=settings.security">
                            <i class="catalyst-shield" ></i><span class="title"><cf_get_lang_main no="739.Güvenlik"></span><span class="arrow"></span>
                        </a>
                    </li>                    
                    <li class="menuItem">
                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_list_lang_settings','medium')">
                            <i class="catalyst-book-open" ></i><span class="title"><cf_get_lang_main no="520.Sözlük"></span><span class="arrow"></span>
                        </a>
                    </li>
                    <li class="menuItem">
                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_currency_history','medium')">
                            <i class="catalyst-graph" ></i><span class="title"><cf_get_lang_main no="236.KUR"></span><span class="arrow"></span>
                        </a>
                    </li>
                    <li class="menuItem">
                    <a href="javascript://"  onclick="myPopup('formPanel');"><i class="catalyst-settings"></i><span class="title">Page Designer</span></a>                      	
                    </li>
                <li class="menuItem">
                    <cfif isdefined("WOStruct") and isStruct(WOStruct) and StructKeyExists(WOStruct['#attributes.fuseaction#'],'print') and StructKeyExists(WOStruct['#attributes.fuseaction#']['print'],'cfcName')>
                        <a href="javascript://"  onclick="myPopup('printPanel','','<cfoutput>#WOStruct['#attributes.fuseaction#']['print']['cfcName']#</cfoutput>');"><i class="catalyst-printer"></i><span class="title">Print Ayarları</span></a>
                    <cfelse>
                        <a href="javascript://"  onclick="myPopup('printPanel');"><i class="catalyst-printer"></i><span class="title">Print Ayarları</span></a>
                    </cfif>
                </li>
                <li class="menuItem">
                    <a href="javascript://"  onclick="myPopup('workDev');"><i class="catalyst-ghost"></i><span class="title">workDev</span></a>                      	
                </li>
                <li class="menuItem">
                    <a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_session','medium')"><i class="catalyst-ghost"></i><span class="title">Variables</span></a>                      	
                </li>
                </cfoutput>
             </ul>
        </div>
    </div>
</div>