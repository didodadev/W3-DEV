<cfsetting showdebugoutput="no">
<cfscript>
	last_month_1 = CreateDateTime(attributes.sal_year,1,1,0,0,0);
	last_month_12 = CreateDateTime(attributes.sal_year,12,1,0,0,0);
	last_month_30 = CreateDateTime(attributes.sal_year,12, daysinmonth(last_month_12), 23,59,59);
</cfscript>

<cfquery name="get_puantaj_rows" datasource="#dsn#">
	SELECT
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID,
		SUM(EMPLOYEES_PUANTAJ_ROWS.VERGI_IADESI) AS ASGARI_GECIM,
		EMPLOYEES_PUANTAJ.SAL_MON
	FROM
		EMPLOYEES_PUANTAJ_ROWS
		INNER JOIN EMPLOYEES_PUANTAJ ON EMPLOYEES_PUANTAJ_ROWS.PUANTAJ_ID = EMPLOYEES_PUANTAJ.PUANTAJ_ID
		INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID
		INNER JOIN BRANCH ON EMPLOYEES_PUANTAJ.SSK_OFFICE_NO = BRANCH.SSK_NO AND EMPLOYEES_PUANTAJ.SSK_OFFICE = BRANCH.SSK_OFFICE
	WHERE
		<cfif isdefined("attributes.ssk_office") and len(attributes.ssk_office)>
			EMPLOYEES_PUANTAJ.SSK_BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.ssk_office,3,'-')#"> AND
		</cfif>
		EMPLOYEES_PUANTAJ.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
		<cfif isdefined("attributes.zone_id") and len(attributes.zone_id)>
			AND BRANCH.ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone_id#">
		</cfif>
		<cfinclude template="../../query/get_emp_codes.cfm">
		<cfif fusebox.dynamic_hierarchy>
			<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
				<cfif database_type is "MSSQL">
					AND ('.' + EMPLOYEES.DYNAMIC_HIERARCHY + '.' + EMPLOYEES.DYNAMIC_HIERARCHY_ADD + '.') LIKE '%.#code_i#.%'
				<cfelseif database_type is "DB2">
					AND ('.' || EMPLOYEES.DYNAMIC_HIERARCHY || '.' || EMPLOYEES.DYNAMIC_HIERARCHY_ADD || '.') LIKE '%.#code_i#.%'
				</cfif>
			</cfloop>
		<cfelse>
			<cfloop list="#emp_code_list#" delimiters="+" index="code_i">
				<cfif database_type is "MSSQL">
					AND ('.' + EMPLOYEES.HIERARCHY + '.') LIKE '%.#code_i#.%'
				<cfelseif database_type is "DB2">
					AND ('.' || EMPLOYEES.HIERARCHY || '.') LIKE '%.#code_i#.%'
				</cfif>
			</cfloop>
		</cfif>
		<cfif not session.ep.ehesap><!--- ehesap yetkisi olmayan ve yetki kodu da bos olan (muhtemelen bir ozlukçudur) kisiler için sube yetkisine bakmali--->
			<cfif not len(session.ep.authority_code_hr)>
				AND BRANCH.BRANCH_ID IN (
											SELECT
												BRANCH_ID
											FROM
												EMPLOYEE_POSITION_BRANCHES
											WHERE
												EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
										)
			</cfif>
		</cfif>
	GROUP BY 
		EMPLOYEES_PUANTAJ_ROWS.EMPLOYEE_ID,
		EMPLOYEES_PUANTAJ.SAL_MON
</cfquery>

<cfif not get_puantaj_rows.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id ='53377.Puantaja Bağlı Satır Bulunamadı'>!");
	</script>
	<cfexit method="exittemplate">
</cfif>

<cfquery name="get_insurance" datasource="#dsn#">
	SELECT 
        STARTDATE, 
        FINISHDATE, 
        MIN_GROSS_PAYMENT_NORMAL 
    FROM 
	    INSURANCE_PAYMENT 
    WHERE 
    	STARTDATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#"> AND FINISHDATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#last_month_1#">
</cfquery>

<cfset emp_list = listdeleteduplicates(listsort(valuelist(get_puantaj_rows.employee_id),'numeric','ASC'))>

<cfquery name="get_employees_relatives" datasource="#dsn#">
	SELECT
		1 AS TYPE,
		ER.RELATIVE_LEVEL,
		ER.WORK_STATUS,
		ER.DISCOUNT_STATUS,
		ER.EDUCATION_STATUS,
		ER.BIRTH_DATE,
		E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		EMPLOYEES E,
		EMPLOYEES_RELATIVES ER
	WHERE
		E.EMPLOYEE_ID = ER.EMPLOYEE_ID AND
		ER.RELATIVE_LEVEL IN ('3','4','5') AND
		E.EMPLOYEE_ID IN (#emp_list#)	
UNION ALL
	SELECT
		2 AS TYPE,
		'' AS RELATIVE_LEVEL,
		0 AS WORK_STATUS,
		0 AS DISCOUNT_STATUS,
		0 AS EDUCATION_STATUS,
		EII.BIRTH_DATE,
		E.EMPLOYEE_ID,
		E.EMPLOYEE_NAME,
		E.EMPLOYEE_SURNAME
	FROM
		EMPLOYEES E,
		EMPLOYEES_IDENTY EII
	WHERE
		E.EMPLOYEE_ID = EII.EMPLOYEE_ID AND
		E.EMPLOYEE_ID IN (#emp_list#)		
</cfquery>

<cfquery name="get_employees_" dbtype="query">
	SELECT DISTINCT EMPLOYEE_ID,EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM get_employees_relatives ORDER BY EMPLOYEE_NAME,EMPLOYEE_SURNAME
</cfquery>

<cfset sayfa_no = 0>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default=#get_employees_.recordcount#>
<cfparam name="attributes.mode" default=12>
<cfparam name="attributes.totalrecords" default=#get_employees_.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cf_grid_list>
	<tr>
  		<cfif attributes.sal_year eq 2015>
  			<cfset colspan_ = 20>
  		<cfelse>
  			<cfset colspan_ = 17>
  		</cfif>
    	<td colspan="<cfoutput>#colspan_#</cfoutput>" class="printbold"><cf_get_lang dictionary_id ='53750.Asgari Ücretin Yıllık Brüt Tutarı'> : <cfoutput>#tlformat(get_insurance.min_gross_payment_normal*12)#</cfoutput></td>
  	</tr>
	<tr class="printbold" align="center">
		<td>&nbsp;</td>
		<td>1</td>
		<td <cfif attributes.sal_year eq 2015>colspan="2"</cfif>>2</td>
		<td <cfif attributes.sal_year eq 2015>colspan="2"</cfif>>3</td>
		<td <cfif attributes.sal_year eq 2015>colspan="2"</cfif>>4</td>
		<td colspan="12" align="center"><cf_get_lang dictionary_id ='53751.Yararlanılan Asgari Geçim İndirimi Tutarı'></td>
	</tr>
	<tr class="printbold" align="center">
		<td width="50" nowrap><cf_get_lang dictionary_id ='53109.Sıra No'></td>
		<td><cf_get_lang dictionary_id ='53752.Ücretlinin Adı Soyadı'></td>
		<td width="75"><cf_get_lang dictionary_id ='53753.Asgari Geçim İndirimi Oranı'> </td>
		<cfif attributes.sal_year eq 2015><td width="75"><cf_get_lang dictionary_id ='53753.Asgari Geçim İndirimi Oranı'> (<cf_get_lang dictionary_id="59511.Mayıs 2015 Sonrası">)</td></cfif>
		<td width="75"><cf_get_lang dictionary_id ='53754.Asgari Geçim İndirimine Esas Tutar'></td>
		<cfif attributes.sal_year eq 2015><td width="75"><cf_get_lang dictionary_id ='53754.Asgari Geçim İndirimine Esas Tutar'> (<cf_get_lang dictionary_id="59511.Mayıs 2015 Sonrası">)</td></cfif>
		<td width="75"><cf_get_lang dictionary_id ='53755.Aylık Asgari Geçim İndirimi Tutarı'></td>
		<cfif attributes.sal_year eq 2015><td width="75"><cf_get_lang dictionary_id ='53755.Aylık Asgari Geçim İndirimi Tutarı'> (<cf_get_lang dictionary_id="59511.Mayıs 2015 Sonrası">)</td></cfif>
		<td width="40" nowrap><cf_get_lang dictionary_id ='57592.OCAK'></td>
		<td width="40" nowrap><cf_get_lang dictionary_id ='57593.ŞUBAT'></td>
		<td width="40" nowrap><cf_get_lang dictionary_id ='57594.MART'></td>
		<td width="40" nowrap><cf_get_lang dictionary_id ='57595.NİSAN'></td>
		<td width="40" nowrap><cf_get_lang dictionary_id ='57596.MAYIS'></td>
		<td width="40" nowrap><cf_get_lang dictionary_id ='57597.HAZİRAN'></td>
		<td width="40" nowrap><cf_get_lang dictionary_id ='57598.TEMMUZ'></td>
		<td width="40" nowrap><cf_get_lang dictionary_id ='57599.AĞUSTOS'></td>
		<td width="40" nowrap><cf_get_lang dictionary_id ='57600.EYLÜL'></td>
		<td width="40" nowrap><cf_get_lang dictionary_id ='57601.EKİM'></td>
		<td width="40" nowrap><cf_get_lang dictionary_id ='57602.KASIM'></td>
		<td width="40" nowrap><cf_get_lang dictionary_id ='57603.ARALIK'></td>
	</tr>
	<cfscript>
		asgari_gecim_tutar_ = 0;
		asgari_gecim_tutar_mayis = 0;
		asgari_indirim_tutar_ = 0;
		asgari_indirim_tutar_mayis = 0;
		ay_1 = 0;
		ay_2 = 0;
		ay_3 = 0;
		ay_4 = 0;
		ay_5 = 0;
		ay_6 = 0;
		ay_7 = 0;
		ay_8 = 0;
		ay_9 = 0;
		ay_10 = 0;
		ay_11 = 0;
		ay_12 = 0;
	</cfscript>
	<cfoutput query="get_employees_">
		<cfscript>
			employee_id_ = employee_id;
			asgari_gecim_indirimi_ = 0;
			asgari_ucret_ = get_insurance.min_gross_payment_normal * 12;
			asgari_gecim_indirimi_yuzdesi_ = 50;
			asgari_gecim_indirimi_yuzdesi_mayis = 50;
			es_oran_ = 0;
			cocuk_oran_ = 0;
			cocuk_sayi_ = 0;
		</cfscript>
	
		<cfquery name="get_emp_relatives" dbtype="query">
			SELECT TYPE,RELATIVE_LEVEL,WORK_STATUS,DISCOUNT_STATUS,EDUCATION_STATUS,BIRTH_DATE FROM get_employees_relatives WHERE EMPLOYEE_ID = #employee_id_#
		</cfquery>

		<cfquery name="get_emp_finish" dbtype="query">
			SELECT * FROM get_employees_relatives WHERE EMPLOYEE_ID = #employee_id_#
		</cfquery>
	
		<cfquery name="get_asgaris" dbtype="query">
			SELECT * FROM get_puantaj_rows WHERE EMPLOYEE_ID = #employee_id_# ORDER BY SAL_MON ASC
		</cfquery>
	
		<cfset ay_list_ = valuelist(get_asgaris.sal_mon)>
		<cfset deger_list = valuelist(get_asgaris.asgari_gecim)>
		<cfloop query="get_emp_relatives">
			<cfif relative_level eq 3 and ((len(work_status) and work_status eq 0) or not len(work_status)) and es_oran_ eq 0 and discount_status eq 1>
				<cfset es_oran_ = 10>
				<cfset asgari_gecim_indirimi_yuzdesi_ = asgari_gecim_indirimi_yuzdesi_ + es_oran_>
				<cfset asgari_gecim_indirimi_yuzdesi_mayis = asgari_gecim_indirimi_yuzdesi_mayis + es_oran_>
			<cfelseif relative_level eq 4 and work_status neq 1 and discount_status eq 1 and education_status eq 1 and datediff("yyyy",birth_date,last_month_30) lte 25>
				<cfset cocuk_sayi_ = cocuk_sayi_ + 1>
			<cfelseif relative_level eq 4 and work_status neq 1 and discount_status eq 1 and datediff("yyyy",birth_date,last_month_30) lt 18>
				<cfset cocuk_sayi_ = cocuk_sayi_ + 1>
			<cfelseif relative_level eq 5 and work_status neq 1 and discount_status eq 1 and education_status eq 1 and datediff("yyyy",birth_date,last_month_30) lte 25>
				<cfset cocuk_sayi_ = cocuk_sayi_ + 1>
			<cfelseif relative_level eq 5 and work_status neq 1 and discount_status eq 1 and datediff("yyyy",birth_date,last_month_30) lt 18>
				<cfset cocuk_sayi_ = cocuk_sayi_ + 1>
			</cfif>
		</cfloop>
		<cfif attributes.sal_year lte 2015>
			<!--- <cfif cocuk_sayi_ gt 0 and cocuk_sayi_ lte 2> --->
			<cfif cocuk_sayi_ eq 1 or cocuk_sayi_ eq 2>
				<cfset asgari_gecim_indirimi_yuzdesi_ = asgari_gecim_indirimi_yuzdesi_ + (cocuk_sayi_ * 7.5)>
			<!--- <cfelseif cocuk_sayi_ gt 0 and cocuk_sayi_ eq 3> --->
			<cfelseif cocuk_sayi_ eq 3>
				<cfset asgari_gecim_indirimi_yuzdesi_ = asgari_gecim_indirimi_yuzdesi_ + (2 * 7.5) + 5>
			<!--- <cfelseif cocuk_sayi_ gt 0 and cocuk_sayi_ gte 4> --->
			<cfelseif cocuk_sayi_ gte 4>
				<cfset asgari_gecim_indirimi_yuzdesi_ = asgari_gecim_indirimi_yuzdesi_ + (2 * 7.5) + 5 + 5>
			</cfif>
		</cfif>
		<cfif attributes.sal_year gte 2015>
			<cfif cocuk_sayi_ gt 0 and cocuk_sayi_ lte 2>
		    	<cfset asgari_gecim_indirimi_yuzdesi_mayis = asgari_gecim_indirimi_yuzdesi_mayis + (cocuk_sayi_ * 7.5)>
		  	<cfelseif cocuk_sayi_ gt 0 and cocuk_sayi_ eq 3>
		    	<cfset asgari_gecim_indirimi_yuzdesi_mayis = asgari_gecim_indirimi_yuzdesi_mayis + (2 * 7.5) + 10>
			<cfelseif cocuk_sayi_ gt 0 and cocuk_sayi_ eq 4 and es_oran_ eq 0>
		   		<cfset asgari_gecim_indirimi_yuzdesi_mayis = asgari_gecim_indirimi_yuzdesi_mayis + (2 * 7.5) + 10 + 5>
			<cfelseif cocuk_sayi_ gt 0 and cocuk_sayi_ eq 4 and es_oran_ gt 0> <!---oranın % 85 i gecmemesi gerektigi icin tekrar duzenleme yapıldı --->
				<cfset asgari_gecim_indirimi_yuzdesi_mayis = asgari_gecim_indirimi_yuzdesi_mayis + (2 * 7.5) + 10>
			<cfelseif cocuk_sayi_ gt 0 and cocuk_sayi_ gte 5 and es_oran_ eq 0><!---oranın % 85 i gecmemesi gerektigi icin tekrar duzenleme yapıldı --->
				<cfset asgari_gecim_indirimi_yuzdesi_mayis = asgari_gecim_indirimi_yuzdesi_mayis + (2 * 7.5) + 10 + 5 + 5>
			<cfelseif cocuk_sayi_ gt 0 and cocuk_sayi_ gte 5 and es_oran_ gt 0><!---oranın % 85 i gecmemesi gerektigi icin tekrar duzenleme yapıldı --->
				<cfset asgari_gecim_indirimi_yuzdesi_mayis = asgari_gecim_indirimi_yuzdesi_mayis + (2 * 7.5) + 10>
			</cfif>
		</cfif>
  		<tr class="print" height="20">
    		<td nowrap class="printbold">#currentrow#</td>
    		<td>#employee_name# #employee_surname#</td>
    		<cfif attributes.sal_year lte 2015><td nowrap align="center">#asgari_gecim_indirimi_yuzdesi_#</td></cfif>
    		<cfif attributes.sal_year gte 2015><td nowrap align="center">#asgari_gecim_indirimi_yuzdesi_mayis#</td></cfif>
    		<cfif attributes.sal_year lte 2015><td nowrap align="center">#tlformat(asgari_ucret_ * asgari_gecim_indirimi_yuzdesi_ /100)#<cfset asgari_gecim_tutar_ = asgari_gecim_tutar_ + (asgari_ucret_ * asgari_gecim_indirimi_yuzdesi_ /100)></td></cfif>
    		<cfif attributes.sal_year gte 2015><td nowrap align="center">#tlformat(asgari_ucret_ * asgari_gecim_indirimi_yuzdesi_mayis /100)#<cfset asgari_gecim_tutar_mayis = asgari_gecim_tutar_mayis + (asgari_ucret_ * asgari_gecim_indirimi_yuzdesi_mayis /100)></td></cfif>
    		<cfif attributes.sal_year lte 2015><td nowrap align="center">#tlformat((asgari_ucret_ * asgari_gecim_indirimi_yuzdesi_ /100)*0.15/12)#<cfset asgari_indirim_tutar_ = asgari_indirim_tutar_ + ((asgari_ucret_ * asgari_gecim_indirimi_yuzdesi_ /100)*0.15/12)></td></cfif>
    		<cfif attributes.sal_year gte 2015><td nowrap align="center">#tlformat((asgari_ucret_ * asgari_gecim_indirimi_yuzdesi_mayis /100)*0.15/12)#<cfset asgari_indirim_tutar_mayis = asgari_indirim_tutar_mayis + ((asgari_ucret_ * asgari_gecim_indirimi_yuzdesi_mayis /100)*0.15/12)></td></cfif>
		    <cfloop from="1" to="12" index="ccm">
				<td nowrap>
					<cfif listfindnocase(ay_list_,ccm)>
						#tlformat(listgetat(deger_list,listfindnocase(ay_list_,ccm)))#
						<cfset 'ay_#ccm#' = evaluate("ay_#ccm#") + listgetat(deger_list,listfindnocase(ay_list_,ccm))>
					<cfelse>
						#tlformat(0)#
						<cfset 'ay_#ccm#' = evaluate("ay_#ccm#") + 0>
					</cfif>
				</td>
			</cfloop>
  		</tr>
	</cfoutput>
	<cfoutput>
		<tr class="printbold">
	  		<cfif attributes.sal_year eq 2015>
	  			<cfset colspan2_ = 4>
	  		<cfelse>
	  			<cfset colspan2_ = 3>
	  		</cfif>
	    	<td colspan="#colspan2_#" nowrap align="center"><cf_get_lang_main no ='80.toplam'></td>
			<cfif attributes.sal_year lte 2015><td nowrap align="center">#tlformat(asgari_gecim_tutar_)#</td></cfif>
			<cfif attributes.sal_year gte 2015><td nowrap align="center">#tlformat(asgari_gecim_tutar_mayis)#</td></cfif>
			<cfif attributes.sal_year lte 2015><td nowrap align="center">#tlformat(asgari_indirim_tutar_)#</td></cfif>
			<cfif attributes.sal_year gte 2015><td nowrap align="center">#tlformat(asgari_indirim_tutar_mayis)#</td></cfif>
			<cfloop from="1" to="12" index="cct">
				<td nowrap>#tlformat(evaluate("ay_#cct#"))#</td>
			</cfloop>
		</tr>
	</cfoutput>
</cf_grid_list>
