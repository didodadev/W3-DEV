<cf_get_lang_set module_name="hr"><!--- sayfanin en altinda kapanisi var --->
<cfsetting showdebugoutput="no">
<cfset d4=0>
<cfset d3=0>
<cfset d2=0>
<cfset d1=0>
<cfset attributes.employee_id=attributes.iid>
<cfquery name="GET_EMPLOYEE" datasource="#dsn#">
	SELECT 
		EMPLOYEES.EMPLOYEE_NO,
		EMPLOYEES.EMPLOYEE_NAME, 
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES.PHOTO,
		EMPLOYEES.EMPLOYEE_EMAIL,
		EMPLOYEES_DETAIL.LAST_SCHOOL,
		EMPLOYEES_IDENTY.BIRTH_DATE,
		EMPLOYEES_IDENTY.BIRTH_PLACE,
		EMPLOYEES_DETAIL.STARTDATE,
		EMPLOYEES_DETAIL.COMP_EXP,
		EMPLOYEES_DETAIL.MILITARY_FINISHDATE,
		EMPLOYEES_DETAIL.MILITARY_DELAY_REASON,
		EMPLOYEES_DETAIL.MILITARY_DELAY_DATE,
		EMPLOYEES_DETAIL.MILITARY_STATUS,
		EMPLOYEES_DETAIL.PARTNER_POSITION,
		EMPLOYEES_DETAIL.HOMEADDRESS,
		EMPLOYEES_DETAIL.HOMETEL,
		EMPLOYEES_DETAIL.HOMETEL_CODE,
		EMPLOYEES.MOBILCODE,
		EMPLOYEES.MOBILTEL,
		EMPLOYEES_DETAIL.HOMEPOSTCODE,
		EMPLOYEES_DETAIL.HOMECOUNTY,
		EMPLOYEES.GROUP_STARTDATE,
		EMPLOYEES_DETAIL.CHILD_0,
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES_DETAIL.KURS1,
		EMPLOYEES_DETAIL.KURS1_YIL,
		EMPLOYEES_DETAIL.KURS1_YER,
		EMPLOYEES_DETAIL.KURS1_GUN,
		EMPLOYEES_DETAIL.KURS2,
		EMPLOYEES_DETAIL.KURS2_YIL,
		EMPLOYEES_DETAIL.KURS2_YER,
		EMPLOYEES_DETAIL.KURS2_GUN,
		EMPLOYEES_DETAIL.KURS3,
		EMPLOYEES_DETAIL.KURS3_YIL,
		EMPLOYEES_DETAIL.KURS3_YER,
		EMPLOYEES_DETAIL.KURS3_GUN,
		EMPLOYEES_DETAIL.HOMECITY,
		EMPLOYEES_DETAIL.HOMECOUNTRY,
		EMPLOYEES_DETAIL.DEFECTED_LEVEL,
		EMPLOYEES_DETAIL.DEFECTED,
		EMPLOYEES_DETAIL.SEX,
	    EMPLOYEES_IDENTY.MARRIED
	FROM 
		EMPLOYEES, 
		EMPLOYEES_DETAIL,
		EMPLOYEES_IDENTY
	WHERE 
		EMPLOYEES.EMPLOYEE_ID =#attributes.employee_id# AND 
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_DETAIL.EMPLOYEE_ID AND
		EMPLOYEES_IDENTY.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID 
</cfquery>
<cfquery name="get_employee_driver_info" datasource="#DSN#">
	SELECT
		SETUP_DRIVERLICENCE.LICENCECAT
	FROM
		EMPLOYEE_DRIVERLICENCE_ROWS,
		SETUP_DRIVERLICENCE
	WHERE
		EMPLOYEE_DRIVERLICENCE_ROWS.EMPLOYEE_ID = #attributes.employee_id# AND
		SETUP_DRIVERLICENCE.LICENCECAT_ID = EMPLOYEE_DRIVERLICENCE_ROWS.LICENCECAT_ID
</cfquery>
<cfquery name="get_work_info" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_APP_WORK_INFO WHERE EMPLOYEE_ID = #attributes.employee_id# ORDER BY EXP_START
</cfquery>
<cfquery name="get_emp_course" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_COURSE WHERE EMPLOYEE_ID= #attributes.employee_id#
</cfquery>
<cfquery name="get_edu_info" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_APP_EDU_INFO WHERE EMPLOYEE_ID = #attributes.employee_id#  ORDER BY EDU_TYPE
</cfquery>
<cfset okul=valuelist(get_edu_info.edu_type,',')>
<cfquery name="get_position" datasource="#dsn#">
	SELECT 
		EMPLOYEE_POSITIONS.POSITION_NAME,
		EMPLOYEE_POSITIONS.TITLE_ID,
		DEPARTMENT.DEPARTMENT_HEAD,
		BRANCH.BRANCH_NAME,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.ASSET_FILE_NAME3_SERVER_ID
	FROM
		EMPLOYEE_POSITIONS,
		DEPARTMENT,
		BRANCH,
		OUR_COMPANY
	WHERE
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = #attributes.employee_id# AND
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND 
		BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID 
</cfquery>
<br/>
<cfif GET_EMPLOYEE.recordcount>
	<cfoutput>
        <table cellSpacing="0" cellpadding="0" border="0" width="700" align="center">
            <tr>
                <td>
                    <table cellspacing="1" cellpadding="2" border="0" width="98%">
                        <tr bgcolor="##FFFFFF">
                            <td height="20" colspan="6"></td>
                        </tr>
                        <tr bgcolor="##CCCCCC">
                            <td colspan="7" height="20"><strong><font color="##000066"><cf_get_lang no="780.Kişisel Bilgileri"></font></strong></td>
                        </tr>
                        
                        <tr bgcolor="##FFFFFF">
                            <td width="150"><b><cf_get_lang no='672.Adı Soyadı'>:</b></td>
                            <td width="270" valign="top">#get_employee.employee_name#&nbsp;#get_employee.employee_surname#</td>
                            <td rowspan="11" valign="top">
                            <cfif len(get_employee.photo)>
                            <!--- <img src="#file_web_path#hr/#get_employee.photo#" border="0" width="120" height="160" align="center"> --->
                            <cf_get_server_file output_file="hr/#get_employee.photo#" output_server="#get_position.asset_file_name3_server_id#" image_width="150" image_height="150" output_type="5"> 
                            </cfif>
                            </td>
                        </tr>
                        <tr bgcolor="##FFFFFF">
                            <td width="150"><b><cf_get_lang_main no='1085.Pozisyon'>:</b></td>
                            <td width="270"><cfloop query="get_position">#get_position.position_name#,</cfloop></td>
                        </tr>
                        <tr bgcolor="##FFFFFF">
                            <td width="150"><b><cf_get_lang_main no='162.Şirket'>:</b></td>
                            <td width="270">#get_position.company_name#</td>
                        </tr>
                        <tr bgcolor="##FFFFFF">
                            <td width="150" valign="top"><b><cf_get_lang_main no='1311.Adresi'>:</b></td>
                            <td width="270">#get_employee.homeaddress#&nbsp;#get_employee.homepostcode#&nbsp;#get_employee.homecounty#&nbsp;
                            <cfif len(get_employee.homecity)>
                                <cfquery name="city" datasource="#dsn#">
                                    SELECT 
                                        CITY_NAME
                                    FROM 
                                        SETUP_CITY
                                    WHERE 
                                        SETUP_CITY.CITY_ID = #get_employee.homecity#
                                </cfquery>
                                #city.city_name#
                            </cfif>&nbsp;
                            <cfif len(get_employee.homecountry)>
                                <cfquery name="country" datasource="#dsn#">
                                    SELECT 
                                        COUNTRY_NAME
                                    FROM
                                        SETUP_COUNTRY
                                    WHERE 
                                        SETUP_COUNTRY.COUNTRY_ID = #get_employee.homecountry# 
                                </cfquery>
                                #country.country_name#
                            </cfif>
                            </td>
                        </tr>
                        <tr>
                            <td width="150"><b><cf_get_lang_main no='1402.Ev Telefonu'>:</b></td>
                            <td width="270">#get_employee.hometel_code#&nbsp;#get_employee.hometel#</td>
                        </tr>
                        <tr>
                            <td width="150"><b><cf_get_lang_main no='1401.Cep Telefonu'>:</b></td>
                            <td width="270">#get_employee.mobilcode#&nbsp;#get_employee.mobiltel#</td>
                        </tr>
                        <tr>
                            <td width="150"><b><cf_get_lang no="399.E Mail">:</b></td>
                            <td width="270">#get_employee.EMPLOYEE_EMAIL#&nbsp;</td>
                        </tr> 
                        <tr bgcolor="##FFFFFF">
                            <td width="150"><b><cf_get_lang_main no='1315.Doğum Tarihi'>/<cf_get_lang_main no='1252.Yeri'>:</b></td>
                            <td width="270">#dateformat(get_employee.birth_date,dateformat_style)# - #get_employee.birth_place#</td>
                        </tr>
                        <cfif get_employee.sex eq 1>
                        <tr bgcolor="##FFFFFF">
                            <td width="150"><b><cf_get_lang no='1460.Askerlik Durumu'>:</b></td>
                            <td width="270">
                            <cfif get_employee.military_status eq 1> 
                            <cf_get_lang_main no='1374.Tamamlandı'> <cfif len(get_employee.military_finishdate)>#dateformat(get_employee.military_finishdate,dateformat_style)#
                            </cfif>
                            <cfelseif get_employee.military_status eq 2>
                            <cf_get_lang no='541.Muaf'>  
                            <cfelseif get_employee.military_status eq 3>
                            <cf_get_lang no='542.Yabancı'>
                            <cfelseif get_employee.military_status eq 4>
                            <cf_get_lang no='255.Tecilli'> #get_employee.military_delay_reason# <cfif len(get_employee.military_delay_date)>#dateformat(get_employee.military_delay_date,dateformat_style)#</cfif>
                            <cfelseif get_employee.military_status eq 0>
                            <cf_get_lang no='539.Yapmadı'>
                            </cfif>					</td>
                        </tr>
                        </cfif>
                        <tr bgcolor="##FFFFFF">
                            <td width="150"><b><cf_get_lang no='1440.Medeni Hali'>:</b></td>
                            <td width="270"><cfif get_employee.married eq 1><cf_get_lang no='658.evli'><cfelse><cf_get_lang no='659.bekar'></cfif></td>
                        </tr>
                        <tr bgcolor="##FFFFFF">
                            <td width="150"><b><cf_get_lang no='249.Ehliyet'> <cf_get_lang no='169.Sınıfı'>:</b></td>
                            <td width="270"> #get_employee_driver_info.LICENCECAT# </td>
                        </tr>
                        <tr bgcolor="##FFFFFF">
                            <td width="150">&nbsp;</td>
                            <td width="270">&nbsp;</td>
                        </tr>
                    </table>
                </td>	
            </tr>
            <tr>
                <td colspan="4" width="98%">
                    <table cellpadding="1" cellspacing="2" border="0" width="98%">
                        <tr bgcolor="CCCCCC">
                            <cfif len(get_employee.last_school)>
                                <cfquery name="get_education" datasource="#dsn#">
                                    SELECT 
                                        EDUCATION_NAME,EDU_LEVEL_ID
                                    FROM 
                                        SETUP_EDUCATION_LEVEL
                                    WHERE 
                                        SETUP_EDUCATION_LEVEL.EDU_LEVEL_ID = #get_employee.last_school#
                                </cfquery>
                            </cfif>
                            <td colspan="6" height="20"><strong><font color="##000066"><cf_get_lang no='654.Eğitim Bilgileri'></font> &nbsp;&nbsp;[<cf_get_lang no='410.Eğitim Durumu'> : <cfif len(get_employee.last_school) and get_education.recordcount and len(get_education.education_name)>#get_education.education_name#</cfif>]</strong></td>
                        </tr>
                        <tr bgcolor="##FFFFFF">
                            <td style="width:75px;"><b><cf_get_lang no ='1396.Okul Türü'></b></td>
                            <td style="width:250px;"><b><cf_get_lang no ='1397.Okul Adı'></b></td>
                            <td style="width:65px;"><b><cf_get_lang no ='1398.Başl Yılı'></b></td>
                            <td style="width:65px;"><b><cf_get_lang no ='1399.Bitiş Yılı'></b></td>
                            <td style="width:65px;"><b><cf_get_lang no ='1068.Not Ort'></b></td>
                            <td style="width:250px;"><b><cf_get_lang_main no='583.Bölüm'></b></td>
                        </tr>
                        <cfloop query="get_edu_info">
                            <tr bgcolor="FFFFFF">
                                <td>
                                    <cfset edu_type_id_control = "">
                                    <cfif len(edu_type)>
                                        <cfquery name="get_education_level_name" datasource="#dsn#">
                                            SELECT EDU_LEVEL_ID,EDUCATION_NAME,EDU_TYPE FROM SETUP_EDUCATION_LEVEL WHERE EDU_LEVEL_ID =#edu_type#
                                        </cfquery>
                                        #get_education_level_name.education_name#
                                        <cfset edu_type_id_control = get_education_level_name.EDU_TYPE>								
                                    </cfif>	
                                </td>	
                                <td>
                                    <cfif len(edu_id) and edu_id neq -1>
                                        <cfquery name="get_unv_name" datasource="#dsn#">
                                            SELECT SCHOOL_ID, SCHOOL_NAME FROM SETUP_SCHOOL WHERE SCHOOL_ID = #edu_id#
                                        </cfquery>
                                        #get_unv_name.SCHOOL_NAME#
                                    <cfelse>
                                        #edu_name#
                                    </cfif>
                                </td>	
                                <td>#edu_start#</td>		
                                <td>#edu_finish#</td>		
                                <td>#edu_rank#</td>		
                                <td>
                                    <cfif (len(edu_part_id) and edu_part_id neq -1)>
                                        <cfif edu_type_id_control eq 1><!--- edu_type lise ise--->
                                            <cfquery name="get_high_school_part_name" datasource="#dsn#">
                                                SELECT HIGH_PART_ID, HIGH_PART_NAME FROM SETUP_HIGH_SCHOOL_PART WHERE HIGH_PART_ID = #edu_part_id#
                                            </cfquery>
                                            #get_high_school_part_name.HIGH_PART_NAME#
                                        <cfelseif listfind('2',edu_type_id_control)> <!--- üniversite ise--->
                                            <cfquery name="get_school_part_name" datasource="#dsn#">
                                                SELECT PART_ID, PART_NAME FROM SETUP_SCHOOL_PART WHERE PART_ID = #edu_part_id#
                                            </cfquery>
                                            #get_school_part_name.PART_NAME#
                                        </cfif>
                                    <cfelseif len(edu_part_name)>
                                        #edu_part_name#
                                    </cfif>
                                </td>		
                            </tr>
                        </cfloop>
                        <tr>
                            <td colspan="7">&nbsp;</td>
                        </tr>
                        <tr>
                            <td width="150"><b><cf_get_lang no="787.Yabancı Diller"></b></td>
                            <td width="135"><b><cf_get_lang no='1073.Konuşma'></b>
                                <cfif get_edu_info.recordcount>
                                    <cfquery name="get_univ_2" dbtype="query">
                                        SELECT * FROM get_edu_info WHERE EDU_TYPE = 4
                                    </cfquery>
                                </cfif>
                            </td>
                            <td><b><cf_get_lang no='1074.Anlama'></b></td>
                            <td><b><cf_get_lang no='1075.Yazma'></b></td>
                            <td colspan="2"><b><cf_get_lang no='1076.Öğrenildiği Yer'></b></td>
                            <cfif get_edu_info.recordcount and get_univ_2.recordcount and get_univ_2.recordcount gt 1><td>&nbsp;</td></cfif>
                        </tr>
                        <cfquery name="get_lang" datasource="#dsn#">
                            SELECT 
                                SL.LANGUAGE_SET,
                                (SELECT KNOWLEVEL FROM SETUP_KNOWLEVEL WHERE KNOWLEVEL_ID=EL.LANG_MEAN) AS LANG_MEAN,
                                (SELECT KNOWLEVEL FROM SETUP_KNOWLEVEL WHERE KNOWLEVEL_ID=EL.LANG_SPEAK) AS LANG_SPEAK,
                                 EL.LANG_WHERE,
                                (SELECT KNOWLEVEL FROM SETUP_KNOWLEVEL WHERE KNOWLEVEL_ID=EL.LANG_WRITE) AS LANG_WRITE
                            FROM 
                                EMPLOYEES_APP_LANGUAGE EL INNER JOIN SETUP_LANGUAGES SL
                                ON EL.LANG_ID = SL.LANGUAGE_ID
                            WHERE 
                                EL.EMPLOYEE_ID = #attributes.employee_id#				
                        </cfquery>
                        <cfloop query="get_lang">
                            <tr>
                                <td>#LANGUAGE_SET#</td>
                                <td>#LANG_SPEAK#</td>
                                <td>#LANG_MEAN#</td>
                                <td>#LANG_WRITE#</td>
                                <td colspan="2">#LANG_WHERE#</td>
                            </tr>
                        </cfloop>
                        <tr>
                            <td colspan="7">&nbsp;</td>
                        </tr>
                        <tr>
                            <td width="150"><b><cf_get_lang no="777.Bilgisayar Bilgileri"></b></td>
                            <td colspan="4">#get_employee.COMP_EXP#</td>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td width="150">&nbsp;</td>
                            <td colspan="4">&nbsp;</td>
                            <td>&nbsp;</td>
                        </tr>
                        <cfloop query="get_work_info">
                            <cfif len(get_work_info.EXP_START) and len(get_work_info.EXP_FINISH)><cfset d1=d1 + DATEDIFF('y',dateformat(get_work_info.EXP_START,'yyyy'),dateformat(get_work_info.EXP_FINISH,'yyyy'))></cfif>
                        </cfloop>
                        <tr bgcolor="##CCCCCC">
                            <td colspan="6" height="20"><strong><font color="##000066"><cf_get_lang no="1530.Deneyimler"> &nbsp;&nbsp;[<cf_get_lang no="781.Toplam Çalışma Süresi">:#d1#]</font></strong></td>
                        </tr>
                        <tr bgcolor="##FFFFFF">
                            <td><b><cf_get_lang_main no="300.Kurum"> <cf_get_lang_main no="485.Adı"></b></td>
                            <td><b><cf_get_lang_main no='243.Başlama Tarihi'></b></td>
                            <td colspan="2"><b><cf_get_lang no='432.Ayrılış Tarihi'></b></td>
                            <td colspan="2"><b><cf_get_lang_main no='159.Ünvan'></b></td>
                        </tr>
                        <cfloop query="get_work_info">
                            <tr>
                                <td>#get_work_info.EXP#</td>
                                <td><cfif len(get_work_info.EXP_START)>#dateformat(get_work_info.EXP_START,dateformat_style)#</cfif></td>
                                <td colspan="2"><cfif len(get_work_info.EXP_FINISH)>#dateformat(get_work_info.EXP_FINISH,dateformat_style)#</cfif></td>
                                <td><cfif len(get_work_info.EXP_POSITION)>#get_work_info.EXP_POSITION#</cfif></td>
                            </tr>
                        </cfloop>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="4" width="98%">
                    <table cellpadding="1" cellspacing="2" width="98%" border="0">
                        <tr bgcolor="##CCCCCC">
                            <td colspan="5" height="20"><strong><font color="##000066"><cf_get_lang no="782.Katıldığı Kurs ve Seminer"></font></strong></td>
                        </tr>
                        <tr>
                            <td width="300"><strong><cf_get_lang no="783.Eğitim Konusu"></strong></td>
                            <td width="100"><strong><cf_get_lang_main no='1043.Yıl'></strong></td>
                            <td width="100"><strong><cf_get_lang_main no='1252.Yer'></strong></td>
                            <td width="100"><strong><cf_get_lang_main no='78.Gün'></strong></td>
                        </tr>
                        <cfloop query="get_emp_course">
                        <tr>
                            <td>#course_subject#</td>
                            <td>#dateformat(course_year,'yyyy')#</td>
                            <td>#course_location#</td>
                            <td>#course_period#</td>
                        </tr>
                        </cfloop>
                    </table>
                </td>
            </tr>
            <cfquery name="get_workgroup" datasource="#dsn#">
                SELECT 
                    WG.WORKGROUP_NAME,
                    WEP.ROLE_HEAD
                FROM 
                    WORK_GROUP WG,
                    WORKGROUP_EMP_PAR WEP
                WHERE 
                    WG.WORKGROUP_ID = WEP.WORKGROUP_ID AND
                    WEP.EMPLOYEE_ID = #attributes.employee_id# 	
            </cfquery>
            <tr>
                <td colspan="4" width="98%">
                    <table cellpadding="1" cellspacing="2" width="98%" border="0">
                        <tr bgcolor="##CCCCCC">
                            <td colspan="5" height="20"><strong><font color="##000066"><cf_get_lang no="784.Görev Aldığı Projeler"></font></strong></td>
                        </tr>
                        <tr>
                            <td width="300"><strong><cf_get_lang no="393.Rol"></strong></td>
                            <td colspan="3"><strong><cf_get_lang_main no="728.İş Grubu"></strong></td>
                        </tr>
                        <cfloop query="get_workgroup">
                        <tr>
                            <td>#WORKGROUP_NAME#</td>
                            <td>#ROLE_HEAD#</td>
                        </tr>
                        </cfloop>
                    </table>
                </td>
            </tr>
        </table>
    </cfoutput>
</cfif>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->
