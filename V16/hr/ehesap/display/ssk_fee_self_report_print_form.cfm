<cfinclude template="../query/get_fee.cfm">
<cfquery name="DETAIL" datasource="#dsn#" maxrows="1">
	SELECT 
		BRANCH_ID,
		START_DATE,
		SOCIALSECURITY_NO,
		FINISH_DATE
	FROM
		EMPLOYEES_IN_OUT
	WHERE 
		IN_OUT_ID = #GET_FEE.in_out_id#
</cfquery>
<cfset my_branch_id = DETAIL.BRANCH_ID>
<cfquery name="SSK" datasource="#dsn#">
	SELECT 
		BRANCH.*,
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
		ED.LAST_SCHOOL,
		EI.FATHER,
		EI.BIRTH_DATE,
		EI.BIRTH_PLACE,
		EI.TC_IDENTY_NO
	FROM
		EMPLOYEES E,
		EMPLOYEES_DETAIL ED,
		EMPLOYEES_IDENTY EI
	WHERE
		E.EMPLOYEE_ID = #get_fee.EMPLOYEE_ID#
		AND ED.EMPLOYEE_ID = E.EMPLOYEE_ID
		AND EI.EMPLOYEE_ID = E.EMPLOYEE_ID
</cfquery>
<br/><br/>
<cfoutput>
<table align="center" cellpadding="0" cellspacing="0" width="700">
	<tr>
		<td class="headbold" height="35" align="center"><cf_get_lang dictionary_id="54005.İŞYERİ KAZA BİLDİRİM FORMU"></td>
	</tr>
	<tr>
		<td height="20"  style="text-align:right;"><cf_get_lang dictionary_id="56032.Düzenleme Tarihi"> : #dateformat(GET_FEE.FEE_DATE, dateformat_style)#</td>
	</tr>
</table>
<table align="center" cellpadding="3" cellspacing="0" width="700" border="1" bordercolor="000000">
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="59455.Bölge Müdürlüğü Sicil No"></td>
		<td>#ssk.WORK_ZONE_M# #ssk.WORK_ZONE_JOB# #ssk.WORK_ZONE_FILE# #ssk.WORK_ZONE_CITY# &nbsp;</td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="57571.Ünvan"></td>
		<td>#ssk.BRANCH_FULLNAME#</td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="58723.Adres"></td>
		<td>#ssk.BRANCH_ADDRESS#  #ssk.BRANCH_POSTCODE# #ssk.BRANCH_COUNTY# #ssk.BRANCH_CITY#</td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="53463.Olay Tarihi İşçi Sayısı"></td>
		<td>#get_fee.total_emp#</td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="48266.Kaza Tarihi"></td>
		<td>#dateformat(get_fee.event_date,dateformat_style)# <cfif len(get_fee.event_hour)>- #get_fee.event_hour#:#get_fee.event_min#</cfif></td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="59456.Kazanın Meydana Geldiği Bölüm"></td>
		<td>#get_fee.place#</td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="45488.Kaza Gününde İşbaşı Saati"></td>
		<td><cfif len(get_fee.workstart)>#get_fee.workstart#</cfif>&nbsp;</td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="59457.Kazanın Ortaya Çıkardığı Maddi Zarar"></td>
		<td>&nbsp;</td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="32370.Adı Soyadı"></td>
		<td>#get_fee.employee_name# #get_fee.employee_surname#</td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="53903.Sigorta Sicil No"></td>
		<td>#detail.SOCIALSECURITY_NO#</td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="30496.Yaş"></td>
		<td><cfif len(get_emp_detail.birth_date)>#datediff("yyyy",get_emp_detail.birth_date,now())#</cfif></td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="38923.İşe Giriş Tarihi"></td>
		<td>#dateformat(detail.start_date,dateformat_style)#</td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="45497.Esas İşi"></td>
		<td>#get_fee.emp_work#</td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="45696.Kaza Anında Yaptığı İş"></td>
		<td>#get_fee.emp_work#</td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="59458.Kaza Sonucu ölü,yaralı sayısı"></td>
		<td>&nbsp;</td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="59459.Kaza Sonucu yaralanan işçilerden istirahat alanların sayısı"></td>
		<td>&nbsp;</td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="31522.Tanıkların Ad ve Soyadları"></td>
		<td>1-#get_fee.witness1# 2-#get_fee.witness2#</td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="45674.Kazanın sebebi"></td>
		<td>#get_fee.event#</td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="59460.Kazada ölenin eşinin yoksa yakınının adı soyadı"></td>
		<td>&nbsp;</td>
	</tr>
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="38974.İkamet Adresi"></td>
		<td>#get_emp_detail.HOMEADDRESS# #get_emp_detail.HOMECOUNTY# &nbsp;</td>
	</tr>
</table>
<br/>
<table align="center" cellpadding="0" cellspacing="0" width="700">
	<tr>
		<td height="20"  style="text-align:right;"><cf_get_lang dictionary_id="45901.İşveren veya vekilinin"> <cf_get_lang dictionary_id="57570.Ad Soyad"> <cf_get_lang dictionary_id="58957.imza"></td>
	</tr>
</table>
</cfoutput>
<script type="text/javascript">
	window.print();
</script>
