
	<cf_box title="#getlang('','Ürün Kategori Sorumlusunu Değiştir','42956')#">
		
			<cfform name="work_product_cat" method="post" action="#request.self#?fuseaction=settings.upd_work_product_cat">
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="form-group">	
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41985.Görevi Aktarılacak Pozisyon'>*</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="old_position_code" id="old_position_code" value="">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='41985.Görevi Aktarılacak Pozisyon'></cfsavecontent>
									<cfinput type="text" name="old_position_name" id="old_position_name" value="" required="yes" message="#message#" >
									<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=work_product_cat.old_position_code&select_list=1&field_pos_name=work_product_cat.old_position_name&show_empty_pos=1</cfoutput>');"></span>
								</div>	
							</div>
						</div>
						<div class="form-group">	
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'>*</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="position_code" id="position_code" value="">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='58497.Pozisyon'></cfsavecontent>
									<cfinput type="text" name="position_name" value="" passthrough="readonly" required="yes" message="#message#" >
									<span class="input-group-addon icon-ellipsis" onclick="javascript:openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=work_product_cat.position_code&field_pos_name=work_product_cat.position_name&select_list=1&field_name=work_product_cat.employee_name</cfoutput>');"></span> 
								</div>	
							</div>
						</div>

						<div class="form-group">	
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='56069.Pozisyon Çalışanı'></label>
							<div class="col col-8 col-xs-12">
									<input type="text" name="employee_name" id="employee_name" value="" readonly>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons add_function="kontrol()">
				</cf_box_footer>          
			</cfform>
	</cf_box>

	<cf_box title="#getlang('','Ürün Tedarikçisi Değiştir','42958')#">
		<cfform name="work_product_comp" method="post" action="#request.self#?fuseaction=settings.upd_prod_company">
			<cf_box_elements>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<div class="form-group">	
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42959.Görevi Aktarılacak Tedarikçi'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="old_company_id" id="old_company_id" value="">
								<cfinput type="text" name="old_company" id="old_company" value="" required="yes" message="#getLang('','Eksik Veri','57471')#: #getLang('','Görevi Aktarılacak Tedarikçi','42959')#">
								<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=work_product_comp.old_company_id&field_comp_name=work_product_comp.old_company&select_list=2&keyword=</cfoutput>');"></span>
							</div>	
						</div>
					</div>
					<div class="form-group">	
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29533.Tedarikçi'>*</label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<input type="hidden" name="comp_id" id="comp_id" value="">
								<cfinput type="text" name="comp" id="comp" value="" required="yes" message="#getLang('','Eksik Veri','57471')#: #getLang('','Tedarikçi','29533')#">
								<span class="input-group-addon icon-ellipsis"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=work_product_comp.comp_id&field_comp_name=work_product_comp.comp&select_list=2&keyword=</cfoutput>');"></span>
							</div>	
						</div>
					</div>
				</div>
				<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
					<div class="form-group" >	
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'>*</label>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'>!</cfsavecontent>
									<cfinput maxlength="10" required="Yes" validate="#validate_style#" message="#message#" type="text" name="startdate" id="startdate">
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
							</div>
						</div>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<div class="input-group">
								<cfoutput>
									<select name="start_hour" id="start_hour">
										<cfloop from="0" to="23" index="i">
											<option value="#i#" <cfif i eq 0>selected</cfif>>#i#:00</option>
										</cfloop>
									</select>
								</cfoutput>
							</div>
						</div>
					</div>

					<div class="form-group" >	
						<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
								<cfinput maxlength="10" required="Yes" validate="#validate_style#" message="#message#" type="text" name="finishdate" id="finishdate">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
							</div>
						</div>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
							<div class="input-group">
								<cfoutput>
									<select name="finish_hour" id="finish_hour">
										<cfloop from="0" to="23" index="i">
											<option value="#i#" <cfif i eq 0>selected</cfif>>#i#:00</option>
										</cfloop>
									</select>
								</cfoutput>
							</div>
						</div>
					</div>
				</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons add_function="kontrol()">
		</cf_box_footer>          
	</cfform>
</cf_box>

<cf_box title="#getlang('','Ürün Sorumlusunu Değiştir','42961')#">
		<cfform name="product_work" method="post" action="#request.self#?fuseaction=settings.upd_product_work">
		<cf_box_elements>
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
				<div class="form-group">	
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='41985.Görevi Aktarılacak Pozisyon'>*</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" value="" name="old_position_code2" id="old_position_code2">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='41985.Görevi Aktarılacak Pozisyon'></cfsavecontent>
							<cfinput type="text" name="old_position_name2" id="old_position_name2" value="" required="yes" message="#message#">
							<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=product_work.old_position_code2&select_list=1&field_pos_name=product_work.old_position_name2&show_empty_pos=1</cfoutput>')"></span>
						</div>	
					</div>
				</div>

				<div class="form-group">	
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'>*</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="position_code2" id="position_code2" value="">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>:<cf_get_lang dictionary_id='58497.Pozisyon'></cfsavecontent>
							<cfinput type="text" name="position_name2" id="position_name2" value="" passthrough="readonly" required="yes" message="#message#">
							<span class="input-group-addon icon-ellipsis" onclick="javascript:openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=product_work.position_code2&field_pos_name=product_work.position_name2&select_list=1&field_name=product_work.employee_name</cfoutput>');"></span>
						</div>	
					</div>
				</div>

				<div class="form-group">	
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42535.Pozisyon Çalışanı'></label>
					<div class="col col-8 col-xs-12">
						<input type="text" name="employee_name" id="employee_name" value=""  readonly>	
					</div>
				</div>

			</div>
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
				<div class="form-group" >	
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'>*</label>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57738.Başlangıç Tarihi Girmelisiniz'>!</cfsavecontent>
								<cfinput name="startdate_" id="startdate_" maxlength="10" required="Yes" validate="#validate_style#" message="#message#" type="text">
							<span class="input-group-addon"><cf_wrk_date_image date_field="startdate_"></span>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="input-group">
							<cfoutput>
								<select name="start_hour" id="start_hour">
									<cfloop from="0" to="23" index="i">
										   <option value="#i#" <cfif i eq 0>selected</cfif>>#i#:00</option>
									</cfloop>
								</select>
							</cfoutput>
						</div>
					</div>
				</div>

				<div class="form-group" >	
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="input-group">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id='57739.Bitiş Tarihi Girmelisiniz'>!</cfsavecontent>
								<cfinput maxlength="10" required="Yes" validate="#validate_style#" message="#message#" type="text" name="finishdate_" id="finishdate_">
								
								<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate_"></span>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<div class="input-group">
							<cfoutput>
								<select name="finish_hour" id="finish_hour">
								   <cfloop from="0" to="23" index="i">
									 <option value="#i#" <cfif i eq 0>selected</cfif>>#i#:00</option>
								   </cfloop>
							   </select>
							 </cfoutput>
						</div>
					</div>
				</div>
			</div>
	
	</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons add_function="kontrol()">
		</cf_box_footer>          
		
	</cfform>
</cf_box>

<cf_box title="#getlang('','Aktif Fırsatlar Satış Çalışanını Değiştir','42962')#">
		<cfform name="form_sales_position" method="post" action="#request.self#?fuseaction=settings.upd_transfer_opp">
		<cf_box_elements>
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
				<div class="form-group">	
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42963.Görevi Aktarılacak Satış Çalışan'>*</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="old_sales_position_code" id="old_sales_position_code" value="">
							<cfinput type="text" name="old_sales_position" id="old_sales_position" value="" required="yes" message="#getLang('','Eksik Veri','57471')#: #getLang('','Görevi Aktarılacak Satış Çalışan','42963')#">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_sales_position.old_sales_position_code&field_name=form_sales_position.old_sales_position&select_list=1,2,3,4');"></span>
						</div>	
					</div>
				</div>
				<div class="form-group">	
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42964.Satış Çalışan'>*</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="sales_position_code" id="sales_position_code" value="">
							<cfinput type="text" name="sales_position" id="sales_position" value="" required="yes" message="#getLang('','Eksik Veri','57471')#: #getLang('','Satış Çalışan','42964')#">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=form_sales_position.sales_position_code&field_name=form_sales_position.sales_position&select_list=1,2,3,4');"></span>
						</div>	
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons add_function="kontrol()">
		</cf_box_footer>          
	</cfform>
</cf_box>

<cf_box title="#getlang('','Aktif Siparişler Satış Çalışanını Değiştir','42965')#">
		<cfform name="form_sal_pos" method="post" action="#request.self#?fuseaction=settings.upd_sales_pos_code">
		<cf_box_elements>
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
				<div class="form-group">	
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42963.Görevi Aktarılacak Satış Çalışan'>*</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="old_sal_pos_code" id="old_sal_pos_code" value="">
							<cfinput type="text" name="old_sal_pos" id="old_sal_pos" value="" required="yes" message="#getLang('','Eksik Veri','57471')#: #getLang('','Görevi Aktarılacak Satış Çalışan','42963')#">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_sal_pos.old_sal_pos_code&field_name=form_sal_pos.old_sal_pos&select_list=1,2,3,4');"></span>
						</div>	
					</div>
				</div>

				<div class="form-group">	
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42964.Satış Çalışan'>*</label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="sal_pos_code" id="sal_pos_code" value="">
							<cfinput type="text" name="sal_pos" id="sal_pos" value="" required="yes" message="#getLang('','Eksik Veri','57471')#: #getLang('','Satış Çalışan','42964')#">
							<span class="input-group-addon icon-ellipsis"  onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_sal_pos.sal_pos_code&field_name=form_sal_pos.sal_pos&select_list=1,2,3,4');"></span>
						</div>	
					</div>
				</div>
			</div>
	</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons add_function="kontrol()">
		</cf_box_footer>          
	</cfform>
</cf_box>

<cf_box title="#getlang('','Aktif Teklifler Satış Çalışanını Değiştir','42966')#">
		<cfform name="form_offer_sal_pos" method="post" action="#request.self#?fuseaction=settings.upd_offer_pos_code">
		<cf_box_elements>
			<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
				<div class="form-group">	
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42963.Görevi Aktarılacak Satış Çalışan'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="old_offer_pos_code" id="old_offer_pos_code" value="">
							<cfinput type="text" name="old_offer_pos" id="old_offer_pos" value=""  required="yes" message="#getLang('','Eksik Veri','57471')#: #getLang('','Görevi Aktarılacak Satış Çalışan','42963')#">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_offer_sal_pos.old_offer_pos_code&field_name=form_offer_sal_pos.old_offer_pos&select_list=1,2,3,4');"></span>
						</div>	
					</div>
				</div>
				<div class="form-group">	
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='42964.Satış Çalışan'></label>
					<div class="col col-8 col-xs-12">
						<div class="input-group">
							<input type="hidden" name="offer_pos_code" id="offer_pos_code" value="">
							<cfinput type="text" name="offer_pos" id="offer_pos" value="" required="yes" message="#getLang('','Eksik Veri','57471')#: #getLang('','Satış Çalışan','42964')#">
							<span class="input-group-addon icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_offer_sal_pos.offer_pos_code&field_name=form_offer_sal_pos.offer_pos&select_list=1,2,3,4');"></span>
						</div>	
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons add_function="kontrol()">
		</cf_box_footer>          
	</cfform>
</cf_box>

