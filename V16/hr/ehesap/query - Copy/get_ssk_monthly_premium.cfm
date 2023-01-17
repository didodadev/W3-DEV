<cfquery name="C2" dbtype="query">
	SELECT 
		EMPLOYEE_ID,
		SSK_STATUTE,
		SEX
	FROM 
		get_puantaj_rows
	WHERE 
		START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#">
		AND START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#">
</cfquery>

<cfquery name="C4" dbtype="query">
	SELECT 
		EMPLOYEE_ID,
		SSK_STATUTE,
		SEX
	FROM 
		get_puantaj_rows
	WHERE 
		FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_basi#">
		AND FINISH_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#bu_ay_sonu#">
</cfquery>

<cfif len(valuelist(C2.employee_id))>
	<cfquery name="A2" dbtype="query">
		SELECT EMPLOYEE_ID FROM C2 WHERE SSK_STATUTE=3 OR SSK_STATUTE=4
	</cfquery>
	<cfquery name="E2" dbtype="query">
		SELECT EMPLOYEE_ID FROM C2 WHERE SEX = 0
	</cfquery>
	<cfquery name="F2" datasource="#dsn#">
		SELECT OFFTIME.EMPLOYEE_ID FROM OFFTIME, SETUP_OFFTIME
		WHERE
			OFFTIME.EMPLOYEE_ID IN (#valuelist(C2.employee_id)#) AND OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
			OFFTIME.IS_PUANTAJ_OFF = 0 AND
			OFFTIME.VALID = 1 AND SETUP_OFFTIME.IS_PAID = 1 AND
			OFFTIME.STARTDATE >= #BU_AY_BASI# AND OFFTIME.FINISHDATE < #BU_AY_SONU#
	</cfquery>
<cfelse>
	<cfset A2.recordcount = 0>
	<cfset E2.recordcount = 0>
	<cfset F2.recordcount = 0>
</cfif>	
<cfif get_puantaj_rows.recordcount>
	<cfquery name="A3" dbtype="query">
		SELECT EMPLOYEE_ID FROM get_puantaj_rows WHERE SSK_STATUTE=3 OR SSK_STATUTE=4
	</cfquery>
	<cfquery name="E3" dbtype="query">
		SELECT EMPLOYEE_ID FROM get_puantaj_rows WHERE SEX = 0
	</cfquery>
	<cfquery name="F3" dbtype="query">
		SELECT DISTINCT get_puantaj_rows.EMPLOYEE_ID FROM get_izins, get_puantaj_rows WHERE get_izins.IS_PAID = 1 AND get_puantaj_rows.EMPLOYEE_ID = get_izins.EMPLOYEE_ID
	</cfquery>
<cfelse>
	<cfset A3.recordcount = 0>
	<cfset E3.recordcount = 0>
	<cfset F3.recordcount = 0>
</cfif>
<cfif len(valuelist(C4.employee_id))>
	<cfquery name="A4" dbtype="query">
		SELECT EMPLOYEE_ID FROM C4 WHERE SSK_STATUTE=3 OR SSK_STATUTE=4
	</cfquery>
	<cfquery name="E4" dbtype="query">
		SELECT EMPLOYEE_ID FROM C4 WHERE SEX = 0
	</cfquery>
	<cfquery name="F4" dbtype="query">
		SELECT DISTINCT C4.EMPLOYEE_ID FROM get_izins, C4 WHERE get_izins.IS_PAID = 1 AND C4.EMPLOYEE_ID = get_izins.EMPLOYEE_ID
	</cfquery>
<cfelse>
	<cfset A4.recordcount = 0>
	<cfset E4.recordcount = 0>
	<cfset F4.recordcount = 0>
</cfif>	
<cfset A5 = 0>
<cfset A6 = 0>
<cfset C5 = 0>
<cfset C6 = 0>
<cfset toplam_issizlik = 0>
<cfset E5 = 0>
<cfset E6 = 0>
<cfset F5 = 0>
<cfset F6 = 0>
<cfset F5_ = 0>
<cfset F6_ = 0>
<cfif a3.recordcount>
	<cfquery name="get_emp_puantaj" dbtype="query">
		SELECT SUM(SSK_MATRAH) AS A6, SUM(TOTAL_DAYS) AS A5 FROM get_puantaj_rows WHERE PUANTAJ_ID = #GET_PUANTAJ.PUANTAJ_ID# AND EMPLOYEE_ID IN (#VALUELIST(A3.EMPLOYEE_ID)#)
	</cfquery>
	<cfif len(get_emp_puantaj.A5) and len(get_emp_puantaj.A6)>
		<cfset A5 = GET_EMP_PUANTAJ.A5>
		<cfset A6 = GET_EMP_PUANTAJ.A6>
	</cfif>
</cfif>
<cfif get_puantaj_rows.recordcount>
	<cfquery name="get_emp_puantaj" dbtype="query">
		SELECT SUM(SSK_MATRAH) AS C6,SUM(TOTAL_DAYS) AS C5,SUM(ISSIZLIK_ISVEREN_HISSESI + ISSIZLIK_ISCI_HISSESI) AS toplam_issizlik FROM get_puantaj_rows WHERE PUANTAJ_ID = #GET_PUANTAJ.PUANTAJ_ID#
	</cfquery>
	<cfif len(get_emp_puantaj.C5)>
		<cfset C5 = GET_EMP_PUANTAJ.C5>
	</cfif>
	<cfif len(get_emp_puantaj.C6)>
		<cfset C6 = GET_EMP_PUANTAJ.C6>
	</cfif>
	<cfif len(get_emp_puantaj.toplam_issizlik)>
		<cfset toplam_issizlik = GET_EMP_PUANTAJ.toplam_issizlik>
	</cfif>
</cfif>
<cfif e3.recordcount>
	<cfquery name="get_emp_puantaj" dbtype="query">
		SELECT SUM(SSK_MATRAH) AS E6, SUM(TOTAL_DAYS) AS E5 FROM get_puantaj_rows WHERE PUANTAJ_ID = #GET_PUANTAJ.PUANTAJ_ID# AND EMPLOYEE_ID IN (#VALUELIST(E3.EMPLOYEE_ID)#)
	</cfquery>
	<cfif len(get_emp_puantaj.E5) and len(get_emp_puantaj.E6)>
		<cfset E5 = GET_EMP_PUANTAJ.E5>
		<cfset E6 = GET_EMP_PUANTAJ.E6>
	</cfif>
</cfif>

<cfif F3.recordcount>
	<cfoutput query="get_puantaj_rows">
		<cfscript>
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0 AND IS_PAID = 0");
				if(get_emp_izins_2.recordcount) izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else izin_paid_yaz = izin_paid;
				if(total_days gt 0)
					izin_paid_amount = (SSK_MATRAH * (izin_paid_yaz / total_days));
				else
					izin_paid_amount = 0;
				}
			else
				{
				izin_paid = 0;
				izin_paid_yaz = 0;
				izin_paid_amount = 0;
				}
			F5 = F5 + izin_paid_yaz;
			F6 = F6 + izin_paid_amount;
		</cfscript>
	</cfoutput>
</cfif>
<!--- ucretsiz izinliler --->
<cfset kisi_sayi = 0>
<cfoutput query="get_puantaj_rows">
	<cfscript>
	if (izin gt 0)
	{
		kisi_sayi = kisi_sayi + 1;
		F5_ = F5_ + izin;
	}
	</cfscript>
</cfoutput>
<!--- //ucretsiz izinliler --->
