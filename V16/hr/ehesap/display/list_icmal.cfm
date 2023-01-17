<!--- TODO: workdevden xml tanımı yapılacak. --->
<cf_xml_page_edit fuseact="ehesap.list_icmal">
<cfprocessingdirective suppresswhitespace="Yes">

<cfset cmp_process = createObject('component','V16.workdata.get_process')>

<cfset getPrintTemplate = createObject("component","cfc.get_print_template")>
<cfset get_templates = getPrintTemplate.GET(print_type : 180)>

<cfparam name="attributes.filter_process" default="">
<cfparam name="attributes.general_paper_tempate" default="">
<cfparam name="attributes.form_type" default="">

<cfif len(attributes.general_paper_tempate)>
	<cfset attributes.form_type = attributes.general_paper_tempate>
</cfif>
<cfif isdefined("attributes.paper_submit") and len(attributes.paper_submit) and attributes.paper_submit eq 1>
	<cfset totalValues = structNew()>
	<cfset totalValues = {
			total_offtime : 0
		}>
	<cfif IsDefined('attributes.comp_id') and len(attributes.comp_id)>
		<cfset url_str="#url_str#&comp_id=#attributes.comp_id#">
	</cfif>
	<cfset action_list_id = '1'>
	<cf_workcube_general_process
		mode = "query"
		general_paper_parent_id = "#(isDefined("attributes.general_paper_parent_id") and len(attributes.general_paper_parent_id)) ? attributes.general_paper_parent_id : 0#"
		general_paper_no = "#attributes.general_paper_no#"
		general_paper_date = "#attributes.general_paper_date#"
		action_list_id = "#action_list_id#"
		process_stage = "#attributes.process_stage#"
		general_paper_notice = "#attributes.general_paper_notice#"
		responsible_employee_id = "#(isDefined("attributes.responsible_employee_id") and len(attributes.responsible_employee_id) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_id : 0#"
		responsible_employee_pos = "#(isDefined("attributes.responsible_employee_pos") and len(attributes.responsible_employee_pos) and isDefined("attributes.responsible_employee") and len(attributes.responsible_employee)) ? attributes.responsible_employee_pos : 0#"
		action_table = 'EMPLOYEES_PUANTAJ'
		action_column = 'PUANTAJ_ID'
		action_page = '#request.self#?fuseaction=ehesap.list_icmal'
		total_values = '#totalValues#'
	>
	<cfset attributes.approve_submit = 0>
</cfif>

<cfscript>
	function saDk(veri) // Bu fonksiyon saat olarak gelen değeri, Saat:Dakika formatına çevirir.
	{
		saat = ListGetAt(veri, 1, ".");
		dakika = "00";
		if (ListLen(veri, ".") eq 2)
			dakika = Int(ListGetAt(veri, 2, ".") * 60 / 100);
		return saat & ":" & dakika;
	}
	if (fusebox.use_period)
		center_dsn = dsn2_alias;
	else
		center_dsn = dsn_alias;
</cfscript>
<!-- sil -->
<script type="text/javascript">
	function get_department_list()
	{
	<cfif isdefined("attributes.department") and listlen(attributes.department)>
		dept_list = '<cfoutput>#attributes.department#</cfoutput>';
	<cfelse>
		dept_list = '';
	</cfif>
		document.getElementById('department').options.length = 0;
		var document_id = document.getElementById('branch_id').options.length;	
		var document_name = '';
		for(i=0;i<document_id;i++)
			{
				if(document.employee.branch_id.options[i].selected && document_name.length==0)
					document_name = document_name + document.employee.branch_id.options[i].value;
				else if(document.employee.branch_id.options[i].selected)
					document_name = document_name + ',' + document.employee.branch_id.options[i].value;
			}
		var get_department_name = wrk_safe_query('hr_get_department_name','dsn',0,document_name);
		document.employee.department.options[0]=new Option("<cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'>",'0')
		if(get_department_name.recordcount != 0) 
		{
			for(var xx=0;xx<get_department_name.recordcount;xx++)
			{
				document.employee.department.options[xx+1]=new Option(get_department_name.DEPARTMENT_HEAD[xx],get_department_name.DEPARTMENT_ID[xx]);
				document.employee.department.options[xx+1].title = get_department_name.DEPARTMENT_HEAD[xx];
				if(dept_list != '' && list_find(dept_list,get_department_name.DEPARTMENT_ID[xx]))
					document.employee.department.options[xx+1].selected = true;	
			}
		}
	}
	function change_mon(i)
	{
		$('#sal_mon_end').val(i);
	}
</script>
<cf_get_lang_set module_name="ehesap">
<cfquery name="get_ssk_offices" datasource="#dsn#">
	SELECT
		B.BRANCH_ID,
		B.BRANCH_NAME,	
		B.BRANCH_FULLNAME,	
		B.SSK_OFFICE,
		B.COMPANY_ID,
		B.SSK_NO,
		B.BRANCH_TAX_NO,
		O.NICK_NAME,
		B.BRANCH_TAX_OFFICE
	FROM
		BRANCH B,
		OUR_COMPANY O
	WHERE
		B.COMPANY_ID = O.COMP_ID AND
		B.SSK_NO IS NOT NULL AND
		B.BRANCH_STATUS =1 AND
		B.SSK_OFFICE IS NOT NULL AND
		B.SSK_BRANCH IS NOT NULL AND
		B.SSK_NO <> '' AND
		B.SSK_OFFICE <> '' AND
		B.SSK_BRANCH <> ''
		<cfif not session.ep.ehesap>
		AND B.BRANCH_ID IN (
                            SELECT
                                BRANCH_ID
                            FROM
                                EMPLOYEE_POSITION_BRANCHES
                            WHERE
                                EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                            )
		</cfif>
	ORDER BY
		O.NICK_NAME,
		O.COMP_ID,
		B.BRANCH_NAME,
		B.SSK_OFFICE
</cfquery>
<cfquery name="get_units" datasource="#DSN#">
	SELECT * FROM SETUP_CV_UNIT WHERE IS_ACTIVE=1 ORDER BY UNIT_NAME
</cfquery>
<cfinclude template="../query/get_code_cat.cfm">
<cfset periods = createObject('component','V16.objects.cfc.periods')>
<cfset period_years = periods.get_period_year()>
<cf_catalystHeader>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="employee" method="post">
			<input type="hidden" name="convert" id="convert"  value="">
			<cf_box_elements>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
					<div class="form-group" id="item-sal_mon">
						<label class="col col-4 col-xs-12">
							<cf_get_lang dictionary_id="58053.Başlangıç Tarihi">
						</label>
						<div class="col col-4 col-xs-12">
							<select name="sal_mon" id="sal_mon" onchange="change_mon(this.value);">
								<cfloop from="1" to="12" index="i">
									<cfoutput>
										<option value="#i#" <cfif (isdefined("attributes.sal_mon") and attributes.sal_mon eq i) or (not isdefined("attributes.sal_mon") and month(now()) gt 1 and i eq month(now())-1)>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
									</cfoutput>
								</cfloop>
							</select>
						</div>
						<div class="col col-4 col-xs-12">
							<select name="sal_year" id="sal_year">
								<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
									<cfoutput>
										<option value="#i#" <cfif (isdefined("attributes.sal_year") and attributes.sal_year eq i) or (not isdefined("attributes.sal_year") and #session.ep.period_year# eq i)>selected</cfif>>#i#</option>
									</cfoutput>
								</cfloop>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
					<div class="form-group" id="item-func_id">
						<label class="col col-4 col-xs-12">
							<cf_get_lang dictionary_id="58702.Fonksiyon Seçiniz">
						</label>
						<div class="col col-8 col-xs-12">
							<cfinput type="hidden" name="maxrows" value="20">
							<select name="func_id" id="func_id">
								<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<cfoutput query="get_units">
									<option value="#get_units.unit_id#" <cfif isdefined("attributes.func_id") and unit_id eq attributes.func_id>selected</cfif>>#unit_name#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
					<div class="form-group" id="item-sal_mon_end">
						<label class="col col-4 col-xs-12">
							<cf_get_lang dictionary_id="57700.Bitiş Tarihi">
						</label>
						<div class="col col-4 col-xs-12">
							<select name="sal_mon_end" id="sal_mon_end">
								<cfloop from="1" to="12" index="i">
									<cfoutput>
										<option value="#i#" <cfif (isdefined("attributes.sal_mon_end") and attributes.sal_mon_end eq i) or (not isdefined("attributes.sal_mon_end") and month(now()) gt 1 and i eq month(now())-1)>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
									</cfoutput>
								</cfloop>
							</select>
						</div>
						<div class="col col-4 col-xs-12">
							<select name="sal_year_end" id="sal_year_end">
								<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
									<cfoutput>
										<option value="#i#" <cfif (isdefined("attributes.sal_year_end") and attributes.sal_year_end eq i) or (not isdefined("attributes.sal_year_end") and #session.ep.period_year# eq i)>selected</cfif>>#i#</option>
									</cfoutput>
								</cfloop>
							</select>
						</div>
					</div>			
				</div>
				<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="4" sort="true">
					<div class="form-group" id="item-hierarchy">
						<label class="col col-4 col-xs-12">
							<cf_get_lang dictionary_id="55898.Hierarşi">
						</label>
						<div class="col col-8 col-xs-12">
							<input type="text" name="hierarchy" id="hierarchy" maxlength="50" value="<cfif isdefined("attributes.hierarchy")><cfoutput>#attributes.hierarchy#</cfoutput></cfif>">
						</div>
					</div>
				</div>
			</cf_box_elements>
			<cfsavecontent variable="message"><cf_get_lang dictionary_id="57904.Daha Fazlası"></cfsavecontent>
			<cf_seperator title="#message#" id="sep" is_designer="1" index="5" seperator_id="item_more_sep">
				<div class="row" type="row"  id="sep">
					<div class="col col-2 col-md-3 col-sm-6 col-xs-12 ui-form-list ui-form-block" type="column" index="6" sort="true">
						<div class="form-group" id="item-branch_id">
							<label class="bold"><cf_get_lang dictionary_id ='57453.Şube'></label>
							<select name="branch_id" id="branch_id" style="width:275px; height:75px;" multiple onChange="get_department_list(this.value)">
								<cfoutput query="get_ssk_offices" group="company_id">
									<optgroup label="#nick_name#"></optgroup>
									<cfoutput>
										<option value="#branch_id#" title="#BRANCH_NAME# (#ssk_office# - #ssk_no#)" <cfif isdefined("attributes.branch_id") and listlen(attributes.branch_id) and listfindnocase(attributes.branch_id,branch_id)>selected</cfif>>#BRANCH_NAME# (#ssk_office# - #ssk_no#)</option>
									</cfoutput>
								</cfoutput>
							</select>				
						</div>
					</div>
					<div class="col col-2 col-md-3 col-sm-6 col-xs-12 ui-form-list ui-form-block" type="column" index="7" sort="true">
						<div class="form-group" id="item-department">
							<label class="bold"><cf_get_lang dictionary_id ='57572.Departman'></label>
							<select name="department" id="department" style="width:150px; height:75px;" multiple>
								<option value="0"><cf_get_lang dictionary_id='58836.Lutfen Departman Seciniz'></option>
							</select>		
						</div>
					</div>
					<div class="col col-2 col-md-3 col-sm-6 col-xs-12 ui-form-list ui-form-block" type="column" index="8" sort="true">
						<div class="form-group" id="item-ssk_statute">
							<label class="bold"><cf_get_lang dictionary_id="53553.SGK Statüsü"></label>
							<select name="ssk_statute" id="ssk_statute" style="width:150px;height:75px;" multiple="multiple">
								<cfloop list="#list_ucret()#" index="i">
									<cfoutput><option value="#i#" title="#listgetat(list_ucret_names(),listfindnocase(list_ucret(),i,','),'*')#" <cfif isdefined("attributes.ssk_statute") and listlen(attributes.ssk_statute) and listfindnocase(attributes.ssk_statute,i)>selected</cfif>>#listgetat(list_ucret_names(),listfindnocase(list_ucret(),i,','),'*')#</option></cfoutput>
								</cfloop>
							</select>		
						</div>
					
					</div>
					<div class="col col-2 col-md-3 col-sm-6 col-xs-12 ui-form-list ui-form-block" type="column" index="9" sort="true">
						<div class="form-group" id="item-EXPENSE_CENTER">
							<label class="bold"><cf_get_lang dictionary_id="54256.Masraf Merkezleri"></label>
							<cfquery name="GET_EXPENSE_CENTER" datasource="#center_dsn#">
								SELECT
									EXPENSE_CODE,
									EXPENSE
								FROM
									EXPENSE_CENTER
								WHERE
									EXPENSE_ACTIVE = 1 
									<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
										AND (EXPENSE LIKE '%#attributes.keyword#%' OR EXPENSE_CODE LIKE '%#attributes.keyword#%')
									</cfif>
									<cfif isDefined("attributes.code") and len(attributes.code)>
										AND EXPENSE_CODE LIKE '#attributes.code#%'
									</cfif>
									<cfif isdefined("attributes.is_store_module") and len(attributes.is_store_module)>
										AND EXPENSE_BRANCH_ID = #ListGetAt(session.ep.user_location,2,"-")#
									</cfif>
								ORDER BY
									EXPENSE_CODE
							</cfquery>
							<select name="EXPENSE_CENTER" id="EXPENSE_CENTER" style="width:150px;height:75px;" multiple="multiple">
								<cfoutput query="GET_EXPENSE_CENTER">
									<option value="#EXPENSE_CODE#" <cfif isdefined("attributes.EXPENSE_CENTER") and listlen(attributes.EXPENSE_CENTER) and listfindnocase(attributes.EXPENSE_CENTER,EXPENSE_CODE)>selected</cfif>>#EXPENSE#</option>
								</cfoutput>
							</select>
						</div>
						
					</div>
					<div class="col col-2 col-md-3 col-sm-6 col-xs-12 ui-form-list ui-form-block" type="column" index="10" sort="true">
						<div class="form-group" id="item-duty_type">
							<label class="bold"><cf_get_lang dictionary_id='58538.Görev Tipi'></label>
							<select name="duty_type" id="duty_type" multiple="multiple" style="width:150px;height:75px;">
								<option value="2" <cfif isdefined("attributes.duty_type") and listfindnocase(attributes.duty_type,2)>selected</cfif>><cf_get_lang dictionary_id='57576.Çalışan'></option>
								<option value="1" <cfif isdefined("attributes.duty_type") and listfindnocase(attributes.duty_type,1)>selected</cfif>><cf_get_lang dictionary_id="53140.İşveren Vekili"></option>
								<option value="0" <cfif isdefined("attributes.duty_type") and listfindnocase(attributes.duty_type,0)>selected</cfif>><cf_get_lang dictionary_id='53550.İşveren'></option>
								<option value="3" <cfif isdefined("attributes.duty_type") and listfindnocase(attributes.duty_type,3)>selected</cfif>><cf_get_lang dictionary_id="53152.Sendikalı"></option>
								<option value="4" <cfif isdefined("attributes.duty_type") and listfindnocase(attributes.duty_type,4)>selected</cfif>><cf_get_lang dictionary_id="53178.Sözleşmeli"></option>
								<option value="5" <cfif isdefined("attributes.duty_type") and listfindnocase(attributes.duty_type,5)>selected</cfif>><cf_get_lang dictionary_id="53169.Kapsam Dışı"></option>
								<option value="6" <cfif isdefined("attributes.duty_type") and listfindnocase(attributes.duty_type,6)>selected</cfif>><cf_get_lang dictionary_id="53182.Kısmi İstihdam"></option>
								<option value="7" <cfif isdefined("attributes.duty_type") and listfindnocase(attributes.duty_type,7)>selected</cfif>><cf_get_lang dictionary_id="53199.Taşeron"></option>
							</select>
						</div>
					</div>
					<div class="col col-2 col-md-3 col-sm-6 col-xs-12 ui-form-list ui-form-block" type="column" index="11" sort="true">
						<div class="form-group" id="item-period_code_cat">
							<label class="bold"><cf_get_lang dictionary_id ='54117.Muhasebe Kod Grubu'></label>
							<select name="period_code_cat" id="period_code_cat" multiple="multiple">
								<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
								<cfoutput query="get_code_cat">
									<option title="#definition#" value="#payroll_id#" <cfif isdefined("attributes.period_code_cat") and listfindnocase(attributes.period_code_cat,payroll_id)>selected</cfif>>#definition#</option>
								</cfoutput>
							</select>
						</div>
					</div>
				</div>
				<cf_seperator title="#getLang('','Belge','57468')#" id="process" is_designer="1" index="10" seperator_id="item_more_sep">
				<div class="row" type="row"  id="process">
					<div class="col col-12 col-md-12 col-sm-12 col-xs-12 ui-form-list ui-form-block" type="column" index="12" sort="true">
						<div class="form-group" id="item-general_process">
							<cfset get_process_f = cmp_process.GET_PROCESS_TYPES(
							faction_list : 'ehesap.list_icmal',
							filter_stage: '#attributes.filter_process#')>
							<cf_workcube_general_process print_type="180" select_value = '#get_process_f.process_row_id#' layout_type="H" detail_type="2" is_termin_date="0" is_template_payroll="1"> 
						</div>
						<div class="form-group col col-2  margin-right-0" id="item-general_paper_tempate">
							<label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="58640.Şablon" ></label>
							<div class="col col-12 col-xs-12">
								<select name="general_paper_tempate" id="general_paper_tempate">
									<option value="-1"><cf_get_lang dictionary_id='35635.Default'></option>
									<cfif get_templates.recordcount>
										<cfoutput query="get_templates">
											<option value="#FORM_ID#" <cfif attributes.general_paper_tempate eq FORM_ID>selected</cfif>>#PRINT_NAME#</option>
										</cfoutput>
									</cfif>
									<cfif len(x_interruption_dues_id) gt 0><option value="interruption-1-<cfoutput>#x_interruption_dues_id#</cfoutput>" <cfif attributes.general_paper_tempate eq "interruption-1-#x_interruption_dues_id#">selected</cfif>><cf_get_lang dictionary_id='64924.Sendika Aidatı Kesintisi'></option></cfif>
										<cfif len(x_interruption_alimony_id) gt 0><option value="interruption-2-<cfoutput>#x_interruption_alimony_id#</cfoutput>" <cfif attributes.general_paper_tempate eq "interruption-2-#x_interruption_alimony_id#">selected</cfif>><cf_get_lang dictionary_id='63285.Nafaka Kesintisi'></option></cfif>
										<cfif len(x_interruption_executive_id) gt 0><option value="interruption-3-<cfoutput>#x_interruption_executive_id#</cfoutput>" <cfif attributes.general_paper_tempate eq "interruption-3-#x_interruption_executive_id#">selected</cfif>><cf_get_lang dictionary_id='64925.İcra Kesintisi'></option></cfif>
										<cfif len(x_interruption_bail_id) gt 0><option value="interruption-4-<cfoutput>#x_interruption_bail_id#</cfoutput>" <cfif attributes.general_paper_tempate eq "interruption-4-#x_interruption_bail_id#">selected</cfif>><cf_get_lang dictionary_id='64057.Kefalet Kesintisi'></option></cfif>	
										<cfif len(x_interruption_rent_id) gt 0><option value="interruption-5-<cfoutput>#x_interruption_rent_id#</cfoutput>" <cfif attributes.general_paper_tempate eq "interruption-5-#x_interruption_rent_id#">selected</cfif>><cf_get_lang dictionary_id='34655.Kira'></option></cfif>
										<cfif len(x_interruption_health_report_id) gt 0><option value="offtime-1-<cfoutput>#x_interruption_health_report_id#</cfoutput>" <cfif attributes.general_paper_tempate eq "offtime-1-#x_interruption_health_report_id#">selected</cfif>><cf_get_lang dictionary_id='64926.Sağlık Raporu Kesintisi'></option></cfif>					
										<cfif len(x_interruption_life_insurance_id) gt 0><option value="exception-<cfoutput>#x_interruption_life_insurance_id#</cfoutput>" <cfif attributes.general_paper_tempate eq "exception-#x_interruption_life_insurance_id#">selected</cfif>><cf_get_lang dictionary_id='53964.Şahıs'> / <cf_get_lang dictionary_id='59577.Hayat Sigortası'></option></cfif>
										<option value="default-1" <cfif attributes.general_paper_tempate eq "default-1">selected</cfif>><cf_get_lang dictionary_id='64917.Ödeme Emri Belgesi'></option>
										<option value="default-2" <cfif attributes.general_paper_tempate eq "default-2">selected</cfif>><cf_get_lang dictionary_id='64918.Personel Bildirim Formu'></option>
										<option value="default-3" <cfif attributes.general_paper_tempate eq "default-3">selected</cfif>><cf_get_lang dictionary_id='64919.Aylık Bordro İcmal'></option>
										<option value="default-4" <cfif attributes.general_paper_tempate eq "default-4">selected</cfif>><cf_get_lang dictionary_id='64920.Aylık Bordro Dökümü'></option>	
										<option value="default-5" <cfif attributes.general_paper_tempate eq "default-5">selected</cfif>><cf_get_lang dictionary_id='64921.Terfi Bilgileri'></option>	
										<option value="default-6" <cfif attributes.general_paper_tempate eq "default-6">selected</cfif>><cf_get_lang dictionary_id='64922.Kesenek Detay Bilgileri'>(5434)</option>
										<option value="default-8" <cfif attributes.general_paper_tempate eq "default-8">selected</cfif>><cf_get_lang dictionary_id='64922.Kesenek Detay Bilgileri'>(5510)</option>
										<option value="default-7" <cfif attributes.general_paper_tempate eq "default-7">selected</cfif>><cf_get_lang dictionary_id='64923.Bes Kesinti Raporu'></option>
								</select>
							</div>
						</div>
					</div>
				</div>
			<cf_box_footer>
				<input type="hidden" id="paper_submit" name="paper_submit" value="0">
				<div>
					<cf_wrk_search_button button_type="2" button_name="#getLang('','Çalıştır','57911')#" search_function="control()">
				</div>
				<cfif isdefined("x_company_logo") and x_company_logo eq 0>
					<cf_workcube_file_action pdf='0' trail='0' mail='1' doc='0' print='1' no_display='1' is_logo="0" icon_text="1" is_print_req="1">
				<cfelse>	
					<cf_workcube_file_action pdf='0' mail='1' doc='0' print='1' no_display='1' icon_text="1" is_print_req="1">
				</cfif>
				<a href="javascript://" onClick="$('#printBordro').printThis();" class="ui-wrk-btn ui-wrk-btn-info ">
					<i class="fa fa-print" title="Yazdır" id="list_print_button"></i>Print
				</a>
			</cf_box_footer>
		</cfform>
	</cf_box>
<cfif isdefined("attributes.sal_mon")>
	<cfset list_status = 1>
	<cfif attributes.sal_year eq attributes.sal_year_end>
		<cfif attributes.sal_mon gt attributes.sal_mon_end>
			<cfset list_status = 0>
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='40467.Başlangıç tarihi bitiş tarihinden büyük olmamalıdır'>.");
			</script>
		</cfif>
	<cfelseif attributes.sal_year gt attributes.sal_year_end>
		<cfset list_status = 0>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='40467.Başlangıç tarihi bitiş tarihinden büyük olmamalıdır'>.");
		</script>
	</cfif>
</cfif>
<cfif isdefined("list_status") and list_status eq 1>
<!---<cfif isdefined("attributes.sal_mon")>--->
	<cfif isdefined("attributes.branch_id") and listlen(attributes.branch_id)>
		<script type="text/javascript">
			get_department_list();
		</script>
	</cfif>

	<cfquery name="GET_PUANTAJ" datasource="#dsn#">
		SELECT
			EP.*
		FROM
			EMPLOYEES_PUANTAJ EP,
			BRANCH B
		WHERE
			<cfif isdefined("attributes.branch_id") and listlen(attributes.branch_id)>
				B.BRANCH_ID IN (#attributes.branch_id#) AND
			</cfif>
			EP.SSK_BRANCH_ID = B.BRANCH_ID AND
			(
				(EP.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
				OR
				(
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
					EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
					(
						EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
						OR
						(EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					)
				)
				OR
				(
					EP.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
					(
						EP.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
						OR
						(EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					)
				)
				OR
				(
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND 
					EP.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
					EP.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
					EP.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
				)
			)
	</cfquery>


	<cfset attributes.sal_mon_ilk = attributes.sal_mon>

	<cfif not get_puantaj.recordcount>
		<cfset kayit_yok = 1>
	<cfelse>
		<cfset attributes.puantaj_id_list = listdeleteduplicates(valuelist(GET_PUANTAJ.puantaj_id))>
	</cfif>

	<cfif not isdefined("kayit_yok")>
		<cfset puantaj_type_ = -1>
		<cfinclude template="../query/get_puantaj_rows.cfm">
		<cfset puantaj_employee_ids = valuelist(get_puantaj_rows.employee_id)>
		<cfif not get_puantaj_rows.recordcount>
			<cfset kayit_yok = 1>
		</cfif>
	</cfif>
	<cfif isdefined("kayit_yok")>
		<cf_box title="Bordro"><cf_get_lang dictionary_id="57484.Kayıt Yok">!</cf_box>
		<cfexit method="exittemplate">
	</cfif>
	
	<cfinclude template="../../query/get_emp_codes.cfm">

	<cfquery name="get_ogis" datasource="#dsn#"><!--- özel gider indirimi sube ile baglanabilirdi ama gerek yok x yilin y ayinda bir kisi icin bir satir olabilir --->
		SELECT
			SUM(OGIR.DAMGA_VERGISI) AS OGI_DAMGA_TOPLAM,
			SUM(OGIR.ODENECEK_TUTAR) AS OGI_ODENECEK_TOPLAM
		FROM
			EMPLOYEES_OZEL_GIDER_IND_ROWS AS OGIR,
			EMPLOYEES_OZEL_GIDER_IND AS OGI,
			EMPLOYEES,
			BRANCH B
		WHERE
			<cfif isdefined("attributes.branch_id") and listlen(attributes.branch_id)>
			B.BRANCH_ID IN (#attributes.branch_id#) AND
			</cfif>
			EMPLOYEES.EMPLOYEE_ID = OGIR.EMPLOYEE_ID AND
			(
				(OGI.PERIOD_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND OGI.PERIOD_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
				OR
				(
					OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
					OGI.PERIOD_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
					(
						OGI.PERIOD_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
						OR
						(OGI.PERIOD_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					)
				)
				OR
				(
					OGI.PERIOD_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
					(
						OGI.PERIOD_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
						OR
						(OGI.PERIOD_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					)
				)
				OR
				(
					OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
					OGI.PERIOD_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
					OGI.PERIOD_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
				)
			) AND
			OGI.SSK_OFFICE = B.SSK_OFFICE AND
			OGI.SSK_NO = B.SSK_NO AND
			OGIR.OZEL_GIDER_IND_ID = OGI.OZEL_GIDER_IND_ID
		<cfif fusebox.dynamic_hierarchy>
			<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
				<cfif database_type is "MSSQL">
					AND 
					('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
						
				<cfelseif database_type is "DB2">
					AND 
					('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
						
				</cfif>
			</cfloop>
		<cfelse>
			<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
				<cfif database_type is "MSSQL">
					AND ('.' + EMPLOYEES.HIERARCHY + '.') LIKE '%.#code_i#.%'
				<cfelseif database_type is "DB2">
					AND ('.' || EMPLOYEES.HIERARCHY || '.') LIKE '%.#code_i#.%'
				</cfif>
			</cfloop>
		</cfif>
	</cfquery>
	
	<cfquery name="get_kumulatif_gelir_vergisi" datasource="#dsn#">
		SELECT 
			SUM(EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI) AS TOPLAM,
			SUM(EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI_MATRAH) AS TOPLAM_MATRAH
		FROM
			EMPLOYEES,
			EMPLOYEES_PUANTAJ,
			EMPLOYEES_PUANTAJ_ROWS,
			BRANCH B
		WHERE
			EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
			EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID IN (#puantaj_employee_ids#) AND
			EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND
			(
				EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
				EMPLOYEES_PUANTAJ.SAL_MON < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_ilk#">
			) 
			AND
			EMPLOYEES_PUANTAJ.SSK_OFFICE = B.SSK_OFFICE AND
			EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = B.SSK_NO
		<cfif fusebox.dynamic_hierarchy>
			<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
				<cfif database_type is "MSSQL">
					AND 
					('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
						
				<cfelseif database_type is "DB2">
					AND 
					('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
						
				</cfif>
			</cfloop>
		<cfelse>
			<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
				<cfif database_type is "MSSQL">
					AND ('.' + EMPLOYEES.HIERARCHY + '.') LIKE '%.#code_i#.%'
				<cfelseif database_type is "DB2">
					AND ('.' || EMPLOYEES.HIERARCHY || '.') LIKE '%.#code_i#.%'
				</cfif>
			</cfloop>
		</cfif>
	</cfquery>
	<cfquery name="get_odeneks" datasource="#dsn#">
		SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID IN (#VALUELIST(GET_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID)#) AND EXT_TYPE = 0 ORDER BY COMMENT_PAY
	</cfquery>
	
	<cfquery name="get_kesintis" datasource="#dsn#">
		SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE FROM_SALARY = 0 AND EMPLOYEE_PUANTAJ_ID IN (#VALUELIST(GET_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID)#) AND EXT_TYPE IN(1,3) ORDER BY COMMENT_PAY
	</cfquery>
	
	<cfquery name="get_kesintis_brut" datasource="#dsn#">
		SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE FROM_SALARY = 1 AND EMPLOYEE_PUANTAJ_ID IN (#VALUELIST(GET_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID)#) AND EXT_TYPE IN(1,3) ORDER BY COMMENT_PAY
	</cfquery>

	<cfquery name="get_vergi_istisnas" datasource="#dsn#">
		SELECT * FROM EMPLOYEES_PUANTAJ_ROWS_EXT WHERE EMPLOYEE_PUANTAJ_ID IN (#VALUELIST(GET_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID)#) AND EXT_TYPE = 2 ORDER BY COMMENT_PAY
	</cfquery>

	<cfset query_name = "get_puantaj_rows">
	<cfset icmal_type = "genel">
	<cfset kisi_say = get_puantaj_rows.recordcount>

	<cfquery name="get_personel_male_aylik" dbtype="query">
		SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SEX = 1 AND SALARY_TYPE = 2
	</cfquery>

	<cfquery name="get_personel_female_aylik" dbtype="query">
		SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SEX = 0 AND SALARY_TYPE = 2
	</cfquery>

	<cfquery name="get_personel_male_yovmiyeli" dbtype="query">
		SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SEX = 1 AND SALARY_TYPE = 1
	</cfquery>

	<cfquery name="get_personel_female_yovmiyeli" dbtype="query">
		SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SEX = 0 AND SALARY_TYPE = 1
	</cfquery>

	<cfquery name="get_personel_male_saat" dbtype="query">
		SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SEX = 1 AND SALARY_TYPE = 0
	</cfquery>

	<cfquery name="get_personel_female_saat" dbtype="query">
		SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SEX = 0 AND SALARY_TYPE = 0
	</cfquery>

	<cfquery name="get_personel_cirak" dbtype="query">
		SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SSK_STATUTE IN (3,4,11)
	</cfquery>

	<cfquery name="get_personel_hastalik" dbtype="query">
		SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SSK_STATUTE = 17
	</cfquery>

	<cfquery name="get_personel_sigorta" dbtype="query">
		SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SSK_STATUTE = 1
	</cfquery>

	<!--Muzaffer Bas Yeraltı Emekli için-->
	<cfquery name="get_personel_emekli" dbtype="query">
		SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SSK_STATUTE IN (2,18)
	</cfquery>
   <!--Muzaffer Bit Yeraltı Emekli için-->

	<cfquery name="get_personel_memur" dbtype="query">
		SELECT DISTINCT EMPLOYEE_PUANTAJ_ID FROM get_puantaj_rows WHERE SSK_STATUTE IN (70,50)
	</cfquery>

	<cfquery name="get_personel_izin_ucret" dbtype="query">
		SELECT
			SUM((TOTAL_SALARY/TOTAL_DAYS)*IZIN_PAID_COUNT) AS IZIN_PAID_COUNT
		FROM
			get_puantaj_rows
	</cfquery>

	<cfquery name="get_ssk_gun" dbtype="query">
		SELECT SUM(TOTAL_DAYS) AS TOTAL_SSK_DAY FROM get_puantaj_rows WHERE SSK_STATUTE IN (1,6,5)
	</cfquery>
    <!---<cfif isdefined("attributes.branch_id") and listlen(attributes.branch_id)>
    <!-- sil -->
    </cfif>--->
	
	<cfinclude template="view_icmal.cfm">
	
</cfif>
</div>
</cfprocessingdirective>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
<script>
	function sendPdf(){
		$('#convert').val('pdf');
		$('#employee').trigger('submit');
	}
	
	$(function() {
		$('.wrkFileACtions').append('<a href="javascript://" onclick="sendPdf()"> <i class="fa fa-file-pdf-o" title="PDF" id="list_pdf_button"></i> </a>')
	});

	function control()
	{
		$('#convert').val('');
		$('#paper_submit').val("1");
		return true;
	}
	
</script>