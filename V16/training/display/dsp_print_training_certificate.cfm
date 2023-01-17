<!--- scorm içerik paketleri eğitim katılım belgesi  toplu print
class_id gonderilir 
--->
<cfif isdefined("attributes.id") and len(attributes.id)>
	<cfquery name="get_sco" datasource="#dsn#">
		SELECT	
			DISTINCT
			SCO.SCO_ID,
			SCO.NAME,
			E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS ADSOYAD
		FROM 
			TRAINING_CLASS_SCO SCO,
			TRAINING_CLASS_SCO_DATA SCO_DATA,
			EMPLOYEES E,
			EMPLOYEE_POSITIONS EP,
			DEPARTMENT D,
			BRANCH B,
			OUR_COMPANY C
		WHERE
			SCO.SCO_ID = SCO_DATA.SCO_ID AND
			SCO_DATA.USER_TYPE = 0 AND
			SCO_DATA.USER_ID = E.EMPLOYEE_ID AND
			E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
			EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
			D.BRANCH_ID = B.BRANCH_ID AND
			B.COMPANY_ID = C.COMP_ID AND
			SCO.CLASS_ID = #attributes.id# 
		UNION
		SELECT 
			DISTINCT
			SCO.SCO_ID,
			SCO.NAME,
			CP.COMPANY_PARTNER_NAME+' '+CP.COMPANY_PARTNER_SURNAME AS ADSOYAD
		FROM 
			TRAINING_CLASS_SCO SCO,
			TRAINING_CLASS_SCO_DATA SCO_DATA,
			COMPANY_PARTNER CP,
			COMPANY C
		WHERE
			SCO.SCO_ID = SCO_DATA.SCO_ID AND
			SCO_DATA.USER_TYPE = 1 AND
			SCO_DATA.USER_ID = CP.PARTNER_ID AND
			CP.COMPANY_ID = C.COMPANY_ID AND
			SCO.CLASS_ID = #attributes.id# 
		UNION 
		SELECT 
			DISTINCT
				SCO.SCO_ID,
				SCO.NAME,
				C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS ADSOYAD
			FROM 
				TRAINING_CLASS_SCO SCO,
				TRAINING_CLASS_SCO_DATA SCO_DATA,
				CONSUMER C
			WHERE
				SCO.SCO_ID = SCO_DATA.SCO_ID AND
				SCO_DATA.USER_TYPE = 2 AND
				SCO_DATA.USER_ID = C.CONSUMER_ID AND
				SCO.CLASS_ID = #attributes.id# 
	</cfquery>
	<cfoutput query="get_sco">
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<title>Katılım Sertifikası</title>
	<style type="text/css">
	.tarih {
		font-family: Georgia, "Times New Roman", Times, serif;
		font-size: 18px;
		color: ##383838;
		font-style: italic;
	}
	.yazi1 {
		font-family: "Arial Narrow", Arial;
		font-size: 24px;
		line-height: 55px;
		color: ##383838;
	}
	.yazi2 {
		font-family: Georgia, "Times New Roman", Times, serif;
		font-size: 25px;
		font-style: italic;
		color: ##10155e;
	}
	</style></head>
	
	<body>
	<cfif currentrow gt 1><div style="page-break-after: always"></div></cfif>
	<table border="0" background="/documents/templates/worknet/tasarim/katilim_sertifika_bg.png" style="height:525px;width:700px;text-align:center;" cellpadding="30" cellspacing="0">
	  <tr>
		<td valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td  style="height:25;" colspan="3">&nbsp;</td>
		  </tr>
		  <tr>
			<td width="33%">&nbsp;</td>
			<td width="33%"><img src="/documents/templates/worknet/tasarim/katilim_sertifika_logo.png" width="211" height="95" /></td>
			<td width="33%" style="text-align:right" valign="top" class="tarih">#dateformat(now(),dateformat_style)#</td>
		  </tr>
		  <tr>
			<td style="height:65;" colspan="3">&nbsp;</td>
			</tr>
		  <tr>
			<td colspan="3" style="text-align:center" class="yazi1">Sayın <span class="yazi2">#ADSOYAD#</span><br />
			  www.styleturkish.com portalında verilen<br />
			  <span class="yazi2">#NAME#</span><br />
			  Konulu E-Eğitim'e Katılmıştır.</td>
		  </tr>
		</table></td>
	  </tr>
	</table>
	</body>
	</html>
	</cfoutput>
</cfif>
