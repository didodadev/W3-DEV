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
<br/><br/>
<cfoutput>
<table align="center" cellpadding="0" cellspacing="0" width="700">
	<tr>
		<td class="headbold" height="35" align="center"><cf_get_lang dictionary_id="54004.İŞ KAZASI TUTANAĞI"></td>
	</tr>
</table>
<br/><br/>
<table align="center" cellpadding="0" cellspacing="0" width="700">
	<tr>
		<td class="headbold" height="35"><cf_get_lang dictionary_id="36245.İŞYERİNİN"> : </td>
	</tr>
</table>

<table align="center" cellpadding="3" cellspacing="0" width="700" border="1" bordercolor="000000">
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="34550.Şirket Ünvanı"></td>
		<td>#ssk.BRANCH_FULLNAME#</td>
	</tr>
	<tr height="30">
		<td><cf_get_lang dictionary_id="44617.İŞYERİ SİCİL NO"></td>
		<td>
		#ssk.ssk_m#
		#ssk.SSK_JOB#
		#ssk.SSK_BRANCH#
		#ssk.SSK_BRANCH_OLD#
		#ssk.SSK_NO#
		#ssk.SSK_CITY#
		#ssk.SSK_COUNTRY#
		#ssk.SSK_CD#
		</td>
	</tr>
</table>
<br/><br/>
<table align="center" cellpadding="0" cellspacing="0" width="700">
	<tr>
		<td class="headbold" height="35"><cf_get_lang dictionary_id="45049.İşçi"> : </td>
	</tr>
</table>
<table align="center" cellpadding="3" cellspacing="0" width="700" border="1" bordercolor="000000">
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="32370.ADI SOYADI"></td>
		<td>#get_fee.employee_name# #get_fee.employee_surname#</td>
	</tr>
	<tr height="30">
		<td><cf_get_lang dictionary_id="58714.SGK"> <cf_get_lang dictionary_id="51231.SİCİL NO"></td>
		<td>#DETAIL.SOCIALSECURITY_NO#</td>
	</tr>
	<tr height="30">
		<td><cf_get_lang dictionary_id="59461.YAPTIĞI İŞ"></td>
		<td>#get_fee.emp_work#&nbsp;</td>
	</tr>
	<tr height="30">
		<td><cf_get_lang dictionary_id="59462.KAZANIN OLUŞ ŞEKLİ"></td>
		<td>#get_fee.event#&nbsp;</td>
	</tr>
	<tr height="30">
		<td><cf_get_lang dictionary_id="59463.KAZANIN OLDUĞU TARİH VE SAAT"></td>
		<td>#dateformat(get_fee.event_date,dateformat_style)# <cfif len(get_fee.event_hour)>- #get_fee.event_hour#:#get_fee.event_min#</cfif></td>
	</tr>
</table>
<br/>
<table align="center" cellpadding="3" cellspacing="0" width="700" border="1" bordercolor="000000">
	<tr height="30">
		<td width="250"><cf_get_lang dictionary_id="53472.Olay Günündeki İşbaşı Saati"></td>
		<td><cfif len(get_fee.workstart)>#get_fee.workstart#</cfif>&nbsp;</td>
	</tr>
	<tr height="30">
		<td><cf_get_lang dictionary_id="59464.KAZA SONRASI UZUV KAYBI OLUP OLMADIĞI"></td>
		<td>#get_fee.DISMEMBERMENT#&nbsp;</td>
	</tr>
	<tr height="30">
		<td><cf_get_lang dictionary_id="59465.KAZADA BAŞKASININ KASITLI EYLEMİNİN OLUP OLMADIĞI"></td>
		<td>#get_fee.WILFUL_ERROR#&nbsp;</td>
	</tr>
</table>
<br/>
<table align="center" cellpadding="0" cellspacing="0" width="700">
	<tr>
		<td height="25" colspan="2">#dateformat(get_fee.fee_date,dateformat_style)#</td>
	</tr>
	<tr>
		<td height="25" colspan="2" align="center"><strong><cf_get_lang dictionary_id="31522.Tanıkların Ad ve Soyadları"></strong></td>
	</tr>
	<tr>
		<td width="50%" align="center">1-#get_fee.witness1#</td>
		<td width="50%" align="center">2-#get_fee.witness2#</td>
	</tr>
</table>
<br/><br/><br/><br/><br/><br/>
<table align="center" cellpadding="0" cellspacing="0" width="700">
	<tr>
		<td width="50%" align="center"><cf_get_lang dictionary_id="59466.BÖLÜM SORUMLUSU"></td>
		<td width="50%" align="center"><cf_get_lang dictionary_id="45050.İŞVEREN VEYA VEKİLİ"></td>
	</tr>
</table>
</cfoutput>
<script type="text/javascript">
	window.print();
</script>
