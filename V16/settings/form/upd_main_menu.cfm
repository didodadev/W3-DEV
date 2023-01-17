<cfquery name="GET_MAIN_MENU" datasource="#DSN#">
	SELECT 
    	MENU_ID,
    	#dsn#.Get_Dynamic_Language(MAIN_MENU_SETTINGS.MENU_ID,'#session.ep.language#','MAIN_MENU_SETTINGS','MENU_NAME',NULL,NULL,MAIN_MENU_SETTINGS.MENU_NAME) AS MENU_NAME,
        IS_ACTIVE,
        IS_ALPHABETIC,
        IS_PUBLISH,
        MAIN_FILE,
        SECOND_FILE,
        FOOTER_FILE,
        MYHOME_FILE,
        LOGIN_FILE,
        SABLON_FILE,
        GENERAL_WIDTH,
        GENERAL_WIDTH_TYPE,
        GENERAL_ALIGN,
        LEFT_MARJIN,
        TOP_MARJIN,
        LEFT_INNER_MARJIN,
        TOP_INNER_MARJIN,
        BACKGROUND_COLOR,
        BACKGROUND_FILE,
        BACKGROUND_FILE_SERVER_ID,
        COLOR_CONTENT_MENU,
        CONTENT_MENU_BACKGROUND,
        CONTENT_MENU_BG_SERVER_ID,
        LOGO_WIDTH,
        LOGO_HEIGHT,
        LOGO_FILE,
        LOGO_FILE_SERVER_ID,
        CSS_FILE,
        LANGUAGE_ID,
        SITE_DOMAIN,
        IS_LOGO,
        IS_FLASH_LOGO,
        IS_TREE_MENU,
        IS_PASSWORD_CONTROL,
        IS_LOGO_BLOCK,
        MAIN_HEIGHT,
        MAIN_ALIGN,
        MAIN_VALIGN,
        SECOND_HEIGHT,
        SECOND_ALIGN,
        FOOTER_HEIGHT,
        FOOTER_ALIGN,
        FOOTER_VALIGN,
        COLOR_TOP_MENU,
        TOP_MENU_BACKGROUND,
        TOP_MENU_BACKGROUND_SERVER_ID,
        COLOR_CENTER_MENU,
        CENTER_MENU_BACKGROUND,
        CENTER_MENU_BG_SERVER_ID,
        COLOR_BOTTOM_MENU,
        BOTTOM_MENU_BACKGROUND,
        BOTTOM_MENU_BG_SERVER_ID,
        COLOR_FOOTER_MENU,
        FOOTER_MENU_BACKGROUND,
        FOOTER_MENU_BG_SERVER_ID,
        AYRAC_TEXT,
        AYRAC_WIDTH,
        AYRAC_BUTON,
        AYRAC_BUTON_SERVER_ID,
        AYRAC_LEFT,
        RECORD_EMP,
        RECORD_DATE,
        UPDATE_EMP,
        UPDATE_DATE,
        SITE_TYPE,
        SITE_TITLE,
        SITE_KEYWORDS,
        SITE_HEADERS,
        SITE_DESCRIPTION,
        APP_KEY,
        STD_DESCRIPTION,
        USER_GROUP_IDS,
        POSITION_CAT_IDS,
        COMPANY_CAT_IDS,
        CONSUMER_CAT_IDS,
        STOCK_TYPE,
        DEPARTMENT_IDS       
    FROM 
    	MAIN_MENU_SETTINGS 
    WHERE 
    	MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
</cfquery>
<cfquery name="GET_DEPARTMENT" datasource="#DSN#">
	SELECT DEPARTMENT_ID,DEPARTMENT_HEAD FROM DEPARTMENT WHERE IS_STORE <> 2 AND DEPARTMENT_STATUS = 1 <cfif isDefined("attributes.branch_id")> AND BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> </cfif> ORDER BY DEPARTMENT_HEAD
</cfquery>
<cfquery name="GET_USER_GROUPS" datasource="#DSN#">
	SELECT USER_GROUP_ID,USER_GROUP_NAME FROM USER_GROUP ORDER BY USER_GROUP_NAME
</cfquery>
<cfquery name="GET_COMPANY_CAT" datasource="#DSN#">
	SELECT COMPANYCAT_ID,COMPANYCAT FROM COMPANY_CAT ORDER BY COMPANYCAT
</cfquery>
<cfquery name="GET_CONSUMER_CAT" datasource="#DSN#">
	SELECT CONSCAT_ID,CONSCAT FROM CONSUMER_CAT ORDER BY CONSCAT
</cfquery>
<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_STATUS = 1 ORDER BY POSITION_CAT
</cfquery>
<cfquery name="GET_MAIN_MENU_SELECT" datasource="#DSN#">
	SELECT 
    	MENU_ID,
    	SELECTED_ID, 
        LINK_NAME_TYPE, 
        LINK_NAME, 
        SELECTED_LINK, 
        LINK_AREA, 
        LINK_TYPE,
        LINK_IMAGE,
        LINK_IMAGE_SERVER_ID, 
        ORDER_NO, 
        IS_SESSION, 
        LOGIN_CONTROL 
    FROM 
    	MAIN_MENU_SELECTS 
    WHERE 
    	MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
</cfquery>
<cfquery name="GET_LANGUAGES" datasource="#DSN#">
	SELECT LANGUAGE_SHORT FROM SETUP_LANGUAGE
</cfquery>
<!--- <table border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td class="headbold" height="35"><cf_get_lang no ='1421.Site Tasarımcısı'>: <cfoutput>#get_main_menu.menu_name#</cfoutput></td>
	</tr>
	<tr>
		<td colspan="2">
            <table border="0" cellpadding="2" cellspacing="1" class="color-border" style="height:25px;"> 
                <tr class="color-row" align="center">
                    <td onmouseover="this.className='hand_cursor';" onclick="gizle_goster(general);"><cf_get_lang no ='2450.Genel Ayarlar'></td>
                    <td onmouseover="this.className='hand_cursor';" onclick="gizle_goster(design);"><cf_get_lang no ='2451.Tasarım Ayarları'></td>  
                    <td onmouseover="this.className='hand_cursor';" onclick="gizle_goster(site);"><cf_get_lang_main no='1564.Meta Tanımları'></td>
                    <td onmouseover="this.className='hand_cursor';" onclick="gizle_goster(access);" ><cf_get_lang no ='2453.Erişim - Yetkilendirme'></td>
                    <td onmouseover="this.className='hand_cursor';" onclick="gizle_goster(link);"><cf_get_lang no ='2454.Menü ve Linkler'></td>
                    <!--- Controllera ekle ---> 
                    <td>	
                        <cfoutput>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_dsp_main_menu&menu_id=#attributes.menu_id#','page');"><img src="/images/elements.gif" border="0" alt="Menü Hiyerarşileri" title="Menü Hiyerarşileri"></a>
                            <a href="#request.self#?fuseaction=settings.list_site_layouts&menu_id=#attributes.menu_id#"><img src="/images/sourcecode.gif" border="0" alt="<cf_get_lang no ='1456.Sayfa Tasarımı'>" title="<cf_get_lang no ='1456.Sayfa Tasarımı'>"></a>
                            <a href="#request.self#?fuseaction=settings.emptypopup_copy_main_menu&menu_id=#attributes.menu_id#"><img src="/images/plus.gif" border="0" alt="<cf_get_lang_main no ='64.Menüyü Kopyala'>" title="<cf_get_lang_main no ='64.Menüyü Kopyala'>"></a>
                        </cfoutput>
                    </td>
                </tr>
            </table>
		</td>
	</tr>
</table> --->
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="user_group" action="#request.self#?fuseaction=settings.emptypopup_upd_main_menu" method="post" enctype="multipart/form-data" onsubmit="newRows()">
            <input name="menu_id" id="menu_id" type="hidden" value="<cfoutput>#get_main_menu.menu_id#</cfoutput>">
            <cfsavecontent  variable="head"><cf_get_lang no ='2450.Genel Ayarlar'></cfsavecontent>
            <cf_seperator title="#head#" id="general">
            <div id="general">
                <cf_box_elements>
                    <cfoutput>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="checkbox" name="is_active" id="is_active" value="1" <cfif get_main_menu.is_active eq 1>checked</cfif>><cf_get_lang_main no='81.Aktif'></label>
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="checkbox" name="is_alphabetic" id="is_alphabetic" value="1" <cfif get_main_menu.is_alphabetic eq 1>checked</cfif>><cf_get_lang no='889.Alfabetik'></label>
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="checkbox" name="is_publish" id="is_publish" value="1" <cfif get_main_menu.is_publish eq 1>checked</cfif>><cf_get_lang no ='2456.Bakım'> / <cf_get_lang_main no='1682.Yayın'></label>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='891.Menü'> *</label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                    <div class="input-group">
                                        <cfsavecontent variable="menu_name"><cf_get_lang no ='2455.Menü Adı Girmelisiniz'></cfsavecontent>
                                            <cfinput type="text" name="menu_name" value="#get_main_menu.menu_name#" required="yes" message="#menu_name#" maxlength="100">
                                            <cfif isDefined('attributes.menu_id')>
                                                <span class="input-group-addon">
                                                    <cf_language_info 
                                                        table_name="MAIN_MENU_SETTINGS" 
                                                        column_name="MENU_NAME" 
                                                        column_id_value="#attributes.menu_id#" 
                                                        maxlength="500" 
                                                        datasource="#dsn#" 
                                                        column_id="MENU_ID" 
                                                        control_type="0">
                                                </span>
                                            </cfif>
                                    </div>
                                    
                                    
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2459.Üst Menü Dosyası'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="main_file" id="main_file" value="#get_main_menu.main_file#"></div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="form-group">
                                <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><input type="radio" name="site_type" id="site_type" value="1" <cfif get_main_menu.site_type eq 1>checked</cfif>><cf_get_lang no ='2807.Çalışan Portalı'></label>
                                <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><input type="radio" name="site_type" id="site_type" value="2" <cfif get_main_menu.site_type eq 2>checked</cfif>><cf_get_lang no ='2805.Üye Portalı'></label>
                                <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><input type="radio" name="site_type" id="site_type" value="3" <cfif get_main_menu.site_type eq 3>checked</cfif>><cf_get_lang no ='2458.Kariyer Portalı'></label>
                                <label class="col col-3 col-md-3 col-sm-3 col-xs-12"><input type="radio" name="site_type" id="site_type" value="4" <cfif get_main_menu.site_type eq 4>checked</cfif>><cf_get_lang no='3169.PDA Portalı'></label>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2460.Alt Menü Dosyası'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="second_file" id="second_file" value="#get_main_menu.second_file#"></div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2461.Footer Menü Dosyası'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="footer_file" id="footer_file" value="#get_main_menu.footer_file#"></div>
                            </div>
                        </div>
                        <div class="col col-4 col-md-4 col-sm-6 col-xs-12">
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2462.Giriş Sayfası Dosyası'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="myhome_file" id="myhome_file" value="#get_main_menu.myhome_file#"></div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2463.Login Page Dosyası'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="login_file" id="login_file" value="#get_main_menu.login_file#"></div>
                            </div>
                            <div class="form-group">
                                <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2464.Genel Şablon Dosyası'></label>
                                <div class="col col-8 col-md-8 col-sm-8 col-xs-12"><input type="text" name="sablon_file" id="sablon_file" value="#get_main_menu.sablon_file#"></div>
                            </div>
                        </div>
                    </cfoutput>
                </cf_box_elements>
            </div>
            <cfsavecontent  variable="head"><cf_get_lang no ='2451.Tasarım Ayarları'></cfsavecontent>
            <cf_seperator title="#head#" id="design">
            <div id="design">
                <cf_box_elements>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <div class="form-group">
                            <label class="bold col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='1456.Sayfa Tasarımı'></label>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='1301.Sayfa Genişliği'></label>
                            <cfsavecontent variable="area_with"><cf_get_lang no ='2465.20-1280 Arası Alan Genişliği Girmelisiniz'></cfsavecontent>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                <cfinput type="text" name="general_width" id="general_width" value="#get_main_menu.general_width#" onKeyUp="isNumber(this);" validate="integer" message="#area_with#" maxlength="4" range="20,1280">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <select name="general_width_type" id="general_width_type">
                                    <option value="%" <cfif get_main_menu.general_width_type is '%'>selected</cfif>>%</option>
                                    <option value="px" <cfif get_main_menu.general_width_type is 'px'>selected</cfif>>px</option>
                                </select>
                            </div>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                <select name="general_align" id="general_align">
                                    <option value="left" <cfif get_main_menu.general_align is 'left'>selected</cfif>><cf_get_lang no ='894.Sola Daya'></option>
                                    <option value="right" <cfif get_main_menu.general_align is 'right'>selected</cfif>><cf_get_lang no ='895.Sağa Daya'></option>
                                    <option value="center" <cfif get_main_menu.general_align is 'center'>selected</cfif>><cf_get_lang_main no ='96.Ortala'></option>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='705.Marjin'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <span class="input-group-addon"><cf_get_lang no ='1309.Sol'></span>
                                    <cfinput type="text" name="left_marjin" id="left_marjin" validate="integer" maxlength="2" value="#get_main_menu.left_marjin#" onKeyUp="isNumber(this);">
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <span class="input-group-addon"><cf_get_lang_main no='573.Üst'></span>
                                    <cfinput type="text" name="top_marjin" id="top_marjin" validate="integer" maxlength="2" value="#get_main_menu.top_marjin#" onKeyUp="isNumber(this);">
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2466.İç Marjin'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <span class="input-group-addon"><cf_get_lang no ='1309.Sol'></span>
                                    <cfinput type="text" name="left_inner_marjin" id="left_inner_marjin" validate="integer" maxlength="2" value="#get_main_menu.left_inner_marjin#" onKeyUp="isNumber(this);">
                                </div>
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <span class="input-group-addon"><cf_get_lang_main no='573.Üst'></span>
                                    <cfinput type="text" name="top_inner_marjin" id="top_inner_marjin" validate="integer" maxlength="2" value="#get_main_menu.top_inner_marjin#" onKeyUp="isNumber(this);"> 
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2467.Body Arkaplan'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <cf_workcube_color_picker name="background_color" value="#get_main_menu.background_color#" width="50">
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <input type="file" name="background_file" id="background_file">
                                    <input type="hidden" name="old_background_file" id="old_background_file" value="<cfoutput>#get_main_menu.background_file#</cfoutput>">
                                    <input type="hidden" name="old_background_file_server_id" id="old_background_file_server_id" value="<cfoutput>#get_main_menu.background_file_server_id#</cfoutput>">
                                    <cfif len(get_main_menu.background_file)>
                                        <span class="input-group-addon" href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=settings.emptypopup_del_background_files&menu_id=#get_main_menu.menu_id#&type=BACKGROUND_FILE&type_server_id=BACKGROUND_FILE_SERVER_ID</cfoutput>','small');"><i class="fa fa-minus"></i></span>
                                    <cfelse>
                                </div>
                                </cfif>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2468.İçerik Arkaplan'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <cf_workcube_color_picker name="color_content_menu" value="#get_main_menu.color_content_menu#" width="50">
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <input type="file" name="content_menu_background" id="content_menu_background">
                                    <input type="hidden" name="old_content_menu_background" id="old_content_menu_background" value="<cfoutput>#get_main_menu.content_menu_background#</cfoutput>">
                                    <input type="hidden" name="old_content_menu_background_server_id" id="old_content_menu_background_server_id" value="<cfoutput>#get_main_menu.content_menu_bg_server_id#</cfoutput>">
                                    <cfif len(get_main_menu.content_menu_background)>
                                        <span class="input-group-addon" href="javascript://" <cfoutput>onClick="windowopen('#request.self#?fuseaction=settings.emptypopup_del_background_files&menu_id=#get_main_menu.menu_id#&type=CONTENT_MENU_BACKGROUND&type_server_id=CONTENT_MENU_BG_SERVER_ID','small');"</cfoutput>><i class="fa fa-minus"></i></span>
                                    <cfelse>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1225.Logo'>(PX)</label>
                            <cfsavecontent variable="width">10px-1000px<cf_get_lang no ='2469.Arası Alan Yüksekliği-Genişiliği Girmelisiniz'></cfsavecontent>
                            <cfsavecontent variable="haigth">10px-200px<cf_get_lang no ='2469.Arası Alan Yüksekliği-Genişiliği Girmelisiniz'></cfsavecontent>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <cfinput type="text" name="logo_width" id="logo_width" value="#get_main_menu.logo_width#" validate="integer" message="#width#" maxlength="3" range="10,1000" onKeyUp="isNumber(this);">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <cfinput type="text" name="logo_height" id="logo_height" value="#get_main_menu.logo_height#" validate="integer" message="#haigth#" maxlength="3" range="10,200" onKeyUp="isNumber(this);">
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <input type="file" name="logo_file" id="logo_file">
                                    <input type="hidden" name="old_logo_file" id="old_logo_file" value="<cfoutput>#get_main_menu.logo_file#</cfoutput>">
                                    <input type="hidden" name="old_logo_file_server_id" id="old_logo_file_server_id" value="<cfoutput>#get_main_menu.logo_file_server_id#</cfoutput>">
                                    <cfif len(get_main_menu.logo_file)>
                                        <span class="input-group-addon" href="javascript://" <cfoutput>onClick="windowopen('#request.self#?fuseaction=settings.emptypopup_del_background_files&menu_id=#get_main_menu.menu_id#&type=LOGO_FILE&type_server_id=LOGO_FILE_SERVER_ID','small');"</cfoutput>><i class="fa fa-minus"></i></span>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">CSS</label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfif len(get_main_menu.css_file)>
                                    <div class="input-group">
                                </cfif>
                                <input type="text" name="css_file" id="css_file" value="<cfoutput>#get_main_menu.css_file#</cfoutput>">
                                <cfif len(get_main_menu.css_file)>
                                    <span class="input-group-addon" href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=settings.popup_add_css_property&menu_id=#attributes.menu_id#</cfoutput>','medium');"> CSS</span>
                                    </div>
                                </cfif>
                            </div>
                        </div>                	
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='1584.Dil'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <select name="language_id" id="language_id">
                                    <cfoutput query="get_languages">
                                        <option value="#language_short#" <cfif get_main_menu.language_id eq language_short>selected</cfif>>#language_short#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no ='480.Domain'></label>
                            <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                                <cfoutput>
                                <select name="site_domain" id="site_domain">
                                    <option value=""><cf_get_lang_main no ='480.Domain'></option>
                                    <optgroup label="Partner Portal"></optgroup>
                                    <cfloop list="#application.systemParam.systemParam().partner_url#" index="i" delimiters=";">
                                        <option value="#i#" <cfif get_main_menu.site_domain is '#i#'>selected</cfif>>#i#</option>
                                    </cfloop>
                                    <optgroup label="Public Portal"></optgroup>
                                    <cfloop list="#application.systemParam.systemParam().server_url#" index="j" delimiters=";">
                                        <option value="#j#" <cfif get_main_menu.site_domain is '#j#'>selected</cfif>>#j#</option>
                                    </cfloop>
                                    <optgroup label="Kariyer Portal"></optgroup>
                                    <cfloop list="#application.systemParam.systemParam().career_url#" index="x" delimiters=";">
                                        <option value="#x#" <cfif get_main_menu.site_domain is '#x#'>selected</cfif>>#x#</option>
                                    </cfloop>
                                    <optgroup label="Employee Portal"></optgroup>
                                    <cfloop list="#application.systemParam.systemParam().employee_url#" index="k" delimiters=";">
                                        <option value="#k#" <cfif get_main_menu.site_domain is '#k#'>selected</cfif>>#k#</option>
                                    </cfloop>
                                    <optgroup label="PDA Portal"></optgroup>
                                    <cfloop list="#application.systemParam.systemParam().pda_url#" index="l" delimiters=";">
                                        <option value="#l#" <cfif get_main_menu.site_domain is '#l#'>selected</cfif>>#l#</option>
                                    </cfloop>
                                </select>
                                </cfoutput>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2470.Logo Göster'></label>
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <input type="checkbox"  name="is_logo" id="is_logo"value="1" <cfif get_main_menu.is_logo eq 1>checked</cfif>>
                                <cf_get_lang no ='2806.Logo Flash'>
                            </label>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <input type="checkbox" name="is_flash_logo" id="is_flash_logo" value="1" <cfif get_main_menu.is_flash_logo eq 1>checked</cfif>>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2472.Sol Menü'></label>
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <input type="checkbox" name="is_tree_menu" id="is_tree_menu" value="1" <cfif get_main_menu.is_tree_menu eq 1>checked</cfif>> (<cf_get_lang no='2807.Çalışan Portalı'>)
                            </label>
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <input type="checkbox" name="is_password_control" id="is_password_control" value="1" <cfif get_main_menu.is_password_control eq 1>checked</cfif>> <cf_get_lang no='2808.Şifre Kontrol'>
                            </label>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12">Orta Menü Logonun Yanında Gelsin</label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><input type="checkbox" name="is_logo_block" id="is_logo_block" value="1" <cfif get_main_menu.is_logo_block eq 1>checked</cfif>></div>
                        </div>
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <div class="form-group">
                            <label class="bold col col-12 col-md-12 col-sm-12 col-xs-12"><cf_get_lang no ='2473.Menü Tasarımı'></label>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2474.Üst Yükseklik'> *</label>
                            <cfsavecontent variable="height">20px-170px<cf_get_lang no ='2475.Arası Alan Yüksekliği Girmelisiniz'>!</cfsavecontent>
                                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                    <cfinput type="text" name="main_height" id="main_height" value="#get_main_menu.main_height#" validate="integer" required="yes" message="#height#" maxlength="3" range="20,170" onKeyUp="isNumber(this);">
                                </div>
                                <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                    <select name="main_align" id="main_align">
                                        <option value="left" <cfif get_main_menu.main_align is 'left'>selected</cfif>><cf_get_lang no='894.Sola Daya'></option>
                                        <option value="right" <cfif get_main_menu.main_align is 'right'>selected</cfif>><cf_get_lang no='895.Sağa Daya'></option>
                                        <option value="center" <cfif get_main_menu.main_align is 'center'>selected</cfif>><cf_get_lang_main no='96.Ortala'></option>
                                    </select>
                                </div>
                                <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                    <select name="main_valign" id="main_valign">
                                        <option value=""><cf_get_lang_main no ='322.Seçiniz'></option>
                                        <option value="top" <cfif get_main_menu.main_valign is 'top'>selected</cfif>><cf_get_lang no ='2476.Yukarı'></option>
                                        <option value="bottom" <cfif get_main_menu.main_valign is 'bottom'>selected</cfif>><cf_get_lang no ='2477.Aşağı'></option>
                                    </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2478.Orta Yükseklik'> *</label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <cfsavecontent variable="second">20px-100px<cf_get_lang no ='2475.Arası Alan Yüksekliği Girmelisiniz'>!</cfsavecontent>
                                <cfinput type="text" name="second_height" id="second_height" value="#get_main_menu.second_height#" validate="integer" required="yes" message="#second#" maxlength="3" range="20,150" onKeyUp="isNumber(this);">
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <select name="second_align" id="second_align">
                                    <option value="left" <cfif get_main_menu.second_align is 'left'>selected</cfif>><cf_get_lang no='894.Sola Daya'></option>
                                    <option value="right" <cfif get_main_menu.second_align is 'right'>selected</cfif>><cf_get_lang no='895.Sağa Daya'></option>
                                    <option value="center" <cfif get_main_menu.second_align is 'center'>selected</cfif>><cf_get_lang_main no='96.Ortala'></option>
                                </select>                        
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2479.Footer Yükseklik'> *</label>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                <cfsavecontent variable="area">20px-100px<cf_get_lang no ='2475.Arası Alan Yüksekliği Girmelisiniz'>!</cfsavecontent>
                                <cfinput type="text" name="footer_height" id="footer_height" value="#get_main_menu.footer_height#" validate="integer" required="yes" message="#area#" maxlength="3" range="20,100" onKeyUp="isNumber(this);">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <select name="footer_align" id="footer_align">
                                    <option value="left" <cfif get_main_menu.footer_align is 'left'>selected</cfif>><cf_get_lang no='894.Sola Daya'></option>
                                    <option value="right" <cfif get_main_menu.footer_align is 'right'>selected</cfif>><cf_get_lang no='895.Sağa Daya'></option>
                                    <option value="center" <cfif get_main_menu.footer_align is 'center'>selected</cfif>><cf_get_lang_main no='96.Ortala'></option>
                                </select>
                            </div>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                                <select name="footer_valign" id="footer_valign">
                                    <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
                                    <option value="top" <cfif get_main_menu.footer_valign is 'top'>selected</cfif>><cf_get_lang no ='2476.Yukarı'></option>
                                    <option value="bottom" <cfif get_main_menu.footer_valign is 'bottom'>selected</cfif>><cf_get_lang no ='2477.Aşağı'></option>
                                </select>                      
                            </div>	
                        </div>					
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2480.Üst Arkaplan'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_workcube_color_picker name="color_top_menu" value="#get_main_menu.color_top_menu#"></div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                               <div class="input-group">
                                    <input type="file" name="top_menu_background" id="top_menu_background">
                                    <input type="hidden" name="old_top_menu_background" id="old_top_menu_background" value="<cfoutput>#get_main_menu.top_menu_background#</cfoutput>">
                                    <input type="hidden" name="old_top_menu_background_server_id" id="old_top_menu_background_server_id" value="<cfoutput>#get_main_menu.top_menu_background_server_id#</cfoutput>">
                                    <cfif len(get_main_menu.top_menu_background)>
                                        <span class="input-group-addon" href="javascript://" <cfoutput>onClick="windowopen('#request.self#?fuseaction=settings.emptypopup_del_background_files&menu_id=#get_main_menu.menu_id#&type=TOP_MENU_BACKGROUND&type_server_id=TOP_MENU_BACKGROUND_SERVER_ID','small');"</cfoutput>><i class="fa fa-minus"></i></span>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2497.Orta Arkaplan'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_workcube_color_picker name="color_center_menu" value="#get_main_menu.color_center_menu#" width="50"></div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <input type="file" name="center_menu_background" id="center_menu_background">
                                    <input type="hidden" name="old_center_menu_background" id="old_center_menu_background" value="<cfoutput>#get_main_menu.center_menu_background#</cfoutput>">
                                    <input type="hidden" name="old_center_menu_background_server_id" id="old_center_menu_background_server_id" value="<cfoutput>#get_main_menu.center_menu_bg_server_id#</cfoutput>">                       
                                    <cfif len(get_main_menu.center_menu_background)>
                                        <span class="input-group-addon" href="javascript://" <cfoutput>onClick="windowopen('#request.self#?fuseaction=settings.emptypopup_del_background_files&menu_id=#get_main_menu.menu_id#&type=CENTER_MENU_BACKGROUND&type_server_id=CENTER_MENU_BG_SERVER_ID','small');"</cfoutput>><i class="fa fa-minus"></i></span>
                                    </cfif>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2481.Alt Arka Plan'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_workcube_color_picker name="color_bottom_menu" value="#get_main_menu.color_bottom_menu#" width="50"></div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                                <div class="input-group">
                                    <input type="file" name="bottom_menu_background" id="bottom_menu_background">
                                    <input type="hidden" name="old_bottom_menu_background" id="old_bottom_menu_background" value="<cfoutput>#get_main_menu.bottom_menu_background#</cfoutput>">
                                    <input type="hidden" name="old_bottom_menu_background_server_id" id="old_bottom_menu_background_server_id" value="<cfoutput>#get_main_menu.bottom_menu_bg_server_id#</cfoutput>">                      
                                    <cfif len(get_main_menu.bottom_menu_background)>
                                        <span class="input-group-addon" href="javascript://" <cfoutput>onClick="windowopen('#request.self#?fuseaction=settings.emptypopup_del_background_files&menu_id=#get_main_menu.menu_id#&type=BOTTOM_MENU_BACKGROUND&type_server_id=BOTTOM_MENU_BG_SERVER_ID','small');"</cfoutput>><i class="fa fa-minus"></i></span>
                                    </cfif>   
                                </div>                    
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2482.Footer Arkaplan'></label>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_workcube_color_picker name="color_footer_menu" value="#get_main_menu.color_footer_menu#" width="50"></div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">					
                               <div class="input-group">
                                    <input type="FILE" name="footer_menu_background" id="footer_menu_background">
                                    <input type="hidden" name="old_footer_menu_background" id="old_footer_menu_background" value="<cfoutput>#get_main_menu.footer_menu_background#</cfoutput>">
                                    <input type="hidden" name="old_footer_menu_background_server_id" id="old_footer_menu_background_server_id" value="<cfoutput>#get_main_menu.footer_menu_bg_server_id#</cfoutput>">
                                    <cfif len(get_main_menu.footer_menu_background)>
                                        <span class="input-group-addon" href="javascript://" <cfoutput>onClick="windowopen('#request.self#?fuseaction=settings.emptypopup_del_background_files&menu_id=#get_main_menu.menu_id#&type=FOOTER_MENU_BACKGROUND&type_server_id=FOOTER_MENU_BG_SERVER_ID','small');"</cfoutput>><i class="fa fa-minus"></i></span>
                                    </cfif>
                               </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no ='2486.Ayraç Text'>/<cf_get_lang no ='670.En'></label>
                            <div class="col col-2 col-md-2 col-sm-2 col-xs-12">
                                <input type="text" name="ayrac_text" id="ayrac_text" value="<cfoutput>#get_main_menu.ayrac_text#</cfoutput>" maxlength="6">
                            </div>
                            <div class="col col-2 col-md-2 col-sm-4 col-xs-12">
                                <input type="text" name="ayrac_width" id="ayrac_width" value="<cfoutput>#get_main_menu.ayrac_width#</cfoutput>" maxlength="6" onkeyup="isNumber(this);">
                            </div>
                            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">	
                               <div class="input-group">
                                    <input type="FILE" name="ayrac_buton" id="ayrac_buton">
                                    <input type="hidden" name="old_ayrac_buton" id="old_ayrac_buton" value="<cfoutput>#get_main_menu.ayrac_buton#</cfoutput>">
                                    <input type="hidden" name="old_ayrac_buton_server_id" id="old_ayrac_buton_server_id" value="<cfoutput>#get_main_menu.ayrac_buton_server_id#</cfoutput>">
                                    <cfif len(get_main_menu.ayrac_buton)>
                                        <span class="input-group-addon" href="javascript://" <cfoutput>onClick="windowopen('#request.self#?fuseaction=settings.emptypopup_del_background_files&menu_id=#get_main_menu.menu_id#&type=AYRAC_BUTON&type_server_id=AYRAC_BUTON_SERVER_ID','small');"</cfoutput>><i class="fa fa-minus"></i></span>
                                    </cfif>
                               </div>
                            </div>
                        </div>
                    </div>
                </cf_box_elements>
                <cfoutput>
                    <div style='<cfif len(get_main_menu.background_file)>background:#file_web_path#settings/#get_main_menu.background_file#</cfif>'> 
                        <tr style="height:#get_main_menu.main_height#px;">
                            <td <cfif len(get_main_menu.top_menu_background)>background="#file_web_path#settings/#get_main_menu.top_menu_background#"</cfif>>
                                <cfif len(get_main_menu.logo_file)>
                                    <cfif get_main_menu.is_flash_logo eq 1>
                                    <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="" <cfif len(get_main_menu.logo_height)>height="#get_main_menu.logo_height#"</cfif> <cfif len(get_main_menu.logo_width)>width="#get_main_menu.logo_width#"</cfif>>
                                    <param name="movie" value="#file_web_path#settings/#get_main_menu.logo_file#">
                                    <param name=wmode value=transparent> 
                                    <param name="quality" value="high">
                                    <embed src="#file_web_path#settings/#get_main_menu.logo_file#" quality="high" pluginspage="" type="application/x-shockwave-flash" <cfif len(get_main_menu.logo_height)>height="#get_main_menu.logo_height#"</cfif> <cfif len(get_main_menu.logo_width)>width="#get_main_menu.logo_width#"</cfif>></embed>
                                    </object>
                                    <cfelse>
                                        <cf_get_server_file output_file="settings/#get_main_menu.logo_file#" output_server="#get_main_menu.logo_file_server_id#" output_type="0" image_width="#get_main_menu.logo_width#" image_height="#get_main_menu.logo_height#" image_link="1">				
                                    </cfif>
                                </cfif>
                            </td>
                        </tr>
                        <tr style="height:#get_main_menu.second_height#px;">
                            <td <cfif len(get_main_menu.center_menu_background)>background="#file_web_path#settings/#get_main_menu.center_menu_background#"</cfif>>&nbsp;</td>
                        </tr>
                        <tr style="height:22px;">
                            <td <cfif len(get_main_menu.bottom_menu_background)>background="#file_web_path#settings/#get_main_menu.bottom_menu_background#"</cfif>>
                                <table cellpadding="0" cellspacing="0">
                                    <tr>
                                    <cfif len(get_main_menu.ayrac_left) and len(get_main_menu.ayrac_center) and len(get_main_menu.ayrac_right)>
                                        <td><cf_get_server_file output_file="settings/#get_main_menu.ayrac_left#" output_server="#get_main_menu.ayrac_left_server_id#" output_type="0"></td>
                                        <td background="#file_web_path#settings/#get_main_menu.ayrac_center#"><cf_get_lang no ='2567.Menü Objesi'></td>
                                        <td><cf_get_server_file output_file="settings/#get_main_menu.ayrac_right#" output_server="#get_main_menu.ayrac_right_server_id#" output_type="0"></td>
                                    </cfif>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr style="height:20px;">
                            <td <cfif len(get_main_menu.content_menu_background)>background="#file_web_path#settings/#get_main_menu.content_menu_background#"</cfif>>&nbsp;</td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr style="height:10px;">
                            <td <cfif len(get_main_menu.footer_menu_background)>background="#file_web_path#settings/#get_main_menu.footer_menu_background#"</cfif>>&nbsp;</td>
                        </tr>
                    </div>
                </cfoutput>
                <div class="ui-form-list-btn">
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <cf_record_info query_name="get_main_menu">
                    </div>
                    <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                        <cfif session.ep.admin eq 1>
                            <cf_workcube_buttons is_upd='1' is_delete='1' delete_page_url='#request.self#?fuseaction=settings.emptypopup_del_main_menu&menu_id=#attributes.menu_id#'>
                        <cfelse>
                            <cf_workcube_buttons is_upd='1' is_delete='0'>
                        </cfif>
                    </div>
                </div>	
            </div>
            <cfsavecontent  variable="head"><cf_get_lang_main no='1564.Meta Tanımlari'></cfsavecontent>
            <cf_seperator title="#head#" id="site">
            <div id="site">
                <cf_box_elements>
                    <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='2811.Title'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="site_title" value="#get_main_menu.site_title#">
                        </div>
                    </div>
                    <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='289.Keywords'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <textarea name="site_keywords" id="site_keywords"><cfoutput>#get_main_menu.site_keywords#</cfoutput></textarea>
                        </div>
                    </div>
                    <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='2809.Headers'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <textarea name="site_headers" id="site_headers"><cfoutput>#get_main_menu.site_headers#</cfoutput></textarea>
                        </div>
                    </div>
                    <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang_main no='217.Aciklama'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="description" value="#get_main_menu.site_description#">
                        </div>
                    </div>
                    <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='2810.App key'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <input type="text"  value="<cfoutput>#get_main_menu.APP_KEY#</cfoutput>" name="APP_KEY" id="APP_KEY" maxlength="100">
                        </div>
                    </div>
                    <div class="form-group col col-4 col-md-4 col-sm-4 col-xs-12">
                        <label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang no='3084.Standart Tanımlar'></label>
                        <div class="col col-8 col-md-8 col-sm-8 col-xs-12">
                            <cfinput type="text" name="std_desc" value="#get_main_menu.std_description#">
                        </div>
                    </div>
                </cf_box_elements>
            </div>
            <cfsavecontent  variable="head"><cf_get_lang no ='2487.Erişim ve Yetki Ayarları'></cfsavecontent>
            <cf_seperator title="#head#" id="access">
            <div id="access">
                <cf_box_elements vertical="1">
                    <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="yetki">
                        <label><b><cf_get_lang no='161.Yetki Grupları'></b></label>
                        <cfoutput query="get_user_groups">
                            <label><input type="checkbox" name="user_group_ids" id="user_group_ids" value="#user_group_id#" <cfif listfind(get_main_menu.USER_GROUP_IDS,user_group_id)>checked</cfif>> #user_group_name#</label>
                        </cfoutput>
                        <label><input type="checkbox" name="check_all_user_group" id="check_all" value="1" onclick="check('user_group');" /> <b>Hepsi</b></label>
                    </div>
                    <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="pozisyon">
                        <label><b><cf_get_lang_main no='367.Pozisyon Tipleri'></b></label>
                        <cfoutput query="GET_POSITION_CATS">
                            <label><input type="checkbox" name="position_cat_ids" id="position_cat_ids" value="#POSITION_CAT_ID#" <cfif listfind(get_main_menu.position_cat_ids,POSITION_CAT_ID)>checked</cfif>> #POSITION_CAT#</label>
                        </cfoutput>	
                        <label><input type="checkbox" name="check_all_position_cat" id="check_all" value="1" onclick="check('position_cat');" /> <b>Hepsi</b></label>
                    </div>
                    <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="partnerlar">
                        <label><b><cf_get_lang_main no='1611.Kurumsal Üyeler'></b></label>
                        <cfoutput query="get_company_cat">
                            <label><input type="checkbox" name="company_cat_ids" id="company_cat_ids" value="#companycat_id#" <cfif listfind(get_main_menu.company_cat_ids,companycat_id)>checked</cfif>> #companycat#</label>
                        </cfoutput>	
                        <label><input type="checkbox" name="check_all_company_cat" id="check_all_company_cat" value="1" onclick="check('company_cat');" /> <b>Hepsi</b></label>
                    </div>
                    <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="consumerlar">
                        <label><b><cf_get_lang_main no='1609.Bireysel Üyeler'></b></label>
                        <cfoutput query="GET_CONSUMER_CAT">
                            <label><input type="checkbox" name="consumer_cat_ids" id="consumer_cat_ids" value="#CONSCAT_ID#" <cfif listfind(get_main_menu.CONSUMER_CAT_IDS,CONSCAT_ID)>checked</cfif>> #CONSCAT#</label>
                        </cfoutput>
                        <label><input type="checkbox" name="check_all_consumer_cat" id="check_all_consumer_cat" value="1" onclick="check('consumer_cat');" /> <b>Hepsi</b></label>
                    </div>
                    <div class="form-group col col-2 col-md-2 col-sm-6 col-xs-12" id="calisan">
                        <cfsavecontent variable="txt_1"><b><cf_get_lang_main no='1463.Çalışanlar'></b></cfsavecontent>
                        <cf_workcube_to_cc 
                            is_update = "1" 
                            to_dsp_name = "#txt_1#" 
                            form_name = "user_group" 
                            str_list_param = "1"
                            action_dsn = "#DSN#"
                            str_action_names = "TO_EMPS AS TO_EMP"
                            action_table = "MAIN_MENU_SETTINGS"
                            action_id_name = "MENU_ID"
                            action_id = "#attributes.menu_id#"
                            data_type = "1"
                            str_alias_names = "">
                    </div>
                    <div class="col col-2 col-md-2 col-sm-6 col-xs-12">
                        <div class="form-group">
                            <label><b><cf_get_lang_main no ='754.Stoklar'></b></label>
                            <select name="stock_type" id="stock_type">
                                <option value="1" <cfif get_main_menu.stock_type eq 1>selected</cfif>><cf_get_lang no ='2488.Stoklarım'></option>
                                <option value="2" <cfif get_main_menu.stock_type eq 2>selected</cfif>>XML<cf_get_lang no ='2488.Stoklarım'></option>
                                <option value="3" <cfif get_main_menu.stock_type eq 3>selected</cfif>><cf_get_lang_main no ='669.Hepsi'></option>
                            </select>
                        </div> 
                        <div class="form-group">
                            <label><b><cf_get_lang no ='2489.Depolar'></b></label>
                            <cfoutput query="get_department">
                                <label><input type="checkbox" name="department_ids" id="department_ids" value="#department_id#" <cfif listfind(get_main_menu.department_ids,department_id)>checked</cfif>> #department_head#</label>
                            </cfoutput>
                        </div>
                    </div>  
                </cf_box_elements>
            </div>
            <cfsavecontent  variable="head"><cf_get_lang no ='2454.Menü ve Linkler'></cfsavecontent>
            <cf_seperator title="#head#" id="link">
            <div id="link">		  
                <cf_grid_list sort="0">
                    <thead>
                        <tr>
                            <th width="20"><a href="javascrript://" onclick="add_row();"  title="<cf_get_lang_main no ='170.Ekle'>"><i class="fa fa-plus"></i></a></th>
                            <th width="165"><cf_get_lang_main no='520.Sözlük'></th>
                            <th width="185"><cf_get_lang no='898.Link Adı'></th>
                            <th width="220"><cf_get_lang_main no='1964.URL'></th>
                            <th width="80"><cf_get_lang no='324.Konum'></th>
                            <th width="210"><cf_get_lang no='899.Davranış'></th>
                            <th width="35"><cf_get_lang_main no='1165.Sıra'></th>
                            <th width="25"> LK</th>
                            <th><cf_get_lang no ='2568.Login Kontrol'></th>
                            <th width="150"><cf_get_lang_main no ='1965.İmaj'></th>
                            <th>
                                <ul class="ui-icon-list">
                                    <li><a href="javascript:void(0)"><i class="fa fa-hand-o-up"></i></a></li>
                                    <li><a href="javascript:void(0)"><i class="fa fa-list-ul"></i></a></li>
                                    <li><a href="javascript:void(0)"><i class="catalyst-note"></i></a></li>
                                </ul>
                            </th>
                        </tr>
                    </thead>
                    <tbody id="link_table">
                        <input name="record_num_sabit" id="record_num_sabit" type="hidden" value="<cfoutput>#get_main_menu_select.recordcount#</cfoutput>">
                        <input name="record_num" id="record_num" type="hidden" value="0">
                        <input name="old_records" id="old_records" type="hidden" value="<cfoutput>#valuelist(get_main_menu_select.selected_id)#</cfoutput>">
                        <cfoutput query="get_main_menu_select">
                            <input type="hidden" value="1" name="row_kontrol_sabit_#currentrow#" id="row_kontrol_sabit_#currentrow#">
                            <input type="hidden" value="#selected_id#" name="selected_id_sabit_#currentrow#" id="selected_id_sabit_#currentrow#">
                            <tr id="frm_row_sabit_#currentrow#">
                                <td><a style="cursor:pointer" onclick="sil_sabit(#currentrow#);" ><i class="fa fa-minus"></i></a></td>
                                <td>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <cfif link_name_type eq 1>
                                                <cfif isNumeric(link_name)>
                                                        <cfquery name="get_lang_name" datasource="#dsn#">
                                                            SELECT ITEM FROM SETUP_LANGUAGE_#UCase(session.ep.language)# WHERE MODULE_ID = 'main' AND ITEM_ID = #link_name#
                                                        </cfquery>
                                                    <cfelse>
                                                        <cfset get_lang_name.item = link_name>
                                                    </cfif>
                                                    <cfinput type="hidden" name="link_name_id_sabit_#currentrow#" value="#link_name#">
                                                    <cfinput type="text" value="#get_lang_name.item#" name="link_name_sabit_#currentrow#" maxlength="100">
                                                <cfelseif link_name_type eq 2>
                                                <cfif isNumeric(link_name)>
                                                        <cfquery name="get_lang_name" datasource="#dsn#">
                                                            SELECT ITEM FROM SETUP_LANGUAGE_#UCase(session.ep.language)# WHERE MODULE_ID = 'objects2' AND ITEM_ID = #link_name#
                                                        </cfquery>
                                                    <cfelse>
                                                        <cfset get_lang_name.item = link_name>
                                                    </cfif>
                                                    <cfinput type="hidden" name="link_name_id_sabit_#currentrow#" value="#link_name#">
                                                    <cfinput type="text" value="#get_lang_name.item#" name="link_name_sabit_#currentrow#" maxlength="100">
                                                <cfelse>
                                                    <cfinput type="hidden" name="link_name_id_sabit_#currentrow#" value="">
                                                    <cfinput type="text" value="" name="link_name_sabit_#currentrow#" maxlength="100">
                                                </cfif>					
                                                <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="pencere_ac2('#currentrow#');"></span>
                                                <cfinput type="hidden" name="link_name_type_sabit_#currentrow#" id="link_name_type_sabit_#currentrow#" value="#link_name_type#" />
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <cfif link_name_type eq 0> 
                                                <cfinput type="text" value="#LINK_NAME#" name="link_name2_sabit_#currentrow#" maxlength="100" onFocus="get_value(#currentrow#,2)">
                                            <cfelse>
                                                <cfinput type="text" value="" name="link_name2_sabit_#currentrow#" maxlength="100" onFocus="get_value(#currentrow#,2)">
                                            </cfif>
                                            <cf_language_info 
                                                table_name="MAIN_MENU_SELECTS" 
                                                column_name="LINK_NAME" 
                                                column_id_value="#GET_MAIN_MENU_SELECT.SELECTED_ID#" 
                                                maxlength="100" 
                                                datasource="#dsn#" 
                                                column_id="SELECTED_ID" 
                                                control_type="0"
                                                class="input-group-addon">
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <div class="input-group">
                                            <cfinput type="text" value="#SELECTED_LINK#" name="selected_link_sabit_#currentrow#" maxlength="250">
                                            <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_list_select_switch<cfif get_main_menu.site_type eq 4>&is_pda=1</cfif>&selected_link=user_group.selected_link_sabit_#currentrow#','list');"></span>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="form-group">
                                        <select name="link_area_sabit_#currentrow#" id="link_area_sabit_#currentrow#">
                                            <option value="-1" <cfif link_area eq -1>selected</cfif>><cf_get_lang no='900.Ana Alan'></option>
                                            <option value="-2" <cfif link_area eq -2>selected</cfif>><cf_get_lang no='901.Ara Alan'></option>
                                            <option value="-3" <cfif link_area eq -3>selected</cfif>><cf_get_lang no ='2493.Footer Alan'></option>
                                        </select>
                                    </div>	
                                </td>
                                <td>
                                    <div class="form-group">
                                        <select name="link_type_sabit_#currentrow#" id="link_type_sabit_#currentrow#">
                                            <option value="-1" <cfif LINK_TYPE eq -1>selected</cfif>><cf_get_lang no='379.Normal'></option>
                                            <option value="-9" <cfif LINK_TYPE eq -9>selected</cfif>><cf_get_lang no='902.Layer'></option>		
                                            <option value="-2" <cfif LINK_TYPE eq -2>selected</cfif>><cf_get_lang no='903.Yeni Sayfa'></option>
                                            <option value="-3" <cfif LINK_TYPE eq -3>selected</cfif>><cf_get_lang no='904.Popup Small'></option>
                                            <option value="-4" <cfif LINK_TYPE eq -4>selected</cfif>><cf_get_lang no='905.Popup Medium'></option>
                                            <option value="-5" <cfif LINK_TYPE eq -5>selected</cfif>><cf_get_lang no='906.Popup List'></option>
                                            <option value="-6" <cfif LINK_TYPE eq -6>selected</cfif>><cf_get_lang no='907.Popup Page'></option>
                                            <option value="-7" <cfif LINK_TYPE eq -7>selected</cfif>><cf_get_lang no='908.Popup Project'></option>
                                            <option value="-8" <cfif LINK_TYPE eq -8>selected</cfif>><cf_get_lang no='909.Popup Horizantal'></option>
                                            <option value="-15" <cfif LINK_TYPE eq -15>selected</cfif>>TV</option>
                                            <option value="-10" <cfif LINK_TYPE eq -10>selected</cfif>><cf_get_lang no ='2420.Güvenli Link'></option>
                                            <option value="-11" <cfif LINK_TYPE eq -11>selected</cfif>><cf_get_lang no ='2421.Popup Güvenli Link'></option>
                                            <option value="-12" <cfif LINK_TYPE eq -12>selected</cfif>><cf_get_lang no ='2494.Sayfa Çağır'></option>
                                            <option value="-13" <cfif LINK_TYPE eq -13>selected</cfif>><cf_get_lang no ='2422.Site Dışı Link'></option>
                                        </select>
                                    </div>
                                </td>					
                                <td>
                                    <div class="form-group">
                                        <cfinput type="text" value="#order_no#" name="order_no_sabit_#currentrow#" maxlength="2" onKeyUp="isNumber(this);" onBlur="isNumber(this);" class="moneybox">
                                    </div>
                                </td>
                                <td><input type="checkbox" value="1" name="is_session_sabit_#currentrow#" id="is_session_sabit_#currentrow#" <cfif is_session eq 1>checked</cfif>></td>
                                <td>
                                    <div class="form-group">
                                        <select name="login_control_#currentrow#" id="login_control_#currentrow#">
                                            <option value="0" <cfif login_control eq 0>selected</cfif>><cf_get_lang no='2569.Her Durumda'></option>
                                            <option value="1" <cfif login_control eq 1>selected</cfif>><cf_get_lang no ='2570.Üye Girişi Varken'></option>
                                            <option value="2" <cfif login_control eq 2>selected</cfif>><cf_get_lang no ='2571.Üye Girişi Yokken'></option>
                                            <option value="3" <cfif login_control eq 3>selected</cfif>><cf_get_lang_main no='1197.Üye Kategorisi'></option>
                                        </select>
                                    </div>
                                </td>
                                <td nowrap="nowrap">
                                    <div class="form-group">
                                        <div class="input-group">
                                            <input type="file" name="menu_row_file_#currentrow#" id="menu_row_file_#currentrow#">
                                            <cfif len(link_image)><span class="input-group-addon"><cf_get_server_file output_file="settings/#link_image#" output_server="#link_image_server_id#" output_type="2" image_link="1"></span></cfif>
                                            <input type="hidden" name="old_menu_row_file_#currentrow#" id="old_menu_row_file_#currentrow#" value="#link_image#">
                                            <input type="hidden" name="old_menu_row_file_server_id_#currentrow#" id="old_menu_row_file_server_id_#currentrow#" value="#link_image_server_id#">
                                            <cfif len(link_image)>
                                                <span class="input-group-addon" href="javascript://" <cfoutput>onClick="windowopen('#request.self#?fuseaction=settings.emptypopup_del_background_files&menu_id=#get_main_menu_select.menu_id#&selected_id=#selected_id#','small');"</cfoutput>><i class="fa fa-minus" title="<cf_get_lang_main no ='51.sil'>"></i></a>
                                            </cfif>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <ul class="ui-icon-list">	
                                        <cfif listfindnocase('-1,-2,-9,-10,-14',link_type)>
                                            <cfif get_main_menu.site_type neq 4>
                                                <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_form_upd_main_menu_layer&selected_id=#selected_id#&menu_id=#attributes.menu_id#','wide2');"><i class="fa fa-hand-o-up" alt="<cf_get_lang no ='2495.Layer Menü'>"></i></a></li>
                                                <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_form_upd_main_menu_sub&selected_id=#selected_id#&menu_id=#attributes.menu_id#','work');"><i class="fa fa-list-ul" alt="<cf_get_lang no ='2496.Alt Menü'>"></i></a></li>
                                            </cfif>
                                            <cfif len(SELECTED_LINK)>
                                                <li><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=settings.popup_select_site_objects&faction=#listlast(SELECTED_LINK,'.')#&menu_id=#attributes.menu_id#<cfif get_main_menu.site_type eq 4>&is_pda=1</cfif>','page');"><i class="catalyst-note" alt="<cf_get_lang no ='2425.Sayfa Tasarla'>"></i></a></li>
                                            </cfif>
                                        </cfif>
                                    </ul>
                                </td>
                            </tr>
                            </cfoutput>
                    </tbody>
                </cf_grid_list>
                <div class="ui-info-bottom flex-end">
                    <cf_workcube_buttons is_upd='1' is_delete='0' is_cancel='0' type_format="1">
                </div>
            </div>
        </cfform>
    </cf_box>
</div>
<script type="text/javascript">
	row_count=0;
	function sil(sy)
	{  
		/*var my_element=eval("user_group.row_kontrol"+sy); */
		var my_element=document.getElementById('row_kontrol'+sy);
		my_element.value=0;

		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	function sil_sabit(sy)
	{   
		var my_element1=eval("user_group.row_kontrol_sabit_"+sy); 
		my_element1.value=0;

		var my_element1=eval("frm_row_sabit_"+sy);
		my_element1.style.display="none";
	}
	
	function get_value(satir,type)
	{
		if(type == 1)
		{
			document.getElementById('link_name_id'+satir).value = '';
			document.getElementById('link_name'+satir).value = '';
			document.getElementById('link_name_type'+satir).value = 0;
		}
		else
		{
			document.getElementById('link_name_sabit_'+satir).value = '';
			document.getElementById('link_name_id_sabit_'+satir).value = '';
			document.getElementById('link_name_type_sabit_'+satir).value = 0;
		}

	}
	
	function add_row()
	{
		row_count++;
		var newRow;
		var newCell;
		newRow = document.getElementById("link_table").insertRow(document.getElementById("link_table").rows.length);
		newRow.setAttribute("name","frm_row" + row_count);
		newRow.setAttribute("id","frm_row" + row_count);
		newRow.setAttribute("NAME","frm_row" + row_count);
		newRow.setAttribute("ID","frm_row" + row_count);
					
		document.user_group.record_num.value=row_count;
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');" ><img  src="images/delete_list.gif" border="0"></a>';	
		
/*		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<select name="link_name_type' + row_count + '" id="link_name_type' + row_count + '"><option value="0" selected><cf_get_lang no ="2417.Menüden"></option><option value="1"><cf_get_lang no ="2491.Ana Sözlük"></option><option value="2"><cf_get_lang no ="2492.Modül Sözlük"></option></select>';
*/		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input  type="hidden"  value="1" name="row_kontrol' + row_count +'" id="row_kontrol' + row_count +'"><input type="hidden" name="link_name_id' + row_count + '" id="link_name_id' + row_count + '"><input type="text" name="link_name' + row_count + '" id="link_name' + row_count + '"" onChange="get_value('+row_count+',1);" readonly="readonly"> <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac(' + row_count + ');"></span></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="hidden" name="link_name_type' + row_count + '" id="link_name_type' + row_count + '" value="0"><input type="text" name="link_name2' + row_count + '" id="link_name2' + row_count + '" onFocus="get_value('+row_count+',1);" "></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="selected_link' + row_count + '" id="selected_link' + row_count + '"><span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac3(' + row_count + ');"></span></div></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="link_area' + row_count + '" id="link_area' + row_count + '"><option value="-1"><cf_get_lang no ="900.Ana Alan"></option><option value="-2"><cf_get_lang no ="901.Ara Alan"></option><option value="-3"><cf_get_lang no ="2493.Footer Alan"></option></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="link_type' + row_count + '" id="link_type' + row_count + '"><option value="-1"><cf_get_lang no ="379.Normal"></option><option value="-9"><cf_get_lang no="902.Layer"></option><option value="-2"><cf_get_lang no ="2572.Yeni Pencere"></option><option value="-3"><cf_get_lang no="904.Popup Small"></option><option value="-4"><cf_get_lang no="905.Popup Medium"></option><option value="-5"><cf_get_lang no="906.Popup List"></option><option value="-6"><cf_get_lang no="907.Popup Page"></option><option value="-7"><cf_get_lang no="908.Popup Project"></option><option value="-8"><cf_get_lang no="909.Popup Horizantal"></option><option value="-15">TV</option><option value="-10"><cf_get_lang no ="2420.Güvenli Link"></option><option value="-11"><cf_get_lang no ="2421.Popup Güvenli Link"></option><option value="-12"><cf_get_lang no ="2494.Sayfa Çağır"></option><option value="-13"><cf_get_lang no ="2422.Site Dışı Link"></option></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><input type="text" name="order_no' + row_count + '" id="order_no' + row_count + '" onKeyup="isNumber(this);" onblur="isNumber(this);" class="moneybox" maxlength="2"></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<input type="checkbox" value="1" name="is_session_' + row_count + '">';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '<div class="form-group"><select name="login_control' + row_count + '" id="login_control' + row_count + '"><option value="0"><cf_get_lang no ="2569.Her Durumda"></option><option value="1"><cf_get_lang no ="2570.Üye Girişi Varken"></option><option value="2"><cf_get_lang no ="2571.Üye Girişi Yokken"></option><option value="3"><cf_get_lang_main no="1197.Üye Kategorisi"></option></select></div>';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '&nbsp;';
		
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.innerHTML = '&nbsp;';
	}
	
	function newRows()
	{  
		for(i=1;i<=row_count;i++)
		{
			document.user_group.appendChild(document.getElementById('row_kontrol' + i + ''));
			document.user_group.appendChild(document.getElementById('order_no' + i + ''));
			document.user_group.appendChild(document.getElementById('link_area' + i + ''));
			document.user_group.appendChild(document.getElementById('selected_link' + i + ''));
			document.user_group.appendChild(document.getElementById('link_type' + i + ''));
			document.user_group.appendChild(document.getElementById('link_name_type' + i + ''));
			document.user_group.appendChild(document.getElementById('link_name' + i + ''));
			document.user_group.appendChild(document.getElementById('link_name_id' + i + ''));
			document.user_group.appendChild(document.getElementById('link_name2' + i + ''));
			document.user_group.appendChild(document.getElementById('login_control' + i + ''));
		}
	}
	
	function pencere_ac(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_list_lang_number&item_id=user_group.link_name_id' + no + '&item=user_group.link_name' + no+'&field_type=user_group.link_name_type'+no+'&field_name2=user_group.link_name2'+no,'medium');
	}
	function pencere_ac2(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_list_lang_number&item_id=user_group.link_name_id_sabit_' + no + '&item=user_group.link_name_sabit_' + no +'&field_type=user_group.link_name_type_sabit_'+no+'&field_name2=user_group.link_name2_sabit_'+no,'medium');
	}	
	function pencere_ac3(no)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=settings.popup_list_select_switch<cfif get_main_menu.site_type eq 4>&is_pda=1</cfif>&selected_link=user_group.selected_link' + no,'medium');
	}
	function check(type)
	{
		if(document.getElementById('check_all_' + type).checked)
		{
			for(i=0;i<document.getElementsByName(type + '_ids').length;i++)
			document.getElementsByName(type + '_ids')[i].checked = true;
		}
		else
		{
			for(i=0;i<document.getElementsByName(type + '_ids').length;i++)
			document.getElementsByName(type + '_ids')[i].checked = false;
		}
	}
	//numeric textbox yapıldı.
	/*function fncNumeric(e)
	{
		var key = e.which ? e.which : e.keyCode; 
		var src = e.target ? e.target : e.srcElement; 
		if(!(key>=48 && key<=57))
		{ 
			return false; 
		} 
		else return true; 
	}*/
</script>
