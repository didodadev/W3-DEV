<cfif isdefined("attributes.product_catid") and len(attributes.product_catid)>
	<cfquery name="GET_CATEGORY_PRODUCT" datasource="#DSN3#">
		SELECT
			P.PRODUCT_NAME,
			P.PRODUCT_ID,
			P.PRODUCT_DETAIL,
			P.PRODUCT_DETAIL2, 
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
			<cfif isdefined("attributes.product_cat_id") and len(attributes.product_cat_id)>
				P.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_cat_id#"> AND
			<cfelse>
				P.PRODUCT_CATID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_catid#"> AND
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
			P.PRODUCT_STATUS = 1 AND
			S.STOCK_STATUS = 1 
			<!--- P.PRODUCT_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#">--->
	</cfquery>
	<cfif get_category_product.recordcount>
		<cfset cat_product_id_list = ''>
		<cfset all_cat_product_id_list = ''>
		<cfoutput query="get_category_product">
			<cfif not listfindnocase(cat_product_id_list,get_category_product.product_id)>
				<cfset cat_product_id_list = listappend(cat_product_id_list,get_category_product.product_id,',')>
			</cfif>
			<cfif not listfindnocase(all_cat_product_id_list,get_category_product.product_id)>
				<cfset all_cat_product_id_list = listappend(all_cat_product_id_list,get_category_product.product_id,',')>
			</cfif>
		</cfoutput>
		<cfif listlen(cat_product_id_list)>
			<cfquery name="GET_PRODUCT_IMAGES_CAT" datasource="#DSN3#">
				SELECT PATH,PRODUCT_ID,PATH_SERVER_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID IN (#cat_product_id_list#) ORDER BY PRODUCT_ID
			</cfquery>
			<cfset cat_product_id_list = listdeleteduplicates(valuelist(get_product_images_cat.product_id,','),'numeric','ASC',',')>
			<cfset cat_product_id_list=listsort(cat_product_id_list,"numeric","ASC",",")>
		</cfif>
		
		<cfif len(attributes.cat_product_maxrows)>
			<cfset cat_maxrows = #attributes.cat_product_maxrows#>
		<cfelse>
			<cfset cat_maxrows = ''>
		</cfif>
		<cfif attributes.cat_product_image eq 1>
			<cfif isdefined("attributes.cat_product_width") and len(attributes.cat_product_width)>
				<cfset cat_prod_width = #attributes.cat_product_width#>
			<cfelse>
				<cfset cat_prod_width = ''>
			</cfif>
			<cfif isdefined("attributes.cat_product_height") and len(attributes.cat_product_height)>
				<cfset cat_prod_height = #attributes.cat_product_height#>
			<cfelse>
				<cfset cat_prod_height = ''>
			</cfif>
		</cfif>
		<cfif isdefined("attributes.is_random_sorting") and attributes.is_random_sorting eq 1>
			<cfloop query="get_category_product">
			   <cfset querySetCell(get_category_product,"sorter",rand(),currentRow)>
			</cfloop>
			<cfquery name="GET_CATEGORY_PRODUCT" dbtype="query">
				SELECT * FROM GET_CATEGORY_PRODUCT ORDER BY SORTER
			</cfquery>
		</cfif>
		<cfif attributes.cat_product_position eq 1>
			<table cellspacing="1" cellpadding="2" border="0" align="center" style="width:100%;">
				<cfoutput query="get_category_product" maxrows="#cat_maxrows#">  
				<cfif attributes.cat_product_image eq 1>
					<tr style="background-color:##FFFFFF;"> 
						<td rowspan="3" style="vertical-align:top;">
							<cfif listfindnocase(cat_product_id_list,product_id)>
                                <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">
                                    <cf_get_server_file output_file="product/#get_product_images_cat.path[listfind(cat_product_id_list,product_id,',')]#" title="#get_product_images_cat.detail[listfind(cat_product_id_list,product_id,',')]#" alt="#get_product_images_cat.detail[listfind(cat_product_id_list,product_id,',')]#" output_server="#get_product_images_cat.path_server_id[listfind(cat_product_id_list,product_id,',')]#"  output_type="0" image_width="#cat_prod_width#" image_height="#cat_prod_height#">
                                </a>
                            </cfif>
						</td>
					</tr>
				</cfif>
				<cfif attributes.cat_product_name eq 1>
					<tr>
						<td style="vertical-align:top;">
							<cfif isdefined("attributes.cat_product_detail2") and attributes.cat_product_detail2 eq 1>
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
				<cfif attributes.cat_product_price eq 1>
					<tr>
						<td class="profiyat" style="vertical-align:top;">#price# #money# +KDV</td>
					</tr>
				</cfif>
				<cfif attributes.cat_product_detail eq 1>
					<tr>
						<td colspan="2">#product_detail#</td>
					</tr>
				</cfif>
				<cfif get_category_product.recordcount neq currentrow>
					<tr style="background-color:##FFFFFF;">
						<td colspan="2"><hr style="height:1px;" color="CCCCCC"></td>
					</tr>
				</cfif>		 
				</cfoutput>	
				<tr>
					<td colspan="2"  style="text-align:right;"><a href="<cfoutput>#request.self#?fuseaction=objects2.view_product_list&all_product_id=#all_cat_product_id_list#</cfoutput>" class="object_all"></a></td>
				</tr>			
			</table>
		<cfelse>
			<table border="0" align="center" style="width:100%;">
				<tr>
					<cfoutput query="get_category_product" maxrows="#cat_maxrows#">
					<td>
						<table style="width:100%;">  
						<cfif attributes.cat_product_image eq 1>
							<tr style="background-color:##FFFFFF;"> 
								<td align="center" style="vertical-align:top;">
								<cfif listfindnocase(cat_product_id_list,product_id)>
									<a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">
										<cf_get_server_file output_file="product/#get_product_images_cat.path[listfind(cat_product_id_list,product_id,',')]#" title="#get_product_images_cat.detail[listfind(cat_product_id_list,product_id,',')]#" alt="#get_product_images_cat.detail[listfind(cat_product_id_list,product_id,',')]#" output_server="#get_product_images_cat.path_server_id[listfind(cat_product_id_list,product_id,',')]#"  output_type="0" image_width="#cat_prod_width#" image_height="#cat_prod_height#">
									</a>
								</cfif>
								</td>
							</tr>
						</cfif>
						<cfif attributes.cat_product_name eq 1>
							<tr>
								<td align="center" style="vertical-align:top;">
								<cfif isdefined("attributes.cat_product_detail2") and attributes.cat_product_detail2 eq 1>
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
						<cfif attributes.cat_product_price eq 1>
							<tr>
								<td class="prodFiyat" align="center" style="vertical-align:top;">#price# #money# +KDV</td>
							</tr>
						</cfif>
						<cfif attributes.cat_product_detail eq 1>
							<tr>
								<td align="center" style="vertical-align:top;">#product_detail#</td>
							</tr>
						</cfif>
					</table>	
					</td>
					</cfoutput>	
				</tr>
				<tr><cfoutput>
						<td colspan="#cat_maxrows#" style="text-align:right;"><a href="#request.self#?fuseaction=objects2.view_product_list&all_product_id=#all_cat_product_id_list#" class="object_all"></a></td>
					</cfoutput>
				</tr>	
			</table>
		</cfif>
	</cfif>
</cfif>
