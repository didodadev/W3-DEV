<cfparam name="attributes.keyword" default="">
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.training_sec_id")>
  <cfset url_str = "#url_str#&training_sec_id=#attributes.training_sec_id#">
<cfelse>
	<cfset attributes.training_sec_id = 0>
</cfif>
<cfif isdefined("attributes.attenders")>
  <cfset url_str = "#url_str#&attenders=#attributes.attenders#">
<cfelse>
	<cfset attributes.attenders = 0>
</cfif>
<cfif isdefined("attributes.form_submitted")>
  <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>
<cfset cfc= createObject("component","V16.training_management.cfc.TrainingTest")>
<cfset get_training_secs=cfc.GET_TRAINING_SECS_FUNC()>
<cfif isdefined("attributes.form_submitted")>
	<cfset GET_QUIZS=cfc.GET_QUIZS_FUNC(
		TRAINING_SEC_ID:attributes.TRAINING_SEC_ID,
		ATTENDERS:attributes.ATTENDERS,
		KEYWORD:attributes.KEYWORD)>
<cfelse>
	<cfset get_quizs.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_quizs.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform method="post" action="#request.self#?fuseaction=training_management.list_quizs">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
				<div class="form-group" id="item-keyword">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" id="keyword" placeholder="#place#" value="#attributes.keyword#" maxlength="50">
				</div>
				<div class="form-group" id="item-training_sec_id">
					<select name="training_sec_id" id="training_sec_id" style="width:125px;">
						<option value="0" selected><cf_get_lang dictionary_id ='46714.Tüm Bölümler'> 
						<cfoutput query="get_training_secs">
							<option value="#training_sec_id#" <cfif attributes.training_sec_id eq training_sec_id>selected</cfif>>#SECTION_NAME#
						</cfoutput>
					</select>
				</div>
				<div class="form-group" id="item-attenders">
					<select name="attenders" id="attenders">
						<option value="0" <cfif attributes.attenders eq 0>selected</cfif>><cf_get_lang dictionary_id='57952.Herkes'>
						<option value="1" <cfif attributes.attenders eq 1>selected</cfif>><cf_get_lang dictionary_id='58875.Çalışanlar'>
						<option value="2" <cfif attributes.attenders eq 2>selected</cfif>><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'>
						<option value="3" <cfif attributes.attenders eq 3>selected</cfif>><cf_get_lang dictionary_id='29406.Bireysel Üyeler'>
					</select>
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:10px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang(59,'Eğitim Testleri genel',46059)#" uidrop="1" hide_table_column="1">
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='58826.Test Başlığı'></th>
					<th><cf_get_lang dictionary_id='46239.Amaç'></th>
					<th><cf_get_lang dictionary_id='46249.Kimler Katılmalı'></th>
					<th><cf_get_lang dictionary_id='29775.Hazırlayan'></th>
					<th><cf_get_lang dictionary_id='29513.Süre'></th>
					<th><cf_get_lang dictionary_id='57482.Aşama'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th width="20" class="header_icn_none text-center"><i class="fa fa-bar-chart" title="<cf_get_lang dictionary_id='58135.Sonuçlar'>" alt="<cf_get_lang dictionary_id='58135.Sonuçlar'>"></i></a></th>
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=training_management.list_quizs&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_quizs.recordcount>
					<cfset list_employee_id=''>
					<cfset list_partner_id=''>
					<cfset list_stage_id = ''>
						<cfoutput query="get_quizs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<cfif not listfind(list_employee_id,RECORD_EMP)>
								<cfset list_employee_id=listappend(list_employee_id,RECORD_EMP)>
							</cfif>
							<cfif not listfind(list_partner_id,RECORD_PAR)>
								<cfset list_partner_id=listappend(list_partner_id,RECORD_PAR)>
							</cfif>
							<cfif len(stage_id) and not listfind(list_stage_id,STAGE_ID)>
								<cfset list_stage_id=listappend(list_stage_id,STAGE_ID)>
							</cfif>
						</cfoutput>
					<cfset list_employee_id=listsort(list_employee_id,"numeric")>
					<cfset list_partner_id=listsort(list_partner_id,"numeric")>
					<cfset list_stage_id=listsort(list_stage_id,"numeric")>
					<cfif len(list_employee_id)>
						<cfquery name="GET_EMPLOYEE" datasource="#dsn#">
							SELECT 
								EMPLOYEES.EMPLOYEE_ID,
								EMPLOYEES.EMPLOYEE_NAME,
								EMPLOYEES.EMPLOYEE_SURNAME
							FROM 
								EMPLOYEES
							WHERE
								EMPLOYEES.EMPLOYEE_ID IN (#list_employee_id#)
							ORDER BY 
								EMPLOYEES.EMPLOYEE_ID
						</cfquery>
					</cfif>
					<cfif len(list_partner_id)>
						<cfquery name="GET_PARTNER" datasource="#dsn#">
							SELECT 
								CP.PARTNER_ID,	
								CP.COMPANY_PARTNER_NAME,
								CP.COMPANY_PARTNER_SURNAME,
								CP.COMPANY_ID,
								CP.DEPARTMENT,
								C.FULLNAME,
								C.COMPANY_ID,
								CP.COMPANY_PARTNER_EMAIL
							FROM 
								COMPANY_PARTNER AS CP,
								COMPANY AS C
							WHERE
								CP.PARTNER_ID IN (#list_partner_id#) AND
								C.COMPANY_ID=CP.COMPANY_ID
							ORDER BY CP.PARTNER_ID
						</cfquery>
					</cfif>
					<cfif len(list_stage_id)>
						<cfquery name="get_stage" datasource="#dsn#">
							SELECT 
								STAGE_ID,
								STAGE_NAME
							FROM 
								SETUP_QUIZ_STAGE
							WHERE
								STAGE_ID IN(#list_stage_id#)
							ORDER BY
								STAGE_ID
						</cfquery>
					</cfif>
						<cfoutput query="get_quizs" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td height="22"><a href="#request.self#?fuseaction=training_management.list_quizs&event=det&quiz_id=#quiz_id#" class="tableyazi">#QUIZ_HEAD#</a></td>
							<td>#quiz_objective#</td>
							<td>
								<cfif len(quiz_partners)>
								<cf_get_lang dictionary_id='57585.Kurumsal Üye'>
								</cfif>
								<cfif len(quiz_partners) and ( len(quiz_consumers) or len(quiz_departments) )>
								,
								</cfif>
								<cfif len(quiz_consumers)>
								<cf_get_lang dictionary_id='57586.Bireysel Üye'>
								</cfif>
								<cfif len(quiz_consumers) and len(quiz_departments)>
								,
								</cfif>
								<cfif len(quiz_departments)>
								<cf_get_lang dictionary_id='57576.Çalışan'>
								</cfif>
							</td>
							<td><cfif len(RECORD_EMP)>
									<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=training_management.popup_detail_emp&emp_id=#GET_EMPLOYEE.EMPLOYEE_ID[listfind(list_employee_id,RECORD_EMP,',')]#','project');" class="tableyazi">#GET_EMPLOYEE.EMPLOYEE_NAME[listfind(list_employee_id,RECORD_EMP,',')]# #GET_EMPLOYEE.EMPLOYEE_SURNAME[listfind(list_employee_id,RECORD_EMP,',')]#</a>
								<cfelseif len(RECORD_PAR)>
									<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#GET_PARTNER.PARTNER_ID[listfind(list_partner_id,RECORD_PAR,',')]#','medium');" class="tableyazi">#GET_PARTNER.COMPANY_PARTNER_NAME[listfind(list_partner_id,RECORD_PAR,',')]# #GET_PARTNER.COMPANY_PARTNER_SURNAME[listfind(list_partner_id,RECORD_PAR,',')]#</a>
								</cfif>
							</td>
							<td>#total_time#<cf_get_lang dictionary_id='58127.dk'></td>
							<td><cfif len(stage_id)>#get_stage.stage_name[listfind(list_stage_id,stage_id,',')]#</cfif><!---#stage_name#---></td>
							<td>#dateformat(record_date,dateformat_style)#</td>
							<!-- sil -->
							<td nowrap="nowrap">
								<a href="#request.self#?fuseaction=training_management.list_quizs&event=dashboard&quiz_id=#quiz_id#"><i class="fa fa-bar-chart" title="<cf_get_lang dictionary_id='58135.Sonuçlar'>"></i></a>
							</td>
							<td nowrap="nowrap">
								<a href="#request.self#?fuseaction=training_management.list_quizs&event=det&quiz_id=#quiz_id#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
							</td>
							<!-- sil -->
						</tr>
						</cfoutput>
				<cfelse>
					<tr>
						<td colspan="8" class="color-row"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif get_quizs.recordcount and (attributes.totalrecords gt attributes.maxrows)>
			<cf_paging
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#attributes.fuseaction##url_str#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

