<cfset upload_folder = "#upload_folder#hr#dir_seperator#eislem#dir_seperator#">
<cftry>
	<cffile
		action = "upload" 
		fileField = "uploaded_file" 
		destination = "#upload_folder#"
		nameConflict = "MakeUnique"  
		mode="777">
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
<cffile action="read" file="#upload_folder##file_name#" variable="dosya">
<cflock name="#CreateUUID()#" timeout="60">
	<cftransaction>
		<cfscript>
			CRLF = Chr(13) & Chr(10);// satir atlama karakteri
			dosya = Replace(dosya,';;','; ;','all');
			dosya = Replace(dosya,';;','; ;','all');
			dosya = ListToArray(dosya,CRLF);
			line_count = ArrayLen(dosya);
			counter = 0;
			liste = "";
		</cfscript>
		<cfif line_count eq 1>
			<script type="text/javascript">
				alert("<cf_get_lang no ='1112.Dosya Hatası Lütfen Dosyanızı Kontrol Ediniz'>!");
			</script>
			<cfabort>
		</cfif>
        
		<cfloop from="2" to="#line_count#" index="i">
            <cfset j= 1>
			<cfset error_flag = 0>
			<cftry>
            <cfscript>
				counter = counter + 1;
				//Satırların sıra nosu
				sira = trim(Listgetat(dosya[i],j,";"));
				j=j+1;
				//TC Kimlik No
				tc_kimlik = trim(Listgetat(dosya[i],j,";"));
				j=j+1;
				//Çalışan Ad-Soyad
				name = trim(Listgetat(dosya[i],j,";"));
				j=j+1;
				//Çalışan Şube
				okes_rate = trim(Listgetat(dosya[i],j,";"));
				j=j+1;
				//Ay
				start_sal_mon = trim(Listgetat(dosya[i],j,";"));
				j=j+1;
				//Bitiş Ay
				end_sal_mon = trim(Listgetat(dosya[i],j,";"));
				j=j+1;
				//Yıl
				sal_year = trim(Listgetat(dosya[i],j,";"));
				j=j+1;
				</cfscript>
                
                <cfcatch type="Any">
					<cfset liste=ListAppend(liste,i&'. satırda okuma sırasında hata oldu <br/>',',')>
					<cfoutput>#i#</cfoutput>. <cf_get_lang_main no='1096.satır'> <cf_get_lang no='2964.Birinci adımda sorun oluştu'><br/>
					<cfset error_flag = 1>
				</cfcatch>
			</cftry>
        <cfif error_flag eq 0>
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
					(EO.FINISH_DATE IS NULL OR EO.FINISH_DATE >= #createodbcdatetime(createdate(sal_year,end_sal_mon,1))#) AND
					EO.START_DATE <= #createodbcdatetime(createdate(sal_year,start_sal_mon,daysinmonth(createdate(sal_year,start_sal_mon,1))))# AND
					EO.EMPLOYEE_ID = EI.EMPLOYEE_ID 
					AND EI.TC_IDENTY_NO = '#tc_kimlik#'
					<cfif len(attributes.branch_id)>
						AND EO.BRANCH_ID = #attributes.branch_id#
					<cfelseif len(attributes.related_company)>
						AND B.RELATED_COMPANY = '#attributes.related_company#'
						AND EO.BRANCH_ID = B.BRANCH_ID
					</cfif>
				ORDER BY
					EO.IN_OUT_ID DESC
			</cfquery>
            
            <cfif get_employee_id.recordcount and len(get_employee_id.EMPLOYEE_ID)>
            	<cfquery name="getRateOkes" datasource="#dsn#">
                	SELECT TOP 1 ODKES_ID,COMMENT_PAY FROM SETUP_PAYMENT_INTERRUPTION WHERE IS_BES = 1 AND STATUS = 1 AND AMOUNT_PAY = #okes_rate# ORDER BY ODKES_ID
                </cfquery>
            
				<cfset this_in_out_id_ = get_employee_id.IN_OUT_ID>
                <cfset this_employee_id_ = get_employee_id.EMPLOYEE_ID>
            
                <cfquery name="add_row" datasource="#dsn#">
                    INSERT INTO SALARYPARAM_BES
                        (
                        FILE_NAME,
                        COMMENT_BES_ID,
                        COMMENT_BES,
                        RATE_BES,
                        START_SAL_MON,
                        END_SAL_MON,
                        EMPLOYEE_ID,
                        TERM,
                        IN_OUT_ID,
                        RECORD_DATE,
                        RECORD_EMP,
                        RECORD_IP
                        )
                    VALUES
                        (
                        '#file_name#',
                        #getRateOkes.ODKES_ID#,
                        '#getRateOkes.COMMENT_PAY#',
                        <cfqueryparam cfsqltype="cf_sql_float" value="#okes_rate#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#start_sal_mon#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#end_sal_mon#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#this_employee_id_#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#sal_year#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#this_in_out_id_#">,
                        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
                        )
                </cfquery>
                <cfoutput>
                    #sira# #tc_kimlik# #name# : İmport işlemi tamamlandı.....<br/>
                </cfoutput>	
            <cfelse>
            	<cfoutput>
                    #sira#  #tc_kimlik# #name# : Çalışan ilgili şubede kayıtlı değil.....<br/>
                </cfoutput>	
            </cfif>
		  </cfif>
		</cfloop>
		<cfquery name="add_file" datasource="#dsn#">
			INSERT INTO
				EMPLOYEES_PUANTAJ_FILES
				(
					PROCESS_TYPE,
					BRANCH_ID,
					FILE_NAME,
					FILE_SERVER_ID,
					RECORD_DATE,
					RECORD_EMP,
					RECORD_IP
				)
			VALUES
				(
					#attributes.process_type#,<!--- Fazla mesai için 1, Ödenek için 2 , Kesinti için 3, vergi istisnaları için 4 verdim --->
					<cfif len(attributes.branch_id)>#attributes.branch_id#,<cfelse>NULL,</cfif>
					'#file_name#',
					#fusebox.server_machine#,
					#now()#,
					#session.ep.userid#,
					'#cgi.REMOTE_ADDR#'
				)
		</cfquery>
	</cftransaction>
</cflock>
<script type="text/javascript">
	alert("<cf_get_lang no ='1114.İmport işlemi tamamlandı '>!");
		<cfif isdefined("attributes.modal_id") and len(attributes.modal_id)>
				location.href = document.referrer;
		<cfelse>
			location.href="<cfoutput>#request.self#?fuseaction=ehesap.list_import_process</cfoutput>";
		</cfif>
	
</script>
