<cf_xml_page_edit fuseact="ehesap.list_ext_worktimes">
<cf_get_lang_set module_name="ehesap">
<cfset url_str = "">
<cfif isdefined("attributes.date1") and len(attributes.date1)>
	<cfparam name="attributes.date1" default="#dateFormat(attributes.date1,dateformat_style)#">
<cfelse>
	<cfparam name="attributes.date1" default="01/#Month(now())#/#year(now())#">
</cfif>
<!--Muzaffer Bas-->
<cfset get_fuseaction_property = createObject("component","V16.objects.cfc.fuseaction_properties")>
    <cfset Akdi_Gun_FM = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_akdi_day_work'
    )>
	<cfset x_akdi_day_work = Akdi_Gun_FM.PROPERTY_VALUE>

	<cfset Hafta_tatili_FM = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_weekly_day_work'
    )>
	<cfset x_weekly_day_work = Hafta_tatili_FM.PROPERTY_VALUE>

	<cfset Resmi_Tatil_Gun = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_official_day_work'
    )>
	<cfset x_official_day_work = Resmi_Tatil_Gun.PROPERTY_VALUE>

	<cfset Arefe_Gun_FM = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_Arefe_day_work'
    )>
	<cfset x_Arefe_day_work = Arefe_Gun_FM.PROPERTY_VALUE>

	<cfset Dini_Gun_FM = get_fuseaction_property.get_fuseaction_property(
    company_id : session.ep.company_id,
    fuseaction_name : 'ehesap.form_upd_program_parameters',
    property_name : 'x_Dini_day_work'
    )>
	<cfset x_Dini_day_work = Dini_Gun_FM.PROPERTY_VALUE>
<!--Muzaffer Bit-->
<cfparam name="attributes.date2" default="#dateformat((Createdate(year(CreateDate(year(now()),month(now()),1)),month(CreateDate(year(now()),month(now()),1)),DaysInMonth(CreateDate(year(now()),month(now()),1)))),dateformat_style)#">

<cfparam name="attributes.work_date1" default="">
<cfparam name="attributes.work_date2" default="">

<cfparam name="attributes.param" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.related_company" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.day_type" default="">
<cfparam name="attributes.pdks_status" default="">
<cfparam name="attributes.period" default="#year(now())#">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.group_paper_no" default="" />
<cfparam name="attributes.filter_process" default="" />
<cfparam name="attributes.working_space" default="" />
<cfparam name="attributes.shift_status" default="" />
<!--- Aşama Component --->
<cfset cmp_process = createObject('component','V16.workdata.get_process')>
<cfset get_process = cmp_process.GET_PROCESS_TYPES(faction_list : 'ehesap.list_ext_worktimes')>
<cfset adres="#listgetat(attributes.fuseaction,1,'.')#.list_ext_worktimes" />
<cfset url_str="&keyword=#attributes.keyword#">
<cfif IsDefined('attributes.day_type') and len(attributes.day_type)>
	<cfset url_str="#url_str#&day_type=#attributes.day_type#">
</cfif>
<cfif IsDefined('attributes.related_company') and len(attributes.related_company)>
	<cfset url_str="#url_str#&related_company=#attributes.related_company#">
</cfif>
<cfset url_str="#url_str#&pdks_status=#attributes.pdks_status#">
<cfif IsDefined('attributes.form_submit') and len(attributes.form_submit)>
	<cfset url_str="#url_str#&form_submit=#attributes.form_submit#">
</cfif>
<cfif IsDefined('attributes.branch_id') and len(attributes.branch_id)>
	<cfset url_str="#url_str#&branch_id=#attributes.branch_id#">
</cfif>
<cfif IsDefined('attributes.department') and len(attributes.department)>
	<cfset url_str="#url_str#&department=#attributes.department#">
</cfif>
<cfif IsDefined('attributes.period') and len(attributes.period)>
	<cfset url_str="#url_str#&period=#attributes.period#">
</cfif>
<cfif IsDefined('attributes.mon') and len(attributes.mon)>
	<cfset url_str="#url_str#&mon=#attributes.mon#">
</cfif>
<cfif IsDefined('attributes.end_mon') and len(attributes.end_mon)>
	<cfset url_str="#url_str#&end_mon=#attributes.end_mon#">
</cfif>
<cfif isDefined('attributes.group_paper_no') and Len(attributes.group_paper_no)>
	<cfset url_str = '#url_str#&group_paper_no=#attributes.group_paper_no#' />
</cfif>
<cfif isDefined('attributes.working_space') and Len(attributes.working_space)>
	<cfset url_str = '#url_str#&working_space=#attributes.working_space#' />
</cfif>
<cfif isDefined('attributes.shift_status') and Len(attributes.shift_status)>
	<cfset url_str = '#url_str#&shift_status=#attributes.shift_status#' />
</cfif>
<!--- sorgu sirayi bozmayin  --->
<cf_date tarih='attributes.date1'>
<cf_date tarih='attributes.date2'>

<cfif isdate(attributes.work_date1)>
	<cf_date tarih='attributes.work_date1'>
</cfif>

<cfif isdate(attributes.work_date2)>
	<cf_date tarih='attributes.work_date2'>
</cfif>

<cfinclude template="../query/get_our_comp_and_branchs.cfm">
<cfif isdefined('attributes.form_submit')>
	<cfif is_extwork_type eq 1>
		<cfinclude template="../query/get_ext_worktimes.cfm">
	<cfelse>
		<cfinclude template="../query/get_ext_worktimes2.cfm">
	</cfif>
<cfelse>
<cfset get_ext_worktimes.recordcount = 0>
</cfif>
<cfif isdate(attributes.work_date1)>
	<cfset attributes.work_date1=dateformat(attributes.work_date1,dateformat_style)>
	<cfset url_str="#url_str#&work_date1=#attributes.work_date1#">
</cfif>
<cfif isdate(attributes.work_date2)>
	<cfset attributes.work_date2=dateformat(attributes.work_date2,dateformat_style)>
	<cfset url_str="#url_str#&work_date2=#attributes.work_date2#">
</cfif>

<cf_box id="list_ext_work_search">
	<cfform action="#request.self#?fuseaction=#fusebox.circuit#.list_ext_worktimes" name="myform" method="post">
		<input type="hidden" name="form_submit" id="form_submit" value="1">
		<cf_box_search>
			<div class="form-group">
				<cfinput name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" placeholder="#getLang('','Filtre',57460)#">
			</div>
			<div class="form-group">
				<cfinput name="hierarchy" id="hierarchy" value="#attributes.hierarchy#" maxlength="50" placeholder="#getLang('','Hierarşi',55898)#">
			</div>
			<cfif is_extwork_type eq 1>
				<div class="form-group">
					<select name="pdks_status" id="pdks_status">
						<option value=""><cf_get_lang dictionary_id='54172.PDKS Durumu'></option>
						<option value="1" <cfif attributes.pdks_status eq 1>selected</cfif>><cf_get_lang dictionary_id='54173.PDKS Kaydı'></option>
						<option value="0" <cfif attributes.pdks_status eq 0>selected</cfif>><cf_get_lang dictionary_id='54174.Normal Kayıt'></option>
					</select>
				</div>
			</cfif>
			<cfif is_extwork_type eq 0>
				<div class="form-group">
					<select name="mon" id="mon">
						<cfloop from="1" to="12" index="j">
							<option value="<cfoutput>#j#</cfoutput>"<cfif isdefined('attributes.mon') and attributes.mon eq j>selected</cfif>><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option>
						</cfloop>
					</select>
				</div>
				<div class="form-group">
					<select name="end_mon" id="end_mon">
						<cfloop from="1" to="12" index="j">
							<option value="<cfoutput>#j#</cfoutput>"<cfif isdefined('attributes.end_mon') and attributes.end_mon eq j>selected</cfif>><cfoutput>#listgetat(ay_list(),j,',')#</cfoutput></option>
						</cfloop>
					</select>
				</div>
				<div class="form-group">
					<select name="period" id="period">
						<cfloop from="#year(now())-1#" to="#year(now())+2#" index="j">
							<option value="<cfoutput>#j#</cfoutput>" <cfif isdefined('attributes.period') and attributes.period eq j>selected</cfif>><cfoutput>#j#</cfoutput></option>
						</cfloop>
					</select>
				</div>
				<div class="form-group small">
					<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cfif>
			<cfif is_extwork_type eq 1>
				<div class="form-group">
					<div class="input-group small">
						<cfset attributes.date1=dateformat(attributes.date1,dateformat_style)>
						<cfset attributes.date2=dateformat(attributes.date2,dateformat_style)>
						<cfset url_str="#url_str#&date1=#attributes.date1#">
						<cfset url_str="#url_str#&date2=#attributes.date2#">
						<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
					</div>
				</div>
				<div class="form-group">
					<cf_wrk_search_button search_function="date_check(myform.date1,myform.date2,'#getLang('','Tarih Değerini Kontrol Ediniz',57782)#')" button_type="4">
				</div>
			</cfif>
			
				<cfoutput>
					<cfif is_extwork_type eq 1>
						<div class="form-group">
							<a href="#request.self#?fuseaction=ehesap.list_ext_worktimes&event=addMulti" target="_blank" class="ui-btn ui-btn-gray2"><i class="fa fa-calendar-o" title="<cf_get_lang dictionary_id='53596.Fazla Mesai Toplu Giriş'>"></i></a>
						</div>
						<div class="form-group">
							<a href="#request.self#?fuseaction=ehesap.list_ext_worktimes&event=addMultiSingle" target="_blank" class="ui-btn ui-btn-gray2"><i class="fa fa-calendar" title="<cf_get_lang dictionary_id='62990.Çalışana Toplu Mesai'>"></i></a>
						</div>
					<cfelse>
						<div class="form-group">
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_add_overtime_all','longpage');" class="ui-btn ui-btn-gray2"><i class="fa fa-calendar-o" alt="<cf_get_lang dictionary_id='53579.Toplu Fazla Mesai'>" title="<cf_get_lang dictionary_id='53579.Toplu Fazla Mesai'>"></i></a>
						</div>
					</cfif>
				</cfoutput>
		</cf_box_search>
		<cf_box_search_detail>
			<cfif is_extwork_type eq 1>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-day_type">
						<label class="col col-12"><cf_get_lang dictionary_id="57490.Gün"></label>
						<div class="col col-12">
							<select name="day_type" id="day_type">
								<option value=""><cf_get_lang dictionary_id='58081.Hepsi'></option>
								<option value="0" <cfif attributes.day_type eq 0> selected</cfif>><cf_get_lang dictionary_id='53014.Normal Gün'></option>
								<option value="1" <cfif attributes.day_type eq 1> selected</cfif>><cf_get_lang dictionary_id='53015.Hafta Sonu'></option>
								<option value="2" <cfif attributes.day_type eq 2> selected</cfif>><cf_get_lang dictionary_id='53016.Resmi Tatil'></option>
								<option value="3" <cfif attributes.day_type eq 3> selected</cfif>><cf_get_lang dictionary_id='54251.Gece Çalışması'></option>
								<!---Muzaffer Bas--->
								<cfif x_weekly_day_work eq 1>
									<option value="-8" <cfif attributes.day_type eq -8> selected</cfif>>Hafta Tatili-Gün</option>
								</cfif>
								<cfif x_akdi_day_work eq 1>
									<option value="-9" <cfif attributes.day_type eq -9> selected</cfif>>Akdi Tatil-Gün</option>
								</cfif>
								<cfif x_official_day_work eq 1>
									<option value="-10" <cfif attributes.day_type eq -10> selected</cfif>>Resmi Tatil-Gün</option>
								</cfif>
								<cfif x_Arefe_day_work eq 1>
									<option value="-11" <cfif attributes.day_type eq -11> selected</cfif>>Arefe Tatil-Gün</option>
								</cfif>
								<cfif x_Dini_day_work eq 1>
									<option value="-12" <cfif attributes.day_type eq -12> selected</cfif>>Dini Bayram-Gün</option>
								</cfif>
								<!---Muzaffer Bit--->
							</select>
						</div>
					</div>
					<div class="form-group" id="item-date1">
						<label class="col col-12"><cf_get_lang dictionary_id="47800.Başlangıç - Bitiş"></label>
						<div class="col col-12">
							<div class="col col-6">
								<div class="input-group">
									<cfinput value="#attributes.date1#" required="Yes" validate="#validate_style#" message="#getLang('','Başlangıç tarihi Girmelisiniz',57738)#" type="text" name="date1" id="date1">
									<span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
								</div>
							</div>
							<div class="col col-6">
								<div class="input-group">
									<cfinput value="#attributes.date2#" required="Yes" validate="#validate_style#" message="#getLang('','Bitiş tarihi Girmelisiniz',57739)#" type="text" name="date2" id="date2">
									<span class="input-group-addon"><cf_wrk_date_image date_field="date2"></span>
								</div>
							</div>
						</div>
					</div>
					<div class="form-group" id="item-work_date1">
						<label class="col col-12"><cf_get_lang dictionary_id='55753.Çalışma Günü'> <cf_get_lang dictionary_id="47800.Başlangıç - Bitiş"></label>
						<div class="col col-12">
							<div class="col col-6">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='55753.Çalışma Günü'> <cf_get_lang dictionary_id='57738.Başlangıç tarihi Girmelisiniz'></cfsavecontent>
									<cfinput value="#attributes.work_date1#"  validate="#validate_style#" message="#message#" type="text" name="work_date1" id="work_date1">
									<span class="input-group-addon"><cf_wrk_date_image date_field="work_date1"></span>
								</div>
							</div>
							<div class="col col-6">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id='55753.Çalışma Günü'> <cf_get_lang dictionary_id='57739.Bitiş tarihi Girmelisiniz'></cfsavecontent>
									<cfinput value="#attributes.work_date2#"  validate="#validate_style#" message="#message#" type="text" name="work_date2" id="work_date2">
									<span class="input-group-addon"><cf_wrk_date_image date_field="work_date2"></span>
								</div>
							</div>
						</div>
					</div>
				</div>
			</cfif>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
				<div class="form-group" id="item-related_company">
					<label class="col col-12"><cf_get_lang dictionary_id='53701.İlgili Şirket'></label>
					<div class="col col-12">
						<select name="related_company" id="related_company">
							<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							<cfoutput query="get_related_companies">
								<option value="#related_company#" <cfif isdefined('attributes.related_company') and len(attributes.related_company) and (attributes.related_company is related_company)>selected</cfif>>#related_company#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-off_validate">
					<label class="col col-12"><cf_get_lang dictionary_id='58054.Süreç Aşama'></label>
					<div class="col col-12">
						<select name="filter_process" id="filter_process">
							<option value="" ><cf_get_lang dictionary_id ="57734.SEÇİNİZ"></option>
							<cfoutput query="get_process"> 
								<option value="#process_row_id#" <cfif isdefined("attributes.filter_process") and (process_row_id eq attributes.filter_process)>selected</cfif>><cfif Len(stage_code)>#stage_code# - </cfif>#stage#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-shift_status">
					<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='30866.Mesai'><cf_get_lang dictionary_id='42004.Karşılığı'></label>
					<div class="col col-12 col-xs-12">                   
						<select name="shift_status" id="shift_status">
							<option value=""><cf_get_lang Dictionary_id='57734.Seçiniz'></option>
							<option value="1" <cfif attributes.shift_status eq 1> selected</cfif>><cf_get_lang dictionary_id='38380.Serbest'><cf_get_lang dictionary_id='41697.Zaman'></option>
							<option value="2" <cfif attributes.shift_status eq 2> selected</cfif>><cf_get_lang dictionary_id='59683.Ucret eklensin'></option>
						</select>
					</div>
				</div>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-branch_id">
					<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
					<div class="col col-12">
						<select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
							<option value="all"><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							<cfoutput query="get_our_comp_and_branchs">
								<option value="#branch_id#" <cfif isdefined('attributes.branch_id') and (attributes.branch_id eq branch_id)>selected</cfif>>#BRANCH_NAME#</option>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group">
					<label><cf_get_lang dictionary_id='60286.Toplu Belge No'></label>
					<cfoutput><input type="text" name="group_paper_no" id="group_paper_no" placeholder="#getLang('','Toplu Belge No','60286')#" value="#attributes.group_paper_no#" /></cfoutput>
				</div>
			</div>
			<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
				<div class="form-group" id="item-department">
					<label class="col col-12"><cf_get_lang dictionary_id='57572.departman'></label>
					<div class="col col-12">
						<select name="department" id="department">
							<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
							<cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
								<cfquery name="get_departmant" datasource="#dsn#">
									SELECT * FROM DEPARTMENT WHERE DEPARTMENT_STATUS = 1 AND BRANCH_ID = #attributes.branch_id# ORDER BY DEPARTMENT_HEAD
								</cfquery>
								<cfoutput query="get_departmant">
									<option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department') and (attributes.department eq get_departmant.DEPARTMENT_ID)>selected</cfif>>#DEPARTMENT_HEAD#</option>
								</cfoutput>
							</cfif>
						</select>
					</div>
				</div>
				<cfif is_extwork_type eq 1>
					<div class="form-group" id="item-working_space">
						<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='32327.Çalışmak istediği yer'></label>
						<div class="col col-12 col-xs-12">                   
							<select name="working_space" id="working_space">
								<option value=""><cf_get_lang Dictionary_id='57734.Seçiniz'></option>
								<option value="1" <cfif attributes.working_space eq 1>selected</cfif>><cf_get_lang Dictionary_id='38672.Kurum İçi'></option>
								<option value="2" <cfif attributes.working_space eq 2>selected</cfif>><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='38447.Şehir İçi'></option>
								<option value="3" <cfif attributes.working_space eq 3>selected</cfif>><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='38448.Yurt İçi'></option>
								<option value="4" <cfif attributes.working_space eq 4>selected</cfif>><cf_get_lang dictionary_id='38449.Kurum Dışı'><cf_get_lang dictionary_id='39476.Yurt Dışı'></option>
							</select>
						</div>
					</div>
				</cfif>
			</div>
		</cf_box_search_detail>
	</cfform>
</cf_box>
<cfform name="setProcessForm" id="setProcessForm" method="post" action="">
	<cfsavecontent variable="title"><cf_get_lang dictionary_id="52970.Fazla Mesailer"></cfsavecontent>
	<cf_box id="ext_worktimes_list" title="#title#" uidrop="1" hide_table_column="1"> 
		<cf_grid_list> 
			<thead>
				<tr>
					<th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th><cf_get_lang dictionary_id='54265.TC No'></td> 
					<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
					<th><cf_get_lang dictionary_id='57453.Şube'></th>
					<th><cf_get_lang dictionary_id='57572.Departman'></th>
					<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
					<cfif is_extwork_type eq 0>
						<th><cf_get_lang dictionary_id="58472.Dönem"></th>
						<th><cf_get_lang dictionary_id="58724.Ay"></th>
						<th><cf_get_lang dictionary_id='53014.Normal Gün'></th>
						<th><cf_get_lang dictionary_id='53015.Hafta Sonu'></th>
						<th><cf_get_lang dictionary_id='53016.Resmi Tatil'></th>
						<th><cf_get_lang dictionary_id='54251.Gece Çalışması'></th>
					</cfif>
					<cfif is_extwork_type eq 1>
						<th><cf_get_lang dictionary_id='32327.Çalışmak istediği yer'></th>
						<th width="65"><cf_get_lang dictionary_id='55753.Çalışma Günü'></th>
						<th width="40"><cf_get_lang dictionary_id='55538.Çalışma Başlangıç'></th>
						<th width="40"><cf_get_lang dictionary_id='55555.Çalışma Bitiş'></th>
						<th width="65"><cf_get_lang dictionary_id='57742.Tarih'></th>
						<th width="40"><cf_get_lang dictionary_id='57501.Başlangıç'></th>
						<th width="40"><cf_get_lang dictionary_id='57502.Bitiş'></th>
						<th width="70"><cf_get_lang dictionary_id='54049.Fark (Dk)'></th>
						<th width="100"><cf_get_lang dictionary_id='53589.Fazla Mesai Ücret'></th>
						<cfif is_planing_salary eq 1>
							<th width="100"><cf_get_lang dictionary_id='53494.Planlanan Ücret'></th>
						</cfif>
						<th width="40">P</th>
						<th width="80"><cf_get_lang dictionary_id='58651.Türü'></th>
						<th><cf_get_lang dictionary_id='30866.Mesai'><cf_get_lang dictionary_id='42004.Karşılığı'></th>
						<th width="65"><cf_get_lang dictionary_id='36199.Açıklama'></th>
					</cfif>
					
					<th width="65"><cf_get_lang dictionary_id='57483.Kayıt'></th>
					<cfif is_extwork_type eq 1>
						<th><cf_get_lang dictionary_id = "41129.Süreç/Aşama"></th>
					</cfif>
					<cfif fusebox.circuit is 'ehesap'>
						<!-- sil -->  
						<th class="header_icn_none">
							<cfif is_extwork_type eq 1>
								<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_ext_worktimes&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='53018.Çalışan Fazla Mesai Süresi Ekle'>"></i></a>
							<cfelse>
								<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_ext_worktimes&event=add','medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='30965.Toplu Fazla Mesai'>"></i></a>
							</cfif>
						</th>
						<!-- sil -->
					</cfif>
					<cfif fusebox.circuit is 'ehesap' and is_extwork_type eq 1 and len(attributes.filter_process)>
						<th nowrap="nowrap" class="header_icn_none"><input type="checkbox" name="allSelecthemand" id="allSelecthemand" onClick="wrk_select_all('allSelecthemand','row_demand_accept');"></th>
					</cfif>
				</tr>
			</thead>
			<cfset mesai_farki = 0>
			<cfset aylik_maas_birim = 0>
			<cfparam name="attributes.totalrecords" default="#get_ext_worktimes.recordcount#">
			<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
			<cfquery name="get_our_company_hours" datasource="#dsn#">
				SELECT SSK_MONTHLY_WORK_HOURS SSK_AYLIK_MAAS,DAILY_WORK_HOURS AS GUNLUK_SAAT FROM OUR_COMPANY_HOURS WHERE OUR_COMPANY_ID = #session.ep.company_id#
			</cfquery>
			<cfif get_ext_worktimes.recordcount>
				<cfset sayfa_dakika = 0>
				<cfset sayfa_tutar = 0>
				<cfset sayfa_tutar_planlanan = 0>
				<cfset overtime_value_0_total = 0>
				<cfset overtime_value_1_total = 0>
				<cfset overtime_value_2_total = 0>
				<cfset overtime_value_3_total = 0>
				<tbody>
					<cfoutput query="get_ext_worktimes" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<cfif is_extwork_type eq 1>
						<cfquery name="get_salary_month" datasource="#dsn#">
							SELECT TOP 1 
								ES.MONEY, 
								ES.M#month(start_time)# AYLIK_MAAS,
								EIO.SALARY_TYPE
							FROM 
								EMPLOYEES_SALARY ES,
								EMPLOYEES_IN_OUT EIO
							WHERE 
								ES.IN_OUT_ID = EIO.IN_OUT_ID AND
								ES.PERIOD_YEAR = #session.ep.period_year# AND 
								ES.EMPLOYEE_ID = #employee_id# AND 
								EIO.IN_OUT_ID = #in_out_id#
						</cfquery>
						<cfif is_planing_salary eq 1 and is_puantaj_off eq 1>
							<cfquery name="get_salary_month_plan" datasource="#dsn#">
								SELECT TOP 1 
									ES.MONEY, 
									ES.M#month(start_time)# AYLIK_MAAS,
									EIO.SALARY_TYPE
								FROM 
									EMPLOYEES_SALARY_PLAN ES,
									EMPLOYEES_IN_OUT EIO
								WHERE 
									ES.IN_OUT_ID = EIO.IN_OUT_ID AND
									ES.PERIOD_YEAR = #session.ep.period_year# AND 
									ES.EMPLOYEE_ID = #employee_id#
							</cfquery>
						</cfif>
						<cfset attributes.sal_mon = MONTH(START_TIME)>
						<cfset attributes.sal_year = YEAR(START_TIME)>
						<cfset attributes.group_id = "">
						<cfif len(get_ext_worktimes.puantaj_group_ids)>
							<cfset attributes.group_id = "#get_ext_worktimes.PUANTAJ_GROUP_IDS#,">
						</cfif>
						<cfset attributes.branch_id = get_ext_worktimes.branch_id>
						<cfset not_kontrol_parameter = 1>
						<cfinclude template="../query/get_program_parameter.cfm">
						</cfif>
						<tr>
						<td>#currentrow#</td>
						<td><cf_duxi type="label" name="TC_IDENTY_NO" id="TC_IDENTY_NO" value="#TC_IDENTY_NO#" hint="TC Kimlik No" gdpr="2"></td>
						<td><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" class="tableyazi">#employee_name# #employee_surname#</a></td>
						<td>#BRANCH_NAME#</td>
						<td>#DEPARTMENT_HEAD#</td>
						<td>#position_name#</td>
						
						<cfif is_extwork_type eq 0>
						<td>#overtime_period#</td>
						<td>#listgetat(ay_list(),overtime_month,',')#</td>
						<td class="text-right">#overtime_value_0#<cfset overtime_value_0_total = overtime_value_0_total+overtime_value_0></td>
						<td class="text-right">#overtime_value_1#<cfset overtime_value_1_total = overtime_value_1_total+overtime_value_1></td>
						<td class="text-right">#overtime_value_2#<cfset overtime_value_2_total = overtime_value_2_total+overtime_value_2></td>
						<td class="text-right">#overtime_value_3#<cfset overtime_value_3_total = overtime_value_3_total+overtime_value_3></td>
						</cfif>
						<cfif is_extwork_type eq 1>
							<td>
								<cfif working_space eq 1>
									<cf_get_lang Dictionary_id='38672.Kurum İçi'>
								<cfelseif working_space eq 2>
									<cf_get_lang dictionary_id='38449.Kurum Dışı'>-<cf_get_lang dictionary_id='38447.Şehir İçi'>
								<cfelseif working_space eq 3>
									<cf_get_lang dictionary_id='38449.Kurum Dışı'>-<cf_get_lang dictionary_id='38448.Yurt İçi'>
								<cfelseif working_space eq 4>
									<cf_get_lang dictionary_id='38449.Kurum Dışı'>-<cf_get_lang dictionary_id='39476.Yurt Dışı'>
								</cfif>
							</td>
							<td>#dateformat(WORK_START_TIME,dateformat_style)#</td>
							<td>#TIMEFORMAT(WORK_START_TIME,timeformat_style)#</td>
							<td>#TIMEFORMAT(WORK_END_TIME,timeformat_style)#</td>
							<td>#dateformat(START_TIME,dateformat_style)#</td>
							<td>#TIMEFORMAT(START_TIME,timeformat_style)#</td>
							<td>#TIMEFORMAT(END_TIME,timeformat_style)#</td>
							<td>#datediff("n",START_TIME,END_TIME)#</td>
							<cfif get_program_parameters.recordcount>
								<cfif is_planing_salary eq 1 and is_puantaj_off eq 1 and get_salary_month_plan.recordcount and len(get_salary_month_plan.aylik_maas) and len(get_our_company_hours.ssk_aylik_maas)>
									<cfif get_salary_month_plan.SALARY_TYPE eq 0>
										<cfset aylik_maas_birim = get_salary_month_plan.aylik_maas>
									<cfelseif get_salary_month.SALARY_TYPE eq 1> 
										<cfset aylik_maas_birim = get_salary_month_plan.aylik_maas / get_our_company_hours.gunluk_saat>
									<cfelse>
										<cfset aylik_maas_birim = get_salary_month_plan.aylik_maas/get_our_company_hours.ssk_aylik_maas>
									</cfif>
								<cfelse>
									<cfif get_salary_month.recordcount and len(get_salary_month.aylik_maas) and len(get_our_company_hours.ssk_aylik_maas)>
										<cfif get_salary_month.SALARY_TYPE eq 0>
											<cfset aylik_maas_birim = get_salary_month.aylik_maas>
										<cfelseif get_salary_month.SALARY_TYPE eq 1> 
											<cfset aylik_maas_birim = get_salary_month.aylik_maas / get_our_company_hours.gunluk_saat>
										<cfelse>
											<cfset aylik_maas_birim = get_salary_month.aylik_maas/get_our_company_hours.ssk_aylik_maas>
										</cfif>
									<cfelse>
										<cfset aylik_maas_birim = 0>	
									</cfif>
								</cfif>
									<!---Muzaffer Bas--->
								<cfif day_type eq 0>
									<cfif len(get_program_parameters.EX_TIME_PERCENT_HIGH)>
										<cfif datediff("n",START_TIME,END_TIME) lte get_program_parameters.EX_TIME_LIMIT>
											<cfset mesai_turu = get_program_parameters.EX_TIME_PERCENT/100>
										<cfelse>
											<cfset mesai_turu = get_program_parameters.EX_TIME_PERCENT_HIGH/100>
										</cfif>
										
									<cfelse>
										<cfset mesai_turu = 1.5>
									</cfif>
								<cfelseif day_type eq 1>
									<cfif len(get_program_parameters.WEEKEND_MULTIPLIER)>
										<cfset mesai_turu = get_program_parameters.WEEKEND_MULTIPLIER>
									<cfelse>
										<cfset mesai_turu = get_program_parameters.EX_TIME_PERCENT_HIGH/100>
									</cfif>
								<cfelseif day_type eq 2>
									<cfif len(get_program_parameters.OFFICIAL_MULTIPLIER)>
										<cfset mesai_turu = get_program_parameters.OFFICIAL_MULTIPLIER>
									<cfelse>
										<cfset mesai_turu = 1>
									</cfif>
								<cfelseif day_type eq 3>
									<cfif len(get_program_parameters.NIGHT_MULTIPLIER)>
										<cfset mesai_turu = get_program_parameters.NIGHT_MULTIPLIER>
									</cfif>
								<cfelseif day_type eq -8>
									<cfif len(get_program_parameters.WEEKEND_DAY_MULTIPLIER)>
										<cfset mesai_turu = get_program_parameters.WEEKEND_DAY_MULTIPLIER>
										
									<cfelse>
										<cfset mesai_turu = get_program_parameters.EX_TIME_PERCENT_HIGH/100>
									</cfif>

									<cfelseif day_type eq -9>
										<cfif len(get_program_parameters.AKDI_DAY_MULTIPLIER)>
											<cfset mesai_turu = get_program_parameters.AKDI_DAY_MULTIPLIER>
										<cfelse>
											<cfset mesai_turu = get_program_parameters.EX_TIME_PERCENT_HIGH/100>
										</cfif>
									<cfelseif day_type eq -10>
										<cfif len(get_program_parameters.OFFICIAL_DAY_MULTIPLIER)>
											<cfset mesai_turu = get_program_parameters.OFFICIAL_DAY_MULTIPLIER>
										<cfelse>
											<cfset mesai_turu = 1>
										</cfif>
									<cfelseif day_type eq -11>
										<cfif len(get_program_parameters.ARAFE_DAY_MULTIPLIER)>
											<cfset mesai_turu = get_program_parameters.ARAFE_DAY_MULTIPLIER>
										<cfelse>
											<cfset mesai_turu = 1>
										</cfif>
									<cfelseif day_type eq -12>
										<cfif len(get_program_parameters.DINI_DAY_MULTIPLIER)>
											<cfset mesai_turu = get_program_parameters.OFFICIAL_DAY_MULTIPLIER>
										<cfelse>
										
										<cfset mesai_turu = 10/100>
									</cfif>
								</cfif>
								<!---Muzaffer Bit--->
								<cfset mesai_farki = datediff("n",START_TIME,END_TIME)/60>
								<cfset odenecek = aylik_maas_birim * mesai_turu * mesai_farki>
								<cfset para_birimi = get_salary_month.money>
								<cfset sayfa_dakika = sayfa_dakika + datediff("n",START_TIME,END_TIME)>
								<cfif is_planing_salary eq 1 and is_puantaj_off eq 1>
									<cfset sayfa_tutar_planlanan = sayfa_tutar_planlanan + odenecek>
								<cfelse>
									<cfset sayfa_tutar = sayfa_tutar + odenecek>
								</cfif>
							<cfelse>
								<cfset odenecek = 0>
								<cfset para_birimi = 'TL'>
							</cfif>
							<td class="text-right">
								<cfif is_planing_salary eq 1 and is_puantaj_off eq 1>-<cfelse><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(odenecek)# #para_birimi#"></cfif>
							</td>
								<cfif is_planing_salary eq 1>
									<td class="text-right">
										<cfif is_puantaj_off eq 1>#TLFormat(odenecek)# #para_birimi#<cfelse>-</cfif>
									</td>
								</cfif>
								<td><cfif is_puantaj_off eq 1><strike>&nbsp;P</strike></cfif></td>
								<td>
									<cfif day_type eq 0>
										<cf_get_lang dictionary_id='53014.Normal Gün'>
									<cfelseif day_type eq 1>
										<cf_get_lang dictionary_id='53015.Hafta Sonu'>
									<cfelseif day_type eq 2>
										<cf_get_lang dictionary_id='53016.Resmi Tatil'>
									<cfelseif day_type eq 3>
										<cf_get_lang dictionary_id='54251.Gece Çalışması'>
									<cfelseif  day_type eq -8>
										<cf_get_lang dictionary_id='58867.Hafta Tatili'> - <cf_get_lang dictionary_id='57490.Gün'>
									<cfelseif day_type eq -9>
										<cf_get_lang dictionary_id='65393.Akdi Tatil'> - <cf_get_lang dictionary_id='57490.Gün'>
									<cfelseif day_type eq -10>
										<cf_get_lang dictionary_id='56022.Resmi Tatil'> - <cf_get_lang dictionary_id='57490.Gün'>
									<cfelseif day_type eq -11>
										<cf_get_lang dictionary_id='65394.Arefe Tatil'> - <cf_get_lang dictionary_id='57490.Gün'>
									<cfelseif day_type eq -12>
										<cf_get_lang dictionary_id='65395.Dini Bayram'> - <cf_get_lang dictionary_id='57490.Gün'>		
									</cfif>
								</td>
								<td>
									<cfif WORKTIME_WAGE_STATU eq 1><cf_get_lang dictionary_id='38380.Serbest'><cf_get_lang dictionary_id='41697.Zaman'></cfif>
									<cfif WORKTIME_WAGE_STATU eq 2><cf_get_lang dictionary_id='59683.Ucret eklensin'></cfif>
								</td>
								<td>#valid_detail#</td>
							</cfif>
							<td>#dateformat(RECORD_DATE,dateformat_style)#</td>
							<cfif is_extwork_type eq 1>
								<td id="valid_status_#EWT_ID#">
									<cf_workcube_process type="color-status" process_stage="#PROCESS_STAGE#" fuseaction="ehesap.list_ext_worktimes">
								</td>
							</cfif>
							
							<cfif fusebox.circuit is 'ehesap'>
								<!-- sil -->
								<td align="center" id="fm_row_td_#EWT_ID#" nowrap="nowrap">
									<div style="display:;" id="fm_row_#EWT_ID#"></div>
									<!---<cfsavecontent variable="message">Fazla Mesai Siliyorsunuz! Emin misiniz?</cfsavecontent>--->
									<cfif is_extwork_type eq 1>
										<a href="#request.self#?fuseaction=ehesap.list_ext_worktimes&event=upd&EWT_ID=#EWT_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='53019.Çalışan Fazla Mesai Süresi Güncelle'>"></i></a>
									<cfelse>
										<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_form_upd_all_overtime&EWT_ID=#EWT_ID#&overtime_id=#EWT_ID#','medium');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='30965.Toplu Fazla Mesai'> <cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
									</cfif>
									<!---<a href="javascript://" onClick="if(confirm('#message#')) AjaxPageLoad('#request.self#?fuseaction=ehesap.emptypopup_del_ext_worktime&EWT_ID=#EWT_ID#','fm_row_#EWT_ID#',1,'Siliniyor',''); else return false;"><img src="/images/delete_list.gif" title="Sil"></a>--->
								</td>
								<!-- sil -->
							</cfif>
							<!---20131026 GSO--->
							<cfif fusebox.circuit is 'ehesap' and is_extwork_type eq 1 and len(attributes.filter_process)>
								<td class="text-center">
									<input type="checkbox" name="row_demand_accept" id="row_demand_accept" value="#EMPLOYEE_ID#;#VALID#;#EWT_ID#">
								</td>
							</cfif>
							<!---20131026 GSO--->
						</tr>
					</cfoutput> 
				</tbody>
				
			<cfelse>
				<tbody>
					<tr> 
						<td colspan="22"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
					</tr>
				</tbody>
			</cfif>
		</cf_grid_list>
		<cfif get_ext_worktimes.recordcount>
			<cf_box_footer>
				<cfoutput>
					<cfif is_extwork_type eq 1>
					<tr>
						<td class="txtbold" colspan="9"  style="text-align:right;"><cf_get_lang dictionary_id='53263.Toplamlar'></td>
						<td class="txtbold">#sayfa_dakika# <cf_get_lang dictionary_id='58127.Dakika'> <br/>(#int(sayfa_dakika/60)# <cf_get_lang dictionary_id='57491.saat'> <cfif sayfa_dakika gt (int(sayfa_dakika/60)*60)>#sayfa_dakika - (int(sayfa_dakika/60) * 60)#</cfif> dk)</td>
						<td class="txtbold" style="text-align:right;"><cf_wrk_crypto_gdpr mode="3" pattern="3" sensitive_label="7" data="#tlformat(sayfa_tutar)#"></td>
						<cfif is_planing_salary eq 1><td class="txtbold" style="text-align:right;">#tlformat(sayfa_tutar_planlanan)#</td></cfif>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<cfif fusebox.circuit is 'ehesap'>
							<td></td>
						</cfif>
						<!-- sil --><td></td><!-- sil -->
					</tr>
					</cfif>
					<!---<cfif fusebox.circuit is 'ehesap' and is_extwork_type eq 1>>
						<tr height="25">
							<td colspan="21" style="text-align:right;">
								<cfinput value="" validate="#validate_style#" type="text" name="puantaj_date" id="puantaj_date" style="width:75px;">
								<cf_wrk_date_image date_field="puantaj_date">
								<input type="button" name="onayBtn" id="onayBtn" value="<cf_get_lang dictionary_id='58475.Onayla'>" onclick="FazlaMesaiOnay();">
								<input type="button" name="silBtn" id="silBtn" value="<cf_get_lang dictionary_id='57463.Sil'>" onclick="FazlaMesaiSil();">
								<input type="hidden" name="id_list" id="id_list" value="">
								<input type="hidden" name="ext_worktime_app" id="ext_worktime_app" value="">
							</td>
						</tr>
					</cfif>---><!---20131026 GSO--->
					<cfif is_extwork_type eq 0>
						<tr>
							<td colspan="8" class="text-right"><cf_get_lang dictionary_id='53263.Toplamlar'></td>                    
							<td class="text-right">#overtime_value_0_total#</td>
							<td class="text-right">#overtime_value_1_total#</td>
							<td class="text-right">#overtime_value_2_total#</td>
							<td class="text-right">#overtime_value_3_total#</td>
							<td colspan="2"></td>
						</tr>
					</cfif>
				</cfoutput>
			</cf_box_footer>
		</cfif>
		<cf_paging
			name="setProcessForm"
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="#url_str#"
			is_form="1">
	</cf_box>
	<cfif isdefined("attributes.form_submit") and len(attributes.form_submit) and len(attributes.filter_process)>
		<cf_box id="list_checked" title="#getLang('','',46186)#">
			<div class="row" type="row">
				<div class="col col-4 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-responsible_employee_id">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="60723.Bordro tarihi"></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfinput value="" validate="#validate_style#" type="text" name="puantaj_date" id="puantaj_date">
								<span class="input-group-addon"><cf_wrk_date_image date_field="puantaj_date"></span>
							</div>
						</div>
					</div>
					<cfset get_process_f = cmp_process.GET_PROCESS_TYPES(
						faction_list : 'ehesap.list_ext_worktimes',
						filter_stage: '#isdefined("attributes.filter_process") and len(attributes.filter_process) ? "#attributes.filter_process#" : ""#')>

						<cf_workcube_general_process print_type="175" select_value = '#get_process_f.process_row_id#'>	
				</div>
			</div>
			<cf_box_footer>
				<div class="col col-12 col-xs-12 text-right">
					<cfif fusebox.circuit is 'ehesap' and is_extwork_type eq 1>
						<tr height="25">
							<td colspan="21" class="text-right">
								<input type="button" name="onayBtn" id="onayBtn" value="<cf_get_lang dictionary_id='58475.Onayla'>" onclick="FazlaMesaiOnay();">
								<input type="button" name="silBtn" id="silBtn" value="<cf_get_lang dictionary_id='57463.Sil'>" onclick="FazlaMesaiSil();">
								<input type="hidden" name="id_list" id="id_list" value="">
								<input type="hidden" name="ext_worktime_app" id="ext_worktime_app" value="">
							</td>
						</tr>
					</cfif>
				</div>
			</cf_box_footer>
		</cf_box>
	</cfif>
</cfform>
<script type="text/javascript">
	document.getElementById('keyword').focus();
	function showDepartment(branch_id)	
	{
		var branch_id = document.getElementById('branch_id').value;
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'item-department',1,'İlişkili Departmanlar');
		}
	}
	function FazlaMesaiOnay(){
		var is_selected=0;
		if( $.trim($('#general_paper_no').val()) == '' ){
			alert("<cf_get_lang dictionary_id='33367.Lütfen Belge No Giriniz'>");
			return false;
		}else{
			paper_no_control = wrk_safe_query('general_paper_control','dsn',0,$('#general_paper_no').val());
			if(paper_no_control.recordcount > 0)
			{
            	alert("<cf_get_lang dictionary_id='49009.Girdiğiniz Belge Numarası Kullanılmaktadır'>.<cf_get_lang dictionary_id='59367.Otomatik olarak değişecektir'>.");
				paper_no_val = $('#general_paper_no').val();
				paper_no_split = paper_no_val.split("-");
				if(paper_no_split.length == 1)
					paper_no = paper_no_split[0];
				else
					paper_no = paper_no_split[1];
				paper_no = parseInt(paper_no);
				paper_no++;
				if(paper_no_split.length == 1)
					$('#general_paper_no').val(paper_no);
				else
					$('#general_paper_no').val(paper_no_split[0]+"-"+paper_no);
				return false;
			}
		}
		if(document.getElementsByName('row_demand_accept').length > 0){
			var id_list="";
			if(document.getElementsByName('row_demand_accept').length ==1){
				if(document.getElementById('row_demand_accept').checked==true){
					is_selected=1;
					id_list+=document.setProcessForm.row_demand_accept.value+',';
				}
			} else {
				for (i=0;i<document.getElementsByName('row_demand_accept').length;i++){
					if(document.setProcessForm.row_demand_accept[i].checked==true){ 
						id_list+=document.setProcessForm.row_demand_accept[i].value+',';
						is_selected=1;
					}
				}
			}
		}
		if(is_selected==1){
			if(list_len(id_list,',') > 1){
				id_list = id_list.substr(0,id_list.length-1);
				document.getElementById('id_list').value=id_list;
				document.getElementById('ext_worktime_app').value=1;
				ext_worktime_app_ = document.getElementById('ext_worktime_app').value;
				if(confirm("<cf_get_lang dictionary_id='57535.Kaydetmek İstediğinizden Emin Misiniz?'> ?")){
					setProcessForm.action='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_app_ext_worktimes&fsactn=#attributes.fuseaction##url_str#</cfoutput>&id_list='+document.getElementById('id_list').value;
					setProcessForm.submit();
				}
			}
		} else {
			alert("<cf_get_lang dictionary_id='54563.En az bir satır seçmelisiniz'>.");
			return false;
		}
	}
	function FazlaMesaiSil(){
		var is_selected=0;
		if(document.getElementsByName('row_demand_accept').length > 0){
			var id_list="";
			if(document.getElementsByName('row_demand_accept').length ==1){
				if(document.getElementById('row_demand_accept').checked==true){
					is_selected=1;
					id_list+=document.setProcessForm.row_demand_accept.value+',';
				}
			} else {
				for (i=0;i<document.getElementsByName('row_demand_accept').length;i++){
					if(document.setProcessForm.row_demand_accept[i].checked==true){ 
						id_list+=document.setProcessForm.row_demand_accept[i].value+',';
						is_selected=1;	
					}
				}
			}
		}
		if(is_selected==1){
			if(list_len(id_list,',') > 1){
				id_list = id_list.substr(0,id_list.length-1);
				document.getElementById('id_list').value=id_list;
				document.getElementById('ext_worktime_app').value=1;
				ext_worktime_app_ = document.getElementById('ext_worktime_app').value;
				get_search_form = $("#myform").serialize();
				if(confirm("Fazla Mesaileri Siliyorsunuz! Emin misiniz?")){
					setProcessForm.action='<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_del_ext_worktimes&fsactn=#attributes.fuseaction#</cfoutput>&id_list='+document.getElementById('id_list').value+'&'+get_search_form;
					setProcessForm.submit();
				}
			}
		} else {
			alert("<cf_get_lang dictionary_id='54563.En az bir satır seçmelisiniz'>.");
			return false;
		}
	}
</script>
<cf_get_lang_set module_name="#fusebox.circuit#">
