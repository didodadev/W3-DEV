<cfset upload_folder = "#upload_folder#hr#dir_seperator#eislem#dir_seperator#">
<cftry>
	<cffile action = "upload" fileField = "uploaded_file" destination = "#upload_folder#" nameConflict = "MakeUnique" mode="777" charset="#attributes.file_format#">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">	
	<!---Script dosyalarını engelle  02092010 FA-ND --->
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
<!---<cffile action="delete" file="#upload_folder##file_name#">--->
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
<cftry>
	<cfscript>
		column = 1;
		error_flag = 0;
		counter = counter + 1;
		satir=dosya[i]&'  ;';

		if(listlen(satir,';') neq 12)
		{
			liste=ListAppend(liste,i&'. Satırda Eksik Kolon Bulunmaktadır - Kolon Sayısı:#listlen(satir,';')#',',');
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
			
			//4 Startdate (İzin Baslangıc Tarihi)
			startdate = Listgetat(satir,column,ayrac);
			startdate = trim(startdate);
			start_year = listgetat(startdate,3,'.');
			start_mon = listgetat(startdate,2,'.');
			start_day = listgetat(startdate,1,'.');
			column = column + 1;
			
			//5 StartHour (İzin Baslangıc Saati)
			starthour = Listgetat(satir,column,ayrac);
			starthour = trim(starthour);
			start_hour = listgetat(starthour,1,':');
			start_min = listgetat(starthour,2,':');
			column = column + 1;
			
			//6 Finishdate (İzin Bitis Tarihi)
			finishdate = Listgetat(satir,column,ayrac);
			finishdate = trim(finishdate);
			finish_year = listgetat(finishdate,3,'.');
			finish_mon = listgetat(finishdate,2,'.');
			finish_day = listgetat(finishdate,1,'.');
			column = column + 1;
			
			//7 FinishHour (İzin Bitiş Saati)
			finishhour = Listgetat(satir,column,ayrac);
			finishhour = trim(finishhour);
			finish_hour = listgetat(finishhour,1,':');
			finish_min = listgetat(finishhour,2,':');
			column = column + 1;
			
			//8 Work_startdate (İse Baslama Tarihi)
			work_startdate = Listgetat(satir,column,ayrac);
			work_startdate = trim(work_startdate);
			work_startdate_year = listgetat(work_startdate,3,'.');
			work_startdate_mon = listgetat(work_startdate,2,'.');
			work_startdate_day = listgetat(work_startdate,1,'.');
			column = column + 1;
			
			//9 Work_StartHour (İşe Başlama Saati)
			work_starthour = Listgetat(satir,column,ayrac);
			work_starthour = trim(work_starthour);
			work_start_hour = listgetat(work_starthour,1,':');
			work_start_min = listgetat(work_starthour,2,':');
			column = column + 1;
			
			//10 Offtimecat_id (İzin Kategori Id)
			offtimecat_id = Listgetat(satir,column,ayrac);
			offtimecat_id = trim(offtimecat_id);
			column = column + 1;

			//11 Sub_Offtimecat_id (İzin Alt Kategori Id)
			sub_offtimecat_id = Listgetat(satir,column,ayrac);
			sub_offtimecat_id = trim(sub_offtimecat_id);
			column = column + 1;
			
			//12 sube_id (Şube Id)
			branch_ = Listgetat(satir,column,ayrac);
			branch_ = trim(branch_);
			column = column + 1;
		}
	</cfscript>
    <cfif #IsNumeric(branch_)# eq 'NO' or #IsNumeric(offtimecat_id)# eq 'NO'>
		<cfset liste=ListAppend(liste,#i#&'. Satırda Hatalı Veri Bulunduğundan Kaydı Yapılamadı.',',')>
        <cfset error_flag=1>
	</cfif>
	<cfif len(sub_offtimecat_id)>
		<cfquery name="get_sub_category_id" datasource="#dsn#">
			SELECT UPPER_OFFTIMECAT_ID FROM SETUP_OFFTIME WHERE OFFTIMECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#sub_offtimecat_id#"> 
		</cfquery>
		<cfset offtimecat_id_list= valueList(get_sub_category_id.UPPER_OFFTIMECAT_ID)>
		<cfif ListFind(offtimecat_id_list,offtimecat_id) eq 0>
			<cfset liste=ListAppend(liste,#i#&'. Satırdaki İzin ve alt izin kategorileri uyuşmamaktadır. Kayıt yapılamadı','.')>
			<cfset error_flag=1>
		</cfif>
	</cfif>
	<cfcatch type="Any">
		<cfset liste=ListAppend(liste,#i#&'. Satırda Okuma Sırasında Hata Oluştu ',',')>
		<cfset error_flag=1>
	</cfcatch>
</cftry>
<cfif error_flag eq 0>
	<cfquery name="get_emp_" datasource="#dsn#" maxrows="1">
		SELECT
			EIO.IN_OUT_ID,
            E.EMPLOYEE_ID,
			E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS NAME
		FROM
			EMPLOYEES E INNER JOIN EMPLOYEES_IN_OUT EIO ON E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
			INNER JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
		WHERE
			EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tc_identy_no#"> AND
            EIO.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#branch_#">
        ORDER BY 
        	EIO.IN_OUT_ID DESC
	</cfquery>
	<cfif get_emp_.recordcount>
		<cfset emp_id_ = get_emp_.employee_id>
        <cfset in_out_id_ = get_emp_.in_out_id>
        <cfset date_start = createdatetime(start_year,start_mon,start_day,start_hour,start_min,0)>
        <cfset date_finish = createdatetime(finish_year,finish_mon,finish_day,finish_hour,finish_min,0)>
        <cfset date_work_start = createdatetime(work_startdate_year,work_startdate_mon,work_startdate_day,work_start_hour,work_start_min,0)>
        <cfif datediff('n',date_finish,date_start) gt 0>
        	<cfset liste=ListAppend(liste,'#get_emp_.name# çalışanı için eklenen izin kaydında #dateformat(date_start,dateformat_style)# #timeformat(date_start,timeformat_style)# başlangıç tarihi #dateformat(date_finish,dateformat_style)# #timeformat(date_finish,timeformat_style)# bitiş tarihinden büyük olduğu için kayıt atılmamıştır.',',')>
        </cfif>
        <cfif datediff('n',date_start,date_finish) gt 0>
	        <cfquery name="get_other_offtimes" datasource="#dsn#">
	            SELECT
	                OFFTIME_ID
	            FROM
	                OFFTIME
	            WHERE
	                EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_.employee_id#"> AND
	                IN_OUT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp_.in_out_id#"> AND
	                VALID = 1 AND
	                (
	                    (STARTDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(date_add('h',-session.ep.time_zone,date_start))#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(date_add('h',-session.ep.time_zone,date_finish))#">) OR
	                    (FINISHDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(date_add('h',-session.ep.time_zone,date_start))#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(date_add('h',-session.ep.time_zone,date_finish))#">) OR
	                    (STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(date_add('h',-session.ep.time_zone,date_start))#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(date_add('h',-session.ep.time_zone,date_finish))#">)
	                )
	        </cfquery>
	        <cfif get_other_offtimes.RecordCount>
	            <cfset liste=ListAppend(liste,'#get_emp_.NAME# çalışanının #dateformat(date_start,dateformat_style)# - #dateformat(date_finish,dateformat_style)# tarihleri arasında onaylı kaydı bulunduğu için kayıt atılmamıştır.',',')>
	        </cfif>
	        <cfif not get_other_offtimes.RecordCount and len(emp_id_)>
		        <cfquery name="add_offtime" datasource="#dsn#">
		            INSERT INTO
		                OFFTIME
		                (
			                FILE_NAME,
			                IS_PUANTAJ_OFF,
			                EMPLOYEE_ID,
			                IN_OUT_ID,
			                STARTDATE,
			                FINISHDATE,
			                WORK_STARTDATE,
			                OFFTIMECAT_ID,
							SUB_OFFTIMECAT_ID,
			                VALIDATOR_POSITION_CODE,
			                VALID_EMPLOYEE_ID,
			                VALIDDATE,
			                RECORD_IP,
			                RECORD_EMP,
			                RECORD_DATE,
			                VALID,
			                OFFTIME_STAGE
		                )
		            VALUES
		                (
			                <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#">,
			                <cfif isdefined('attributes.is_puantaj_off') and len(attributes.is_puantaj_off)>1<cfelse>0</cfif>,
			                <cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id_#">,
			                <cfif len(in_out_id_)><cfqueryparam cfsqltype="cf_sql_integer" value="#in_out_id_#"><cfelse>NULL</cfif>,
			                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(date_add('h',-session.ep.time_zone,date_start))#">,
			                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(date_add('h',-session.ep.time_zone,date_finish))#">,
			                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#createodbcdatetime(date_add('h',-session.ep.time_zone,date_work_start))#">,
			                <cfqueryparam cfsqltype="cf_sql_integer" value="#offtimecat_id#">,
			                <cfif len(sub_offtimecat_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#sub_offtimecat_id#"><cfelse>0</cfif>,
			                <cfif attributes.valid eq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.validator_position_code#"><cfelse>NULL</cfif>,
			                <cfif attributes.valid eq 0><cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.valid_employee_id#"><cfelse>NULL</cfif>,
			                <cfif attributes.valid eq 0><cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"><cfelse>NULL</cfif>,
			                <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
			                <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
			                <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">,
			                <cfif attributes.valid eq 0>1<cfelse>NULL</cfif>,
			                <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.process_stage#">
		                )
		        </cfquery>
	        </cfif>
		</cfif>
	<cfelse>
		<cfset liste=ListAppend(liste,'#tc_identy_no# kimlik numaralı #employee_name# isimli çalışana ait kayıt bulunamadı.',',')>
    </cfif>
</cfif>
</cfloop>
<cfoutput>
<cfquery name="add_file" datasource="#dsn#">
	INSERT INTO
		EMPLOYEES_PUANTAJ_FILES
		(
			PROCESS_TYPE,
			FILE_NAME,
			FILE_SERVER_ID,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
		)
	VALUES
		(
			6,<!--- izin --->
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#fusebox.server_machine#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.REMOTE_ADDR#">
		)
</cfquery>

<cfif listlen(liste,',') gt 0>
	&nbsp;#listlen(liste,',')# Kayıtta Sorun Oluştu. <br/>
	Sorunlu Kayıtlar Aşağıdaki Gibidir, Lütfen Kontrol Ediniz :<br/><br/>
	<cfloop list="#liste#" index="i">&nbsp;#i#,<br/></cfloop>
	<br/>
<cfelse>
     <script type="text/javascript">
     	{
			alert("<cfoutput>#counter#</cfoutput> Sorunsuz Kayıt Yapıldı!");
			<cfif isdefined("attributes.modal_id") and len(attributes.modal_id)>
				location.href = document.referrer;
				<cfelse>
					location.href='<cfoutput>#request.self#?fuseaction=ehesap.offtimes</cfoutput>';
			</cfif>
			
		}
	 </script>
</cfif> 
</cfoutput>
