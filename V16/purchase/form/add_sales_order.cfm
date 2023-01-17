<!--- Sayfa ;
		1-Toplu siparis yapabilmek icin,
		Firma adina, stok durumuna gore ,tum depolara gore urunleri listelemek ve siparis sayfasina yonlendirmek icin kullanılır.
		2-Satış siparisindeki ürünler için satınalma siparisi olusturmak icin kullanılır. --->
<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
	<cfquery name="GET_ORDER_DETAIL" datasource="#dsn3#">
		SELECT 
			* 
		FROM 
			ORDERS 
		WHERE 
			ORDER_ID=#attributes.order_id# 
			AND	
			(
				(PURCHASE_SALES = 1 AND ORDER_ZONE = 0)  
			OR
			 	(PURCHASE_SALES = 0 AND ORDER_ZONE = 1)
			) 
	</cfquery>
	<cfset attributes.project_id =  GET_ORDER_DETAIL.PROJECT_ID>
</cfif>
<table width="98%" border="0" cellspacing="0" cellpadding="0" height="35" align="center">
	<tr>
		<td class="headbold"><cf_get_lang dictionary_id='38614.Toplu Sipariş'></td>
	</tr>
</table>
<table width="98%" border="0" cellspacing="1" cellpadding="2" class="color-border" align="center">
	<tr>
		<td class="color-row" valign="top">
			<table>
			<cfform name="add_order" action="#request.self#?fuseaction=purchase.add_product_all_order">
			<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.order_id") and len(attributes.order_id) and isdefined("attributes.project_id") and len(attributes.project_id)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
			<tr>
				<td width="100"><cf_get_lang dictionary_id='57519.Cari Hesap'>*</td>
				<td colspan="2">
				<input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.order_id") and len(attributes.order_id) and isdefined("attributes.consumer_id") and len(attributes.consumer_id)><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
				<input type="hidden" name="comp_id" id="comp_id" value="<cfif isdefined("attributes.order_id") and len(attributes.order_id) and isdefined("attributes.comp_id") and len(attributes.comp_id)><cfoutput>#attributes.comp_id#</cfoutput></cfif>">
				<input type="hidden" name="partner_id" id="partner_id" value="<cfif isdefined("attributes.order_id") and len(attributes.order_id) and isdefined("attributes.partner_id") and len(attributes.partner_id)><cfoutput>#attributes.partner_id#</cfoutput></cfif>">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='38619.Uye Cari Hesap Girmelisiniz'> !</cfsavecontent>	
				<cfinput name="comp_name" type="text" required="yes"  message="#message#" value="" style="width:150px;">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2&field_name=add_order.partner_name&field_partner=add_order.partner_id&field_comp_name=add_order.comp_name&field_comp_id=add_order.comp_id&field_consumer=add_order.consumer_id</cfoutput>','list')">
				<img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
				</td>
			</tr>
			<tr>
				<cfif isdefined("attributes.order_id") and len(attributes.order_id) and isdefined("attributes.partner_id") and len(attributes.partner_id)>
					<cfset my_partner_name = get_par_info(attributes.partner_id,0,-1,0)>
				</cfif>
				<td><cf_get_lang dictionary_id='57578.Yetkili'> *</td>
				<td><input type="text" name="partner_name" id="partner_name" value="<cfif isdefined("my_partner_name")><cfoutput>#my_partner_name#</cfoutput></cfif>" readonly style="width:150px;"></td>
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='58449.Teslim Yeri'>*</td>
				<td>
				<cfset str_link_dep = "objects.popup_list_stores_locations&form_name=add_order&field_location_id=deliver_loc_id&field_name=deliver_dept_name&field_id=deliver_dept_id&branch_id=branch_id">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='38680.Teslim Yeri Seçmelisiniz '></cfsavecontent>
				<cfinput type="text" name="deliver_dept_name" value="" required="yes" message="#message#" style="width:150px;">
				<a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=#str_link_dep#</cfoutput>','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
				<input type="hidden" name="deliver_dept_id" id="deliver_dept_id" value="">
				<input type="hidden" name="deliver_loc_id" id="deliver_loc_id" value="">
				<input type="hidden" name="branch_id" id="branch_id" value="">
				</td>		  
			</tr>
			<tr>
				<td><cf_get_lang dictionary_id='57645.Teslim Tarihi'> *</td>
				<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
					<cfset deliver_date =dateformat(GET_ORDER_DETAIL.DELIVERDATE,dateformat_style)>
				<cfelse>
					<cfset deliver_date=''>
				</cfif>
				<td><cfsavecontent variable="message"><cf_get_lang dictionary_id='38627.Teslim Tarihi Girmelisiniz'></cfsavecontent>
				<cfinput type="text" name="deliverdate" value="#deliver_date#" validate="#validate_style#" maxlength="10" required="yes" message="#message#" style="width:150px;">
				<cf_wrk_date_image date_field="deliverdate"></td>
			</tr>
			</tr>
				<td><cf_get_lang dictionary_id='38696.Referans Sipariş'></td>
				<td>
				<!--- satıs siparisinden sayfaya gelindiginde order_id de gonderiliyor --->
				<input type="hidden" name="related_order_id" id="related_order_id" value="<cfif isdefined('attributes.order_id') and len(attributes.order_id)><cfoutput>#GET_ORDER_DETAIL.ORDER_ID#</cfoutput></cfif>">
				<input type="text" name="related_order_no" id="related_order_no"  value="<cfif isdefined('attributes.order_id') and len(attributes.order_id)><cfoutput>#GET_ORDER_DETAIL.ORDER_NUMBER#</cfoutput></cfif>" readonly style="width:150px;">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_orders_list&field_id=add_order.related_order_id&field_name=add_order.related_order_no</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
				</td>
			</tr>
			</tr>
				<td><cf_get_lang dictionary_id='57544.Sorumlu'></td>
				<td> <input type="hidden" name="order_employee_id" id="order_employee_id">
				<input type="text" name="order_employee" id="order_employee" readonly style="width:150px;">
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_order.order_employee_id&field_name=add_order.order_employee</cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
				</td>
			</tr>
			<tr>
				<td width="60"><cf_get_lang dictionary_id='57629.Aciklama'></td>
				<td rowspan="2">
				<textarea name="order_detail" id="order_detail" style="width:150px;height:45px;"><cfif isdefined('attributes.order_id') and len(attributes.order_id)><cfoutput>#GET_ORDER_DETAIL.SHIP_ADDRESS#</cfoutput></cfif></textarea>
			</tr>
			<tr>
				<td width="60"></td>
			</tr>
			<cfif isdefined('attributes.order_id') and len(attributes.order_id)>
				<!--- Eğer seçilirse sadece seçilen carinin tedarikçisi olduğu ürünler gelir--->
				<tr>
					<td><cf_get_lang dictionary_id='38697.Referans Siparişteki Tedarikçisi Olunan Ürünler'></td>
					<td><input type="checkbox" name="order_all_products" id="order_all_products" value="1"></td>
				</tr>
				<!--- Eğer seçilirse sadece tedarik aşamasında olan ürünler gelir--->
				<tr>
					<td><cf_get_lang dictionary_id='38698.Referans Siparişteki Tedarik Aşamasındaki Ürünler'></td>
					<td><input type="checkbox" name="order_stage_products" id="order_stage_products" value="1"></td>
				</tr>
			<cfelse>
				<!--- Toplu sipariş ekranından giderken her zaman tedarikçi kontrolü yapsın diye eklendi.--->
				<input type="hidden" name="order_all_products" id="order_all_products" value="">
			</cfif>
			<tr>
			<td><cf_get_lang dictionary_id ='57564.Ürünler'></td>
			<td>
				<select name="stock_control_type" id="stock_control_type" style="width:150px;">
					<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
					<option value="1" <cfif isdefined("attributes.stock_control_type") and attributes.stock_control_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='38701.Tüm Siparişlerde Rezerve'></option>
					<option value="2" <cfif isdefined("attributes.stock_control_type") and attributes.stock_control_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='38702.Yeniden Sipariş Noktası'></option>
					<option value="3" <cfif isdefined("attributes.stock_control_type") and attributes.stock_control_type eq 3>selected</cfif>><cf_get_lang dictionary_id ='38703.Toplam Bekleyen'></option>
				</select>
			</td>
			<tr>
			<td></td>
			<td><input type="checkbox" name="is_real_stock" id="is_real_stock" value="1"><cf_get_lang dictionary_id ='38704.Eldeki Stoğu Düş'> 
			</tr>
			<tr>
				<td></td>
				<td class="headbold"><cfsavecontent variable="message"><cf_get_lang dictionary_id='58126.Devam'></cfsavecontent>
				<cfsavecontent variable="message_2"><cf_get_lang dictionary_id='58587.Devam Etmek Istediğinizden Eminmisiniz'></cfsavecontent>
				<cf_workcube_buttons is_upd="0" insert_info='#message#' insert_alert="#message_2#">
				</td>
			</tr>
			</cfform>  
			</table>
		</td>
	</tr>
</table>
