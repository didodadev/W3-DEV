<cfquery name="del_" datasource="#dsn#">
	DELETE FROM MAIN_SITE_LAYOUTS_SELECTS WHERE FACTION = '#attributes.faction#' AND MENU_ID = #attributes.menu_id#
</cfquery>

<cfloop from="1" to="#attributes.dongu_sayisi#" index="fl">
	<cfif isdefined("attributes.position_#fl#") and len(evaluate("attributes.position_#fl#"))>
		<cfquery name="add_" datasource="#dsn#">
			INSERT INTO 
			MAIN_SITE_LAYOUTS_SELECTS
				(
				OBJECT_POSITION,
				OBJECT_NAME,
				OBJECT_FOLDER,
				OBJECT_FILE_NAME,
				ORDER_NUMBER,
				FACTION,
				MENU_ID
				)
			VALUES
				(
				#evaluate("attributes.position_#fl#")#,
				#sql_unicode()#'#wrk_eval("attributes.name_#fl#")#',
				'#wrk_eval("attributes.folder_name_#fl#")#',
				'#wrk_eval("attributes.file_name_#fl#")#',
				<cfif len(evaluate("attributes.sira_#fl#"))>#evaluate("attributes.sira_#fl#")#,<cfelse>NULL,</cfif>
				'#attributes.faction#',
				#attributes.menu_id#
				)
		</cfquery>
	</cfif>
</cfloop>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>


