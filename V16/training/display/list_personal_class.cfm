<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.valid" default="">
<cfparam name="attributes.periodyear" default="#year(now())#">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.branch_name" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.department_name" default="">
<cfquery name="get_training_req" datasource="#dsn#">
	SELECT * FROM TRAINING_REQUEST WHERE EMPLOYEE_ID = #session.ep.userid# AND REQUEST_YEAR = #year(DATEADD('YYYY',+1,now()))#
</cfquery>
<cfif isdefined("attributes.is_submit")>
<cfquery name="GET_TRAINING_JOIN_REQUESTS" datasource="#dsn#">
	SELECT 
		TR.*,
		EP.EMPLOYEE_NAME,
		EP.EMPLOYEE_SURNAME,
		EPS.POSITION_NAME,
		D.DEPARTMENT_HEAD,
		B.BRANCH_NAME,
		OC.COMPANY_NAME
	FROM 
		TRAINING_REQUEST AS TR,
		EMPLOYEES AS EP,
		EMPLOYEE_POSITIONS EPS,
		DEPARTMENT D,
		BRANCH B,
		OUR_COMPANY OC
	WHERE
		EPS.POSITION_CODE = TR.POSITION_CODE AND
		EPS.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.BRANCH_ID = B.BRANCH_ID AND 
		B.COMPANY_ID = OC.COMP_ID AND
		EP.EMPLOYEE_ID = TR.EMPLOYEE_ID AND
		EPS.EMPLOYEE_ID = EP.EMPLOYEE_ID AND 
		(
			TR.EMPLOYEE_ID = #session.ep.userid# OR
			TR.FIRST_BOSS_ID = #session.ep.userid#  OR 
			TR.SECOND_BOSS_ID = #session.ep.userid#  OR 
			TR.THIRD_BOSS_ID = #session.ep.userid#  OR 
			TR.FOURTH_BOSS_ID = #session.ep.userid#  OR 
			TR.FIFTH_BOSS_ID = #session.ep.userid# OR
			TR.FIRST_BOSS_CODE = #session.ep.position_code# OR
			TR.SECOND_BOSS_CODE = #session.ep.position_code# OR
			TR.THIRD_BOSS_CODE = #session.ep.position_code#
		)
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
		AND
		(
			EP.EMPLOYEE_NAME LIKE '%#attributes.keyword#%' OR
			EP.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
		)
		</cfif>
		<cfif len(attributes.periodyear)>AND REQUEST_YEAR = #attributes.periodyear#</cfif>
		<cfif len(attributes.department_id) and len(attributes.department_name)>AND EPS.DEPARTMENT_ID = #attributes.department_id#</cfif>
		<cfif len(attributes.branch_id) and len(attributes.branch_name)>AND EPS.BRANCH_ID = #attributes.branch_id#</cfif>
	ORDER BY
		TR.RECORD_DATE DESC,
		EP.EMPLOYEE_NAME,
		EP.EMPLOYEE_SURNAME 
</cfquery>
<cfelse>
<cfset get_training_join_requests.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_training_join_requests.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="form1" method="post" action="#request.self#?fuseaction=training.list_class_request">
<input type="hidden" name="is_submit" id="is_submit" value="1">
<cf_big_list_search title="#getLang('training',112)#"> 
	<cf_big_list_search_area>
		<table>
			<tr> 
				<td><cf_get_lang_main no='48.Filtre'></td>
				<td><cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="50" style="width:100px;"></td>
				<td><cf_get_lang no ='135.Departman/Şube'></td>
				<td align="right" style="text-align:right;">
					<input type="hidden" name="branch_id" id="branch_id" value="<cfif isdefined("attributes.branch_id")><cfoutput>#attributes.branch_id#</cfoutput></cfif>">
					<input type="text" name="branch_name" id="branch_name" value="<cfif isdefined("attributes.branch_id") and len(attributes.branch_id) and len(attributes.branch_name)><cfoutput>#attributes.branch_name#</cfoutput></cfif>" style="width:100px;">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_branch_name=search.branch_name&field_branch_id=search.branch_id</cfoutput>','list');"><img src="/images/plus_thin.gif"></a>
					<input type="hidden" name="department_id" id="department_id" value="<cfif isdefined("attributes.department_id")><cfoutput>#attributes.department_id#</cfoutput></cfif>">
					<input type="text" name="department_name" id="department_name" value="<cfif isdefined("attributes.department_id") and len(attributes.department_id) and len(attributes.department_name)><cfoutput>#attributes.department_name#</cfoutput></cfif>" style="width:100px;">
					<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=hr.popup_list_departments&field_id=search.department_id&field_name=search.department_name&is_all_departments</cfoutput>','list');"><img src="/images/plus_thin.gif"></a>
				</td>
				<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)" style="width:25px;"></td>
				<td><select name="periodyear" id="periodyear">
					<cfoutput>
					<cfif get_training_req.recordcount>
					<cfloop from="2004" to="#year(date_add('YYYY',+1,now()))#" index="i">
						<option value="#i#" <cfif attributes.periodyear eq i>selected</cfif>>#i#</option>
					</cfloop>
					<cfelse>
					<cfloop from="2004" to="#year(now())#" index="i">
						<option value="#i#" <cfif attributes.periodyear eq i>selected</cfif>>#i#</option>
					</cfloop>
					</cfif>
					</cfoutput>
					</select>
				</td>
				<td><cf_wrk_search_button></td>
					<cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'> 
			</tr>
		</table>
	</cf_big_list_search_area>
</cf_big_list_search> 
</cfform>
<cf_big_list>
	<thead>
		<tr> 
			<th width="35"><cf_get_lang_main no='1165. Sıra'></th>
			<th><cf_get_lang_main no='158.Ad Soyad'></th>
			<th><cf_get_lang_main no='1085.Pozisyon'></th>
			<th><cf_get_lang no ='135.Departman/Şube'></th>
			<th><cf_get_lang_main no ='162.Şirket'></th>
			<th><cf_get_lang_main no='1043.Yıl'></th>
			<th><cf_get_lang no='95.Talep  Tarihi'></th>
			<th class="header_icn_none">
				<!--- <a href="<cfoutput>#request.self#</cfoutput>?fuseaction=training.form_add_class_request"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>"></a> --->
				<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=training.popup_form_add_training_request_annual','medium')"><img src="/images/plus_list.gif" title="Yıllık Eğitim Talebi Ekle"></a>
			</th>
		</tr>
	</thead>
	<tbody>
		<cfif GET_TRAINING_JOIN_REQUESTS.recordcount>
		<cfoutput query="GET_TRAINING_JOIN_REQUESTS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
			<tr>
				<td width="35">#currentrow#</td>
				<td><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#employee_id#','project');" class="tableyazi">#employee_name# #employee_surname#</a></td>
				<td>#position_name#</td>
				<td>#department_head#-#branch_name#</td>
				<td>#company_name#</td>
				<td>#request_year#</td>
				<td>#dateformat(record_date,dateformat_style)#</td>
			<!-- sil -->
				<td align="center">
					<!--- <a href="#request.self#?fuseaction=training.form_upd_class_request&train_req_id=#TRAIN_REQUEST_ID#" ><img src="/images/update_list.gif" title="<cf_get_lang no ='167.Ayrıntılar'>"></a> --->
					<cfif len(emp_validdate)>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training.popup_dsp_training_request_annual&train_req_id=#TRAIN_REQUEST_ID#','medium')"><img src="/images/update_list.gif" title="<cf_get_lang no ='1143.Ayrıntılar'>"></a>
					<cfelse>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training.popup_form_upd_training_request_annual&train_req_id=#TRAIN_REQUEST_ID#','medium')"><img src="/images/update_list.gif" title="<cf_get_lang no ='1143.Ayrıntılar'>"></a>
					</cfif>
				</td>
			<!-- sil -->
			</tr>
		</cfoutput> 
		<cfelse>
		<tr> 
			<td colspan="9"><cfif isdefined("attributes.is_submit")><cf_get_lang_main no='72.Kayıt Bulunamadı'><cfelse><cf_get_lang_main no='289.Filtre Ediniz'></cfif>!</td>
		</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfset adres = "">
<cfif fusebox.circuit is "training">
	<cfset adres = "training.list_class_request">
</cfif>
<cfif len(attributes.keyword)>
	<cfset adres = "#adres#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.is_submit")>
	<cfset adres = "#adres#&is_submit=#attributes.is_submit#">
</cfif>
<cf_paging 
	page="#attributes.page#" 
	maxrows="#attributes.maxrows#" 
	totalrecords="#attributes.totalrecords#" 
	startrow="#attributes.startrow#" 
	adres="#adres#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

