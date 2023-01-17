<cfset STR_VALUE="">

<cfloop from="1" to="15" index="i">
	<cfif isdefined("attributes.PROPERTY#i#") and LEN(evaluate("attributes.PROPERTY#i#")) >
		<cfset STR_VALUE=STR_VALUE & "PROPERTY#i#='"&   evaluate("attributes.PROPERTY#i#")& "', ">
	</cfif>
</cfloop> 

<cfif LEN(STR_VALUE)>
	<cfquery name="UPD_INFO" datasource="#DSN3#">
		UPDATE
			PRODUCT_TREE_INFO_PLUS
		SET	
			#PreserveSingleQuotes(STR_VALUE)#	
			STOCK_ID=#attributes.STOCK_ID#
		WHERE
				STOCK_ID=#attributes.STOCK_ID#
	</cfquery>
</cfif>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
