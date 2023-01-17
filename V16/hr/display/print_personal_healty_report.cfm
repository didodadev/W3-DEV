<cfinclude template="../query/get_employee_healty_report.cfm">
<cfinclude template="../query/get_hr_name.cfm">
<cfinclude template="../query/get_hr.cfm">
<cfinclude template="../query/get_hr_detail.cfm">
<cfquery name="get_emp_branch" datasource="#DSN#">
	SELECT 
		BRANCH.BRANCH_ID 
	FROM 
		EMPLOYEE_POSITIONS EP,
		DEPARTMENT,
		BRANCH 
	WHERE 
		EP.EMPLOYEE_ID = #attributes.EMPLOYEE_ID# 
	AND 
		EP.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID 
	AND 
		DEPARTMENT.BRANCH_ID = BRANCH.BRANCH_ID
</cfquery>
<cfquery name="get_edu_inf" datasource="#dsn#" maxrows="1">
	SELECT EDU_TYPE FROM EMPLOYEES_APP_EDU_INFO WHERE EMPLOYEE_ID=#attributes.employee_id# ORDER BY EDU_START DESC
</cfquery>
<cfif LEN(get_emp_branch.BRANCH_ID)>
<cfset attributes.branch_id = get_emp_branch.BRANCH_ID>
<cfinclude template="../query/get_branches.cfm">
</cfif>
<cfif not isDefined("attributes.print")>
<cfelse>
	<script type="text/javascript">
	function waitfor(){
	window.close();
	}	
	setTimeout("waitfor()",3000);
	window.print();
	</script>
</cfif>
<table width="1000" align="center">
  <tr>
    <td align="center" class="formbold">
	<span class="headbold"><cf_get_lang dictionary_id="36247.SAĞLIK RAPORU"></span><br/>
	(<cf_get_lang dictionary_id="36246.Ağır ve Tehlikeli İşlerde Çalışanlara Ait">)
	</td>
  </tr>
</table>

<table width="1000" align="center">
  <tr>
    <td valign="top">
	<table width="99%" border="1" cellspacing="0" cellpadding="0" bordercolor="cccccc">
      <tr>
        <td width="65" align="center"><cf_get_lang dictionary_id="36245.İŞYERİNİN"></td>
        <td width="250" valign="top"><cf_get_lang dictionary_id="32328.Sicil No">:<cfoutput>#BRANCHES.SSK_NO# #BRANCHES.SSK_M# #BRANCHES.SSK_JOB# #BRANCHES.SSK_BRANCH# #BRANCHES.SSK_CITY# #BRANCHES.SSK_COUNTRY# #BRANCHES.SSK_CD#</cfoutput></td>
        <td valign="top"><cf_get_lang dictionary_id="36237.Adı,Adresi">:<cfoutput>#BRANCHES.BRANCH_FULLNAME# #BRANCHES.BRANCH_ADDRESS# #BRANCHES.BRANCH_COUNTY# #BRANCHES.BRANCH_CITY# #BRANCHES.BRANCH_POSTCODE#</cfoutput></td>
      </tr>
    </table>
	<br/>
	<cfoutput>
	<table width="99%" border="1" cellspacing="0" cellpadding="0" bordercolor="cccccc">
      <tr>
        <td width="65" align="center"><cf_get_lang dictionary_id="36236.Muayene Yapan Doktorun"></td>
        <td><cf_get_lang dictionary_id="57897.Adı">: #get_healty_report.doctor_name#
		<br/>
		<cf_get_lang dictionary_id="58550.Soyadı">: #get_healty_report.doctor_surname#
		</td>
        <td width="150"><cf_get_lang dictionary_id="53916.Görevi">: #get_healty_report.doctor_task#</td>
        <td width="150"><cf_get_lang dictionary_id="55695.Diploma No">: #get_healty_report.doctor_diploma_no#</td>
      </tr>
    </table>
	</cfoutput>
	<br/>
	<table width="99%" border="1" cellspacing="0" cellpadding="0" bordercolor="cccccc">
      <tr>
        <td width="65" rowspan="3" align="center"><cf_get_lang dictionary_id="36235.İŞÇİNİN"></td>
        <td><cf_get_lang dictionary_id="39269.Sigorta No">:<cfoutput>#GET_HR_DETAIL.SOCIALSECURITY_NO#</cfoutput></td>
        <td width="150"><cf_get_lang dictionary_id="32370.Adı Soyadı">:<cfoutput>#GET_HR_DETAIL.EMPLOYEE_NAME# #GET_HR_DETAIL.EMPLOYEE_SURNAME#</cfoutput></td>
        <td width="150"><cf_get_lang dictionary_id="36229.Doğum Yılı ve yeri">:<cfoutput>#dateformat(GET_HR_DETAIL.BIRTH_DATE,dateformat_style)# #GET_HR_DETAIL.BIRTH_PLACE#</cfoutput></td>
      </tr>
      <tr>
        <td><cf_get_lang dictionary_id="36228.Meslek ve tahsil durumu">: 
		<cfoutput>
		<cfif len(get_edu_inf.EDU_TYPE) and get_edu_inf.EDU_TYPE eq 1>
			<cf_get_lang dictionary_id="31688.İlk Okul">
		<cfelseif len(get_edu_inf.EDU_TYPE) and get_edu_inf.EDU_TYPE eq 2>
			<cf_get_lang dictionary_id="31291.Orta Okul">
		<cfelseif len(get_edu_inf.EDU_TYPE) and get_edu_inf.EDU_TYPE eq 3>
			<cf_get_lang dictionary_id="30480.Lise">
		<cfelseif len(get_edu_inf.EDU_TYPE) and get_edu_inf.EDU_TYPE eq 4>
			<cf_get_lang dictionary_id="29755.Üniversite">
		<cfelseif len(get_edu_inf.EDU_TYPE) and get_edu_inf.EDU_TYPE eq 5>
			<cf_get_lang dictionary_id="30483.Yüksek Lisans">
		</cfif>
		</cfoutput>
		</td>
        <td><cf_get_lang dictionary_id="35141.Askerlik Durumu">:
		<cfoutput>
		<cfif GET_HR_DETAIL.MILITARY_STATUS eq 0>
		<cf_get_lang dictionary_id='55624.Yapmadı'>
		<cfelseif GET_HR_DETAIL.MILITARY_STATUS eq 1> 
		<cf_get_lang dictionary_id='55625.Yaptı'>
		<cfelseif GET_HR_DETAIL.MILITARY_STATUS eq 2> 
		<cf_get_lang dictionary_id='55626.Muaf'>
		<cfelseif GET_HR_DETAIL.MILITARY_STATUS eq 3>
		<cf_get_lang dictionary_id='55627.Yabancı'>
		<cfelseif GET_HR_DETAIL.MILITARY_STATUS eq 4>
			<cf_get_lang dictionary_id="31214.Tecilli">
		</cfif>
		</cfoutput></td>
        <td><cf_get_lang dictionary_id="36227.Talip olduğu iş">:</td>
      </tr>
      <tr>
        <td height="50" valign="top"><cf_get_lang dictionary_id="30606.Ev Adresi">:
		<cfoutput>#GET_HR_DETAIL.HOMEADDRESS# #GET_HR_DETAIL.HOMECOUNTY# 
		<cfif len(get_hr_detail.homecity)><cfquery name="get_city" datasource="#dsn#">SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = #get_hr_detail.homecity#</cfquery>#GET_CITY.CITY_NAME#</cfif>
		#GET_HR_DETAIL.HOMEPOSTCODE#</cfoutput>
		</td>
        <td colspan="2" valign="top"><cf_get_lang dictionary_id="36225.İştirak Ettiği Kurs ve seminerler">:<cfoutput>#GET_HR_DETAIL.KURS1# #GET_HR_DETAIL.KURS2# #GET_HR_DETAIL.KURS3#</cfoutput></td>
        </tr>
    </table>	
</td>
    <td width="120" height="170">
		<!--- Resim --->
				<table width="100%" border="1" cellspacing="0" cellpadding="0" height="100%" bordercolor="cccccc">
					<tr>
						<td align="center">
							<cfif len(get_hr.photo)>
							     <cf_get_server_file output_file="hr/#get_hr.photo#" output_server="#get_hr.photo_server_id#" output_type="0"  image_width="105" image_height="136" image_link="1">
							<cfelse>
							 	<cf_get_lang dictionary_id="31495.Fotoğraf"> <br/>
								(<cf_get_lang dictionary_id="36224.4.5 ve 6 cm. boyunda olacak ve zamanla düşmeyecek şekilde yapıştırılacaktır.">)
							</cfif>
						</td>
					</tr>
				</table>
		<!--- Resim --->
	</td>
  </tr>
</table>
<cfoutput query="get_healty_report">
<table width="1000" align="center">
<tr>
<td width="50%" valign="top"> 
	<table width="99%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center" class="formbold"><cf_get_lang dictionary_id="36221.İŞÇİNİN ÖZ GEÇMİŞİ (İşveren dolduracaktır.)"></td>
  </tr>
</table>

	<table width="99%" border="1" cellspacing="0" cellpadding="0" bordercolor="cccccc">
  <tr>
    <td height="100" rowspan="4" valign="top"><cf_get_lang dictionary_id="55821.Konjenital ve diğer hastalıklar">: #konjentinal#</td>
    <td><cf_get_lang dictionary_id="58441.Kan Grubu">:</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="55793.Çiçek">: #cicek#</td>
  </tr>
  <tr>
    <td>B.C.G.: #bcg#</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="36292.Tetanoz">: #tetanoz#</td>
  </tr>
  <tr>
    <td height="50" rowspan="2" valign="top"><cf_get_lang dictionary_id="55819.İş Kazaları">: #is_kazasi#</td>
    <td><cf_get_lang dictionary_id="36280.Tüberkulin Testi">: #tiberkulin#</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="55742.Tanzim edilen veya edilmeyen meslek hastalıkları">:
	#meslek_hastalik#
	</td>
  </tr>
  <tr>
    <td height="50" rowspan="2" valign="top"><cf_get_lang dictionary_id="55818.Diğer Kazalar">: #diger_kaza#</td>
    <td><cf_get_lang dictionary_id="55746.Zehirlenmeler">: #zehirlenme#</td>
  </tr>
  <tr>
    <td><cf_get_lang dictionary_id="36278.Alerjik Durum">: #alerji#</td>
  </tr>
</table>
    <table width="99%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td height="30" align="center" class="formbold"><cf_get_lang dictionary_id="36268.TIBBİ MUAYENEYE GİRİŞ (İşveren dolduracaktır.)"></td>
  </tr>
</table>
<table width="99%" border="1" cellspacing="0" cellpadding="0" bordercolor="cccccc">
  <tr>
    <td height="30"><cf_get_lang dictionary_id="48153.Boy">: #boy#</td>
    <td><cf_get_lang dictionary_id="29784.Ağırlık">: #agirlik#</td>
    <td><cf_get_lang dictionary_id="36267.Göğüs çevresi(nefes alma verme)">: #gogus#</td>
  </tr>
  <tr>
    <td height="55" colspan="3" valign="top"><cf_get_lang dictionary_id="55635.Görünüş">:<br/>
	(<cf_get_lang dictionary_id="36264.Kuvvetli, normal, atletik, platorik, şişman, zayıf, çok zayıf, astonik, anemik">)<br/>
	#gorunus#
	</td>
    </tr>
</table>
</td>
<td  valign="top" style="text-align:right;">
	<table width="99%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="center" class="formbold"><cf_get_lang dictionary_id="36253.TIBBİ MUAYENELER (Dr. dolduracaktır.)"></td>
  </tr>
</table>
<table width="99%" border="1" cellspacing="0" cellpadding="0" bordercolor="cccccc">
  <tr>
    <td valign="top"><cf_get_lang dictionary_id="36853.DERİ (ÇEŞİTLİ BELİRTİLER)">:<br/>
	(<cf_get_lang dictionary_id="36852.Renk, tonüs, ödem, adenopati tümörle egzama, siflize dalalet eden araz">):<br/>
	#deri#	
	</td>
    </tr>
	  <tr>
    <td valign="top"><cf_get_lang dictionary_id="55717.İSKELET VE KAS SİSTEMİ">: <br/>
	(<cf_get_lang dictionary_id="36851.Gözle görülebilen şekil ve hakaret bozuklukları">):<br/>
	#iskelet_sistemi#
	</td>
    </tr>
	  <tr>
    <td valign="top"><cf_get_lang dictionary_id="55709.DUYU ORGANLARI">:<br/>
	<strong><cf_get_lang dictionary_id="55708.Göz"></strong>: #goz# &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong><cf_get_lang dictionary_id="55577.Burun"></strong>: #burun#<br/>
	<strong><cf_get_lang dictionary_id="55697.Kulak"></strong>: #kulak# &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong><cf_get_lang dictionary_id="55576.Boğaz"></strong>: #bogaz#
	</td>
    </tr>
	  <tr>
    <td valign="top"><cf_get_lang dictionary_id="55623.Ağız ve Dişler">: #agiz_dis#</td>
    </tr>
	  <tr>
    <td valign="top"><cf_get_lang dictionary_id="55606.DAHİLİYE">:<br/>
		<cf_get_lang dictionary_id="36850.Dolaşım Sistemi(Kan Basıncı)">:<br/> #dahiliye#
		
	</td>
    </tr>
	  <tr>
    <td valign="top"><cf_get_lang dictionary_id="36849.SOLUNUM SİSTEMİ (Akciğer Grafisi)">: <br/>
	#solunum_sistemi#
	</td>
    </tr>
	  <tr>
    <td valign="top"><cf_get_lang dictionary_id="55582.SİNDİRİM SİSTEMİ">:<br/>
	#sindirim_sistemi#
	</td>
    </tr>
	  <tr>
    <td valign="top"><cf_get_lang dictionary_id="55714.RUH VE SİNİR HASTALIKLARI">:<br/>
	(<cf_get_lang dictionary_id="36848.Epilepsi şüphesi verecek belirtiler dikkate alınmalıdır.">)<br/>
	#ruh_sinir#
	</td>
    </tr>
	  <tr>
    <td valign="top"><cf_get_lang dictionary_id="55713.ÜRO GENİTAL SİSTEM">:<br/>
	(<cf_get_lang dictionary_id="36937.Basit idrar tahlili. Lüzümda Wass.">)<br/>
	#uro_genital#
	</td>
    </tr>
</table>
</td>
</tr>
</table>
</cfoutput>
<script>
	window.print();
</script>
