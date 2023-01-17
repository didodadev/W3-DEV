<cfsetting showdebugoutput="no">
<!--- Personel Talep Formu --->
<style>
	table,td{font-size:13px;}
	.txtbold_{font-weight: bold;}
</style>
<cfquery name="get_edu_level" datasource="#dsn#">
	SELECT EDU_LEVEL_ID, EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL ORDER BY EDU_LEVEL_ID
</cfquery>
<cfquery name="get_per_req" datasource="#dsn#">
	SELECT 
        PERSONEL_REQUIREMENT_ID, 
        PERSONEL_REQUIREMENT_HEAD, 
        OUR_COMPANY_ID, 
        DEPARTMENT_ID, 
        BRANCH_ID, 
        POSITION_CAT_ID, 
        POSITION_ID, 
        PERSONEL_COUNT, 
        PERSONEL_DETAIL, 
        REQUIREMENT_REASON, 
        PERSONEL_EXP, 
        PERSONEL_AGE, 
        PERSONEL_ABILITY, 
        PERSONEL_PROPERTIES, 
        PERSONEL_LANG, 
        PERSONEL_OTHER, 
        MIN_SALARY, 
        MIN_SALARY_MONEY, 
        MAX_SALARY,
        MAX_SALARY_MONEY, 
        PERSONEL_START_DATE, 
        REQUIREMENT_EMP, 
        TRAINING_LEVEL, 
        PER_REQ_STAGE, 
        RECORD_EMP,
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        REQUIREMENT_PAR_ID, 
        REQUIREMENT_CONS_ID, 
        REQUIREMENT_EMP_POS_CODE, 
        VEHICLE_REQ, 
        VEHICLE_REQ_MODEL, 
        LICENCECAT_ID, 
        OLD_PERSONEL_NAME, 
        OLD_PERSONEL_POSITION, 
        OLD_PERSONEL_FINISHDATE, 
        OLD_PERSONEL_DETAIL, 
        FORM_TYPE, 
        REQUIREMENT_DATE, 
        WORK_START, 
        WORK_FINISH, 
        CHANGE_PERSONEL_POSITION, 
        CHANGE_PERSONEL_NAME, 
        CHANGE_PERSONEL_POSITION_NEW, 
        CHANGE_PERSONEL_FINISHDATE, 
        TRANSFER_PERSONEL_NAME, 
        TRANSFER_PERSONEL_POSITION, 
        TRANSFER_PERSONEL_BRANCH_NEW, 
        TRANSFER_PERSONEL_POSITION_NEW, 
        TRANSFER_PERSONEL_STARTDATE, 
        IS_SHOW, 
        CHANGE_POSITION_ID, 
        CHANGE_PERSONEL_POSITION_NEW_ID, 
        TRANSFER_POSITION_ID, 
        TRANSFER_PERSONEL_BRANCH_NEW_ID, 
        TRANSFER_PERSONEL_POSITION_NEW_ID, 
        IS_FINISHED, 
        SEX, 
        LANGUAGE, 
        LANGUAGE_ID, 
        KNOWLEVEL_ID, 
        RELATED_FORMS, 
        PERSONEL_EMPLOYEE_ID, 
        PERSONAL_AGE_MIN, 
        PERSONAL_AGE_MAX 
    FROM 
        PERSONEL_REQUIREMENT_FORM 
    WHERE 
        PERSONEL_REQUIREMENT_ID 
    IN 
    	(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#" list="yes">)
</cfquery>
<cfloop query="get_per_req">
	<cfset attributes.id = get_per_req.personel_requirement_id>
	<cfif len(get_per_req.our_company_id) and len(get_per_req.branch_id) and len(get_per_req.department_id)>
		<cfquery name="get_department_info" datasource="#dsn#">
			SELECT 
				OUR_COMPANY.NICK_NAME,
				BRANCH.BRANCH_NAME,
				DEPARTMENT.DEPARTMENT_HEAD
			FROM 
				OUR_COMPANY,
				BRANCH,
				DEPARTMENT
			WHERE 
				OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID AND
				BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
				OUR_COMPANY.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.our_company_id#"> AND
				BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.branch_id#"> AND
				DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.department_id#">
		</cfquery>
	</cfif>
	<cfset app_position = "">
	<cfif len(get_per_req.position_id)>
		<cfquery name="get_position_name" datasource="#dsn#">
			SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.position_id#">
		</cfquery>
		<cfset app_position = "#get_position_name.position_name#">
	</cfif>
	<cfset position_cat = "">
	<cfif len(get_per_req.position_cat_id)>
		<cfset attributes.position_cat_id = get_per_req.position_cat_id>
		<cfinclude template="../query/get_position_cat.cfm">
		<cfset position_cat = "#get_position_cat.position_cat#">
	</cfif>
	<table width="700" height="35" align="center" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td style="height:20mm;">
				<cfif len(get_per_req.our_company_id)>
					<cfquery name="get_our_company" datasource="#dsn#">
						SELECT ASSET_FILE_NAME2, ASSET_FILE_NAME2_SERVER_ID FROM OUR_COMPANY WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.our_company_id#">
					</cfquery>
					<cfif Len(get_our_company.asset_file_name2)>
						<!--- <cfinclude template="../../objects/display/view_company_logo.cfm"> --->
						<cf_get_server_file output_file="settings/#get_our_company.asset_file_name2#" output_server="#get_our_company.asset_file_name2_server_id#" output_type="5" image_height="60">
					</cfif>
				</cfif>
			</td>
		</tr>
		<tr> 
			<td style="font-size:16px;" class="headbold" align="center"><cf_get_lang dictionary_id="31880.Personel Talep Formu"></td>
		</tr>
		<tr>
			<td height="30" class="formbold" style="text-align:right;"><cf_get_lang dictionary_id="30770.Talep No">: <cfoutput>#attributes.id#</cfoutput></td>
		</tr>
	</table>
	<table width="700" align="center" cellpadding="2" cellspacing="1" border="0" bgcolor="000000">
		<tr bgcolor="FFFFFF"> 
			<td>
			<cfoutput>
			<table width="100%" border="0">
				<tr>
					<td class="txtbold_" width="100"><cf_get_lang dictionary_id='57574.Şirket'> - <cf_get_lang dictionary_id='57453.Şube'> - <cf_get_lang dictionary_id='57572.Departman'></td>
					<td><cfif len(GET_PER_REQ.OUR_COMPANY_ID)>#get_department_info.nick_name#</cfif>
						<cfif isdefined('get_department_info.branch_name')>#get_department_info.branch_name#</cfif>
						<cfif isdefined('get_department_info.department_head')>#get_department_info.department_head#</cfif>
					</td>
				</tr>
				<tr>
					<td class="txtbold_"><cf_get_lang dictionary_id="55280.Birim ve Görev"></td>
					<td>#position_cat#</td>
				</tr>
				<tr>
					<td class="txtbold_"><cf_get_lang dictionary_id="55283.Talep Edilen Kişi Sayısı"></td>
					<td>#GET_PER_REQ.PERSONEL_COUNT#</td>
				</tr>
				<tr>
					<td class="txtbold_"><cf_get_lang dictionary_id="31023.Talep Tarihi"></td>
					<td>#dateformat(GET_PER_REQ.REQUIREMENT_DATE,dateformat_style)#</td>
				</tr>
				<cfif len(GET_PER_REQ.REQUIREMENT_EMP)>
					<cfset isim = '#get_emp_info(GET_PER_REQ.REQUIREMENT_EMP,0,0,0)#'>
				<cfelseif len(GET_PER_REQ.REQUIREMENT_PAR_ID)>
					<cfset isim = '#get_par_info(GET_PER_REQ.REQUIREMENT_PAR_ID,0,0,0)#'>
				<cfelseif len(GET_PER_REQ.REQUIREMENT_CONS_ID)>
					<cfset isim = '#get_cons_info(GET_PER_REQ.REQUIREMENT_CONS_ID,0,0)#'>
				<cfelse>
					<cfset isim = ''>
				</cfif>
				<cfif len(isim)>
					<tr>
						<td class="txtbold_"><cf_get_lang dictionary_id="31342.İstekte Bulunan"></td>
						<td>#isim#</td>
					</tr>
				</cfif>
				<tr>
					<td colspan="2"><hr noshade="noshade" /></td>
				</tr>
				<tr>
					<td colspan="2" class="formbold" height="30"><cf_get_lang dictionary_id="55297.TALEP EDİLEN KİŞİ ÖZELLİKLERİ"></td>
				</tr>
				<tr>
					<td class="txtbold_"><cf_get_lang dictionary_id="30237.Eğitim Durumu"></td>
					<td><cfloop query="GET_EDU_LEVEL">
							<cfif EDU_LEVEL_ID eq GET_PER_REQ.TRAINING_LEVEL>#GET_EDU_LEVEL.EDUCATION_NAME#,</cfif>
						</cfloop>					
					</td>
				</tr>
				<tr>
					<td class="txtbold_"><cf_get_lang dictionary_id="39531.Yaş Aralığı"></td>
					<td><!---#GET_PER_REQ.PERSONEL_AGE#--->#GET_PER_REQ.PERSONAL_AGE_MIN# - #GET_PER_REQ.PERSONAL_AGE_MAX#</td>
				</tr>
				<tr>
					<td class="txtbold_"><cf_get_lang dictionary_id="55309.Bu Alandaki İş Tecrübesi (Yıl)"></td>
					<td>#GET_PER_REQ.PERSONEL_EXP#</td>
				</tr>
				<tr>
					<td class="txtbold_"><cf_get_lang dictionary_id="31200.Ehliyet"></td>
					<td><cfquery name="DRIVERLICENCECATEGORIES" datasource="#dsn#">
							SELECT 
                            	LICENCECAT_ID, 
                                LICENCECAT, 
                                RECORD_EMP, 
                                RECORD_IP, 
                                RECORD_DATE, 
                                UPDATE_EMP, 
                                UPDATE_IP, 
                                UPDATE_DATE 
                            FROM 
                            	SETUP_DRIVERLICENCE 
                            ORDER BY 
                            	LICENCECAT
						</cfquery>
						<cfloop query="DRIVERLICENCECATEGORIES">
							<cfif len(GET_PER_REQ.LICENCECAT_ID) and listfindnocase(GET_PER_REQ.LICENCECAT_ID,LICENCECAT_ID)>#LICENCECAT#,</cfif>
						</cfloop>
					</td>
				</tr>
				<tr>
					<td class="txtbold_"><cf_get_lang dictionary_id="55335.Araç Talebi"></td>
					<td><cfif GET_PER_REQ.vehicle_req eq 1><cf_get_lang dictionary_id='58564.Var'><cfelse><cf_get_lang dictionary_id='58546.Yok'></cfif></td>
				</tr>
				<tr>
					<td class="txtbold_"><cf_get_lang dictionary_id='55605.Var ise Araç Modeli'></td>
					<td>#GET_PER_REQ.vehicle_req_model#</td>
				</tr>
				<tr>
					<td valign="top" class="txtbold_"><cf_get_lang dictionary_id='55344.Diğer Nitelikler'></td>
					<td>#GET_PER_REQ.PERSONEL_DETAIL#</td>
				</tr>
				<tr>
					<td class="txtbold_"><cf_get_lang dictionary_id='31622.İşe Başlama Tarihi'></td>
					<td><cfif len(GET_PER_REQ.PERSONEL_START_DATE)>#dateformat(GET_PER_REQ.PERSONEL_START_DATE,dateformat_style)#</cfif></td>
				</tr>
				<tr>
					<td colspan="2"><hr noshade="noshade" /></td>
				</tr>
				<tr>
					<td colspan="2" class="formbold" height="30"><cf_get_lang dictionary_id='55370.İHTİYAÇ GEREKÇELERİ'></td>
				</tr>
				<tr>
					<td colspan="2 class="txtbold_"">
						<cfif GET_PER_REQ.form_type eq 1><cf_get_lang dictionary_id="55433.Ayrılan Kişinin Yerine"></cfif>
						<cfif GET_PER_REQ.form_type eq 2><cf_get_lang dictionary_id="55574.Ek Kadro"></cfif>
						<cfif GET_PER_REQ.form_type eq 3><cf_get_lang dictionary_id="55451.Pozisyon Değişikliği Yapan Personelin Yerine"></cfif>
						<cfif GET_PER_REQ.form_type eq 4><cf_get_lang dictionary_id="55481.Nakil Olan Personelin Yerine"></cfif>
						<cfif GET_PER_REQ.form_type eq 5><cf_get_lang dictionary_id="55488.Emeklilik Nedeniyle Giriş / Çıkış Yapan Personelin Yerine"></cfif>
						<cfif GET_PER_REQ.form_type eq 6><cf_get_lang dictionary_id="55449.Ek Kadro Süreli"></cfif>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="formbold" height="30">
						<cfif not ListFind("3,4,6",GET_PER_REQ.form_type)>
							<cf_get_lang dictionary_id="55489.İlgili Pozisyondaki Çalışan Bilgileri">
						<cfelseif ListFind("3",GET_PER_REQ.form_type)>
							<cf_get_lang dictionary_id="55519.Pozisyon Değişikliği Yapan Personelin">
						<cfelseif ListFind("4",GET_PER_REQ.form_type)>
							<cf_get_lang dictionary_id="55524.Nakil Olan Personelin">
						<cfelse>
							<cf_get_lang dictionary_id="55536.Belirli Süreli Çalışan ise">
						</cfif>
					</td>
				</tr>
				<cfif not ListFind("3,4,6",GET_PER_REQ.form_type)>
					<tr>
						<td class="txtbold_"><cf_get_lang dictionary_id="36902.Ayrılan Kişi Ad Soyad / Görev"></td>
						<td><cfif GET_PER_REQ.form_type neq 2>#GET_PER_REQ.old_personel_name# - #GET_PER_REQ.old_personel_position#</cfif>
						</td>
					</tr>
					<tr>
						<td class="txtbold_"><cf_get_lang dictionary_id="31530.Ayrılma Nedeni"></td>
						<td><cfif GET_PER_REQ.form_type neq 2>
							<cfif listlen(GET_PER_REQ.old_personel_detail) and listfindnocase(GET_PER_REQ.old_personel_detail,'İstifa')><cf_get_lang dictionary_id="55508.İstifa"></cfif>
							<cfif listlen(GET_PER_REQ.old_personel_detail) and listfindnocase(GET_PER_REQ.old_personel_detail,'Fesih')><cf_get_lang dictionary_id="55509.Fesih"></cfif>
							<cfif listlen(GET_PER_REQ.old_personel_detail) and listfindnocase(GET_PER_REQ.old_personel_detail,'Nakil')><cf_get_lang dictionary_id="40516.Nakil"></cfif>
							<cfif listlen(GET_PER_REQ.old_personel_detail) and listfindnocase(GET_PER_REQ.old_personel_detail,'Diğer')><cf_get_lang dictionary_id="58156.Diğer"> : </cfif>
							<cfif listlen(GET_PER_REQ.old_personel_detail) and listfindnocase(GET_PER_REQ.old_personel_detail,'Diğer') and listlen(GET_PER_REQ.old_personel_detail) eq 2>#listgetat(GET_PER_REQ.old_personel_detail,2)#</cfif>
							</cfif>
						</td>
					</tr>
					<tr>
						<td class="txtbold_"><cf_get_lang dictionary_id="55517.İşten Ayrılma Tarihi"></td>
						<td><cfif GET_PER_REQ.form_type neq 2 and len(GET_PER_REQ.old_personel_finishdate)>#dateformat(GET_PER_REQ.old_personel_finishdate,dateformat_style)#</cfif>
						</td>
					</tr>
				<cfelseif GET_PER_REQ.form_type eq 3>
					<tr>
						<td class="txtbold_"><cf_get_lang dictionary_id="55522.Ad Soyad / Görev"></td>
						<td>#GET_PER_REQ.change_personel_name# - #GET_PER_REQ.change_personel_position#</td>
					</tr>
					<tr>
						<td class="txtbold_"><cf_get_lang dictionary_id="55523.Yeni Pozisyon"></td>
						<td>#GET_PER_REQ.change_personel_position_new#</td>
					</tr>
					<tr>
						<td class="txtbold_"><cf_get_lang dictionary_id="32655.Onay Tarihi"></td>
						<td><cfif len(GET_PER_REQ.change_personel_finishdate)>#dateformat(GET_PER_REQ.change_personel_finishdate,dateformat_style)#</cfif></td>
					</tr>
				<cfelseif GET_PER_REQ.form_type eq 6>
					<tr>
						<td class="txtbold_"><cf_get_lang dictionary_id="55538.Çalışma Başlangıç"></td>
						<td><cfif len(GET_PER_REQ.work_start)>#dateformat(GET_PER_REQ.work_start,dateformat_style)#</cfif></td>
					</tr>
					<tr>
						<td class="txtbold_"><cf_get_lang dictionary_id="55555.Çalışma Bitiş"></td>
						<td><cfif len(GET_PER_REQ.work_finish)>#dateformat(GET_PER_REQ.work_finish,dateformat_style)#</cfif>
						</td>
					</tr>
				<cfelse>
					<tr>
						<td class="txtbold_"><cf_get_lang dictionary_id="55522.Ad Soyad / Görev"></td>
						<td><cfif GET_PER_REQ.form_type neq 2>#GET_PER_REQ.transfer_personel_name# - #GET_PER_REQ.transfer_personel_position#</cfif></td>
					</tr>
					<tr>
						<td class="txtbold_"><cf_get_lang dictionary_id="55525.Yeni Şubesi / Pozisyon"></td>
						<td><cfif GET_PER_REQ.form_type neq 2>#GET_PER_REQ.transfer_personel_branch_new# / #GET_PER_REQ.transfer_personel_position_new#</cfif></td>
					</tr>
					<tr>
						<td class="txtbold_"><cf_get_lang dictionary_id="32655.Onay Tarihi"></td>
						<td><cfif GET_PER_REQ.form_type neq 2>
								<cfif len(GET_PER_REQ.change_personel_finishdate)>
									#dateformat(GET_PER_REQ.change_personel_finishdate,dateformat_style)#
								</cfif>
							</cfif>
						</td>
					</tr>
				</cfif>
				<tr>
					<td colspan="2"><hr noshade="noshade" /></td>
				</tr>
				<cfquery name="Get_Relation_Asset" datasource="#dsn#">
					SELECT
						A.ASSET_FILE_NAME,
						A.ASSET_ID,
						A.ASSETCAT_ID,
						A.ASSET_NAME,
						ASSET_CAT.ASSETCAT_PATH
					FROM
						ASSET A,
						CONTENT_PROPERTY CP,
						ASSET_CAT
					WHERE
						A.ASSETCAT_ID = ASSET_CAT.ASSETCAT_ID AND
						A.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="PER_REQ_ID"> AND
						A.ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> AND
						A.PROPERTY_ID = CP.CONTENT_PROPERTY_ID AND
						(A.IS_IMAGE = 0 OR A.IS_IMAGE IS NULL) AND
						(
							A.IS_SPECIAL = 0 OR A.IS_SPECIAL IS NULL OR
							(A.IS_SPECIAL = 1 AND (A.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#"> OR A.UPDATE_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">))
						)
					ORDER BY 
						A.ASSET_NAME
				</cfquery>
				<cfif Get_Relation_Asset.RecordCount>
					<tr class="formbold">
						<td colspan="2"><cf_get_lang dictionary_id="34134.İLİŞKİLİ BELGELER"></td>
					</tr>
					<cfloop query="Get_Relation_Asset">
						<tr>
							<td colspan="2"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_download_file&file_name=#assetcat_path#/#asset_file_name#&asset_id=#asset_id#&assetcat_id=#assetcat_id#','list');">#Get_Relation_Asset.Asset_Name#</a></td>						
						</tr>
					</cfloop>
					<tr>
						<td colspan="2"><hr noshade="noshade" /></td>
					</tr>
				</cfif>
				<tr>
					<td colspan="2" class="formbold" height="30"><cf_get_lang dictionary_id="55571.GÖRÜŞ VE ONAY"></td>
				</tr>
				<cfquery name="Get_Notes" datasource="#dsn#">
					SELECT 
    	                ACTION_SECTION, 
                        ACTION_ID, 
                        NOTE_BODY, 
                        RECORD_DATE, 
                        RECORD_IP, 
                        RECORD_EMP, 
                        UPDATE_DATE, 
                        UPDATE_IP, 
                        UPDATE_EMP, 
                        COMPANY_ID, 
                        IS_SPECIAL
                    FROM 
	                    NOTES 
                    WHERE 
                        ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="PER_REQ_ID"> AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GET_PER_REQ.PERSONEL_REQUIREMENT_ID#"> 
                    ORDER BY 
                    	RECORD_DATE DESC
				</cfquery>
				<tr valign="top">
					<td colspan="2" style="font-size:9px;">
						<cfloop query="Get_Notes">
							#NOTE_BODY#&nbsp;
							(#get_emp_info(Get_Notes.record_emp,0,0)# - #DateFormat(Get_Notes.record_date,'dd.mm.yyyy')# #TimeFormat(DateAdd('h',session.ep.time_zone,Get_Notes.record_date),timeformat_style)#)
							<BR /><BR />
						</cfloop>
					</td>
				</tr>
				<tr>
					<td colspan="2" class="formbold" height="30"><hr noshade="noshade" /></td>
				</tr>
			</table>
			<br/>
			<table>
				<cfset url_link_ = "index.cfm?fuseaction=hr.from_upd_personel_requirement_form&per_req_id=#attributes.id#">
				<cfquery name="Get_Warnings" datasource="#dsn#">
					SELECT RECORD_EMP,RECORD_IP,RECORD_DATE,WARNING_HEAD FROM PAGE_WARNINGS WHERE URL_LINK LIKE '%#url_link_#%' GROUP BY RECORD_EMP,RECORD_IP,RECORD_DATE,WARNING_HEAD ORDER BY RECORD_DATE
				</cfquery>
				<tr valign="top">
					<cfloop query="Get_Warnings">
					<td style="font-size:10px;" width="150" valign="top">
						#Record_Ip#<br />
						#DateFormat(Record_Date,'dd.mm.yyyy')#<br />
						<font class="txtbold_">#ListLast(Warning_Head,'-')#</font><br />
						<font class="txtbold_">(#get_emp_info(Record_Emp,0,0)#)</font><br />
						<cfif ListLast(Warning_Head,'-') contains 'Red'>
							<cf_get_lang dictionary_id="36917.Elektronik Olarak"> <br /><cf_get_lang dictionary_id="36906.Reddedilmiştir">.
						<cfelse>
							<cf_get_lang dictionary_id="36917.Elektronik Olarak"> <br /><cf_get_lang dictionary_id="36904.Onaylanmıştır">.
						</cfif>
					</td>
					</cfloop>
				</tr>
			</table>
			</cfoutput>
			<br />
			<br />
			<br />
			<br />
			<table width="100%">
				<tr>
					<td align="center"><cf_get_lang dictionary_id="36903.İnsan Kaynakları Müdürlüğü"></td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
	<cfif get_per_req.currentrow neq get_per_req.recordcount>
		<div style="page-break-after: always"></div>
	</cfif>
</cfloop>
