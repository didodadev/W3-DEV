<!--- Sayfa ;
		1-Toplu siparis yapabilmek icin,
		Firma adina, stok durumuna gore ,tum depolara gore urunleri listelemek ve siparis sayfasina yonlendirmek icin kullanılır.
		2-Satış siparisindeki ürünler için satınalma siparisi olusturmak icin kullanılır. 
		3- satınalma siparisini satis siparisine donusturur satıs modulunde yansıması var dikkatli olunuz		
--->

<cf_get_lang_set module_name="purchase"><!--- sayfanin en altinda kapanisi var --->
<cf_xml_page_edit fuseact="purchase.add_order_product_all_criteria">
<cfparam name="attributes.category_name" default="">
<cfparam name="attributes.cat_id" default="">
<cfparam name="attributes.brand_id" default="">
<cfparam name="attributes.stock_control_type" default="">
<cfparam name="attributes.select_order_demand" default="1">

<cf_catalystHeader>
	<cfif attributes.select_order_demand eq 0 or isdefined("attributes.from_purchase_order") or isdefined("attributes.from_sale_order")><!--- eğer xml den sipariş seçilerek oluşturulsun seçilmemişse ve sipariş detayından gelmiyorsa--->
		<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
			<cfquery name="GET_ORDER_DETAIL" datasource="#dsn3#">
				SELECT 
					ORDER_ID,
	                ORDER_NUMBER,
	                ORDER_DETAIL,
	                PROJECT_ID,
	                SHIP_ADDRESS,
	                DELIVERDATE
				FROM 
					ORDERS 
				WHERE 
					ORDER_ID = #attributes.order_id# 
					<cfif isdefined("attributes.from_sale_order") and attributes.from_sale_order eq 1>
						AND	
						(
							(PURCHASE_SALES = 1 AND ORDER_ZONE = 0)  
						OR
							(PURCHASE_SALES = 0 AND ORDER_ZONE = 1)
						) 
					<cfelseif isdefined("attributes.from_purchase_order") and attributes.from_purchase_order eq 1>
						AND	
						(
							(PURCHASE_SALES = 0 AND ORDER_ZONE = 0)  
						) 
					</cfif>
			</cfquery>
			<cfset attributes.project_id =  GET_ORDER_DETAIL.PROJECT_ID>
		</cfif>
		<cfif isdefined("attributes.from_purchase_order") and attributes.from_purchase_order eq 1>
	        <cfset fuseact_ = "sales.list_order&event=add&upd_order=1">
	    <cfelseif session.ep.isBranchAuthorization>
	        <cfset fuseact_ = "purchase.list_order&event=fromSaleOrder&upd_order=1">
	    <cfelse>
	        <cfset fuseact_ = "purchase.list_order&event=fromSaleOrder">
		</cfif>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cf_box>
				<cfform name="add_order" action="#request.self#?fuseaction=#fuseact_#">
					<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.order_id") and len(attributes.order_id) and isdefined("attributes.project_id") and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
					<cf_box_elements>
						<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-comp_name">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.order_id") and len(attributes.order_id) and isdefined("attributes.consumer_id") and len(attributes.consumer_id)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
										<input type="hidden" name="comp_id" id="comp_id" value="<cfif isdefined("attributes.order_id") and len(attributes.order_id) and isdefined("attributes.comp_id") and len(attributes.comp_id)><cfoutput>#attributes.comp_id#</cfoutput></cfif>">
										<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.order_id") and len(attributes.order_id) and isdefined("attributes.partner_id") and len(attributes.partner_id)><cfoutput>#attributes.partner_id#</cfoutput></cfif>">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='38619.Uye Cari Hesap Girmelisiniz'> !</cfsavecontent>	
										<cfinput name="comp_name" id="comp_name" type="text" required="yes"  message="#message#" value="" style="width:150px;">
										<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2&field_name=add_order.partner_name&field_partner=add_order.partner_id&field_comp_name=add_order.comp_name&field_comp_id=add_order.comp_id&field_consumer=add_order.consumer_id</cfoutput>','list')"></span>
									</div>
								</div>
							</div>
							<cfif isdefined("attributes.order_id") and len(attributes.order_id) and isdefined("attributes.partner_id") and len(attributes.partner_id)>
								<cfset my_partner_name = get_par_info(attributes.partner_id,0,-1,0)>
							</cfif>
							<div class="form-group" id="item-partner_name">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57578.Yetkili'> *</label>
								<div class="col col-8 col-xs-12">
									<input type="text" name="partner_name" id="partner_name" value="<cfif isdefined("my_partner_name")><cfoutput>#my_partner_name#</cfoutput></cfif>" readonly style="width:150px;">
								</div>
							</div>
							<div class="form-group" id="item-deliver_loc_id">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58763.Depo'>*</label>
								<div class="col col-8 col-xs-12">
									<cf_wrkDepartmentlocation
									returnInputValue="deliver_loc_id,deliver_dept_name,deliver_dept_id,branch_id"
									returnQueryValue="LOCATION_ID,LOCATION_NAME,DEPARTMENT_ID,BRANCH_ID"
									fieldName="deliver_dept_name"
									fieldId="deliver_loc_id"
									department_fldId="deliver_dept_id"
									branch_fldId="branch_id"
									user_level_control="#session.ep.OUR_COMPANY_INFO.IS_LOCATION_FOLLOW#"
									width="150">
								</div>
							</div>
							<div class="form-group" id="item-deliverdate">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57645.Teslim Tarihi'>*</label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
											<cfset deliver_date =dateformat(GET_ORDER_DETAIL.DELIVERDATE,dateformat_style)>
										<cfelse>
											<cfset deliver_date=''>
										</cfif>
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='38627.Teslim Tarihi Girmelisiniz'></cfsavecontent>
										<cfinput type="text" name="deliverdate" id="deliverdate" value="#deliver_date#" validate="#validate_style#" maxlength="10" required="yes" message="#message#" style="width:150px;">
										<span class="input-group-addon"><cf_wrk_date_image date_field="deliverdate"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-related_order_no">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='38696.Referans Sipariş'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
									<!--- satıs siparisinden sayfaya gelindiginde order_id de gonderiliyor --->
										<input type="hidden" name="related_order_id" id="related_order_id" value="<cfif isdefined('attributes.order_id') and len(attributes.order_id)><cfoutput>#GET_ORDER_DETAIL.ORDER_ID#</cfoutput></cfif>">
										<input type="text" name="related_order_no" id="related_order_no"  value="<cfif isdefined('attributes.order_id') and len(attributes.order_id)><cfoutput>#GET_ORDER_DETAIL.ORDER_NUMBER#</cfoutput></cfif>" readonly style="width:150px;">
										<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_orders_list&field_id=add_order.related_order_id&field_name=add_order.related_order_no</cfoutput>','list');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-order_employee">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57544.Sorumlu'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="order_employee_id" id="order_employee_id">
										<input type="text" name="order_employee" id="order_employee" readonly style="width:150px;">
										<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_order.order_employee_id&field_name=add_order.order_employee</cfoutput>','list');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-order_detail">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Aciklama'></label>
								<div class="col col-8 col-xs-12">
									<textarea name="order_detail" id="order_detail" style="width:150px;height:45px;"></textarea>
								</div>
							</div>
							<cfif not (isdefined("attributes.from_purchase_order") and attributes.from_purchase_order eq 1)>
								<div class="form-group" id="item-stock_control_type">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57564.Ürünler'></label>
								<div class="col col-8 col-xs-12">
									<select name="stock_control_type" id="stock_control_type" style="width:150px;"  onchange="change_stock_control_type();">
										<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
										<option value="1" <cfif isdefined("attributes.stock_control_type") and attributes.stock_control_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='38701.Tüm Siparişlerde Rezerve'></option>
										<option value="2" <cfif isdefined("attributes.stock_control_type") and attributes.stock_control_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='38702.Yeniden Sipariş Noktası'></option>
										<option value="3" <cfif isdefined("attributes.stock_control_type") and attributes.stock_control_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='38703.Toplam Bekleyen'></option>
										<option value="4" <cfif isdefined("attributes.stock_control_type") and attributes.stock_control_type eq 4>selected</cfif>><cf_get_lang dictionary_id ='38538.Max Stoğa Göre Sipariş Verme'></option>
									</select>
								</div>
							</div>
								<cfif attributes.stock_control_type neq 4>
									<div class="form-group" style="display:none;" id="is_category_name">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57486.Kategori'></label>
										<div class="col col-8 col-xs-12">
											<div class="input-group">
												<input type="hidden" name="cat_id" id="cat_id" value="<cfif len(attributes.cat_id) and len(attributes.category_name)><cfoutput>#attributes.cat_id#</cfoutput></cfif>">
												<input type="text" name="category_name" id="category_name" style="width:150px;" onfocus="AutoComplete_Create('category_name','PRODUCT_CAT,HIERARCHY','PRODUCT_CAT_NAME','get_product_cat','','HIERARCHY','cat_id','','3','200','','1');" value="<cfif len(attributes.category_name)><cfoutput>#attributes.category_name#</cfoutput></cfif>" autocomplete="off">
												<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_cat_names&is_sub_category=1&field_code=add_order.cat_id&field_name=add_order.category_name</cfoutput>','list');"></span>
											</div>
										</div>
									</div>
								</cfif>
								<cfif attributes.stock_control_type neq 4>
									<div class="form-group" style="display:none;" id="is_brand_id">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58847.Marka'></label>
										<div class="col col-8 col-xs-12">
											<cf_wrkProductBrand
											width="150"
											compenent_name="getProductBrand"               
											boxwidth="240"
											boxheight="150"
											brand_ID="#attributes.brand_id#">
										</div>
									</div>
								</cfif>
								<div class="form-group" id="item-is_real_stock">
									<label class="col col-8 col-xs-12" style="float:right;">
										<input type="checkbox" name="is_real_stock" id="is_real_stock" value="1"><cf_get_lang dictionary_id ='38704.Eldeki Stoğu Düş'>   
									</label>
								</div>
								<div class="form-group" id="item-order_stage_products">
									<label class="col col-8 col-xs-12" style="float:right;">
										<input type="checkbox" name="order_stage_products" id="order_stage_products" value="1"><cf_get_lang dictionary_id='38698.Referans Siparişteki Tedarik Aşamasındaki Ürünler'>
									</label>
								</div>
							</cfif>
							<cfif isdefined("attributes.order_id") and len(attributes.order_id)>
								<cfif isdefined("attributes.from_sale_order") and attributes.from_sale_order eq 1>
									<div class="form-group" id="item-order_all_products">
										<label class="col col-8 col-xs-12" style="float:right;">
											<input type="checkbox" name="order_all_products" id="order_all_products" value="1"><cf_get_lang dictionary_id='38697.Referans Siparişteki Tedarikçisi Olunan Ürünler'>
										</label>
									</div>	
								</cfif>
							<cfelse>
								<input type="hidden" name="order_all_products" id="order_all_products" value="">
							</cfif>
						</div>
					</cf_box_elements>
					<cf_box_footer>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='58126.Devam'></cfsavecontent>
						<cfsavecontent variable="message_2"><cf_get_lang dictionary_id='58587.Devam Etmek Istediğinizden Eminmisiniz'></cfsavecontent>
						<cf_workcube_buttons is_upd="0" insert_info='#message#' insert_alert="#message_2#" add_function='control()'>
					</cf_box_footer>
				</cfform>  
			</cf_box>
		</div>
		<script type="text/javascript">
			function control()
			{
				if(document.add_order.stock_control_type != undefined && document.add_order.stock_control_type.value == 4 && document.add_order.brand_id!=undefined && document.add_order.brand_id.value == '')
				{
					alert("<cf_get_lang dictionary_id='58946.Marka Seçmelisiniz'> !");
					return false;
				}
				if(document.getElementById('deliver_loc_id').value=='')
				{
					alert("<cf_get_lang dictionary_id='38664.Teslim yeri Seçiniz'> !");
					return false;
				}
				document.getElementById('add_order').submit();
				return true;
			}
			function change_stock_control_type()
			{
				if(document.add_order.stock_control_type.value == 4)
				{
					is_category_name.style.display = '';
					is_brand_id.style.display = '';
				}
				else
				{
					is_category_name.style.display = 'none';
					is_brand_id.style.display = 'none';
				}
			}
		</script>
	<cfelse>
		<cfinclude template="list_orders_internaldemands.cfm">
	</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
