<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfsetting showdebugoutput="false">
	<cfparam name="attributes.branch_id" default="">
	<cfscript>
		bu_ay_basi = CreateDate(year(now()),month(now()),1);
		bu_ay_sonu = DaysInMonth(bu_ay_basi);
		cmp_branch = createObject("component","hr.cfc.get_branches");
		cmp_branch.dsn = dsn;
		get_branches = cmp_branch.get_branch();
		cmp_department = createObject("component","hr.cfc.get_departments");
		cmp_department.dsn = dsn;
		get_department = cmp_department.get_department(branch_id : '#iif(len(attributes.branch_id),"attributes.branch_id",DE(""))#');
	</cfscript>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.inout_statue" default="2">
	<cfparam name="attributes.startdate" default="#dateformat(date_add('m',-1,bu_ay_basi),'dd/mm/yyyy')#">
	<cfparam name="attributes.finishdate" default="#dateformat(Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu),'dd/mm/yyyy')#">
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
				window.location.href = "<cfoutput>#request.self#?fuseaction=hr.popup_group_print&keyword=#attributes.keyword#&branch_id=#attributes.branch_id#&department=#attributes.department#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#&inout_statue=#attributes.inout_statue#&form_type=#attributes.form_type#</cfoutput>";
				alert("Çalışan Kaydı Bulunamadı!");
			</script>
			<cfabort>
		</cfif>
		
		<cfparam name="attributes.page" default=1>
		<cfparam name="attributes.maxrows" default='20'>
		<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
		
		<cfquery name="GET_FORM" datasource="#dsn3#">
			SELECT TEMPLATE_FILE,FORM_ID,PROCESS_TYPE,IS_STANDART FROM SETUP_PRINT_FILES WHERE FORM_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.form_type#"> ORDER BY IS_XML,NAME
		</cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
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
				txtFld.appendChild(document.createTextNode('<cf_get_lang_main no="160.Departman">'));
				myList.appendChild(txtFld);
			}
		}
		
		function sbmtKontrol()
		{
			if ($('#form_type').val() == "")
			{
				alert("Lütfen Yazıcı Belge Tipi Seçin!");
				return false;
			}
			return true;
		}
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.popup_group_print';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/popup_group_print.cfm';
</cfscript>
