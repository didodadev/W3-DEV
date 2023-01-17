<cfif isdefined("attributes.product_id")>
	<cfset attributes.pid = attributes.product_id>
</cfif>
<cfquery name="GET_ALTERNATE_PRODUCT_EXCEPT" datasource="#DSN3#">
	SELECT
		P.PRODUCT_NAME,
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
		ALTERNATIVE_PRODUCTS_EXCEPT APE,
		PRODUCT_CAT PC,
		#dsn1_alias#.PRODUCT_CAT_OUR_COMPANY PCO
	WHERE
		P.PRODUCT_ID IN (SELECT PRODUCT_ID FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0) AND
		PS.PRODUCT_ID = APE.ALTERNATIVE_PRODUCT_ID AND
        PS.PRODUCT_ID = P.PRODUCT_ID AND
		PS.PRICESTANDART_STATUS = 1 AND
		PS.PURCHASESALES = 1 AND
		PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
		S.PRODUCT_ID = P.PRODUCT_ID AND
		APE.ALTERNATIVE_PRODUCT_ID = P.PRODUCT_ID AND
		<cfif isdefined("attributes.pid") and len(attributes.pid)>
			APE.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
		<cfelse>
			APE.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.product_id#"> AND
		</cfif>
		P.PRODUCT_CATID = PC.PRODUCT_CATID AND
		PC.IS_PUBLIC = 1 AND
		<cfif isdefined("session.pp")>P.IS_EXTRANET = 1 AND<cfelse>P.IS_INTERNET = 1 AND</cfif>
		P.PRODUCT_STATUS = 1 AND 
        S.STOCK_STATUS = 1
<!---UNION ALL
	SELECT
		P.PRODUCT_NAME,
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
		ALTERNATIVE_PRODUCTS_EXCEPT APE,
		PRODUCT_CAT PC,
		#dsn1_alias#.PRODUCT_CAT_OUR_COMPANY PCO
	WHERE
		PS.PRODUCT_ID = APE.PRODUCT_ID AND
        PS.PRODUCT_ID = P.PRODUCT_ID AND
		PS.PRICESTANDART_STATUS = 1 AND
		PS.PURCHASESALES = 1 AND
		PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = #session_base.our_company_id# AND
		S.PRODUCT_ID = P.PRODUCT_ID AND
		APE.PRODUCT_ID = P.PRODUCT_ID AND
		<cfif isdefined("attributes.pid") and len(attributes.pid)>
			APE.ALTERNATIVE_PRODUCT_ID = #attributes.pid# AND
		<cfelse>
			APE.ALTERNATIVE_PRODUCT_ID = #attributes.product_id# AND
		</cfif>
		P.PRODUCT_CATID = PC.PRODUCT_CATID AND
		PC.IS_PUBLIC = 1 AND
		<cfif isdefined("session.pp")>P.IS_EXTRANET = 1 AND<cfelse>P.IS_INTERNET = 1 AND</cfif>
		P.PRODUCT_STATUS = 1 AND 
        S.STOCK_STATUS = 1--->
</cfquery>
<cfif get_alternate_product_except.recordcount>
	<cfset product_id_list_except = ''>
	<cfset all_product_except = ''>
	<cfoutput query="get_alternate_product_except">
		<cfif not listfindnocase(product_id_list_except,get_alternate_product_except.product_id)>
			<cfset product_id_list_except = listappend(product_id_list_except,get_alternate_product_except.product_id,',')>
		</cfif>
		<cfif not listfindnocase(all_product_except,get_alternate_product_except.product_id)>
			<cfset all_product_except = listappend(all_product_except,get_alternate_product_except.product_id,',')>
		</cfif>
	</cfoutput>
	<cfif listlen(product_id_list_except)>
		<cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#">
			SELECT PATH,PRODUCT_ID,PATH_SERVER_ID,DETAIL FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID IN (#product_id_list_except#) ORDER BY PRODUCT_ID
		</cfquery>
		<cfset product_id_list_except = listdeleteduplicates(valuelist(get_product_images.product_id,','),'numeric','ASC',',')>
		<cfset product_id_list_except=listsort(product_id_list_except,"numeric","ASC",",")>
	</cfif>
	
	<cfif len(attributes.product_except_maxrows)>
		<cfset alternative_maxrows_except = #attributes.product_except_maxrows#>
	<cfelse>
		<cfset alternative_maxrows_except = ''>
	</cfif>
	<cfif isdefined("attributes.is_random_sorting") and attributes.is_random_sorting eq 1>
		<cfloop query="get_alternate_product_except">
		   <cfset querySetCell(get_alternate_product_except,"sorter",rand(),currentRow)>
		</cfloop>
		<cfquery name="GET_ALTERNATE_PRODUCT_EXCEPT" dbtype="query">
			SELECT * FROM GET_ALTERNATE_PRODUCT_EXCEPT ORDER BY SORTER
		</cfquery>
	</cfif>
	<cfif attributes.product_except_position eq 1>
		<table cellspacing="1" cellpadding="2" border="0" align="center" style="width:100%;">
			<cfoutput query="get_alternate_product_except" maxrows="#alternative_maxrows_except#">  
			<cfif attributes.product_except_image eq 1>
				<tr style="background-color:##FFFFFF;"> 
					<td rowspan="3" style="vertical-align:top;">
					<cfif listfindnocase(product_id_list_except,product_id)>
						<cfif isdefined("attributes.product_except_width") and len(attributes.product_except_width)>
							<cfset product_except_width =attributes.product_except_width>
						<cfelse>
							<cfset product_except_width = 70>
						</cfif>
						<cfif isdefined("attributes.product_except_height") and len(attributes.product_except_height)>
							<cfset product_except_height = attributes.product_except_height>
						<cfelse>
							<cfset product_except_height = 70>
						</cfif>
						<a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">
							<cf_get_server_file output_file="product/#get_product_images.path[listfind(product_id_list_except,product_id,',')]#" title="#get_product_images.detail[listfind(product_id_list_except,product_id,',')]#" alt="#get_product_images.detail[listfind(product_id_list_except,product_id,',')]#" output_server="#get_product_images.path_server_id[listfind(product_id_list_except,product_id,',')]#"  output_type="0" image_width="#product_except_width#" image_height="#product_except_height#">
						</a>
					</cfif>
					</td>
				</tr>
			</cfif>
			<cfif attributes.product_except_name eq 1>
				<tr>
					<td style="vertical-align:top;">
					<cfif isdefined("attributes.product_except_detail2") and attributes.product_except_detail2 eq 1>
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
			<cfif attributes.product_except_price eq 1>
				<tr>
					<td style="vertical-align:top;">#price# #money# +KDV</td>
				</tr>
			</cfif>
			<cfif attributes.product_except_detail eq 1>
				<tr>
					<td colspan="2">#product_detail#</td>
				</tr>
			</cfif>
			<cfif get_alternate_product_except.recordcount neq currentrow>
				<tr style="background-color:##FFFFFF;">
					<td colspan="2"><hr style="height:1px;" color="CCCCCC"></td>
				</tr>
			</cfif>			 
			</cfoutput>
			<tr>
				<td colspan="2"  style="text-align:right;"><a href="<cfoutput>#request.self#?fuseaction=objects2.view_product_list&all_product_id=#all_product_except#</cfoutput>" class="object_all"></a></td>
			</tr>
		</table>
	<cfelse>
		<table border="0" align="center" style="width:100%;">
			<tr>
				<cfoutput query="get_alternate_product_except" maxrows="#alternative_maxrows_except#">
				<td>
					<table style="width:100%;">  
						<cfif attributes.product_except_image eq 1>
                            <tr style="background-color:##FFFFFF;"> 
                                <td align="center" style="vertical-align:top;">
                                <cfif listfindnocase(product_id_list_except,product_id)>
                                    <cfif isdefined("attributes.product_except_width") and len(attributes.product_except_width)>
                                        <cfset product_except_width = #attributes.product_except_width#>
                                    <cfelse>
                                        <cfset product_except_width = ''>
                                    </cfif>
                                    <cfif isdefined("attributes.product_except_height") and len(attributes.product_except_height)>
                                        <cfset product_except_height = #attributes.product_except_height#>
                                    <cfelse>
                                        <cfset product_except_height = ''>
                                    </cfif>
                                    <a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">
                                        <cf_get_server_file output_file="product/#get_product_images.path[listfind(product_id_list_except,product_id,',')]#" title="#get_product_images.detail[listfind(product_id_list_except,product_id,',')]#" alt="#get_product_images.detail[listfind(product_id_list_except,product_id,',')]#" output_server="#get_product_images.path_server_id[listfind(product_id_list_except,product_id,',')]#"  output_type="0" image_width="#product_except_width#" image_height="#product_except_height#">
                                    </a>
                                </cfif>
                                </td>
                            </tr>
                        </cfif>
                        <cfif attributes.product_except_name eq 1>
                            <tr>
                                <td align="center" style="vertical-align:top;">
                                <cfif isdefined("attributes.product_except_detail2") and attributes.product_except_detail2 eq 1>
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
                        <cfif attributes.product_except_price eq 1>
                            <tr>
                                <td class="prodFiyat" align="center" style="vertical-align:top;">#price# #money# +KDV</td>
                            </tr>
                        </cfif>
                        <cfif attributes.product_except_detail eq 1>
                            <tr>
                                <td align="center" style="vertical-align:top;">#product_detail#</td>
                            </tr>
                        </cfif>
                    </table>	
				</td>
				</cfoutput>	
			</tr>
			<tr><cfoutput>
					<td colspan="#alternative_maxrows_except#" style="text-align:right;"><a href="#request.self#?fuseaction=objects2.view_product_list&all_product_id=#all_product_except#" class="object_all"></a></td>
				</cfoutput>
			</tr>
		</table>
	</cfif>
</cfif>
