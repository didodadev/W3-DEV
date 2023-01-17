<cfquery name="GET_BRANCH" datasource="#dsn#">
	SELECT
		BRANCH_NAME,
		BRANCH_ID
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# )
		ORDER BY BRANCH_NAME
</cfquery>
<cfquery name="GET_EVENT_PLAN" datasource="#dsn#">
	SELECT * FROM ACTIVITY_PLAN WHERE EVENT_PLAN_ID = #attributes.visit_id#
</cfquery>
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_EXPENSE" datasource="#dsn2#">
	SELECT * FROM EXPENSE_ITEMS ORDER BY EXPENSE_ITEM_NAME
</cfquery>

<cfform name="add_event" method="post" action="#request.self#?fuseaction=crm.emptypopup_upd_activity">
    <input type="hidden" name="visit_id" id="visit_id" value="<cfoutput>#attributes.visit_id#</cfoutput>">
	<cf_basket_form id="upd_activity_">
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cfsavecontent variable="title"><cf_get_lang dictionary_id='51839.Etkinlik Planı'>: <cfoutput>#get_event_plan.event_plan_head#</cfoutput></cfsavecontent>
		<cf_box title="#title#" add_href_2="javascript:openBoxDraggable('#request.self#?fuseaction=crm.popup_add_collacted_activity&event_plan_id=#attributes.visit_id#')" add_href_2_title="#getLang('','Toplu Etkinlik Sonucu Girişi','52317')#"> 
			<cfform name="add_event" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_activity">
				<cf_box_elements>
					<div class="col col-4 col-md-6 col-sm-12 col-xs-12">
						<div class="form-group" id="activity">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='51770.Etkinlik Adı'> *</label>
							<div class="col col-8 col-sm-12">
									<input type="text" name="warning_head" id="warning_head" value="<cfoutput>#get_event_plan.event_plan_head#</cfoutput>">
							</div>
						</div>
						<div class="form-group" id="category">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
							<div class="col col-8 col-sm-12">
								<cfset form_main_warning_id = get_event_plan.event_cat>
								<cfsavecontent variable="text"><cf_get_lang dictionary_id='58947.Kategori Seçmelisiniz'> !</cfsavecontent>
								<cf_wrk_combo
									name="main_warning_id"
									query_name="GET_ACTIVITY_TYPES"
									option_name="activity_type"
									option_value="activity_type_id"
									option_text="#text#"
									value="#form_main_warning_id#"
									width="190">
							</div>
						</div>
						<div class="form-group" id="process">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
							<div class="col col-8 col-sm-12">
								<cf_workcube_process 
											is_upd='0' 
											select_value='#get_event_plan.event_status#' 
											process_cat_width='190' 
											is_detail='1'>
							</div>
						</div>
						<div class="form-group" id="eventform">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='51774.Etkinlik Formu'></label>
							<div class="col col-8 col-sm-12">
								<div class="col col-12 input-group">
									<cfif len(get_event_plan.analyse_id)>
										<cfquery name="GET_ANALYSIS" datasource="#dsn#">
											SELECT ANALYSIS_HEAD FROM MEMBER_ANALYSIS WHERE ANALYSIS_ID = #get_event_plan.analyse_id#
										</cfquery>
											<input type="hidden" name="analyse_id" id="analyse_id" value="<cfoutput>#get_event_plan.analyse_id#</cfoutput>">
											<input type="text" name="analyse_head" id="analyse_head" value="<cfoutput>#get_analysis.analysis_head#</cfoutput>">
										<cfelse>
											<input type="hidden" name="analyse_id" id="analyse_id">
											<input type="text" name="analyse_head" id="analyse_head">
									</cfif>
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_analyse&field_id=add_event.analyse_id&field_name=add_event.analyse_head');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="estcost">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='51775.Tahmini Gider'> *</label>
							<div class="col col-5 col-xs-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id ='41188.Maliyet Girmelisiniz'></cfsavecontent>
								<input type="text" name="est_limit" id="est_limit" onKeyup="return(FormatCurrency(this,event));" value="<cfoutput>#tlformat(get_event_plan.est_limit)#</cfoutput>" class="moneybox">
							</div>
							<div class="col col-3 col-xs-12">
								<select name="money" id="money">
									<cfoutput query="get_money">
										<option value="#money#" <cfif get_event_plan.money_currency eq money>selected</cfif>>#money#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="expenseitem">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58551.Gider Kalemi'> *</label>
							<div class="col col-8 col-sm-12">
								<select name="main_expense_id" id="main_expense_id" style="width:170px;">
									<option value=""><cf_get_lang dictionary_id='58551.Gider Kalemi'></option>
									<cfoutput query="get_expense">
										<option value="#expense_item_id#" <cfif expense_item_id eq get_event_plan.expense_id>selected</cfif>>#expense_item_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-6 col-sm-12 col-xs-12">
						<div class="form-group" id="explanation">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57629.Açıklama'></label>
							<div class="col col-8 col-sm-12">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id='58059.Başlık Girmelisiniz!'></cfsavecontent>
								<textarea name="event_detail" id="event_detail"><cfoutput>#get_event_plan.detail#</cfoutput></textarea>
							</div>
						</div>
						<div class="form-group" id="dates">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
							<div class="col col-8 col-sm-12">
								<div class="col col-6 col-sm-12">
									<div class="input-group">
										<input type="text" name="main_start_date" id="main_start_date" value="<cfoutput>#dateformat(get_event_plan.main_start_date,dateformat_style)#</cfoutput>">
										<span class="input-group-addon"><cf_wrk_date_image date_field="main_start_date"></span>
									</div>
								</div>
								<div class="col col-6 col-sm-12">
									<div class="input-group">
										<input type="text" name="main_finish_date" id="main_finish_date" value="<cfoutput>#dateformat(get_event_plan.main_finish_date,dateformat_style)#</cfoutput>">
										<span class="input-group-addon"><cf_wrk_date_image date_field="main_finish_date"></span>
									</div>
								</div>
							</div>
						</div>
						<div class="form-group" id="authbranches">
							<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='51554.Yetkili Şubeler'> *</label>
							<div class="col col-8 col-sm-12">
								<select name="sales_zones" id="sales_zones">
									<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
									<cfoutput query="get_branch">
										<option value="#branch_id#" <cfif branch_id eq get_event_plan.sales_zones>selected</cfif>>#branch_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-6 col-sm-12 col-xs-12">
						<div class="col col-6 col-sm-12">
							<div id="cc" style="z-index:88; overflow:auto;">
								<cfsavecontent variable="txt_1"><cf_get_lang dictionary_id='51771.Yardımcı Ekip'></cfsavecontent>
								<cf_workcube_to_cc 
								is_update="1"
								to_dsp_name="#txt_1#"
								form_name="add_event"
								str_list_param="1"
								action_dsn="#dsn#"
								str_action_names = "POS_ID AS TO_POS"
								str_alias_names = ""
								action_table="ACTIVITY_PLAN_ROW_POS"
								action_id_name="EVENT_PLAN_ID"
								data_type="2"
								action_id="#attributes.visit_id#">
							</div>
						</div>
						<div class="col col-6 col-sm-12">
							<div id="cc1" style="z-index:88; overflow:auto;">
								<cfsavecontent variable="txt_2"><cf_get_lang dictionary_id='58773.Bilgi Verilecekler'></cfsavecontent>
								<cf_workcube_to_cc 
								is_update="1"
								cc_dsp_name="#txt_2#" 
								form_name="add_event"
								str_list_param="1"
								action_dsn="#dsn#"
								str_action_names = "CC_ID AS CC_POS"
								str_alias_names = ""
								action_table="ACTIVITY_PLAN_ROW_CC"
								action_id_name="EVENT_PLAN_ID"
								data_type="2"
								action_id="#attributes.visit_id#">
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_basket id="upd_activity_basket_">               
					<cfinclude template="../display/list_activity_rows_detail.cfm">
				</cf_basket>

				<cf_box_footer>
					
						<cf_record_info query_name="get_event_plan">
						<cfif get_event_plan.record_emp eq session.ep.userid>
							<cfif get_event_plan.ispotantial eq 1>
								<cf_workcube_buttons is_upd='1' add_function='check()' is_reset='0' is_delete='0'>
							<cfelse>
								<cf_workcube_buttons is_upd='1' add_function='check()' is_reset='0' is_delete='0'>
							</cfif>
						</cfif>
					
				</cf_box_footer>
			</cfform>
		</cf_box>
	</div>
	</cf_basket_form>  
</cfform>

<script type="text/javascript">
function check()
{		
	if(document.add_event.process_stage.value == "")
	{
		alert("<cf_get_lang dictionary_id='64071.Lütfen Süreçlerinizi Tanımlayiniz veya Tanımlanan Süreçler Üzerinde Yetkiniz Yok'> !");
		return false;
	}
	if(document.add_event.warning_head.value == "")
	{
		alert("<cf_get_lang dictionary_id='51841.Lütfen Etkinlik Başlığı Giriniz'> !");
		return false;
	}
	x = document.add_event.main_warning_id.selectedIndex;
	if (document.add_event.main_warning_id[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='48372.Lütfen Kategori Giriniz'> !");
		return false;
	}
	if(document.add_event.est_limit.value == "")
	{
		alert("<cf_get_lang dictionary_id='42757.Lütfen Tahmini Gider Giriniz'> !");
		return false;
	}
	x = document.add_event.main_expense_id.selectedIndex;
	if (document.add_event.main_expense_id[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='33461.Lütfen Gider Kalemi Seçiniz'> !");
		return false;
	}
	x = document.add_event.sales_zones.selectedIndex;
	if (document.add_event.sales_zones[x].value == "")
	{ 
		alert ("<cf_get_lang dictionary_id='58579.Lütfen Şube Seçiniz'>!");
		return false;
	}
	if(document.add_event.main_start_date.value == "")
	{
		alert("<cf_get_lang dictionary_id='30623.Lütfen Başlangıç Tarihi Giriniz'> !");
		return false;
	}
	if(document.add_event.main_finish_date.value == "")
	{
		alert("<cf_get_lang dictionary_id='50693.Lütfen Bitiş Tarihi Giriniz'> !");
		return false;
	}
	tarih1_1 = document.add_event.main_start_date.value.substr(6,4) + document.add_event.main_start_date.value.substr(3,2) + document.add_event.main_start_date.value.substr(0,2);
	tarih2_2 = document.add_event.main_start_date.value.substr(6,4) + document.add_event.main_start_date.value.substr(3,2) + document.add_event.main_start_date.value.substr(0,2);
	if (tarih1_1 > tarih2_2) 
	{
		alert("<cf_get_lang dictionary_id='39642.Etkinlik Bitiş Tarihi Başlangıç Tarihinden Büyük Olmalıdır'> !");
		return false;
	}
	if (document.add_event.record_num.value == 0)
	{
		alert("<cf_get_lang dictionary_id='52053.Lütfen Eczane Seçiniz'>");
		return false;
	}
	for(r=1;r<=add_event.record_num.value;r++)
	{
		deger_row_kontrol = eval("document.add_event.row_kontrol"+r);
		deger_start_date = eval("document.add_event.start_date"+r);
		deger_finish_date = eval("document.add_event.finish_date"+r);
		tarih1_ = deger_start_date.value.substr(6,4) + deger_start_date.value.substr(3,2) + deger_start_date.value.substr(0,2);
		tarih2_ = deger_finish_date.value.substr(6,4) + deger_finish_date.value.substr(3,2) + deger_finish_date.value.substr(0,2);
		if(deger_row_kontrol.value == 1)
		{
			if(deger_start_date.value == "")
			{
				alert("<cf_get_lang dictionary_id='30623.Lütfen Başlangıç Tarihi Giriniz'> !");
				return false;
			}
			
			if(deger_finish_date.value == "")
			{
				alert("<cf_get_lang dictionary_id='50693.Lütfen Bitiş Tarihi Giriniz'> !");
				return false;
			}

			if (tarih1_ > tarih2_) 
			{
				alert("<cf_get_lang dictionary_id='39642.Etkinlik Bitiş Tarihi Başlangıç Tarihinden Büyük Olmalıdır'> !");
				return false;
			}
		}
	}
	for(r=1;r<=add_event.record_num.value;r++)
	{
		deger_row_kontrol = eval("document.add_event.row_kontrol"+r);
		deger_pos_emp_id = eval("document.add_event.pos_emp_id"+r);
		if(deger_row_kontrol.value == 1)
		{	
			if(deger_pos_emp_id.value == "")
			{
				alert("<cf_get_lang dictionary_id='34877.Lütfen Etkinliği Düzenleyeni Seçiniz'> !");
				return false;
			}
		}
	}
	add_event.est_limit.value = filterNum(add_event.est_limit.value);
	/*for(r=1;r<=add_event.record_num.value;r++)
	{
		deger_row_kontrol = eval("document.add_event.row_kontrol"+r);
		deger_est_limit = eval("document.add_event.est_limit"+r);
		if(deger_row_kontrol.value == 1)
		{	
			deger_est_limit.value = filterNum(deger_est_limit.value);
		}
	}*/
	/*x = document.add_event.main_warning_id.selectedIndex;
	if (document.add_event.main_warning_id[x].value == "")
	{ 
		for(r=1;r<=add_event.record_num.value;r++)
		{
			deger_warning_id = eval("document.add_event.warning_id"+r);
			deger_row_kontrol = eval("document.add_event.row_kontrol"+r);
				
			if(deger_row_kontrol.value == 1)
			{
				x = deger_warning_id.selectedIndex;
				if (deger_warning_id[x].value == "")
				{ 
					alert ("Lütfen Etkinlik Kategorisi Giriniz !");
					return false;
				}	
			}
		}
	}*/
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
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&is_buyer_seller=0&field_id=add_event.partner_id' + no +'&field_comp_name=add_event.company_name' + no +'&field_name=add_event.partner_name' + no +'&field_comp_id=add_event.company_id' + no + '&is_crm_module=1&select_list=2,6');
	}
	function pencere_ac_pos(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_id=add_event.pos_emp_id' + no +'&field_name=add_event.pos_emp_name' + no +'&select_list=1&is_upd=0');
	}
	function pencere_ac_inf(no)
	{
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multi_pars&field_id=add_event.inf_emp_id' + no +'&field_name=add_event.inf_emp_name' + no +'&select_list=1&is_upd=0');
	}
	function pencere_ac_company(no)
	{
		if((add_event.main_start_date.value == '') || (add_event.main_finish_date.value == ''))
		{
			alert("<cf_get_lang dictionary_id='52054.Önce Etkinlik Tarihlerini Giriniz'>!");
			return false;
		}
		else
		openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multiuser_company&kontrol_startdate='+add_event.main_start_date.value+'&kontrol_finishdate='+add_event.main_finish_date.value+'&record_num_=' + add_event.record_num.value +'&is_first=1&is_activity=1');
	}
	function time_check(satir_deger)
	{
		
		check_start_date = eval("document.add_event.start_date"+satir_deger);
		check_finish_date = eval("document.add_event.finish_date"+satir_deger);
		tarih_main_start_date = add_event.main_start_date.value.substr(6,4) + add_event.main_start_date.value.substr(3,2) + add_event.main_start_date.value.substr(0,2);
		tarih_main_finish_date = add_event.main_finish_date.value.substr(6,4) + add_event.main_finish_date.value.substr(3,2) + add_event.main_finish_date.value.substr(0,2);
		check_start = check_start_date.value.substr(6,4) + check_start_date.value.substr(3,2) + check_start_date.value.substr(0,2);
		check_finish = check_finish_date.value.substr(6,4) + check_finish_date.value.substr(3,2) + check_finish_date.value.substr(0,2);
		if((check_start != "") && ((check_start < tarih_main_start_date) || (check_start > tarih_main_finish_date)))
		{
			alert("<cf_get_lang dictionary_id='51849.Başlangıç Tarihi Plan Başlangıç ve Bitiş Tarihleri Arasında Olmalıdır'> !");
			check_start_date.value = "";
		}
		if((check_finish != "") && ((check_finish < tarih_main_start_date) || (check_finish > tarih_main_finish_date)))
		{
			alert("<cf_get_lang dictionary_id='51850.Bitiş Tarihi Plan Başlangıç ve Bitiş Tarihleri Arasında Olmalıdır'> !");
			check_finish_date.value = "";
		}
		
	}
	<cfif isdefined("attributes.is_target")>
		row_count=0;
		<cfoutput>
		<cfloop list="#attributes.target_company_id#" index="i">
				<cfquery name="GET_COMPANY_PART"  datasource="#dsn#">
					SELECT
						COMPANY.FULLNAME,
						COMPANY_PARTNER.PARTNER_ID,
						COMPANY_PARTNER.COMPANY_PARTNER_NAME,
						COMPANY_PARTNER.COMPANY_PARTNER_SURNAME
					FROM
						COMPANY,
						COMPANY_PARTNER
					WHERE
						COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND 
						COMPANY_PARTNER.PARTNER_ID = #i#
				</cfquery>
				row_count++;
				var newRow;
				var newCell;
				document.all.record_num.value=row_count;
				newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
				newRow.setAttribute("name","frm_row" + row_count);
				newRow.setAttribute("id","frm_row" + row_count);		
				newRow.setAttribute("NAME","frm_row" + row_count);
				newRow.setAttribute("ID","frm_row" + row_count);		
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><i class="fa fa-minus"></i></a>';		
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><input type="hidden" name="company_id' + row_count +'" value="<cfoutput>#i#</cfoutput>"><input type="text" name="company_name' + row_count +'" readonly="" style="width:150px;" value="<cfoutput>#get_company_part.fullname#</cfoutput>">';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="hidden" name="partner_id' + row_count +'" value="#get_company_part.partner_id#"><input type="text" name="partner_name' + row_count +'" readonly="" style="width:125px;" value="<cfoutput>#get_company_part.company_partner_name# #get_company_part.company_partner_surname#</cfoutput>"><a href="javascript://" onClick="pencere_ac(' + row_count +');"><i class="fa fa-plus"></i></a>';
				newCell = newRow.insertCell(newRow.cells.length);
				
				newCell.setAttribute("id","start_date" + row_count + "_td");
				newCell.innerHTML = '<input type="text" name="start_date' + row_count +'" class="text" maxlength="10" style="width:65px;" value="">';
				wrk_date_image('start_date' + row_count);
				newCell = newRow.insertCell(newRow.cells.length);
				
				newCell.setAttribute("id","finish_date" + row_count + "_td");
				newCell.innerHTML = '<input type="text" name="finish_date' + row_count +'" class="text" maxlength="10" style="width:65px;" value="">';
				wrk_date_image('finish_date' + row_count);
				newCell = newRow.insertCell(newRow.cells.length);
				
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<select name="warning_id' + row_count +'" style="width:150px;"><option value="" selected>Kategori Seçiniz !</option><cfloop query="get_event_cats"><option value="#activity_type_id#">#activity_type#</option></cfloop></select>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="pos_emp_id' + row_count +'" value=""><input type="text" name="pos_emp_name' + row_count +'" readonly="" style="width:150;" value=""> <span class="input-group-addon icon-ellipsis" href="javascript://" onClick="pencere_ac_pos(' + row_count +');"></span></div></div>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<input type="text" name="est_limit'+ row_count +'" onKeyup="return(FormatCurrency(this,event));" value="0" style="width:120px;" class="moneybox"><select name="money'+ row_count +'" style="width:57px;"><cfloop query="get_money"><option value="#money#" <cfif money eq session.ep.money>selected</cfif>>#money#</option></cfloop></select></td>';
				newCell = newRow.insertCell(newRow.cells.length);
				newCell.innerHTML = '<select name="expense_id' + row_count +'" style="width:150px;"><option value="" selected>Gider Kalemi !</option><cfloop query="get_expense"><option value="#expense_item_id#">#expense_item_name#</option></cfloop></select>';
		</cfloop>
		</cfoutput>
	</cfif>
	function manage_date(gelen_alan)
{
	wrk_date_image(gelen_alan);
}
</script>
