<table>
  <tr>
  	<td valign="top">
	<table>
	  <tr>
		<td><cf_get_lang dictionary_id='57480.Başlık'> *</td>
		<td colspan="3">
		  <cfsavecontent variable="message"><cf_get_lang dictionary_id='38560.Başlık girmelisiniz'></cfsavecontent>	
		  <cfinput type="text" name="ORDER_HEAD"  value="#get_pro_material_detail.PRO_MATERIAL_NO#" required="Yes" message="#message#" maxlength="100" style="width:353px;">
		</td>
		<td><cf_get_lang dictionary_id="58859.Süreç"></td>
		<td><cf_workcube_process is_upd='0' process_cat_width='140' is_detail='0'></td> 
		<td><cf_get_lang dictionary_id='57629.açıklama'></td>
		<td rowspan="3">
		  <textarea name="order_detail" id="order_detail" style="width:135px;height:65px;"><cfoutput>#get_pro_material_detail.DETAIL#</cfoutput></textarea>
		</td>
	  </tr>
	  <tr>
		<td width="70"><cf_get_lang dictionary_id='57519.Cari Hesap'> *</td>
		<td width="190">
 		  <cfif len(get_pro_material_detail.partner_id)>
			<cfset attributes.partner_id = get_pro_material_detail.partner_id>
		  <cfelseif len(listsort(get_pro_material_detail.offer_to_partner,'Numeric'))>
			<cfset attributes.partner_id = listfirst(listsort(get_pro_material_detail.offer_to_partner,'Numeric'))>
		  </cfif>
		  <cfif len(get_pro_material_detail.company_id)>
		  	<cfset company = get_par_info(get_pro_material_detail.company_id,1,0,0)>
		  <cfelse>
		  	<cfset company = "">						  
		  </cfif>
		  <cfset company_id = get_pro_material_detail.company_id>
		  <cfset partner = get_par_info(get_pro_material_detail.partner_id,0,-1,0)>
		  <input type="text" name="company" id="company" style="width:150px;"  value="<cfoutput>#company#</cfoutput>" readonly>
		  <cfset str_linkeait="&field_paymethod_id=form_basket.pay_method_id&field_paymethod=form_basket.pay_method&field_basket_due_value=form_basket.basket_due_value&ship_method_id=form_basket.ship_method_id&ship_method_name=form_basket.ship_method_name">
		  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars#str_linkeait#&field_comp_id=form_basket.company_id&field_comp_name=form_basket.company&field_id=form_basket.partner_id&field_name=form_basket.emp_name&select_list=7</cfoutput>','list')"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a><!--- TolgaS 20060729: 20060727 tarihine döndük dosyada ve ,8 vardı kaldırdım --->
		</td>
		<td width="70"><cf_get_lang dictionary_id='29501.Sipariş Tarihi'> *</td>
		<td width="160">
		  <cfsavecontent variable="message"><cf_get_lang dictionary_id='38654.Sipariş Tarihi Girmelisiniz'>!</cfsavecontent>
		  <cfinput type="text" name="order_date" required="yes" value="" validate="#validate_style#" message="#message#" maxlength="10" style="width:65px;">
		  <cf_wrk_date_image date_field="order_date">
		</td>
		<td width="70"><cf_get_lang dictionary_id='58516.Ödeme Yöntemi'></td>
		<td width="170">
		 <input type="hidden" name="card_paymethod_id" id="card_paymethod_id" value="">
		<input type="hidden" name="commission_rate" id="commission_rate" value="">
		<input name="basket_due_value" id="basket_due_value" type="hidden" value="">	
		<input type="hidden" name="paymethod_id" id="paymethod_id" value="">
		<input type="text" name="pay_method" id="pay_method" value="" style="width:140px;">
		<cfset card_link="&field_card_payment_id=form_basket.card_paymethod_id&field_card_payment_name=form_basket.pay_method&field_commission_rate=form_basket.commission_rate">
		<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_paymethods&field_id=form_basket.paymethod_id&field_name=form_basket.pay_method&field_dueday=form_basket.basket_due_value#card_link#</cfoutput>','list');return false;"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
		</td>
	  </tr>
	  <tr>
		<td><cf_get_lang dictionary_id='57578.Yetkili'></td>
		<td>
		  <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#company_id#</cfoutput>">
		  <input type="text" name="emp_name" id="emp_name" style="width:150px;"  value="<cfoutput>#partner#</cfoutput>" readonly>
		  <input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_pro_material_detail.partner_id#</cfoutput>">
		<td><cf_get_lang dictionary_id='57645.Teslim Tarihi'></td>
		<td>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='38627.Teslim Tarihi Girmelisiniz'></cfsavecontent>
			<cfinput type="text" name="deliverdate" style="width:68px;" value="" validate="#validate_style#" maxlength="10" required="yes" message="#message#">		  
			<cf_wrk_date_image date_field="deliverdate">
		</td>
    	<td><cf_get_lang dictionary_id='38626.Aksiyon'></td>
    	<td>
		  <input type="hidden" name="catalog_id" id="catalog_id" value="">
	  	  <input type="text" name="catalog_name" id="catalog_name" value="" style="width:135px;">
	  	  <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_catalog_promotion&field_id=form_basket.catalog_id&field_name=form_basket.catalog_name</cfoutput>','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
		</td>
	  </tr>
	  <tr>
	  	<td><cf_get_lang dictionary_id='58796.Sipariş Veren'></td>
    	<td>
		  <input type="hidden" name="order_employee_id" id="order_employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
	  	  <input type="text" name="order_employee" id="order_employee" readonly="" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>" style="width:150px;">
      	  <a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&select_list=1&field_name=form_basket.order_employee&field_emp_id2=form_basket.order_employee_id</cfoutput>','list')"><img src="/images/plus_thin.gif" title="<cf_get_lang dictionary_id='57734.seçiniz'>" border="0"></a>
		</td>		 
		<td><cf_get_lang dictionary_id='38530.Partner Portal'></td>
		<td>
		  <cfinput type="text" name="PUBLISHDATE" style="width:65px;"  value="" validate="#validate_style#" maxlength="10" message="Yayın Tarihi !">
		  <cf_wrk_date_image date_field="PUBLISHDATE">
		  <input type="checkbox" name="INVISIBLE" id="INVISIBLE"><cf_get_lang dictionary_id='29479.Yayın'>
		</td>
		<td><cf_get_lang dictionary_id='29500.Sevk'></td>
    	<td> 
			<input type="hidden" name="ship_method_id" id="ship_method_id" value="">
			<input type="text" name="ship_method_name" id="ship_method_name" style="width:140px;" value="" >
			<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_methods&field_name=ship_method_name&field_id=ship_method_id','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a> 		
		</td>
		<td><cf_get_lang dictionary_id='57416.Proje'></td>
		<td>
		  <input type="hidden" name="project_id" id="project_id"  value="<cfoutput>#get_pro_material_detail.PROJECT_ID#</cfoutput>" >
		  <input type="text" name="project_head" id="project_head" style="width:135px;"  value="<cfif LEN(get_pro_material_detail.PROJECT_ID)><cfoutput>#GET_PROJECT_NAME(get_pro_material_detail.PROJECT_ID)#</cfoutput></cfif>" readonly>
		  <a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=form_basket.project_id&project_head=form_basket.project_head');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
		</td>
	  </tr>
	  <tr>
		<td>Referans</td>
		<td>
		 <input type="text" name="ref_no" id="ref_no" value="" maxlength="50" style="width:150px;">
			<!---PK 14032006 30güne silinsin <td><cf_get_lang dictionary_id='88.Onay Verecek Yetkili'></td>
			<td>
			<input type="hidden" name="position_code" value="">
			<input type="text" name="position" style="width:125px;" value="" readonly>
		  	<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_basket.position_code&field_name=form_basket.position</cfoutput>','list')"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a> --->
		</td>
		<td><cf_get_lang dictionary_id='58449.Teslim Yeri'></td>
		<td colspan="4">
		  <!--- 20041231 basketteki depo dagilim bu inputun olmamasina bagli bu basket tanimlarinda parametreye baglanmali --->
		  <cfset str_link_dep = "objects.popup_list_stores_locations&form_name=form_basket&field_location_id=deliver_loc_id&field_name=deliver_dept_name&field_id=deliver_dept_id&branch_id=branch_id">	  
		  <cfsavecontent variable="message"><cf_get_lang dictionary_id='38680.Teslim Yeri Seçmelisiniz'></cfsavecontent>
		  <cfinput type="text" name="deliver_dept_name" value="" required="yes" message="#message#" style="width:140px;" passthrough="readonly=yes">
		  <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=#str_link_dep#</cfoutput>','list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
		  <input type="hidden" name="deliver_dept_id" id="deliver_dept_id" value="">
		  <input type="hidden" name="deliver_loc_id" id="deliver_loc_id" value="">
		  <input type="hidden" name="branch_id" id="branch_id" value="">
		</td>
	  	<td><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
	  </tr>
	</table>
  	</td>
  </tr>
</table>
