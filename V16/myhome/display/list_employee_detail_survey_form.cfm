<!--- kullaniciya g�nderilen deneme s�resi degerlendirme ve isten �ikis degerlendirme formlari burada listelenir SG 20120921--->
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.type_id" default="">
<cfif isdefined('attributes.form_submitted')>
	<cfquery name="get_main_result" datasource="#dsn#">
		SELECT
			SM.SURVEY_MAIN_HEAD AS HEAD,
			SM.SURVEY_MAIN_ID,
			SM.TYPE,
			SR.SURVEY_MAIN_RESULT_ID,
			SR.ACTION_TYPE,
			SR.ACTION_ID,
			SR.EMP_ID,
			SR.IS_SHOW_EMPLOYEE,
			SR.START_DATE,
			SR.FINISH_DATE,
			SR.RECORD_DATE,
			E.EMPLOYEE_NO,
			ETT.TEST_TIME_TYPE_NAME,
			ET.RECORD_DATE AS ATAMA_TARIHI,
			ET.TEST_TIME_DAY,
			EI.START_DATE AS STARTDATE,
			SR.SCORE_RESULT,
			PTR.STAGE
		FROM
			SURVEY_MAIN SM,
			SURVEY_MAIN_RESULT SR
			LEFT JOIN EMPLOYEES_TEST_TIME ET ON  SR.ACTION_ID = ET.EMPLOYEE_ID
			LEFT JOIN EMPLOYEES_TEST_TIME_TYPE ETT ON  ET.TEST_TIME_TYPE = ETT.EMPLOYEES_TEST_TIME_TYPE_ID
			LEFT JOIN EMPLOYEES E ON  ET.EMPLOYEE_ID = E.EMPLOYEE_ID
			LEFT JOIN EMPLOYEES_IN_OUT EI ON  EI.EMPLOYEE_ID = SR.ACTION_ID
			LEFT JOIN PROCESS_TYPE_ROWS PTR ON PTR.PROCESS_ROW_ID = ET.TEST_TIME_STAGE
		WHERE
			SR.SURVEY_MAIN_ID = SM.SURVEY_MAIN_ID AND
			(SR.EMP_ID = #session.ep.userid# 
			OR (SR.ACTION_ID = #session.ep.userid# AND SM.TYPE <> 10 AND SR.IS_SHOW_EMPLOYEE = 1) 
			)
			AND (SM.START_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> AND
			SM.FINISH_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> ) AND
			SM.TYPE IN (6,10) AND <!--- deneme süresi ve isten çikis formlari--->
			SR.ACTION_TYPE IS NOT NULL AND
			SR.ACTION_ID IS NOT NULL AND
			(
			<!---deneme süresi tipindeki formlar deneme s�resi uyari tarihi geldikten sonra gosterilmeli --->
				(SM.TYPE = 6 AND GETDATE() >= (SELECT TOP 1 (DATEADD(d,(TEST_TIME_DAY-CAUTION_TIME_DAY),(SELECT TOP 1 START_DATE FROM EMPLOYEES_IN_OUT WHERE EMPLOYEE_ID = SR.ACTION_ID ORDER BY IN_OUT_ID DESC))) AS STARTDATE FROM EMPLOYEES_TEST_TIME WHERE EMPLOYEE_ID = SR.ACTION_ID))
				OR 
				SM.TYPE <> 6
			)
			<cfif len(attributes.type_id)>
				AND SM.TYPE = #attributes.type_id#
			</cfif>
			<cfif len(attributes.keyword)>
				AND 
				(
					SM.SURVEY_MAIN_HEAD LIKE '%#attributes.keyword#%'
				)
			</cfif>
		ORDER BY
			SR.RECORD_DATE DESC
	</cfquery>
<cfelse>
	<cfset get_main_result.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfparam name="attributes.totalrecords" default='#get_main_result.recordcount#'>
<div class="col col-12">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='29744.Değerlendirme Formları'></cfsavecontent>
	<cf_box title="#message#" closable="0" uidrop="1" hide_table_column="1">
		<cfform name="search" method="post" action="#request.self#?fuseaction=myhome.list_employee_detail_survey_form">
			<input type="hidden" name="form_submitted" value="1">
			<!--- <cf_big_list_search title="#getLang('main',1947)#">
			<cf_big_list_search_area> --->
				<cf_box_search more="0">
					<div class="form-group" id="item-keyword">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
						<cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
					</div>		 
					<div class="form-group" id="item-type_id">
						<select name="type_id" id="type_id">
							<option value=""><cf_get_lang dictionary_id='29785.Lütfen Tip Seçiniz'></option>
							<cfoutput>
								<option value="6" <cfif isdefined("attributes.type_id") and attributes.type_id eq 6>selected</cfif>><cf_get_lang dictionary_id='29776.Deneme Süresi'></option>
								<option value="10" <cfif isdefined("attributes.type_id") and attributes.type_id eq 10>selected</cfif>><cf_get_lang dictionary_id='29832.İşten Çıkış'></option>
								<option value="14" <cfif isdefined("attributes.type_id") and attributes.type_id eq 14>selected</cfif>>Anket</option>
							</cfoutput>
						</select>
					</div>	
					<div class="form-group small">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
					</div>
					<div class="form-group">
						<cf_wrk_search_button button_type="4">
					</div>
				</cf_box_search>
			<!--- </cf_big_list_search_area>
			</cf_big_list_search> --->
		</cfform>
		<cf_flat_list>
				<thead>
					<tr>
						<th width="35"><cf_get_lang dictionary_id='58577.Sira'></th>
						<th><cf_get_lang dictionary_id='56542.Sicil No'></th>
						<th><cf_get_lang dictionary_id='46196.Değerlendirilen'></th>
						<th><cf_get_lang dictionary_id='29764.Form'></th>
						<th><cf_get_lang dictionary_id='59264.Form Tipi'></th>
						<th><cf_get_lang dictionary_id='61259.Atama Tarihi'></th>
						<th><cf_get_lang dictionary_id='56685.Değerlendirme'><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
						<th><cf_get_lang dictionary_id='58984.Puan'></th>
						<th><cf_get_lang dictionary_id='58859.Süreç'></th>
						<th></th>
					</tr>
				</thead>
				<tbody>
					<cfif get_main_result.recordcount>
						<cfoutput query="get_main_result" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
							<tr>
								<td width="35">#currentrow#</td>
								<td>#employee_no#</td>
								<td>#get_emp_info(action_id,0,0)#</td>
								<td>#head#</td>
								<td>
									<!--- <cfif type eq 1>
										<cf_get_lang dictionary_id='57612.Firsat'>
									<cfelseif type eq 2>
										<cf_get_lang dictionary_id='57653.İçerik'>
									<cfelseif type eq 3>
										<cf_get_lang dictionary_id='57446.Kampanya'>
									<cfelseif type eq 4>
										<cf_get_lang dictionary_id='57657.Ürün'>
									<cfelseif type eq 5>
										<cf_get_lang dictionary_id='57416.Proje'>
									<cfelseif type eq 6>
										<cf_get_lang dictionary_id='29776.Deneme Süresi'>
									<cfelseif type eq 7>
										<cf_get_lang dictionary_id='57996.İşe Alım'>
									<cfelseif type eq 8>
										<cf_get_lang dictionary_id='58003.Performans'>
									<cfelseif type eq 9>
										<cf_get_lang dictionary_id='57419.Egitim'>
									<cfelseif type eq 10>
										<cf_get_lang dictionary_id='29832.İşten Çıkış'>
									</cfif>	 --->
									#TEST_TIME_TYPE_NAME#
								</td>					
								<td>#dateformat(ATAMA_TARIHI,dateformat_style)#</td>
								<td>
									#dateformat(dateadd('d',test_time_day,STARTDATE),dateformat_style)#</td>
									<td>#TLformat(score_result,session.ep.our_company_info.rate_round_num)#</td>
									<td>#stage#</td>
								<td width="35"> 
									<cfquery name="get_question_result" datasource="#dsn#">
										SELECT SURVEY_MAIN_RESULT_ID FROM SURVEY_QUESTION_RESULT WHERE SURVEY_MAIN_RESULT_ID = #survey_main_result_id#
									</cfquery>
									<cfif fusebox.circuit eq 'myhome'>
										<cfset survey_main_id_ = contentEncryptingandDecodingAES(isEncode:1,content:survey_main_id,accountKey:session.ep.userid)>
										<cfset survey_main_result_id_ = contentEncryptingandDecodingAES(isEncode:1,content:survey_main_result_id,accountKey:session.ep.userid)>
									<cfelse>
										<cfset survey_main_id_ = survey_main_id>
										<cfset survey_main_result_id_ = survey_main_result_id>
									</cfif>
									<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_form_upd_detailed_survey_main_result&fbx=myhome&survey_id=#survey_main_id_#&result_id=#survey_main_result_id_#&is_popup=1','page')">
									<cfif not get_question_result.recordcount>
										<i class="fa fa-plus" title="<cf_get_lang dictionary_id='57762.Formu doldur'>"></i>
									<cfelseif get_main_result.action_id neq session.ep.userid>
										<i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>
									<cfelse>
										<i class="fa fa-eye" title="<cf_get_lang dictionary_id='54685.Sonuçları İncele'>"></i>
									</cfif>
									</a>
								</td>
							</tr>
						</cfoutput>
					<cfelse>
						<tr>
							<td colspan="10"><cfif isdefined('attributes.form_submitted')><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'><cfelse><cf_get_lang dictionary_id='57701.Filtre ediniz'></cfif>!</td>
						</tr>
					</cfif>
				</tbody>
		</cf_flat_list>
		<cfset url_str = "">
		<cfif len(attributes.keyword)>
			<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
		</cfif>
		<cfif len(attributes.type_id)>
			<cfset url_str = "#url_str#&type_id=#attributes.type_id#">
		</cfif>
		<cfif isdefined('attributes.form_submitted')>
			<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
		</cfif>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cf_paging 
						page="#attributes.page#" 
						maxrows="#attributes.maxrows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#" 
						adres="myhome.list_employee_detail_survey_form#url_str#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>