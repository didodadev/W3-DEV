<cfset LANG_1="TR">
<cfset LANG_2="ENG">
<cfset LANG_3="ARB">
<cfset LANG_4="DE">
<cflock name="#createUUID()#" timeout="500">
  <cftransaction>
	 <cfloop from="1" to="4" index="i">
		<cfset my_lang=evaluate("LANG_#i#")>
		<cfset our_Table_name="SETUP_LANGUAGE_#my_lang#">		 
		<cfloop from="1" to="#attributes.max_item#" index="no">
			<cfif Evaluate("is_change#no#") eq 1><!--- Eğer kelime değişti ise --->
				<cfquery name="GET_LANG" datasource="#DSN#">
					SELECT
						MODULE_ID
					FROM
						#our_Table_name#
					WHERE
						MODULE_ID = '#attributes.module_name#' AND 
						ITEM_ID = #no#				
				</cfquery>
				<cfif get_lang.recordcount>
				<cfset yeni_deger=evaluate("ITEM_#my_lang#_#no#")>		
				<cfquery name="UPD_LANG" datasource="#DSN#">
					UPDATE
						#our_Table_name#
					SET
						ITEM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#yeni_deger#">
					WHERE
						MODULE_ID='#attributes.module_name#' AND 
						ITEM_ID=#no#				
				</cfquery>
				<cfelse>
					<cfset yeni_deger=evaluate("ITEM_#my_lang#_#no#")>			
				<cfquery name="ADD_LANG" datasource="#DSN#">
					INSERT INTO
						#our_Table_name#
						(
							ITEM,
							ITEM_ID,
							MODULE_ID
						)
					VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#yeni_deger#">
							,#no#
							,<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.module_name#">
						)
				</cfquery>
			</cfif>
			</cfif>
		 </cfloop>
	 </cfloop>			 
  </cftransaction>
</cflock>
<cflocation addtoken="no" url="#request.self#?fuseaction=settings.new_lang_settings&module_name=#attributes.module_name#"> 
