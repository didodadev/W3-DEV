<!--- menu genel bilgiler --->
<cfquery name="GET_OLD_MENU" datasource="#DSN#">
	SELECT 
		OUR_COMPANY_ID, 
		IS_ALPHABETIC, 
		IS_ACTIVE,
        SITE_TYPE,
		IS_PUBLISH,
		IS_PARTNER,
		IS_LOGO,
		IS_FLASH_LOGO,
		IS_VISUAL,
		IS_TREE_MENU,
		IS_PASSWORD_CONTROL,
		AYRAC_TEXT,
		AYRAC_WIDTH,
		LOGO_HEIGHT,
		LOGO_WIDTH,
		MENU_NAME ,
		MAIN_HEIGHT,
		MAIN_ALIGN,
		MAIN_VALIGN,
		MAIN_BACKGROUND,
		MAIN_LINK,
		SECOND_ALIGN,
		SECOND_HEIGHT,
		BACKGROUND_COLOR,
		COLOR_TOP_MENU,
		COLOR_CENTER_MENU,
		COLOR_BOTTOM_MENU,
		COLOR_FOOTER_MENU,
		COLOR_CONTENT_MENU,
		FOOTER_ALIGN,
		FOOTER_VALIGN,
		FOOTER_HEIGHT,
		LEFT_MARJIN,
		TOP_MARJIN,
		LEFT_INNER_MARJIN,
		TOP_INNER_MARJIN,
		SECOND_BACKGROUND,
		SECOND_LINK,
		USER_GROUP_IDS,
		POSITION_CAT_IDS,
		COMPANY_CAT_IDS,
		CONSUMER_CAT_IDS,
		DEPARTMENT_IDS ,
		TO_EMPS,
		GENERAL_ALIGN,
		GENERAL_WIDTH_TYPE,
		GENERAL_WIDTH,
		STOCK_TYPE,
		CSS_FILE,
		LANGUAGE_ID,
		SITE_TITLE,
		SITE_DESCRIPTION,
		SITE_KEYWORDS,
		SITE_HEADERS,
		MAIN_FILE,
		SECOND_FILE,
		FOOTER_FILE,
		MYHOME_FILE,
		LOGIN_FILE,
		SABLON_FILE 
	FROM 
		MAIN_MENU_SETTINGS 
	WHERE 
		MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
</cfquery>
<!--- menu genel bilgiler --->

<!--- menu linkler --->
<cfquery name="GET_MAIN_MENU_SELECT" datasource="#DSN#">
	SELECT 
		ORDER_NO,
		SELECTED_ID,
		LINK_AREA,
		SELECTED_LINK,
		LINK_TYPE,
		LINK_NAME,
		LINK_NAME_TYPE,
		IS_SESSION,
		LOGIN_CONTROL 
	FROM 
		MAIN_MENU_SELECTS 
	WHERE 
		MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
</cfquery>
<!--- menu linkler --->

<!--- menu layer sayfalar --->
<cfquery name="GET_LAYERS" datasource="#DSN#">
	SELECT 
		LAYER_ROW_ID,
		SELECTED_ID, 
		ORDER_NO, 
		LINK_TYPE,
		LINK_NAME,
		LINK_NAME_TYPE,
		IS_SESSION,
		MAIN_LAYER_ROW_ID,
		LOGIN_CONTROL,
		SELECTED_LINK 
	FROM 
		MAIN_MENU_LAYER_SELECTS 
	WHERE 
		MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
</cfquery>
<!--- menu layer sayfalar --->

<!--- menu alt sayfalar --->
<cfquery name="GET_SUBS" datasource="#DSN#">
	SELECT IS_VIEW, LAYER_ROW_ID FROM MAIN_MENU_SUB_SELECTS WHERE MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
</cfquery>
<!--- menu alt sayfalar --->

<!--- menu sayfalar --->
<cfquery name="GET_LAYOUTS" datasource="#DSN#">
	SELECT 
		FACTION, 
		LEFT_WIDTH, 
		RIGHT_WIDTH, 
		CENTER_WIDTH, 
		MARGIN, 
		LEFT_DESIGN_ID ,
		RIGHT_DESIGN_ID,
		CENTER_DESIGN_ID,
		LEFT_OBJECT_NAME,
		RIGHT_OBJECT_NAME,
		CENTER_OBJECT_NAME
	FROM 
		MAIN_SITE_LAYOUTS 
	WHERE 
		MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
</cfquery>
<!--- menu sayfalar --->

<!--- menu alt sayfalar --->
<cfquery name="GET_LAYOUTS_SELECT" datasource="#DSN#">
	SELECT 
		OBJECT_POSITION, 
		OBJECT_NAME,
		FACTION, 
		ORDER_NUMBER, 
		OBJECT_FOLDER,
		OBJECT_FILE_NAME,
		DESIGN_ID,
		CLASS_CSS_NAME,
		ROW_ID   
	FROM 
		MAIN_SITE_LAYOUTS_SELECTS 
	WHERE 
		MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
</cfquery>
<!--- menu layer sayfalar --->

<!--- menu genel bilgiler kopyalaniyor --->
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_NEW_MENU" datasource="#DSN#">
			INSERT INTO
				MAIN_MENU_SETTINGS
				(
					OUR_COMPANY_ID,
					IS_ALPHABETIC,
					IS_ACTIVE,
        			SITE_TYPE,
					IS_PUBLISH,
					IS_LOGO,
					IS_FLASH_LOGO,
					IS_VISUAL,
					IS_TREE_MENU,
					IS_PASSWORD_CONTROL,
					<!---IS_AYRAC,--->
					AYRAC_TEXT,
					AYRAC_WIDTH,
					LOGO_HEIGHT,
					LOGO_WIDTH,
					MENU_NAME,
					MAIN_HEIGHT,
					MAIN_ALIGN,
					MAIN_VALIGN,
					MAIN_BACKGROUND,
					MAIN_LINK,
					SECOND_ALIGN,
					SECOND_HEIGHT,
					BACKGROUND_COLOR,
					COLOR_TOP_MENU,
					COLOR_CENTER_MENU,
					COLOR_BOTTOM_MENU,
					COLOR_FOOTER_MENU,
					COLOR_CONTENT_MENU,
					FOOTER_ALIGN,
					FOOTER_VALIGN,
					FOOTER_HEIGHT,
					LEFT_MARJIN,
					TOP_MARJIN,
					LEFT_INNER_MARJIN,
					TOP_INNER_MARJIN,
					SECOND_BACKGROUND,
					SECOND_LINK,
					USER_GROUP_IDS,
					POSITION_CAT_IDS,
					COMPANY_CAT_IDS,
					CONSUMER_CAT_IDS,
					DEPARTMENT_IDS,
					TO_EMPS,
					GENERAL_ALIGN,
					GENERAL_WIDTH_TYPE,
					GENERAL_WIDTH,
					<!---MENU_STYLE, --->
					STOCK_TYPE,
					CSS_FILE,
					LANGUAGE_ID,
					SITE_TITLE,
					SITE_DESCRIPTION,
					SITE_KEYWORDS,
					SITE_HEADERS,
					MAIN_FILE,
					SECOND_FILE,
					FOOTER_FILE,
					MYHOME_FILE,
					LOGIN_FILE,
					SABLON_FILE,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
			VALUES
				(
					<cfif len(get_old_menu.our_company_id)>#get_old_menu.our_company_id#,<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.is_alphabetic)>#get_old_menu.is_alphabetic#,<cfelse>0,</cfif>
					<cfif len(get_old_menu.is_active)>#get_old_menu.is_active#,<cfelse>0,</cfif>
					<cfif len(get_old_menu.site_type)>#get_old_menu.site_type#,<cfelse>0,</cfif>
					<cfif len(get_old_menu.is_publish)>#get_old_menu.is_publish#,<cfelse>0,</cfif>
					<cfif len(get_old_menu.is_logo)>#get_old_menu.is_logo#,<cfelse>0,</cfif>
					<cfif len(get_old_menu.is_flash_logo)>#get_old_menu.is_flash_logo#,<cfelse>0,</cfif>
					<cfif len(get_old_menu.is_visual)>#get_old_menu.is_visual#,<cfelse>0,</cfif>
					<cfif len(get_old_menu.is_tree_menu)>#get_old_menu.is_tree_menu#,<cfelse>0,</cfif>
					<cfif len(get_old_menu.is_password_control)>#get_old_menu.is_password_control#,<cfelse>0,</cfif>
					<!---<cfif len(get_old_menu.is_ayrac)>#get_old_menu.is_ayrac#,<cfelse>0,</cfif>--->
					<cfif len(get_old_menu.ayrac_text)>'#get_old_menu.ayrac_text#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.ayrac_width)>#get_old_menu.ayrac_width#,<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.logo_height)>#get_old_menu.logo_height#,<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.logo_width)>#get_old_menu.logo_width#,<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.menu_name)>#sql_unicode()#'#get_old_menu.menu_name# (2)',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.main_height)>#get_old_menu.main_height#,<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.main_align)>'#get_old_menu.main_align#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.main_valign)>'#get_old_menu.main_valign#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.main_background)>'#get_old_menu.main_background#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.main_link)>'#get_old_menu.main_link#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.second_align)>'#get_old_menu.second_align#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.second_height)>#get_old_menu.second_height#,<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.background_color)>'#get_old_menu.background_color#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.color_top_menu)>'#get_old_menu.color_top_menu#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.color_center_menu)>'#get_old_menu.color_center_menu#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.color_bottom_menu)>'#get_old_menu.color_bottom_menu#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.color_footer_menu)>'#get_old_menu.color_footer_menu#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.color_content_menu)>'#get_old_menu.color_content_menu#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.footer_align)>'#get_old_menu.footer_align#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.footer_valign)>'#get_old_menu.footer_valign#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.footer_height)>#get_old_menu.footer_height#,<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.left_marjin)>#get_old_menu.left_marjin#,<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.top_marjin)>#get_old_menu.top_marjin#,<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.left_inner_marjin)>#get_old_menu.left_inner_marjin#,<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.top_inner_marjin)>#get_old_menu.top_inner_marjin#,<cfelse>NULL,</cfif>
					'#get_old_menu.second_background#',
					'#get_old_menu.second_link#',
					<cfif listlen(get_old_menu.user_group_ids)>'#get_old_menu.user_group_ids#',<cfelse>NULL,</cfif>
					<cfif listlen(get_old_menu.position_cat_ids)>'#get_old_menu.position_cat_ids#',<cfelse>NULL,</cfif>
					<cfif listlen(get_old_menu.company_cat_ids)>'#get_old_menu.company_cat_ids#',<cfelse>NULL,</cfif>
					<cfif listlen(get_old_menu.consumer_cat_ids)>'#get_old_menu.consumer_cat_ids#',<cfelse>NULL,</cfif>
					<cfif listlen(get_old_menu.department_ids)>'#get_old_menu.department_ids#',<cfelse>NULL,</cfif>
					<cfif listlen(get_old_menu.to_emps)>'#get_old_menu.to_emps#',<cfelse>NULL,</cfif>
					'#get_old_menu.general_align#',
					'#get_old_menu.general_width_type#',
					<cfif len(get_old_menu.general_width)>#get_old_menu.general_width#,<cfelse>NULL,</cfif>
					<!---<cfif len(get_old_menu.menu_style)>#get_old_menu.menu_style#,<cfelse>null,</cfif> --->
					<cfif len(get_old_menu.stock_type)>#get_old_menu.stock_type#,<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.css_file)>'#get_old_menu.css_file#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.language_id)>'#get_old_menu.language_id#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.site_title)>'#get_old_menu.site_title#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.site_description)>'#get_old_menu.site_description#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.site_keywords)>'#get_old_menu.site_keywords#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.site_headers)>'#get_old_menu.site_headers#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.main_file)>'#get_old_menu.main_file#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.second_file)>'#get_old_menu.second_file#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.footer_file)>'#get_old_menu.footer_file#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.myhome_file)>'#get_old_menu.myhome_file#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.login_file)>'#get_old_menu.login_file#',<cfelse>NULL,</cfif>
					<cfif len(get_old_menu.sablon_file)>'#get_old_menu.sablon_file#',<cfelse>NULL,</cfif>
					#now()#,
					#session.ep.userid#,
					'#CGI.REMOTE_ADDR#'
				)
		</cfquery>
		<cfquery name="GET_" datasource="#DSN#" maxrows="1">
			SELECT MENU_ID FROM MAIN_MENU_SETTINGS ORDER BY MENU_ID DESC
		</cfquery>
		
		<cfloop query="get_main_menu_select">
			<cfquery name="ADD_NEW_MENU" datasource="#DSN#">
				INSERT INTO
					MAIN_MENU_SELECTS
					(
						ORDER_NO,
						LINK_AREA,
						SELECTED_LINK,
						LINK_TYPE,
						MENU_ID,
						LINK_NAME,
						LINK_NAME_TYPE,
						IS_SESSION,
						LOGIN_CONTROL
					)
				VALUES
					(
						<cfif len(get_main_menu_select.order_no)>#get_main_menu_select.order_no#,<cfelse>NULL,</cfif>
						#get_main_menu_select.link_area#,
						'#get_main_menu_select.selected_link#',
						#get_main_menu_select.link_type#,
						#get_.menu_id#,
						#sql_unicode()#'#get_main_menu_select.link_name#',
						<cfif len(get_main_menu_select.link_name_type)>#get_main_menu_select.link_name_type#,<cfelse>NULL,</cfif>
						<cfif len(get_main_menu_select.is_session)>#get_main_menu_select.is_session#,<cfelse>0,</cfif>
						<cfif len(get_main_menu_select.login_control)>#get_main_menu_select.login_control#<cfelse>NULL</cfif>
					)
			</cfquery>
			<cfquery name="GET_1" datasource="#DSN#" maxrows="1">
				SELECT SELECTED_ID FROM MAIN_MENU_SELECTS ORDER BY SELECTED_ID DESC
			</cfquery>
			
			<cfquery name="GET_ALT_LAYERS" dbtype="query">
				SELECT * FROM GET_LAYERS WHERE SELECTED_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_main_menu_select.selected_id#">
			</cfquery>
			<cfloop query="get_alt_layers">		
				<cfquery name="ADD_NEW_MENU" datasource="#DSN#">
					INSERT INTO
						MAIN_MENU_LAYER_SELECTS
						(
							ORDER_NO,
							SELECTED_ID,
							SELECTED_LINK,
							LINK_TYPE,
							MENU_ID,
							LINK_NAME,
							LINK_NAME_TYPE,
							IS_SESSION,
							MAIN_LAYER_ROW_ID,
							LOGIN_CONTROL
						)
					VALUES
						(
							<cfif len(get_alt_layers.order_no)>#get_alt_layers.order_no#,<cfelse>NULL,</cfif>
							#get_1.selected_id#,
							'#get_alt_layers.selected_link#',
							#get_alt_layers.link_type#,
							#get_.menu_id#,
							#sql_unicode()#'#get_alt_layers.link_name#',
							<cfif len(get_alt_layers.link_name_type)>#get_alt_layers.link_name_type#,<cfelse>NULL,</cfif>
							<cfif len(get_alt_layers.is_session)>#get_alt_layers.is_session#,<cfelse>0,</cfif>
							'#get_alt_layers.main_layer_row_id#',
							<cfif len(get_alt_layers.login_control)>#get_alt_layers.login_control#<cfelse>NULL</cfif>
						)
				</cfquery>
				<cfquery name="GET_2" datasource="#DSN#" maxrows="1">
					SELECT LAYER_ROW_ID,SELECTED_ID FROM MAIN_MENU_LAYER_SELECTS ORDER BY LAYER_ROW_ID DESC
				</cfquery>
			
				<cfquery name="GET_SUBS_LAYER" dbtype="query">
					SELECT * FROM GET_SUBS WHERE LAYER_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_layers.layer_row_id#"> 
				</cfquery>
				<cfloop query="get_subs_layer">
					<cfquery name="ADD_NEW_LAYER_MENU" datasource="#DSN#">
						INSERT INTO
							MAIN_MENU_SUB_SELECTS
							(
								ORDER_NO,
								LAYER_ROW_ID,
								SELECTED_ID,
								SELECTED_LINK,
								LINK_TYPE,
								LINK_NAME,
								LINK_NAME_TYPE,
								MENU_ID,
								IS_VIEW,
								IS_SESSION,
							)
						VALUES
							(
								<cfif len(get_subs_layer.order_no)>#get_subs_layer.order_no#,<cfelse>NULL,</cfif>
								<cfif len(get_2.layer_row_id)>#get_2.layer_row_id#,<cfelse>NULL,</cfif>
								<cfif len(get_subs_layer.selected_id)>#get_subs_layer.selected_id#,<cfelse>NULL,</cfif>
								'#get_subs_layer.selected_link#',
								#get_subs_layer.link_type#,
								#sql_unicode()#'#get_subs_layer.link_name#',
								<cfif len(get_subs_layer.link_name_type)>#get_subs_layer.link_name_type#,<cfelse>NULL,</cfif>
								#get_.menu_id#,
								#get_subs_layer.is_view#,
								<cfif len(get_subs_layer.is_session)>#get_subs_layer.is_session#<cfelse>0</cfif>
							)
					</cfquery>	
				</cfloop>	
			</cfloop>
		</cfloop>
		
		<cfloop query="get_layouts">
			<cfquery name="ADD_NEW_LAYOUTS" datasource="#DSN#">
				INSERT INTO
					MAIN_SITE_LAYOUTS
					(
						FACTION,
						LEFT_WIDTH,
						RIGHT_WIDTH,
						CENTER_WIDTH,
						MARGIN,
						LEFT_DESIGN_ID,
						RIGHT_DESIGN_ID,
						CENTER_DESIGN_ID,
						LEFT_OBJECT_NAME,
						RIGHT_OBJECT_NAME,
						CENTER_OBJECT_NAME,
						RECORD_DATE,
						RECORD_EMP,
						RECORD_IP,
						MENU_ID
					)
					VALUES
					(
						'#get_layouts.faction#',
						<cfif len(get_layouts.left_width)>#get_layouts.left_width#,<cfelse>0,</cfif>
						<cfif len(get_layouts.right_width)>#get_layouts.right_width#,<cfelse>0,</cfif>
						<cfif len(get_layouts.center_width)>#get_layouts.center_width#,<cfelse>0,</cfif>
						<cfif len(get_layouts.margin)>#get_layouts.margin#,<cfelse>0,</cfif>
						<cfif len(get_layouts.left_design_id)>#get_layouts.left_design_id#,<cfelse>NULL,</cfif>
						<cfif len(get_layouts.right_design_id)>#get_layouts.right_design_id#,<cfelse>NULL,</cfif>
						<cfif len(get_layouts.center_design_id)>#get_layouts.center_design_id#,<cfelse>NULL,</cfif>
						<cfif len(get_layouts.left_object_name)>'#get_layouts.left_object_name#',<cfelse>NULL,</cfif>
						<cfif len(get_layouts.right_object_name)>'#get_layouts.right_object_name#',<cfelse>NULL,</cfif>
						<cfif len(get_layouts.center_object_name)>'#get_layouts.center_object_name#',<cfelse>NULL,</cfif>
						#now()#,
						#session.ep.userid#,
						'#CGI.REMOTE_ADDR#',
						#get_.menu_id#
					)
			</cfquery>
		</cfloop>
		
		<cfloop query="get_layouts_select">
			<cfquery name="ADD_NEW_LAYOUTS_SELECTS" datasource="#DSN#">
				INSERT INTO
					MAIN_SITE_LAYOUTS_SELECTS
					(
						OBJECT_POSITION,
						OBJECT_NAME,
						FACTION,
						ORDER_NUMBER,
						OBJECT_FOLDER,
						OBJECT_FILE_NAME,
						MENU_ID,
						DESIGN_ID,
						CLASS_CSS_NAME
					)
					VALUES
					(
						#get_layouts_select.object_position#,
						<cfif len(get_layouts_select.object_name)>#sql_unicode()#'#get_layouts_select.object_name#',<cfelse>NULL,</cfif>
						'#get_layouts_select.faction#',
						<cfif len(get_layouts_select.order_number)>#get_layouts_select.order_number#,<cfelse>NULL,</cfif>
						'#get_layouts_select.object_folder#',
						'#get_layouts_select.object_file_name#',
						#get_.menu_id#,
						#get_layouts_select.design_id#,
						<cfif len(get_layouts_select.class_css_name)>'#get_layouts_select.class_css_name#'<cfelse>NULL</cfif>
					)
			</cfquery>
			<cfquery name="GET_3" datasource="#DSN#">
				SELECT MAX(ROW_ID) AS MAX_ROW_ID FROM MAIN_SITE_LAYOUTS_SELECTS
			</cfquery>
			
			<cfquery name="GET_LAYOUTS_PROPERTIES" datasource="#DSN#">
				SELECT 
                    ROW_ID, 
                    PROPERTY_NAME,
                    PROPERTY_VALUE 
                FROM 
	                MAIN_SITE_LAYOUTS_SELECTS_PROPERTIES 
                WHERE 
                	ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_layouts_select.row_id#">
			</cfquery>
			
			<cfloop query="get_layouts_properties">
				<cfquery name="ADD_LAYOUT_" datasource="#DSN#">
					INSERT INTO
						MAIN_SITE_LAYOUTS_SELECTS_PROPERTIES
							(
								ROW_ID,
								PROPERTY_NAME,
								PROPERTY_VALUE			
							)
						VALUES
							(
								#get_3.max_row_id#,
								'#get_layouts_properties.property_name#',
								<cfif len(get_layouts_properties.property_value)>'#get_layouts_properties.property_value#'<cfelse>NULL</cfif>
							)
				</cfquery>
			</cfloop>
		</cfloop>
	</cftransaction>
</cflock>
<!--- menu genel bilgiler kopyalama bitti --->
<cflocation url="#request.self#?fuseaction=settings.list_main_menu&event=upd&menu_id=#get_.menu_id#" addtoken="no">
		
