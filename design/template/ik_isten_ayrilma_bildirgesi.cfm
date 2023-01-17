<cfset attributes.IN_OUT_ID = attributes.action_id>
<cfsetting showdebugoutput="no">
<cfif not len(attributes.in_out_id)>
	<script type="text/javascript">
		alert('Giriş - Çıkış Kaydı Bulunamadı !');
		window.close();
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfquery name="get_in_out" datasource="#dsn#">
	SELECT 
		BRANCH.*,
		EMPLOYEES_IN_OUT.*,
		OUR_COMPANY.COMPANY_NAME,
		OUR_COMPANY.TAX_OFFICE,
		OUR_COMPANY.TAX_NO,
		OUR_COMPANY.T_NO
	FROM 
		BRANCH,
		OUR_COMPANY,
		EMPLOYEES_IN_OUT 
	WHERE
		EMPLOYEES_IN_OUT.IN_OUT_ID = #attributes.IN_OUT_ID#
		AND BRANCH.BRANCH_ID = EMPLOYEES_IN_OUT.BRANCH_ID
		AND OUR_COMPANY.COMP_ID = BRANCH.COMPANY_ID
</cfquery>
<cfset attributes.EMPLOYEE_ID = get_in_out.EMPLOYEE_ID>
<cfquery name="GET_EMP_CODES" datasource="#dsn#">
	SELECT 
		DEPARTMENT.BRANCH_ID, 
		DEPARTMENT.ADMIN1_POSITION_CODE AS DEPT_ADMIN1_POSITION_CODE, 
		BRANCH.ADMIN1_POSITION_CODE AS BRANCH_ADMIN1_POSITION_CODE
	FROM 
		EMPLOYEE_POSITIONS, DEPARTMENT, BRANCH
	WHERE
		EMPLOYEE_POSITIONS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
		EMPLOYEE_POSITIONS.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
</cfquery>

<cfif IsNumeric(GET_EMP_CODES.DEPT_ADMIN1_POSITION_CODE)>
	<cfquery name="GET_EMP_DEPT_CHIEF" datasource="#dsn#">
		SELECT 
			EMPLOYEE_ID, POSITION_CODE, EMPLOYEE_NAME, EMPLOYEE_SURNAME
		FROM 
			EMPLOYEE_POSITIONS
		WHERE
			POSITION_CODE = #GET_EMP_CODES.DEPT_ADMIN1_POSITION_CODE# 
	</cfquery>
</cfif>

<cfif IsNumeric(GET_EMP_CODES.BRANCH_ADMIN1_POSITION_CODE)>
	<cfquery name="GET_EMP_BRANCH_CHIEF" datasource="#dsn#">
		SELECT 
			EMPLOYEE_ID, POSITION_CODE, EMPLOYEE_NAME, EMPLOYEE_SURNAME
		FROM 
			EMPLOYEE_POSITIONS
		WHERE
			POSITION_CODE = #GET_EMP_CODES.BRANCH_ADMIN1_POSITION_CODE# 
	</cfquery>
</cfif>
<cfif not len(get_in_out.finish_date)>
	<script type="text/javascript">
		alert('Çıkış Tarihi Bulunamadı !');
		history.back();
	</script>
	<cfexit method="exittemplate">
</cfif>
<cfif (get_in_out.SSK_STATUTE NEQ 1)>
	<script type="text/javascript">
    	alert('Seçilen Çalışan Normal SSK Statüsüne Sahip Olmadığından Çıkış Bildirgesi Düzenlemez');
    </script>
</cfif>
<cfquery name="get_emp_detail" datasource="#dsn#">
	SELECT 
		ED.*,
		EI.*,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM 
		EMPLOYEES_DETAIL ED,
		EMPLOYEES_IDENTY EI,
		EMPLOYEES E
	WHERE 
		ED.EMPLOYEE_ID=#attributes.EMPLOYEE_ID#
		AND EI.EMPLOYEE_ID = ED.EMPLOYEE_ID
		AND E.EMPLOYEE_ID = ED.EMPLOYEE_ID
</cfquery>
<cfquery name="get_position" datasource="#dsn#">
	SELECT 
		POSITION_NAME
	FROM 
		EMPLOYEE_POSITIONS
	WHERE 
		EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND
		IS_MASTER = 1
</cfquery>
<cfset attributes.sal_mon = MONTH(get_in_out.FINISH_DATE)>
<cfset attributes.sal_year = YEAR(get_in_out.FINISH_DATE)>
<cfset attributes.group_id = "">
<cfif len(get_in_out.puantaj_group_ids)>
	<cfset attributes.group_id = "#get_in_out.PUANTAJ_GROUP_IDS#,">
</cfif>
<cfset attributes.branch_id = get_in_out.branch_id>
<cfinclude template="/V16/hr/ehesap/query/get_program_parameter.cfm">
<cfif get_in_out.GROSS_NET eq 1>
	<cfquery name="get_last_net_salary" datasource="#dsn#">
		SELECT
			M#month(get_in_out.finish_date)#<cfif get_in_out.salary_type eq 1>* 30</cfif>  AS NET_UCRET
		FROM
			EMPLOYEES_SALARY
		WHERE
			IN_OUT_ID = #get_in_out.in_out_id# AND
			PERIOD_YEAR = #year(get_in_out.finish_date)#
	</cfquery>
<cfelse>
	<cfquery name="get_last_puantaj" datasource="#dsn#">
		SELECT
			EPR.*
		FROM
			EMPLOYEES_PUANTAJ,
			EMPLOYEES_PUANTAJ_ROWS EPR
		WHERE
			EPR.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
			AND EMPLOYEES_PUANTAJ.SAL_YEAR = #YEAR(get_in_out.finish_date)#
			AND EMPLOYEES_PUANTAJ.SAL_MON = #MONTH(get_in_out.finish_date)#
			AND EPR.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
	</cfquery>
	<cfif get_last_puantaj.recordcount>
		<cfset isci_paylari_ = (get_last_puantaj.salary * 1 / 100) + (get_last_puantaj.salary * 14 / 100)>
		<cfset damga_vergisi_ = (get_last_puantaj.salary * get_program_parameters.stamp_tax_binde / 1000)>
		<cfset gelir_vergisi_ = ((get_last_puantaj.salary - isci_paylari_) * get_last_puantaj.tax_ratio)>
		<cfset salary_1 = get_last_puantaj.salary - isci_paylari_ - damga_vergisi_ - gelir_vergisi_>
		<cfset get_last_net_salary.NET_UCRET = salary_1>
	<cfelse>
		<cfset get_last_net_salary.NET_UCRET = 0>
	</cfif>
</cfif>
<cfquery name="get_emp_puantajs" datasource="#dsn#" maxrows="5">
  	SELECT
		SUM(TOTAL_DAYS) AS TOTAL_DAYS,
		SAL_YEAR,
		SAL_MON,
		SUM(IZIN) AS IZIN,
		SUM(SSK_MATRAH) AS SSK_MATRAH
	FROM
		EMPLOYEES_PUANTAJ,
		EMPLOYEES_PUANTAJ_ROWS,
		BRANCH
	WHERE
		BRANCH.BRANCH_ID = #get_in_out.branch_id# AND
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND 
		EMPLOYEES_PUANTAJ.SSK_OFFICE = BRANCH.SSK_OFFICE AND 
		EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = BRANCH.SSK_NO AND 
		EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID AND
		(
			(
				EMPLOYEES_PUANTAJ.SAL_YEAR = #year(NOW())#
				AND EMPLOYEES_PUANTAJ.SAL_MON <= #MONTH(NOW())#
			)
			OR
				EMPLOYEES_PUANTAJ.SAL_YEAR < #year(NOW())#
			OR
			(
				EMPLOYEES_PUANTAJ.SAL_MON > #MONTH(get_in_out.START_DATE)#
				AND EMPLOYEES_PUANTAJ.SAL_YEAR = #YEAR(get_in_out.START_DATE)#
			)
		)
	GROUP BY SAL_YEAR,SAL_MON
	ORDER BY 
		EMPLOYEES_PUANTAJ.SAL_YEAR DESC,
		EMPLOYEES_PUANTAJ.SAL_MON DESC
	
</cfquery>
<cfquery name="get_emp_last_3_years" datasource="#dsn#">
  	SELECT
		TOTAL_DAYS AS TOTAL_PAID
	FROM
		EMPLOYEES_PUANTAJ,
		EMPLOYEES_PUANTAJ_ROWS,
		BRANCH
	WHERE
		BRANCH.BRANCH_ID = #get_in_out.branch_id# AND
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# AND 
		EMPLOYEES_PUANTAJ.SSK_OFFICE = BRANCH.SSK_OFFICE AND 
		EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = BRANCH.SSK_NO 
		AND EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
		AND
		(
			(
				EMPLOYEES_PUANTAJ.SAL_YEAR = #session.ep.period_year#
				AND EMPLOYEES_PUANTAJ.SAL_MON <= #MONTH(NOW())#
			)
			OR
			(
				EMPLOYEES_PUANTAJ.SAL_YEAR > #SESSION.EP.PERIOD_YEAR-3#
				AND EMPLOYEES_PUANTAJ.SAL_YEAR < #session.ep.period_year#
			)
			OR
			(
				EMPLOYEES_PUANTAJ.SAL_YEAR = #SESSION.EP.PERIOD_YEAR-3#
				AND EMPLOYEES_PUANTAJ.SAL_MON > #MONTH(NOW())#
			)
		)
	ORDER BY
		EMPLOYEES_PUANTAJ.SAL_YEAR DESC,
		EMPLOYEES_PUANTAJ.SAL_MON DESC
</cfquery>

<cfset iab_real_list = "-1,0,1,2,26,27,21,25,6,7,3,4,5,29,14,9,10,8,13,15,11,12,17,18,19,20,22,23,24,26">
<cfset iab_iskur_list = "10,10,10,1,4,7,10,10,3,10,10,10,10,10,5,6,5,5,5,2,6,10,7,10,8,10,10,10,9,10">
<cfset iab_name_list = "İstifa,İşçi Kusuru,Askerlik,4447-51-a,4447-51-b,4447-51-c,4447-51-d,4447-51-e,4447-51-f,Diğer">
<table>
	<tr>
		<td width="135">&nbsp;</td>
		<td><cfinclude template="/V16/objects/display/view_company_logo.cfm"></td>
	</tr>
</table>
<table width="650" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC">
<!--- <form name="send" method="post">
<input type="hidden" name="gonderildi" value="1">
<input type="hidden" name="in_out_id" value="<cfoutput>#attributes.in_out_id#</cfoutput>">
<input type="hidden" name="employee_id" value="<cfoutput>#attributes.employee_id#</cfoutput>"> --->
  <tr>
    <td colspan="5">
	<table width="100%">
        <tr>
          <td width="250" class="headbold">TÜRKİYE İŞ KURUMU</td>
          <td class="headbold">İŞTEN AYRILMA BİLDİRGESİ</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td class="headbold">(İAB)</td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td colspan="5" height="25">1-İŞVEREN BİLGİLERİ</td>
  </tr>
  <tr>
    <td colspan="4" height="25">Adı Soyadı Ünvanı : <cfoutput>#get_in_out.branch_fullname#</cfoutput></td>
    <td>SSK İşyeri Sicil No : 
	<cfoutput>
	<table>
		<tr>
			<td>#get_in_out.ssk_m#</td>
			<td>#get_in_out.SSK_JOB#</td>
			<td>#get_in_out.SSK_BRANCH#</td>
			<td>#get_in_out.SSK_BRANCH_OLD#</td>
			<td>#get_in_out.SSK_NO#</td>
			<td>#get_in_out.SSK_CITY#</td>
			<td>#get_in_out.SSK_COUNTRY#</td>
			<td>#get_in_out.SSK_CD#</td>
			<td>#get_in_out.SSK_AGENT#</td>
		</tr>
	</table>
	</cfoutput>
	</td>
  </tr>
  <tr>
    <td colspan="4" height="25">İşyeri Adresi : <cfoutput>#get_in_out.BRANCH_ADDRESS#</cfoutput></td>
    <td>Ticaret Sicil No: <cfoutput> #get_in_out.T_NO#</cfoutput></td>
  </tr>
  <tr>
    <td colspan="4" height="25">&nbsp;</td>
    <td>Kuruluş Tarihi (gün/ay/yıl) : <cfoutput>#dateformat(get_in_out.FOUNDATION_DATE,dateformat_style)#</cfoutput></td>
  </tr>
  <tr>
    <td colspan="2" height="25">İl : <cfoutput>#get_in_out.BRANCH_CITY#</cfoutput></td>
    <td colspan="2">İlçe : <cfoutput>#get_in_out.BRANCH_County#</cfoutput></td>
    <td>Ana Çalışma Alanı : <cfoutput>#get_in_out.REAL_WORK#</cfoutput></td>
  </tr>
  <tr>
    <td colspan="2" height="25">Tel : <cfoutput>#get_in_out.BRANCH_TELCODE# #get_in_out.BRANCH_TEL1#</cfoutput></td>
    <td colspan="2">Fax : <cfoutput>#get_in_out.BRANCH_TELCODE# #get_in_out.BRANCH_fax#</cfoutput></td>
    <td>Kapsam : &nbsp;&nbsp; Kamu
      <input type="checkbox" name="Kapsam1" id="Kapsam1" value="1" disabled>
      Özel
      <input type="checkbox" name="Kapsam2" id="Kapsam2" value="2" checked disabled>
    </td>
  </tr>
  <tr>
    <td colspan="5" height="25">2-SİGORTALI BİLGİLERİ</td>
  </tr>
  <tr>
    <td colspan="4" height="25">Adı Soyadı : <cfoutput>#get_emp_detail.employee_name# #get_emp_detail.employee_surname#</cfoutput></td>
    <td>SSK Sicil No : <cfoutput>#get_in_out.socialsecurity_no#</cfoutput></td>
  </tr>
  <tr>
    <td colspan="4" height="25">Adres : <cfoutput>#get_emp_detail.HOMEADDRESS#</cfoutput></td>
    <td>Doğum Tarihi (gün/ay/yıl) : <cfif len(get_emp_detail.birth_date)><cfoutput>#day(get_emp_detail.birth_date)#/#month(get_emp_detail.birth_date)#/#year(get_emp_detail.birth_date)#</cfoutput><cfelse>.../.../.....</cfif></td>
  </tr>
  <tr>
    <td colspan="2" height="25">İl : 
		<cfif len(get_emp_detail.homecity)>
			<cfquery name="get_city" datasource="#dsn#">
				SELECT * FROM SETUP_CITY WHERE CITY_ID = #get_emp_detail.homecity#
			</cfquery>
			<cfoutput>#get_city.CITY_NAME#</cfoutput>
		</cfif>
	</td>
    <td colspan="2">İlçe : 
		<cfif len(get_emp_detail.HOMECOUNTY)>
			<cfquery name="get_cOUNTY" datasource="#dsn#">
				SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = #get_emp_detail.HOMECOUNTY#
			</cfquery>
			<cfoutput>#get_cOUNTY.COUNTY_NAME#</cfoutput>
		</cfif>
	</td>
    <td>Doğum Yeri : <cfoutput>#get_emp_detail.birth_place#</cfoutput></td>
  </tr>
  <tr>
    <td colspan="2" height="25">Tel : <cfoutput>#get_emp_detail.HOMETEL_CODE# #get_emp_detail.HOMETEL#</cfoutput></td>
    <td colspan="2">Fax : </td>
    <td>Ana Adı : <cfoutput>#get_emp_detail.mother#</cfoutput></td>
  </tr>
  <tr>
    <td colspan="4" height="25">Cinsiyet: <cfif get_emp_detail.SEX eq 0>Kadın<cfelseif get_emp_detail.SEX eq 1>Erkek</cfif>
    </td>
    <td>Baba Adı : <cfoutput>#get_emp_detail.father#</cfoutput></td>
  </tr>
  <tr>
    <td colspan="5" height="25">193 Sayılı Gelir
      Kanununun 31 nci maddesi kapsamında olanlar için doldurulacaktır.</td>
  </tr>
  <tr>
    <td colspan="4" height="25">Sakatlık Derecesi
      %</td>
    <td> Sakatlık Vergi Dilimi :&nbsp;&nbsp; 1
      <input type="checkbox" name="vergi1" id="vergi1" value="1"<cfif get_in_out.DEFECTION_LEVEL eq 1> checked</cfif> disabled>
      2
      <input type="checkbox" name="vergi2" id="vergi2" value="2"<cfif get_in_out.DEFECTION_LEVEL eq 2> checked</cfif> disabled>
      3
      <input type="checkbox" name="vergi3" id="vergi3" value="3"<cfif get_in_out.DEFECTION_LEVEL eq 3> checked</cfif> disabled>
    </td>
  </tr>
  <tr>
    <td colspan="5" height="25">3-Sandık Bilgileri
      (Bu bölüm sigortalı 506 sayılı kanunun geçici 20 nci maddesi kapsamında
      bir sandığa bağlı ise doldurulur.)</td>
  </tr>
  <tr>
    <td colspan="4" height="25">Sandık Adı:</td>
    <td>Sigortalı Sandık Sicil no</td>
  </tr>
  <tr>
    <td colspan="5" height="25">4-SİGORTALININ İŞYERİNDEKİ ÇALIŞMA BİLGİLERİ</td>
  </tr>
  <tr>
    <td colspan="4" height="25">İşe Giriş Tarihi (gün/ay/yıl)  : <cfif len(get_in_out.start_date)><cfoutput>#dateformat(get_in_out.start_date,dateformat_style)#</cfoutput><cfelse>.../.../.....</cfif></td>
    <td>İşten Çıkış Tarihi (gün/ay/yıl) : 
      <cfif len(get_in_out.finish_date)><cfoutput>#dateformat(get_in_out.finish_date,dateformat_style)#</cfoutput><cfelse>.../.../.....</cfif></td>
  </tr>
  <tr>
    <td colspan="4" height="25">İşten Çıkış Nedeni :
		<cfset sira_ = listfindnocase(iab_real_list,get_in_out.explanation_id)>
		<cfset sira_1 = listgetat(iab_iskur_list,sira_)>
		<cfset name_ = listgetat(iab_name_list,sira_1)>
		<cfoutput>#name_#</cfoutput>
	</td>
    <td>İşyerindeki Görevi : 
	<cfif get_position.recordcount><cfoutput>#get_position.position_name#</cfoutput></cfif>
	</td>
  </tr>
  <tr>
    <td colspan="5" height="25">Son Aldığı Aylık Net Ücret : &nbsp;&nbsp;&nbsp;
		<cfoutput>#TLFormat(get_last_net_salary.NET_UCRET)#</cfoutput>
	</td>
  </tr>
  <tr>
    <td colspan="5" height="25">İşten çıkış
      tarihinide kapsayan son 120 gün içinde işyerindeki kayıtları <br/>
      (En son çalışan ay en üst satırda başlayarak geriye doğru doldurulacaktır.) </td>
  </tr>
  <tr>
    <td width="50" height="25">Yıl</td>
    <td width="50">Ay</td>
    <td width="100">Aylık Prime Esas Brüt Kazanç</td>
    <td width="50">Aylık Prim Gün Sayısı</td>
    <td>Ay içinde eksik prim gün sayısı var ise nedeni (Bu bölüme arka
      sayfada listelenen nedenlerden bir veya birkaçı yazılacaktır.)</td>
  </tr>
  <cfset TEMP_DAYS = 0>
  <cfset row_counter_temp = 0>
  <cfoutput query="get_emp_puantajs">
	  <cfif TEMP_DAYS LTE 120>
		  <cfset TEMP_DAYS = TEMP_DAYS + TOTAL_DAYS>
			<cfset row_counter_temp = row_counter_temp + 1>
		
		<cfset bu_ay_basi = createdate(sal_year,sal_mon, 1)>
		<cfset bu_ay_sonu = date_add('s',-1,date_add('m',1,bu_ay_basi))>

		<cfquery name="get_izins" datasource="#dsn#">
			SELECT
				OFFTIME.EMPLOYEE_ID,
				SETUP_OFFTIME.EBILDIRGE_TYPE_ID,
				SETUP_OFFTIME.SIRKET_GUN,
				OFFTIME.STARTDATE
			FROM
				OFFTIME, SETUP_OFFTIME
			WHERE
				SETUP_OFFTIME.OFFTIMECAT_ID = OFFTIME.OFFTIMECAT_ID
				AND SETUP_OFFTIME.IS_PAID = 0 
				AND OFFTIME.IS_PUANTAJ_OFF = 0
				AND OFFTIME.VALID = 1
				AND OFFTIME.STARTDATE <= #bu_ay_sonu#
				AND OFFTIME.FINISHDATE >= #bu_ay_basi#
				AND OFFTIME.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
			ORDER BY
				OFFTIME.EMPLOYEE_ID
		</cfquery>
		<cfscript>
			eksik_neden_id = '';
			if (izin gt 0)
			{
			get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #attributes.EMPLOYEE_ID#");
			eksik_neden_id = get_emp_izins_2.EBILDIRGE_TYPE_ID;
			if (not len(eksik_neden_id)) eksik_neden_id = 13;
			if (get_emp_izins_2.recordcount gte 2)
				for (geii=2; geii lte get_emp_izins_2.recordcount; geii=geii+1)
					if (get_emp_izins_2.EBILDIRGE_TYPE_ID[geii-1] neq get_emp_izins_2.EBILDIRGE_TYPE_ID[geii])
						eksik_neden_id = 12; // birden fazla
			}
		</cfscript>
		  <tr>
			<td height="20">#SAL_YEAR#&nbsp;</td>
			<td>#SAL_MON#&nbsp;</td>
			<td>
			<cfif sal_year gt 2004>
			<cfset TEMP = ssk_matrah>
			<cfelse>
			<cfset TEMP = (round(ssk_matrah / 10000)/100)>
			</cfif>
			#TLFormat(TEMP)# </td>
			<td><cfif TOTAL_DAYS gt 30>30<cfelse>#TOTAL_DAYS#</cfif>&nbsp;</td>
			<td>&nbsp;
			<cfif len(eksik_neden_id)>
				(#eksik_neden_id#) - 
				<cfif eksik_neden_id eq 1>İstirahat
				<cfelseif eksik_neden_id eq 2>Ücretsiz İzin
				<cfelseif eksik_neden_id eq 3>Disiplin Cezası
				<cfelseif eksik_neden_id eq 4>Gözaltına Alınma
				<cfelseif eksik_neden_id eq 5>Tutukluluk
				<cfelseif eksik_neden_id eq 6>Kısmi İstihdam
				<cfelseif eksik_neden_id eq 7>Puantaj Kayıtları
				<cfelseif eksik_neden_id eq 8>Grev
				<cfelseif eksik_neden_id eq 9>Lokavt
				<cfelseif eksik_neden_id eq 10>GHE Olaylar
				<cfelseif eksik_neden_id eq 11>Doğal Afet
				<cfelseif eksik_neden_id eq 12>Birden Fazla
				<cfelseif eksik_neden_id eq 13>Diğer
				</cfif>
			<cfelse>
				&nbsp;
			</cfif>
			</td>
		  </tr>
	  </cfif>
  </cfoutput>
	<cfloop from="1" to="#5-row_counter_temp#" index="tempo">
		  <tr>
			<td height="20">&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
	</cfloop>
  <cfset TEMP_TOTAL_DAYS = 0>
  <cfoutput query="get_emp_last_3_years">
	  <cfset TEMP_TOTAL_DAYS = TEMP_TOTAL_DAYS + get_emp_last_3_years.TOTAL_PAID>
  </cfoutput>
  <tr>
    <td colspan="5" height="25">Son üç yıl içinde bu işyerindeki işsizlik sigortası prim ödeme gün sayısı : &nbsp;&nbsp;&nbsp;<cfoutput>#TEMP_TOTAL_DAYS#</cfoutput></td>
  </tr>
  <tr>
    <td colspan="5" height="25">5-BİLDİRGE İŞLEMLERİ</td>
  </tr>
  <tr>
    <td colspan="5" height="25">Bildirgenin verileceği İŞKUR Brimi:<cfoutput>#get_in_out.ISKUR_BRANCH_NAME#</cfoutput></td>
  </tr>
  <tr>
    <td colspan="4" height="25">Düzenleme Tarihi (gün/ay/yıl): <cfoutput>#dateformat(now(),dateformat_style)#</cfoutput></td>
    <td>Sigortalıya tebliğ tarihi(gün/ay/yıl) : ......./........./.........</td>
  </tr>
  <tr>
    <td colspan="4" valign="top">
      <table width="240">
        <tr>
          <td colspan="3"> Bu bildirgede yer alan
            tüm bilgilerin tam ve doğru olduğunu, yanlış veya eksik bilgiler
            bulunması halinde kurumca yapılacak haksız ve fazla ödemelerden doğabilecek
            her türlü sorumluluğun tarafıma ait olacağını kabul ederim. <br/>
            <br/>
          </td>
        </tr>
        <tr>
          <td width="50">&nbsp;</td>
          <td align="center">İŞVEREN YETKİLİ</td>
          <td width="10">&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td align="center">Adı Soyadı, Ünvanı, İmza, Kaşe</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td align="center">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td align="center">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table>
    </td>
    <td valign="top">
      <table width="97%">
        <tr>
          <td colspan="3"> Bu bildirgede yer alan
            tüm bilgilerin tam ve doğru olduğunu, yanlış veya eksik bilgiler
            bulunması halinde kurumca yapılacak haksız ve fazla ödemelerden doğabilecek
            her türlü sorumluluğun tarafıma ait olacağını kabul ederim. <br/>
            <br/>
            <br/>
          </td>
        </tr>
        <tr>
          <td width="50">&nbsp;</td>
          <td align="center">SİGORTALI</td>
          <td width="10">&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td align="center">Adı Soyadı,İmza</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td align="center"><cfoutput>#get_emp_detail.employee_name# #get_emp_detail.employee_surname#</cfoutput>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
        <tr>
          <td>&nbsp;</td>
          <td align="center">&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
 <!--- </form> --->
</table>

<br/>
<cfif isdefined("attributes.gonderildi")>
<script type="text/javascript">
window.print();
</script>
</cfif>
