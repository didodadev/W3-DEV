<cf_xml_page_edit fuseact="myhome.list_myweek">
	<script type="text/javascript">
		function call(dd)
		{
			for(yy=1;yy<=dd;yy++)
			{
				add_row();
			}
		}
	</script>
	<cfscript>
		if (isdefined('url.yil'))
			tarih = url.yil;
		else
			tarih = dateformat(now(),'yyyy');
		if (isdefined('url.ay'))
			tarih=tarih&'-'&url.ay;
		else
			tarih=tarih&'-'&dateformat(now(),'mm');
		
		if (isdefined('url.gun'))
			tarih=tarih&'-'&url.gun;
		else
			tarih=tarih&'-'&dateformat(now(),'d');
		
		fark = (-1)*(dayofweek(tarih)-2);
		if (fark EQ 1) fark = -6;
	 
		last_week = date_add('d',fark-1,tarih);
		first_day = date_add('d',fark,tarih);
		second_day = date_add('d',1,first_day);
		third_day = date_add('d',2,first_day);
		fourth_day = date_add('d',3,first_day);
		fifth_day = date_add('d',4,first_day);
		sixth_day = date_add('d',5,first_day);
		seventh_day = date_add('d',6,first_day);
		next_week = date_add('d',7,first_day);
		attributes.to_day = date_add('h',-session.ep.time_zone, first_day);
	</cfscript>
	<cfset get_component = createObject("component", "V16.myhome.cfc.time_cost")>
	<cfset get_activity = get_component.get_activity()>
	<cfset get_time_cost_cats = get_component.get_time_cost_cats()>
	<cfset get_process_stage = get_component.get_process_stage(
		upd_myweek : "myhome.upd_myweek"
	)>
	<cfset get_time_cost = get_component.get_time_cost(
		next_week : next_week,
		to_day : attributes.to_day
	)>
	<script type="text/javascript">
		row_count=<cfoutput>#get_time_cost.recordcount#</cfoutput>;
		function sil(sy)
		{	
			var my_element=document.getElementById('row_kontrol'+sy);
			my_element.value=0;
			var my_element=eval("frm_row"+sy);
			my_element.style.display="none";
		}
		function add_row()
		{
			row_count++;
			var newRow;
			var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);
			newRow.className = 'color-row';
			document.getElementById('record_num').value=row_count;
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" value="" id="time_cost_id' + row_count +'" name="time_cost_id' + row_count +'"><input type="hidden" value="1" id="row_kontrol' + row_count +'" name="row_kontrol' + row_count +'"><span class="input-group-addon fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>" onclick="sil(' + row_count + ');"></span></div></div>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("id","today" + row_count + "_td");
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<input type="text" name="today' + row_count +'" id="today' + row_count +'"  maxlength="10"  validate="#validate_style#" required="yes" value="<cfoutput>#DateFormat(date_add('h',session.ep.time_zone,Now()),dateformat_style)#</cfoutput>"> ';
			wrk_date_image('today' + row_count);
			
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" name="total_time_hour' + row_count +'" id="total_time_hour' + row_count +'" <cfif isdefined('x_timecost_limited') and x_timecost_limited eq 0>maxlength="2"<cfelse>range="0,999"</cfif> validate="integer" style="width:30px;" class="boxtext" onKeyup="isNumber(this);return(FormatCurrency(this,event,0));"></div>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" name="total_time_minute' + row_count +'" id="total_time_minute' + row_count +'" maxlength="2" validate="integer" style="width:30px;" range="0,59" class="boxtext" onKeyup="return(FormatCurrency(this,event,0));"></div>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<select name="process_stage' + row_count +'"  id="process_stage' + row_count +'" style="width:70px;"><cfoutput query="get_process_stage"><option value="#process_row_id#">#stage#</option></cfoutput></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<select name="time_cost_cat' + row_count +'"  id="time_cost_cat' + row_count +'" style="width:70px;"><option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option><cfoutput query="get_time_cost_cats"><option value="#time_cost_cat_id#">#time_cost_cat#</option></cfoutput></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<select name="overtime_type' + row_count +'"  id="overtime_type' + row_count +'"><option value="1"><cf_get_lang dictionary_id='32287.Normal'></option><option value="2"><cf_get_lang dictionary_id='31547.Fazla Mesai'></option><option value="3"><cf_get_lang dictionary_id='31472.Hafta Sonu'></option><option value="4"><cf_get_lang dictionary_id='31473.Resmi Tatil'></option></select>';
			
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<div class="form-group"><input type="text" name="comment' + row_count +'" id="comment' + row_count +'" maxlength="300" style="width:300px;" class="boxtext" required></div>';
			
			<cfloop list="#ListDeleteDuplicates(xml_list_myweek_rows)#" index="xlr">
				<cfswitch expression="#xlr#">
					<cfcase value="1">
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute("nowrap","nowrap");
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="project_id'+ row_count +'" id="project_id'+ row_count +'" value=""><input type="text" id="project'+ row_count +'" name="project'+ row_count +'" value="" onFocus="AutoComplete_Create(\'project'+ row_count +'\',\'PROJECT_HEAD\',\'PROJECT_HEAD\',\'get_project\',\'\',\'PROJECT_ID,PARTNER_ID,COMPANY_ID,MEMBER_NAME,CONSUMER_ID\',\'project_id'+ row_count +',partner_id' + row_count +',company_id' + row_count +',member_name'+ row_count +',consumer_id'+ row_count +'\',\'my_week_timecost\',3,116);" style="width:135px;" class="boxtext"><span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_project('+ row_count +');"></span></div></div>';
					</cfcase>
					<cfcase value="2">
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute("nowrap","nowrap");
						newCell.innerHTML = '<input type="hidden" name="consumer_id' + row_count +'" id="consumer_id' + row_count +'" value="">';
						newCell.innerHTML += '<input type="hidden" name="partner_id' + row_count +'" id="partner_id' + row_count +'" value="">';
						newCell.innerHTML += '<input type="hidden" name="company_id' + row_count +'" id="company_id' + row_count +'" value="">';
						newCell.innerHTML += '<div class="form-group"><div class="input-group"><input type="text" name="member_name' + row_count +'" id="member_name' + row_count +'" value="" onFocus="AutoComplete_Create(\'member_name'+ row_count +'\',\'MEMBER_NAME,MEMBER_PARTNER_NAME\',\'MEMBER_NAME,MEMBER_PARTNER_NAME\',\'get_member_autocomplete\',\'1,2\',\'CONSUMER_ID,PARTNER_ID,COMPANY_ID\',\'consumer_id' + row_count +',partner_id' + row_count +',company_id' + row_count +'\',\'my_week_timecost\',3,116);"  style="width:110px;" class="boxtext"><span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_company('+ row_count +');"></span></div></div>';
					</cfcase>
					<cfcase value="3">
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute("nowrap","nowrap");
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="work_id' + row_count +'" id="work_id' + row_count +'" value=""><input type="text" name="work_head' + row_count +'" id="work_head' + row_count +'" value="" onFocus="AutoComplete_Create(\'work_head'+ row_count +'\',\'WORK_HEAD\',\'WORK_HEAD\',\'get_work\',\'\',\'WORK_ID\',\'work_id'+ row_count +'\',\'\',3,116);" style="width:128px;" class="boxtext"><span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_work('+ row_count +');"></span></div></div>';
					</cfcase>
					<cfcase value="4">
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute("nowrap","nowrap");
						newCell.innerHTML = '<select name="activity' + row_count +'" id="activity' + row_count +'" style="width:150px;"><option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option><cfoutput query="get_activity"><option value="#ACTIVITY_ID#">#ACTIVITY_NAME#</option></cfoutput></select>';
					</cfcase>
					<cfcase value="5">
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute("nowrap","nowrap");
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="expense_id' + row_count +'" id="expense_id' + row_count +'" value=""><input type="text" name="expense' + row_count +'" id="expense' + row_count +'" value="" onFocus="AutoComplete_Create(\'expense' + row_count +'\',\'EXPENSE,EXPENSE_CODE\',\'EXPENSE,EXPENSE_CODE\',\'get_expense_center\',\'\',\'EXPENSE_ID\',\'expense_id' + row_count +'\',\'my_week_timecost\',3,116);" style="width:116px;" class="boxtext"><span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_expense('+ row_count +');"></span></div></div>';
					</cfcase>
					<cfcase value="6">
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute("nowrap","nowrap");
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="service_id' + row_count +'" id="service_id' + row_count +'" value=""><input type="text" name="service_head' + row_count +'" id="service_head' + row_count +'" value=""  onFocus="AutoComplete_Create(\'service_head' + row_count +'\',\'SERVICE_NO,SERVICE_HEAD\',\'SERVICE_NO,SERVICE_HEAD\',\'get_service\',\'\',\'SERVICE_ID\',\'service_id' + row_count +'\',\'\',3,116);"  style="width:116px;" class="boxtext"><span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_service('+ row_count +');"></span></div></div>';
					</cfcase>
					<cfcase value="7">
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute("nowrap","nowrap");
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="event_id' + row_count +'" id="event_id' + row_count +'" value=""><input type="text" name="event_head' + row_count +'" id="event_head' + row_count +'" value="" onFocus="AutoComplete_Create(\'event_head' + row_count +'\',\'EVENT_HEAD\',\'EVENT_HEAD\',\'get_event\',\'\',\'EVENT_ID\',\'event_id' + row_count +'\',\'\',3,116);" style="width:116px;" class="boxtext"><span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_event('+ row_count +');"></span></div></div>';
					</cfcase>
					<cfcase value="8">
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute("nowrap","nowrap");
						newCell.innerHTML = '<input type="hidden" name="subscription_id' + row_count +'" id="subscription_id' + row_count +'" value="">';
						newCell.innerHTML += '<div class="form-group"><div class="input-group"><input type="text" name="subscription_no' + row_count +'" id="subscription_no' + row_count +'" value="" onFocus="AutoComplete_Create(\'subscription_no' + row_count +'\',\'SUBSCRIPTION_NO,SUBSCRIPTION_HEAD\',\'SUBSCRIPTION_NO,SUBSCRIPTION_HEAD\',\'get_subscription\',\'2\',\'SUBSCRIPTION_ID\',\'subscription_id' + row_count +'\',\'\',3,116);" style="width:116px;" class="boxtext"><span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_subscription('+ row_count +');"></span></div></div>';
					</cfcase>
					<cfcase value="9">
						newCell = newRow.insertCell(newRow.cells.length);
						newCell.setAttribute("nowrap","nowrap");
						newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="hidden" name="class_id' + row_count +'" id="class_id' + row_count +'" value=""><input type="text" name="class_name' + row_count +'" id="class_name' + row_count +'" style="width:116px;" onFocus="AutoComplete_Create(\'class_name' + row_count +'\',\'CLASS_NAME\',\'CLASS_NAME\',\'get_training_class\',\'2\',\'CLASS_ID\',\'class_id' + row_count +'\',\'\',3,116);" class="boxtext"><span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_class('+ row_count +');"></span></div></div>';
					</cfcase>
				</cfswitch>
			</cfloop>
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.setAttribute("nowrap","nowrap");
			newCell.innerHTML = '<select name="is_rd_ssk' + row_count +'"  id="is_rd_ssk' + row_count +'" ><option value="0"><cf_get_lang dictionary_id='57496.Hayır'></option><option value="1"><cf_get_lang dictionary_id='57495.Evet'></option></select>';
			
		}
		function pencere_ac_project(no)
		{
			if(eval('my_week_timecost.consumer_id'+no) != undefined)
				var project_str_ = 'company_id=my_week_timecost.company_id' + no +'&consumer_id=my_week_timecost.consumer_id' + no +'&company_name=my_week_timecost.member_name' + no+'&partner_id=my_week_timecost.partner_id' + no+'';
			else
				var project_str_ = '';
				openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&'+project_str_+'&project_id=my_week_timecost.project_id' + no +'&project_head=my_week_timecost.project' + no);
		}
		function pencere_ac_service(no)
		{
			if(eval('my_week_timecost.consumer_id'+no) != undefined)
				var service_str_ = 'field_comp_id=my_week_timecost.company_id' + no +'';
			else
				var service_str_ = '';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_add_crm&'+service_str_+'&field_id=my_week_timecost.service_id' + no +'&field_name=my_week_timecost.service_head' + no,'list');
		}
		function pencere_ac_event(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_events&field_id=my_week_timecost.event_id' + no +'&field_name=my_week_timecost.event_head' + no,'list');
		}
		function pencere_ac_expense(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_expense_center&field_id=my_week_timecost.expense_id' + no +'&is_invoice=1&field_name=my_week_timecost.expense' + no,'list');
		}
		function pencere_detail_work(no)
		{	
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=project.works&event=det&id='+eval("document.my_week_timecost.work_id"+no).value,'list');
		}
		
		function pencere_ac_work(no)
		{
			if(eval('my_week_timecost.consumer_id'+no) != undefined)
				var service_str1_ = 'comp_id=my_week_timecost.company_id'+ no +'&comp_name=my_week_timecost.member_name' + no +'';
			else
				var service_str1_ = '';
			if(eval('my_week_timecost.project_id'+no) != undefined)
				var service_str2_ = 'field_pro_id=my_week_timecost.project_id' + no +'&field_pro_name=my_week_timecost.project' + no +'';
			else
				var service_str2_ = '';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_add_work&'+service_str1_+'&'+service_str2_+'&field_id=my_week_timecost.work_id' + no +'&field_name=my_week_timecost.work_head' + no,'list');
		}
	
		function pencere_ac_subscription(no)
		{
			if(eval('my_week_timecost.consumer_id'+no) != undefined)
				var service_str_ = 'field_company_id=my_week_timecost.company_id' + no +'&field_company_name=my_week_timecost.member_name' + no+'';
			else
				var service_str_ = '';
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&'+service_str_+'&field_id=my_week_timecost.subscription_id' + no +'&field_no=my_week_timecost.subscription_no' + no,'list');
		}
		function pencere_ac_class(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_list_training_classes&field_id=my_week_timecost.class_id' + no +'&field_name=my_week_timecost.class_name' + no,'list');
		}
		function pencere_ac_company(no)
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&field_consumer=my_week_timecost.consumer_id' + no +'&field_comp_id=my_week_timecost.company_id' + no +'&field_member_name=my_week_timecost.member_name' + no +'&field_partner=my_week_timecost.partner_id' + no+'&select_list=2,3','list');
		}
		
		function kontrol_et()
		{
			if(row_count != 0)
			{
				var minsPerHour = 60;
				var minsPerDay = 24 * minsPerHour;
				var currentDate = null;
				var dateList = new Array();
				var myTimeCostList = new Array();
				for(i=1; i <= document.getElementById('record_num').value; i++)
				{
					deger_row_kontrol = eval("document.my_week_timecost.row_kontrol"+i);
					deger_comment = eval("document.my_week_timecost.comment"+i);
					deger_total_time_hour = eval("document.my_week_timecost.total_time_hour"+i);
					deger_total_time_minute = eval("document.my_week_timecost.total_time_minute"+i);
					if(eval("document.my_week_timecost.project_id"+i != undefined))
						deger_project = eval("document.my_week_timecost.project_id"+i);
					else
						deger_project = '';
					if(eval("document.my_week_timecost.work_id"+i != undefined))
						deger_work = eval("document.my_week_timecost.work_id"+i);
					else
						deger_work = '';
					<cfif isdefined('x_timecost_limited') and x_timecost_limited eq 0>
					if (deger_row_kontrol.value == 1)
					{
						if(document.getElementById("total_time_hour"+i).value == "") document.getElementById("total_time_hour"+i).value = 0;
						if(document.getElementById("total_time_minute"+i).value == "") document.getElementById("total_time_minute"+i).value = 0;
						
						var today_i = trim(String(document.getElementById("today"+i).value)); //date_add fonksiyonu sebebiyle tarih basinda bosluk oluyordu trim edildi fbs
						var total_hour_i = document.getElementById("total_time_hour"+i).value;
						var total_minute_i = document.getElementById("total_time_minute"+i).value;
						
						if(total_hour_i != 0 || total_minute_i != 0)
						{
							if(myTimeCostList[today_i] != undefined)
								myTimeCostList[today_i] = parseInt(myTimeCostList[today_i]) + (parseInt(total_hour_i*minsPerHour) + parseInt(total_minute_i));
							else
								myTimeCostList[today_i] = (parseInt(total_hour_i*minsPerHour) + parseInt(total_minute_i));
						}
						if(parseInt(myTimeCostList[today_i]) > parseInt(minsPerDay))
						{
							alert("(" + today_i + ") <cf_get_lang dictionary_id='31902.Zaman Harcaması Bir Gün İçin 24 Saatten Fazla Girilemez'>!");
							return false;
						}
						else
						{
							if(document.getElementById("total_time_hour"+i).value == 0) document.getElementById("total_time_hour"+i).value = "";
							if(document.getElementById("total_time_minute"+i).value == 0) document.getElementById("total_time_minute"+i).value = "";	
						}
						
						/* 20130313 fbs kaldirdi, yanlis hesapliyordu
						currentDate = eval("document.my_week_timecost.today"+i).value;
						var dateIndex = -1;
						for (d = 0; d < dateList.length; d++)
						{
							if (String(dateList[d].date) == String(currentDate))
							{
								dateIndex = d;
								break;
							}
						}
						if (trim(deger_total_time_hour.value).length == 0 && trim(deger_total_time_hour.value).length != 0){deger_total_time_hour.value = "0"};
						if (trim(deger_total_time_hour.value).length != 0 && trim(deger_total_time_minute.value).length == 0){deger_total_time_minute.value = "0"};
						
						if (dateIndex != -1)
						{
							dateList[dateIndex].totalMinutes = eval(dateList[dateIndex].totalMinutes) + eval(Number(deger_total_time_hour.value) * minsPerHour) + eval(Number(deger_total_time_minute.value));
						}
						else 
						{
							dateList.push({date: String(currentDate), totalMinutes: eval(Number(deger_total_time_hour.value) * minsPerHour) + eval(Number(deger_total_time_minute.value))});
							dateIndex = dateList.length - 1;
						}
						
						if (dateList[dateIndex].totalMinutes > minsPerDay)
						{
							alert("<cf_get_lang dictionary_id='1144.Zaman Harcaması Bir Gün İçin 24 Saatten Fazla Girilemez'>");
							return false;
						}
						*/
					}
					</cfif>
	
					if(deger_row_kontrol.value == 1)
					{	
						if((deger_total_time_hour.value != "" || deger_total_time_minute.value != "") && deger_comment.value == "")
						{
							alert( "<cf_get_lang dictionary_id='31629.Lütfen Açıklama Giriniz'>!");
							return false;
						}
						<cfif x_required_project eq 1>
						if((deger_total_time_hour.value != "" || deger_total_time_minute.value != "") && deger_project.value == "")
						{
							alert(i + ". <cf_get_lang dictionary_id='32338.Satır İçin Lütfen Proje Seçiniz'>!");
							return false;
						}
						</cfif>
						<cfif x_required_work eq 1>
						if((deger_total_time_hour.value != "" || deger_total_time_minute.value != "") && deger_work.value == "")
						{
							alert(i + ".<cf_get_lang dictionary_id='32339.Satır İçin Lütfen İş Seçiniz'>!");
							return false;
						}
						</cfif>
						if(deger_total_time_minute.value < 0 || deger_total_time_minute.value > 59)
						{ 
							alert ("<cf_get_lang dictionary_id='58127.Dakika'>: <cf_get_lang dictionary_id ='31631.1 ile 59 arası girebilirsiniz'>!");
							return false;
						}
					
					}
				}
			}
			<cfif browserDetect() contains 'Firefox'>
				return newRows();
			</cfif>
			return process_cat_control();
		}
	</script>
	<cfset date_list = " ">
	<cfloop query="get_time_cost">
		<cfif (datediff("d", EVENT_DATE, first_day) gte 0) and (datediff("d", first_day, EVENT_DATE) gte 0)><cfset date_list = listappend(date_list, first_day, ",")></cfif>
		<cfif (datediff("d", EVENT_DATE, second_day) gte 0) and (datediff("d", second_day, EVENT_DATE) gte 0)><cfset date_list = listappend(date_list, second_day, ",")></cfif>
		<cfif (datediff("d", EVENT_DATE, third_day) gte 0) and (datediff("d", third_day, EVENT_DATE) gte 0)><cfset date_list = listappend(date_list, third_day, ",")></cfif>
		<cfif (datediff("d", EVENT_DATE, fourth_day) gte 0) and (datediff("d", fourth_day, EVENT_DATE) gte 0)><cfset date_list = listappend(date_list, fourth_day, ",")></cfif>
		<cfif (datediff("d", EVENT_DATE, fifth_day) gte 0) and (datediff("d", fifth_day, EVENT_DATE) gte 0)><cfset date_list = listappend(date_list, fifth_day, ",")></cfif>
		<cfif (datediff("d", EVENT_DATE, sixth_day) gte 0) and (datediff("d", sixth_day, EVENT_DATE) gte 0)><cfset date_list = listappend(date_list, sixth_day, ",")></cfif>
		<cfif (datediff("d", EVENT_DATE, seventh_day) gte 0) and (datediff("d", seventh_day, EVENT_DATE) gte 0)><cfset date_list = listappend(date_list, seventh_day, ",")></cfif>
	</cfloop>
	<cfset date_list = listsort(date_list, "text", "asc", ",")>
	<cf_catalystHeader>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#getLang('myhome',611)#" scroll="1" closable="0">
			<cfform name="my_week_" method="post" action="#request.self#?fuseaction=myhome.upd_myweek">
				<div>
					<cfoutput>
						<a href="#request.self#?fuseaction=myhome.upd_myweek&yil=#dateformat(last_week,"yyyy")#&ay=#dateformat(last_week,"mm")#&gun=#dateformat(last_week,"dd")#"><i class="fa fa-caret-left" width="15" height="20"></i></a>
							#dateformat(first_day,dateformat_style)# - #dateformat(seventh_day,dateformat_style)#
						<a href="#request.self#?fuseaction=myhome.upd_myweek&yil=#dateformat(next_week,"yyyy")#&ay=#dateformat(next_week,"mm")#&gun=#dateformat(next_week,"dd")#"><i class="fa fa-caret-right" width="15" height="20"></i></a>
					</cfoutput>
				</div>
			</cfform>
			<cfform name="my_week_timecost" method="post" action="#request.self#?fuseaction=myhome.add_my_week_timecost">
					<cf_grid_list>
					<thead>
						<tr style="display:none;"><td><cf_workcube_process is_upd='0' is_detail='0'></td></tr>
						<tr>
							<th><div class="form-group"><div class="input-group"><input name="record_num" id="record_num" type="hidden" value="<cfoutput>#get_time_cost.recordcount#</cfoutput>"><span class="input-group-addon fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>" onclick="add_row();"></span></div></div>
							<th style="width: 75px;" nowrap="nowrap"><cf_get_lang dictionary_id='57490.Gün'></th>
							<th style="width: 30px;" nowrap><cf_get_lang dictionary_id='57491.Saat'></th>
							<th style="width: 30px;" nowrap><cf_get_lang dictionary_id='58827.Dk'>.</th>
							<th style="width: 70px;" nowrap><cf_get_lang dictionary_id ='58859.Süreç'></th>
							<th style="width: 70px;" nowrap><cf_get_lang dictionary_id ='57486.Kategori'></th>
							<th nowrap><cf_get_lang dictionary_id ='31990.Mesai Türü'></th>
							<th style="width: 300px;" nowrap><cf_get_lang dictionary_id='57629.Açıklama'> *</th>
							<!--- Satirlardaki Veriler Degisken Olarak Geliyor --->
							<cfloop list="#ListDeleteDuplicates(xml_list_myweek_rows)#" index="xlr">
								<cfswitch expression="#xlr#">
									<cfcase value="1"><th style="width: 125px;" nowrap><cf_get_lang dictionary_id='57416.Proje'></th></cfcase>
									<cfcase value="2"><th style="width: 125px;" nowrap><cf_get_lang dictionary_id='57519.Cari Hesap'></th></cfcase>
									<cfcase value="3"><th style="width: 140px;" nowrap><cf_get_lang dictionary_id='58445.İş'></th></cfcase>
									<cfcase value="4"><th style="width: 150px;" nowrap><cf_get_lang dictionary_id='32374.Aktiviteler'></th></cfcase>
									<cfcase value="5"><th style="width: 125px;" nowrap><cf_get_lang dictionary_id='58460.Masraf Merkezi'></th></cfcase>
									<cfcase value="6"><th style="width: 125px;" nowrap><cf_get_lang dictionary_id='57656.Servis'></th></cfcase>
									<cfcase value="7"><th style="width: 125px;" nowrap><cf_get_lang dictionary_id='31065.Toplantı'></th></cfcase>
									<cfcase value="8"><th style="width: 125px;" nowrap><cf_get_lang dictionary_id='58832.Abone'></th></cfcase>
									<cfcase value="9"><th style="width: 125px;" nowrap><cf_get_lang dictionary_id='57419.Eğitim'></th></cfcase>
								</cfswitch>
							</cfloop>
							<th style="width: 150px;" nowrap><cf_get_lang dictionary_id = "31750.ARGE Gününe Dahil"> *</th>
						</tr>
					</thead>
					<tbody id="table1">
						<cfoutput query="get_time_cost">
						<tr id="frm_row#currentrow#" onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row">
							<td><input type="hidden" name="time_cost_id#currentrow#" id="time_cost_id#currentrow#" value="#get_time_cost.time_cost_id#">
								<div class="form-group"><div class="input-group"><input type="hidden" value="1" id="row_kontrol#currentrow#" name="row_kontrol#currentrow#"><span class="input-group-addon fa fa-minus" title="<cf_get_lang dictionary_id='57463.Sil'>" alt="<cf_get_lang dictionary_id='57463.Sil'>" onclick="sil('#currentrow#');" ></span></div></div>
							</td>
							<td>
								<input type="text" required="yes" name="today#currentrow#" id="today#currentrow#" value="#DateFormat(date_add('h',session.ep.time_zone,get_time_cost.event_date),dateformat_style)#" maxlength="10">
								<cf_wrk_date_image date_field="today#currentrow#">
									
							</td>
							<td style="width:30px;"><cfset totalminute = expensed_minute mod 60>
								<cfset totalhour = (expensed_minute-totalminute)/60>
								<cfif isdefined('x_timecost_limited') and x_timecost_limited eq 0>
									<cfinput type="text" name="total_time_hour#currentrow#" id="total_time_hour#currentrow#" value="#totalhour#" onKeyUp="isNumber(this);" class="boxtext" maxlength="2" validate="integer" style="width:40px;">
								<cfelse>
									<cfinput type="text" name="total_time_hour#currentrow#" id="total_time_hour#currentrow#" value="#totalhour#" onKeyUp="isNumber(this);" class="boxtext" validate="integer" style="width:40px;">
								</cfif>
							</td>
							<td style="width:30px;"><cfinput type="text" class="boxtext" name="total_time_minute#currentrow#" id="total_time_minute#currentrow#" maxlength="2" validate="integer" style="width:40px;" value="#totalminute#"></td>
							<td style="width:70px;">
								<select name="process_stage#currentrow#" id="process_stage#currentrow#" style="width:70px;">
									<cfloop query="get_process_stage">
										<cfif is_stage_back eq 1 or (is_stage_back eq 0 and line_number gte get_time_cost.line_number)><option value="#process_row_id#" <cfif get_time_cost.time_cost_stage eq process_row_id>selected</cfif>>#stage#</option></cfif>
									</cfloop>
								</select>
							</td>
							<td style="width:70px;">
								<select name="time_cost_cat#currentrow#" id="time_cost_cat#currentrow#" style="width:70px;">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfloop query="get_time_cost_cats">
										<option value="#time_cost_cat_id#"<cfif get_time_cost.time_cost_cat_id eq time_cost_cat_id>selected</cfif>>#time_cost_cat#</option>
									</cfloop>
								</select>
							</td>
							<td >
								<select name="overtime_type#currentrow#" id="overtime_type#currentrow#">
									<option value="1"<cfif get_time_cost.OVERTIME_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id='32287.Normal'></option>
									<option value="2"<cfif get_time_cost.OVERTIME_TYPE eq 2>selected</cfif>><cf_get_lang dictionary_id='31547.Fazla Mesai'></option>
									<option value="3"<cfif get_time_cost.OVERTIME_TYPE eq 3>selected</cfif>><cf_get_lang dictionary_id='31472.Hafta Sonu'></option>
									<option value="4"<cfif get_time_cost.OVERTIME_TYPE eq 4>selected</cfif>><cf_get_lang dictionary_id='31473.Resmi Tatil'></option>
								</select>
							</td>
							<td style="width:300px;"><cfset Comment_ = Replace(comment,'"','')>
								<input type="text" class="boxtext" name="comment#currentrow#" id="comment#currentrow#" style="width:300px;" maxlength="300" value="#Comment_#">
							</td>
							<cfloop list="#ListDeleteDuplicates(xml_list_myweek_rows)#" index="xlr">
								<cfswitch expression="#xlr#">
									<cfcase value="1">                                
										<td style="width:140px;" nowrap="nowrap">
											<div class="form-group">
												<div class="input-group">
													<input type="text" class="boxtext" name="project#currentrow#" id="project#currentrow#"  style="width:135px;" onfocus="AutoComplete_Create('project#currentrow#','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID,PARTNER_ID,COMPANY_ID,MEMBER_NAME,CONSUMER_ID','project_id#currentrow#,partner_id#currentrow#,company_id#currentrow#,member_name#currentrow#,consumer_id#currentrow#','my_week_timecost','3','110');" value="#PROJECT_HEAD#" autocomplete="off">
													<input type="hidden" name="project_id#currentrow#" id="project_id#currentrow#" value="#project_id#">
													<span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_project('#currentrow#');"></span>
												</div>
											</div		
										</td>
									</cfcase>
									<cfcase value="2">
										<td style="width:125px;" nowrap="nowrap">
											<div class="form-group">
												<div class="input-group">	
													<input type="hidden" name="consumer_id#currentrow#" id="consumer_id#currentrow#" value="#consumer_id#">
													<input type="hidden" name="partner_id#currentrow#" id="partner_id#currentrow#" value="#partner_id#">
													<input type="hidden" name="company_id#currentrow#" id="company_id#currentrow#" value="#company_id#">
													<cfif len(company_id)>
														<input type="text" name="member_name#currentrow#" id="member_name#currentrow#" onfocus="AutoComplete_Create('member_name#currentrow#','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'1,2\',0,0,0','CONSUMER_ID,PARTNER_ID,COMPANY_ID','consumer_id#currentrow#,partner_id#currentrow#,company_id#currentrow#','','3','200');" style="width:110px;" value="#get_par_info(company_id,1,1,0)#" class="boxtext">
													<cfelseif len(consumer_id)>
														<input type="text" name="member_name#currentrow#" id="member_name#currentrow#" onfocus="AutoComplete_Create('member_name#currentrow#','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'1,2\',0,0,0','CONSUMER_ID,PARTNER_ID,COMPANY_ID','consumer_id#currentrow#,partner_id#currentrow#,company_id#currentrow#','','3','200');" style="width:110px;" value="#get_cons_info(consumer_id,0,0,0)#" class="boxtext">
													<cfelse>
														<input type="text" name="member_name#currentrow#" id="member_name#currentrow#" onfocus="AutoComplete_Create('member_name#currentrow#','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','\'1,2\',0,0,0','CONSUMER_ID,PARTNER_ID,COMPANY_ID','consumer_id#currentrow#,partner_id#currentrow#,company_id#currentrow#','','3','200');" value="" style="width:110px;" class="boxtext">
													</cfif>
													<span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_company('#currentrow#');"></span>
												</div>
											</div>
										</td>
									</cfcase>
									<cfcase value="3">
										<td style="width:140px;" nowrap="nowrap">
											<div class="form-group">
												<div class="input-group">
													<input type="text" class="boxtext" name="work_head#currentrow#" id="work_head#currentrow#" style="width:110px;" value="#WORK_HEAD#" onfocus="AutoComplete_Create('work_head#currentrow#','WORK_HEAD','WORK_HEAD','get_work','','WORK_ID','work_id#currentrow#','','3','110')">
													<input type="hidden" class="boxtext" name="work_id#currentrow#" id="work_id#currentrow#" value="#WORK_ID#">
													<cfif len(work_id)><span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='58445.iş'><cf_get_lang dictionary_id='57771.detayı'>" onclick="pencere_detail_work('#currentrow#');"></span><cfelse></cfif>
														<span class="input-group-addon icon-ellipsis btnPointer" title="<cf_get_lang dictionary_id='58691.iş listesi'>" onclick="pencere_ac_work('#currentrow#');"></span> 
												</div>
											</div>					
										</td>
									</cfcase>
									<cfcase value="4">
										<td style="width:150px;">
											<select name="activity#currentrow#" id="activity#currentrow#" style="width:150px;">
												<option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
													<cfloop query="get_activity">
														<option value="#activity_id#"<cfif get_time_cost.activity_id eq activity_id>selected</cfif>>#ACTIVITY_NAME#</option>
													</cfloop>
											</select>	
										</td>
									</cfcase>
									<cfcase value="5">
										<td style="width:125px;" nowrap="nowrap">
											<div class="form-group">
												<div class="input-group">
													<input name="expense#currentrow#" id="expense#currentrow#" type="text" value="#expense#" style="width:110px;" class="boxtext" onfocus="AutoComplete_Create('expense#currentrow#','EXPENSE,EXPENSE_CODE','EXPENSE,EXPENSE_CODE','get_expense_center','','EXPENSE_ID','expense_id#currentrow#','my_week_timecost','3','110')" autocomplete="off">
													<input type="hidden" name="expense_id#currentrow#" id="expense_id#currentrow#" value="#EXPENSE_ID#" class="boxtext">
													<span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_expense('#currentrow#');"></span> 
												</div>
											</div>			
										</td>
									</cfcase>
									<cfcase value="6">
										<td style="width:125px;" nowrap="nowrap">
											<div class="form-group">
												<div class="input-group">
													<input type="text" name="service_head#currentrow#" id="service_head#currentrow#" value="#service_head#" style="width:110px;" class="boxtext" onfocus="AutoComplete_Create('service_head#currentrow#','SERVICE_NO,SERVICE_HEAD','SERVICE_NO,SERVICE_HEAD','get_service','','SERVICE_ID,SERVICE_HEAD','service_id#currentrow#,service_head#currentrow#','my_week_timecost','3','110')">
													<input type="hidden" name="service_id#currentrow#" id="service_id#currentrow#" value="#service_id#">
													<span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_service('#currentrow#');"></span>
												</div>
											</div>			
										</td>
									</cfcase>
									<cfcase value="7">
										<td style="width:125px;" nowrap="nowrap">
											<div class="form-group">
												<div class="input-group">
													<input type="text" name="event_head#currentrow#" id="event_head#currentrow#" value="#event_head#" style="width:110px;" onfocus="AutoComplete_Create('event_head#currentrow#','EVENT_HEAD','EVENT_HEAD','get_event','','EVENT_ID','event_id#currentrow#','','3','200');" class="boxtext">
													<input type="hidden" name="event_id#currentrow#" id="event_id#currentrow#" value="#event_id#">
													<span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_event('#currentrow#');"></span>
												</div>
											</div>	
										</td>
									</cfcase>
									<cfcase value="8">
										<td style="width:125px;" nowrap="nowrap">
											<div class="form-group">
												<div class="input-group">
													<input type="text" class="boxtext" name="subscription_no#currentrow#" id="subscription_no#currentrow#" value="#subscription_no#" onfocus="AutoComplete_Create('subscription_no#currentrow#','SUBSCRIPTION_NO,SUBSCRIPTION_HEAD','SUBSCRIPTION_NO','get_subscription','2','SUBSCRIPTION_ID','subscription_id#currentrow#','','3','200');" style="width:110px;">
													<input type="hidden" class="boxtext" name="subscription_id#currentrow#"  id="subscription_id#currentrow#" value="#subscription_id#">
													<span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_subscription('#currentrow#');"></span>
												</div>
											</div>			
										</td>
									</cfcase>
									<cfcase value="9">
										<td style="width:125px;" nowrap="nowrap">
											<div class="form-group">
												<div class="input-group">
													<input type="text" class="boxtext" name="class_name#currentrow#" id="class_name#currentrow#" value="#class_name#" onfocus="AutoComplete_Create('class_name#currentrow#','CLASS_NAME','CLASS_NAME','get_training_class','','CLASS_ID','class_id#currentrow#','','3','200');" style="width:110px;" >
													<input type="hidden" class="boxtext" name="class_id#currentrow#" id="class_id#currentrow#" value="#CLASS_ID#">
													<span class="input-group-addon icon-ellipsis btnPointer" onclick="pencere_ac_class('#currentrow#');"></span>
												</div>
											</div>		
										</td>
									</cfcase>
								</cfswitch>
							</cfloop>
							<td style="width:300px;">
								<select name="is_rd_ssk#currentrow#" id="is_rd_ssk#currentrow#" >
									<option value="0" <cfif get_time_cost.is_rd_ssk eq 0>selected</cfif>><cf_get_lang dictionary_id = "57496.Hayır" ></option>
									<option value="1" <cfif get_time_cost.is_rd_ssk eq 1>selected</cfif>><cf_get_lang dictionary_id = "57495.Evet"></option>
								</select>
							</td>
						</tr>
						</cfoutput>
						<input type="hidden" name="call_count" id="call_count" value="<cfoutput>#10-get_time_cost.recordcount#</cfoutput>">
						<script type="text/javascript">
							call(document.my_week_timecost.call_count.value);
						</script>
					</tbody>
					</cf_grid_list>
				<cf_box_footer>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<cfif get_time_cost.recordcount>
								<cf_get_lang dictionary_id='34989.Harcanan Zaman'>:&nbsp
							<cfquery name="total_time" dbtype="query">
								SELECT SUM(EXPENSED_MINUTE) TOTAL_TIME FROM GET_TIME_COST
							</cfquery>
							<cfset totalminute = total_time.total_time mod 60>
							<cfset totalhour = (total_time.total_time-totalminute)/60>
								<cfoutput><b>#totalhour#&nbsp<cf_get_lang dictionary_id ='57491.saat'>&nbsp#totalminute#&nbsp<cf_get_lang dictionary_id ='58127.dakika'> </b></cfoutput>
						</cfif>
					</div>
					<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
						<cf_workcube_buttons is_upd='0' add_function='kontrol_et()'>
					</div>
				</cf_box_footer>
			</cfform>
		</cf_box>
	</div>
	<script type="text/javascript">
		function newRows()
		{
			for(i=1;i<=row_count;i++)
			{   
				document.my_week_timecost.appendChild(document.getElementById('comment' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('total_time_hour' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('total_time_minute' + i + '')); 
				document.my_week_timecost.appendChild(document.getElementById('project_id' + i + '')); 
				document.my_week_timecost.appendChild(document.getElementById('project' + i + '')); 
				document.my_week_timecost.appendChild(document.getElementById('service_id' + i + '')); 	
				document.my_week_timecost.appendChild(document.getElementById('service_head' + i + ''));	
				document.my_week_timecost.appendChild(document.getElementById('event_id' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('event_head' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('expense_id' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('expense' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('consumer_id' + i + '')); 
				document.my_week_timecost.appendChild(document.getElementById('partner_id' + i + '')); 	
				document.my_week_timecost.appendChild(document.getElementById('company_id' + i + ''));	
				document.my_week_timecost.appendChild(document.getElementById('member_name' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('work_id' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('work_head' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('subscription_id' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('subscription_no' + i + '')); 
				document.my_week_timecost.appendChild(document.getElementById('class_id' + i + '')); 	
				document.my_week_timecost.appendChild(document.getElementById('class_name' + i + ''));	
				document.my_week_timecost.appendChild(document.getElementById('today' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('time_cost_id' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('row_kontrol' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('overtime_type' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('activity' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('time_cost_cat' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('process_stage' + i + ''));
				document.my_week_timecost.appendChild(document.getElementById('is_rd_ssk' + i + ''));
			}
		return true;
		}
	</script>	
	