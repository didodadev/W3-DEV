<cfif not isdefined("session.cp.userid")>
	<cflocation url="#request.self#?fuseaction=objects2.kariyer_login" addtoken="no">
</cfif>
<cfset attributes.empapp_id = session.cp.userid>
<cfset empapp_id = session.cp.userid>

<cfinclude template="../query/get_id_card_cats.cfm">
<cfinclude template="../query/get_country.cfm">
<cfinclude template="../query/get_city.cfm">
<cfinclude template="../query/get_empapp.cfm">
<cfinclude template="../query/get_app_identy.cfm">
<cfquery name="GET_APP_WORK" datasource="#DSN#">
	SELECT
		EXP_START,
		EXP,
		EXP_TASK_ID,
		EXP_FINISH,
		EXP_SALARY,
		EXP_MONEY_TYPE,
		EXP_TELCODE,
		EXP_TEL,
		EXP_EXTRA_SALARY,
		EXP_EXTRA,
		EXP_REASON
	FROM
		EMPLOYEES_APP_WORK_INFO
	WHERE
		<cfif isdefined("session.cp.userid") and len(session.cp.userid)>
			 EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
		<cfelse>
			 1=0
		</cfif>
</cfquery>

<cfquery name="GET_EMP_REFERENCES" datasource="#DSN#">
	SELECT
		REFERENCE_NAME,
		REFERENCE_COMPANY,
		REFERENCE_POSITION,
		REFERENCE_TELCODE,
		REFERENCE_TEL,
		REFERENCE_EMAIL
	FROM
		EMPLOYEES_REFERENCE
	WHERE
		EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
	ORDER BY
		REFERENCE_ID ASC
</cfquery>

<cfquery name="GET_TEACHER_DETAIL" datasource="#DSN#">
	SELECT 
		COMPUTER_EDUCATION,
		SALARY_RANGE
	FROM 
		EMPLOYEES_APP_TEACHER_INFO 
	WHERE 
		<cfif isdefined("session.cp.userid") and len(session.cp.userid)>
			EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
		<cfelse>
			1=0
		</cfif>
</cfquery>
<cfquery name="GET_BRANCHES" datasource="#DSN#">
	SELECT BRANCHES_ID FROM SETUP_APP_BRANCHES
</cfquery>
<cfquery name="GET_ADD_INFO" datasource="#DSN#">
	SELECT 
		SPP.BRANCHES_ID
	FROM 
		EMPLOYEES_APP_INFO EP,
		SETUP_APP_BRANCHES_ROWS SPP
	WHERE 
		EP.BRANCHES_ROW_ID = SPP.BRANCHES_ROW_ID AND
		<cfif isdefined("session.cp.userid") and len(session.cp.userid)>
			EP.EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
		<cfelse>
			1=0
		</cfif>
</cfquery>
<cfquery name="GET_APP_EDU_UNIV" datasource="#DSN#">
	SELECT
		EDU_NAME,
		EDU_TYPE,
		EDU_START,
		EDU_FINISH,
		EDU_RANK,
		EDU_PART_NAME
	FROM
		EMPLOYEES_APP_EDU_INFO
	WHERE
		<cfif isdefined("session.cp.userid") and len(session.cp.userid)>
			EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#"> AND
			EDU_TYPE IN (4,5,6)
		<cfelse>
			1=0
		</cfif>
</cfquery>
<cfquery name="GET_APP_EDU_LISE" datasource="#DSN#" maxrows="1">
	SELECT
		EDU_NAME,
		EDU_TYPE,
		EDU_START,
		EDU_FINISH,
		EDU_RANK,
		EDU_PART_NAME
	FROM
		EMPLOYEES_APP_EDU_INFO
	WHERE
		<cfif isdefined("session.cp.userid") and len(session.cp.userid)>
			 EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#"> AND
			 EDU_TYPE = 3
		<cfelse>
			 1=0
		</cfif>
	ORDER BY EDU_START DESC
</cfquery>
<div class="main_tree">
	<h1 style="color:#f6921e;">Cv Önizleme</h1>
    <table width="100%">
        <tr>
            <td style="text-align:right;"> <cf_workcube_file_action pdf='1' mail='0' doc='0' print='1' tag_module='area_#this_row_id_#'> </td>
        </tr>
    </table>
    <div class="curriculum_cv">
        <table cellpadding="1" cellspacing="1" width="100%">
            <tr height="30" bgcolor="#E7E7E7">
                <td colspan="2" class="txtbold"><cfoutput>#get_app.name#</cfoutput> <cfoutput>#get_app.surname#</cfoutput></td>
            </tr>
            <tr>
                <td valign="top" width="600">
                    <table cellpadding="5" cellspacing="5">
                        <tr>
                            <td class="txtbold" width="128">Adres Bilgileri</td><td>: 
                            <cfoutput>#get_app.homeaddress#&nbsp;#get_app.homepostcode#</cfoutput>
							<cfif len(get_app.homecounty)>
                                <cfquery name="GET_COUNTY" datasource="#DSN#">
                                    SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.homecounty#">
                                </cfquery>
                                <cfoutput>#get_county.county_name#</cfoutput>
                            </cfif>
                            <cfif len(get_app.homecity)>
                                <cfquery name="GET_HOMECITY" dbtype="query">
                                    SELECT CITY_NAME FROM GET_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.homecity#">
                                </cfquery>
                                <cfoutput>#get_homecity.city_name#</cfoutput>
                            </cfif>
                            <cfoutput query="get_country">
                                <cfif get_app.homecountry eq get_country.country_id>#get_country.country_name#</cfif>
                            </cfoutput>
                            </td>
                        </tr>
                        <tr>
                            <td class="txtbold">Cep Telefonu</td><td>: <cfoutput>#trim(get_app.mobilcode)# #trim(get_app.mobil)#</cfoutput></td>
                        </tr>
                         <tr>
                            <td class="txtbold">E-Mail</td><td>: <cfoutput>#get_app.email#</cfoutput></td>
                        </tr>
                    </table>
                </td>
                <td><cfif len(get_app.photo)><div class="curriculum_cv_imaj"><img src="<cfoutput>#file_web_path#hr/#get_app.photo#</cfoutput>" width="80" alt="<cf_get_lang no='207.Fotoğraf'>" title="<cf_get_lang no='207.Fotoğraf'>" /></div></cfif></td>
            </tr>
            <tr height="20" bgcolor="#E7E7E7">
                <td colspan="2" class="txtbold">Kişisel Bilgiler</td>
            </tr>
            <tr>
            	<td valign="top" width="600">
                    <table cellpadding="5" cellspacing="5">
                    	<tr>
                            <td class="txtbold"><cf_get_lang_main no='1315.Doğum Tarihiniz'></td><td  width="150">: <cfif len(get_app_identy.birth_date)><cfoutput>#dateformat(get_app_identy.birth_date,'dd/mm/yyyy')#</cfoutput></cfif></td>
                            <td class="txtbold"><cf_get_lang_main no='378.Doğum Yeriniz'></td><td>: <cfoutput>#get_app_identy.birth_place#</cfoutput></td>
                        </tr>
                        <tr>
                            <td class="txtbold"><cf_get_lang no='306.Sigara Kullanıyor musunuz'>?</td><td  width="150">: <cfif get_app.use_cigarette eq 1><cf_get_lang_main no='83.Evet'><cfelse><cf_get_lang_main no='84.Hayır'></cfif></td>
                            <td class="txtbold"><cf_get_lang_main no='352.Cinsiyetiniz'></td><td>: <cfif get_app.sex eq 1 or not len(get_app.sex)><cf_get_lang_main no='1547.Erkek'><cfelseif get_app.sex eq 0><cf_get_lang_main no='1546.Kadin'></cfif></td>
                        </tr>
                        <tr>
                            <td class="txtbold"><cf_get_lang no='819.Fiziksel Engeliniz Var mı'>?</td><td>: <cfif get_app.defected eq 1><cf_get_lang_main no='83.Evet'>  %<cfoutput>#get_app.defected_level#</cfoutput><cfelse><cf_get_lang_main no='84.Hayır'></cfif></td>
                            <td class="txtbold"><cf_get_lang no='310.Ehliyet Tipi /Yıl'></td><td>: 
								<cfif len(get_app.licencecat_id)>
                                    <cfquery name="GET_DRIVER_LIS" datasource="#DSN#">
                                        SELECT LICENCECAT FROM SETUP_DRIVERLICENCE WHERE LICENCECAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_app.licencecat_id#"> ORDER BY LICENCECAT
                                    </cfquery>
                                    <cfoutput>#get_driver_lis.licencecat#</cfoutput>
                                </cfif>
                                <cfoutput>/ #DateFormat(get_app.licence_start_date,'dd/mm/yyyy')#</cfoutput>
                            </td>
                        </tr>
                        <cfif get_app.sex eq 1 or not len(get_app.sex)>
                            <tr>
                                <td class="txtbold"><cf_get_lang no='820.Askerlik Durumunuz'></td>
                                <td nowrap>: 
                                    <cfif get_app.military_status eq 0>
                                        <cf_get_lang no='319.Yapmadı'>&nbsp;
                                    <cfelseif get_app.military_status eq 1>
                                        <cf_get_lang no='320.Yaptı'>
                                        <cfif get_app.military_rank eq 0 or not len(get_app.military_rank)> - Er<cfelseif get_app.military_rank eq 1> - <cf_get_lang no='824.Yedek Subay'></cfif>
                                        &nbsp;
                                    <cfelseif get_app.military_status eq 2>
                                        <cf_get_lang no='321.Muaf'>
                                    <cfelseif get_app.military_status eq 3>
                                        <cf_get_lang no='322.Yabancı'>
                                    <cfelseif get_app.military_status eq 4>
                                        <cf_get_lang no='323.Tecilli'>
                                    </cfif>
                                </td>
                                <td colspan="2" nowrap="nowrap">
									<cfif get_app.military_status eq 1>
                                        <table id="Yapti">
                                            <tr>
                                                <td nowrap="nowrap"><cf_get_lang no='326.Terhis Tarihi'>
                                                : <cfif len(get_app.military_finishdate)><cfoutput>#dateformat(get_app.military_finishdate,'dd/mm/yyyy')#</cfoutput></cfif><br />
                                                <cf_get_lang_main no='1716.Süre'> (<cf_get_lang no='823.Ay Olarak Giriniz'>)
                                                : <cfoutput>#get_app.military_month#</cfoutput></td>
                                            </tr>
                                        </table>
                                    </cfif>
                                    <cfif get_app.military_status eq 2>
                                        <table id="Muaf">
                                            <tr>
                                                <td class="txtbold"><cf_get_lang no='327.Muaf Olma Nedeniniz'> *</td>
                                                <td>: <cfoutput>#get_app.military_exempt_detail#</cfoutput></td>
                                            </tr>
                                        </table>
                                    </cfif>
                                    <cfif get_app.military_status eq 4>
                                        <table id="Tecilli">
                                            <tr>
                                                <td class="txtbold"><cf_get_lang no='324.Tecil Gerekçeniz'></td>
                                                <td>: <cfoutput>#get_app.military_delay_reason#</cfoutput></td>
                                            </tr>
                                            <tr>
                                                <td class="txtbold"><cf_get_lang no='325.Tecil Süreniz'></td>
                                                <td>: <cfif len(get_app.military_delay_date)><cfoutput>#dateformat(get_app.military_delay_date,'dd/mm/yyyy')#</cfoutput></cfif></td>
                                            </tr>
                                        </table>
                                    </cfif>	
                            	</td>
                            </tr>
                        </cfif>
                    </table>
                </td>
            </tr>
            <tr height="20" bgcolor="#E7E7E7">
               <td colspan="2" class="txtbold">Eğitim Bilgileri</td>
            </tr>
            <tr>
            	<td valign="top" width="600">
                	<cfinclude template="../query/get_edu_level.cfm">
                    <cfinclude template="../query/get_know_levels.cfm">
                    <cfinclude template="../query/get_school.cfm">
                    <cfinclude template="../query/get_school_part.cfm">
                    <cfinclude template="../query/get_high_school_part.cfm">
                    <cfinclude template="../query/get_languages.cfm">
                    <cfinclude template="../query/get_empapp.cfm">
                	<table cellpadding="5" cellspacing="5">
                    	<tr>
                        	<td width="125" class="txtbold"><cf_get_lang no='834.Eğitim Seviyeniz'> </td>
                            <td>:
                            	<cfoutput query="get_edu_level">
									<cfif edu_level_id eq get_app.training_level>#education_name#</cfif>
                                </cfoutput>
                            </td>
                        </tr>
                        <tr>
                        	<td colspan="2">
                            	<table class="form_table">
                                	<thead>
                                        <tr>
                                            <th></th>
                                            <th class="txtbold"><cf_get_lang no='520.Okul Adı'></th>
                                            <th class="txtbold"><cf_get_lang no='838.Gir Yılı'></th>
                                            <th class="txtbold"><cf_get_lang no='839.Mez Yılı'></th>
                                            <th class="txtbold"><cf_get_lang no='836.Not Ort'>.</th>
                                            <th class="txtbold"><cf_get_lang_main no="583.Bölüm"></th>
                                        </tr>
                                    </thead>
                                    <cfoutput query="get_app_edu_univ">
                                        <tr>
                                            <td class="txtbold"><cfif get_app_edu_univ.edu_type eq 4><cf_get_lang_main no='1958.Üniversite'><cfelseif get_app_edu_univ.edu_type eq 5><cf_get_lang no='526.Yükseklisans'><cfelseif get_app_edu_univ.edu_type eq 6><cf_get_lang no='840.Doktora'></cfif></td>
                                            <td>#get_app_edu_univ.edu_name#</td>
                                            <td>#get_app_edu_univ.edu_start#</td>
                                            <td>#get_app_edu_univ.edu_finish#</td>
                                            <td>#get_app_edu_univ.edu_rank#</td>
                                            <td>#get_app_edu_univ.edu_part_name#</td>
                                        </tr>
                                    </cfoutput>
                                    <cfoutput>
                                        <tr height="20">
                                            <td class="txtbold"><cf_get_lang no='524.Lise'></td>
                                            <td>#get_app_edu_lise.edu_name#</td>
                                            <td><cfif len(get_app_edu_lise.edu_start)>#get_app_edu_lise.edu_start#<cfelse>-</cfif></td>
                                            <td><cfif len(get_app_edu_lise.edu_finish)>#get_app_edu_lise.edu_finish#<cfelse>-</cfif></td>
                                            <td>#get_app_edu_lise.edu_rank#</td>
                                            <td>#get_app_edu_lise.edu_part_name#</td>
                                        </tr>
                                    </cfoutput>
                            		<cfquery name="GET_APP_LANG" datasource="#DSN#">
                                    	SELECT
                                            ID,
                                            LANG_ID,
                                            LANG_SPEAK,
                                            LANG_MEAN,
                                            LANG_WRITE,
                                            LANG_WHERE
                                         FROM
                                            EMPLOYEES_APP_LANGUAGE
                                        WHERE
                                            EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
                                    </cfquery>
                                    <tr height="25">
                                        <td class="txtbold" align="left"><cf_get_lang no='841.Yabancı Dil'></td>
                                        <td class="txtbold"><cf_get_lang_main no='1584.Dil'></td>
                                        <td class="txtbold"><cf_get_lang no='842.Konuşma'></td>
                                        <td class="txtbold"><cf_get_lang no='843.Anlama'></td>
                                        <td class="txtbold"><cf_get_lang no='844.Yazma'></td>
                                        <td class="txtbold"><cf_get_lang no='845.Öğrenildiği Yer'></td>
                                    </tr>
                                    <cfloop query="get_app_lang">
										<tr>
                                            <td></td>
                                            <td><cfoutput query="get_languages">
                                                    <cfif get_languages.language_id eq get_app_lang.lang_id>#language_set#</cfif>
                                                </cfoutput>
                                            </td>
                                            <td><cfoutput query="know_levels">
                                                    <cfif get_app_lang.lang_speak eq knowlevel_id>#knowlevel# </cfif>
                                                </cfoutput>
                                            </td>
                                            <td><cfoutput query="know_levels">
                                                    <cfif get_app_lang.lang_mean eq knowlevel_id>#knowlevel#</cfif>
                                                </cfoutput>
                                            </td>
                                            <td><cfoutput query="know_levels">
                                                    <cfif get_app_lang.lang_write eq knowlevel_id>#knowlevel#</cfif>
                                                </cfoutput>
                                            </td>
                                            <td><cfoutput>#get_app_lang.lang_where#</cfoutput></td>
                                        </tr>
                            		</cfloop>
                                    <cfif len(get_app.kurs1) or len(get_app.kurs2) or len(get_app.kurs3)>
                                        <tr height="25">
                                            <td class="txtbold"><cf_get_lang no ='1152.Kurs ve Seminer'></td>
                                            <td class="txtbold"><cf_get_lang_main no='68.Konu'></td>
                                            <td class="txtbold"><cf_get_lang_main no='1043.Yıl'></td>
                                            <td class="txtbold"><cf_get_lang_main no='78.Gün'></td>
                                            <td class="txtbold" colspan="2"><cf_get_lang no='897.Yer'></td>
                                            <td></td>
                                        </tr>
                                    </cfif>
                                    <cfoutput>
                                        <cfif len(get_app.kurs1)>
                                        <tr>
                                            <td></td>
                                            <td>#get_app.kurs1#</td>
                                            <td>#dateformat(get_app.kurs1_yil,'yyyy')#</td>
                                            <td>#get_app.kurs1_gun#</td>
                                            <td colspan="2">#get_app.kurs1_yer#</td>
                                            <td></td>
                                        </tr>
                                        </cfif>
                                        <cfif len(get_app.kurs2)>
                                        <tr>
                                            <td></td>
                                            <td>#get_app.kurs2#</td>
                                            <td>#dateformat(get_app.kurs2_yil,'yyyy')#</td>
                                            <td>#get_app.kurs2_gun#</td>
                                            <td colspan="2">#get_app.kurs2_yer#</td>
                                            <td></td>
                                        </tr>
                                        </cfif>
                                        <cfif len(get_app.kurs3)>
                                        <tr>
                                            <td></td>
                                            <td>#get_app.kurs3#</td>
                                            <td>#dateformat(get_app.kurs3_yil,'yyyy')#</td>
                                            <td>#get_app.kurs3_gun#</td>
                                            <td colspan="2">#get_app.kurs3_yer#</td>
                                            <td></td>
                                        </tr>
                                        </cfif>
                                    </cfoutput>
                                </table>
                            </td>
                        </tr>
                        <cfif len(get_app.comp_exp) or (get_teacher_detail.recordcount and len(get_teacher_detail.computer_education))>
                            <tr>
                                <td class="txtbold"><cf_get_lang no='847.Bilgisayar Bilginiz'></td>
                                <td>:
                                    <cfif get_teacher_detail.recordcount and len(get_teacher_detail.computer_education)>
                                        <cfset computer_education_list = listsort(get_teacher_detail.computer_education,"numeric","ASC",",")>
                                        <cfset comp_edu_list=computer_education_list>
                                        <cfif listfind(computer_education_list,-1,',')>
                                            <cfset comp_edu_list=listdeleteat(comp_edu_list,listfindnocase(comp_edu_list,-1))>
                                        </cfif>
                                        <cfif len(comp_edu_list)>
                                            <cfquery name="GET_COMPUTER_INFO" datasource="#DSN#">
                                                SELECT COMPUTER_INFO_NAME FROM SETUP_COMPUTER_INFO WHERE COMPUTER_INFO_STATUS = 1 AND COMPUTER_INFO_ID IN (#comp_edu_list#)
                                            </cfquery>
                                            <cfoutput query="get_computer_info">
                                                #computer_info_name# <cfif currentrow neq get_computer_info.recordcount>,&nbsp;</cfif>
                                            </cfoutput>
                                        </cfif>
                                        <cfif listfind(computer_education_list,-1,',')><cfif len(comp_edu_list)>,</cfif><cfoutput>#get_app.comp_exp#</cfoutput></cfif>
                                    </cfif>
                                </td>
                            </tr>
                        </cfif>
                    </table>
                </td>
            </tr>
            <cfif get_add_info.recordcount>
                <tr height="20" bgcolor="#E7E7E7">
                   <td colspan="2" class="txtbold">Branş</td>
                </tr>
                <tr>
                    <td>
                        <table>
                            <cfoutput query="get_branches">	
                                <cfquery name="GET_ALL_BRANCHES" dbtype="query">
                                    SELECT * FROM GET_ADD_INFO WHERE BRANCHES_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_branches.branches_id#">
                                </cfquery>
                                <tr>
                                    <td  width="125" class="txtbold">#get_branches.branches_name#&nbsp;&nbsp;&nbsp;</td>
                                    <td>: <cfloop query="get_all_branches">
                                            #branches_name_row#<cfif get_all_branches.currentrow neq get_all_branches.recordcount>,&nbsp</cfif>
                                        </cfloop>
                                    </td>
                                </tr>
                            </cfoutput>
                        </table>
                    </td>
                </tr>
            </cfif>
            <cfif get_app_work.recordcount>
                <tr height="20" bgcolor="#E7E7E7">
                   <td  colspan="2" class="txtbold">İş Tecrübeleri</td>
                </tr>
                <tr>
                     <td>
                        <cfoutput query="get_app_work">
                            <table cellpadding="5" cellspacing="5" style="border-bottom:2px solid ##CCC;" width="100%">
                                <tr>
                                    <td width="125" class="txtbold">Deneyim</td>
                                    <td colspan="3">: #currentrow#</td>
                                </tr>
                                <tr>
                                    <td class="txtbold"><cf_get_lang_main no='162.Şirket'></td>
                                    <td width="150">: #exp#</td>
                                    <td width="80" class="txtbold"><cf_get_lang_main no='89.Başlangıç'></td>
                                    <td>: <cfif len(exp_start)>#dateformat(exp_start,'dd/mm/yyyy')#</cfif></td>
                                </tr>
                                <tr>
                                    <td class="txtbold"><cf_get_lang_main no='159.Ünvan'></td>
                                    <td>: 
                                        <cfif len(exp_task_id)>
                                            <cfquery name="GET_TASK" datasource="#DSN#">
                                                SELECT PARTNER_POSITION_ID,PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#exp_task_id#">
                                            </cfquery>
                                            #get_task.partner_position#
                                        </cfif>
                                    </td>
                                    <td class="txtbold"><cf_get_lang_main no='90.Bitiş'></td>
                                    <td>: <cfif len(exp_finish)>#dateformat(exp_finish,'dd/mm/yyyy')#</cfif></td>
                                </tr>
                                <cfif len(exp_salary) or (len(exp_telcode) and len(exp_tel))>
                                    <tr>
                                        <td class="txtbold"><cf_get_lang_main no='1173.Kod'> / <cf_get_lang_main no='87.Telefon'></td>
                                        <td>: #exp_telcode# #exp_tel#</td>
                                        <td class="txtbold"><cf_get_lang no='761.Ücret'> (<cf_get_lang no='907.Son Ayın Net Ücreti'>)</td>
                                        <td>: <cfif len(exp_salary)>#TLFormat(exp_salary)#</cfif> <cfif len(exp_money_type)>#exp_money_type#</cfif></td>
                                    </tr>
                                </cfif>
                                <cfif len(exp_extra_salary)>
                                    <tr>
                                        <td colspan="2" class="txtbold"><cf_get_lang no='763.Ek Ödemeler'></td>
                                        <td colspan="2">: #exp_extra_salary#</td>
                                    </tr>
                                </cfif>
                                <cfif len(exp_extra)>
                                    <tr>
                                        <td valign="top" width="120" class="txtbold"><cf_get_lang no='765.Görev Sorumluluk ve Ek Açıklamalar'></td>
                                        <td colspan="3">: #exp_extra#</td>
                                    </tr>
                                </cfif>
                                <tr>
                                    <td  valign="top" class="txtbold"><cf_get_lang no='766.Ayrılma Nedeni'></td>
                                    <td colspan="3">: #exp_reason#</td>
                                </tr>
                            </table>
                        </cfoutput>
                        <cfif get_emp_references.recordcount>
                            <table cellpadding="5" cellspacing="5">
                                <tr>
                                    <td class="txtbold"><cf_get_lang no='853.Hakkınızda Bilgi Edinebileceğimiz Kişiler'></td>
                                </tr>
                                <tr>
                                    <td>
                                        <table class="form_table">
                                            <thead>
                                                <tr>
                                                    <th>&nbsp;</th>
                                                    <th class="txtbold"><cf_get_lang_main no='158.Ad Soyad'></th>
                                                    <th class="txtbold"><cf_get_lang_main no='162.Şirket'></th>
                                                    <th class="txtbold"><cf_get_lang_main no='1085.Pozisyon'></th>
                                                    <th class="txtbold"><cf_get_lang_main no='87.Tel'></th>
                                                    <th class="txtbold"><cf_get_lang_main no='16.E posta'></th>
                                                </tr>
                                            </thead>
                                            <cfoutput query="get_emp_references">
                                                <tr>
                                                    <td>#currentrow#</td>
                                                    <td>#reference_name#</td>
                                                    <td>#reference_company#</td>
                                                    <td>#reference_position#</td>
                                                    <td>#reference_telcode# #reference_tel#</td>
                                                    <td>#reference_email#</td>
                                                </tr>
                                            </cfoutput>
                                         </table>
                                    </td>
                                </tr>
                            </table>
                        </cfif>
                        <cfif len(get_app.hobby) or len(get_app.club)>
                            <table cellpadding="5" cellspacing="5">
                                <tr>
                                    <td width="125" class="txtbold"><cf_get_lang no='857.Özel İlgi Alanlarınız'></td>
                                    <td>: <cfoutput>#get_app.hobby#</cfoutput></td>
                                </tr>
                                <tr>
                                    <td class="txtbold"><cf_get_lang no='858.Üye Olduğunuz Klüp Ve Dernekler'></td>
                                    <td>: <cfoutput>#get_app.club#</cfoutput></td>
                                </tr>
                                <cfquery name="GET_RELATIVES" datasource="#DSN#">
                                    SELECT NAME, SURNAME, RELATIVE_LEVEL FROM EMPLOYEES_RELATIVES WHERE EMPAPP_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#"> ORDER BY BIRTH_DATE, NAME, SURNAME, RELATIVE_LEVEL
                                </cfquery>
                                <cfif get_relatives.recordcount>
                                    <tr>
                                        <td class="txtbold" colspan="2"><cf_get_lang no='861.Aile Bilgileri'></td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <cfif get_relatives.recordcount>
                                                <table class="form_table" id="table_list">
                                                	<thead>
                                                        <tr class="txtbold">
                                                            <th width="120"><cf_get_lang_main no='219.Ad'></th>
                                                            <th width="120"><cf_get_lang_main no='1314.Soyad'></th>
                                                            <th><cf_get_lang no='794.Yakınlık Derecesi'></th>
                                                            <th width="15"></th>
                                                        </tr>
                                                    </thead>
                                                    <cfoutput query="get_relatives">
                                                        <tr>
                                                            <td>#get_relatives.name#</td>
                                                            <td>#get_relatives.surname#</td>
                                                            <td><cfif get_relatives.relative_level eq 1><cf_get_lang no='795.Babası'>
                                                                <cfelseif get_relatives.relative_level eq 2><cf_get_lang no='796.Annesi'>
                                                                <cfelseif get_relatives.relative_level eq 3><cf_get_lang no='797.Eşi'>
                                                                <cfelseif get_relatives.relative_level eq 4><cf_get_lang no='798.Oğlu'>
                                                                <cfelseif get_relatives.relative_level eq 5><cf_get_lang no='799.Kızı'>
                                                                <cfelseif get_relatives.relative_level eq 6><cf_get_lang no='800.Kardeşi'></cfif>
                                                            </td>
                                                            <td width="15"></td>
                                                        </tr>
                                                    </cfoutput>
                                                </table>
                                            </cfif>
                                        </td>
                                    </tr>
                                </cfif>
                             </table>
                         </cfif>
                     </td>
                </tr>
            </cfif>
            <cfquery name="GET_APP_UNIT" datasource="#DSN#"> 
                SELECT UNIT_ID,UNIT_ROW FROM EMPLOYEES_APP_UNIT WHERE EMPAPP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.cp.userid#">
            </cfquery>
            <cfquery name="GET_CV_UNIT" datasource="#DSN#">
                SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT WHERE IS_VIEW=1
            </cfquery>
            <cfif get_cv_unit.recordcount>
                <tr height="20" bgcolor="#E7E7E7">
                   <td  colspan="2" class="txtbold">Çalışmak İstenilen Birimler</td>
                </tr>
                <tr>
                	<td>
                    	<table cellpadding="5" cellspacing="5">
                        	<tr>
                            	<td width="125" class="txtbold">Çalışmak İstenilen Birimler</td>
                                <td colspan="4">:
                                	<cfset liste = valuelist(get_app_unit.unit_id)>
									<cfset liste_row = valuelist(get_app_unit.unit_row)>					
                                    <cfoutput query="get_cv_unit">
                                        <cfif listfind(liste,get_cv_unit.unit_id,',')>
                                            <table>
                                                <tr>
                                                    <td>#listgetat(liste_row,listfind(liste,get_cv_unit.unit_id,','),',')# -</td>
                                                    <td style="width:120px;">#get_cv_unit.unit_name#</td>
                                                </tr>
                                            </table>
                                        </cfif>
                                    </cfoutput>
                                </td>
                            </tr>
                            <tr>
								<cfif len(get_app.preference_branch)>
                                     <td colspan="4" class="txtbold"><cf_get_lang no='866.Çalışmak İstediği Şube'></td>
                                </cfif>
                            </tr>
                            <cfif len(get_app.preference_branch)>
								<cfset branch_list= listsort(listdeleteduplicates(valuelist(get_app.preference_branch,',')),'numeric','ASC',',')>
                            </cfif>
                            <tr>
                            	<cfif len(get_app.preference_branch)>
                                    <td colspan="4">
                                        <table>
                                            <cfquery name="GET_BRANCH" datasource="#DSN#">
                                                SELECT 
                                                    BRANCH_ID,
                                                    BRANCH_NAME,
                                                    BRANCH_CITY
                                                FROM 
                                                    BRANCH
                                                WHERE
                                                    IS_INTERNET = 1 AND
                                                    BRANCH_ID IN (#branch_list#)
                                            </cfquery>
                                            <cfoutput query="get_branch">
                                                <tr>
                                                    <td>#branch_name# - #branch_city#</td>
                                                </tr>
                                            </cfoutput>
                                        </table>
                                    </td>
                                </cfif>
                            </tr>
                            <tr>
                            	<td  class="txtbold"><cf_get_lang no='875.Seyahat Edebilir misiniz'></td>
                                <td width="150">: <cfif get_app.is_trip is 1 or get_app.is_trip is ""> <cf_get_lang_main no='83.Evet'>
									  <cfelseif get_app.IS_TRIP is 0><cf_get_lang_main no='84.Hayır'></cfif>	
                                </td>
                                <td class="txtbold"><cf_get_lang no='753.İstenilen Ücret'> (<cf_get_lang_main no='671.Net'>)</td>
                                <td>:
                                    <cfif len(get_teacher_detail.salary_range)>
                                        <cfif get_teacher_detail.salary_range eq 1>250
                                        <cfelseif get_teacher_detail.salary_range eq 2>250-500
                                        <cfelseif get_teacher_detail.salary_range eq 3>500-1000
                                        <cfelseif get_teacher_detail.salary_range eq 4>1000-1500
                                        <cfelseif get_teacher_detail.salary_range eq 5>1500-2000
                                        <cfelseif get_teacher_detail.salary_range eq 6>2000-2500
                                        <cfelseif get_teacher_detail.salary_range eq 7>2500-3000
                                        <cfelseif get_teacher_detail.salary_range eq 8>3000-3500
                                        <cfelseif get_teacher_detail.salary_range eq 9>3500-4000
                                        <cfelseif get_teacher_detail.salary_range eq 10>4000-4500
                                        <cfelseif get_teacher_detail.salary_range eq 11>4500-5000
                                        <cfelseif get_teacher_detail.salary_range eq 12>5000-5500
                                        <cfelseif get_teacher_detail.salary_range eq 13>5500-6000
                                        <cfelseif get_teacher_detail.salary_range eq 14>6000-6500
                                        <cfelseif get_teacher_detail.salary_range eq 15>6500-7000
                                        <cfelseif get_teacher_detail.salary_range eq 16>7000-7500
                                        <cfelseif get_teacher_detail.salary_range eq 17>7500-8000
                                        <cfelseif get_teacher_detail.salary_range eq 18>8000-8500
                                        <cfelseif get_teacher_detail.salary_range eq 19>8500-9000
                                        <cfelseif get_teacher_detail.salary_range eq 20>9000-9500
                                        <cfelseif get_teacher_detail.salary_range eq 21>9500-10000
                                        </cfif><cfoutput>#session_base.money#</cfoutput>
                                    <cfelse>
                                        <cfif len(get_app.expected_price)><cfoutput>#TLFormat(get_app.expected_price)# #get_app.expected_money_type#</cfoutput></cfif>
                                    </cfif>		 	
                                </td>
                             </tr>
                            <cfif len(get_app.applicant_notes)>
                                 <tr>
                                    <td class="txtbold"><cf_get_lang no='870.Eklemek İstedikleriniz'></td>
                                    <td colspan="3">: <cfoutput>#get_app.applicant_notes#</cfoutput></td>
                                 </tr>
                             </cfif>
                         </table>
                    </td>
                </tr>
            </cfif>
        </table>
    </div>
    <br />
    <div style="text-align:right;">
    	<cfif isdefined('attributes.is_fast_cv') and attributes.is_fast_cv eq 1>
            <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.form_upd_cv_1" class="trubuttonaktif" style="color:#FFF;">Özgeçmişinizi Güncellemek için tıklayınız</a>
        </cfif>
    </div>
</div>
