<!--- Giriş Sayfası ---->
<!--- <cfinclude template="../../objects2/query/get_brand.cfm"> --->
<cfquery name="GET_BRAND" datasource="#DSN3#">
	SELECT 
		PB.BRAND_NAME,
		PB.DETAIL
		<!---PBI.PATH,
		PBI.PATH_SERVER_ID--->
   	FROM
		PRODUCT_BRANDS PB
        <!---#dsn1_alias#.PRODUCT_BRANDS_IMAGES PBI--->
	WHERE
    	<!---PBI.BRAND_ID = PB.BRAND_ID AND--->
		PB.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#">
</cfquery>
<table style="width:100%">
	<cfoutput>
		<tr>
			<!--- <td rowspan="2"><cf_get_server_file output_file="product/#get_brand.brand_logo#" output_server="#get_brand.brand_logo_server_id#" output_type="0"  image_link="0"  alt="#getLang('main',668)#" title="#getLang('main',668)#"></td> --->
			<!--- <td><img src="documents/product/#get_brand.brand_logo#"></td> --->
			<td class="formbold">#get_brand.brand_name#</td>
		</tr>
		<tr>
			<td>#get_brand.detail#</td>
		</tr>
	</cfoutput>
</table>
