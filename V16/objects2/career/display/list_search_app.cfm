<cfset url_str = "">
<cfinclude template="../query/get_search_app_emp.cfm">
<table width="100%" cellpadding="0" cellspacing="0" border="0" height="100%">
  <tr>
    <td valign="top">
      <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
        <tr>
          <td class="headbold" height="35"><cf_get_lang dictionary_id='58088.Search Results'></td>
		  <td colspan="2"  valign="bottom" style="text-align:right;">
		  <!-- sil -->
            <table>
                <tr>
				  <td><a href="javascript://" onClick="add_select_list();" title="<cf_get_lang dictionary_id='35093.Create Selection List'>"><img src="../../images/outsource.gif" border="0" alt="<cf_get_lang dictionary_id='35093.Create Selection List'>" /></a></td>
				  <td><a href="javascript://" onClick="edit_select_list();" title="<cf_get_lang dictionary_id='35094.Add to Existing Selection List'>"><img src="../../images/out.gif" border="0" alt="<cf_get_lang dictionary_id='35094.Add to Existing Selection List'>" /></a></td>
				  <!--- <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> --->
                </tr>
            </table>
			<!-- sil -->
          </td>
        </tr>
      </table>
      <table cellSpacing="0" cellpadding="0" border="0" width="98%" align="center">
        <tr class="color-border">
          <td>
            <table cellspacing="1" cellpadding="2" width="100%" border="0">
			<!-- sil -->
			<form name="emp_list" method="post" action="">
			 	<input type="hidden" name="mail" id="mail" value="">
			 	<!-- sil -->
				<tr class="color-header">
					<td height="22" class="form-title" width="65"><cf_get_lang dictionary_id='57487.Number'></td>
					<td class="form-title" width="60"><cf_get_lang dictionary_id='57742.Date'></td>
					<td class="form-title"><cf_get_lang dictionary_id='57570.Name  Last name'></td>
					<td class="form-title"><cf_get_lang dictionary_id='35242.Adverts'></td>
					<td class="form-title" width="25"><cf_get_lang dictionary_id='35244.Age'></td>
					<td class="form-title" width="25"><cf_get_lang dictionary_id='57709.School'> </td>
					<td class="form-title" width="25"><cf_get_lang dictionary_id='57995.Section'></td>
					<td class="form-title" width="75"><cf_get_lang dictionary_id='35243.Last Work Experience'></td>
					<td class="form-title" width="40"><cf_get_lang dictionary_id='57756.Status'></td>
					<!-- sil -->
					<td width="15"><img src="/images/print2_white.gif" border="0" alt="<cf_get_lang dictionary_id='57474.Print'>" title="<cf_get_lang dictionary_id='57474.Print'>" /></td>
					<td width="15"><a href="javascript://" onclick="send_mail();" title="<cf_get_lang dictionary_id='57475.Send email'>"><img src="/images/mail.gif" border="0" alt="<cf_get_lang dictionary_id='57475.Send email'>" /></a></td>
					<td width="10"><input type="checkbox" name="all_check" id="all_check" value="1" onclick="javascript: hepsi();"></td>
					<!-- sil -->
				</tr>
              	<cfif get_apps.recordcount>
					<cfoutput query="get_apps">
						<cfquery name="GET_NOTICESS" datasource="#DSN#">
						SELECT NOTICE_ID,NOTICE_HEAD,NOTICE_NO,STATUS FROM NOTICES WHERE NOTICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_apps.notice_id#"> AND COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> ORDER BY NOTICE_HEAD
						</cfquery>
					<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
						<td><cfif len(get_apps.app_pos_id) and get_apps.app_pos_id neq 0>
								<a href="#request.self#?fuseaction=objects2.upd_app_pos&empapp_id=#get_apps.empapp_id#&app_pos_id=#get_apps.app_pos_id#" class="tableyazi">#currentrow#</a>
							<cfelse>
								<a href="#request.self#?fuseaction=objects2.dsp_cv_partner&empapp_id=#get_apps.empapp_id#" class="tableyazi">#currentrow#</a>
							</cfif>
						</td>
						<td>#dateformat(get_apps.APP_DATE,'dd/mm/yyyy')#</td>
						<td><cfif len(get_apps.app_pos_id) and get_apps.app_pos_id neq 0>
								<a href="#request.self#?fuseaction=objects2.upd_app_pos&empapp_id=#get_apps.empapp_id#&app_pos_id=#get_apps.app_pos_id#" class="tableyazi">#name# #surname#</a>
							<cfelse>
								<a href="#request.self#?fuseaction=objects2.dsp_cv_partner&empapp_id=#get_apps.empapp_id#" class="tableyazi">#name# #surname#</a>
							</cfif>
						</td>
						<td><a href="#request.self#?fuseaction=objects2.form_upd_notice&notice_id=#get_apps.notice_id#" class="tableyazi">#GET_NOTICESS.notice_no# #GET_NOTICESS.notice_head#</a>
							<!--- #ListGetAt(notice_list,ListFind(notice_list,get_apps.notice_id,',')+1,',')#-#ListGetAt(notice_list,ListFind(notice_list,get_apps.notice_id,',')+2,',')# --->
						</td>
						<td>
						<cfif len(get_apps.BIRTH_DATE)>
							<cfset yas = datediff("yyyy",get_apps.BIRTH_DATE,NOW())>
							<cfif yas neq 0>#yas#</cfif>	
						</cfif>
						</td>
						<td><cfquery name="get_app_edu_info" datasource="#dsn#" maxrows="1">
								SELECT EDU_NAME,EDU_PART_NAME FROM EMPLOYEES_APP_EDU_INFO WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#empapp_id#"> ORDER BY EDU_START DESC
							</cfquery>
							<cfif get_app_edu_info.recordcount> #get_app_edu_info.edu_name#</cfif>
						</td>
						<td><cfif get_app_edu_info.recordcount>#get_app_edu_info.edu_part_name#</cfif></td>
						<td><cfquery name="get_app_work_info" datasource="#dsn#" maxrows="1">
								SELECT EXP,EXP_POSITION,EXP_FINISH FROM EMPLOYEES_APP_WORK_INFO WHERE EMPAPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#empapp_id#"> ORDER BY EXP_START DESC
							</cfquery>
							<cfif get_app_work_info.recordcount>#get_app_work_info.exp#-#get_app_work_info.exp_position#-#dateformat(get_app_work_info.exp_finish,'mm/yyyy')#</cfif></td>
						<td><cfif app_pos_status eq 1><cf_get_lang dictionary_id='57493.Active'><cfelse><cf_get_lang dictionary_id='38569.Having Invoices'></cfif></td>
					<!-- sil -->
						<td><cfif len(get_apps.app_pos_id) and get_apps.app_pos_id neq 0>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_print_files&iid=#get_apps.app_pos_id#&print_type=171','print_page','workcube_print');" title="<cf_get_lang dictionary_id='57474.Print'>"><img src="/images/print2.gif" alt="<cf_get_lang dictionary_id='57474.Print'>" border="0" /></a>
							<cfelse>
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_dsp_cv_print&empapp_id=#get_apps.empapp_id#','page');return false;" title="<cf_get_lang dictionary_id='57474.Print'>"><img src="/images/print2.gif" alt="<cf_get_lang dictionary_id='57474.Print'>" border="0" /></a>
							</cfif>
						</td>
						<td><cfif get_apps.app_pos_id and get_apps.app_pos_id neq 0>
								<input type="hidden" name="basvuru_id" id="basvuru_id" value="#get_apps.app_pos_id#">
								<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_app_add_mail&empapp_id=#get_apps.empapp_id#&app_pos_id=#get_apps.app_pos_id#','page');return false;" title="<cf_get_lang dictionary_id='57475.Send email'>"><img src="/images/mail.gif" border="0" alt="<cf_get_lang dictionary_id='57475.Send email'>" /></a>
							<cfelse>
								<input type="hidden" name="basvuru_id" id="basvuru_id" value="0">
							</cfif>
						</td>
						<td><input type="checkbox" name="ozgecmis_id" id="ozgecmis_id" value="#get_apps.empapp_id#"></td>
					<!-- sil -->
					</tr>
					</cfoutput>
              	<cfelse>
					<tr class="color-row" height="20">
						<td colspan="12"><cf_get_lang_main no='72.Kayıt Yok'> !</td>
					</tr>
				</cfif>
			  <!-- sil -->
			  </form>
			  <!-- sil -->
            </table>
          </td>
        </tr>
      </table>
        <table width="98%" align="center" cellpadding="0" cellspacing="0" height="35">
          <tr>
           	<td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'> : #get_apps.recordcount#</cfoutput></td>
          </tr>
        </table>
    </td>
</tr>
</table>
<!-- sil -->
<form name="list_app" method="post" action="">
<cfoutput>
<input type="hidden" name="list_app_pos_id" id="list_app_pos_id" value="">
<input type="hidden" name="list_empapp_id" id="list_empapp_id" value="">
<input type="hidden" name="search_app_pos" id="search_app_pos" value="<cfif isdefined("attributes.search_app_pos")>#attributes.search_app_pos#</cfif>">
<input type="hidden" name="status_app_pos" id="status_app_pos" value="#attributes.status_app_pos#">
<input type="hidden" name="date_status" id="date_status" value="#attributes.date_status#">
<input type="hidden" name="notice_id" id="notice_id" value="#attributes.notice_id#">
<input type="hidden" name="notice_head" id="notice_head" value="#attributes.notice_head#">
<input type="hidden" name="company_id" id="company_id" value="#session.pp.company_id#">
<input type="hidden" name="company" id="company" value="#session.pp.company#">
<input type="hidden" name="our_company_id" id="our_company_id" value="#session.pp.our_company_id#">	
<input type="hidden" name="app_date1" id="app_date1" value="#attributes.app_date1#">
<input type="hidden" name="app_date2" id="app_date2" value="#attributes.app_date2#">
<input type="hidden" name="prefered_city" id="prefered_city" value="<cfif isdefined("attributes.prefered_city")>#attributes.prefered_city#</cfif>">
<input type="hidden" name="salary_wanted1" id="salary_wanted1" value="#attributes.salary_wanted1#">
<input type="hidden" name="salary_wanted2" id="salary_wanted2" value="#attributes.salary_wanted2#">
<input type="hidden" name="salary_wanted_money" id="salary_wanted_money" value="#attributes.salary_wanted_money#">
<input type="hidden" name="search_app" id="search_app" value="<cfif isdefined("attributes.search_app")>#attributes.search_app#</cfif>">
<input type="hidden" name="status_app" id="status_app" value="#attributes.status_app#">
<input type="hidden" name="app_name" id="app_name" value="#attributes.app_name#">
<input type="hidden" name="app_surname" id="app_surname" value="#attributes.app_surname#">
<input type="hidden" name="birth_date1" id="birth_date1" value="#attributes.birth_date1#">
<input type="hidden" name="birth_date2" id="birth_date2" value="#attributes.birth_date2#">
<input type="hidden" name="birth_place" id="birth_place" value="#attributes.birth_place#">
<input type="hidden" name="married" id="married" value="<cfif isdefined("attributes.married")>#attributes.married#</cfif>">
<input type="hidden" name="city" id="city" value="#attributes.city#">
<input type="hidden" name="sex" id="sex" value="<cfif isdefined("attributes.sex")>#attributes.sex#</cfif>">
<input type="hidden" name="martyr_relative" id="martyr_relative" value="<cfif isdefined("attributes.martyr_relative")>#attributes.martyr_relative#</cfif>">
<input type="hidden" name="is_trip" id="is_trip" value="<cfif isdefined("attributes.is_trip")>#attributes.is_trip#</cfif>">
<input type="hidden" name="driver_licence" id="driver_licence" value="<cfif isdefined("attributes.driver_licence")>#attributes.driver_licence#</cfif>">
<input type="hidden" name="driver_licence_type" id="driver_licence_type" value="#attributes.driver_licence_type#">
<input type="hidden" name="sentenced" id="sentenced" value="<cfif isdefined("attributes.sentenced")>#attributes.sentenced#</cfif>">
<input type="hidden" name="defected" id="defected" value="<cfif isdefined("attributes.defected")>#attributes.defected#</cfif>">
<input type="hidden" name="defected_level" id="defected_level" value="#attributes.defected_level#">
<input type="hidden" name="email" id="email" value="#attributes.email#<cfif isdefined("attributes.email")>#attributes.email#</cfif>">
<input type="hidden" name="military_status" id="military_status" value="<cfif isdefined("attributes.military_status")>#attributes.military_status#</cfif>">
<input type="hidden" name="homecity" id="homecity" value="<cfif isdefined("attributes.homecity")>#attributes.homecity#</cfif>">
<input type="hidden" name="training_level" id="training_level" value="<cfif isdefined("attributes.training_level")>#attributes.training_level#</cfif>">
<input type="hidden" name="edu_finish" id="edu_finish" value="#attributes.edu_finish#">
<input type="hidden" name="exp_year_s1" id="exp_year_s1" value="#attributes.exp_year_s1#">
<input type="hidden" name="exp_year_s2" id="exp_year_s2" value="#attributes.exp_year_s2#">
<input type="hidden" name="lang" id="lang" value="<cfif isdefined("attributes.lang")>#attributes.lang#</cfif>">
<input type="hidden" name="lang_level" id="lang_level" value="#attributes.lang_level#">
<input type="hidden" name="lang_par" id="lang_par" value="#attributes.lang_par#">
<input type="hidden" name="edu3_part" id="edu3_part" value="#attributes.edu3_part#">
<input type="hidden" name="edu4_id" id="edu4_id" value="#attributes.edu4_id#">
<input type="hidden" name="edu4_part_id" id="edu4_part_id" value="#attributes.edu4_part_id#">
<input type="hidden" name="edu4" id="edu4" value="#attributes.edu4#">
<input type="hidden" name="edu4_part" id="edu4_part" value="#attributes.edu4_part#">
<input type="hidden" name="unit_id" id="unit_id" value="<cfif isdefined("attributes.unit_id")>#attributes.unit_id#</cfif>">
<input type="hidden" name="unit_row" id="unit_row" value="<cfif isdefined("attributes.unit_row") and len(attributes.unit_row)>#attributes.unit_row#</cfif>">
<input type="hidden" name="referance" id="referance" value="#attributes.referance#">
<input type="hidden" name="tool" id="tool" value="#attributes.tool#">
<input type="hidden" name="kurs" id="kurs" value="#attributes.kurs#">
<input type="hidden" name="other" id="other" value="#attributes.other#">
<input type="hidden" name="other_if" id="other_if" value="#attributes.other_if#">
</cfoutput>
</form>
<script type="text/javascript">
function hepsi()
{
	if (document.emp_list.all_check.checked)
		{
	<cfif get_apps.recordcount gt 1>	
		for(i=0;i<emp_list.ozgecmis_id.length;i++) emp_list.ozgecmis_id[i].checked = true;
	<cfelseif get_apps.recordcount eq 1>
		emp_list.ozgecmis_id.checked = true;
	</cfif>
		}
	else
		{
	<cfif get_apps.recordcount gt 1>	
		for(i=0;i<emp_list.ozgecmis_id.length;i++) emp_list.ozgecmis_id[i].checked = false;
	<cfelseif get_apps.recordcount eq 1>
		emp_list.ozgecmis_id.checked = false;
	</cfif>
		}
}

function send_mail()
{
<cfif get_apps.recordcount>
	<cfif get_apps.recordcount gt 1> 
		for(var i=0;i<<cfoutput>#get_apps.recordcount#</cfoutput>;i++)
			if(!document.emp_list.ozgecmis_id[i].checked && document.emp_list.basvuru_id[i].value>0)
			{
			if(document.emp_list.mail.value.length==0) ayirac=''; else ayirac=',';
				document.emp_list.mail.value=document.emp_list.mail.value+ayirac+document.emp_list.ozgecmis_id[i].value;
			}
	<cfelse>
		if(!document.emp_list.ozgecmis_id.checked && document.emp_list.basvuru_id.value>0)
			document.emp_list.mail.value=document.emp_list.ozgecmis_id.value;
	</cfif>
		windowopen('','list','select_list_window');
		emp_list.action='<cfoutput>#request.self#?fuseaction=objects2.popup_app_add_mail&mail_sum=1&is_refresh=0</cfoutput>';
		emp_list.target='select_list_window';emp_list.submit();
		document.emp_list.mail.value='';/* maileri yolladıktan sonra alanı boşaltıyoruz*/
<cfelse>
	alert("<cf_get_lang_main no='72.Kayıt Yok'>!")
</cfif>
}

function add_select_list()
{
<cfif get_apps.recordcount>
	<cfif get_apps.recordcount gt 1> 
		for(var i=0;i<<cfoutput>#get_apps.recordcount#</cfoutput>;i++)
			if(document.emp_list.ozgecmis_id[i].checked)
			{
				if(document.list_app.list_empapp_id.value.length==0) ayirac=''; else ayirac=',';
				document.list_app.list_empapp_id.value=document.list_app.list_empapp_id.value+ayirac+document.emp_list.ozgecmis_id[i].value;
				document.list_app.list_app_pos_id.value=document.list_app.list_app_pos_id.value+ayirac+document.emp_list.basvuru_id[i].value;
			}
	<cfelse>
		if(document.emp_list.ozgecmis_id.checked)
			document.list_app.list_empapp_id.value=document.emp_list.ozgecmis_id.value;
			document.list_app.list_app_pos_id.value=document.emp_list.basvuru_id.value;
	</cfif>
	if(document.list_app.list_empapp_id.value.length==0)
	{
		alert("<cf_get_lang no ='1155.Özgeçmiş Seçmelisiniz'>");
		return false;
	}
		windowopen('','list','select_list_window');
		list_app.action='<cfoutput>#request.self#?fuseaction=objects2.popup_add_select_emp_list</cfoutput>';
		list_app.target='select_list_window';list_app.submit();
		document.list_app.list_empapp_id.value='';/* id_leri boşaltıyoruz popup açılıp bi ilem yapılmadn kapatılır ve tekrar popup açılırsa aynı idleri tekrar ekliyor*/
		document.list_app.list_app_pos_id.value='';
<cfelse>
	alert("<cf_get_lang_main no='72.Kayıt Yok'>!")
</cfif>
}

function edit_select_list()
{
<cfif get_apps.recordcount>
	<cfif get_apps.recordcount gt 1> 
		for(var i=0;i<<cfoutput>#get_apps.recordcount#</cfoutput>;i++)
			if(document.emp_list.ozgecmis_id[i].checked)
			{
			if(document.list_app.list_empapp_id.value.length==0) ayirac=''; else ayirac=',';
				document.list_app.list_empapp_id.value=document.list_app.list_empapp_id.value+ayirac+document.emp_list.ozgecmis_id[i].value;
				document.list_app.list_app_pos_id.value=document.list_app.list_app_pos_id.value+ayirac+document.emp_list.basvuru_id[i].value;
			}
	<cfelse>
		if(document.emp_list.ozgecmis_id.checked)
			document.list_app.list_empapp_id.value=document.emp_list.ozgecmis_id.value;
			document.list_app.list_app_pos_id.value=document.emp_list.basvuru_id.value;
	</cfif>
	if(document.list_app.list_empapp_id.value.length==0)
	{
		alert("<cf_get_lang no ='1155.Özgeçmiş Seçmelisiniz'>");
		return false;
	}
		windowopen('','list','select_list_window');
		list_app.action='<cfoutput>#request.self#?fuseaction=objects2.popup_add_select_emp_list&old=1</cfoutput>';
		list_app.target='select_list_window';list_app.submit();
		document.list_app.list_empapp_id.value='';/* id_leri boşaltıyoruz popup açılıp bi ilem yapılmadn kapatılır ve tekrar popup açılırsa aynı idleri tekrar ekliyor*/
		document.list_app.list_app_pos_id.value='';
<cfelse>
	alert("<cf_get_lang_main no='72.Kayıt Yok'>!")
</cfif>
}
</script>
<!-- sil -->
