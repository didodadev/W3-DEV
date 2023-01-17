<!--- Site Objeleri Kopyalama Query --->
<cfquery name="GET_LAYOUTS" datasource="#DSN#">
	SELECT FACTION FROM MAIN_SITE_LAYOUTS WHERE FACTION = '#attributes.faction#' AND MENU_ID = #attributes.menu_id#
</cfquery>
<cfif get_layouts.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='2519.Bu sayfa için tasarım ayarları tanımlanmış! Tekrar Tanımlama Yapamazsınız'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>	 
		<cfquery name="ADD_SITE_OBJECTS" datasource="#DSN#">
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
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP,
				MENU_ID
			) 
			SELECT
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
				#session.ep.userid#,
				#now()#,
				'#cgi.remote_addr#',
				<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">
			FROM
				MAIN_SITE_LAYOUTS
			WHERE
				FACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.faction#"> AND 
				MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_menu_id#">
		</cfquery>
		
		<cfquery name="LIST_LAYOUT_SELECTS" datasource="#DSN#">
			SELECT 
				ROW_ID
			FROM
				MAIN_SITE_LAYOUTS_SELECTS
			WHERE
				FACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.faction#"> AND 
				MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_menu_id#">
		</cfquery>
		
		<cfloop query="list_layout_selects">
			<cfquery name="ADD_LAYOUT_SELECTS" datasource="#DSN#">
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
				SELECT 
					OBJECT_POSITION,
					OBJECT_NAME,
					FACTION,
					ORDER_NUMBER,
					OBJECT_FOLDER,
					OBJECT_FILE_NAME,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.menu_id#">,
					DESIGN_ID,
					CLASS_CSS_NAME
				FROM 
					MAIN_SITE_LAYOUTS_SELECTS
				WHERE
					FACTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.faction#"> AND 
					MENU_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.old_menu_id#"> AND
					ROW_ID = #row_id#	
				SELECT @@IDENTITY AS MAX_ROW_ID
			</cfquery>

			<cfquery name="LIST_LAYOUT_SELECTS_PROPERTIES" datasource="#DSN#">		
				SELECT ROW_ID FROM MAIN_SITE_LAYOUTS_SELECTS_PROPERTIES WHERE ROW_ID = #row_id#
			</cfquery>
			
			<cfquery name="ADD_LAYOUT_SELECTS_PROPERTIES" datasource="#DSN#">
				INSERT INTO 
					MAIN_SITE_LAYOUTS_SELECTS_PROPERTIES
				( 
					ROW_ID,
					PROPERTY_NAME,
					PROPERTY_VALUE
				)
				SELECT 
					#add_layout_selects.MAX_ROW_ID#,
					PROPERTY_NAME,
					PROPERTY_VALUE
				FROM 
					MAIN_SITE_LAYOUTS_SELECTS_PROPERTIES
				WHERE 
					ROW_ID = #row_id#
			</cfquery>
		</cfloop>
 	</cftransaction>
</cflock> 

<script>
	window.close();
</script>



		
