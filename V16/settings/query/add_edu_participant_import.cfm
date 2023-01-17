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
			alert("<cf_get_lang dictionary_id='63329.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz'>!");
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
		alert("<cf_get_lang dictionary_id='63330.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir.'>");
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
<cfif line_count lte 1>
	<cfoutput> Satırda Zorunlu Alanlar Eksik !</cfoutput>
	<script>
	   window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_add_edu_participant_import</cfoutput>";
   </script>
<cfelse>	
<cfloop from="2" to="#line_count#" index="i">
	<cfset kont=1>
	<cftry>
		<cfset identy_no = trim(listgetat(dosya[i],1,';'))>
		<cfset class_id = trim(listgetat(dosya[i],2,';'))>
		<cfset attendance = trim(listgetat(dosya[i],3,';'))>
		<cfset start_date = trim(listgetat(dosya[i],4,';'))>
		<cfset start_time = trim(listgetat(dosya[i],5,';'))>
		<cfset finish_date = trim(listgetat(dosya[i],6,';'))>
		<cfset finish_time = trim(listgetat(dosya[i],7,';'))>
		<cfset pretest_point = trim(listgetat(dosya[i],8,';'))>
		<cfif (listlen(dosya[i],';') gte 9)>
			<cfset finaltest_point = trim(listgetat(dosya[i],9,';'))> 
		<cfelse>
			<cfset finaltest_point = ''>
		</cfif>
		<cfcatch type="Any">
			<cfoutput>#i#</cfoutput>. satır 1. adımda sorun oluştu.<br/>
			<cfset error_flag = 1>
			<script>
				window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_add_edu_participant_import</cfoutput>";
			</script>
		</cfcatch>  
	</cftry>
	<cfif len(class_id)>
		<cfquery name="get_class" datasource="#dsn#">
			SELECT CLASS_ID FROM TRAINING_CLASS WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#class_id#">
		</cfquery>
	<cfelse>
		<cfset get_class.class_id = ''>
	</cfif>
	<cfif len(identy_no)>
		<cfquery name="geT_id" datasource="#dsn#">
			SELECT DISTINCT
				TYPE,
				ID,
				IDENTITY_NO
			FROM
				(SELECT 
					1 TYPE,
					TCA.EMP_ID ID,
					EI.TC_IDENTY_NO IDENTITY_NO
				FROM 
					TRAINING_CLASS_ATTENDER TCA,
					EMPLOYEES_IDENTY EI
				WHERE
					TCA.EMP_ID = EI.EMPLOYEE_ID
				UNION ALL
				SELECT 
					2 TYPE,
					TCA.CON_ID ID,
					C.TC_IDENTY_NO IDENTITY_NO
				FROM
					TRAINING_CLASS_ATTENDER TCA,
					CONSUMER C
				WHERE 
					TCA.CON_ID = C.CONSUMER_ID
				UNION ALL
				SELECT 
					3 TYPE,
					TCA.PAR_ID ID, 
					CP.TC_IDENTITY IDENTITY_NO
				FROM
					TRAINING_CLASS_ATTENDER TCA,
					COMPANY_PARTNER CP
				WHERE 
					TCA.PAR_ID = CP.PARTNER_ID
				)T1
				WHERE
					IDENTITY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#identy_no#">
		</cfquery>
	<cfelse>
		<cfset get_id.type = ''>
		<cfset get_id.id = ''>
	</cfif>
	<!--- <cfif len(identy_no)>
		<cfquery name="get_employee" datasource="#dsn#">
			SELECT EMPLOYEE_ID FROM EMPLOYEES_IDENTY WHERE TC_IDENTY_NO = '#identy_no#'
		</cfquery>
		<cfquery name="get_partner" datasource="#dsn#">
			SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE TC_IDENTITY = '#identy_no#'
		</cfquery>
		<cfquery name="get_consumer" datasource="#dsn#">
			SELECT CONSUMER_ID FROM CONSUMER WHERE TC_IDENTY_NO = '#identy_no#'
		</cfquery>
	<cfelse>
		<cfset get_employee.employee_id = ''>
		<cfset get_partner.partner_id = ''>
		<cfset get_consumer.consumer_id = ''>
	</cfif> --->
	
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
	<cftry>
		<cflock name="#CreateUUID()#" timeout="60">
			<cftransaction>
				<cfquery name="GET_CLASS_ATTENDER" datasource="#DSN#">
					SELECT CLASS_ID FROM TRAINING_CLASS_ATTENDER WHERE CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.class_id#">
				</cfquery>
				<cfif GET_CLASS_ATTENDER.recordcount>
					<cftry>
						<cfquery name="get_control" datasource="#dsn#">
							SELECT 
								CLASS_ATTENDANCE_ID 
							FROM 
								TRAINING_CLASS_ATTENDANCE 
							WHERE 
								CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.class_id#"> AND
								START_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date#"> AND
								FINISH_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#finish_date#">
						</cfquery>
						<cfif get_control.recordcount>
							<cfset attributes.CLASS_ATTENDANCE_ID = get_control.CLASS_ATTENDANCE_ID>
						<cfelse>
							<cfquery name="add_class_attendance" datasource="#dsn#">
								INSERT INTO
									TRAINING_CLASS_ATTENDANCE
									(
										CLASS_ID,
										START_DATE,
										FINISH_DATE,
										RECORD_DATE,
										RECORD_IP,
										RECORD_EMP
									)
								VALUES
									(
										<cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.class_id#">,
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#start_date#">,
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#finish_date#">,
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
									)
							</cfquery>	
							<cfquery name="get_class_attendance_id" DATASOURCE="#DSN#" maxrows="1">
								SELECT
									MAX(CLASS_ATTENDANCE_ID) AS CLASS_ATTENDANCE_ID
								FROM
									TRAINING_CLASS_ATTENDANCE
								WHERE
									CLASS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.class_id#">
							</cfquery>
							<cfset attributes.CLASS_ATTENDANCE_ID = get_class_attendance_id.CLASS_ATTENDANCE_ID>
						</cfif>
						<cfquery name="add_class_attendance_dt" datasource="#dsn#">
							INSERT INTO
								TRAINING_CLASS_ATTENDANCE_DT
								(
									CLASS_ATTENDANCE_ID,
									ATTENDANCE_MAIN,
									IS_TRAINER,
									<cfif get_id.type eq 1>EMP_ID<cfelseif get_id.type eq 2>CON_ID<cfelseif get_id.type eq 3>PAR_ID</cfif>
								)
							VALUES
								(
									<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.CLASS_ATTENDANCE_ID#">,
									<cfif len(attendance)><cfqueryparam cfsqltype="cf_sql_float" value="#attendance#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_float"></cfif>,
									0,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#get_id.id#">
								)
						</cfquery>
						<cfquery name="add_train_class_results" datasource="#dsn#">
							INSERT INTO
								TRAINING_CLASS_RESULTS
								(
									PRETEST_POINT,
									FINALTEST_POINT,
									<cfif get_id.type eq 1>EMP_ID<cfelseif get_id.type eq 2>CON_ID<cfelseif get_id.type eq 3>PAR_ID</cfif>,
									CLASS_ID
								)
							VALUES
								(
									<cfif len(pretest_point)><cfqueryparam cfsqltype="cf_sql_float" value="#pretest_point#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_float"></cfif>,
									<cfif len(finaltest_point)><cfqueryparam cfsqltype="cf_sql_float" value="#finaltest_point#"><cfelse><cfqueryparam null="yes" value="" cfsqltype="cf_sql_float"></cfif>,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#get_id.id#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#get_class.class_id#">
								)
						</cfquery>
						<cfcatch type="Any">
							<cfoutput>
								#i#. Satırda;<br />
									<cfif not len(get_id.id)>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id='63572.TC Kimlik Numarasını Kontrol Ediniz.'><br/>
									</cfif>
									<cfif not len(get_class.class_id)>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id='63571.Eğitim ID Eksik Kontrol Ediniz.'><br/>
									</cfif>
									<cfif not len(start_date)>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id='63570.Yoklama Başlangıç Tarihini ve Yoklama Başlangıç Saatini Kontrol Ediniz.'><br/>
									</cfif>
									<cfif not len(finish_date)>
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <cf_get_lang dictionary_id='63569.Yoklama Bitiş Tarihini ve Yoklama Bitiş Saatini Kontrol Ediniz.'><br/>
									</cfif>
									<br/>
							</cfoutput>	
							<cfset kont=0>
						</cfcatch>
					</cftry>
				<cfelse>
					<cfset kont=0>
				</cfif>
			</cftransaction>
		</cflock>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='63329.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz'>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch> 
	</cftry>

</cfloop>
<cfoutput><cf_get_lang dictionary_id='44145.Aktarım Başarı İle Yapılmıştır'> <br/></cfoutput>
	<script>
		window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_add_edu_participant_import</cfoutput>";
	</script>
</cfif>
