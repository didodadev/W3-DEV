<!--- Alttaki fonskisyonun bir benzeri metal sektorunde kullanilmaktadir. Degisiklik icin bilgi veriniz BK. 20070509 --->
<cfsetting enablecfoutputonly="yes"><cfprocessingdirective suppresswhitespace="yes">
<cffunction name="get_product_no" returntype="any" output="false">
	<!---
	by :  20040110
	notes : 

	usage :
	get_product_no
		(
		action_type : product_no,stock_no
		);
	<cfset product_no = get_product_no(action_type:'product_no')>
	revisions : 
	--->
	<cfargument name="action_type" required="true" type="any">
	<cftransaction>
		<cfquery name="GET_PRODUCT_NO_" datasource="#dsn1#">
			SELECT 
				<cfif arguments.action_type is 'product_no'>PRODUCT_NO</cfif>
				<cfif arguments.action_type is 'stock_no'>STOCK_NO</cfif>
				AS URUN_NUMBER
			FROM
				PRODUCT_NO
		</cfquery>
		<cfif GET_PRODUCT_NO_.recordcount>
			<cfset urun_no_=GET_PRODUCT_NO_.URUN_NUMBER>
			<cfquery name="UPDATE_PRODUCT_NO_" datasource="#dsn1#">
				UPDATE PRODUCT_NO
					SET <cfif arguments.action_type is 'product_no'>PRODUCT_NO</cfif><cfif arguments.action_type is 'stock_no'>STOCK_NO</cfif>=#urun_no_+1#
			</cfquery>
			<cfreturn urun_no_>
		<cfelse>
			<cfreturn ''>
		</cfif>
	</cftransaction>
</cffunction>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
