<cfset upload_folder = "#upload_folder#hr#dir_seperator#eislem#dir_seperator#">
<cfif not directoryexists("#upload_folder#")>
	<cfdirectory action="create" directory="#upload_folder#">
</cfif>
<cfif isdefined("attributes.uploaded_file") and len(attributes.uploaded_file)>		
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
					alert("\<cf_get_lang dictionary_id='47804.php,jsp,asp,cfm,cfml Formatlarında Dosya Girmeyiniz!!'>");
					history.back();
				</script>
				<cfabort>
			</cfif>		
		<cfset file_size = cffile.filesize>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
</cfif>
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
				alert("<cf_get_lang dictionary_id='65003.Dosya Hatası Lütfen Dosyanızı Kontrol Ediniz'>!");
			</script>
			<cfabort>
		</cfif>
        
		<cfloop from="2" to="#line_count#" index="i">
			<!---<cfset kont=1>--->
            <cfset j= 1>
			<cfset error_flag = 0>
			<cftry>
            <cfscript>
				counter = counter + 1;
				//Satırların sıra nosu
				sira = trim(Listgetat(dosya[i],j,";"));
				j=j+1;
				//Ödenek/Kesinti Tipi
				type = trim(Listgetat(dosya[i],j,";"));
				j=j+1;
				//TC Kimlik No
				tc_kimlik = trim(Listgetat(dosya[i],j,";"));
				j=j+1;
				//Çalışan Ad-Soyad
				name = trim(Listgetat(dosya[i],j,";"));
				j=j+1;
				//Çalışan Şube
				if(listlen(dosya[i],';') gte j)
					branch = trim(Listgetat(dosya[i],j,";"));
				else
					branch = '';
				j=j+1;
				//Çalışan Pozisyon
				if(listlen(dosya[i],';') gte j)
					position = trim(Listgetat(dosya[i],j,";"));
				else
					position = '';
				j=j+1;
				//Tutar
				sal_value = trim(Listgetat(dosya[i],j,";"));
				j=j+1;
				//Ay
				sal_mon = trim(Listgetat(dosya[i],j,";"));
				j=j+1;
				//Bitiş Ay
				end_sal_mon = trim(Listgetat(dosya[i],j,";"));
				j=j+1;
				//Yıl
				sal_year = trim(Listgetat(dosya[i],j,";"));
				j=j+1;
				//Ücret Kartı ID
				if(attributes.process_type == 2 or attributes.process_type == 3) {
					if(listlen(dosya[i],';') gte j)
						ucret_kart_id = trim(Listgetat(dosya[i],j,";"));
					else
						ucret_kart_id = "";
				
					j=j+1;
				}
				//Proje ıd
				if(listlen(dosya[i],';') gte j)
					project_id =  trim(Listgetat(dosya[i],j,";"));
				else
					project_id = '';
				j=j+1;
				if(listlen(dosya[i],';') gte j)
					process_stage = trim(Listgetat(dosya[i],j,";"));
				else
				 process_stage = '';
				j=j+1;
				</cfscript>
				
                <cfcatch type="Any">
					<cfset liste=ListAppend(liste,i&'. satırda okuma sırasında hata oldu <br/>',',')>
					<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.Satır'> <cf_get_lang dictionary_id='44947.1. adımda sorun oluştu.'><br/>
					<cfset error_flag = 1>
				</cfcatch>
				<!---<cfcatch type="Any">
					<cfoutput>#i-1#. Satır Hatalı<br/></cfoutput>	
					<cfset kont=0>
				</cfcatch> ---> 
			</cftry>
		<!---<cfif kont eq 1>--->
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
					(EO.FINISH_DATE IS NULL OR EO.FINISH_DATE >= #createodbcdatetime(createdate(sal_year,sal_mon,1))#) AND
					EO.START_DATE <= #createodbcdatetime(createdate(sal_year,sal_mon,daysinmonth(createdate(sal_year,sal_mon,1))))# AND
					EO.EMPLOYEE_ID = EI.EMPLOYEE_ID 
					<cfif attributes.process_type eq 2 or attributes.process_type eq 3>
						<cfif len(ucret_kart_id)>
							AND EO.IN_OUT_ID = '#ucret_kart_id#'
						</cfif>
					</cfif>
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
			<cfset this_in_out_id_ = get_employee_id.IN_OUT_ID>
			<cfset this_employee_id_ = get_employee_id.EMPLOYEE_ID>
			<cfif attributes.process_type eq 2 or attributes.process_type eq 3>
				<cfif not len(ucret_kart_id)>
					<cfset ucret_kart_id =  this_in_out_id_>
				</cfif>
			</cfif>
			
			<!---<cfset sal_value = filterNum(sal_value)>--->
			<cfif attributes.process_type eq 2>
				<cfquery name="get_types" datasource="#dsn#">
					SELECT 
                        ODKES_ID, 
                        COMMENT_PAY, 
                        PERIOD_PAY, 
                        METHOD_PAY, 
                        AMOUNT_PAY, 
                        SSK, 
                        TAX, 
                        SHOW, 
                        START_SAL_MON,
                        END_SAL_MON, 
                        IS_ODENEK,
                        CALC_DAYS, 
                        IS_INST_AVANS, 
                        FROM_SALARY, 
                        IS_KIDEM, 
                        RECORD_DATE, 
                        RECORD_EMP, 
                        RECORD_IP, 
                        IS_ISSIZLIK, 
                        IS_DAMGA, 
                        SSK_EXEMPTION_RATE,
                        TAX_EXEMPTION_RATE, 
                        TAX_EXEMPTION_VALUE, 
                        ACC_TYPE_ID, 
                        SSK_EXEMPTION_TYPE, 
                        AMOUNT_MULTIPLIER ,
						IS_INCOME,
						FACTOR_TYPE,
						COMMENT_TYPE,
						ISNULL(IS_RD_DAMGA,0) IS_RD_DAMGA,
						ISNULL(IS_RD_GELIR,0) IS_RD_GELIR, 
						ISNULL(IS_RD_SSK,0) IS_RD_SSK,
						SSK_STATUE,
						STATUE_TYPE
                    FROM 
    	                SETUP_PAYMENT_INTERRUPTION 
                    WHERE 
	                    ODKES_ID = #type# AND IS_ODENEK = 1
				</cfquery>
				<cfif get_types.recordcount>
					
					<cfif get_employee_id.recordcount and len(get_employee_id.EMPLOYEE_ID)>
							<cfquery name="add_odenek" datasource="#dsn#">
								INSERT INTO
									SALARYPARAM_PAY
									(
										FILE_NAME,
										SSK_EXEMPTION_RATE,
										SSK_EXEMPTION_TYPE,
										TAX_EXEMPTION_VALUE,
										COMMENT_PAY,
										COMMENT_PAY_ID,
										METHOD_PAY,
										PERIOD_PAY,
										SHOW,
										SSK,
										TAX,
										IS_DAMGA,
										IS_ISSIZLIK,
										IS_KIDEM,
										CALC_DAYS,
										FROM_SALARY,
										START_SAL_MON,
										END_SAL_MON,
										TERM,
										AMOUNT_PAY,
										AMOUNT_MULTIPLIER,
										EMPLOYEE_ID,
										IN_OUT_ID,
										RECORD_DATE,
										RECORD_EMP,
										RECORD_IP,
										IS_INCOME,
										FACTOR_TYPE,
										COMMENT_TYPE,
										IS_RD_DAMGA,
										IS_RD_GELIR, 
										IS_RD_SSK,
										SSK_STATUE,
										STATUE_TYPE,
										PROJECT_ID,
										PROCESS_STAGE
									)
								VALUES
									(
										'#file_name#',
										<cfif len(get_types.SSK_EXEMPTION_RATE)>#get_types.SSK_EXEMPTION_RATE#<cfelse>NULL</cfif>,
										<cfif len(get_types.SSK_EXEMPTION_TYPE)>#get_types.SSK_EXEMPTION_TYPE#<cfelse>NULL</cfif>,
										<cfif len(get_types.TAX_EXEMPTION_VALUE)>#get_types.TAX_EXEMPTION_VALUE#<cfelse>NULL</cfif>,
										'#get_types.comment_pay#',
										#type#,
										#get_types.method_pay#,
										#get_types.period_pay#,
										#get_types.show#,
										#get_types.ssk#,
										#get_types.tax#,
										#get_types.IS_DAMGA#,
										#get_types.IS_ISSIZLIK#,
										#get_types.is_kidem#,
										#get_types.calc_days#,
										#get_types.from_salary#,
										#sal_mon#,
										#end_sal_mon#,
										#sal_year#,
										#sal_value#,
										<cfif len(get_types.AMOUNT_MULTIPLIER)>#get_types.AMOUNT_MULTIPLIER#<cfelse>NULL</cfif>,
										#this_employee_id_#,
										#this_in_out_id_#,
										#now()#,
										#session.ep.userid#,
										'#cgi.REMOTE_ADDR#',
										<cfif len(get_types.IS_INCOME)>#get_types.IS_INCOME#<cfelse>0</cfif>,
										<cfif len(get_types.FACTOR_TYPE)>#get_types.FACTOR_TYPE#<cfelse>NULL</cfif>,
										<cfif len(get_types.COMMENT_TYPE)>#get_types.COMMENT_TYPE#<cfelse>1</cfif>,
										#get_types.IS_RD_DAMGA#,
										#get_types.IS_RD_GELIR#,
										#get_types.IS_RD_SSK#,
										<cfif len(get_types.SSK_STATUE)><cfqueryparam cfsqltype="cf_sql_integer" value="#get_types.SSK_STATUE#"><cfelse>1</cfif>,
										<cfif len(get_types.SSK_STATUE) and len(get_types.STATUE_TYPE) and get_types.SSK_STATUE eq 2><cfqueryparam cfsqltype="cf_sql_integer" value="#get_types.STATUE_TYPE#"><cfelse>0</cfif>,
										<cfif len(project_id)><cfqueryparam cfsqltype="cf_sql_integer" value="#project_id#"><cfelse>NULL</cfif>,
										<cfif isdefined("process_stage")and len(process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#process_stage#"><cfelse>NULL</cfif>
									)
						</cfquery>
						<cfoutput>
							#sira#  #tc_kimlik# #name# : <cf_get_lang dictionary_id='44525.Import completed'>.....<br/>
						</cfoutput>	
					<cfelse>
						<cfoutput>
								#sira#  #tc_kimlik# #name# : <cf_get_lang dictionary_id='64999.Çalışan ilgili şubede kayıtlı değil'>.....<br/>
						</cfoutput>	
					</cfif>
				<cfelse>
					<cfoutput>
							#sira#  #tc_kimlik# #name# : <cf_get_lang dictionary_id='65000.Belirttiğiniz ödenek tipi tanımlı değil'>.....<br/>
					</cfoutput>	
				</cfif>
			<cfelseif attributes.process_type eq 3>
				<cfquery name="get_types" datasource="#dsn#">
					SELECT 
                        ODKES_ID, 
                        COMMENT_PAY, 
                        PERIOD_PAY, 
                        METHOD_PAY, 
                        AMOUNT_PAY, 
                        SSK, 
                        TAX, 
                        SHOW, 
                        START_SAL_MON,
                        END_SAL_MON, 
                        IS_ODENEK,
                        CALC_DAYS, 
                        IS_INST_AVANS, 
                        FROM_SALARY, 
                        IS_KIDEM, 
                        RECORD_DATE, 
                        RECORD_EMP, 
                        RECORD_IP, 
                        IS_ISSIZLIK, 
                        IS_DAMGA, 
                        SSK_EXEMPTION_RATE,
                        TAX_EXEMPTION_RATE, 
                        TAX_EXEMPTION_VALUE, 
                        ACC_TYPE_ID, 
                        SSK_EXEMPTION_TYPE, 
                        AMOUNT_MULTIPLIER,
						ACCOUNT_CODE,
						ACCOUNT_NAME ,
                        COMPANY_ID,
                        CONSUMER_ID,
						IS_NET_TO_GROSS                       
                    FROM 
	                    SETUP_PAYMENT_INTERRUPTION 
                    WHERE 
                    	ODKES_ID = #type# AND IS_ODENEK = 0
				</cfquery>
				<cfif get_types.recordcount>
					<cfif get_employee_id.recordcount and len(get_employee_id.EMPLOYEE_ID)>
							<cfquery name="add_kesinti" datasource="#dsn#">
								INSERT INTO
									SALARYPARAM_GET
									(
										FILE_NAME,
										COMMENT_GET,
										METHOD_GET,
										PERIOD_GET,
										SHOW,
										CALC_DAYS,
										IS_INST_AVANS,
										FROM_SALARY,
										START_SAL_MON,
										END_SAL_MON,
										TERM,
										AMOUNT_GET,
										EMPLOYEE_ID,
										IN_OUT_ID,
										TAX,
										RECORD_DATE,
										RECORD_EMP,
										RECORD_IP,
										ACC_TYPE_ID,
                                        ACCOUNT_CODE,
                                        ACCOUNT_NAME,
                                        COMPANY_ID,
                                        CONSUMER_ID,
										PROCESS_STAGE,
										IS_NET_TO_GROSS
									)
								VALUES
									(
										'#file_name#',
										'#get_types.comment_pay#',
										#get_types.method_pay#,
										#get_types.period_pay#,
										#get_types.show#,
										#get_types.calc_days#,
										#get_types.is_inst_avans#,
										#get_types.from_salary#,
										#sal_mon#,
										#end_sal_mon#,
										#sal_year#,
										#sal_value#,
										#this_employee_id_#,
										#this_in_out_id_#,
										#get_types.tax#,
										#now()#,
										#session.ep.userid#,
										'#cgi.REMOTE_ADDR#',
										<cfif len(get_types.ACC_TYPE_ID)>#get_types.ACC_TYPE_ID#<cfelse>NULL</cfif>,
										<cfif len(get_types.ACCOUNT_CODE)>'#get_types.ACCOUNT_CODE#'<cfelse>NULL</cfif>,
										<cfif len(get_types.ACCOUNT_NAME)>'#get_types.ACCOUNT_NAME#'<cfelse>NULL</cfif>,
										<cfif len(get_types.COMPANY_ID)>#get_types.COMPANY_ID#<cfelse>NULL</cfif>,
										<cfif len(get_types.CONSUMER_ID)>#get_types.CONSUMER_ID#<cfelse>NULL</cfif>,
										<cfif isdefined("process_stage")and len(process_stage)><cfqueryparam cfsqltype="cf_sql_integer" value="#process_stage#"><cfelse>NULL</cfif>,
										<cfif isDefined("get_types.is_net_to_gross") and len(get_types.is_net_to_gross) and get_types.from_salary eq 1><cfqueryparam cfsqltype="cf_sql_bit" value="#get_types.is_net_to_gross#"><cfelse>0</cfif>
									)
							</cfquery>
					<cfoutput>
						#sira#  #tc_kimlik# #name# : <cf_get_lang dictionary_id='44525.Import completed'>.....<br/>
					</cfoutput>	
				<cfelse>
					<cfoutput>
							#sira#  #tc_kimlik# #name# : <cf_get_lang dictionary_id='64999.Çalışan ilgili şubede kayıtlı değil'>.....<br/>
					</cfoutput>
				</cfif>
			<cfelse>
				<cfoutput>
						#sira#  #tc_kimlik# #name# : <cf_get_lang dictionary_id='65001.Belirttiğiniz kesinti tipi tanımlı değil'>.....<br/>
				</cfoutput>	
			</cfif>
			<cfelseif attributes.process_type eq 4>
				<cfquery name="get_tax_types" datasource="#dsn#">
					SELECT 
    	                TAX_EXCEPTION_ID, 
                        TAX_EXCEPTION, 
                        START_MONTH, 
                        FINISH_MONTH, 
                        AMOUNT, 
                        YUZDE_SINIR, 
                        IS_ALL_PAY, 
                        RECORD_DATE, 
                        RECORD_EMP, 
                        RECORD_IP, 
                        IS_ISVEREN, 
                        IS_SSK, 
                        EXCEPTION_TYPE,
                        CALC_DAYS
                    FROM 
	                    TAX_EXCEPTION 
                    WHERE 
                    	TAX_EXCEPTION_ID = #type#
				</cfquery>
					<cfif get_tax_types.recordcount>
						<cfif get_employee_id.recordcount and len(get_employee_id.EMPLOYEE_ID)>
									<cfquery name="add_tax" datasource="#dsn#">
										INSERT INTO
											SALARYPARAM_EXCEPT_TAX
											(
												EXCEPTION_TYPE,
												IS_SSK,
												IS_ISVEREN,
												IS_ALL_PAY,
												FILE_NAME,
												TAX_EXCEPTION,
												START_MONTH	,
												FINISH_MONTH,
												TERM,
												AMOUNT,
												CALC_DAYS,
												YUZDE_SINIR,
												EMPLOYEE_ID,
												IN_OUT_ID
											)
										VALUES
											(
												<cfif len(get_tax_types.EXCEPTION_TYPE)>#get_tax_types.EXCEPTION_TYPE#<cfelse>NULL</cfif>,
												<cfif len(get_tax_types.IS_SSK)>#get_tax_types.IS_SSK#<cfelse>0</cfif>,
												<cfif len(get_tax_types.IS_ISVEREN)>#get_tax_types.IS_ISVEREN#<cfelse>0</cfif>,
												<cfif len(get_tax_types.IS_ALL_PAY)>#get_tax_types.IS_ALL_PAY#<cfelse>0</cfif>,
												'#file_name#',
												'#get_tax_types.tax_exception#',
												#sal_mon#,
												#end_sal_mon#,
												#sal_year#,
												#sal_value#,
												#get_tax_types.calc_days#,
												#get_tax_types.YUZDE_SINIR#,
												#this_employee_id_#,
												#this_in_out_id_#
									)
									</cfquery>
								<cfoutput>
									#sira#  #tc_kimlik# #name# : <cf_get_lang dictionary_id='44525.Import completed'>.....<br/>
								</cfoutput>	
						<cfelse>
							<cfoutput>
									#sira#  #tc_kimlik# #name# : <cf_get_lang dictionary_id='64999.Çalışan ilgili şubede kayıtlı değil'>.....<br/>
							</cfoutput>	
						</cfif>
				<cfelse>
					<cfoutput>
							#sira#  #tc_kimlik# #name# : <cf_get_lang dictionary_id='65002.Belirttiğiniz Vergi İstisnası tipi tanımlı değil'>.....<br/>
					</cfoutput>	
				</cfif>
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
	alert("<cf_get_lang dictionary_id='44525.Import completed'>!");
	location.href="<cfoutput>#request.self#?fuseaction=ehesap.list_import_process</cfoutput>";
</script>
