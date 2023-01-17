<cfscript>
	last_month_1 = CreateDateTime(session.ep.period_year, attributes.sal_mon_,1,0,0,0);
	last_month_30 = CreateDateTime(session.ep.period_year, attributes.sal_mon_,daysinmonth(last_month_1),23,59,59);
</cfscript>
<cfquery name="GET_CALENDER_OFFTIMES_" datasource="#DSN#">
	SELECT
		START_DATE,
		FINISH_DATE,
		OFFTIME_NAME
	FROM 
		SETUP_GENERAL_OFFTIMES
	ORDER BY
		START_DATE
</cfquery>
<cfset resmi_tatil_gunleri = ''>

<cfif GET_CALENDER_OFFTIMES_.recordcount>	
	<cfoutput query="GET_CALENDER_OFFTIMES_">
		<cfset off_name_ = OFFTIME_NAME>
		<cfset day_count = DateDiff("d",GET_CALENDER_OFFTIMES_.START_DATE,GET_CALENDER_OFFTIMES_.FINISH_DATE) + 1>
			<cfloop index="k" from="1" to="#day_count#">
				<cfset current_day = date_add("d", k-1, GET_CALENDER_OFFTIMES_.START_DATE)>
				<cfif not (year(now()) eq year(current_day) and month(now()) eq month(current_day) and day(now()) eq day(current_day))>
					<cfset resmi_tatil_gunleri = listappend(resmi_tatil_gunleri,"#dateformat(current_day,'yyyymmdd')#")>
				</cfif>
			</cfloop>
	</cfoutput>
</cfif>

<cfset attributes.SSK_OFFICE_ = urldecode(attributes.SSK_OFFICE_)>
<cfquery name="get_ssk_offices" datasource="#dsn#">
	SELECT
		BRANCH_ID,
		BRANCH_FULLNAME,	
		SSK_OFFICE,
		COMPANY_ID,
		SSK_NO,
		BRANCH_TAX_NO,
		BRANCH_TAX_OFFICE
	FROM
		BRANCH
	WHERE
		BRANCH.BRANCH_STATUS =1 AND
		BRANCH.SSK_NO = '#attributes.SSK_NO_#' AND
		BRANCH.SSK_OFFICE ='#attributes.SSK_OFFICE_#' AND
		BRANCH.SSK_BRANCH <> ''
	ORDER BY
		BRANCH_NAME,
		SSK_OFFICE
</cfquery>
<cfset sal_year_=session.ep.period_year>
<cfset ay =attributes.SAL_MON_>
<cfquery name="GET_SSK_EMPLOYEES" datasource="#DSN#">
	SELECT
		EMPLOYEES_IN_OUT.IS_PUANTAJ_OFF,
		EMPLOYEES_IN_OUT.IN_OUT_ID,
		EMPLOYEES_IN_OUT.DEPARTMENT_ID,
		EMPLOYEES_IN_OUT.EMPLOYEE_ID,
		EMPLOYEES_IN_OUT.POSITION_CODE,
		EMPLOYEES_IN_OUT.START_DATE,
		EMPLOYEES_IN_OUT.FINISH_DATE,
		EMPLOYEES_IN_OUT.VALID,
		EMPLOYEES_IN_OUT.POSITION_CODE,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IDENTY.TC_IDENTY_NO,
		EMPLOYEES_IN_OUT.SOCIALSECURITY_NO,
		BRANCH.BRANCH_ID
	FROM 
		EMPLOYEES_IN_OUT,
		EMPLOYEES_IDENTY,
		BRANCH,
		EMPLOYEES
	WHERE
		BRANCH.BRANCH_STATUS = 1 AND
		EMPLOYEES.EMPLOYEE_STATUS = 1 AND
		BRANCH.SSK_OFFICE = '#attributes.SSK_OFFICE_#' AND
		BRANCH.SSK_NO = '#attributes.SSK_NO_#' AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
		EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
	<cfif not session.ep.ehesap>
		AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# )
	</cfif>
		AND
		EMPLOYEES_IN_OUT.START_DATE <= #CREATEDATE(SESSION.EP.PERIOD_YEAR,attributes.SAL_MON_,DAYSINMONTH(CREATEDATE(SESSION.EP.PERIOD_YEAR,attributes.SAL_MON_,1)))#
		AND
		(
			(EMPLOYEES_IN_OUT.FINISH_DATE >= #CREATEDATE(SESSION.EP.PERIOD_YEAR,attributes.SAL_MON_,1)#)
			OR
			EMPLOYEES_IN_OUT.FINISH_DATE IS NULL
		)
		AND BRANCH.BRANCH_ID = EMPLOYEES_IN_OUT.BRANCH_ID
	ORDER BY
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME,
		EMPLOYEES_IN_OUT.IN_OUT_ID ASC
</cfquery>

<cfif not GET_SSK_EMPLOYEES.RecordCount>
	<script>
		alert("<cf_get_lang dictionary_id='33572.Çalışan bulunamadı'>!");
		window.close();
	</script>
	<cfabort>
</cfif>

<cfquery name="get_all_izin" datasource="#dsn#">
	SELECT 
		OFFTIME.STARTDATE,
		OFFTIME.FINISHDATE,
		OFFTIME.EMPLOYEE_ID,
		CASE
			WHEN OFFTIME.IN_OUT_ID IS NOT NULL
				THEN OFFTIME.IN_OUT_ID
			WHEN OFFTIME.IN_OUT_ID IS NULL
				THEN
				(
					SELECT
						IN_OUT_ID
					FROM
						EMPLOYEES_IN_OUT EIO
					WHERE
						EIO.EMPLOYEE_ID = OFFTIME.EMPLOYEE_ID AND
						EIO.BRANCH_ID = #GET_SSK_EMPLOYEES.BRANCH_ID# AND
						EIO.START_DATE <= #DATEADD('h',-session.ep.time_zone,last_month_30)# AND
						(
							EIO.FINISH_DATE IS NULL OR
							EIO.FINISH_DATE > #DATEADD('h',-session.ep.time_zone,last_month_1)#
						)
				)
		END
			AS THIS_IN_OUT,
		OFFTIME.STARTDATE,
		SETUP_OFFTIME.IS_PAID,
		SETUP_OFFTIME.IS_YEARLY,
		SETUP_OFFTIME.SIRKET_GUN,
		SETUP_OFFTIME.EBILDIRGE_TYPE_ID
	FROM 
		OFFTIME,
		SETUP_OFFTIME
	WHERE 
		OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
		OFFTIME.STARTDATE <= #DATEADD('h',-session.ep.time_zone,last_month_30)# AND
		OFFTIME.FINISHDATE > #DATEADD('h',-session.ep.time_zone,last_month_1)#
</cfquery>

<cfoutput query="get_all_izin">
	<cfscript>
		if (IS_PAID eq 1 and EBILDIRGE_TYPE_ID neq 1 and (is_yearly eq 0 or not len(is_yearly)) and (SIRKET_GUN eq 0 or not len(SIRKET_GUN)))
			type_ = 'i';
		else if (is_yearly eq 1)
			type_ = 'y';
		else if (EBILDIRGE_TYPE_ID eq 15)
			type_ = 'd';
		else if (SIRKET_GUN gt 0)
			type_ = 'r2';
		else if (EBILDIRGE_TYPE_ID eq 1 and (SIRKET_GUN eq 0 or SIRKET_GUN is 'NULL'))
			type_ = 'r';
		else if (EBILDIRGE_TYPE_ID eq 7)
			type_ = 'p';
		else
			type_ = 'u';
		total_izin_ = datediff('d',get_all_izin.startdate,get_all_izin.finishdate)+1;
		izin_startdate_ = date_add("h", session.ep.time_zone, get_all_izin.startdate); 
		izin_finishdate_ = date_add("h", session.ep.time_zone, get_all_izin.finishdate);
		for (mck_=0; mck_ lt total_izin_; mck_=mck_+1)
		{
			temp_izin_gunu_ = date_add("d",mck_,izin_startdate_);
			'calisan_durum_#day(temp_izin_gunu_)#_#THIS_IN_OUT#' = type_;
		}
	</cfscript>
</cfoutput>

<cfquery name="get_all_ins" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_DAILY_IN_OUT WHERE START_DATE >= #last_month_1# AND START_DATE <= #last_month_30#
</cfquery>
<cfoutput query="get_all_ins">
	<cfif IS_WEEK_REST_DAY eq 0>
		<cfset 'calisan_durum_#day(START_DATE)#_#in_out_id#' = 2>
	<cfelseif is_puantaj_off eq 1>
		<cfset 'calisan_durum_#day(START_DATE)#_#in_out_id#' = 'yg'>
	<cfelseif IS_WEEK_REST_DAY eq 1>
    	<cfset 'calisan_durum_#day(START_DATE)#_#in_out_id#' = 3>
    <cfelse>
		<cfset 'calisan_durum_#day(START_DATE)#_#in_out_id#' = 1>
	</cfif>
</cfoutput>

<cfset aydaki_gun_sayisi = daysinmonth(last_month_1)>
<table class="print_page">
	<tr>
		<td>
			<table width="100%">
				<tr class="row_border">
					<cfoutput>
						<td style="padding:10px 0 0 0!important">
							<table class="print_header">
								<tr>
									<th class="print_title">#GET_SSK_OFFICES.BRANCH_FULLNAME# #listgetat(ay_list(),ay,',')# <cf_get_lang dictionary_id='55762.AYI PERSONEL PUANTAJI'></th>
								</tr>
							</table>
						</td>
					</cfoutput>
				</tr>
			</table>
			<br /><br />
			<tr>
				<td>
					<table class="print_border">
						<tr>
							<th align="center"><cf_get_lang dictionary_id='56870.Personel'></th>
							<cfoutput><th colspan="#aydaki_gun_sayisi+3#" align="center"> #listgetat(ay_list(),ay,',')# #SESSION.EP.PERIOD_YEAR#</th></cfoutput>
							<th style="width:150px"><cf_get_lang dictionary_id='55753.Çalışma Günü'></th>
							<th style="width:150px"><cf_get_lang dictionary_id="31473.Resmi Tatil"></th>
							<th style="width:150px"><cf_get_lang dictionary_id='57434.Rapor'></th>
							<th style="width:150px"><cf_get_lang dictionary_id="56893.Devamsızlık"></th>
							<th style="width:150px"><cf_get_lang dictionary_id='58575.İzin'></th>
							<th style="width:150px"><cf_get_lang dictionary_id='43082.Yıllık İzin'> </th>
							<th style="width:150px"><cf_get_lang dictionary_id='55756.Ücretsiz İzin'></th>
							<th style="width:150px"><cf_get_lang dictionary_id='58956.Haftalık Tatil'></th>
							<th style="width:150px"><cf_get_lang dictionary_id='29482.Genel Tatil'></th>
							<th style="width:150px"><cf_get_lang dictionary_id='57492.Toplam'></th>
							<th style="width:150px"><cf_get_lang dictionary_id='58957.İmza'></th>
						</tr>
						<tr>
							<th style="width:150px"><cf_get_lang dictionary_id='55757.Adı Soyadı'></th>
							<th style="width:150px"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
							<th style="width:150px"><cf_get_lang dictionary_id='55663.SSK NO'> </th>
							<th style="width:150px"><cf_get_lang dictionary_id='58025.TC Kimlik No'></th>
							<input type="hidden" value="<cfoutput>#aydaki_gun_sayisi#</cfoutput>" name="gun_sayisi" id="gun_sayisi">
							<cfloop from="1" to="#aydaki_gun_sayisi#" index="j">
									<th width="10"><cfoutput>#j#</cfoutput></th>
							</cfloop>
						</tr>
						<cfif get_ssk_employees.recordcount>
								<cfscript>
									last_month_1 = CreateDateTime(session.ep.period_year,ay, 1,0,0,0);
									last_month_30 = CreateDateTime(session.ep.period_year,ay, daysinmonth(last_month_1), 23,59,59);
									if (datediff("h",last_month_1,GET_SSK_EMPLOYEES.start_date) gte 0)
										last_month_1 = GET_SSK_EMPLOYEES.start_date;
									last_month_1 = date_add("d",0,last_month_1);
									if (len(GET_SSK_EMPLOYEES.finish_date) and datediff("d",GET_SSK_EMPLOYEES.finish_date,last_month_30) gt 0)
										last_month_30 = CreateDateTime(year(GET_SSK_EMPLOYEES.finish_date),month(GET_SSK_EMPLOYEES.finish_date),day(GET_SSK_EMPLOYEES.finish_date), 23,59,59);
								</cfscript>	
							<cfoutput query="get_ssk_employees">
								<cfquery name="GET_POS_NAME" datasource="#dsn#">
									SELECT
										*
									FROM
										EMPLOYEE_POSITIONS EP,
										BRANCH B,
										DEPARTMENT D
									WHERE
										EP.IS_MASTER = 1 AND
										EP.DEPARTMENT_ID = #DEPARTMENT_ID# AND
										D.DEPARTMENT_ID = EP.DEPARTMENT_ID AND
										B.BRANCH_ID = D.BRANCH_ID
								</cfquery>
								<tr>
									<td>#employee_name# #employee_surname#</td>
									<td>#GET_POS_NAME.POSITION_NAME#</td>
									<td>#socialsecurity_no#</td>
									<td>#tc_identy_no#</td>
									<cfset toplam_work =0>
									<cfset toplam_devamsizlik = 0>
									<cfset toplam_rapor =0>
									<cfset toplam_izin =0>
									<cfset toplam_yizin =0>
									<cfset toplam_uizin =0>
									<cfset toplam_htizin =0>
									<cfset toplam_gtizin =0>
									<cfset toplam_yarim =0>
									<cfset toplam_resmi = 0>
									<cfloop from="1" to="#aydaki_gun_sayisi#" index="i">
											<cfset day_ = "#session.ep.period_year#">
											<cfif attributes.sal_mon_ gte 10>
												<cfset day_ = "#day_##attributes.sal_mon_#">
											<cfelse>
												<cfset day_ = "#day_#0#attributes.sal_mon_#">
											</cfif>
											<cfif i gte 10>
												<cfset day_ = "#day_##i#">
											<cfelse>
												<cfset day_ = "#day_#0#i#">
											</cfif>
										<cfif listfindnocase(resmi_tatil_gunleri,day_)>
											<cfset is_resmi_ = 1>
										<cfelse>
											<cfset is_resmi_ = 0>
										</cfif>
										<td <cfif listfindnocase(resmi_tatil_gunleri,day_)>class="color-list"</cfif>>
											<cfif day(last_month_1) lte i or day(last_month_30) gte i>
												<cfif isdefined("calisan_durum_#i#_#in_out_id#") and evaluate("calisan_durum_#i#_#in_out_id#") is '1'>
													<cfif is_resmi_ eq 1>
														RT
														<cfset toplam_resmi = toplam_resmi +1>
													<cfelse>					
														1
														<cfset toplam_work = toplam_work +1>
													</cfif>
												<cfelseif isdefined("calisan_durum_#i#_#in_out_id#") and evaluate("calisan_durum_#i#_#in_out_id#") is 'yg'>YG
													<cfset toplam_yarim =toplam_yarim+1>
												<cfelseif isdefined("calisan_durum_#i#_#in_out_id#") and evaluate("calisan_durum_#i#_#in_out_id#") is 'd'>D
													<cfset toplam_devamsizlik =toplam_devamsizlik+1>
												<cfelseif isdefined("calisan_durum_#i#_#in_out_id#") and evaluate("calisan_durum_#i#_#in_out_id#") is 'r'>R
													<cfset toplam_rapor =toplam_rapor+1>
												<cfelseif isdefined("calisan_durum_#i#_#in_out_id#") and evaluate("calisan_durum_#i#_#in_out_id#") is 'r2'>R2
													<cfset toplam_rapor =toplam_rapor+1>
												<cfelseif isdefined("calisan_durum_#i#_#in_out_id#") and evaluate("calisan_durum_#i#_#in_out_id#") is 'i'>I
													<cfset toplam_izin =toplam_izin+1>
												<cfelseif isdefined("calisan_durum_#i#_#in_out_id#") and evaluate("calisan_durum_#i#_#in_out_id#") is 'y'>Y
													<cfset toplam_yizin =toplam_yizin+1>
												<cfelseif isdefined("calisan_durum_#i#_#in_out_id#") and evaluate("calisan_durum_#i#_#in_out_id#") is 'u'>U
													<cfset toplam_uizin =toplam_uizin+1>
												<cfelseif isdefined("calisan_durum_#i#_#in_out_id#") and evaluate("calisan_durum_#i#_#in_out_id#") is '2'>HT
													<cfset toplam_htizin =toplam_htizin+1>
												<cfelseif isdefined("calisan_durum_#i#_#in_out_id#") and evaluate("calisan_durum_#i#_#in_out_id#") is '3'>GT
													<cfset toplam_gtizin =toplam_gtizin+1>
												<cfelse>
													0
												</cfif> 
											<cfelse>
											0
											<input type="hidden" value="0" name="day_#in_out_id#_#i#" id="day_#in_out_id#_#i#">
											</cfif>
										</td>
									</cfloop>
									<cfset toplam_=toplam_work+toplam_izin+toplam_yizin+toplam_htizin+toplam_gtizin+(toplam_yarim * 0.5)+toplam_rapor+toplam_resmi+toplam_devamsizlik>
									<td width="20"  style="text-align:right;">#tlformat(toplam_work + (toplam_yarim * 0.5))#</td>
									<td width="20"  style="text-align:right;">#toplam_resmi#</td>
									<td width="20"  style="text-align:right;">#toplam_rapor#</td>
									<td width="20"  style="text-align:right;">#toplam_devamsizlik#</td>
									<td width="20"  style="text-align:right;">#toplam_izin#</td>
									<td width="20"  style="text-align:right;">#toplam_yizin#</td>
									<td width="20"  style="text-align:right;">#toplam_uizin#</td>
									<td width="20"  style="text-align:right;">#toplam_htizin#</td>
									<td width="20"  style="text-align:right;">#toplam_gtizin#</td>
									<td style="text-align:right">#tlformat(toplam_)#</td>
									<td width="100"  style="text-align:right;"></td>
								</tr>
							</cfoutput>
						<cfelse>
							<tr height="22" class="color-row">
								<td colspan="<cfoutput>#aydaki_gun_sayisi+17#</cfoutput>"><cf_get_lang dictionary_id="58486.Kayıt Bulunamadı">!</td>
							</tr>
						</cfif>
					</table>
				</td>
			</tr>
		</td>
	</tr>
</table>
<script type="text/javascript">
function iframe_yazdir()
{
	parent.auto_print_page.focus(); 
	parent.auto_print_page.print();
}
</script>
