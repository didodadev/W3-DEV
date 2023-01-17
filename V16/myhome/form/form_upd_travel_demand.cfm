
<cfif listfirst(attributes.fuseaction,'.') is 'myhome'>
	<cfset attributes.travel_demand_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.TRAVEL_DEMAND_ID,accountKey:'wrk')/>
<cfelse>
	<cfset attributes.travel_demand_id = attributes.travel_demand_id />
</cfif>
<cfscript>
	get_demands = createObject("component","V16.myhome.cfc.get_travel_demands");
	get_demands.dsn = dsn;
	get_travel_demand = get_demands.travel_demands
					(
						travel_demand_id : attributes.travel_demand_id
					);
</cfscript>	
<cfif not get_travel_demand.recordcount>
	<cfset hata  = 10>
	<cfsavecontent variable="message"><cf_get_lang_main no='1531.Böyle Bir Kayıt Bulunmamaktadır'>!</cfsavecontent>
	<cfset hata_mesaj  = message>
	<cfinclude template="../../dsp_hata.cfm">
<cfelse>
	<cfscript>
		get_demands = createObject("component","V16.myhome.cfc.get_travel_demands");
		get_demands.dsn = dsn;
		GET_MONEY = get_demands.GET_MONEY();
		get_emp_pos = get_demands.get_emp_pos(position_id : get_travel_demand.emp_position_id);
		get_department = get_demands.get_department(position_code : get_travel_demand.emp_position_id);
		GET_COUNTRY = get_demands.GET_COUNTRY();
		GET_CITY = get_demands.GET_CITY();
	</cfscript>	
	<cfif len(get_travel_demand.employee_id)>
		<cfset employee_position_id = get_demands.get_employee_position(employee_id : get_travel_demand.employee_id)>
	<cfelse>
		<cfset employee_position_id = "">
	</cfif>
	<cfscript>
		Position_Assistant= createObject("component","V16.hr.ehesap.cfc.position_assistant");
		get_modules_no = Position_Assistant.GET_MODULES_NO(fuseaction:attributes.fuseaction)
	</cfscript>
	<cfparam name="attributes.is_country" default="1">
	<cfparam name="attributes.place" default="">
	<cfparam name="attributes.is_top_title_limit" default="1">
	<cfparam name="attributes.is_vehicle_demand" default="1">
	<cfparam name="attributes.is_hotel_demand" default="1">
	<cfparam name="attributes.is_visa_requirement" default="">
	<cfparam name="attributes.is_travel_advance_demand" default="1">
	<cfparam name="attributes.is_hotel_advance_demand" default="1">
	<cfparam name="attributes.is_departure_fee" default="1">
	<cfparam name="attributes.departure_date" default="">
	<cfparam name="attributes.departure_of_date" default="">
	<cfsavecontent variable="pagehead"><cf_get_lang dictionary_id="59930.Seyahat Talebi"></cfsavecontent>
	<cfset pageHead = #pagehead#>
	<cf_catalystHeader>
	<div class="col col-9 col-xs-12">
		<cf_box>
			<cfform name="travel_demand" id="travel_demand" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.emptypopup_upd_travel_demand" method="post">
				<cfoutput>
					<input type="hidden" name="control_field_value" id="control_field_value" value="">
					<input type="hidden" name="travel_demand_id" id="travel_demand_id" value="#get_travel_demand.travel_demand_id#">
					<input type="hidden" name="manager1_valid_date" id="manager1_valid_date" value="#get_travel_demand.manager1_valid_date#">
					<input type="hidden" name="old_process_stage" id="old_process_stage" value="#get_travel_demand.demand_stage#">
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
												<input type="hidden" name="pos_cat_id" id="pos_cat_id" value="#employee_position_id#">
												<input type="hidden" name="employee_id" id="employee_id" value="#get_travel_demand.employee_id#">
												<input name="emp_name" type="text" id="emp_name" readonly="readonly" value="#get_emp_info(get_travel_demand.employee_id,0,0)#">	
												<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=travel_demand.employee_id&field_name=travel_demand.emp_name&field_id=travel_demand.position_code&field_pos_name=travel_demand.position_name&field_dep_id=travel_demand.emp_department_id&field_dep_name=travel_demand.emp_department&is_position_assistant=1&module_id=<cfoutput>#get_modules_no.module_no#</cfoutput>&upper_pos_code=<cfoutput>#session.ep.position_code#</cfoutput>&select_list=1&show_rel_pos=1','list');"></span>

											</div>									
										<cfelse>
											<div class="input-group">
												<input type="hidden" name="pos_cat_id" id="pos_cat_id" value="#employee_position_id#">
												<input type="hidden" name="employee_id" id="employee_id" value="#get_travel_demand.employee_id#">
												<input type="text" name="emp_name" id="emp_name" value="#get_emp_info(get_travel_demand.employee_id,0,0)#" onfocus="AutoComplete_Create('emp_name','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','employee_id','','3','135');" autocomplete="off">
												<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=travel_demand.employee_id&field_name=travel_demand.emp_name&field_id=travel_demand.position_code&field_pos_name=travel_demand.position_name&field_dep_id=travel_demand.emp_department_id&field_dep_name=travel_demand.emp_department&select_list=1','list');"></span>                                     
											</div>
										</cfif>
									</div>
								</div>
								<div class="form-group" id="item-paper_no">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='31257.Kayıt No'></label>
									<div class="col col-12 col-xs-12">
											<input type="text" name="paper_number" id="paper_number" value="#get_travel_demand.paper_no#" maxlength="40" readonly>
									</div>
								</div>
								<div class="form-group" id="item-emp_position_id">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58497.Pozisyon'></label>
									<div class="col col-12 col-xs-12">
										<cfif listfirst(attributes.fuseaction,'.') is 'myhome'>	
											<input type="hidden" name="position_code" id="position_code" value="#get_travel_demand.emp_position_id#">
											<input name="position_name" type="text" id="position_name" readonly="readonly" value="#get_emp_pos.POSITION_NAME#">
										<cfelse>
											<input type="hidden" name="position_code" id="position_code" value="#get_travel_demand.emp_position_id#">
											<input name="position_name" type="text" id="position_name" readonly="readonly" value="#get_emp_pos.position_name#">
										</cfif>
									</div>
								</div>
								<div class="form-group" id="item-emp_department_id">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="57572.Departman"></label>
									<div class="col col-12 col-xs-12">
										<cfif listfirst(attributes.fuseaction,'.') is 'myhome'>	
											<input type="hidden" name="emp_department_id" id="emp_department_id" value="#get_travel_demand.emp_department_id#">
											<input name="emp_department" type="text" id="emp_department"  readonly="readonly" value="#get_department.NICK_NAME# - #get_department.BRANCH_NAME# - #get_department.DEPARTMENT_HEAD#">
										<cfelse>
											<input type="hidden" name="emp_department_id" id="emp_department_id" value="#get_travel_demand.emp_department_id#">
											<input name="emp_department" type="text" id="emp_department"  readonly="readonly" value="#get_department.DEPARTMENT_HEAD#">
										</cfif>
									</div>
								</div>
							</div>
							<div class="col col-4 col-xs-12" type="column" sort="true" index="2">
								<div class="form-group" id="item-place">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="60394.Gidilecek Ülke"></label>
									<div class="col col-12 col-xs-12">
										<select class="empty" name="place" id="place">
											<cfloop query="get_country">
												<option value="#country_name#" <cfif get_travel_demand.place eq country_name>selected</cfif>>#country_name#</option>
											</cfloop>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-city">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="60395.Gidilecek Şehir">*</label>
									<div class="col col-12 col-xs-12">
									<select class="city_name" name="city" id="city" style="<cfif get_travel_demand.is_country eq 1>display:'';<cfelse>display:none;</cfif>" class="city_name">
										<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
										<cfloop query="GET_CITY">
											<option value="#city_name#" <cfif get_travel_demand.city eq city_name>selected</cfif>>#city_name#</option>
										</cfloop>
									</select>
									<input class="city" type="text" name="city_" id="city_" maxlength="200" style="<cfif get_travel_demand.is_country eq 1>display:none;<cfelse>display:'';</cfif>" value="#get_travel_demand.city#">
									</div>
								</div>
								<div class="form-group" id="item-is_top_title_limit">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="60396.Üst Ünvanın Otel Limiti Kullanımı"></label>
									<label class="col col-6"><input type="radio" name="is_top_title_limit" id="is_top_title_limit1" value="1" <cfif get_travel_demand.is_top_title_limit eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></label>
									<label class="col col-6"><input type="radio" name="is_top_title_limit" id="is_top_title_limit2" value="0" <cfif get_travel_demand.is_top_title_limit eq 0 >checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></label>				
								</div>
								<div class="form-group" id="item-top_title_id">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="60397.Birlikte Seyahat Edilen En Üst Ünvanlı Personel"></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="top_title_id" id="top_title_id" value="<cfif isdefined('get_travel_demand.top_title_id') and len(get_travel_demand.top_title_id)><cfoutput>#get_travel_demand.top_title_id#</cfoutput></cfif>">
											<input type="text" name="top_title" id="top_title" value="<cfif isdefined('get_travel_demand.top_title_id') and len(get_travel_demand.top_title_id)><cfoutput>#get_emp_info(get_travel_demand.top_title_id,0,0)#</cfoutput></cfif>" onfocus="AutoComplete_Create('top_title','MEMBER_NAME','MEMBER_NAME','get_member_autocomplete','3','EMPLOYEE_ID','top_title_id','','3','135');" autocomplete="off">
											<span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=travel_demand.top_title_id&field_name=travel_demand.top_title&select_list=1','list');"></span>                                     
										</div>
									</div>
								</div>
							</div>
							<div class="col col-4 col-xs-12" type="column" sort="true" index="3">
								<div class="ui-form-block">
									<div class="form-group" id="item-task_causes">
										<label><cf_get_lang dictionary_id="29525.Görevlendirme"><cf_get_lang dictionary_id="34777.Nedeni"></label>
										<textarea name="task_causes" id="task_causes">#get_travel_demand.task_causes#</textarea>
									</div>
								</div>
								<div class="form-group" id="item-is_country">	
									<div class="col col-12 col-xs-12">
										<input type="checkbox" name="is_country" id="is_country" maxlength="200" value="1" <cfif get_travel_demand.is_country eq 1>checked</cfif>>
										<cf_get_lang dictionary_id="29691.Yurtiçi"><cf_get_lang dictionary_id="59973.Seyahat">
									</div>					
								</div>
								<div class="form-group" id="item-travel_type">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="59973.Seyahat"><cf_get_lang dictionary_id="58651.Türü"></label>
									<div class="col col-12 col-xs-12">
										<select class="empty" name="travel_type" id="travel_type">
											<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
											<option value="1" <cfif get_travel_demand.travel_type eq 1>selected</cfif>><cf_get_lang dictionary_id="60477.Görev Seyahatleri"></option>
											<option value="2" <cfif get_travel_demand.travel_type eq 2>selected</cfif>><cf_get_lang dictionary_id="60478.Uzun Süreli Seyahatler"></option>
											<option value="3" <cfif get_travel_demand.travel_type eq 3>selected</cfif>><cf_get_lang dictionary_id="60479.Eğitim Seyahatleri"></option>
										</select>
									</div>
								</div>
								<div class="form-group" id="item-project_id">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57416.proje'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="project_id" id="project_id" value="<cfif isdefined('get_travel_demand.project_id')>#get_travel_demand.project_id#</cfif>">
											<input type="text" name="project_head" id="project_head"  value="<cfif isdefined('get_travel_demand.project_id') and len(get_travel_demand.project_id)>#get_project_name(get_travel_demand.project_id)#</cfif>">
											<span class="input-group-addon icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=travel_demand.project_id&project_head=travel_demand.project_head');"></span>
										</div>
									</div>
								</div>
								<div class="form-group">
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
							<div class="col-4 col-xs-12" type="column" sort="true" index="4">
								<div class="form-group" id="item-departure_date">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'>*</label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='30623.Lütfen Başlangıç Tarihi giriniz'></cfsavecontent>
											<cfinput type="text" name="departure_date" id="departure_date" value="#dateFormat(get_travel_demand.departure_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" required="yes" onchange="totalday()">
											<span class="input-group-addon"><cf_wrk_date_image date_field="departure_date"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-departure_of_date">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'>*</label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='36494.Lütfen Bitiş Tarihi giriniz'></cfsavecontent>
											<cfinput type="text" name="departure_of_date" id="departure_of_date" value="#dateFormat(get_travel_demand.departure_of_date,dateformat_style)#" validate="#validate_style#" maxlength="10" message="#message#" required="yes" onChange="totalday()">
											<span class="input-group-addon"><cf_wrk_date_image date_field="departure_of_date"></span>
										</div>
									</div>
								</div>
								<!--- <div class="form-group" id="item-fare">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60402.Bilet Ücreti'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="text" name="fare" id="fare" class="moneybox" value="#TLformat(get_travel_demand.fare)#" onkeyup="return(FormatCurrency(this,event));">
											<span class="input-group-addon width">
												<select class="empty" name="fare_type" id="fare_type">
													<cfloop query="get_money">                                     
														<option value="#MONEY#" <cfif get_travel_demand.fare_type eq money>selected</cfif>>#MONEY#</option>                                                                             
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
								</div>--->
								<cfif len(get_travel_demand.departure_date) and len(get_travel_demand.departure_of_date)>
									<cfset sum_day=datediff('d',get_travel_demand.departure_date,get_travel_demand.departure_of_date) + 1>
								<cfelse>
									<cfset sum_day= 0>
								</cfif>
								<div class="form-group" id="item-sum_day">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57492.Toplam'><cf_get_lang dictionary_id='30201.Görev'><cf_get_lang dictionary_id='48188.Gün Sayısı'></label>
									<div class="col col-12 col-xs-12">
										<input type="text" name="sum_day" id="sum_day" value="#sum_day#" >
									</div>
								</div>
							</div>
							<div class="col-4 col-xs-12" type="column" sort="true" index="5">
								<div class="form-group" id="item-is_vehicle_demand">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='55335.Araç Talebi'></label>
									<label class="col col-6"><input type="radio" name="is_vehicle_demand" id="is_vehicle_demand1" value="1" <cfif get_travel_demand.is_vehicle_demand eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></label>
									<label  class="col col-6"><input type="radio" name="is_vehicle_demand" id="is_vehicle_demand2" value="0" <cfif get_travel_demand.is_vehicle_demand eq 0 >checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></label>	
								</div>				
								<div class="form-group" id="item-demand_cause" style="<cfif get_travel_demand.is_vehicle_demand eq 1>display:'';<cfelse>display:none;</cfif>">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='31317.Talep Nedeni'></label>
									<div class="col col-12 col-xs-12">
											<input type="text" name="demand_cause" id="demand_cause" value="#get_travel_demand.demand_cause#">
									</div>
								</div>
								<div class="form-group" id="item-is_visa_requirement">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60414.Vize İhtiyacı'></label>
										<label class="col col-6"><input type="radio" name="is_visa_requirement" id="is_visa_requirement1" value="1" <cfif get_travel_demand.is_visa_requirement eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></label>
										<label class="col col-6"><input type="radio" name="is_visa_requirement" id="is_visa_requirement2" value="0" <cfif get_travel_demand.is_visa_requirement eq 0>checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></label>
								</div>
								<!--- <div class="form-group" id="item-visa_fare"  style="<cfif get_travel_demand.is_visa_requirement eq 1>display:'';<cfelse>display:none;</cfif>">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60420.Vize Ücreti'>*</label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="text" name="visa_fare" id="visa_fare" class="moneybox" value="#TLFormat(get_travel_demand.visa_fare)#" onkeyup="return(FormatCurrency(this,event));">
											<span class="input-group-addon width">
												<select class="empty" name="visa_fare_money_type" id="visa_fare_money_type" value="#get_travel_demand.visa_fare_money_type#">
													<cfloop query="get_money">                                     
														<option value="#MONEY#" <cfif get_travel_demand.visa_fare_money_type eq money>selected</cfif>>#MONEY#</option>                                                                             
													</cfloop>
												</select>   
											</span> 
										</div>
									</div>
								</div> --->
								<div class="form-group" id="item-flight_class_demand">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="31181.Talep Edilen"><cf_get_lang dictionary_id="60415.Uçuş Sınıfı"></label>
									<div class="col col-12 col-xs-12">
										<select class="empty" name="flight_class_demand" id="flight_class_demand">
												<option value="0" <cfif get_travel_demand.flight_class_demand eq 0>selected</cfif>><cf_get_lang dictionary_id="57734.Seçiniz"></option>
												<option value="1" <cfif get_travel_demand.flight_class_demand eq 1>selected</cfif>><cf_get_lang dictionary_id="60416.Business"></option>
												<option value="2" <cfif get_travel_demand.flight_class_demand eq 2>selected</cfif>><cf_get_lang dictionary_id="60417.Ekonomi"></option>
										</select>
									</div>
								</div>
							</div>
							<div class="col-4 col-xs-12" type="column" sort="true" index="6">
								<div class="form-group" id="item-task_detail">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57467.Not'></label>
									<div class="col col-12 col-xs-12">
										<textarea name="task_detail" id="task_detail">#get_travel_demand.task_detail#</textarea>
									</div>
								</div>
								<div class="form-group" id="item-is_hotel_demand">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60408.Otel Talebi'></label>
									<label class="col col-6"><input type="radio" name="is_hotel_demand" id="is_hotel_demand1" value="1" <cfif get_travel_demand.is_hotel_demand eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></label>
									<label class="col col-6"><input type="radio" name="is_hotel_demand" id="is_hotel_demand2" value="0" <cfif get_travel_demand.is_hotel_demand eq 0 >checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></label>
								</div>
								<div class="form-group" id="item-hotel_name" style="<cfif get_travel_demand.is_hotel_demand eq 1>display:block;<cfelse>display:none;</cfif>">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60418.Otel İsmi'></label>
									<div class="col col-12 col-xs-12">
										<input type="text" name="hotel_name" id="hotel_name" value="#get_travel_demand.hotel_name#">
									</div>
								</div>
								<div class="form-group" id="item-hotel_payment" style="<cfif get_travel_demand.is_hotel_demand eq 1>display:'';<cfelse>display:none;</cfif>">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="60410.Otel Ödemesi"></label>
									<div class="col col-12 col-xs-12">
										<select class="empty" name="hotel_payment" id="hotel_payment">
											<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
											<option value="1"<cfif get_travel_demand.hotel_payment eq 1>selected</cfif>><cf_get_lang dictionary_id="60411.Acenta Ödemeli"></option>
											<option value="2" <cfif get_travel_demand.hotel_payment eq 2>selected</cfif>><cf_get_lang dictionary_id="60412.Otel Misafir Ödemeli"></option>
											<option value="3" <cfif get_travel_demand.hotel_payment eq 3>selected</cfif>><cf_get_lang dictionary_id="60413.Karşı Taraf Ödemeli"></option>
										</select>
									</div>
								</div>
								<!--- <div class="form-group" id="item-night_fare"  style="<cfif get_travel_demand.is_hotel_demand eq 1>display:'';<cfelse>display:none;</cfif>">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60419.Gecelik Ücret'>*</label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="text" name="night_fare" id="night_fare" class="moneybox" value="#TLFormat(get_travel_demand.night_fare)#" onkeyup="return(FormatCurrency(this,event));">
											<span class="input-group-addon width">
												<select class="empty" name="night_fare_money_type" id="night_fare_money_type">
													<cfloop query="get_money">                                     
														<option value="#MONEY#" <cfif get_travel_demand.night_fare_money_type eq money>selected</cfif>>#MONEY#</option>                                                                             
													</cfloop>
												</select>    
											</span>
										</div>
									</div>
								</div> --->
							</div>	
						</cf_box_elements>
					<!---Avans Bilgileri--->
					<cfsavecontent variable="header3"><cf_get_lang dictionary_id="58204.Avans"><cf_get_lang dictionary_id="37022.Bilgileri"></cfsavecontent>
						<cf_seperator id="advance_info" header="#header3#">
						<cf_box_elements id="advance_info" vertical="1">
							<div class="col col-4 col-xs-12" type="column" sort="true" index="7">
								<div class="form-group" id="item-is_travel_advance_demand" style="<cfif get_travel_demand.travel_type eq 1>display:;<cfelse>display:none;</cfif>"> 
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='59973.Seyahat'><cf_get_lang dictionary_id="30914.Avans Talebi"></label>
									<label class="col col-6"><input type="radio" name="is_travel_advance_demand" id="is_travel_advance_demand1" value="1" <cfif get_travel_demand.is_travel_advance_demand eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></label>
									<label class="col col-6"><input type="radio" name="is_travel_advance_demand" id="is_travel_advance_demand2" value="0" <cfif get_travel_demand.is_travel_advance_demand eq 0 >checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></label>
								</div>
								<div class="form-group" id="item-is_hotel_advance_demand">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60421.Otel'><cf_get_lang dictionary_id="30914.Avans Talebi"></label>
									<label class="col col-6"><input type="radio" name="is_hotel_advance_demand" id="is_hotel_advance_demand1" value="1" <cfif get_travel_demand.is_hotel_advance_demand eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></label>
									<label class="col col-6"><input type="radio" name="is_hotel_advance_demand" id="is_hotel_advance_demand2" value="0" <cfif get_travel_demand.is_hotel_advance_demand eq 0>checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></label>
								</div>
								<div class="form-group" id="item-is_departure_fee">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60422.Yurtdışı Çıkış Harcı Yatırılması Gerekiyor mu?'></label>
									<label class="col col-6"><input type="radio" name="is_departure_fee" id="is_departure_fee1" value="1" <cfif get_travel_demand.is_departure_fee eq 1>checked</cfif>><cf_get_lang dictionary_id='57495.Evet'></label>
									<label class="col col-6"><input type="radio" name="is_departure_fee" id="is_departure_fee2" value="0" <cfif get_travel_demand.is_departure_fee eq 0 >checked</cfif>><cf_get_lang dictionary_id='57496.Hayır'></label>
								</div>
							</div>
							<!--- <div class="col col-4 col-xs-12">
								<div class="form-group" id="item-travel_advance_demand_fare" style="<cfif get_travel_demand.travel_type eq 1>display:;<cfelse>display:none;</cfif>"> 
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='31282.Ücret'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="text" name="travel_advance_demand_fare" id="travel_advance_demand_fare" class="moneybox" value="#TLFormat(get_travel_demand.travel_advance_demand_fare)#" onkeyup="return(FormatCurrency(this,event));">
											<span class="input-group-addon width">
												<select class="empty" name="travel_advance_demand_type" id="travel_advance_demand_type">
													<cfloop query="get_money">                                     
														<option value="#MONEY#" <cfif get_travel_demand.travel_advance_demand_type eq money>selected</cfif>>#MONEY#</option>                                                                             
													</cfloop>
												</select>  
											</span>  
										</div>
									</div>
								</div>
								<div class="form-group" id="item-hotel_advance_demand_fare" style="<cfif get_travel_demand.is_hotel_advance_demand eq 1>display:'';<cfelse>display:none;</cfif>">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='31282.Ücret'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="text" name="hotel_advance_demand_fare" id="hotel_advance_demand_fare" class="moneybox" value="#TLFormat(get_travel_demand.hotel_advance_demand_fare)#" onkeyup="return(FormatCurrency(this,event));">
											<span class="input-group-addon width">
												<select class="empty" name="hotel_advance_demand_type" id="hotel_advance_demand_type">
													<cfloop query="get_money">                                     
														<option value="#MONEY#"  <cfif get_travel_demand.hotel_advance_demand_type eq money>selected</cfif>>#MONEY#</option>                                                                             
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
							<div class="col col-4 col-xs-6" type="column" sort="true" index="8">
								<div class="form-group" id="item-activity_start_date">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="text" name="activity_start_date" id="activity_start_date" value="#dateFormat(get_travel_demand.activity_start_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon"><cf_wrk_date_image date_field="activity_start_date"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-activity_finish_date">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="text" name="activity_finish_date" id="activity_finish_date" value="#dateFormat(get_travel_demand.activity_finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon"><cf_wrk_date_image date_field="activity_finish_date"></span>
										</div>
									</div>
								</div>
							</div>
						<!--- 	<div class="col col-4 col-xs-6">	
								<div class="form-group" id="item-activity_fare">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='29465.Etkinlik'><cf_get_lang dictionary_id='31282.Ücret'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="text" name="activity_fare" id="activity_fare" class="moneybox" value="#TLFormat(filternum(get_travel_demand.activity_fare))#" onkeyup="return(FormatCurrency(this,event));">
											<span class="input-group-addon width">
												<select class="empty" name="activity_fare_money_type" id="activity_fare_money_type">
													<cfloop query="get_money">                                     
														<option value="#MONEY#" <cfif get_travel_demand.activity_fare_money_type eq money>selected</cfif>>#MONEY#</option>                                                                             
													</cfloop>
												</select>
											</span>  
										</div>  
									</div>
								</div>
							</div> --->
							<div class="col col-4 col-xs-12" type="column" sort="true" index="9">
								<div class="form-group" id="item-activity_detail">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57467.Not'></label>
									<div class="col col-12 col-xs-12">
										<textarea name="activity_detail" id="activity_detail">#get_travel_demand.activity_detail#</textarea>
									</div>
								</div>
							</div>
						</cf_box_elements>	
					<!---Kişisel Seyahat Tercihleri--->
					<cfsavecontent variable="header5"><cf_get_lang dictionary_id="29688.Kişisel"><cf_get_lang dictionary_id="59973.Seyahat"><cf_get_lang dictionary_id="44333.Tercihi"></cfsavecontent>
						<cf_seperator id="personal_travel_info" header="#header5#">
						<cf_box_elements id="personal_travel_info" vertical="1">
							<div class="col col-4 col-xs-12" type="column" sort="true" index="10">
								<div class="form-group" id="item-flight_departure_date">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60427.Uçak'><cf_get_lang dictionary_id='45410.Gidiş Tarihi'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="text" name="flight_departure_date" id="flight_departure_date" value="#dateFormat(get_travel_demand.flight_departure_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon"><cf_wrk_date_image date_field="flight_departure_date"></span>
										</div>
									</div>
								</div>
								<div class="form-group" id="item-flight_departure_of_date">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60427.Uçak'><cf_get_lang dictionary_id='45408.Dönüş Tarihi'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="text" name="flight_departure_of_date" id="flight_departure_of_date" value="#dateFormat(get_travel_demand.flight_departure_of_date,dateformat_style)#" validate="#validate_style#" maxlength="10">
											<span class="input-group-addon"><cf_wrk_date_image date_field="flight_departure_of_date"></span>
										</div>
									</div>
								</div>
							</div>
							<!--- <div class="col col-4 col-xs-12">	
								<div class="form-group" id="item-airfare">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='60423.Uçak Ücreti'></label>
									<div class="col col-12 col-xs-12">
										<div class="input-group">
											<input type="text" name="airfare" id="airfare" class="moneybox" value="<cfif len(get_travel_demand.airfare)>#TLFormat(get_travel_demand.airfare)#</cfif>" onkeyup="return(FormatCurrency(this,event));">
											<span class="input-group-addon width">
												<select class="empty" name="airfare_money_type" id="airfare_money_type">
													<cfloop query="get_money">                                     
														<option value="#MONEY#" <cfif get_travel_demand.airfare_money_type eq money>selected</cfif>>#MONEY#</option>                                                                             
													</cfloop>
												</select>    
											</span>
										</div>
									</div>
								</div>
							</div> --->
							<div class="col col-4 col-xs-12" type="column" sort="true" index="11">
								<div class="form-group" id="item-flight_detail">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57467.Not'></label>
									<div class="col col-12 col-xs-12">
										<textarea name="flight_detail" id="flight_detail">#get_travel_demand.flight_detail#</textarea>
									</div>
								</div>
							</div>
						</cf_box_elements>
					<!---Seyahat için / Seyahat Esnasında Yararlanılacak Ulaşım Aracı--->
					<cfsavecontent variable="header6"><cf_get_lang dictionary_id="60428.Seyahat için / Seyahat Esnasında Yararlanılacak Ulaşım Aracı"></cfsavecontent>
						<cf_seperator id="travel_vehicle_" header="#header6#">
						<cf_box_elements id="travel_vehicle_" vertical="1">
							<div class="col col-12 col-xs-12" id="item-travel_vehicle" type="column" sort="true" index="12">	
								<div class="form-group">
									<div class="col col-2 col-xs-4"> 
										<label><cf_get_lang dictionary_id='60427.Uçak'><input type="checkbox" id="travel_vehicle_1" name="travel_vehicle" value="1" <cfif get_travel_demand.travel_vehicle contains 1>checked</cfif>></label>
									</div>
									<div class="col col-2 col-xs-4"> 
										<label><cf_get_lang dictionary_id='29677.Şahsi'><cf_get_lang dictionary_id='58480.Araç'><input type="checkbox" id="travel_vehicle_2" name="travel_vehicle" value="2" <cfif get_travel_demand.travel_vehicle contains 2>checked</cfif>></label>
									</div>
									<div class="col col-2 col-xs-4"> 
										<label><cf_get_lang dictionary_id='60429.Otobüs'><input type="checkbox" id="travel_vehicle_3" name="travel_vehicle" value="3" <cfif get_travel_demand.travel_vehicle contains 3>checked</cfif>></label>
									</div>
									<div class="col col-2 col-xs-4"> 
										<label><cf_get_lang dictionary_id='60430.Rent-a-Car'><input type="checkbox" id="travel_vehicle_4" name="travel_vehicle" value="4" <cfif get_travel_demand.travel_vehicle contains 4>checked</cfif>></label>
									</div>
									<div class="col col-2 col-xs-4"> 
										<label><cf_get_lang dictionary_id='57712.Kurum'><cf_get_lang dictionary_id='34831.Aracı'><input type="checkbox" id="travel_vehicle_5" name="travel_vehicle" value="5" <cfif get_travel_demand.travel_vehicle contains 5>checked</cfif>></label>
									</div>
									<div class="col col-2 col-xs-4"> 
										<label><cf_get_lang dictionary_id='60431.Havaalanı Transferi'><input type="checkbox" id="travel_vehicle_6" name="travel_vehicle" value="6" <cfif get_travel_demand.travel_vehicle contains 6>checked</cfif>></label>
									</div>
								</div>
								<cfset travel_list = listdeleteduplicates(get_travel_demand.travel_vehicle,'1,2,3,4,5,6,',',')>
								<div class="form-group">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58156.Diğer'></label>
									<div class="col col-12 col-xs-12">
										<input type="text" name="travel_vehicle" id="travel_vehicle" value="#travel_list#"></input>
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
						<cf_seperator id="activity" header="#header7#">
						<cf_box_elements id="activity" vertical="1">
							<div class="col col-4 col-xs-12" type="column" sort="true" index="13">	
								<div class="form-group"  id="item-activity_address">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58723.Adres'></label>
									<div class="col col-12 col-xs-12"> 
										<textarea id="activity_address" name="activity_address">#get_travel_demand.activity_address#</textarea>
									</div>
								</div>
							</div>
							<div class="col col-4 col-xs-12" type="column" sort="true" index="14">
								<div class="form-group"  id="item-activity_website">
									<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='34867.Web Sitesi'></label>
									<div class="col col-12 col-xs-12">
										<input type="text" name="activity_website" id="activity_website" value="#get_travel_demand.activity_website#"></input>
									</div>
								</div>
							</div>
						</cf_box_elements>
					<!---Onaylar--->
					<cfsavecontent variable="header8"><cf_get_lang dictionary_id="30870.Onaylar"></cfsavecontent>
						<cf_seperator id="valid" header="#header8#">
						<cf_box_elements id="valid" vertical="1">
							<div class="col col-4 col-xs-12" type="column" sort="true" index="15">		
								<div class="form-group" id="item-process_cat">
									<label class="col col-12 col-xs-12"><cf_get_lang_main no ='1447.Süreç'>*</label>
									<div class="col col-12 col-xs-12">
										<cf_workcube_process is_upd='0' process_cat_width='180' is_detail='1' select_value='#get_travel_demand.demand_stage#'>
									</div>
								</div>			
							</div>
						</cf_box_elements>
					<cf_box_footer>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12">
							<cf_record_info query_name="get_travel_demand">
						</div>
						<div class="col col-6 col-md-6 col-sm-6 col-xs-12" id="form_button">
							<cfif fusebox.circuit neq 'myhome' or (fusebox.circuit eq 'myhome' and not len(get_travel_demand.manager1_valid_date))>
								<cf_workcube_buttons is_upd='1' is_delete='1'  delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_travel_demand&TRAVEL_DEMAND_ID=#TRAVEL_DEMAND_ID#' add_function="check()">
							</cfif>
						</div>
					</cf_box_footer>
				</cfoutput>
			</cfform>
		</cf_box>
		<cf_box title="#getLang('','Harcırah Talepleri',62018)#" add_href="#request.self#?fuseaction=hr.allowance_expense&event=add&travel_demand_id=#attributes.travel_demand_id#">
			<cfquery name="get_allowance_expense" datasource="#dsn2#">
				SELECT * FROM EXPENSE_ITEM_PLAN_REQUESTS WHERE EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_travel_demand.employee_id#"> AND EXPENSE_HR_ALLOWANCE = #attributes.travel_demand_id#
			</cfquery>
			<cf_flat_list>
				<thead>
						<th><cf_get_lang dictionary_id = "57880.Belge No"></th>
						<th><cf_get_lang dictionary_id = "57742.Tarih"></th>
						<th><cf_get_lang dictionary_id = "58859.Süreç"></th>
						<th><cf_get_lang dictionary_id = "56975.KDV'li tutar"></th>
						<th><a href="javascript://"><i class="fa fa-pencil"></i></a></th>
				</thead>
				<cfif get_allowance_expense.recordCount>
					<cfoutput query="get_allowance_expense">
						<cfquery name="get_process" datasource="#dsn#">
							SELECT * FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_allowance_expense.expense_stage#">
						</cfquery>
						<tbody>
							<td>#paper_no#</td>
							<td>#dateFormat(expense_date,dateformat_style)#</td>
							<td>#get_process.stage#</td>
							<td>#TLFormat(net_kdv_amount)# #money#</td>
							<td><a href="#request.self#?fuseaction=hr.allowance_expense&event=upd&request_id=#expense_id#" ><i class="fa fa-pencil"></i></a></td>
						</tbody>
						</tbody>
					</cfoutput>
				</cfif>
			</cf_flat_list>

		</cf_box>
	</div>
	<div class="col col-3 col-xs-12">
		<cf_get_workcube_asset asset_cat_id="-8" company_id="#session.ep.company_id#" period_id="#session.ep.period_id#" module_id='3' action_section='TRAVEL_DEMAND_ID' action_id='#attributes.travel_demand_id#'>
	<cf_box title="#getLang('','Seyahat Bütçesi',62017)#">
		<cfform name="add_expense" action="#request.self#?fuseaction=hr.allowance_expense&event=add&travel_demand_id=#attributes.travel_demand_id#" method="post">
			<div id="expense_request_bask">
				<cf_grid_list sort="0">
					<thead>
					<th width="15">  
						<input type="hidden" name="record_num" id="record_num" value="0">
						<a href="javascript://" title="<cf_get_lang dictionary_id='57582.Ekle'>" onClick="add_row();"><i class="fa fa-plus"></i></a>
					</th>
					<th><cf_get_lang dictionary_id='41539.Harcırah Tipi'></th>
					<th><cf_get_lang dictionary_id='57673.Tutar'></th>
				</thead>
				<tbody id="table1" name="table1"></tbody>
			</cf_grid_list>
			<div class="ui-row">
				<div id="sepetim_total" class="padding-0">
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12">	  
						<table>
							<input type="hidden" name="kur_say" id="kur_say" value="<cfoutput>#get_money.recordcount#</cfoutput>">
							<tbody>
								<tr>
									<td><cf_get_lang dictionary_id='57492.Toplam'></td>
										<td class="text-right"><cfinput type="text" name="total_amount" id="total_amount" class="box" readonly="" value="#TlFormat(0,session.ep.our_company_info.rate_round_num)#" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#session.ep.our_company_info.rate_round_num#);this.select();"></td>
								</tr>
								<tr>
									<td width="100" class="txtbold"><cf_get_lang dictionary_id='58204.Avans'></td>
									<td class="text-right"><cfinput type="text" name="total_advance" id="total_advance" class="box"  value="#TlFormat(0,session.ep.our_company_info.rate_round_num)#" onchange="toplam_hesapla();" onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.rate_round_num#));" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#session.ep.our_company_info.rate_round_num#);this.select();"></td>
								</tr>
								<tr>
									<td width="100" class="txtbold"><cf_get_lang dictionary_id='58583.Fark'></td>
									<td class="text-right"><cfinput type="text" name="total_difference" id="total_difference" class="box" readonly=""  value="#TlFormat(0,session.ep.our_company_info.rate_round_num)#" onFocus="document.getElementById('control_field_value').value=filterNum(this.value,#session.ep.our_company_info.rate_round_num#);this.select();"></td>
								</tr>
							</tbody>
						</table>    
					</div>
				</div>
			</div>
			<div class="ui-info-bottom flex-end">
				<button type="submit" name="submit" value=""  class="ui-wrk-btn ui-wrk-btn-extra"><cf_get_lang dictionary_id='47809.Harcırah Talebi'><cf_get_lang dictionary_id='58966.Oluştur'></button>
			</div>
		</div>
		</cfform>
	</cf_box>
	</div>
</cfif>
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
		/* $('input:radio[name="is_visa_requirement"]').change(
			function(){
				if ($(this).is(':checked')) {
					if($(this).attr('id')=='is_visa_requirement1') {
						$('#item-visa_fare').css('display', 'block');
					} else {
						$('#item-visa_fare').css('display', 'none');
					}
				}
			}); */
		/* $('input:radio[name="is_travel_advance_demand"]').change(
			function(){
				if ($(this).is(':checked')) {
					if($(this).attr('id')=='is_travel_advance_demand1') {
						$('#item-travel_advance_demand_fare').css('display', 'block');
					} else {
						$('#item-travel_advance_demand_fare').css('display', 'none');
					}
				}
			}); */
		$('input:radio[name="is_hotel_advance_demand"]').change(
			function(){
				if ($(this).is(':checked')) {
					/* if($(this).attr('id')=='is_hotel_advance_demand1') {
						$('#item-hotel_advance_demand_fare').css('display', 'block');
						
					} else {
						$('#item-hotel_advance_demand_fare').css('display', 'none');
					} */
					
				}
			});
			$("input[type='radio'][name='is_hotel_demand']").change(function() {
				if ($('#is_hotel_demand2').is(':checked')) {
					$('#is_hotel_advance_demand1').prop("checked", false);
					$('#is_hotel_advance_demand2').prop("checked", true);
				} else {
					$('#is_hotel_advance_demand1').prop("checked", true);
					$('#is_hotel_advance_demand2').prop("checked", false);
				}
			});
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
					//$('#item-travel_advance_demand_fare').css('display', 'none');
				}
				else
				{
					$('#item-is_travel_advance_demand').css('display', 'block');
					/* if($('#is_travel_advance_demand2').prop("checked", true))
						$('#item-travel_advance_demand_fare').css('display', 'none');
					else
						$('#item-travel_advance_demand_fare').css('display', 'block'); */
				}
				
			}); 

			var travel_type = $("#travel_type").val();
			var is_travel_advance_demand = $("input[name='is_travel_advance_demand']:checked"). val();
			if (travel_type != 1) {
				$("input[name='is_travel_advance_demand']:checked"). val(0);
				/* if (is_travel_advance_demand == 0) {

					$('#item-travel_advance_demand_fare').css('display', 'none');
				}  */
			}
			
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
	row_count=0;
	function toplam_hesapla() {
		var toplam_dongu_1 = 0;
		for(r=1;r<=add_expense.record_num.value;r++)
		{
			if(document.getElementById('row_kontrol'+r).value==1)
			{
				deger_total = document.getElementById('total'+r) ;//tutar
				if(deger_total.value == "") deger_total.value = 0;
				deger_total.value = filterNum(deger_total.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
				toplam_dongu_1 = toplam_dongu_1 + parseFloat(deger_total.value);
				deger_total.value = commaSplit(deger_total.value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
			}
		}
		document.getElementById("total_difference").value = filterNum(document.getElementById("total_difference").value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
		document.getElementById("total_advance").value = filterNum(document.getElementById("total_advance").value,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>);
		document.add_expense.total_amount.value = toplam_dongu_1;
		document.add_expense.total_difference.value = document.add_expense.total_amount.value - document.add_expense.total_advance.value;
		unformatfields();
	}
	function sil(sy)
	{
		var my_element=eval("add_expense.row_kontrol"+sy);
		my_element.value=0;
		var my_element=eval("frm_row"+sy);
		my_element.style.display="none";	
		add_expense.record_num.value = add_expense.record_num.value - 1;
		toplam_hesapla();
	}
	function add_row(amount,expense_type,expense_type_name) {
		
		if(amount == undefined) amount = '0';
		if(expense_type == undefined) expense_type = '';
		if(expense_type_name == undefined) expense_type_name = '';
		var pos_cat_id_ = document.getElementById("pos_cat_id").value;
		row_count++;
            var newRow;
            var newCell;
			newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
			document.add_expense.record_num.value=row_count;
			newRow.setAttribute("name","frm_row" + row_count);
			newRow.setAttribute("id","frm_row" + row_count);		
			newRow.setAttribute("NAME","frm_row" + row_count);
			newRow.setAttribute("ID","frm_row" + row_count);	
			newCell = newRow.insertCell(newRow.cells.length);	
			newCell.innerHTML = '<input  type="hidden" value="1" id="row_kontrol' + row_count +'" name="row_kontrol' + row_count +'" ><a style="cursor:hand" onclick="sil('+ row_count +');"><i class="fa fa-minus" border="0"></i></a>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><div class="input-group"> <input type="hidden" name="expense_type'+row_count+'" id="expense_type'+row_count+'" value="'+expense_type+'"><input type="hidden" name="expense_center_id'+row_count+'" id="expense_center_id'+row_count+'" value=""><input type="hidden" name="expense_center_name'+row_count+'" id="expense_center_name'+row_count+'" value=""> <input type="hidden" name="expense_item_name'+row_count+'" id="expense_item_name'+row_count+'" value=""><input type="hidden" name="expense_item_id'+row_count+'" id="expense_item_id'+row_count+'" value=""><input type="text" name="expense_type_name'+row_count+'" id="expense_type_name'+row_count+'" value="'+expense_type_name+'" class="boxtext" style="width:90%" onFocus="AutoComplete_Create(\'expense_type_name' + row_count +'\',\'EXPENSE_HR_RULES_DETAIL,EXPENSE_HR_RULES_ID\',\'EXPENSE_HR_RULES_DETAIL\',\'get_expense_rules\',\''+pos_cat_id_+'\',\'EXPENSE_HR_RULES_TYPE,EXPENSE_CENTER,EXPENSE,EXPENSE_ITEM_ID,EXPENSE_ITEM_NAME\',\'expense_type' + row_count +','+'expense_center_id'+row_count+','+'expense_center_name'+row_count+','+'expense_item_id'+row_count+','+'expense_item_name'+row_count+'\',\'\',\'3\',\'200\',\'\',\'1\');" autocomplete="off" value=""> <span class="input-group-addon icon-ellipsis" onClick="open_expense_allowance('+row_count+');"></span></div></div>';
			newCell = newRow.insertCell(newRow.cells.length);
			newCell.innerHTML = '<div class="form-group"><div class="input-group"><input type="text" name="total' + row_count + '" id="total' + row_count + '"  onblur="toplam_hesapla();"  onkeyup="return(FormatCurrency(this,event,4));" class="moneybox" value="'+commaSplit(amount,<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>)+'" style="padding-right:6px!important;"><span class="input-group-addon width"><select name="money_id' + row_count +'"><cfoutput query="get_money"><option value="#money#">#money#</option></cfoutput></select></span></div></div>';
	}
			
	function open_expense_allowance(no)
	{
		employee_id_ = document.getElementById("employee_id").value;

		cfmodal('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_allowance_rules&is_popup=0&field_id=expense_type'+no+'&field_expense_center_id=expense_center_id'+no+'&field_expense_center_name=expense_center_name'+no+'&field_expense_item_id=expense_item_id'+no+'&field_expense_item_name=expense_item_name'+no+'&field_money_type=money_id'+no+'&field_name=expense_type_name'+no+'&employee_id='+employee_id_,'warning_modal');
	}
	function check()
	{
		
		var hotel_payment = $("#hotel_payment").val();
		var night_fare=$("#night_fare").val();
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
	
		var visa_fare=$("#visa_fare").val();
		var is_visa_requirement = $("input[name='is_visa_requirement']:checked"). val();
		/* if (is_visa_requirement == 1) 
		{
			if (visa_fare == '') {
			alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id='60420.Vize Ücreti'>");
				return false;   
			}
		} */
		if ($("#city").val() == '' && $("#city_").val() == '') 
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


		if( is_hotel_demand == 1 ) 
		{
			if (hotel_payment == 0) {

				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'>:<cf_get_lang dictionary_id="60410.Otel Ödemesi">");
				document.getElementById("hotel_payment").focus();
				return false;   
			}
		}

		if(datediff(document.getElementById('departure_date').value,document.getElementById('departure_of_date').value,0)<0)
		{
			alert("<cf_get_lang dictionary_id='40467.Başlangıç tarihi bitiş tarihinden büyük olmamalıdır.'>!");
			return false;
		} 
		if(datediff(document.getElementById('activity_start_date').value,document.getElementById('activity_finish_date').value,0)<0)
		{
			alert("<cf_get_lang dictionary_id='294654.Etkinlik'><cf_get_lang dictionary_id='40467.Başlangıç tarihi bitiş tarihinden büyük olmamalıdır.'>!");
			return false;
		} 

		if(datediff(document.getElementById('flight_departure_date').value,document.getElementById('flight_departure_of_date').value,0)<0)
		{
			alert("<cf_get_lang dictionary_id='60427.Uçak'><cf_get_lang dictionary_id='40467.Başlangıç tarihi bitiş tarihinden büyük olmamalıdır.'>!");
			return false;
		} 
		return process_cat_control();
	}
	function unformatfields() {
		document.getElementById("total_amount").value = commaSplit(document.getElementById("total_amount").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("total_difference").value = commaSplit(document.getElementById("total_difference").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
		document.getElementById("total_advance").value = commaSplit(document.getElementById("total_advance").value,'<cfoutput>#session.ep.our_company_info.rate_round_num#</cfoutput>');
	}
	</script> 