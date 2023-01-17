<!------NUMUNE SAYFASI KUMAS DETAYLARI----------------->

<cfparam name="attributes.product_plan" default="0">
<cfparam name="attributes.modelhouse_plan" default="0">
<cfparam name="attributes.price_plan" default="0">
<cfparam name="attributes.request_plan" default="0">
<cfparam name="attributes.plan_id" default="">
<cfparam name="attributes.employee_id" default="">
<cfparam name="attributes.employee" default="">
<cfparam name="attributes.category" default="">
<cfparam name="attributes.workrequest" default="0">
<!---<cfinclude template="../../../../../V16/objects/query/get_product_cat2.cfm">--->
<cfset textile_round=4>
<cfsetting showdebugoutput="no">
<cf_xml_page_edit fuseact="textile.list_sample_request">
<cfscript>
	CreateCompenent = CreateObject("component","WBP.Fashion.files.cfc.get_req_supplier_rival");
	getAuthority=CreateCompenent.getProcessAuthority(process_stage:full_stage_id);
	plan_id=attributes.plan_id;
	if(attributes.modelhouse_plan eq 1)//plana gore bakmasına gerek yok diye dusunuyoruz
	plan_id='';
	
	if(attributes.request_plan eq 1 or getAuthority gt 0)
	{
		getSupplier = CreateCompenent.getOppSupplier(req_id:attributes.req_id,req_type:attributes.req_type,plan_id:plan_id);
	}
	else {

			getSupplier = CreateCompenent.getOppSupplier(req_id:attributes.req_id,req_type=attributes.req_type,access=1,plan_id:plan_id);
	}
	if(isDefined("attributes.is_copy") and len(attributes.is_copy))
	{
		getSupplier_copy = CreateCompenent.getOppSupplier(req_id:attributes.is_copy,req_type=attributes.req_type);
	}
	get_money = CreateCompenent.getMoney();
	get_operation=CreateCompenent.getOperation();
	getProductCat=CreateCompenent.getProductCat(product_catid:fabric_pcatid);
</cfscript>

<cfquery name="GET_PRODUCT_CAT" datasource="#DSN1#">
	SELECT
		PC.HIERARCHY,
		CASE
            WHEN LEN(SLI.ITEM) > 0 THEN SLI.ITEM
            ELSE PRODUCT_CAT
        END AS PRODUCT_CAT,
		PC.IS_SUB_PRODUCT_CAT,
		PC.PRODUCT_CATID,
		PC.PROFIT_MARGIN,
		PC.PROFIT_MARGIN_MAX,
		PC.POSITION_CODE,
		PC.POSITION_CODE2
	FROM
		PRODUCT_CAT PC
        <cfif len(attributes.employee) and len(employee_id)>
        LEFT JOIN PRODUCT_CAT_POSITIONS PCP ON PCP.product_cat_ID = PC.PRODUCT_CATID
		LEFT JOIN #dsn_alias#.EMPLOYEE_POSITIONS E ON E.POSITION_CODE = PCP.POSITION_CODE
      --  LEFT JOIN #dsn_alias#.EMPLOYEE_POSITIONS E ON E.EMPLOYEE_ID = PC.RECORD_EMP
        </cfif>
        	LEFT JOIN #dsn_alias#.SETUP_LANGUAGE_INFO SLI ON SLI.UNIQUE_COLUMN_ID = PC.PRODUCT_CATID
            AND SLI.COLUMN_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_CAT">
            AND SLI.TABLE_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="PRODUCT_CAT">
            AND SLI.LANGUAGE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.language#">,
		PRODUCT_CAT_OUR_COMPANY PCO
	WHERE 
		PC.PRODUCT_CATID IS NOT NULL AND
		PCO.PRODUCT_CATID = PC.PRODUCT_CATID AND
		PCO.OUR_COMPANY_ID = #session.ep.company_id#
	<cfif isDefined('attributes.category') and len(attributes.category)>
		AND PC.HIERARCHY LIKE '#attributes.category#%'
	</cfif>
	<cfif isDefined('attributes.keyword') and len(attributes.keyword)>
		AND (PC.PRODUCT_CAT LIKE '<cfif len(attributes.keyword) neq 1>%</cfif>#attributes.keyword#%' OR PC.HIERARCHY LIKE '#attributes.keyword#%')
	</cfif>
	<cfif len(attributes.employee) and len(employee_id)>
     AND (E.POSITION_ID = #employee_id#)
	</cfif>
	/* AND HIERARCHY IN ('150.01.008' , '150.01') *//* Model detay sayfasında kategori içeriği gelmesi amacıyla yoruma alınmıştır. */
	ORDER BY
		PC.HIERARCHY
</cfquery>

<cfform name="add_opp_supplier" method="post" action="#request.self#?fuseaction=textile.emptypopup_add_req_supplier_act" enctype="multipart/form-data">
	<cf_grid_list>
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
		
			<input type="hidden" name="record_num" id="record_num" value="#getSupplier.RECORDCOUNT#">
		<cfif isDefined("attributes.plan_id") and len(attributes.plan_id)>
			<input type="hidden" name="plan_id" id="plan_id" value="#attributes.plan_id#">
		</cfif>
		<input type="hidden" name="workrequest" id="workrequest" value="">
	  </cfoutput>
        <thead>
            <tr>
                <tr>
                 <th width="30" style="text-align:center;" >
					<cfif attributes.request_plan eq 1><input type="button" class="eklebuton" onClick="add_row();"></cfif>
				</th>
				<th><i class="fa fa-copy"></i></th>
				<cfif attributes.request_plan eq 1><th><cf_get_lang dictionary_id='58445.İş'></th></cfif>
				 <th><cf_get_lang dictionary_id='57756.Durum'></th>
				 <th><cf_get_lang dictionary_id='62708.Asıl/Revize'></th>
				 <th width="200" style="min-width: 200px;"><cf_get_lang dictionary_id='57486.Kategori'>*</th>
				 <th width="50"><cf_get_lang dictionary_id='29419.Operasyon'>*</th>
                 <th width="170"><cf_get_lang dictionary_id='29533.Tedarikçi'></th>
				 <th width="200"><cf_get_lang dictionary_id='36445.Hammadde'>*</th>
                 <th width="100"><cf_get_lang dictionary_id='57657.Ürün'></th>
				 <th width="50"><cf_get_lang dictionary_id='62707.Metraj'></th>
				 <th width="50"><cf_get_lang dictionary_id='57636.Birim'></th>
				 <th width="50"><cf_get_lang dictionary_id='58084.Fiyat'></th>
				 <th width="50"><cf_get_lang dictionary_id='48152.En'></th>
				 <th width="50"><cf_get_lang dictionary_id='40935.Revize'><cf_get_lang dictionary_id='62707.Metraj'></th>
				 <th width="50"><cf_get_lang dictionary_id='40935.Revize'><cf_get_lang dictionary_id='58084.Fiyat'></th>
				 <th width="50"><cf_get_lang dictionary_id='57489.Para Birimi'></th>
				 <th width="50"><cf_get_lang dictionary_id='36199.Açıklama'></th>
				 <th width="15"><cf_get_lang dictionary_id='58080.Resim'></th>
				 <!--- <th width="15">İç Talep No</th> --->
					<!---<cfif attributes.modelhouse_plan eq 1>
						<th width="50"></th>	
					</cfif>--->
            </tr>
            </tr>
        </thead>
        <tbody id="table1">
		<cfoutput query="getSupplier">
			<cfif len(brand_id)>
				<cfquery name="get_brand" datasource="#dsn1#">
					SELECT BRAND_NAME FROM PRODUCT_BRANDS WHERE BRAND_ID = #brand_id#
				</cfquery>
			</cfif>
			<tr name="frm_row#currentrow#" id="frm_row#currentrow#" style="" class="<cfif getSupplier.is_status eq 0>lock</cfif>">
				<td width="20" nowrap="nowrap">
					<cfif not isdefined("attributes.is_copy")><!---numune kopyalamadan geliyor ise satır idler yeniden oluşsun--->
							<input type="hidden" name="rowid#currentrow#" value="#getSupplier.id#">
							<input type="hidden" name="wrk_row_id#currentrow#" value="#getSupplier.wrk_row_id#">
					</cfif>
					
					<input type="hidden" name="work_id#currentrow#" value="#getSupplier.work_id#">
						<input type="hidden" name="row_kontrol#currentrow#" id="row_kontrol#currentrow#" value="1">
					<cfif attributes.request_plan eq 1><!---sadece numune tarafında silme kopyalama islemleri yapılabilir--->
						<cfif not len(getSupplier.plan_id)><a style="cursor:pointer" onclick="sil_supplier(#currentrow#);"><i class="fa fa-minus" title="#getLang('','sil','57463')#"></i></a></cfif>	
							
						
					</cfif>
				</td>
				<td width="20" nowrap="nowrap">	
					<cfif getSupplier.is_status neq 0>
						<a  style="cursor:pointer" id="copy_link#currentrow#" onclick="copy_supplier(#currentrow#);"><i class="fa fa-copy"></i></a>
					</cfif>
				</td>
				<cfif attributes.request_plan eq 1><td><cfif len(plan_id)><a href="javacript://" class="tableyazi" onclick="window.open('#request.self#?fuseaction=textile.fabric_price&event=upd&plan_id=#plan_id#','page')">#plan_id#</a></cfif></td></cfif>
				<td>
					<select name="status#currentrow#" id="status#currentrow#">
						<option value="1" <cfif getSupplier.is_status neq 0>selected</cfif>><cf_get_lang dictionary_id='57493.Active'></option>
						<option value="0" <cfif getSupplier.is_status eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</td>
				<td>
					<select name="revize#currentrow#"  id="revize#currentrow#">
						<option value="0" <cfif getSupplier.is_revision neq 1>selected</cfif>><cf_get_lang dictionary_id='31403.Asıl'></option>
						<option value="1" <cfif getSupplier.is_revision eq 1>selected</cfif>><cf_get_lang dictionary_id='40935.Revize'></option>
					</select>
				</td>
				<td nowrap="nowrap" style="width:200px;">
					<div style="position: relative; width: 100%; height: 100%;">
					<select name="category#currentrow#" class="supplier-product-cat" id="category_supp#currentrow#"  onchange = "getOperation(this.value, 'operation#currentrow#')">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfif GET_PRODUCT_CAT.recordCount>
							<cfloop query="GET_PRODUCT_CAT">
								<option value="#GET_PRODUCT_CAT.product_catid#" <cfif getSupplier.product_catid eq GET_PRODUCT_CAT.product_catid>selected</cfif>>#GET_PRODUCT_CAT.product_cat#</option>
							</cfloop>
						</cfif>
					</select>
					<!--- <cfif find("textile.list_sample_request", cgi.HTTP_REFERER) gt 0>
					<div style="display: block; position: absolute; width: 100%; height: 100%; top:0; left: 0">&nbsp;</div>
					</cfif> --->
					</div>
				</td>
				<td nowrap="nowrap" >
					<div style="position: relative; width: 100%; height: 100%;">
					<select style="width:120px;"  name="operation#currentrow#" id="operation#currentrow#">
						<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
						<cfloop query="get_operation"><option value="#operation_type_id#" <cfif get_operation.OPERATION_TYPE_ID eq getSupplier.operation_id>selected</cfif>>#OPERATION_TYPE#</option></cfloop>
					</select>
				<!--- 	<cfif find("textile.list_sample_request", cgi.HTTP_REFERER) gt 0>
					<div style="display: block; position: absolute; width: 100%; height: 100%; top:0; left: 0">&nbsp;</div>
					</cfif> --->
					</div>
				</td>
				<td nowrap="nowrap"><input type="hidden"  name="company_id#currentrow#" id="company_id#currentrow#" value="#company_id#">
					<div style="position: relative; width: 100%; height: 100%;">
					<input type="text" name="company_name#currentrow#" id="company_name#currentrow#" value="#get_par_info(company_id,1,1,0)#" style="width:150px;" >
					<a href="javascript://" onClick="pencereSupplier('#currentrow#');"><span><i class="icon-ellipsis"></i></span></a>
					<!--- <cfif find("textile.list_sample_request", cgi.HTTP_REFERER) gt 0>
					<div style="display: block; position: absolute; width: 100%; height: 100%; top:0; left: 0">&nbsp;</div>
					</cfif> --->
					</div>
				</td>
				<td nowrap="nowrap">
					<input type="text" name="demand_stock#currentrow#" id="demand_stock#currentrow#"  value="#REQUEST_COMPANY_STOCK#"  style="width:200px;">	
				</td>
				<td nowrap="nowrap">
					<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" value="#stock_id#">
					<input type="hidden" name="product_id#currentrow#" id="product_id#currentrow#" value="#product_id#">
					<input type="text" name="product#currentrow#" id="product#currentrow#" value="#product_name#" style="width:200px;" >
					<!--- <cfif attributes.price_plan eq 1> --->
						<a href="javascript://" onclick="pencere_ac_product('#currentrow#');"><span><i class="icon-ellipsis"></i></span></a>
					<!--- </cfif> --->
				</td>
				<td nowrap="nowrap">
					<input type="text" name="quantity#currentrow#" value="#tlformat(getSupplier.quantity,textile_round)#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#textile_round#));" onBlur="fiyat_hesapla('#currentrow#');" style="width:50px;">
				</td>
				<td nowrap="nowrap">
						<input type="hidden" name="unit_id#currentrow#" id="unit_id#currentrow#" value="#unit_id#">
						<input type="text" name="unit_name#currentrow#" id="unit_name#currentrow#" value="#unit#"  style="width:40px;">
				</td>
				<td nowrap="nowrap">
					<input type="text" name="price#currentrow#" value="#tlformat(getSupplier.price,textile_round)#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#textile_round#));" onBlur="fiyat_hesapla('#currentrow#');" style="width:50px;">
					<input type="hidden" name="total_price#currentrow#" id="total_price#currentrow#">
				</td>
				<td nowrap="nowrap">
					<input type="text" name="en#currentrow#" value="#tlformat(getSupplier.en,textile_round)#" class="moneybox"  onkeyup="return(FormatCurrency(this,event,#textile_round#));" onBlur="fiyat_hesapla('#currentrow#');" style="width:50px;">
				</td>
				<td nowrap="nowrap">
					<input type="text" name="revize_quantity#currentrow#"  value="#tlformat(getSupplier.revize_quantity,textile_round)#" class="moneybox" onkeyup="return(FormatCurrency(this,event,#textile_round#));" onBlur="fiyat_hesapla('#currentrow#');" style="width:50px;">
				</td>
				<td nowrap="nowrap">
					<input type="text"  class="moneybox"  name="revize_price#currentrow#" value="#tlformat(getSupplier.revize_price,textile_round)#"   onkeyup="return(FormatCurrency(this,event,#textile_round#));" onBlur="fiyat_hesapla('#currentrow#');" style="width:50px;">
					<input type="hidden" name="revize_total_price#currentrow#" id="revize_total_price#currentrow#">
				</td>
				<td>
					<select name="money#currentrow#" id="money#currentrow#"  <!--- <cfif attributes.price_plan eq 0>disabled</cfif> --->  style="width:60px;">
					<cfloop query="get_money">
						<option value="#get_money.money#" <cfif get_money.money is getSupplier.money_type>selected</cfif>>#get_money.money#</option>
					</cfloop>
					</select>
					<cfif attributes.price_plan eq 0>
						<input type="hidden" name="money#currentrow#" value="#getSupplier.money_type#">
					</cfif>
				</td>
				<td><input type="text" name="row_detail#currentrow#" value="#getSupplier.row_detail#" style="width:150px;"></td>
				<td nowrap="nowrap">
					<cfif len(IMAGE_PATH)>
						
						<input type="hidden"  name="image_var#currentrow#" id="image_var#currentrow#" value="#IMAGE_PATH#">
						<input type="file" style="width:180px;" name="image_#currentrow#" id="image_#currentrow#" value="">
						<a href="documents/textile/kumas/#IMAGE_PATH#">#IMAGE_PATH#</a>
					<cfelse>
						<input type="file" style="width:180px;" name="image_#currentrow#" id="image_#currentrow#" value="">
					</cfif>
				</td>
				<!--- <td>
					<input type="hidden"  name="i_id#currentrow#" id="i_id#currentrow#" value="#i_id#">
					<cfif len(i_id)>
					<a href="#request.self#?fuseaction=purchase.list_internaldemand&event=upd&id=#i_id#">#INTERNAL_NUMBER#<i class="fa fa-external-link fa-lg"></i></a>
					</cfif>
				</td> --->
				<!---<cfif attributes.modelhouse_plan eq 1>
					<td >
						<button type="button" onclick="gondertalep('#currentrow#');" name="btndemand" class="btn btn-yellow">İç talep oluştur</button>
					</td>
				</cfif>--->
			</tr>	
		</cfoutput>
        </tbody>
		
	</cf_grid_list>
	<cf_box_footer >               
		<div class="col col-12 ui-form-list-btn" >
					<cfif getSupplier.recordcount gt 0>
						<cfif attributes.request_plan eq 1>
							<cfif isDefined("attributes.req_stage") and attributes.req_stage neq request_accept_stage_id>
							<div class="form-group">	
								<a href="javascript://" class="ui-wrk-btn ui-wrk-btn-red ui-wrk-btn-addon-left" onclick="kontrol(workrequest);"><i class="fa fa-plus"></i><cf_get_lang dictionary_id='30828.Talep'>-<cf_get_lang dictionary_id='58868.İş Emri'></a>
							</div>
							<div class="form-group">
								<cf_workcube_buttons is_upd='1' is_delete="0" add_function='supplier_kontrol(0)' type_format="1">
							</div>
							</cfif>
						<cfelse>
							<div class="form-group">	
								<a href="javascript://" class="ui-wrk-btn ui-wrk-btn-red ui-wrk-btn-addon-left" onclick="kontrol(workrequest);"><i class="fa fa-plus"></i><cf_get_lang dictionary_id='30828.Talep'>-<cf_get_lang dictionary_id='58868.İş Emri'></a>
							</div>
							<div class="form-group">
								<cf_workcube_buttons is_upd='1' is_delete="0" add_function='supplier_kontrol(0)' type_format="1">
							</div>
						</cfif>
					<cfelse>
						  <cf_workcube_buttons is_upd='0' add_function='supplier_kontrol(0)' type_format="1">
					</cfif>
				</div>
				<div style="float:right;">
				<cfif attributes.price_plan eq 1>
					<button type="button" onclick="gondertalep('add_opp_supplier');" name="btndemand" class="btn btn-yellow"><cf_get_lang dictionary_id='32698.İç Talep Oluştur'></button>
				</cfif>
				</div>
				<div style="float:right;display:none;">
						<cfif getSupplier.recordcount gt 0 and attributes.modelhouse_plan eq 1>
							<button type="button" name="btnsend" class="btn btn-primary" value="" onclick="supplier_kontrol(1);"><cf_get_lang dictionary_id='62872.Diğer Birimlere Gönder'></button>
						<cfelseif getSupplier.recordcount gt 0 and attributes.request_plan eq 1>
							<button type="button" name="btnsend" class="btn btn-primary" value="" onclick="supplier_kontrol(-1);"><cf_get_lang dictionary_id='62873.Ürün Yönetimine Gönder'></button>	
						</cfif>
				</div>
						<!---<cfif attributes.request_plan eq 1>
							<div class="navi" style="float:right;">
										<a href="##" class="previous round" onClick="gizle_goster_('list_supplier_k','sample_request');">&laquo; Geri</a>
										<a href="##" class="next round btn-primary" onClick="gizle_goster_('list_supplier_k','list_supplier_a');">İleri&raquo;</a>
							</div>
						</cfif>--->
				<div style="float:left;" id="show_user_message1"></div>
			
	</cf_box_footer>
</cfform>
<script type="text/javascript">
row_count=<cfoutput>#getSupplier.RECORDCOUNT#</cfoutput>;

<cfif attributes.request_plan eq 1>
	if(row_count==0)
	{
	<cfoutput query="getProductCat">
		add_row('#HIERARCHY# #PRODUCT_CAT#','#PRODUCT_CATID#');
	</cfoutput>
		
	}
</cfif>
function kontrol(){
	document.getElementById("workrequest").value =1;
	document.getElementById("add_opp_supplier").submit();
}

function sil_supplier(sy)
{
	if(confirm('Satır silinecek eminmisiniz?'))
	{
		var my_element=eval("add_opp_supplier.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";
	}
	
}
function copy_supplier(sy)
{

	if(eval('document.add_opp_supplier.status'+sy).value==0)
	{
		return;
	}

	eval('document.add_opp_supplier.status'+sy).value=0;
	eval('document.add_opp_supplier.revize'+sy).value=0;
	var category=eval('document.add_opp_supplier.category_supp'+sy).value;
	var operation=eval('document.add_opp_supplier.operation'+sy).value;
	var company_name='';eval('document.add_opp_supplier.company_name'+sy).value;
	var company_id='';//eval('document.add_opp_supplier.company_id'+sy).value;
	var demand_stock=eval('document.add_opp_supplier.demand_stock'+sy).value;
	var stock_id='';//eval('document.add_opp_supplier.stock_id'+sy).value;
	var product_id='';eval('document.add_opp_supplier.product_id'+sy).value;
	var product='';eval('document.add_opp_supplier.product'+sy).value;
	var quantity='';//eval('document.add_opp_supplier.quantity'+sy).value;
	var unit_id=eval('document.add_opp_supplier.unit_id'+sy).value;
	var unit_name=eval('document.add_opp_supplier.unit_name'+sy).value;
	var price='';//=eval('document.add_opp_supplier.price'+sy).value;
	var en='';//eval('document.add_opp_supplier.en'+sy).value;
	var revize_quantity='';//eval('document.add_opp_supplier.revize_quantity'+sy).value;
	var revize_price='';//eval('document.add_opp_supplier.revize_price'+sy).value;
	var money=eval('document.add_opp_supplier.money'+sy).value;
	var row_detail=''//;eval('document.add_opp_supplier.row_detail'+sy).value;
	var image_='';//eval('document.add_opp_supplier.image_'+sy).value;
	
	row_count++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);	
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);				
	document.add_opp_supplier.record_num.value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="hidden" name="wrk_row_id'+row_count+'" value=""><input type="hidden" name="work_id'+row_count+'" value=""><input type="hidden" name="row_kontrol'+row_count+'" value="1"><a style="cursor:pointer" onclick="sil_supplier(' + row_count + ');"><i class="fa fa-minus" ></i></a>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<a style="cursor:pointer" onclick="sil_supplier(' + row_count_ + ');"></a><a style="cursor:pointer" onclick="copy_supplier('+ row_count_ +');"><i class="fa fa-copy"></i></a>';
	<cfif attributes.request_plan eq 1>
		newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
		newCell.innerHTML ='';
	</cfif>

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML ='<select name="status'+row_count+'" id="status'+row_count+'"><option value="1"><cf_get_lang dictionary_id='57493.Aktif'></option><option value="0"><cf_get_lang dictionary_id='57494.Pasif'></option></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML ='<select name="revize'+row_count+'" id="revize'+row_count+'"><option value="0"><cf_get_lang dictionary_id='56015.Asıl'></option><option value="1"><cf_get_lang dictionary_id='40935.Revize'></option></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML ='<select name="category'+row_count+'" class="supplier-product-cat" id="category_supp'+row_count+'"  onchange = "getOperation(this.value, \'operation'+row_count+'\')"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfif GET_PRODUCT_CAT.recordCount><cfloop query="GET_PRODUCT_CAT"><option value="<cfoutput>#product_catid#</cfoutput>"><cfoutput>#product_cat#</cfoutput></option></cfloop></cfif></select>';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<select style="width:120px;" name="operation'+row_count+'" id="operation'+row_count+'"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_operation"><option value="#OPERATION_TYPE_ID#" <cfif isdefined("attributes.default_station") and attributes.default_station eq getSupplier.operation_id>selected</cfif>>#OPERATION_TYPE#</option></cfoutput></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="company_name'+row_count+'"  value="'+company_name+'" style="width:150px;" ><input type="hidden" name="company_id'+row_count+'" value="'+company_id+'"> 	<cfif attributes.request_plan eq 1><a href="javascript://" onClick="pencereSupplier('+row_count+');"><span><i class="icon-ellipsis"></i></span></a></cfif>';
	
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="demand_stock'+row_count+'" value="'+demand_stock+'" style="width:200px;">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="hidden" name="stock_id' + row_count +'" value="'+stock_id+'"><input type="hidden" name="product_id' + row_count +'" value="'+product_id+'"><input type="text" name="product' + row_count +'" value="'+product+'" style="width:200px;" >&nbsp; <a onclick="javascript:pencere_ac_product(' + row_count + ');"><span><i class="icon-ellipsis"></i></span></a>';
	
	newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="quantity' + row_count +'"  value="'+quantity+'" class="moneybox" onkeyup="return(FormatCurrency(this,event));" onBlur="fiyat_hesapla(' + row_count + ');" style="width:50px;">';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
			newCell.innerHTML = '<input type="hidden" name="unit_id' + row_count +'" id="unit_id' + row_count +'" value="'+unit_id+'"><input type="text"  name="unit_name' + row_count +'" id="unit_name' + row_count +'" value="'+unit_name+'"  style="width:40px;">';
	
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="price' + row_count +'"  value="'+price+'" class="moneybox" onkeyup="return(FormatCurrency(this,event,<cfoutput>#textile_round#</cfoutput>));" onBlur="fiyat_hesapla(' + row_count + ');" style="width:50px;"><input type="hidden" name="total_price'+row_count +'" id="total_price'+ row_count +'">';

	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="en'+row_count +'" value="'+en+'" class="moneybox" onkeyup="return(FormatCurrency(this,event,<cfoutput>#textile_round#</cfoutput>));" style="width:50px;">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="revize_quantity'+ row_count +'"   value="'+revize_quantity+'" class="moneybox" onkeyup="return(FormatCurrency(this,event,<cfoutput>#textile_round#</cfoutput>));" onBlur="fiyat_hesapla(' + row_count + ');" style="width:50px;">';
		
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="revize_price' + row_count +'" value="'+revize_price+'" class="moneybox"  onkeyup="return(FormatCurrency(this,event));" onBlur="fiyat_hesapla(' + row_count + ');" style="width:50px;"><input type="hidden" name="revize_total_price' + row_count +'" id="revize_total_price' + row_count +'">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<select name="money' + row_count +'" id="money' + row_count +'" style="width:60px;"><cfoutput query="get_money"><option value="#get_money.money#" >#get_money.money#</option></cfoutput></select>';
		
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="row_detail' + row_count +'" id="row_detail' + row_count+'"  value="'+row_detail+'" style="width:150px;">';
			
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="file"  name="image_'+row_count+'" id="image_'+row_count+'">';

	
	
	eval('document.add_opp_supplier.category_supp'+row_count).value=category;
	eval('document.add_opp_supplier.operation'+row_count).value=operation;
	eval('document.add_opp_supplier.money'+row_count).value=money;
	eval('document.add_opp_supplier.revize'+row_count).value=1;

	$(".supplier-product-cat").select2();
	
colorchange(sy,row_count);
	
	
}
colorchange();
function colorchange(sy,newrow)
{
  if(sy!=undefined)
  {
	$('#table1 #'+'frm_row'+sy+' td').css("background-color", "#CD6155");
	$('#table1 #'+'frm_row'+sy+' td').css("color", "#000");
	
	if($('#table1 #revize'+newrow).val()=='1')
		{
			$('#table1 #'+'frm_row'+newrow+' td').css("background-color", "yellow");
			$('#table1 #'+'frm_row'+newrow+' td').css("color", "#000");
		}
  }
  else
  {
	for(var i=1;i<=row_count;i++)
	{	if($('#table1 #status'+i).val()=='0')
		{
			$('#table1 #'+'frm_row'+i+' td').css("background-color", "#CD6155");
			$('#table1 #'+'frm_row'+i+' td').css("color", "#000");
		}
		if($('#table1 #revize'+i).val()=='1')
		{
			$('#table1 #'+'frm_row'+i+' td').css("background-color", "#ABEBC6");
			$('#table1 #'+'frm_row'+i+' td').css("color", "#000");
		}
	}
  
  }
	
}
function add_row(pcat,pcatid)
{


	if(pcat==undefined)
	{
		pcat="";
		pcatid="";
	}


	row_count++;
	var newRow;
	var newCell;
	newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
	newRow.setAttribute("name","frm_row" + row_count);
	newRow.setAttribute("id","frm_row" + row_count);	
	newRow.setAttribute("NAME","frm_row" + row_count);
	newRow.setAttribute("ID","frm_row" + row_count);	
	document.add_opp_supplier.record_num.value=row_count;
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.innerHTML = '<input type="hidden" name="wrk_row_id'+row_count+'" value=""><input type="hidden" name="work_id'+row_count+'" value=""><input type="hidden" name="row_kontrol'+row_count+'" value="1"><a style="cursor:pointer" onclick="sil_supplier(' + row_count + ');"><i class="fa fa-minus"></i></a>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<a style="cursor:pointer" onclick="copy_supplier('+ row_count +');"><i class="fa fa-copy"></i></a>';

<cfif attributes.request_plan eq 1>
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML ='';
</cfif>

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML ='<select name="status'+row_count+'" id="status'+row_count+'"><option value="1">Aktif</option><option value="0">Pasif</option></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML ='<select name="revize'+row_count+'" id="revize'+row_count+'"><option value="0"><cf_get_lang dictionary_id='56015.Asıl'></option><option value="1"><cf_get_lang dictionary_id='40935.Revize'></option></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML ='<select name="category'+row_count+'" class="supplier-product-cat" id="category_supp'+row_count+'"  onchange = "getOperation(this.value, \'operation'+row_count+'\')"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfif GET_PRODUCT_CAT.recordCount><cfloop query="GET_PRODUCT_CAT"><option value="<cfoutput>#product_catid#</cfoutput>" '+(pcatid==<cfoutput>#product_catid#</cfoutput>?'selected="selected"':'')+'><cfoutput>#product_cat#</cfoutput></option></cfloop></cfif></select>';
	$(".supplier-product-cat").select2();
	getOperation(document.getElementById("category_supp"+row_count).value, 'operation'+row_count);
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<select style="width:120px;"  name="operation'+row_count+'" id="operation'+row_count+'"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_operation"><option value="#OPERATION_TYPE_ID#" <cfif isdefined("attributes.default_station") and attributes.default_station eq getSupplier.operation_id>selected</cfif>>#OPERATION_TYPE#</option></cfoutput></select>';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="company_name'+row_count+'"  value="" style="width:150px;" ><input type="hidden" name="company_id'+row_count+'" value=""> 	<cfif attributes.request_plan eq 1><a href="javascript://" onClick="pencereSupplier('+row_count+');"><span><i class="icon-ellipsis"></i></span></a></cfif>';
	
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="demand_stock'+row_count+'"  value="" style="width:200px;">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="hidden" name="stock_id' + row_count +'"><input type="hidden" name="product_id' + row_count +'"><input type="text" name="product' + row_count +'" style="width:200px;" >&nbsp; <a onclick="javascript:pencere_ac_product(' + row_count + ');"><span><i class="icon-ellipsis"></i></span></a>';
	
	newCell = newRow.insertCell(newRow.cells.length);
		newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="quantity' + row_count +'"  value="0" class="moneybox" onkeyup="return(FormatCurrency(this,event));" onBlur="fiyat_hesapla(' + row_count + ');" style="width:50px;">';
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="hidden" name="unit_id' + row_count +'" id="unit_id' + row_count +'"><input type="text"  name="unit_name' + row_count +'" id="unit_name' + row_count +'" value=""   style="width:40px;">';
	
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="price' + row_count +'" value="0" class="moneybox" onkeyup="return(FormatCurrency(this,event,<cfoutput>#textile_round#</cfoutput>));" onBlur="fiyat_hesapla(' + row_count + ');" style="width:50px;"><input type="hidden" name="total_price'+row_count +'" id="total_price'+ row_count +'">';

	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="en'+row_count +'" value="" class="moneybox" onkeyup="return(FormatCurrency(this,event,<cfoutput>#textile_round#</cfoutput>));" style="width:50px;">';

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="revize_quantity'+ row_count +'"   value="" class="moneybox" onkeyup="return(FormatCurrency(this,event,<cfoutput>#textile_round#</cfoutput>));" onBlur="fiyat_hesapla(' + row_count + ');" style="width:50px;">';
	
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="revize_price' + row_count +'" value="0" class="moneybox"  onkeyup="return(FormatCurrency(this,event));" onBlur="fiyat_hesapla(' + row_count + ');" style="width:50px;"><input type="hidden" name="revize_total_price' + row_count +'" id="revize_total_price' + row_count +'">';

	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<select name="money' + row_count +'" id="money' + row_count +'" style="width:60px;"><cfoutput query="get_money"><option value="#get_money.money#" >#get_money.money#</option></cfoutput></select>';
		
	
	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="text" name="row_detail' + row_count +'" id="row_detail' + row_count+'" style="width:150px;">';
		

	newCell = newRow.insertCell(newRow.cells.length);
	newCell.setAttribute('nowrap','nowrap');
	newCell.innerHTML = '<input type="file"  name="image_'+row_count+'" id="image_'+row_count+'">';

	
	}
<cfoutput>

function pencerePosition(no)
{
	alert(no);
	
	windowopen('#request.self#?fuseaction=objects.popup_list_position_cats_multiuser&table_row_name=table_row_pcat&field_form_name=upd_process_cat&field_poscat_id=position_cats&field_td=td_yetkili2&table_name=pos_cats&row_count=row_count_positon_cat&function_row_name=sil_process_cat','list');
}

/*function pencere_ac_product(no)
{
	openBoxDraggable('#request.self#?fuseaction=objects.popup_product_price_unit&field_stock_id=add_opp_supplier.stock_id'+ no +'&field_id=add_opp_supplier.product_id'+ no +'&field_name=add_opp_supplier.product'+ no);
}*/


function pencere_ac_product(no)
	{
	
			sbr = '';
	//&field_price=add_opp_supplier.price'+ no+'&field_total_price=add_opp_supplier.total_price'+ no+'&field_amount=add_opp_supplier.quantity'+ no +';
	openBoxDraggable('#request.self#?fuseaction=objects.popup_product_price_unit'+ sbr+'&company_id=&field_stock_id=add_opp_supplier.stock_id'+ no +'&field_id=add_opp_supplier.product_id'+ no +'&field_name=add_opp_supplier.product'+ no +'&field_unit_id=add_opp_supplier.unit_id'+ no+'&field_unit=add_opp_supplier.unit_name'+ no+'&field_money=add_opp_supplier.money'+ no+'&field_product_catid=add_opp_supplier.category_supp'+ no);
	}
function pencere_ac_brand(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_brands&brand_id=add_opp_supplier.brand_id' + no +'&brand_name=add_opp_supplier.brand_name' + no +'','list');
}
function pencereSupplier(no)
{
	openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&select_list=2&field_comp_name=add_opp_supplier.company_name' + no +'&field_comp_id=add_opp_supplier.company_id' + no + '');
}
/* function pencere_ac_category(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_cat_names&field_id=add_opp_supplier.category_supp' + no + '&field_name=add_opp_supplier.category_name' + no + '&is_sub_category=1','list');
} */
function supplier_kontrol(tip)
{
	static_row=0;
	
	document.add_opp_supplier.other_process.value=tip;
	
	for(r=1;r<=row_count;r++)		
	{
		if(eval("document.add_opp_supplier.row_kontrol"+r).value == 1)
		{	
			static_row++;
			deger_member_id = eval("document.add_opp_supplier.company_id"+r);
			deger_demand_stock_id = eval("document.add_opp_supplier.demand_stock"+r);
				deger_op_id = eval("document.add_opp_supplier.operation"+r);
				deger_pcat_id = eval("document.add_opp_supplier.category_supp"+r);
				
				deger_product_id = eval("document.add_opp_supplier.product_id"+r);
				deger_product = eval("document.add_opp_supplier.product"+r);
				deger_unit_id = eval("document.add_opp_supplier.unit_id"+r);
				deger_unit_name = eval("document.add_opp_supplier.unit_name"+r);
				deger_price = eval("document.add_opp_supplier.price"+r);
				deger_money = eval("document.add_opp_supplier.money"+r);
				deger_quantity = eval("document.add_opp_supplier.quantity"+r);
			/*if(deger_member_id.value=="")
			{
				alert(static_row+".Satır Tedarikçi Seçmelisiniz !");
				return false;
			}*/
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
							alert(static_row+".Satır Metraj girişi yapmalısınız !");
							return false;
						}
				</cfif>
		}
	}
	
	for(r=1;r<=row_count;r++)
	{
		if(eval("document.add_opp_supplier.row_kontrol"+r).value == 1)
		{
			/*eval("document.add_opp_supplier.quantity"+r).value=filterNum(eval("document.add_opp_supplier.quantity"+r).value);
		    eval("document.add_opp_supplier.price"+r).value=filterNum(eval("document.add_opp_supplier.price"+r).value);
			*/
			/*
			eval("document.add_opp_supplier_a.ESTIMATED_INCOME"+r).value = filterNum(eval("document.add_opp_supplier_a.ESTIMATED_INCOME"+r).value);
			eval("document.add_opp_supplier_a.ESTIMATED_COST"+r).value = filterNum(eval("document.add_opp_supplier_a.ESTIMATED_COST"+r).value);
			eval("document.add_opp_supplier_a.ESTIMATED_PROFIT"+r).value = filterNum(eval("document.add_opp_supplier_a.ESTIMATED_PROFIT"+r).value);
			*/
		}
	}

		/*var durum=AjaxFormSubmit(add_opp_supplier,'show_user_message1',0,'&nbsp;Kaydediliyor','&nbsp;Kaydedildi','#request.self#?fuseaction=textile.emptypopup_ajax_req_supplier&req_id=#attributes.req_id#','div_list_supplier',true);
		alert(durum);
	if(durum)
	box_refresh('list_supplier_k');*/

	return true;
}

function fiyat_hesapla(satir)
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
	$('.lock input').prop('readonly','false');
	$('.lock select').prop('readonly','false');
	$(".supplier-product-cat").select2();
});

function getOperation(productcat_id, supplier_el_id){
	$.ajax({
		url : "WBP/Fashion/files/cfc/get_req_supplier_rival.cfc?method=get_supplier_by_productcat",
		type : "POST",
		dataType : "json",
		data : {productcat_id : productcat_id},
		success : function(response) {
			if(response.STATUS){
				eval("document.add_opp_supplier."+supplier_el_id+"").value = response.SUPLIERS_ID;
			}
		}
	});
}

</script>
</cfoutput>

