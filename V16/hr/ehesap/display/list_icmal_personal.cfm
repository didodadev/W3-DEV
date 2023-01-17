<cf_xml_page_edit fuseact="ehesap.popup_view_price_compass">
<cf_get_lang_set module_name="ehesap">
<cfsetting showdebugoutput="no">
<style>
.wrkFileACtions{
	right:0px !important;
	position:relative !important;
}
td{font-size:10px!important}
</style>
<cfif not (isdefined("attributes.EMPLOYEE_ID") and len(attributes.EMPLOYEE_ID)) and (isdefined("attributes.in_out_id") and len(attributes.in_out_id))>
	<cfquery name="get_emp_id" datasource="#dsn#">
		SELECT EMPLOYEE_ID FROM EMPLOYEES_IN_OUT WHERE IN_OUT_ID = <cfqueryparam CFSQLType = "cf_sql_integer" value = "#attributes.in_out_id#" null = "no">
	</cfquery>
	<cfset attributes.employee_id = get_emp_id.employee_id>
</cfif>
<cfparam name="attributes.puantaj_type" default="-1">
<cfparam name="attributes.sal_year" default="#year(now())#">
<cfparam name="attributes.sal_mon" default="<cfif month(now()) gt 1>#month(now()) - 1#><cfelse>#month(now())#</cfif>">
<cfparam name="attributes.sal_mon_end" default="#attributes.sal_mon#">
<cfparam name="attributes.sal_year_end" default="#attributes.sal_year#">
<cfparam name="attributes.form_type" default="-2">
<cfset main_puantaj_table = "EMPLOYEES_PUANTAJ">
<cfset row_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS">
<cfset ext_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_EXT">
<cfset add_puantaj_table = "EMPLOYEES_PUANTAJ_ROWS_ADD">
<cfset maas_puantaj_table = "EMPLOYEES_SALARY">
<cfset periods = createObject('component','V16.objects.cfc.periods')>
<cfset period_years = periods.get_period_year()>
<cfscript>
	function saDk(veri) // Bu fonksiyon saat olarak gelen değeri, Saat:Dakika formatına çevirir.
	{
		saat = ListGetAt(veri, 1, ".");
		dakika = "00";
		if (ListLen(veri, ".") eq 2)
			dakika = Int(ListGetAt(veri, 2, ".") * 60 / 100);
		return saat & ":" & dakika;
	}
</cfscript>
<cfset getPrintTemplate = createObject("component","cfc.get_print_template")>
<cfset get_templates = getPrintTemplate.GET(print_type : 180)>
<cfif attributes.form_type eq -2 and get_templates.recordcount>
	<cfquery name="get_templates_standart" dbtype="query">
		SELECT 
			*
		FROM
			get_templates
		WHERE
			IS_DEFAULT = 1
	</cfquery>
	<cfif get_templates_standart.recordcount>
		<cfset attributes.form_type = get_templates_standart.form_id>
	</cfif>
</cfif>

<cfif not ((attributes.fuseaction contains "popup_view_price_compass") or (attributes.fuseaction contains "popupflush_view_puantaj_print") )>
	<cfset form_submit_action = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_icmal_personal">
	<cfset isciye = 0>
<cfelse>
	<cfset form_submit_action = "#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_view_price_compass">
	<cfset isciye = 1>
</cfif>
<cfif isdefined("attributes.style") and ((attributes.style is "all") or (attributes.style is "list"))>
	<cfset toplu = 1>
<cfelse>
	<cfset toplu = 0>
</cfif>
<cfform name="employee" method="post" action="#form_submit_action#">
	<cfif toplu eq 0>
		<cfif (not isdefined("attributes.employee_id")) or (isdefined("attributes.employee_id") and (not len(attributes.employee_id)))>
			<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
			<input type="hidden" name="employee_id" id="employee_id" value="">
			<cf_box title="#getLang('','Çalışan icmal',47081)#">
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-sal_mon">
							<label class="col col-4 col-xs-12">
								<cf_get_lang dictionary_id="58053.Başlangıç Tarihi">
							</label>
							<div class="col col-4 col-xs-12">
								<div class="form-group">
									<select name="sal_mon" id="sal_mon" onchange="change_mon(this.value);">
										<cfloop from="1" to="12" index="i">
											<cfoutput>
												<option value="#i#" <cfif i eq attributes.sal_mon>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
											</cfoutput>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="col col-4 col-xs-12">
								<div class="form-group">
									<select name="sal_year" id="sal_year">
										<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
											<cfoutput>
												<option value="#i#" <cfif attributes.sal_year eq i>selected</cfif>>#i#</option>
											</cfoutput>
										</cfloop>
									</select>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-employee_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57576.Çalışan"></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57576.Çalışan'></cfsavecontent>
									<cfinput type="text" name="employee_name" id="employee_name" required="yes" message="#message#" value="" style="width:150px;" autocomplete="off" onFocus="AutoComplete_Create('employee_name','EMPLOYEE_NAME,EMPLOYEE_SURNAME,TC_IDENTY_NO,SOCIALSECURITY_NO,RETIRED_SGDP_NUMBER,BRANCH_NAME','FULLNAME,BRANCH_NAME','get_in_outs_autocomplete','0','FULLNAME,EMPLOYEE_ID','employee_name,employee_id','employee','3','300');">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emps&conf_=1&field_id=employee.employee_id&field_name=employee.employee_name&keyword='+encodeURIComponent(document.employee.employee_name.value),'list');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-form_type">
							<label class="col col-4"><cf_get_lang dictionary_id='58640.Şablon'>*</label>
							<div class="col col-8">
								<select  name="form_type" id="form_type">
									<option value="-1"><cf_get_lang dictionary_id='35635.Default'></option>
									<cfoutput query="get_templates">
										<option value="#FORM_ID#" <cfif attributes.form_type eq FORM_ID or  IS_STANDART eq 1>selected</cfif>>#PRINT_NAME#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-sal_mon">
							<label class="col col-4 col-xs-12">
								<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>
							</label>
							<div class="form-group col col-4 col-xs-12">
								<select name="sal_mon_end" id="sal_mon_end">
									<cfloop from="1" to="12" index="i">
										<cfoutput>
											<option value="#i#" <cfif attributes.sal_mon_end eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
										</cfoutput>
									</cfloop>
								</select>
							</div>
							<div class="form-group col col-4 col-xs-12">
								<select name="sal_year_end" id="sal_year_end">
									<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
										<cfoutput>
											<option value="#i#" <cfif attributes.sal_year_end eq i>selected</cfif>>#i#</option>
										</cfoutput>
									</cfloop>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-puantaj_type">
							<label class="col col-4 col-xs-12">
								<cf_get_lang dictionary_id="45125.Puantaj Tipi">
							</label>
							<div class="col col-8 col-xs-12">
								<select name="puantaj_type" id="puantaj_type">
									<option value="0" <cfif isdefined("attributes.puantaj_type") and attributes.puantaj_type eq 0>selected</cfif>><cf_get_lang dictionary_id="54194.Sanal Puantaj"></option>
									<option value="-1" <cfif isdefined("attributes.puantaj_type") and attributes.puantaj_type eq -1>selected</cfif>><cf_get_lang dictionary_id="53548.Gerçek Puantaj"></option>
									<option value="-2" <cfif isdefined("attributes.puantaj_type") and attributes.puantaj_type eq -2>selected</cfif>><cf_get_lang dictionary_id="53575.Fark Puantajı"></option>
									<option value="-3" <cfif isdefined("attributes.puantaj_type") and attributes.puantaj_type eq -3>selected</cfif>><cf_get_lang dictionary_id="53609.Son Puantaj"></option>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
						<div class="form-group" id="item-type">
							<label class="col col-4 col-xs-12"></label>
							<div class="col col-8 col-xs-12">
								<select name="view_type" id="view_type">
									<option value="0" <cfif isdefined("attributes.view_type") and attributes.view_type eq 0>selected</cfif>><cf_get_lang dictionary_id="46074.Toplam Göster"></option>
									<option value="1" <cfif isdefined("attributes.view_type") and attributes.view_type eq 1>selected</cfif>><cf_get_lang dictionary_id="46076.Dağılım Göster"></option>
								</select>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_wrk_search_button search_function="control_date()">
				</cf_box_footer>
			</cf_box>
		<cfelse>
			<cfif not (isdefined("attributes.EMPLOYEE_ID") and len(attributes.EMPLOYEE_ID))>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57576.Çalışan'>");
					history.back();
				</script>
				<cfabort>
			</cfif>
			<cfinclude template="../query/get_employee_name.cfm">
			<cf_box title="#getLang('','Çalışan icmal',47081)#">
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
						<div class="form-group" id="item-sal_mon">
							<label class="col col-4 col-xs-12">
								<cf_get_lang dictionary_id="58053.Başlangıç Tarihi">
							</label>
							<div class="col col-4 col-xs-12">
								<div class="form-group">
									<select name="sal_mon" id="sal_mon">
										<cfloop from="1" to="12" index="i">
											<cfoutput>
												<option value="#i#" <cfif attributes.sal_mon eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
											</cfoutput>
										</cfloop>
									</select>
								</div>
							</div>
							<div class="col col-4 col-xs-12">
								<div class="form-group">
									<select name="sal_year" id="sal_year">
										<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
											<cfoutput>
												<option value="#i#" <cfif attributes.sal_year eq i>selected</cfif>>#i#</option>
											</cfoutput>
										</cfloop>
									</select>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-employee_name">
							<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57576.Çalışan"></label>
							<div class="col col-8 col-xs-12">
								<div class="input-group">
									<cfinput type="hidden" name="maxrows" value="20">
									<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>">
									<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57576.Çalışan'></cfsavecontent>
									<cfinput type="text" name="employee_name" id="employee_name" required="yes" message="#message#" style="width:150px;" value="#get_employee_name.employee_name# #get_employee_name.employee_surname#" autocomplete="off" onFocus="AutoComplete_Create('employee_name','EMPLOYEE_NAME,EMPLOYEE_SURNAME,TC_IDENTY_NO,SOCIALSECURITY_NO,RETIRED_SGDP_NUMBER,BRANCH_NAME','FULLNAME,BRANCH_NAME','get_in_outs_autocomplete','','FULLNAME,EMPLOYEE_ID','employee_name,employee_id','employee','3','300');">
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_list_emps&conf_=1&field_id=employee.employee_id&field_name=employee.employee_name&keyword='+encodeURIComponent(document.employee.employee_name.value),'list');"></span>
								</div>
							</div>
						</div>
						<div class="form-group" id="item-type">
							<label class="col col-4 col-xs-12">
								<cf_get_lang dictionary_id='43721.Görünüm Tipi '>
							</label>
							<div class="col col-8 col-xs-12">
								<select name="view_type" id="view_type">
									<option value="0" <cfif isdefined("attributes.view_type") and attributes.view_type eq 0>selected</cfif>><cf_get_lang dictionary_id='46074.Toplam Göster'></option>
									<option value="1" <cfif isdefined("attributes.view_type") and attributes.view_type eq 1>selected</cfif>><cf_get_lang dictionary_id='46076.Dağılım Göster'></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-form_type">
							<label class="col col-4"><cf_get_lang dictionary_id='58640.Şablon'>*</label>
							<div class="col col-8">
								<select  name="form_type" id="form_type">
									<option value="-1"><cf_get_lang dictionary_id='35635.Default'></option>
									<cfoutput query="get_templates">
										<option value="#FORM_ID#" <cfif attributes.form_type eq FORM_ID>selected</cfif>>#PRINT_NAME#</option>
									</cfoutput>
								</select>
							</div>
						</div>
					</div>
					<div class="col col-4 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
						<div class="form-group" id="item-sal_mon">
							<label class="col col-4 col-xs-12">
								<cf_get_lang dictionary_id='57700.Bitiş Tarihi'>
							</label>
							<div class="col col-6 col-xs-12">
								<select name="sal_mon_end" id="sal_mon_end">
									<cfloop from="1" to="12" index="i">
										<cfoutput>
											<option value="#i#" <cfif attributes.sal_mon_end eq i>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
										</cfoutput>
									</cfloop>
								</select>
							</div>
							<div class="col col-2 col-xs-12">
								<select name="sal_year_end" id="sal_year_end">
									<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
										<cfoutput>
											<option value="#i#" <cfif attributes.sal_year_end eq i>selected</cfif>>#i#</option>
										</cfoutput>
									</cfloop>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-puantaj_type">
							<label class="col col-4 col-xs-12">
								<cf_get_lang dictionary_id="45125.Puantaj Tipi">
							</label>
							<div class="col col-8 col-xs-12">
								<select name="puantaj_type" id="puantaj_type">
									<option value="0" <cfif isdefined("attributes.puantaj_type") and attributes.puantaj_type eq 0>selected</cfif>><cf_get_lang dictionary_id="54194.Sanal Puantaj"></option>
									<option value="-1" <cfif isdefined("attributes.puantaj_type") and attributes.puantaj_type eq -1>selected</cfif>><cf_get_lang dictionary_id="53548.Gerçek Puantaj"></option>
									<option value="-2" <cfif isdefined("attributes.puantaj_type") and attributes.puantaj_type eq -2>selected</cfif>><cf_get_lang dictionary_id="53575.Fark Puantajı"></option>
									<option value="-3" <cfif isdefined("attributes.puantaj_type") and attributes.puantaj_type eq -3>selected</cfif>><cf_get_lang dictionary_id="53609.Son Puantaj"></option>
								</select>
							</div>
						</div>
						<div class="form-group" id="item-show_detail">
							<label class="col col-4 col-xs-12">
								<cf_get_lang dictionary_id='43721.Görünüm Tipi'>
							</label>
							<div class="col col-8 col-xs-12">
								<select name="show_detail" id="show_detail">
									<option value="0" <cfif isdefined("attributes.show_detail") and attributes.show_detail eq 0>selected</cfif>><cf_get_lang dictionary_id='58052.Özet'></option>
									<option value="1" <cfif isdefined("attributes.show_detail") and attributes.show_detail eq 1>selected</cfif>><cf_get_lang dictionary_id='57771.Detay'></option>
								</select>
							</div>
						</div>
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_file_action pdf='1' mail='1' print='0' tag_module="pdf" isAjaxPage="1" extra_parameters="is_puantaj_print">
					<a href="javascript://" onClick="print_puantaj()" class="ui-wrk-btn ui-wrk-btn-info ">
						<i class="fa fa-print" title="Yazdır" id="list_print_button"></i>
					</a>
					<cf_wrk_search_button search_function="control_date()" button_type="5">
				</cf_box_footer>
			</cf_box>		
		</cfif>
	</cfif>
</cfform>
<div id="pdf">
<cfif isdefined("attributes.employee_id") and len(attributes.employee_id)><!--- not isdefined("attributes.mevcut_durum") and--->
	<cfscript>
		function QueryRow(Query,Row) 
		{
			var tmp = QueryNew(Query.ColumnList);
			QueryAddRow(tmp,1);
			for(x=1;x lte ListLen(tmp.ColumnList);x=x+1) QuerySetCell(tmp, ListGetAt(tmp.ColumnList,x), query[ListGetAt(tmp.ColumnList,x)][row]);
			return tmp;
		}
	</cfscript>
	<cfif (not isdefined("attributes.style")) or (attributes.style is "one")>
		<cfquery name="get_hr_branch" datasource="#DSN#">
			SELECT 
				BRANCH_ID,
				USE_SSK
			FROM 
				EMPLOYEES_IN_OUT
			WHERE 
				EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> 
				AND USE_SSK = 2
		</cfquery>
		<cfif get_hr_branch.recordCount AND get_hr_branch.use_ssk eq 2>
			<cfset attributes.branch_id = get_hr_branch.branch_id>
			<cfinclude template="../query/get_program_parameter.cfm">
			<cfif (isdefined("get_program_parameters.FIRST_DAY_MONTH") and len(get_program_parameters.FIRST_DAY_MONTH) and not(get_program_parameters.FIRST_DAY_MONTH eq 1 and get_program_parameters.LAST_DAY_MONTH eq 0)) >
                <cfset start_date_new = CreateDateTime(attributes.sal_year,attributes.sal_mon,get_program_parameters.FIRST_DAY_MONTH,0,0,0)>
                <cfset finish_date_new = CreateDateTime(attributes.sal_year,attributes.sal_mon,get_program_parameters.LAST_DAY_MONTH,0,0,0)>
                <cfset finish_date_new = dateadd("m",1,finish_date_new)>
            </cfif>
		</cfif>
		<cfinclude template="../query/get_puantaj_personal.cfm">
		<cfif not GET_PUANTAJ_PERSONAL.recordcount>
			<script type="text/javascript">
				alert("1- <cf_get_lang dictionary_id ='53775.Bu çalışan için puantaj kaydı'> <cfif not session.ep.ehesap><cf_get_lang dictionary_id ='53028.veya Yetkiniz'></cfif><cf_get_lang dictionary_id='58546.Yok'>!");
				history.back();
			</script>
			<cfabort>
		</cfif>
		<cfquery name="get_ogis" datasource="#dsn#"><!--- özel gider indirimi sube ile baglanabilirdi ama gerek yok x yilin y ayinda bir kisi icin bir satir olabilir --->
			SELECT
				OGIR.DAMGA_VERGISI AS OGI_DAMGA_TOPLAM,
				OGIR.ODENECEK_TUTAR AS OGI_ODENECEK_TOPLAM
			FROM
				EMPLOYEES_OZEL_GIDER_IND_ROWS AS OGIR,
				EMPLOYEES_OZEL_GIDER_IND AS OGI
			WHERE
				OGIR.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#"> AND
				<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_mon_end)>
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
							OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
							OGI.PERIOD_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
							OGI.PERIOD_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
						)
					) AND
				<cfelse>
					OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
					OGI.PERIOD_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
				</cfif>
				OGIR.OZEL_GIDER_IND_ID = OGI.OZEL_GIDER_IND_ID
		</cfquery>

		<cfif not get_ogis.recordcount>
			<!--- 20050215 ocak ayinda bu tutarlar puantajdan gelen kisiye bagli olmadigi icin 0 set ediliyor --->
			<cfset get_ogis.OGI_DAMGA_TOPLAM = 0>
			<cfset get_ogis.OGI_ODENECEK_TOPLAM = 0>
		</cfif>
		<cfinclude template="../query/get_hours.cfm">
		<cfset icmal_type = "personal">
		<cfif attributes.sal_year eq attributes.sal_year_end and attributes.sal_mon eq attributes.sal_mon_end>
			<cfset same_mon = 1>
		<cfelse>
			<cfset same_mon = 0>
		</cfif>
		<cfif same_mon neq 1>
			<cfset mxrw = 1>
			<cfset puantaj_ids = valuelist(get_puantaj_personal.employee_puantaj_id,',')>
		<cfelse>
			<cfset puantaj_ids = valuelist(get_puantaj_personal.employee_puantaj_id,',')>
			<cfset mxrw = get_puantaj_personal.recordcount>
		</cfif>	
		
		<cfif isdefined("attributes.view_type") and attributes.view_type eq 1>
			<cfset mxrw = get_puantaj_personal.recordcount>
		<cfelse>
			<cfset mxrw = 1>
		</cfif>
		<div id="printBordroIcmal" style="page-break-after: always;">
			<cfoutput query="get_puantaj_personal" maxrows="#mxrw#">
				<cfif isdefined("attributes.view_type") and attributes.view_type eq 1 and statue_type neq 11>
					<cfset puantaj_ids = employee_puantaj_id>
				<cfelse>
					<cfset puantaj_ids = valuelist(get_puantaj_personal.employee_puantaj_id,',')>
				</cfif>
				<cfquery name="get_odeneks" datasource="#dsn#">
					SELECT * FROM #ext_puantaj_table# WHERE EMPLOYEE_PUANTAJ_ID IN (#puantaj_ids#) AND EXT_TYPE = 0 ORDER BY COMMENT_PAY, EMPLOYEE_PUANTAJ_ID ASC
				</cfquery>
				<cfquery name="get_kesintis" datasource="#dsn#">
					SELECT * FROM #ext_puantaj_table# WHERE EMPLOYEE_PUANTAJ_ID IN (#puantaj_ids#) AND FROM_SALARY = 0 AND EXT_TYPE IN (1,3) ORDER BY COMMENT_PAY, EMPLOYEE_PUANTAJ_ID ASC
				</cfquery>
				<cfquery name="get_kesintis_brut" datasource="#dsn#">
					SELECT * FROM #ext_puantaj_table# WHERE EMPLOYEE_PUANTAJ_ID IN (#puantaj_ids#) AND FROM_SALARY = 1 AND EXT_TYPE IN (1,3) ORDER BY COMMENT_PAY, EMPLOYEE_PUANTAJ_ID ASC
				</cfquery>
				<cfquery name="get_vergi_istisnas" datasource="#dsn#">
					SELECT * FROM #ext_puantaj_table# WHERE EMPLOYEE_PUANTAJ_ID IN (#puantaj_ids#) AND EXT_TYPE = 2 ORDER BY COMMENT_PAY, EMPLOYEE_PUANTAJ_ID ASC
				</cfquery>		
				<cfquery name="get_kumulatif_gelir_vergisi" datasource="#dsn#" >
					SELECT 
						SUM(EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI) AS TOPLAM,
						SUM(EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI_MATRAH) AS TOPLAM_MATRAH
					FROM 
						<cfif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1>
							EMPLOYEES_PUANTAJ_VIRTUAL AS EMPLOYEES_PUANTAJ,
							EMPLOYEES_PUANTAJ_ROWS_VIRTUAL AS EMPLOYEES_PUANTAJ_ROWS
						<cfelse>
							EMPLOYEES_PUANTAJ,
							EMPLOYEES_PUANTAJ_ROWS
						</cfif>
						<cfif same_mon neq 1 and get_puantaj_personal.tax_account_style eq 1><!--- şirket içi devir--->
							,BRANCH B
						</cfif>
					WHERE 
						<cfif same_mon neq 1 and get_puantaj_personal.tax_account_style eq 1>
							EMPLOYEES_PUANTAJ.SSK_BRANCH_ID = B.BRANCH_ID AND
							B.COMPANY_ID = (SELECT B2.COMPANY_ID FROM BRANCH B2 WHERE B2.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.BRANCH_ID#">) AND
						</cfif>
						EMPLOYEES_PUANTAJ.PUANTAJ_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_type#"> AND
						EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND 
						<cfif statue_type neq 11>
							EMPLOYEES_PUANTAJ.SAL_YEAR = <cfif same_mon eq 1><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.sal_year#"></cfif> AND 
							(
								EMPLOYEES_PUANTAJ.SAL_MON < <cfif same_mon eq 1><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"><cfelse><cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.sal_mon#"></cfif> 
								<cfif (isDefined("attributes.view_type") and attributes.view_type eq 1) and statue_type neq 11>
									OR
									(
										EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID < #puantaj_ids#
									)
								</cfif>
							)AND
						<cfelse>
							EMPLOYEES_PUANTAJ.SAL_YEAR = #year(now())# AND
						</cfif>
						EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#">
				</cfquery>	
				<cfif isdefined("attributes.view_type") and attributes.view_type eq 1>
					<cfset temp_query_1 = QueryRow(get_puantaj_personal,currentrow)>
					<cfset attributes.sal_mon = temp_query_1.sal_mon>
					<cfset attributes.sal_year = temp_query_1.sal_year>
				<cfelse>
					<cfset temp_query_1 = get_puantaj_personal>
				</cfif>
				<cfset query_name = "temp_query_1">
				<cfinclude template="view_icmal.cfm">
			</cfoutput>
		</div>
	<cfelse>
		<cfif attributes.style is 'all'>
			<cfif not len(attributes.SSK_OFFICE) and not len(attributes.hierarchy)>
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id ='54140.SSK Ofis Bilgileri veya Hierarşi Kodu Eksik'>!");
					window.close();
				</script>
			<cfelse>
				<cfinclude template="../query/get_icmal_puantaj_rows.cfm">
				<cfset sayi = 0>
				<cfset puantaj_list = "">
				<cfset employee_list = "">
				<cfoutput query="get_puantaj_rows">
					<cfset puantaj_list = listappend(puantaj_list,get_puantaj_rows.EMPLOYEE_PUANTAJ_ID,',')>
					<cfset employee_list = listappend(employee_list,get_puantaj_rows.EMPLOYEE_ID,',')>
				</cfoutput>
				<cfset puantaj_list=listsort(puantaj_list,"numeric","ASC",",")>
				<cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
				<cfif listlen(puantaj_list)>
					<cfquery name="get_odeneks_all" datasource="#dsn#">
						SELECT * FROM #ext_puantaj_table# WHERE EMPLOYEE_PUANTAJ_ID IN (#puantaj_list#) ORDER BY COMMENT_PAY
					</cfquery>
				</cfif>
				<cfif listlen(employee_list)>
					<cfquery name="get_ogis_all" datasource="#dsn#"><!--- özel gider indirimi sube ile baglanabilirdi ama gerek yok x yilin y ayinda bir kisi icin bir satir olabilir --->
						SELECT
							OGIR.DAMGA_VERGISI AS OGI_DAMGA_TOPLAM,
							OGIR.ODENECEK_TUTAR AS OGI_ODENECEK_TOPLAM,
							OGIR.EMPLOYEE_ID
						FROM
							EMPLOYEES_OZEL_GIDER_IND_ROWS AS OGIR,
							EMPLOYEES_OZEL_GIDER_IND AS OGI
						WHERE
							OGIR.EMPLOYEE_ID IN (#employee_list#) AND
							<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_mon_end)>
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
										OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
										OGI.PERIOD_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
										OGI.PERIOD_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
									)
								) AND
							<cfelse>
								OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
								OGI.PERIOD_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
							</cfif>
							OGIR.OZEL_GIDER_IND_ID = OGI.OZEL_GIDER_IND_ID
					</cfquery>
					<cfquery name="get_kumulatif_gelir_vergisi_all" datasource="#dsn#">
						SELECT 
							EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI,
							EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID,
							B.BRANCH_ID,
							B.COMPANY_ID
						FROM 
							EMPLOYEES_PUANTAJ,
							EMPLOYEES_PUANTAJ_ROWS,
							BRANCH B
						WHERE
							EMPLOYEES_PUANTAJ.SSK_BRANCH_ID = B.BRANCH_ID AND
							EMPLOYEES_PUANTAJ.PUANTAJ_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#ATTRIBUTES.PUANTAJ_TYPE#"> AND
							EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND 
							<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_mon_end)>
								(
									(EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
									OR
									(
										EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
										EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
										(
											EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
											OR
											(EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
										)
									)
									OR
									(
										EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
										(
											EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">
											OR
											(EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
										)
									)
									OR
									(
										EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND 
										EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
										EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
										EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
									)
								) AND
							<cfelse>
								EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
								EMPLOYEES_PUANTAJ.SAL_MON < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND 
							</cfif>
								EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID IN (#employee_list#)
					</cfquery>
				</cfif>	
				<cfset before_empid = ""><!--- bir önceki index değerinin employee_id'sini tutar 04092019ERU --->
				<cfset now_empid = ""><!--- loopta o an bulunan index değerinin employee_id'sini tutar 04092019ERU --->
				<cfloop query="get_puantaj_rows">
					<div class="printBordroIcmal" style="page-break-after: always;">
						<cfset index_id = get_puantaj_rows.currentrow>			
						<cfset attributes.employee_id = get_puantaj_rows.employee_id[index_id]>
						<cfif isdefined("attributes.view_type") and attributes.view_type eq 1>
							<cfset attributes.sal_mon = get_puantaj_rows.sal_mon[index_id]>
						</cfif>
						<cfset now_empid = get_puantaj_rows.employee_id[index_id]>
						<cfif index_id-1 neq 0><!--- önceki index 0 değilse --->
							<cfset before_empid = get_puantaj_rows.employee_id[index_id-1]><!--- Bir önceki indexteki employee_id --->
						</cfif>
						<!--- <cfinclude template="../query/get_puantaj_personal.cfm"> --->
						<cfquery name="GET_PUANTAJ_PERSONAL" dbtype="query">
							SELECT 
								*
							FROM
								get_puantaj_rows
							WHERE
								EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">
								<cfif isdefined("attributes.view_type") and attributes.view_type eq 1><!--- Dağılım göster işaretliyse sadecebulunan index'in seçili ay'ı --->
									AND SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> 
								</cfif>
						</cfquery>
						<cfif isdefined("attributes.view_type") and attributes.view_type eq 1><!--- Dağılım Göster Seçili ise tek bir employee_puantaj ID 03092019ERU --->
							<cfset puantaj_ids = employee_puantaj_id>
						<cfelse><!--- Toplam göster seçili ise seçilen tarihler arasındaki puantaj ID'lerin listesi 03092019ERU--->
							<cfset puantaj_ids = valuelist(get_puantaj_personal.employee_puantaj_id,',')>
						</cfif>				
						<cfif not GET_PUANTAJ_PERSONAL.recordcount>
							<script type="text/javascript">
								alert("2- <cf_get_lang dictionary_id ='53775.Bu çalışan için puantaj kaydı'> <cfif not session.ep.ehesap><cf_get_lang dictionary_id ='53028.veya Yetkiniz'></cfif><cf_get_lang dictionary_id='58546.Yok'>!");
								history.back();
							</script>
							<cfabort>
						</cfif>
						<!--- özel gider indirimi sube ile baglanabilirdi ama gerek yok x yilin y ayinda bir kisi icin bir satir olabilir --->
						<cfquery name="get_ogis" dbtype="query">
							SELECT
								OGI_DAMGA_TOPLAM,
								OGI_ODENECEK_TOPLAM
							FROM
								get_ogis_all
							WHERE
								EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">
						</cfquery>
						<cfif not get_ogis.recordcount>
							<!--- 20050215 ocak ayinda bu tutarlar puantajdan gelen kisiye bagli olmadigi icin 0 set ediliyor --->
							<cfset get_ogis.OGI_DAMGA_TOPLAM = 0>
							<cfset get_ogis.OGI_ODENECEK_TOPLAM = 0>
						</cfif>
						<cfquery name="get_kumulatif_gelir_vergisi" dbtype="query">
							SELECT 
								SUM(GELIR_VERGISI) AS TOPLAM 
							FROM 
								get_kumulatif_gelir_vergisi_all 
							WHERE 
								EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">
								<cfif get_puantaj_personal.tax_account_style eq 1><!--- şirket içi devir--->
									AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj_personal.company_id#">
								</cfif>
						</cfquery>
						<cfset icmal_type = "personal">
						<cfoutput query="get_puantaj_personal">
							<cfquery name="get_odeneks" dbtype="query">
								SELECT * FROM get_odeneks_all WHERE EMPLOYEE_PUANTAJ_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#puantaj_ids#" list="yes">) AND EXT_TYPE = 0 ORDER BY COMMENT_PAY
							</cfquery>

							<cfquery name="get_kesintis" dbtype="query">
								SELECT * FROM get_odeneks_all WHERE EMPLOYEE_PUANTAJ_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#puantaj_ids#" list="yes">) AND EXT_TYPE = 1 ORDER BY COMMENT_PAY
							</cfquery>
							
							<cfquery name="get_vergi_istisnas" dbtype="query">
								SELECT * FROM get_odeneks_all WHERE EMPLOYEE_PUANTAJ_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#puantaj_ids#" list="yes">) AND EXT_TYPE = 2 ORDER BY COMMENT_PAY
							</cfquery>
							<cfif isdefined("attributes.view_type") and attributes.view_type eq 1><!--- Dağılım göster işaretliyse var olan querysatırını view_icmal'e gönderiyor 03092019ERU--->
								<cfset temp_query_1 = QueryRow(get_puantaj_personal,currentrow)>
								<cfset attributes.sal_mon = temp_query_1.sal_mon>
								<cfset attributes.sal_year = temp_query_1.sal_year>					
							</cfif>		
						</cfoutput>
						<cfif isdefined("attributes.view_type") and attributes.view_type eq 0><!--- Dağılım göster işaretliyse tüm qery'i view_icmal'e gönderiyor 03092019ERU--->
							<cfset temp_query_1 = get_puantaj_personal>
						</cfif>
						<cfset query_name = "temp_query_1">
						<cfif before_empid neq now_empid and attributes.view_type eq 0>
							<table cellpadding="0" cellspacing="0" style="width:210mm; height:283.5mm;page-break-after: always;" align="center" border="0">
								<tr>
									<td height="5">&nbsp;</td>
								</tr>
								<tr>
									<td valign="top">
										<cfif GET_PUANTAJ_PERSONAL.use_pdks eq 2>
											<cfinclude template="view_icmal_pdks.cfm">
										<cfelse>	
											<cfinclude template="view_icmal.cfm">
										</cfif>
									</td>
								</tr>
							</table>
						<cfelseif attributes.view_type eq 1>
							<table cellpadding="0" cellspacing="0" style="width:210mm; height:283.5mm;page-break-after: always;" align="center" border="0">
								<tr>
									<td height="5">&nbsp;</td>
								</tr>
								<tr>
									<td valign="top">
										<cfif GET_PUANTAJ_PERSONAL.use_pdks eq 2>
											<cfinclude template="view_icmal_pdks.cfm">
										<cfelse>	
											<cfinclude template="view_icmal.cfm">
										</cfif>
									</td>
								</tr>
							</table>
						</cfif>
					</div>
				</cfloop>
			</cfif>
		<cfelseif attributes.style is 'list' and isdefined("attributes.list_employee_id")>
			<cfinclude template="../query/get_icmal_puantaj_rows.cfm">
				<cfset sayi = 0>
				<cfset puantaj_list = "">
				<cfset employee_list = "">
				<cfoutput query="get_puantaj_rows">
					<cfset puantaj_list = listappend(puantaj_list,get_puantaj_rows.EMPLOYEE_PUANTAJ_ID,',')>
					<cfset employee_list = listappend(employee_list,get_puantaj_rows.EMPLOYEE_ID,',')>
				</cfoutput>
				<cfset puantaj_list=listsort(puantaj_list,"numeric","ASC",",")>
				<cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
				<cfif listlen(puantaj_list)>
					<cfquery name="get_odeneks_all" datasource="#dsn#">
						SELECT * FROM #ext_puantaj_table# WHERE EMPLOYEE_PUANTAJ_ID IN (#puantaj_list#) ORDER BY COMMENT_PAY
					</cfquery>
				</cfif>
				<cfif listlen(employee_list)>
					<cfquery name="get_ogis_all" datasource="#dsn#"><!--- özel gider indirimi sube ile baglanabilirdi ama gerek yok x yilin y ayinda bir kisi icin bir satir olabilir --->
						SELECT
							OGIR.DAMGA_VERGISI AS OGI_DAMGA_TOPLAM,
							OGIR.ODENECEK_TUTAR AS OGI_ODENECEK_TOPLAM,
							OGIR.EMPLOYEE_ID
						FROM
							EMPLOYEES_OZEL_GIDER_IND_ROWS AS OGIR,
							EMPLOYEES_OZEL_GIDER_IND AS OGI
						WHERE
							OGIR.EMPLOYEE_ID IN (#employee_list#) AND
							<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_year_end)>
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
										OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
										OGI.PERIOD_MONTH >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
										OGI.PERIOD_MONTH <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
									)
								) AND
							<cfelse>
								OGI.PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
								OGI.PERIOD_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
							</cfif>
							OGIR.OZEL_GIDER_IND_ID = OGI.OZEL_GIDER_IND_ID
					</cfquery>
				
					<cfquery name="get_kumulatif_gelir_vergisi_all" datasource="#dsn#">
						SELECT EMPLOYEES_PUANTAJ_ROWS.GELIR_VERGISI,EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID FROM 
						<cfif isdefined("attributes.is_virtual_puantaj") and attributes.is_virtual_puantaj eq 1>
							EMPLOYEES_PUANTAJ_VIRTUAL AS EMPLOYEES_PUANTAJ,
							EMPLOYEES_PUANTAJ_ROWS_VIRTUAL AS EMPLOYEES_PUANTAJ_ROWS
						<cfelse>
							EMPLOYEES_PUANTAJ,
							EMPLOYEES_PUANTAJ_ROWS
						</cfif>
						WHERE 
							EMPLOYEES_PUANTAJ.PUANTAJ_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_type#"> AND
							EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND 
							EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
							EMPLOYEES_PUANTAJ.SAL_MON < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.SAL_MON#"> AND 
							EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID IN (#employee_list#)
					</cfquery>
				</cfif>
				<cfloop query="get_puantaj_rows">
					<div id="printBordroIcmal" style="page-break-after: always;">
						<cfset index_id = get_puantaj_rows.currentrow>
						<cfset attributes.employee_id = get_puantaj_rows.employee_id[index_id]>
						<cfquery name="GET_PUANTAJ_PERSONAL" dbtype="query">
							SELECT 
								*
							FROM
								get_puantaj_rows
							WHERE
								EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">
						</cfquery>
						<cfif not GET_PUANTAJ_PERSONAL.recordcount>
							<script type="text/javascript">
								alert("3- <cf_get_lang dictionary_id ='53775.Bu çalışan için puantaj kaydı'> <cfif not session.ep.ehesap><cf_get_lang dictionary_id ='53028.veya Yetkiniz'></cfif><cf_get_lang dictionary_id='58546.Yok'>!");
								history.back();
							</script>
							<cfabort>
						</cfif>
						<cfquery name="get_ogis" dbtype="query"><!--- özel gider indirimi sube ile baglanabilirdi ama gerek yok x yilin y ayinda bir kisi icin bir satir olabilir --->
							SELECT
								OGI_DAMGA_TOPLAM,
								OGI_ODENECEK_TOPLAM
							FROM
								get_ogis_all
							WHERE
								EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">
						</cfquery>
						<cfif not get_ogis.recordcount>
							<!--- 20050215 ocak ayinda bu tutarlar puantajdan gelen kisiye bagli olmadigi icin 0 set ediliyor --->
							<cfset get_ogis.OGI_DAMGA_TOPLAM = 0>
							<cfset get_ogis.OGI_ODENECEK_TOPLAM = 0>
						</cfif>
						<cfquery name="get_kumulatif_gelir_vergisi" dbtype="query">
							SELECT SUM(GELIR_VERGISI) AS TOPLAM FROM get_kumulatif_gelir_vergisi_all WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">
						</cfquery> 
						<cfquery name="get_odeneks" dbtype="query">
							SELECT * FROM get_odeneks_all WHERE EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#"> AND EXT_TYPE = 0 ORDER BY COMMENT_PAY
						</cfquery>
						<cfquery name="get_kesintis" dbtype="query">
							SELECT * FROM get_odeneks_all WHERE EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#"> AND EXT_TYPE = 1 ORDER BY COMMENT_PAY
						</cfquery>
						<cfquery name="get_vergi_istisnas" dbtype="query">
							SELECT * FROM get_odeneks_all WHERE EMPLOYEE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PUANTAJ_PERSONAL.EMPLOYEE_PUANTAJ_ID#"> AND EXT_TYPE = 2 ORDER BY COMMENT_PAY
						</cfquery>
						<cfset icmal_type = "personal">
						<cfoutput query="get_puantaj_personal">
							<cfset temp_query_1 = QueryRow(get_puantaj_personal,currentrow)>
							<cfset query_name = "temp_query_1">
							<table cellpadding="0" cellspacing="0" style="width:210mm;height:284.9mm;" align="center" border="0">
								<tr>
									<td height="5">&nbsp;</td>
								</tr>
								<tr>
									<td valign="top">
										<cfif GET_PUANTAJ_PERSONAL.use_pdks eq 2>
											<cfinclude template="view_icmal_pdks.cfm">
										<cfelse>
											<cfinclude template="view_icmal.cfm">
										</cfif>
									</td>
								</tr>
							</table>
						</cfoutput>
					</div>
				</cfloop>
		</cfif>
	</cfif>
<cfelseif isdefined("attributes.EMPLOYEE_ID")>
	<br/>
	<cfset attributes.action_type = "pusula_görüntüleme">
	<cfquery name="get_relatives" datasource="#dsn#">
		SELECT * FROM EMPLOYEES_RELATIVES WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND (RELATIVE_LEVEL = '3' OR RELATIVE_LEVEL = '4' OR RELATIVE_LEVEL = '5')
	</cfquery>
	<cfquery name="get_hr_ssk" datasource="#dsn#">
		SELECT
			E.EMPLOYEE_ID,
			EI.BIRTH_DATE,
			EIO.IN_OUT_ID,
			E.EMPLOYEE_NO,
			E.TASK,
			ED.SEX,
			EIO.GROSS_NET,
			EIO.START_DATE,
			EIO.FINISH_DATE,
			EIO.USE_SSK,
			EIO.USE_TAX,
			EIO.IS_TAX_FREE,
			EIO.IS_DAMGA_FREE,
			EIO.SSK_STATUTE,
			EIO.IS_DISCOUNT_OFF,
			EIO.IS_USE_506,
			EIO.DAYS_506,
			EIO.DEFECTION_LEVEL,
			EIO.SOCIALSECURITY_NO,
			EIO.TRADE_UNION_DEDUCTION,
			EIO.FAZLA_MESAI_SAAT,
			EIO.LAW_NUMBERS,
			EIO.KIDEM_AMOUNT, 
			EIO.IHBAR_AMOUNT, 
			EIO.KULLANILMAYAN_IZIN_AMOUNT,
			EIO.GROSS_COUNT_TYPE,
			EIO.FINISH_DATE,
			EIO.VALID,
			BRANCH.BRANCH_ID,
			BRANCH.DANGER_DEGREE,
			BRANCH.DANGER_DEGREE_NO,
			BRANCH.KANUN_5084_ORAN,
			BRANCH.IS_5615,
			BRANCH.IS_5615_TAX_OFF,
			BRANCH.IS_5510 AS SUBE_IS_5510,
			EIO.IS_5084,
			EIO.IS_5510,
			(SELECT EIOP.EXPENSE_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,BRANCH B2 WHERE B2.BRANCH_ID = EIO.BRANCH_ID AND B2.COMPANY_ID = EIOP.PERIOD_COMPANY_ID AND EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_YEAR = #attributes.sal_year#) AS EXPENSE_CODE,
			(SELECT EIOP.ACCOUNT_CODE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,BRANCH B2 WHERE B2.BRANCH_ID = EIO.BRANCH_ID AND B2.COMPANY_ID = EIOP.PERIOD_COMPANY_ID AND EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_YEAR = #attributes.sal_year#) AS ACCOUNT_CODE,
			(SELECT EIOP.ACCOUNT_BILL_TYPE FROM EMPLOYEES_IN_OUT_PERIOD EIOP,BRANCH B2 WHERE B2.BRANCH_ID = EIO.BRANCH_ID AND B2.COMPANY_ID = EIOP.PERIOD_COMPANY_ID AND EIOP.IN_OUT_ID = EIO.IN_OUT_ID AND EIOP.PERIOD_YEAR = #sal_year#) AS ACCOUNT_BILL_TYPE,
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			BRANCH.COMPANY_ID,
			DEPARTMENT.DEPARTMENT_HEAD,
			OUR_COMPANY.NICK_NAME COMP_NICK_NAME,
			OUR_COMPANY.COMPANY_NAME COMP_FULL_NAME,
			OUR_COMPANY.ASSET_FILE_NAME2,
			OUR_COMPANY.ASSET_FILE_NAME2_SERVER_ID,
			BRANCH.BRANCH_FULLNAME,
			BRANCH.BRANCH_NAME,
			BRANCH.SSK_OFFICE,
			BRANCH.SSK_NO,
			EIO.BRANCH_ID,
			EIO.PUANTAJ_GROUP_IDS,
			EIO.IS_6486,
			BRANCH.KANUN_6486,
			ADDITIONAL_INDICATOR_COMPENSATION,
			IS_EDUCATION_ALLOWANCE,
			GRADE_NORMAL,
			STEP_NORMAL,
			ADDITIONAL_SCORE_NORMAL,
			WORK_DIFFICULTY,
			BUSINESS_RISK_EMP,
			JUL_DIFFICULTIES,
			FINANCIAL_RESPONSIBILITY,
			SEVERANCE_PENSION_SCORE
		FROM
			EMPLOYEES_IDENTY EI,
			EMPLOYEES_DETAIL ED,
			EMPLOYEES_IN_OUT EIO,
			BRANCH,
			DEPARTMENT,
			OUR_COMPANY,
			EMPLOYEES E
		WHERE
			EIO.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
			BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
			E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
			E.EMPLOYEE_ID = ED.EMPLOYEE_ID AND
			E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
			(EIO.IS_PUANTAJ_OFF = 0 OR EIO.IS_PUANTAJ_OFF IS NULL) AND
			EIO.EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_ID#">
			<cfif isdefined('attributes.sal_year_end') and len(attributes.sal_year_end) and isdefined('attributes.sal_mon_end') and len(attributes.sal_mon_end)>
				AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(attributes.sal_year_end,attributes.sal_mon_end,daysinmonth(CreateDate(sal_year_end,attributes.sal_mon_end,1)))#">
			<cfelse>
				AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(attributes.sal_year,attributes.sal_mon,daysinmonth(CreateDate(sal_year,attributes.sal_mon,1)))#">
			</cfif>
			AND
			(
				(EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(sal_year,attributes.sal_mon,1)#">)
				OR
				EIO.FINISH_DATE IS NULL
			)
			AND BRANCH.BRANCH_ID = EIO.BRANCH_ID
		<cfif not session.ep.ehesap>
			AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
		</cfif>
		ORDER BY
			E.EMPLOYEE_NAME,
			E.EMPLOYEE_SURNAME,
			EIO.START_DATE
	</cfquery>
	<cfif not get_hr_ssk.recordcount>
		<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='45471.Kişi İçin Uygun Giriş - Çıkış Kaydı Bulunamadı!'>");
		window.close();
		</script>
		<cfabort>
	</cfif>
	<cfinclude template="../query/get_hr_compass_loop.cfm">
</cfif>
<cfif fusebox.fuseaction is 'popupflush_view_puantaj_print' and not style is 'one'>
	<script type="text/javascript">
		window.print();
	</script>
</cfif>
</div>
<script type="text/javascript">
	function control_date()
	{
		if(document.getElementById('employee_id').value == "" || document.getElementById('employee_name').value == "")
		{
			alert('<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="57576.Çalışan">');
			return false;	
		}
		if (parseInt(document.getElementById('sal_year').value) == parseInt(document.getElementById('sal_year_end').value))
		{
			if (parseInt(document.getElementById('sal_mon').value) > parseInt(document.getElementById('sal_mon_end').value))
			{
				
				alert("<cf_get_lang dictionary_id='40467.Başlangıç tarihi bitiş tarihinden büyük olmamalıdır'>.");
				return false;
			}
		}
		else if (parseInt(document.getElementById('sal_year').value) > parseInt(document.getElementById('sal_year_end').value))
		{
			
			{
				alert("<cf_get_lang dictionary_id='40467.Başlangıç tarihi bitiş tarihinden büyük olmamalıdır'>.");
				return false;
			}
		}
		return true;
	}
	function change_mon(i)
	{
		$('#sal_mon_end').val(i);
	}	
	function print_puantaj(){
		<cfif attributes.fuseaction eq 'ehesap.popup_puantaj_print' or attributes.fuseaction eq 'ehesap.popup_view_price_compass'>
			$(".printBordroIcmal").css({'background-color':'#fff'});
			$("form[name=employee],#wrk_bug_add_div,.portHeadLight,font").css("display","none");
			window.print();
			$("form[name=employee],#wrk_bug_add_div,.portHeadLight,font").css("display","block");
			$(".portHeadLight,font").css("display","flex");
		<cfelse>
			$('#printBordroIcmal').printThis();
		</cfif>
	}
</script>
<cf_get_lang_set module_name="#listgetat(attributes.fuseaction,1,'.')#">