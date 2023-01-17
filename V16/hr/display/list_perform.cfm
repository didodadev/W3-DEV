<cfparam name="attributes.form_position_cat_id" default=''>
<cfparam name="attributes.emp_status" default=1>
<cfparam name="attributes.eval_date" default="">
<cfparam name="attributes.period_year" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch_name" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.is_form_submit" default="0">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.closed_type" default="">
<cfif len(attributes.eval_date)>
	<cf_date tarih="attributes.eval_date">
</cfif>
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%hr.form_upd_perf_emp%">
</cfquery>
<cfset url_str = "">
<cfif attributes.is_form_submit>
	<cfset url_str = '#url_str#&is_form_submit=#attributes.is_form_submit#'>
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif len(attributes.closed_type)>
		<cfset url_str = "#url_str#&closed_type=#attributes.closed_type#">
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
	<cfif isdefined("attributes.form_position_cat_id")>
	  <cfset url_str = "#url_str#&form_position_cat_id=#attributes.form_position_cat_id#">
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
	<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
		<cfset url_str="#url_str#&process_stage=#attributes.process_stage#">
	</cfif>
	<cfif isdefined("attributes.valid_type") and len(attributes.valid_type)>
		<cfset url_str="#url_str#&valid_type=#attributes.valid_type#">
	</cfif>
</cfif>
<cfquery name="GET_POSITION_CATS" datasource="#DSN#">
	SELECT * FROM SETUP_POSITION_CAT WHERE POSITION_CAT_STATUS =1 ORDER BY POSITION_CAT
</cfquery>
<cfif attributes.is_form_submit>
	<cfinclude template="../query/get_perf_results.cfm">
<cfelse>
	<cfset get_perf_results.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default="#get_perf_results.recordcount#">
<cfform name="search" method="post" action="#request.self#?fuseaction=hr.list_perform"><!--- #request.self#?fuseaction=hr.list_perform --->
<input type="hidden" name="is_form_submit" id="is_form_submit" value="1">
<cfsavecontent variable="message"><cf_get_lang dictionary_id="55768.Ölçme-Değerlendirme"></cfsavecontent>
	<cf_big_list_search title="#message#">
		<cf_big_list_search_area>
			<table>
				<tr>
					<td><cf_get_lang dictionary_id='57460.Filtre'></td>
					<td><cfinput type="text" name="keyword" id="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
					<td>
						<cf_get_lang dictionary_id='57572.Departman'>
						<input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
						<input type="text" name="branch_name" id="branch_name" value="<cfoutput>#attributes.branch_name#</cfoutput>" style="width:120px;">
						<input type="hidden" name="department_id" id="department_id" value="<cfoutput>#attributes.department_id#</cfoutput>">
						<cfinput type="text" name="department_name" value="#attributes.department_name#" style="width:100px;">
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=search.department_id&field_name=search.department_name&field_branch_id=search.branch_id&field_branch_name=search.branch_name&without_department</cfoutput>&keyword='+document.search.department_name.value,'list');"><img src="/images/plus_thin.gif"></a>
					</td>
					<td><cf_get_lang dictionary_id='57761.Hiyerarşi'></td>
					<td><cfinput type="text" name="hierarchy" style="width:50px;" value="#attributes.hierarchy#" maxlength="50"></td>
						<!--- <td>
						<select name="department_id">
						<option value="">Åube-Departman
						<cfinclude template="../query/get_all_department_branches.cfm">
						<cfoutput query="ALL_BRANCHES">
						<option value="#department_id#" <cfif attributes.department_id eq department_id>selected</cfif>>#BRANCH_NAME#-#department_head#
						</cfoutput>
						</select>
						</td> --->
					<td>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı!'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" onKeyUp="isNumber(this)" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td>
						<cf_wrk_search_button search_function='kontrol()'>
					</td>
				</tr>
			</table>
		</cf_big_list_search_area>
		<cf_big_list_search_detail_area>
			<table>
				<tr>
					<td>
						Kilit Durumu
						<select name="CLOSED_TYPE" id="CLOSED_TYPE">
							<option value="">Se&ccedil;iniz</option>
							<option value="0" <cfif isdefined("attributes.CLOSED_TYPE") and attributes.CLOSED_TYPE is 0>selected</cfif>>A&ccedil;&#305;k</option>
							<option value="1" <cfif isdefined("attributes.CLOSED_TYPE") and attributes.CLOSED_TYPE is 1>selected</cfif>>Kilitli</option>
						</select>&nbsp;
						<cf_get_lang dictionary_id='55944.Değerlendirme Tarihi'>&nbsp;
						  <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='56240.Değerlendirme Tarihi Giriniz'></cfsavecontent>
							<cfif len(attributes.eval_date) gt 9>
								<cfinput type="text" name="eval_date" maxlength="10" value="#dateformat(attributes.eval_date,dateformat_style)#" validate="#validate_style#" style="width:65px;" message="#alert#">
							<cfelse>
								<cfinput type="text" name="eval_date" maxlength="10" value="" validate="#validate_style#" style="width:65px;" message="#alert#">
							</cfif>
						  <cf_wrk_date_image date_field="eval_date">
						<select name="form_position_cat_id" id="form_position_cat_id" style="width:150px;">
							<option value="" selected><cf_get_lang dictionary_id='59004.Pozisyon Tipi'>
							<cfoutput query="get_position_cats">
								<option value="#position_cat_id#" <cfif attributes.form_position_cat_id eq position_cat_id>selected</cfif>>#position_cat#</option>
							</cfoutput>
						</select>&nbsp;
						<select name="valid_type" id="valid_type">
							<option value=""><cf_get_lang dictionary_id="35447.Değerlendirme Durumu"></option>
							<option value="1" <cfif isdefined("attributes.valid_type") and attributes.valid_type is 1>selected</cfif>>G&ouml;r&uuml;&#351; Bildirilenler</option>
							<option value="2" <cfif isdefined("attributes.valid_type") and attributes.valid_type is 2>selected</cfif>>G&ouml;r&uuml;&#351; Bildirilmeyenler</option>
						</select>&nbsp;
						<select name="process_stage" id="process_stage">
							<option value=""><cf_get_lang dictionary_id='57482.Aşama'></option>
							<cfoutput query="get_process_stage">
								<option value="#PROCESS_ROW_ID#" <cfif isdefined("attributes.process_stage") and (attributes.process_stage eq PROCESS_ROW_ID)>selected</cfif>>#stage#</option>
							</cfoutput>
						</select>
						<select name="period_year" id="period_year">
							<option value="" selected>T&uuml;m&uuml;</option>
							<cfloop from="#year(now())+1#" to="2002" index="yr" step="-1">
								<option value="<cfoutput>#yr#</cfoutput>" <cfif isdefined('attributes.period_year') and (yr eq attributes.period_year)>selected</cfif>><cfoutput>#yr#</cfoutput></option>
							</cfloop>
						</select>
					</td>
				</tr>
			</table>
		</cf_big_list_search_detail_area>
	</cf_big_list_search>
</cfform>
<cf_big_list> 
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id='57576.Calisan'></th>
			<th><cf_get_lang dictionary_id='58497.Pozisyon'></th>
			<th><cf_get_lang dictionary_id='29764.Form'></th>
			<th width="130"><cf_get_lang dictionary_id='58472.Donem'></th>
			<th width="80"><cf_get_lang dictionary_id='55944.Degerlendirme Tarihi'></th>
			<th width="115"><cf_get_lang dictionary_id='57627.Kayit Tarihi'></th>
			<!-- sil -->
			<th width="15">
			<a href="<cfoutput>#request.self#</cfoutput>?fuseaction=hr.form_add_perf_emp_info"><img src="/images/plus_list.gif" alt="<cf_get_lang_main no='170.Ekle'>" title="<cf_get_lang_main no='170.Ekle'>"></a>
			</th>
			<th class="header_icn_none"><img src="../images/print2.gif" title="Performans Değerlendirme"></th>
			<th class="header_icn_none"><a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_print_files&iid=0&print_type=174</cfoutput>','page');"><img src="../images/print3.gif" title="Performans Değerlendirme Mektubu"></a></th>
			<th class="header_icn_none"></th>
			<!-- sil -->
		</tr>
	</thead>
	<tbody>
		<cfif get_perf_results.recordcount>
			<cfif not len(attributes.form_position_cat_id)>
				<cfset employee_id_list = ''>
				<cfoutput query="get_perf_results" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<cfif len(employee_id) and (not listfind(employee_id_list,employee_id))>
						<cfset employee_id_list = listappend(employee_id_list,get_perf_results.employee_id,',')>
					</cfif>
				</cfoutput>
				<cfif listlen(employee_id_list)>
					<cfquery name="get_pos_name" datasource="#dsn#">
						SELECT 
							POSITION_ID,
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
					<td width="40">#currentrow#</td>
					<td><a href="#request.self#?fuseaction=hr.list_hr&event=upd&employee_id=#employee_id#" class="tableyazi">#employee_name# #employee_surname#</a></td>
					<td>
						<cfif len(attributes.form_position_cat_id)>
							<a href="#request.self#?fuseaction=hr.list_positions&event=upd&position_id=#POSITION_ID#" clasS="tableyazi">#position_name#</a>
						<cfelse>
							<a href="#request.self#?fuseaction=hr.list_positions&event=upd&position_id=#get_pos_name.POSITION_ID[listfind(employee_id_list,employee_id,',')]#" clasS="tableyazi">#get_pos_name.position_name[listfind(employee_id_list,employee_id,',')]#</a>
						</cfif>
					</td>
					<td>#QUIZ_HEAD# <cfif RECORD_TYPE is 1>(<cf_get_lang dictionary_id='56015.Asıl'>)<cfelseif RECORD_TYPE is 2>(<cf_get_lang dictionary_id='56016.56016'> 1)<cfelseif RECORD_TYPE is 3>(<cf_get_lang dictionary_id='56016.56016'> 2)<cfelseif RECORD_TYPE is 4>(<cf_get_lang dictionary_id="35430.Ara D.">)</cfif></td>
					<td>#DateFormat(START_DATE,dateformat_style)# - #DateFormat(FINISH_DATE,dateformat_style)#</td>
					<td>#DateFormat(EVAL_DATE,dateformat_style)#</td>
					<td>#DateFormat(RECORD_DATE,dateformat_style)# #TimeFormat(RECORD_DATE,'HH:mm:ss')#</td>						
					<!-- sil -->
					<td align="center">
						<cfif not listfindnocase(denied_pages,'hr.form_upd_performance')>
							<a href="#request.self#?fuseaction=hr.form_upd_perf_emp&per_id=#PER_ID#"> <img src="/images/update_list.gif" alt="<cf_get_lang no='684.Formu GÃ¼ncelle'>" title="<cf_get_lang_main no='52.Güncelle'>"> </a>
						</cfif>
					</td>
					<td style="text-align:center;">
						<cfif not listfindnocase(denied_pages,'hr.form_upd_performance')>
							<!--- <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=hr.popup_print_performance&per_id=#per_id#','page');"><img src="../images/print2.gif" border="0"></a> --->
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#per_id#&print_type=176','page');"><img src="../images/print2.gif" border="0" title="<cf_get_lang_main no='62.Yazdır'>"></a>
						</cfif>
					</td>
					<td style="text-align:center;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#per_id#&print_type=174','page');"><img src="../images/print2.gif" title="<cf_get_lang_main no='62.Yazdır'>"></a></td>
					<td align="center">
						<cfif is_closed eq 1><img src="/images/list_open.gif" alt="Kilitli Değerlendirme"><cfelse><img src="/images/list_lock.gif" alt="Açık (Kilitsiz) Değerlendirme" title="<cf_get_lang_main no='1448.Kilitle'>"></cfif>
					</td>
					<!-- sil -->
				</tr>
			</cfoutput>
			<cfelse>
				<tr>
					<td colspan="11"><cfif attributes.is_form_submit><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
				</tr>
		</cfif>
	</tbody>
</cf_big_list> 
<cf_paging 
    page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="hr.list_perform#url_str#">
<script type="text/javascript">
document.getElementById('keyword').focus();
function kontrol()
{
	if(document.search.branch_name.value.length==0)document.search.branch_id.value="";
	if(document.search.department_name.value.length==0)document.search.department_id.value="";
	return true;
}
</script>
