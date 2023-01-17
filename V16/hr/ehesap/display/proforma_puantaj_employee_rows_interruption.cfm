<cfsetting showdebugoutput="no">

<cfset p_baslangic = createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,1))>
<cfset aydaki_gun_sayisi = daysinmonth(p_baslangic)>
<cfset p_bitis = createodbcdatetime(createdatetime(attributes.sal_year,attributes.sal_mon,aydaki_gun_sayisi))>


<cfquery name="get_emps" datasource="#dsn#">
SELECT
	E.EMPLOYEE_ID,
	E.EMPLOYEE_NAME,
	E.EMPLOYEE_SURNAME,
	EIO.IN_OUT_ID,
	EIO.START_DATE,
	EIO.FINISH_DATE,
	EIO.DUTY_TYPE,
	EIO.SSK_STATUTE,
	EI.TC_IDENTY_NO
FROM
	EMPLOYEES_IN_OUT EIO,
	EMPLOYEES_IDENTY EI,
	EMPLOYEES E
WHERE
	EIO.BRANCH_ID = #attributes.ssk_office# AND
	EIO.START_DATE <= #p_bitis# AND
	(EIO.FINISH_DATE >= #p_baslangic# OR EIO.FINISH_DATE IS NULL) AND
	EI.EMPLOYEE_ID = E.EMPLOYEE_ID AND
	E.EMPLOYEE_ID = EIO.EMPLOYEE_ID
ORDER BY
	E.EMPLOYEE_NAME ASC,
	E.EMPLOYEE_SURNAME ASC
</cfquery>

<cfif not get_emps.recordcount>
	<cf_get_lang dictionary_id='33572.Çalışan bulunamadı'>!
	<cfexit method="exittemplate">
</cfif>
<cfset in_out_ids = valuelist(get_emps.IN_OUT_ID)>

<cfquery name="get_salary_pay" datasource="#dsn#">
	SELECT
		COMMENT_GET_ID,
		COMMENT_GET,
		AMOUNT_GET,
		IN_OUT_ID,
		METHOD_GET,
		FROM_SALARY,
		ISNULL((SELECT SL.ITEM FROM SETUP_LANGUAGE_INFO AS SL WHERE (SL.UNIQUE_COLUMN_ID= SP.COMMENT_GET_ID OR SL.ITEM = SP.COMMENT_GET) AND SL.TABLE_NAME= 'SETUP_PAYMENT_INTERRUPTION' AND SL.LANGUAGE='#ucase(session.ep.language)#' GROUP BY SL.ITEM),COMMENT_GET) AS COMMENT_GET_NAME
	FROM
		SALARYPARAM_GET SP
	WHERE
		SP.START_SAL_MON <= #attributes.sal_mon# AND 
		SP.END_SAL_MON >= #attributes.sal_mon# AND
		SP.TERM = #attributes.sal_year# AND
		SP.IN_OUT_ID IN (#in_out_ids#)
</cfquery>

<cfquery name="get_names" dbtype="query">
	SELECT DISTINCT COMMENT_GET_ID,COMMENT_GET,FROM_SALARY,METHOD_GET,COMMENT_GET_NAME FROM get_salary_pay
</cfquery>

<cfoutput query="get_salary_pay">
	<cfif isdefined("kesinti_#COMMENT_GET_ID#_#IN_OUT_ID#")>
		<cfset "kesinti_#COMMENT_GET_ID#_#IN_OUT_ID#" = evaluate("kesinti_#COMMENT_GET_ID#_#IN_OUT_ID#") + AMOUNT_GET>
	<cfelse>
		<cfset "kesinti_#COMMENT_GET_ID#_#IN_OUT_ID#" = AMOUNT_GET>
	</cfif>
	
	<cfif METHOD_GET eq 1>
		<cfif isdefined("total_kesinti_#COMMENT_GET_ID#")>
			<cfset "total_kesinti_#COMMENT_GET_ID#" = evaluate("total_kesinti_#COMMENT_GET_ID#") + AMOUNT_GET>
		<cfelse>
			<cfset "total_kesinti_#COMMENT_GET_ID#" = AMOUNT_GET>
		</cfif>
	</cfif>
</cfoutput>

<cf_ajax_list>
	<thead>
        <tr>
			<th><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
			<th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			<cfoutput query="get_names">
				<th style="text-align:right;">#COMMENT_GET_NAME # (<cfif FROM_SALARY eq 0><cf_get_lang dictionary_id='56257.Brüt'><cfelse><cf_get_lang dictionary_id='58083.Net'></cfif>  <cfif METHOD_GET eq 1>+<cfelse>%</cfif>)</th>
			</cfoutput>
		</tr>
	</thead>
	<tbody>
	<cfset gun_toplam = 0>
    <cfset p_toplam = 0>
    <cfset e_toplam = 0>
    <cfset i_toplam = 0>
    <cfset a_toplam = 0>
	<cfoutput query="get_emps">
		<cfset employee_id_ = employee_id>
		<cfset in_out_id_ = in_out_id>
		<cfif year(start_date) eq year(p_baslangic) and month(start_date) eq month(p_baslangic)>
			<cfset kisi_start = start_date>
			<cfset bu_ay_basladi = 1>
		<cfelse>
			<cfset kisi_start = p_baslangic>
			<cfset bu_ay_basladi = 0>
		</cfif>
		<cfif len(FINISH_DATE) and year(FINISH_DATE) eq year(p_bitis) and month(FINISH_DATE) eq month(p_bitis)>
			<cfset kisi_finish= FINISH_DATE>
			<cfset bu_ay_cikti = 1>
		<cfelse>
			<cfset kisi_finish = p_bitis>
			<cfset bu_ay_cikti = 0>
		</cfif>
		<cfset calisma_gun_sayisi = datediff('d',kisi_start,kisi_finish)+1>

		<cfset reel_calisma_gun_sayisi = datediff('d',kisi_start,kisi_finish)+1>
		<cfif isdefined("kisi_ucretsiz_total_#employee_id#")>
			<cfset calisma_gun_sayisi = calisma_gun_sayisi - evaluate("kisi_ucretsiz_total_#employee_id#")>
		</cfif>
		
		<cfif calisma_gun_sayisi eq 31>
			<cfset calisma_gun_sayisi = 30>
		</cfif>
		<cfset gun_toplam = gun_toplam + calisma_gun_sayisi>
		<tr class="color-row">
			<td>#currentrow#</td>
			<td>
            	<cfif listgetat(session.ep.user_level, 3)>
                    <a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" target="hr_profil">#tc_identy_no#</a>
                <cfelse>
                    #tc_identy_no#
                </cfif>
            </td>
			<td style="font-weight:bold;color:<cfif bu_ay_basladi eq 1>green<cfelseif bu_ay_cikti eq 1>red<cfelseif reel_calisma_gun_sayisi lt aydaki_gun_sayisi>blue</cfif>;" nowrap="nowrap">
            	#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#
            	<cfif DUTY_TYPE eq 6>(<cf_get_lang dictionary_id='55896.Kısmi İstihdam'>)</cfif>
                 <cfif SSK_STATUTE eq 2 or SSK_STATUTE eq 18>(<cf_get_lang dictionary_id='58541.Emekli'>)</cfif><!---Muzaffer Yeraltı Emeli--->
            </td>
			<cfloop query="get_names">
				<td style="text-align:right;"><cfif isdefined("kesinti_#COMMENT_GET_ID#_#in_out_id_#")>#evaluate("kesinti_#COMMENT_GET_ID#_#in_out_id_#")#<cfelse>-</cfif></td>
			</cfloop>
		</tr>
	</cfoutput>
	</tbody>
	<tfoot>
		<tr>
			<td></td>
			<td></td>
			<td><cf_get_lang dictionary_id='57492.Toplam'></td>
			<cfoutput query="get_names">
				<th style="text-align:right;"><cfif isdefined("total_kesinti_#COMMENT_GET_ID#")>#evaluate("total_kesinti_#COMMENT_GET_ID#")#<cfelse>-</cfif></th>
			</cfoutput>
		</tr>
	</tfoot>
</cf_ajax_list>