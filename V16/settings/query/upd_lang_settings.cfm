<cflock name="#createUUID()#"  timeout="500" >
	<cftransaction>
		 <cfloop from="1" to="#attributes.max_item#" index="no">
				<cfset my_variable=evaluate("ITEM_#no#")>
				<cfquery name="add_lang" datasource="#DSN#">
					UPDATE
						SETUP_LANGUAGE_TR
					SET
						ITEM='#my_variable#'
					WHERE
						MODULE_ID='#attributes.module_name#'			 
					AND 
						ITEM_ID=#no#				
				
				</cfquery>
		 </cfloop>
	</cftransaction>
</cflock>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.lang_settings&module_name=#attributes.module_name#">
