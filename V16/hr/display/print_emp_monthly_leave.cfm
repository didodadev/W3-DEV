<cfset attributes.sal_mon_ = listgetat(attributes.woc_list,2,',')>
<cfset attributes.id = listgetat(listgetat(attributes.woc_list,3,','),2,'-')>
<cfset attributes.SSK_OFFICE_ = urlDecode(listgetat(listgetat(attributes.woc_list,3,','),1,'-'))>
<cfset attributes.SSK_OFFICE_ALL_ = urlDecode(listgetat(attributes.woc_list,3,','))>
<cfsetting showdebugoutput="no">
<cfscript>
	last_month_1 = CreateDateTime(session.ep.period_year, attributes.sal_mon_,1,0,0,0);
	last_month_30 = CreateDateTime(session.ep.period_year, attributes.sal_mon_,daysinmonth(last_month_1),23,59,59);
</cfscript> 
<cfif not isdefined("attributes.action_id")>
	<cfset attributes.employee_id = listdeleteduplicates(attributes.iid)>
<cfelse>
	<cfset attributes.employee_id = attributes.action_id>
</cfif>

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
		BRANCH.SSK_NO =#attributes.id# AND
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
		BRANCH.SSK_OFFICE = '#listgetat(attributes.SSK_OFFICE_,1,'-')#' AND
        BRANCH.SSK_NO = '#attributes.id#' AND
        EMPLOYEES.EMPLOYEE_ID =#attributes.employee_id# AND
        EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IDENTY.EMPLOYEE_ID AND
        EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_IN_OUT.EMPLOYEE_ID
    <cfif not session.ep.ehesap>
        AND BRANCH.BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# )
    </cfif>
        AND
        EMPLOYEES_IN_OUT.START_DATE <= #CREATEDATE(SESSION.EP.PERIOD_YEAR,ay,DAYSINMONTH(CREATEDATE(SESSION.EP.PERIOD_YEAR,ay,1)))#
        AND
        (
            (EMPLOYEES_IN_OUT.FINISH_DATE >= #CREATEDATE(SESSION.EP.PERIOD_YEAR,ay,1)#)
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
		OFFTIME.EMPLOYEE_ID,
		CASE
			WHEN OFFTIME.IN_OUT_ID IS NOT NULL THEN  OFFTIME.IN_OUT_ID
			WHEN OFFTIME.IN_OUT_ID IS NULL THEN (SELECT  TOP 1 IN_OUT_ID FROM EMPLOYEES_IN_OUT EIO WHERE EIO.EMPLOYEE_ID = OFFTIME.EMPLOYEE_ID AND EIO.BRANCH_ID = #GET_SSK_EMPLOYEES.BRANCH_ID# AND EIO.START_DATE <= #DATEADD('h',-session.ep.time_zone,last_month_30)# AND (EIO.FINISH_DATE IS NULL OR EIO.FINISH_DATE > #DATEADD('h',-session.ep.time_zone,last_month_1)#))
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
		OFFTIME.EMPLOYEE_ID =#attributes.employee_id# AND
		OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
		OFFTIME.STARTDATE <= #DATEADD('h',-session.ep.time_zone,last_month_30)# AND
		OFFTIME.FINISHDATE > #DATEADD('h',-session.ep.time_zone,last_month_1)#
</cfquery>
<cfoutput query="get_all_izin">
	<cfif IS_PAID eq 1 and EBILDIRGE_TYPE_ID neq 1 and (is_yearly eq 0 or not len(is_yearly)) and (SIRKET_GUN eq 0 or not len(SIRKET_GUN))>
		<cfset type_ = 'i'>
	<cfelseif is_yearly eq 1>
		<cfset type_ = 'y'>
	<cfelseif EBILDIRGE_TYPE_ID eq 15>
		<cfset type_ = 'd'>
	<cfelseif SIRKET_GUN gt 0 or EBILDIRGE_TYPE_ID eq 1>
		<cfset type_ = 'r'>
	<cfelse>
		<cfset type_ = 'u'>
	</cfif>
	<cfset 'calisan_durum_#day(STARTDATE)#_#THIS_IN_OUT#' = type_>
</cfoutput>

<cfquery name="get_all_ins" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_DAILY_IN_OUT WHERE SPECIAL_CODE = '#ay##SESSION.EP.PERIOD_YEAR##attributes.SSK_OFFICE_ALL_#' AND EMPLOYEE_ID = #attributes.employee_id# AND ISNULL(FROM_HOURLY_ADDFARE,0) = 0
</cfquery>
<cfoutput query="get_all_ins">
	<cfif IS_WEEK_REST_DAY eq 1>
		<cfset 'calisan_durum_#day(START_DATE)#_#get_all_ins.IN_OUT_ID#' = 2>
	<cfelseif is_puantaj_off eq 1>
		<cfset 'calisan_durum_#day(START_DATE)#_#get_all_ins.IN_OUT_ID#' = 'yg'>
	<cfelse>
		<cfset 'calisan_durum_#day(START_DATE)#_#get_all_ins.IN_OUT_ID#' = 1>
	</cfif>
</cfoutput>
<cfset aydaki_gun_sayisi = daysinmonth(last_month_1)>
<cfset gun=0>
<cfscript>
last_month_1 = CreateDateTime(session.ep.period_year,ay, 1,0,0,0);
last_month_30 = CreateDateTime(session.ep.period_year,ay, daysinmonth(last_month_1), 23,59,59);
if (len(GET_SSK_EMPLOYEES.start_date) and datediff("h",last_month_1,GET_SSK_EMPLOYEES.start_date) gte 0)
	last_month_1 = GET_SSK_EMPLOYEES.start_date;
last_month_1 = date_add("d",0,last_month_1);
if (len(GET_SSK_EMPLOYEES.finish_date) and datediff("d",GET_SSK_EMPLOYEES.finish_date,last_month_30) gt 0)
	last_month_30 = CreateDateTime(year(GET_SSK_EMPLOYEES.finish_date),month(GET_SSK_EMPLOYEES.finish_date),day(GET_SSK_EMPLOYEES.finish_date), 23,59,59);
</cfscript>	
<cfif get_ssk_employees.recordcount>
	<table class="print_page">
		<cfoutput query="get_ssk_employees">
			<cfset toplam_izin =0>
				<cfloop from="1" to="#aydaki_gun_sayisi#" index="i">
					<input type="hidden" value="0" name="day_#in_out_id#_#i#" id="day_#in_out_id#_#i#">
					<cfif day(last_month_1) lte i or day(last_month_30) gte i>
						<cfif isdefined("calisan_durum_#i#_#get_all_izin.THIS_IN_OUT#") and evaluate("calisan_durum_#i#_#get_all_izin.THIS_IN_OUT#") is 'u'>
							<cfset toplam_izin =toplam_izin+1>
						</cfif>
					</cfif>
				</cfloop>
			</cfoutput>
			<tr>
				<td>
					<cfoutput>
						<table>
								<tr class="row_border">
									<td style="padding:10px 0 0 0!important">
										<table class="print_header">
											<tr>
												<th class="print_title"><cf_get_lang dictionary_id="35914.AYLIK ÜCRETSİZ İZİN KAĞIDI"></th>
											</tr>
										</table>
									</td>
								</tr>
								<tr class="row_border">
									<td>
										#listgetat(ay_list(),ay,',')# #SESSION.EP.PERIOD_YEAR# <cf_get_lang dictionary_id="35913.ayında aşağıda belirtilen günlerde toplam"> ...<cfoutput>#toplam_izin#</cfoutput>... <cf_get_lang dictionary_id="35912.Ücretsiz izin kullandığımı ve ücretsiz izin kullanımının kendi özgür iradem sonucu olduğunu kabul ve beyan ederim"> <br/> <cf_get_lang dictionary_id="35911.Saygılarımla.">
									</td>
								</tr>
						</table>
						<br /><br />
						<tr>
							<td>
								<table class="print_border">
									<tr class="row_border">
										<td style="padding:10px 0 0 0!important">
											<table class="print_header">
												<tr>
													<th class="print_title">#listgetat(ay_list(),ay,',')# <cf_get_lang dictionary_id="35910.AYI"> #SESSION.EP.PERIOD_YEAR#</th>
												</tr>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</cfoutput>
				</td>
				<td>
					<table>
						<tr>
							<td valign="top">
								<table border="1" cellpadding="3" cellspacing="0" bordercolor="666666">
									<cfset ilk_blok=aydaki_gun_sayisi-16>
									<cfloop from="1" to="#aydaki_gun_sayisi-15#" index="j">
										<cfset gun=gun+1>
										<tr>
											<td><cfoutput>#gun# #dateformat(last_month_1,'mm yyyy')#</cfoutput></td>
											<td width="90" align="center">
											<cfoutput query="get_ssk_employees">
												<cfif isdefined("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") and evaluate("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") is 'u'>
													<cf_get_lang dictionary_id="43317.ÜCRETSİZ İZİN"> 
												<cfelseif isdefined("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") and evaluate("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") is 'd'>
													<cf_get_lang dictionary_id="40514.DEVAMSIZLIK">	
												<cfelseif isdefined("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") and evaluate("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") is 'r'>
													<cf_get_lang dictionary_id="35899.RAPORLU">
												<cfelseif isdefined("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") and (evaluate("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") is not '2' or evaluate("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") is not '1' or evaluate("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") is not 'd' or evaluate("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") is not 'r')>
													&nbsp;
												<cfelse>
													X	
												</cfif>
											</cfoutput>
											</td>
										</tr>
									</cfloop>
								</table>			
							</td>
							<td valign="top">
								<table border="1" cellpadding="3" cellspacing="0" bordercolor="666666">
									<cfset gun=0>
									<cfset ilk_blok=aydaki_gun_sayisi-15>
									<cfloop from="#aydaki_gun_sayisi-14#" to="#aydaki_gun_sayisi#" index="j">
										<cfset ilk_blok=ilk_blok+1>
										<tr>
											<td><cfoutput>#ilk_blok# #dateformat(last_month_1,'mm yyyy')#</cfoutput></td>
											<td width="90" align="center">
											<cfoutput query="get_ssk_employees">
												<cfif isdefined("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") and evaluate("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") is 'u'>
													<cf_get_lang dictionary_id="43317.ÜCRETSİZ İZİN"> 
												<cfelseif isdefined("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") and evaluate("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") is 'd'>
													<cf_get_lang dictionary_id="40514.DEVAMSIZLIK">	
												<cfelseif isdefined("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") and evaluate("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") is 'r'>
													<cf_get_lang dictionary_id="35899.RAPORLU">
												<cfelseif isdefined("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") and (evaluate("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") is not '2' or evaluate("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#")  is not '1' or evaluate("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") is not 'd' or evaluate("calisan_durum_#j#_#get_ssk_employees.IN_OUT_ID#") is not 'r')>
													&nbsp;
												<cfelse>
													X	
												</cfif>
											</cfoutput>
											</td>
										</tr>
									</cfloop>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr  class="print_footer">
				<td>
					<table width="50%">
						<tr>
							<td><u><cf_get_lang dictionary_id="56406.İşveren"></u></td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td><cf_get_lang dictionary_id="35893.Uygundur"></td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td>&nbsp;</td>
						</tr>
					</table>
				</td>
				<td>
					<table  width="50%">
						<tr>
							<td>&nbsp;</td>
							<td><u><cf_get_lang dictionary_id="35898.İzin Kullananın"></u></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td><cf_get_lang dictionary_id="57742.Tarih">.........../.........../................</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td><cf_get_lang dictionary_id="32370.Adı - Soyadı"> :<cfoutput>#get_ssk_employees.employee_name# #get_ssk_employees.employee_surname#</cfoutput></td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td><cf_get_lang dictionary_id="58957.İmza"></td>
						</tr>
					</table>
				</td>
			</tr>
	</table>
<table width="98%" border="0" cellspacing="0" cellpadding="0">

	<tr>
		<td align="center"><br />
		
		</td>
	</tr>
</table>
</cfif>

<script type="text/javascript">
function iframe_yazdir()
{
	parent.auto_print_page.focus(); 
	parent.auto_print_page.print();
}
</script>
