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
<cfif LEN(get_perf.USER_POINT) AND LEN(get_perf.PERFORM_POINT)>
	<cfset user_point_over_5_raw = 5*get_perf.USER_POINT / get_perf.PERFORM_POINT>
	<cfset user_point_over_5_raw = round(user_point_over_5_raw*100)/100>
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
					<td valign="top" style="height:25mm">
						<table width="100%">
							<tr>
								<td><cfif len(CHECK.asset_file_name3)><cfoutput><img src="#user_domain##file_web_path#settings/#CHECK.asset_file_name3#" border="0"></cfoutput></cfif></td>
								<td style="text-align:right;" width="100%"><cfoutput>#dateformat(now(),dateformat_style)#</cfoutput></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td valign="top"><cfoutput>#get_emp.employee_name# #UCase(get_emp.employee_surname)#</cfoutput></td>
				</tr>
				<tr>
					<td valign="top" style="height:40mm"><cfif get_dep.recordcount><cfoutput>#get_dep.branch_name# (#get_dep.department_head#)</cfoutput></cfif></td>
				</tr>
				<tr>
					<td>Sayın <cfoutput>#get_emp.employee_surname#</cfoutput>, <br/><br/><br/><br/></td>
				</tr>
				<tr>
					<td><cfoutput>#dateformat(get_perf.start_date,'YYYY')# Yılı Performans Geliştirme ve Değerlendirme Sistemi dahilinde yapılan değerlendirmeniz sonucunda 
						Performans Değerlendirme Notunuz <cfif len(user_point_over_5_raw)>#user_point_over_5_raw#<cfelse>-</cfif> olarak tespit edilmiştir ve bu puan performans kategorilerinden <cfif len(get_perf.user_point_over_5)>#get_perf.user_point_over_5#<cfelse>-</cfif>  tanımında yer almaktadır. 
						<br/>
						<br/>
						<cfif get_perf.user_point_over_5 eq 2 or get_perf.user_point_over_5 eq 2.5>
							Başarınızın gelecek dönemlerde artmasını dileriz.
						<cfelseif get_perf.user_point_over_5 eq 3>
							Başarınızın gelecek dönemlerde artarak devamını dileriz.
						<cfelseif get_perf.user_point_over_5 eq 3.5>
							Beklenenin üzerinde gösterdiğiniz performansınızdan dolayı sizi tebrik eder,  başarınızın gelecek dönemlerde artarak devamını dileriz.
						<cfelseif get_perf.user_point_over_5 eq 4>
							Başarılı performansınızdan dolayı sizi tebrik eder, başarınızın daha da artmasını dileriz.
						<cfelseif get_perf.user_point_over_5 eq 4.5>
							Üstün başarınızdan dolayı sizi tebrik eder, başarınızın daha da artmasını dileriz.
						<cfelseif get_perf.user_point_over_5 eq 5>
							Sıradışı performansınızdan dolayı sizi tebrik eder, başarınızın devamını dileriz.
						<cfelse>
							Gelecek dönemler için başarınızın artmasını dileriz.
						</cfif>
						</cfoutput>
						<br/><br/><br/> 
					</td>
				</tr>
				<tr>
					<td  style="height:75mm">Saygılarımızla, <br/><br/>
					İnsan Kaynakları Direktörlüğü<br/><br/><br/><br/>
					</td>
				</tr>
				<tr>
					<td>
					<table>
						<tr>
							<td colspan="2" class="txtbold">Performans Geliştirme ve Değerlendirme Notu Tanımları</td>
						</tr>
						<tr>
							<td>PD Notu 1 - 1,5 (1,00/1,24-1,25/1,74)</td>
							<td>: <cf_get_lang_main no='785.Başarısız'></td>
						</tr>
						<tr>
							<td>PD Notu 2 - 2,5 (1,75/2,24-2,25/2,74)</td>
							<td>: Beklenenin altında</td>
						</tr>
						<tr>
							<td>PD Notu 3 (2,75-3,24)</td>
							<td>: Beklenen düzeyde</td>
						</tr>
						<tr>
							<td>PD Notu 3,5 (3,25-3,74)</td>
							<td>: Beklenenin Üzerinde</td>
						</tr>
						<tr>
							<td>PD Notu 4 (3,75-4,24)</td>
							<td>: Başarılı</td>
						</tr>
						<tr>
							<td>PD Notu 4,5 (4,25-4,74)	</td>
							<td>: Çok Başarılı</td>
						</tr>
						<tr>
							<td>PD Notu 5 (4,75-5,00)</td>
							<td>: Sıradışı Performans</td>
						</tr>						
					</table>
					</td>
				</tr>
			</table>
		</td>
		<td style="width:10mm">&nbsp;</td>
	</tr>
</table>
</cfif>

