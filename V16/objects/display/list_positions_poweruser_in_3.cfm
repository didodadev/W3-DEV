<cfparam name="attributes.modal_id" default="">
<cfform name="power_user" method="post" action="#request.self#?fuseaction=objects.emptypopup_upd_employee&id=add_options&employee_id=#attributes.employee_id#&position_id=#attributes.position_id#">
	<input type="hidden" name="page_type" id="page_type" value="<cfif isdefined('attributes.type') and len(attributes.type)><cfoutput>#attributes.type#</cfoutput></cfif>">
	<input type="hidden" name="auth_emps_pos" id="auth_emps_pos" value="">
	<cf_box_elements>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group">
				<label class="col col-2 col-xs-12"><input type="checkbox" name="discount_valid" id="discount_valid" value="1" <cfif get_hr.discount_valid eq 1>checked</cfif>></label>
				<div class="col col-8 col-xs-12"><cf_get_lang dictionary_id ='33741.Basketlerde İskonto Değişimi Yapmasın'></div>
			</div>
			<div class="form-group">
				<label class="col col-2 col-xs-12"><input type="checkbox" name="price_valid" id="price_valid" value="1" <cfif get_hr.price_valid eq 1>checked</cfif>></label>
				<div class="col col-8 col-xs-12"><cf_get_lang dictionary_id ='33742.Basketlerde Fiyat Değişimi Yapmasın'></div>
			</div>
			<div class="form-group">
				<label class="col col-2 col-xs-12"><input type="checkbox" name="price_display_valid" id="price_display_valid" value="1" <cfif get_hr.price_display_valid eq 1>checked</cfif>></label>
				<div class="col col-8 col-xs-12"><cf_get_lang dictionary_id ='33743.Basketlerde Fiyat ve Toplamı Görüntülemesin'></div>
			</div>
			<div class="form-group">
				<label class="col col-2 col-xs-12"><input type="checkbox" name="member_direct_denied" id="member_direct_denied" value="1" <cfif get_hr.member_direct_denied eq 1>checked</cfif>></label>
				<div class="col col-8 col-xs-12"><cf_get_lang dictionary_id ='32657.Üye Bilgilerine Doğrudan Erişemesin'></div>
			</div>
			<div class="form-group">
				<label class="col col-2 col-xs-12"><input type="checkbox" name="rate_valid" id="rate_valid" value="1" <cfif get_hr.rate_valid eq 1>checked</cfif>></label>
				<div class="col col-8 col-xs-12"><cf_get_lang dictionary_id='32468.Kurları Değiştiremesin'></div>
			</div>
		</div>
		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
			<div class="form-group">
				<label class="col col-2 col-xs-12"><input type="checkbox" name="consumer_priority" id="consumer_priority" value="1" <cfif get_hr.consumer_priority eq 1>checked</cfif>></label>
				<div class="col col-8 col-xs-12"><cf_get_lang dictionary_id ='33744.Bireysel Müşteri Listeleri Öncelikli'></div>
			</div>
			<div class="form-group">
				<label class="col col-2 col-xs-12"><input type="checkbox" name="member_view_control" id="member_view_control" value="1" <cfif get_hr.member_view_control eq 1>checked</cfif>></label>
				<div class="col col-8 col-xs-12"><cf_get_lang dictionary_id ='33745.Sadece Kendi Üyelerini Görebilir'></div>
			</div>
			<div class="form-group">
				<label class="col col-2 col-xs-12"><input type="checkbox" name="cost_display_valid" id="cost_display_valid" value="1" <cfif get_hr.cost_display_valid eq 1>checked</cfif>></label>
				<div class="col col-8 col-xs-12"><cf_get_lang dictionary_id ='34239.Basketlerde ve Üretim Sonucunda Maliyeti Görüntülemesin'></div>
			</div>
			<div class="form-group">
				<label class="col col-2 col-xs-12"><input type="checkbox" name="duedate_valid" id="duedate_valid" value="1" <cfif get_hr.duedate_valid eq 1>checked</cfif>></label>
				<div class="col col-8 col-xs-12"><cf_get_lang dictionary_id ='34255.Basketlerde Vade DEğişimi Yapmasın'></div>
			</div>
			<div class="form-group">
				<label class="col col-2 col-xs-12"><input type="checkbox" name="their_records_only" id="rate_valid" value="1" <cfif get_hr.their_records_only eq 1>checked</cfif>></label>
				<div class="col col-8 col-xs-12"><cf_get_lang dictionary_id='60126.Gündem Ekranında Sadece Kendi Kayıtlarını Görebilsin'>.</div>
			</div>
		</div>
	</cf_box_elements>
    <cf_box_footer>
		<cf_record_info query_name="get_position_detail">
		<cf_workcube_buttons is_upd="0" add_function="control()">
	</cf_box_footer>
</cfform>

<script>
	function control() {
		get_auth_emps(0,1,0);
		<cfif isdefined("attributes.draggable")>
			loadPopupBox('power_user' , <cfoutput>#attributes.modal_id#</cfoutput>)
		</cfif>
	}
</script>
