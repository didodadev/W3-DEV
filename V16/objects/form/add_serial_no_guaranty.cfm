<cfinclude template="../query/get_guaranty_cat.cfm">
<cfsavecontent variable="head_">
<cf_get_lang dictionary_id='57637.Seri No'>/<cfif isdefined("attributes.sale")><cf_get_lang dictionary_id='57448.Satış'><cfelseif isdefined("attributes.take")><cf_get_lang dictionary_id='58176.Alış'></cfif><cf_get_lang dictionary_id='32497.Garanti Giriş'>
</cfsavecontent>
<cf_get_lang_set module_name="objects">
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#head_#">
		<cfform name="form_basket" id="form_basket" action="#request.self#?fuseaction=objects.add_serialno_guaranty" method="post">
			<cf_box_elements>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-is_purchase_sales">
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12"><label><cf_get_lang dictionary_id='57756.Durum'></label></div>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="col col-6">
								<label><input type="radio" name="is_purchase_sales" id="is_purchase_sales" value="0" checked><cf_get_lang dictionary_id='58176.Alış'></label>
								<label><input type="checkbox" name="is_rma" id="is_rma" value="1"><cf_get_lang dictionary_id='33239.Üreticide'></label>	 
								<label><input type="checkbox" name="in_out" id="in_out" value="1"><cf_get_lang dictionary_id='33237.Satılabilir'></label>	                        
								<label><input type="checkbox" name="is_return" id="is_return" value="1"><cf_get_lang dictionary_id='29418.İade'></label>
							</div>
							<div class="col col-6">
								<label><input type="radio" name="is_purchase_sales" id="is_purchase_sales" value="1"><cf_get_lang dictionary_id='57448.Satış'></label>
								<label><input type="checkbox" name="is_service" id="is_service" value="1"><cf_get_lang dictionary_id='33240.Serviste'></label>
								<label><input type="checkbox" name="is_trash" id="is_trash" value="1"><cf_get_lang dictionary_id='29471.Fire'></label>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-method">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29472.Yöntem'></label>
						<div class="col col-8 col-xs-12">
							<div class="col col-6">
								<label><input type="radio" name="method" id="method" value="0" checked > <cf_get_lang dictionary_id='32749.Ardışık'></label>
							</div>
							<div class="col col-6">
								<label><input type="radio" name="method" id="method" value="1" > <cf_get_lang dictionary_id='32767.Tek Tek'></label>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-stock_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="stock_id" id="stock_id">
								<input type="text" name="product_name" id="product_name" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME','get_product','0','STOCK_ID','stock_id','','3','200');">
								<span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57657.Ürün'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_product_names&field_id=form_basket.stock_id&field_name=form_basket.product_name&keyword='+encodeURIComponent(document.form_basket.product_name.value));"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-amount">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57635.Miktar'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='60222.Miktar Seçiniz'> !</cfsavecontent>
							<cfinput type="text" name="amount" value="" class="moneybox" message="#message#" onKeyUp="isNumber(this)" required="yes">
						</div>
					</div>
					<div class="form-group" id="item-department">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'>-<cf_get_lang dictionary_id='30031.Lokasyon'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<cf_wrkdepartmentlocation
							returnInputValue="location_id,department_name,department_id"
							returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID"
							fieldName="department_name"
							fieldId="location_id"
							user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#">
						</div>
					</div>
					<div class="form-group" id="item-start_date">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='33243.Alış Garanti Başlama'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="start_date" value="#dateformat(now(),dateformat_style)#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-guarantycat_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='33244.Alış Garanti Kategorisi'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="guarantycat_id" id="guarantycat_id">
								<option value="" selected><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfoutput query="get_guaranty_cat">
									<option value="#guarantycat_id#" <cfif isDefined("attributes.category") and len(attributes.category) and (guarantycat_id eq attributes.category)>selected</cfif>>#guarantycat#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-start_date">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='33245.Satış Garanti Başlama'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<cfinput type="text" name="sale_start_date" value="#dateformat(now(),dateformat_style)#">
								<span class="input-group-addon"><cf_wrk_date_image date_field="sale_start_date"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-sale_guarantycat_id">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='33246.Satış Garanti Kategorisi'>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<select name="sale_guarantycat_id" id="sale_guarantycat_id">
								<option value="" selected><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfoutput query="get_guaranty_cat">
									<option value="#guarantycat_id#">#guarantycat#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-update_time">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='33247.Süre Uzatma'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="update_time" id="update_time">
						</div>
					</div>
					<div class="form-group" id="item-lot_no">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32916.Lot No'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<input type="text" name="lot_no" id="lot_no">
						</div>
					</div>
					<div class="form-group" id="item-tek_tek">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cfoutput>#getLang('call',57)#</cfoutput>*</label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<div class="input-group">
								<input type="text" name="ship_start_no" id="ship_start_no" value="">
								<span class="input-group-addon no-bg">-</span>
								<input type="text" name="ship_start_text" id="ship_start_text" value="">
							</div>
						</div>
					</div>
					<div class="form-group" id="item-ship_start_nos">
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32726.Ürün Seri Nolar'></label>
						<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
							<textarea name="ship_start_nos" id="ship_start_nos" style="width:150px;height:50px;"></textarea>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
				<cf_box_footer>
					<cf_workcube_buttons type_format='1' is_upd='0' add_function='chk_form()'>
				</cf_box_footer>
			</div>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function chk_form()
{
		if(document.getElementById('product_name').value== "")
		{
			alert("<cf_get_lang dictionary_id='45986.Ürün Girmelisiniz'>!");
			return false;
		}
		
		if(document.getElementById('department_name').value== "")

		{
			alert("<cf_get_lang dictionary_id='57572.Departman'>-<cf_get_lang dictionary_id='45248.Lokasyon Girmelisiniz'> !");
			return false;
		}
		
		if(document.getElementById('guarantycat_id').value== "")
		{
			alert("<cf_get_lang dictionary_id='60223.Alış Garanti Kategorisi Girmelisiniz'>!");
			return false;
		}	
		
		if(document.getElementById('sale_guarantycat_id').value== "")
		{
			alert("<cf_get_lang dictionary_id='60224.Satış Garanti Kategorisi Girmelisiniz'>!");
			return false;
		}	
		
		if(document.getElementById('ship_start_no').value== "")
		{
			alert("<cf_get_lang dictionary_id ='33855.Seri No Başlangıç Girmelisiniz'>!");
			return false;
		}	
	
	
	return true;
}

//function kontrol(gelen)
	//if (gelen == 0)
//	{
//		ardisik.style.display = "";
//		tek_tek.style.display = "none";
//	}
//	else
//	{
//		ardisik.style.display = "none";
//		tek_tek.style.display = "";
//	}

</script>
