<cfquery name="get_stage" datasource="#dsn#">
	SELECT
		TOP 1
		PTR.PROCESS_ROW_ID
	FROM
		PROCESS_TYPE PT,
		PROCESS_TYPE_OUR_COMPANY PTOC,
		PROCESS_TYPE_ROWS PTR
	WHERE
		PT.PROCESS_ID = PTR.PROCESS_ID AND 
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTOC.PROCESS_ID AND
		PTOC.OUR_COMPANY_ID = #session.ep.company_id# AND
		CAST(PT.FACTION AS NVARCHAR(2500))+',' LIKE '%training_management.form_add_class%' 
	ORDER BY
		PT.PROCESS_ID
</cfquery>
<cfif get_stage.recordcount and not len(get_stage.PROCESS_ROW_ID)>
    <script language="javascript">
        alert('Tanımlanmış Bir Eğitim Süreci Bulunamadı.Lütfen Eğitim Süreci Tanımlayınız !');
        history.back();
    </script>
    <cfabort>
</cfif>
<cfsetting showdebugoutput="no">
<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
<cftry>
	<cffile action = "upload" 
			fileField = "uploaded_file" 
			destination = "#upload_folder_#"
			nameConflict = "MakeUnique"  
			mode="777" charset="utf-8">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">	
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cftry>
	<cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="utf-8">
	<cffile action="delete" file="#upload_folder_##file_name#">
<cfcatch>
	<script type="text/javascript">
		alert("Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.");
		history.back();
	</script>
	<cfabort>
</cfcatch>
</cftry>
<cfscript>
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,';;','; ;','all');
	dosya = Replace(dosya,';;','; ;','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	counter = 0;
	liste = "";
</cfscript>
<cfloop from="2" to="#line_count#" index="i">
	<cfset kont=1>
	<cftry>
		<cfset class_name = trim(listgetat(dosya[i],1,';'))>
		<cfset training_cat_id = trim(listgetat(dosya[i],2,';'))>
		<cfset training_sec_id = trim(listgetat(dosya[i],3,';'))>
		<cfset training_style = trim(listgetat(dosya[i],4,';'))>
		<cfset date_no = trim(listgetat(dosya[i],5,';'))>
		<cfset hour_no = trim(listgetat(dosya[i],6,';'))>
		<cfset class_place = trim(listgetat(dosya[i],7,';'))>
		<cfset emp_id = trim(listgetat(dosya[i],8,';'))>
		<cfset par_id = trim(listgetat(dosya[i],9,';'))>
		<cfset cons_id = trim(listgetat(dosya[i],10,';'))>
		<cfset class_place_manager = trim(listgetat(dosya[i],11,';'))>
		<cfset class_place_address = trim(listgetat(dosya[i],12,';'))>
		<cfset class_place_tel = trim(listgetat(dosya[i],13,';'))>
		<cfset project_id = trim(listgetat(dosya[i],14,';'))>
		<cfset start_date = trim(listgetat(dosya[i],15,';'))>
		<cfset start_time = trim(listgetat(dosya[i],16,';'))>
		<cfset finish_date = trim(listgetat(dosya[i],17,';'))>
		<cfset finish_time = trim(listgetat(dosya[i],18,';'))>
		<cfif (listlen(dosya[i],';') gte 19)>
			<cfset is_view = trim(listgetat(dosya[i],19,';'))> 
		<cfelse>
			<cfset is_view = ''>
		</cfif>
		<cfcatch type="Any">
			<cfoutput>#i-1#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
			<cfset error_flag = 1>
			<script>
				window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_add_edu_import</cfoutput>";
			</script>
		</cfcatch>  
	</cftry>
	<cfif len(training_cat_id)>
		<cfquery name="get_training_cat" datasource="#dsn#">
			SELECT TRAINING_CAT_ID FROM TRAINING_CAT WHERE TRAINING_CAT_ID IN (#training_cat_id#)
		</cfquery>
	<cfelse>
		<cfset get_training_cat.training_cat_id = ''>
	</cfif>
	<cfif len(training_sec_id) and len(training_cat_id)>
		<cfquery name="get_training_sec" datasource="#dsn#">
			SELECT
				TRAINING_CAT.TRAINING_CAT_ID,
				TRAINING_SEC.TRAINING_SEC_ID
			FROM
				TRAINING_SEC,
				TRAINING_CAT
			WHERE
				TRAINING_SEC.TRAINING_CAT_ID = TRAINING_CAT.TRAINING_CAT_ID
				AND TRAINING_CAT.TRAINING_CAT_ID IN (#training_cat_id#)
				AND TRAINING_SEC.TRAINING_SEC_ID IN (#training_sec_id#)
			ORDER BY
				TRAINING_CAT.TRAINING_CAT,
				TRAINING_SEC.SECTION_NAME
		</cfquery>
	<cfelse>
		<cfset get_training_sec.training_sec_id = ''>
	</cfif>
	<cfif len(training_style)>
		<cfquery name="get_training_style" datasource="#dsn#">
			SELECT TRAINING_STYLE_ID FROM SETUP_TRAINING_STYLE WHERE TRAINING_STYLE_ID IN (#training_style#)
		</cfquery>
	<cfelse>
		<cfset get_training_style.training_style_id = ''>
	</cfif>
	<cfif len(project_id)>
		<cfquery name="get_project" datasource="#dsn#">
			SELECT PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_id#)
		</cfquery>
	<cfelse>
		<cfset get_project.project_id = ''>
	</cfif>
	<cfif len(start_date)>
		<cf_date tarih="start_date">
		<cfif len(start_time)>
			<cfset start_date = date_add('h', listfirst(start_time,':') - session.ep.TIME_ZONE, start_date)>
			<cfset start_date = date_add('n', listlast(start_time,':'), start_date)>
		</cfif>
	</cfif>
	<cfif len(finish_date)>
		<cf_date tarih="finish_date">
		<cfif len(finish_time)>
			<cfset finish_date = date_add('h', listfirst(finish_time,':') - session.ep.TIME_ZONE, finish_date)>
			<cfset finish_date = date_add('n', listlast(finish_time,':'), finish_date)>
		</cfif>
	</cfif>
	<cfquery name="find_department_branch" datasource="#dsn#">
		SELECT
			EMPLOYEE_POSITIONS.EMPLOYEE_ID,
			EMPLOYEE_POSITIONS.POSITION_ID,
			EMPLOYEE_POSITIONS.POSITION_CODE,
			BRANCH.BRANCH_ID,
			BRANCH.BRANCH_NAME,
			DEPARTMENT.DEPARTMENT_ID,
			DEPARTMENT.DEPARTMENT_HEAD
		FROM
			EMPLOYEE_POSITIONS,
			DEPARTMENT,
			BRANCH
		WHERE
			EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
			DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID AND
			EMPLOYEE_POSITIONS.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
	</cfquery>
	<cfif is_view eq 1>
		<cfset view_to_all = 1>
		<cfset is_view_branch = 'NULL'>
		<cfset is_view_department = 'NULL'>
	<cfelseif is_view eq 2>
		<cfset view_to_all = 1>
		<cfset is_view_branch = find_department_branch.branch_id>
		<cfset is_view_department = 'NULL'>
	<cfelseif is_view eq 3>
		<cfset view_to_all = 1>
		<cfset is_view_branch = find_department_branch.branch_id>
		<cfset is_view_department = find_department_branch.department_id>
	<cfelse>
		<cfset view_to_all = 'NULL'>
		<cfset is_view_branch = 'NULL'>
		<cfset is_view_department = 'NULL'>
	</cfif>
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cftry>
				<cfquery name="add_training_class" datasource="#dsn#">
					INSERT INTO
						TRAINING_CLASS
						(
							CLASS_NAME,
							TRAINING_CAT_ID,
							TRAINING_SEC_ID,
							TRAINING_STYLE,
							DATE_NO,
							HOUR_NO,
							CLASS_PLACE,
							<!--- <cfif len(trim(emp_id))>TRAINER_EMP
							<cfelseif len(trim(par_id))>TRAINER_PAR
							<cfelseif len(trim(cons_id))>TRAINER_CONS</cfif>, --->
							CLASS_PLACE_MANAGER,
							CLASS_PLACE_ADDRESS,
							CLASS_PLACE_TEL,
							PROJECT_ID,
							START_DATE,
							FINISH_DATE,
							VIEW_TO_ALL,
							IS_WIEW_BRANCH,
							IS_WIEW_DEPARTMENT,
							IS_INTERNET,
							RECORD_DATE,
							RECORD_IP,
							RECORD_EMP,
                            PROCESS_STAGE
						)
					VALUES
						(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#class_name#">,
							#get_training_cat.training_cat_id#,
							<cfif len(get_training_sec.training_sec_id)>#get_training_sec.training_sec_id#<cfelse>NULL</cfif>,
							<cfif len(get_training_style.training_style_id)>#get_training_style.training_style_id#<cfelse>NULL</cfif>,
							#date_no#,
							#hour_no#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#class_place#">,
							<!--- <cfif len(trim(emp_id))>#emp_id#
							<cfelseif len((par_id))>#par_id#
							<cfelseif len(trim(cons_id))>#cons_id#</cfif>, --->
							<cfif len(class_place_manager)><cfqueryparam cfsqltype="cf_sql_varchar" value="#class_place_manager#"><cfelse>NULL</cfif>,
							<cfif len(class_place_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#class_place_address#"><cfelse>NULL</cfif>,
							<cfif len(class_place_tel)><cfqueryparam cfsqltype="cf_sql_varchar" value="#class_place_tel#"><cfelse>NULL</cfif>,
							<cfif len(project_id)>#get_project.project_id#<cfelse>NULL</cfif>,
							#start_date#,
							#finish_date#,
							#view_to_all#,
							#is_view_branch#,
							#is_view_department#,
							0,
							#now()#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
							#session.ep.userid#,
                            <cfqueryparam  cfsqltype="cf_sql_integer" value="#get_stage.PROCESS_ROW_ID#">
						)
				</cfquery>
				<cfquery name="get_max_id" datasource="#dsn#">
					SELECT MAX(CLASS_ID) AS MAX_ID FROM TRAINING_CLASS
				</cfquery>
				<!--- Eğitimci kaydı  SG20130319--->
				<cfif len(trim(emp_id)) or len(trim(par_id)) or len(trim(cons_id))>
					<cfquery name="add_trainers" datasource="#dsn#">
						INSERT INTO
							TRAINING_CLASS_TRAINERS
							(
								CLASS_ID,
								<cfif len(trim(emp_id))>EMP_ID
								<cfelseif len(trim(par_id))>PAR_ID
								<cfelseif len(trim(cons_id))>CONS_ID</cfif>,	
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP							
							)
							VALUES
							(
								#get_max_id.MAX_ID#,
								<cfif len(trim(emp_id))>#emp_id#
								<cfelseif len((par_id))>#par_id#
								<cfelseif len(trim(cons_id))>#cons_id#</cfif>,		
								#now()#,
								#session.ep.userid#	,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">					
							)
					</cfquery>
				</cfif>
				<cfcatch type="Any"> 
					<cfoutput>
						#i-1#. Satırda; <br />
						<cfif not len(class_name)>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Ders Adı Eksik<br/>
						</cfif> 
						<cfif not len(get_training_cat.training_cat_id)>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Kategori Eksik<br/>
						</cfif>
						<cfif not len(date_no)>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Toplam Gün Eksik<br/>
						</cfif>
						<cfif not len(hour_no)>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Saat Eksik<br/>
						</cfif>
						<cfif not len(class_place)>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Eğitim Yeri Eksik<br/>
						</cfif>
						<cfif not len(start_date)>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Başlangıç Tarihi Eksik<br/>
						</cfif>
						<cfif not len(finish_date)>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*Bitiş Tarihi Eksik<br/>
						</cfif><br />
					</cfoutput>	
					<cfset kont=0>
				</cfcatch>
			</cftry>
			<cfif kont eq 1>
				<cfoutput>#i-1#. Satır İmport Edildi... <br/></cfoutput>
			</cfif>
		</cftransaction>
	</cflock>
</cfloop>
<script>
	window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_add_edu_import</cfoutput>";
</script>
