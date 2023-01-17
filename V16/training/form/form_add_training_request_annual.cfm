<!--- 20121113 SG Yıllık Eğitim talebi--->
<cf_xml_page_edit fuseact="training_management.form_add_training_request">
	<cfquery name="get_position_detail" datasource="#dsn#">
		SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2 FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.EMPLOYEE_ID =  #session.ep.userid# AND IS_MASTER = 1
	</cfquery>
	<cfquery name="get_all_positions" datasource="#dsn#">
		SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID = #session.ep.userid#
	</cfquery>
	<cfset pos_code_list = valuelist(get_all_positions.position_code)>
	<!---İzinde olan kişilerin vekalet bilgileri alınıypr --->
	<cfquery name="Get_Offtime_Valid" datasource="#dsn#">
		SELECT
			O.EMPLOYEE_ID,
			EP.POSITION_CODE
		FROM
			OFFTIME O,
			EMPLOYEE_POSITIONS EP
		WHERE
			O.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
			O.VALID = 1 AND
			#Now()# BETWEEN O.STARTDATE AND O.FINISHDATE
	</cfquery>
	<cfif Get_Offtime_Valid.recordcount>
		<cfset Now_Offtime_PosCode = ValueList(Get_Offtime_Valid.Position_Code)>
		<cfquery name="Get_StandBy_Position1" datasource="#dsn#"><!--- Asil Kisi Izinli ise ve 1.Yedek Izinli Degilse --->
			SELECT POSITION_CODE, CANDIDATE_POS_1 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN(#pos_code_list#)
		</cfquery>
		<cfoutput query="Get_StandBy_Position1">
			<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position1.Position_Code))>
		</cfoutput>
		<cfquery name="Get_StandBy_Position2" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek Izinli ise ve 2.Yedek Izinli Degilse --->
			SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#pos_code_list#)
		</cfquery>
		<cfoutput query="Get_StandBy_Position2">
			<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position2.Position_Code))>
		</cfoutput>
		<cfquery name="Get_StandBy_Position3" datasource="#dsn#"><!--- Asil Kisi, 1.Yedek,2.Yedek Izinli ise ve 3.Yedek Izinli Degilse --->
			SELECT POSITION_CODE, CANDIDATE_POS_1, CANDIDATE_POS_2 FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_1 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_2 IN (#Now_Offtime_PosCode#) AND CANDIDATE_POS_3 IN (#pos_code_list#)
		</cfquery>
		<cfoutput query="Get_StandBy_Position3">
			<cfset pos_code_list = ListAppend(pos_code_list,ValueList(Get_StandBy_Position3.Position_Code))>
		</cfoutput>
	</cfif>
	<cfsavecontent  variable="title">
		<cf_get_lang dictionary_id="31108.Yıllık Eğitim Talebi">
	</cfsavecontent>
	<cf_box title="#title#">
		<cfform name="add_request_annual" method="post" action="#request.self#?fuseaction=training.emptypopup_add_training_request_annual">
			<input type="hidden" name="pos_code_list" id="pos_code_list" value="<cfoutput>#pos_code_list#</cfoutput>">
			<input type="hidden" name="first_boss_valid_date" id="first_boss_valid_date" value="">
			<input type="hidden" name="second_boss_valid_date" id="second_boss_valid_date" value="">
			<input type="hidden" name="third_boss_valid_date" id="third_boss_valid_date" value="">
			<input type="hidden" name="emp_valid_date" id="emp_valid_date" value="">
			<cf_box_elements>
					<div class="col col-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" style="margin-top:5px;">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57482.Aşama"></label>
							<div class="col col-8 col-xs-12">
								<cf_workcube_process is_upd='0' process_cat_width='200' is_detail='0'>
							</div>
						</div> 
						<div class="form-group">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58472.Dönem">*</label>
							<div class="col col-8 col-xs-12">
								<select name="period" id="period">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop from="#year(now())#" to="#year(now())+1#" index="i">
										<option value="<cfoutput>#i#</cfoutput>"><cfoutput>#i#</cfoutput></option>
									</cfloop>
								</select>
							</div>
						</div> 
						<div class="form-group">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57419.Eğitim'><cf_get_lang dictionary_id='38555.Talep Eden'></label>
							<div class="col col-8 col-xs-12">
								<input type="hidden" name="request_emp_id" id="request_emp_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
								<input type="hidden" name="request_position_code" id="request_position_code" readonly="yes" value="<cfoutput>#session.ep.position_code#</cfoutput>">
								<input type="text" name="request_emp_name" id="request_emp_name" readonly="yes" style="width:200px;" value="<cfoutput>#get_emp_info(session.ep.userid,0,0)#</cfoutput>">
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'>1</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="Hidden" name="validator_position_code_1" id="validator_position_code_1" value="<cfif len(get_position_detail.upper_position_code)><cfoutput>#get_position_detail.upper_position_code#</cfoutput></cfif>">
									<input type="text" name="validator_position_1" id="validator_position_1" style="width:200px;" value="<cfif len(get_position_detail.upper_position_code)><cfoutput>#get_emp_info(get_position_detail.upper_position_code,1,0)#</cfoutput></cfif>" readonly>
									<cfif not len(get_position_detail.upper_position_code)><span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_request_annual.validator_position_code_1&field_name=add_request_annual.validator_position_1','list');return false"></span></cfif> 
								</div>
							</div>
						</div>
						<div class="form-group">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57500.Onay'>2</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="validator_position_code_2" id="validator_position_code_2" value="<cfif len(get_position_detail.upper_position_code2)><cfoutput>#get_position_detail.upper_position_code2#</cfoutput></cfif>">
									<input type="text" name="validator_position_2" id="validator_position_2" style="width:200px;" value="<cfif len(get_position_detail.upper_position_code2)><cfoutput>#get_emp_info(get_position_detail.upper_position_code2,1,0)#</cfoutput></cfif>" readonly>
									<span class="input-group-addon icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_request_annual.validator_position_code_2&field_name=add_request_annual.validator_position_2','list');return false"></span>
								</div>
							</div>
						</div>
						<cfif len(x_manager_code)>
							<div class="form-group">
								<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29511.Yönetici'><cf_get_lang dictionary_id='57500.Onay'></label>
								<div class="col col-8 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="validator_position_code_2" id="validator_position_code_2" value="<cfif len(get_position_detail.upper_position_code2)><cfoutput>#get_position_detail.upper_position_code2#</cfoutput></cfif>">
										<input type="text" name="validator_position_2" id="validator_position_2" style="width:200px;" value="<cfif len(get_position_detail.upper_position_code2)><cfoutput>#get_emp_info(get_position_detail.upper_position_code2,1,0)#</cfoutput></cfif>" readonly>
										<a  class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_code=add_request_annual.validator_position_code_2&field_name=add_request_annual.validator_position_2','list');return false"></a>
									</div>
								</div>
							</div>
						</cfif>
					</div>
					<div class="col col-6 col-xs-12">
						<cf_grid_list>
							<input type="hidden" name="add_row_info" id="add_row_info" value="">
							<thead>
								<tr>
									<th colspan="4"><cf_get_lang dictionary_id="29912.Eğitimler"></th>
								</tr>
								<tr>			
									<th width="250"><cf_get_lang dictionary_id="57480.Konu"></th>
									<th><cf_get_lang dictionary_id="57485.Öncelik">*</th>
									<th><a href="javascript://" onclick="add_row();"><img src="images/plus_list.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></a></th>
								</tr>
							</thead>
							<tbody id="row_info"></tbody>
						</cf_grid_list>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons type_format='1' is_upd='0' add_function='kontrol()'>
				</cf_box_footer> 
		</cfform>
	</cf_box>
	<script type="text/javascript">
		var add_row_info = 0;
		function add_row()
		{	
			add_row_info++;
			add_request_annual.add_row_info.value=add_row_info;
			var newRow;
			var newCell;
			newRow = document.getElementById("row_info").insertRow(document.getElementById("row_info").rows.length);
			newRow.setAttribute("name","row_info" + add_row_info);
			newRow.setAttribute("id","row_info" + add_row_info);
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<div class="input-group"> <input type="hidden" name="train_id'+ add_row_info +'" id="train_id'+ add_row_info +'" value=""><input type="text" name="train_head'+ add_row_info +'" id="train_head'+ add_row_info +'" value=""><span href="javascript://" class="input-group-addon icon-ellipsis" onClick="windowopen('+"'<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_list_training_subjects&field_id=add_request_annual.train_id"+add_row_info+"&field_name=add_request_annual.train_head"+add_row_info+"','list');"+'"></span> </div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="text" name="priority'+ add_row_info +'" id="priority'+ add_row_info +'" value="" onKeyUp="isNumber(this);" style="width:50px;border:none;">';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML ='<input type="hidden" value="1" name="del_row_info'+ add_row_info +'"><a style="cursor:pointer" onclick="del_row(' + add_row_info + ');"><img  src="images/delete_list.gif" border="0" title="<cf_get_lang dictionary_id='57463.sil'>" alt="<cf_get_lang dictionary_id='57463.sil'>"></a>';
		}
		function del_row(dell)
		{
			var my_emement1=eval("add_request_annual.del_row_info"+dell);
			my_emement1.value=0;
			var my_element1=eval("row_info"+dell);
			my_element1.style.display="none";
		}
		function kontrol()
		{
			if (!process_cat_control()) return false;
			if(document.getElementById('period').value == '')
			{
				alert("Dönem seçiniz");
				return false;
			}
			if(document.getElementById('add_row_info').value == 0 || document.getElementById('add_row_info').value == '')
			{
				alert("Konu Seçiniz");
				return false;
			}
			var sayac = add_row_info;
			for (var r=1; r<=add_row_info;r++)
			{
				deger_my_value = eval("document.add_request_annual.train_id"+r);
				deger_my_valu2 = eval("document.add_request_annual.train_head"+r);
				oncelik = eval("document.add_request_annual.priority"+r);
				sil_row = eval("document.add_request_annual.del_row_info"+r);
				if (sil_row.value == 1)
				{
					if(deger_my_value.value == "" || deger_my_valu2.value == "")
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:Konu!");
						return false;
						break;
					}
					if(oncelik.value == "")
					{
						alert("<cf_get_lang_main no='782.girilmesi zorunlu alan'>:Öncelik!");
						return false;
						break;
					}
				}
				if (sil_row.value == 0)
				{
					sayac-=1;
				}
			}
			if(sayac == 0)
			{
				alert("Eğitim satırı eklemelisiniz");
				return false;
			}
			
			return true;
		}
	</script>
	