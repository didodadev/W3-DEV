<cfinclude template="../query/get_money.cfm">
	<cfinclude template="../query/get_fuel_type.cfm">
		<cfquery name="GET_DOCUMENT_TYPE" datasource="#DSN#">
			SELECT
			SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID,
			SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_NAME
			FROM
			SETUP_DOCUMENT_TYPE,
			SETUP_DOCUMENT_TYPE_ROW
			WHERE
			SETUP_DOCUMENT_TYPE_ROW.DOCUMENT_TYPE_ID = SETUP_DOCUMENT_TYPE.DOCUMENT_TYPE_ID AND
			SETUP_DOCUMENT_TYPE_ROW.FUSEACTION LIKE '%#fuseaction#%'
			ORDER BY
			DOCUMENT_TYPE_NAME
		</cfquery>
		<cfquery name="GET_ASETP_FUEL_KM" datasource="#DSN#">
			SELECT
			A.ASSETP,
			B.BRANCH_NAME,
			D.DEPARTMENT_HEAD,
			AF.FUEL_ID,
			AF.FUEL_TYPE_ID,
			AF.DOCUMENT_TYPE_ID,
			AF.FUEL_COMPANY_ID,
			AF.DOCUMENT_NUM,
			AF.FUEL_AMOUNT,
			AF.TOTAL_AMOUNT,
			AF.RECORD_DATE,
			AF.RECORD_EMP,
			AF.UPDATE_EMP,
			AF.UPDATE_DATE,
			AK.KM_CONTROL_ID,
			AK.EMPLOYEE_ID,
			AK.ASSETP_ID,
			AK.DEPARTMENT_ID,
			AK.START_DATE,
			AK.FINISH_DATE,
			AK.DETAIL,
			AK.KM_START,
			AK.KM_FINISH,
			AK.IS_OFFTIME,
			AK.IS_ALLOCATE,
			(SELECT MAX(KM_FINISH) FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = A.ASSETP_ID) AS KM_LAST,
			(SELECT MAX(KM_CONTROL_ID) FROM ASSET_P_KM_CONTROL WHERE ASSETP_ID = A.ASSETP_ID) AS KM_CONTROL_ID_LAST
			FROM
			ASSET_P_KM_CONTROL AK,
			ASSET_P_FUEL AF,
			ASSET_P A,
			DEPARTMENT D,
			BRANCH B
			WHERE
			AK.KM_CONTROL_ID = #attributes.km_control_id# AND
			AK.FUEL_ID = AF.FUEL_ID AND
			A.ASSETP_ID = AK.ASSETP_ID AND
			D.DEPARTMENT_ID = AF.DEPARTMENT_ID AND
			D.BRANCH_ID = B.BRANCH_ID AND
			<!--- Sadece yetkili olunan subeler gozuksun--->
			B.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE =
			#session.ep.position_code#)
		</cfquery>
		<cfquery name="GET_COMPANY" datasource="#DSN#">
			SELECT COMPANY_ID, FULLNAME FROM COMPANY WHERE COMPANY_ID = #get_asetp_fuel_km.fuel_company_id#
		</cfquery>
		<!--- <cfsavecontent variable="img"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=assetcare.popup_add_fuel_km"><img src="/images/plus1.gif" alt="" title="<cf_get_lang_main no='170. Ekle'>"></a></cfsavecontent> --->
		<cf_box title="#getLang('','Yakıt-Km',48556)#" add_href="#request.self#?fuseaction=assetcare.popup_add_fuel_km">

			<cfform name="upd_fuel_km" method="post" action="#request.self#?fuseaction=assetcare.emptypopup_upd_fuel_km"
				onsubmit="return unformat_fields();">
				<cf_box_elements>
					<input type="hidden" name="km_control_id" id="km_control_id"
						value="<cfoutput>#get_asetp_fuel_km.km_control_id#</cfoutput>">
					<input type="hidden" name="is_allocate" id="is_allocate"
						value="<cfoutput>#get_asetp_fuel_km.is_allocate#</cfoutput>">
					<input type="hidden" name="km_last" id="km_last"
						value="<cfoutput>#get_asetp_fuel_km.km_last#</cfoutput>">

					<!--- First Row		 --->
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">

						<div class="form-group" id="car_info">
							<label class="col fw-bold"><span style="font-weight:bold;">
									<cf_get_lang dictionary_id='48559.Araç Bilgisi'>
								</span></label>
						</div>

						<div class="form-group" id="branch_id">
							<label class="col col-4 col-xs-12">
								<cf_get_lang dictionary_id='41443.Plaka'>*
							</label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<input type="hidden" name="assetp_id" id="assetp_id"
										value="<cfoutput>#get_asetp_fuel_km.assetp_id#</cfoutput>">
									<cfinput name="assetp_name" value="#get_asetp_fuel_km.assetp#" type="text" readonly
										style="width:140px;">
										<cfif (get_asetp_fuel_km.km_control_id_last eq get_asetp_fuel_km.km_control_id)
											and (get_asetp_fuel_km.is_allocate eq 0)>
										</cfif>
										<span class="input-group-addon icon-ellipsis"
											onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_ship_vehicles&field_id=upd_fuel_km.assetp_id&field_name=upd_fuel_km.assetp_name&field_emp_id=upd_fuel_km.employee_id&field_emp_name=upd_fuel_km.employee_name&field_dep_name=upd_fuel_km.department&field_dep_id=upd_fuel_km.department_id&field_pre_date=upd_fuel_km.start_date&field_pre_km=upd_fuel_km.pre_km&is_from_km_kontrol=1&fuel_type_id=upd_fuel_km.fuel_type_id&is_active=1','list','popup_list_ship_vehicles');"
											</span> 
										</div>
									 </div>
									 </div> 
									 <div class=" form-group" id="response">
											<label class="col col-4 col-xs-12">
												<cf_get_lang dictionary_id='57544.Sorumlu'>*
											</label>
											<div class="col col-8 col-xs-12">
												<div class="input-group">
													<input type="hidden" name="employee_id" id="employee_id"
														value="<cfoutput>#get_asetp_fuel_km.employee_id#</cfoutput>">
													<cfinput type="text" name="employee_name"
														value="#get_emp_info(get_asetp_fuel_km.employee_id,0,0)#"
														readonly style="width:140px;">
														<cfif (get_asetp_fuel_km.km_control_id_last eq
															get_asetp_fuel_km.km_control_id) and
															(get_asetp_fuel_km.is_allocate eq 0)>
															<span class="input-group-addon icon-ellipsis"
																onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=upd_fuel_km.employee_id&field_name=upd_fuel_km.employee_name&field_pre_km=upd_fuel_km.pre_km&field_pre_date=upd_fuel_km.start_date&select_list=1&branch_related','list','popup_list_positions')"></span>
														</cfif>
												</div>
											</div>
								</div>

								<div class=" form-group" id="branch_id">
									<label class="col col-4 col-xs-12">
										<cf_get_lang dictionary_id='57453.Şube'> *
									</label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<input type="hidden" name="department_id" id="department_id"
												value="<cfoutput>#get_asetp_fuel_km.department_id#</cfoutput>">
											<cfinput type="text" name="department"
												value="#get_asetp_fuel_km.branch_name# - #get_asetp_fuel_km.department_head#"
												readonly style="width:140px;">
												<cfif (get_asetp_fuel_km.km_control_id_last eq
													get_asetp_fuel_km.km_control_id) and (get_asetp_fuel_km.is_allocate
													eq 0)>
													<span class="input-group-addon icon-ellipsis"
														onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_departments&field_id=upd_fuel_km.department_id&field_name=upd_fuel_km.department','list','popup_list_departments');"></span>
												</cfif>
										</div>
									</div>
								</div>
							</div>
							<!--- Second Row --->
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="2" sort="true">
								<div class="form-group" id="Km_record">
									<label class="col fw-bold"><span style="font-weight:bold;">
											<cf_get_lang dictionary_id='47971.KM Kayıt'>
										</span></label>
								</div>

								<div class=" form-group" id="km_exdate">
									<label class="col col-4 col-xs-12">
										<cf_get_lang dictionary_id='48227.Önceki KM Tarihi'>
									</label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfinput type="text" name="start_date"
												value="#dateformat(get_asetp_fuel_km.start_date,dateformat_style)#"
												readonly style="width:140px;">
												<cfif (get_asetp_fuel_km.km_control_id_last eq
													get_asetp_fuel_km.km_control_id) and (get_asetp_fuel_km.is_allocate
													eq 0)>
													<span class="input-group-addon" <i class="fa fa-calendar">
														<cf_wrk_date_image date_field="start_date"></i>
													</span>
												</cfif>
										</div>
									</div>
								</div>
								<div class=" form-group" id="exkm">
									<label class="col col-4 col-xs-12">
										<cf_get_lang dictionary_id='48228.Önceki KM'>
									</label>
									<div class="col col-8 col-xs-12">

										<cfinput type="text" name="pre_km" value="#get_asetp_fuel_km.km_start#" readonly
											style="width:140px;">
											<a href="javascript://"
												onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=add_assetp.position_code&field_name=add_assetp.position</cfoutput>','list','popup_list_positions')"></a>

									</div>
								</div>
								<div class=" form-group" id="km_date">
									<label class="col col-4 col-xs-12">
										<cf_get_lang dictionary_id='48230.Son KM Tarihi'>*
									</label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<cfif (get_asetp_fuel_km.km_control_id_last eq
												get_asetp_fuel_km.km_control_id) and (get_asetp_fuel_km.is_allocate eq
												0)>
												<cfinput type="text" name="finish_date"
													value="#dateformat(get_asetp_fuel_km.finish_date,dateformat_style)#"
													style="width:140px;" maxlength="10">
													<span class="input-group-addon" <i class="fa fa-calendar">
														<cf_wrk_date_image date_field="finish_date"></i>
													</span>
													<cfelse>
														<cfinput type="text" name="finish_date"
															value="#dateformat(get_asetp_fuel_km.finish_date,dateformat_style)#"
															style="width:140px;" readonly maxlength="10">
											</cfif>
										</div>
									</div>
								</div>

								<div class=" form-group" id="lastkm">
									<label class="col col-4 col-xs-12">
										<cf_get_lang dictionary_id='48090.Son KM '>*
									</label>
									<div class="col col-8 col-xs-12">

										<cfif (get_asetp_fuel_km.km_control_id_last eq get_asetp_fuel_km.km_control_id)
											and (get_asetp_fuel_km.is_allocate eq 0)>
											<cfinput name="last_km" type="text" value="#get_asetp_fuel_km.km_finish#"
												style="width:140px;" onKeyup="return(FormatCurrency(this,event,0));">
												<cfelse>
													<cfinput name="last_km" type="text"
														value="#get_asetp_fuel_km.km_finish#" style="width:140px;"
														readonly onKeyup="return(FormatCurrency(this,event,0));">
										</cfif>

									</div>
								</div>

								<div class="form-group" id="descp">
									<label class="col col-4 col-xs-12">
										<cf_get_lang dictionary_id='36199.Açıklama'>
									</label>
									<div class="col col-8 col-xs-12">

										<cfif (get_asetp_fuel_km.km_control_id_last eq get_asetp_fuel_km.km_control_id)
											and (get_asetp_fuel_km.is_allocate eq 0)>
											<cfinput type="text" name="detail" value="#get_asetp_fuel_km.detail#"
												style="width:140px" maxlength="200">
												<cfelse>
													<cfinput type="text" name="detail"
														value="#get_asetp_fuel_km.detail#" readonly style="width:140px"
														maxlength="200">
										</cfif>
									</div>
								</div>


								<div class="form-group" id="branch_id">

									<label class="col col-4 col-xs-12">
										<cf_get_lang dictionary_id='48229.Mesai Dışı'>
									</label>
									<div class="col col-8 col-xs-12">
										<cfif (get_asetp_fuel_km.km_control_id_last eq get_asetp_fuel_km.km_control_id)
											and (get_asetp_fuel_km.is_allocate eq 0)>
											<input name="is_offtime" id="is_offtime" type="checkbox" value="1" <cfif
												get_asetp_fuel_km.is_offtime eq 1>checked</cfif>>
										<cfelse>
											<input name="is_offtime" id="is_offtime" type="checkbox" value="1" disabled
												<cfif get_asetp_fuel_km.is_offtime eq 1>checked</cfif>>
											</cfif>
									</div>
								</div>
							</div>

							<!--- Third Row --->
							<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="3" sort="true">

								<div class="form-group" id="fuel_record">
									<label class="col"><span style="font-weight:bold;">
											<cf_get_lang dictionary_id='48069.Yakıt Kayıt'>
										</span></label>
								</div>

								<div class="form-group " id="doc">
									<label class="col col-4 col-xs-12">
										<cf_get_lang dictionary_id='57880.Belge No'>
									</label>

									<div class="col col-4 col-xs-8" style="padding-right:0.5rem;">
										<cfinput type="text" name="fuel_num" value="#get_asetp_fuel_km.fuel_id#"
											readonly style="width:39px;">
									</div>

									<div class="col col-4 col-xs-8">
										<cfinput type="text" name="document_num"
											value="#get_asetp_fuel_km.document_num#" style="width:99px;">
									</div>
								</div>
								<div class="form-group" id="doc_type">
									<label class="col col-4 col-xs-12">
										<cf_get_lang dictionary_id='58533.Belge Tipi'>*
									</label>
									<div class="col col-8 col-xs-12">
										<select name="document_type_id" id="document_type_id" style="width:140px">
											<option value="">
												<cf_get_lang dictionary_id='57734.Seçiniz'>
											</option>
											<cfoutput query="get_document_type">
												<option value="#document_type_id#" <cfif
													get_asetp_fuel_km.document_type_id eq document_type_id>selected
													</cfif>>#document_type_name#</option>
											</cfoutput>
										</select>

									</div>
								</div>
								<div class="form-group" id="fuel_comp">
									<label class="col col-4 col-xs-12">
										<cf_get_lang dictionary_id='30117.Yakıt Şirketi'>*
									</label>
									<div class="col col-8 col-xs-12">
										<div class="input-group">
											<input name="fuel_comp_id" id="fuel_comp_id" type="hidden"
												value="<cfoutput>#get_asetp_fuel_km.fuel_company_id#</cfoutput>">
											<cfsavecontent variable="message12">
												<cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang
														dictionary_id='30117.Yakıt Şirketi'>
											</cfsavecontent>
											<cfinput type="text" name="fuel_comp_name" value="#get_company.fullname#"
												readonly required="yes" message="#message12#" style="width:140px;">
												<span class="input-group-addon icon-ellipsis"
													onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_pars&field_comp_id=upd_fuel_km.fuel_comp_id&field_comp_name=upd_fuel_km.fuel_comp_name&is_buyer_seller=1&select_list=2','list','popup_list_pars')"></span>

										</div>
									</div>
								</div>

								<div class="form-group" id="fuel_type">
									<label class="col col-4 col-xs-12">
										<cf_get_lang dictionary_id='48259.Yakıt Miktarı'> (Lt)*
									</label>
									<div class="col col-8 col-xs-12">
										<cfsavecontent variable="message25">
											<cf_get_lang dictionary_id='63587.girilmesi zorunlu alan'>:<cf_get_lang
													dictionary_id='48259.Yakıt Miktarı'> !
										</cfsavecontent>
										<cfinput type="text" name="fuel_amount"
											value="#TLFormat(get_asetp_fuel_km.fuel_amount)#" class="moneybox"
											style="width:140px;" required="yes" message="#message25#"
											onKeyup="return(FormatCurrency(this,event));">
									</div>
								</div>
								<div class="form-group" id="fuel_quantity">
									<label class="col col-4 col-xs-12">
										<cf_get_lang dictionary_id='30113.Yakıt Tipi'>*
									</label>
									<div class="col col-8 col-xs-12">
										<select name="fuel_type_id" id="fuel_type_id" style="width:140px">
											<option value="">
												<cf_get_lang dictionary_id='57734.Seçiniz'>
											</option>
											<cfoutput query="get_fuel_type">
												<option value="#fuel_id#" <cfif get_asetp_fuel_km.fuel_type_id eq
													fuel_id>selected</cfif>>#fuel_name#</option>
											</cfoutput>
										</select>

									</div>
								</div>

								<div class="form-group" id="total_pay">
									<label class="col col-4 col-xs-12">
										<cf_get_lang dictionary_id='48114.KDV li Toplam Tutar'>
									</label>
									<div class="col col-5" style="padding-right:0.5rem;">
										<cfinput type="text" name="total_amount"
											value="#TLFormat(get_asetp_fuel_km.total_amount)#" class="moneybox"
											style="width:95px;" onKeyup="return(FormatCurrency(this,event));">
									</div>
									<div class="col col-3">
										<select name="total_currency" id="total_currency" style="width:43px;">
											<cfoutput query="get_money">
												<option value="#money#" <cfif money eq session.ep.money>selected</cfif>
													>#money#</option>
											</cfoutput>
										</select>
									</div>
								</div>
							</div>



				</cf_box_elements>
				<cf_box_footer>
					<cf_record_info query_name="get_asetp_fuel_km">
						<cfif (get_asetp_fuel_km.km_control_id_last eq get_asetp_fuel_km.km_control_id) and
							(get_asetp_fuel_km.is_allocate eq 0)>
							<cf_workcube_buttons type_format="1" is_upd='1' is_cancel='0' is_reset='0'
								add_function='kontrol()'
								delete_page_url='#request.self#?fuseaction=assetcare.emptypopup_del_fuel_km&km_control_id=#get_asetp_fuel_km.km_control_id#&fuel_id=#get_asetp_fuel_km.fuel_id#&plaka=#get_asetp_fuel_km.assetp#'>
								<cfelse>
									<cf_workcube_buttons type_format="1" is_upd='1' is_delete='0' is_cancel='1'
										is_reset='0' add_function='kontrol()'>
						</cfif>
				</cf_box_footer>
			</cfform>
		</cf_box>
		<script type="text/javascript">
			function unformat_fields() {
				document.upd_fuel_km.pre_km.value = filterNum(document.upd_fuel_km.pre_km.value);
				document.upd_fuel_km.last_km.value = filterNum(document.upd_fuel_km.last_km.value);
				document.upd_fuel_km.fuel_amount.value = filterNum(document.upd_fuel_km.fuel_amount.value);
				document.upd_fuel_km.total_amount.value = filterNum(document.upd_fuel_km.total_amount.value);
			}

			function kontrol() {
				if (document.upd_fuel_km.assetp_name.value == "") {
					alert(
						"<cf_get_lang dictionary_id='63587.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='41443.Plaka'>!");
					return false;
				}

				if ((document.upd_fuel_km.employee_id.value.length == "") || (document.upd_fuel_km.employee_id.value == 0)) {

					alert("<cf_get_lang dictionary_id='48493.Lütfen Aracın Sorumlu Bilgisini Kontrol Ediniz'>!");
					return false;
				}

				if (document.upd_fuel_km.department.value == "") {
					alert(
						"<cf_get_lang dictionary_id='63587.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='29532.Şube Adı'>!");
					return false;
				}

				if (document.upd_fuel_km.finish_date.value == "") {
					alert(
						"<cf_get_lang dictionary_id='63587.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='48230.Son KM Tarihi'>!");
					return false;
				}

				if (!date_check(document.add_fuel_km.start_date, document.add_fuel_km.finish_date,
						"<cf_get_lang dictionary_id='57806.Tarih Aralığını Kontrol Ediniz'>!")) {
					return false;
				}
				a = parseFloat(filterNum(document.add_fuel_km.pre_km.value));
				b = parseFloat(filterNum(document.add_fuel_km.last_km.value));
				if (a >= b) {
					alert("<cf_get_lang dictionary_id='48495.Km Aralığını Kontrol Ediniz'>!");
					return false;
				}
				if (!CheckEurodate(document.add_fuel_km.finish_date.value, "<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>")) {
					return false;
				}
				if (document.upd_fuel_km.fuel_type_id.value == "") {
					alert(
						"<cf_get_lang dictionary_id='63587.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='30113.Yakıt Tipi'> !");
					return false;
				}
				if (document.upd_fuel_km.document_type_id.value == "") {
					alert(
						"<cf_get_lang dictionary_id='63587.girilmesi zorunlu alan'>:<cf_get_lang dictionary_id='58533.Belge Tipi'> !");
					return false;
				}
				return true;
			}
		</script>