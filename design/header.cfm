<head>
	<link rel="manifest" href="/manifest.json" />
	<meta name="robots" content="noindex" />
</head>
<cfset upload_folder = application.systemParam.systemParam().upload_folder>
<cf_get_lang_set module_name = 'myhome'>
	<cfset comp = createObject("component","AddOns.Devonomy.GDPR.cfc.gdpr_decleration")/>
	<cfset Data_Decleration = comp.Data_Decleration()/>
	<cfset MAX_DECLERATION = comp.MAX_DECLERATION()/>
	<!--- Objenin XML parametreleri baska bir objesinin XML parametrelerini kullanıyor ise controllerda XmlFuseaction tanımlanıyor ve bu parametre gonderiliyor --->
	<cfif isdefined("attributes.event") and isdefined("WOStruct") and StructKeyExists(WOStruct['#attributes.fuseaction#'],attributes.event) and StructKeyExists(WOStruct['#attributes.fuseaction#']['#attributes.event#'],'fuseaction')>
		<cfif StructKeyExists(WOStruct['#attributes.fuseaction#']['#attributes.event#'],'XmlFuseaction')>
			<cfset XmlFuseaction = WOStruct['#attributes.fuseaction#']['#attributes.event#']['XmlFuseaction']>
		<cfelse>
			<cfset XmlFuseaction = WOStruct['#attributes.fuseaction#']['#attributes.event#']['fuseaction']>
		</cfif>
	<cfelse>
		<cfset XmlFuseaction = attributes.fuseaction>
	</cfif>
	
	<cfset act_url_link=''>
	<cfif isdefined('form.FIELDNAMES') and url.fuseaction is not 'objects2.list_basket'>
		<cfif isdefined('url.fuseaction')>
			<cfset act_url_link="#url.fuseaction#">
		</cfif>
		<cfif isdefined("url.fuseaction") and StructCount(url) gt 1>
			<cfloop collection="#url#" item="url_index">
				<cfif  url_index neq 'fuseaction'>
					<cfset act_url_link="#act_url_link#&#url_index#=#evaluate("url.#url_index#")#">
				</cfif>
			</cfloop>			
		</cfif>
		<cfloop list="#form.FIELDNAMES#" index="attributes_index">
			<cfif not act_url_link contains '&#attributes_index#=' and isdefined("form.#attributes_index#") and not attributes_index contains '.'>
				<cfset act_url_link='#act_url_link#&#attributes_index#=#evaluate("form.#attributes_index#")#'>
			</cfif>
		</cfloop>
	<cfelse>
		<cfset act_url_link=replace(cgi.query_string,'fuseaction=','')>
	</cfif>
	<form name="add_to_favorites" id="add_to_favorites" target="_blank" method="post" action="<cfoutput>#request.self#?fuseaction=myhome.popup_favorites</cfoutput>">
	<input type="hidden" name="act" id="act" value='<cfoutput>#act_url_link#</cfoutput>'></form>
	<cfset lang_change_ = 0>
	<cfscript>
		getHeader = createObject("component","cfc.right_menu_fnc");
		Get_My_Profile = getHeader.GET_PROFILE('#session.ep.userid#');
		GET_ONLINE_USER = getHeader.ONLINE_USER();
		ONLINE_USER_INTRANET = getHeader.ONLINE_USER_INTRANET();
		ONLINE_USER_EXTRANET = getHeader.ONLINE_USER_EXTRANET();
		MY_FAVORITE = getHeader.USER_FAVORITES('#session.ep.userid#');
		GET_USER_GROUP_MENU = getHeader.GET_USER_GROUP_MENU_INSIDE('#session.ep.userid#');
		/* Uyarı alanları için kullanılıyor */
		pageType = 0;
		warningStartResponseDate = date_add('m',-1,now());
		warningFinishResponseDate = now();
		warningIsActive = 1;
		warningCondition = 1;
		warningAttached = 1;
		/* Uyarı alanları için kullanılıyor */
	</cfscript>
	<cfif session.ep.menu_id neq 0>
		<cfscript>
			menuObject = createObject("component","WMO.login");
			getMenuJSON = menuObject.getMenuUserGroup('#session.ep.language#','#GET_USER_GROUP_MENU#','#dsn#');
		</cfscript>
	<cfelse>
		<cftry><!--- userGruba ait json dosya mevcutsa --->
			<cffile action="read" file="#upload_folder#personal_settings/userGroup_#session.ep.language#_#GET_USER_GROUP_MENU#.json" variable="personalMenu" charset="utf-8">
		<cfcatch><!--- userGruba ait json dosya silinmiş olabilir --->
			<cfscript>
				menuObject = createObject("component","WMO.login");
				getMenuJSON = menuObject.getMenuUserGroup('#session.ep.language#','#GET_USER_GROUP_MENU#','#dsn#');
			</cfscript>
			<cftry><!--- Sisteme giren o userGruba ait ilk kullanıcı json dosyasını create eder.  --->
				<cffile action="write" file="#upload_folder#personal_settings/userGroup_#session.ep.language#_#GET_USER_GROUP_MENU#.json" addnewline="no" output="#replace(serializeJSON(getMenuJSON),'//','')#" charset="utf-8">
			<cfcatch></cfcatch>
			</cftry>
		</cfcatch>
		</cftry>

		<cftry><!--- userGruba ait jelibon menu json dosya mevcutsa --->
			<cffile action="read" file="#upload_folder#personal_settings/userGroup_jelibon_menu_#session.ep.language#_#GET_USER_GROUP_MENU#.json" variable="personalMenu" charset="utf-8">
			<cffile action="read" file="#upload_folder#personal_settings/userGroup_watomic_menu_#session.ep.language#_#GET_USER_GROUP_MENU#.json" variable="personalMenu" charset="utf-8">
		<cfcatch><!--- userGruba ait jelibon menu json dosya silinmiş olabilir --->
			<cfscript>
				jeliMenuObject = createObject("component","WMO.login");
				getJelibonJSON = jeliMenuObject.getJeliMenuUserGroup('#session.ep.language#','#GET_USER_GROUP_MENU#','#dsn#');
				getWatomicJSON = jeliMenuObject.getJeliMenuUserGroup('#session.ep.language#','#GET_USER_GROUP_MENU#','#dsn#',2);
			</cfscript>
			<cftry><!--- Sisteme giren o userGruba ait ilk kullanıcı json dosyasını create eder.  --->
				<cffile action="write" file="#upload_folder#personal_settings/userGroup_jelibon_menu_#session.ep.language#_#GET_USER_GROUP_MENU#.json" addnewline="no" output="#getJelibonJSON#" charset="utf-8">
				<cffile action="write" file="#upload_folder#personal_settings/userGroup_watomic_menu_#session.ep.language#_#GET_USER_GROUP_MENU#.json" addnewline="no" output="#getWatomicJSON#" charset="utf-8">
			<cfcatch></cfcatch>
			</cftry>
		</cfcatch>
		</cftry>

	</cfif>
	<!--- Sanal santral enetegrasyon bilgileri için eklendi. --->
	<cfset getComponent = createObject('component', 'WEX.cti.cfc.verimor')>
	<cfset getCallInformations = getComponent.getCallInformations()>
	<cfif getCallInformations.recordcount and getCallInformations.IS_CTI_INTEGRATED eq 1 and len(getCallInformations.api_key) and len(getCallInformations.extension)>
		<cfset missed_counter = getComponent.getMissedCount(key : getCallInformations.api_key, extension : getCallInformations.extension)>
	</cfif>
	<cfset get_messages = createObject("Component","V16.objects.cfc.messages") />
	<cfset messageCounter = get_messages.message_counter() />
	<cfset totalMessageCount = ( messageCounter.recordcount ) ? messageCounter.COUNT : 0 />
	<cfset mistake = false />
	<!--- 
		upd: 20/11/2019 Uğur Hamurpet 
		desc: get_warnings sorgusuna yeni alanlar eklendi. WRO çalıştırılmadıysa sayfa hata verdiğinden try catch konuldu.
	--->
	<cftry>
		<cfinclude template="../V16/myhome/query/get_warnings.cfm">
		<cfset warningAttached = 0>
		<cfset warningCount = get_warnings.recordcount>
	<cfcatch>
		<cfset mistake = true>
		<cfset warningCount = 0>
	</cfcatch>
	</cftry>

	<cfif isDefined('session.ep.userid')>
		<cfset my_id = session.ep.userid>
		<cfset sender_type = 0>
		<cfset receiver_type = 0>
	<cfelseif isDefined('session.pp.userid')>
		<cfset my_id = session.pp.userid>
		<cfset sender_type = 1>
		<cfset receiver_type = 1>
	<cfelseif isDefined('session.ww.userid')>
		<cfset my_id = session.ww.userid>
		<cfset sender_type = 2>
		<cfset receiver_type = 2>
	</cfif>
<cfset workcube_license = createObject("V16.settings.cfc.workcube_license").get_license_information() />
	<cfif not (attributes.fuseaction contains 'objects.workflowpages') and not (attributes.fuseaction contains 'objects.chatflow') and not (attributes.fuseaction contains 'production.order_operator' and isdefined("attributes.event") and attributes.event eq 'list')>
		<div class="page-header navbar navbar-fixed-top">
			<div class="page-header-inner">
				<div class="page-logo">
					<cfif IsDefined("session.ep.userid") and session.ep.design_id eq 2>
						<a class="leftBarOpenBtn" href="javascript:;"><img src="images/watom-amblem.png" title="<cfoutput>Workcube #workcube_version#</cfoutput>"/></a>
						<style>
							.page-header.navbar .page-logo{
								background:#13c603;
							}
							.page-header.navbar .page-logo:hover{
								background:#13c603;
							}
							.page-header.navbar .page-logo img{
								width:275%;
								padding-top:2px;
								margin-left:-18px;
							}
						</style>
					<cfelse>
						<a class="leftBarOpenBtn" href="javascript:;"><img src="images/w3-white.png" title="<cfoutput>Workcube #workcube_version#</cfoutput>"/></a>
					</cfif>
				</div>
				<a href="javascript:;" class="menu-toggler responsive-toggler" data-toggle="collapse" data-target=".navbar-collapse"></a>
				<div class="headerMenu" id="headerMenu" >
					<nav class="topLeftMenu">
						<ul>
							<li class="dropdown" style="padding-left:4px;"><a class="catalyst-home" title="<cfoutput>#getLang('main','Gündem',57413)#</cfoutput>" href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.welcome"></a></li>
							<li class="dropdown" style="padding-left:5px;"><a class="catalyst-cup" title="Intranet" href="<cfoutput>#request.self#</cfoutput>?fuseaction=rule.welcome"></a></li>
							<li class="dropdown" style="padding-left:5px;"><a class="catalyst-bar-chart" title="BI - <cfoutput>#getLang('main','Rapor',57434)#</cfoutput>" href="<cfoutput>#request.self#</cfoutput>?fuseaction=report.welcome"></a></li>
							<li class="dropdown" style="padding-left:5px;"><a class="catalyst-calendar" href="<cfoutput>#request.self#?fuseaction=agenda.view_daily</cfoutput>" title="<cf_get_lang dictionary_id='57415.Ajanda'>"></a></li>	
						</ul>
					</nav>
					<!--- <nav class="topMobileMenu pull-right"><ul><li class="dropdownBox"><a href="javascript://" class="fa fa-bars fa-lg mobileMenuOpen rightBarOpenBtn"></a></li></ul></nav> --->
				</div>
				<div class="headerMenu pull-right">
					<nav class="topRightMenu">
						<!--- sayfa mobile geçince rightmenü altında görünmeyecek iconlar için oluşturuldu.--->
						<cfquery name="getOnlineUserIntranet" dbtype="query">
							SELECT DISTINCT USERID,KULLANICI,POSITION_NAME,PHOTO,SEX,USER_TYPE,SURNAME FROM ONLINE_USER_INTRANET
						</cfquery>
												
						<ul class="mobileMenuParent">
							<li class="dropdownBox lzymg"><a onclick="window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.phone','Phone')"><i style="font-size:17px;" class="catalyst-earphones-alt"></i><span id="missed_count"></span></a></li>
							<li class="dropdownBox lzymg"><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_form_add_warning&employee_id=<cfoutput>#session.ep.userid#</cfoutput>','','ui-draggable-box-large')" title="<cf_get_lang dictionary_id='61915.Workshare'>"><i class="catalyst-share"></i></a></li>
							<li class="dropdownBox lzymg"><a onclick="window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.chatflow&tab=1&subtab=1','ChatFlow');"><i style="font-size:17px;" class="catalyst-emotsmile"></i> <span class="badge badgeCount"><cfoutput>#getOnlineUserIntranet.recordcount+ONLINE_USER_EXTRANET.recordcount#</cfoutput></span></a></li>
								<li class="dropdown" id="pm_varmi">
									<cfoutput>
										<script>
											document.addEventListener("DOMContentLoaded", function(event)
											{
												if (#totalMessageCount#) {
													document.getElementById('pm_varmi').style.display = '';
												}
											});
											
											function kapat()
											{
												document.getElementById('pm_badge').textContent=document.getElementById('pm_badge').textContent-1;
												document.getElementById('pm_badge').style.display = 'none';
											}
											
											<cfif warningCount neq 0>
												function warningKapat()
												{
													document.getElementById('warning_badge').textContent=document.getElementById('warning_badge').textContent-1;
													document.getElementById('warning_badge').style.display = 'none';
												}
											</cfif>
										</script>
										<a id="link_pm" style="height:32px;" title="<cf_get_lang dictionary_id='57543.Mesaj'>" onclick="window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.chatflow&tab=1&subtab=2','Workflow');<cfif totalMessageCount neq 0>kapat();</cfif>">
											<i class="catalyst-bubble"></i></span>
											<span id="pm_badge" class="badge badgeCount" <cfif totalMessageCount eq 0>style="display:none;"</cfif>><cfif totalMessageCount neq 0>#totalMessageCount#</cfif></span>
										</a>
									</cfoutput>
								</li>
							
							<li class="dropdown">
								<cfif mistake>
									<a href="<cfoutput>#request.self#?fuseaction=settings.wro_control</cfoutput>" target="_blank" title="Bu alanı kullanabilmek için çalışması gereken WRO'lar var!">
										<i class="fa fa-bell-o"></i>
									</a>
								<cfelse>
									<a href="javascript://" title="<cf_get_lang dictionary_id='57757.Uyarılar'>" class="warningBarOpenBtn" onclick="<!--- openNav('','warning_page','') --->window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.workflowpages&tab=2','Workflow');">
										<i class="catalyst-bell"></i>
										<cfif warningCount><span class="badge badgeCount"><cfoutput>#warningCount#</cfoutput></span></cfif>
									</a>
								</cfif>		
							</li>
							<li class="dropdown dropdown-user">
								<a href="javascript://"><i style="line-height:32px;" class="catalyst-user"></i></a>
								<ul class="dropdown-menu">
									<cfif get_module_user(80)>
										<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_position"><i class="catalyst-briefcase" ></i><cfoutput>#getLang('myhome',36)#</cfoutput></a></li>
										<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.dashboard"><i class="catalyst-pie-chart" ></i>Dashboard</a></li>
									</cfif>
									<li class="divider"></li>
									<cfif get_module_user(81)>
										<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.hr"><i class="catalyst-users"></i><cfoutput>#getLang('agenda',60)#</cfoutput></a></li>
									</cfif>
									<cfif get_module_user(82)>
										<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.other_hr"><i class="catalyst-plane" ></i><cfoutput>#getLang('assetcare',557)#</cfoutput></a></li>
									</cfif>
									<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.myTeam"><i class="catalyst-target" ></i><cfoutput>#getLang('myhome','',61183,'Ekibim Ve Ben')#</cfoutput></a></li>
									<cfif get_module_user(81)>
										<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.upd_myweek"><i class="catalyst-clock" ></i><cfoutput>#getLang('myhome',1461)#</cfoutput></a></li>
									</cfif>
									<li class="divider"></li>
									<li><cfoutput><a href="#request.self#?fuseaction=home.logout" title="<cfoutput>#getLang('main','Çıkış',57431)#</cfoutput>"><i class="catalyst-logout" ></i> <cfoutput>#getLang('main','Çıkış',57431)#</cfoutput></a></cfoutput></li>
								</ul>
							</li>							
							<li class="dropdown mega-menu"><a><i style="line-height:32px;" class="catalyst-question"></i></a>
								<div class="interaction_menu">
									<div class="interaction_menu_right">
										<ul>
											<li><a href="<cfoutput>#request.self#?fuseaction=help.wiki&meta_desc=#attributes.fuseaction#&form_submitted=1</cfoutput>" target="_blank" title="<cf_get_lang dictionary_id='60722.INHOUSE WIKI'>"><cf_get_lang dictionary_id='60722.INHOUSE WIKI'></a></li>
											<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=help.worktips" id="helpWorktips"><cf_get_lang dictionary_id='61526.Worktips'></a></li>
											<cfif len(workcube_license.implementation_project_domain) and len(workcube_license.implementation_project_id)>
												<li><cfoutput><a href="javascript://" id = "AddWorkLink" onclick = "window.open('#workcube_license.implementation_project_domain#/index.cfm?fuseaction=project.works&event=add&id=#workcube_license.implementation_project_id#&work_fuse=#attributes.fuseaction#','İş Ekle');">#getLang('','',57933)#</cfoutput></a></li>
											</cfif>
										
											<li><cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_about_workcube','medium');"><cf_get_lang dictionary_id="48837.Sürüm Notları"></cfoutput></a></li>
											<cfif workcube_mode eq 0>
												<li><cfoutput><a href="javascript://" onclick="cfmodal('#request.self#?fuseaction=objects.emptypopup_add_test_page&fuseact=#attributes.fuseaction#&event=#iif(isDefined("attributes.event"),"attributes.event", de("list"))#','warning_modal');" title="<cf_get_lang dictionary_id="55085.Test kontrolü">"><cf_get_lang dictionary_id="55085.Test kontrolü"></cfoutput></a></li>
											</cfif>
											<li><a href="javascript://" title="<cfoutput>#getLang('','','60940')#</cfoutput>" onclick = "cfmodal('<cfoutput>#request.self#?fuseaction=objects.workcube_license</cfoutput>','warning_modal');"><cfoutput>#getLang('','','60940')#</cfoutput></a></li>
											<cfif Data_Decleration.recordcount>
												<li><a href="javascript://"onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=myhome.approve</cfoutput>','','ui-draggable-box-large')"  title="<cf_get_lang dictionary_id='64696.Kişisel Veri Aydınlatma Metni'>"><cf_get_lang dictionary_id='64696.Kişisel Veri Aydınlatma Metni'></a></li>
											</cfif>
											<li><a href="javascript://"onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=myhome.popup_dsp_kural</cfoutput>','dsp_kural', 'ui-draggable-box-large');"  title="<cf_get_lang dictionary_id='64841.Kullanım Kuralları'>"><cf_get_lang dictionary_id='64841.Kullanım Kuralları'></a></li>
											<li class="new"><a href="javascript://">Yenilikler</a></li>
											<li><cfoutput><a href="javascript://" id = "helpLink" onclick = "window.open('#request.self#?fuseaction=help.popup_add_problem&help=#attributes.fuseaction#','Destek Başvuru');">#getLang("help",22)#</cfoutput></a></li>
											<li class="divider"></li>
											<li><a  href="https://wiki.workcube.com" target="_blank" title="<cfoutput>#getLang("myhome",624)#</cfoutput>">wiki.workcube</a></li>
											<li><cfoutput><a href="https://project.workcube.com" target="_blank">project.workcube</cfoutput></a></li>
											<li><a  href="https://www.workcube.com/workcubetv" target="_blank" title="<cf_get_lang dictionary_id='52635.Workcube TV'>"><cf_get_lang dictionary_id='52635.Workcube TV'></a></li>
											<li><a  href="https://www.workcube.com" target="_blank" title="Workcube Catalyst">workcube.com</a></li>
											<li><a  href="https://www.workcube.com/workcube-toplulugu" target="_blank" title="<cf_get_lang dictionary_id='31384.Kullanıcı Topluluğu'>"><cf_get_lang dictionary_id='29994.Topluluk'></a></li>
											<!--- <li><a onclick="nModal({head:'<cfoutput>#getLang("myhome",626)#</cfoutput>',page:'<cfoutput>#request.self#</cfoutput>?fuseaction=help.popup_list_helpdesk&help=#attributes.fuseaction#',content:'626Content'});"  title="<cfoutput>#getLang("myhome",626)#</cfoutput>"><cfoutput>#getLang("myhome",626)#</cfoutput></a></li> --->
											<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
												<div class="help_tour_wrapper_pin">
													<div class="help_tour_pin_add">
														<a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.widget_loader&widget_load=addWorktips&is_box=1&box_title=<cf_get_lang dictionary_id="63531.Tips Ekle">&fuseact=<cfoutput>#attributes.fuseaction#</cfoutput>','','ui-draggable-box-medium')"><i class="fa fa-plus" title="<cfoutput>#getLang('','Tips Ekle',63531)#</cfoutput>"></i></a>
													</div>
													<div class="help_tour_wrapper_pin_item"></div>
													<div class="help_tour_checkbox" style="text-align:left">
														<div class="checkbox checbox-switch">
															<label style="width:100%;position:relative;">
																<!--- <a href="javascript://" id="helpTour" style="display:inherit;"><cf_get_lang dictionary_id='61527.Work Tips Ekle'></a> --->
																<input type="checkbox" name="worktips_open" <cfif isdefined("session.ep.worktips_open") and session.ep.worktips_open eq 1>checked="checked"</cfif> />
																<span title="Tips Açık Çalış" style="position: absolute;right:0;top:-10px;"></span>
															</label>
														</div>	
													</div>
												</div>
											</div>
										</ul>
									</div>
								</div>
							</li>
							<li class="dropdown"><a href="javascript://" class="rightBarOpenBtn"  title="<cf_get_lang dictionary_id='29670.Kontrol Paneli'>" ><i style="line-height:32px;" class="catalyst-settings"></i></a></li>
						</ul>
						<!--- sayfa mobile geçince rightmenü altında görünmeyecek iconlar için oluşturuldu.--->
						<ul class="mobileMenu">
							<li class="dropdown" id="addOptionsWarning" style="display:none;"><a class="fa fa-exclamation fa-inverse" title="AddOptions"></a></li>
							<li class="dropdown"><cfoutput><a href="javascript://" onclick="periodChange('<cfoutput>#attributes.fuseaction#</cfoutput>','<cfoutput>#XmlFuseaction#</cfoutput>');">#session.ep.company_nick# - #session.ep.period_year#</a></cfoutput></li>					
							<li class="dropdown dropdown-user"><a href="javascript://">
								<cfif len(Get_My_Profile.PHOTO) and FileExists("#upload_folder#/hr/#Get_My_Profile.PHOTO#")>
									<img class="img-circle" alt="" src="../documents/hr/<cfoutput>#Get_My_Profile.PHOTO#</cfoutput>" />
								<cfelse>
									<span class="avatextCt onlineusers color-<cfoutput>#Left(Get_My_Profile.NAME, 1)#</cfoutput>"style="width: 25px !important; float: left;margin-top: 3px; margin-right: 8px; height: 25px; display: inline-block;"><small class="avatext onlineusers" style="font-size:11px; top:-6px; width:26px !important;"><cfoutput>#Left(Get_My_Profile.NAME, 1)##Left(Get_My_Profile.SURNAME, 1)#</cfoutput></small></span>
								</cfif>
									<cfoutput>#Get_My_Profile.NAME#</cfoutput> <i class="fa fa-angle-down fa-lg" ></i></a>
								<ul class="dropdown-menu">
									<cfif get_module_user(80)>
										<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_position"><i class="catalyst-briefcase" ></i><cfoutput>#getLang('myhome',36)#</cfoutput></a></li>
										<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.dashboard"><i class="catalyst-pie-chart" ></i>Dashboard</a></li>
									</cfif>
									<li class="divider"></li>
									<cfif get_module_user(81)>
										<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.hr"><i class="catalyst-users" ></i><cfoutput>#getLang('agenda',60)#</cfoutput></a></li>
									</cfif>
									<cfif get_module_user(82)>
										<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.other_hr"><i class="catalyst-plane" ></i><cfoutput>#getLang('assetcare',557)#</cfoutput></a></li>
									</cfif>
									<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.myTeam"><i class="catalyst-target" ></i><cfoutput>#getLang('myhome','',61183,'Ekibim Ve Ben')#</cfoutput></a></li>
									<cfif get_module_user(81)>
										<li><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.upd_myweek"><i class="catalyst-clock" ></i><cfoutput>#getLang('myhome',1461)#</cfoutput></a></li>
									</cfif>
									<li class="divider"></li>
									<li><cfoutput><a href="#request.self#?fuseaction=home.logout" title="<cfoutput>#getLang('main','Çıkış',57431)#</cfoutput>"><i class="catalyst-logout" ></i> <cfoutput>#getLang('main','Çıkış',57431)#</cfoutput></a></cfoutput></li>
								</ul>
							</li>
							<li class="dropdownBox hidden-element lzymg"><a onclick="window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.phone','Phone')"><i style="font-size:17px;" class="catalyst-earphones-alt"></i><span id="missed_count1"></span></a></li>	
							<li class="dropdownBox hidden-element lzymg"><a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_form_add_warning&employee_id=<cfoutput>#session.ep.userid#</cfoutput>','','ui-draggable-box-large')" title="<cf_get_lang dictionary_id='61915.Workshare'>"><i style="font-size:17px;" class="catalyst-share"></i></a></li>
							<li class="dropdownBox hidden-element lzymg"><a onclick="window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.chatflow&tab=1&subtab=1','Workflow');"><i style="font-size:17px;" class="catalyst-emotsmile"></i> <span class="badge badgeCount"><cfoutput>#getOnlineUserIntranet.recordcount+ONLINE_USER_EXTRANET.recordcount#</cfoutput></span><span class="menuTitle"><cf_get_lang_main  no="2218.Online" > <cf_get_lang_main  no="518.Kullanıcı" ></span></a></li>
							<!--- <li class="dropdown"><a class="catalyst-calendar" href="<cfoutput>#request.self#?fuseaction=agenda.view_daily</cfoutput>" title="<cf_get_lang dictionary_id='3.Ajanda'>"><span class="menuTitle"><cf_get_lang dictionary_id='3.Ajanda'></span></a></li> --->
							<li class="dropdown" id="pm_varmi">
								<cfoutput>
									<script>
										document.addEventListener("DOMContentLoaded", function(event)
										{
											if (#totalMessageCount#) {
												document.getElementById('pm_varmi').style.display = '';
											}
										});
										
										function kapat()
										{
											document.getElementById('pm_badge').textContent=document.getElementById('pm_badge').textContent-1;
											document.getElementById('pm_badge').style.display = 'none';
										}
										
										<cfif warningCount neq 0>
											function warningKapat()
											{
												document.getElementById('warning_badge').textContent=document.getElementById('warning_badge').textContent-1;
												document.getElementById('warning_badge').style.display = 'none';
											}
										</cfif>
									</script>
									<a id="link_pm" style="height:32px;" title="<cf_get_lang dictionary_id='57543.Mesaj'>" onclick="window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.chatflow&tab=1&subtab=2','Workflow');<cfif totalMessageCount neq 0>kapat();</cfif>">
										<i class="catalyst-bubbles"></i><span class="menuTitle"><cf_get_lang dictionary_id='57543.Mesaj'></span>
										<span id="pm_badge" class="badge badgeCount" <cfif totalMessageCount eq 0>style="display:none;"</cfif>><cfif totalMessageCount neq 0>#totalMessageCount#</cfif></span>
									</a>
								</cfoutput>
							</li>
							<li class="dropdown hidden-element">
								<cfset warningAttached = 0>
								<cfif mistake>
									<a href="<cfoutput>#request.self#?fuseaction=settings.wro_control</cfoutput>" target="_blank" title="Bu alanı kullanabilmek için çalışması gereken WRO'lar var!">
										<i class="catalyst-bell" ></i>
									</a>
								<cfelse>
									<a title="<cf_get_lang dictionary_id='57757.Uyarılar'>" class="warningBarOpenBtn" onclick="window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.workflowpages&tab=2','Workflow');<cfif warningCount neq 0>warningKapat();</cfif>">
										<i class="catalyst-bell" ></i>
										<span class="menuTitle"><cf_get_lang dictionary_id='57757.Uyarılar'></span>
										<cfif warningCount><span id="warning_badge" class="badge badgeCount"><cfoutput>#warningCount#</cfoutput></span></cfif>
									</a>
								</cfif>
								<!---
								<ul class="dropdown-menu scrollContent menuFavorite">
									<li><a href="javascript://" title="<cf_get_lang dictionary_id='345.Uyarılar'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_list_warning','wide2');"><cf_get_lang dictionary_id='345.Uyarılar'><cfif warningCount><span class="badge"><cfoutput>#warningCount#</cfoutput></span></cfif></a></li>
									<li><cfoutput><a href="javascript://" onclick="nModal({head: '<cf_get_lang_main dictionary_id='57935.Uyarı Ekle'>',page:'#request.self#?fuseaction=myhome.popup_form_add_warning',class:'modalBlue'});" ><cf_get_lang_main dictionary_id='57935.Uyarı Ekle'></a></cfoutput></li>
								</ul>\0
								--->							
							</li>
							<cfif MY_FAVORITE.recordcount>
								<li class="dropdown"><a href="javascript://" class="catalyst-star"><span class="menuTitle">Favoriler</span></a>
									<ul class="dropdown-menu scrollContent menuFavorite">
										<cfoutput query="MY_FAVORITE">
											<li>
												<div class="row">
													<div class="col col-10 padding-0 text-left">
														<a href="#FAVORITE#" <cfif IS_NEW_PAGE>target="_blank"</cfif>><i class="fa fa-link"></i>#FAVORITE_NAME#</a>
													</div>
													<div value="#FAVORITE_ID#" class="col col-2 text-right"><cfif SHOW eq 0 or not len(SHOW)><span onclick="saveFav('#FAVORITE_ID#','#session.ep.userid#');"><i class="icon-pluss"></i></span><cfelse><span onclick="delFav('#FAVORITE_ID#','#session.ep.userid#');"><i class="icon-minus"></i></span></cfif></div>
												</div>
											</li>
										</cfoutput>
									</ul>
								</li>
							</cfif>
							
							<li class="dropdown mega-menu"><a class="catalyst-question" ><span class="menuTitle"><cf_get_lang dictionary_id='57433.Yardım'></span></a>
								<div class="interaction_menu">
									<div class="col col-7 col-md-7 col-sm-7 col-xs-12">
										<div class="interaction_menu_left">
											<!--- <div class="interaction_menu_left_top">
												<div class="interaction_menu_left_top_img">
													<img src="https://networg.workcube.com/documents/project/22FE35A7-155D-1309-BA36EC6D20A04E62.PNG" />
													<a target="_blank" class="interaction_menu_left_top_img_play" href="javascript://">
														<i class="fa fa-youtube-play"></i>
													</a>
												</div>
												<div class="interaction_menu_left_top_text">
													<span><cf_get_lang dictionary_id='63119.Workfuse neden önemlidir?'></span>
													<p><cf_get_lang dictionary_id='63120.Dijital ekonomide dijital faaliyetler tıpkı lojistik, satış, pazarlama, üretim gibi kesintisiz devam etmesi gereken bir alandır.'></p>
													<p><cf_get_lang dictionary_id='63121.Satış sürecinde başarılı olmak için kullanacağınız standartlar ve dokümanları mutlaka inceleyin.'></p>
												</div>
											</div> --->
											<div class="interaction_menu_left_bottom">
												<!---<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
													 <div class="interaction_menu_left_bottom_text">
														<div class="interaction_menu_left_top_text_title">
															<img src="https://networg.workcube.com/css/assets/icons/catalyst-icon-svg/wiki-logo.svg">
															<cf_get_lang dictionary_id='60721.Wiki'>
														</div>
														<span><cf_get_lang dictionary_id='63122.Kalite Kontrol İşlemleri Vaka Çalışması'></span>
														<p><cf_get_lang dictionary_id='63123.Acme Holding, yoksul çocukların okumasına destek olan bir vakfın düzenlemiş olduğu kermeste özel olarak ambalajlanmış 1000 adet şişe Sızma Zeytinyağı satmak ve gelirini vakfa bağışlamak için kollarını sıvamıştır.'></p>
														<a href="javascript://"><cf_get_lang dictionary_id='62026.Devamını oku'>...</a>
													</div> 
												</div>
												--->
												<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
													<div class="help_tour" style="background-color:#e1f5fe">
														<div class="help_tour_title">
															<a href="javascript://">Yenilikler</a>
															<a id="help_tour_next_news" href="javascript://"><i class="icon-angle-down"></i></a>
															<a id="help_tour_prev_news" href="javascript://"><i class="icon-angle-up"></i></a>	
														</div>
														<div class="help_tour_wrapper" id="help_tour_wrapper_news"></div>
													</div> 
												</div>
												<cfif attributes.fuseaction neq 'help.worktips'>
													<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
														<script>
															getTourList({help_fuseaction: "<cfoutput>#attributes.fuseaction#</cfoutput>"});
															getTourListNews({help_fuseaction: "", keyword: "", news: 1, startrow: 1, maxrows: 25});
														</script>
														<div class="help_tour">
															<div class="help_tour_title">
																<a href="javascript://"><cf_get_lang dictionary_id='62428.Worktips'></a>
																<a id="help_tour_next" href="javascript://"><i class="icon-angle-down"></i></a>
																<a id="help_tour_prev" href="javascript://"><i class="icon-angle-up"></i></a>	
															</div>
															<div class="help_tour_wrapper" id="help_tour_wrapper"></div>
														</div> 
													</div>
												</cfif>										
											</div>
										</div>
									</div>
									<div class="col col-5 col-md-5 col-sm-5 col-xs-12">
										<div class="interaction_menu_right">
											<ul>
												<li><a href="<cfoutput>#request.self#?fuseaction=help.wiki&meta_desc=#attributes.fuseaction#&form_submitted=1</cfoutput>" target="_blank" title="<cf_get_lang dictionary_id='60722.INHOUSE WIKI'>"><cf_get_lang dictionary_id='60722.Kurum İçi Wiki'></a></li>
												<li><a target="_blank" href="<cfoutput>#request.self#</cfoutput>?fuseaction=help.worktips" id="helpWorktips"><cf_get_lang dictionary_id='61526.Worktips'></a></li>
												<cfif len(workcube_license.implementation_project_domain) and len(workcube_license.implementation_project_id)>
													<li><cfoutput><a href="javascript://" id = "AddWorkLink" onclick = "window.open('#workcube_license.implementation_project_domain#/index.cfm?fuseaction=project.works&event=add&id=#workcube_license.implementation_project_id#&work_fuse=#attributes.fuseaction#','İş Ekle');">#getLang('','',57933)#</cfoutput></a></li>
												</cfif>
												
												
												<li><cfoutput><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_about_workcube','medium');"><cf_get_lang dictionary_id="48837.Sürüm Notları"></cfoutput></a></li>
												<li><a href="<cfoutput>#request.self#?fuseaction=settings.data_services</cfoutput>" target="_blank">Data Services</a></li>
												
												<cfif workcube_mode eq 0>
													<li><cfoutput><a href="javascript://" onclick="cfmodal('#request.self#?fuseaction=objects.emptypopup_add_test_page&fuseact=#attributes.fuseaction#&event=#iif(isDefined("attributes.event"),"attributes.event", de("list"))#','warning_modal');" title="<cf_get_lang dictionary_id="55085.Test kontrolü">"><cf_get_lang dictionary_id="55085.Test kontrolü"></cfoutput></a></li>
												</cfif>
												<li><a href="javascript://" title="<cfoutput>#getLang('','Uygulamanız Hakkında','60940')#</cfoutput>" onclick = "openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.workcube_license</cfoutput>');"><cfoutput>#getLang('','Uygulamanız Hakkında','60940')#</cfoutput></a></li>
												<cfif Data_Decleration.recordcount>
													<li><a href="javascript://"onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=myhome.approve</cfoutput>','','ui-draggable-box-large')" title="<cf_get_lang dictionary_id='64696.Kişisel Veri Aydınlatma Metni'>"><cf_get_lang dictionary_id='64696.Kişisel Veri Aydınlatma Metni'></a></li>
												</cfif>
												<li><a href="javascript://"onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=myhome.popup_dsp_kural</cfoutput>','dsp_kural', 'ui-draggable-box-large');"  title="<cf_get_lang dictionary_id='64841.Kullanım Kuralları'>"><cf_get_lang dictionary_id='64841.Kullanım Kuralları'></a></li>
												<li class="new"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=help.worktips&news=1"><cf_get_lang dictionary_id='61899.Yenilikler'></a></li>
												<!--- <li class="divider"></li> --->
												<li><cfoutput><a href="javascript://" id = "helpLink" onclick = "window.open('#request.self#?fuseaction=help.popup_add_problem&help=#attributes.fuseaction#','Destek Başvuru');">#getLang("help",'Sorun Bildir',55064)#</cfoutput></a></li>
												<li><a  href="https://wiki.workcube.com" target="_blank" title="<cfoutput>#getLang("myhome",'Eğitim ve Yardım Merkezi',31381)#</cfoutput>">wiki.workcube</a></li>
												<li><cfoutput><a href="https://project.workcube.com" target="_blank">project.workcube</cfoutput></a></li>
												<li><a  href="https://www.workcube.com/workcubetv" target="_blank" title="<cfoutput>#getLang("cubetv",'Workcube TV',52635)#</cfoutput>">workcube.tv</a></li>
												<li><a  href="https://www.workcube.com" target="_blank" title="Workcube Catalyst">workcube.com</a></li>
												<li><a  href="https://www.workcube.com/workcube-toplulugu" target="_blank" title="<cfoutput>#getLang("myhome",'Kullanıcı Topluluğu',31384)#</cfoutput>"><cf_get_lang dictionary_id='29994.Topluluk'></a></li>
												<!--- <li><a onclick="nModal({head:'<cfoutput>#getLang("myhome",626)#</cfoutput>',page:'<cfoutput>#request.self#</cfoutput>?fuseaction=help.popup_list_helpdesk&help=#attributes.fuseaction#',content:'626Content'});"  title="<cfoutput>#getLang("myhome",626)#</cfoutput>"><cfoutput>#getLang("myhome",626)#</cfoutput></a></li> --->
											</ul>
										</div>
									</div>
									<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
										<div class="help_tour_wrapper_pin">
											<div class="help_tour_pin_add">
												<a title="<cf_get_lang dictionary_id='63531.Tips Ekle'>" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.widget_loader&widget_load=addWorktips&is_box=1&box_title=<cf_get_lang dictionary_id='63531.Tips Ekle'>&fuseact=#attributes.fuseaction#</cfoutput>','','ui-draggable-box-medium')"><i class="fa fa-plus"></i></a>
											</div>
											<div class="help_tour_wrapper_pin_item"></div>
											<div class="help_tour_checkbox">
												<div class="checkbox checbox-switch">
													<label style="width:100%;position:relative;">
														<input type="checkbox" name="worktips_open" <cfif isdefined("session.ep.worktips_open") and session.ep.worktips_open eq 1>checked="checked"</cfif> />
														<span title="<cf_get_lang dictionary_id='63124.Tips Açık Çalış'>" style="position: absolute;right:0;top:-10px;"></span>
													</label>
												</div>	
											</div>
										</div>
									</div>
								</div>
							</li>
							<li class="dropdown"><a href="javascript://" class="catalyst-settings rightBarOpenBtn"  title="<cf_get_lang dictionary_id='29670.Kontrol Paneli'>" ><span class="menuTitle"><cf_get_lang dictionary_id='29670.Kontrol Paneli'></span></a></li>
						</ul>
					</nav>
				</div>
			</div>
		</div>
		<cfinclude template="../V16/objects/display/favourites.cfm"> <!--- Sık kullanılan kısayol tuş kombinasyonlarına her sayfadan ulaşabilmesi için eklendi --->
		<div id="mySidenav1" class="sidenav1"></div>
	</cfif>
		<span id="pm_badgeNone" class="badge badgeCount" style="display:none;"></span>
		
		<script type="text/javascript">
	<!---
		rightClick
			Sağ tık kullanılmaması istenen elemenler settings dizisine selector olarak ekleyin.
				---- !!!  Dikkat ----
				Selector eklemeden önce selectoru mutlaka kontrol edin
	
	---->
	
		var language = {
	
				diger			: 	"<cf_get_lang dictionary_id="58156.diğer">",
				gundem			: 	"<cf_get_lang dictionary_id="57413.gündem">",
				kolon			: 	"<cfoutput>#getLang('report',30)#</cfoutput>",
				aktif			: 	"<cf_get_lang dictionary_id="57493.aktif">",
				sadeceOkunur	: 	"<cfoutput>#getLang('settings',1750)#</cfoutput>",
				zorunlu			: 	"<cfoutput>#getLang('settings',3073)#</cfoutput>",
				kaydedildi		:	"<cf_get_lang dictionary_id="58890.Kaydedildi">",
				workcube_hata	:	"<cf_get_lang dictionary_id="58191.WorkCube Hata">",
				kaydediliyor    :	"<cf_get_lang dictionary_id="58889.Kaydediliyor">",
				BuKolonDuzenlenemez : "<cfoutput>#getLang('settings',1751)#</cfoutput>",
				tabMenu				: "<cfoutput>#getLang('settings',1752)#</cfoutput>",
				pageBar				: "Page Bar",
				seperatorAdi		: "<cfoutput>#getLang('settings',1768)#</cfoutput>",
				belge_numarası      : "<cfoutput>#getLang('sales',156)#</cfoutput>"
			}
	
	var settings = [
	
			'a[href="javascript:;"]',
			'a[href="javascript:void(0)"]',
			'a[href="javascript://"]',
			'a[href="#"]'
	
		];// settings
	
	$(function(){
		
		/* if( typeof window.localStorage.activeWindow === 'undefined' ) window.localStorage.setItem("");
		window.localStorage.activeWindow.push( document.title );
		console.log( window.localStorage.activeWindow ); */

		<cfif session.ep.menu_id eq 0>
			var standart = 'first';
		<cfelse>
			var standart = 'second';
		</cfif>
		<cfif session.ep.menu_id eq 0>
			<cfif not isdefined("personalMenu")>
				var menuSettings = { id: null, standart : standart, data : <cfoutput>#replace(serializeJSON(getMenuJSON),"//","")#</cfoutput> }; //menuSettings
			<cfelse>
				var menuSettings = { id: "<cfoutput>#session.ep.language#_#GET_USER_GROUP_MENU#</cfoutput>", standart : standart, data : null }; //menuSettings
			</cfif>
		<cfelse>
			var menuSettings = { id: null, standart : standart, data : <cfoutput>#replace(serializeJSON(getMenuJSON),"//","")#</cfoutput> }; //menuSettings
		 </cfif>
	
		var menu = menus( menuSettings );
	
			menu.leftMenu( $('#sidebar-menu') );
			menu.leftMenuSearch( $('#leftMenuSearch'), $('#responseSearch'), $('#sidebar-menu')  );
			//menu.headerMenu( $('#headerMenu') );
			//menu.headerMenuOther ( $('#headerMenu') );
			<!--- <cfif isdefined("attributes.event") and isdefined("WOStruct") and StructKeyExists(WOStruct['#attributes.fuseaction#'],attributes.event) and StructKeyExists(WOStruct['#attributes.fuseaction#']['#attributes.event#'],'fuseaction')>
				var panel = openPanel('<cfoutput>#WOStruct["#attributes.fuseaction#"]["#attributes.event#"]["fuseaction"]#</cfoutput>','<cfoutput>#XmlFuseaction#</cfoutput>');
			<cfelse>
				var panel = openPanel('<cfoutput>#attributes.fuseaction#</cfoutput>','<cfoutput>#attributes.fuseaction#</cfoutput>');
			</cfif> --->

			var panel = openPanel('<cfoutput>#attributes.fuseaction#</cfoutput>','<cfoutput>#xmlfuseaction#</cfoutput>');

	
			panel.leftPanel();   // sidebar left open function
			panel.rightPanel(); // sidebar right open function
			panel.userPanel(); // user panel open function
	
		openMenus().settingMenus();  // rightPanel Setting menu open function
		openMenus().treeMenu(); 	// sidebar left menu function
	
		pageBar('set,sort',$('section#pageBar') ); // pagebar
	
		menuControl(); // menu click control
	
		resizeControl(); // window resize control
		loadControl();	// window load control
		loadFav('','<cfoutput>#session.ep.userid#</cfoutput>');
	
		rightClickNone( settings ); // right click none function
	
		});//ready
	
		// warning bar kontrolleri
		function openNav(employeeid,divid,fuseaction) { // warning bar 
			$("#rightBarDiv").removeClass('rightBarOpen push');
			$("ul.tabNav li").removeClass('active');
			$("ul.tabNav li:first").addClass('active');
			$("ul.mobileMenu").css("display","none");
			var fuseact = 'myhome.popup_list_warning';
			if(fuseaction != ""){
				fuseact = fuseaction;
			}
			if(employeeid != ""){
				window.messagepageid = employeeid;
				AjaxPageLoad('index.cfm?fuseaction=objects.warningBarObjects&employee_id='+employeeid+'&divid='+divid+"&fuseact="+fuseact,'mySidenav1');
			}else AjaxPageLoad('index.cfm?fuseaction=objects.warningBarObjects&employee_id='+'&divid='+divid+"&fuseact="+fuseact,'mySidenav1');
		}
		
		function closeNav() { // warning bar
			document.getElementById("mySidenav").style.width = "0";
			document.getElementById("mySidenav1").style.width = "0";
		}

		<cfif isDefined("attributes.notEvent") and len(attributes.notEvent)>
			
			<cfif attributes.notEvent eq 'chat_page' and isDefined("attributes.emp_id") and len(attributes.emp_id)>
				openNav(<cfoutput>#attributes.emp_id#,'#attributes.notEvent#',''</cfoutput>);
				kapat();
			<cfelseif attributes.notEvent eq 'warning_page'>
				openNav(<cfoutput>'','#attributes.notEvent#',''</cfoutput>);
				warningKapat();
			</cfif>
			
		</cfif>
	
	</script>

	<!-- dsp_message içerisinden iframe kaldırıldığı için ajax ezilmeleri oluyor, o yüzden websocket ve chat fonksiyonları bu sayfaya alındı. -->

	<cfif cgi.https neq "on">
        <cfset wssecure = "false">
    <cfelse>
        <cfset wssecure = "true"> 
    </cfif>

    <cfwebsocket name="webSocketObj"
        onMessage="messageHandler"
        onError="errorHandler"
        onOpen="openHandler"
        onClose="closeHandler"
        useCfAuth="true"
        secure="#wssecure#"
        subscribeTo="chat.#my_id#"
	/>

	<cftry>
		<cfwebsocket name="ws_santral_control" onMessage="santral_control" subscribeTo="webphone" secure="#wssecure#"/>
		<cfcatch type="any"></cfcatch>
	</cftry>
	<script>
		function santral_control(listen)  {
			var socket_data = listen.data;
			<cfif getCallInformations.recordcount and getCallInformations.IS_CTI_INTEGRATED eq 1 and len(getCallInformations.api_key) and len(getCallInformations.extension)>
				var EXTENSION = <cfoutput>#getCallInformations.extension#</cfoutput>;
				try {
					if(EXTENSION == socket_data.EXTENSION ){
						<cfif attributes.fuseaction eq 'objects.phone'>
							AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=call.list_callcenter&form_submitted=1&webphone=1&tel=' + socket_data.CALLER_ID_NUMBER + '&MOBILTEL=' + socket_data.CALLER_ID_NUMBER,'item-contact');
						</cfif>
					}
				}
				catch(err) {}	
			</cfif>   
		}
	</script>
	<cfset encryptionKey ="dvayMin0XFT2PQp8PMinoA==" />
    <cfset raw = my_id&"/*/*/"&sender_type&"/*/*/"&receiver_type&"/*/*/"&DSN >
	<cfset ws_secret = encrypt(raw,encryptionKey,"AES","hex") />
	
	<script type="text/javascript">

		window.messageFiles = [];
		window.messagepageid = "";
		window.messageGroupid = "";
		window.messageGroupEmpid = [];
		window.messageEncKey = "";
		window.activeWindow = 0;
		var imageList = ["png","jpg","jpeg","gif"], windowPanelId = "";

		var hidden, visibilityChange;
		if (typeof document.hidden !== "undefined") { // Opera 12.10 and Firefox 18 and later support
			hidden = "hidden";
			visibilityChange = "visibilitychange";
		} else if (typeof document.msHidden !== "undefined") {
			hidden = "msHidden";
			visibilityChange = "msvisibilitychange";
		} else if (typeof document.webkitHidden !== "undefined") {
			hidden = "webkitHidden";
			visibilityChange = "webkitvisibilitychange";
		}

		function goBottom(id)
		{
			var element = document.getElementById(id);
			element.scrollTop = element.scrollHeight - element.clientHeight;
		}
		function convert(message)
		{
			var exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig;
			var text1=message.replace(exp, "<a style='color:blue;' target='_blank' href='$1'>$1</a>");
			var exp2 =/(^|[^\/])(www\.[\S]+(\b|$))/gim;
			return text1.replace(exp2, '$1<a style="color:blue;" href="http://$2" target="_blank">$2</a>');
		}

		function setNewMessage( messageOption ) {
			
			var date = new Date();
			date = date.getDate() +"/"+ date.getMonth() + "/" + date.getFullYear() + " - " + date.getUTCHours() + ":" + date.getUTCMinutes();

			if( messageOption.sender_info.group.group_id != '' ){ ///Grup Mesajı

				//Önceki mesajlaşmayı siler
				$("#groupMsgList ul.lightList li[data-id = " + messageOption.sender_info.group.group_id + "]").remove();
						
				//Mesajlarım listesinin en başına yeni mesajı oluşturur.
				$("<li>").attr({"data-id" : "" + messageOption.sender_info.group.group_id}).append(
					$("<div>").addClass("ContentRow col col-12 col-md-12 col-sm-12 col-xs-12").append(
						$("<a>").attr({ "href" : "javascript://", "onclick" : "get_all_messages('', "+messageOption.sender_info.group.group_id+")" }).append(
							$("<div>").append(
								$("<span>").addClass("avatextCt color-"+messageOption.sender_info.group.groupName.charAt(0)).append( $("<small>").addClass("avatext").html( messageOption.sender_info.group.groupName.charAt(0) ) ),
								$("<span>").addClass("UpRow").text(messageOption.sender_info.group.groupName),
								$("<span>").addClass("RightUpRow").text(date),
								$("<br>"),
								$("<span>").addClass("DownRow").text(messageOption.message_info.message.substring(0,40))
							)
						),
						$("<input>").attr({ 'title' : '+ ' + messageOption.sender_info.group.groupName, 'style' : 'display:none', 'type'  : 'checkbox', 'name'  : 'groupmessage'}).val( messageOption.sender_info.group.group_id ).addClass("pull-right checkbox")
					)
				).prependTo($("#groupMsgList ul.lightList"));
			
			}else if( Object.keys( messageOption.sender_info.visitor ).length != 0 ){ ///Protein ChatFlow mesajı

				//Önceki mesajlaşmayı siler
				$("#visitorMsgList ul.lightList li[data-id = " + messageOption.sender_info.visitor.enc_key + "]").remove();
						
				//Mesajlarım listesinin en başına yeni mesajı oluşturur.
				$("<li>").attr({"data-id" : messageOption.sender_info.visitor.enc_key}).append(
					$("<div>").addClass("ContentRow col col-12 col-md-12 col-sm-12 col-xs-12").append(
						$("<a>").attr({ "href" : "javascript://", "onclick" : "get_all_messages('','','"+messageOption.sender_info.visitor.enc_key+"')" }).append(
							$("<div>").append(
								$("<span>").addClass("avatextCt color-"+messageOption.sender_info.name.charAt(0)).append( $("<small>").addClass("avatext").html( messageOption.sender_info.name.charAt(0) + messageOption.sender_info.surname.charAt(0) ) ),
								$("<span>").addClass("UpRow").text(messageOption.sender_info.name +' ' + messageOption.sender_info.surname),
								$("<span>").addClass("RightUpRow").text(date),
								$("<br>"),
								$("<span>").addClass("DownRow").text(messageOption.message_info.message.substring(0,40))	
							)
						),
						$("<input>").attr({ 'title' : '+ ' + messageOption.sender_info.name +' ' + messageOption.sender_info.surname, 'style' : 'display:none', 'type'  : 'checkbox', 'name'  : 'multimessage'}).val( messageOption.sender_info.visitor.enc_key ).addClass("pull-right checkbox")
					)
				).prependTo($("#visitorMsgList ul.lightList"));

			}else{

				//Önceki mesajlaşmayı siler
				$("#LastMsgList ul.lightList li[data-id = " + messageOption.sender_info.sender_id + "]").remove();
						
				//Mesajlarım listesinin en başına yeni mesajı oluşturur.
				$("<li>").attr({"data-id" : messageOption.sender_info.sender_id}).append(
					$("<div>").addClass("ContentRow col col-12 col-md-12 col-sm-12 col-xs-12").append(
						$("<a>").attr({ "href" : "javascript://", "onclick" : "get_all_messages("+messageOption.sender_info.sender_id+")" }).append(
							$("<div>").append(
								$("<span>").addClass("avatextCt color-"+messageOption.sender_info.name.charAt(0)).append( $("<small>").addClass("avatext").html( messageOption.sender_info.name.charAt(0) + messageOption.sender_info.surname.charAt(0) ) ),
								$("<span>").addClass("UpRow").text(messageOption.sender_info.name +' ' + messageOption.sender_info.surname),
								$("<span>").addClass("RightUpRow").text(date),
								$("<br>"),
								$("<span>").addClass("DownRow").text(messageOption.message_info.message.substring(0,40))	
							)
						),
						$("<input>").attr({ 'title' : '+ ' + messageOption.sender_info.name +' ' + messageOption.sender_info.surname, 'style' : 'display:none', 'type'  : 'checkbox', 'name'  : 'multimessage'}).val( messageOption.sender_info.sender_id ).addClass("pull-right checkbox")
					)
				).prependTo($("#LastMsgList ul.lightList"));

			}

		}

		messageHandler =  function(aEvent,aToken) 
		{
			if (aEvent.data && aEvent.data.SENDER_ID)
			{

				var windowPanelSelector, dataId;

				if($("span#pm_badge:eq(1)").text() != "") $("span#pm_badge").text( parseInt($("span#pm_badge:eq(1)").text()[0]) + 1 ).show();
				else $("span#pm_badge").text( 1 ).show();
				
				var newMessage = (aEvent.data.MESSAGE != "") ? aEvent.data.MESSAGE : "Dosya gönderdi";
				var redirectUrl = "<cfoutput>#application.systemParam.systemParam().fusebox.server_machine_list#/#request.self#?fuseaction=objects.chatflow&tab=1</cfoutput>" + (aEvent.data.GROUP.GROUP_ID != '' ? '&subtab=3&group_id=' + aEvent.data.GROUP.GROUP_ID : ( aEvent.data.ENC_KEY != '' ? '&subtab=4&enc_key=' + aEvent.data.ENC_KEY : '&subtab=2&employee_id=' + aEvent.data.SENDER_ID)) + ""; 
				
				chatSettings = getChatStorage();

				if( chatSettings.isActive ){///Chatflow sayfası açıksa

					if( aEvent.data.GROUP.GROUP_ID != '' ){
						windowPanelSelector = "#groupMsgList .lightList";
						dataId = aEvent.data.GROUP.GROUP_ID;
					}else if( aEvent.data.ENC_KEY != '' ){
						windowPanelSelector = "#visitorMsgList .lightList";
						dataId = aEvent.data.ENC_KEY;
					}else{
						windowPanelSelector = "#LastMsgList .lightList";
						dataId = aEvent.data.SENDER_ID;
					}

					var nameSurname = $(""+ windowPanelSelector +" li[data-id = " + dataId + "] span.UpRow").text();
					if( aEvent.data.GROUP.GROUP_ID == '' ) nameSurname = nameSurname.split( ' ' );

					//Önceki mesaj sayısını alır - !!setNewMessage fonksiyonundan önce kullanılmalıdır.Çünkü aşağıdaki element fonk. içerisinde silinip yeniden üretiliyor.
					var oldMessageCount = $(""+ windowPanelSelector +" li[data-id = " + dataId + "] span.countm_badge").length != 0 
										? parseInt($(""+ windowPanelSelector +" li[data-id = " + dataId + "] span.countm_badge").text()) 
										: 0;

					setNewMessage({
						sender_info : { sender_id : aEvent.data.SENDER_ID, name : aEvent.data.GROUP.GROUP_ID == '' ? nameSurname[0] : '', surname : aEvent.data.GROUP.GROUP_ID == '' ? nameSurname[1] : '', group: { group_id: aEvent.data.GROUP.GROUP_ID, groupName: nameSurname }, visitor: aEvent.data.ENC_KEY != '' ? { enc_key: aEvent.data.ENC_KEY } : {} },
						message_info : { message : newMessage } 
					});

					//Yeni mesaj sayısını mesaj listesine yazar - !!setNewMessage fonksiyonundan sonra kullanılmalıdır.
					if( 
							( aEvent.data.GROUP.GROUP_ID != '' && window.messageGroupid != aEvent.data.GROUP.GROUP_ID )
						||	( aEvent.data.ENC_KEY != '' && window.messageEncKey != aEvent.data.ENC_KEY )
						||	( aEvent.data.GROUP.GROUP_ID == '' && aEvent.data.ENC_KEY == '' && window.messagepageid != aEvent.data.SENDER_ID) 
					){
						oldMessageCount++;
						$(""+ windowPanelSelector +" li[data-id = " + dataId + "] input[ type = checkbox ]").after('<span class="countm_badge badge">' + oldMessageCount + '</span>');
					}

					if( 
						document.getElementById("new_message") != undefined 
						&& (
							(aEvent.data.GROUP.GROUP_ID != '' && window.messageGroupid == aEvent.data.GROUP.GROUP_ID)	
							||	( aEvent.data.ENC_KEY != '' && window.messageEncKey == aEvent.data.ENC_KEY )
							||	( aEvent.data.GROUP.GROUP_ID == '' && aEvent.data.ENC_KEY == '' && window.messagepageid == aEvent.data.SENDER_ID)
						)
					){

						var txt = document.getElementById("new_message");
						var messageOption = '<div class="message_option meYouTop5 message_option_you"><ul><li><a href="javascript://"><i class="fa fa-ellipsis-h"></i></a><ul><li><a href="javascript://" onclick="forwardMessage(' + aEvent.data.MESSAGE_ID + ')"><i class="fa fa-location-arrow"></i><cf_get_lang dictionary_id='51096.İlet'></a></li><li><a href="javascript://" onclick="removeMessage(' + aEvent.data.MESSAGE_ID + ')"><i class="fa fa-trash"></i><cf_get_lang dictionary_id='57463.Sil'></a></li></ul></li></ul></div>';
						var forwardTemp = aEvent.data.MESSAGESTATUS.IS_DELIVERED ? '<div class="forwardIcon_you ' + (aEvent.data.FILE.ISFILE ? "meYouTop60" : "meYouTop30") + '"><i class="fa fa-share"></i></div>' : '';
						
						if( aEvent.data.FILE.ISFILE ){
							aEvent.data.FILE.DATA.forEach((el) => {
								var txt = document.getElementById("new_message");
								var imgsrcdownload = 'messageFiles/' + el.fullEncryptedName;
								<cfsavecontent variable="bbb"><cf_get_server_file output_file="'+imgsrcdownload+'" output_server="1" output_type="6" image_link="1"></cfsavecontent>
								<cfset bbb = replaceNoCase(bbb,chr(13),' ','All')>
								<cfset bbb = replaceNoCase(bbb,chr(10),' ','All')>
								var fileContent = ( imageList.indexOf(el.ext.toLowerCase()) != -1 ) ? '<img src="documents/messageFiles/'+ el.fullEncryptedName +'" width="280" height="auto" />' : '<img src="css/assets/icons/catalyst-icon-svg/'+ el.ext.toUpperCase() +'.svg" width="40" height="auto" /><span style="color:rgba(0,0,0,.5);font-weight:bold;margin:0 0 0 10px;">'+ el.fileName +'</span>';
								txt.innerHTML += '<div class="bubble_block" id="message_'+ aEvent.data.MESSAGE_ID +'"><div class="bubble_checkbox_panel"><input type="checkbox" name="bubble_checkbox" value="' + aEvent.data.MESSAGE_ID + '"></div><div title="<cfoutput>#dateformat(now(),dateformat_style)#-#timeformat(now(),timeformat_style)#</cfoutput>" class="bubble wrap you">' + messageOption + '<div class="download_you meYouTop30"><cfoutput>#bbb#</cfoutput></div>'+ fileContent + forwardTemp + ((aEvent.data.MESSAGE != '') ? '<div class="file_message">' + convert( aEvent.data.MESSAGE ) + '</div>' : "") +'<div style="margin-top:12px;"><cfoutput>#dateformat(now(),dateformat_style)#-#timeformat(now(),timeformat_style)#</cfoutput></div></div></div>';
							});
						}else if( aEvent.data.MESSAGE != "" ){
							txt.innerHTML += '<div class="bubble_block" id="message_'+ aEvent.data.MESSAGE_ID +'"><div class="bubble_checkbox_panel"><input type="checkbox" name="bubble_checkbox" value="' + aEvent.data.MESSAGE_ID + '"></div><div title="<cfoutput>#dateformat(now(),dateformat_style)#-#timeformat(now(),timeformat_style)#</cfoutput>" class="bubble wrap you">' + messageOption + '<span>' + aEvent.data.MESSAGE + '</span>' + forwardTemp + '<div style="margin-top:10px;"><cfoutput>#dateformat(now(),dateformat_style)#-#timeformat(now(),timeformat_style)#</cfoutput></div></div></div>';
						}

						$.ajax({url: "V16/objects/cfc/messages.cfc?method=isalerted", type: "POST", data: { employee_id : aEvent.data.SENDER_ID, group_id: aEvent.data.GROUP.GROUP_ID, enc_key: aEvent.data.ENC_KEY }});

						goBottom('all_messages');

					}else{
						createNotification({
							title : "<cf_get_lang dictionary_id='63586.Yeni bir mesajınız var'>!",
							content : newMessage,
							redirecturl : redirectUrl
						});
						window.warningCounter.chatCounter++; //wrkTemplate.cfm'de tanımı vardır!
					}

				}else{
					createNotification({
						title : "<cf_get_lang dictionary_id='63586.Yeni bir mesajınız var'>!",
						content : newMessage,
						redirecturl : redirectUrl
					});
					window.warningCounter.chatCounter++; //wrkTemplate.cfm'de tanımı vardır!
				}

				if( document.title.toLowerCase().includes('workflow') || document.title.toLowerCase().includes('chatflow') ){
					if( document.title.toLowerCase().includes('workflow') ) pageTitle = 'WorkFlow';
					else if( document.title.toLowerCase().includes('chatflow') ) pageTitle = document["hidden"] ? ( '( ' + newMessage + ' ) ChatFlow') : 'ChatFlow';
					else pageTitle = document.title;
					setWarningCounts( window.warningCounter.chatCounter, window.warningCounter.warningCounter, pageTitle );
				}

			}	
			
		}

		openHandler = function() {
			//alert("Bağlandı");
		}

		closeHandler= function() {
			//alert("Websocket kapatıldı");
		}

		errorHandler = function(error) 
		{
			if(window.last_message) 
			{
				document.getElementById('text_area').value = window.last_message;
				alert("<cf_get_lang dictionary_id='40129.Gönderilemedi'>");
				console.log(error);
			}
			else 
			{
				alert("Websocket <cf_get_lang dictionary_id='57541.Hata'>!");
			}
		}
		
		sendMessage = function( isForward = false, isDeleted = false, messageText = "", group_id = "", visitor = {} ) {
			
			var message = messageText,
				fileMessage = "",
				messagetype = false,
				receiverid = [];

			if( !isForward ){
				message = $.trim($("#text_area").val());
				fileMessage = $.trim($("#fileMessage").val());
			}

			if (window.multi_message_show) {

				$.each($("input[name='multimessage']:checked"), function(){
					receiverid.push($(this).val());
					messagetype = true;
				});
				
			}else{
				receiverid = (group_id == '' && Object.keys( visitor ).length === 0) ? [window.messagepageid] : (window.messageGroupEmpid.length ? window.messageGroupEmpid : [visitor.visitor_key]);
				messagetype = false;
			}

			if (message != "" || fileMessage != "" || window.messageFiles.length > 0) {

				function wssend(receiverid, messageContent, addMessage = true) {
					
					var channel = 'chat.'+receiverid;
					messageContent.addMessage = addMessage;
					var headers = {
						receiver_id: receiverid,
						token: "<cfoutput>#ws_secret#</cfoutput>",
						msgContent: messageContent
					}
					response = webSocketObj.publish(channel, messageContent.message, headers);
					
					if( response && addMessage ){

						function setMyMessage( receiverid, callback ) {
							var data = new FormData();
							if( group_id != '' ) data.append('group_id', group_id);
							else if( Object.keys( visitor ).length != 0 ) data.append('enc_key', visitor.enc_key);
							else data.append('employee_id', receiverid);
							AjaxControlPostDataJson( "V16/objects/cfc/messages.cfc?method=get_last_messages", data, callback);	
						}

						setMyMessage( receiverid, function ( resp ) {

							if( resp.length ){
								if (!messagetype){
									var txt = document.getElementById("new_message");
									var messageOption = '<div class="message_option meYouTop5 message_option_me"><ul><li><a href="javascript://"><i class="fa fa-ellipsis-h"></i></a><ul><li><a href="javascript://" onclick="forwardMessage(' + resp[0].WRK_MESSAGE_ID + ')"><i class="fa fa-location-arrow"></i><cf_get_lang dictionary_id='51096.İlet'></a></li><li><a href="javascript://" onclick="removeMessage(' + resp[0].WRK_MESSAGE_ID + ')"><i class="fa fa-trash"></i><cf_get_lang dictionary_id='57463.Sil'></a></li></ul></li></ul></div>';
									
									if( messageContent.isFile ){
										var el = messageContent.file;
										var txt = document.getElementById("new_message");
										var imgsrcdownload = 'messageFiles/' + el.fullEncryptedName;
										<cfsavecontent variable="aaa"><cf_get_server_file output_file="'+imgsrcdownload+'" output_server="1" output_type="6" image_link="1"></cfsavecontent>
										<cfset aaa = replaceNoCase(aaa,chr(13),' ','All')>
										<cfset aaa = replaceNoCase(aaa,chr(10),' ','All')>
										var fileContent = ( imageList.indexOf(el.ext.toLowerCase()) != -1 ) ? '<img src="documents/messageFiles/'+ el.fullEncryptedName +'" width="280" height="auto" />' : '<img src="css/assets/icons/catalyst-icon-svg/'+ el.ext.toUpperCase() +'.svg" width="40" height="auto" /><span style="color:rgba(0,0,0,.5);font-weight:bold;margin:0 0 0 10px;">'+ el.fileName +'</span>';
										$( txt ).html( $( txt ).html() + '<div class="bubble_block" id="message_' + resp[0].WRK_MESSAGE_ID + '"><div class="bubble_checkbox_panel"><input type="checkbox" name="bubble_checkbox" value="' + resp[0].WRK_MESSAGE_ID + '"></div><div title="<cfoutput>#dateformat(now(),dateformat_style)#-#timeformat(now(),timeformat_style)#</cfoutput>" class="bubble wrap me">' + messageOption + '<div class="download_me meYouTop30"><cfoutput>#aaa#</cfoutput></div>'+ fileContent + ((fileMessage != "") ? '<div class="file_message">' + convert( fileMessage ) + '</div>' : "") + '<div style="margin-top:12px;"><cfoutput>#dateformat(now(),dateformat_style)#-#timeformat(now(),timeformat_style)#</cfoutput></div></div></div>' );
									}
									if( message != "" ) txt.innerHTML += '<div class="bubble_block" id="message_' + resp[0].WRK_MESSAGE_ID + '"><div class="bubble_checkbox_panel"><input type="checkbox" name="bubble_checkbox" value="' + resp[0].WRK_MESSAGE_ID + '"></div><div title="<cfoutput>#dateformat(now(),dateformat_style)#-#timeformat(now(),timeformat_style)#</cfoutput>" class="bubble wrap me">' + messageOption + '<span>'+ convert( message ) +'</span><div style="margin-top:10px;"><cfoutput>#dateformat(now(),dateformat_style)#-#timeformat(now(),timeformat_style)#</cfoutput></div></div></div>';
									
									goBottom('all_messages');

								}else if( !isForward ){
									alert('<cf_get_lang dictionary_id='32576.Toplu Mesaj'> <cf_get_lang dictionary_id='48306.Gönderildi'>');
								}
							}

						});

					}

					switch (window.activeWindow) {
						case 1: 
							windowPanelSelector = "#onlineUserList .OnlineuserListLeft";
							dataId = receiverid;
						break;
						case 2: 
							windowPanelSelector = "#LastMsgList .lightList";
							dataId = receiverid;
						break;
						case 3: 
							windowPanelSelector = "#userListLeft .userListLeft";
							dataId = receiverid;
						break;
						case 4: 
							windowPanelSelector = "#groupMsgList .lightList";
							dataId = window.messageGroupid;
						break;
						case 5: 
							windowPanelSelector = "#visitorMsgList .lightList";
							dataId = visitor.enc_key;
						break;
					}

					var nameSurname = $(""+ windowPanelSelector +" li[data-id = " + dataId + "] span.UpRow")[0].innerText;
					var newMessage = (messageContent.message != "") ? messageContent.message : "Dosya gönderdi";
					if( group_id == '' ) nameSurname = nameSurname.split( ' ' );

					setNewMessage({
						sender_info : { sender_id : receiverid, name : group_id == '' ? nameSurname[0] : '', surname : group_id == '' ? nameSurname[1] : '', group: { group_id: group_id, groupName: nameSurname }, visitor: visitor },
						message_info : { message : newMessage }
					});

				}
				
				var totalMessage = [];
				if( window.messageFiles.length ){
					window.messageFiles.forEach((el) => {
						totalMessage.push({
							message : fileMessage,
							messageStatus: { isDeleted: isDeleted, isForward: isForward },
							isFile : true,
							file : el,
							group: { group_id: group_id, groupUsers: window.messageGroupEmpid },
							enc_key: Object.keys( visitor ).length != 0 ? visitor.enc_key : ''
						});
					});
				}
				if( message ){
					totalMessage.push({ 
						message : message, 
						messageStatus: { isDeleted: isDeleted, isForward: isForward }, 
						isFile : false, 
						group: { group_id: group_id, groupUsers: window.messageGroupEmpid }, 
						enc_key: Object.keys( visitor ).length != 0 ? visitor.enc_key : '' 
					});
				}

				receiverid.forEach((rec, index) => {
					totalMessage.forEach(ttm => {
						wssend(rec, ttm, (group_id != '' && index > 0) ? false : true );
					});
				});

				window.last_message = document.getElementById('text_area').value;
				document.getElementById('text_area').value = '';
				document.getElementById('fileMessage').value = '';

				if( !isForward && window.messageFiles.length ){
					var objDZ = Dropzone.forElement("#file-dropzone");
					objDZ.emit("resetFiles");
					$("#upload_modal a.catalystClose").click();
				}

				window.messageFiles = [];
				$("#messages-body").css({ "height" : "calc(100% - (60px))" });
			}
		}

		setChatStorage = function( option ){
			if (typeof(Storage) !== "undefined") {
				localStorage.setItem('chatflow', JSON.stringify( option ));
			}
		}

		getChatStorage = function() {
			return (typeof(Storage) !== "undefined") ? JSON.parse( localStorage.getItem('chatflow') ) : {};
		}

		chatFlowSettings = function () {
			if( !document[hidden] && document.title.toLowerCase().includes('chatflow') ){ //Chatflow sayfası açıksa
				
				setWarningCounts( window.warningCounter.chatCounter, window.warningCounter.warningCounter, 'ChatFlow' );
				setChatStorage({ isActive: true });

			}else setChatStorage({ isActive: false });
		}

		document.addEventListener(visibilityChange, () => { chatFlowSettings() }, false);

		setTimeout(() => { chatFlowSettings(); }, 2000);

		function multi_message_display(){
			if (window.multi_message_show) 
			{
				$.each($(".person-list input[name='multimessage']"), function(){$(this).hide();});
				window.multi_message_show = 0;
			}
			else 
			{
				$.each($(".person-list input[name='multimessage']"), function(){$(this).show();});
				window.multi_message_show = 1;
			}
		}

		$.fn.lazyimagemenu = function( options ) {
			var self = this;
			$( self ).hover( 
			function() {
				var images = $( self ).find( options.images );
				
				$( images ).each(function(){
					$(this).attr( "src", $( this ).attr( "data-src" ) );
				});
			},

			function() {
			$( self ).unbind( 'mouseenter mouseleave' );
			}
		)}
	
		$(".lzymg").lazyimagemenu({images: "img.img-circle"});     
		
		$("input[name=worktips_open]").change(function() {
			var ischecked= $(this).is(':checked');
			var data = new FormData();
			if(ischecked == true){		
				data.append('worktips_open',1);
				AjaxControlPostData( 'cfc/right_menu_fnc.cfc?method=UPDATE_WORKTIPS_OPEN', data, function( response ){
					location.reload();
				});		
			}
			else if (ischecked == false){
				data.append('worktips_open',0);
				AjaxControlPostData( 'cfc/right_menu_fnc.cfc?method=UPDATE_WORKTIPS_OPEN', data, function( response ){
					location.reload();
				});	
				$('.tour_pin').hide();
			}
		}); 
	</script>