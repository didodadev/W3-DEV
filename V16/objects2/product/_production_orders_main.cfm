		<table width="100%" align="left" style="text-align:left;">
			<tr>
            	<cfif isdefined('is_demand')>
                    <td width="60" class="formbold">Talep No</td>
                    <td width="140"><!---<input type="hidden" name="is_demand" id="is_demand" value="1"><input type="text" name="demand_no" id="demand_no" value="---><cfoutput>#get_det_po.demand_no#</cfoutput><!---" style="width:120px;">---></td>
                <cfelse>
                    <td width="60" class="formbold">Üretim No</td>
                    <td width="140"><!---<input type="hidden" name="is_demand" id="is_demand" value="0"><input type="text" name="p_order_no" id="p_order_no" value="---><cfoutput>#get_det_po.p_order_no#</cfoutput><!---" style="width:120px;">---></td>
                </cfif>
				<td width="60"><cf_get_lang_main no='89.Başlama'></td>
				<td width="185">
					<input type="hidden" name="_popup" id="_popup" value="2">
					<cfsavecontent variable="message"><cf_get_lang_main no='383.Başlama Tarihi girmelisiniz'></cfsavecontent>
					<cfinput required="Yes" message="#message#" type="text" name="start_date" id="start_date" validate="eurodate" style="width:63px;" value="#dateformat(get_det_po.start_date,'dd/mm/yyyy')#">
					<cf_wrk_date_image date_field="start_date">
					<cfoutput>
					<select name="start_h" id="start_h" style="width:37px;">
						<cfloop from="0" to="23" index="i">
							<option value="#i#" <cfif timeformat(get_det_po.start_date,'HH') eq i> selected</cfif>><cfif i lt 10>0</cfif>#I#</option>
						</cfloop>
					</select>
					<select name="start_m" id="start_m" style="width:37px;">
						<cfloop from="0" to="59" index="i">
							<option value="#i#" <cfif timeformat(get_det_po.start_date,'mm') eq i>selected</cfif>><cfif i lt 10>0</cfif>#I#</option>
						</cfloop>
					</select>
					<input type="hidden" name="old_start_date" id="old_start_date" value="#get_det_po.start_date#"><!--- Silmeyiniz, sureclerde kullaniliyor FBS 20100513 --->
					</cfoutput>
				</td>
				<!---<td width="60"><cf_get_lang_main no='81.Aktif'><input type="checkbox" name="status" id="status" value="1" <cfif get_det_po.status eq 1>checked</cfif>></td>
				<td colspan="2"><input type="checkbox" name="stock_reserved" id="stock_reserved" value="1" <cfif get_det_po.is_stock_reserved eq 1>checked</cfif>> <cf_get_lang no='72.Stok Rezerve Et'><a href="javascript://" onClick="sayfa_getir();" ><img src="/images/alternative_list.gif" title="<cf_get_lang no='27.Durum ve Stok Rezerve Et Güncelle'>"></a><div id="status_div" style="display:none;"></div>
					<input type="checkbox" name="is_demontaj" id="is_demontaj" value="1" <cfif get_det_po.IS_DEMONTAJ eq 1>checked</cfif>> <cf_get_lang no='547.Demontaj'>
				</td> --->
			</tr>
			<tr>
				<td><cf_get_lang_main no='799.Siparis No'></td>
				<td><input type="hidden" name="order_id" id="order_id" value="<cfoutput>#valuelist(get_order_row.order_id,',')#</cfoutput>">
					<input type="hidden" name="order_row_id" id="order_row_id" value="<cfif isdefined('GET_ORDER_ROW_1')><cfoutput>#valuelist(GET_ORDER_ROW_1.order_row_id,',')#</cfoutput></cfif>">
					<input type="text" name="order_id_" id="order_id_" style="width:120px;" readonly="" value="<cfoutput>#valuelist(get_order_row.order_number,',')#</cfoutput>">
				</td>
				<td><cf_get_lang_main no='90.Bitiş'></td>
				<td nowrap="nowrap"><cfsavecontent variable="message"><cf_get_lang_main no='327.Bitiş Tarihi girmelisiniz'></cfsavecontent>
					<cfinput required="yes" message="#message#" type="text" name="finish_date" id="finish_date" validate="eurodate" style="width:63px;" value="#dateformat(get_det_po.finish_date,'dd/mm/yyyy')#">
					<cf_wrk_date_image date_field="finish_date">
					<cfoutput>
					<select name="finish_h" id="finish_h" style="width:37px;">
						<cfloop from="0" to="23" index="I">
							<option value="#i#" <cfif timeformat(get_det_po.finish_date,'HH') eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
						</cfloop>
					</select>
					<select name="finish_m" id="finish_m" style="width:37px;">
						<cfloop from="0" to="59" index="i">
							<option value="#i#" <cfif timeformat(get_det_po.finish_date,'mm') eq i>selected</cfif>><cfif i lt 10>0</cfif>#i#</option>
						</cfloop>
					</select>
					<input type="hidden" name="old_finish_date" id="old_finish_date" value="#get_det_po.finish_date#"><!--- Silmeyiniz, sureclerde kullaniliyor FBS 20100513 --->
					</cfoutput>
					<!---<a href="javascript://" onClick="calc_deliver_date();"><img src="/images/workdevwork.gif" style="cursor:pointer;" title="Tarih Hesapla"></a>
					<div style="position:absolute;z-index:9999999" id="deliver_date_info"></div>--->
				</td>
				<td><cf_get_lang_main no='344.Süreç'></td>
				<td><cf_workcube_process is_upd='0' select_value='#get_det_po.prod_order_stage#' process_cat_width='140' is_detail='1'></td>
			</tr>
			<tr>
				<td><cf_get_lang no='385.Lot No'></td>
				<td><input type="text" name="lot_no" id="lot_no" style="width:120px;" value="<cfoutput>#get_det_po.lot_no#</cfoutput>"></td>
				<td width="100"><cf_get_lang_main no='106.Stok Kodu'></td>
				<td><input type="text" readonly="yes" name="stock_code" id="stock_code" value="<cfoutput>#get_det_po.stock_code#</cfoutput>" style="width:162px;"></td>
				<td><cf_get_lang_main no='4.Proje'></td>
				<td>
					<cf_wrkProject
						project_Id="#get_det_po.project_id#"
						width="140"
						AgreementNo="1" Customer="2" Employee="3" Priority="4" Stage="5"
						boxwidth="600"
						boxheight="400">
				</td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='1422.İstasyon'></td>
				<td><input type="hidden" name="station_id" id="station_id" <cfif len(get_det_po.station_id) >value="<cfoutput>#get_det_po.station_id#</cfoutput>"<cfelse>value=""</cfif>>
					<input type="text" name="station_name" id="station_name" style="width:120px;" readonly <cfif len(get_det_po.station_id)> value="<cfoutput>#get_w.station_name#</cfoutput>"</cfif>>
					<!---<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_list_workstation&field_name=add_production_order.station_name&field_id=add_production_order.station_id&c=1</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>--->
				</td>
				<td><cf_get_lang_main no='245.Ürün'></td>
				<td><cfif isdefined("attributes.order_id")>
						<script type="text/javascript">
							temp_var = <cfoutput>#get_det_po.stock_id#</cfoutput>;
						</script>
						<input type="hidden" name="stock_id" id="stock_id" value="<cfoutput>#get_det_po.stock_id#</cfoutput>">
						<input type="text" name="product_name" id="product_name" value="<cfoutput>#get_product_name(stock_id:get_det_po.stock_id)#</cfoutput>" readonly style="width:140px;">
					<cfelse>
						<input type="hidden" name="stock_id" id="stock_id" <cfif isdefined("attributes.upd")>value="<cfoutput>#get_det_po.stock_id#</cfoutput>"<cfelse>value=""</cfif> >
						<input type="text" name="product_name" id="product_name" style="width:162px;" readonly <cfif isdefined("attributes.upd")>value="<cfoutput>#get_det_po.product_name# #get_det_po.property#</cfoutput>"</cfif>>
						<!--- <a <cfoutput>#prod_and_spec_disp#</cfoutput> href="javascript://" onclick="temizle_order(); windowopen('<cfoutput>#request.self#?fuseaction=prod.popup_add_product&is_production=1&spec_field_id=add_production_order.spect_main_id&field_name=add_production_order.product_name&field_id=add_production_order.stock_id&stock_code=add_production_order.stock_code</cfoutput>','list')"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a> --->
					</cfif>
				</td>
				<td><cf_get_lang_main no='1033.İş'></td>
				<td><cfif isdefined("get_det_po.work_id") and len(get_det_po.work_id)>
						<cfquery name="get_work" datasource="#dsn#">
							SELECT 
							   WORK_ID,
							   WORK_HEAD 
							FROM 
								PRO_WORKS 
							WHERE 
								WORK_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_det_po.work_id#">
						</cfquery>
						<cfset get_work.work_head = get_work.work_head>
					<cfelse>
						<cfset get_work.work_head = ''>
					</cfif>
					<input type="hidden" name="work_id" id="work_id" value="<cfif isdefined("get_det_po.work_id") and len(get_det_po.work_id)><cfoutput>#get_det_po.work_id#</cfoutput></cfif>">
					<input type="text" name="work_head" id="work_head" style="width:140px;" value="<cfoutput>#get_work.work_head#</cfoutput>" onFocus="AutoComplete_Create('work_head','WORK_HEAD','WORK_HEAD','get_work','','WORK_ID','work_id','','3','110')">
					<!---<a href="javascript://" onClick="pencere_ac_work();"><img src="/images/plus_thin.gif" title="<cf_get_lang_main no='1279.iş listesi'>" align="absmiddle" border="0"></a>
				---></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='1372.Referans'></td>
				<td><input type="text" name="reference_no" id="reference_no" value="<cfoutput>#get_det_po.REFERENCE_NO#</cfoutput>" style="width:120px;"></td>
				<td><cf_get_lang_main no='235.Spec'></td>
				<td>
                	<input type="text" style="width:30px;" name="spect_main_id" id="spect_main_id" value="<cfoutput>#get_det_po.spec_main_id#</cfoutput>"readonly>
					<input type="hidden" style="width:33px;" name="old_spect_var_id" id="old_spect_var_id" value="<cfoutput>#get_det_po.spect_var_id#</cfoutput>"readonly>
                    <input type="text" style="width:33px;" name="spect_var_id" id="spect_var_id" value="<cfoutput>#get_det_po.spect_var_id#</cfoutput>"readonly>
					<input type="text" name="spect_var_name" id="spect_var_name" value="<cfoutput>#get_det_po.spect_var_name#</cfoutput>" style="width:93px;" readonly>
					<!--- <cfoutput>
						<cfif get_order_result.recordcount eq 0>
							<a <cfoutput>#prod_and_spec_disp#</cfoutput>  href="javascript://" onClick="open_spec();"><img src="images/plus_thin.gif" border="0" align="absmiddle"></a>
						</cfif>
					</cfoutput> --->
				</td>
				<td rowspan="2" valign="top"><cf_get_lang_main no='217.Açıklama'></td>
				<td rowspan="2"><textarea name="detail" id="detail" maxlength="500" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="500 Karakterden Fazla Yazmayınız!" style="width:140px;height:45px;"><cfoutput>#get_det_po.detail#</cfoutput></textarea></td>
			</tr>
			<tr>
				<td><cf_get_lang_main no='223.Miktar'></td>
				<td>
					<input type="hidden" name="dp_order_id" id="dp_order_id" value="<cfoutput>#get_det_po.dp_order_id#</cfoutput>">
					<input type="hidden" name="p_order_id" id="p_order_id" value="<cfoutput>#attributes.upd#</cfoutput>">
					<cfsavecontent variable="message"><cf_get_lang no='73.Miktar girmelisiniz'></cfsavecontent>
					<cfinput type="hidden" name="old_quantity" id="old_quantity" value="#get_det_po.quantity#">
					<cfinput type="text" name="quantity" id="quantity" required="Yes" validate="float" message="#message#" maxlength="100" value="#tlformat(get_det_po.quantity,2)#" passThrough="onkeyup=""return(FormatCurrency(this,event,8));""" onBlur="aktar();" style="width:120px;">
					<cfinput type="hidden" name="quantity_" id="quantity_" required="Yes" maxlength="100" value="#tlformat(get_det_po.quantity,8)#" passThrough="onkeyup=""return(FormatCurrency(this,event,8));""" onBlur="aktar();" style="width:120px;">
				</td>
				<cfif isdefined("is_show_result_amount") and is_show_result_amount eq 1>
					<td>Üretilen</td>
					<td>
						<cfinput type="text" name="result_amount" id="result_amount" maxlength="100" value="#tlformat(get_det_po.row_result_amount)#" readonly style="width:65px;">
						Kalan
						<cfinput type="text" name="result_amount" id="result_amount" maxlength="100" value="#tlformat(get_det_po.quantity-get_det_po.row_result_amount)#" readonly style="width:65px;">
					</td>
				</cfif>
			</tr>
		</table>
<script type="text/javascript">
	function sayfa_getir()
	{
		if(document.add_production_order.status.checked == true) status_info = 1; else status_info = 0;
		if(document.add_production_order.stock_reserved.checked == true) stock_reserved_info = 1; else stock_reserved_info = 0;
		if(confirm("Güncelleme Yapılacak. Emin misiniz ?"))
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=prod.emptypopup_upd_production_orders_status&upd=#attributes.upd#</cfoutput>&status='+status_info+'&stock_reserved='+stock_reserved_info,'status_div');
	}
	function pencere_ac_work()
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&field_id=all.work_id&field_name=all.work_head','list');
	}
</script>
