<cfif isdefined("attributes.brand_id") and len(attributes.brand_id)>
	<cfquery name="GET_BRAND_PRODUCT" datasource="#DSN3#">
		SELECT
			P.PRODUCT_NAME,
			P.PRODUCT_ID,
			P.PRODUCT_DETAIL,
			P.PRODUCT_DETAIL2, 
			P.PRODUCT_ID,
			S.STOCK_ID,
			S.PROPERTY ,
			PS.PRICE,
			PS.MONEY,
			'' AS SORTER
		FROM
			PRODUCT P,
			PRICE_STANDART PS,
			STOCKS S,
			PRODUCT_CAT PC,
			#dsn1_alias#.PRODUCT_CAT_OUR_COMPANY PCO
		WHERE
			P.PRODUCT_ID IN (SELECT PRODUCT_ID FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0) AND
			<cfif isdefined("attributes.product_brand_id") and len(attributes.product_brand_id)>
				P.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_brand_id#"> AND
			<cfelse>
				P.BRAND_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.brand_id#"> AND
			</cfif>
			PS.PRODUCT_ID = P.PRODUCT_ID AND
			PS.PRICESTANDART_STATUS = 1 AND
			PS.PURCHASESALES = 1 AND
			PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
			PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
			S.PRODUCT_ID = P.PRODUCT_ID AND
			P.PRODUCT_CATID = PC.PRODUCT_CATID AND
			PC.IS_PUBLIC = 1 AND
			<cfif isdefined("session.pp")>P.IS_EXTRANET = 1 AND<cfelse>P.IS_INTERNET = 1 AND</cfif>
			P.PRODUCT_STATUS = 1
			<cfif isdefined("attributes.pid") and len(attributes.pid)>
				AND P.PRODUCT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">
			</cfif>
	</cfquery>
	<cfif get_brand_product.recordcount>
		<cfset brand_product_id_list = ''>
		<cfset all_brand_product = ''>
		<cfoutput query="get_brand_product">
			<cfif not listfindnocase(brand_product_id_list,get_brand_product.product_id)>
				<cfset brand_product_id_list = listappend(brand_product_id_list,get_brand_product.product_id,',')>
			</cfif>
			<cfif not listfindnocase(all_brand_product,get_brand_product.product_id)>
				<cfset all_brand_product = listappend(all_brand_product,get_brand_product.product_id,',')>
			</cfif>
		</cfoutput>
		<cfif listlen(brand_product_id_list)>
			<cfquery name="GET_PRODUCT_IMAGES_BRAND" datasource="#DSN3#">
				SELECT PATH,PRODUCT_ID,PATH_SERVER_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID IN (#brand_product_id_list#) ORDER BY PRODUCT_ID
			</cfquery>
			<cfset brand_product_id_list = listdeleteduplicates(valuelist(get_product_images_brand.product_id,','),'numeric','ASC',',')>
			<cfset brand_product_id_list=listsort(brand_product_id_list,"numeric","ASC",",")>
		</cfif>
		
		<cfif len(attributes.brand_product_maxrows)>
			<cfset brand_maxrows = #attributes.brand_product_maxrows#>
		<cfelse>
			<cfset brand_maxrows = ''>
		</cfif>
		<cfif attributes.brand_product_image eq 1>
			<cfif isdefined("attributes.brand_product_width") and len(attributes.brand_product_width)>
				<cfset brand_prod_width = #attributes.brand_product_width#>
			<cfelse>
				<cfset brand_prod_width = ''>
			</cfif>
			<cfif isdefined("attributes.brand_product_height") and len(attributes.brand_product_height)>
				<cfset brand_prod_height = #attributes.brand_product_height#>
			<cfelse>
				<cfset brand_prod_height = ''>
			</cfif>
		</cfif>
		<cfif isdefined("attributes.is_random_sorting") and attributes.is_random_sorting eq 1>
			<cfloop query="get_brand_product">
			   <cfset querySetCell(get_brand_product,"sorter",rand(),currentRow)>
			</cfloop>
			<cfquery name="GET_BRAND_PRODUCT" dbtype="query">
				SELECT * FROM GET_BRAND_PRODUCT ORDER BY SORTER
			</cfquery>
		</cfif>
		<cfif attributes.brand_product_position eq 1>
			<table cellspacing="1" cellpadding="2" border="0" align="center" style="width:100%;">
				<cfoutput query="get_brand_product" maxrows="#brand_maxrows#">  
				<cfif attributes.brand_product_image eq 1>
					<tr style="background-color:##FFFFFF;"> 
						<td rowspan="3" style="vertical-align:top;">
						<cfif listfindnocase(brand_product_id_list,product_id)>
							<a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">
								<cf_get_server_file output_file="product/#get_product_images_brand.path[listfind(brand_product_id_list,product_id,',')]#" title="#get_product_images_brand.detail[listfind(brand_product_id_list,product_id,',')]#" alt="#get_product_images_brand.detail[listfind(brand_product_id_list,product_id,',')]#" output_server="#get_product_images_brand.path_server_id[listfind(brand_product_id_list,product_id,',')]#"  output_type="0" image_width="#brand_prod_width#" image_height="#brand_prod_height#">
							</a>
						</cfif>
						</td>
					</tr>
				</cfif>
				<cfif attributes.brand_product_name eq 1>
					<tr>
						<td style="vertical-align:top;">
						<cfif isdefined("attributes.brand_product_detail2") and attributes.brand_product_detail2 eq 1>
							<cfif attributes.fuseaction eq 'objects2.detail_product'>
								<a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">#product_detail2#</a>
							<cfelse>
								<a href="#request.self#?fuseaction=objects2.detail_product_simple&product_id=#product_id#" class="tableyazi">#product_detail2#</a>
							</cfif>
						<cfelse>
							<cfif attributes.fuseaction eq 'objects2.detail_product'>
								<a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">#product_name# #property#</a>
							<cfelse>
								<a href="#request.self#?fuseaction=objects2.detail_product_simple&product_id=#product_id#" class="tableyazi">#product_name# #property#</a>
							</cfif>
						</cfif>
						</td>
					</tr>
				</cfif>
				<cfif attributes.brand_product_price eq 1>
					<tr>
						<td style="vertical-align:top;"><cf_get_lang_main no='672.Fiyat'> : #price# #money# +KDV</td>
					</tr>
				</cfif>
				<cfif attributes.brand_product_detail eq 1>
					<tr>
						<td colspan="2"><cf_get_lang_main no='217.Açıklama'> : #product_detail#</td>
					</tr>
				</cfif>
				<cfif get_brand_product.recordcount neq currentrow>
					<tr style="background-color:##FFFFFF;">
						<td colspan="2"><hr style="height:1px;" color="CCCCCC"></td>
					</tr>
				</cfif>			 
				</cfoutput>	
				<tr>
					<td colspan="2"  style="text-align:right;"><a href="<cfoutput>#request.self#?fuseaction=objects2.view_product_list&all_product_id=#all_brand_product#</cfoutput>" class="object_all"></a></td>
				</tr>
			</table>
		<cfelse>
			<table border="0" align="center" style="width:100%;">
				<tr>
					<cfoutput query="get_brand_product" maxrows="#brand_maxrows#">
					<td>
						<table style="width:100%;">  
							<cfif attributes.brand_product_image eq 1>
                                <tr style="background-color:##FFFFFF;"> 
                                    <td align="center" style="vertical-align:top;">
                                    <cfif listfindnocase(brand_product_id_list,product_id)>
                                        <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">
                                            <cf_get_server_file output_file="product/#get_product_images_brand.path[listfind(brand_product_id_list,product_id,',')]#" title="#get_product_images_brand.detail[listfind(brand_product_id_list,product_id,',')]#" alt="#get_product_images_brand.detail[listfind(brand_product_id_list,product_id,',')]#" output_server="#get_product_images_brand.path_server_id[listfind(brand_product_id_list,product_id,',')]#"  output_type="0" image_width="#brand_prod_width#" image_height="#brand_prod_height#">
                                        </a>
                                    </cfif>
                                    </td>
                                </tr>
                            </cfif>
                            <cfif attributes.brand_product_name eq 1>
                                <tr>
                                    <td align="center" style="vertical-align:top;">
                                    <cfif isdefined("attributes.brand_product_detail2") and attributes.brand_product_detail2 eq 1>
                                        <cfif attributes.fuseaction eq 'objects2.detail_product'>
                                            <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">#product_detail2#</a>
                                        <cfelse>
                                            <a href="#request.self#?fuseaction=objects2.detail_product_simple&product_id=#product_id#" class="tableyazi">#product_detail2#</a>
                                        </cfif>
                                    <cfelse>
                                        <cfif attributes.fuseaction eq 'objects2.detail_product'>
                                            <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">#product_name# #property#</a>
                                        <cfelse>
                                            <a href="#request.self#?fuseaction=objects2.detail_product_simple&product_id=#product_id#" class="tableyazi">#product_name# #property#</a>
                                        </cfif>
                                    </cfif>
                                    </td>
                                </tr>
                            </cfif>
                            <cfif attributes.brand_product_price eq 1>
                                <tr>
                                    <td class="prodFiyat" align="center" style="vertical-align:top;">#price# #money# +KDV</td>
                                </tr>
                            </cfif>
                            <cfif attributes.brand_product_detail eq 1>
                                <tr>
                                    <td align="center" style="vertical-align:top;">#product_detail#</td>
                                </tr>
                            </cfif>
                        </table>	
					</td>
					</cfoutput>	
				</tr>
				<tr><cfoutput>
						<td colspan="#brand_maxrows#" style="text-align:right;"><a href="#request.self#?fuseaction=objects2.view_product_list&all_product_id=#all_brand_product#" class="object_all"></a></td>
					</cfoutput>
				</tr>
			</table>
		</cfif>
	</cfif>
</cfif>
