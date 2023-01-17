<style>
	.progress-bar {
		box-shadow: none !important
	}

	.dashboard-stat2 {
		float: left;
		width: 100%;
		padding: 10px 15px;
		margin: 0;
		letter-spacing: 1px;
	}

	.dashboard-stat2 .progress-info .status {
		float: left;
		width: 100%;
		margin-top: 10px;
		text-transform: initial !important;
	}

	.dashboard-stat2 .display {
		margin: 0;
	}

	.dashboard-stat2 .display .date {
		float: right;
		font-size: 14px;
		line-height: 27px;
	}

	.number h4 {
		font-size: 12px;
		font-weight: bold;
		background: #2ab4c0;
		padding: 6px 10px;
		color: #fff;
		border-radius: 4px;
		margin:0;
	}

	.number h4 i {
		font-size: 15px;
		color: #fff;
		margin-right: 5px;
		vertical-align: middle;
	}

	.status a {
		display: inline-block;
		padding: 5px 10px;
		color: #555;
		border-radius: 4px;
		transition: .4s;
	}

	.status a:hover {
		color: #fff;
		background-color: #2ab4c0;
		transition: .4s;
	}

	.status a:hover i {
		color: #fff;
		transition: .4s;
	}

	.status a i {
		text-align: center;
		margin-right: 5px;
		color: #2ab4c0;
		font-size: 12px;
	}

	.dashboard-stat2-content {
		float: left;
		width: 100%;
		padding: 10px;
	}

	.dashboard-stat2-content label {
		margin: 0 !important;
	}

	.content-item {
		float: left;
		width: 100%;
		padding: 5px 0;
	}

	.content-item p {
		margin: 0;
	}

	.content-item p sub {
		margin-left: 5px;
	}

	.circleContent {
		width: 25%
	}

	@media screen and (max-width: 1200px) {
		.circleContent {
			width: 33% !important;
		}
	}

	@media screen and (max-width: 992px) {
		.circleContent {
			width: 33% !important;
		}
	}

	@media screen and (max-width: 768px) {
		.circleContent {
			width: 33% !important;
		}
	}

	@media screen and (max-width: 548px) {
		.circleContent {
			width: 50% !important;
		}
	}

	@media screen and (max-width: 319px) {
		.circleContent {
			width: 100% !important;
		}
	}

	.notification-count {
		background-color: rgba(3, 109, 187, 0.9);
		min-width: 14px;
		padding: 5px;
		margin-left: 10px;
		border-radius: 55px;
		position: absolute;
		font-size: 12px;
		box-shadow: 1px 1px 1px rgba(0, 0, 0, 0.7);
		vertical-align: middle;
		color: #fff;
	}
</style>
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.member_cat_type" default="">
<cfparam name="attributes.pos_code" default="">
<cfparam name="attributes.pos_code_text" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.employee_id" default="#session.ep.userid#">
<cfparam name="attributes.acc_type_id" default="">
<cfquery name="get_member_accounts" datasource="#dsn#">
	SELECT *,0 AS ACC_TYPE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfscript>
	all_borctoplam = 0;
	all_alacaktoplam = 0;
	attributes.acc_type_id = '';
	if(listlen(attributes.employee_id,'_') eq 2)
	{
	attributes.acc_type_id = listlast(attributes.employee_id,'_');
	attributes.employee_id = listfirst(attributes.employee_id,'_');
	}
</cfscript>
<cfif validate_style eq "eurodate">
	<cfset date1="01/01/#session.ep.period_year#">
	<cfset date2="31/12/#session.ep.period_year#">
<cfelse>
	<cfset date1="01/01/#session.ep.period_year#">
	<cfset date2="12/31/#session.ep.period_year#">
</cfif>
<cf_date tarih='date1'>
<cf_date tarih='date2'>
<cfquery name="get_hours_dashboard" datasource="#dsn#">
	SELECT
	OUR_COMPANY_HOURS.OCH_ID,
	OUR_COMPANY_HOURS.OUR_COMPANY_ID,
	OUR_COMPANY_HOURS.DAILY_WORK_HOURS,
	OUR_COMPANY_HOURS.SATURDAY_WORK_HOURS,
	OUR_COMPANY_HOURS.SSK_MONTHLY_WORK_HOURS,
	OUR_COMPANY_HOURS.SSK_WORK_HOURS,
	OUR_COMPANY_HOURS.WEEKLY_OFFDAY,
	OUR_COMPANY_HOURS.UPDATE_DATE,
	OUR_COMPANY_HOURS.UPDATE_EMP,
	OUR_COMPANY_HOURS.UPDATE_IP,
	OUR_COMPANY_HOURS.RECORD_DATE,
	OUR_COMPANY_HOURS.RECORD_IP,
	OUR_COMPANY_HOURS.RECORD_EMP,
	OUR_COMPANY_HOURS.SATURDAY_OFF,
	OUR_COMPANY_HOURS.START_HOUR,
	OUR_COMPANY_HOURS.START_MIN,
	OUR_COMPANY_HOURS.END_HOUR,
	OUR_COMPANY_HOURS.END_MIN,
	OUR_COMPANY.NICK_NAME,
	EMPLOYEES.EMPLOYEE_NAME,
	EMPLOYEES.EMPLOYEE_SURNAME
	FROM
	OUR_COMPANY_HOURS,
	EMPLOYEES,
	OUR_COMPANY
	WHERE
	OUR_COMPANY.COMP_ID = OUR_COMPANY_HOURS.OUR_COMPANY_ID
	AND EMPLOYEES.EMPLOYEE_ID = OUR_COMPANY_HOURS.UPDATE_EMP
	AND OUR_COMPANY_HOURS.OCH_ID = 1
	<cfif isdefined("attributes.och_id") and len(attributes.och_id)>
		AND OUR_COMPANY_HOURS.OCH_ID = #attributes.och_id#
	</cfif>

	AND OUR_COMPANY_HOURS.OUR_COMPANY_ID = #session.ep.company_id#

</cfquery>

<cfif fusebox.use_period eq true>
	<!--- Sağlık Harcamaları --->
	<cfset get_health_expense_comp = createObject("component","V16.myhome.cfc.health_expense")>
	<cfset get_total_amount = get_health_expense_comp.GET_SUM_HEALTH_EXPENSE(employee_id : attributes.employee_id)>
	<cfset get_total_self_amount = get_health_expense_comp.GET_SUM_HEALTH_EXPENSE(employee_id : attributes.employee_id, treated : 1)>
	<cfset get_total_rel_amount = get_health_expense_comp.GET_SUM_HEALTH_EXPENSE(employee_id : attributes.employee_id, treated : 2)>
</cfif>

<cfset total_minutes = 0>
<cfset total_time = 0>
<!--- Çalışan Fazla mesailer Esma R. Uysal 02/06/2020 --->
<cfset get_ext_worktimes_comp = createObject("component","V16.hr.ehesap.cfc.get_ext_worktimes")>
<cfset get_ext_worktimes = get_ext_worktimes_comp.get_ext_worktimes(employee_id : session.ep.userid)>
<cfif get_ext_worktimes.recordcount>
	<cfoutput query="get_ext_worktimes">
		<cfset total_minutes = total_minutes + datediff("n",START_TIME,END_TIME)>	
	</cfoutput>
	<cfset total_time = total_minutes / 60>
</cfif>
<div class="ui-row">
	
	<div class="col col-6 col-md-4 col-sm-4 col-xs-12">
		<cf_box>
			<div class="dashboard-stat2">
				<div class="display">
					<div class="number">
						<h4 style="background: #2ab4c0;">
							<span><i class="fa fa-user-o"></i><cf_get_lang dictionary_id='57652.Hesap'></span>
						</h4>
					</div>
					<div class="date">
						<cfoutput>#session.ep.period_year#</cfoutput>
					</div>
				</div>
				<cfif fusebox.use_period eq true>
					<cfloop query="get_member_accounts">
						<cfset
							MyExtre=createObject("component","V16.myhome.cfc.cari_rows")>
							<cfset
								cari_rows=MyExtre.CARI_ROWS(date_1:attributes.date1
								? : "" , date_2:attributes.date2 ? : "" ,
								company_id:attributes.company_id,
								company:attributes.company,
								member_cat_type:attributes.member_cat_type,
								pos_code:attributes.pos_code,
								pos_code_text:attributes.pos_code_text,
								consumer_id:attributes.consumer_id,
								employee_id:attributes.employee_id,
								acc_type_id:get_member_accounts.acc_type_id)>
								<cfset total=0>
									<cfset borctoplam=0>
										<cfset alacaktoplam=0>
											<cfoutput query="cari_rows">
												<cfset borctoplam=borctoplam + borc>
													<cfset alacaktoplam=alacaktoplam
														+ alacak>
														<cfset
															all_borctoplam=all_borctoplam
															+ borc>
															<cfset
																all_alacaktoplam=all_alacaktoplam
																+ alacak>
																<cfset total=abs(
																	borctoplam -
																	alacaktoplam)>
											</cfoutput>
											<div class="dashboard-stat2-content">
												<div class="content-item">
													<div
														class="col col-6 col-md-6 col-sm-6 col-xs-6">
														<b>
														<cf_get_lang dictionary_id='57587.Borç'>
														</b>
													</div>
													<div
														class="col col-6 col-md-6 col-sm-6 col-xs-6">
														<p>
															<cfoutput>
																#TLFormat(borctoplam)#
																#session.ep.money#
															</cfoutput>
														</p>
													</div>
												</div>
												<div class="content-item">
													<div
														class="col col-6 col-md-6 col-sm-6 col-xs-6">
														<b>
															<cf_get_lang dictionary_id='57588.Alacak'>
														</b>
													</div>
													<div
														class="col col-6 col-md-6 col-sm-6 col-xs-6">
														<p>
															<cfoutput>
																#TLFormat(alacaktoplam)#
																#session.ep.money#
															</cfoutput>
														</p>
													</div>
												</div>
												<div class="content-item">
													<div
														class="col col-6 col-md-6 col-sm-6 col-xs-6">
														<b>
															<cfif borctoplam GT alacaktoplam>
																	<cfoutput>
																		<cf_get_lang dictionary_id='57589.Bakiye'>
																		(B)
																	</cfoutput>
															<cfelseif borctoplam LT alacaktoplam>
																	<cfoutput>
																		<cf_get_lang dictionary_id='57589.Bakiye'>
																		(A)
																	</cfoutput>
															</cfif>
														</b>
													</div>
													<div
														class="col col-6 col-md-6 col-sm-6 col-xs-6">
														<p>
															<cfoutput>
																#TLFormat(total)#
																#session.ep.money#
															</cfoutput>
														</p>
													</div>
												</div>
											</div>
					</cfloop>
				</cfif>
				<div class="progress-info">
					<div class="progress">
						<span style="width: 100%;background-color:#2ab4c0;"
							class="progress-bar">
						</span>
					</div>
					<div class="status">
						<div
							class="col col-12 col-md-12 col-sm-12 col-xs-12 padding-0">
							<div
								class="col col-6 col-md-6 col-sm-6 col-xs-6 padding-0">
								<a
									href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_extre"><i
										class="fa fa-info"></i>
									<cf_get_lang dictionary_id='33077.Detaylar'>
								</a>
							</div>
							<div
								class="col col-6 col-md-6 col-sm-6 col-xs-6 padding-0">
								<a href="javascript://"
									onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.form_add_payment_request&popup_page=1&is_installment=1&from_hr=1','medium');"
									class="pull-right"><i
										class="fa fa-plus"></i>
									<cf_get_lang dictionary_id='30914.Avans Talebi'>
								</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</cf_box>
	</div>
	<cfif fusebox.use_period eq true>										
		<div class="col col-6 col-md-4 col-sm-4 col-xs-12">
			<cf_box>
				<div class="dashboard-stat2">
					<div class="display">
						<div class="number">
							<h4 style="background-color:#2196F3;">
								<span><i class="fa fa-stethoscope"></i>
									<cf_get_lang dictionary_id='41808.Sağlık Harcamaları'>
								</span>
							</h4>
						</div>
						<div class="date">
							<cfoutput>#session.ep.period_year#</cfoutput>
						</div>
					</div>
					<div class="dashboard-stat2-content">
						<div class="content-item">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
								<b>
									<cf_get_lang dictionary_id='39885.Toplam Harcama'>
								</b>
							</div>
							<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
								<label name="total_expense" id="total_expense"><cfoutput>#TLFormat(get_total_amount.NET_TOTAL_AMOUNT)# #session.ep.money#</cfoutput></label>
							</div>
						</div>
						<div class="content-item">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
								<b>
									<cf_get_lang dictionary_id='31276.Çalışan Yakınları'>
								</b>
							</div>
							<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
								<label name="rel_amount" id="rel_amount"><cfoutput>#TLFormat(get_total_rel_amount.NET_TOTAL_AMOUNT)# #session.ep.money#</cfoutput></label>
							</div>
						</div>
						<div class="content-item">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
								<b>
									<cf_get_lang dictionary_id="57576.Çalışan">
								</b>
							</div>
							<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
								<label name="self_amount" id="self_amount"><cfoutput>#TLFormat(get_total_self_amount.NET_TOTAL_AMOUNT)# #session.ep.money#</cfoutput></label>
							</div>
						</div>
					</div>

					<div class="progress-info">
						<div class="progress">
							<span style="width: 100%;background-color:#2196F3;"
								class="progress-bar">
							</span>
						</div>
						<div class="status">
							<div
								class="col col-12 col-md-12 col-sm-12 col-xs-12 padding-0">
								<div
									class="col col-6 col-md-6 col-sm-6 col-xs-6 padding-0">
									<a
										href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.health_expense_approve"><i
											class="fa fa-info"></i>
										<cf_get_lang dictionary_id='33077.Detaylar'>
									</a>
								</div>
								<div
									class="col col-6 col-md-6 col-sm-6 col-xs-6 padding-0">
									<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.health_expense_approve&event=add"
										class="pull-right"><i
											class="fa fa-plus"></i><cf_get_lang dictionary_id='59971.Sağlık Talebi'></a>
								</div>
							</div>
						</div>
					</div>
				</div>
			</cf_box>
		</div>
	</cfif>
	<div class="col col-6 col-md-4 col-sm-4 col-xs-12">
		<cf_box>
			<div class="dashboard-stat2">
				<div class="display">
					<div class="number">
						<h4 style="background-color:#e91e63;">
							<span><i class="fa fa-briefcase"></i>
								<cf_get_lang dictionary_id='36795.Çalışma Programı'>
							</span>
						</h4>
					</div>
					<div class="date">
						<cfoutput>#session.ep.period_year#</cfoutput>
					</div>
				</div>
				<div class="dashboard-stat2-content">
					<div class="content-item">
						<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
							<b>
								<cf_get_lang dictionary_id='53415.Çalışma Saatleri'>
							</b>
						</div>
						<cfoutput query="get_hours_dashboard">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
								<p><cf_get_lang dictionary_id='40828.Hafta içi'> : #start_hour#:#start_min#-#end_hour#:#end_min#</p>
							</div>
						</cfoutput>
					</div>
					<cfoutput>
						<!----
						Hesaplaması öğrenildikten sonra geri eklenecek şuan hiç bir hesaplama yapmıyor.
						<div class="content-item">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
								<b><cf_get_lang dictionary_id='59972.Esnek Program'></b>
							</div>
							<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
								<p><cf_get_lang dictionary_id='58932.Aylık'> 0 <cf_get_lang dictionary_id='57491.Saat'></p>
							</div>
						</div>
						---->
						<div class="content-item">
							<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
								<b>
									<cf_get_lang dictionary_id='38224.Fazla Mesai'>
								</b>
							</div>
							<div class="col col-6 col-md-6 col-sm-6 col-xs-6">
								<p>#total_time# <cf_get_lang dictionary_id='57491.Saat'></p>
							</div>
						</div>
					</cfoutput>
				</div>

				<div class="progress-info">
					<div class="progress">
						<span style="width: 100%;background-color:#e91e63;"
							class="progress-bar">
						</span>
					</div>
					<div class="status">
						<div
							class="col col-12 col-md-12 col-sm-12 col-xs-12 padding-0">
							<div
								class="col col-6 col-md-6 col-sm-6 col-xs-6 padding-0">
								<a
									href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_my_extra_times"><i
										class="fa fa-info"></i>
									<cf_get_lang dictionary_id='33077.Detaylar'>
								</a>
							</div>
							<div
								class="col col-6 col-md-6 col-sm-6 col-xs-6 padding-0">
								<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.list_my_extra_times&event=add"
									class="pull-right"><i
										class="fa fa-plus"></i><cf_get_lang dictionary_id='54126.Mesai'> <cf_get_lang dictionary_id ='33224.Talebi'></a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</cf_box>
	</div>
	<div class="col col-6 col-md-4 col-sm-4 col-xs-12">
		<cf_box>
			<div class="dashboard-stat2">
				<div class="display">
					<div class="number">
						<h4 style="background-color:#9e9e9e;">
							<span><i class="fa fa-braille"></i>
								<cf_get_lang dictionary_id='30820.İzinler'>
							</span>
						</h4>
					</div>
					<div class="date">
						<cfoutput>#session.ep.period_year#</cfoutput>
					</div>
				</div>
				
				<cfinclude  template="offtimes_dashboard.cfm">
				<div class="progress-info">
					<div class="progress">
						<span
							style="width: 100%;background-color:#9e9e9e;"
							class="progress-bar">
						</span>
					</div>
					<div class="status">
						<div
							class="col col-12 col-md-12 col-sm-12 col-xs-12 padding-0">
							<div
								class="col col-6 col-md-6 col-sm-6 col-xs-6 padding-0">
								<a
									href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_offtimes"><i
										class="fa fa-info"></i>
									<cf_get_lang dictionary_id='33077.Detaylar'>
								</a>
							</div>
							<div
								class="col col-6 col-md-6 col-sm-6 col-xs-6 padding-0">
								<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_offtimes&event=add&employee_id=<cfoutput>#session.ep.userid#&kalan_izin=#toplam_hakedilen_izin - genel_izin_toplam - old_days#</cfoutput>"
									class="pull-right"><i
										class="fa fa-plus"></i>
									<cf_get_lang dictionary_id='32347.İzin Talebi'>
								</a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</cf_box>
	</div>
</div>