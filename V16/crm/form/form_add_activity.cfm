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
<cfquery name="GET_MONEY" datasource="#dsn#">
	SELECT * FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1
</cfquery>
<cfquery name="GET_EXPENSE" datasource="#dsn2#">
	SELECT * FROM EXPENSE_ITEMS ORDER BY EXPENSE_ITEM_NAME
</cfquery>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id='51769.Etkinlik Planlama'></cfsavecontent>
	<cf_box title="#title#">
		<cfform name="add_event" method="post" action="#request.self#?fuseaction=crm.emptypopup_add_activity">
			<cf_box_elements>
				<div class="col col-4 col-md-6 col-sm-12 col-xs-12">
					<div class="form-group" id="activity">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='51770.Etkinlik Adı'> *</label>
						<div class="col col-8 col-sm-12">
								<input type="text" name="warning_head" id="warning_head" value="">
						</div>
					</div>
					<div class="form-group" id="category">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57486.Kategori'> *</label>
						<div class="col col-8 col-sm-12">
							<cfsavecontent variable="text"><cf_get_lang dictionary_id='58947.Kategori Seçmelisiniz'> !</cfsavecontent>
							<cf_wrk_combo
										name="main_warning_id"
										query_name="GET_ACTIVITY_TYPES"
										option_name="activity_type"
										option_value="activity_type_id"
										option_text="#text#"
										width="170">
						</div>
					</div>
					<div class="form-group" id="process">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='58859.Süreç'></label>
						<div class="col col-8 col-sm-12">
							<cf_workcube_process 
										is_upd='0' 
										process_cat_width='170' 
										is_detail='0'>
						</div>
					</div>
					<div class="form-group" id="eventform">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='51774.Etkinlik Formu'></label>
						<div class="col col-8 col-sm-12">
							<div class="col col-12 input-group">
									<input type="hidden" name="analyse_id" id="analyse_id">
                                	<input type="text" name="analyse_head" id="analyse_head">
									<span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_analyse&field_id=add_event.analyse_id&field_name=add_event.analyse_head');"></span>
							</div>
						</div>
					</div>
					<div class="form-group" id="estcost">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='51775.Tahmini Gider'> *</label>
						<div class="col col-5 col-xs-12">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id ='41188.Maliyet Girmelisiniz'></cfsavecontent>
							<input type="text" name="est_limit" id="est_limit" onKeyup="return(FormatCurrency(this,event));" value="" class="moneybox">
						</div>
						<div class="col col-3 col-xs-12">
							<select name="money" id="money">
								<cfoutput query="get_money">
									<option value="#money#" <cfif money eq session.ep.money>selected</cfif>>#money#</option>
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
									<option value="#expense_item_id#">#expense_item_name#</option>
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
							<textarea name="event_detail" id="event_detail"></textarea>
						</div>
					</div>
					<div class="form-group" id="dates">
						<label class="col col-4 col-sm-12"><cf_get_lang dictionary_id='57742.Tarih'> *</label>
						<div class="col col-8 col-sm-12">
							<div class="col col-6 col-sm-12">
								<div class="input-group">
									<cfif isdefined('attributes.is_detail_search')>
										<input type="text" name="main_start_date" id="main_start_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
									<cfelse>
										<input type="text" name="main_start_date" id="main_start_date" value="">
									</cfif>
									<span class="input-group-addon"><cf_wrk_date_image date_field="main_start_date"></span>
								</div>
							</div>
							<div class="col col-6 col-sm-12">
								<div class="input-group">
									<cfif isdefined('attributes.is_detail_search')>
										<input type="text" name="main_finish_date" id="main_finish_date" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>" validate="#validate_style#" maxlength="10">
									<cfelse>
										<input type="text" name="main_finish_date" id="main_finish_date" value="">
									</cfif>
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
									<option value="#branch_id#">#branch_name#</option>
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
							is_update="0" 
							to_dsp_name="#txt_1#" 
							form_name="add_event" 
							str_list_param="1" 
							data_type="1">
						</div>
					</div>
					<div class="col col-6 col-sm-12">
						<div id="cc1" style="z-index:88; overflow:auto;">
							<cfsavecontent variable="txt_2"><cf_get_lang dictionary_id='58773.Bilgi Verilecekler'></cfsavecontent>
							<cf_workcube_to_cc 
							is_update="0" 
							cc_dsp_name="#txt_2#" 
							form_name="add_event" 
							str_list_param="1" 
							data_type="1">
						</div>
					</div>
				</div>
			</cf_box_elements>
			
			<cf_basket id="add_activity_bask">
				<cfinclude template="../display/list_activity_rows.cfm">
			</cf_basket>

			<cf_box_footer>
				<div class="col col12 col-md-12 col-sm-12 col-xs-12">
					<cf_workcube_buttons is_upd='0' add_function='check()'>
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>


<script type="text/javascript">
	function check()
	{		
		if(document.add_event.process_stage.value == "")
		{
			alert("<cf_get_lang dictionary_id='51217.Lütfen Süreçlerinizi Tanimlayiniz ve veya Tanimlanan Süreçler Üzerinde Yetkiniz Yok'> !");
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
			alert ("<cf_get_lang dictionary_id='31523.Lütfen Etkinlik Kategorisi Giriniz'> !");
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
			alert ("<cf_get_lang dictionary_id='53374.Lütfen Gider Kalemi Seçiniz'> !");
			return false;
		}
		
		x = document.add_event.sales_zones.selectedIndex;
		if (document.add_event.sales_zones[x].value == "")
		{ 
			alert ("<cf_get_lang dictionary_id='58579.Lütfen Şube Seçiniz'> !");
			return false;
		}
		
		if(document.add_event.main_start_date.value == "")
		{
			alert("<cf_get_lang dictionary_id='41039.Lütfen Başlangıç Tarihi Giriniz'> !");
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
			alert("<cf_get_lang dictionary_id='52053.Lütfen Eczane Seçiniz'> !");
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
					alert("<cf_get_lang dictionary_id='41039.Lütfen Başlangıç Tarihi Giriniz'> !");
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
					alert("<cf_get_lang dictionary_id='40156.Lütfen Etkinlik Düzenleyeni Seçiniz'> !");
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
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_event.pos_emp_id' + no +'&field_name=add_event.pos_emp_name' + no +'&select_list=1&is_upd=0');
		}
		
		function pencere_ac_inf(no)
		{
			openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_multi_pars&field_id=add_event.inf_emp_id' + no +'&field_name=add_event.inf_emp_name' + no +'&select_list=1&is_upd=0');
		}
		
		function pencere_ac_company(no)
		{
			if((add_event.main_start_date.value == '') || (add_event.main_finish_date.value == ''))
			{
				alert("<cf_get_lang dictionary_id='52054.Önce Etkinlik Tarihlerini Giriniz'> !");
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
		<cfquery name="GET_POSITIONID" datasource="#dsn#">
			SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
		</cfquery>
		<cfif isdefined("attributes.is_target")>
			row_count=0;
			<cfoutput>
			<cfloop list="#attributes.target_company_id#" index="i">
					<cfquery name="GET_COMPANY_PART"  datasource="#dsn#">
						SELECT
							COMPANY.COMPANY_ID,
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
					newCell.innerHTML = '<a style="cursor:pointer" onclick="sil(' + row_count + ');"><img  src="images/delete_list.gif" border="0"></a>';		
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input  type="hidden"  value="1"  name="row_kontrol' + row_count +'" ><input type="hidden" name="company_id' + row_count +'" value="<cfoutput>#get_company_part.company_id#</cfoutput>"><input type="text" name="company_name' + row_count +'" readonly="" style="width:150;" value="<cfoutput>#get_company_part.fullname#</cfoutput>">';
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="hidden" name="partner_id' + row_count +'" value="#get_company_part.partner_id#"><input type="text" name="partner_name' + row_count +'" readonly="" style="width:150;" value="<cfoutput>#get_company_part.company_partner_name# #get_company_part.company_partner_surname#</cfoutput>"><a href="javascript://" onClick="pencere_ac(' + row_count +');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>';
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.setAttribute("id","start_date" + row_count + "_td");
					newCell.innerHTML = '<input type="text" name="start_date' + row_count +'" class="text" maxlength="10" style="width:65px;" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">';
					wrk_date_image('start_date' + row_count);
					newCell = newRow.insertCell(newRow.cells.length);
					
					newCell.setAttribute("id","finish_date" + row_count + "_td");
					newCell.innerHTML = '<input type="text" name="finish_date' + row_count +'" class="text" maxlength="10" style="width:65px;" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>">';
					wrk_date_image('finish_date' + row_count);

					
					<!--- newCell.innerHTML = '<input  type="text"  name="start_date' + row_count +'" style="width:65" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>"> <a href="javascript://" onClick="pencere_ac_date(' + row_count + ');"><img border="0" src="/images/calender.gif" align="absmiddle"></a>'; 
					newCell = newRow.insertCell();
					newCell.innerHTML = '<input  type="text"  name="finish_date' + row_count +'" style="width:65" value="<cfoutput>#dateformat(now(),dateformat_style)#</cfoutput>"> <a href="javascript://" onClick="pencere_ac_date_finish(' + row_count + ');"><img border="0" src="/images/calender.gif" align="absmiddle"></a>';--->
					newCell = newRow.insertCell(newRow.cells.length);
					newCell.innerHTML = '<input type="hidden" name="pos_emp_id' + row_count +'" value="#session.ep.position_code#"><input type="text" name="pos_emp_name' + row_count +'" readonly="" style="width:150;" value="#get_emp_info(session.ep.userid,0,0)#"> <a href="javascript://" onClick="pencere_ac_pos(' + row_count +');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>';
			</cfloop>
			</cfoutput>
		</cfif>
		function manage_date(gelen_alan)
	{
		wrk_date_image(gelen_alan);
	}
</script>
