<cfif not len(attributes.norm_file)>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz!'>!");
		history.back();
	</script>
	<cfabort>
<cfelse>
<cfset upload_folder = "#upload_folder#hr#dir_seperator#eislem#dir_seperator#">
<cftry>
	<cffile
		action = "upload" 
		fileField = "norm_file" 
		destination = "#upload_folder#"
		nameConflict = "MakeUnique"  
		mode="777">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#">	
	<cfset file_size = cffile.filesize>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz!'>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="windows-1254">

<cfscript>
CRLF = Chr(13) & Chr(10);// satır atlama karakteri
dosya1 = ListToArray(dosya,CRLF);
line_count = ArrayLen(dosya1);
</cfscript>

<cfif line_count eq 1>
	<script type="text/javascript">
	alert("<cf_get_lang no='2864.Dosya Geçersiz veya Satır Sayısı Hatalı Lütfen Dosyanızı Kontrol Ediniz!'>!");
	</script>
	<cfabort>
</cfif>
<cfloop from="2" to="#line_count#" index="i">
			<cfset kont=1>
			<cfset deger_ = replace(dosya1[i],';;;',';*_*;*_*;',"all")>
			<cfset deger_ = replace(deger_,';;',';*_*;',"all")>
			<cftry>
				<cfset tip_ = trim(listgetat(deger_,1,';'))>
				<cfset org_ = trim(listgetat(deger_,2,';'))>
				<cfset yil_ = trim(listgetat(deger_,3,';'))>
				<cfset ay_ = trim(listgetat(deger_,4,';'))>
				<cfset average_salary_ = trim(listgetat(deger_,5,';'))>
				<cfset real_salary_ = trim(listgetat(deger_,6,';'))>
				<cfset real_cost_ = trim(listgetat(deger_,7,';'))>
				<cfset para_ = trim(listgetat(deger_,8,';'))>
				<cfif average_salary_ contains ','>
					<cfset average_salary_ = replace(average_salary_,',','.',"all")>
				</cfif>
				<cfif real_salary_ contains ','>
					<cfset real_salary_ = replace(real_salary_,',','.',"all")>
				</cfif>
				<cfif real_cost_ contains ','>
					<cfset real_cost_ = replace(real_cost_,',','.',"all")>
				</cfif>
				<cfif not len(average_salary_)>
					<cfoutput>#i-1#.<cf_get_lang no='2865.Satır İçin Tutar Girilmemiş.'><br/></cfoutput>
					<cfset kont=0>
				</cfif>
				<cfcatch type="Any">
					<cfoutput>#i-1#.<cf_get_lang no='2866.Satır Verilerini Okuma Aşamasında Hata Var.'> (#deger_#)<br/></cfoutput>	
					<cfset kont=0>
				</cfcatch>  
			</cftry>

	<cfif kont eq 1>
		<cftry>
		<cfquery name="check_ssk" datasource="#dsn#">
			SELECT
				*
			FROM
				EMPLOYEE_NORM_POSITIONS_AVERAGE
			WHERE
				NORM_YEAR = #yil_# AND
				NORM_MONTH = #ay_# AND
				<cfif tip_ eq 1>
				RELATED_COMPANY = '#org_#'
				<cfelseif tip_ eq 2>
				BRANCH_ID = #org_#
				<cfelse>
				DEPARTMENT_ID = #org_#
				</cfif>
		</cfquery>
		<cfoutput>		
			<cfif check_ssk.recordcount>
				<cfquery name="upd_salary" datasource="#dsn#">
					UPDATE 
						EMPLOYEE_NORM_POSITIONS_AVERAGE
					SET					
						AVERAGE_SALARY = #average_salary_#,
						<cfif len(real_salary_) and real_salary_ is not '*_*'>
							REAL_SALARY	= #real_salary_#,
						</cfif>
						<cfif len(real_cost_) and real_cost_ is not '*_*'>
							REAL_COST = #real_cost_#,
						</cfif>
						MONEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#para_#">,
						UPDATE_IP = '#CGI.REMOTE_ADDR#',
						UPDATE_DATE = #NOW()#,
						UPDATE_EMP = #SESSION.EP.USERID#
					WHERE
						NORM_YEAR = #yil_# AND
						NORM_MONTH = #ay_# AND
						<cfif tip_ eq 1>
						RELATED_COMPANY = '#org_#'
						<cfelseif tip_ eq 2>
						BRANCH_ID = #org_#
						<cfelse>
						DEPARTMENT_ID = #org_#
						</cfif>
				</cfquery>
			<cfelse>
				<cfquery name="add_salary" datasource="#dsn#">
					INSERT INTO
						EMPLOYEE_NORM_POSITIONS_AVERAGE
						(
						RELATED_COMPANY,
						BRANCH_ID,
						DEPARTMENT_ID,
						NORM_YEAR,
						NORM_MONTH,
						AVERAGE_SALARY,
						REAL_SALARY,
						REAL_COST,
						MONEY,
						RECORD_IP,
						RECORD_DATE,
						RECORD_EMP
						)
					VALUES
						(
						<cfif tip_ eq 1><cfqueryparam cfsqltype="cf_sql_varchar" value="#org_#">,<cfelse>NULL,</cfif>
						<cfif tip_ eq 2>#org_#,<cfelse>NULL,</cfif>
						<cfif tip_ eq 3>#org_#,<cfelse>NULL,</cfif>
						#yil_#,
						#ay_#,
						#average_salary_#,
						<cfif len(real_salary_) and real_salary_ is not '*_*'>#real_salary_#,<cfelse>NULL,</cfif>
						<cfif len(real_cost_) and real_cost_ is not '*_*'>#real_cost_#,<cfelse>NULL,</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#para_#">,
						'#CGI.REMOTE_ADDR#',
						#NOW()#,
						#SESSION.EP.USERID#
						)
				</cfquery>
			</cfif>
		#i-1#.<cf_get_lang no='2868.kişi bitti'>...<br/>
		</cfoutput>
				<cfcatch type="Any">
					<cfoutput>#i-1#.<cf_get_lang no='2867.Satır Verilerini Yazma Aşamasında Hata Var.'> (#deger_#)<br/></cfoutput>	
				</cfcatch>  
			</cftry>
	</cfif>
	</cfloop>
</cfif>
<script type="text/javascript">
	alert("İ<cf_get_lang no='2869.mport İşlemi Başarıyla Tamamlandı!'>!");
	window.location.href="<cfoutput>#request.self#?fuseaction=settings.form_norm_average</cfoutput>";
</script>
