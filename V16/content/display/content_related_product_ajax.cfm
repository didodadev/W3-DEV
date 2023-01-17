<cfsetting showdebugoutput="no">
<cfquery name="GET_RELATED_PRODUCTS" datasource="#DSN#">
	SELECT 
		PRODUCT_ID
	FROM
		CONTENT_RELATION
	WHERE
		CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#"> AND
		ACTION_TYPE = 'PRODUCT_ID'
</cfquery>
<table cellspacing="1" cellpadding="2" border="0" style="width:98%; text-align:center">
<cfif get_related_products.recordcount>
	<cfoutput query="get_related_products">
		<cfset attributes.product_id = get_related_products.product_id>
		<cfinclude template="../query/get_product_name.cfm">
		<tr class="color-row" height="20">
			<td><a href="javascript://" class="tableyazi" onClick="windowopen('#request.self#?fuseaction=objects.popup_dsp_product&pid=#attributes.product_id#','medium');">#get_product_name.product_name#</a></td>
			<cfsavecontent variable="pro_del"><cf_get_lang no ='181.Kayıtlı Ürün Baglantısını Siliyorsunuz! Emin misiniz'></cfsavecontent>
			<td width="15"><a href="##" onClick="javascript:if(confirm('#pro_del#')) windowopen('#request.self#?fuseaction=content.emptypopup_del_product&content_id=#url.cntid#&product_id=#get_product_name.product_id#','small'); return false;"><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" border="0" title="<cf_get_lang_main no='51.Sil'>"></a></td>
		</tr>
	</cfoutput>
<cfelse>
	<tr class="color-row" height="18">
		<td><cf_get_lang_main no='72.Kayıt Yok'>!</td>
	</tr>
</cfif>
</table>
