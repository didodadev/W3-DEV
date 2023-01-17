<cfparam name="attributes.product_compare" default="1">
<cfparam name="attributes.is_image" default="1">
<cfparam name="attributes.is_popup" default="0">

<cfquery name="GET_SIMPLE_PRODUCT" datasource="#DSN3#">
	SELECT
		P.STOCK_ID,
		P.PRODUCT_ID,
		P.PRODUCT_NAME,
		P.BRAND_ID,
		PC.PRODUCT_CAT,
		P.PRODUCT_DETAIL
	FROM
		STOCKS P,
		PRODUCT_CAT PC,
		#dsn1_alias#.PRODUCT_CAT_OUR_COMPANY PCO
	WHERE
		PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session_base.our_company_id#"> AND
		P.PRODUCT_CATID = PC.PRODUCT_CATID AND
		P.PRODUCT_STATUS = 1 AND
		<!---<cfif isdefined("session.pp")>P.IS_EXTRANET = 1 AND<cfelse>P.IS_INTERNET = 1 AND</cfif>--->
		P.PRODUCT_ID IN
        (
            SELECT 
                PRODUCT_ID
            FROM 
                CATALOG_PROMOTION_PRODUCTS AS CPP,
                CATALOG_PROMOTION AS CP
            WHERE
                CP.CATALOG_ID = CPP.CATALOG_ID AND 
                CP.CAMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#camp_id#"> AND
                CP.IS_APPLIED = 1 AND
                #now()# BETWEEN CP.STARTDATE AND CP.FINISHDATE
        )
</cfquery>

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_simple_product.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<!--- <cfdump var="#get_simple_product#"> --->

<cfset brand_list = ''>
<cfset image_list = ''>
<cfoutput query="get_simple_product" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
	<cfset brand_list = listappend(brand_list,get_simple_product.brand_id,',')>
	<cfset image_list = listappend(image_list,get_simple_product.product_id,',')>
</cfoutput>	
<cfset brand_list=listsort(brand_list,"numeric","ASC",",")>
<cfset image_list=listsort(image_list,"numeric","ASC",",")>
<cfif listlen(brand_list)>
	<cfquery name="GET_BRANDS" datasource="#DSN1#">
		SELECT 
			PRODUCT_BRANDS.BRAND_NAME,
			PRODUCT_BRANDS.BRAND_ID 
		FROM 
			PRODUCT_BRANDS
		WHERE 
			PRODUCT_BRANDS.BRAND_ID IN (#brand_list#)
	</cfquery>
	<cfset brand_list = listsort(listdeleteduplicates(valuelist(get_brands.brand_id,',')),'numeric','ASC',',')>
</cfif>
<cfif listlen(image_list)>
	<cfquery name="GET_PRODUCT_IMAGES" datasource="#DSN3#">
		SELECT PATH,PRODUCT_ID,PATH_SERVER_ID FROM PRODUCT_IMAGES WHERE IMAGE_SIZE = 0 AND PRODUCT_ID IN (#image_list#)
	</cfquery>
	<cfset image_list = listdeleteduplicates(valuelist(get_product_images.product_id,','),'numeric','ASC',',')>
	<cfset image_list = listsort(image_list,"numeric","ASC",",")>
</cfif>

<table cellpadding="2" cellspacing="2" border="0" style="width:100%;">
	<cfoutput query="get_simple_product" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<tr <cfif currentrow mod 2> class="color-list" <cfelse>class="color-row" </cfif> style="height:20px;">
	  		<td style="width:20px;">#currentrow#</td>
	  		<td style="width:20%;">
				<cfif listfindnocase(image_list,product_id)>
					<cf_get_server_file output_file="product/#get_product_images.path[listfind(image_list,product_id,',')]#" output_server="#get_product_images.path_server_id[listfind(image_list,product_id,',')]#"  output_type="0" image_width="50" image_height="50" image_link=1 alt="#getLang('objects2',207)#" title="#getLang('objects2',207)#">
				</cfif>
	  		</td>
	  		<td>
	  			<cfif len(brand_id)>#get_brands.brand_name[listfind(brand_list,brand_id,',')]#</cfif> - #product_cat# <br/>
	  			<a href="#request.self#?fuseaction=objects2.detail_product&product_id=#product_id#&stock_id=#stock_id#" class="tableyazi">#product_name#</a>
				<br/>#product_detail#
			</td>
		</tr>
	</cfoutput>
</table>

<cfif get_simple_product.recordcount and (attributes.totalrecords gt attributes.maxrows)>
	<!-- sil -->
		<table cellpadding="0" cellspacing="0" border="0" align="center" style="width:98%; height:30px;">
			<tr> 
				<td>
					<cf_pages page="#attributes.page#" 
						maxrows="#attributes.maxrows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#" 
						adres="objects2.dsp_campaign&camp_id=#attributes.camp_id#"> 
				</td>
				<!-- sil --><td  style="text-align:right;"> <cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		  	</tr>
		</table>
	<!-- sil -->
</cfif>
