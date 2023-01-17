<cflock name="#createUUID()#"  timeout="500" >
	<cftransaction>
		<cfquery name="get_item" datasource="#DSN#">
			SELECT
				MAX(ITEM_ID) AS MAX_ITEM_ID
			FROM
				SETUP_LANGUAGE_TR
			WHERE
				MODULE_ID ='#attributes.module_name#'
		</cfquery>
	
		<cfif LEN(get_item.MAX_ITEM_ID)>
			<cfset item_max_no=get_item.MAX_ITEM_ID+1>
		<cfelse>
			<cfset item_max_no=1>
		</cfif>
	
		<cfquery name="add_new_item" datasource="#DSN#">
			INSERT INTO 
				SETUP_LANGUAGE_TR
				(
					MODULE_ID,
					ITEM_ID,
					ITEM
				)
				values
				(
					'#attributes.module_name#',
					#item_max_no#,
					'#attributes.sub_modulename_1#'
				)
		
		</cfquery>
	</cftransaction>
</cflock>	

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
