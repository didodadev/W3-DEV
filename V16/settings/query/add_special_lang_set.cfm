<cfquery name="get_new_item" datasource="#DSN#">
	SELECT 
        LANGUAGE_SHORT 
    FROM 
    	SETUP_LANGUAGE
</cfquery>
<cflock name="#createUUID()#"  timeout="500">
	<cftransaction>
		<cfloop from="1" to="#get_new_item.recordcount#" index="i">
			<cfif IsDefined("SETUP_LANGUAGE_#UCASE(get_new_item.LANGUAGE_SHORT[i])#")>
				<cfset NEW_DB_NAME="SETUP_LANGUAGE_#UCASE(get_new_item.LANGUAGE_SHORT[i])#">
				<cfif DATABASE_TYPE IS "MSSQL">
					<cfquery name="GET_LANGUAGE_DB" datasource="#DSN#">
						SELECT 
							* 
						FROM 
							sysobjects 
						WHERE id = object_id(N'[#NEW_DB_NAME#]') and OBJECTPROPERTY(id, N'IsUserTable') = 1
					</cfquery>
				<cfelseif DATABASE_TYPE IS "DB2">
					<cfquery name="GET_LANGUAGE_DB" datasource="#DSN#">
						SELECT TBNAME FROM SYSIBM.SYSCOLUMNS WHERE TBNAME='#NEW_DB_NAME#'
					</cfquery>
				</cfif>
				<cfquery name="check" datasource="#dsn#">
					SELECT 
						ITEM_ID, 
						MODULE_ID, 
						ITEM, 
						LANG_NAME 
					FROM 
						SETUP_LANG_SPECIAL 
					WHERE 
						LANG_NAME = '#UCASE(get_new_item.LANGUAGE_SHORT[i])#'
				</cfquery>
				<cfif check.recordcount>
					<cfoutput query="check">
						<cfquery name="upd_lang" datasource="#dsn#">
							UPDATE #NEW_DB_NAME# SET ITEM = '#ITEM#' WHERE ITEM_ID = #ITEM_ID# AND MODULE_ID = '#MODULE_ID#'
						</cfquery>
					</cfoutput>
				</cfif>
			</cfif>
		</cfloop>
	</cftransaction>
</cflock>		
<script type="text/javascript">
	alert("<cf_get_lang dictionary_id ='44493.Aktarım Tamamlandı'>!");
	window.location.href='<cfoutput>#request.self#?fuseaction=settings.special_langs</cfoutput>';
</script>
<cfabort>
