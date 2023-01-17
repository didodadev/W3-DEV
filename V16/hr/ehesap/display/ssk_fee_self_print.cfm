<cf_get_lang_set module_name="ehesap">
<cfquery name="GET_FEE" datasource="#dsn#">
    SELECT 
        FEE_ID,
        EMPLOYEE_ID,
        FEE_DATE,
        FEE_DATEOUT,
        FEE_HOUR,
        FEE_HOUROUT, 
        TOTAL_EMP,
        EMP_WORK,
        EVENT,
        PLACE,
        EVENT_DATE,
        EVENT_HOUR,
        WORKSTART,
        WITNESS1,
        WITNESS1_ID,
        WITNESS2,
        WITNESS2_ID, 
        RECORD_EMP, 
        RECORD_IP,
        RECORD_DATE, 
        UPDATE_EMP,
        UPDATE_IP,
        UPDATE_DATE,
        VALIDATOR_POS_CODE, 
        VALID_EMP,
        VALID,
        ACCIDENT,
        ILLNESS,
        DETAIL, 
        EVENT_MIN, 
        ACCIDENT_TYPE_ID,
        ACCIDENT_SECURITY_ID, 
        BRANCH_ID,
        IN_OUT_ID, 
        VALIDATOR_POS_CODE_1,
        VALID_EMP_1,
        VALID_1, 
        VALIDATOR_POS_CODE_2, 
        VALID_EMP_2, 
        VALID_2,
        RELATIVE_REPORT,
        ACCIDENT_CONTINUATION,
        DISMEMBERMENT, 
        WILFUL_ERROR,
        DETAIL_PRINT,
        JOB_ILLNESS_TO_FIX,
        ACCIDENT_RESULT_DEAD,
        ACCIDENT_RESULT_DEAD_WOUNDED, 
        ORGAN_TO_LOSE,
        LIGHT_WOUNDED,
        REST_FIRST_DAY,
        REST_SECOND_DAY,
        REST_THIRD_DAY,
        REST_EXTRA_DAY,
        RELATIVE_NAME_SURNAME, 
        RELATIVE_ADDRESS, 
        PROFESSION_ILL_DIAGNOSIS,
        PROFESSION_ILL_WORK, 
        PROFESSION_ILL_DOUBT 
    FROM 
	    EMPLOYEES_SSK_FEE 
    WHERE 
    	FEE_ID = #attributes.FEE_ID#
</cfquery>
<!--- queryler --->
<cfif not len(GET_FEE.in_out_id)>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='59434.Vizite Tarihi Giriş Çıkışlarında Sorun Oluştu.'> <cf_get_lang dictionary_id='59435.Lütfen Viziteyi Güncelleyiniz'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cfquery name="DETAIL" datasource="#dsn#" maxrows="1">
	SELECT 
		BRANCH_ID,
		START_DATE,
		SOCIALSECURITY_NO,
		FINISH_DATE
	FROM
		EMPLOYEES_IN_OUT
	WHERE 
		EMPLOYEES_IN_OUT.IN_OUT_ID = #GET_FEE.in_out_id#
</cfquery>
<cfset my_branch_id = DETAIL.BRANCH_ID>
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
		BRANCH.BRANCH_ID = #my_branch_id# 
		AND OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
</cfquery>
<cfif not detail.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='59436.Çalışan Bilgileri Eksik'>!");
		window.close();
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="get_emp_puantajs" datasource="#dsn#" maxrows="12">
  	SELECT
		EMPLOYEES_PUANTAJ.SAL_MON,
		EMPLOYEES_PUANTAJ.SAL_YEAR,
		EMPLOYEES_PUANTAJ_ROWS.SSK_MATRAH,
		EMPLOYEES_PUANTAJ_ROWS.TOTAL_DAYS,
		EMPLOYEES_PUANTAJ_ROWS.TOTAL_PAY_SSK_TAX,
		EMPLOYEES_PUANTAJ_ROWS.TOTAL_PAY_SSK
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
				EMPLOYEES_PUANTAJ.SAL_YEAR = #dateformat(get_fee.FEE_DATE,'yyyy')#
				AND EMPLOYEES_PUANTAJ.SAL_MON <= #dateformat(get_fee.FEE_DATE,'mm')#
			)
			OR 
			(
				EMPLOYEES_PUANTAJ.SAL_YEAR < #dateformat(get_fee.FEE_DATE,'yyyy')#			
			)
		)
	<cfif not session.ep.ehesap>
		AND BRANCH.BRANCH_ID IN ( SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# )
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

<!--- queryler --->
<table align="center" style="width:190mm;" cellpadding="0" cellspacing="0">
<tr>
	<td>
		<table width="99%" border="0" cellspacing="0" cellpadding="0">
			<tr align="center">
				<td colspan="2" class="formbold">
				<img src="/images/ssk.gif">
				<br/>
				  <cf_get_lang dictionary_id="59426.SOSYAL GÜVENLİK KURUMU VİZİTE KAĞIDI"><br/> 
				(<cf_get_lang dictionary_id="59437.Sigortalıya Ait">)</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td  class="txtbold" style="text-align:right;"><cf_get_lang dictionary_id="45418.Belgenin Düzenlendiği Tarih"> : <cfoutput>#dateformat(GET_FEE.FEE_DATE, dateformat_style)#</cfoutput></td>
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
		<td width="220">#get_emp_detail.TC_IDENTY_NO#&nbsp;</td>
		<td class="txtbold"><cf_get_lang dictionary_id="38974.İkametgah Adresi"></td>
	</tr>
	<tr>
		<td class="txtbold">2</td>
		<td class="txtbold"><cf_get_lang dictionary_id="53903.Sigorta Sicil No"></td>
		<td>#DETAIL.SOCIALSECURITY_NO#</td>
		<td rowspan="3" valign="top">
			#get_emp_detail.HOMEADDRESS#
			<cfif len(get_emp_detail.homecounty)>
				<cfquery name="get_county" datasource="#dsn#">
					SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_emp_detail.homecounty#
				</cfquery>
				#get_county.county_name#
			</cfif>
			<cfif len(get_emp_detail.homecity)>
				<cfquery name="get_city" datasource="#dsn#">
					SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_emp_detail.homecity#
				</cfquery>
				#GET_CITY.CITY_NAME#
			</cfif>&nbsp;
		</td>
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
		<td class="txtbold"><cf_get_lang dictionary_id="32872.Cinsiyeti"></td>
		<td>
			<cfif get_emp_detail.SEX eq 1><cf_get_lang dictionary_id="58959.Erkek"><cfelse><cf_get_lang dictionary_id="58958.Kadın"></cfif>
		</td>
		<td class="txtbold"><cf_get_lang dictionary_id="57472.Posta Kodu">: #get_emp_detail.HOMEPOSTCODE#</td>
	</tr>
	<tr>
		<td class="txtbold">6</td>
		<td class="txtbold"><cf_get_lang dictionary_id="30502.Uyruğu">(<cf_get_lang dictionary_id="53936.Yabancı İse Ülke Adı">)</td>
		<td>T.C.&nbsp;&nbsp;&nbsp;&nbsp;</td>
		<td class="txtbold"><cf_get_lang dictionary_id="31261.Ev Tel">: #get_emp_detail.HOMETEL_CODE# #get_emp_detail.HOMETEL#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<cf_get_lang dictionary_id="30697.Cep Tel">: #get_emp_detail.MOBILCODE# #get_emp_detail.MOBILTEL#</td>
	</tr>
	<tr>
		<td class="txtbold">7</td>
		<td class="txtbold"><cf_get_lang dictionary_id="57790.Doğum Yeri"> / <cf_get_lang dictionary_id="58727.Doğum Tarihi"></td>
		<td colspan="2">#dateformat(get_emp_detail.BIRTH_DATE,dateformat_style)# / #get_emp_detail.BIRTH_PLACE#</td>
	</tr>
	<tr>
		<td class="txtbold">8</td>
		<td class="txtbold"><cf_get_lang dictionary_id="30929.Öğrenim Durumu"></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td class="txtbold">9</td>
		<td class="txtbold"><cf_get_lang dictionary_id="38923.İşe Giriş Tarihi"></td>
		<td>&nbsp;#dateformat(detail.START_DATE, dateformat_style)#&nbsp;</td>
		<td>&nbsp;#dateformat(detail.FINISH_DATE, dateformat_style)#&nbsp;</td>
	</tr>
	<tr>
		<td class="txtbold">10</td>
		<td class="txtbold"><cf_get_lang dictionary_id="45582.İstihdam Durumu"></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
		<tr>
		<td class="txtbold">11</td>
		<td class="txtbold"><cf_get_lang dictionary_id="59438.Viziteye Çıkmak İçin işyerinde Ayrılış"></td>
		<td>&nbsp;<cf_get_lang dictionary_id="57742.Tarih">: #dateformat(GET_FEE.FEE_DATEOUT, dateformat_style)#</td>
		<td>&nbsp;<cf_get_lang dictionary_id="57491.Saat">: #GET_FEE.FEE_HOUROUT#:00</td>
	</tr>
	<tr>
		<td class="txtbold">12</td>
		<td class="txtbold"><cf_get_lang dictionary_id="45524.Son Bir Yıl İçindeki Toplam Ücretli İzin"></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
</table>
</cfoutput>
<!--- çalışan bilgileri --->
<br/>
<!--- iş kazası bilgileri --->
<cfoutput>
<table width="99%" border="1" cellspacing="0" cellpadding="0">
	<tr align="center">
		<td colspan="4" class="formbold">B-<cf_get_lang dictionary_id="53466.İş Kazasının"></td>
	</tr>
	<tr>
		<td width="15" class="txtbold">13</td>
		<td width="250" class="txtbold"><cf_get_lang dictionary_id="59439.Olduğu Tarihte Çalışan Toplam İşçi Sayısı"></td>
		<td colspan="2">&nbsp;#get_fee.total_emp#</td>
	</tr>
	<tr>
		<td class="txtbold">14</td>
		<td class="txtbold"><cf_get_lang dictionary_id="59440.Olduğu Sırada Sigortalının Yaptığı İş ve Bu İşin Mahiyeti"></td>
		<td colspan="2">&nbsp;#get_fee.emp_work# 
		<cfif GET_FEE.RELATIVE_REPORT eq 1>
				- <cf_get_lang dictionary_id="53920.İŞ GÖREMEZLİK ÖDENEĞİ">
		<cfelseif GET_FEE.ACCIDENT_CONTINUATION eq 1>
				- <cf_get_lang dictionary_id="53919.İŞ KAZASININ DEVAMIDIR">
		<cfelseif GET_FEE.ILLNESS eq 1>
				- <cf_get_lang dictionary_id="53462.MESLEK HASTALIĞI">
		<cfelseif GET_FEE.ACCIDENT eq 1>
				- <cf_get_lang dictionary_id="53147.İŞ KAZASI">
		</cfif>
		</td>
	</tr>
	<tr>
		<td class="txtbold">15</td>
		<td class="txtbold"><cf_get_lang dictionary_id="31572.Oluş Şekli"></td>
		<td colspan="2">&nbsp;#get_fee.event#</td>
	</tr>
	<tr>
		<td class="txtbold">16</td>
		<td class="txtbold"><cf_get_lang dictionary_id="59441.Meydana Geldiği Yer"></td>
		<td colspan="2">&nbsp;#get_fee.place#</td>
	</tr>
	<tr>
		<td class="txtbold">17</td>
		<td class="txtbold"><cf_get_lang dictionary_id="59442.Olduğu Tarih ve Saat"></td>
		<td class="txtbold"><cf_get_lang dictionary_id="57742.Tarih">: #dateformat(get_fee.event_date,dateformat_style)#</td>
		<td class="txtbold"><cf_get_lang dictionary_id="57491.Saat">: <cfif len(get_fee.event_hour)>#get_fee.event_hour#:#get_fee.event_min#</cfif></td>
	</tr>
	<tr>
		<td class="txtbold">18</td>
		<td class="txtbold"><cf_get_lang dictionary_id="59443.Olduğu Günün İşbaşı Saati"></td>
		<td colspan="2">&nbsp; <cfif len(get_fee.workstart)>#get_fee.workstart#</cfif></td>
	</tr>
	<tr>
		<td height="30" class="txtbold">19</td>
		<td class="txtbold"><cf_get_lang dictionary_id="59444.Olduğunu Gören Tanıkların Adı ve Soyadları"></td>
			<td><table width="99%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>1-#get_fee.witness1#</td>
				</tr>
				<tr>
					<td>2-#get_fee.witness2#</td>
				</tr>
			</table></td>
		<td><table width="99%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>3-</td>
				</tr>
				<tr>
					<td>4-</td>
				</tr>
			</table></td>
	</tr>
</table>
		<br/>
</cfoutput>
<!--- iş kazası bilgileri --->
<!--- ssk prim --->
<table width="99%" border="1" cellspacing="0" cellpadding="0">
	<tr>
		<td width="15" class="txtbold">20</td>
		<td class="printbold" width="150">
			<cf_get_lang dictionary_id="59430.Prim Ödeme Halinin Sona Erip Ermediğini 'Sona Erdi' veya 'Sona Ermedi' Şeklinde ve El Yazınız İle Yandaki Haneye Yazınız.">
		</td>
		<td width="200">&nbsp;</td>
			<td width="200" class="printbold" valign="top" nowrap="nowrap">
				<cf_get_lang dictionary_id="45527.Sona Erdi İse">; <cfif isdefined('detail.FINISH_DATE') and len(detail.FINISH_DATE)><cfoutput>#dateFormat(detail.FINISH_DATE,dateformat_style)#</cfoutput></cfif> 
		</td>
	</tr>
</table>
<br/>
<table width="99%" border="1" cellspacing="0" cellpadding="0" class="print">
	<tr align="center">
		<td colspan="7" class="formbold">C-<cf_get_lang dictionary_id="59406.SİGORTALININ PRİM ÖDEME GÜN SAYISI VE KAZANÇLARI"></td>
	</tr>
	<tr class="printbold">
		<td width="25">&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td colspan="2"><cf_get_lang dictionary_id="59445.Hak Ettiği Ücretler"></td>
		<td rowspan="2" width="65"><cf_get_lang dictionary_id="59446.Prim veya İkramiye Gibi Ek Ödenekler"></td>
		<td rowspan="2" align="center" width="135"><cf_get_lang dictionary_id="59447.İşverence veya Mahkemelerce Ödenmesine Karar verilen Ücret Prim ve İkramiyeler"></td>
	</tr>
		<tr class="printbold">
		<td width="30"><cf_get_lang dictionary_id="58455.Yıl"></td>
		<td width="50"><cf_get_lang dictionary_id="58724.Ay"></td>
		<td width="60"><cf_get_lang dictionary_id="53856.Prim Ödeme Gün Sayısı"></td>
		<td><cf_get_lang dictionary_id="59448.Rakamla"></td>
		<td><cf_get_lang dictionary_id="33221.Yazıyla"></td>
	</tr>
		<cfset row_counter_temp = 0>
		<cfset t_ssk_days = 0>
		<cfset t_ssk_matrah = 0>
		<cfoutput query="get_emp_puantajs">		  
			<cfset row_counter_temp = row_counter_temp + 1>
			<cfset t_ssk_days = t_ssk_days + total_days>
			<cfset t_ssk_matrah = t_ssk_matrah + ssk_matrah>
	<tr> 
		<td>#SAL_YEAR#</td>
		<td>#Listgetat(ay_list(),sal_mon)#</td>
		<td>#total_days#</td>
			<cfif sal_year gt 2004>
				<cfset TEMP = ssk_matrah>
			<cfelse>
				<cfset TEMP = (round(ssk_matrah / 10000)/100)>
			</cfif>
		<td  style="text-align:right;">#TLFormat(TEMP)# #session.ep.money#</td>			
		<td>
		<cf_n2txt number="TEMP">
		#TEMP#&nbsp;
		</td>
		<td>
			<cfif sal_year gt 2004>
				<cfset TEMP2 = (total_pay_ssk+total_pay_ssk_tax)>
			<cfelse>
				<cfset TEMP2 = (round((total_pay_ssk+total_pay_ssk_tax) / 10000)/100)>
			</cfif>
			<cfif get_fee.detail_print eq 1>&nbsp;<cfelse>#TLFormat(TEMP2)# #session.ep.money#</cfif>
		</td>
		<td>&nbsp;</td>
		</tr>
			</cfoutput>
				<cfloop from="1" to="#12-row_counter_temp#" index="tempo">
					<tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
				</cfloop>
        </table>
<!--- ssk prim --->
<!--- işveren bilgileri --->
<cfoutput>
<br/>
<table width="99%" border="1" cellspacing="0" cellpadding="0">
	<tr>
		<td align="center" class="FORMBOLD" colspan="2"><cf_get_lang dictionary_id="53908.BEYAN VE TAAHHÜTLER"></td>
	</tr>
	<tr>
		<td class="txtbold" valign="top"><cf_get_lang dictionary_id="53833.İşverenin"> <cf_get_lang dictionary_id="59416.Adı Soyadı / Unvanı"><br/>
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
	<td width="200" height="50" valign="top"><strong><cf_get_lang dictionary_id="59431.İşyeri Adresi"></strong> <br/>#ssk.BRANCH_ADDRESS#</td>
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
<table width="99%" border="1" cellspacing="0" cellpadding="0" height="40">
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
