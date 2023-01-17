<cfinclude template="set_cookies.cfm">
<cfquery name="GET_MY_" datasource="#DSN#" maxrows="1">
	SELECT 
		IS_PASSWORD_CONTROL,
		MENU_ID,
		IS_PUBLISH,
		LEFT_MARJIN,
		TOP_MARJIN,
		GENERAL_WIDTH,
		GENERAL_WIDTH_TYPE,
        COLOR_CONTENT_MENU,
        CONTENT_MENU_BACKGROUND,
        CONTENT_MENU_BG_SERVER_ID,
		GENERAL_ALIGN,
		TOP_INNER_MARJIN,
		LEFT_INNER_MARJIN
	FROM 
		MAIN_MENU_SETTINGS 
	WHERE 
		<cfif isdefined("session.pp.menu_id")>
			MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.menu_id#">
		<cfelseif isdefined("session.ww.our_company_id") and isdefined("session.ww.menu_id") and len(session.ww.menu_id) and session.ww.menu_id neq 0>
			MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.menu_id#"> 
		<cfelseif isdefined("session.cp.our_company_id")>
			IS_ACTIVE = 1 AND IS_CAREER = 1 AND SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#">
		<cfelseif isdefined("session.ww.our_company_id")>
			IS_ACTIVE = 1 AND SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#">
		<cfelseif isdefined("session.ww.our_company_id")>
			IS_ACTIVE = 1 AND SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#">
		<cfelseif isdefined("session.ep")>
			IS_ACTIVE = 1 AND SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#">
		<cfelseif isdefined("attributes.ma")>
			MENU_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.menu_id#">
		<cfelse>
            IS_ACTIVE = 1 AND 
			SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.http_host#">
		</cfif>
</cfquery>

<cfif not get_my_.recordcount>
	<cf_get_lang no ='1202.Bu sistem için public portal tanımı yapılmamış'>.
	<cfexit method="exittemplate">
</cfif>
<div id="_message_" align="center" class="sepet_div_menu" style="display:none;position:absolute;font:Verdana, Arial, Helvetica, sans-serif;font-size:18px; left:1; top:1; width:400px; height:120px; z-index:9999;"></div>

<cfif get_my_.is_password_control eq 1>
	<cfif isdefined("session.pp.userid") or isdefined("session.ww.userid")>
		<cfquery name="CHECK_PASSWORD" datasource="#DSN#">
			SELECT 
				LAST_PASSWORD_CHANGE 
			FROM 
				<cfif isdefined("session.pp.userid")>COMPANY_PARTNER<cfelse>CONSUMER</cfif>
			WHERE 
				<cfif isdefined("session.pp.userid")>PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.userid#"><cfelse>CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"></cfif>
		</cfquery>
		<cfif not len(check_password.last_password_change)>
			<cfif isdefined("session.pp.userid") and fusebox.fuseaction is not 'form_upd_partner'>
				<script type="text/javascript">
					alert("<cf_get_lang no ='1548.Lütfen Şifre Bilginizi Değiştiriniz'>!");
					window.location.href = '<cfoutput>#request.self#?fuseaction=objects2.form_upd_partner&pid=#session.pp.userid#</cfoutput>';
				</script>
				<cfabort>
			<cfelseif isdefined("session.ww.userid") and fusebox.fuseaction is not 'me'>
				<script type="text/javascript">
					alert("<cf_get_lang no ='1548.Lütfen Şifre Bilginizi Değiştiriniz'>!");
					window.location.href = '<cfoutput>#request.self#?fuseaction=objects2.me</cfoutput>';
				</script>
				<cfabort>
			</cfif>
		</cfif>	
	</cfif>
</cfif>

<cfset fuseact_ = replace(attributes.fuseaction,'autoexcelpopuppage_','','all')>
<cfstoredproc procedure="GET_SITE_PAGES" datasource="#DSN#">
	<cfif fuseact_ is 'user_friendly'>
   		<cfprocparam cfsqltype="cf_sql_varchar" value="#attributes.user_friendly_url#">
    <cfelse>
    	<cfprocparam cfsqltype="cf_sql_varchar" value="">
	</cfif>
    <cfprocparam cfsqltype="cf_sql_varchar" value="#listlast(fuseact_,'.')#">
    <cfprocparam cfsqltype="cf_sql_integer" value="#get_my_.menu_id#">
    <cfprocresult name="GET_SITE_PAGES">
</cfstoredproc>
<cfif get_my_.is_publish eq 1>
	<div id="popup_site_manage" style="position:absolute;width:40px;height:11px;z-index:2;left:1;top:1;"><a href="javascript://" onclick="windowopen('<cfoutput>http://#ListFirst(employee_url,';')#/index.cfm?fuseaction=settings.popup_select_site_objects<cfif listlast(fuseact_,'.') is 'user_friendly'>&faction=#attributes.user_friendly_url#<cfelse>&faction=#listlast(fuseact_,'.')#</cfif>&menu_id=#get_my_.menu_id#</cfoutput>','list')"><font color="red"><cf_get_lang_main no='1306.Düzenle'></font></a></div>
</cfif>
<cfif get_site_pages.recordcount>
	<cfset property_row_id_list = valuelist(get_site_pages.row_id)>
	<cfquery name="GET_ROW_PROPERTIES_" datasource="#DSN#">
		SELECT ROW_ID, PROPERTY_NAME, PROPERTY_VALUE FROM MAIN_SITE_LAYOUTS_SELECTS_PROPERTIES WHERE ROW_ID IN (#property_row_id_list#)
	</cfquery>
	<cfquery name="GET_1" dbtype="query">
		SELECT * FROM GET_SITE_PAGES WHERE OBJECT_POSITION = 1 ORDER BY ORDER_NUMBER
	</cfquery>
	<cfquery name="GET_2" dbtype="query">
		SELECT * FROM GET_SITE_PAGES WHERE OBJECT_POSITION = 2 ORDER BY ORDER_NUMBER
	</cfquery>
	<cfquery name="GET_3" dbtype="query">
		SELECT * FROM GET_SITE_PAGES WHERE OBJECT_POSITION = 3 ORDER BY ORDER_NUMBER
	</cfquery>
	<cfquery name="GET_4" dbtype="query">
		SELECT * FROM GET_SITE_PAGES WHERE OBJECT_POSITION = 4 ORDER BY ORDER_NUMBER
	</cfquery>
	<cfset cols_ = 0>
	<cfif (len(get_site_pages.left_width) and get_site_pages.left_width gt 0) or (get_1.recordcount)>
		<cfset cols_ = cols_ + 1>
	</cfif>
	<cfif get_2.recordcount>
		<cfset cols_ = cols_ + 1>
		<cfif (len(get_site_pages.left_width) and get_site_pages.left_width gt 0) or (get_1.recordcount)>
			<cfset cols_ = cols_ + 1>
		</cfif>
	</cfif>
	<cfif get_3.recordcount>
		<cfset cols_ = cols_ + 1>
		<cfif (len(get_site_pages.left_width) and get_site_pages.left_width gt 0) or (get_2.recordcount) or (not get_2.recordcount and get_1.recordcount)>
			<cfset cols_ = cols_ + 1>
		</cfif>
	</cfif>
	<cfif len(get_my_.left_marjin)>
		<cfset my_margin_left_ = get_my_.left_marjin>
	<cfelse>
		<cfset my_margin_left_ = ''>
	</cfif>
	<cfif len(get_my_.top_marjin)>
		<cfset my_margin_top_ = get_my_.top_marjin>
	<cfelse>
		<cfset my_margin_top_ = ''>
	</cfif>
    <section style="<cfif len(get_my_.content_menu_background)>background-image:url(<cf_get_server_file output_file="settings/#get_my_.content_menu_background#" output_server="#get_my_.content_menu_bg_server_id#" output_type="4" alt="#lang_array.item[1315]#" title="#lang_array.item[1315]#">);<cfelse>background-color:###get_my_.color_content_menu#;</cfif><cfif len(get_my_.top_inner_marjin)>margin-top:<cfoutput>#get_my_.top_inner_marjin#</cfoutput>px;</cfif>" class="main">
    	<cfif get_4.recordcount>
            <section class="main_area" style="width:100%;margin-left:<cfoutput>#get_site_pages.margin#</cfoutput>px;margin-right:<cfoutput>#get_site_pages.margin#</cfoutput>px;">
            	<cfoutput query="get_4">
					<cfset this_row_id_ = row_id>
                    <cfset this_design_id_ = design_id>
                    <cfif listfindnocase(property_row_id_list,row_id)>
                        <cfquery name="GET_THIS_PROPERTIES" dbtype="query">
                            SELECT * FROM GET_ROW_PROPERTIES_ WHERE ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#row_id#">
                        </cfquery>
                        <cfloop query="get_this_properties">
                            <cfset 'attributes.#property_name#' = property_value>
                        </cfloop>
                    </cfif>
                    <cfsavecontent variable="content_class_name">#class_css_name#</cfsavecontent>
                    <cfsavecontent variable="content_header">#object_name#</cfsavecontent>
                    <cfsavecontent variable="content"><cfinclude template="../#object_folder#/#object_file_name#"></cfsavecontent>
                    <cfif len(content)>
                        <cfquery name="GET_DESIGN_STYLE" datasource="#DSN#">
                            SELECT DESIGN_PATH FROM MAIN_SITE_OBJECT_DESIGN WHERE DESIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#design_id#">
                        </cfquery>
                       	<div id="area_#this_row_id_#" align="center" style="width:100%;">
                            <cfinclude template="../../#get_design_style.design_path#">
                       	</div>
                        <br/>
                    </cfif>
				</cfoutput>                
            </section>
        </cfif>
        <cfif get_1.recordcount>
        	<section class="main_area" style="width:<cfoutput>#get_site_pages.left_width#</cfoutput>px; margin-left:<cfoutput>#get_site_pages.margin#</cfoutput>px;">
				<cfoutput query="get_1">
					<cfset this_row_id_ = row_id>
                    <cfset this_design_id_ = design_id>
                    <cfif listfindnocase(property_row_id_list,row_id)>
                        <cfquery name="GET_THIS_PROPERTIES" dbtype="query">
                            SELECT * FROM GET_ROW_PROPERTIES_ WHERE ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#row_id#">
                        </cfquery>
                        <cfloop query="get_this_properties">
                            <cfset 'attributes.#property_name#' = property_value>
                        </cfloop>
                    </cfif>
                    <cfsavecontent variable="content_class_name">#class_css_name#</cfsavecontent>
                    <cfsavecontent variable="content_header">#object_name#</cfsavecontent>
                    <cfsavecontent variable="content"><cfinclude template="../#object_folder#/#object_file_name#"></cfsavecontent>
                    <cfif len(content)>
                        <cfquery name="GET_DESIGN_STYLE" datasource="#DSN#">
                            SELECT DESIGN_PATH FROM MAIN_SITE_OBJECT_DESIGN WHERE DESIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#design_id#">
                        </cfquery>
                        <div id="area_#this_row_id_#"  <cfif len(get_site_pages.left_width)>style="width:#get_site_pages.left_width#px;"</cfif>>
                            <cfinclude template="../../#get_design_style.design_path#">
                        </div>
                        <br/>
                    </cfif>                          
                </cfoutput>
            </section>
        </cfif>
        <cfif get_2.recordcount>
        	<section class="main_area" style="width:<cfoutput>#get_site_pages.center_width#</cfoutput>px; margin-left:<cfoutput>#get_site_pages.margin#</cfoutput>px;">
				<cfoutput query="get_2">
					<cfset this_row_id_ = row_id>
                    <cfset this_design_id_ = design_id>
                    <cfif listfindnocase(property_row_id_list,row_id)>
                        <cfquery name="GET_THIS_PROPERTIES" dbtype="query">
                            SELECT * FROM GET_ROW_PROPERTIES_ WHERE ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#row_id#">
                        </cfquery>
                        <cfloop query="get_this_properties">
                            <cfset 'attributes.#property_name#' = property_value>
                        </cfloop>
                    </cfif>
                    <cfsavecontent variable="content_class_name">#class_css_name#</cfsavecontent>
                    <cfsavecontent variable="content_header">#object_name#</cfsavecontent>
                    <cfsavecontent variable="content"><cfinclude template="../#object_folder#/#object_file_name#"></cfsavecontent>
                    <cfif len(content)>
                        <cfquery name="GET_DESIGN_STYLE" datasource="#DSN#">
                            SELECT DESIGN_PATH FROM MAIN_SITE_OBJECT_DESIGN WHERE DESIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#design_id#">
                        </cfquery>
                        <div id="area_#this_row_id_#"  <cfif len(get_site_pages.center_width)>style="width:#get_site_pages.center_width#px;"</cfif>>
                            <cfinclude template="../../#get_design_style.design_path#">
                        </div>
                        <br/>
                    </cfif>                           
                </cfoutput>
            </section>
        </cfif>
        <cfif get_3.recordcount>
        	<section class="main_area" style="width:<cfoutput>#get_site_pages.right_width#</cfoutput>px; margin-left:<cfoutput>#get_site_pages.margin#</cfoutput>px;">
				<cfoutput query="get_3">
                    <cfset this_row_id_ = row_id>
                    <cfset this_design_id_ = design_id>
                    <cfif listfindnocase(property_row_id_list,row_id)>
                        <cfquery name="GET_THIS_PROPERTIES" dbtype="query">
                            SELECT * FROM GET_ROW_PROPERTIES_ WHERE ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#row_id#">
                        </cfquery>
                        <cfloop query="get_this_properties">
                            <cfset 'attributes.#property_name#' = property_value>
                        </cfloop>
                    </cfif>
                    <cfsavecontent variable="content_class_name">#class_css_name#</cfsavecontent>
                    <cfsavecontent variable="content_header">#object_name#</cfsavecontent>
                    <cfsavecontent variable="content"><cfinclude template="../#object_folder#/#object_file_name#"></cfsavecontent>
                    <cfif len(content)>
                        <cfquery name="GET_DESIGN_STYLE" datasource="#DSN#">
                            SELECT DESIGN_PATH FROM MAIN_SITE_OBJECT_DESIGN WHERE DESIGN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#design_id#">
                        </cfquery>
                        <div id="area_#this_row_id_#"  <cfif len(get_site_pages.right_width)>style="width:#get_site_pages.right_width#px;"</cfif>>
                            <cfinclude template="../../#get_design_style.design_path#">
                        </div>
                        <br/>
                    </cfif>                           
                </cfoutput>
            </section>
        </cfif>
    </section>
    <!-- sil -->
    <div id="_working_" align="center" class="sepet_div_menu" style="display:none;">
        <cf_get_lang no ='1137.Ürün Sepete Atıldı'>
    </div>
	<!-- sil -->
	<cfif (not len(cgi.http_referer) or cgi.http_referer contains 'login') and fusebox.fuseaction is 'welcome'>
		<cfinclude template="control_notice.cfm">
	</cfif>
<cfelse>
	<cf_get_lang_main no ='614.Bu Action İçin Sayfa Tanımı Yapılmamış'>
</cfif>
<script type="text/javascript">
	<cfif len(get_my_.general_width)>
		ekran_bosluk = document.body.clientWidth - <cfoutput>#get_my_.general_width#</cfoutput>;
	<cfelse>
		ekran_bosluk = 800;
	</cfif>
	<cfif get_my_.general_align is 'center'>
		baslangic_ = ekran_bosluk / 2;
	<cfelseif get_my_.general_align is 'left'>
		baslangic_ = 0;
	<cfelse>
		baslangic_ = ekran_bosluk;
	</cfif>
</script>

<style type="text/css">
	.error_close { position:absolute; right:0px;background:url(../../objects2/image/close.png); no-repeat; width:30px; height:30px; cursor:pointer; }
</style>
