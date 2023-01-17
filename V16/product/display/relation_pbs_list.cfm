<cfsetting showdebugoutput="no">
<cfif isdefined('attributes.pid') and len(attributes.pid)>
	<cfset attribute_deger = 'pid=#attributes.pid#'>
	<cfset attribute_edit_deger = 'pid_=#attributes.pid#'>
	<cfset relation_deger = 'PRODUCT_ID=#attributes.pid#'>
<cfelseif isdefined('attributes.opp_id') and len(attributes.opp_id)>
	<cfset attribute_deger = 'opp_id=#attributes.opp_id#'>
	<cfset attribute_edit_deger = 'opp_id_=#attributes.opp_id#'>
	<cfset relation_deger = 'OPPORTUNITY_ID=#attributes.opp_id#'>
<cfelseif isdefined('attributes.project_id') and len(attributes.project_id)>
	<cfset attribute_deger = 'project_id=#attributes.project_id#'>
	<cfset attribute_edit_deger = 'project_id_=#attributes.project_id#'>
	<cfset relation_deger = 'PROJECT_ID=#attributes.project_id#'>
<cfelseif  isdefined('attributes.offer_id') and len(attributes.offer_id)>
	<cfset attribute_deger = 'offer_id=#attributes.offer_id#'>
	<cfset attribute_edit_deger = 'offer_id_=#attributes.offer_id#'>
	<cfset relation_deger = 'OFFER_ID=#attributes.offer_id#'>
</cfif>

<cfquery name="get_relation_pbs_code" datasource="#dsn3#">
	SELECT 
		RPC.*,
		SPC.PBS_CODE,
		SPC.PBS_DETAIL,
		SPC.PBS_DETAIL2
	FROM 
		RELATION_PBS_CODE RPC,
		SETUP_PBS_CODE SPC
	WHERE 
		SPC.PBS_ID = RPC.PBS_ID AND
        #relation_deger#
</cfquery>

<cfif isdefined('attributes.opp_id') and len(attributes.opp_id)>
	<cfquery name="getProduct" datasource="#dsn3#">
		SELECT STOCK_ID FROM OPPORTUNITIES WHERE OPP_ID = #attributes.opp_id#
	</cfquery>
	<cfset productSelect = getProduct.STOCK_ID>	
</cfif>
<cfif isdefined('attributes.project_id') and len(attributes.project_id)>
	<cfquery name="getProduct" datasource="#dsn#">
		SELECT PRODUCT_ID FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.project_id#
	</cfquery>
	<cfquery name="getOffer" datasource="#dsn3#">
		SELECT OFFER_ID FROM OFFER WHERE PROJECT_ID = #attributes.project_id#
	</cfquery>
	<cfquery name="getOpp" datasource="#dsn3#">
		SELECT OPP_ID FROM OPPORTUNITIES WHERE PROJECT_ID = #attributes.project_id#
	</cfquery>
</cfif>
<cfif isdefined('attributes.pid') and len(attributes.pid)>
	<cfquery name="getProject" datasource="#dsn#">
		SELECT PROJECT_ID FROM PRO_PROJECTS WHERE PRODUCT_ID = #attributes.pid#
	</cfquery>
	<cfquery name="getOpp" datasource="#dsn3#">
		SELECT DISTINCT OPP.OPP_ID FROM OPPORTUNITIES OPP,STOCKS S WHERE S.STOCK_ID = OPP.STOCK_ID AND S.PRODUCT_ID = #attributes.pid#
	</cfquery>
</cfif>
<cfif (isdefined('productSelect') and not len(productSelect)) or 
	(isdefined('attributes.project_id') and not len(getProduct.product_id) and getOffer.recordcount eq 0 and getOpp.recordcount eq 0) or 
	(isdefined('attributes.pid') and (getProject.recordcount eq 0 and getOpp.recordcount eq 0))>
	<cfset is_del_pbs_row = 0>
<cfelse>
	<cfset is_del_pbs_row = 1>
</cfif>
<div id="pbs_action_div" style="display:none;"></div>
<cf_basket id="relation_pbs">
		<table name="table1" id="table1" class="detail_basket_list">
        <thead>
			<tr class="nohover">
				<th rowspan="3">&nbsp;</th>
				<th rowspan="3" width="50"><cf_get_lang dictionary_id='45155.PBS Kod'></th>
				<th rowspan="3" width="50"><cf_get_lang dictionary_id='58233.Tanım'></th>
				<th rowspan="3" width="50"><cf_get_lang dictionary_id='58233.Tanım'> 2</th>
				<th rowspan="3" width="50"><cf_get_lang dictionary_id='57629.Açıklama'></th>
				<th colspan="16" style="text-align:center"><cf_get_lang dictionary_id='30772.Alış'></th>
				<th colspan="16" style="text-align:center"><cf_get_lang dictionary_id='30815.Satış'></th>
			</tr>
			<tr>
				<th colspan="4" style="text-align:center"><cf_get_lang dictionary_id='57784.İşçilik'></th>
				<th colspan="4" style="text-align:center"><cf_get_lang dictionary_id='38326.Malzeme'></th>
				<th colspan="4" style="text-align:center"><cf_get_lang dictionary_id='45607.Mühendislik'></th>
				<th colspan="4" style="text-align:center"><cf_get_lang dictionary_id='59352.Yönetim'></th>
				<th colspan="4" style="text-align:center"><cf_get_lang dictionary_id='57784.İşçilik'></th>
				<th colspan="4" style="text-align:center"><cf_get_lang dictionary_id='38326.Malzeme'></th>
				<th colspan="4" style="text-align:center"><cf_get_lang dictionary_id='45607.Mühendislik'></th>
				<th colspan="4" style="text-align:center"><cf_get_lang dictionary_id='59352.Yönetim'></th>
			</tr>
			<tr>
				<!--- Alıs İscilik --->
				<th style="text-align:center"><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th style="text-align:center"><cf_get_lang dictionary_id='57636.Birim'></th>
				<th style="text-align:center"><cf_get_lang dictionary_id='57638.B.Fiyat'></th>
				<th style="text-align:center">P.B</th>
				<!--- Alıs malzeme --->
				<th style="text-align:center"><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th style="text-align:center"><cf_get_lang dictionary_id='57636.Birim'></th>
				<th style="text-align:center"><cf_get_lang dictionary_id='57638.B.Fiyat'></th>
				<th style="text-align:center">P.B</th>
				<!--- Alıs muhendislik --->
				<th style="text-align:center"><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th style="text-align:center"><cf_get_lang dictionary_id='57636.Birim'></th>
				<th style="text-align:center"><cf_get_lang dictionary_id='57638.B.Fiyat'></th>
				<th style="text-align:center">P.B</th>
				<!--- Alıs yonetim --->
				<th style="text-align:center"><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th style="text-align:center"><cf_get_lang dictionary_id='57636.Birim'></th>
				<th style="text-align:center"><cf_get_lang dictionary_id='57638.B.Fiyat'></th>
				<th style="text-align:center">P.B</th>
				<!--- satıs iscilik--->
				<th style="text-align:center"><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th style="text-align:center"><cf_get_lang dictionary_id='57636.Birim'></th>
				<th style="text-align:center"><cf_get_lang dictionary_id='57638.B.Fiyat'></th>
				<th style="text-align:center">P.B</th>
				<!--- satıs malzeme--->
				<th style="text-align:center"><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th style="text-align:center"><cf_get_lang dictionary_id='57636.Birim'></th>
				<th style="text-align:center"><cf_get_lang dictionary_id='57638.B.Fiyat'></th>
				<th style="text-align:center">P.B</th>
				<!--- satıs muhendislik--->
				<th style="text-align:center"><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th style="text-align:center"><cf_get_lang dictionary_id='57636.Birim'></th>
				<th style="text-align:center"><cf_get_lang dictionary_id='57638.B.Fiyat'></th>
				<th style="text-align:center">P.B</th>
				<!--- satıs yonetim--->
				<th style="text-align:center"><cf_get_lang dictionary_id='57635.Miktar'></th>
				<th style="text-align:center"><cf_get_lang dictionary_id='57636.Birim'></th>
				<th style="text-align:center"><cf_get_lang dictionary_id='57638.B.Fiyat'></th>
				<th style="text-align:center">P.B</th>
			</tr>
           </thead>
           <tbody>
			<cfif get_relation_pbs_code.recordcount>
				<cfoutput query="get_relation_pbs_code">
						<tr id="frm_row#pbs_id#">
						<td style="width:40px;" nowrap="nowrap">
							<cfif is_del_pbs_row eq 0>
								<a href="javascript://" onClick="sil('#currentrow#','#pbs_id#');"><img  src="images/delete_list.gif" border="0"></a>
							</cfif>
							<a href="javascript://" onClick="pbs_edit('#currentrow#','#pbs_id#');"><img  src="images/update_list.gif" border="0"></a>
						</td>
						<td nowrap>#pbs_code#</td>
						<td nowrap title="#pbs_detail#">#left(pbs_detail,30)#</td>
						<td nowrap title="#pbs_detail2#">#left(pbs_detail2,30)#</td>
						<td nowrap>#left(detail,30)#</td>
						<!--- Alıs İscilik --->
						<td>#purchase_labour_amount#</td>
						<td>
						<cfif len(purchase_labour_unit_id)>
							<cfquery name="get_unit_pl" datasource="#dsn#">
								SELECT UNIT FROM SETUP_UNIT WHERE UNIT_ID = #purchase_labour_unit_id#
							</cfquery>
							#get_unit_pl.unit#
						</cfif>
						</td>
						<td>#TLFormat(purchase_labour_price,2)#</td>
						<td>#purchase_labour_money#</td>
						<!--- Alıs malzeme --->
						<td>#purchase_material_amount#</td>
						<td><cfif len(purchase_material_unit_id)>
								<cfquery name="get_unit_pm" datasource="#dsn#">
									SELECT UNIT FROM SETUP_UNIT WHERE UNIT_ID = #purchase_material_unit_id#
								</cfquery>
								#get_unit_pm.unit#
							</cfif>
						</td>
						<td>#TLFormat(purchase_material_price,2)#</td>
						<td>#purchase_material_money#</td>
						<!--- Alıs muhendislik --->
						<td>#purchase_engineering_amount#</td>
						<td><cfif len(purchase_engineering_unit_id)>
								<cfquery name="get_unit_pe" datasource="#dsn#">
									SELECT UNIT FROM SETUP_UNIT WHERE UNIT_ID = #purchase_engineering_unit_id#
								</cfquery>
								#get_unit_pe.unit#
							</cfif>
						</td>
						<td>#TLFormat(purchase_engineering_price,2)#</td>
						<td>#purchase_engineering_money#</td>
						<!--- Alıs yonetim --->
						<td>#purchase_management_amount#</td>
						<td><cfif len(purchase_management_unit_id)>
								<cfquery name="get_unit_p_m" datasource="#dsn#">
									SELECT UNIT FROM SETUP_UNIT WHERE UNIT_ID = #purchase_management_unit_id#
								</cfquery>
								#get_unit_p_m.unit#
							</cfif>
						</td>
						<td>#TLFormat(purchase_management_price,2)#</td>
						<td>#purchase_management_money#</td>
						<!--- satıs iscilik --->
						<td>#sales_labour_amount#</td>
						<td><cfif len(sales_labour_unit_id)>
								<cfquery name="get_unit_sl" datasource="#dsn#">
									SELECT UNIT FROM SETUP_UNIT WHERE UNIT_ID = #sales_labour_unit_id#
								</cfquery>
								#get_unit_sl.unit#
							</cfif>
						</td>
						<td>#TLFormat(sales_labour_price,2)#</td>
						<td>#sales_labour_money#</td>
						<!--- satıs malzeme --->
						<td>#sales_material_amount#</td>
						<td><cfif len(sales_material_unit_id)>
								<cfquery name="get_unit_sm" datasource="#dsn#">
									SELECT UNIT FROM SETUP_UNIT WHERE UNIT_ID = #sales_material_unit_id#
								</cfquery>
								#get_unit_sm.unit#
							</cfif>
						</td>
						<td>#TLFormat(sales_material_price,2)#</td>
						<td>#sales_material_money#</td>
						<!--- satıs muhendislik --->
						<td>#sales_engineering_amount#</td>
						<td><cfif len(sales_engineering_unit_id)>
								<cfquery name="get_unit_se" datasource="#dsn#">
									SELECT UNIT FROM SETUP_UNIT WHERE UNIT_ID = #sales_engineering_unit_id#
								</cfquery>
								#get_unit_se.unit#
							</cfif>
						</td>
						<td>#TLFormat(sales_engineering_price,2)#</td>
						<td>#sales_engineering_money#</td>
						<!--- satıs yonetim --->
						<td>#sales_management_amount#</td>
						<td><cfif len(sales_management_unit_id)>
								<cfquery name="get_unit_s_m" datasource="#dsn#">
									SELECT UNIT FROM SETUP_UNIT WHERE UNIT_ID = #sales_management_unit_id#
								</cfquery>
								#get_unit_s_m.unit#
							</cfif>
						</td>
						<td>#TLFormat(sales_management_price,2)#</td>
						<td>#sales_management_money#</td>
					</tr>
				</cfoutput>
			</cfif>
           </tbody>
		</table>
</cf_basket>
<iframe src="" name="relation_upd_iframe" id="relation_upd_iframe" frameborder="0" width="0" height="0"></iframe>
<cfform name="upd_relation_pbs_row" id="upd_relation_pbs_row" action="#request.self#?fuseaction=product.emptypopup_upd_relation_pbs_query" method="post">
	<cfif isdefined('attributes.pid') and len(attributes.pid)>
		<input type="hidden" name="pid" id="pid" value="<cfoutput>#attributes.pid#</cfoutput>"/>
	<cfelseif isdefined('attributes.opp_id') and len(attributes.opp_id)>
		<input type="hidden" name="opp_id" id="opp_id" value="<cfoutput>#attributes.opp_id#</cfoutput>"/>
	<cfelseif isdefined('attributes.project_id') and len(attributes.project_id)>
		<input type="hidden" name="project_id" id="project_id" value="<cfoutput>#attributes.project_id#</cfoutput>"/>
	<cfelseif  isdefined('attributes.offer_id') and len(attributes.offer_id)>
		<input type="hidden" name="offer_id" id="offer_id" value="<cfoutput>#attributes.offer_id#</cfoutput>"/>
	</cfif>
	<input type="hidden" name="is_del_pbs_row" id="is_del_pbs_row" value="#is_del_pbs_row#"/>
	<input type="hidden" name="row_id" id="row_id" value=""/>
	<input type="hidden" name="pbs_id" id="pbs_id" value=""/>
	<input type="hidden" name="rel_detail" id="rel_detail">

	<input type="hidden" name="purchase_labour_amount" id="purchase_labour_amount" value="">
	<input type="hidden" name="purchase_labour_unit_id" id="purchase_labour_unit_id" value=""/>
	<input type="hidden" name="purchase_labour_price" id="purchase_labour_price" value="">
	<input type="hidden" name="purchase_labour_money" id="purchase_labour_money" value=""/>
		
	<input type="hidden" name="purchase_material_amount" id="purchase_material_amount" value="">
	<input type="hidden" name="purchase_material_unit_id" id="purchase_material_unit_id" value=""/>
	<input type="hidden" name="purchase_material_price" id="purchase_material_price" value="">
	<input type="hidden" name="purchase_material_money" id="purchase_material_money" value=""/>
		
	<input type="hidden" name="purchase_engineering_amount" id="purchase_engineering_amount" value="">
	<input type="hidden" name="purchase_engineering_unit_id" id="purchase_engineering_unit_id" value=""/>
	<input type="hidden" name="purchase_engineering_price" id="purchase_engineering_price" value="">
	<input type="hidden" name="purchase_engineering_money" id="purchase_engineering_money" value=""/>
	
	<input type="hidden" name="purchase_management_amount" id="purchase_management_amount" value="">
	<input type="hidden" name="purchase_management_unit_id" id="purchase_management_unit_id" value=""/>
	<input type="hidden" name="purchase_management_price" id="purchase_management_price" value="">
	<input type="hidden" name="purchase_management_money" id="purchase_management_money" value=""/>
	
	<input type="hidden" name="sales_labour_amount" id="sales_labour_amount" value="">
	<input type="hidden" name="sales_labour_unit_id" id="sales_labour_unit_id" value=""/>
	<input type="hidden" name="sales_labour_price" id="sales_labour_price" value="">
	<input type="hidden" name="sales_labour_money" id="sales_labour_money" value=""/>
	
	<input type="hidden" name="sales_material_amount" id="sales_material_amount" value="">
	<input type="hidden" name="sales_material_unit_id" id="sales_material_unit_id" value=""/>
	<input type="hidden" name="sales_material_price" id="sales_material_price" value="">
	<input type="hidden" name="sales_material_money" id="sales_material_money" value=""/>
	
	<input type="hidden" name="sales_engineering_amount" id="sales_engineering_amount" value="">
	<input type="hidden" name="sales_engineering_unit_id" id="sales_engineering_unit_id" value=""/>
	<input type="hidden" name="sales_engineering_price" id="sales_engineering_price" value="">
	<input type="hidden" name="sales_engineering_money" id="sales_engineering_money" value=""/>
	
	<input type="hidden" name="sales_management_amount" id="sales_management_amount" value="">
	<input type="hidden" name="sales_management_unit_id" id="sales_management_unit_id" value=""/>
	<input type="hidden" name="sales_management_price" id="sales_management_price" value="">
	<input type="hidden" name="sales_management_money" id="sales_management_money" value=""/>
</cfform>
<cfoutput>
	<script language="javascript">
		gizle(div_pbs_);
		document.getElementById('pbs_id').value = '';
		document.getElementById('pbs_code').value = '';
		
		function sil(row,pbs_id)
		{
			if (confirm("<cf_get_lang dictionary_id='60439.İlişkili PBS Kaydı Silinecektir Emin misiniz'>?"))
			{
			adress_ = '#request.self#?fuseaction=product.emptypopup_del_relation_pbs&#attribute_deger#&pbs_id='+pbs_id;
			AjaxPageLoad(adress_,'pbs_action_div',1);
			row_ = eval('frm_row' + pbs_id);
			gizle(row_);
			}
		}
		function pbs_edit(row_,pbs_id)
		{
			satir_ = parseInt(row_) + 2;
			adress_ = '#request.self#?fuseaction=product.emptypopup_upd_relation_pbs&#attribute_edit_deger#&pbs_id=' + pbs_id + '&satir_=' + satir_;
			AjaxPageLoad(adress_,'pbs_action_div',1);
			
			var table_renk_ = document.getElementById('table1');
			table_renk_.rows[satir_].style.backgroundColor = 'FF6600';
		}
		
		function update_pbs(row_,pbs_id)
		{
			document.upd_relation_pbs_row.row_id.value = row_;
			document.upd_relation_pbs_row.pbs_id.value = pbs_id;
			
			document.upd_relation_pbs_row.rel_detail.value = document.getElementById('rel_detail_' + pbs_id).value;
			document.upd_relation_pbs_row.purchase_labour_amount.value = document.getElementById('purchase_labour_amount_' + pbs_id).value;
			document.upd_relation_pbs_row.purchase_labour_unit_id.value = document.getElementById('purchase_labour_unit_id_' + pbs_id).value;
			document.upd_relation_pbs_row.purchase_labour_price.value = document.getElementById('purchase_labour_price_' + pbs_id).value;
			document.upd_relation_pbs_row.purchase_labour_money.value = document.getElementById('purchase_labour_money_' + pbs_id).value;
			
			document.upd_relation_pbs_row.purchase_material_amount.value = document.getElementById('purchase_material_amount_' + pbs_id).value;
			document.upd_relation_pbs_row.purchase_material_unit_id.value = document.getElementById('purchase_material_unit_id_' + pbs_id).value;
			document.upd_relation_pbs_row.purchase_material_price.value = document.getElementById('purchase_material_price_' + pbs_id).value;
			document.upd_relation_pbs_row.purchase_material_money.value = document.getElementById('purchase_material_money_' + pbs_id).value;
			
			document.upd_relation_pbs_row.purchase_engineering_amount.value = document.getElementById('purchase_engineering_amount_' + pbs_id).value;
			document.upd_relation_pbs_row.purchase_engineering_unit_id.value = document.getElementById('purchase_engineering_unit_id_' + pbs_id).value;
			document.upd_relation_pbs_row.purchase_engineering_price.value = document.getElementById('purchase_engineering_price_' + pbs_id).value;
			document.upd_relation_pbs_row.purchase_engineering_money.value = document.getElementById('purchase_engineering_money_' + pbs_id).value;
			
			document.upd_relation_pbs_row.purchase_management_amount.value = document.getElementById('purchase_management_amount_' + pbs_id).value;
			document.upd_relation_pbs_row.purchase_management_unit_id.value = document.getElementById('purchase_management_unit_id_' + pbs_id).value;
			document.upd_relation_pbs_row.purchase_management_price.value = document.getElementById('purchase_management_price_' + pbs_id).value;
			document.upd_relation_pbs_row.purchase_management_money.value = document.getElementById('purchase_management_money_' + pbs_id).value;
			
			document.upd_relation_pbs_row.sales_labour_amount.value = document.getElementById('sales_labour_amount_' + pbs_id).value;
			document.upd_relation_pbs_row.sales_labour_unit_id.value = document.getElementById('sales_labour_unit_id_' + pbs_id).value;
			document.upd_relation_pbs_row.sales_labour_price.value = document.getElementById('sales_labour_price_' + pbs_id).value;
			document.upd_relation_pbs_row.sales_labour_money.value = document.getElementById('sales_labour_money_' + pbs_id).value;
			
			document.upd_relation_pbs_row.sales_material_amount.value = document.getElementById('sales_material_amount_' + pbs_id).value;
			document.upd_relation_pbs_row.sales_material_unit_id.value = document.getElementById('sales_material_unit_id_' + pbs_id).value;
			document.upd_relation_pbs_row.sales_material_price.value = document.getElementById('sales_material_price_' + pbs_id).value;
			document.upd_relation_pbs_row.sales_material_money.value = document.getElementById('sales_material_money_' + pbs_id).value;
			
			document.upd_relation_pbs_row.sales_engineering_amount.value = document.getElementById('sales_engineering_amount_' + pbs_id).value;
			document.upd_relation_pbs_row.sales_engineering_unit_id.value = document.getElementById('sales_engineering_unit_id_' + pbs_id).value;
			document.upd_relation_pbs_row.sales_engineering_price.value = document.getElementById('sales_engineering_price_' + pbs_id).value;
			document.upd_relation_pbs_row.sales_engineering_money.value = document.getElementById('sales_engineering_money_' + pbs_id).value;
			
			document.upd_relation_pbs_row.sales_management_amount.value = document.getElementById('sales_management_amount_' + pbs_id).value;
			document.upd_relation_pbs_row.sales_management_unit_id.value = document.getElementById('sales_management_unit_id_' + pbs_id).value;
			document.upd_relation_pbs_row.sales_management_price.value = document.getElementById('sales_management_price_' + pbs_id).value;
			document.upd_relation_pbs_row.sales_management_money.value = document.getElementById('sales_management_money_' + pbs_id).value;
			
			document.upd_relation_pbs_row.target = 'relation_upd_iframe';
			document.upd_relation_pbs_row.submit();
			
		}
	</script>
</cfoutput>
