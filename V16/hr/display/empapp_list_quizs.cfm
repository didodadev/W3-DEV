<cfset xfa.fuseac = "hr.popup_app_empapp_list_quizs">
<cfset xfa.fuseac2 = "hr.emptypopup_empapp_quiz">
<cfparam name="attributes.form_status" default="">
<cfparam name="attributes.form_stage" default="-2">
<cfinclude template="../query/get_quizs.cfm">
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif isdefined("attributes.empapp_id")>
	<cfset url_str = "#url_str#&empapp_id=#attributes.empapp_id#">
</cfif>
<cfif isdefined("attributes.app_pos_id")>
	<cfset url_str = "#url_str#&app_pos_id=#attributes.app_pos_id#">
</cfif>
<cfif isdefined("attributes.list_id")>
	<cfset url_str = "#url_str#&list_id=#attributes.list_id#">
</cfif>
<cfif isdefined("attributes.is_app")><!---başvurdan geliyorsa--->
	<cfset url_str = "#url_str#&is_app=#attributes.is_app#">
</cfif>
<cfif isdefined("attributes.is_cv")><!---cvden geliyorsa--->
	<cfset url_str = "#url_str#&is_cv=#attributes.is_cv#">
</cfif>
<cfif isdefined("attributes.attenders")>
	<cfset url_str = "#url_str#&attenders=#attenders#">
</cfif>

<cfinclude template="../query/get_position_cats.cfm">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_quizs.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_medium_list_search title="#getLang('hr',34)#">
	<cf_medium_list_search_area>
	  <cfform method="post" action="#request.self#?fuseaction=#xfa.fuseac##url_str#">
	  <table>	
		<tr> 
		  <td><cf_get_lang dictionary_id='57460.Filtre'>:</td>
		  <td>
			<cfinput type="text" name="keyword" value="#attributes.keyword#">
		  </td>
		  <td> 
			<select name="form_type" id="form_type" style="width:125px;">
				<option value="0" selected><cf_get_lang dictionary_id='55480.Tüm Formlar'> </option>
				<option value="1" <cfif isdefined("attributes.form_type") AND attributes.form_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57576.Çalışan'></option>
				<option value="2" <cfif isdefined("attributes.form_type") AND attributes.form_type eq 2>selected</cfif>><cf_get_lang dictionary_id='55116.Başvuru'></option>
				<option value="5" <cfif isdefined("attributes.form_type") AND attributes.form_type eq 5>selected</cfif>><cf_get_lang dictionary_id='56666.Mülakat'></option>
				<option value="6" <cfif isdefined("attributes.form_type") AND attributes.form_type eq 6>selected</cfif>><cf_get_lang dictionary_id='29776.Deneme Süresi'></option>
			</select>
		  </td>
		  <td> 
			<select name="last30_all" id="last30_all" style="width:100px;">
				<option value="1" <cfif (isdefined("attributes.last30_all") AND attributes.last30_all eq 1) or not isdefined("attributes.last30_all")>selected</cfif>><cf_get_lang dictionary_id='56667.Son Kayıtlar'> (30<cf_get_lang dictionary_id='57490.gün'>)</option>
				<option value="2" <cfif isdefined("attributes.last30_all") AND attributes.last30_all eq 2 or not isdefined("attributes.last30_all")>selected</cfif>><cf_get_lang dictionary_id ='58081.Hepsi'> </option>            
			</select>
		  </td>
		  <td>
			<select name="form_status" id="form_status">
				<option value=""<cfif not len(attributes.form_status)> selected</cfif>><cf_get_lang dictionary_id='58081.Hepsi'> </option>
				<option value="1"<cfif attributes.form_status eq 1> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
				<option value="0"<cfif attributes.form_status eq 0> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
			</select>
		  </td> 
		  <td> 
			<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
			<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
		  </td>
		  <td><cf_wrk_search_button></td>
		  <td><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></td>
		</tr>
	  </table>
	  </cfform>
	</cf_medium_list_search_area>
</cf_medium_list_search>
<cf_medium_list>
	<thead>
	  <tr> 
		<th height="22"><cf_get_lang dictionary_id='29764.Form'></th>
		<th width="55"><cf_get_lang dictionary_id='57630.Tip'></th>
		<th width="100"><cf_get_lang dictionary_id='29775.Hazırlayan'></th>
		<th width="65"><cf_get_lang dictionary_id='57483.Kayıt'></th>
		<th width="45"><cf_get_lang dictionary_id='57756.Durum'></th>
		<th width="1%"><a <cfif fuseaction contains 'popup'>target="_blank"</cfif> href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.form_add_quiz"><img src="/images/plus_list.gif" border="0"></a></th>
	  </tr>
   </thead>
   <tbody>
	<cfif get_quizs.recordcount>
	 <cfoutput query="get_quizs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
	  <cfset stage = get_quizs.STAGE_ID> 
		<tr>
		  <td>				   
			<a href="#request.self#?fuseaction=#xfa.fuseac2#&quiz_id=#quiz_id#<cfif IsDefined('attributes.empapp_id')>&empapp_id=#attributes.empapp_id#</cfif><cfif IsDefined('attributes.app_pos_id')>&app_pos_id=#app_pos_id#</cfif><cfif IsDefined('attributes.list_id')>&list_id=#list_id#</cfif>" class="tableyazi">#QUIZ_HEAD#</a>
		  </td>
		  <td>
			<cfif 1 IS IS_APPLICATION><cf_get_lang dictionary_id='55116.Başvuru'>
			<cfelseif 1 IS IS_EDUCATION><cf_get_lang dictionary_id='57419.Eğitim'>
			<cfelseif 1 IS IS_TRAINER><cf_get_lang dictionary_id='55913.Eğitimci'>
			<cfelseif 1 IS IS_INTERVIEW><cf_get_lang dictionary_id='55212.Mülakat'>
			<cfelseif 1 IS IS_TEST_TIME><cf_get_lang dictionary_id='29776.Deneme Süresi'>
			<cfelse><cf_get_lang dictionary_id='57576.Çalışan'>
			</cfif>
		  </td>
		  <td> 
			<cfif len(RECORD_EMP)>
			<!--- <cfset attributes.employee_id = RECORD_EMP>
				<cfinclude template="../query/get_employee.cfm">
				#get_employee.employee_name# #get_employee.employee_surname#  --->
				#get_emp_info(RECORD_EMP,0,0)#
			<cfelseif len(record_par)>
				<cfset attributes.partner_id = RECORD_PAR>
				<cfinclude template="../query/get_partner2.cfm">
				#get_partner.company_partner_name# #get_partner.company_partner_surname# 
			</cfif>
		  </td>
		  <td>#dateformat(record_date,dateformat_style)#</td>
		  <td><cfif IS_ACTIVE IS 1><cf_get_lang dictionary_id='57493.Aktif'><cfelse><cf_get_lang dictionary_id='57494.Pasif'></cfif></td>
		  <td>
			<a href="#request.self#?fuseaction=#xfa.fuseac2#&quiz_id=#quiz_id#<cfif IsDefined('attributes.empapp_id')>&empapp_id=#attributes.empapp_id#</cfif><cfif IsDefined('attributes.app_pos_id')>&app_pos_id=#app_pos_id#</cfif><cfif IsDefined("attributes.poscat_id")>&poscat_id=#attributes.poscat_id#</cfif><cfif IsDefined("attributes.position_id")>&position_id=#attributes.position_id#</cfif>"><img src="/images/update_list.gif" border="0"></a>
		  </td>
	   </tr>
	  </cfoutput> 
   <cfelse>
	  <tr> 
		<td colspan="7"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
	  </tr>
  </cfif>
  </tbody>
</cf_medium_list>
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.form_type")>
	<cfset url_str = "#url_str#&form_type=#form_type#">
</cfif>
<cfif isdefined('attributes.form_status') and len(attributes.form_status)>
	<cfset url_str="#url_str#&form_status=#attributes.form_status#">
</cfif>
<cfif isdefined('attributes.last30_all') and len(attributes.last30_all)>
	<cfset url_str="#url_str#&last30_all=#attributes.last30_all#">
</cfif>
<cfif attributes.totalrecords gt attributes.maxrows>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr> 
  <td>
	<cf_pages 
		page="#attributes.page#" 
		maxrows="#attributes.maxrows#" 
		totalrecords="#attributes.totalrecords#" 
		startrow="#attributes.startrow#" 
		adres="#xfa.fuseac##url_str#"> 
  </td>
  <!-- sil --><td height="35"  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
</tr>
</table>
</cfif>
