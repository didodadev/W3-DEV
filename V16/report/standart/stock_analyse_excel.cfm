<cfparam name="attributes.module_id_control" default="3,48">
<cfinclude template="report_authority_control.cfm">
<cfquery name="get_emp_branch" datasource="#DSN#">
	SELECT
		*
	FROM
		EMPLOYEE_POSITION_BRANCHES
	WHERE
		POSITION_CODE = #SESSION.EP.POSITION_CODE#
</cfquery>
<cfset emp_branch_list=valuelist(get_emp_branch.BRANCH_ID)>

<cfquery name="get_branches" datasource="#dsn#">
SELECT DISTINCT
	RELATED_COMPANY
FROM 
	BRANCH 
WHERE 
	BRANCH_ID IS NOT NULL 
	<cfif not session.ep.ehesap>
		AND BRANCH_ID IN (#emp_branch_list#)
	</cfif>
ORDER BY 
	RELATED_COMPANY
</cfquery>

<cfquery name="get_ssk_offices" datasource="#dsn#">
	SELECT
		BRANCH_ID,
		BRANCH_NAME,	
		BRANCH_FULLNAME,	
		SSK_OFFICE,
		COMPANY_ID,
		SSK_NO,
		BRANCH_TAX_NO,
		BRANCH_TAX_OFFICE
	FROM
		BRANCH
	WHERE
		BRANCH.SSK_NO IS NOT NULL AND
		BRANCH.SSK_OFFICE IS NOT NULL AND
		BRANCH.SSK_BRANCH IS NOT NULL AND
		BRANCH.SSK_NO <> '' AND
		BRANCH.SSK_OFFICE <> '' AND
		BRANCH.SSK_BRANCH <> ''
		<cfif not session.ep.ehesap>
		AND BRANCH_ID IN (#emp_branch_list#)
		</cfif>
	ORDER BY
		BRANCH_NAME,
		SSK_OFFICE
</cfquery>

<table cellpadding="0" cellspacing="0" width="98%" align="center">
	<tr height="35">
		<td class="headbold"><cf_get_lang no ='1201.Aile Durum Bildirim Raporu'></td>
        <!-- sil --><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'><!-- sil -->
	</tr>
</table>
<table width="98%" cellpadding="2" cellspacing="1" class="color-border" align="center">
	<tr  class="color-row">
		<td align="right" style="text-align:right;">
			<table>
				<cfform name="ara_form" method="post" action="#request.self#?fuseaction=report.family_detail">
				<tr>
					<td>
					<select name="RELATED_COMPANY">
						<option value=""><cf_get_lang no ='234.İlgili Şirket'></option>
					<cfoutput query="get_branches">
						<option value="#RELATED_COMPANY#" <cfif isdefined("attributes.RELATED_COMPANY") and attributes.RELATED_COMPANY is RELATED_COMPANY>selected</cfif>>#related_company#</option>
					</cfoutput>	
					</select>
					</td>
					<td>
					<select name="SSK_OFFICE">
					  		<option value=""><cf_get_lang_main no='2329.Şube Seçiniz'></option>
                        <cfoutput query="GET_SSK_OFFICES">
                          <cfif len(SSK_OFFICE) and len(SSK_NO)>
                            <option value="#branch_id#">#BRANCH_NAME#-#SSK_OFFICE#-#SSK_NO#</option>
                          </cfif>
                        </cfoutput>
                      </select>
					  </td>
					<td>
						<select name="related_year">
							<option value="2008">2008</option>
							<option value="2008">2009</option>
							<option value="2008">2010</option>
							<option value="2008">2011</option>
						</select>
					</td>
					<td>
						<select name="related_mon">
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
							<option value="6">6</option>
							<option value="7">7</option>
							<option value="8">8</option>
							<option value="9">9</option>
							<option value="10">10</option>
							<option value="11">11</option>
							<option value="12">12</option>
						</select>
					</td>
					<td><input type="submit" value="<cf_get_lang_main no ='446.Excel Getir'>"></td>
				</tr>
				</cfform>
			</table>
		</td>
	</tr>
</table>

<cfif isdefined("attributes.RELATED_COMPANY")>
	<cfset ay_sonu = CreateDateTime(attributes.related_year, attributes.related_mon,daysinmonth(createdate(attributes.related_year,attributes.related_mon,1)), 23,59,59)>
		<cfquery name="get_employees_1" datasource="#dsn#">
			SELECT 
				1 AS TYPE,
				E.EMPLOYEE_ID,
				E.EMPLOYEE_NO,
				E.EMPLOYEE_NAME EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
				B.BRANCH_NAME,
				B.RELATED_COMPANY,
				EII.TC_IDENTY_NO AS KISI_TC_NO,
				EII.MARRIED,
				EII.BIRTH_DATE AS KISI_DOGUM,
				ED.SEX,
				EP.POSITION_NAME,
				ST.TITLE,
				ER.NAME,
				ER.SURNAME,
				ER.RELATIVE_LEVEL,
				ER.TC_IDENTY_NO,
				ER.BIRTH_DATE,
				ER.BIRTH_PLACE,
				ER.RECORD_DATE,
				ER.DISCOUNT_STATUS,
				ER.EDUCATION_STATUS,
				ER.WORK_STATUS
			FROM 
				EMPLOYEES_IN_OUT EI,
				EMPLOYEES E,
				BRANCH B,
				EMPLOYEES_IDENTY EII,
				EMPLOYEES_DETAIL ED,
				EMPLOYEES_RELATIVES ER,
				EMPLOYEE_POSITIONS EP,
				SETUP_TITLE ST
			WHERE
				EII.BIRTH_DATE IS NOT NULL AND
				EP.IS_MASTER = 1 AND
				EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
				ST.TITLE_ID = EP.TITLE_ID AND
				(EI.FINISH_DATE IS NULL OR EI.FINISH_DATE >= #NOW()#) AND
				<cfif len(attributes.SSK_OFFICE)>B.BRANCH_ID = #attributes.SSK_OFFICE# AND</cfif>
				<cfif len(attributes.RELATED_COMPANY)>B.RELATED_COMPANY = '#attributes.RELATED_COMPANY#' AND</cfif>
				<cfif not session.ep.ehesap>B.BRANCH_ID IN (#emp_branch_list#) AND</cfif>
				ED.EMPLOYEE_ID = E.EMPLOYEE_ID AND
				EII.EMPLOYEE_ID = E.EMPLOYEE_ID AND
				EI.EMPLOYEE_ID = E.EMPLOYEE_ID AND
				EI.EMPLOYEE_ID = ER.EMPLOYEE_ID AND
				EI.BRANCH_ID = B.BRANCH_ID 
				AND (ER.RELATIVE_LEVEL = '3' OR ER.RELATIVE_LEVEL = '4' OR ER.RELATIVE_LEVEL = '5')
			UNION ALL
			SELECT 
				2 AS TYPE,
				E.EMPLOYEE_ID,
				E.EMPLOYEE_NO,
				E.EMPLOYEE_NAME EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME EMPLOYEE_SURNAME,
				B.BRANCH_NAME,
				B.RELATED_COMPANY,
				EII.TC_IDENTY_NO AS KISI_TC_NO,
				EII.MARRIED,
				EII.BIRTH_DATE AS KISI_DOGUM,
				ED.SEX,
				EP.POSITION_NAME,
				ST.TITLE,
				'' AS NAME,
				'' AS SURNAME,
				'0' AS RELATIVE_LEVEL,
				'' AS TC_IDENTY_NO,
				EII.BIRTH_DATE AS BIRTH_DATE,
				EII.BIRTH_PLACE AS BIRTH_PLACE,
				E.RECORD_DATE,
				1 AS DISCOUNT_STATUS,
				0 AS EDUCATION_STATUS,
				1 AS WORK_STATUS
			FROM 
				EMPLOYEES_IN_OUT EI,
				EMPLOYEES E,
				BRANCH B,
				EMPLOYEES_IDENTY EII,
				EMPLOYEES_DETAIL ED,
				EMPLOYEE_POSITIONS EP,
				SETUP_TITLE ST
			WHERE
				EII.BIRTH_DATE IS NOT NULL AND
				EP.IS_MASTER = 1 AND
				EP.EMPLOYEE_ID = E.EMPLOYEE_ID AND
				ST.TITLE_ID = EP.TITLE_ID AND
				(EI.FINISH_DATE IS NULL OR EI.FINISH_DATE >= #NOW()#) AND
				<cfif len(attributes.SSK_OFFICE)>B.BRANCH_ID = #attributes.SSK_OFFICE# AND</cfif>
				<cfif len(attributes.RELATED_COMPANY)>B.RELATED_COMPANY = '#attributes.RELATED_COMPANY#' AND</cfif>
				<cfif not session.ep.ehesap>B.BRANCH_ID IN (#emp_branch_list#) AND</cfif>
				ED.EMPLOYEE_ID = E.EMPLOYEE_ID AND
				EII.EMPLOYEE_ID = E.EMPLOYEE_ID AND
				EI.EMPLOYEE_ID = E.EMPLOYEE_ID AND
				EI.BRANCH_ID = B.BRANCH_ID 
		</cfquery>
		<CFQUERY name="get_employees" dbtype="query">
			SELECT * FROM get_employees_1 ORDER BY EMPLOYEE_NAME,EMPLOYEE_SURNAME,TYPE DESC,RELATIVE_LEVEL
		</CFQUERY>
		
	<cfset cocuk_sayisi = 0> 
	<cfset type_ = 1>
	<cf_wrk_html_table border="1" cellpadding="2" cellspacing="0" table_draw_type="#type_#" filename="family_detail#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
		<cf_wrk_html_tr>
			<cf_wrk_html_td class="txtbold"><cf_get_lang_main no ='1165.Sıra'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang_main no ='1075.Çalışan No'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang_main no ='164.Çalışan'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang no ='1393.Çalışan Yaşı'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang_main no ='164.Çalışan'><cf_get_lang_main no ='613.TC No'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang_main no ='1085.Pozisyon'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang_main no ='159.Ünvan'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang no ='234.İlgili Şirket'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang_main no ='162.Şirket'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang no ='193.Medeni Durum'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang no ='1396.Yakını'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang no ='1397.Yakınlık Derecesi'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang_main no ='613.TC No'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang_main no='378.Doğum Yeri'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang_main no='1315.Doğum Tarihi'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang no ='677.Yaş'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang no ='250.Vergi İndirimi'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang no ='1399.Okul Durumu'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang no ='1400.İş Durumu'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang_main no='1044.ORAN'></cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang_main no='1060.Dönem'><cf_get_lang_main no ='1043.Yıl'> </cf_wrk_html_td>
			<cf_wrk_html_td class="txtbold"><cf_get_lang_main no='1060.Dönem'><cf_get_lang_main no='1312.Ay'> </cf_wrk_html_td>
		</cf_wrk_html_tr>	
		<cfoutput query="get_employees">
			<cf_wrk_html_tr>
				<cf_wrk_html_td>#currentrow#</cf_wrk_html_td>
				<cf_wrk_html_td>#EMPLOYEE_NO#</cf_wrk_html_td>
				<cf_wrk_html_td>#employee_name# #employee_surname#</cf_wrk_html_td>
				<cf_wrk_html_td>#datediff("yyyy",KISI_DOGUM,now())#</cf_wrk_html_td>
				<cf_wrk_html_td>#kisi_tc_no#</cf_wrk_html_td>
				<cf_wrk_html_td>#position_name#</cf_wrk_html_td>
				<cf_wrk_html_td>#TITLE#</cf_wrk_html_td>
				<cf_wrk_html_td>#related_company#</cf_wrk_html_td>
				<cf_wrk_html_td>#BRANCH_NAME#</cf_wrk_html_td>
				<cf_wrk_html_td><cfif MARRIED eq 1><cf_get_lang no ='195.Evli'><cfelse><cf_get_lang no ='194.Bekar'></cfif></cf_wrk_html_td>
				<cf_wrk_html_td><cfif TYPE eq 2>-<cfelse>#NAME# #SURNAME#</cfif></cf_wrk_html_td>
				<cf_wrk_html_td>
				<cfif RELATIVE_LEVEL eq 3><cfset relative_type = "Eşi">
				<cfelseif RELATIVE_LEVEL eq 4><cfset relative_type = "Oğlu">
				<cfelseif RELATIVE_LEVEL eq 5><cfset relative_type = "Kızı">
				<cfelse><cfset relative_type = "Kendisi">
				</cfif>
				#relative_type#
				</cf_wrk_html_td>
				<cf_wrk_html_td><cfif TYPE eq 2>#kisi_tc_no#<cfelse>#TC_IDENTY_NO#</cfif></cf_wrk_html_td>
				<cf_wrk_html_td>#birth_place#</cf_wrk_html_td>
				<cf_wrk_html_td><cfif TYPE eq 2><cfif len(KISI_DOGUM)>#DateFormat(KISI_DOGUM,dateformat_style)#</cfif><cfelse><cfif len(BIRTH_DATE)>#DateFormat(BIRTH_DATE,dateformat_style)#</cfif></cfif></cf_wrk_html_td>
				<cf_wrk_html_td><cfif TYPE eq 2><cfif len(KISI_DOGUM)>#datediff("yyyy",KISI_DOGUM,now())#</cfif><cfelse><cfif len(birth_date)>#datediff("yyyy",birth_date,now())#</cfif></cfif></cf_wrk_html_td>
				<cf_wrk_html_td><cfif discount_status eq 1><cf_get_lang_main no='1695.Kullanıyor'><cfelse><cf_get_lang_main no='1696.Kullanmıyor'></cfif></cf_wrk_html_td>
				<cf_wrk_html_td><cfif education_status eq 1><cf_get_lang no ='1409.Öğrenci'><cfelse><cf_get_lang no ='1410.Okumuyor'></cfif></cf_wrk_html_td>
				<cf_wrk_html_td><cfif work_status eq 1><cf_get_lang no ='1416.Çalışıyor'><cfelse><cf_get_lang no ='1417.Çalışmıyor'></cfif></cf_wrk_html_td>
				<cf_wrk_html_td>
					<cfif TYPE eq 2>50<cfelseif RELATIVE_LEVEL eq 3>
						<cfif work_status neq 1 and discount_status eq 1>10<cfelse>0</cfif>
					<cfelseif (relative_level eq 4 or relative_level eq 5)>
						<cfif RELATIVE_LEVEL eq 4 and work_status neq 1 and discount_status eq 1 and education_status eq 1 and datediff("yyyy",BIRTH_DATE,ay_sonu) lte 25>
							<cfif cocuk_sayisi lt 2>7,5<cfelse>5</cfif>
							<cfset cocuk_sayisi = cocuk_sayisi + 1>
						<cfelseif RELATIVE_LEVEL eq 4 and work_status neq 1 and discount_status eq 1 and datediff("yyyy",BIRTH_DATE,ay_sonu) lt 18>
							<cfif cocuk_sayisi lt 2>7,5<cfelse>5</cfif>
							<cfset cocuk_sayisi = cocuk_sayisi + 1>
						<cfelseif RELATIVE_LEVEL eq 5 and work_status neq 1 and discount_status eq 1 and education_status eq 1 and datediff("yyyy",BIRTH_DATE,ay_sonu) lte 25>
							<cfif cocuk_sayisi lt 2>7,5<cfelse>5</cfif>
							<cfset cocuk_sayisi = cocuk_sayisi + 1>
						<cfelseif RELATIVE_LEVEL eq 5 and work_status neq 1 and discount_status eq 1 and datediff("yyyy",BIRTH_DATE,ay_sonu) lt 18>
							<cfif cocuk_sayisi lt 2>7,5<cfelse>5</cfif>
							<cfset cocuk_sayisi = cocuk_sayisi + 1>
						<cfelse>0</cfif>
					</cfif>
				</cf_wrk_html_td>
				<cfif year(record_date) lt 2008>
					<cf_wrk_html_td>2008</cf_wrk_html_td>
					<cf_wrk_html_td>1</cf_wrk_html_td>
				<cfelse>
					<cf_wrk_html_td>#year(record_date)#</cf_wrk_html_td>
					<cf_wrk_html_td>#month(record_date)#</cf_wrk_html_td>
				</cfif>
			</cf_wrk_html_tr>
			<cfif currentrow neq recordcount and employee_id neq employee_id[currentrow+1]>
				<cfset cocuk_sayisi = 0>
			</cfif>
		</cfoutput>
	</cf_wrk_html_table>
</cfif>
