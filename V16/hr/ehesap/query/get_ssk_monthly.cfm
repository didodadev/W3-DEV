<cfquery name="C2" dbtype="query">
	SELECT 
		EMPLOYEE_ID 
	FROM 
		GET_PUANTAJ_ROWS
	WHERE 
		START_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#BU_AY_BASI#"> AND
		START_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#BU_AY_SONU#">
</cfquery>

<cfquery name="C4" dbtype="query">
	SELECT 
		EMPLOYEE_ID 
	FROM 
		GET_PUANTAJ_ROWS
	WHERE 
		FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#BU_AY_BASI#"> AND
		FINISH_DATE < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#BU_AY_SONU#">
</cfquery>

<cfset C5 = 0>
<cfset C6 = 0>

<cfif get_puantaj_rows.recordcount>
	<cfquery name="get_emp_puantaj" dbtype="query">
		SELECT
			SUM (SSK_MATRAH) AS C6,
			SUM (TOTAL_DAYS) AS C5
		FROM
			get_puantaj_rows
	</cfquery>
	<cfif len(get_emp_puantaj.C5) and len(get_emp_puantaj.C6)>
		<cfset C5 = GET_EMP_PUANTAJ.C5>
		<cfset C6 = GET_EMP_PUANTAJ.C6>
	</cfif>

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

<cfset F5 = 0>
<cfset F6 = 0>
<cfif F3.recordcount>
	<cfoutput query="get_puantaj_rows">
		<cfscript>
			if (izin_paid gt 0)
				{
				get_emp_izins_2 = cfquery(datasource : "yok", dbtype : "query", sqlstring : "SELECT EBILDIRGE_TYPE_ID FROM get_izins WHERE EMPLOYEE_ID = #EMPLOYEE_ID# AND SIRKET_GUN > 0 AND IS_PAID = 0");
				if(get_emp_izins_2.recordcount) 
					izin_paid_yaz = izin_paid - (2*get_emp_izins_2.recordcount);
				else 
					izin_paid_yaz = izin_paid ;
				izin_paid_amount = (SSK_MATRAH * (izin_paid_yaz / total_days));
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
<cfset F5_ = 0>
<cfoutput query="get_puantaj_rows">
	<cfscript>
	if (izin gt 0)
	{
		kisi_sayi = kisi_sayi + 1;
		F5_ = F5_ + izin;
	}
	</cfscript>
</cfoutput>
