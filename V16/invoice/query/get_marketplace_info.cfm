<cfif isdefined("list_of_ship")>
	<cfquery name="GET_SHIP_DETAIL" datasource="#DSN2#">
		SELECT * FROM SHIP WHERE SHIP_ID IN (#LIST_OF_SHIP#)
	</cfquery>
	<cfif listlen(list_of_ship)>
		<cfloop list="#list_of_ship#" index="k">
			<cfset comp_1 = evaluate("company_id_#k#")>
			<cfset con_1 = evaluate("consumer_id_#k#")>	
			<cfloop list="#list_of_ship#" index="j">
				<cfset comp_2 = evaluate("company_id_#j#")>
				<cfset con_2 = evaluate("consumer_id_#j#")>	
				<cfif ((comp_2 neq comp_1) and comp_2 neq 0 and len(comp_2))>
					<script type="text/javascript">
						alert("<cf_get_lang no='25.Aynı Cariye Ait Seçim Yapınız'>!");
						history.back();
					</script>
					<cfabort>
				</cfif>
				<cfif ((con_2 neq con_1) and con_2 neq 0 and len(con_2))>
					<script type="text/javascript">
						alert("<cf_get_lang no='25.Aynı Cariye Ait Seçim Yapınız'>!");
						history.back();
					</script>
					<cfabort>			
				</cfif>
			</cfloop>
		</cfloop>
	</cfif>
<cfelse>
	<script type="text/javascript">
		alert("<cf_get_lang no='24.İrsaliye Seçimi Yapınız'>!");
		history.back();
	</script>
	<cfabort>			
</cfif>
