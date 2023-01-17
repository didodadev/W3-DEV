<!--- ürün detay iliskili ürünler --->
<cfsetting showdebugoutput="no">
<cfquery name="GET_RELATED_CAT" datasource="#dsn1#">
	SELECT 
	    PRC.RELATED_PRODUCT_CAT_ID,
    	PRC.PRODUCT_CAT_ID,
        PC.PRODUCT_CAT
    FROM 
    	RELATED_PRODUCT_CAT PRC,
        PRODUCT_CAT PC
    WHERE 
    	PRC.PRODUCT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND
        PC.PRODUCT_CATID = PRC.PRODUCT_CAT_ID
</cfquery>
<cf_flat_list>
	<tbody>
		<cfif get_related_cat.recordcount>
			<cfoutput query="get_related_cat">
				<tr>
					<td><a href="#request.self#?fuseaction=product.list_product_cat&event=upd&ID=#PRODUCT_CAT_ID#" target="_blank">#PRODUCT_CAT#</a></td>
					<td width="20"><a href="javascript://" onClick="javascript:if(confirm('#getLang('','İlişkili Ürün Siliyorsunuz! Emin misiniz?',37384)#')) windowopen('#request.self#?fuseaction=product.emptypopup_del_related_product_cat&related_cat_id=#RELATED_PRODUCT_CAT_ID#','small'); else return false;"><i class="fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
				</tr>
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
			</tr>    
		</cfif>
	</tbody> 
</cf_flat_list>
