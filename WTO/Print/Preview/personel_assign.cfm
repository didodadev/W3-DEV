<cfsetting showdebugoutput="no">
<!--- Personel Atama Formu --->
<style>
	table,td{font-size:13px;}
	.txtbold_{font-weight: bold;}
</style>
<cfquery name="get_edu_level" datasource="#DSN#">
	SELECT EDU_LEVEL_ID, EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL ORDER BY EDU_LEVEL_ID
</cfquery>
<cfquery name="get_per_req" datasource="#dsn#">
	SELECT 
    	PERSONEL_ASSIGN_ID, 
        PERSONEL_ASSIGN_HEAD, 
        PERSONEL_ASSIGN_DETAIL, 
        PERSONEL_NAME, 
        PERSONEL_SURNAME, 
        PERSONEL_TC_IDENTY_NO, 
        BIRTH_DATE, 
        SEX, 
        MILITARY_STATUS, 
        MILITARY_DETAIL, 
        TRAINING_LEVEL, 
        PERSONEL_ATTEMPT, 
        LICENCECAT_ID, 
        RELATIVE_STATUS, 
        RELATIVE_DETAIL, 
        WORK_START, 
        WORK_FINISH, 
        OUR_COMPANY_ID, 
        DEPARTMENT_ID, 
        BRANCH_ID, 
        OLD_OUR_COMPANY_ID, 
        OLD_DEPARTMENT_ID, 
        OLD_BRANCH_ID, 
        POSITION_CAT_ID, 
        OLD_POSITION_ID, 
        OLD_POSITION_NAME, 
        OLD_WORK_START, 
        OLD_WORK_FINISH, 
        OLD_FINISH_DETAIL, 
        ASSIGN_PROPERTIES, 
        SALARY,
        SALARY_MONEY, 
        RECORD_EMP, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_EMP, 
        UPDATE_DATE, 
        UPDATE_IP, 
        PER_ASSIGN_STAGE,
        PERSONEL_REQ_ID, 
        OLD_SALARY,
        OLD_SALARY_MONEY, 
        IS_FINISHED, 
        ASSIGN_NUMBER, 
        RELATED_CV_BANK_ID, 
        IS_PSYCHOTECHNICS 
    FROM 
    	PERSONEL_ASSIGN_FORM 
    WHERE 
	    PERSONEL_ASSIGN_ID 
   	IN 
    	(<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#" list="yes">)
</cfquery>
<cfloop query="get_per_req">
	<cfset attributes.id = get_per_req.personel_assign_id>
	<cfif Len(get_per_req.personel_req_id)>
		<cfquery name="get_relation_requirement" datasource="#dsn#">
			SELECT PERSONEL_REQUIREMENT_HEAD FROM PERSONEL_REQUIREMENT_FORM WHERE PERSONEL_REQUIREMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.personel_req_id#">
		</cfquery>
	</cfif>
	<cfif len(get_per_req.our_company_id) and len(get_per_req.branch_id) and len(get_per_req.department_id)>
		<cfquery name="get_dep" datasource="#dsn#">
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
	
	<cfif len(get_per_req.old_our_company_id) and len(get_per_req.old_branch_id) and len(get_per_req.old_department_id)>
		<cfquery name="get_old_dep" datasource="#dsn#">
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
				OUR_COMPANY.COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.old_our_company_id#"> AND
				BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.old_branch_id#"> AND
				DEPARTMENT.DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.old_department_id#">
		</cfquery>
	</cfif>
	<cfset app_position = "">
	<cfif len(get_per_req.old_position_id)>
		<cfquery name="get_position_name" datasource="#dsn#">
			SELECT POSITION_NAME FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_per_req.old_position_id#">
		</cfquery>
		<cfset app_position = "#get_position_name.position_name#">
	</cfif>
	<cfset position_cat = "">
	<cfif len(get_per_req.position_cat_id)>
		<cfset attributes.position_cat_id = get_per_req.position_cat_id>
		<cfinclude template="../../../V16/hr/query/get_position_cat.cfm">
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
			<td style="font-size:16px;" class="headbold" align="center"><cf_get_lang dictionary_id="56872.Atama Formu"></td>
		</tr>
		<tr>
			<td height="30">
			<table width="100%">
				<cfoutput>
					<tr class="formbold">
						<cfif Len(get_per_req.personel_req_id) and get_relation_requirement.recordcount><td><cf_get_lang dictionary_id="56873.Personel Talebi"> : #get_per_req.personel_req_id#</td></cfif><!--- get_relation_requirement.personel_requirement_head --->
						<td style="text-align:right"><cf_get_lang dictionary_id="36920.Atama No"> : #attributes.id#</td>
					</tr>
				</cfoutput>
			</table>
			</td>
		</tr>
	</table>
	<table width="700" align="center" cellpadding="2" cellspacing="1" border="0" bgcolor="000000">
		<tr bgcolor="#FFFFFF"> 
		<td>
		<cfoutput>
		<table width="100%" border="0">
			<tr>
				<td width="200" class="txtbold_"><cf_get_lang dictionary_id="57570.Ad Soyad"></td>
				<td>#get_per_req.personel_name#	#get_per_req.personel_surname#</td>
			</tr>
			<tr>
				<td class="txtbold_"><cf_get_lang dictionary_id="58025.TC Kimlik No"> *</td>
				<td>#get_per_req.personel_tc_identy_no#</td>
			</tr>
			<tr>
				<td class="txtbold_"><cf_get_lang dictionary_id="57574.Şirket"> - <cf_get_lang dictionary_id='57453.Şube'> - <cf_get_lang dictionary_id='57572.Departman'> *</td>
				<td><cfif len(get_per_req.OUR_COMPANY_ID)>#get_dep.nick_name#</cfif> -
					<cfif isdefined('get_dep.branch_name')>#get_dep.branch_name#</cfif> -
					<cfif isdefined('get_dep.department_head')>#get_dep.department_head#</cfif>
				</td>
			</tr>
			<tr>
				<td class="txtbold_"><cf_get_lang dictionary_id="55280.Birim ve Görev"> *</td>
				<td>#position_cat#</td>
			</tr>
			<tr>
				<td colspan="2"><hr noshade="noshade"></td>
			</tr>
			<tr>
				<td colspan="2" class="formbold" height="30"><cf_get_lang dictionary_id="56874.KİŞİ ÖZELLİKLERİ"></td>
			</tr>
			<tr>
				<td class="txtbold_"><cf_get_lang dictionary_id="58727.Doğum Tarihi"></td>
				<td><cfif len(get_per_req.birth_date)>#dateformat(get_per_req.birth_date,dateformat_style)#</cfif></td>
			</tr>
			<tr>
				<td class="txtbold_"><cf_get_lang dictionary_id="57764.Cinsiyet"></td>
				<td><cfif get_per_req.sex eq 0><cf_get_lang dictionary_id="58958.Kadın"><cfelse><cf_get_lang dictionary_id="58959.Erkek"></cfif></td>
			</tr>
			<tr>
				<td class="txtbold_"><cf_get_lang dictionary_id="44311.Askerlik Durumu"></td>
				<td><cfif get_per_req.military_status eq 0><cf_get_lang dictionary_id='55624.Yapmadı'></cfif>
					<cfif get_per_req.military_status eq 1><cf_get_lang dictionary_id='55625.Yaptı'></cfif>
					<cfif get_per_req.military_status eq 2><cf_get_lang dictionary_id='55626.Muaf'></cfif>
					<cfif get_per_req.military_status eq 3><cf_get_lang dictionary_id='55627.Yabancı'></cfif>
					<cfif get_per_req.military_status eq 4><cf_get_lang dictionary_id='55340.Tecilli'></cfif>
					<font class="txtbold_"><cf_get_lang dictionary_id="57629.Açıklama"> : </font>#get_per_req.military_detail#
				</td>
			</tr>
			<tr>
				<td class="txtbold_"><cf_get_lang dictionary_id="30237.Eğitim Durumu"></td>
				<td><cfloop query="GET_EDU_LEVEL">
						<cfif EDU_LEVEL_ID eq get_per_req.TRAINING_LEVEL>#GET_EDU_LEVEL.EDUCATION_NAME#</cfif>
					</cfloop>
				</td>
			</tr>
			<tr>
				<td class="txtbold_"><cf_get_lang dictionary_id="55309.Bu Alandaki İş Tecrübesi (Yıl)"></td>
				<td>#get_per_req.PERSONEL_ATTEMPT#</td>
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
						<cfif len(get_per_req.LICENCECAT_ID) and listfindnocase(get_per_req.LICENCECAT_ID,LICENCECAT_ID)>#LICENCECAT#,</cfif>
					</cfloop>
				</td>
			</tr>
			<tr>
				<td class="txtbold_"><cf_get_lang dictionary_id="55764.Aynı Depoda Çalışan Yakını Var mı">?</td>
				<td><cfif get_per_req.relative_status eq 0><cf_get_lang dictionary_id="57496.Hayır"></cfif>
					<cfif get_per_req.relative_status eq 1><cf_get_lang dictionary_id="57495.Evet"></cfif>
					&nbsp;&nbsp;
					<font class="txtbold_"><cf_get_lang dictionary_id="55766.Var İse Yakınlığı"> :</font> #get_per_req.relative_detail#
				</td>
			</tr>
			<tr>
				<td colspan="2"><hr noshade="noshade"></td>
			</tr>
			<tr>
				<td colspan="2" class="formbold" height="30"><cf_get_lang dictionary_id="55771.Belirsiz Süreli Çalışan ise"></td>
			</tr>
			<tr>
				<td class="txtbold_"><cf_get_lang dictionary_id="55538.Çalışma Başlangıç"></td>
				<td><cfif len(get_per_req.work_start)>
						#dateformat(get_per_req.work_start,dateformat_style)#
					</cfif>	
				</td>
			</tr>
			<tr>
				<td class="txtbold_"><cf_get_lang dictionary_id="55555.Çalışma Bitiş"></td>
				<td><cfif len(get_per_req.work_finish)>
						#dateformat(get_per_req.work_finish,dateformat_style)#
					</cfif>
				</td>
			</tr>
			<tr>
				<td colspan="2"><hr noshade="noshade"></td>
			</tr>
			<tr>
				<td colspan="2" class="formbold" height="30"><cf_get_lang dictionary_id="55772.NAKİL YOLUYLA ATAMA YAPILIYORSA VEYA ESKİ ÇALIŞANIMIZSA SON İŞYERİNE AİT"></td>
			</tr>
			<tr>
				<td class="txtbold_"><cf_get_lang dictionary_id="57574.Şirket"> - <cf_get_lang dictionary_id='57453.Şube'> - <cf_get_lang dictionary_id='57572.Departman'>*</td>
				<td><cfif len(get_per_req.old_OUR_COMPANY_ID)>#get_old_dep.nick_name#</cfif>
					-
					<cfif isdefined('get_old_dep.branch_name')>#get_old_dep.branch_name#</cfif>
					-
					<cfif isdefined('get_old_dep.department_head')>#get_old_dep.department_head#</cfif>
				</td>
			</tr>
			<tr>
				<td class="txtbold_"><cf_get_lang dictionary_id="32332.Görev"></td>
				<td>#get_per_req.old_position_name#</td>
			</tr>
			<tr>
				<td class="txtbold_"><cf_get_lang dictionary_id="31530.Ayrılma Nedeni"></td>
				<td><cfif listlen(get_per_req.old_finish_detail) and listfindnocase(get_per_req.old_finish_detail,'İstifa')><cf_get_lang dictionary_id="55508.İstifa"></cfif>
					<cfif listlen(get_per_req.old_finish_detail) and listfindnocase(get_per_req.old_finish_detail,'Fesih')><cf_get_lang dictionary_id="55509.Fesih"></cfif>
					<cfif listlen(get_per_req.old_finish_detail) and listfindnocase(get_per_req.old_finish_detail,'Nakil')><cf_get_lang dictionary_id="55510.Nakil"></cfif>
					<cfif listlen(get_per_req.old_finish_detail) and listfindnocase(get_per_req.old_finish_detail,'Diğer')><cf_get_lang dictionary_id="58156.Diğer"> : </cfif>
					<cfif listlen(get_per_req.old_finish_detail) and listfindnocase(get_per_req.old_finish_detail,'Diğer') and listlen(get_per_req.old_finish_detail) eq 2>#listgetat(get_per_req.old_finish_detail,2)#</cfif>
				</td>
			</tr>
			<tr>
				<td class="txtbold_"><cf_get_lang dictionary_id="55538.Çalışma Başlangıç"></td>
				<td><cfif len(get_per_req.old_work_start)>
						#dateformat(get_per_req.old_work_start,dateformat_style)#
					</cfif>	
				</td>
			</tr>
			<tr>
			<td class="txtbold_"><cf_get_lang dictionary_id="55555.Çalışma Bitiş"></td>
			<td><cfif len(get_per_req.old_work_finish)>#dateformat(get_per_req.old_work_finish,dateformat_style)#</cfif></td>
			</tr>
			<tr>
				<td class="txtbold_"><cf_get_lang dictionary_id="55774.Brüt Ücret"></td>
				<td>#tlformat(get_per_req.salary)# #get_per_req.salary_money#</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>
				<table border="0">
					<tr>
						<cfset Assign_Property_List = "Cep Tel Hattı,İkramiye,Otomobil,Prim,Performans Primi,Giysi Yardımı,Jestiyon,Öğle Yemeği,Servis,Yakacak Yardımı,Ticket">
						<cfloop list="#Assign_Property_List#" index="apl">
							<td><cfoutput><input type="checkbox" value="#apl#" name="assign_properties" id="assign_properties" disabled="disabled" <cfif listlen(get_per_req.assign_properties) and listfindnocase(get_per_req.assign_properties,apl)>checked</cfif>>#apl#</cfoutput></td>
							<cfif ListFind(Assign_Property_List,apl) mod 4 eq 0></tr></cfif>
						</cfloop>
						<!--- <img src="/images/ok_list.gif">,<img src="/images/ok_list_empty.gif" /> --->
				</table>
				</td>
			</tr>
			<tr>
				<td colspan="2"><hr noshade="noshade"></td>
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
					A.ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="PER_ASSIGN_ID"> AND
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
                    ACTION_SECTION = <cfqueryparam cfsqltype="cf_sql_varchar" value="PER_ASSIGN_ID"> AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#"> 
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
				<td colspan="2" class="formbold" height="20"><hr noshade="noshade" /></td>
			</tr>
		</table>
		<br/>
		<table>
			<cfset url_link_ = "index.cfm?fuseaction=hr.from_upd_personel_assign_form&per_assign_id=#attributes.id#">
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
		<br /><br /><br /><br />
		<table width="100%">
			<tr>
				<td align="center"><cf_get_lang dictionary_id="36903.İnsan Kaynakları Müdürlüğü"></td>
			</tr>
		</table>
	</table>
	<cfif get_per_req.currentrow neq get_per_req.recordcount>
		<div style="page-break-after: always"></div>
	</cfif>
</cfloop>
