
<cfscript>
	get_demands = createObject("component","V16.myhome.cfc.get_travel_demands");
	get_payment_request = get_demands.get_payment_request(travel_demand_id : attributes.travel_demand_id);
	get_department = get_demands.get_department(position_code : get_payment_request.emp_position_id);
	get_emp_pos = get_demands.get_emp_pos(position_id : get_payment_request.emp_position_id);
</cfscript>
<cf_catalystHeader>
<cfsavecontent variable="title"><cf_get_lang dictionary_id="59930.Seyahat Talebi"> <cf_get_lang dictionary_id="57771.Detay"></cfsavecontent>
<div class="col col-12 col-xs-12">
<cf_box title = "#title#" closable="0">
    <cfform name = "travel_demand_valid" method="post" action="">
        <input type="hidden" name="travel_demand_id" id="travel_demand_id" value="<cfoutput>#attributes.travel_demand_id#</cfoutput>">
        <input type="hidden" name="valid_1" id="valid_1" value="">
        <input type="hidden" name="valid_2" id="valid_2" value="">
        <cf_box_elements>
			<div class="col col-12 col-md-12 col-sm-12 col-xs-12" type="column" index="1" sort="true">
				<cfoutput query="get_payment_request">
						<!---Seyahat Bilgileri--->
						<cfsavecontent variable="header1"><cf_get_lang dictionary_id="59973.Seyahat"><cf_get_lang dictionary_id="37022.Bilgileri"></cfsavecontent>
							<cf_seperator id="travel_info" header="#header1#">
							<cf_box_elements id="travel_info">
								<div class="col col-6 col-xs-12">
									<div class="form-group" id="item-emp_name">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30368.Çalışan'></label>
										<div class="col col-8 col-xs-12">
												<input name="emp_name" type="text" id="emp_name" readonly="readonly" value="#get_emp_info(employee_id,0,0)#">	
										</div>
									</div>
									<div class="form-group" id="item-emp_position_id">						
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
										<div class="col col-8 col-xs-12">
												<input name="position_name" type="text" id="position_name" readonly="readonly" value="#get_emp_pos.position_name#">
										</div>
									</div>
									<div class="form-group" id="item-emp_department_id">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57572.Departman"></label>
										<div class="col col-8 col-xs-12">
											<input name="emp_department" type="text" id="emp_department"  readonly="readonly" value="#get_department.department_head#">
										</div>
									</div>
									<div class="form-group" id="item-place">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="60394.Gidilecek Ülke"></label>
										<div class="col col-8 col-xs-12">
											<input name="emp_department" type="text" id="emp_department"  readonly="readonly" value="#place#">
										</div>
									</div>
									<div class="form-group" id="item-city">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="60395.Gidilecek Şehir"></label>
										<div class="col col-8 col-xs-12">
											<input class="city" type="text" name="city" id="city" maxlength="200" readonly value="#city#">
										</div>
									</div>
									<div class="form-group" id="item-top_title_id">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="60397.Birlikte Seyahat Edilen En Üst Ünvanlı Personel"></label>
										<div class="col col-8 col-xs-12">
											<input type="text" name="top_title" id="top_title" value="#get_emp_info(top_title_id,0,0)#" readonly>
										</div>
									</div>
								</div>
								<div class="col col-6 col-xs-12">
									<div class="ui-form-block">
										<div class="form-group" id="item-task_causes">
											<label><cf_get_lang dictionary_id="29525.Görevlendirme"><cf_get_lang dictionary_id="34777.Nedeni"></label>
											<textarea name="task_causes" id="task_causes" readonly>#task_causes#</textarea>
										</div>
									</div>
									<div class="form-group" id="item-travel_type">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59973.Seyahat"><cf_get_lang dictionary_id="58651.Türü"></label>
										<div class="col col-8 col-xs-12">
											<input type="text" name="travel_type" id="travel_type" readonly value="<cfif travel_type eq 1><cf_get_lang dictionary_id="60477.Görev Seyahatleri"><cfelseif travel_type eq 2><cf_get_lang dictionary_id="60478.Uzun Süreli Seyahatler"><cfelseif travel_type eq 3><cf_get_lang dictionary_id="60479.Eğitim Seyahatleri"></cfif>">
										</div>
									</div>
									<div class="form-group" id="item-project_id">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57416.proje'></label>
										<div class="col col-8 col-xs-12">
											<input type="text" name="project_head" id="project_head" readonly value="<cfif isdefined('project_id') and len(project_id)>#get_project_name(project_id)#</cfif>">
										</div>
									</div>
								</div>
							</cf_box_elements>
								<!---Yol Dahil Görevlendirme Bilgileri--->
						<cfsavecontent variable="header2"><cf_get_lang dictionary_id="60400.Yol Dahil"><cf_get_lang dictionary_id="29525.Görevlendirme"><cf_get_lang dictionary_id="37022.Bilgileri"></cfsavecontent>
							<cf_seperator id="task_info" header="#header2#">
							<cf_box_elements id="task_info">
									<div class="form-group col col-6 col-xs-12" id="item-departure_date">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>*</label>
										<div class="col col-8 col-xs-12">
											<cfinput type="text" name="departure_date" id="departure_date" readonly value="#dateFormat(departure_date,dateformat_style)#" validate="#validate_style#" maxlength="10" required="yes" onchange="totalday()">
										</div>
									</div>
									<div class="form-group col col-6 col-xs-12" id="item-fare">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60402.Bilet Ücreti'></label>
										<div class="col col-6 col-xs-12">
											<input type="text" name="fare" id="fare" class="moneybox" readonly value="#TLformat(fare)#" onkeyup="isNumber(this);return(FormatCurrency(this,event,4));">
										</div>
										<div class="col col-2 col-xs-12">
											<input type="text" name="fare_type" id="fare_type" class="moneybox" value="#fare_type#" readonly>  
										</div>
									</div>
									<div class="form-group col col-6 col-xs-12" id="item-departure_of_date">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
										<div class="col col-8 col-xs-12">
											<cfinput type="text" name="departure_of_date" id="departure_of_date" readonly value="#dateFormat(departure_of_date,dateformat_style)#" validate="#validate_style#" maxlength="10" required="yes" onChange="totalday()">
										</div>
									</div>
									<div class="form-group col col-6 col-xs-12" id="item-departure_of_date_">
									</div>
									<cfif len(departure_date) and len(departure_of_date)>
										<cfset sum_day=datediff('d',departure_date,departure_of_date) + 1>
									<cfelse>
										<cfset sum_day= 0>
									</cfif>
									<div class="form-group col col-6 col-xs-12" id="item-sum_day">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57492.Toplam'><cf_get_lang dictionary_id='30201.Görev'><cf_get_lang dictionary_id='48188.Gün Sayısı'></label>
										<div class="col col-4 col-xs-12">
											<input type="text" name="sum_day" id="sum_day" readonly value="#sum_day#" >
										</div>
									</div>
									<div class="form-group col col-12 col-xs-12" id="item-task_detail">
										<label class="col col-2 col-xs-12"><cf_get_lang dictionary_id='57467.Not'></label>
										<div class="col col-10 col-xs-12">
											<textarea name="task_detail" id="task_detail" readonly>#task_detail#</textarea>
										</div>
									</div>
										<div class="form-group  col col-6 col-xs-12" id="item-is_vehicle_demand">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='55335.Araç Talebi'></label>
											<div class="col col-4">
												<label  class="col col-3"><cfif is_vehicle_demand eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></label>
											</div>
										</div>					
										<div class="form-group  col col-6 col-xs-12" id="item-demand_cause" style="<cfif is_vehicle_demand eq 1>display:'';<cfelse>display:none;</cfif>">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31317.Talep Nedeni'></label>
											<div class="col col-8 col-xs-12">
												<input type="text" name="demand_cause" id="demand_cause" readonly value="#demand_cause#">
											</div>
										</div>
										<div class="form-group  col col-6 col-xs-12" id="item-is_hotel_demand">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60408.Otel Talebi'></label>
											<div class="col col-4">
												<label  class="col col-3"><cfif is_hotel_demand eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></label>									
											</div>
										</div>
										<div class="form-group  col col-6 col-xs-12" id="item-hotel_name" style="<cfif is_hotel_demand eq 1>display:block;<cfelse>display:none;</cfif>">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60418.Otel İsmi'></label>
											<div class="col col-8 col-xs-12">
												<input type="text" name="hotel_name" id="hotel_name" readonly value="#hotel_name#">
											</div>
										</div>
										<div class="form-group  col col-6 col-xs-12" id="item-hotel_payment" style="<cfif is_hotel_demand eq 1>display:'';<cfelse>display:none;</cfif>">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="60410.Otel Ödemesi"></label>
											<div class="col col-8 col-xs-12">
												<input type="text" name="hotel_payment" id="hotel_payment" readonly value="#hotel_payment#">
											</div>
										</div>
										<div class="form-group  col col-6 col-xs-12" id="item-night_fare" style="<cfif is_hotel_demand eq 1>display:'';<cfelse>display:none;</cfif>">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60419.Gecelik Ücret'>*</label>
											<div class="col col-5 col-xs-12">
												<input type="text" name="night_fare" id="night_fare" class="moneybox" value="#TLFormat(night_fare)#" readonly>
											</div>
											<label class="col col-1 col-xs-12"><cf_get_lang dictionary_id='57636.Birim'></label>
											<div class="col col-2 col-xs-12">
												<input type="text" name="night_fare_money_type" id="night_fare_money_type" value="#night_fare_money_type#" readonly>
											</div>
										</div>
										<div class="form-group  col col-6 col-xs-12" id="item-is_visa_requirement">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60414.Vize İhtiyacı'></label>
												<div class="col col-4">
													<label  class="col col-3"><cfif is_visa_requirement eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></label>					
												</div>
										</div>
										<div class="form-group  col col-6 col-xs-12" id="item-visa_fare"  style="<cfif is_visa_requirement eq 1>display:'';<cfelse>display:none;</cfif>">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60420.Vize Ücreti'>*</label>
											<div class="col col-5 col-xs-12">
													<input type="text" name="visa_fare" id="visa_fare" class="moneybox" readonly value="#TLFormat(visa_fare)#" onkeyup="isNumber(this);return(FormatCurrency(this,event));">
											</div>
											<label class="col col-1 col-xs-12"><cf_get_lang dictionary_id='57636.Birim'></label>
											<div class="col col-2 col-xs-12">
												<input type="text" name="visa_fare_money_type" id="visa_fare_money_type" value="#visa_fare_money_type#" readonly> 
											</div>
										</div>
										<div class="form-group  col col-6 col-xs-12" id="item-flight_class_demand">
											<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="31181.Talep Edilen"><cf_get_lang dictionary_id="60415.Uçuş Sınıfı"></label>
											<div class="col col-8 col-xs-12">
													<input type="text" readonly value="<cfif flight_class_demand eq 1><cf_get_lang dictionary_id="60416.Business"><cfelseif flight_class_demand eq 2><cf_get_lang dictionary_id="60417.Ekonomi"></cfif>">
												</select>
											</div>
										</div>
							</cf_box_elements>
								<!---Avans Bilgileri--->
						<cfsavecontent variable="header3"><cf_get_lang dictionary_id="58204.Avans"><cf_get_lang dictionary_id="37022.Bilgileri"></cfsavecontent>
							<cf_seperator id="advance_info" header="#header3#">
							<cf_box_elements id="advance_info">
								<div class="col col-6 col-xs-12">
								<div class="form-group" id="item-is_travel_advance_demand" style="<cfif travel_type eq 1>display:;<cfelse>display:none;</cfif>"> 
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59973.Seyahat'><cf_get_lang dictionary_id="30914.Avans Talebi">/ <cf_get_lang dictionary_id="31282.Ücret"></label>
											<div class="col col-4">
												<label class="col col-3"><cfif is_travel_advance_demand eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></label>										
											</div>
									</div>
									<div class="form-group" id="item-is_hotel_advance_demand" style="<cfif is_hotel_demand eq 1>display:'';<cfelse>display:none;</cfif>">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60421.Otel'><cf_get_lang dictionary_id="30914.Avans Talebi">/ <cf_get_lang dictionary_id="31282.Ücret"></label>
											<div class="col col-4">
												<label class="col col-3"><cfif is_hotel_advance_demand eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></cfif></label>	
											</div>
									</div>
									<div class="form-group" id="item-is_departure_fee">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60422.Yurtdışı Çıkış Harcı Yatırılması Gerekiyor mu?'></label>
											<div class="col col-4">
												<label class="col col-3"><cfif is_departure_fee eq 1><cf_get_lang dictionary_id='57495.Evet'><cfelse><cf_get_lang dictionary_id='57496.Hayır'></label></cfif>
											</div>
									</div>
								</div>
								<div class="col col-6 col-xs-12">
								<div class="form-group" id="item-travel_advance_demand_fare" style="<cfif travel_type eq 1>display:;<cfelse>display:none;</cfif>"> 
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31282.Ücret'></label>
										<div class="col col-5 col-xs-12">
												<input type="text" name="travel_advance_demand_fare" id="travel_advance_demand_fare" readonly class="moneybox" value="#TLFormat(travel_advance_demand_fare)#" onkeyup="isNumber(this);return(FormatCurrency(this,event));">
										</div>
										<label class="col col-1 col-xs-12"><cf_get_lang dictionary_id='57636.Birim'></label>
										<div class="col col-2 col-xs-12">                                  
											<input type="text" name="travel_advance_demand_type" id="travel_advance_demand_type" value="#travel_advance_demand_type#" readonly/>  
										</div>
									</div>
									<div class="form-group" id="item-hotel_advance_demand_fare" style="<cfif is_hotel_advance_demand eq 1>display:'';<cfelse>display:none;</cfif>">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='31282.Ücret'></label>
										<div class="col col-5 col-xs-12">
											<input type="text" name="hotel_advance_demand_fare" id="hotel_advance_demand_fare" readonly class="moneybox" value="#TLFormat(hotel_advance_demand_fare)#" onkeyup="isNumber(this);return(FormatCurrency(this,event));">
										</div>
										<label class="col col-1 col-xs-12"><cf_get_lang dictionary_id='57636.Birim'></label>
										<div class="col col-2 col-xs-12"> 
											<input type="text" name="hotel_advance_demand_type" id="hotel_advance_demand_type" readonly value="#hotel_advance_demand_type#"/>  
										</div>
									</div>
								</div>
							</cf_box_elements>	
							<!---Etkinlik Bilgileri--->
						<cfsavecontent variable="header4"><cf_get_lang dictionary_id="51624.Etkinlik Bilgileri"></cfsavecontent>
							<cf_seperator id="activity_info" header="#header4#">
							<cf_box_elements id="activity_info">
								<div class="col col-6 col-xs-6">
									<div class="form-group" id="item-activity_start_date">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
										<div class="col col-8 col-xs-12">
											<div class="input-group">
												<input type="text" name="activity_start_date" id="activity_start_date" readonly value="#dateFormat(activity_start_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
											</div>
										</div>
									</div>
									<div class="form-group" id="item-activity_finish_date">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
										<div class="col col-8 col-xs-12">
											<div class="input-group">
												<input type="text" name="activity_finish_date" id="activity_finish_date" readonly value="#dateFormat(activity_finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
											</div>
										</div>
									</div>
								</div>
								<div class="col col-6 col-xs-6">	
									<div class="form-group" id="item-activity_fare">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29465.Etkinlik'><cf_get_lang dictionary_id='31282.Ücret'></label>
										<div class="col col-6 col-xs-12">
											<input type="text" name="activity_fare" id="activity_fare" class="moneybox" readonly value="#TLFormat(filternum(activity_fare))#" onkeyup="isNumber(this);return(FormatCurrency(this,event));">
										</div>
										<div class="col col-2 col-xs-12">
											<input type="text" name="activity_fare_money_type" id="activity_fare_money_type" readonly class="moneybox" value="#activity_fare_money_type#"> 
										</div>
									</div>
								</div>
								<div class="col col-12 col-xs-12">
									<div class="form-group" id="item-activity_detail">
										<label class="col col-2 col-xs-12"><cf_get_lang dictionary_id='57467.Not'></label>
										<div class="col col-10 col-xs-12">
											<textarea name="activity_detail" id="activity_detail" readonly>#activity_detail#</textarea>
										</div>
									</div>
								</div>
							</cf_box_elements>	
						<!---Kişisel Seyahat Tercihleri--->
						<cfsavecontent variable="header5"><cf_get_lang dictionary_id="29688.Kişisel"><cf_get_lang dictionary_id="59973.Seyahat"><cf_get_lang dictionary_id="44333.Tercihi"></cfsavecontent>
							<cf_seperator id="personal_travel_info" header="#header5#">
							<cf_box_elements id="personal_travel_info">
								<div class="col col-6 col-xs-6">
									<div class="form-group" id="item-flight_departure_date">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60427.Uçak'><cf_get_lang dictionary_id='45410.Gidiş Tarihi'></label>
										<div class="col col-8 col-xs-12">
											<div class="input-group">
												<input type="text" name="flight_departure_date" id="flight_departure_date" readonly value="#dateFormat(flight_departure_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
											</div>
										</div>
									</div>
									<div class="form-group" id="item-flight_departure_of_date">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60427.Uçak'><cf_get_lang dictionary_id='45408.Dönüş Tarihi'></label>
										<div class="col col-8 col-xs-12">
											<div class="input-group">
												<input type="text" name="flight_departure_of_date" id="flight_departure_of_date" readonly value="#dateFormat(flight_departure_of_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
											</div>
										</div>
									</div>
								</div>
								<div class="col col-6 col-xs-6">	
									<div class="form-group" id="item-airfare">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='60423.Uçak Ücreti'></label>
										<div class="col col-6 col-xs-12">
											<input type="text" name="airfare" id="airfare" class="moneybox" readonly value="<cfif len(airfare)>#TLFormat(airfare)#</cfif>" onkeyup="isNumber(this);return(FormatCurrency(this,event));">
										</div>
										<div class="col col-2 col-xs-12">
											<input type="text" name="airfare_money_type" id="airfare_money_type" class="moneybox" readonly value="#airfare_money_type#"> 
										</div>
									</div>
								</div>
								<div class="col col-12 col-xs-12">
									<div class="form-group" id="item-flight_detail">
										<label class="col col-2 col-xs-12"><cf_get_lang dictionary_id='57467.Not'></label>
										<div class="col col-10 col-xs-12">
											<textarea name="flight_detail" id="flight_detail" readonly>#flight_detail#</textarea>
										</div>
									</div>
								</div>
							</cf_box_elements>
						<!---Seyahat için / Seyahat Esnasında Yararlanılacak Ulaşım Aracı--->
						<cfsavecontent variable="header6"><cf_get_lang dictionary_id="60428.Seyahat için / Seyahat Esnasında Yararlanılacak Ulaşım Aracı"></cfsavecontent>
							<cf_seperator id="travel_vehicle_" header="#header6#">
							<cf_box_elements id="travel_vehicle_">
								<div class="col col-12 col-xs-12" id="item-travel_vehicle">	
									<div class="form-group">
										<div class="col col-2 col-xs-4"> 
											<label><cf_get_lang dictionary_id='60427.Uçak'><input type="checkbox" id="travel_vehicle_1" disabled  name="travel_vehicle" value="1" <cfif travel_vehicle contains 1>checked</cfif>></label>
										</div>
										<div class="col col-2 col-xs-4"> 
											<label><cf_get_lang dictionary_id='29677.Şahsi'><cf_get_lang dictionary_id='58480.Araç'><input type="checkbox" disabled id="travel_vehicle_2" name="travel_vehicle" value="2" <cfif travel_vehicle contains 2>checked</cfif>></label>
										</div>
										<div class="col col-2 col-xs-4"> 
											<label><cf_get_lang dictionary_id='60429.Otobüs'><input type="checkbox" id="travel_vehicle_3" disabled name="travel_vehicle" value="3" <cfif travel_vehicle contains 3>checked</cfif>></label>
										</div>
										<div class="col col-2 col-xs-4"> 
											<label><cf_get_lang dictionary_id='60430.Rent-a-Car'><input type="checkbox" id="travel_vehicle_4" disabled  name="travel_vehicle" value="4" <cfif travel_vehicle contains 4>checked</cfif>></label>
										</div>
										<div class="col col-2 col-xs-4"> 
											<label><cf_get_lang dictionary_id='57712.Kurum'><cf_get_lang dictionary_id='34831.Aracı'><input type="checkbox" disabled id="travel_vehicle_5" name="travel_vehicle" value="5" <cfif travel_vehicle contains 5>checked</cfif>></label>
										</div>
										<div class="col col-2 col-xs-4"> 
											<label><cf_get_lang dictionary_id='60431.Havaalanı Transferi'><input type="checkbox" id="travel_vehicle_6" disabled name="travel_vehicle" value="6" <cfif travel_vehicle contains 6>checked</cfif>></label>
										</div>
									</div>
									<cfset travel_list = listdeleteduplicates(travel_vehicle,'1,2,3,4,5,6,',',')>
									<div class="form-group">
										<label class="col col-1 col-xs-12"><cf_get_lang dictionary_id='58156.Diğer'></label>
										<div class="col col-11 col-xs-12">
											<input type="text" name="travel_vehicle" id="travel_vehicle" readonly value="#travel_list#"></input>
										</div>
									</div>
								</div>
							</cf_box_elements>
							<!---Gidilecek Konferans / Toplantı Bilgileri--->
						<cfsavecontent variable="header7"><cf_get_lang dictionary_id="60433.Gidilecek Konferans/Toplantı"><cf_get_lang dictionary_id="37022.Bilgileri"></cfsavecontent>
							<cf_seperator id="activity" header="#header7#">
							<cf_box_elements id="activity">
								<div class="col col-6 col-xs-12">	
									<div class="form-group"  id="item-activity_address">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
										<div class="col col-8 col-xs-12"> 
											<textarea id="activity_address" name="activity_address" readonly>#activity_address#</textarea>
										</div>
									</div>
									<div class="form-group"  id="item-activity_website">
										<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='34867.Web Sitesi'></label>
										<div class="col col-6 col-xs-12">
											<input type="text" name="activity_website" id="activity_website" value="#activity_website#" readonly></input>
										</div>
									</div>
								</div>
							</cf_box_elements>
						<!---Onaylar--->
						<cfsavecontent variable="header8"><cf_get_lang dictionary_id="30870.Onaylar"></cfsavecontent>
							<cf_seperator id="valid" header="#header8#">
							<cf_box_elements id="valid">
								<div class="col col-6 col-xs-12">		
									<div class="form-group" id="item-process_cat">
										<label class="col col-4 col-xs-12"><cf_get_lang_main no ='1447.Süreç'>*</label>
										<div class="col col-8 col-xs-12">
											<cf_workcube_process is_upd='0' process_cat_width='180' is_detail='1' select_value='#demand_stage#'>
										</div>
									</div>			
								</div>
							</cf_box_elements>
				</cfoutput>
			</div>
		</cf_box_elements>
        <cf_box_footer>
            <div class="col col-6"><cf_record_info query_name="get_payment_request"></div>
            <div class="col col-6"><cf_workcube_buttons is_upd='1' is_delete="0"></div>
        </cf_box_footer>
    </cfform>
</cf_box>
</div>



