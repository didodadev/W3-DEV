<cfsetting showdebugoutput="no">
<cfif not isdefined('attributes.form_submit')>
<table width="98%" height="35" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td class="headbold">Toplu Performans Mektubu</td>
  </tr>
</table>
<table width="98%" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr class="color-border">
    <td>
      <table width="100%" border="0" cellspacing="1" cellpadding="2">
        <tr class="color-row">
          <td>
            <table border="0">
              <form name="search_form" method="post" action="">
			  <input type="hidden" name="form_submit" id="form_submit" value="1">
			  <input type="hidden" name="print_type" id="print_type" value="174">
			  <input type="hidden" name="iid" id="iid" value="<cfoutput>125</cfoutput>">
			  <input type="hidden" name="form_type" id="form_type" value="<cfoutput>#attributes.form_type#</cfoutput>">
				<tr>
					<td><cf_get_lang_main no='41.Şube'></td>
					<td>
						<input type="hidden" name="branch_id" id="branch_id" value="">
						<input type="text" name="branch_name" id="branch_name" value="" style="width:150px;">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_branches&field_branch_id=search_form.branch_id&field_branch_name=search_form.branch_name</cfoutput>&keyword='+encodeURIComponent(document.search_form.branch_name.value),'list');"><img src="/images/plus_thin.gif" align="absmiddle" border="0"></a>
					</td>
					<td>
					<select name="period_year" id="period_year" style="width:50px;">
						<option value="" selected><cf_get_lang_main no='322.Seciniz'></option>
						<cfloop from="#year(now())+1#" to="2002" index="yr" step="-1">
							<option value="<cfoutput>#yr#</cfoutput>" <cfif isdefined('attributes.period_year') and (yr eq attributes.period_year)>selected</cfif>><cfoutput>#yr#</cfoutput></option>
						</cfloop>
					</select>
					</td>
					<td>Form Tipi</td>
					<td>
						<select name="RECORD_TYPE" id="RECORD_TYPE">
							<option value="1" selected>Asıl</option>
							<option value="4" >Ara Değerlendirme</option>
						</select>
					</td>
					<td>Basılacak En Düşük Puan</td>
					<td>
						<select name="min_point" id="min_point">
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3" selected>3</option>
							<option value="4">4</option>
							<option value="5">5</option>
						</select>
					</td>
					<td colspan="2"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
				</tr>
              </form>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
function kontrol(){
 if(document.search_form.branch_name.value.length==0 || document.search_form.branch_id.value.length==0){
 	alert("<cf_get_lang no='472.Şube Seçmelisiniz'>");
	return false;
 }
 if(document.search_form.period_year.value.length==0){
 	alert("<cf_get_lang_main no='531.Tarih Seciniz'>");
	return false;
 }
 return true;
 }
</script>

<cfelse>

	<cfquery name="get_dep_emp" datasource="#dsn#">
		SELECT 
			EMPLOYEE_POSITIONS.EMPLOYEE_ID,
			EMPLOYEE_POSITIONS.POSITION_ID,
			EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
			EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME,
			BRANCH.BRANCH_NAME,
			DEPARTMENT.DEPARTMENT_HEAD
		FROM 
			EMPLOYEE_POSITIONS,
			DEPARTMENT,
			BRANCH 
		WHERE 
			BRANCH.BRANCH_ID=#attributes.branch_id# AND
			EMPLOYEE_POSITIONS.DEPARTMENT_ID=DEPARTMENT.DEPARTMENT_ID AND
			DEPARTMENT.BRANCH_ID=BRANCH.BRANCH_ID AND
			EMPLOYEE_POSITIONS.EMPLOYEE_ID <>0
		ORDER BY 
			EMPLOYEE_POSITIONS.EMPLOYEE_ID
	</cfquery>
	<cfset emp_list=valuelist(GET_DEP_EMP.EMPLOYEE_ID,',')>

	<cfif listlen(emp_list,',')>
		<cfquery name="get_perf" datasource="#dsn#">
			SELECT
				*
			FROM
				EMPLOYEE_PERFORMANCE
			WHERE
				EMP_ID IN(#emp_list#) AND
				USER_POINT_OVER_5>=#attributes.min_point# AND
				YEAR(START_DATE) = #attributes.period_year#
				AND RECORD_TYPE=#attributes.record_type#
		</cfquery>
		
		<cfif get_perf.recordcount>
			<cfquery name="CHECK" datasource="#DSN#">
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

			<cfoutput query="get_perf">
				<cfif LEN(USER_POINT) AND LEN(PERFORM_POINT)>
					<cfset user_point_over_5_raw = 5*USER_POINT / PERFORM_POINT>
					<cfset user_point_over_5_raw = round(user_point_over_5_raw*100)/100>
				<cfelse>
					<cfset user_point_over_5_raw = 0>
				</cfif>
				<table style="width:210mm;height:297mm;" cellpadding="0" cellspacing="0" border="0" >
					<tr>
						<td style="width:5mm;"></td>
						<td style="height:25mm"></td>
						<td style="width:10mm">&nbsp;</td>
					<tr>
						<td style="width:5mm;"></td>
						<td valign="top">
							<table cellpadding="0" cellspacing="0" border="0">
								<tr>
									<td valign="top" style="height:25mm">
										<table width="100%">
											<tr>
												<td><cfif len(CHECK.asset_file_name3)><img src="#user_domain##file_web_path#settings/#CHECK.asset_file_name3#" border="0"></cfif></td>
												<td style="text-align:right;" width="100%">#dateformat(now(),dateformat_style)#</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td valign="top">#get_dep_emp.employee_name[listfind(emp_list,get_perf.EMP_ID,',')]# #UCase(get_dep_emp.employee_surname[listfind(emp_list,get_perf.EMP_ID,',')])#</td>
								</tr>
								<tr>
									<td valign="top" style="height:40mm"><cfif get_dep_emp.recordcount>#get_dep_emp.branch_name[listfind(emp_list,get_perf.EMP_ID,',')]# (#get_dep_emp.department_head[listfind(emp_list,get_perf.EMP_ID,',')]#)</cfif></td>
								</tr>
								<tr>
									<td>Sayın #get_dep_emp.employee_surname[listfind(emp_list,get_perf.EMP_ID,',')]#, <br/><br/><br/><br/></td>
								</tr>
								<tr>
									<td>#dateformat(get_perf.start_date,'YYYY')# Yılı Performans Geliştirme ve Değerlendirme Sistemi dahilinde yapılan değerlendirmeniz sonucunda 
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
											<td>: <cf_get_lang no='1156.Beklenenin alti'></td>
										</tr>
										<tr>
											<td>PD Notu 3 (2,75-3,24)</td>
											<td>: <cf_get_lang no='1155.Beklenen düzey'></td>
										</tr>
										<tr>
											<td>PD Notu 3,5 (3,25-3,74)</td>
											<td>: <cf_get_lang no='1154.Beklenenin Ustu'></td>
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
			</cfoutput>
		</cfif>
	</cfif>

</cfif>
