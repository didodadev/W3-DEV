﻿<cf_get_lang_set module_name="ehesap">
<cfif isDefined("URL.FEE_ID") and len(URL.FEE_ID)>
   <cfquery name="GET_DOC" datasource="#DSN#">
     SELECT 
    	 FEE_ID, 
         FEE_DATE, 
         EMPLOYEE_ID, 
         VALIDATOR_POS_CODE, 
         VALID_EMP, 
         VALID, 
         ILL_NAME, 
         ILL_SURNAME, 
         SEX, 
         ILL_RELATIVE, 
         BIRTH_DATE, 
         BIRTH_PLACE, 
         FEE_HOUR, 
         BRANCH_ID, 
         TC_IDENTY_NO, 
         IN_OUT_ID, 
         VALID_1, 
         VALID_2, 
         ILL_SEX 
     FROM 
	     EMPLOYEES_SSK_FEE_RELATIVE 
     WHERE 
     	FEE_ID = #URL.FEE_ID#
   </cfquery>
</cfif>
<!--- queryler --->
<cfquery name="DETAIL" datasource="#dsn#">
	SELECT 
		BRANCH_ID,
		START_DATE,
		FINISH_DATE,
		SOCIALSECURITY_NO,
		IN_OUT_ID
	FROM
		EMPLOYEES_IN_OUT
	WHERE 
		EMPLOYEES_IN_OUT.IN_OUT_ID = #GET_DOC.in_out_id#
</cfquery>
<cfif NOT DETAIL.RECORDCOUNT>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='54638.Çalışan Kaydı Bulunamadı'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfif len(GET_DOC.branch_id)>
	<cfset my_branch_id = GET_DOC.BRANCH_ID>
<cfelse>
	<cfset my_branch_id = DETAIL.BRANCH_ID>
</cfif>
<cfquery name="SSK" datasource="#dsn#">
	SELECT 
		BRANCH.SSK_NO,
		BRANCH.SSK_M,
		BRANCH.SSK_JOB,
		BRANCH.SSK_BRANCH,   
		BRANCH.BRANCH_FULLNAME,
		BRANCH.SSK_CITY,
		BRANCH.SSK_CD,
		BRANCH.SSK_COUNTRY,
		BRANCH.SSK_BRANCH_OLD,
		BRANCH.SSK_OFFICE,
		BRANCH.BRANCH_ADDRESS,
		BRANCH.BRANCH_POSTCODE,
		BRANCH.BRANCH_COUNTY,
		BRANCH.BRANCH_CITY,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.ADDRESS,
		OUR_COMPANY.MANAGER
	FROM 
		BRANCH,
		OUR_COMPANY
	WHERE
		BRANCH.BRANCH_ID = #my_branch_id# AND  
		OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
</cfquery>

<cfquery name="get_emp_puantajs" datasource="#dsn#" maxrows="12">
  	SELECT
		EMPLOYEES_PUANTAJ.SAL_MON,
		EMPLOYEES_PUANTAJ.SAL_YEAR,
		EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS
	FROM
		EMPLOYEES_PUANTAJ,
		EMPLOYEES_PUANTAJ_ROWS,
		BRANCH
	WHERE
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		AND EMPLOYEES_PUANTAJ.SSK_OFFICE = BRANCH.SSK_OFFICE
		AND EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = BRANCH.SSK_NO		
		AND BRANCH.BRANCH_ID = #my_branch_id#
		AND EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
		AND
		(
			(
				EMPLOYEES_PUANTAJ.SAL_YEAR = #dateformat(GET_DOC.FEE_DATE,'yyyy')#
				AND EMPLOYEES_PUANTAJ.SAL_MON < #MONTH(GET_DOC.FEE_DATE)#
			)
			OR
			(			
				EMPLOYEES_PUANTAJ.SAL_YEAR < #dateformat(GET_DOC.FEE_DATE,'yyyy')#
			)
		)
	<cfif not session.ep.ehesap>
		AND 
		BRANCH.BRANCH_ID IN (
							SELECT
								BRANCH_ID
							FROM
								EMPLOYEE_POSITION_BRANCHES
							WHERE
								EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
							)
	</cfif>
	ORDER BY
		EMPLOYEES_PUANTAJ.SAL_YEAR DESC,
		EMPLOYEES_PUANTAJ.SAL_MON DESC
</cfquery>
<cfquery name="GET_EMP_DETAIL" datasource="#DSN#">
	SELECT
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		E.MOBILCODE,
		E.MOBILTEL,
		ED.HOMETEL_CODE,
		ED.HOMETEL,
		ED.HOMEADDRESS,
		ED.HOMEPOSTCODE,
		ED.HOMECITY,
		ED.HOMECOUNTRY,
		ED.HOMECOUNTY,
		ED.SEX,
		EI.FATHER,
		EI.BIRTH_DATE,
		EI.BIRTH_PLACE,
		EI.NATIONALITY,
		EI.TC_IDENTY_NO
	FROM
		EMPLOYEES E,
		EMPLOYEES_DETAIL ED,
		EMPLOYEES_IDENTY EI
	WHERE
		E.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		AND ED.EMPLOYEE_ID = E.EMPLOYEE_ID
		AND EI.EMPLOYEE_ID = E.EMPLOYEE_ID
</cfquery>

<cfif len(get_emp_detail.homecity)>
	<cfquery name="get_city" datasource="#dsn#">SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_emp_detail.homecity#</cfquery> 
</cfif>

<cfif len(GET_EMP_DETAIL.NATIONALITY)>
	<cfquery name="get_country" datasource="#dsn#">
		SELECT COUNTRY_ID,COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = #GET_EMP_DETAIL.NATIONALITY#
	</cfquery>
</cfif>
<table align="center" style="width:190mm;" cellpadding="0" cellspacing="0">
<tr>
	<td>
		<table width="99%">
			<tr>
				<td align="center" class="printbold"><img src="/images/ssk.gif"><br/>
				<span class="formbold"><cf_get_lang dictionary_id="59426.SOSYAL GÜVENLİK KURUMU VİZİTE KAĞIDI"></span><br/>
				(<cf_get_lang dictionary_id="59427.Sigortalının Eşi ve Geçindirmekle Yükümlü Olduğu Çocuklarına Ait">)
			</td>
			</tr>
		</table>
		<table width="99%">
			<tr>
				<td></td>
				<td class="txtbold" width="175"><cf_get_lang dictionary_id="45418.Belgenin Düzenlendiği Tarih">:</td>
				<td width="100"><cfoutput>#dateformat(GET_DOC.FEE_DATE,dateformat_style)#</cfoutput></td>
			</tr>
		</table>
<!--- çalışan bilgileri --->
<cfoutput>
		<table width="99%" border="1" cellspacing="0" cellpadding="0">
			<tr align="center">
				<td colspan="4" class="formbold">A-<cf_get_lang dictionary_id="31517.SİGORTALININ"></td>
			</tr>
			<tr>
				<td width="15" class="txtbold">1</td>
				<td width="175" class="txtbold"><cf_get_lang dictionary_id="58025.TC Kimlik No"></td>
				<td width="220"><cf_duxi name='tc_identity_no' class="tableyazi" type="label" value="#get_emp_detail.TC_IDENTY_NO#" gdpr="2"></td>
				<td class="txtbold"><cf_get_lang dictionary_id="38974.İkametgah Adresi"></td>
			</tr>
			<tr>
				<td class="txtbold">2</td>
				<td class="txtbold"><cf_get_lang dictionary_id="53903.Sigorta Sicil No"></td>
				<td>#DETAIL.SOCIALSECURITY_NO#</td>
				<td rowspan="3" valign="top">#get_emp_detail.HOMEADDRESS#
					<cfif len(get_emp_detail.homecounty)>
						<cfquery name="get_county" datasource="#dsn#">
							SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_emp_detail.homecounty#
						</cfquery>
						#get_county.county_name#
					</cfif>
				 <cfif len(get_emp_detail.homecity)>&nbsp;#GET_CITY.CITY_NAME#</cfif>&nbsp;</td>
			</tr>
			<tr>
				<td class="txtbold">3</td>
				<td class="txtbold"><cf_get_lang dictionary_id="32370.Adı Soyadı"></td>
				<td>#get_emp_detail.employee_name# #get_emp_detail.employee_surname#</td>
			</tr>
			<tr>
				<td class="txtbold">4</td>
				<td class="txtbold"><cf_get_lang dictionary_id="58033.Baba Adı"></td>
				<td>#get_emp_detail.father#</td>
			</tr>
			<tr>
				<td class="txtbold">5</td>
				<td class="txtbold"><cf_get_lang dictionary_id="51527.Cinsiyeti"></td>
				<td>
					<cfif get_emp_detail.SEX eq 1><cf_get_lang dictionary_id="58959.Erkek"><cfelse><cf_get_lang dictionary_id="58958.Kadın"></cfif>
				</td>
				<td class="txtbold"><cf_get_lang dictionary_id="57472.Posta Kodu">: #get_emp_detail.HOMEPOSTCODE#</td>
			</tr>
			<tr>
				<td class="txtbold">6</td>
				<td class="txtbold"><cf_get_lang dictionary_id="30502.Uyruğu">(<cf_get_lang dictionary_id="53936.Yabancı İse Ülke Adı">)</td>
				<td>
					<cfif len(GET_EMP_DETAIL.NATIONALITY)>#get_country.COUNTRY_NAME#</cfif>
				</td>
				<td class="txtbold">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td width="50%" class="txtbold"><cf_get_lang dictionary_id="31261.Ev Tel">: <cf_get_lang dictionary_id="31261.Ev Tel">: <cf_duxi name='ev_tel' class="tableyazi" type="label" value="#get_emp_detail.HOMETEL_CODE# #get_emp_detail.HOMETEL#" gdpr="1"></td>
							<td width="50%" class="txtbold"><cf_get_lang dictionary_id="30697.Cep Tel">: <cf_duxi name='cep_tel' class="tableyazi" type="label" value="#get_emp_detail.MOBILCODE# #get_emp_detail.MOBILTEL#" gdpr="1"> </td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td class="txtbold">7</td>
				<td class="txtbold"><cf_get_lang dictionary_id="57790.Doğum Yeri"> / <cf_get_lang dictionary_id="58727.Doğum Tarihi"></td>
				<td colspan="2">#dateformat(get_emp_detail.BIRTH_DATE,dateformat_style)# / #get_emp_detail.BIRTH_PLACE#</td>
			</tr>
			<tr>
				<td class="txtbold">8</td>
				<td class="txtbold"><cf_get_lang dictionary_id="38923.İşe Giriş Tarihi"></td>
				<td>#dateformat(detail.START_DATE,dateformat_style)#&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
		</table>
</cfoutput>
<!--- çalışan bilgileri --->
<br/>
<!--- yakın bilgileri --->
<cfoutput>
		<table width="99%" border="1" cellspacing="0" cellpadding="0">
			<tr align="center">
				<td colspan="4" class="formbold">B-<cf_get_lang dictionary_id="59428.HASTANIN"></td>
			</tr>
			<tr>
				<td width="15" class="txtbold">9</td>
				<td width="175" class="txtbold"><cf_get_lang dictionary_id="59429.Sigortalıya Yakınlığı"></td>
				<td width="220">
				<cfif isnumeric(GET_DOC.ILL_RELATIVE) and GET_DOC.ILL_RELATIVE eq 1><cf_get_lang dictionary_id="31327.Baba">
					<cfelseif isnumeric(GET_DOC.ILL_RELATIVE) and GET_DOC.ILL_RELATIVE eq 1><cf_get_lang dictionary_id="31328.Anne">
					<cfelseif isnumeric(GET_DOC.ILL_RELATIVE) and GET_DOC.ILL_RELATIVE eq 1><cf_get_lang dictionary_id="44696.Eş">
					<cfelseif isnumeric(GET_DOC.ILL_RELATIVE) and GET_DOC.ILL_RELATIVE eq 1><cf_get_lang dictionary_id="53277.Oğul">
					<cfelseif isnumeric(GET_DOC.ILL_RELATIVE) and GET_DOC.ILL_RELATIVE eq 1><cf_get_lang dictionary_id="44605.Kız">
					<cfelse>#GET_DOC.ILL_RELATIVE#
				</cfif>
				<td class="txtbold"><cf_get_lang dictionary_id="30606.Ev Adresi"></td>
			</tr>
			<tr>
				<td class="txtbold">10</td>
				<td class="txtbold"><cf_get_lang dictionary_id="58025.TC Kimlik No"></td>
				<td><cf_duxi name='tc_identity_no' class="tableyazi" type="label" value="#GET_DOC.TC_IDENTY_NO#" gdpr="2"></td>
				<td rowspan="2" valign="top">#get_emp_detail.HOMEADDRESS# #get_emp_detail.HOMECOUNTY# <cfif len(get_emp_detail.homecity)>&nbsp;#GET_CITY.CITY_NAME#</cfif>&nbsp;&nbsp;</td>
			</tr>
			<tr>
				<td class="txtbold">11</td>
				<td class="txtbold"><cf_get_lang dictionary_id="32370.Adı ve Soyadı"></td>
				<td>#GET_DOC.ill_name# #GET_DOC.ill_surname#&nbsp;</td>
			</tr>
			<tr>
				<td class="txtbold">12</td>
				<td class="txtbold"><cf_get_lang dictionary_id="32872.Cinsiyeti"></td>
				<td><cfif get_doc.ill_sex eq 1><cf_get_lang dictionary_id="58959.Erkek"><cfelse><cf_get_lang dictionary_id="58958.Kadın"></cfif></td>
				<td class="txtbold"><cf_get_lang dictionary_id="57472.Posta Kodu"> : #get_emp_detail.HOMEPOSTCODE#</td>
			</tr>
			<tr>
				<td class="txtbold">13</td>
				<td class="txtbold"><cf_get_lang dictionary_id="30502.Uyruğu"> (<cf_get_lang dictionary_id="53936.Yabancı İse Ülke Adı">)</td>
				<td><cfif len(GET_EMP_DETAIL.NATIONALITY)>#get_country.COUNTRY_NAME#</cfif></td>
				<td class="txtbold">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td width="50%" class="txtbold"><cf_get_lang dictionary_id="31261.Ev Tel">: <cf_duxi name='ev_tel' class="tableyazi" type="label" value="#get_emp_detail.HOMETEL_CODE# #get_emp_detail.HOMETEL#" gdpr="1"></td>
							<td width="50%" class="txtbold"><cf_get_lang dictionary_id="30697.Cep Tel">: <cf_duxi name='cep_tel' class="tableyazi" type="label" value="#get_emp_detail.MOBILCODE# #get_emp_detail.MOBILTEL#" gdpr="1"> </td>
						</tr>
					</table>
				</td>            
			</tr>
			<tr>
				<td class="txtbold">14</td>
				<td class="txtbold"><cf_get_lang dictionary_id="57790.Doğum Yeri"> / <cf_get_lang dictionary_id="58727.Doğum Tarihi"></td>
				<td colspan="2">#GET_DOC.BIRTH_PLACE# - #dateformat(GET_DOC.BIRTH_DATE,dateformat_style)# &nbsp;</td>
			</tr>
		</table>
				</cfoutput>		
				<!--- yakın bilgileri --->
				<br/>
				<!--- sigorta prim durumları --->
		<table width="99%" border="1" cellspacing="0" cellpadding="0">
			<tr>
				<td width="15" class="txtbold">15</td>
				<td class="txtbold"><cf_get_lang dictionary_id="59430.Prim Ödeme Halinin Sona Erip Ermediğini Sona Erdi  veya Sona Ermedi Şeklinde ve El Yazınız İle Yandaki Haneye Yazınız."></td>
				<td width="200" class="txtbold">
				<cf_get_lang dictionary_id="45527.Sona Erdi; İse Erdiği Tarih"> : 
				<cfif len(DETAIL.FINISH_DATE)>
					<cfoutput>#dateFormat(DETAIL.FINISH_DATE,dateformat_style)#</cfoutput>
				</cfif>
				</td>
			</tr>
		</table>
		<br/>
		<table width="99%" border="1" cellspacing="0" cellpadding="0">
			<tr align="center">
				<td colspan="4" class="formbold">C-<cf_get_lang dictionary_id="59406.SİGORTALININ PRİM ÖDEME GÜN SAYISI"></td>
			</tr>
			<tr class="txtbold">
				<td width="15" align="center"><cf_get_lang dictionary_id="58577.Sıra"></td>
				<td width="200" align="center"><cf_get_lang dictionary_id="58455.Yıl"></td>
				<td width="200" align="center"><cf_get_lang dictionary_id="58724.Ay"></td>
				<td align="center"><cf_get_lang dictionary_id="53856.Prim Ödeme Gün Sayısı"></td>
			</tr>
				<cfset i=0>
					<cfoutput query="get_emp_puantajs">
					<cfset i=i+1>
						<tr>
							<td align="center">#i#</td>
							<td align="center">#SAL_YEAR#</td>
							<td align="center">#Listgetat(ay_list(),sal_mon)#</td>
							<td align="center">#total_days#</td>
						</tr>
					</cfoutput>
				<cfloop from="#i+1#" to="12" index="i">
					<tr>
						<td align="center"><cfoutput>#i#</cfoutput></td>
						<td align="center">&nbsp;</td>
						<td align="center">&nbsp;</td>
						<td align="center">&nbsp;</td>
					</tr>
				</cfloop>
		</table>
<!--- sigorta prim durumları --->
<br/>
<!--- işveren bilgileri --->
<cfoutput>
		<table width="99%" border="1" cellspacing="0" cellpadding="0">
			<tr>
				<td align="center" class="FORMBOLD" colspan="2"><cf_get_lang dictionary_id="53908.BEYAN VE TAAHHÜTLER"></td>
			</tr>
			<tr>
				<td class="txtbold" valign="top"><cf_get_lang dictionary_id="53833.İşverenin"> <cf_get_lang dictionary_id="59416.Adı ve Soyadı / Unvanı"> <br/><br/>
				#ssk.company_name#
				</td>
				<td width="500" align="center">	
				<br/>
					<table width="98%" border="1" cellspacing="0" cellpadding="0">
						<tr align="center">
							<td colspan="26"><cf_get_lang dictionary_id="44617.İŞYERİ SİCİL NO"></td>
						</tr>
						<tr class="printbold">
							<td rowspan="2">M</td>
							<td colspan="4" align="center"><cf_get_lang dictionary_id="46374.İŞ KOLU KODU"></td>
							<td colspan="4" align="center" rowspan="2"><cf_get_lang dictionary_id="39974.ÜNİTE KODU"></td>
							<td colspan="7" rowspan="2" align="center"><cf_get_lang dictionary_id="53826.İŞYERİ SIRA NUMARASI"></td>
							<td colspan="3" rowspan="2" align="center"><cf_get_lang dictionary_id="39976.İL KODU"></td>
							<td colspan="2" rowspan="2" align="center"><cf_get_lang dictionary_id="39977.İLÇE KODU"></td>
							<td colspan="2" rowspan="2" align="center"><cf_get_lang dictionary_id="40010.KONTROL NUMARASI"></td>
							<td colspan="3" rowspan="2" align="center"><cf_get_lang dictionary_id="39979.ARACI KODU"></td>
						</tr>
						<tr>
							<td colspan="2"><cf_get_lang dictionary_id="58674.YENİ"></td>
							<td colspan="2"><cf_get_lang dictionary_id="53832.ESKİ"></td>
						</tr>
						<tr>
							<td>&nbsp;#ssk.ssk_m#</td>
							<td>&nbsp;#mid(ssk.SSK_JOB,1,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_JOB,2,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_JOB,3,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_JOB,4,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_BRANCH,1,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_BRANCH,2,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_BRANCH_OLD,1,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_BRANCH_OLD,2,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_NO,1,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_NO,2,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_NO,3,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_NO,4,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_NO,5,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_NO,6,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_NO,7,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_CITY,1,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_CITY,2,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_CITY,3,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_COUNTRY,1,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_COUNTRY,2,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_CD,1,1)#</td>
							<td>&nbsp;#mid(ssk.SSK_CD,2,1)#</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
					</table>
				<br/>
			    </td>            
            </tr>
			<tr>
				<td width="200" height="60" valign="top"><strong><cf_get_lang dictionary_id="59431.İşyeri Adresi"></strong> <br/>#ssk.BRANCH_ADDRESS#</td>
				<td>
					<table width="99%" height="99%" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td>
								<table border="0" cellspacing="0" cellpadding="0">
									<tr>
										<td width="30" class="txtbold"><cf_get_lang dictionary_id="58132.Semt"></td>
										<td width="100">&nbsp;</td>
										<td width="30" class="txtbold"><cf_get_lang dictionary_id="58638.İlçe"></td>
										<td width="100">&nbsp;#ssk.BRANCH_COUNTY#</td>
										<td width="30" class="txtbold"><cf_get_lang dictionary_id="57971.Şehir"></td>
										<td width="100">&nbsp;#ssk.BRANCH_CITY#</td>
										<td width="65" class="txtbold"><cf_get_lang dictionary_id="57472.Posta Kodu"></td>
										<td>&nbsp;#ssk.BRANCH_POSTCODE#</td>
									</tr>
								</table>					  
							</td>
						</tr>
					</table>
				</td>
			</tr>	
        </table>
		<br/>
		<table width="99%" border="1" cellspacing="0" cellpadding="0" height="75">
			<tr>
				<td valign="top"><cf_get_lang dictionary_id="59432.Yukarıda ki bilgilerin yanlış olması sebebiyle sigortalının eşi ve geçindirmekle yükümlü olduğu çocukları ile ana ve babasına  Kurumca yersiz olarak yapılan her türlü masrafları ödemeyi kabul ederim"><br/>
					<cf_get_lang dictionary_id="57742.Tarih">:</td>
				<td align="center" valign="bottom"><cf_get_lang dictionary_id="59409.İşverenin veya Vekilinin Adı-Soyadı İmzası, Mühür veya Kaşesi"></td>
			</tr>			
		</table>
</cfoutput>
<!--- işveren bilgileri --->
</td>
</tr>
</table>
<script>
	window.print();
</script>
