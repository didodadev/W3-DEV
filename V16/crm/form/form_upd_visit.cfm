<cfif fusebox.use_period eq true>
    <cfset DSN2 = dsn2>
<cfelse>
    <cfset DSN2 = dsn>
</cfif>
<cfquery name="GET_EVENT_CATS" datasource="#DSN#">
	SELECT * FROM SETUP_VISIT_TYPES ORDER BY VISIT_TYPE
</cfquery>

<cfquery name="GET_BRANCH" datasource="#DSN#">
	SELECT
		BRANCH_NAME,
		BRANCH_ID
	FROM 
		BRANCH,
		COMPANY_BOYUT_DEPO_KOD
	WHERE
		COMPANY_BOYUT_DEPO_KOD.W_KODU = BRANCH.BRANCH_ID AND
		BRANCH_ID IN(SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
	ORDER BY 
		BRANCH_NAME
</cfquery>

<cfquery name="GET_EVENT_PLAN" datasource="#DSN#">
	SELECT * FROM EVENT_PLAN WHERE EVENT_PLAN_ID = #attributes.visit_id#
</cfquery>

<cfquery name="GET_MONEY" datasource="#DSN#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>

<cfquery name="GET_EXPENSE" datasource="#DSN2#">
	SELECT * FROM EXPENSE_ITEMS ORDER BY EXPENSE_ITEM_NAME
</cfquery>
<cfsavecontent variable="right_images">
	<cfoutput>
		<li><a href="#request.self#?fuseaction=crm.list_visit"><i class="icon-list-ul"></i></a></li>
    </cfoutput>
</cfsavecontent>
<cf_box title="#getlang('','Ziyaret Planları','51824')#" print_href="#request.self#?fuseaction=crm.popup_print_visit_plan&visit_id=#attributes.visit_id#" right_images="#right_images#">
<cfform name="add_event" method="post" action="#request.self#?fuseaction=crm.emptypopup_upd_warning">
<cf_box_elements>
	<input type="hidden" name="visit_id" id="visit_id" value="<cfoutput>#attributes.visit_id#</cfoutput>">
	<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
		<div class="form-group" id="item-plan">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57487.No'></label>
			<div class="col col-8 col-xs-12"> 
				<cfoutput>#get_event_plan.event_plan_id#</cfoutput>
			</div>
		</div>
		<div class="form-group" id="item-plan">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51861.Plan Adı'> *</label>
			<div class="col col-8 col-xs-12"> 
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='51862.plan girmelsiniz'></cfsavecontent>
				<cfinput type="text" name="warning_head" required="Yes" message="#message#" maxlength="100" value="#get_event_plan.event_plan_head#" style="width:180px;">
			</div>
		</div>
		<div class="form-group" id="item-plan">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58859.Süreç"></label>
			<div class="col col-8 col-xs-12"> 
				<cf_workcube_process is_upd='0' select_value='#get_event_plan.event_status#' process_cat_width='180' is_detail='1'>
			</div>
		</div>
		<div class="form-group" id="item-plan">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51826.Ziyaret Formu'></label>
			<div class="col col-8 col-xs-12"> 
				<div class="input-group"> 
			    <cfif len(get_event_plan.analyse_id)>
					<cfquery name="GET_ANALYSIS" datasource="#DSN#">
						SELECT ANALYSIS_HEAD FROM MEMBER_ANALYSIS WHERE ANALYSIS_ID = #get_event_plan.analyse_id#
					</cfquery>
					<input type="hidden" name="analyse_id" id="analyse_id" value="<cfoutput>#get_event_plan.analyse_id#</cfoutput>">
					<input type="text" name="analyse_head" id="analyse_head" value="<cfoutput>#get_analysis.analysis_head#</cfoutput>" style="width:180px;">
				  <cfelse>
					<input type="hidden" name="analyse_id" id="analyse_id">
					<input type="text" name="analyse_head" id="analyse_head" style="width:180px;">
				  </cfif>
				  <span class="input-group-addon btnPointer icon-ellipsis"  onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_analyse&field_id=add_event.analyse_id&field_name=add_event.analyse_head','list');"></span>
			</div>
		</div>
		</div>
		<div class="form-group" id="item-plan">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51554.Yetkili Şubeler'> *</label>
			<div class="col col-8 col-xs-12"> 
				<select name="sales_zones" id="sales_zones" style="width:180px;">
					<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
					<cfoutput query="get_branch">
						<option value="#branch_id#" <cfif get_event_plan.sales_zones eq branch_id>selected</cfif>>#branch_name#</option>
					</cfoutput>
					</select>	
				</div>
		</div>
	</div>
	<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
		<div class="form-group" id="item-plan">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57493.Aktif'></label>
			<div class="col col-8 col-xs-12"> 
				<input type="checkbox" name="is_active" id="is_active" <cfif get_event_plan.is_active eq 1>checked</cfif>>
			</div>
		</div>
		<div class="form-group" id="item-plan">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
			<div class="col col-8 col-xs-12"> 
				<textarea name="event_detail" id="event_detail" style="width:180px;height:65px;"><cfoutput>#get_event_plan.detail#</cfoutput></textarea>
			</div>
		</div>
		<div class="form-group" id="item-plan">
			<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
			<div class="col col-8 col-xs-12"> 
				<div class="col col-6 col-xs-12"> 
					<div class="input-group">
			    <cfsavecontent variable="message"><cf_get_lang dictionary_id='58503.Lutfen Tarih Giriniz !'></cfsavecontent>
					<cfinput type="text" name="main_start_date" validate="#validate_style#" message="#message#" value="#dateformat(get_event_plan.main_start_date,dateformat_style)#" required="yes" style="width:65px">
						<span class="input-group-addon"><cf_wrk_date_image date_field="main_start_date"> </span>
						</div>
					</div>
					<div class="col col-6 col-xs-12"> 
					<div class="input-group">
					<cfinput type="text" name="main_finish_date" validate="#validate_style#" message="#message#" value="#dateformat(get_event_plan.main_finish_date,dateformat_style)#" required="yes" style="width:65px">
					<span class="input-group-addon"><cf_wrk_date_image date_field="main_finish_date"></span>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
		<div id="cc" style="width:100%;height:99%; z-index:88; overflow:auto;">
			<cfsavecontent variable="txt_2"><cf_get_lang dictionary_id='58773.Bilgi Verilecekler'></cfsavecontent>
		<cf_workcube_to_cc
		is_update="1"
		cc_dsp_name="#txt_2#" 
		form_name="add_event"
		str_list_param="1"
		action_dsn="#dsn#"
		str_action_names = "CC_ID AS CC_POS"
		str_alias_names = ""
		action_table="EVENT_PLAN_ROW_CC"
		action_id_name="EVENT_PLAN_ID"
		data_type="2"
		action_id="#attributes.visit_id#">
		</div>
	</div>
</cf_box_elements>
		<cf_basket id="form_upd_visit_bask">
			<cfinclude template="../display/list_visit_rows_detail.cfm">
		</cf_basket>
        <cf_box_footer>
        	<cf_record_info query_name="get_event_plan">
			 <cfif session.ep.userid eq get_event_plan.record_emp>
                <cfif get_event_plan.ispotantial eq 1>
                  <cf_workcube_buttons is_upd='1' add_function='check()' is_reset='0' is_delete='0'>
                <cfelse>
                  <cf_workcube_buttons is_upd='1' add_function='check()' is_reset='0' is_delete='0'>
                </cfif>
             </cfif>
        </cf_box_footer>
</cfform>
</cf_box>
<script type="text/javascript">
function check()
{
	if(document.all.process_stage.value == "")
	{
		alert("<cf_get_lang dictionary_id='57976.Lütfen Süreçlerinizi Tanımlayınız ve veya Tanımlanan Süreçler Üzerinde Yetkiniz Yok'> !");
		return false;
	}

	x = document.add_event.sales_zones.selectedIndex;
	if (document.add_event.sales_zones[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='30126.Şube Seçiniz'>!");
		return false;
	}

	if (document.add_event.record_num.value == 0)
	{
		alert("<cf_get_lang dictionary_id='33527.Ziyaret Edilecek Eczane Seçiniz'>!");
		return false;
	}
	row_kontrol=0;
	for(r=1;r<=add_event.record_num.value;r++)
	{
		deger_row_kontrol = eval("document.add_event.row_kontrol"+r);
		deger_start_date = eval("document.add_event.start_date"+r);
		deger_start_clock = eval("document.add_event.start_clock"+r);
		deger_start_minute = eval("document.add_event.start_minute"+r);
		deger_finish_date = eval("document.add_event.start_date"+r);
		deger_finish_clock = eval("document.add_event.finish_clock"+r);
		deger_finish_minute = eval("document.add_event.finish_minute"+r);
		deger_pos_emp_name = eval("document.add_event.pos_emp_name"+r);
		deger_warning_id = eval("document.add_event.warning_id"+r);
	
		if(deger_row_kontrol.value == 1)
		{
			row_kontrol++;
			if(!CheckEurodate(deger_start_date.value,r+'.<cf_get_lang dictionary_id="57742.Tarih"> '))
			{ 
				deger_start_date.focus();
				return false;
			}
	
			if(deger_start_date.value == "" || deger_start_date.value.length!=10)
			{
				deger_start_date.focus();
				alert("<cf_get_lang dictionary_id='41039.Lütfen Başlangıç Tarihi Giriniz'> !");
				return false;
			}
			
			if (!time_check(r))
			{
				return false;
			}
	
			if ((deger_start_date.value != "") && (deger_finish_date.value != ""))
			{
				tarih1_ = deger_start_date.value.substr(6,4) + deger_start_date.value.substr(3,2) + deger_start_date.value.substr(0,2);
				tarih2_ = deger_finish_date.value.substr(6,4) + deger_finish_date.value.substr(3,2) + deger_finish_date.value.substr(0,2);
	
				if (deger_start_clock.value.length < 2) saat1_ = '0' + deger_start_clock.value; else saat1_ = deger_start_clock.value;
				if (deger_start_minute.value.length < 2) dakika1_ = '0' + deger_start_minute.value; else dakika1_ = deger_start_minute.value;
				if (deger_finish_clock.value.length < 2) saat2_ = '0' + deger_finish_clock.value; else saat2_ = deger_finish_clock.value;
				if (deger_finish_minute.value.length < 2) dakika2_ = '0' + deger_finish_minute.value; else dakika2_ = deger_finish_minute.value;
			
				tarih1_ = tarih1_ + saat1_ + dakika1_;
				tarih2_ = tarih2_ + saat2_ + dakika2_;	
	
				if (tarih1_ >= tarih2_) 
				{
					alert("<cf_get_lang dictionary_id='41041.Ziyaret Başlama Tarihi Bitiş Tarihinden Önce Olmalıdır'> !");
					return false;
				}
			}	
	
			x = deger_warning_id.selectedIndex;
			if(deger_warning_id[x].value == "")
			{ 
				alert ("<cf_get_lang dictionary_id='41042.Lütfen Ziyaret Nedeni Giriniz'> !");
				return false;
			}
				
			if(deger_pos_emp_name.value == "")
			{
				alert("<cf_get_lang dictionary_id='41043.Lütfen Ziyaret Edecekler Satırına En Az Bir Kişi Ekleyiniz'> !");
				return false;
			}
		}
	}
	if(row_kontrol == 0 )
	{
		alert("<cf_get_lang dictionary_id='41371.Ziyaret Edilecek Seçiniz'>!");
		return false;
	}	
}

function time_check(satir_deger)
{
	check_start_date = eval("document.add_event.start_date"+satir_deger);
	tarih_main_start_date = add_event.main_start_date.value.substr(6,4) + add_event.main_start_date.value.substr(3,2) + add_event.main_start_date.value.substr(0,2);
	tarih_main_finish_date = add_event.main_finish_date.value.substr(6,4) + add_event.main_finish_date.value.substr(3,2) + add_event.main_finish_date.value.substr(0,2);
	check_start = check_start_date.value.substr(6,4) + check_start_date.value.substr(3,2) + check_start_date.value.substr(0,2);

	if((check_start < tarih_main_start_date) || (check_start > tarih_main_finish_date))
	{
		alert("<cf_get_lang dictionary_id='41044.Tarih Başlangıç ve Bitiş Tarihleri Arasında Olmalıdır'> !");
		check_start_date.value = "";
		check_start_date.focus();
		return false;
	}
	return true;
}

function sil(sy)
{
	var my_element=eval("add_event.row_kontrol"+sy);
	my_element.value=0;
	var my_element=eval("frm_row"+sy);
	my_element.style.display="none";
}

function kontrol_et()
{
	if(row_count ==0)
		return false;
	else
		return true;
}

function pencere_ac(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_buyer_seller=0&field_id=add_event.partner_id' + no +'&field_comp_name=add_event.company_name' + no +'&field_name=add_event.partner_name' + no +'&field_comp_id=add_event.company_id' + no + '&is_crm_module=1&select_list=2,6','project');
}

function pencere_ac_pos(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multi_pars&field_id=add_event.pos_emp_id' + no +'&field_name=add_event.pos_emp_name' + no +'&select_list=1&is_upd=0','list');
}

function pencere_ac_inf(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multi_pars&field_id=add_event.inf_emp_id' + no +'&field_name=add_event.inf_emp_name' + no +'&select_list=1&is_upd=0','list');
}

function pencere_ac_date(no)
{
	if((document.add_event.main_start_date.value == "") && (document.add_event.main_finish_date.value == ""))
		alert("<cf_get_lang dictionary_id='51848.Lütfen İlk Önce Olay Başlangıç ve Bitiş Tarihlerini Seçiniz'> !");
	else
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan=add_event.start_date' + no +'&is_check=' + no,'date');
}

function pencere_ac_date_finish(no)
{
	windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_calender&alan=add_event.finish_date' + no ,'date');
}

function pencere_ac_company(no)
{
	if((add_event.main_start_date.value == '') || (add_event.main_finish_date.value == ''))
	{
		alert("<cf_get_lang dictionary_id='52054.Önce Etkinlik Tarihlerini Giriniz'>!");
		return false;
	}
	else	
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multiuser_company&kontrol_startdate='+add_event.main_start_date.value+'&record_num_=' + add_event.record_num.value +'&is_first=1');
}
function manage_date(gelen_alan)
{
	wrk_date_image(gelen_alan);
}
</script>
