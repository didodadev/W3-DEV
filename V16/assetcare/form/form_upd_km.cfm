<cfparam name="employee_id" default="">
<cfparam name="is_detail" default="">
<cfinclude template="../query/get_km_upd.cfm">
<cfset  pageHead="#getLang('assetcare',374)# : #getLang('main',1656)# : #get_km_upd.assetp#">
<cf_catalystHeader>
<cfform name="upd_km" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_km&km_control_id=#attributes.km_control_id#">
	<input type="hidden" name="is_detail" id="is_detail" value="1">
	<input type="hidden" name="km_control_id" id="km_control_id" value="<cfoutput>#attributes.km_control_id#</cfoutput>">
	<div class="row">
        <div class="col col-12 uniqueRow">
            <div class="row formContent">
                <div class="row" type="row">
					<div class="row" type="row">
						<div class="col col-4 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-assetp_name">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='1656.Plaka'> *</label>
								<div class="col col-6 col-xs-12">
									<input type="hidden" name="assetp_id" id="assetp_id" value="<cfoutput>#get_km_upd.assetp_id#</cfoutput>">
									<input name="assetp_name" id="assetp_name" type="text" readonly value="<cfoutput>#get_km_upd.assetp#</cfoutput>">
								</div>
							</div>
							<div class="form-group" id="item-employee_name">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='132.Sorumlu'> *</label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<input name="employee_id" id="employee_id" type="hidden" value="<cfoutput>#get_km_upd.employee_id#</cfoutput>">
										<input type="text" name="employee_name" id="employee_name" value="<cfoutput>#get_emp_info(get_km_upd.employee_id,0,0)#</cfoutput>">
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=upd_km.employee_id&field_name=upd_km.employee_name&select_list=1</cfoutput>','list')"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-branch_name">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='41.Şube'> *</label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#get_km_upd.department_id#</cfoutput>">
										<input type="text" name="department" id="department" readonly value="<cfoutput>#get_km_upd.branch_name# - #get_km_upd.department_head#</cfoutput>" >
										<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=upd_km.department_id&field_name=upd_km.department','list');"></span>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-4 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-start_date">
								<label class="col col-4 col-xs-12"><cf_get_lang no='356.Önceki KM Tarihi'></label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
									<input name="start_date" id="start_date" type="text" value="<cfoutput>#dateformat(get_km_upd.start_date,dateformat_style)#</cfoutput>" readonly>
									<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-pre_km">
								<label class="col col-4 col-xs-12"><cf_get_lang no='357.Önceki KM'> </label>
								<div class="col col-6 col-xs-12">
									<input name="pre_km" id="pre_km" type="text" value="<cfoutput>#tlformat(get_km_upd.km_start,0)#</cfoutput>" readonly>
								</div>
							</div>
							<div class="form-group" id="item-detail">
								<label class="col col-4 col-xs-12"><cf_get_lang_main no='217.Açıklama'> </label>
								<div class="col col-6 col-xs-12">
									<input type="text" name="detail" id="detail" maxlength="200" value="<cfoutput>#get_km_upd.detail#</cfoutput>">
								</div>
							</div>
						</div>
						<div class="col col-4 col-xs-12" type="column" index="3" sort="true">
							<div class="form-group" id="item-finish_date">
								<label class="col col-4 col-xs-12"><cf_get_lang no='359.Son KM Tarihi'> *</label>
								<div class="col col-6 col-xs-12">
									<div class="input-group">
										<input type="text" name="finish_date" id="finish_date" value="<cfoutput>#dateformat(get_km_upd.finish_date,dateformat_style)#</cfoutput>">
										<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-last_km">
								<label class="col col-4 col-xs-12"><cf_get_lang no='219.Son KM '> *</label>
								<div class="col col-6 col-xs-12">
									<input type="text" name="last_km" id="last_km" value="<cfoutput>#tlformat(get_km_upd.km_finish,0)#</cfoutput>" onKeyup="return(FormatCurrency(this,event,0));">
								</div>
							</div>
							<div class="form-group" id="item-detail">
								<label class="col col-4 col-xs-12"><cf_get_lang no='358.Mesai Dışı'> </label>
								<div class="col col-6 col-xs-12">
									<input name="is_offtime" id="is_offtime" type="checkbox" value="1" <cfif get_km_upd.is_offtime eq 1>checked</cfif>>
								</div>
							</div>
						</div>
					</div>
				</div>
                <div class="row formContentFooter">
                    <div class="col col-12">
                        <cf_workcube_buttons type_format="1" is_upd='1' is_cancel='0' is_reset='0' add_function='kontrol()' delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_km&km_control_id=#attributes.km_control_id#&plaka=#get_km_upd.assetp#&assetp_id=#attributes.assetp_id#&is_detail=1'>
                    </div>
                </div>
            </div>
		</div>
    </div>
</cfform>

<script type="text/javascript">
function unformat_fields()
{
	$('#pre_km').val(filterNum($('#pre_km').val()));
	$('#last_km').val(filterNum($('#last_km').val()));
}
function km_kayit()
{
	window.opener.parent.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.form_add_km';
	window.close();
}
function kontrol()
{	
	if($('#assetp_name').val() == "")
	{
		alert("Plaka Girmelisiniz!");
		return false;
	}
	
	if($('#employee_name').val() == "")
	{
		alert("Sorumlu Girmelisiniz!");
		return false;
	}
	
	if($('#department').val == "")
	{
		alert("Şube Girmelisiniz!");
		return false;
	}
	
	if(!CheckEurodate(document.upd_km.start_date.value,'Başlangıç Tarihi'))
	{
		return false;
	}
	
	if(!CheckEurodate(document.upd_km.finish_date.value,'Bitiş Tarihi'))
	{
		return false;
	}

	if(!date_check(document.upd_km.start_date,document.upd_km.finish_date,"Tarih Aralığını Kontrol Ediniz!"))
	{	
		return false;
	}
	
	a = parseInt(filterNum($('#pre_km').val()));
	b = parseInt(filterNum($('#last_km').val()));
	
	if(a >= b || trim(document.upd_km.last_km.value) == "")
	{
		alert("Km Aralığını Kontrol Ediniz!");
		return false;
	}
	unformat_fields();
	return true;
}
</script>
