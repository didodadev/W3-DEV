
<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
	<cfif not isdefined('attributes.uploaded_file')>
		<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
			<cf_box title="#getLang('','Çalışan Amir Aktarım','43731')#" closable="0">
				<cfform name="formimport" action="#request.self#?fuseaction=ehesap.import_standby" enctype="multipart/form-data" method="post">
					<cf_box_elements>
						<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">
							<div class="form-group" id="item-uploaded_file">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>		
								<div class="col col-6 col-md-8 col-sm-8 col-xs-12">		
									<input type="file" name="uploaded_file" id="uploaded_file">		
								</div>		
							</div>  
							<div class="form-group" id="item-download-link">
								<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>		
								<div class="col col-6 col-md-8 col-sm-8 col-xs-12">		
									<a  href="/IEF/standarts/import_example_file/Amir_Aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
								</div>		
							</div> 
						</div>
						<div class="col col-6 col-md-6 col-sm-8 col-xs-12" type="column" index="2" sort="true">
							<div class="form-group" id="item-format">
								<label><b><cf_get_lang dictionary_id='58594.Format'></b></label>		
							</div>  
							<div class="form-group" id="item-exp1">
								<cf_get_lang dictionary_id ='35657.Dosya uzantısı csv olacak ve alan araları noktalı virgül (;) ile ayrılacaktır'>
								<cf_get_lang dictionary_id ='44193.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>.
								<cf_get_lang dictionary_id ='59664.Eski veriler eklemiş olduğunuz belgedeki verilerle güncellenecektir'>.<br/>
								<cf_get_lang dictionary_id ='56451.Belgede toplam 14 sütun olacaktır alanlar sırası ile'>;<br/><br/>
								1- <cf_get_lang dictionary_id = '57576.Çalışan'> <cf_get_lang dictionary_id="57570.Ad Soyad"><br/>
								2- <cf_get_lang dictionary_id = '57576.Çalışan'><cf_get_lang dictionary_id = '58025.Tc Kimlik No'>*<br/>
								3- 1.<cf_get_lang dictionary_id = '29666.Amir'><br/>
								4- 1.<cf_get_lang dictionary_id = '29666.Amir'><cf_get_lang dictionary_id = '58025.Tc Kimlik No'><br/>
								5- 2.<cf_get_lang dictionary_id = '29666.Amir'><br/>
								6- 2.<cf_get_lang dictionary_id = '29666.Amir'><cf_get_lang dictionary_id = '58025.Tc Kimlik No'><br/>
								7- <cf_get_lang dictionary_id= '29908.Görüş Bildiren'><br/>
								8- <cf_get_lang dictionary_id= '29908.Görüş Bildiren'><cf_get_lang dictionary_id = '58025.Tc Kimlik No'><br/>
								9-  <cf_get_lang dictionary_id="35927.Birinci Amir"><cf_get_lang dictionary_id="32895.Yedek"> <br/>
								10- <cf_get_lang dictionary_id="35927.Birinci Amir"><cf_get_lang dictionary_id="32895.Yedek"><cf_get_lang dictionary_id = '58025.Tc Kimlik No'><br/>
								11- <cf_get_lang dictionary_id="35921.İkinci Amir"><cf_get_lang dictionary_id="32895.Yedek"><br/>
								12- <cf_get_lang dictionary_id="35921.İkinci Amir"> <cf_get_lang dictionary_id="32895.Yedek"><cf_get_lang dictionary_id = '58025.Tc Kimlik No'><br/>
								13- <cf_get_lang dictionary_id= '29908.Görüş Bildiren'> <cf_get_lang dictionary_id="32895.Yedek"><br/>
								14- <cf_get_lang dictionary_id= '29908.Görüş Bildiren'> <cf_get_lang dictionary_id="32895.Yedek"> <cf_get_lang dictionary_id = '58025.Tc Kimlik No'><br/>
								<br/><br/>
							</div>
					</cf_box_elements>
					<cf_box_footer>
						<cf_workcube_buttons is_upd='0'>
					</cf_box_footer>
				</cfform>
			</cf_box>
		</div>
	<cfelse>
		<cfsetting showdebugoutput="no">
		<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
		<cftry>
			<cffile action = "upload" 
				filefield = "uploaded_file" 
				destination = "#upload_folder_#"
				nameconflict = "MakeUnique"  
				mode="777"  charset="utf-8">
			<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
			<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="utf-8">
			<cfset file_size = cffile.filesize>
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang dictionary_id='57455.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
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
				alert("<cf_get_lang dictionary_id='59615.Dosya Okunamadı'>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
		</cftry>
		<cfscript>
			CRLF = Chr(13) & Chr(10);// satir atlama karakteri
			dosya = Replace(dosya,';;','; ;','all');
			dosya = Replace(dosya,';;','; ;','all');
			dosya = ListToArray(dosya,CRLF);
			line_count = ArrayLen(dosya);
			counter = 0;
			liste = "";
		</cfscript>
		<cfset error_flag = 0>

		<cfloop from="2" to="#line_count#" index="i">
			<cfset j= 1>
			<cftry>
				<cfscript>
					counter = counter + 1;
					//calisan_ad_soyad
					calisan_ad = trim(Listgetat(dosya[i],j,";"));
					j=j+1;
					//calisan tckimlik_no
					calisan_tc = trim(Listgetat(dosya[i],j,";"));
					j=j+1;
					//birinci amir
					if(listlen(dosya[i],';') gte j)
						birinci_amir = trim(Listgetat(dosya[i],j,";"));
					else
						birinci_amir = '';
					j=j+1;
					//birinci amir tckimlik_no
					if(listlen(dosya[i],';') gte j)
						birinci_amir_tc = trim(Listgetat(dosya[i],j,";"));
					else
						birinci_amir_tc = '';
					j=j+1;
					//ikinci amir
					if(listlen(dosya[i],';') gte j)
						ikinci_amir = trim(Listgetat(dosya[i],j,";"));
					else
						ikinci_amir = '';
					j=j+1;
					//ikinci amir tckimlik_no
					if(listlen(dosya[i],';') gte j)
						ikinci_amir_tc = trim(Listgetat(dosya[i],j,";"));
					else
						ikinci_amir_tc = '';
					j=j+1;
					//gorus bildiren
					if(listlen(dosya[i],';') gte j)
						gorus_bildiren = trim(Listgetat(dosya[i],j,";"));
					else
						gorus_bildiren = '';
					j=j+1;
					//gorus bildiren tckimlik_no
					if(listlen(dosya[i],';') gte j)
						gorus_bildiren_tc = trim(Listgetat(dosya[i],j,";"));
					else
						gorus_bildiren_tc = '';
					j=j+1;
					//birinci amir yedek
					if(listlen(dosya[i],';') gte j)
						birinci_amir_yedek = trim(Listgetat(dosya[i],j,";"));
					else
						birinci_amir_yedek = '';
					j=j+1;
					//birinci amir yedek tckimlik_no
					if(listlen(dosya[i],';') gte j)
						birinci_amir_yedek_tc = trim(Listgetat(dosya[i],j,";"));
					else
						birinci_amir_yedek_tc = '';
					j=j+1;
					//ikinci amir yedek
					if(listlen(dosya[i],';') gte j)
						ikinci_amir_yedek = trim(Listgetat(dosya[i],j,";"));
					else
						ikinci_amir_yedek = '';
					j=j+1;
					//ikinci amir yedek tckimlik_no
					if(listlen(dosya[i],';') gte j)
						ikinci_amir_yedek_tc = trim(Listgetat(dosya[i],j,";"));
					else
						ikinci_amir_yedek_tc = '';
					j=j+1;
					//gorus bildiren yedek
					if(listlen(dosya[i],';') gte j)
						gorus_bildiren_yedek = trim(Listgetat(dosya[i],j,";"));
					else
						gorus_bildiren_yedek = '';
					j=j+1;
					//gorus bildiren yedek tckimlik_no
					if(listlen(dosya[i],';') gte j)
						gorus_bildiren_yedek_tc = trim(Listgetat(dosya[i],j,";"));
					else
						gorus_bildiren_yedek_tc = '';
					j=j+1;
					//alanlar bitti
				</cfscript>
				
				<cfcatch type="Any">
					<cfset liste=ListAppend(liste,i&'. satırda okuma sırasında hata oldu <br/>',',')>
					<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44947.Birinci adımda sorun oluştu'><br/>
					<cfset error_flag = 1>
					<script>window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.import_standby"</script>
				</cfcatch>
			</cftry>
			<cfif error_flag eq 0>
				<cfif not len(calisan_tc)>
					<cfoutput>
						<script type="text/javascript">
							alert("#i#"."<cf_get_lang dictionary_id='59216.satırdaki zorunlu alanlarda eksik değerler var. Lütfen dosyanızı kontrol ediniz'>!");
							history.back();
						</script>
					</cfoutput>
					<cfabort>
				</cfif>
				<cfquery name="get_emp" maxrows="1" datasource="#dsn#">
					SELECT
						EP.POSITION_CODE
					FROM
						EMPLOYEES E
						INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
						INNER JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_ID = ISNULL ((SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=E.EMPLOYEE_ID AND IS_MASTER=1 AND POSITION_STATUS=1),(SELECT TOP 1 POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=E.EMPLOYEE_ID AND POSITION_STATUS=1 ORDER BY UPDATE_DATE DESC))
					WHERE
						EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#calisan_tc#">
				</cfquery>
				<cfif get_emp.recordcount>
					<cfif len(birinci_amir_tc)>
						<cfquery name="get_upper_pos" maxrows="1" datasource="#dsn#">
							SELECT
								EP.POSITION_CODE
							FROM
								EMPLOYEES E
								INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
								INNER JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_ID = ISNULL((SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=E.EMPLOYEE_ID AND IS_MASTER=1 AND POSITION_STATUS=1),(SELECT TOP 1 POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=E.EMPLOYEE_ID AND POSITION_STATUS=1 ORDER BY UPDATE_DATE DESC))
							WHERE
								EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#birinci_amir_tc#">
						</cfquery>
					</cfif>
					<cfif len(ikinci_amir_tc)>
						<cfquery name="get_upper_pos2" maxrows="1" datasource="#dsn#">
							SELECT
								EP.POSITION_CODE
							FROM
								EMPLOYEES E
								INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
								INNER JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_ID = ISNULL((SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=E.EMPLOYEE_ID AND IS_MASTER=1 AND POSITION_STATUS=1),(SELECT TOP 1 POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=E.EMPLOYEE_ID AND POSITION_STATUS=1 ORDER BY UPDATE_DATE DESC))
							WHERE
								EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ikinci_amir_tc#">
						</cfquery>
					</cfif>
					<cfif len(gorus_bildiren_tc)>
						<cfquery name="get_chief3" maxrows="1" datasource="#dsn#">
							SELECT
								EP.POSITION_CODE
							FROM
								EMPLOYEES E
								INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
								INNER JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_ID = ISNULL((SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=E.EMPLOYEE_ID AND IS_MASTER=1 AND POSITION_STATUS=1),(SELECT TOP 1 POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=E.EMPLOYEE_ID AND POSITION_STATUS=1 ORDER BY UPDATE_DATE DESC))
							WHERE
								EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gorus_bildiren_tc#">
						</cfquery>
					</cfif>
					<cfif len(birinci_amir_yedek_tc)>
						<cfquery name="get_candidate_pos_1" maxrows="1" datasource="#dsn#">
							SELECT
								EP.POSITION_CODE
							FROM
								EMPLOYEES E
								INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
								INNER JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_ID = ISNULL((SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=E.EMPLOYEE_ID AND IS_MASTER=1 AND POSITION_STATUS=1),(SELECT TOP 1 POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=E.EMPLOYEE_ID AND POSITION_STATUS=1 ORDER BY UPDATE_DATE DESC))
							WHERE
								EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#birinci_amir_yedek_tc#">
						</cfquery>
					</cfif>
					<cfif len(ikinci_amir_yedek_tc)>
						<cfquery name="get_candidate_pos_2" maxrows="1" datasource="#dsn#">
							SELECT
								EP.POSITION_CODE
							FROM
								EMPLOYEES E
								INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
								INNER JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_ID = ISNULL((SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=E.EMPLOYEE_ID AND IS_MASTER=1 AND POSITION_STATUS=1),(SELECT TOP 1 POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=E.EMPLOYEE_ID AND POSITION_STATUS=1 ORDER BY UPDATE_DATE DESC))
							WHERE
								EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ikinci_amir_yedek_tc#">
						</cfquery>
					</cfif>
					<cfif len(gorus_bildiren_yedek_tc)>
						<cfquery name="get_candidate_pos_3" maxrows="1" datasource="#dsn#">
							SELECT
								EP.POSITION_CODE
							FROM
								EMPLOYEES E
								INNER JOIN EMPLOYEES_IDENTY EI ON E.EMPLOYEE_ID = EI.EMPLOYEE_ID
								INNER JOIN EMPLOYEE_POSITIONS EP ON E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND EP.POSITION_ID = ISNULL((SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=E.EMPLOYEE_ID AND IS_MASTER=1 AND POSITION_STATUS=1),(SELECT TOP 1 POSITION_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=E.EMPLOYEE_ID AND POSITION_STATUS=1 ORDER BY UPDATE_DATE DESC))
							WHERE
								EI.TC_IDENTY_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#gorus_bildiren_yedek_tc#">
						</cfquery>
					</cfif>
					<cfquery name="get_standby" datasource="#dsn#">
						SELECT SB_ID FROM EMPLOYEE_POSITIONS_STANDBY WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp.position_code#">
					</cfquery>
					<cftry>
						<cfquery name="upd_pos" datasource="#dsn#">
							UPDATE
								EMPLOYEE_POSITIONS
							SET
								UPPER_POSITION_CODE = <cfif len(birinci_amir_tc) and get_upper_pos.recordcount><cfqueryparam cfsqltype="cf_sql_integer" value="#get_upper_pos.position_code#"><cfelse>NULL</cfif>,
								UPPER_POSITION_CODE2 = <cfif len(ikinci_amir_tc) and get_upper_pos2.recordcount><cfqueryparam cfsqltype="cf_sql_integer" value="#get_upper_pos2.position_code#"><cfelse>NULL</cfif>,
								UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
								UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
								UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
							WHERE
								POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp.position_code#">
						</cfquery>
						<cfif get_standby.recordcount>
							<cfquery name="upd_sb" datasource="#dsn#">
								UPDATE
									EMPLOYEE_POSITIONS_STANDBY
								SET
									CHIEF1_CODE = <cfif len(birinci_amir_tc) and get_upper_pos.recordcount><cfqueryparam cfsqltype="cf_sql_integer" value="#get_upper_pos.position_code#"><cfelse>NULL</cfif>,
									CHIEF2_CODE = <cfif len(ikinci_amir_tc) and get_upper_pos2.recordcount><cfqueryparam cfsqltype="cf_sql_integer" value="#get_upper_pos2.position_code#"><cfelse>NULL</cfif>,
									CHIEF3_CODE = <cfif len(gorus_bildiren_tc) and get_chief3.recordcount><cfqueryparam cfsqltype="cf_sql_integer" value="#get_chief3.position_code#"><cfelse>NULL</cfif>,
									CANDIDATE_POS_1 = <cfif len(birinci_amir_yedek_tc) and get_candidate_pos_1.recordcount><cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_pos_1.position_code#"><cfelse>NULL</cfif>,
									CANDIDATE_POS_2 = <cfif len(ikinci_amir_yedek_tc) and get_candidate_pos_2.recordcount><cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_pos_2.position_code#"><cfelse>NULL</cfif>,
									CANDIDATE_POS_3 = <cfif len(gorus_bildiren_yedek_tc) and get_candidate_pos_3.recordcount><cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_pos_3.position_code#"><cfelse>NULL</cfif>,
									UPDATE_DATE = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
									UPDATE_KEY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.userkey#">,
									UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">,
									UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
								WHERE
									SB_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_standby.sb_id#">
							</cfquery>
						<cfelse>
							<cfquery name="addd_sb" datasource="#dsn#">
								INSERT INTO
									EMPLOYEE_POSITIONS_STANDBY
									(
										POSITION_CODE
										<cfif len(birinci_amir_tc) and get_upper_pos.recordcount>,CHIEF1_CODE</cfif>
										<cfif len(ikinci_amir_tc) and get_upper_pos2.recordcount>,CHIEF2_CODE</cfif>
										<cfif len(gorus_bildiren_tc) and get_chief3.recordcount>,CHIEF3_CODE</cfif>
										<cfif len(birinci_amir_yedek_tc) and get_candidate_pos_1.recordcount>,CANDIDATE_POS_1</cfif>
										<cfif len(ikinci_amir_yedek_tc) and get_candidate_pos_2.recordcount>,CANDIDATE_POS_2</cfif>
										<cfif len(gorus_bildiren_yedek_tc) and get_candidate_pos_3.recordcount>,CANDIDATE_POS_3</cfif>
										,RECORD_EMP
										,RECORD_DATE
										,RECORD_KEY
										,RECORD_IP
									)
									VALUES
									(
										<cfqueryparam cfsqltype="cf_sql_integer" value="#get_emp.position_code#">
										<cfif len(birinci_amir_tc) and get_upper_pos.recordcount>,<cfqueryparam cfsqltype="cf_sql_integer" value="#get_upper_pos.position_code#"></cfif>
										<cfif len(ikinci_amir_tc) and get_upper_pos2.recordcount>,<cfqueryparam cfsqltype="cf_sql_integer" value="#get_upper_pos2.position_code#"></cfif>
										<cfif len(gorus_bildiren_tc) and get_chief3.recordcount>,<cfqueryparam cfsqltype="cf_sql_integer" value="#get_chief3.position_code#"></cfif>
										<cfif len(birinci_amir_yedek_tc) and get_candidate_pos_1.recordcount>,<cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_pos_1.position_code#"></cfif>
										<cfif len(ikinci_amir_yedek_tc) and get_candidate_pos_2.recordcount>,<cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_pos_2.position_code#"></cfif>
										<cfif len(gorus_bildiren_yedek_tc) and get_candidate_pos_3.recordcount>,<cfqueryparam cfsqltype="cf_sql_integer" value="#get_candidate_pos_3.position_code#"></cfif>
										,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
										,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
										,<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ep.userkey#">
										,<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">
									)
							</cfquery>
						</cfif>
						<cfcatch type="Any">
							<cfset liste=ListAppend(liste,i&'. satırda kayıt sırasında hata oldu <br/>',',')>
							<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44948.İkinci adımda sorun oluştu'><br/>
						</cfcatch>
					</cftry>
				<cfelse>
					<cfset liste=ListAppend(liste,i&'. satırın employee_id si yok <br/>',',')>
				</cfif>
			</cfif>
		</cfloop>
		<cfoutput>#liste#</cfoutput>
		<cfif error_flag neq 1>
			<cf_get_lang dictionary_id='44519.İŞLEM TAMAMLANDI'>
			<script>window.location.href = "<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.import_standby"</script>
		</cfif>
	</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
