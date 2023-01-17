<cfset upload_folder = "#upload_folder#hr#dir_seperator#eislem#dir_seperator#">
<cftry>
	<cffile action = "upload" fileField = "uploaded_file" destination = "#upload_folder#" nameConflict = "MakeUnique" mode="777" charset="#attributes.file_format#">
	<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#" charset="#attributes.file_format#">	
	<!---Script dosyalarını engelle  02092010 ND --->
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

		if(listlen(satir,';') lt 7)
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
			
			//4 Fm_minute (Fazla Mesai)
			fm_minute = Listgetat(satir,column,ayrac);
			fm_minute = trim(fm_minute);
			column = column + 1;
			
			//5 Fm_id (Fm_id)
			fm_id = Listgetat(satir,column,ayrac);
			fm_id = trim(fm_id);
			column = column + 1;

			//6 process_id (Sürec)
			process_id = Listgetat(satir,column,ayrac);
			process_id = trim(process_id);
			column = column + 1;

			//7 mk_id (mesai karsılığı)
			mk_id = Listgetat(satir,column,ayrac);
			mk_id = trim(mk_id);
		}
	</cfscript>
<cfif error_flag eq 0>
		<cfquery name="get_emp_" datasource="#dsn#" maxrows="1">
		SELECT
			E.EMPLOYEE_ID,
			EIO.START_DATE,
            EIO.FINISH_DATE,
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
		<cfset emp_id_ = get_emp_.EMPLOYEE_ID>
		<cfset fark_ = datediff("d",bu_ay_basi,get_emp_.start_date)>
		<cfset fark_bitis_ = datediff("d",get_emp_.start_date,bu_ay_sonu)>	
			<cfif fark_ lte daysinmonth(bu_ay_basi)>	
				<cfif len(get_emp_.finish_date) and month(get_emp_.finish_date) eq attributes.sal_mon>
					<cfset islem_dakika = 1380>	
                <cfelse>
					<cfif fm_id eq 2>
                        <cfset islem_dakika = 660>
                    <cfelse>
                        <cfset islem_dakika = 180>	
                    </cfif>
                </cfif>
				<cfset gun_sayisi_ = (fm_minute \ islem_dakika)>
				<cfif fm_minute gt (gun_sayisi_ * islem_dakika)>
					<cfset gun_sayisi_ = gun_sayisi_ + 1>
				</cfif>
				
				<cfif fark_bitis_ lt daysinmonth(bu_ay_basi)>
					<cfset ay_gunum_ = fark_bitis_>
				<cfelse>
					<cfset ay_gunum_ = daysinmonth(bu_ay_basi)>
				</cfif>
				
				<cfif gun_sayisi_ gt ay_gunum_>
					<cfset islem_dakika = 480>
					<cfset gun_sayisi_ = (fm_minute \ 480)>
					
					<cfif fm_minute gt (gun_sayisi_ * 480)>
						<cfset gun_sayisi_ = gun_sayisi_ + 1>
					</cfif>
				</cfif>
				
				<cfif fark_ gt 0>
					<cfset baslangic_ = fark_>
				<cfelse>
					<cfset baslangic_ = 0>
				</cfif>
                
				<cfset kullanilan_ = 0>
				<cfloop from="1" to="#gun_sayisi_#" index="mmd">
					<cfif mmd neq gun_sayisi_>
						<cfset yazilacak_ = islem_dakika>
					<cfelse>
						<cfset yazilacak_ = (fm_minute - (islem_dakika * (mmd-1)))>
					</cfif> 
					<cfset new_tarih_ = createodbcdatetime(createdate(attributes.sal_year,attributes.sal_mon,(baslangic_+mmd)))>
                    
					<cfif len(get_emp_.finish_date) and month(get_emp_.finish_date) eq attributes.sal_mon>
                    	<cfset startdate_ = date_add('h',0,new_tarih_)>
                    <cfelse>
						<cfset startdate_ = date_add('h',9,new_tarih_)>
                    </cfif>
					<cfset finishdate_ = date_add('n',yazilacak_,startdate_)>
					<cfif yazilacak_ contains '.'>
						<cfset finishdate_ = date_add('n',yazilacak_,finishdate_)>
					</cfif>
					<cfquery name="add_worktime" datasource="#dsn#">
						INSERT INTO
							EMPLOYEES_EXT_WORKTIMES
							(
							FILE_NAME,
							EMPLOYEE_ID,
							START_TIME,
							END_TIME,
							WORK_START_TIME,
							WORK_END_TIME,
							RECORD_DATE,
							RECORD_EMP,
							RECORD_IP,
							IN_OUT_ID,
							IS_PUANTAJ_OFF,
							DAY_TYPE,
							VALID,
							VALIDDATE,
							PROCESS_STAGE,
							WORKTIME_WAGE_STATU
							)
						VALUES
							(
							'#file_name#',
							#emp_id_#,
							#startdate_#,
							#finishdate_#,
							#startdate_#,
							#finishdate_#,
							#now()#,
							#session.ep.userid#,
							'#cgi.REMOTE_ADDR#',
							<cfif isdefined('get_emp_.in_out_id') and len(get_emp_.in_out_id)>#get_emp_.in_out_id#</cfif>,
							<cfif isdefined('attributes.is_puantaj_off') and len(attributes.is_puantaj_off)>1<cfelse>0</cfif>,
							#fm_id#,
							1,
							#now()#,
							#process_id#,
							#mk_id#
							)
					</cfquery>
				</cfloop>
				<cfset counter = counter + 1>
			<cfelse>
				<cfscript>
					liste=ListAppend(liste,i&'. Satırda Çalışanın İşe Giriş Tarihleri Uygun Değil!',',');
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
			5,<!--- fazla mesai import 2 --->
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
<br />
<br />
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

