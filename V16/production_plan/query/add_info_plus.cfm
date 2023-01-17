
<cfset STR_COLUMN="">
<cfset STR_VALUE="">

<cfloop from="1" to="15" index="i">
	<cfif isdefined("attributes.PROPERTY#i#") and LEN(evaluate("attributes.PROPERTY#i#")) >
		<cfset STR_COLUMN=STR_COLUMN & " PROPERTY#i#,">
		<cfset STR_VALUE=STR_VALUE & "'"&   evaluate("attributes.PROPERTY#i#")& "',">
	</cfif>
</cfloop> 

<cfif LEN(STR_VALUE)>
	<cfquery name="ADD_INFO" datasource="#DSN3#">
		INSERT INTO 
			PRODUCT_TREE_INFO_PLUS
			(
				#PreserveSingleQuotes(STR_COLUMN)#
				STOCK_ID
			)
				VALUES
			(
				#PreserveSingleQuotes(STR_VALUE)#	
				#attributes.STOCK_ID#
			)
	</cfquery>
</cfif>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

