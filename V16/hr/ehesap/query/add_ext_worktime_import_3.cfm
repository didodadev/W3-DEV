<cfset upload_folder = "#upload_folder#hr#dir_seperator#eislem#dir_seperator#">
<cftry>
	<cffile action = "upload" fileField = "uploaded_file" destination = "#upload_folder#" nameConflict = "MakeUnique" mode="777" charset="#attributes.file_format#">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">	
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
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<cffile action="read" file="#upload_folder##file_name#" variable="dosya" charset="#attributes.file_format#">
<cfset bu_ay_basi = createdate(attributes.sal_year,attributes.sal_mon,1)>
<cfset bu_ay_sonu = date_add('s',-1,date_add('m',1,bu_ay_basi))>
<cfscript>
	ayrac=';';
	CRLF = Chr(13) & Chr(10);// satır atlama karakteri
	dosya = Replace(dosya,'#ayrac##ayrac#',' #ayrac# #ayrac# ','all');
	dosya = Replace(dosya,'#ayrac##ayrac#',' #ayrac# #ayrac# ','all');
	dosya = Replace(dosya,'#ayrac#',' #ayrac# ','all');
	dosya = ListToArray(dosya,CRLF);
	line_count = ArrayLen(dosya);
	counter = 0;
	liste = "";
</cfscript>
<cfloop from="2" to="#line_count#" index="i">
	<cfscript>
		column = 1;
		error_flag = 0;		
		satir=dosya[i]&'  ;';

		if(listlen(satir,';') lt 9)
		{
			liste=ListAppend(liste,i&'. Satırda Eksik Kolon Bulunmaktadır - Kolon:#listlen(satir,';')#',',');
			error_flag=1;
		}
		else
		{	
			//1 Sira_no (Sira No)
			sira_no = Listgetat(satir,column,ayrac);
			sira_no = trim(sira_no);
			column = column + 1;
			
			//2 Tc_Identy_No (Tc Kimlik No)
			tc_identy_no = Listgetat(satir,column,ayrac);
			tc_identy_no = trim(tc_identy_no);
			column = column + 1;
		
			//3 Employee_name (Calisan Adi)
			employee_name = Listgetat(satir,column,ayrac);
			employee_name = trim(employee_name);
			column = column + 1;
			
			//4 fm_hour_0 (normal mesai)
			fm_hour_0 = Listgetat(satir,column,ayrac);
			fm_hours_0 = Replace(fm_hour_0,',','.',"all");
			column = column + 1;
			
			//5 fm_hour_1 (hafta sonu)
			fm_hour_1 = Listgetat(satir,column,ayrac);
			fm_hours_1 = Replace(fm_hour_1,',','.',"all");
			column = column + 1;
			
			//6 fm_hour_2 (resmi tatil)
			fm_hour_2 = Listgetat(satir,column,ayrac);
			fm_hour_2 = Replace(fm_hour_2,',','.',"all");
			column = column + 1;
			
			//7 fm_hour_3 (gece çalışması)
			fm_hour_3 = Listgetat(satir,column,ayrac);
			fm_hour_3 = Replace(fm_hour_3,',','.',"all");
			column = column + 1;

			//8 process_id (Sürec)
			process_id = Listgetat(satir,column,ayrac);
			process_id = trim(process_id);
			column = column + 1;

			//9 mk_id (mesai karsılığı)
			mk_id = Listgetat(satir,column,ayrac);
			mk_id = trim(mk_id);
		}
	</cfscript>
<cfif error_flag eq 0>
		<cfquery name="get_emp_" datasource="#dsn#" maxrows="1">
		SELECT
			E.EMPLOYEE_ID,
			EIO.START_DATE,
			EIO.IN_OUT_ID
		FROM
			EMPLOYEES E,
			EMPLOYEES_IDENTY EI,
			EMPLOYEES_IN_OUT EIO
		WHERE
			E.EMPLOYEE_ID = EI.EMPLOYEE_ID AND
			E.EMPLOYEE_ID = EIO.EMPLOYEE_ID AND
			EI.TC_IDENTY_NO = '#tc_identy_no#' AND
			START_DATE < #createodbcdatetime(bu_ay_sonu)# AND
			(FINISH_DATE IS NULL OR FINISH_DATE >= #createodbcdatetime(bu_ay_basi)#)	
		ORDER BY
			EIO.IN_OUT_ID DESC
		</cfquery>
	<cftry>
	<cfif get_emp_.recordcount>
		<cfset emp_id_ = get_emp_.employee_id>
			<cfif (len(trim(fm_hour_0)) and fm_hour_0 neq 0) or (len(trim(fm_hour_1)) and fm_hour_1 neq 0) or (len(trim(fm_hour_2)) and fm_hour_2 neq 0) or (len(trim(fm_hour_3)) and fm_hour_3 neq 0)>
				<cfquery name="get_control" datasource="#dsn#" maxrows="1">
					SELECT
						WORKTIMES_ID
					FROM
						EMPLOYEES_OVERTIME
					WHERE
						IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_.in_out_id#"> AND
						OVERTIME_PERIOD = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#"> AND
						OVERTIME_MONTH = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
				</cfquery>
				<cfif not get_control.recordcount>
					<cfquery name="add_worktime" datasource="#dsn#">
						INSERT INTO
							EMPLOYEES_OVERTIME
							(
							FILE_NAME,
							EMPLOYEE_ID,
							IN_OUT_ID,
							OVERTIME_PERIOD,
							OVERTIME_MONTH,
							OVERTIME_VALUE_0,
							OVERTIME_VALUE_1,
							OVERTIME_VALUE_2,
							OVERTIME_VALUE_3,
							RECORD_EMP,
							RECORD_DATE,
							RECORD_IP,
							PROCESS_STAGE,
							WORKTIME_WAGE_STATU
							)
						VALUES
							(
							'#file_name#',
							#emp_id_#,
							#get_emp_.IN_OUT_ID#,
							#attributes.sal_year#,
							#attributes.sal_mon#,
							<cfif len(trim(fm_hour_0))>#replace(fm_hour_0,',','.','all')#<cfelse>0</cfif>,
							<cfif len(trim(fm_hour_1))>#replace(fm_hour_1,',','.','all')#<cfelse>0</cfif>,
							<cfif len(trim(fm_hour_2))>#replace(fm_hour_2,',','.','all')#<cfelse>0</cfif>,
							<cfif len(trim(fm_hour_3))>#replace(fm_hour_3,',','.','all')#<cfelse>0</cfif>,
							#session.ep.userid#,
							#now()#,
							'#cgi.REMOTE_ADDR#',
							#process_id#,
							#mk_id#
							)
					</cfquery>
					<cfset counter = counter + 1>
				<cfelse>
					<cfscript>
						liste = ListAppend(liste,i&'. Satırda Çalışan İçin Daha Önceden Yapılmış Kayıt Bulunmakta',',');
					</cfscript>
				</cfif>
			<cfelse>
				<cfscript>
					liste=ListAppend(liste,i&'. Satırda Mesai Saatleri 0 girilmiş!',',');
				</cfscript>
			</cfif>
	<cfelse>
		<cfscript>
			liste=ListAppend(liste,i&'. Satırda TC Kimlik Noya Ait Çalışan Bulunamadı!',',');
		</cfscript>
	</cfif>
	<cfcatch type="Any">
		<cfoutput>#tc_identy_no#</cfoutput> Tc Kimlik Numaralı Çalışanda Hata Oluştu!<br/>
	</cfcatch> 
	</cftry>
</cfif>
</cfloop>
<cfoutput>
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
			8,<!--- fazla mesai import 3 --->
			#attributes.sal_mon#,
			#attributes.sal_year#,
			<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>#attributes.branch_id#,<cfelse>NULL,</cfif>
			'#file_name#',
			#fusebox.server_machine#,
			#now()#,
			#session.ep.userid#,
			'#cgi.REMOTE_ADDR#'
		)
</cfquery>
<input type="button" onclick="window.location.href='#request.self#?fuseaction=ehesap.list_ext_worktimes';" value="Devam">
<br />
<br />
<cfif listlen(liste,',') gt 0>
	&nbsp;#listlen(liste,',')# Kayıtta Sorun Oluştu. <br/>
	Sorunlu Kayıtlar Aşağıdaki Gibidir, Lütfen Kontrol Ediniz :<br/><br/>
	<cfloop list="#liste#" index="i">&nbsp;#i#,<br/></cfloop>
	<br/>
<cfelse>
	&nbsp;#counter# Sorunsuz Kayıt Yapıldı !!!
</cfif>
</cfoutput>

