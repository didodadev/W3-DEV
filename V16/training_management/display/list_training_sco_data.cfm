<cfinclude template="../scorm_engine/core.cfm">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.emp_id" default="">
<cfparam name="attributes.par_id" default="">
<cfparam name="attributes.cons_id" default="">
<cfparam name="attributes.emp_par_name" default="">
<cfparam name="attributes.is_completed" default="">
<cfset url_str = "">
<cfset url_str = "#url_str#&class_id=#attributes.class_id#">
<cfif isdefined("attributes.keyword")>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.emp_id")>
	<cfset url_str = "#url_str#&emp_id=#attributes.emp_id#">
</cfif>
<cfif isdefined("attributes.cons_id")>
	<cfset url_str = "#url_str#&cons_id=#attributes.cons_id#">
</cfif>
<cfif isdefined("attributes.par_id")>
	<cfset url_str = "#url_str#&par_id=#attributes.par_id#">
</cfif>
<cfif isdefined("attributes.emp_par_name")>
	<cfset url_str = "#url_str#&emp_par_name=#attributes.emp_par_name#">
</cfif>
<cfparam name="attributes.is_completed" default="">
<cfquery name="get_data" datasource="#dsn#">
	SELECT	
		DISTINCT
		SCO.SCO_ID,
		SCO.NAME,
		SCO.VERSION,
		SCO_DATA.USER_ID AS USERID,
		SCO_DATA.USER_TYPE,
		E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME AS ADSOYAD,
		C.NICK_NAME AS NICK_NAME,
		'' AS TOTAL_TIME,
		'' AS SCORE,
		'' AS COMPLETION_STATUS,
		'' AS SUCCESS_STATUS,
		'' AS PROGRESS,
		'' AS DATA_ID
	FROM 
		TRAINING_CLASS_SCO SCO,
		TRAINING_CLASS_SCO_DATA SCO_DATA,
		EMPLOYEES E,
		EMPLOYEE_POSITIONS EP,
		DEPARTMENT D,
		BRANCH B,
		OUR_COMPANY C
	WHERE
		SCO.SCO_ID = SCO_DATA.SCO_ID AND
		SCO_DATA.USER_TYPE = 0 AND
		SCO_DATA.USER_ID = E.EMPLOYEE_ID AND
		E.EMPLOYEE_ID = EP.EMPLOYEE_ID AND
		EP.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.BRANCH_ID = B.BRANCH_ID AND
		B.COMPANY_ID = C.COMP_ID AND
		SCO.CLASS_ID = #attributes.class_id#
		<cfif len(attributes.keyword)>
		AND (
			SCO.NAME LIKE '%#attributes.keyword#%' OR
			E.EMPLOYEE_NAME+' '+E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' OR
			C.NICK_NAME LIKE '%#attributes.keyword#%'
			)
		</cfif>
		<cfif len(attributes.emp_id) and len(emp_par_name)>
		AND E.EMPLOYEE_ID = #attributes.emp_id#
		<cfelseif len(attributes.par_id) and len(emp_par_name)>
		AND 1=0
		<cfelseif len(attributes.cons_id) and len(emp_par_name)>
		AND 1=0
		</cfif>
		<cfif len(attributes.is_completed) and attributes.is_completed eq 1>
		AND (VAR_NAME LIKE 'cmi.completion_status' OR VAR_NAME LIKE 'cmi.core.lesson_status')
		AND CAST(VAR_VALUE AS varchar(50)) = 'completed'
		<cfelseif len(attributes.is_completed) and attributes.is_completed eq 0>
		AND (VAR_NAME LIKE 'cmi.completion_status' OR VAR_NAME LIKE 'cmi.core.lesson_status')
		AND CAST(VAR_VALUE AS varchar(50)) <> 'completed'
		</cfif>
	UNION
		SELECT 
		DISTINCT
			SCO.SCO_ID,
			SCO.NAME,
			SCO.VERSION,
			SCO_DATA.USER_ID AS USERID,
			SCO_DATA.USER_TYPE,
			CP.COMPANY_PARTNER_NAME+' '+CP.COMPANY_PARTNER_SURNAME AS ADSOYAD,
			C.NICKNAME AS NICK_NAME,
			'' AS TOTAL_TIME,
			'' AS SCORE,
			'' AS COMPLETION_STATUS,
			'' AS SUCCESS_STATUS,
			'' AS PROGRESS,
			'' AS DATA_ID
		FROM 
			TRAINING_CLASS_SCO SCO,
			TRAINING_CLASS_SCO_DATA SCO_DATA,
			COMPANY_PARTNER CP,
			COMPANY C
		WHERE
			SCO.SCO_ID = SCO_DATA.SCO_ID AND
			SCO_DATA.USER_TYPE = 1 AND
			SCO_DATA.USER_ID = CP.PARTNER_ID AND
			CP.COMPANY_ID = C.COMPANY_ID AND
			SCO.CLASS_ID = #attributes.class_id#
			<cfif len(attributes.keyword)>
			AND (
				SCO.NAME LIKE '%#attributes.keyword#%' OR
				CP.COMPANY_PARTNER_NAME+' '+CP.COMPANY_PARTNER_SURNAME LIKE '%#attributes.keyword#%' OR
				C.NICKNAME LIKE '%#attributes.keyword#%'
				)
			</cfif>
			<cfif len(attributes.par_id) and len(emp_par_name)>
			AND CP.PARTNER_ID = #attributes.par_id#
			<cfelseif len(attributes.emp_id) and len(emp_par_name)>
			AND 1=0
			<cfelseif len(attributes.cons_id) and len(emp_par_name)>
			AND 1=0
			</cfif>
			<cfif len(attributes.is_completed) and attributes.is_completed eq 1>
			AND (VAR_NAME LIKE 'cmi.completion_status' OR VAR_NAME LIKE 'cmi.core.lesson_status')
			AND CAST(VAR_VALUE AS varchar(50)) = 'completed'
			<cfelseif len(attributes.is_completed) and attributes.is_completed eq 0>
			AND (VAR_NAME LIKE 'cmi.completion_status' OR VAR_NAME LIKE 'cmi.core.lesson_status')
			AND CAST(VAR_VALUE AS varchar(50)) <> 'completed'
			</cfif>
		UNION 
	SELECT 
		DISTINCT
			SCO.SCO_ID,
			SCO.NAME,
			SCO.VERSION,
			SCO_DATA.USER_ID AS USERID,
			SCO_DATA.USER_TYPE,
			C.CONSUMER_NAME+' '+C.CONSUMER_SURNAME AS ADSOYAD,
			'' AS NICK_NAME
			,
			'' AS TOTAL_TIME,
			'' AS SCORE,
			'' AS COMPLETION_STATUS,
			'' AS SUCCESS_STATUS,
			'' AS PROGRESS,
			'' AS DATA_ID
		FROM 
			TRAINING_CLASS_SCO SCO,
			TRAINING_CLASS_SCO_DATA SCO_DATA,
			CONSUMER C
		WHERE
			SCO.SCO_ID = SCO_DATA.SCO_ID AND
			SCO_DATA.USER_TYPE = 2 AND
			SCO_DATA.USER_ID = C.CONSUMER_ID AND
			SCO.CLASS_ID = #attributes.class_id#
			<cfif len(attributes.keyword)>
			AND (
				SCO.NAME LIKE '%#attributes.keyword#%' OR
				CONSUMER_NAME+' '+C.CONSUMER_SURNAME LIKE '%#attributes.keyword#%'
				)
			</cfif>
			<cfif len(attributes.cons_id) and len(emp_par_name)>
			AND C.CONSUMER_ID = #attributes.cons_id#
			<cfelseif len(attributes.par_id) and len(emp_par_name)>
			AND 1=0
			<cfelseif len(attributes.emp_id) and len(emp_par_name)>
			AND 1=0
			</cfif>
			<cfif len(attributes.is_completed) and attributes.is_completed eq 1>
			AND (VAR_NAME LIKE 'cmi.completion_status' OR VAR_NAME LIKE 'cmi.core.lesson_status')
			AND CAST(VAR_VALUE AS varchar(50)) = 'completed'
			<cfelseif len(attributes.is_completed) and attributes.is_completed eq 0>
			AND (VAR_NAME LIKE 'cmi.completion_status' OR VAR_NAME LIKE 'cmi.core.lesson_status')
			AND CAST(VAR_VALUE AS varchar(50)) <> 'completed'
			</cfif>
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_data.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform method="post" action="#request.self#?fuseaction=training_management.popup_list_training_sco_data" name="form">
	<cf_medium_list_search title="#getLang('main',178)#">
		<cf_medium_list_search_area>
			<table align="right">
			<cfinput type="hidden" name="class_id" value="#attributes.class_id#">
				<tr> 
					<td class="label"><cf_get_lang_main no='48.Filtre'></td>
					<td><cfinput type="text" name="keyword" value="#attributes.keyword#"></td>
					<td><cf_get_lang_main no='1983.Katılımcı'></td>
					<td>
						<input type="hidden" name="emp_id" id="emp_id" value="<cfif isdefined("attributes.emp_id") and len(attributes.emp_id) and isdefined("attributes.emp_par_name") and len(attributes.emp_par_name)><cfoutput>#attributes.emp_id#</cfoutput></cfif>">
						<input type="hidden" name="par_id" id="par_id" value="<cfif isdefined("attributes.par_id") and len(attributes.par_id) and isdefined("attributes.emp_par_name") and len(attributes.emp_par_name)><cfoutput>#attributes.par_id#</cfoutput></cfif>">
						<input type="hidden" name="cons_id" id="cons_id" value="<cfif isdefined("attributes.cons_id") and len(attributes.cons_id) and isdefined("attributes.emp_par_name") and len(attributes.emp_par_name)><cfoutput>#attributes.cons_id#</cfoutput></cfif>">
						<input type="text" name="emp_par_name" id="emp_par_name" value="<cfif isdefined("attributes.emp_par_name") and len(attributes.emp_par_name)><cfoutput>#attributes.emp_par_name#</cfoutput></cfif>" onFocus="AutoComplete_Create('emp_par_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',0,0,0','EMPLOYEE_ID,PARTNER_ID,CONSUMER_ID','EMP_ID,PAR_ID,CONS_ID','','3','120');" autocomplete="on"/>
						<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=form.emp_id&field_name=form.emp_par_name&field_partner=form.par_id&field_consumer=form.cons_id&select_list=1<cfif get_module_user(4)>,2,8</cfif></cfoutput>','list');"><img src="/images/plus_thin.gif" border="0" align="absmiddle"></a>
					</td>
					<td>
						<select name="is_completed" id="is_completed" style="width:150px;">
							<option value=""><cf_get_lang main no='296.Tümü'></option>
							<option value="1"<cfif attributes.is_completed eq 1>selected</cfif>><cf_get_lang no='16.Tamamlayanlar'></option>
							<option value="0"<cfif attributes.is_completed eq 0>selected</cfif>><cf_get_lang no='20.Tamamlamayanlar'></option>
						</select>
					</td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
					<td><cf_wrk_search_button></td>
				</tr>
			</table>
		</cf_medium_list_search_area>
	</cf_medium_list_search>
</cfform>
<cf_medium_list>
	<thead>
		<tr>
			<th width="125"><cf_get_lang_main no='158.Adı Soyadı'></th>
			<th><cf_get_lang_main no='162.Şirket'></th>
			<th><cf_get_lang main no='7.Eğitim'></th>
			<th><cf_get_lang no='11.Versiyon'></th>
			<th><cf_get_lang no='45.Toplam Oturum Süresi'></th>
			<th><cf_get_lang no='28.Tamamlanma Oranı'></th>
			<th><cf_get_lang no='31.Tamamlanma Durumu'></th>
			<th><cf_get_lang no='59.Başarı Durumu'></th>
			<th><cf_get_lang_main no='1975 .Skor'></th>
			<th>
				<!---toplu print --->
				<cfoutput><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_operate_page&operation=emptypopup_dsp_print_training_certificate&action=print&id=#attributes.class_id#&module=training&trail=0','page');return false;"><img src="/images/print2.gif" title="" border="0"></a></cfoutput>
			</th>
		</tr>
	</thead>
	<tbody>
			<cfif get_data.recordcount>
			<cfoutput query="get_data">
					<cfquery name="get_total_time" datasource="#APPLICATION_DB#">
						SELECT ISNULL(VAR_VALUE, '') AS TOTAL_TIME FROM #TABLE_SCO_DATA# WHERE SCO_ID = #SCO_ID# AND USER_ID = #get_data.USERID# AND VAR_NAME = <cfqueryparam value="#getVarName(tag: 'totalTime', version: get_data.VERSION)#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfif get_total_time.recordCount eq 0>
						<cfset QueryAddRow(get_total_time, 1)>
						<cfset QuerySetCell(get_total_time, "TOTAL_TIME", "-", 1)>
					</cfif>
					
					<cfquery name="get_score" datasource="#APPLICATION_DB#">
						SELECT ISNULL(VAR_VALUE, '0') AS SCORE FROM #TABLE_SCO_DATA# WHERE SCO_ID = #SCO_ID# AND USER_ID = #get_data.USERID# AND VAR_NAME = <cfqueryparam value="#getVarName(tag: 'score', version: get_data.VERSION)#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfif get_score.recordCount eq 0>
						<cfset QueryAddRow(get_score, 1)>
						<cfset QuerySetCell(get_score, "SCORE", "-", 1)>
					</cfif>
					
					<cfquery name="get_completion_status" datasource="#APPLICATION_DB#">
						SELECT ISNULL(VAR_VALUE, '') AS COMPLETION_STATUS FROM #TABLE_SCO_DATA# WHERE SCO_ID = #SCO_ID# AND USER_ID = #get_data.USERID# AND VAR_NAME = <cfqueryparam value="#getVarName(tag: 'completionStatus', version: get_data.VERSION)#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfif get_completion_status.recordCount eq 0>
						<cfset QueryAddRow(get_completion_status, 1)>
						<cfset QuerySetCell(get_completion_status, "COMPLETION_STATUS", "-", 1)>
					</cfif>
					
					<cfquery name="get_success_status" datasource="#APPLICATION_DB#">
						SELECT ISNULL(VAR_VALUE, '') AS SUCCESS_STATUS FROM #TABLE_SCO_DATA# WHERE SCO_ID = #SCO_ID# AND USER_ID = #get_data.USERID# AND VAR_NAME = <cfqueryparam value="#getVarName(tag: 'successStatus', version: get_data.VERSION)#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfif get_success_status.recordCount eq 0>
						<cfset QueryAddRow(get_success_status, 1)>
						<cfset QuerySetCell(get_success_status, "SUCCESS_STATUS", "-", 1)>
					</cfif>
					
					<cfquery name="get_progress" datasource="#APPLICATION_DB#">
						SELECT ISNULL(VAR_VALUE, '0') AS PROGRESS FROM #TABLE_SCO_DATA# WHERE SCO_ID = #SCO_ID# AND USER_ID = #USERID# AND VAR_NAME = <cfqueryparam value="#getVarName(tag: 'progress', version: get_data.VERSION)#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfif get_progress.recordCount eq 0>
						<cfset QueryAddRow(get_progress, 1)>
						<cfset QuerySetCell(get_progress, "PROGRESS", "-", 1)>
					</cfif>
					<cfquery name="get_data_id" datasource="#APPLICATION_DB#">
						SELECT DATA_ID FROM #TABLE_SCO_DATA# WHERE SCO_ID = #SCO_ID# AND USER_ID = #USERID# AND VAR_NAME = <cfqueryparam value="#getVarName(tag: 'userID', version: get_data.VERSION)#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfif get_data_id.recordCount eq 0>
						<cfset QueryAddRow(get_data_id, 1)>
						<cfset QuerySetCell(get_data_id, "DATA_ID", "-", 1)>
					</cfif>
					
					<cfset QuerySetCell(get_data, "TOTAL_TIME", get_total_time.TOTAL_TIME, currentRow)>
					<cfset QuerySetCell(get_data, "SCORE", "#get_score.SCORE#", currentRow)>
					<cfset QuerySetCell(get_data, "COMPLETION_STATUS", "#get_completion_status.COMPLETION_STATUS#", currentRow)>
					<cfset QuerySetCell(get_data, "SUCCESS_STATUS", "#get_success_status.SUCCESS_STATUS#", currentRow)>
					<cfset QuerySetCell(get_data, "PROGRESS", "#get_progress.PROGRESS#", currentRow)>
					<cfset QuerySetCell(get_data, "DATA_ID", "#get_data_id.DATA_ID#", currentRow)>
					
				</cfoutput>				
				<cfoutput query="get_data" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#ADSOYAD#</td>
						<td>#NICK_NAME#</td>
						<td>#NAME#</td>
						<td>#VERSION#</td>
						<td>#TOTAL_TIME#</td>
						<td><cfif isNumeric(PROGRESS)>% #round(PROGRESS * 100)#<cfelse>#PROGRESS#</cfif></td>
						<td><cfif COMPLETION_STATUS eq 'incomplete'><cf_get_lang_main no='2068.Tamamlanmadı'><cfelseif COMPLETION_STATUS eq 'completed'><cf_get_lang_main no='1374.Tamamlandı'></cfif></td>
						<td>#SUCCESS_STATUS#</td>
						<td><cfif isNumeric(SCORE)>#round(SCORE)#<cfelse>#SCORE#</cfif></td>
						<td width="15"><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_print_files&iid=#data_id#&print_type=320','print_page','workcube_print');"><img src="/images/print2.gif" title="<cf_get_lang_main no='62.Yazdır'>" border="0"></a></td>
					</tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="10"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
				</tr>
			</cfif>
	</tbody>
</cf_medium_list>			
<cfif (attributes.totalrecords gt attributes.maxrows)>
	<table width="99%" align="center">
		<tr> 
			<td height="35">
				<cf_pages page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="training_management.popup_list_training_sco_data#url_str#"> 
			</td>
			<!-- sil --><td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
		</tr>
	</table>
</cfif>
