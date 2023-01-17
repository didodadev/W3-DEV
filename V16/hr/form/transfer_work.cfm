<cf_get_lang_set module_name="myhome">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="30962.Pozisyon Görevi Aktar"></cfsavecontent>
<div class="col col-10 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#message#">
		<cfform action="#request.self#?fuseaction=hr.emptypopup_transfer_work" method="post" name="form_work_transfer">
		<cf_box_elements>
			<div class="col col-6 col-md-6 col-sm-6 col-xs-12" type="column" index="1"> 
				<div class="form-group" id="item-position_name">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31114.Görevleri Aktarılacak Pozisyon'>*</label>
					<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
						<!--- EMP_ID'ye göre çalışıyor.--->
						<cfif isdefined("attributes.old_emp_id") and len(attributes.old_emp_id)>
							<input type="hidden" id="old_emp_id" value="<cfoutput>#attributes.old_emp_id#</cfoutput>" name="old_emp_id">
							<input type="hidden" id="old_position_code" value="<cfoutput>#attributes.old_position_code#</cfoutput>" name="old_position_code">					
							<cfoutput> #session.ep.position_name# - #session.ep.name# #session.ep.surname# </cfoutput>
						<cfelse>
							<div class="input-group">
								<input type="hidden" value="" name="old_emp_id" id="old_emp_id">
								<input type="hidden" value="" name="old_position_code" id="old_position_code">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='31114.Görevleri Aktarılacak Pozisyon '></cfsavecontent>
								<cfinput type="text" name="old_emp_name" id="old_emp_name" value="" readonly="yes" required="yes" message="#message#">
								<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_work_transfer.old_position_code&field_emp_id=form_work_transfer.old_emp_id&select_list=1&field_name=form_work_transfer.old_emp_name</cfoutput>')"></span>
							</div>
						</cfif>
					</div>
				</div>
				<div class="form-group" id="item-position_code">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='41314.Görevleri Devralacak Pozisyon'>*</label>
					<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
						<input type="hidden" name="emp_id" id="emp_id" value="">
						<input type="hidden" name="position_code"  id="position_code" value="">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57471.Eksik Veri'>: <cf_get_lang dictionary_id='41314.Görevleri Devralacak Pozisyon'></cfsavecontent>
						<cfinput type="text" name="position_name" id="position_name" value="" readonly="yes" required="yes" message="#message#" placeholder="#getLang('','Pozisyon Çalışanı','31006')# #getLang('','Seçiniz','57734')#">
					</div>
				</div>
				<div class="form-group" id="item-employee_name">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='31006.Pozisyon Çalışanı'></label>
					<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
						<div class="input-group">
							<input type="text" name="employee_name" id="employee_name" value="" readonly>
							<span class="input-group-addon icon-ellipsis btnPointer" href="javascript://" onclick="javascript:openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_code=form_work_transfer.position_code&field_emp_id=form_work_transfer.emp_id&field_pos_name=form_work_transfer.position_name&select_list=1&field_name=form_work_transfer.employee_name</cfoutput>');"></span>
						</div>
					</div>
				</div>               
				<div class="form-group" id="item-start_hour">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>*</label>
					<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
						<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='30623.Lütfen Başlangıç Tarihi Giriniz'>!</cfsavecontent>
								<cfinput maxlength="10" required="Yes" validate="#validate_style#" message="#message#" type="text" name="startdate" id="startdate">
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
							</div>
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
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
				<div class="form-group" id="item-finishdate">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
					<div class="col col-6 col-md-8 col-sm-8 col-xs-12">
						<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='52129.Bitiş Tarihi Giriniz!'></cfsavecontent>
								<cfinput maxlength="10" required="Yes" validate="#validate_style#" message="#message#" type="text" name="finishdate" id="finishdate">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
							</div>
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
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
				<div class="form-group" id="item-chexbox">
					<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='58538.Görev Tipi'></label>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<label><input type="checkbox" name="works" id="works" value="1"> <cf_get_lang dictionary_id='58020.İşler'></label>
						<label><input type="checkbox" name="service" id="service" value="1"> <cf_get_lang dictionary_id='57656.Servis'></label>
						<label><input type="checkbox" name="consumer"  id="consumer" value="1"><cf_get_lang dictionary_id ='31589.Üye Temsilcisi'></label>
						<label><input type="checkbox" name="offer_purchase" id="offer_purchase" value="1"> <cf_get_lang dictionary_id='31040.Satın Alma Teklifleri'></label>
					</div>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12">
						<label><input type="checkbox" name="sales_offer" id="sales_offer" value="1"><cf_get_lang dictionary_id='30007.Satış Teklifleri'></label>
						<label><input type="checkbox" name="opportunity" id="opportunity" value="1"><cf_get_lang dictionary_id='57612.Fırsat'> </label>
						<label><input type="checkbox" name="orders" id="orders" value="1"><cf_get_lang dictionary_id='57611.Sipariş'></label>
						<label><input type="checkbox" name="assetp"  id="assetp" value="1"><cf_get_lang dictionary_id='58833.Fiziki Varlık'></label>
					</div>
				</div>
			</div>
		</cf_box_elements>
		<cf_box_footer>
			<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
		</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
function kontrol()
{
	if(document.form_work_transfer.startdate.value != '' && document.form_work_transfer.finishdate.value != '' )
		{
			return date_check(form_work_transfer.startdate,form_work_transfer.finishdate,"<cf_get_lang dictionary_id='58862.Başlangıç Tarihi Bitiş Tarihinden Büyük Olamaz'> !");
		}
}
</script>
