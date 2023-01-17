<!-- sil -->
<table cellspacing="1" cellpadding="2" width="100%" border="0" class="color-border">
<tr class="color-row">	
<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1' trail='0'>
</tr>
</table>
<!-- sil -->
<cfquery name="get_employee_detail" datasource="#dsn#">
	SELECT 
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME,
		EIO.SOCIALSECURITY_NO,
		B.BRANCH_NAME,
		B.SSK_NO,
		EIO.SSK_STATUTE,
		EIO.RETIRED_SGDP_NUMBER
	FROM
		EMPLOYEES_IN_OUT EIO,
		BRANCH B,
		EMPLOYEES E
	WHERE
		EIO.EMPLOYEE_ID = #attributes.employee_id# AND
		EIO.EMPLOYEE_ID = E.EMPLOYEE_ID AND
		EIO.FINISH_DATE IS NULL AND
		EIO.BRANCH_ID = B.BRANCH_ID
</cfquery>

<cfoutput>
<table style="width:200mm;height:275mm;" align="center">
	<tr>
		<td height="75">&nbsp;</td>
	</tr>
	<tr>
		<td class="formbold" height="30"><u>Ek -2 :</u></td>
	</tr>
	<tr>
		<td class="formbold" height="30" align="center"><u>TAAHHÜTNAME</u></td>
	</tr>
	<tr>
		<td class="formbold" height="30"><u>Konu:</u> Asgari Geçim İndirimi Aile Durum Bildirimi</td>
	</tr>
	<tr>
		<td height="25">
		<b>#get_employee_detail.SOCIALSECURITY_NO#</b> SSK sicil numarası ile şirketinizde çalışmaktayım.
		<br/><br/>
		Asgari Geçim İndiriminden faydalanabilmek için vermiş olduğum, Aile Durum Bildirim formundaki 
		bilgilerin doğruluğunu ve bu bilgilerde değişiklik olduğunda, bu değişiklikleri 1 ay içinde bildireceğimi taahhüt eder,
		beyan ettiğim bilgilerin yanlışlığından kaynaklanan her türlü cezai yaptırımı ve bu durumun iş aktimin işverence haklı nedenle
		feshine neden olacağını peşinen kabul ederim.
		<br/><br/><br/>
		<b>#get_employee_detail.EMPLOYEE_NAME# #get_employee_detail.EMPLOYEE_SURNAME#</b>	<br/>
		Tarih ve İmza		
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
</cfoutput>
