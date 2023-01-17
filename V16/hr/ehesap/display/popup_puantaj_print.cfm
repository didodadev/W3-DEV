<cfparam name="attributes.sal_year" default="#year(now())#">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.department" default="">
<cfparam name="attributes.ssk_office" default="">
<cfparam name="attributes.is_submit" default="0">
<cfparam name="attributes.duty_type" default="">
<cfparam name="attributes.collar_type" default="">
<cfparam name="attributes.title_id" default="">
<cfif month(now()) eq 1>
	<cfparam name="attributes.sal_mon" default="1">
<cfelse>
	<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
</cfif>
<cfinclude template="../query/get_ssk_offices.cfm">
<cfset periods = createObject('component','V16.objects.cfc.periods')>
<cfset period_years = periods.get_period_year()>

<cfquery name="GET_DET_FORM" datasource="#dsn3#">
  	SELECT 
		SPF.TEMPLATE_FILE,
		SPF.FORM_ID,
		SPF.NAME,
		SPF.PROCESS_TYPE,
		SPF.MODULE_ID,
		SPFC.PRINT_NAME
	FROM 
		SETUP_PRINT_FILES SPF,
		#dsn_alias#.SETUP_PRINT_FILES_CATS SPFC
	WHERE
		SPF.ACTIVE = 1 AND
		SPFC.PRINT_TYPE = SPF.PROCESS_TYPE AND
		SPFC.PRINT_TYPE = 180
</cfquery>
<cfscript>
	cmp_title = createObject("component","V16.hr.cfc.get_titles");
	cmp_title.dsn = dsn;
	get_title = cmp_title.get_title();
</cfscript>
<script type="text/javascript">
	function showDepartment(branch_id)	
		{
			var branch_id = list_getat(document.getElementById('ssk_office').value, 3, '-');
			if (branch_id != "")
			{
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&upper_dep=1&branch_id="+branch_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE',1,"<cf_get_lang dictionary_id='54322.İlişkili Departmanlar'>");
			}
			else
			{
				var myList = document.getElementById("department");
				myList.options.length = 0;
				var txtFld = document.createElement("option");
				txtFld.value='';
				txtFld.appendChild(document.createTextNode('<cf_get_lang dictionary_id="57572.Departman">'));
				myList.appendChild(txtFld);
			}
		}

	function sbmtKontrol()
	{
		/*
		if (document.getElementById('form_type').value == "")
		{
			alert("<cf_get_lang no='1378.Lütfen Yazıcı Belge Tipi seçin'>!");
			return false;
		}
		*/
		if(document.getElementById('ssk_office').value == "")
		{
			alert("<cf_get_lang dictionary_id='58579.Lütfen Şube Seçiniz'>");
			return false;
		}
		<!---if(document.getElementById('ssk_office').value == "")
		{
			alert("<cf_get_lang_main no='1167.Lütfen Şube Seçiniz'>");
			return false;
		}--->
		return true;
	}
	function change_mon(i)
	{
		$('#sal_mon_end').val(i);
	}
</script>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
<cfform name="employee" method="post" action="#request.self#?fuseaction=ehesap.popup_puantaj_print" onsubmit="return sbmtKontrol();">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="58650.Puantaj"></cfsavecontent>
    <cf_box title="#message#" no_display="1">
		<cf_box_search>
			<input name="is_submit" id="is_submit" type="hidden" value="1" />
			<div class="form-group">
				<cfinput type="text" name="keyword" id="keyword" style="width:130px; float:left;" value="#attributes.keyword#" maxlength="255">
			</div>			
			<div class="form-group">
				<select name="sal_mon" id="sal_mon" onchange="change_mon(this.value);">
					<cfloop from="1" to="12" index="i">
						<cfoutput>
							<option value="#i#"<cfif attributes.sal_mon eq i> selected</cfif>>#listgetat(ay_list(),i,',')#</option>
						</cfoutput>
					</cfloop>
				</select>
			</div>
			<div class="form-group">
				<select name="sal_year" id="sal_year">
					<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
						<cfoutput>
							<option value="#i#" <cfif (isdefined("attributes.sal_year") and attributes.sal_year eq i) or (not isdefined("attributes.sal_year") and year(now()) eq i)>selected</cfif>>#i#</option>
						</cfoutput>
					</cfloop>
				</select>
			</div>
			<div class="form-group">
				<select name="sal_mon_end" id="sal_mon_end">
					<cfloop from="1" to="12" index="i">
						<cfoutput>
							<option value="#i#" <cfif (isdefined("attributes.sal_mon_end") and attributes.sal_mon_end eq i) or (not isdefined("attributes.sal_mon_end") and attributes.sal_mon eq i)>selected</cfif>>#listgetat(ay_list(),i,',')#</option>
						</cfoutput>
					</cfloop>
				</select>
			</div>
			<div class="form-group">
				<select name="sal_year_end" id="sal_year_end">
					<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
						<cfoutput>
							<option value="#i#" <cfif (isdefined("attributes.sal_year_end") and attributes.sal_year_end eq i) or (not isdefined("attributes.sal_year_end") and year(now()) eq i)>selected</cfif>>#i#</option>
						</cfoutput>
					</cfloop>
				</select>
			</div>
			<div class="form-group">
				<select name="form_type" id="form_type" style="width:170px;">
					<option value=""><cf_get_lang dictionary_id='57792.Modül İçi Yazıcı Belgeleri'></option>
					<cfoutput query="get_det_form">
						<option value="#form_id#" <cfif isdefined("attributes.form_type") and attributes.form_type eq form_id>selected</cfif>>
							#name# - #print_name#
						</option>
					</cfoutput>
				</select>
			</div>
			<div class="form-group">
				<cf_wrk_search_button button_type="4">
			</div>
			<div class="form-group">
				<cf_workcube_file_action pdf='1' mail='1' doc='1' print='0' trail='0' search_buttons='1'  extra_parameters="is_puantaj_print" tag_module="pdf" >
			</div>
			<div class="form-group">
				<a href="javascript://" onClick="print_puantaj();" class="ui-btn ui-btn-gray2">
					<i class="fa fa-print" title="Yazdır" id="list_print_button"></i>
				</a>
			</div>
		</cf_box_search>
        <cf_box_search_detail>
			<div class="col col-4 col-md-6 col-xs-12" type="column" sort="true" index="1">
				<div class="form-group" id="item-title">
					<label class="col col-12"><cf_get_lang dictionary_id="57571.Ünvan"></label>
					<div class="col col-12 multiselect-z1">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id="57571.Ünvan"></cfsavecontent>
						<cf_multiselect_check
								query_name="get_title"
								name="title_id"
								width="140"
								option_value="TITLE_ID"
								option_name="TITLE"
								option_text="#message#"
								value="#attributes.title_id#">
					</div>
				</div>
				<div class="form-group" id="item-collar_type">
					<label class="col col-12"><cf_get_lang dictionary_id='54054.Yaka Tipi'></label>
					<div class="col col-12">
						<select name="collar_type" id="collar_type">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<option value="1"<cfif attributes.collar_type eq 1> selected</cfif>><cf_get_lang dictionary_id='54055.Mavi Yaka'></option> 
							<option value="2"<cfif attributes.collar_type eq 2> selected</cfif>><cf_get_lang dictionary_id='54056.Beyaz Yaka'></option>
						</select>
					</div>
				</div>			
				<div class="form-group" id="item-type"><!--- 04092019ERU toplam göster - dağılım göster selectbox'ı eklenmiştir.--->
					<label class="col col-12"><cf_get_lang dictionary_id='43721.Görünüm Tipi '></label>
					<div class="col col-12">
						<select name="view_type" id="view_type">
							<option value="0" <cfif isdefined("attributes.view_type") and attributes.view_type eq 0>selected</cfif>><cf_get_lang dictionary_id='46074.Toplam Göster'></option> <!--- Toplam Göster: Seçilen aylar arasındaki kişilerin puantajlarının toplamı şeklinde gösterir --->
							<option value="1" <cfif isdefined("attributes.view_type") and attributes.view_type eq 1>selected</cfif>><cf_get_lang dictionary_id='46076.Dağılım Göster'></option><!--- Dağılım Göster: Seçilen aylar arasındaki kişilerin puantajlarınıher ay için ayrı ayrı gösterir --->
						</select>
					</div>
				</div>
			</div>
			<div class="col col-4 col-md-6 col-xs-12" type="column" sort="true" index="2">
				<div class="form-group" id="item-branch">
					<label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
					<div class="col col-12">
						<select name="ssk_office" id="ssk_office" onChange="showDepartment(list_getat(this.value, 3, '-'))">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<cfoutput query="GET_SSK_OFFICES">
								<cfif len(SSK_OFFICE) and len(SSK_NO)>
									<!--- <cfif not (isdefined("attributes.ssk_office") and len(attributes.ssk_office))><cfset attributes.ssk_office = "#SSK_OFFICE#-#SSK_NO#-#BRANCH_ID#"></cfif> --->
									<option value="#replace(ssk_office,'-',' ')#-#replace(ssk_no,'-',' ')#-#branch_id#"<cfif attributes.ssk_office is "#replace(ssk_office,'-',' ')#-#replace(ssk_no,'-',' ')#-#branch_id#"> selected</cfif>>#branch_name#-#ssk_office#-#ssk_no#</option>
								</cfif>
							</cfoutput>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-department">
					<label class="col col-12"><cf_get_lang dictionary_id='57572.Departman'></label>
					<div class="col col-12" id="DEPARTMENT_PLACE">
						<select name="department" id="department" style="width:120px;">
							<option value=""><cf_get_lang dictionary_id='57734.Seciniz'></option>
							<cfif isdefined("attributes.ssk_office") and Len(attributes.ssk_office)>
								<cfquery name="get_departmant" datasource="#dsn#">
									SELECT 
										DEPARTMENT_ID, 
										DEPARTMENT_HEAD,
										HIERARCHY_DEP_ID
									FROM 
										DEPARTMENT 
									WHERE 
										BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#ListGetAt(attributes.ssk_office, 3, '-')#"> 
										AND DEPARTMENT_STATUS = 1
									ORDER BY 
										HIERARCHY_DEP_ID,DEPARTMENT_HEAD
								</cfquery>
								<cfoutput query="get_departmant">
									<cfset uzunluk = listlen(HIERARCHY_DEP_ID,'.')>
									<cfif HIERARCHY_DEP_ID eq DEPARTMENT_ID>
										<option value="#HIERARCHY_DEP_ID#"<cfif isdefined('attributes.department') and (attributes.department eq get_departmant.DEPARTMENT_ID)>selected</cfif>>#DEPARTMENT_HEAD#</option>
									<cfelse>
										<option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department') and (attributes.department eq get_departmant.DEPARTMENT_ID)>selected</cfif>><cfif uzunluk eq 2>&nbsp;&nbsp;&nbsp;&nbsp;<cfelseif uzunluk eq 3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cfelseif uzunluk eq 4>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</cfif>#DEPARTMENT_HEAD#</option>
									</cfif>
								</cfoutput>
							</cfif>
						</select>
					</div>
				</div>
			</div>
			<div class="col col-4 col-md-6 col-xs-12" type="column" sort="true" index="3">
				<div class="form-group" id="item-print">
					<label class="col col-12"><cf_get_lang dictionary_id="46420.Print Tipi"></label>
					<div class="col col-12">
						<select name="print_type" id="print_type">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<option value="1"><cf_get_lang dictionary_id="46600.Normal çıktı"></option>
							<option value="2"><cf_get_lang dictionary_id="46599.PDF çıktı"></option>
						</select>
					</div>
				</div>
				<div class="form-group" id="item-duty_type">
					<label class="col col-12"><cf_get_lang dictionary_id='58538.Görev Tipi'></label>
					<div class="col col-12">
						<select name="duty_type" id="duty_type" style="width:130px; float:left;">
							<option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
							<option value="2"<cfif attributes.duty_type eq 2>selected</cfif>><cf_get_lang dictionary_id='57576.Çalışan'></option>
							<option value="1"<cfif attributes.duty_type eq 1>selected</cfif>><cf_get_lang dictionary_id="53140.İşveren Vekili"></option>
							<option value="0"<cfif attributes.duty_type eq 0>selected</cfif>><cf_get_lang dictionary_id='53550.İşveren'></option>
							<option value="3"<cfif attributes.duty_type eq 3>selected</cfif>><cf_get_lang dictionary_id="53152.Sendikalı"></option>
							<option value="4"<cfif attributes.duty_type eq 4>selected</cfif>><cf_get_lang dictionary_id="53178.Sözleşmeli"></option>
							<option value="5"<cfif attributes.duty_type eq 5>selected</cfif>><cf_get_lang dictionary_id="53169.Kapsam Dışı"></option>
							<option value="6"<cfif attributes.duty_type eq 6>selected</cfif>><cf_get_lang dictionary_id="53182.Kısmi İstihdam"></option>
							<option value="7"<cfif attributes.duty_type eq 7>selected</cfif>><cf_get_lang dictionary_id="53199.Taşeron"></option>
						</select>
					</div>
				</div>
			</div>
        </cf_box_search_detail>
	</cf_box>
</cfform>
</div>
<!-- sil -->
<cfif isdefined("attributes.is_submit") and attributes.is_submit eq 1>
	<!---<cfif not len(attributes.SSK_OFFICE) and not (isdefined('attributes.hierarchy') and len(attributes.hierarchy))>
		<script type="text/javascript">
			alert("<cf_get_lang no ='1194.SSK Ofis Bilgileri veya Hierarşi Kodu Eksik'>!");
			window.close();
		</script>
		<cfabort>
	</cfif>--->
	<cfset puantaj_gun_ = daysinmonth(createdate(attributes.sal_year_end,attributes.sal_mon_end,1))>
	<cfif not isdefined("attributes.puantaj_id")>
		<cfset puantaj_start_ = createodbcdatetime(createdate(attributes.sal_year,attributes.sal_mon,1))>
		<cfset puantaj_finish_ = createodbcdatetime(date_add("d",1,createdate(attributes.sal_year_end,attributes.sal_mon_end,puantaj_gun_)))>
	</cfif>
	<cfset bu_ay_sonu = createodbcdatetime(date_add("d",1,createdate(attributes.sal_year_end,attributes.sal_mon_end,puantaj_gun_)))>
	<cfquery name="get_puantaj_rows" datasource="#dsn#">
		SELECT
			EMPLOYEES_PUANTAJ_ROWS.*,
			EMPLOYEES_PUANTAJ.*,
			EMPLOYEES.HIERARCHY,
			EMPLOYEES.EMPLOYEE_NO,
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			EMPLOYEES.GROUP_STARTDATE,
			EMPLOYEES.KIDEM_DATE,
			EMPLOYEES_IDENTY.TC_IDENTY_NO,
			EMPLOYEES_IDENTY.BIRTH_DATE,
			BRANCH.*,
			EMPLOYEES_IN_OUT.IS_5084 AS KISI_5084,
			EMPLOYEES_IN_OUT.IS_5510 AS KISI_5510,
			EMPLOYEES_IN_OUT.USE_PDKS,
			BRANCH.SSK_NO AS B_SSK_NO,
			DEPARTMENT.DEPARTMENT_HEAD,
			OUR_COMPANY.COMPANY_NAME,
			OUR_COMPANY.WEB,
			OUR_COMPANY.ADDRESS,
			OUR_COMPANY.T_NO,
			OPR.*,
			EMPLOYEES_IN_OUT.*
		FROM
			EMPLOYEES_PUANTAJ_ROWS
			LEFT JOIN OFFICER_PAYROLL_ROW OPR ON OPR.EMPLOYEE_PAYROLL_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_PUANTAJ_ID
			INNER JOIN EMPLOYEES_PUANTAJ ON EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
			INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID
			INNER JOIN EMPLOYEES_IN_OUT ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID AND EMPLOYEES_PUANTAJ_ROWS.IN_OUT_ID = EMPLOYEES_IN_OUT.IN_OUT_ID
			INNER JOIN EMPLOYEES_IDENTY ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID
			INNER JOIN DEPARTMENT ON EMPLOYEES_IN_OUT.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID
			INNER JOIN BRANCH ON BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID
			INNER JOIN OUR_COMPANY ON BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID
		WHERE
			1 = 1
			<cfif not isdefined("attributes.puantaj_id")>
				AND EMPLOYEES_IN_OUT.START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_finish_#">
				AND (EMPLOYEES_IN_OUT.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#puantaj_start_#"> OR EMPLOYEES_IN_OUT.FINISH_DATE IS NULL)
			</cfif>
			<cfif isdefined("attributes.employee_name") and len(attributes.employee_name)>
				AND EMPLOYEES.EMPLOYEE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.employee_name#%">
			</cfif>
			<cfif isdefined("attributes.collar_type") and Len(attributes.collar_type)>
				AND EMPLOYEES.EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.COLLAR_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.collar_type#">)
			</cfif>
			<cfif isdefined('attributes.duty_type') and len(attributes.duty_type)>
				AND EMPLOYEES_IN_OUT.DUTY_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.duty_type#">
			</cfif>
			<cfif isdefined('attributes.title_id') and len(attributes.title_id)>
				AND EMPLOYEES_PUANTAJ_ROWS.TITLE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.title_id#">)
			</cfif>
			<cfinclude template="../../query/get_emp_codes.cfm">
			<cfif fusebox.dynamic_hierarchy>
				<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
					<cfif database_type is "MSSQL">
						AND ('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
					<cfelseif database_type is "DB2">
						AND ('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
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
			<cfif not isdefined("attributes.puantaj_id") and not isdefined("attributes.list_employee_id")>
				AND (
					(EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					OR
					(
						EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
						(
							EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
							(EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						)
					)
					OR
					(
						EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						(
							EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
							(EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						)
					)
					OR
					(
						EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
						EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
						EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
					)
				)
				<cfif isdefined("attributes.SSK_OFFICE") and len(attributes.SSK_OFFICE)>
					AND EMPLOYEES_PUANTAJ.SSK_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.ssk_office,3,'-')#">
				</cfif>
			<cfelseif isdefined("attributes.puantaj_id")>
				AND EMPLOYEES_PUANTAJ.PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.puantaj_id#">
			<cfelseif attributes.style is 'list' and isdefined("attributes.list_employee_id")>
				AND (
					(EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
					OR
					(
						EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
						(
							EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
							(EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						)
					)
					OR
					(
						EMPLOYEES_PUANTAJ.SAL_YEAR > <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND 
						(
							EMPLOYEES_PUANTAJ.SAL_YEAR < <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> OR
							(EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#"> AND EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#">)
						)
					)
					OR
					(
						EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year_end#"> AND
						EMPLOYEES_PUANTAJ.SAL_MON >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#"> AND
						EMPLOYEES_PUANTAJ.SAL_MON <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon_end#">
					)
				)
				AND EMPLOYEES.EMPLOYEE_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#attributes.list_employee_id#">)
			</cfif>
			<cfif not session.ep.ehesap>
				AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">)
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				<cfif database_type is "MSSQL">
					AND ((EMPLOYEES.EMPLOYEE_NAME + ' ' + EMPLOYEES.EMPLOYEE_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2></cfif>%#attributes.keyword#%' OR EMPLOYEES_IN_OUT.SOCIALSECURITY_NO = '#attributes.keyword#' OR EMPLOYEES_IDENTY.TC_IDENTY_NO = '#attributes.keyword#' OR EMPLOYEES.EMPLOYEE_NO = '#attributes.keyword#')
				<cfelse>
					AND ((EMPLOYEES.EMPLOYEE_NAME || ' ' || EMPLOYEES.EMPLOYEE_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2></cfif>%#attributes.keyword#%' OR EMPLOYEES_IN_OUT.SOCIALSECURITY_NO = '#attributes.keyword#' OR EMPLOYEES_IDENTY.TC_IDENTY_NO = '#attributes.keyword#')
				</cfif>
			</cfif>
			<cfif isdefined('attributes.department') and len(attributes.department)>
				AND DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listlast(attributes.department,'.')#">
			</cfif>
		ORDER BY
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME
	</cfquery>

	<cfif not GET_PUANTAJ_ROWS.RecordCount>
		<script type="text/javascript">
			document.body.innerHTML = "";
			window.location.href = "<cfoutput>#request.self#?fuseaction=ehesap.popup_puantaj_print&keyword=#attributes.keyword#&form_type=#attributes.form_type#&sal_mon=#attributes.sal_mon#&department=#attributes.department#&ssk_office=#attributes.ssk_office#</cfoutput>";
			alert("<cf_get_lang dictionary_id='53712.Puantaj Kaydı Bulunamadı'>!");
		</script>
		<cfabort>
	</cfif>

	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='20'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<br />

	<cfset attributes.action_id = get_puantaj_rows.employee_puantaj_id>

	<cfquery name="GET_FORM" datasource="#dsn3#">
		SELECT TEMPLATE_FILE,FORM_ID,PROCESS_TYPE,IS_STANDART FROM SETUP_PRINT_FILES WHERE PROCESS_TYPE = 180 <cfif len(attributes.form_type)>AND FORM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.form_type#"></cfif> ORDER BY IS_XML,NAME
	</cfquery>
    <cfif GET_FORM.recordcount>
		<cfset get_puantaj_personal = get_puantaj_rows>
		<cfif isDefined('get_form') And get_form.recordcount and len(attributes.form_type)>
			<cfif findNoCase("WTO/", get_form.template_file) gt 0>
				<cfinclude template="/#get_form.template_file#">
			<cfelse>
				<cfinclude template="#file_web_path#settings/#get_form.template_file#">
			</cfif>
		<cfelse>
			<cfset attributes.employee_id = -1>
			<cfset attributes.style = 'all'>
			<cfinclude template="list_icmal_personal.cfm">
		</cfif>
    <cfelse>
    	<cfset attributes.employee_id = -1>
    	<cfset attributes.style = 'all'>
    	<cfinclude template="list_icmal_personal.cfm">
    </cfif>
</cfif>