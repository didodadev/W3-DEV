<cfif isDefined('attributes.site_type') and (attributes.site_type eq 2 or attributes.site_type eq 3 or attributes.site_type eq 4)>
    <cfquery name="GET_SITE_DOMAIN" datasource="#DSN#">
        SELECT 
            SITE_DOMAIN 
        FROM 
            MAIN_MENU_SETTINGS 
        WHERE 
            MENU_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#"> AND 
            SITE_DOMAIN = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.site_domain#"> AND 
            IS_ACTIVE = 1
    </cfquery>
    <cfif get_site_domain.recordcount>
        <script type="text/javascript">
            alert("Bu Site Adıyla Aktif Bir Site Tanımı Bulunmaktadır !");
            history.back();
        </script>
        <cfabort>
    </cfif>
</cfif>

<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
<!--- 1.asset bas--->
<cfif isdefined("attributes.logo_file") and len(attributes.logo_file)>	
	<cfif len(attributes.old_logo_file)>
		<cf_del_server_file output_file="settings/#attributes.old_logo_file#" output_server="#attributes.old_logo_file_server_id#">
	</cfif>	
	<cftry>
		<cffile action = "upload" filefield="logo_file" destination = "#upload_folder#" nameconflict = "MakeUnique" mode="777">
		<cfcatch type="Any">
		<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
				history.back();
			</script>
		</cfcatch>
	</cftry>
	<cfset file_name = createUUID()>
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
	<cfset file_name_logo_file = '#file_name#.#cffile.serverfileext#'>
</cfif>

<!--- 1.asset son --->
<cfif isdefined("attributes.background_file") and len(attributes.background_file)>		
		<cfif len(attributes.old_background_file)>
			<cf_del_server_file output_file="settings/#attributes.old_background_file#" output_server="#attributes.old_background_file_server_id#">
		</cfif>		
	<cftry>
		<cffile action = "upload" filefield = "background_file" destination = "#upload_folder#" nameconflict = "MakeUnique" mode="777">
		<cfcatch type="Any">
		<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
				history.back();
			</script>
		</cfcatch>  
	</cftry>
	<cfset file_name3 = createUUID()>
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name3#.#cffile.serverfileext#">
	<cfset file_name_background_file = '#file_name3#.#cffile.serverfileext#'>
</cfif>

<cfscript>
	if(isdefined("to_emp_ids")) CC_EMPS = ListSort(to_emp_ids,"Numeric", "Desc"); else CC_EMPS ='';	
</cfscript>

<!--- menu backgroundlar --->
<cfif isdefined("attributes.bottom_menu_background") and len(attributes.bottom_menu_background)>		
		<cfif len(attributes.old_bottom_menu_background)>
			<cf_del_server_file output_file="settings/#attributes.old_bottom_menu_background#" output_server="#attributes.old_bottom_menu_background_server_id#">
		</cfif>		
	<cftry>
		<cffile action = "upload" filefield = "bottom_menu_background" destination = "#upload_folder#" nameconflict = "MakeUnique" mode="777">
		<cfcatch type="Any">
		<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
				history.back();
			</script>
		</cfcatch>
	</cftry>
	<cfset file_name7 = createUUID()>
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name7#.#cffile.serverfileext#">
	<cfset file_name_bottom_menu_background = '#file_name7#.#cffile.serverfileext#'>
</cfif>

<cfif isdefined("attributes.top_menu_background") and len(attributes.top_menu_background)>
		<cfif len(attributes.old_top_menu_background)>
			<cf_del_server_file output_file="settings/#attributes.old_top_menu_background#" output_server="#attributes.old_top_menu_background_server_id#">
		</cfif>		
	<cftry>
		<cffile action = "upload" filefield = "top_menu_background" destination = "#upload_folder#" nameconflict = "MakeUnique" mode="777">
		<cfcatch type="Any">
		<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
				history.back();
			</script>
		</cfcatch>  
	</cftry>
	<cfset file_name8 = createUUID()>
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name8#.#cffile.serverfileext#">
	<cfset file_name_top_menu_background = '#file_name8#.#cffile.serverfileext#'>
</cfif>

<cfif isdefined("attributes.center_menu_background") and len(attributes.center_menu_background)>		
		<cfif len(attributes.old_center_menu_background)>
			<cf_del_server_file output_file="settings/#attributes.old_center_menu_background#" output_server="#attributes.old_center_menu_background_server_id#">
		</cfif>		
	<cftry>
		<cffile action = "upload" filefield = "center_menu_background" destination = "#upload_folder#" nameconflict = "MakeUnique" mode="777">
		<cfcatch type="Any">
		<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
				history.back();
			</script>
		</cfcatch>
	</cftry>
	<cfset file_name9 = createUUID()>
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name9#.#cffile.serverfileext#">
	<cfset file_name_center_menu_background = '#file_name9#.#cffile.serverfileext#'>
</cfif>

<cfif isdefined("attributes.footer_menu_background") and len(attributes.footer_menu_background)>		
		<cfif len(attributes.old_footer_menu_background)>
			<cf_del_server_file output_file="settings/#attributes.old_footer_menu_background#" output_server="#attributes.old_footer_menu_background_server_id#">
		</cfif>		
	<cftry>
		<cffile action = "upload" filefield = "footer_menu_background" destination = "#upload_folder#" nameconflict = "MakeUnique" mode="777">
		<cfcatch type="Any">
		<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
				history.back();
			</script>
		</cfcatch>
	</cftry>
	<cfset file_name10 = createUUID()>
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name10#.#cffile.serverfileext#">
	<cfset file_name_footer_menu_background = '#file_name10#.#cffile.serverfileext#'>
</cfif>

<cfif isdefined("attributes.content_menu_background") and len(attributes.content_menu_background)>		
		<cfif len(attributes.old_content_menu_background)>
			<cf_del_server_file output_file="settings/#attributes.old_content_menu_background#" output_server="#attributes.old_content_menu_background_server_id#">
		</cfif>		
	<cftry>
		<cffile action = "upload" filefield = "content_menu_background" destination = "#upload_folder#" nameconflict = "MakeUnique" mode="777">
		<cfcatch type="Any">
		<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
				history.back();
			</script>
		</cfcatch>
	</cftry>
	<cfset file_name11 = createUUID()>
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name11#.#cffile.serverfileext#">
	<cfset file_name_content_menu_background = '#file_name11#.#cffile.serverfileext#'>
</cfif>
<!--- menu backgroundlar --->
<!--- ayrac buton --->
<cfif isdefined("attributes.ayrac_buton") and len(attributes.ayrac_buton)>		
		<cfif len(attributes.old_ayrac_buton)>
			<cf_del_server_file output_file="settings/#attributes.old_ayrac_buton#" output_server="#attributes.old_ayrac_buton_server_id#">
		</cfif>		
	<cftry>
		<cffile action = "upload" filefield = "ayrac_buton" destination = "#upload_folder#" nameconflict = "MakeUnique" mode="777">
		<cfcatch type="Any">
		<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
				history.back();
			</script>
		</cfcatch>
	</cftry>
	<cfset file_name12 = createUUID()>
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name12#.#cffile.serverfileext#">
	<cfset file_name_ayrac_buton = '#file_name12#.#cffile.serverfileext#'>
</cfif>

<cfquery name="UPD_TRAINING_CAT" datasource="#dsn#">
	UPDATE 
	  MAIN_MENU_SETTINGS 
	SET	
	  SITE_DOMAIN = <cfif isDefined('attributes.site_domain') and len(attributes.site_domain)>'#attributes.site_domain#',<cfelse>NULL,</cfif>
	  SITE_HEADERS = '#attributes.site_headers#',
	  MYHOME_FILE = '#attributes.myhome_file#',
	  MAIN_FILE = '#attributes.main_file#',
	  SECOND_FILE = '#attributes.second_file#',
	  FOOTER_FILE = '#attributes.footer_file#',
	  LOGIN_FILE = '#attributes.login_file#',
	  SABLON_FILE = '#attributes.sablon_file#',
	  IS_ALPHABETIC = <cfif isdefined("attributes.IS_ALPHABETIC")>1,<cfelse>0,</cfif>
	  IS_ACTIVE = <cfif isdefined("attributes.is_active")>1,<cfelse>0,</cfif>
	  IS_PUBLISH = <cfif isdefined("attributes.is_publish")>1,<cfelse>0,</cfif>
	  IS_LOGO = <cfif isdefined("attributes.is_logo")>1,<cfelse>0,</cfif>
      SITE_TYPE = <cfif isDefined('attributes.site_type') and len(attributes.site_type)>#attributes.site_type#<cfelse>NULL</cfif>,
	  IS_PASSWORD_CONTROL = <cfif isdefined("attributes.is_password_control")>1,<cfelse>0,</cfif>
	  IS_FLASH_LOGO = <cfif isdefined("attributes.is_flash_logo")>1,<cfelse>0,</cfif>
	  IS_LOGO_BLOCK = <cfif isdefined("attributes.IS_LOGO_BLOCK")>1,<cfelse>0,</cfif>
	  IS_TREE_MENU = <cfif isdefined("attributes.is_tree_menu")>1,<cfelse>0,</cfif>
	  <!---IS_AYRAC = <cfif isdefined("attributes.is_ayrac")>1,<cfelse>0,</cfif>--->
	  AYRAC_TEXT = <cfif len(attributes.ayrac_text)>'#attributes.ayrac_text#',<cfelse>NULL,</cfif>
	  LANGUAGE_ID = <cfif len(attributes.language_id)>'#attributes.language_id#',<cfelse>NULL,</cfif>
	  AYRAC_WIDTH = <cfif len(attributes.ayrac_width)>#attributes.ayrac_width#,<cfelse>NULL,</cfif>
	  POSITION_CAT_IDS = <cfif isDefined("FORM.position_cat_ids")>',#FORM.POSITION_CAT_IDS#,',<cfelse>NULL,</cfif>
	  COMPANY_CAT_IDS = <cfif isDefined("FORM.COMPANY_CAT_IDS")>',#FORM.COMPANY_CAT_IDS#,',<cfelse>NULL,</cfif>
	  CONSUMER_CAT_IDS = <cfif isDefined("FORM.CONSUMER_CAT_IDS")>',#FORM.CONSUMER_CAT_IDS#,',<cfelse>NULL,</cfif>
	  USER_GROUP_IDS = <cfif isDefined("FORM.USER_GROUP_IDS")>',#FORM.USER_GROUP_IDS#,',<cfelse>NULL,</cfif>
	  DEPARTMENT_IDS = <cfif isDefined("FORM.DEPARTMENT_IDS")>'#FORM.DEPARTMENT_IDS#',<cfelse>NULL,</cfif>
	  STOCK_TYPE = #attributes.stock_type#,
	  SITE_TITLE = <cfif len(attributes.site_title)>#sql_unicode()#'#attributes.site_title#',<cfelse>NULL,</cfif>
	  SITE_DESCRIPTION = <cfif len(attributes.description)>#sql_unicode()#'#attributes.description#',<cfelse>NULL,</cfif>
	  SITE_KEYWORDS = <cfif len(attributes.site_keywords)>#sql_unicode()#'#attributes.site_keywords#',<cfelse>NULL,</cfif>
	  MENU_NAME = #sql_unicode()#'#ATTRIBUTES.MENU_NAME#',
	  TO_EMPS = ',#CC_EMPS#,',
	  AYRAC_BUTON = <cfif len(attributes.ayrac_buton)>'#file_name_ayrac_buton#',<CFELSE>'#attributes.old_ayrac_buton#',</CFIF>
	  <cfif len(attributes.ayrac_buton)>AYRAC_BUTON_SERVER_ID = #fusebox.server_machine#,</CFIF>
	  LOGO_FILE = <cfif len(attributes.logo_file)>'#file_name_logo_file#',<CFELSE>'#attributes.old_logo_file#',</CFIF>
	  <cfif len(attributes.logo_file)>LOGO_FILE_SERVER_ID = #fusebox.server_machine#,</CFIF>
	  BACKGROUND_FILE = <cfif len(attributes.background_file)>'#file_name_background_file#',<CFELSE>'#attributes.old_background_file#',</CFIF>
	  <cfif len(attributes.background_file)>BACKGROUND_FILE_SERVER_ID = #fusebox.server_machine#,</CFIF>
	 <!--- AYRAC_RIGHT = <cfif len(attributes.ayrac_right)>'#file_name_ayrac_right#',<CFELSE>'#attributes.old_ayrac_right#',</CFIF>
	  <cfif len(attributes.ayrac_right)>AYRAC_RIGHT_SERVER_ID =#fusebox.server_machine#,</CFIF>
	  AYRAC_LEFT = <cfif len(attributes.ayrac_left)>'#file_name_ayrac_left#',<CFELSE>'#attributes.old_ayrac_left#',</CFIF>
	  <cfif len(attributes.ayrac_left)>AYRAC_LEFT_SERVER_ID = #fusebox.server_machine#,</CFIF>
	  AYRAC_CENTER = <cfif len(attributes.ayrac_center)>'#file_name_ayrac_center#',<CFELSE>'#attributes.old_ayrac_center#',</CFIF>
	  <cfif len(attributes.ayrac_center)>AYRAC_CENTER_SERVER_ID = #fusebox.server_machine#,</CFIF>--->
	  BOTTOM_MENU_BACKGROUND = <cfif len(attributes.bottom_menu_background)>'#file_name_bottom_menu_background#',<CFELSE>'#attributes.old_bottom_menu_background#',</CFIF>
	  <cfif len(attributes.bottom_menu_background)>BOTTOM_MENU_BG_SERVER_ID = #fusebox.server_machine#,</CFIF>
	  TOP_MENU_BACKGROUND = <cfif len(attributes.top_menu_background)>'#file_name_top_menu_background#',<CFELSE>'#attributes.old_top_menu_background#',</CFIF>
	  <cfif len(attributes.top_menu_background)>TOP_MENU_BACKGROUND_SERVER_ID = #fusebox.server_machine#,</CFIF>
	  CENTER_MENU_BACKGROUND = <cfif len(attributes.center_menu_background)>'#file_name_center_menu_background#',<CFELSE>'#attributes.old_center_menu_background#',</CFIF>
	   <cfif len(attributes.center_menu_background)>CENTER_MENU_BG_SERVER_ID =#fusebox.server_machine#,</CFIF>
	  FOOTER_MENU_BACKGROUND = <cfif len(attributes.footer_menu_background)>'#file_name_footer_menu_background#',<CFELSE>'#attributes.old_footer_menu_background#',</CFIF>
	  <cfif len(attributes.footer_menu_background)>FOOTER_MENU_BG_SERVER_ID = #fusebox.server_machine#,</CFIF>
	  CONTENT_MENU_BACKGROUND = <cfif len(attributes.content_menu_background)>'#file_name_content_menu_background#',<CFELSE>'#attributes.old_content_menu_background#',</CFIF>
	  <cfif len(attributes.content_menu_background)>CONTENT_MENU_BG_SERVER_ID =#fusebox.server_machine#,</CFIF>
	  BACKGROUND_COLOR = <cfif len(attributes.background_color)>'#attributes.background_color#',<cfelse>NULL,</cfif>
	  COLOR_TOP_MENU = <cfif len(attributes.color_top_menu)>'#attributes.color_top_menu#',<cfelse>NULL,</cfif>
	  COLOR_CENTER_MENU = <cfif len(attributes.color_center_menu)>'#attributes.color_center_menu#',<cfelse>NULL,</cfif>
	  COLOR_BOTTOM_MENU = <cfif len(attributes.color_bottom_menu)>'#attributes.color_bottom_menu#',<cfelse>NULL,</cfif>
	  COLOR_FOOTER_MENU = <cfif len(attributes.color_footer_menu)>'#attributes.color_footer_menu#',<cfelse>NULL,</cfif>
	  COLOR_CONTENT_MENU = <cfif len(attributes.color_content_menu)>'#attributes.color_content_menu#',<cfelse>NULL,</cfif>
	  LEFT_MARJIN = <cfif len(attributes.left_marjin)>#attributes.left_marjin#,<cfelse>NULL,</cfif>
	  TOP_MARJIN = <cfif len(attributes.top_marjin)>#attributes.top_marjin#,<cfelse>NULL,</cfif> 
	  LEFT_INNER_MARJIN = <cfif len(attributes.left_inner_marjin)>#attributes.left_inner_marjin#,<cfelse>NULL,</cfif>
	  TOP_INNER_MARJIN = <cfif len(attributes.top_inner_marjin)>#attributes.top_inner_marjin#,<cfelse>NULL,</cfif>	  
	  LOGO_HEIGHT = <cfif len(attributes.LOGO_HEIGHT)>#attributes.LOGO_HEIGHT#,<cfelse>NULL,</cfif>
	  LOGO_WIDTH = <cfif len(attributes.LOGO_WIDTH)>#attributes.LOGO_WIDTH#,<cfelse>NULL,</cfif>
	  GENERAL_WIDTH = <cfif len(attributes.GENERAL_WIDTH)>#attributes.GENERAL_WIDTH#,<cfelse>NULL,</cfif>
	  GENERAL_WIDTH_TYPE = '#attributes.GENERAL_WIDTH_TYPE#',
	  GENERAL_ALIGN = '#attributes.GENERAL_ALIGN#',
	  MAIN_HEIGHT = <cfif len(attributes.MAIN_HEIGHT)>'#attributes.MAIN_HEIGHT#',<cfelse>NULL,</cfif>
	  APP_KEY='#attributes.APP_KEY#',
	  SECOND_HEIGHT = <cfif len(attributes.SECOND_HEIGHT)>#attributes.SECOND_HEIGHT#,<cfelse>0,</cfif>
	  FOOTER_HEIGHT = <cfif len(attributes.FOOTER_HEIGHT)>'#attributes.FOOTER_HEIGHT#',<cfelse>NULL,</cfif>
	  MAIN_ALIGN = '#attributes.MAIN_ALIGN#',
	  MAIN_VALIGN = <cfif len(attributes.main_valign)>'#attributes.MAIN_VALIGN#',<cfelse>NULL,</cfif>
	  SECOND_ALIGN = '#attributes.SECOND_ALIGN#',
	  FOOTER_ALIGN = '#attributes.FOOTER_ALIGN#',
	  FOOTER_VALIGN = <cfif len(attributes.footer_valign)>'#attributes.FOOTER_VALIGN#',<cfelse>NULL,</cfif>
	 <!--- MENU_STYLE = <cfif len(attributes.menu_style)>#attributes.menu_style#,<cfelse>NULL,</cfif> --->
	  CSS_FILE = '#attributes.css_file#',
	  UPDATE_EMP = #SESSION.EP.USERID#,
	  UPDATE_DATE = #NOW()#,
	  UPDATE_IP = '#CGI.REMOTE_ADDR#',
      STD_DESCRIPTION = '#attributes.std_desc#'
	WHERE 
	  MENU_ID = #ATTRIBUTES.MENU_ID#
</cfquery>
<cfloop from="1" to="#attributes.record_num_sabit#" index="i">
	<cfif evaluate("attributes.row_kontrol_sabit_#i#") neq 0 and len(evaluate("attributes.menu_row_file_#i#"))>
		<cfif len(evaluate("attributes.old_menu_row_file_#i#"))>
			<cf_del_server_file output_file="settings/#evaluate("attributes.old_menu_row_file_#i#")#" output_server="#evaluate("attributes.old_menu_row_file_server_id_#i#")#">
		</cfif>		
		<cftry>
			<cffile action="upload" filefield="menu_row_file_#i#" destination="#upload_folder#" nameconflict="MakeUnique" mode="777">
			<cfcatch type="Any">
			<cfset error=1>
				<script type="text/javascript">
					alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
					history.back();
				</script>
				<cfabort>
			</cfcatch>
		</cftry>
		<cfset file_name11 = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name11#.#cffile.serverfileext#">
		<cfset 'file_menu_row_#i#' = '#file_name11#.#cffile.serverfileext#'>
	</cfif>
</cfloop>
<cftransaction>
	<cfloop from="1" to="#attributes.record_num_sabit#" index="i">
		<cfif evaluate("attributes.row_kontrol_sabit_#i#") neq 0>
			<cfquery name="UPD_MAIN_MENU_SELECTS" datasource="#dsn#">
				UPDATE 
					MAIN_MENU_SELECTS 
				SET
					<cfif isdefined("file_menu_row_#i#")>LINK_IMAGE = '#wrk_eval("file_menu_row_#i#")#',</cfif>
					<cfif isdefined("file_menu_row_#i#")>LINK_IMAGE_SERVER_ID = #fusebox.server_machine#,</cfif>
					IS_SESSION = <cfif isdefined("attributes.is_session_sabit_#i#")>1,<CFELSE>0,</cfif>
					LINK_NAME_TYPE = <cfif len(evaluate("attributes.link_name_type_sabit_#i#"))>#evaluate("attributes.link_name_type_sabit_#i#")#<cfelse>0</cfif>,
					LINK_AREA = #evaluate("attributes.link_area_sabit_#i#")#,
					ORDER_NO = <cfif isnumeric(#evaluate("attributes.order_no_sabit_#i#")#)>#evaluate("attributes.order_no_sabit_#i#")#,<cfelse>NULL,</cfif>
					SELECTED_LINK = '#wrk_eval("attributes.selected_link_sabit_#i#")#',
					LINK_TYPE = #evaluate("attributes.link_type_sabit_#i#")#,
					MENU_ID = #ATTRIBUTES.MENU_ID#,
					LINK_NAME = <cfif evaluate("attributes.link_name_type_sabit_#i#") eq 0>#sql_unicode()#'#wrk_eval("attributes.link_name2_sabit_#i#")#'<cfelse>#sql_unicode()#'#wrk_eval("attributes.link_name_id_sabit_#i#")#'</cfif>,
					LOGIN_CONTROL = #evaluate("attributes.login_control_#i#")#
				WHERE
					SELECTED_ID = #evaluate("attributes.selected_id_sabit_#i#")#
			</cfquery>
		<cfelse>
			<cfquery name="DEL_" datasource="#dsn#">
				DELETE FROM MAIN_MENU_SELECTS WHERE SELECTED_ID = #evaluate("attributes.selected_id_sabit_#i#")#
			</cfquery>
		</cfif>
	</cfloop>
	<cfloop from="1" to="#attributes.record_num#" index="i">
		<cfif evaluate("attributes.row_kontrol#i#") neq 0>
            <cfquery name="ADD_PURCHASE_JOIN_WITHOUT" datasource="#dsn#">
                INSERT INTO
                    MAIN_MENU_SELECTS 
                    (
                        IS_SESSION,
                        ORDER_NO,
                        LINK_AREA,
                        SELECTED_LINK,
                        LINK_TYPE,
                        MENU_ID,
                        LINK_NAME_TYPE,
                        LINK_NAME,
                        LOGIN_CONTROL
                    )
                	VALUES
                    (
                        <cfif isdefined("attributes.is_session_#i#")>1,<CFELSE>0,</cfif>
                        <cfif isnumeric(#evaluate("attributes.order_no#i#")#)>#evaluate("attributes.order_no#i#")#,<cfelse>NULL,</cfif>
                        #evaluate("attributes.link_area#i#")#,
                        '#wrk_eval("attributes.selected_link#i#")#',
                        #evaluate("attributes.link_type#i#")#,
                        #attributes.menu_id#,
                        <cfif len(evaluate("attributes.link_name_type#i#"))>#evaluate("attributes.link_name_type#i#")#<cfelse>0</cfif>,
                        <cfif len(evaluate("attributes.link_name_type#i#")) and evaluate("attributes.link_name_type#i#") eq 0>#sql_unicode()#'#wrk_eval("attributes.link_name2#i#")#'<cfelse>#sql_unicode()#'#wrk_eval("attributes.link_name_id#i#")#'</cfif>,
                        #evaluate("attributes.login_control#i#")#
                    )
            </cfquery>
        </cfif>
	</cfloop>
</cftransaction>
<script type="text/javascript">
	window.location.href = "<cfoutput>#request.self#?fuseaction=settings.list_main_menu&event=upd&menu_id=#attributes.menu_id#</cfoutput>";
</script>