<cfset upload_folder = "#upload_folder#hr#dir_seperator#eislem#dir_seperator#">
<cfif not directoryexists("#upload_folder#")>
	<cfdirectory action="create" directory="#upload_folder#">
</cfif>

<cftry>
	<cffile
		action = "upload" 
		fileField = "uploaded_file" 
		destination = "#upload_folder#"
		nameConflict = "MakeUnique"  
		mode="777" charset="utf-8">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">

	<!---Script dosyalarını engelle  02092010 FA,ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder##file_name#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>		
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cfquery name="get_all_offtimes" datasource="#dsn#">
	SELECT 
		START_DATE, 
		FINISH_DATE, 
		RECORD_DATE, 
		RECORD_EMP, 
		RECORD_IP, 
		UPDATE_DATE, 
		UPDATE_EMP, 
		UPDATE_IP 
	FROM 
		SETUP_GENERAL_OFFTIMES
</cfquery>
	<cffile action="read" file="#upload_folder##file_name#" variable="dosya">
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cfscript>
				CRLF = Chr(13) & Chr(10);// satır atlama karakteri
				dosya1 = ListToArray(dosya,CRLF);
				line_count = ArrayLen(dosya1);
			</cfscript>
			<cfif line_count eq 1>
				<script type="text/javascript">
					alert("<cf_get_lang no ='1112.Dosya Hatası Lütfen Dosyanızı Kontrol Ediniz'>!");
				</script>
				<cfabort>
			</cfif>
			<cfif listlen(dosya1[1],';') neq 39>
				<script type="text/javascript">
					alert("<cf_get_lang no ='1113.Dosyada Eksik Kolon Var Lütfen Dosyanızı Kontrol Ediniz'>!");
				</script>
				<cfabort>
			</cfif>
			<cfloop from="2" to="#line_count#" index="i">
			<cfset kont=1>
				<cftry>
					<cfset tc_kimlik = trim(listgetat(dosya1[i],2,';'))>
					<cfset employee_name = trim(listgetat(dosya1[i],3,';'))>
					<cfset branch_name = trim(listgetat(dosya1[i],4,';'))>
					<cfset process_stage = trim(listgetat(dosya1[i],6,';'))>
					<cfset shift_status = trim(listgetat(dosya1[i],7,';'))>
					<cfcatch type="Any">
						<cfoutput>#i-1#. Satır Hatalı<br/></cfoutput>	
						<cfset kont=0>
					</cfcatch>  
				</cftry>
			<cfif kont eq 1>
				<cfquery name="get_employee_id" datasource="#dsn#" maxrows="1">
						SELECT
							EI.EMPLOYEE_ID,
							EO.IN_OUT_ID
						FROM
							EMPLOYEES_IDENTY EI,
							EMPLOYEES_IN_OUT EO
							<cfif len(attributes.related_company)>
							,BRANCH B
							</cfif>
						WHERE
							EO.EMPLOYEE_ID = EI.EMPLOYEE_ID 
							AND EI.TC_IDENTY_NO = '#tc_kimlik#'
							<cfif len(attributes.branch_id)>
								AND EO.BRANCH_ID = #attributes.branch_id#
							<cfelseif len(attributes.related_company)>
								AND B.RELATED_COMPANY = '#attributes.related_company#'
								AND EO.BRANCH_ID = B.BRANCH_ID
							</cfif>
							<cfif not len(attributes.branch_id) and isnumeric(branch_name)>
								AND EO.BRANCH_ID = #branch_name#
							</cfif>
						ORDER BY					
							EO.IN_OUT_ID DESC
				</cfquery>
				
				<cfset this_in_out_id_ = get_employee_id.IN_OUT_ID>
				<cfset this_employee_id_ = get_employee_id.EMPLOYEE_ID>
				<!--- Cumartesi haftta tatili mi --->
				<cfquery name="GET_OUR_COMPANY_HOURS" datasource="#dsn#">
					SELECT 
						SATURDAY_OFF 
					FROM 
						OUR_COMPANY_HOURS 
						<cfif isdefined("attributes.related_company") and len(attributes.related_company)>
							,BRANCH B
						</cfif>
					WHERE 
						<cfif isdefined("attributes.related_company") and len(attributes.related_company)>
							B.RELATED_COMPANY = '#attributes.related_company#'
							AND OUR_COMPANY_HOURS.OUR_COMPANY_ID = B.COMPANY_ID
						<cfelse>
							OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
						</cfif>
				</cfquery>
				<cfif GET_OUR_COMPANY_HOURS.recordCount and GET_OUR_COMPANY_HOURS.SATURDAY_OFF eq 1>
					<cfset saturday_off = 1>
				<cfelse>
					<cfset saturday_off = 0>
				</cfif>
				<cfif get_employee_id.recordcount and len(get_employee_id.in_out_id)>
					<cfset j =1>
					<cfloop from="8" to="38" index="mesai_gun">
						<cfset mesai_degeri = trim(listgetat(dosya1[i],mesai_gun,';'))>
						
						<cfif attributes.mesai_type eq 1><!--- saatlik --->
							<cfif mesai_degeri contains ':'>
								<cfset mesai_saat = listfirst(mesai_degeri,':')>
								<cfset mesai_dakika = listlast(mesai_degeri,':')>
							<cfelse>
								<cfset mesai_saat = mesai_degeri>
								<cfset mesai_dakika = 0>
							</cfif>
						<cfelse>
							<cfset mesai_dakika = mesai_degeri>
							<cfset mesai_saat = 0>
						</cfif>
						
						<cfif mesai_saat gt 0 or mesai_dakika gt 0>
							<cfif mesai_saat eq 0 and mesai_dakika gt 60>
								<cfset baslama_saat = 22 - ((mesai_dakika \ 60) + 1)>
							<cfelse>
								<cfset baslama_saat = 23 - (mesai_saat + 1)>
							</cfif>					
							<cfset mesai_saat = baslama_saat + mesai_saat>
							<cfset resmi_gun = 0>
							<cfset mesai_tarih = '#attributes.sal_mon#/#j#/#attributes.sal_year#'>
							<cfset startdate = date_add('h',baslama_saat, mesai_tarih)>
							<cfset startdate = date_add('n',0,startdate)>
							<cfset finishdate = date_add('h',mesai_saat, mesai_tarih)>
							<cfset finishdate = date_add('n',mesai_dakika,finishdate)>
							<cfif get_all_offtimes.recordcount>
								<cfquery name="get_offtime_days" dbtype="query">
									SELECT 
										*
									FROM 
										get_all_offtimes
									WHERE
										#CreateODBCDateTime(mesai_tarih)# BETWEEN START_DATE AND FINISH_DATE
								</cfquery>
								<cfif get_offtime_days.recordcount>
									<cfset resmi_gun = 2>
								</cfif>
								
								<cfif (DayOfWeek(mesai_tarih) eq 7 and saturday_off eq 1) || DayOfWeek(mesai_tarih) eq 1>
									<cfset resmi_gun = 1>
								</cfif>
							</cfif>
								<cfquery name="add_worktime" datasource="#dsn#">
									INSERT INTO
										EMPLOYEES_EXT_WORKTIMES
										(
											FILE_NAME,
											EMPLOYEE_ID,
											WORK_START_TIME,
											WORK_END_TIME,
											START_TIME,
											END_TIME,
											DAY_TYPE,
											RECORD_DATE,
											RECORD_EMP,
											RECORD_IP,
											IN_OUT_ID,
											IS_PUANTAJ_OFF,
											VALID,
											VALIDDATE,
											PROCESS_STAGE,
											WORKTIME_WAGE_STATU
										)
									VALUES
										(
											'#file_name#',
											#this_employee_id_#,
											#startdate#,
											#finishdate#,
											#startdate#,
											#finishdate#,
											#resmi_gun#,
											#now()#,
											#session.ep.userid#,
											'#cgi.REMOTE_ADDR#',
											#this_in_out_id_#,
											<cfif isdefined('attributes.is_puantaj_off') and len(attributes.is_puantaj_off)>1<cfelse>0</cfif>,
											1,
											#now()#,
											#process_stage#,
											#shift_status#
										)
								</cfquery>
								<cfoutput>
									#tc_kimlik#   #employee_name# : Mesai import işlemi tamamlandı.....<br/>
								</cfoutput>	
							</cfif>
						<cfset j = j+1>
					</cfloop>
				<cfelse>
					<cfoutput>
							#tc_kimlik#  #employee_name# : Çalışan ilgili şubede kayıtlı değil.....<br/>
					</cfoutput>	
				</cfif> 
			</cfif>
			</cfloop>
		</cftransaction>
	</cflock>
	<cfquery name="add_file" datasource="#dsn#">
		INSERT INTO
			EMPLOYEES_PUANTAJ_FILES
			(
				PROCESS_TYPE,
				SAL_MON,
				SAL_YEAR,
				BRANCH_ID,
				FILE_NAME,
				FILE_SERVER_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			)
		VALUES
			(
				1,
				#attributes.sal_mon#,
				#attributes.sal_year#,
				<cfif len(attributes.branch_id)>#attributes.branch_id#,<cfelse>NULL,</cfif>
				'#file_name#',
				#fusebox.server_machine#,
				#now()#,
				#session.ep.userid#,
				'#cgi.REMOTE_ADDR#'
			)
	</cfquery>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1114.İmport işlemi tamamlandı '>!");
			<cfif isdefined("attributes.modal_id") and len(attributes.modal_id)>
				location.href = document.referrer;
		<cfelse>
			location.href="<cfoutput>#request.self#?fuseaction=ehesap.list_ext_worktimes</cfoutput>";
		</cfif>
	
		
	</script>

