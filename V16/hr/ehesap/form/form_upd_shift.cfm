<cfinclude template="../query/get_shift.cfm">
<cfif isdefined('attributes.is_production') or get_shift.is_production eq 1>
	<cfquery name="GET_BRANCH" datasource="#DSN#">
		SELECT BRANCH_ID,BRANCH_NAME FROM BRANCH WHERE COMPANY_ID = #session.ep.company_id# ORDER BY BRANCH_NAME
	</cfquery>
</cfif> 
<cfset xfa.del = "ehesap.emptypopup_del_shift">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="47082.Çalışma Programları"><cf_get_lang dictionary_id="58527.ID">:<cfoutput>#attributes.shift_id#</cfoutput></cfsavecontent>
<cfset pageHead = #message# >
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="add_shift" action="#request.self#?fuseaction=ehesap.emptypopup_upd_shift" method="post">
			<input type="hidden" name="SHIFT_ID" id="SHIFT_ID" value="<cfoutput>#attributes.shift_id#</cfoutput>" />
			<input type="hidden" name="is_production" id="is_production" value="<cfoutput>#get_shift.is_production#</cfoutput>" />
			<input type="hidden" name="this_fuseaction" id="this_fuseaction" value="<cfoutput>#attributes.fuseaction#</cfoutput>" />
			
			<cf_box_elements>
				<div class="col col-9 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-shift_name">
						<label class="col col-3"><cf_get_lang dictionary_id="36795.Çalışma Programı"></label>
						<div class="col col-9">
							<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="36795.Çalışma Programı"></cfsavecontent>
							<cfinput type="text" name="shift_name" maxlength="200" required="yes" message="#message#" value="#get_shift.shift_name#">
						</div>
					</div>
					<div class="form-group" id="item-aa">
						<div class="col col-3">
							<label class="hide"></label>
						</div>
						<div class="col col-3">
							<label class="bold"><cf_get_lang dictionary_id='58467.Başlama'></label>
						</div>
						<div class="col col-3">
							<label class="bold"><cf_get_lang dictionary_id='57502.Bitiş'></label>
						</div>
						<div class="col col-3">
							<label class="bold"><cf_get_lang dictionary_id="54182.Mesai Durumu"></label>
						</div>
					</div>
					<div class="form-group" id="item-startdate">
						<label class="col col-3"><cf_get_lang dictionary_id='58624.Geçerlilik Tarihi'> *</label>
						<div class="col col-3">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='53064.geçerlilik başlama tarihi'></cfsavecontent>
								<cfinput value="#dateformat(get_shift.startdate,dateformat_style)#" type="text" name="startdate" validate="#validate_style#" message="#message#" required="yes">
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
							</div>
						</div>
						<div class="col col-3">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='53065.geçerlilik bitiş tarihi'></cfsavecontent>
								<cfinput value="#dateformat(get_shift.finishdate,dateformat_style)#" type="text" name="finishdate" validate="#validate_style#" message="#message#" required="yes">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
							</div>
						</div>
						<div class="col col-3">
							<select name="STD_TYPE" id="STD_TYPE">
								<option value="0" <cfif get_shift.STD_TYPE eq 0>selected</cfif>><cf_get_lang dictionary_id="54048.Çalışma Saati"></option>
								<option value="1" <cfif get_shift.STD_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id="58869.Planlanan"></option>
								<option value="2" <cfif get_shift.STD_TYPE eq 2>selected</cfif>><cf_get_lang dictionary_id="53718.Fazla Mesai Tutarı"></option>
								<option value="3" <cfif get_shift.STD_TYPE eq 3>selected</cfif>><cf_get_lang dictionary_id="58866.Gözardı Et"></option>
							</select>        
						</div>
					</div>
					<div class="form-group" id="item-start_hour">
						<label class="col col-3"><cf_get_lang dictionary_id="54183.Vardiya Aralığı"></label>
						<div class="col col-3">
							<div class="input-group">
								<cf_wrkTimeFormat name="start_hour" value="#get_shift.start_hour#">																																																																																			
								<span class="input-group-addon no-bg"></span>
								<select name="start_min" id="start_min">
									<option value="00"<cfif get_shift.start_min eq 0> selected</cfif>>00</option>
									<option value="05"<cfif get_shift.start_min eq 5> selected</cfif>>05</option>
									<option value="10"<cfif get_shift.start_min eq 10> selected</cfif>>10</option>
									<option value="15"<cfif get_shift.start_min eq 15> selected</cfif>>15</option>
									<option value="20"<cfif get_shift.start_min eq 20> selected</cfif>>20</option>
									<option value="25"<cfif get_shift.start_min eq 25> selected</cfif>>25</option>
									<option value="30"<cfif get_shift.start_min eq 30> selected</cfif>>30</option>
									<option value="35"<cfif get_shift.start_min eq 35> selected</cfif>>35</option>
									<option value="40"<cfif get_shift.start_min eq 40> selected</cfif>>40</option>
									<option value="45"<cfif get_shift.start_min eq 45> selected</cfif>>45</option>
									<option value="50"<cfif get_shift.start_min eq 50> selected</cfif>>50</option>
									<option value="55"<cfif get_shift.start_min eq 55> selected</cfif>>55</option>
								</select>
							</div>
						</div>
						<div class="col col-3">
							<div class="input-group">
								<cf_wrkTimeFormat name="end_hour" value="#get_shift.end_hour#">						
								<span class="input-group-addon no-bg"></span>
								<select name="end_min" id="end_min">
									<option value="00"<cfif get_shift.end_min eq 0> selected</cfif>>00</option>
									<option value="05"<cfif get_shift.end_min eq 5> selected</cfif>>05</option>
									<option value="10"<cfif get_shift.end_min eq 10> selected</cfif>>10</option>
									<option value="15"<cfif get_shift.end_min eq 15> selected</cfif>>15</option>
									<option value="20"<cfif get_shift.end_min eq 20> selected</cfif>>20</option>
									<option value="25"<cfif get_shift.end_min eq 25> selected</cfif>>25</option>
									<option value="30"<cfif get_shift.end_min eq 30> selected</cfif>>30</option>
									<option value="35"<cfif get_shift.end_min eq 35> selected</cfif>>35</option>
									<option value="40"<cfif get_shift.end_min eq 40> selected</cfif>>40</option>
									<option value="45"<cfif get_shift.end_min eq 45> selected</cfif>>45</option>
									<option value="50"<cfif get_shift.end_min eq 50> selected</cfif>>50</option>
									<option value="55"<cfif get_shift.end_min eq 55> selected</cfif>>55</option>
								</select>
							</div>
						</div>
						<div class="col col-3">
							<select name="LAST_ADD_TIME_TYPE" id="LAST_ADD_TIME_TYPE">
								<option value="1" <cfif get_shift.LAST_ADD_TIME_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id="58869.Planlanan"> <cf_get_lang dictionary_id="54126.Mesai"></option>
								<option value="2" <cfif get_shift.LAST_ADD_TIME_TYPE eq 2>selected</cfif>><cf_get_lang dictionary_id="53718.Fazla Mesai Tutarı"></option>
								<option value="3" <cfif get_shift.LAST_ADD_TIME_TYPE eq 3>selected</cfif>><cf_get_lang dictionary_id='58866.Gözardı Et'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-stday_start_hour">
						<label class="col col-3"><cf_get_lang dictionary_id="54184.Cumartesi Vardiyası"></label>
						<div class="col col-3">
							<div class="input-group">
								<cf_wrkTimeFormat name="stday_start_hour" value="#get_shift.std_start_hour#">														
								<span class="input-group-addon no-bg"></span>
								<select name="stday_start_min" id="stday_start_min">
									<option value="00"<cfif get_shift.std_start_min eq 0> selected</cfif>>00</option>
									<option value="05"<cfif get_shift.std_start_min eq 5> selected</cfif>>05</option>
									<option value="10"<cfif get_shift.std_start_min eq 10> selected</cfif>>10</option>
									<option value="15"<cfif get_shift.std_start_min eq 15> selected</cfif>>15</option>
									<option value="20"<cfif get_shift.std_start_min eq 20> selected</cfif>>20</option>
									<option value="25"<cfif get_shift.std_start_min eq 25> selected</cfif>>25</option>
									<option value="30"<cfif get_shift.std_start_min eq 30> selected</cfif>>30</option>
									<option value="35"<cfif get_shift.std_start_min eq 35> selected</cfif>>35</option>
									<option value="40"<cfif get_shift.std_start_min eq 40> selected</cfif>>40</option>
									<option value="45"<cfif get_shift.std_start_min eq 45> selected</cfif>>45</option>
									<option value="50"<cfif get_shift.std_start_min eq 50> selected</cfif>>50</option>
									<option value="55"<cfif get_shift.std_start_min eq 55> selected</cfif>>55</option>
								</select>
							</div>
						</div>
						<div class="col col-3">
							<div class="input-group">
								<cf_wrkTimeFormat name="stday_end_hour" value="#get_shift.std_end_hour#">																						
								<span class="input-group-addon no-bg"></span>
								<select name="stday_end_min" id="stday_end_min">
									<option value="00"<cfif get_shift.std_end_min eq 0> selected</cfif>>00</option>
									<option value="05"<cfif get_shift.std_end_min eq 5> selected</cfif>>05</option>
									<option value="10"<cfif get_shift.std_end_min eq 10> selected</cfif>>10</option>
									<option value="15"<cfif get_shift.std_end_min eq 15> selected</cfif>>15</option>
									<option value="20"<cfif get_shift.std_end_min eq 20> selected</cfif>>20</option>
									<option value="25"<cfif get_shift.std_end_min eq 25> selected</cfif>>25</option>
									<option value="30"<cfif get_shift.std_end_min eq 30> selected</cfif>>30</option>
									<option value="35"<cfif get_shift.std_end_min eq 35> selected</cfif>>35</option>
									<option value="40"<cfif get_shift.std_end_min eq 40> selected</cfif>>40</option>
									<option value="45"<cfif get_shift.std_end_min eq 45> selected</cfif>>45</option>
									<option value="50"<cfif get_shift.std_end_min eq 50> selected</cfif>>50</option>
									<option value="55"<cfif get_shift.std_end_min eq 55> selected</cfif>>55</option>
								</select>
							</div>
						</div>
						<div class="col col-3">
							<select name="FIRST_ADD_TIME_TYPE" id="FIRST_ADD_TIME_TYPE">
								<option value="1" <cfif get_shift.FIRST_ADD_TIME_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id="58869.Planlanan"> <cf_get_lang dictionary_id="54126.Mesai"></option>
								<option value="2" <cfif get_shift.FIRST_ADD_TIME_TYPE eq 2>selected</cfif>><cf_get_lang dictionary_id="53718.Fazla Mesai Tutarı"></option>
								<option value="3" <cfif get_shift.FIRST_ADD_TIME_TYPE eq 3>selected</cfif>><cf_get_lang dictionary_id='58866.Gözardı Et'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-first_add_time_start_hour">
						<label class="col col-3"><cf_get_lang dictionary_id="54187.Vardiya Öncesi Fazla Mesai"></label>
						<div class="col col-3">
							<div class="input-group">
								<cf_wrkTimeFormat name="first_add_time_start_hour" value="#get_shift.first_add_time_start_hour#">																														
								<span class="input-group-addon no-bg"></span>
								<select name="first_add_time_start_min" id="first_add_time_start_min">
									<option value="00"<cfif get_shift.first_add_time_start_min eq 0> selected</cfif>>00</option>
									<option value="05"<cfif get_shift.first_add_time_start_min eq 5> selected</cfif>>05</option>
									<option value="10"<cfif get_shift.first_add_time_start_min eq 10> selected</cfif>>10</option>
									<option value="15"<cfif get_shift.first_add_time_start_min eq 15> selected</cfif>>15</option>
									<option value="20"<cfif get_shift.first_add_time_start_min eq 20> selected</cfif>>20</option>
									<option value="25"<cfif get_shift.first_add_time_start_min eq 25> selected</cfif>>25</option>
									<option value="30"<cfif get_shift.first_add_time_start_min eq 30> selected</cfif>>30</option>
									<option value="35"<cfif get_shift.first_add_time_start_min eq 35> selected</cfif>>35</option>
									<option value="40"<cfif get_shift.first_add_time_start_min eq 40> selected</cfif>>40</option>
									<option value="45"<cfif get_shift.first_add_time_start_min eq 45> selected</cfif>>45</option>
									<option value="50"<cfif get_shift.first_add_time_start_min eq 50> selected</cfif>>50</option>
									<option value="55"<cfif get_shift.first_add_time_start_min eq 55> selected</cfif>>55</option>
								</select>
							</div>
						</div>
						<div class="col col-3">
							<div class="input-group">
								<cf_wrkTimeFormat name="first_add_time_end_hour" value="#get_shift.first_add_time_end_hour#">																																						
								<span class="input-group-addon no-bg"></span>
								<select name="first_add_time_end_min" id="first_add_time_end_min">
									<option value="00"<cfif get_shift.first_add_time_end_min eq 0> selected</cfif>>00</option>
									<option value="05"<cfif get_shift.first_add_time_end_min eq 5> selected</cfif>>05</option>
									<option value="10"<cfif get_shift.first_add_time_end_min eq 10> selected</cfif>>10</option>
									<option value="15"<cfif get_shift.first_add_time_end_min eq 15> selected</cfif>>15</option>
									<option value="20"<cfif get_shift.first_add_time_end_min eq 20> selected</cfif>>20</option>
									<option value="25"<cfif get_shift.first_add_time_end_min eq 25> selected</cfif>>25</option>
									<option value="30"<cfif get_shift.first_add_time_end_min eq 30> selected</cfif>>30</option>
									<option value="35"<cfif get_shift.first_add_time_end_min eq 35> selected</cfif>>35</option>
									<option value="40"<cfif get_shift.first_add_time_end_min eq 40> selected</cfif>>40</option>
									<option value="45"<cfif get_shift.first_add_time_end_min eq 45> selected</cfif>>45</option>
									<option value="50"<cfif get_shift.first_add_time_end_min eq 50> selected</cfif>>50</option>
									<option value="55"<cfif get_shift.first_add_time_end_min eq 55> selected</cfif>>55</option>
								</select>
							</div>
						</div>
						<div class="col col-3"></div>
					</div>
					<div class="form-group" id="item-last_add_time_start_hour">
						<label class="col col-3"><cf_get_lang dictionary_id="54188.Vardiya Sonrası Fazla Mesai"></label>
						<div class="col col-3">
							<div class="input-group">
								<cf_wrkTimeFormat name="last_add_time_start_hour" value="#get_shift.last_add_time_start_hour#">																																														
								<span class="input-group-addon no-bg"></span>
								<select name="last_add_time_start_min" id="last_add_time_start_min">
									<option value="00"<cfif get_shift.last_add_time_start_min eq 0> selected</cfif>>00</option>
									<option value="05"<cfif get_shift.last_add_time_start_min eq 5> selected</cfif>>05</option>
									<option value="10"<cfif get_shift.last_add_time_start_min eq 10> selected</cfif>>10</option>
									<option value="15"<cfif get_shift.last_add_time_start_min eq 15> selected</cfif>>15</option>
									<option value="20"<cfif get_shift.last_add_time_start_min eq 20> selected</cfif>>20</option>
									<option value="25"<cfif get_shift.last_add_time_start_min eq 25> selected</cfif>>25</option>
									<option value="30"<cfif get_shift.last_add_time_start_min eq 30> selected</cfif>>30</option>
									<option value="35"<cfif get_shift.last_add_time_start_min eq 35> selected</cfif>>35</option>
									<option value="40"<cfif get_shift.last_add_time_start_min eq 40> selected</cfif>>40</option>
									<option value="45"<cfif get_shift.last_add_time_start_min eq 45> selected</cfif>>45</option>
									<option value="50"<cfif get_shift.last_add_time_start_min eq 50> selected</cfif>>50</option>
									<option value="55"<cfif get_shift.last_add_time_start_min eq 55> selected</cfif>>55</option>
								</select>
							</div>
						</div>
						<div class="col col-3">
							<div class="input-group">
								<cf_wrkTimeFormat name="last_add_time_end_hour" value="#get_shift.last_add_time_end_hour#">																																																						
								<span class="input-group-addon no-bg"></span>
								<select name="last_add_time_end_min" id="last_add_time_end_min">
									<option value="00"<cfif get_shift.last_add_time_end_min eq 0> selected</cfif>>00</option>
									<option value="05"<cfif get_shift.last_add_time_end_min eq 5> selected</cfif>>05</option>
									<option value="10"<cfif get_shift.last_add_time_end_min eq 10> selected</cfif>>10</option>
									<option value="15"<cfif get_shift.last_add_time_end_min eq 15> selected</cfif>>15</option>
									<option value="20"<cfif get_shift.last_add_time_end_min eq 20> selected</cfif>>20</option>
									<option value="25"<cfif get_shift.last_add_time_end_min eq 25> selected</cfif>>25</option>
									<option value="30"<cfif get_shift.last_add_time_end_min eq 30> selected</cfif>>30</option>
									<option value="35"<cfif get_shift.last_add_time_end_min eq 35> selected</cfif>>35</option>
									<option value="40"<cfif get_shift.last_add_time_end_min eq 40> selected</cfif>>40</option>
									<option value="45"<cfif get_shift.last_add_time_end_min eq 45> selected</cfif>>45</option>
									<option value="50"<cfif get_shift.last_add_time_end_min eq 50> selected</cfif>>50</option>
									<option value="55"<cfif get_shift.last_add_time_end_min eq 55> selected</cfif>>55</option>
								</select>
							</div>
						</div>
						<div class="col col-3"></div>
					</div>
					<div class="form-group" id="item-WEEK_OFFDAY">
						<label class="col col-3"><cf_get_lang dictionary_id='58867.Hafta Tatili'></label>
						<div class="col col-9">
							<select name="WEEK_OFFDAY" id="WEEK_OFFDAY">
								<option value="1" <cfif get_shift.WEEK_OFFDAY eq 1>selected</cfif>><cf_get_lang dictionary_id='57610.Pazar'></option>
								<option value="2" <cfif get_shift.WEEK_OFFDAY eq 2>selected</cfif>><cf_get_lang dictionary_id='57604.Pazartesi'></option>
								<option value="3" <cfif get_shift.WEEK_OFFDAY eq 3>selected</cfif>><cf_get_lang dictionary_id='57605.Salı'></option>
								<option value="4" <cfif get_shift.WEEK_OFFDAY eq 4>selected</cfif>><cf_get_lang dictionary_id='57606.Çarşamba'></option>
								<option value="5" <cfif get_shift.WEEK_OFFDAY eq 5>selected</cfif>><cf_get_lang dictionary_id='57607.Perşembe'></option>
								<option value="6" <cfif get_shift.WEEK_OFFDAY eq 6>selected</cfif>><cf_get_lang dictionary_id='57608.Cuma'></option>
								<option value="7" <cfif get_shift.WEEK_OFFDAY eq 7>selected</cfif>><cf_get_lang dictionary_id='57609.Cumartesi'></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-control_hour_1">
						<label class="col col-3"><cf_get_lang dictionary_id='58457.Günlük'></label>
						<div class="col col-3">
							<input type="text" name="control_hour_1" id="control_hour_1" value="<cfoutput>#tlformat(get_shift.control_hour_1)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" />
						</div>
						<div class="col col-6">
							<label><cf_get_lang dictionary_id="54189.çalışma saati ve üstünü tam say"></label>
						</div>
					</div>
					<div class="form-group" id="item-control_hour_2">
						<label class="col col-3"><cf_get_lang dictionary_id='58457.Günlük'></label>
						<div class="col col-3">
							<input type="text" name="control_hour_2" id="control_hour_2" value="<cfoutput>#tlformat(get_shift.control_hour_2)#</cfoutput>" onkeyup="return(FormatCurrency(this,event));" />
						</div>
						<div class="col col-6">
							<label><cf_get_lang dictionary_id="54190.çalışma saati ve eksiğini gün olarak hesaplama, mesai hesapla"></label>
						</div>
					</div>
					<cfif isdefined('attributes.is_production') or get_shift.is_production eq 1>
						<div class="form-group" id="item-branch_id">
							<label class="col col-3"><cf_get_lang dictionary_id='57453.Şube'> *</label>
							<div class="col col-9">
								<select name="branch_id" id="branch_id" onChange="get_departments(this.value);">
									<option value="0"><cf_get_lang dictionary_id='57734.Seçiniz'></option>
									<cfoutput query="get_branch">
										<option value="#branch_id#" <cfif get_shift.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
									</cfoutput>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-department_id">
							<label class="col col-3"><cf_get_lang dictionary_id='57572.Departman'></label>
							<div class="col col-9">
								<cfif len(get_shift.branch_id)>
									<cfquery name="GET_DEP" datasource="#dsn#">
										SELECT DEPARTMENT_HEAD,DEPARTMENT_ID FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND IS_STORE <> 1 AND BRANCH_ID = #get_shift.branch_id#
									</cfquery>
								</cfif>
								<select name="department_id" id="department_id">
									<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
										<cfif len(get_shift.branch_id)>
											<cfoutput query="GET_DEP">
												<option value="#DEPARTMENT_ID#" <cfif get_shift.DEPARTMENT_ID eq DEPARTMENT_ID>selected</cfif>>#DEPARTMENT_HEAD#</option>
											</cfoutput>
										</cfif>
								</select>
							</div>
						</div>
					</cfif>
					<div class="form-group" id="item-IS_NEXT_DAY_CONTROL">
						<div class="col col-3">
							<label class="hide"><cf_get_lang dictionary_id="54191.24'ten sonraki çıkış bir önceki güne dahil edilsin"></label>
						</div>
						<div class="col col-9">
							<label><input type="checkbox" value="1" name="IS_NEXT_DAY_CONTROL" id="IS_NEXT_DAY_CONTROL" <cfif get_shift.IS_NEXT_DAY_CONTROL eq 1>checked</cfif> /><cfoutput>#getLang('ehesap',1245)#</cfoutput></label>
						</div>
					</div>
					<div class="form-group" id="item-IS_ARA_MESAI_DUS">
						<label class="col col-3 bold"><cf_get_lang dictionary_id="54023.Mesai Aralıkları"></label>
						<div class="col col-9">
							<label><input type="checkbox" value="1" name="IS_ARA_MESAI_DUS" id="IS_ARA_MESAI_DUS" <cfif get_shift.IS_ARA_MESAI_DUS eq 1> checked</cfif> /><label for="IS_ARA_MESAI_DUS"><cfoutput>#getLang('ehesap',1085)#</cfoutput></label></label>
						</div>
					</div>
				</div>
				<div class="col col-9 " type="column" index="2" sort="false">
					<div class="form-group">
						<div class="col col-2 bold">
							<cf_get_lang dictionary_id="54022.Süre Tanımı">
						</div>
						<div class="col col-2 bold" >
							<cf_get_lang dictionary_id='58467.Başlama'>
						</div>
						<div class="col col-2 bold">
							<cf_get_lang dictionary_id='57502.Bitiş'>
						</div>
						<div class="col col-1 bold">
							<cf_get_lang dictionary_id='57609.Cumartesi'>
						</div>
						<div class="col col-1 bold">
							<cf_get_lang dictionary_id="54192.Vardiya Gecesi">
						</div>
						<div class="col col-1 bold">
							<cf_get_lang dictionary_id="54193.Vardiya Sonrası">
						</div>
					</div>
					<div  class="form-group" id="item-free_time_name_1">
						<div class="col col-2 bold">
							<input type="text" name="FREE_TIME_NAME_1" id="FREE_TIME_NAME_1" maxlength="100" value="<cfoutput>#get_shift.FREE_TIME_NAME_1#</cfoutput>" />
						</div>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='54024.Boş Geçen Süre Tanımları Sayısal Olmalıdır'></cfsavecontent>
						<div class="col col-1 bold">
							<cf_wrkTimeFormat name="FREE_TIME_START_HOUR_1" value="#get_shift.FREE_TIME_START_HOUR_1#">																																																													
						</div>
						<div class="col col-1 bold">
							<select name="FREE_TIME_START_MIN_1" id="FREE_TIME_START_MIN_1">
								<option value="00"<cfif get_shift.FREE_TIME_START_MIN_1 eq 0> selected</cfif>>00</option>
								<option value="05"<cfif get_shift.FREE_TIME_START_MIN_1 eq 5> selected</cfif>>05</option>
								<option value="10"<cfif get_shift.FREE_TIME_START_MIN_1 eq 10> selected</cfif>>10</option>
								<option value="15"<cfif get_shift.FREE_TIME_START_MIN_1 eq 15> selected</cfif>>15</option>
								<option value="20"<cfif get_shift.FREE_TIME_START_MIN_1 eq 20> selected</cfif>>20</option>
								<option value="25"<cfif get_shift.FREE_TIME_START_MIN_1 eq 25> selected</cfif>>25</option>
								<option value="30"<cfif get_shift.FREE_TIME_START_MIN_1 eq 30> selected</cfif>>30</option>
								<option value="35"<cfif get_shift.FREE_TIME_START_MIN_1 eq 35> selected</cfif>>35</option>
								<option value="40"<cfif get_shift.FREE_TIME_START_MIN_1 eq 40> selected</cfif>>40</option>
								<option value="45"<cfif get_shift.FREE_TIME_START_MIN_1 eq 45> selected</cfif>>45</option>
								<option value="50"<cfif get_shift.FREE_TIME_START_MIN_1 eq 50> selected</cfif>>50</option>
								<option value="55"<cfif get_shift.FREE_TIME_START_MIN_1 eq 55> selected</cfif>>55</option>
							</select>
						</div>
						<div class="col col-1 bold">
							<cf_wrkTimeFormat name="FREE_TIME_END_HOUR_1" value="#get_shift.FREE_TIME_END_HOUR_1#">																																																																				
						</div>
						<div class="col col-1 bold">
								<select name="FREE_TIME_END_MIN_1" id="FREE_TIME_END_MIN_1">
									<option value="00"<cfif get_shift.FREE_TIME_END_MIN_1 eq 0> selected</cfif>>00</option>
									<option value="05"<cfif get_shift.FREE_TIME_END_MIN_1 eq 5> selected</cfif>>05</option>
									<option value="10"<cfif get_shift.FREE_TIME_END_MIN_1 eq 10> selected</cfif>>10</option>
									<option value="15"<cfif get_shift.FREE_TIME_END_MIN_1 eq 15> selected</cfif>>15</option>
									<option value="20"<cfif get_shift.FREE_TIME_END_MIN_1 eq 20> selected</cfif>>20</option>
									<option value="25"<cfif get_shift.FREE_TIME_END_MIN_1 eq 25> selected</cfif>>25</option>
									<option value="30"<cfif get_shift.FREE_TIME_END_MIN_1 eq 30> selected</cfif>>30</option>
									<option value="35"<cfif get_shift.FREE_TIME_END_MIN_1 eq 35> selected</cfif>>35</option>
									<option value="40"<cfif get_shift.FREE_TIME_END_MIN_1 eq 40> selected</cfif>>40</option>
									<option value="45"<cfif get_shift.FREE_TIME_END_MIN_1 eq 45> selected</cfif>>45</option>
									<option value="50"<cfif get_shift.FREE_TIME_END_MIN_1 eq 50> selected</cfif>>50</option>
									<option value="55"<cfif get_shift.FREE_TIME_END_MIN_1 eq 55> selected</cfif>>55</option>
								</select>
						</div>
						
						<div class="col col-1" class="text-center"><input type="checkbox" value="1" name="IS_WEEKEND_1" id="IS_WEEKEND_1" <cfif get_shift.IS_WEEKEND_1 eq 1>checked</cfif> /></div>
						<div class="col col-1" class="text-center"><input type="checkbox" value="1" name="IS_FISRT_ADD_TIME_1" id="IS_FISRT_ADD_TIME_1" <cfif get_shift.IS_FISRT_ADD_TIME_1 eq 1>checked</cfif> /></div>
						<div class="col col-1" class="text-center"><input type="checkbox" value="1" name="IS_LAST_ADD_TIME_1" id="IS_LAST_ADD_TIME_1" <cfif get_shift.IS_LAST_ADD_TIME_1 eq 1>checked</cfif> /></div>
					</div>
					<div  class="form-group" id="item-free_time_name_2">
						<div class="col col-2 ">
							<input type="text" name="FREE_TIME_NAME_2" id="FREE_TIME_NAME_2" maxlength="100" value="<cfoutput>#get_shift.FREE_TIME_NAME_2#</cfoutput>" />
						</div>	
						<div class="col col-1 ">
							<cf_wrkTimeFormat name="FREE_TIME_START_HOUR_2" value="#get_shift.FREE_TIME_START_HOUR_2#">																																																																												
						</div>
						<div class="col col-1 ">
							<select name="FREE_TIME_START_MIN_2" id="FREE_TIME_START_MIN_2">
								<option value="00"<cfif get_shift.FREE_TIME_START_MIN_2 eq 0> selected</cfif>>00</option>
								<option value="05"<cfif get_shift.FREE_TIME_START_MIN_2 eq 5> selected</cfif>>05</option>
								<option value="10"<cfif get_shift.FREE_TIME_START_MIN_2 eq 10> selected</cfif>>10</option>
								<option value="15"<cfif get_shift.FREE_TIME_START_MIN_2 eq 15> selected</cfif>>15</option>
								<option value="20"<cfif get_shift.FREE_TIME_START_MIN_2 eq 20> selected</cfif>>20</option>
								<option value="25"<cfif get_shift.FREE_TIME_START_MIN_2 eq 25> selected</cfif>>25</option>
								<option value="30"<cfif get_shift.FREE_TIME_START_MIN_2 eq 30> selected</cfif>>30</option>
								<option value="35"<cfif get_shift.FREE_TIME_START_MIN_2 eq 35> selected</cfif>>35</option>
								<option value="40"<cfif get_shift.FREE_TIME_START_MIN_2 eq 40> selected</cfif>>40</option>
								<option value="45"<cfif get_shift.FREE_TIME_START_MIN_2 eq 45> selected</cfif>>45</option>
								<option value="50"<cfif get_shift.FREE_TIME_START_MIN_2 eq 50> selected</cfif>>50</option>
								<option value="55"<cfif get_shift.FREE_TIME_START_MIN_2 eq 55> selected</cfif>>55</option>
							</select>
						</div>
						<div class="col col-1">
							<cf_wrkTimeFormat name="FREE_TIME_END_HOUR_2" value="#get_shift.FREE_TIME_END_HOUR_2#">																																																																												
						</div>
						<div class="col col-1">
							<select name="FREE_TIME_END_MIN_2" id="FREE_TIME_END_MIN_2">
								<option value="00"<cfif get_shift.FREE_TIME_END_MIN_2 eq 0> selected</cfif>>00</option>
								<option value="05"<cfif get_shift.FREE_TIME_END_MIN_2 eq 5> selected</cfif>>05</option>
								<option value="10"<cfif get_shift.FREE_TIME_END_MIN_2 eq 10> selected</cfif>>10</option>
								<option value="15"<cfif get_shift.FREE_TIME_END_MIN_2 eq 15> selected</cfif>>15</option>
								<option value="20"<cfif get_shift.FREE_TIME_END_MIN_2 eq 20> selected</cfif>>20</option>
								<option value="25"<cfif get_shift.FREE_TIME_END_MIN_2 eq 25> selected</cfif>>25</option>
								<option value="30"<cfif get_shift.FREE_TIME_END_MIN_2 eq 30> selected</cfif>>30</option>
								<option value="35"<cfif get_shift.FREE_TIME_END_MIN_2 eq 35> selected</cfif>>35</option>
								<option value="40"<cfif get_shift.FREE_TIME_END_MIN_2 eq 40> selected</cfif>>40</option>
								<option value="45"<cfif get_shift.FREE_TIME_END_MIN_2 eq 45> selected</cfif>>45</option>
								<option value="50"<cfif get_shift.FREE_TIME_END_MIN_2 eq 50> selected</cfif>>50</option>
								<option value="55"<cfif get_shift.FREE_TIME_END_MIN_2 eq 55> selected</cfif>>55</option>
							</select>
						</div>
						<div class="col col-1" class="text-center"><input type="checkbox" value="1" name="IS_WEEKEND_2" id="IS_WEEKEND_2" <cfif get_shift.IS_WEEKEND_2 eq 1>checked</cfif> /></div>
						<div class="col col-1" class="text-center"><input type="checkbox" value="1" name="IS_FISRT_ADD_TIME_2" id="IS_FISRT_ADD_TIME_2" <cfif get_shift.IS_FISRT_ADD_TIME_2 eq 1>checked</cfif> /></div>
						<div class="col col-1" class="text-center"><input type="checkbox" value="1" name="IS_LAST_ADD_TIME_2" id="IS_LAST_ADD_TIME_2" <cfif get_shift.IS_LAST_ADD_TIME_2 eq 1>checked</cfif> /></div>
					</div>
					<div  class="form-group" id="item-free_time_name_3">	
						<div class="col col-2">
							<input type="text" name="FREE_TIME_NAME_3" id="FREE_TIME_NAME_3" maxlength="100" value="<cfoutput>#get_shift.FREE_TIME_NAME_3#</cfoutput>" />
						</div>
						<div class="col col-1 ">
							<cf_wrkTimeFormat name="FREE_TIME_START_HOUR_3" value="#get_shift.FREE_TIME_START_HOUR_3#">																																																																																			
						</div>
						<div class="col col-1 ">
							<select name="FREE_TIME_START_MIN_3" id="FREE_TIME_START_MIN_3">
								<option value="00"<cfif get_shift.FREE_TIME_START_MIN_3 eq 0> selected</cfif>>00</option>
								<option value="05"<cfif get_shift.FREE_TIME_START_MIN_3 eq 5> selected</cfif>>05</option>
								<option value="10"<cfif get_shift.FREE_TIME_START_MIN_3 eq 10> selected</cfif>>10</option>
								<option value="15"<cfif get_shift.FREE_TIME_START_MIN_3 eq 15> selected</cfif>>15</option>
								<option value="20"<cfif get_shift.FREE_TIME_START_MIN_3 eq 20> selected</cfif>>20</option>
								<option value="25"<cfif get_shift.FREE_TIME_START_MIN_3 eq 25> selected</cfif>>25</option>
								<option value="30"<cfif get_shift.FREE_TIME_START_MIN_3 eq 30> selected</cfif>>30</option>
								<option value="35"<cfif get_shift.FREE_TIME_START_MIN_3 eq 35> selected</cfif>>35</option>
								<option value="40"<cfif get_shift.FREE_TIME_START_MIN_3 eq 40> selected</cfif>>40</option>
								<option value="45"<cfif get_shift.FREE_TIME_START_MIN_3 eq 45> selected</cfif>>45</option>
								<option value="50"<cfif get_shift.FREE_TIME_START_MIN_3 eq 50> selected</cfif>>50</option>
								<option value="55"<cfif get_shift.FREE_TIME_START_MIN_3 eq 55> selected</cfif>>55</option>
							</select>
						</div>
						<div class="col col-1 ">
							<cf_wrkTimeFormat name="FREE_TIME_END_HOUR_3" value="#get_shift.FREE_TIME_END_HOUR_3#">																																																																																			
						</div>
						<div class="col col-1 ">
							<select name="FREE_TIME_END_MIN_3" id="FREE_TIME_END_MIN_3">
								<option value="00"<cfif get_shift.FREE_TIME_END_MIN_3 eq 0> selected</cfif>>00</option>
								<option value="05"<cfif get_shift.FREE_TIME_END_MIN_3 eq 5> selected</cfif>>05</option>
								<option value="10"<cfif get_shift.FREE_TIME_END_MIN_3 eq 10> selected</cfif>>10</option>
								<option value="15"<cfif get_shift.FREE_TIME_END_MIN_3 eq 15> selected</cfif>>15</option>
								<option value="20"<cfif get_shift.FREE_TIME_END_MIN_3 eq 20> selected</cfif>>20</option>
								<option value="25"<cfif get_shift.FREE_TIME_END_MIN_3 eq 25> selected</cfif>>25</option>
								<option value="30"<cfif get_shift.FREE_TIME_END_MIN_3 eq 30> selected</cfif>>30</option>
								<option value="35"<cfif get_shift.FREE_TIME_END_MIN_3 eq 35> selected</cfif>>35</option>
								<option value="40"<cfif get_shift.FREE_TIME_END_MIN_3 eq 40> selected</cfif>>40</option>
								<option value="45"<cfif get_shift.FREE_TIME_END_MIN_3 eq 45> selected</cfif>>45</option>
								<option value="50"<cfif get_shift.FREE_TIME_END_MIN_3 eq 50> selected</cfif>>50</option>
								<option value="55"<cfif get_shift.FREE_TIME_END_MIN_3 eq 55> selected</cfif>>55</option>
							</select>
						</div>
						<div class="col col-1 " class="text-center"><input type="checkbox" value="1" name="IS_WEEKEND_3" id="IS_WEEKEND_3" <cfif get_shift.IS_WEEKEND_3 eq 1>checked</cfif> /></div>
						<div class="col col-1 " class="text-center"><input type="checkbox" value="1" name="IS_FISRT_ADD_TIME_3" id="IS_FISRT_ADD_TIME_3" <cfif get_shift.IS_FISRT_ADD_TIME_3 eq 1>checked</cfif> /></div>
						<div class="col col-1 " class="text-center"><input type="checkbox" value="1" name="IS_LAST_ADD_TIME_3" id="IS_LAST_ADD_TIME_3" <cfif get_shift.IS_LAST_ADD_TIME_3 eq 1>checked</cfif> /></div>
				
					</div>		
					<div  class="form-group" id="item-free_time_name_4">
						<div class="col col-2 ">
							<input type="text" name="FREE_TIME_NAME_4" id="FREE_TIME_NAME_4" maxlength="100" value="<cfoutput>#get_shift.FREE_TIME_NAME_4#</cfoutput>" />
						</div>
						<div class="col col-1 ">
							<cf_wrkTimeFormat name="FREE_TIME_START_HOUR_4" value="#get_shift.FREE_TIME_START_HOUR_4#">																																																																																			
						</div>
						<div class="col col-1 ">
								<select name="FREE_TIME_START_MIN_4" id="FREE_TIME_START_MIN_4">
								<option value="00"<cfif get_shift.FREE_TIME_START_MIN_4 eq 0> selected</cfif>>00</option>
								<option value="05"<cfif get_shift.FREE_TIME_START_MIN_4 eq 5> selected</cfif>>05</option>
								<option value="10"<cfif get_shift.FREE_TIME_START_MIN_4 eq 10> selected</cfif>>10</option>
								<option value="15"<cfif get_shift.FREE_TIME_START_MIN_4 eq 15> selected</cfif>>15</option>
								<option value="20"<cfif get_shift.FREE_TIME_START_MIN_4 eq 20> selected</cfif>>20</option>
								<option value="25"<cfif get_shift.FREE_TIME_START_MIN_4 eq 25> selected</cfif>>25</option>
								<option value="30"<cfif get_shift.FREE_TIME_START_MIN_4 eq 30> selected</cfif>>30</option>
								<option value="35"<cfif get_shift.FREE_TIME_START_MIN_4 eq 35> selected</cfif>>35</option>
								<option value="40"<cfif get_shift.FREE_TIME_START_MIN_4 eq 40> selected</cfif>>40</option>
								<option value="45"<cfif get_shift.FREE_TIME_START_MIN_4 eq 45> selected</cfif>>45</option>
								<option value="50"<cfif get_shift.FREE_TIME_START_MIN_4 eq 50> selected</cfif>>50</option>
								<option value="55"<cfif get_shift.FREE_TIME_START_MIN_4 eq 55> selected</cfif>>55</option>
								</select>
						</div>
						<div class="col col-1 ">
							<cf_wrkTimeFormat name="FREE_TIME_END_HOUR_4" value="#get_shift.FREE_TIME_END_HOUR_4#">																																																																																			
						</div>
						<div class="col col-1 ">
								<select name="FREE_TIME_END_MIN_4" id="FREE_TIME_END_MIN_4">
									<option value="00"<cfif get_shift.FREE_TIME_END_MIN_4 eq 0> selected</cfif>>00</option>
									<option value="05"<cfif get_shift.FREE_TIME_END_MIN_4 eq 5> selected</cfif>>05</option>
									<option value="10"<cfif get_shift.FREE_TIME_END_MIN_4 eq 10> selected</cfif>>10</option>
									<option value="15"<cfif get_shift.FREE_TIME_END_MIN_4 eq 15> selected</cfif>>15</option>
									<option value="20"<cfif get_shift.FREE_TIME_END_MIN_4 eq 20> selected</cfif>>20</option>
									<option value="25"<cfif get_shift.FREE_TIME_END_MIN_4 eq 25> selected</cfif>>25</option>
									<option value="30"<cfif get_shift.FREE_TIME_END_MIN_4 eq 30> selected</cfif>>30</option>
									<option value="35"<cfif get_shift.FREE_TIME_END_MIN_4 eq 35> selected</cfif>>35</option>
									<option value="40"<cfif get_shift.FREE_TIME_END_MIN_4 eq 40> selected</cfif>>40</option>
									<option value="45"<cfif get_shift.FREE_TIME_END_MIN_4 eq 45> selected</cfif>>45</option>
									<option value="50"<cfif get_shift.FREE_TIME_END_MIN_4 eq 50> selected</cfif>>50</option>
									<option value="55"<cfif get_shift.FREE_TIME_END_MIN_4 eq 55> selected</cfif>>55</option>
								</select>
						</div>
						<div class="col col-1 " class="text-center"><input type="checkbox" value="1" name="IS_WEEKEND_4" id="IS_WEEKEND_4" <cfif get_shift.IS_WEEKEND_4 eq 1>checked</cfif> /></div>
						<div class="col col-1 " class="text-center"><input type="checkbox" value="1" name="IS_FISRT_ADD_TIME_4" id="IS_FISRT_ADD_TIME_4" <cfif get_shift.IS_FISRT_ADD_TIME_4 eq 1>checked</cfif> /></div>
						<div class="col col-1 " class="text-center"><input type="checkbox" value="1" name="IS_LAST_ADD_TIME_4" id="IS_LAST_ADD_TIME_4" <cfif get_shift.IS_LAST_ADD_TIME_4 eq 1>checked</cfif> /></div>		
					</div>
					<div  class="form-group" id="item-free_time_name_5">
						<div class="col col-2 ">
							<input type="text" name="FREE_TIME_NAME_5" id="FREE_TIME_NAME_5" maxlength="100" value="<cfoutput>#get_shift.FREE_TIME_NAME_5#</cfoutput>" />
						</div>
						<div class="col col-1 ">
							<cf_wrkTimeFormat name="FREE_TIME_START_HOUR_5" value="#get_shift.FREE_TIME_START_HOUR_5#">																																																																																			
						</div>
						<div class="col col-1 ">
							<select name="FREE_TIME_START_MIN_5" id="FREE_TIME_START_MIN_5">
								<option value="00"<cfif get_shift.FREE_TIME_START_MIN_5 eq 0> selected</cfif>>00</option>
								<option value="05"<cfif get_shift.FREE_TIME_START_MIN_5 eq 5> selected</cfif>>05</option>
								<option value="10"<cfif get_shift.FREE_TIME_START_MIN_5 eq 10> selected</cfif>>10</option>
								<option value="15"<cfif get_shift.FREE_TIME_START_MIN_5 eq 15> selected</cfif>>15</option>
								<option value="20"<cfif get_shift.FREE_TIME_START_MIN_5 eq 20> selected</cfif>>20</option>
								<option value="25"<cfif get_shift.FREE_TIME_START_MIN_5 eq 25> selected</cfif>>25</option>
								<option value="30"<cfif get_shift.FREE_TIME_START_MIN_5 eq 30> selected</cfif>>30</option>
								<option value="35"<cfif get_shift.FREE_TIME_START_MIN_5 eq 35> selected</cfif>>35</option>
								<option value="40"<cfif get_shift.FREE_TIME_START_MIN_5 eq 40> selected</cfif>>40</option>
								<option value="45"<cfif get_shift.FREE_TIME_START_MIN_5 eq 45> selected</cfif>>45</option>
								<option value="50"<cfif get_shift.FREE_TIME_START_MIN_5 eq 50> selected</cfif>>50</option>
								<option value="55"<cfif get_shift.FREE_TIME_START_MIN_5 eq 55> selected</cfif>>55</option>
							</select>
						</div>
						<div class="col col-1 ">
							<cf_wrkTimeFormat name="FREE_TIME_END_HOUR_5" value="#get_shift.FREE_TIME_END_HOUR_5#">																																																																																			
						</div>
						<div class="col col-1 ">
							<select name="FREE_TIME_END_MIN_5" id="FREE_TIME_END_MIN_5">
								<option value="00"<cfif get_shift.FREE_TIME_END_MIN_5 eq 0> selected</cfif>>00</option>
								<option value="05"<cfif get_shift.FREE_TIME_END_MIN_5 eq 5> selected</cfif>>05</option>
								<option value="10"<cfif get_shift.FREE_TIME_END_MIN_5 eq 10> selected</cfif>>10</option>
								<option value="15"<cfif get_shift.FREE_TIME_END_MIN_5 eq 15> selected</cfif>>15</option>
								<option value="20"<cfif get_shift.FREE_TIME_END_MIN_5 eq 20> selected</cfif>>20</option>
								<option value="25"<cfif get_shift.FREE_TIME_END_MIN_5 eq 25> selected</cfif>>25</option>
								<option value="30"<cfif get_shift.FREE_TIME_END_MIN_5 eq 30> selected</cfif>>30</option>
								<option value="35"<cfif get_shift.FREE_TIME_END_MIN_5 eq 35> selected</cfif>>35</option>
								<option value="40"<cfif get_shift.FREE_TIME_END_MIN_5 eq 40> selected</cfif>>40</option>
								<option value="45"<cfif get_shift.FREE_TIME_END_MIN_5 eq 45> selected</cfif>>45</option>
								<option value="50"<cfif get_shift.FREE_TIME_END_MIN_5 eq 50> selected</cfif>>50</option>
								<option value="55"<cfif get_shift.FREE_TIME_END_MIN_5 eq 55> selected</cfif>>55</option>
							</select>
						</div>
						<div class="col col-1 " class="text-center"><input type="checkbox" value="1" name="IS_WEEKEND_5" id="IS_WEEKEND_5" <cfif get_shift.IS_WEEKEND_5 eq 1>checked</cfif> /></div>
						<div class="col col-1 " class="text-center"><input type="checkbox" value="1" name="IS_FISRT_ADD_TIME_5" id="IS_FISRT_ADD_TIME_5" <cfif get_shift.IS_FISRT_ADD_TIME_5 eq 1>checked</cfif> /></div>
						<div class="col col-1 " class="text-center"><input type="checkbox" value="1" name="IS_LAST_ADD_TIME_5" id="IS_LAST_ADD_TIME_5" <cfif get_shift.IS_LAST_ADD_TIME_5 eq 1>checked</cfif> /></div>
					</div>		
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<div class="col col-6 col-xs-12">
					<cf_record_info query_name="get_shift" >
				</div>
				<div class="col col-6 col-xs-12">
					<cfsavecontent variable="message_sil"><cf_get_lang dictionary_id="53150.E-Hesapta Kayıtlı Vardiyayı Silmek Üzeresiniz, Emin misiniz?"></cfsavecontent>
					<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=#xfa.del#&SHIFT_ID=#attributes.shift_id#' delete_alert='#message_sil#' add_function="control()" >
				</div>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function get_departments(branch_id)
	{
		var get_dep = wrk_safe_query('hr_get_dep','dsn',0,branch_id)
		document.add_shift.department_id.options.length=0;
		document.add_shift.department_id.options[0] = new Option('Seçiniz','');
		if (get_dep.recordcount)
		{
			for(var jj=0;jj<get_dep.recordcount;jj++)
				document.add_shift.department_id.options[jj+1] = new Option(get_dep.DEPARTMENT_HEAD[jj],get_dep.DEPARTMENT_ID[jj]);
		}
	}
	function get_employees(department_id)
	{
		branch_id = $("#branch_id").value;
		var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.shift_employees&department="+department_id+"&branch_id="+branch_id;
		AjaxPageLoad(send_address,'employees_div',1,'Çalışanlar');
	}
	function control()
	{
		<cfif isdefined('attributes.is_production') or get_shift.is_production eq 1>
			if(document.add_shift.branch_id.value == 0)
			{
				alert("<cf_get_lang dictionary_id='58194.Zorunlu Alan'> : <cf_get_lang dictionary_id='57453.Şube'>");
				return false;
			}
		</cfif>
		if (!time_check(document.add_shift.startdate, document.add_shift.start_hour, document.add_shift.start_min, document.add_shift.finishdate, document.add_shift.end_hour, document.add_shift.end_min, "<cf_get_lang dictionary_id='64683.Geçerlilik Tarihi / Vardiya Aralığı Değerlerini Kontrol Ediniz'> <cf_get_lang dictionary_id='64684.	Başlama Değeri, Bitiş Değerinden Büyük Olamaz'> !"))
		return false;
		add_shift.control_hour_1.value = filterNum(add_shift.control_hour_1.value);
		add_shift.control_hour_2.value = filterNum(add_shift.control_hour_2.value);
	}	

</script>
