<!--- hedef için performans sonucu mektup printti--->
<cfsetting showdebugoutput="no">
<cfquery name="get_perf" datasource="#dsn#">
	SELECT     
		*
	FROM
		EMPLOYEE_PERFORMANCE
	WHERE
		PER_ID=#attributes.iid#
</cfquery>

<cfif get_perf.recordcount>
<cfquery name="CHECK" datasource="#dsn#">
	SELECT
		ASSET_FILE_NAME3
	FROM
	   OUR_COMPANY
	WHERE
	<cfif isDefined("SESSION.EP.COMPANY_ID")>
	    COMP_ID = #SESSION.EP.COMPANY_ID#
	<cfelseif isDefined("SESSION.PP.COMPANY")>	
	    COMP_ID = #SESSION.PP.COMPANY#
	</cfif> 
</cfquery>

<cfquery name="get_emp" datasource="#dsn#">
	SELECT EMPLOYEE_NAME,EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID=#get_perf.emp_id#
</cfquery>
	<cfif get_emp.recordcount>
	<cfquery name="get_dep" datasource="#dsn#">
		SELECT
			EMPLOYEE_POSITIONS.POSITION_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_ID,
			BRANCH.BRANCH_NAME,
			DEPARTMENT.DEPARTMENT_HEAD
		FROM 
			EMPLOYEE_POSITIONS,
			DEPARTMENT,
			BRANCH 
		WHERE
			EMPLOYEE_POSITIONS.EMPLOYEE_ID=#get_perf.emp_id# AND
			EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND
			DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID
	</cfquery>
	</cfif>




<cfset total_puan_ = 0>
<cfset kisi_say_ = 0>
<cfif LEN(get_perf.PERFORM_POINT)>
	<cfif len(get_perf.USER_POINT)>
		<cfset total_puan_ = total_puan_ + get_perf.USER_POINT>
		<cfset kisi_say_ = 1>
	</cfif>
	<cfif len(get_perf.MANAGER_POINT)>
		<cfset total_puan_ = total_puan_ + get_perf.MANAGER_POINT>
		<cfset kisi_say_ = kisi_say_ + 1>
	</cfif>
	<cfset user_point_over_5_raw = wrk_round((total_puan_/kisi_say_) / get_perf.PERFORM_POINT * 100)>
<cfelse>
	<cfset user_point_over_5_raw = 0>
</cfif>


<table style="width:210mm;height:297mm;" cellpadding="0" cellspacing="0" border="0" >
	<tr>
		<td style="width:5mm;"></td>
		<td style="height:15mm"></td>
		<td style="width:10mm">&nbsp;</td>
	<tr>
		<td style="width:5mm;"></td>
		<td valign="top">
			<table cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td valign="top" style="height:25mm" colspan="2">
						<table width="100%">
							<tr>
								<td><cfif len(CHECK.asset_file_name3)><cfoutput><img src="#user_domain##file_web_path#settings/#CHECK.asset_file_name3#" border="0"></cfoutput></cfif></td>
								<td style="text-align:right;" width="100%"><cfoutput>#dateformat(now(),dateformat_style)#</cfoutput></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td valign="top" colspan="2"><cfoutput>#get_emp.employee_name# #UCase(get_emp.employee_surname)#<br />#get_dep.POSITION_NAME#</cfoutput></td>
				</tr>
				<tr>
					<td valign="top" colspan="2" style="height:40mm"><cfif get_dep.recordcount><cfoutput>#get_dep.branch_name# (#get_dep.department_head#)</cfoutput></cfif></td>
				</tr>
				<tr>
					<td colspan="2">Sayın <cfoutput>#get_emp.employee_surname#</cfoutput>, <br/><br/><br/><br/></td>
				</tr>
				<tr>
					<td colspan="2"><cfoutput>#dateformat(get_perf.start_date,'YYYY')# Yılı Performans Değerlendirme Sistemi dahilinde yapılan değerlendirmeniz sonucunda 
						Performans Değerlendirme Notunuz 
						<b>#user_point_over_5_raw# 
						(<cfset myNumber = user_point_over_5_raw>
						<cf_n2txt number="myNumber" para_birimi="." alt_para_birimi=" ">
						<cfoutput>#myNumber#</cfoutput>)
						</b> puandır.
						Almış olduğunuz puanın denk geldiği başarı kategorisi aşağıda belirtilmiştir. 
						<br/>
						<br/>
						Başarı Kategoriniz : 
						<b>
						<cfif user_point_over_5_raw  lte 30>
							Zayıf
						<cfelseif user_point_over_5_raw gte 31 and user_point_over_5_raw lte 50>
							Geliştirilmeli
						<cfelseif user_point_over_5_raw gte 51 and user_point_over_5_raw lte 60>
							Yeterli
						<cfelseif user_point_over_5_raw gte 61 and user_point_over_5_raw lte 80>
							İyi
						<cfelseif user_point_over_5_raw gte 81 and user_point_over_5_raw lte 100>
							Çok İyi												
						</cfif>
						</b>
						</cfoutput>
						<br/><br/><br/> 
					</td>
				</tr>
				<tr>
					<td style="height:75mm; width:75%;">Saygılarımızla, <br/><br/>
					İnsan Kaynakları Müdürlüğü<br/><br/><br/><br/>
					</td>
					<td style="height:75mm;"><br/><br/>
					Çalışanın İmzası / Tarih<br/><br/><br/><br/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
					<table>
						<tr>
							<td colspan="2" class="txtbold">Performans Geliştirme ve Değerlendirme Kategorisi</td>
						</tr>
						<tr>
							<td>PD Notu 1 (0-30)</td>
							<td>: Zayıf</td>
						</tr>
						<tr>
							<td>PD Notu 2 (31-50)</td>
							<td>: Geliştirilmeli</td>
						</tr>
						<tr>
							<td>PD Notu 3 (51-60)</td>
							<td>: Yeterli</td>
						</tr>
						<tr>
							<td>PD Notu 4 (61-80)</td>
							<td>: İyi</td>
						</tr>
						<tr>
							<td> PD Notu 5 (81-100)</td>
							<td> : Çok İyi</td>
						</tr>												
					</table>
					</td>
				</tr>
			</table>
		</td>
		<td style="width:15mm">&nbsp;</td>
	</tr>
</table>
</cfif>
