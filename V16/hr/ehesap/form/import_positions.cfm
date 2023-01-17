<cfsetting showdebugoutput="no">
<cf_get_lang_set module_name="settings"><!--- sayfanin en altinda kapanisi var --->
<cfif not isdefined('attributes.uploaded_file')>
	<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
		<cf_box title="#getLang('','Pozisyon Aktarım','43732')#">
			<cfform name="formimport" action="#request.self#?fuseaction=ehesap.import_positions" enctype="multipart/form-data" method="post">
				<cfquery name="GET_PROCESS_TYPES" datasource="#DSN#">
					SELECT
						PTR.STAGE,
						PTR.PROCESS_ROW_ID 
					FROM
						PROCESS_TYPE_ROWS PTR,
						PROCESS_TYPE_OUR_COMPANY PTO,
						PROCESS_TYPE PT
					WHERE
						PT.IS_ACTIVE = 1 AND
						PTR.PROCESS_ID = PT.PROCESS_ID AND
						PT.PROCESS_ID = PTO.PROCESS_ID AND
						PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
						PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%hr.popup_add_position%">
				</cfquery>
				<cf_box_elements>
					<div class="col col-4 col-md-4 col-sm-4 col-xs-12" type="column" index="1" sort="true">   
						<div class="form-group" id="item-file_format">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='32901.Belge Formatı'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="file_format" id="file_format">
									<option value="UTF-8"><cf_get_lang dictionary_id='43388.UTF-8'></option>
								</select>
							</div>
						</div>      
						<div class="form-group" id="item-process_stage">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57482.Aşama'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<select name="process_stage" id="process_stage">
									<cfoutput query="get_process_types">
										<option value="#process_row_id#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq process_row_id)>selected</cfif>>#stage#</option>
									</cfoutput>
								</select>
							</div>
						</div> 			
						<div class="form-group" id="item-file">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='57468.Belge'>*</label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<input type="file" name="uploaded_file" id="uploaded_file">
							</div>
						</div> 	
						<div class="form-group" id="item-example_file">
							<label class="col col-4 col-md-4 col-sm-4 col-xs-12"><cf_get_lang dictionary_id='43671.Örnek Ürün Dosyası'></label>
							<div class="col col-8 col-md-8 col-sm-8 col-xs-12">
								<a href="/IEF/standarts/import_example_file/pozisyon_aktarim.csv"><strong><cf_get_lang dictionary_id='43675.İndir'></strong></a>
							</div>
						</div> 									         
					</div>
					<div class="col col-8 col-md-8 col-sm-8 col-xs-12" type="column" index="2" sort="true">  
						<div class="form-group" id="item-format">
							<label><b><cf_get_lang dictionary_id='58594.Format'></b></label>
						</div>   
						<div class="form-group" id="item-exp1">
							<cf_get_lang dictionary_id ='35657.Dosya uzantısı csv olacak ve alan araları noktalı virgül (;) ile ayrılacaktır'>.
						</div>  
						<div class="form-group" id="item-exp2">
							<cf_get_lang dictionary_id ='44193.Aktarım işlemi dosyanın 2 satırından itibaren başlar bu yüzden birinci satırda alan isimleri olmalıdır'>.
						</div> 
						<div class="form-group" id="item-exp3">
							<cf_get_lang dictionary_id ='44347.Belgede toplam 10 sutun olacaktır alanlar sırasi ile'>;
						</div> 
						<div class="form-group" id="item-exp4">
							1-<cf_get_lang dictionary_id ='58025.Tc Kimlik No'>*</br>
							2-<cf_get_lang dictionary_id ='55479.Pozisyon Adı'>*</br>
							3-<cf_get_lang dictionary_id ='59004.Pozisyon Tipi'> <cf_get_lang dictionary_id="58527.ID">*</br>
							4-<cf_get_lang dictionary_id ='57571.Unvan'> <cf_get_lang dictionary_id="58527.ID">*</br>
							5-<cf_get_lang dictionary_id ='59144.Fonksiyon Id'></br>
							6-<cf_get_lang dictionary_id ='59146.Kademe Id'></br>
							7-<cf_get_lang dictionary_id ='56063.Yaka Tipi'> (<cf_get_lang dictionary_id="56065.Mavi yaka">=1,<cf_get_lang dictionary_id="56066.Beyaz Yaka">=2)</br>
							8-<cf_get_lang dictionary_id ='30562.Master'> (<cf_get_lang dictionary_id ='30562.Master'>=1,<cf_get_lang dictionary_id="39177.Master Olmayan">=0)</br>
							9-<cf_get_lang dictionary_id ='56059.Org Şemada Göster'> (<cf_get_lang dictionary_id="57495.Evet">=1,<cf_get_lang dictionary_id="57496.Hayır">=0)</br>
							10-<cf_get_lang dictionary_id ='30937.Gerekçe'> <cf_get_lang dictionary_id="58527.ID"></br>
							11-<cf_get_lang dictionary_id ='57572.Departman'> <cf_get_lang dictionary_id="58527.ID">*</br>
							12-<cf_get_lang dictionary_id='56232.Göreve Başlama'></br>
						</div> 
					</div>
				</cf_box_elements>
				<cf_box_footer>
					<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</cf_box_footer>
			</cfform>
		</cf_box>
	</div>
	<script type="text/javascript">
		function kontrol()
		{
			if(formimport.uploaded_file.value.length==0)
			{
				alert("<cf_get_lang dictionary_id='43424.Belge Seçmelisiniz'>!");
				return false;
			}
			if(document.getElementById('process_stage').value == '')
			{
				alert("<cf_get_lang dictionary_id='57978.Bu İşlem Tipine Yetkiniz Yok !'>");
				return false;
			}
				return true;
			
		}
	</script>
<cfelse>
	<cfsetting showdebugoutput="no">
	<cfset upload_folder_ = "#upload_folder#temp#dir_seperator#">
	<cftry>
		<cffile action = "upload" 
				filefield = "uploaded_file" 
				destination = "#upload_folder_#"
				nameconflict = "MakeUnique"  
				mode="777" charset="#attributes.file_format#">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder_##cffile.serverfile#" destination="#upload_folder_##file_name#" charset="#attributes.file_format#">	
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
		<cffile action="read" file="#upload_folder_##file_name#" variable="dosya" charset="#attributes.file_format#">
		<cffile action="delete" file="#upload_folder_##file_name#">
	<cfcatch>
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='29450.Dosya Okunamadı! Karakter Seti Yanlış Seçilmiş Olabilir'>.");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
	</cftry>
	<cfscript>
		CRLF = Chr(13) & Chr(10);// satır atlama karakteri
		dosya = Replace(dosya,';;','; ;','all');
		dosya = Replace(dosya,';;','; ;','all');
		dosya = ListToArray(dosya,CRLF);
		line_count = ArrayLen(dosya);
		counter = 0;
		liste = "";
	</cfscript>
	
	
	<cfset error_flag = 0>
	<cfloop from="2" to="#line_count#" index="i">
		<cfset error_flag_bir = 0>
		
		<cfset j= 1>
		<cftry>
			
			<cfscript>
			counter = counter + 1;
			//tckimlik_no
			tckimlik_no = Listgetat(dosya[i],j,";");
			tckimlik_no =trim(tckimlik_no);
			j=j+1;
			//pozisyon adı
			position_name = Listgetat(dosya[i],j,";");
			position_name =trim(position_name);
			j=j+1;
			//pozisyon cat id
			position_cat_id = Listgetat(dosya[i],j,";");
			position_cat_id =trim(position_cat_id);
			j=j+1;
			//unvan id
			title_id = Listgetat(dosya[i],j,";");
			title_id =trim(title_id);
			j=j+1;
			//fonksiyon id
			func_id = Listgetat(dosya[i],j,";");
			func_id =trim(func_id);
			j=j+1;
			//kademe id
			organization_step_id = Listgetat(dosya[i],j,";");
			organization_step_id =trim(organization_step_id);
			j=j+1;
			//yaka tipi
			collar_type = Listgetat(dosya[i],j,";");
			collar_type =trim(collar_type);
			j=j+1;
			//master
			is_master = Listgetat(dosya[i],j,";");
			is_master =trim(is_master);
			j=j+1;
			//org şemada goster
			is_org_view = Listgetat(dosya[i],j,";");
			is_org_view =trim(is_org_view);
			j=j+1;
			//gerekçe id
			in_company_reason_id= Listgetat(dosya[i],j,";");
			in_company_reason_id =trim(in_company_reason_id);
			j=j+1;
			//departman no
			department_id = Listgetat(dosya[i],j,";");
			department_id =trim(department_id);
			j=j+1;
			
			if(listlen(dosya[i],";") gte 12)
			{
				//gorev tarih
				start_date = Listgetat(dosya[i],j,";");
				start_date = trim(start_date);
				j=j+1;
			}
			else
				start_date = '';
			</cfscript>
			
			<cfcatch type="Any">
				
				<cfset liste=ListAppend(liste,i&'. satırda okuma sırasında hata oldu <br/>',',')>
				<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44947.Birinci adımda sorun oluştu'><br/>
				<cfset error_flag = 1>
				<cfset error_flag_bir = 1>
			</cfcatch>
		</cftry>
 		<cfif len(tckimlik_no) and len(department_id) and len(position_name) and len(position_cat_id) and len(title_id) and error_flag_bir neq 1>
				<cfquery name="GET_EMPLOYEE_INFO" maxrows="1" datasource="#dsn#">
                	SELECT 
						E.EMPLOYEE_ID,
                        E.EMPLOYEE_NAME,
                        E.EMPLOYEE_SURNAME,
                        E.EMPLOYEE_EMAIL
					FROM
						EMPLOYEES_IDENTY EI,
                        EMPLOYEES E
					WHERE 
                        EI.EMPLOYEE_ID = E.EMPLOYEE_ID AND
						EI.TC_IDENTY_NO = '#tckimlik_no#'
				</cfquery>
                <cfif get_employee_info.recordcount and len(is_master) and is_master eq 1>
                    <cfquery name="master_position_control" maxrows="1" datasource="#dsn#">
                        SELECT
                            POSITION_CODE
                        FROM
                            EMPLOYEE_POSITIONS
                        WHERE
                            EMPLOYEE_ID = #GET_EMPLOYEE_INFO.EMPLOYEE_ID#
                            AND IS_MASTER = 1
                    </cfquery>
                    <cfif master_position_control.recordcount>
                    	<cfoutput>#liste#</cfoutput>
                    	<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44948.İkinci adımda sorun oluştu'><br/>
                    	<cf_get_lang dictionary_id="59661.Bir çalışanın birden fazla master pozisyonu olamaz">. <cf_get_lang dictionary_id="59662.Kayıtları kontrol ederek tekrar deneyiniz">!
                        <cfabort>
					</cfif>
                </cfif>
                <cfquery name="get_dep_branch" datasource="#dsn#">
                	SELECT 
                    	BRANCH_ID
                    FROM 
                    	DEPARTMENT
                    WHERE
                    	DEPARTMENT_ID = #department_id#
                </cfquery>
                <cfquery name="GET_MAX_POS" datasource="#dsn#">
                    SELECT
                        MAX(POSITION_CODE) AS PCODE
                    FROM
                        EMPLOYEE_POSITIONS
                </cfquery>
                <cfif not len(get_max_pos.PCODE)>
                    <cfset p=0>
                <cfelse>
                    <cfset p=get_max_pos.PCODE>
                </cfif>
                <cfset pcode=evaluate(p + 1)>
				<cfif GET_EMPLOYEE_INFO.recordcount>
					<cftry>
						<cfset new_hie_ = ''>
						<cfif fusebox.dynamic_hierarchy>
							<cfquery name="get_uppers" datasource="#DSN#">
								SELECT 
									O.HIERARCHY AS HIE1,
									Z.HIERARCHY AS HIE2,
									O.HIERARCHY2 AS HIE3,			
									B.HIERARCHY AS HIE4,
									D.HIERARCHY AS HIE5
								FROM
									DEPARTMENT D,
									BRANCH B,
									OUR_COMPANY O,
									ZONE Z
								WHERE
									B.ZONE_ID = Z.ZONE_ID AND
									D.BRANCH_ID = B.BRANCH_ID AND
									B.COMPANY_ID = O.COMP_ID AND
									D.DEPARTMENT_ID = #department_id#
							</cfquery>
							<cfquery name="get_position_cat" datasource="#DSN#">
								SELECT HIERARCHY FROM SETUP_POSITION_CAT WHERE POSITION_CAT_ID = #position_cat_id#
							</cfquery>
							<cfquery name="get_title" datasource="#DSN#">
								SELECT HIERARCHY FROM SETUP_TITLE WHERE TITLE_ID = #title_id#
							</cfquery>
							<cfif len(func_id)><!--- fonksiyon son eleman olacak sekilde ayarlandi --->
								<cfquery name="get_fonk" datasource="#DSN#">
									SELECT
									   HIERARCHY
									FROM
										SETUP_CV_UNIT
									WHERE
										UNIT_ID = #func_id#
								</cfquery>
								<cfif get_fonk.recordcount and len(get_fonk.HIERARCHY)>
									<cfset fonk_add_ = '.#get_fonk.HIERARCHY#'>
								<cfelse>
									<cfset fonk_add_ = ''>
								</cfif>
							<cfelse>
								<cfset fonk_add_ = ''>
							</cfif>
							<cfif get_uppers.recordcount>
								<cfset new_hie_ = '#get_uppers.HIE1#.' & '#get_uppers.HIE2#.' & '#get_uppers.HIE3#.' & '#get_uppers.HIE4#.' & '#get_uppers.HIE5#.' & '#get_title.HIERARCHY#.' & '#get_position_cat.HIERARCHY#' & '#fonk_add_#'>
							<cfelse>
								<cfset new_hie_ = ''>
							</cfif>
							<cfset attributes.dynamic_hierarchy_add = ''>
							<cfquery name="upd_2" datasource="#DSN#">
								UPDATE 
									EMPLOYEES 
								SET 
									DYNAMIC_HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hie_#">,
									DYNAMIC_HIERARCHY_ADD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dynamic_hierarchy_add#"> 
								WHERE 
									EMPLOYEE_ID = #GET_EMPLOYEE_INFO.EMPLOYEE_ID#
							</cfquery>
						</cfif>	
						<cfquery datasource="#dsn#" name="add_position" RESULT="XX">
							INSERT INTO
                            	EMPLOYEE_POSITIONS
                            (
                            	IN_COMPANY_REASON_ID,
                                POSITION_CODE,
                                POSITION_CAT_ID,
                                COLLAR_TYPE,
                                POSITION_STATUS,
                                POSITION_NAME,
                                EMPLOYEE_ID,
                                EMPLOYEE_NAME,
                                EMPLOYEE_SURNAME,
                                EMPLOYEE_EMAIL,
                                DEPARTMENT_ID,
                                BRANCH_ID,
                                EHESAP,
                                TITLE_ID,
                                ORGANIZATION_STEP_ID,
                                IS_MASTER,
								IS_ORG_VIEW,
                                FUNC_ID,
                                POSITION_STAGE,
                                IS_VEKALETEN,
								UPDATE_DATE,
								UPDATE_EMP,
								UPDATE_IP
								<cfif fusebox.dynamic_hierarchy>
								,DYNAMIC_HIERARCHY
								,DYNAMIC_HIERARCHY_ADD
								</cfif>
                            )
                            VALUES
                            (
                            	<cfif len(in_company_reason_id)>#in_company_reason_id#<cfelse>0</cfif>,
                                #pcode#,
                                #position_cat_id#,
                                <cfif len(collar_type)>#collar_type#<cfelse>NULL</cfif>,
                                1,
                                '#position_name#',
                                #GET_EMPLOYEE_INFO.EMPLOYEE_ID#,
                                <cfif len(GET_EMPLOYEE_INFO.EMPLOYEE_NAME)>'#GET_EMPLOYEE_INFO.EMPLOYEE_NAME#'<cfelse>NULL</cfif>,
                                <cfif len(GET_EMPLOYEE_INFO.EMPLOYEE_SURNAME)>'#GET_EMPLOYEE_INFO.EMPLOYEE_SURNAME#'<cfelse>NULL</cfif>,
                                <cfif len(GET_EMPLOYEE_INFO.EMPLOYEE_EMAIL)>'#GET_EMPLOYEE_INFO.EMPLOYEE_EMAIL#'<cfelse>NULL</cfif>,
                                #department_id#,
                                <cfif len(get_dep_branch.BRANCH_ID)>#get_dep_branch.BRANCH_ID#<cfelse>NULL</cfif>,
                                0,
                                #title_id#,
                                <cfif len(organization_step_id)>#organization_step_id#<cfelse>NULL</cfif>,
                                <cfif len(is_master)>#is_master#<cfelse>NULL</cfif>,
                                <cfif len(is_org_view)>#is_org_view#<cfelse>NULL</cfif>,
                                <cfif len(func_id)>#func_id#<cfelse>NULL</cfif>,
                                #attributes.process_stage#,
                                0,
								#now()#,
								#SESSION.EP.USERID#,
								'#CGI.REMOTE_ADDR#'	
								<cfif fusebox.dynamic_hierarchy>
									,<cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hie_#">
									,<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dynamic_hierarchy_add#">
								</cfif>
                            )
						</cfquery>
						
						<cfif len(start_date)>
							<cf_date tarih="start_date">
						</cfif>
						
						<cfquery datasource="#dsn#" name="add_positionh">
							INSERT INTO
                            EMPLOYEE_POSITIONS_HISTORY
                            (
								POSITION_ID,
								START_DATE,
                            	IN_COMPANY_REASON_ID,
                                POSITION_CODE,
                                POSITION_CAT_ID,
                                COLLAR_TYPE,
                                POSITION_STATUS,
                                POSITION_NAME,
                                EMPLOYEE_ID,
                                EMPLOYEE_NAME,
                                EMPLOYEE_SURNAME,
                                EMPLOYEE_EMAIL,
                                DEPARTMENT_ID,
                                EHESAP,
                                TITLE_ID,
                                ORGANIZATION_STEP_ID,
                                IS_MASTER,
								IS_ORG_VIEW,
                                FUNC_ID,
                                POSITION_STAGE,
                                IS_VEKALETEN,
								RECORD_DATE,
								RECORD_EMP,
								RECORD_IP
								<cfif fusebox.dynamic_hierarchy>
								,DYNAMIC_HIERARCHY
								,DYNAMIC_HIERARCHY_ADD
								</cfif>
                            )
                            VALUES
                            (
								#XX.IDENTITYCOL#,
								<cfif len(start_date)>#start_date#<cfelse>NULL</cfif>,
                            	<cfif len(in_company_reason_id)>#in_company_reason_id#<cfelse>0</cfif>,
                                #pcode#,
                                #position_cat_id#,
                                <cfif len(collar_type)>#collar_type#<cfelse>NULL</cfif>,
                                1,
                                '#position_name#',
                                #GET_EMPLOYEE_INFO.EMPLOYEE_ID#,
                                <cfif len(GET_EMPLOYEE_INFO.EMPLOYEE_NAME)>'#GET_EMPLOYEE_INFO.EMPLOYEE_NAME#'<cfelse>NULL</cfif>,
                                <cfif len(GET_EMPLOYEE_INFO.EMPLOYEE_SURNAME)>'#GET_EMPLOYEE_INFO.EMPLOYEE_SURNAME#'<cfelse>NULL</cfif>,
                                <cfif len(GET_EMPLOYEE_INFO.EMPLOYEE_EMAIL)>'#GET_EMPLOYEE_INFO.EMPLOYEE_EMAIL#'<cfelse>NULL</cfif>,
                                #department_id#,
                                0,
                                #title_id#,
                                <cfif len(organization_step_id)>#organization_step_id#<cfelse>NULL</cfif>,
                                <cfif len(is_master)>#is_master#<cfelse>NULL</cfif>,
                                <cfif len(is_org_view)>#is_org_view#<cfelse>NULL</cfif>,
                                <cfif len(func_id)>#func_id#<cfelse>NULL</cfif>,
                                #attributes.process_stage#,
                                0,
								#now()#,
								#SESSION.EP.USERID#,
								'#CGI.REMOTE_ADDR#'
								
								<cfif fusebox.dynamic_hierarchy>
									, <cfif len(new_hie_)><cfqueryparam cfsqltype="cf_sql_varchar" value="#new_hie_#"><cfelse>NULL</cfif>
									, <cfif len(attributes.dynamic_hierarchy_add)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.dynamic_hierarchy_add#"><cfelse>NULL</cfif>
								</cfif>
                            )
						</cfquery>
						<cfcatch type="Any">
							<cfset liste=ListAppend(liste,i&'. satırda kayıt sırasında hata oldu <br/>',',')>
							<cfoutput>#i#</cfoutput>. <cf_get_lang dictionary_id='58508.satır'> <cf_get_lang dictionary_id='44948.İkinci adımda sorun oluştu'><br/>
							<cfset error_flag = 1>
						</cfcatch>
					</cftry>
				<cfelse>
					<cfset liste=ListAppend(liste,i&'. satırın zorunlu bilgilerinden biri eksik ya da böyle bir çalışan kaydı yok <br/>',',')>
				</cfif>
			</cfif>
	</cfloop>
	<cfoutput>#liste#</cfoutput>
	<cfif error_flag neq 1>
		<cf_get_lang dictionary_id='44519.İŞLEM TAMAMLANDI'>.....
	</cfif>
	<script type="text/javascript">
		window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.import_positions';
	</script><abort>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
