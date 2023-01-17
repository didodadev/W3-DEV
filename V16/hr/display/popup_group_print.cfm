<cfsetting showdebugoutput="false">
<cfparam name="attributes.branch_id" default="">
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
	cmp_branch = createObject("component","V16.hr.cfc.get_branches");
	cmp_branch.dsn = dsn;
	get_branches = cmp_branch.get_branch();
	cmp_department = createObject("component","V16.hr.cfc.get_departments");
	cmp_department.dsn = dsn;
	get_department = cmp_department.get_department(branch_id : '#iif(len(attributes.branch_id),"attributes.branch_id",DE(""))#');
</cfscript>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.inout_statue" default="2">
<cfparam name="attributes.startdate" default="#dateformat(date_add('m',-1,bu_ay_basi),dateformat_style)#">
<cfparam name="attributes.finishdate" default="#dateformat(Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu),dateformat_style)#">
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
		SPFC.PRINT_TYPE = 187
</cfquery>
<cfform name="search_form" method="post" action="#request.self#?fuseaction=hr.popup_group_print">
	<input name="is_submit" id="is_submit" type="hidden" value="1">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id="55901.Toplu Print"></cfsavecontent>
	<cf_box title="#message#" no_display="1" uidrop="1">
	<cf_box_search>
					<div class="form-group">
						<cfinput type="text" placeholder="#getlang('','Filtre','57460')#" name="keyword" id="keyword" style="width:130px; float:left;" value="#attributes.keyword#" maxlength="255">
					</div>
						<div class="form-group medium" id="branch_place">
							<select name="branch_id" id="branch_id" style="width:150px; float:left; margin-left:5px;" onChange="showDepartment(this.value)">
								<option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
								<cfoutput query="get_branches">
									<option value="#branch_id#"<cfif attributes.branch_id eq branch_id> selected</cfif>>#branch_name#</option>
								</cfoutput>
							</select>
						</div>
						<div class="form-group medium" id="department_place">
							<select name="department" id="department" style="width:150px;">
								<option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
								<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
									<cfoutput query="get_department">
										<option value="#department_id#"<cfif isdefined('attributes.department') and attributes.department eq get_department.department_id>selected</cfif>>#department_head#</option>
									</cfoutput>
								</cfif>
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
					<div class="form-group"><cf_wrk_search_button search_function='sbmtKontrol()' button_type="1"></div>
		</cf_box_search>
		<cf_box_search_detail search_function='sbmtKontrol()'>
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
					<div class="input-group">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
				<cfinput type="text" name="startdate" id="startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" value="#attributes.startdate#">
				<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
					</div>
				</div>
			</div>
			<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group">
			<div class="input-group">
			<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
			<cfinput type="text" name="finishdate" id="finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" value="#attributes.finishdate#">
			<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>	
			</div>
			</div>
		</div>
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group">
		<select name="inout_statue" id="inout_statue">
			<option value=""><cf_get_lang dictionary_id='55904.Giriş ve Çıkışlar'></option>
			<option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
			<option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
			<option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id='55905.Aktif Çalışanlar'></option>
		</select>
			</div>
		</div>
		<div class="col col-3 col-md-3 col-sm-3 col-xs-12" type="column" index="1" sort="true">
			<div class="form-group">
				<input type="checkbox" name="is_transfer" id="is_transfer" value="1" <cfif isdefined("attributes.is_transfer") or not isdefined("attributes.is_submit")>checked</cfif>><cf_get_lang dictionary_id="64653.Nakil giriş/çıkış gelmesin">

			</div>
		</div>
			</cf_box_search_detail>
	</cf_box>
</cfform>
<!-- sil -->
<cfif isdefined("attributes.is_submit") and attributes.is_submit eq 1>
	<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
        <cf_date tarih = "attributes.startdate">
    </cfif>
    <cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
        <cf_date tarih = "attributes.finishdate">
    </cfif>
	<cfquery name="get_employees" datasource="#dsn#">
		SELECT
			E.EMPLOYEE_NAME AD,
			E.EMPLOYEE_SURNAME SOYAD,
			E.PHOTO,
			E.PHOTO_SERVER_ID,
			EIO.START_DATE,
			EIO.FINISH_DATE,
			EI.TC_IDENTY_NO TC_KIMLIK,
			EI.FATHER BABA_ADI,
			EI.MOTHER ANA_ADI,
			EI.BIRTH_PLACE DOGUM_YERI,
			EI.BIRTH_DATE DOGUM_TARIHI,
			EI.MARRIED MEDENI_HALI,
			EI.CITY,
			EI.COUNTY,
			EI.WARD,
			EI.VILLAGE,
			EI.NATIONALITY,
			EI.GIVEN_DATE,
			EI.BINDING,
			EI.FAMILY,
			EI.CUE,
			EP.POSITION_NAME,
			ED.SEX,
			ED.HOMEADDRESS,
			B.BRANCH_NAME,
			B.BRANCH_CITY,
			B.BRANCH_COUNTY,
			B.BRANCH_ADDRESS,
			B.BRANCH_TELCODE,
			B.BRANCH_TEL1
		FROM
			EMPLOYEES_IN_OUT EIO
			INNER JOIN EMPLOYEES E ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
			LEFT JOIN EMPLOYEE_POSITIONS EP ON EP.EMPLOYEE_ID = E.EMPLOYEE_ID
			LEFT JOIN EMPLOYEES_DETAIL ED ON E.EMPLOYEE_ID = ED.EMPLOYEE_ID
			LEFT JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
			LEFT JOIN DEPARTMENT D ON D.DEPARTMENT_ID = EP.DEPARTMENT_ID
			LEFT JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
		WHERE
			1=1
			<cfif isdefined('attributes.is_transfer') and attributes.is_transfer eq 1>
				AND EIO.EX_IN_OUT_ID IS NULL AND (EIO.EXPLANATION_ID <> 18 OR EIO.EXPLANATION_ID IS NULL)
			</cfif>
			<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
				AND E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			</cfif>
			<cfif isdefined('attributes.branch_id') and len(attributes.branch_id)>
				AND B.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#">
			</cfif>
			<cfif isdefined('attributes.department') and len(attributes.department)>
				AND D.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.department#">
			</cfif>
			<cfif isdefined('attributes.inout_statue') and attributes.inout_statue eq 1><!--- Girişler --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				</cfif>
			<cfelseif isdefined('attributes.INOUT_STATUE') and attributes.inout_statue eq 0><!--- Çıkışlar --->
				<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
					AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
				</cfif>
				<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
					AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
				</cfif>
		        <cfif isdefined('attributes.explanation_id') and len(attributes.explanation_id)>
					AND EIO.EXPLANATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.explanation_id#">
				</cfif>
				AND	EIO.FINISH_DATE IS NOT NULL
			<cfelseif isdefined('attributes.inout_statue') and attributes.inout_statue eq 2><!--- aktif calisanlar --->
				AND 
				(
					<cfif isdate(attributes.startdate) or isdate(attributes.finishdate)>
						<cfif isdate(attributes.startdate) and not isdate(attributes.finishdate)>
						(
							(
								EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
								EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
							)
							OR
							(
								EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
								EIO.FINISH_DATE IS NULL
							)
						)
						<cfelseif not isdate(attributes.startdate) and isdate(attributes.finishdate)>
						(
							(
								EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
								EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
							OR
							(
								EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#"> AND
								EIO.FINISH_DATE IS NULL
							)
						)
						<cfelse>
						(
							(
								EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
								EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
							OR
							(
								EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
								EIO.FINISH_DATE IS NULL
							)
							OR
							(
								EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
								EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
							OR
							(
								EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#"> AND
								EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
							)
						)
						</cfif>
					<cfelse>
						EIO.FINISH_DATE IS NULL
					</cfif>
				)
			<cfelse><!--- giriş ve çıkışlar Seçili ise --->
				AND 
				(
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EIO.START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EIO.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
					)
					OR
					(
						EIO.START_DATE IS NOT NULL
						<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
							AND EIO.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.startdate#">
						</cfif>
						<cfif isdefined('attributes.finishdate') and isdate(attributes.finishdate)>
							AND EIO.FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finishdate#">
						</cfif>
					)
				)
			</cfif>
	</cfquery>
	
	<cfif not get_employees.recordcount>
		<script type="text/javascript">
			document.body.innerHTML = "";
			window.location.href = "<cfoutput>#request.self#?fuseaction=hr.popup_group_print&keyword=#attributes.keyword#&branch_id=#attributes.branch_id#&department=#attributes.department#&startdate=#dateformat(attributes.startdate,dateformat_style)#&finishdate=#dateformat(attributes.finishdate,dateformat_style)#&inout_statue=#attributes.inout_statue#&form_type=#attributes.form_type#</cfoutput>";
			alert("<cf_get_lang dictionary_id='54638.Çalışan Kaydı Bulunamadı!'>");
		</script>
		<cfabort>
	</cfif>
	
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='20'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<br />
	
	<cfquery name="GET_FORM" datasource="#dsn3#">
		SELECT TEMPLATE_FILE,FORM_ID,PROCESS_TYPE,IS_STANDART FROM SETUP_PRINT_FILES WHERE FORM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.form_type#"> ORDER BY IS_XML,NAME
	</cfquery>
	<cfoutput query="get_employees">
		<cfinclude template="/documents/settings/#get_form.template_file#">
	</cfoutput>
</cfif>
<script type="text/javascript">
	function showDepartment(branch_id)	
	{
		var branch_id = $('#branch_id').val();
		if (branch_id != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=hr.popup_ajax_list_hr&branch_id="+branch_id;
			AjaxPageLoad(send_address,'department_place',1,'İlişkili Departmanlar');
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
		if (document.getElementById('form_type').value == "")
		{
			alert("<cf_get_lang dictionary_id='54324.Lütfen Yazıcı Belge Tipi Seçin'>!");
			return false;
		}
		return true;
	}
</script>
