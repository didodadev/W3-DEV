<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_product_stock_detail.cfm">
<cfset tree_status = stock_list = "">
<cfset colspn = 8>
<cf_grid_list>
	<thead>
        <tr>
            <th width="20"><cf_get_lang dictionary_id="58527.Id"></th>
            <th width="20"></th>
            <cfif attributes.is_production is 1><th width="20"></th></cfif>
            <th width="110"><cf_get_lang dictionary_id='57518.Stok Kodu'></th>
			<th width="110"><cf_get_lang dictionary_id='57789.özel kod'></th>
			<th width="20"><cf_get_lang dictionary_id='36588.Asorti'></th>
			<th width="110"><cf_get_lang dictionary_id='57636.Birim'></th>
            <th width="90"><cf_get_lang dictionary_id='57633.Barkod'></th>
            <th width="20"></th>
            <th width="200"><cf_get_lang dictionary_id='37428.Diğer Barkod'></th>
            <th width="200"><cf_get_lang dictionary_id='57629.Açıklama'></th>
        </tr>
    </thead>
    <tbody>
		<cfoutput query="get_stock_detail">
			<tr>
				<td width="10">#get_stock_detail.STOCK_ID#</td>
				<td align="center"><a href="javascript://" onClick="show_product_member_stock_code(#get_stock_detail.STOCK_ID#)"><i class="icon-plus-square" title="<cf_get_lang dictionary_id='37125.Üye Stok Kodu'>"> </i></td>
				<cfif attributes.is_production is 1>
					<cfquery name="tree_control" datasource="#dsn3#">
						SELECT PRODUCT_TREE_ID, STOCK_ID FROM PRODUCT_TREE WHERE STOCK_ID = #get_stock_detail.STOCK_ID#
					</cfquery>
					<cfset tree_status = listAppend(tree_status, ( len(tree_control.PRODUCT_TREE_ID)) ? tree_control.PRODUCT_TREE_ID : 0)>
					<cfif currentrow eq 1>
						<cfset main_tree_cnt = ( len(tree_control.PRODUCT_TREE_ID)) ? tree_control.PRODUCT_TREE_ID : 0>
					<cfelse>
						<cfset stock_list = listAppend(stock_list, tree_control.STOCK_ID)>
					</cfif>
					<td width="10" align="center">
						<a href="#request.self#?fuseaction=prod.list_product_tree&event=upd&product_id=#pid#&stock_id=#get_stock_detail.STOCK_ID#"> <i class="fa fa-tree" style="color:<cfif len(tree_control.PRODUCT_TREE_ID)>green<cfelse>red</cfif> !important;" border="0" title="<cf_get_lang dictionary_id='37104.Ürün Ağacı'>"> </i>
					</td>
				</cfif>
				<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.form_upd_popup_options&pid=#attributes.pid#&pcode=#attributes.product_code#&stock_id=#get_stock_detail.STOCK_ID#&is_terazi=#attributes.is_terazi#&is_inventory=#attributes.is_inventory#&is_auto_barcode=#is_auto_barcode#&is_product_status=#attributes.is_product_status#','','ui-draggable-box-medium');" class="tableyazi">#get_stock_detail.stock_code#</a> <cfif get_stock_detail.STOCK_STATUS is 0>(<cf_get_lang dictionary_id='57494.Pasif'>)</cfif></td>
				<td><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=product.form_upd_popup_options&pid=#attributes.pid#&pcode=#attributes.product_code#&stock_id=#get_stock_detail.STOCK_ID#&is_terazi=#attributes.is_terazi#&is_inventory=#attributes.is_inventory#&is_auto_barcode=#is_auto_barcode#&is_product_status=#attributes.is_product_status#','','ui-draggable-box-medium');" class="tableyazi">#get_stock_detail.stock_code_2#</a></td>
				<td>#get_stock_detail.ASSORTMENT_DEFAULT_AMOUNT#</td>
				<td>#get_stock_detail.ADD_UNIT#</td>
				<td>#get_stock_detail.BARCOD#</td>
				<td width="10">
				<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=objects.popup_form_add_stock_barcode&stock_id=#get_stock_detail.STOCK_ID#&is_terazi=#attributes.is_terazi#');"><i class="fa fa-barcode"  border="0" title="<cf_get_lang dictionary_id='57633.Barkod'>"></i></a>
				</td>
					<cfquery name="GET_STOCKS_BARCODES" datasource="#dsn1#">
						SELECT BARCODE FROM STOCKS_BARCODES WHERE STOCK_ID = #get_stock_detail.STOCK_ID# AND BARCODE<>'#get_stock_detail.BARCOD#'
					</cfquery>
				<td><cfloop query="GET_STOCKS_BARCODES">#BARCODE#<cfif GET_STOCKS_BARCODES.currentrow neq GET_STOCKS_BARCODES.recordcount>, </cfif></cfloop></td>
				<td>#get_stock_detail.property#</td>
			</tr>
        </cfoutput>
     </tbody>
</cf_grid_list>
<cfif cgi.HTTP_REFERER contains 'prod.list_product_tree'>
	<div class="ui-info-bottom">
		<cfif isdefined('main_tree_cnt') and main_tree_cnt gt 0 and listFind(tree_status, 0) neq 0>
			<a href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=prod.variation_product_tree&pid=#attributes.pid#&stock_id=#get_stock_detail.STOCK_ID#</cfoutput>')" class="ui-wrk-btn ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="fa fa-tree"></i><cf_get_lang dictionary_id='63521.Varyasonlara göre ürün ağacı yarat'></a>
		<cfelseif listFind(tree_status, 0) eq 0>
			<a href="javascript://" onclick="delTree('<cfoutput>#stock_list#</cfoutput>')" class="ui-wrk-btn btn-red color-C ui-wrk-btn-extra ui-wrk-btn-addon-left"><i class="fa fa-tree"></i><cf_get_lang dictionary_id='63706.Ürün ağacı varyasyonlarını temizle'></a>
		<cfelse>
			<cf_get_lang dictionary_id='63522.Ana ürün ağacı oluşmadan varsayson ağacı oluşturulamaz.'>
		</cfif>
	</div>
</cfif>
<table>
    <tr id="sc_tr1" height="22" style="display:none;">
    </tr>
    <tr id="sc_tr2" style="display:none;">
        <td colspan="9" class="nohover"><div id="_dsp_company_stock_code_"></div></td>
    </tr>
</table>
<script type="text/javascript">
	function show_product_member_stock_code(stock_id){
		goster(sc_tr1);goster(sc_tr2);
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=product.emptypopup_add_company_stock_code_ajax&pid=<cfoutput>#attributes.pid#</cfoutput>&sid='+stock_id+'','_dsp_company_stock_code_',1);
	}

	function delTree(stock_list) {
		var data = new FormData();
		data.append("stock_list", stock_list);
		if(confirm("<cf_get_lang dictionary_id='36366.Ürün Ağacının Bileşenleri Silinecektir'> , <cf_get_lang dictionary_id='36367.Yaptığınız İşlem Geri Alınamaz'> ! <cf_get_lang dictionary_id='58588.Emin misiniz'>?")){
				AjaxControlPostDataJson("V16/production_plan/cfc/get_tree.cfc?method=del_prod_tree", data, function(response){
						if( response.STATUS ){
							alert(response.MESSAGE);
							location.reload();
						}
					});
					return false;
			}
			else
				return false;
	}
</script>