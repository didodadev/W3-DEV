<cfparam name="attributes.is_country" default="1">
<cfparam name="attributes.place" default="">
<cfparam name="attributes.is_top_title_limit" default="0">
<cfparam name="attributes.is_vehicle_demand" default="0">
<cfparam name="attributes.emp_position_id" default="#session.ep.position_code#">
<cfparam name="attributes.is_hotel_demand" default="0">
<cfparam name="attributes.is_visa_requirement" default="0">
<cfparam name="attributes.is_travel_advance_demand" default="0">
<cfparam name="attributes.is_hotel_advance_demand" default="0">
<cfparam name="attributes.is_departure_fee" default="0">
<cfparam name="attributes.departure_date" default="">
<cfparam name="attributes.departure_of_date" default="">
<cfparam name="attributes.employee_id" default="#session.ep.userid#">
<cfscript>
	get_demands = createObject("component","V16.myhome.cfc.get_travel_demands");
	get_department = get_demands.get_department(position_code : attributes.emp_position_id);
	GET_COUNTRY = get_demands.GET_COUNTRY();
	GET_CITY = get_demands.GET_CITY();
	get_emp_pos = get_demands.get_position_detail();
	GET_MONEY = get_demands.GET_MONEY();
</cfscript>
<cfscript>
	Position_Assistant= createObject("component","V16.hr.ehesap.cfc.position_assistant");
	get_modules_no = Position_Assistant.GET_MODULES_NO(fuseaction:attributes.fuseaction)
</cfscript>
<cf_papers paper_type="travel_demand">
<cf_catalystHeader>

<div class="col col-12">
	<cf_box>
		<cfform name="travel_demand" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_add_travel_demand" method="post">
			<cfoutput>
				<!---Seyahat Bilgileri--->
				<cfsavecontent variable="header1"><cf_get_lang dictionary_id="59973.Seyahat"><cf_get_lang dictionary_id="37022.Bilgileri"></cfsavecontent>
					<cf_seperator id="travel_info" header="#header1#">
					<cf_box_elements id="travel_info" vertical="1">
						<div class="col col-4 col-xs-12" type="column" sort="true" index="1">
							<div class="form-group" id="item-emp_name">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57570.Ad Soyad'></label>
								<div class="col col-12 col-xs-12">
									<cfif listfirst(attributes.fuseaction,'.') is 'myhome'>									
										<div class="input-group">									
											<input type="hidden" name="employee_id" id="employee_id" value="#session.ep.userid#">
											<input name="emp_name" type="text" id="emp_name" readonly="readonly" value="#get_emp_info(attributes.employee_id,0,0)#">
											<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=travel_demand.employee_id&field_name=travel_demand.emp_name&field_id=travel_demand.position_code&field_pos_name=travel_demand.position_name&field_dep_id=travel_demand.emp_department_id&field_dep_name=travel_demand.emp_department&is_position_assistant=1&module_id=<cfoutput>#get_modules_no.module_no#</cfoutput>&upper_pos_code=<cfoutput>#session.ep.position_code#</cfoutput>&select_list=1&show_rel_pos=1','list');"></span>	
										</div>										
									<cfelse>
										<div class="input-group">
											<input type="hidden" name="employee_id" id="employee_id" value="#session.ep.userid#">
											<input type="text" name="emp_name" id="emp_name" value="#get_emp_info(attributes.employee_id,0,0)#" onfocus="AutoComplete_Create('emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=travel_demand.employee_id&field_name=travel_demand.emp_name&field_id=travel_demand.position_code&field_pos_name=travel_demand.position_name&field_dep_id=travel_demand.emp_department_id&field_dep_name=travel_demand.emp_department&select_list=1','list');"></span>                                     
										</div>
									</cfif>
								</div>
							</div>							
							<div class="form-group" id="item-paper_no">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='31257.Kayıt No'></label>
								<div class="col col-12 col-xs-12">
									<cfif isdefined("paper_code") and len(paper_code) and len(paper_number)>
										<cfinput type="text" name="paper_number" id="paper_number" value="#paper_code & '-' & paper_number#" maxlength="40" readonly>
									<cfelse>
										<cfinput type="text" name="paper_number" id="paper_number" value="" maxlength="40" readonly>
									</cfif>
								</div>
							</div>
							<div class="form-group" id="item-emp_position_id">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
								<div class="col col-12 col-xs-12">
									<cfif listfirst(attributes.fuseaction,'.') is 'myhome'>	
										<input type="hidden" name="position_code" id="position_code" value="#get_emp_pos.position_code#">
										<input name="position_name" type="text" id="position_name" readonly="readonly" value="#get_emp_pos.position_name#">
									<cfelse>
										<input type="hidden" name="position_code" id="position_code" value="#get_emp_pos.position_code#">
										<input name="position_name" type="text" id="position_name" readonly="readonly" value="#get_emp_pos.position_name#">
									</cfif>
								</div>
							</div>
						
							<div class="form-group" id="item-emp_department_id">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57572.Departman"></label>
								<div class="col col-12 col-xs-12">
									<cfif listfirst(attributes.fuseaction,'.') is 'myhome'>	
										<input type="hidden" name="emp_department_id" id="emp_department_id" value="#get_department.department_id#">
										<input name="emp_department" type="text" id="emp_department"  readonly="readonly" value="#get_department.NICK_NAME# - #get_department.BRANCH_NAME# - #get_department.DEPARTMENT_HEAD#">
									<cfelse>
										<input type="hidden" name="emp_department_id" id="emp_department_id" value="#get_department.department_id#">
										<input name="emp_department" type="text" id="emp_department"  readonly="readonly" value="#get_department.DEPARTMENT_HEAD#">
									</cfif>
								</div>
							</div>
							
						</div>
						<div class="col col-4 col-xs-12" type="column" sort="true" index="2">
							<div class="form-group" id="item-place">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="60394.Gidilecek Ülke"></label>
								<div class="col col-12 col-xs-12">
									<select name="place" id="place">
										<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
										<cfloop query="get_country">
											<option value="#country_name#">#country_name#</option>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="form-group" id="item-city">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="60395.Gidilecek Şehir"> *</label>
								<div class="col col-12 col-xs-12">
										<select name="city" id="city" style="display:none;" class="city_name">
											<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
											<cfloop query="GET_CITY">
												<option value="#city_name#">#city_name#</option>
											</cfloop>
										</select>
										<input class="city" type="text" name="city_" id="city_" maxlength="200" value="">
								</div>
							</div>
							<div class="form-group" id="item-is_top_title_limit">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="60396.Üst Ünvanın Otel Limiti Kullanımı"></label>
								<label class="col col-6"><input type="radio" name="is_top_title_limit" id="is_top_title_limit1" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
								<label class="col col-6"><input type="radio" name="is_top_title_limit" id="is_top_title_limit2" value="0" checked><cf_get_lang dictionary_id='57496.Hayır'></label>				
							</div>
							<div class="form-group" id="item-top_title_id">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="60397.Birlikte Seyahat Edilen En Üst Ünvanlı Personel"></label>
								<div class="col col-12 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="top_title_id" id="top_title_id" value="<cfif isdefined('attributes.top_title_id') and len(attributes.top_title_id)><cfoutput>#attributes.top_title_id#</cfoutput></cfif>">
										<input type="text" name="top_title" id="top_title" value="<cfif isdefined('attributes.top_title') and len(attributes.top_title)><cfoutput>#attributes.top_title#</cfoutput></cfif>" onfocus="AutoComplete_Create('top_title','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','top_title_id','','3','135');" autocomplete="off">
										<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=travel_demand.top_title_id&field_name=travel_demand.top_title&select_list=1','list');"></span>                                     
									</div>
								</div>
							</div>
						</div>
						<div class="col col-4 col-xs-12" type="column" sort="true" index="3">
							<div class="ui-form-block">
								<div class="form-group" id="item-task_causes">
									<label><cf_get_lang dictionary_id="29525.Görevlendirme"><cf_get_lang dictionary_id="34777.Nedeni"></label>
									<textarea name="task_causes" id="task_causes"></textarea>
								</div>
							</div>
							<div class="form-group" id="item-is_country">	
								<div class="col col-12 col-xs-12">
									<input type="checkbox" name="is_country" id="is_country" maxlength="200" value="1">
									<cf_get_lang dictionary_id="29691.Yurtiçi"><cf_get_lang dictionary_id="59973.Seyahat">
								</div>					
							</div>
							<div class="form-group" id="item-travel_type">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="59973.Seyahat"><cf_get_lang dictionary_id="58651.Türü"></label>
									<div class="col col-12 col-xs-12">
										<select name="travel_type" id="travel_type">
												<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
												<option value="1"><cf_get_lang dictionary_id="60477.Görev Seyahatleri"></option>
												<option value="2"><cf_get_lang dictionary_id="60478.Uzun Süreli Seyahatler"></option>
												<option value="3"><cf_get_lang dictionary_id="60479.Eğitim Seyahatleri"></option>
										</select>
									</div>
							</div>
							<div class="form-group" id="item-project_id">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57416.proje'></label>
								<div class="col col-12 col-xs-12">
									<div class="input-group">
										<input type="hidden" name="project_id" id="project_id" value="">
										<input type="text" name="project_head" id="project_head"  value="">
										<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=travel_demand.project_id&project_head=travel_demand.project_head');"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-project_id">
								<div class="col col-12 col-xs-12">
									<label style="color:red">
										<b><cf_get_lang dictionary_id='57467.Not'>:</b><cf_get_lang dictionary_id="64659.Süresine bakılmaksızın yurt içi/yurt dışı seminer, kurs, konferans, panel, zirve, fuar gibi etkinliklerde izleyici olarak yer alınan seyahatler, Eğitim Seyahati olarak değerlendirilir."><cf_get_lang dictionary_id="64660.Bu etkinliklerde aktif olarak görev alınması durumunda; Görev Seyahati kapsamında değerlendirilir."><cf_get_lang dictionary_id="64661.30 günü aşan süreli görev seyahatleri, Uzun Süreli Görev olarak değerlendirilir.">
									</label>
								</div>
							</div>
						</div>
					</cf_box_elements>
				<!---Yol Dahil Görevlendirme Bilgileri--->
				<cfsavecontent variable="header2"><cf_get_lang dictionary_id="60400.Yol Dahil"><cf_get_lang dictionary_id="29525.Görevlendirme"><cf_get_lang dictionary_id="37022.Bilgileri"></cfsavecontent>
					<cf_seperator id="task_info" header="#header2#">
					<cf_box_elements id="task_info" vertical="1">
						<div class="col col-4 col-xs-12"  type="column" sort="true" index="4">
							<div class="form-group" id="item-departure_date">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>*</label>
								<div class="col col-12 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='30623.Lütfen Başlangıç Tarihi giriniz'></cfsavecontent>
										<cfinput type="text" name="departure_date" id="departure_date" value="" validate="#validate_style#" maxlength="10" message="#message#" required="yes" onchange="totalday()">
										<span class="input-group-addon"><cf_wrk_date_image date_field="departure_date"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-departure_of_date">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
								<div class="col col-12 col-xs-12">
									<div class="input-group">
										<cfsavecontent variable="message"><cf_get_lang dictionary_id='36494.Lütfen Bitiş Tarihi giriniz'></cfsavecontent>
										<cfinput type="text" name="departure_of_date" id="departure_of_date" value="" validate="#validate_style#" maxlength="10" message="#message#" required="yes" onChange="totalday()">
										<span class="input-group-addon"><cf_wrk_date_image date_field="departure_of_date"></span>
									</div>
								</div>
							</div>
							<!--- <div class="form-group" id="item-fare">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60402.Bilet Ücreti'></label>
								<div class="col col-12 col-xs-12">
									<div class="input-group">
										<input type="text" name="fare" id="fare" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event));">
										<span class="input-group-addon width">
											<select name="fare_type" id="fare_type">
												<cfloop query="get_money">                                     
													<option value="#MONEY#">#MONEY#</option>                                                                             
												</cfloop>
											</select>    
										</span>
									</div>
								</div>
							</div>				
							<div class="form-group" id="item-fare">								
								<div class="col col-12 col-xs-12">
									<label style="color:red"><b><cf_get_lang dictionary_id='57467.Not'>:</b> Rezervasyon fiyatıdır ve değişkenlik gösterebilir. </label>
								</div>
							</div> --->	
							<div class="form-group" id="item-sum_day">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57492.Toplam'><cf_get_lang dictionary_id='30201.Görev'><cf_get_lang dictionary_id='48188.Gün Sayısı'></label>
								<div class="col col-12 col-xs-12">
									<input type="text" name="sum_day" id="sum_day" value="" >
								</div>
							</div>
						</div>
						<div class="col col-4 col-xs-12"  type="column" sort="true" index="5">
							<div class="form-group" id="item-is_vehicle_demand">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='55335.Araç Talebi'></label>
								<label class="col col-6"><input type="radio" name="is_vehicle_demand" id="is_vehicle_demand1" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
								<label  class="col col-6"><input type="radio" name="is_vehicle_demand" id="is_vehicle_demand2" value="0" checked><cf_get_lang dictionary_id='57496.Hayır'></label>
							</div>					
							<div class="form-group" id="item-demand_cause" style="display:none;">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='31317.Talep Nedeni'></label>
								<div class="col col-12 col-xs-12">
									<input type="text" name="demand_cause" id="demand_cause" value="">
								</div>
							</div>
							<div class="form-group" id="item-is_visa_requirement">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60414.Vize İhtiyacı'></label>
								<label class="col col-6"><input type="radio" name="is_visa_requirement" id="is_visa_requirement1" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
								<label class="col col-6"><input type="radio" name="is_visa_requirement" id="is_visa_requirement2" value="0" checked><cf_get_lang dictionary_id='57496.Hayır'></label>
							</div>
							<!--- <div class="form-group" id="item-visa_fare" style="display:none;">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60420.Vize Ücreti'>*</label>
								<div class="col col-12 col-xs-12">
									<div class="input-group">
										<input type="text" name="visa_fare" id="visa_fare" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event));">										
										<span class="input-group-addon width">
											<select name="visa_fare_money_type" id="visa_fare_money_type">
												<cfloop query="get_money">                                     
													<option value="#MONEY#">#MONEY#</option>                                                                             
												</cfloop>
											</select> 
										</span>
									</div>
								</div>
							</div> --->
							<div class="form-group" id="item-flight_class_demand">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="31181.Talep Edilen"><cf_get_lang dictionary_id="60415.Uçuş Sınıfı"></label>
								<div class="col col-12 col-xs-12">
									<select name="flight_class_demand" id="flight_class_demand">
										<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
										<option value="1"><cf_get_lang dictionary_id="60416.Business"></option>
										<option value="2"><cf_get_lang dictionary_id="60417.Ekonomi"></option>
									</select>
								</div>
							</div>
						</div>
						<div class="col col-4 col-xs-12"  type="column" sort="true" index="6">
							<div class="form-group" id="item-is_hotel_demand">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60408.Otel Talebi'></label>
								<label class="col col-6"><input type="radio" name="is_hotel_demand" id="is_hotel_demand1" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
								<label class="col col-6"><input type="radio" name="is_hotel_demand" id="is_hotel_demand2" value="0" checked><cf_get_lang dictionary_id='57496.Hayır'></label>
							</div>
							<div class="form-group" id="item-hotel_name" style="display:none;">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60418.Otel İsmi'></label>
								<div class="col col-12 col-xs-12">
									<cfinput type="text" name="hotel_name" id="hotel_name" value="">
								</div>
							</div>
							<div class="form-group" id="item-hotel_payment" style="display:none;">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="60410.Otel Ödemesi">*</label>
								<div class="col col-12 col-xs-12">
									<select name="hotel_payment" id="hotel_payment">
											<option value="0"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
											<option value="1"><cf_get_lang dictionary_id="60411.Acenta Ödemeli"></option>
											<option value="2"><cf_get_lang dictionary_id="60412.Otel Misafir Ödemeli"></option>
											<option value="3"><cf_get_lang dictionary_id="60413.Karşı Taraf Ödemeli"></option>
									</select>
								</div>
							</div>
							<!--- 	<div class="form-group" id="item-night_fare" style="display:none;">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60419.Gecelik Ücret'>*</label>
								<div class="col col-12 col-xs-12">
									<div class="input-group">
										<input type="text" name="night_fare" id="night_fare" class="moneybox" value="" onkeyup="return(FormatCurrency(this,event));">					
										<span class="input-group-addon width">
											<select name="night_fare_money_type" id="night_fare_money_type">
												<cfloop query="get_money">                                     
													<option value="#MONEY#">#MONEY#</option>                                                                             
												</cfloop>
											</select>    
										</span>
									</div>
								</div>
							</div> --->
							<div class="form-group" id="item-task_detail">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57467.Not'></label>
								<div class="col col-12 col-xs-12">
									<textarea name="task_detail" id="task_detail"></textarea>
								</div>
							</div>
						</div>	
					</cf_box_elements>
				<!---Avans Bilgileri--->
				<cfsavecontent variable="header3"><cf_get_lang dictionary_id="58204.Avans"><cf_get_lang dictionary_id="37022.Bilgileri"></cfsavecontent>
					<cf_seperator id="advance_info" header="#header3#">
					<cf_box_elements id="advance_info" vertical="1">
						<div class="col col-4 col-xs-12"  type="column" sort="true" index="7">
							<div class="form-group" id="item-is_travel_advance_demand">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='59973.Seyahat'><cf_get_lang dictionary_id="30914.Avans Talebi"></label>
								<label class="col col-6"><input type="radio" name="is_travel_advance_demand" id="is_travel_advance_demand1" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
								<label class="col col-6"><input type="radio" name="is_travel_advance_demand" id="is_travel_advance_demand2" value="0" checked><cf_get_lang dictionary_id='57496.Hayır'></label>
							</div>
							<div class="form-group" id="item-is_hotel_advance_demand">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60421.Otel'><cf_get_lang dictionary_id="30914.Avans Talebi"></label>
								<label class="col col-6"><input type="radio" name="is_hotel_advance_demand" id="is_hotel_advance_demand1" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
								<label class="col col-6"><input type="radio" name="is_hotel_advance_demand" id="is_hotel_advance_demand2" value="0" checked><cf_get_lang dictionary_id='57496.Hayır'></label>
							</div>
							<div class="form-group" id="item-is_departure_fee">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60422.Yurtdışı Çıkış Harcı Yatırılması Gerekiyor mu?'></label>
								<label class="col col-6"><input type="radio" name="is_departure_fee" id="is_departure_fee1" value="1"><cf_get_lang dictionary_id='57495.Evet'></label>
								<label class="col col-6"><input type="radio" name="is_departure_fee" id="is_departure_fee2" value="0" checked><cf_get_lang dictionary_id='57496.Hayır'></label>
							</div>
						</div>
							<!--- <div class="col col-4 col-xs-12">
							<div class="form-group" id="item-travel_advance_demand_fare" style="display:none;">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='31282.Ücret'></label>
								<div class="col col-12 col-xs-12">
									<div class="input-group">
										<input type="text" name="travel_advance_demand_fare" id="travel_advance_demand_fare" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event));">									
										<span class="input-group-addon width">
											<select name="travel_advance_demand_type" id="travel_advance_demand_type">
												<cfloop query="get_money">                                     
													<option value="#MONEY#">#MONEY#</option>                                                                             
												</cfloop>
											</select>    
										</span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-hotel_advance_demand_fare" style="display:none;">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='31282.Ücret'></label>
								<div class="col col-12 col-xs-12">
									<div class="input-group">
										<input type="text" name="hotel_advance_demand_fare" id="hotel_advance_demand_fare" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event));">																
										<span class="input-group-addon width">
											<select name="hotel_advance_demand_type" id="hotel_advance_demand_type">
												<cfloop query="get_money">                                     
													<option value="#MONEY#">#MONEY#</option>                                                                             
												</cfloop>
											</select>    
										</span>
									</div>
								</div>
							</div>
							</div> --->
					</cf_box_elements>	
				<!---Etkinlik Bilgileri--->
				<cfsavecontent variable="header4"><cf_get_lang dictionary_id="51624.Etkinlik Bilgileri"></cfsavecontent>
					<cf_seperator id="activity_info" header="#header4#">
					<cf_box_elements id="activity_info" vertical="1">
						<div class="col col-4 col-xs-6"  type="column" sort="true" index="8">
							<div class="form-group" id="item-activity_start_date">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
								<div class="col col-12 col-xs-12">
									<div class="input-group">
										<cfinput type="text" name="activity_start_date" id="activity_start_date" value="" validate="#validate_style#" maxlength="10">
										<span class="input-group-addon"><cf_wrk_date_image date_field="activity_start_date"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-activity_finish_date">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
								<div class="col col-12 col-xs-12">
									<div class="input-group">
										<cfinput type="text" name="activity_finish_date" id="activity_finish_date" value="" validate="#validate_style#" maxlength="10">
										<span class="input-group-addon"><cf_wrk_date_image date_field="activity_finish_date"></span>
									</div>
								</div>
							</div>
						</div>
						<!--- <div class="col col-4 col-xs-6">	
									<div class="form-group" id="item-activity_fare">
										<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29465.Etkinlik'><cf_get_lang dictionary_id='31282.Ücret'></label>
										<div class="col col-12 col-xs-12">
											<div class="input-group">
												<input type="text" name="activity_fare" id="activity_fare" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event));">						
												<span class="input-group-addon width">
													<select name="activity_fare_money_type" id="activity_fare_money_type">
														<cfloop query="get_money">                                     
															<option value="#MONEY#">#MONEY#</option>                                                                             
														</cfloop>
													</select>    
												</span>
											</div>
										</div>
									</div>
							</div> --->
						<div class="col col-4 col-xs-6"  type="column" sort="true" index="9">
							<div class="form-group" id="item-activity_detail">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57467.Not'></label>
								<div class="col col-12 col-xs-12">
									<textarea name="activity_detail" id="activity_detail"></textarea>
								</div>
							</div>
						</div>
					</cf_box_elements>	
				<!---Kişisel Seyahat Tercihleri--->
				<cfsavecontent variable="header5"><cf_get_lang dictionary_id="29688.Kişisel"><cf_get_lang dictionary_id="59973.Seyahat"><cf_get_lang dictionary_id="44333.Tercihi"></cfsavecontent>
					<cf_seperator id="personal_travel_info" header="#header5#">
					<cf_box_elements id="personal_travel_info" vertical="1">
						<div class="col col-4 col-xs-6"  type="column" sort="true" index="10">
							<div class="form-group" id="item-flight_departure_date">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60427.Uçak'><cf_get_lang dictionary_id='45410.Gidiş Tarihi'></label>
								<div class="col col-12 col-xs-12">
									<div class="input-group">
										<cfinput type="text" name="flight_departure_date" id="flight_departure_date" value="" validate="#validate_style#" maxlength="10">
										<span class="input-group-addon"><cf_wrk_date_image date_field="flight_departure_date"></span>
									</div>
								</div>
							</div>
							<div class="form-group" id="item-flight_departure_of_date">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60427.Uçak'><cf_get_lang dictionary_id='45408.Dönüş Tarihi'></label>
								<div class="col col-12 col-xs-12">
									<div class="input-group">
										<cfinput type="text" name="flight_departure_of_date" id="flight_departure_of_date" value="" validate="#validate_style#" maxlength="10">
										<span class="input-group-addon"><cf_wrk_date_image date_field="flight_departure_of_date"></span>
									</div>
								</div>
							</div>
						</div>
						<!--- <div class="col col-4 col-xs-6">	
							<div class="form-group" id="item-airfare">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60423.Uçak Ücreti'></label>
								<div class="col col-12 col-xs-12">
									<div class="input-group">
										<input type="text" name="airfare" id="airfare" class="moneybox" value="0" onkeyup="return(FormatCurrency(this,event));">								
										<span class="input-group-addon width">
											<select name="airfare_money_type" id="airfare_money_type">
												<cfloop query="get_money">                                     
													<option value="#MONEY#">#MONEY#</option>                                                                             
												</cfloop>
											</select>    
										</span>
									</div>
								</div>
							</div>
						</div> --->
						<div class="col col-4 col-xs-6"  type="column" sort="true" index="11">	
							<div class="form-group" id="item-flight_detail">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57467.Not'></label>
								<div class="col col-12 col-xs-12">
									<textarea name="flight_detail" id="flight_detail"></textarea>
								</div>
							</div>
						</div>
					</cf_box_elements>
				<!---Seyahat için / Seyahat Esnasında Yararlanılacak Ulaşım Aracı--->
				<cfsavecontent variable="header6"><cf_get_lang dictionary_id="60428.Seyahat için / Seyahat Esnasında Yararlanılacak Ulaşım Aracı"></cfsavecontent>
					<cf_seperator id="travel_vehicle_" header="#header6#">
					<cf_box_elements id="travel_vehicle_" vertical="1">
						<div class="col col-12 col-xs-12" id="item-travel_vehicle"  type="column" sort="true" index="12">	
							<div class="form-group">
								<div class="col col-2 col-xs-4"> 
									<label><cf_get_lang dictionary_id='60427.Uçak'><input type="checkbox" id="travel_vehicle_1" name="travel_vehicle" value="1"></label>
								</div>
								<div class="col col-2 col-xs-4"> 
									<label><cf_get_lang dictionary_id='29677.Şahsi'><cf_get_lang dictionary_id='58480.Araç'><input type="checkbox" id="travel_vehicle_2" name="travel_vehicle" value="2"></label>
								</div>
								<div class="col col-2 col-xs-4"> 
									<label><cf_get_lang dictionary_id='60429.Otobüs'><input type="checkbox" id="travel_vehicle_3" name="travel_vehicle" value="3"></label>
								</div>
								<div class="col col-2 col-xs-4"> 
									<label><cf_get_lang dictionary_id='60430.Rent-a-Car'><input type="checkbox" id="travel_vehicle_4" name="travel_vehicle" value="4"></label>
								</div>
								<div class="col col-2 col-xs-4"> 
									<label><cf_get_lang dictionary_id='57712.Kurum'><cf_get_lang dictionary_id='34831.Aracı'><input type="checkbox" id="travel_vehicle_5" name="travel_vehicle" value="5"></label>
								</div>
								<div class="col col-2 col-xs-4"> 
									<label><cf_get_lang dictionary_id='60431.Havaalanı Transferi'><input type="checkbox" id="travel_vehicle" name="travel_vehicle_6" value="6"></label>
								</div>
							</div>
							<div class="form-group">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58156.Diğer'></label>
								<div class="col col-12 col-xs-12">
									<input type="text" name="travel_vehicle" id="travel_vehicle"></input>
								</div>
							</div>
							<div class="form-group">
								<div class="col col-12 col-xs-12">
									<label style="color:red">
										<b><cf_get_lang dictionary_id='57467.Not'>1 :</b>
											<cf_get_lang dictionary_id="64662.Şehirlerarası otobüs biletlerinin Seyahat Giderleri Beyan Formu'nun ekine iliştirilmesi gerekmektedir.">	
									</label>
								</div>
							</div>
							<div class="form-group">
								<div class="col col-12 col-xs-12">
									<label style="color:red">
										<b><cf_get_lang dictionary_id='57467.Not'> 2 :</b>
											<cf_get_lang dictionary_id="64663.Kurum Aracı ile şehirlerarası seyahat gerçekleştirecek ise aracın Destek Hizmetleri Bölümü''nden talep edilmesi gerekmektedir.">
									</label>
								</div>
							</div>
						</div>
					</cf_box_elements>
					<!---Gidilecek Konferans / Toplantı Bilgileri--->
				<cfsavecontent variable="header7"><cf_get_lang dictionary_id="60433.Gidilecek Konferans/Toplantı"><cf_get_lang dictionary_id="37022.Bilgileri"></cfsavecontent>
					<cf_seperator id="toplanti_" header="#header7#">
					<cf_box_elements id="toplanti_" vertical="1">
						<div class="col col-4 col-xs-12"  type="column" sort="true" index="13">	
							<div class="form-group"  id="item-activity_address">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
								<div class="col col-12 col-xs-12"> 
									<textarea id="activity_address" name="activity_address"></textarea>
								</div>
							</div>
						</div>
						<div class="col col-4 col-xs-12"  type="column" sort="true" index="14">
							<div class="form-group"  id="item-activity_website">
								<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='34867.Web Sitesi'></label>
								<div class="col col-12 col-xs-12">
									<input type="text" name="activity_website" id="activity_website"></input>
								</div>
							</div>
						</div>
					</cf_box_elements>
				<!---Onaylar--->
				<cfsavecontent variable="header8"><cf_get_lang dictionary_id="30870.Onaylar"></cfsavecontent>
					<cf_seperator id="valid" header="#header8#">
					<cf_box_elements id="valid" vertical="1">
						<div class="col col-4 col-xs-12"  type="column" sort="true" index="15">	
							<div class="form-group" id="item-process_cat">
								<label class="col col-12 col-xs-12"><cf_get_lang_main no ='1447.Süreç'>*</label>
								<div class="col col-12 col-xs-12">
									<cf_workcube_process is_upd='0' process_cat_width='180' is_detail='0' is_select_text="0">
								</div>
							</div>
						</div>
					</cf_box_elements>
			<cf_box_footer>
				<cf_workcube_buttons is_upd='0' type_format='1' add_function="check()">
			</cf_box_footer>
			</cfoutput>
			<div style="display:none" class="ui-cfmodal ui-cfmodal__alert">
				<cf_box title="Bilgilendirme" closable="0" resize="0">
					<div class="ui-cfmodal-close">×</div>
					<ul class="required_list"></ul>
					<div class="ui-form-list-btn">
						<div>
							<input type="submit" class="ui-btn ui-btn-success" value="Tamam" onClick="return process_cat_control();">		
						</div>
					</div>
				</cf_box>
			</div>
		</cfform>
	</cf_box>
</div>
<script> 
$(document).ready(function()
{
  $('#is_country').change(function() 
  {
    if(this.checked == 1)
    {
		$('.city_name').show();
		$('.city').hide();
		$('#place').val('Türkiye');
		$('.city_name').val('');
	}
	else
	{
		$('.city_name').hide();
		$('.city').show();
		$('#place').val('ABD');
		$('.city').val('');
	}
  });   
  $('#place').change(function() 
  {
    if(this.value != 'Türkiye')
    {
		$('.city_name').hide();
		$('.city').show();
		$('.city_name').val('');
		$('#is_country').prop("checked", false);
	}
	else{
		$('.city_name').show();
		$('.city').hide();
		$('.city').val('');
		$('#is_country').prop("checked", true);
	}
  });  
  
	$('#item-demand_cause').css('display', 'none');
	$('input:radio[name="is_vehicle_demand"]').change(
		function(){
			if ($(this).is(':checked')) {
				if($(this).attr('id')=='is_vehicle_demand1') {
					$('#item-demand_cause').css('display', 'block');
				} else {
					$('#item-demand_cause').css('display', 'none');
				}
			}
		});

	$('#item-hotel_name').css('display', 'none');
	$('input:radio[name="is_hotel_demand"]').change(
		function(){
			if ($(this).is(':checked')) {
				if($(this).attr('id')=='is_hotel_demand1') {
					$('#item-hotel_name').css('display', 'block');
					//$('#item-hotel_advance_demand_fare').css('display', 'block');
					$('#item-hotel_payment').css('display', 'block');
					$('#item-is_hotel_advance_demand').css('display', 'block');
					//$('#item-night_fare').css('display', 'block');
				} else {
					$('#item-hotel_name').css('display', 'none');
					//$('#item-hotel_advance_demand_fare').css('display', 'none');
					$('#item-hotel_payment').css('display', 'none');
					$('#item-is_hotel_advance_demand').css('display', 'none');
					//$('#item-night_fare').css('display', 'none');
				}
			}
		});
	/*
		$('#item-visa_fare').css('display', 'none');
 		$('input:radio[name="is_visa_requirement"]').change(
		function(){
			if ($(this).is(':checked')) {
				if($(this).attr('id')=='is_visa_requirement1') {
					$('#item-visa_fare').css('display', 'block');
				} else {
					$('#item-visa_fare').css('display', 'none');
				}
			}
		}); 

		$('#item-travel_advance_demand_fare').css('display', 'none');
		$('input:radio[name="is_travel_advance_demand"]').change(
			function(){
				if ($(this).is(':checked')) {
					if($(this).attr('id')=='is_travel_advance_demand1') {
						$('#item-travel_advance_demand_fare').css('display', 'block');
					} else {
						$('#item-travel_advance_demand_fare').css('display', 'none');
					}
				}
			});
	
		$('#item-hotel_advance_demand_fare').css('display', 'none');
		$('input:radio[name="is_hotel_advance_demand"]').change(
			function(){
				if ($(this).is(':checked')) {
					if($(this).attr('id')=='is_hotel_advance_demand1') {
						$('#item-hotel_advance_demand_fare').css('display', 'block');
						
					} else {
						$('#item-hotel_advance_demand_fare').css('display', 'none');
					}
					
				}
			});
	*/
		$("input[type='radio'][name='is_hotel_demand']").change(function() {
			if ($('#is_hotel_demand2').is(':checked')) {
				$('#is_hotel_advance_demand1').prop("checked", false);
				$('#is_hotel_advance_demand2').prop("checked", true);
			} else {
				$('#is_hotel_advance_demand1').prop("checked", true);
				$('#is_hotel_advance_demand2').prop("checked", false);
			}
		});

		//$('#item-hotel_advance_demand_fare').css('display', 'none');
		$('#item-is_hotel_advance_demand').css('display', 'block');
		$('#hotel_payment').on('change', function() {
			var hotel_payment = $("#hotel_payment").val();
			if (hotel_payment == 1)
			{
				//$('#item-hotel_advance_demand_fare').css('display', 'none');
				$('#item-is_hotel_advance_demand').css('display', 'none');
			}
			else
			{
				//$('#item-hotel_advance_demand_fare').css('display', 'block');
				$('#item-is_hotel_advance_demand').css('display', 'block');
			}
			
		});
		$('#travel_type').on('change', function() {
			var travel_type = $("#travel_type").val();
			if (travel_type != 1)
			{
				$('#item-is_travel_advance_demand').css('display', 'none');
			//	$('#item-travel_advance_demand_fare').css('display', 'none');
			}
			else
			{
				$('#item-is_travel_advance_demand').css('display', 'block');
				//$('#item-travel_advance_demand_fare').css('display', 'block');
			}
			
		});

		

      //İstanbul dışı için seyahat talebinde bulunulabilir ! 
		$('.city_name').on('change', function() {
			var city_ = $(".city_name").val();
			if (city_ == 'İSTANBUL(Avrupa)' || city_ == 'İSTANBUL(Anadolu)')
			{
				alert('<cf_get_lang dictionary_id="60854.İstanbul dışı için seyahat talebinde bulunabilirsiniz!">');
				$(".city_name").val('ADANA');
			}			
		});
		
		process_cat_dsp_function();
       
});
function totalday() {
	travel_demand.sum_day.value  = datediff($("#departure_date").val(),$("#departure_of_date").val()) + 1;
}
$('.ui-cfmodal-close').click(function(){
           $('.ui-cfmodal__alert').fadeOut();
       })
function check()
	{
		
		var hotel_payment = $("#hotel_payment").val();
	//	var night_fare=$("#night_fare").val();

		var is_hotel_demand = $("input[name='is_hotel_demand']:checked").val();
		/* if( is_hotel_demand == 1 ) 
		{
			if(hotel_payment != 3) 
			{
			if (night_fare == '') {
				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='60419.Gecelik Ücret'>");
					document.getElementById("night_fare").focus();
						return false;   
			}
			}	
		} */
		if( is_hotel_demand == 1 ) 
		{
			if (hotel_payment == 0) {

				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id="60410.Otel Ödemesi">");
				document.getElementById("hotel_payment").focus();
				return false;   
			}
		}
		
		//var visa_fare=$("#visa_fare").val();
		var is_visa_requirement = $("input[name='is_visa_requirement']:checked").val();
		/* if(is_visa_requirement == 1) 
		{
			if (visa_fare == '') {
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='60420.Vize Ücreti'>");
				document.getElementById("visa_fare").focus();
				return false;   
			}
		} */
		if (($("#city").val() == '') && ($("#city_").val() == '')) 
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='57971.Şehir'>");
			document.getElementById("city").focus();
			document.getElementById("city_").focus();
			return false;  
		}
		if ($("#travel_type").val() == '') 
		{
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id="59973.Seyahat"><cf_get_lang dictionary_id="58651.Türü">");
			document.getElementById("travel_type").focus();
			return false;  
		}

		if(datediff(document.getElementById('departure_date').value,document.getElementById('departure_of_date').value,0)<0)
			{
				alert("<cf_get_lang dictionary_id='40467.Başlangıç tarihi bitiş tarihinden büyük olmamalıdır.'>!");
				document.getElementById("departure_date").focus();
				return false;
			} 
			if(datediff(document.getElementById('activity_start_date').value,document.getElementById('activity_finish_date').value,0)<0)
			{
				alert("<cf_get_lang dictionary_id='294654.Etkinlik'><cf_get_lang dictionary_id='40467.Başlangıç tarihi bitiş tarihinden büyük olmamalıdır.'>!");
				document.getElementById("activity_start_date").focus();
				return false;
			} 
	
			if(datediff(document.getElementById('flight_departure_date').value,document.getElementById('flight_departure_of_date').value,0)<0)
			{
				alert("<cf_get_lang dictionary_id='60427.Uçak'><cf_get_lang dictionary_id='40467.Başlangıç tarihi bitiş tarihinden büyük olmamalıdır.'>!");
				document.getElementById("flight_departure_date").focus();
				return false;
			} 
			$('.ui-cfmodal__alert .required_list li').remove();
			$('.ui-cfmodal__alert .required_list').append('<li><cf_get_lang dictionary_id='62052.Seyahat Talebiniz için bütçe oluşturabilir ve harcama talebinde bulunabilirsiniz.'></li>');
            $('.ui-cfmodal__alert').fadeIn();
            return false;
	}
		
/* 	function unformat_fields(){
        document.getElementById("fare").value = filterNum(document.getElementById("fare").value,4);
        document.getElementById("night_fare").value = filterNum(document.getElementById("night_fare").value,4);
        document.getElementById("visa_fare").value = filterNum(document.getElementById("visa_fare").value,4);
        document.getElementById("activity_fare").value = filterNum(document.getElementById("activity_fare").value,4);
        document.getElementById("hotel_advance_demand_fare").value = filterNum(document.getElementById("hotel_advance_demand_fare").value,4);
		document.getElementById("travel_advance_demand_fare").value = filterNum(document.getElementById("travel_advance_demand_fare").value,4);
		document.getElementById("airfare").value = filterNum(document.getElementById("airfare").value,4);
		} */
</script>