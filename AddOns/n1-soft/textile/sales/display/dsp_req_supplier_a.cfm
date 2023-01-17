<!----------NUMUNE SAYFASI AKSESUAR DETAYLARI SAYFASI-------------------------->

<cfparam name="attributes.product_plan" default="0">
<cfparam name="attributes.modelhouse_plan" default="0">
<cfparam name="attributes.price_plan" default="0">
<cfparam name="attributes.request_plan" default="0">
<cfparam name="attributes.plan_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.category" default="">
<cfinclude template="../../../../../V16/objects/query/get_product_cat2.cfm">
<cfset textile_round=3>
<cfsetting showdebugoutput="no">
<cf_xml_page_edit fuseact="textile.list_sample_request">
<cfscript>
	CreateCompenent = CreateObject("component","AddOns.N1-Soft.textile.cfc.get_req_supplier_rival");
	getAuthority=CreateCompenent.getProcessAuthority(process_stage:full_stage_id);
	plan_id=attributes.plan_id;
	if(attributes.modelhouse_plan eq 1)//plana gore bakmasına gerek yok diye dusunuyoruz
	plan_id='';
	if(attributes.request_plan eq 1 or getAuthority gt 0)
		getSupplier_ = CreateCompenent.getOppSupplier(req_id:attributes.req_id,req_type=attributes.req_type,plan_id:plan_id);
	else {
		getSupplier_ = CreateCompenent.getOppSupplier(req_id:attributes.req_id,req_type=attributes.req_type,access=1,plan_id:plan_id);
	}
	get_money = CreateCompenent.getMoney();
		get_operation=CreateCompenent.getOperation();
	getProductCat=CreateCompenent.getProductCat(product_catid:accessory_pcatid);
</cfscript>
<cfform name="add_opp_supplier_a" method="post" action="#request.self#?fuseaction=textile.emptypopup_add_req_supplier_act_a" enctype="multipart/form-data">
	<cf_big_list>
		<cfoutput>
			<cfif attributes.request_plan eq 1>
				<input type="hidden" name="supplier_page" value="request_plan">
			<cfelseif attributes.price_plan eq 1>
				<input type="hidden" name="supplier_page" value="price_plan">
			<cfelseif attributes.modelhouse_plan eq 1>
				<input type="hidden" name="supplier_page" value="modelhouse_plan">
			<cfelseif attributes.product_plan eq 1>
				<input type="hidden" name="supplier_page" value="product_plan">
			</cfif>
			<input type="hidden" name="req_id" id="req_id" value="#attributes.req_id#">
			<input type="hidden" name="other_process" id="other_process" value="0">
			<input type="hidden" name="req_type" id="req_type" value="#attributes.req_type#">
			<input type="hidden" name="record_num" id="record_num" value="#getSupplier_.RECORDCOUNT#">
			<cfif isDefined("attributes.plan_id") and len(attributes.plan_id)>
				<input type="hidden" name="plan_id" id="plan_id" value="#attributes.plan_id#">
			</cfif>
		</cfoutput>
        <thead>
            <tr>
                 <th width="15"><cfif attributes.request_plan eq 1><input type="button" class="eklebuton" onClick="add_rowa();"></cfif></th>
				 <cfif attributes.request_plan eq 1><th>İş</th></cfif>
				 <th>Durum</th>
				 <th>Asıl/Revize</th>
				 <th width="100">Kategori*</th>
				 <th width="50">Operasyon*</th>
                 <th width="170"><cf_get_lang_main no='1736.Tedarikçi'></th>
				 <th width="200">Hammadde*</th>
                 <th width="200"><cf_get_lang_main no='245.Ürün'></th>
				 <th width="50">Miktar</th>
				 <th width="50">Birim</th>
				 <th width="50">Fiyat</th>
				 <th width="50" style="display:none;">En</th>
				 <th width="50">R.Miktar</th>
				 <th width="50">R.Fiyat</th>
				 <th width="50"><cf_get_lang_main no='77.Para Birimi'></th>
				 <th width="50">Açıklama</th>
				 <th width="250">Resim</th>
				 <th width="15">İç Talep No</th>
					<!---<cfif attributes.modelhouse_plan eq 1>
						<th width="50"></th>	
					</cfif>--->
            </tr>
        </thead>
        <tbody id="table1a">
		<cfoutput query="getSupplier_">
			<cfif len(brand_id)>
				<cfquery name="get_brand" datasource="#dsn1#">
					SELECT BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID = #brand_id#
				</cfquery>
			</cfif>
			<tr name="frm_row_#currentrow#" id="frm_row_#currentrow#" class="<cfif getSupplier_.is_status eq 0>lock</cfif>">
				<td nowrap="nowrap">
				<input type="hidden" name="rowid#currentrow#" value="#getSupplier_.id#">
				<input type="hidden" name="wrk_row_id#currentrow#" value="#getSupplier_.wrk_row_id#">
				<input type="hidden" name="work_id#currentrow#" value="#getSupplier_.work_id#">
					<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
					<cfif attributes.request_plan eq 1>
						<cfif not len(getSupplier_.plan_id)><a style="cursor:pointer" onclick="sil_supplier_(#currentrow#);"><img  src="images/delete_list.gif" border="0"></a></cfif>
						&nbsp;&nbsp;
							<cfif getSupplier_.is_status neq 0>
								<a style="cursor:pointer" onclick="copy_supplier_(#currentrow#);"><img  src="images/copy_list.gif" border="0"></a>
							</cfif>
					</cfif>
				
				</td>
				<cfif attributes.request_plan eq 1><td><cfif len(plan_id)><a href="javacript://" class="tableyazi" onclick="window.open('#request.self#?fuseaction=textile.accessory_price&event=upd&plan_id=#plan_id#','page')">#plan_id#</a></cfif></td></cfif>
				<td>
						<select name="status#currentrow#" id="status#currentrow#">
								<option value="1" <cfif getSupplier_.is_status neq 0>selected</cfif>>Aktif</option>
								<option value="0" <cfif getSupplier_.is_status eq 0>selected</cfif>>Pasif</option>
						</select>
				</td>
				<td>
						<select name="revize#currentrow#"  id="revize#currentrow#">
								<option value="0" <cfif getSupplier_.is_revision neq 1>selected</cfif>>Asıl</option>
								<option value="1" <cfif getSupplier_.is_revision eq 1>selected</cfif>>Revize</option>
						</select>
				</td>
				<td nowrap="nowrap" style="width:200px;">
					<select name="category#currentrow#" class="supplier-product-cat" id="category_supp_a#currentrow#" <cfif attributes.request_plan eq 0>readonly<cfelse>required</cfif> onchange = "getOperation_suplier_a(this.value, 'operation#currentrow#')">
						<option value="">Seçiniz</option>
						<cfif GET_PRODUCT_CAT.recordCount>
							<cfloop query="GET_PRODUCT_CAT">
								<option value="#GET_PRODUCT_CAT.product_catid#" <cfif getSupplier_.product_catid eq GET_PRODUCT_CAT.product_catid>selected</cfif>>#GET_PRODUCT_CAT.product_cat#</option>
							</cfloop>
						</cfif>
					</select>
				</td>
				<td nowrap="nowrap" >
					<select style="width:70px;" <cfif attributes.request_plan eq 0>disabled</cfif> name="operation#currentrow#" id="operation#currentrow#">
						<option value="">Seçiniz</option>
						<cfloop query="get_operation"><option value="#operation_type_id#" <cfif get_operation.OPERATION_TYPE_ID eq getSupplier_.operation_id>selected</cfif>>#OPERATION_TYPE#</option></cfloop>
					</select>
				
				</td>
				<td nowrap="nowrap"><input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#company_id#">
					<input type="text" name="company_name#currentrow#"  id="company_name#currentrow#" value="#get_par_info(company_id,1,1,0)#" style="width:150px;" readonly>
					<a href="javascript://" onClick="pencereSupplier_('#currentrow#');"><img border="0" src="/images/plus_thin.gif" align="absmiddle"></a>
				</td>
				<td nowrap="nowrap">
					<input type="text" name="demand_stock#currentrow#" <cfif attributes.request_plan eq 0>disabled</cfif> id="demand_stock#currentrow#" value="#REQUEST_COMPANY_STOCK#"  style="width:200px;">	
				</td>
				
				<td nowrap="nowrap">
					<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#stock_id#">
					<input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
					<input type="text" name="product#currentrow#" id="product#currentrow#" value="#product_name#" style="width:200px;" <cfif attributes.price_plan eq 0>disabled</cfif>>
					<cfif attributes.price_plan eq 1>
						<a href="javascript://" onclick="pencere_ac_product_('#currentrow#');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
					</cfif>
				</td>
				<td nowrap="nowrap">
					<input type="text" name="quantity#currentrow#" <cfif attributes.modelhouse_plan eq 0 and attributes.request_plan eq 0>disabled</cfif>  value="#tlformat(getSupplier_.quantity,textile_round)#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#textile_round#));" onBlur="fiyat_hesapla('#currentrow#');" style="width:50px;">
				</td>
				<td nowrap="nowrap">
						<input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="#unit_id#">
						<input type="text" name="unit_name#currentrow#" id="unit_name#currentrow#" value="#unit#" readonly  style="width:40px;">
					
				</td>
				<td nowrap="nowrap">
					<input type="text" name="price#currentrow#" value="#tlformat(getSupplier_.price,textile_round)#" class="moneybox" <cfif attributes.price_plan eq 0>disabled</cfif> onkeyup="return(FormatCurrency(this,event,#textile_round#));" onBlur="fiyat_hesapla('#currentrow#');" style="width:50px;">
					<input type="hidden" name="total_price#currentrow#" id="total_price#currentrow#">
				</td>
				<td nowrap="nowrap" style="display:none;">
					<input type="text" name="en#currentrow#" value="#tlformat(getSupplier_.en,textile_round)#" class="moneybox"  <cfif attributes.price_plan eq 1>disabled</cfif> onkeyup="return(FormatCurrency(this,event,#textile_round#));" onBlur="fiyat_hesapla('#currentrow#');"  style="display:none;">
				</td>
				<td nowrap="nowrap">
					<input type="text" readonly name="revize_quantity#currentrow#" <cfif attributes.modelhouse_plan eq 0 >disabled</cfif>  value="#tlformat(getSupplier_.revize_quantity,textile_round)#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#textile_round#));" onBlur="fiyat_hesapla('#currentrow#');" style="width:50px;">
				</td>
				<td nowrap="nowrap">
					<input type="text" name="revize_price#currentrow#" value="#tlformat(getSupplier_.revize_price,textile_round)#" readonly class="moneybox" <cfif attributes.price_plan eq 0>disabled</cfif> onkeyup="return(FormatCurrency(this,event,#textile_round#));" onBlur="fiyat_hesapla('#currentrow#');" style="width:50px;">
					<input type="hidden" name="revize_total_price#currentrow#" id="revize_total_price#currentrow#">
				</td>
				
				<td>
					<select name="money#currentrow#" id="money#currentrow#"  <cfif attributes.price_plan eq 0>disabled</cfif>  style="width:60px;">
					<cfloop query="get_money">
						<option value="#get_money.money#" <cfif get_money.money is getSupplier_.money_type>selected</cfif>>#get_money.money#</option>
					</cfloop>
					</select>
				</td>
				<td><input type="text" name="row_detail#currentrow#" value="#getSupplier_.row_detail#" style="width:150px;"></td>
				<td nowrap="nowrap">
					<cfif len(IMAGE_PATH)>
						<a href="javascript://" onclick="windowopen('/documents/textile/aksesuar/#IMAGE_PATH#','wwide');"><img src="/addons/n1-soft/textile/img/file_zcn_store.png" width="24" height="24" /></a><a>
						<input type="hidden"  name="image_var#currentrow#" id="image_var#currentrow#" value="#IMAGE_PATH#">
						<input type="file" style="width:120px;" name="image_#currentrow#" id="image_#currentrow#" value="">
						</a>
					<cfelse>
						<input type="file" style="width:120px;"  name="image_#currentrow#" id="image_#currentrow#" value="">
					</cfif>
				
				</td>
				<td>
					<input type="hidden"  name="i_id#currentrow#" id="i_id#currentrow#" value="#i_id#">
					<cfif len(i_id)>
						<a href="#request.self#?fuseaction=purchase.list_internaldemand&event=upd&id=#i_id#">#INTERNAL_NUMBER#<i class="fa fa-external-link fa-lg"></i></a>
					</cfif>
				</td>
				<!---<cfif attributes.modelhouse_plan eq 1>
					<td>
						<button type="button" name="btndemand" class="btn btn-yellow">İç talep oluştur</button>
					</td>
				</cfif>--->
			</tr>
		</cfoutput>
        </tbody>
		<tfoot>
        	<tr>
            	<td colspan="19"> 
					<div style="float:left;">
						<cfif getSupplier_.recordcount gt 0>
							<cfif attributes.request_plan eq 1>
								<cfif isDefined("attributes.req_stage") and attributes.req_stage neq request_accept_stage_id>
									<cf_workcube_buttons is_upd='1' is_delete="0" add_function='supplier_kontrol_(0)' type_format="1">
								</cfif>
							<cfelse>
								<cf_workcube_buttons is_upd='1' is_delete="0" add_function='supplier_kontrol_(0)' type_format="1">
							</cfif>
						<cfelse>
							<cf_workcube_buttons is_upd='0' add_function='supplier_kontrol_(0)' type_format="1">
						</cfif>
					</div>
					<div style="float:right;">
					<cfif attributes.price_plan eq 1>
						<button type="button" onclick="gondertalep('add_opp_supplier_a');" name="btndemand" class="btn btn-yellow">İç talep oluştur</button>
					</cfif>
					</div>
                    <div style="float:right;display:none;">
							<cfif getSupplier_.recordcount gt 0 and attributes.product_plan eq 1>
								<button type="button" name="btnsend" class="btn btn-primary" value="" onclick="supplier_kontrol_(1);">Diğer birimlere gönder</button>
							<cfelseif getSupplier_.recordcount gt 0 and attributes.request_plan eq 1>
								<button type="button" name="btnsend" class="btn btn-primary" value="" onclick="supplier_kontrol_(-2);">Ürün yönetimine gönder</button>	
							</cfif>
					</div>
				<!---	<cfif attributes.request_plan eq 1>
								<div class="navi" style="float:right;">
											<a href="##" class="previous round" onClick="gizle_goster_('list_supplier_a','list_supplier_k');">&laquo; Geri</a>
											<a href="##" class="next round btn-primary" onClick="gizle_goster_('list_supplier_a','list_process');">İleri&raquo;</a>
								</div>
							</cfif>--->
					<div style="float:left;" id="show_user_message1_a"></div>
                </td>
            </tr>
        </tfoot>
	</cf_big_list>
</cfform>
<script type="text/javascript">
row_count_=<cfoutput>#getSupplier_.RECORDCOUNT#</cfoutput>;


<cfif attributes.request_plan eq 1>
	if(row_count_==0)
	{
	<cfoutput query="getProductCat">
		add_rowa('#HIERARCHY# #PRODUCT_CAT#','#PRODUCT_CATID#');
	</cfoutput>
		
	}
</cfif>



function sil_supplier_(sy)
{
	var my_element=eval("add_opp_supplier_a.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row_"+sy);
	my_element.style.display="none";
}
function copy_supplier_(sy)
{
	if(eval('document.add_opp_supplier_a.status'+sy).value==0)
	{
		return;
	}

	eval('document.add_opp_supplier_a.status'+sy).value=0;
	eval('document.add_opp_supplier_a.revize'+sy).value=0;
	var category=eval('document.add_opp_supplier_a.category_supp_a'+sy).value;
	var operation=eval('document.add_opp_supplier_a.operation'+sy).value;
	var company_name='';//eval('document.add_opp_supplier_a.company_name'+sy).value;
	var company_id='';//eval('document.add_opp_supplier_a.company_id'+sy).value;
	var demand_stock=eval('document.add_opp_supplier_a.demand_stock'+sy).value;
	var stock_id='';//eval('document.add_opp_supplier_a.stock_id'+sy).value;
	var product_id='';//eval('document.add_opp_supplier_a.product_id'+sy).value;
	var product='';//eval('document.add_opp_supplier_a.product'+sy).value;
	var quantity='';//eval('document.add_opp_supplier_a.quantity'+sy).value;
	var unit_id='';//eval('document.add_opp_supplier_a.unit_id'+sy).value;
	var unit_name='';//eval('document.add_opp_supplier_a.unit_name'+sy).value;
	var price='';//eval('document.add_opp_supplier_a.price'+sy).value;
	var en='';//eval('document.add_opp_supplier_a.en'+sy).value;
	var revize_quantity='';//eval('document.add_opp_supplier_a.revize_quantity'+sy).value;
	var revize_price='';//eval('document.add_opp_supplier_a.revize_price'+sy).value;
	var money=eval('document.add_opp_supplier_a.money'+sy).value;
	var row_detail='';//eval('document.add_opp_supplier_a.row_detail'+sy).value;
	var image_='';//eval('document.add_opp_supplier_a.image_'+sy).value;
	
	row_count_++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table1a").insertRow(document.getElementById("table1a").rows.length);
	newRow.setAttribute("name","frm_row_" + row_count_);
	newRow.setAttribute("id","frm_row_" + row_count_);	
	newRow.setAttribute("NAME","frm_row_" + row_count_);
	newRow.setAttribute("ID","frm_row_" + row_count_);				
	document.add_opp_supplier_a.record_num.value=row_count_;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="hidden" name="wrk_row_id'+row_count_+'" value=""><input type="hidden" name="work_id'+row_count_+'" value=""><input type="hidden" name="row_kontrol'+row_count_+'" value="1"><a style="cursor:pointer" onclick="sil_supplier(' + row_count_ + ');"><img src="images/delete_list.gif" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;<a style="cursor:pointer" onclick="copy_supplier_('+ row_count_ +');"><img  src="images/copy_list.gif" border="0"></a>';
	
	<cfif attributes.request_plan eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML ='';
	</cfif>

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML ='<select name="status'+row_count_+'" id="status'+row_count_+'"><option value="1">Aktif</option><option value="0">Pasif</option></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML ='<select name="revize'+row_count_+'" id="revize'+row_count_+'"><option value="0">Asıl</option><option value="1">Revize</option></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML ='<select name="category'+row_count_+'" class="supplier-product-cat" id="category_supp_a'+row_count_+'" <cfif attributes.request_plan eq 0>readonly<cfelse>required</cfif> onchange = "getOperation_suplier_a(this.value, \'operation'+row_count_+'\')"><option value="">Seçiniz</option><cfif GET_PRODUCT_CAT.recordCount><cfloop query="GET_PRODUCT_CAT"><option value="<cfoutput>#product_catid#</cfoutput>"><cfoutput>#product_cat#</cfoutput></option></cfloop></cfif></select>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<select style="width:70px;" <cfif attributes.request_plan eq 0>disabled</cfif> name="operation'+row_count_+'" id="operation'+row_count_+'"><option value="">Seçiniz</option><cfoutput query="get_operation"><option value="#OPERATION_TYPE_ID#" <cfif isdefined("attributes.default_station") and attributes.default_station eq getSupplier_.operation_id>selected</cfif>>#OPERATION_TYPE#</option></cfoutput></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="company_name'+row_count_+'" <cfif attributes.request_plan eq 0>disabled</cfif>  value="'+company_name+'" style="width:150px;" readonly><input type="hidden" name="company_id'+row_count_+'" value="'+company_id+'"> 	<cfif attributes.request_plan eq 1><a href="javascript://" onClick="pencereSupplier('+row_count_+');"><img border="0" src="/images/plus_thin.gif" align="absmiddle"></a></cfif>';
	
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="demand_stock'+row_count_+'" <cfif attributes.request_plan eq 0>disabled</cfif> value="'+demand_stock+'" style="width:200px;">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="hidden" name="stock_id' + row_count_ +'" value="'+stock_id+'"><input type="hidden" name="product_id' + row_count_ +'" value="'+product_id+'"><input type="text" name="product' + row_count_ +'" value="'+product+'" style="width:200px;" <cfif attributes.product_plan eq 0>disabled</cfif>>&nbsp; <cfif attributes.product_plan eq 1><a onclick="javascript:pencere_ac_product(' + row_count_ + ');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></cfif>';
	
	newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="quantity' + row_count_ +'" <cfif attributes.modelhouse_plan eq 0 >disabled</cfif> value="'+quantity+'" class="moneybox" onkeyup="return(FormatCurrency(this,event));" onBlur="fiyat_hesapla(' + row_count_ + ');" style="width:50px;">';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="hidden" name="unit_id' + row_count_ +'" id="unit_id' + row_count_ +'" value="'+unit_id+'"><input type="text"  name="unit_name' + row_count_ +'" id="unit_name' + row_count_ +'" value="'+unit_name+'" readonly <cfif attributes.product_plan eq 0>disabled</cfif> style="width:40px;">';
	
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="price' + row_count_ +'" <cfif attributes.price_plan eq 0>disabled</cfif> value="'+price+'" class="moneybox" onkeyup="return(FormatCurrency(this,event,<cfoutput>#textile_round#</cfoutput>));" onBlur="fiyat_hesapla(' + row_count_ + ');" style="width:50px;"><input type="hidden" name="total_price'+row_count_ +'" id="total_price'+ row_count_ +'">';

	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="en'+row_count_ +'" value="'+en+'" class="moneybox" onkeyup="return(FormatCurrency(this,event,<cfoutput>#textile_round#</cfoutput>));" style="display:none;">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="revize_quantity'+ row_count_ +'" <cfif attributes.modelhouse_plan eq 0 >disabled</cfif>  value="'+revize_quantity+'" class="moneybox" onkeyup="return(FormatCurrency(this,event,<cfoutput>#textile_round#</cfoutput>));" onBlur="fiyat_hesapla(' + row_count_ + ');" style="width:50px;">';
		
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="revize_price' + row_count_ +'" value="'+revize_price+'" class="moneybox" <cfif attributes.price_plan eq 0>disabled</cfif> onkeyup="return(FormatCurrency(this,event));" onBlur="fiyat_hesapla(' + row_count_ + ');" style="width:50px;"><input type="hidden" name="revize_total_price' + row_count_ +'" id="revize_total_price' + row_count_ +'">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<select name="money' + row_count_ +'" id="money' + row_count_ +'" style="width:60px;" <cfif attributes.price_plan eq 0>disabled</cfif>><cfoutput query="get_money"><option value="#get_money.money#" >#get_money.money#</option></cfoutput></select>';
		
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="row_detail' + row_count_ +'" id="row_detail' + row_count_+'"  value="'+row_detail+'" style="width:150px;">';
			
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="file"  name="image_'+row_count_+'" id="image_'+row_count_+'">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '';
	
	eval('document.add_opp_supplier_a.category_supp_a'+row_count_).value=category;
	eval('document.add_opp_supplier_a.operation'+row_count_).value=operation;
	eval('document.add_opp_supplier_a.money'+row_count_).value=money;
	eval('document.add_opp_supplier_a.revize'+row_count_).value=1;
	
	$(".supplier-product-cat").select2();

colorchange_(sy,row_count_);
	
	
}
colorchange_();
function colorchange_(sy,newrow)
{
  if(sy!=undefined)
  {
	$('#table1a #'+'frm_row_'+sy+' td').css("background-color", "#CD6155");
	$('#table1a #'+'frm_row_'+sy+' td').css("color", "#000");
	if(eval('document.add_opp_supplier_a.revize'+newrow).value=='1')
		{
			$('#table1a #'+'frm_row_'+newrow+' td').css("background-color", "yellow");
			$('#table1a #'+'frm_row_'+newrow+' td').css("color", "#000");
		}
  }
  else
  {
	for(var i=1;i<=row_count_;i++)
	{	if(eval('document.add_opp_supplier_a.status'+i).value=='0')
		{
			$('#table1a #'+'frm_row_'+i+' td').css("background-color", "#CD6155");
			$('#table1a #'+'frm_row_'+i+' td').css("color", "#000");
		}
		if(eval('document.add_opp_supplier_a.revize'+i).value=='1')
		{
			$('#table1a #'+'frm_row_'+i+' td').css("background-color", "#ABEBC6");
			$('#table1a #'+'frm_row_'+i+' td').css("color", "#000");
		}
	}
  
  }
	
}
function add_rowa(pcat,pcatid)
{
	if(pcat==undefined)
	{
		pcat="";
		pcatid="";
	}


	
	row_count_++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table1a").insertRow(document.getElementById("table1a").rows.length);
	newRow.setAttribute("name","frm_row_" + row_count_);
	newRow.setAttribute("id","frm_row_" + row_count_);	
	newRow.setAttribute("NAME","frm_row_" + row_count_);
	newRow.setAttribute("ID","frm_row_" + row_count_);				
	document.add_opp_supplier_a.record_num.value=row_count_;
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="wrk_row_id'+row_count_+'" value=""><input type="hidden" name="work_id'+row_count_+'" value=""><input type="hidden" name="row_kontrol'+row_count_+'" value="1"><a style="cursor:pointer" onclick="sil_supplier_(' + row_count_ + ');"><img src="images/delete_list.gif" border="0"></a>&nbsp;&nbsp;&nbsp;&nbsp;<a style="cursor:pointer" onclick="copy_supplier_('+ row_count_ +');"><img  src="images/copy_list.gif" border="0"></a>';
	
	<cfif attributes.request_plan eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML ='';
	</cfif>

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML ='<select name="status'+row_count_+'" id="status'+row_count_+'"><option value="1">Aktif</option><option value="0">Pasif</option></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML ='<select name="revize'+row_count_+'" id="revize'+row_count_+'"><option value="0">Asıl</option><option value="1">Revize</option></select>';
	
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML ='<select name="category'+row_count_+'" class="supplier-product-cat" id="category_supp_a'+row_count_+'" <cfif attributes.request_plan eq 0>readonly<cfelse>required</cfif> onchange = "getOperation_suplier_a(this.value, \'operation'+row_count_+'\')"><option value="">Seçiniz</option><cfif GET_PRODUCT_CAT.recordCount><cfloop query="GET_PRODUCT_CAT"><option value="<cfoutput>#product_catid#</cfoutput>"><cfoutput>#product_cat#</cfoutput></option></cfloop></cfif></select>';
	$(".supplier-product-cat").select2();
	
	<!---
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<select style="width:70px;" <cfif attributes.request_plan eq 0>disabled</cfif> name="work_station'+row_count_+'"><cfoutput query="get_workstation"><option value="#station_id#" <cfif isdefined("attributes.default_station") and attributes.default_station eq station_id>selected</cfif>>#station_name#</option></cfoutput></select>';
	--->
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<select style="width:70px;" <cfif attributes.request_plan eq 0>disabled<cfelse>readonly</cfif> name="operation'+row_count_+'" id="operation'+row_count_+'"><option value="">Seçiniz</option><cfoutput query="get_operation"><option value="#OPERATION_TYPE_ID#" <cfif isdefined("attributes.default_station") and attributes.default_station eq getSupplier_.operation_id>selected</cfif>>#OPERATION_TYPE#</option></cfoutput></select>';
	
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="company_name'+row_count_+'" <cfif attributes.request_plan eq 0>disabled</cfif>  value="" style="width:150px;" readonly><input type="hidden" name="company_id'+row_count_+'" value=""> 	<cfif attributes.request_plan eq 1><a href="javascript://" onClick="pencereSupplier_('+row_count_+');"><img border="0" src="/images/plus_thin.gif" align="absmiddle"></a></cfif>';
	
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="demand_stock'+row_count_+'" <cfif attributes.request_plan eq 0>disabled<cfelse>required</cfif> value="" style="width:200px;">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="hidden" name="stock_id' + row_count_ +'"><input type="hidden" name="product_id' + row_count_ +'"><input type="text" name="product' + row_count_ +'" style="width:200px;" <cfif attributes.product_plan eq 0>disabled</cfif>>&nbsp; <cfif attributes.product_plan eq 1><a onclick="javascript:pencere_ac_product_(' + row_count_ + ');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a></cfif>';
	
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="quantity' + row_count_ +'" <cfif attributes.modelhouse_plan eq 0 and attributes.request_plan eq 0>disabled</cfif> value="1" class="moneybox" onkeyup="return(FormatCurrency(this,event));" onBlur="fiyat_hesapla(' + row_count_ + ');" style="width:50px;">';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="hidden" name="unit_id' + row_count_ +'" id="unit_id' + row_count_ +'"><input type="text" <cfif attributes.product_plan eq 0>disabled</cfif> name="unit_name' + row_count_ +'" id="unit_name' + row_count_ +'" value="" readonly <cfif attributes.product_plan eq 0>disabled</cfif> style="width:40px;">';
	
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="price' + row_count_ +'" <cfif attributes.price_plan eq 0>disabled</cfif> value="0" class="moneybox" onkeyup="return(FormatCurrency(this,event,<cfoutput>#textile_round#</cfoutput>));" onBlur="fiyat_hesapla(' + row_count_ + ');" style="width:50px;">';

	<!---newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
		newCell.setAttribute('style','nowrap');
	newCell.innerHTML = '<input type="text" name="en'+row_count_ +'" value="" class="moneybox" onkeyup="return(FormatCurrency(this,event));" >';
    newCell.style.display='none';--->
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="hidden" name="en'+row_count_ +'" value="" class="moneybox"><input type="text" name="revize_quantity'+ row_count_ +'" <cfif attributes.modelhouse_plan eq 0 >disabled</cfif>  value="" class="moneybox" onkeyup="return(FormatCurrency(this,event,<cfoutput>#textile_round#</cfoutput>));" onBlur="fiyat_hesapla(' + row_count_ + ');" style="width:50px;">';
	
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="revize_price' + row_count_ +'" value="0" class="moneybox" <cfif attributes.price_plan eq 0>disabled</cfif> onkeyup="return(FormatCurrency(this,event,<cfoutput>#textile_round#</cfoutput>));" onBlur="fiyat_hesapla(' + row_count_ + ');" style="width:50px;"><input type="hidden" name="revize_total_price' + row_count_ +'" id="revize_total_price' + row_count_ +'">';

	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<select name="money' + row_count_ +'" id="money' + row_count_ +'" style="width:60px;" <cfif attributes.price_plan eq 0>disabled</cfif>><cfoutput query="get_money"><option value="#get_money.money#" >#get_money.money#</option></cfoutput></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="row_detail' + row_count_ +'" id="row_detail' + row_count_ +'" style="width:150px;">';
		
		
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="file"  name="image_'+row_count_+'" id="image_'+row_count_+'">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '';
	
	}
<cfoutput>
/*function pencere_ac_product(no)
{
	windowopen('#request.self#?fuseaction=objects.popup_product_price_unit&field_stock_id=add_opp_supplier_a.stock_id'+ no +'&field_id=add_opp_supplier_a.product_id'+ no +'&field_name=add_opp_supplier_a.product'+ no,'list');
}*/


function pencere_ac_product_(no)
	{
	
			sbr = '';
	//&field_price=add_opp_supplier_a.price'+ no+'&field_total_price=add_opp_supplier_a.total_price'+ no+'&field_amount=add_opp_supplier_a.quantity'+ no +'
		windowopen('#request.self#?fuseaction=objects.popup_product_price_unit'+ sbr+'&company_id=&field_stock_id=add_opp_supplier_a.stock_id'+ no +'&field_id=add_opp_supplier_a.product_id'+ no +'&field_name=add_opp_supplier_a.product'+ no +'&field_unit_id=add_opp_supplier_a.unit_id'+ no+'&field_unit=add_opp_supplier_a.unit_name'+ no+'&field_money=add_opp_supplier_a.money'+ no+'&field_product_catid=add_opp_supplier_a.category_supp_a'+ no,'list');
	}
function pencereSupplier_(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2&field_comp_name=add_opp_supplier_a.company_name' + no +'&field_comp_id=add_opp_supplier_a.company_id' + no + '','list');
}
/* function pencere_ac_category_(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_id=add_opp_supplier_a.category_supp_a' + no + '&field_name=add_opp_supplier_a.category_name' + no + '&is_sub_category=1','list');
} */
function supplier_kontrol_(tip)
{

	document.add_opp_supplier_a.other_process.value=tip;

	static_row=0;
	for(r=1;r<=row_count_;r++)		
	{
		if(eval("document.add_opp_supplier_a.row_kontrol"+r).value == 1)
		{	
			static_row++;
			deger_member_id = eval("document.add_opp_supplier_a.company_id"+r);
			deger_demand_stock_id = eval("document.add_opp_supplier_a.demand_stock"+r);
				deger_op_id = eval("document.add_opp_supplier_a.operation"+r);
				deger_pcat_id = eval("document.add_opp_supplier_a.category_supp_a"+r);
				
				deger_product_id = eval("document.add_opp_supplier_a.product_id"+r);
				deger_product = eval("document.add_opp_supplier_a.product"+r);
				deger_unit_id = eval("document.add_opp_supplier_a.unit_id"+r);
				deger_unit_name = eval("document.add_opp_supplier_a.unit_name"+r);
				deger_price = eval("document.add_opp_supplier_a.price"+r);
				deger_money = eval("document.add_opp_supplier_a.money"+r);
				deger_quantity = eval("document.add_opp_supplier_a.quantity"+r);
			<cfif attributes.request_plan eq 1>
				if(deger_demand_stock_id.value=="")
				{
					alert(static_row+".Satır Talep edilen hammaddeler girişi yapılmalı !");
					return false;
				}
				if(deger_op_id.value =="")
				{
					alert(static_row+".Satır Operasyon seçmelisiniz !");
					return false;
				}
				if(deger_pcat_id.value=="")
				{
					alert(static_row+".Satır Hammadde kategori seçmelisiniz !");
					return false;
				}
			<cfelseif attributes.price_plan eq 1>
					if(deger_product_id.value=="" || deger_product.value=="" )
						{
							alert(static_row+".Satır Ürün girişi yapmalısınız !");
							return false;
						}	
						if(deger_unit_id.value=="" || deger_unit_name.value=="" )
						{
							alert(static_row+".Satır Birim girişi yapmalısınız !");
							return false;
						}
						if(deger_price.value=="")
						{
							alert(static_row+".Satır Fiyat girişi yapmalısınız !");
							return false;
						}
						if(deger_money.value=="")
						{
							alert(static_row+".Satır Para birimi girişi yapmalısınız !");
							return false;
						}
						if(deger_op_id.value =="")
						{
							alert(static_row+".Satır Operasyon seçmelisiniz !");
							return false;
						}
			<cfelseif attributes.modelhouse_plan eq 1>
						if(deger_quantity.value =="")
						{
							alert(static_row+".Satır Miktar girişi yapmalısınız !");
							return false;
						}
			</cfif>
		}
	}
	
	for(r=1;r<=row_count_;r++)
	{
		if(eval("document.add_opp_supplier_a.row_kontrol"+r).value == 1)
		{
		
	/*	eval("document.add_opp_supplier_a.quantity"+r).value=filterNum(eval("document.add_opp_supplier_a.quantity"+r).value);
			
		eval("document.add_opp_supplier_a.price"+r).value=filterNum(eval("document.add_opp_supplier_a.price"+r).value);*/
			/*
			eval("document.add_opp_supplier_a.ESTIMATED_INCOME"+r).value = filterNum(eval("document.add_opp_supplier_a.ESTIMATED_INCOME"+r).value);
			eval("document.add_opp_supplier_a.ESTIMATED_COST"+r).value = filterNum(eval("document.add_opp_supplier_a.ESTIMATED_COST"+r).value);
			eval("document.add_opp_supplier_a.ESTIMATED_PROFIT"+r).value = filterNum(eval("document.add_opp_supplier_a.ESTIMATED_PROFIT"+r).value);
			*/
		}
	}
	
	/*var durum=AjaxFormSubmit(add_opp_supplier_a,'show_user_message1_a',0,'&nbsp;Kaydediliyor','&nbsp;Kaydedildi','#request.self#?fuseaction=textile.emptypopup_ajax_req_supplier_a&req_id=#attributes.req_id#&req_type=#attributes.req_type#','div_list_supplier_a',true);
	if(durum)
	box_refresh('list_supplier_a');*/

		if(tip!=0)//buton tıklamasıdır
	document.add_opp_supplier_a.submit();

	return true;
	
}

function fiyat_hesapla_(satir)
{
	/*
	if(eval("add_opp_supplier_a.ESTIMATED_INCOME"+satir).value.length != 0 && eval("add_opp_supplier_a.ESTIMATED_COST"+satir).value.length != 0)
	{
		eval("add_opp_supplier_a.ESTIMATED_PROFIT" + satir).value =  filterNum(eval("document.add_opp_supplier_a.ESTIMATED_INCOME"+satir).value) - filterNum(eval("document.add_opp_supplier_a.ESTIMATED_COST"+satir).value);
		eval("add_opp_supplier_a.ESTIMATED_PROFIT" + satir).value = commaSplit(eval("add_opp_supplier_a.ESTIMATED_PROFIT" + satir).value);
	}*/
	//eval("add_opp_supplier_a.quantityT" + satir).value
	return true;
}
$(document).ready(function(){
	$('.lock input').prop('readonly','true');
	$('.lock select').prop('disabled','true');
	$(".supplier-product-cat").select2();
});

function getOperation_suplier_a(productcat_id, supplier_el_id){
	$.ajax({
		url : "AddOns/n1-soft/textile/cfc/get_req_supplier_rival.cfc?method=get_supplier_by_productcat",
		type : "POST",
		dataType : "json",
		data : {productcat_id : productcat_id},
		success : function(response) {
			if(response.STATUS){
				eval("document.add_opp_supplier_a."+supplier_el_id+"").value = response.SUPLIERS_ID;
			}
		}
	});
}
</script>
</cfoutput>