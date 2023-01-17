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
<cfif line_count eq 1>
	<script type="text/javascript">
        alert("<cf_get_lang no ='853.Dosya Hatası Lütfen Dosyanızı Kontrol Ediniz'>!");
    </script>
    <cfabort>
</cfif>
<cfloop from="2" to="#line_count#" index="i">
<cftry>
	<cfscript>
		column = 1;
		error_flag = 0;
		counter = counter + 1;
		satir=dosya[i]&'  ;';

		if(listlen(satir,';') neq 16)
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
			
			//4 Startdate (Baslangıc Tarihi)
			startdate = Listgetat(satir,column,ayrac);
			startdate = trim(startdate);
			start_year = listgetat(startdate,3,'.');
			start_mon = listgetat(startdate,2,'.');
			start_day = listgetat(startdate,1,'.');
			column = column + 1;
			
			//5 Finishdate (Bitis Tarihi)
			finishdate = Listgetat(satir,column,ayrac);
			finishdate = trim(finishdate);
			finish_year = listgetat(finishdate,3,'.');
			finish_mon = listgetat(finishdate,2,'.');
			finish_day = listgetat(finishdate,1,'.');
			column = column + 1;
			
			//6 targetcat_id (Kategori Id)
			targetcat_id = Listgetat(satir,column,ayrac);
			targetcat_id = trim(targetcat_id);
			column = column + 1;
			
			//7 target_head (Hedef)
			target_head = Listgetat(satir,column,ayrac);
			target_head = trim(target_head);
			column = column + 1;
			
			//8 target_number (Rakam)
			target_number = Listgetat(satir,column,ayrac);
			target_number = trim(target_number);
			column = column + 1;
			
			//9 calculation_type (Rakam Tipi)
			calculation_type = Listgetat(satir,column,ayrac);
			calculation_type = trim(calculation_type);
			column = column + 1;
			
			//10 suggested_budget (Ayrılan Butce)
			suggested_budget = Listgetat(satir,column,ayrac);
			suggested_budget = trim(suggested_budget);
			column = column + 1;
			
			//11 money_type (Ayrılan Butce Doviz)
			money_type = Listgetat(satir,column,ayrac);
			money_type = trim(money_type);
			column = column + 1;
			
			//12 target_weight (Ağırlık)
			target_weight = Listgetat(satir,column,ayrac);
			target_weight = trim(target_weight);
			column = column + 1;
			
			//13 target_emp_tc (Hedef Veren)
			target_emp_tc = Listgetat(satir,column,ayrac);
			target_emp_tc = trim(target_emp_tc);
			column = column + 1;
			
			//14 other_date1 (Gorusme Tarihi1)
			other_date1 = Listgetat(satir,column,ayrac);
			other_date1 = trim(other_date1);
			column = column + 1;
			
			//15 other_date1 (Gorusme Tarihi2)
			other_date2 = Listgetat(satir,column,ayrac);
			other_date2 = trim(other_date2);
			column = column + 1;
			
			//16 target_detail (Acıklama)
			target_detail = Listgetat(satir,column,ayrac);
			target_detail = trim(target_detail);
			column = column + 1;
		}
	</cfscript>
    <cfif #IsNumeric(targetcat_id)# eq 'NO'>
		<cfset liste=ListAppend(liste,#i#&'. Satırda Hatalı Veri Bulunduğundan Kaydı Yapılamadı.',',')>
        <cfset error_flag=1>
	</cfif>
	<cfcatch type="Any">
		<cfset liste=ListAppend(liste,#i#&'. Satırda Okuma Sırasında Hata Oluştu ',',')>
		<cfset error_flag=1>
	</cfcatch>
</cftry>
<cfif error_flag eq 0>
	<cfquery name="get_emp_" datasource="#dsn#" maxrows="1">
		SELECT
        	EP.POSITION_CODE,
            E.EMPLOYEE_ID
		FROM
			EMPLOYEES E INNER JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID
			INNER JOIN EMPLOYEES_IDENTY EI ON EI.EMPLOYEE_ID = E.EMPLOYEE_ID
		WHERE
			EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#tc_identy_no#"> AND
            EP.IS_MASTER = 1
	</cfquery>
	<cfif get_emp_.recordcount>
    	<cfif len(target_emp_tc)>
            <cfquery name="get_target_emp" datasource="#dsn#" maxrows="1">
                SELECT
                    E.EMPLOYEE_ID
                FROM
                    EMPLOYEES E INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
                WHERE
                    EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#target_emp_tc#"> 
            </cfquery>
            <cfset target_emp_id = get_target_emp.EMPLOYEE_ID>
        </cfif>
		<cfset emp_id_ = get_emp_.employee_id>
        <cfset position_code = get_emp_.POSITION_CODE>
        <cfset date_start = createdate(start_year,start_mon,start_day)>
        <cfset date_finish = createdate(finish_year,finish_mon,finish_day)>
        <cfif datediff('n',date_finish,date_start) gt 0>
        	<cfset liste=ListAppend(liste,'#get_emp_.name# çalışanı için eklenen kayıtta #dateformat(date_start,dateformat_style)# #timeformat(date_start,timeformat_style)# başlangıç tarihi #dateformat(date_finish,dateformat_style)# #timeformat(date_finish,timeformat_style)# bitiş tarihinden büyük olduğu için kayıt atılmamıştır.',',')>
        </cfif>
        <cfif len(emp_id_)>
            <cfquery name="add_target" datasource="#dsn#">
                INSERT INTO
                    TARGET
                    (
                        POSITION_CODE,
                        EMP_ID,
                        TARGETCAT_ID,
                        STARTDATE,
                        FINISHDATE,
                        TARGET_HEAD,
                        TARGET_NUMBER,
                        CALCULATION_TYPE,
                        TARGET_DETAIL,
                        SUGGESTED_BUDGET,
                        TARGET_MONEY,
                        TARGET_EMP,
                        TARGET_WEIGHT,
                        OTHER_DATE1,
                        OTHER_DATE2,
                        FILE_NAME,
                        RECORD_IP,
                        RECORD_EMP,
                        RECORD_DATE
                    )
                    VALUES 
                    (	
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#position_code#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#emp_id_#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#targetcat_id#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#createodbcdatetime(date_start)#">,
                        <cfqueryparam cfsqltype="cf_sql_date" value="#createodbcdatetime(date_finish)#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#target_head#">,
                        <cfif len(target_number)><cfqueryparam cfsqltype="cf_sql_float" value="#target_number#"><cfelse>NULL</cfif>,
                        <cfif len(calculation_type)><cfqueryparam cfsqltype="cf_sql_integer" value="#calculation_type#"><cfelse>NULL</cfif>,
                        <cfif len(target_detail)><cfqueryparam cfsqltype="cf_sql_varchar" value="#target_detail#"><cfelse>NULL</cfif>,
                        <cfif len(suggested_budget)><cfqueryparam cfsqltype="cf_sql_float" value="#suggested_budget#"><cfelse>NULL</cfif>,
                        <cfif len(money_type)><cfqueryparam cfsqltype="cf_sql_varchar" value="#money_type#"><cfelse>NULL</cfif>,
                        <cfif isdefined('target_emp_id')><cfqueryparam cfsqltype="cf_sql_integer" value="#target_emp_id#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#target_weight#">,
                        <cfif len(other_date1)><cfqueryparam cfsqltype="cf_sql_date" value="#other_date1#"><cfelse>NULL</cfif>,
                        <cfif len(other_date2)><cfqueryparam cfsqltype="cf_sql_date" value="#other_date2#"><cfelse>NULL</cfif>,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.REMOTE_ADDR#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#SESSION.EP.USERID#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">
                    )
            </cfquery>
		</cfif>
	<cfelse>
		<cfset liste=ListAppend(liste,'#tc_identy_no# kimlik numaralı #employee_name# isimli çalışana ait kayıt bulunamadı.',',')>
    </cfif>
</cfif>
</cfloop>
<cfoutput>
<cfquery name="add_file" datasource="#dsn#">
	INSERT INTO
		EMPLOYEES_PERFORMANCE_FILES
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
			2,<!--- hedef --->
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
			location.href='<cfoutput>#request.self#?fuseaction=hr.targets</cfoutput>';
		}
	 </script>
</cfif>
</cfoutput>
