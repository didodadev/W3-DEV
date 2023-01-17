<cfscript>
	attributes.product_name = trim(attributes.product_name);
	list = "',""";
	list2 = " , ";
	attributes.product_name = replacelist(attributes.product_name,list,list2);// ürün adına tek ve cift tirnak yazilmamali
	attributes.manufact_code = trim(attributes.manufact_code);
</cfscript>
<cfquery name="GET_PRODUCT" datasource="#dsn1#">
	SELECT 
		PRODUCT.PRODUCT_ID,
		PRODUCT.PRODUCT_NAME,
		PRODUCT.PRODUCT_CODE,
		PRODUCT.BARCOD,
		PRODUCT.MANUFACT_CODE,
		PRODUCT_CAT.PRODUCT_CAT
	FROM
		PRODUCT,
		PRODUCT_CAT
	WHERE
		PRODUCT_CAT.PRODUCT_CATID = PRODUCT.PRODUCT_CATID AND
		(
			PRODUCT.PRODUCT_ID IS NULL 
			<cfif len(attributes.product_name)>OR PRODUCT.PRODUCT_NAME = '#attributes.product_name#'</cfif>
			<cfif len(attributes.manufact_code)>OR PRODUCT.MANUFACT_CODE = '#attributes.manufact_code#'</cfif>
		)
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='37603.Benzer Kriterlerde Kayitlar Bulundu'></cfsavecontent>
<div class="col col-12 col-xs-12">
	<cf_box title="#message#">
		<cf_flat_list>
			<thead>
				<tr>
					<th width="25"><cf_get_lang dictionary_id='57487.No'></th>
					<th nowrap><cf_get_lang dictionary_id='57657.Ürün'></th>
					<th nowrap><cf_get_lang dictionary_id='57486.Kategori'></th>
					<th nowrap width="120"><cf_get_lang dictionary_id='58800.Ürün Kodu'></th>
					<th width="80"><cf_get_lang dictionary_id='57633.Barkod'></th>
					<th nowrap width="100"><cf_get_lang dictionary_id='57634.Üretici Kodu'></th>
				</tr>
			</thead>
			<tbody>
				<form name="search_" method="post" action="">
				<cfif get_product.recordcount>
				<cfoutput query="get_product">
					<tr>
					<td>#currentrow#</td>
					<td nowrap><a href="://javascript" onClick="control(1,#product_id#);" class="tableyazi">#product_name#</a></td>
					<td>#product_cat#</td>
					<td>#product_code#</td>
					<td>#barcod#</td>
					<td>#manufact_code#</td>
				</tr>
				</cfoutput>
				<tr>
				<td colspan="8" style="text-align:right;"><input type="submit" name="Devam" id="Devam" value=" <cf_get_lang dictionary_id='37604.Varolan Kayıtları Gözardi Et'> " onClick="control(2,0);"></td>
				</tr>
				<cfelse>
					<tr>
						<td height="20" colspan="8"><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'> !</td>
					</tr>
				</cfif>
				</form>
			</tbody>
		</cf_flat_list>
	</cf_box>
</div>
<script type="text/javascript">
	<cfif not get_product.recordcount>
		window.close();
	</cfif>
	function control(id,value)
	{
		if(id==1)
		{
			opener.location.href='<cfoutput>#request.self#?fuseaction=product.list_product&event=det&is_search=1&pid=</cfoutput>' + value;
			window.close();
		}
		if(id==2)
		{
			window.close();
		}
	}
</script>
