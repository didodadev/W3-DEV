<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
<cfif not len(attributes.salary_file)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfset upload_folder = "#upload_folder#temp#dir_seperator#">
	<cftry>
		<cffile
			action = "upload" 
			fileField = "salary_file" 
			destination = "#upload_folder#"
			nameConflict = "MakeUnique"  
			mode="777" charset="#attributes.file_format#">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">	
		<cfset file_size = cffile.filesize>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
		
	<cftry>
		<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
		<cffile action="delete" file="#upload_folder##file_name#">
		<cfcatch>
			<script type="text/javascript">
				alert("Dosya Okunamadı ! ");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>

	<cfscript>
		CRLF = Chr(13) & Chr(10);// satır atlama karakteri
		dosya1 = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya1);
	</cfscript>

	<cfif line_count eq 1>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='44524.Dosya Geçersiz veya Satır Sayısı Hatalı. Lütfen Dosyanızı Kontrol Ediniz'>");
		</script>
		<cfabort>
	</cfif>
	<cfif attributes.salary_type eq 1>
		<cfset tablo_ = "EMPLOYEES_SALARY">
	<cfelse>
		<cfset tablo_ = "EMPLOYEES_SALARY_PLAN">
	</cfif>
		
	<cfloop from="2" to="#line_count#" index="i">
		<cfset kont=1>
		<cftry>
			<cfset sira_ = trim(listgetat(dosya1[i],1,';'))>
			<cfset tc_kimlik_ = trim(listgetat(dosya1[i],2,';'))>
			<cfset name_ = trim(listgetat(dosya1[i],3,';'))>				
			<cfset baslangic_ = trim(listgetat(dosya1[i],4,';'))>
			<cfset bitis_ = trim(listgetat(dosya1[i],5,';'))>
			<cfset yil_ = trim(listgetat(dosya1[i],6,';'))>
			<cfset maas_ = trim(listgetat(dosya1[i],7,';'))>
			<cfif maas_ contains ','>
				<cfset maas_ = replace(maas_,',','.',"all")>
			</cfif>
			<cfset para_birimi_ = trim(listgetat(dosya1[i],8,';'))>
			<cfcatch type="Any">
				<cfoutput>#i#.<cf_get_lang dictionary_id='44849.Satır Verilerini Okuma Aşamasında Hata Var.'><br/></cfoutput>	
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
				WHERE
					EO.EMPLOYEE_ID = EI.EMPLOYEE_ID 
					AND EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tc_kimlik_#">
				ORDER BY
					EO.IN_OUT_ID DESC
			</cfquery>
			<cfif not get_employee_id.recordcount>
				<cfoutput>#i#.<cf_get_lang dictionary_id='63414.Satırdaki Kişi Kartı veya Giriş Çıkışı Bulunamadı'>!<br/></cfoutput>	
				<cfset kont=0>
			<cfelse>
				<cfset this_in_out = get_employee_id.in_out_id>
				<cfset this_employee = get_employee_id.EMPLOYEE_ID>
			</cfif>
		</cfif>
		<cfif kont eq 1>
			<cfquery name="check_ssk" datasource="#dsn#">
				SELECT
					*
				FROM
					#tablo_#
				WHERE
					EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_employee#">
					AND PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#yil_#">
					AND IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_in_out#">
			</cfquery>
		<cfif check_ssk.recordcount>
			<cfif attributes.salary_type eq 1>
				<cfquery name="add_salary" datasource="#dsn#">
					INSERT INTO
						EMPLOYEES_SALARY_HISTORY
					(
						EMPLOYEE_ID,
						PERIOD_YEAR,
						M1,
						M2,
						M3,
						M4,
						M5,
						M6,
						M7,
						M8,
						M9,
						M10,
						M11,
						M12,
						MONEY,
						RECORD_IP,
						RECORD_DATE,
						RECORD_EMP,
						IN_OUT_ID
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#this_employee#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#yil_#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#check_ssk.M1#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#check_ssk.M2#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#check_ssk.M3#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#check_ssk.M4#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#check_ssk.M5#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#check_ssk.M6#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#check_ssk.M7#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#check_ssk.M8#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#check_ssk.M9#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#check_ssk.M10#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#check_ssk.M11#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#check_ssk.M12#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#check_ssk.MONEY#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#this_in_out#">
					)
				</cfquery>
			</cfif>
				<cfquery name="upd_salary" datasource="#dsn#">
					UPDATE 
						#tablo_#
					SET
						<cfloop from="#baslangic_#" to="#bitis_#" index="aaa">
							M#aaa# = <cfqueryparam cfsqltype="cf_sql_float" value="#maas_#">,
						</cfloop>
						MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#para_birimi_#">,
						UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
						UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
						UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">
					WHERE
						EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_employee#">
						AND PERIOD_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#yil_#">
						AND IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this_in_out#">
				</cfquery>
			<cfelse>
				<cfquery name="add_salary" datasource="#dsn#">
					INSERT INTO
						#tablo_#
					(
						EMPLOYEE_ID,
						PERIOD_YEAR,
						<cfloop from="#baslangic_#" to="#bitis_#" index="aaa">
							M#aaa#,
						</cfloop>			
						MONEY,
						RECORD_IP,
						RECORD_DATE,
						RECORD_EMP,
						IN_OUT_ID
					)
					VALUES
					(
						<cfqueryparam cfsqltype="cf_sql_integer" value="#this_employee#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#yil_#">,
						<cfloop from="#baslangic_#" to="#bitis_#" index="aaa">
							<cfqueryparam cfsqltype="cf_sql_float" value="#maas_#">,
						</cfloop>			
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#para_birimi_#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#this_in_out#">
					)
				</cfquery>
			</cfif>
			<cfoutput>#i-1#.<cf_get_lang dictionary_id='44851.kişi bitti'>...</cfoutput><br/>
		</cfif>
	</cfloop>
</cfif>
<script type="text/javascript">
	alert("import işlemi başarıyla tamamlandı");
	window.location.href="<cfoutput>#request.self#?fuseaction=ehesap.form_transfer_salary</cfoutput>";
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
