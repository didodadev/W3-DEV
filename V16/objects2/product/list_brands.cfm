<cfif isdefined("attributes.is_brand_maxrow") and len(attributes.is_brand_maxrow)>
	<cfset is_maxrows = #attributes.is_brand_maxrow#>
<cfelse>
	<cfset is_maxrows = 5>
</cfif>
<cfquery name="GET_PRODUCERS" datasource="#DSN3#" maxrows="#is_maxrows#">
	SELECT 
		PBI.PATH,
        PBI.PATH_SERVER_ID,
        PB.BRAND_NAME,
        PB.DETAIL,
        PB.BRAND_ID
	FROM 
		PRODUCT_BRANDS PB,
        #dsn1_alias#.PRODUCT_BRANDS_IMAGES PBI 
	WHERE 
		PBI.BRAND_ID = PB.BRAND_ID AND
		PB.IS_ACTIVE = 1 AND 
		PB.IS_INTERNET = 1 AND 
		PBI.PATH IS NOT NULL 
	ORDER BY 
		PB.BRAND_NAME
</cfquery>
<table align="center" style="width:100%">
	<cfoutput query="get_producers">
		<cfif attributes.is_brand_image eq 1>
			<cfif len(attributes.is_image_width)>
				<cfset is_width = (#attributes.is_image_width# + 20)>
			<cfelse>
				<cfset is_width = ''>
			</cfif>
			<tr>
				<td rowspan="3" style="width:#is_width#px;">
					<a href="#request.self#?fuseaction=objects2.view_brand_page&brand_id=#brand_id#">
						<cf_get_server_file output_file="product/#get_producers.path#" output_server="#get_producers.path_server_id#" output_type="0" image_width="#attributes.is_image_width#" image_height="#attributes.is_image_height#" image_link="5" alt="#getLang('main',668)#" title="#getLang('main',668)#">
					</a>
				</td>
			</tr>
		</cfif>
		<tr>
			<cfif attributes.is_brand_name eq 1>
				<td class="formbold" style="vertical-align:top;">
					<a href="#request.self#?fuseaction=objects2.view_brand_page&brand_id=#brand_id#">#get_producers.brand_name#</a>
				</td>
			</cfif>
		</tr>
		<tr>
			<cfif attributes.is_brand_detail eq 1>
				<td style="vertical-align:top;">
					#get_producers.detail#
				</td>
			</cfif>
		</tr>
		<cfif recordcount neq currentrow>
			<tr>
				<td colspan="2"><hr style="height:0.2px; color:CCCCCC"></td>
			</tr>
		</cfif>
	</cfoutput>
</table>

