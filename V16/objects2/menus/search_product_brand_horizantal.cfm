<cfparam name="attributes.keyword" default="">
<cfquery name="get_product_cat" datasource="#dsn1#">
	SELECT 
		PC.PRODUCT_CAT,
		PC.PRODUCT_CATID,
		PC.HIERARCHY
	FROM 
		PRODUCT_CAT PC,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
		<cfif isdefined("session.ep")>
			PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		<cfelse>
			PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
		</cfif>
		PC.IS_PUBLIC = 1	
	ORDER BY
		PC.HIERARCHY,
		PC.PRODUCT_CAT
</cfquery>

<cfquery name="get_brands" datasource="#dsn1#">
	SELECT 
		PB.BRAND_NAME,
		PB.BRAND_ID
	FROM 
		PRODUCT_BRANDS PB,
		PRODUCT_BRANDS_OUR_COMPANY PBO
	WHERE
		PB.BRAND_ID = PBO.BRAND_ID AND
		<cfif isdefined("session.ep")>
			PBO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		<cfelse>
			PBO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
		</cfif>
		PB.IS_ACTIVE = 1 AND
		PB.IS_INTERNET = 1
	ORDER BY 
		PB.BRAND_NAME
</cfquery>
<cfif listlast(attributes.fuseaction,'.') is 'popup_view_product_list'>
	<cfset fuseact = 'popup_view_product_list'>
<cfelse>
	<cfset fuseact = 'view_product_list'>
</cfif>
<table cellpadding="0" cellspacing="0" width="98%" border="0">
	<tr>
		<td style="text-align:right">
			<table>
			<cfform name="search" action="#request.self#?fuseaction=objects2.#fuseact#" method="post">
				<tr> 
					<td>
						<select name="hierarchy" id="hierarchy">
							<option value=""><cf_get_lang_main no='74.Kategori'></option>
							<cfoutput query="get_product_cat">
								<option value="#hierarchy#" <cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy) and (attributes.hierarchy eq hierarchy)>selected</cfif>><cfloop from="2" to="#listlen(hierarchy,'.')#" index="pc">&nbsp;&nbsp;</cfloop>#product_cat#</option>
							</cfoutput>
						</select>
					</td>	
					<td>
						<select name="brand_id" id="brand_id">
							<option value=""><cf_get_lang_main no='1435.Marka'></option>
							<cfoutput query="get_brands">
								<option value="#brand_id#" <cfif isdefined("attributes.brand_id") and len(attributes.brand_id) and  (attributes.brand_id eq brand_id)>selected</cfif>>#brand_name#</option>
							</cfoutput>
						</select>
					</td>
					<td><cfinput type="text" name="keyword" value="#attributes.keyword#" class="keyword" onFocus="this.value='';"></td>
					<td><input type="submit" value="<cf_get_lang_main no='153.Ara'>"></td>
			  	</tr>
			</cfform>
			</table>
		</td>
	</tr>
</table>
