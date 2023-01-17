<!--- Ürünün Bulunduğu Karma Koliler --->
<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_karma_products.cfm">
<cf_ajax_list>
	<tbody>
		<cfif GET_KARMA_PRODUCT.RecordCount eq 0 and GET_KARMA_FOR_PRODUCT.recordcount eq 0>
			<tr>
				<td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
		<cfelse>		
			<cfif GET_KARMA_PRODUCT.RecordCount>
				<tr>
					<td><a href="<cfoutput>#request.self#?fuseaction=product.dsp_karma_contents&pid=#attributes.pid#</cfoutput>"><cf_get_lang dictionary_id='54782.Master Koli'></a></td>	
				</tr>
			</cfif>	 
			<cfif GET_KARMA_FOR_PRODUCT.RecordCount>
				<cfoutput query="GET_KARMA_FOR_PRODUCT">
					<tr>
						<td><a href="#request.self#?fuseaction=product.dsp_karma_contents&pid=#KARMA_PRODUCT_ID#">#get_product_name(KARMA_PRODUCT_ID)#</a></td>	
					</tr>
				</cfoutput>				
			</cfif>	 
			
		</cfif>
	</tbody>
</cf_ajax_list>
<cfquery name="get_mix_detail" datasource="#DSN1#">
    SELECT 
    	DISTINCT
        P.PRODUCT_NAME 
    FROM 
        KARMA_PRODUCTS KP ,
        PRODUCT P
    WHERE
        KP.PRODUCT_ID =#attributes.pid# AND
        P.PRODUCT_ID = KP.KARMA_PRODUCT_ID
</cfquery>
<cfset CCS = "">
<cf_ajax_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='41167.İçinde Olunan Karma Koliler'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_mix_detail.recordcount>
			<cfoutput query="get_mix_detail">
				<tr>
					<td>#PRODUCT_NAME#</td>	
				</tr>
			</cfoutput>
		<cfelse>			 
			<tr>
				<td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
		</cfif>
	</tbody>
</cf_ajax_list>
