<cfparam name="attributes.position_cat_id" default=''>
<cfparam name="attributes.emp_status" default=1>
<cfparam name="attributes.eval_date" default="">
<cfparam name="attributes.period_year" default="#session.ep.period_year#">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch_name" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.is_form_submit" default="0">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.eval_date)>
	<cf_date tarih = "attributes.eval_date">
</cfif>
<cfif not len(attributes.period_year) and attributes.is_form_submit>
	<cfset attributes.period_year = session.ep.period_year>
</cfif>
<cfset url_str = "">
<cfif attributes.is_form_submit>
	<cfset url_str = '#url_str#&is_form_submit=#attributes.is_form_submit#'>
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif len(attributes.department_id)>
		<cfset url_str = "#url_str#&department_id=#attributes.department_id#">
	</cfif>
	<cfif len(attributes.department_name)>
		<cfset url_str = "#url_str#&department_name=#attributes.department_name#">
	</cfif>
	<cfif len(attributes.branch_name)>
		<cfset url_str="#url_str#&branch_name=#attributes.branch_name#">
	</cfif>
	<cfif len(attributes.branch_id)>
		<cfset url_str="#url_str#&branch_id=#attributes.branch_id#">
	</cfif>
	<cfif isdefined("attributes.position_cat_id")>
		<cfset url_str = "#url_str#&position_cat_id=#attributes.position_cat_id#">
	</cfif>
	<cfif len(attributes.eval_date) gt 9>
		<cfset url_str = "#url_str#&eval_date=#dateformat(attributes.eval_date,dateformat_style)#" >
	</cfif>
	<cfif isdefined("attributes.period_year")>
		<cfset url_str = "#url_str#&period_year=#attributes.period_year#">
	</cfif>
	<cfif isdefined("attributes.attenders")>
		<cfset url_str = "#url_str#&attenders=#attributes.attenders#">
	</cfif>
	<cfif isdefined('emp_status')>
		<cfset url_str = '#url_str#&emp_status=#attributes.emp_status#'>
	</cfif>
</cfif>
<cfif attributes.is_form_submit>
<cfquery name="get_emp_pos" datasource="#dsn#">
	SELECT POSITION_CODE FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=#session.ep.userid#
</cfquery>
<cfquery name="GET_PERF_RESULTS" datasource="#dsn#">
	SELECT 
	DISTINCT
		EPERF.PER_ID,
		EPERF.START_DATE,
		EPERF.FINISH_DATE,
		EPERF.EVAL_DATE,
		EPERF.RECORD_DATE,
		EPERF.RECORD_TYPE,
		EPERF.POSITION_CODE,
		EPERF.EMP_POSITION_NAME,
		EMPLOYEE_POSITIONS.POSITION_NAME,
		EMPLOYEES.EMPLOYEE_ID,		
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM 
		EMPLOYEE_PERFORMANCE EPERF,
		EMPLOYEE_PERFORMANCE_TARGET EPT,
		EMPLOYEE_QUIZ_RESULTS EQR,
		EMPLOYEES,
		EMPLOYEE_POSITIONS
	WHERE
		EPERF.EMP_ID = #session.ep.userid# AND
		EPERF.PER_ID=EPT.PER_ID AND
		EPERF.RESULT_ID = EQR.RESULT_ID AND
		EPERF.EMP_ID = EMPLOYEES.EMPLOYEE_ID AND
		EPERF.EMP_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID AND
		EMPLOYEE_POSITIONS.POSITION_CODE = EPERF.POSITION_CODE
		<cfif len(attributes.eval_date)>AND EPERF.EVAL_DATE = #attributes.eval_date#
		<cfelseif not len(attributes.eval_date) and len(attributes.period_year)>AND YEAR(EPERF.START_DATE) = #attributes.period_year#
		<cfelseif len(attributes.eval_date) and len(attributes.period_year)>AND EPERF.EVAL_DATE=#attributes.eval_date#
		<cfelseif not len(attributes.eval_date) and not len(attributes.period_year)>AND YEAR(EPERF.START_DATE) = #session.ep.period_year#</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
			EMPLOYEES.EMPLOYEE_NAME LIKE '%#attributes.keyword#%' OR
			EMPLOYEES.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
		)
		</cfif>
		ORDER BY 
			EMPLOYEES.EMPLOYEE_NAME,
			EMPLOYEES.EMPLOYEE_SURNAME,
			EPERF.EVAL_DATE DESC,
			EPERF.RECORD_DATE DESC
</cfquery>
<cfelse>
	<cfset get_perf_results.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_perf_results.recordcount#'>
<cf_medium_list_search title="#getLang('training',141)#">
<cf_medium_list_search_area>
<cfif fuseaction does not contain "popup">
	<cfinclude template="../../objects/display/tree_back.cfm">
	<cfoutput>#td_back#</cfoutput>>
</cfif>  
<cfform name="search" method="post" action="#request.self#?fuseaction=training.popup_dsp_performance_form">
	<table>
		<input type="hidden" name="is_form_submit" id="is_form_submit" value="1">
		<tr>
			<td><cf_get_lang_main no='48.Filtre'></td>
			<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
			<td><cf_get_lang no ='142.Degerlendirme Tarihi'></td>
			<td><cfif len(attributes.eval_date) gt 9>
					<cfinput type="text" name="eval_date" value="#dateformat(attributes.eval_date,dateformat_style)#" validate="#validate_style#" style="width:65px;" message="<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='142.Degerlendirme Tarihi'>!">
				<cfelse>
					<cfinput type="text" name="eval_date" value="" validate="#validate_style#" style="width:65px;" message="<cf_get_lang_main no='782.girilmesi zorunlu alan'>:<cf_get_lang no ='142.Degerlendirme Tarihi'> !">
				</cfif>
				<cf_wrk_date_image date_field="eval_date"></td> 
			<td>
				<select name="period_year" id="period_year" style="width:50px;">
				<cfloop from="#year(now())+1#" to="2002" index="yr" step="-1">
					<option value="<cfoutput>#yr#</cfoutput>" <cfif isdefined('attributes.period_year') and (yr eq attributes.period_year)>selected</cfif>><cfoutput>#yr#</cfoutput></option>
				</cfloop>
				</select>
			</td>
			<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
			<td><cf_wrk_search_button search_function='kontrol()'></td>
				<cf_workcube_file_action pdf='0' mail='0' doc='0' print='1'>
		</tr>
	</table> 
	</cfform>
</cf_medium_list_search_area>
</cf_medium_list_search>	
<cf_medium_list>
<thead>	
		  <tr>
			<th><cf_get_lang_main no='164.Çalisan'></th>
			<th><cf_get_lang_main no='1085.Pozisyon'></th>
			<th width="130"><cf_get_lang_main no='1060.Dönem'></th>
			<th width="80"><cf_get_lang_main no ='1054.Deg Tarihi'></th>
			<th width="115"><cf_get_lang_main no='215.Kayit Tarihi'></th>
		  </tr>
	</thead>
	<tbody>
		<cfif get_perf_results.recordcount>
			<cfif not len(attributes.POSITION_CAT_ID)>
				<cfset employee_id_list = ''>
				<cfoutput query="get_perf_results" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(employee_id) and (not listfind(employee_id_list,employee_id))>
						<cfset employee_id_list = listappend(employee_id_list,get_perf_results.employee_id,',')>
					</cfif>
				</cfoutput>
				<cfif listlen(employee_id_list)>
					<cfquery name="get_pos_name" datasource="#dsn#">
						SELECT 
							POSITION_CODE,
							POSITION_NAME,
							EMPLOYEE_ID
						FROM 
							EMPLOYEE_POSITIONS
						WHERE 
							EMPLOYEE_ID IN (#employee_id_list#)
						ORDER BY 
							EMPLOYEE_ID
					</cfquery>
					<cfset employee_id_list = listsort(valuelist(get_pos_name.EMPLOYEE_ID,','),"numeric","ASC",',')>
				</cfif>
			</cfif>
			<cfoutput query="get_perf_results" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				 <tr>
					<td><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" class="tableyazi" target="_blank">#employee_name# #employee_surname#</a></td>
					<td>#emp_position_name#</td>
					<td><a href="#request.self#?fuseaction=hr.upd_target_plan_forms&per_id=#per_id#" class="tableyazi" target="_blank">#DateFormat(START_DATE,dateformat_style)# - #DateFormat(FINISH_DATE,dateformat_style)#</a></td>
					<td>#DateFormat(EVAL_DATE,dateformat_style)#</td>
					<td>#DateFormat(RECORD_DATE,dateformat_style)# #TimeFormat(RECORD_DATE,'HH:mm:ss')#</td>						
				 </tr>
			</cfoutput>
		 <cfelse>
			<tr>
			  <td height="20" colspan="9"><cfif attributes.is_form_submit><cf_get_lang_main no='72.Kayit Bulunamadi'><cfelse><cf_get_lang_main no ='289.Filtre Ediniz'></cfif>!</td>
			</tr>
		 </cfif>
	 </tbody>
</cf_medium_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table cellpadding="0" cellspacing="0" border="0" width="99%" height="35" align="center">
		<tr>
			<td> <cf_pages 
				page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="training.popup_dsp_performance_form#url_str#"> </td>
			<!-- sil --><td style="text-align:right;"> <cfoutput> <cf_get_lang_main no='128.Toplam Kayit'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif>
<script type="text/javascript">
function kontrol(){
	return true;
}
</script>

