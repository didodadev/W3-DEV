<cfif not isdefined("attributes.row_id")> <!--- ekleme --->
	<cflock name="CreateUUID()" timeout="20">
		<cftransaction>
			<cfquery name="add_layout_" datasource="#dsn#">
				INSERT INTO
					MAIN_SITE_LAYOUTS_SELECTS
						(
						MENU_ID,
						FACTION,
						COL_ID,
						ORDER_NUMBER,
						OBJECT_POSITION,
						DESIGN_ID,
						OBJECT_NAME,
						OBJECT_FOLDER,
						OBJECT_FILE_NAME,
						CLASS_CSS_NAME,
						VIEW_TITLE
						)
					VALUES
						(
						#attributes.menu_id#,
						'#attributes.faction#',
						#attributes.COL_ID#,
						<cfif len(attributes.order_number)>#attributes.order_number#<cfelse>NULL</cfif>,
						#attributes.object_position#,
						<cfif isdefined("attributes.design_id") and len(attributes.design_id)>#attributes.design_id#<cfelse>NULL</cfif>,
						'#attributes.object_name#',
						'#attributes.object_folder#',
						'#attributes.object_file_name#',
						<cfif isdefined("attributes.class_css_name") and len(attributes.class_css_name)>'#attributes.class_css_name#'<cfelse>NULL</cfif>,
						#attributes.object_title#
						)
			</cfquery>
			
			<cfquery name="GET_MAX" datasource="#DSN#">
				SELECT 
					MAX(ROW_ID) AS MAX_ROW_ID
				FROM
					MAIN_SITE_LAYOUTS_SELECTS
			</cfquery>
		</cftransaction>
	</cflock>
	
	<cfif attributes.property_count gt 0>
		<cfloop from="1" to="#attributes.property_count#" index="pro">
			<cfset this_ = evaluate("attributes.property_#pro#")>
			<cfif listlast(this_) is not 'EMPTY'>
				<cfquery name="add_layout_" datasource="#dsn#">
					INSERT INTO
						MAIN_SITE_LAYOUTS_SELECTS_PROPERTIES
							(
							ROW_ID,
							PROPERTY_NAME,
							PROPERTY_VALUE			
							)
						VALUES
							(
							#GET_MAX.MAX_ROW_ID#,
							'#listfirst(this_)#',
							<cfif listlast(this_) is not 'EMPTY'>'#mid(this_,len(listfirst(this_))+2,len(this_)-len(listfirst(this_))+1)#'<cfelse>NULL</cfif>
							)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
<cfelse> <!--- guncelleme --->
	<cfquery name="upd_layout_" datasource="#dsn#">
		UPDATE
			MAIN_SITE_LAYOUTS_SELECTS
		SET
			MENU_ID = #attributes.menu_id#,
			FACTION = '#attributes.faction#',
			ORDER_NUMBER = <cfif len(attributes.order_number)>#attributes.order_number#<cfelse>NULL</cfif>,
			OBJECT_POSITION = #attributes.object_position#,
			DESIGN_ID = #attributes.design_id#,
			OBJECT_NAME = '#attributes.object_name#',
			OBJECT_FOLDER = '#attributes.object_folder#',
			OBJECT_FILE_NAME = 	'#attributes.object_file_name#',
			CLASS_CSS_NAME = <cfif isdefined("attributes.class_css_name") and len(attributes.class_css_name)>'#attributes.class_css_name#'<cfelse>NULL</cfif>
		WHERE
			ROW_ID = #attributes.row_id#
	</cfquery>
	<cfquery name="del_" datasource="#dsn#">
		DELETE FROM MAIN_SITE_LAYOUTS_SELECTS_PROPERTIES WHERE ROW_ID = #attributes.row_id#
	</cfquery>
	<cfif attributes.property_count gt 0>
		<cfloop from="1" to="#attributes.property_count#" index="pro">
			<cfset this_ = evaluate("attributes.property_#pro#")>
			<cfif listlast(this_) is not 'EMPTY'>
				<cfquery name="add_layout_" datasource="#dsn#">
					INSERT INTO
						MAIN_SITE_LAYOUTS_SELECTS_PROPERTIES
							(
							ROW_ID,
							PROPERTY_NAME,
							PROPERTY_VALUE			
							)
						VALUES
							(
							#attributes.row_id#,
							'#listfirst(this_)#',
							<cfif listlast(this_) is not 'EMPTY'>'#mid(this_,len(listfirst(this_))+2,len(this_)-len(listfirst(this_))+1)#'<cfelse>NULL</cfif>
							)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
</cfif>
<script type="text/javascript">
	window.top.wrk_opener_reload();
	window.top.close();
</script>
