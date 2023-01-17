<!--- 
	gerekli olanlar:
		silinecek olan id
		module_id
 --->
<cfquery name="get_new_item" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_LANGUAGE
</cfquery>

<cflock name="#createUUID()#"  timeout="500" >
	<cftransaction>
			<cfloop query="get_new_item">
				<cfset my_lang = get_new_item.LANGUAGE_SHORT[currentrow]>
				<cfset NEW_DB_NAME = "SETUP_LANGUAGE_#UCase(my_lang)#">
				<cfquery name="add_ext_row" datasource="#DSN#">
					DELETE FROM #NEW_DB_NAME# WHERE ITEM_ID=#attributes.item_id# and MODULE_ID='#attributes.module_id#'
				</cfquery>
			</cfloop>
	</cftransaction>
</cflock>		
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>  
