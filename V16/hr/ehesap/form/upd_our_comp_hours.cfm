<cfinclude template="../query/get_hours_all.cfm"> 
<cfsavecontent variable="images"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_add_our_comp_hours"><img src="/images/plus1.gif" title="<cf_get_lang dictionary_id='54328.Şirket SSK Çalışma Saati Ekle'>"></a></cfsavecontent>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form_upd" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_upd_our_comp_hours">
			<input type="hidden" name="och_id" id="och_id" value="<cfoutput>#attributes.och_id#</cfoutput>">
			<cf_box_elements>
				<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-OUR_COMPANY_ID">
						<cfinclude template="../../../settings/query/get_our_companies.cfm">
						<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="57574.Şirket"></label>
						<div class="col col-7 col-xs-12">
							<select name="OUR_COMPANY_ID" id="OUR_COMPANY_ID" style="width:345px;">
								<cfoutput query="OUR_COMPANY">
									<option value="#COMP_ID#"<cfif get_hours.our_company_id eq comp_id> selected</cfif>>#COMPANY_NAME#</option>
								</cfoutput>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-ssk_monthly_work_hours">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="53870.SGK Aylık Çalışma Saati"></cfsavecontent>
						<label class="col col-5 col-xs-12"><cfoutput>#message#</cfoutput></label>
						<div class="col col-7 col-xs-12">
							<cfinput type="text" name="ssk_monthly_work_hours" value="#TLFormat(get_hours.ssk_monthly_work_hours,1)#" message="#message#" required="yes" style="width:85px;" onkeyup="return(FormatCurrency(this,event));">
						</div>
					</div>
					<div class="form-group" id="item-daily_work_hours">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="53896.Hafta içi Günlük Çalışma Saati"></cfsavecontent>
						<label class="col col-5 col-xs-12"><cfoutput>#message#</cfoutput></label>
						<div class="col col-7 col-xs-12">
							<cfinput type="text" name="daily_work_hours" value="#TLFormat(get_hours.daily_work_hours,1)#" message="#message#" required="yes" style="width:75px;" onkeyup="return(FormatCurrency(this,event));">
						</div>
					</div>
					<div class="form-group" id="item-SSK_WORK_HOURS">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="53930.SGK Mesai Saati"></cfsavecontent>
						<label class="col col-5 col-xs-12"><cfoutput>#message#</cfoutput> </label>
						<div class="col col-7 col-xs-12">
							<cfinput type="text" name="SSK_WORK_HOURS" value="#TLFormat(get_hours.SSK_WORK_HOURS,1)#" message="#message#" required="yes" style="width:85px;" onkeyup="return(FormatCurrency(this,event));">
						</div>
					</div>
					<div class="form-group" id="item-SATURDAY_WORK_HOURS">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="53918.Cumartesi Çalışma Saati"></cfsavecontent>
						<label class="col col-5 col-xs-12"><cfoutput>#message#</cfoutput></label>
						<div class="col col-7 col-xs-12">
							<cfinput type="text" name="SATURDAY_WORK_HOURS" value="#TLFormat(get_hours.SATURDAY_WORK_HOURS,1)#" message="#message#" required="yes" style="width:75px;" onkeyup="return(FormatCurrency(this,event));">
						</div>
					</div>
					<div class="form-group" id="item-weekly_offday">
						<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id="29516.Haftalık Tatil Günü"></label>
						<div class="col col-7 col-xs-12">
							<select name="weekly_offday" id="weekly_offday" style="width:85px;">
								<option value="2"<cfif get_hours.weekly_offday eq 2> selected</cfif>><cf_get_lang dictionary_id="57604.Pazartesi"></option>
								<option value="3"<cfif get_hours.weekly_offday eq 3> selected</cfif>><cf_get_lang dictionary_id="57605.Salı"></option>
								<option value="4"<cfif get_hours.weekly_offday eq 4> selected</cfif>><cf_get_lang dictionary_id="57606.Çarşamba"></option>
								<option value="5"<cfif get_hours.weekly_offday eq 5> selected</cfif>><cf_get_lang dictionary_id="57607.Perşembe"></option>
								<option value="6"<cfif get_hours.weekly_offday eq 6> selected</cfif>><cf_get_lang dictionary_id="57608.Cuma"></option>
								<option value="7"<cfif get_hours.weekly_offday eq 7> selected</cfif>><cf_get_lang dictionary_id="57609.Cumartesi"></option>
								<option value="1"<cfif get_hours.weekly_offday eq 1 or not Len(get_hours.weekly_offday)> selected</cfif>><cf_get_lang dictionary_id="57610.Pazar"></option>
							</select>
						</div>
					</div>
					<div class="form-group" id="item-saturday_off">
						<label class="col col-5 col-xs-12 hide"></label>
						<div class="col col-7 col-xs-12">
							<label><input type="checkbox" name="saturday_off" id="saturday_off" value="1" <cfif get_hours.saturday_off eq 1>checked</cfif>> <cf_get_lang dictionary_id="53915.Cumartesi Ek Hafta Tatili Sayılsın"></label>
						</div>
					</div>
					<div class="form-group" id="item-hours">
						<label class="col col-12 bold"><cf_get_lang dictionary_id='53415.Çalışma Saatleri'></label>
					</div>
					<div class="form-group" id="item-start_hour">
						<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='53066.Başlama saati'></label>
						<div class="col col-7 col-xs-12">
							<div class="input-group">
								<select name="start_hour" id="start_hour">
									<cfloop from="0" to="24" index="i">
										<cfoutput>
											<option value="#i#" <cfif get_hours.start_hour eq i>selected</cfif>>#i#</option>
										</cfoutput>
									</cfloop>
								</select>
								<span class="input-group-addon no-bg"></span>
								<select name="start_min" id="start_min">
									<option value="00"<cfif get_hours.start_min eq 0> selected</cfif>>00</option>
									<option value="05"<cfif get_hours.start_min eq 5> selected</cfif>>05</option>
									<option value="10"<cfif get_hours.start_min eq 10> selected</cfif>>10</option>
									<option value="15"<cfif get_hours.start_min eq 15> selected</cfif>>15</option>
									<option value="20"<cfif get_hours.start_min eq 20> selected</cfif>>20</option>
									<option value="25"<cfif get_hours.start_min eq 25> selected</cfif>>25</option>
									<option value="30"<cfif get_hours.start_min eq 30> selected</cfif>>30</option>
									<option value="35"<cfif get_hours.start_min eq 35> selected</cfif>>35</option>
									<option value="40"<cfif get_hours.start_min eq 40> selected</cfif>>40</option>
									<option value="45"<cfif get_hours.start_min eq 45> selected</cfif>>45</option>
									<option value="50"<cfif get_hours.start_min eq 50> selected</cfif>>50</option>
									<option value="55"<cfif get_hours.start_min eq 55> selected</cfif>>55</option>
								</select>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-end_hour">
						<label class="col col-5 col-xs-12"><cf_get_lang dictionary_id='53067.Bitiş saati'></label>
						<div class="col col-7 col-xs-12">
							<div class="input-group">
								<select name="end_hour" id="end_hour">
									<cfloop from="0" to="24" index="i">
										<cfoutput>
											<option value="#i#"<cfif get_hours.end_hour eq i> selected</cfif>>#i#</option>
										</cfoutput>
									</cfloop>
								</select>
								<span class="input-group-addon no-bg"></span>
								<select name="end_min" id="end_min">
									<option value="00"<cfif get_hours.end_min eq 0> selected</cfif>>00</option>
									<option value="05"<cfif get_hours.end_min eq 5> selected</cfif>>05</option>
									<option value="10"<cfif get_hours.end_min eq 10> selected</cfif>>10</option>
									<option value="15"<cfif get_hours.end_min eq 15> selected</cfif>>15</option>
									<option value="20"<cfif get_hours.end_min eq 20> selected</cfif>>20</option>
									<option value="25"<cfif get_hours.end_min eq 25> selected</cfif>>25</option>
									<option value="30"<cfif get_hours.end_min eq 30> selected</cfif>>30</option>
									<option value="35"<cfif get_hours.end_min eq 35> selected</cfif>>35</option>
									<option value="40"<cfif get_hours.end_min eq 40> selected</cfif>>40</option>
									<option value="45"<cfif get_hours.end_min eq 45> selected</cfif>>45</option>
									<option value="50"<cfif get_hours.end_min eq 50> selected</cfif>>50</option>
									<option value="55"<cfif get_hours.end_min eq 55> selected</cfif>>55</option>
								</select>
							</div>
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cf_box_footer>
				<cf_record_info query_name="get_hours">
				<cf_workcube_buttons is_upd='1' is_delete='0' add_function='unformat_fields()'>
			</cf_box_footer>
		</cfform>
	</cf_box>
</div>
<script type="text/javascript">
	function unformat_fields()
	{
		document.form_upd.ssk_monthly_work_hours.value=filterNum(document.form_upd.ssk_monthly_work_hours.value);
		document.form_upd.daily_work_hours.value=filterNum(document.form_upd.daily_work_hours.value);
		document.form_upd.SSK_WORK_HOURS.value=filterNum(document.form_upd.SSK_WORK_HOURS.value);
		document.form_upd.SATURDAY_WORK_HOURS.value=filterNum(document.form_upd.SATURDAY_WORK_HOURS.value);
	}
</script>
