<cfparam name="attributes.keyword" default="">
<cfset url_str = "">
<cfquery name="get_class_scorm_results" datasource="#dsn#">
	SELECT
		TC.CLASS_NAME,
		TCS.NAME,
		E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME AS CALISAN,
		E.EMPLOYEE_NO,
		CS.COMPLETION_STATUS,
		S_RAW.SCORE_RAW,
		T_TIME.TOTAL_TIME,
		T_TIME.TOTAL_TIME_RECORD_DATE,
		TCSD.RECORD_DATE
	FROM
		TRAINING_CLASS TC,
		TRAINING_CLASS_SCO TCS,
		EMPLOYEES E,
		TRAINING_CLASS_SCO_DATA TCSD
			OUTER APPLY
				(
					SELECT
						VAR_VALUE AS COMPLETION_STATUS
					FROM
						TRAINING_CLASS_SCO_DATA TCSD2
					WHERE
						TCSD2.SCO_ID = TCSD.SCO_ID AND
						TCSD2.USER_ID = TCSD.USER_ID AND
						TCSD2.VAR_NAME = 'cmi.completion_status'
				) CS
			OUTER APPLY
				(
					SELECT
						VAR_VALUE AS SCORE_RAW
					FROM
						TRAINING_CLASS_SCO_DATA TCSD2
					WHERE
						TCSD2.SCO_ID = TCSD.SCO_ID AND
						TCSD2.USER_ID = TCSD.USER_ID AND
						TCSD2.VAR_NAME = 'cmi.score.raw'
				) S_RAW	
			OUTER APPLY
				(
					SELECT
						VAR_VALUE AS TOTAL_TIME,
						RECORD_DATE AS TOTAL_TIME_RECORD_DATE
					FROM
						TRAINING_CLASS_SCO_DATA TCSD2
					WHERE
						TCSD2.SCO_ID = TCSD.SCO_ID AND
						TCSD2.USER_ID = TCSD.USER_ID AND
						TCSD2.VAR_NAME = 'cmi.total_time'
				) T_TIME
	WHERE
		<cfif len(attributes.keyword)>
			(
				E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%'
				OR
				TCS.NAME LIKE '%#attributes.keyword#%'
			)
			AND
		</cfif>
		TCSD.SCO_ID = TCS.SCO_ID AND
		TCSD.USER_ID = E.EMPLOYEE_ID AND
		TCSD.VAR_NAME = 'cmi.learner_id' AND
		TC.CLASS_ID = TCS.CLASS_ID AND
		TC.CLASS_ID = #attributes.class_id#
</cfquery>


<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_class_scorm_results.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="form1" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_class&event=scorm_result&class_id=#attributes.class_id#">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search>
						<div class="form-group">
							<cfinput type="text" name="keyword" id="keyword" placeholder="#getLang('main',48)#" value="#attributes.keyword#" maxlength="50"style="width:100px;">
						</div>
						<div class="form-group small">
							<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)">
						</div>
						<div class="form-group">
							<cf_wrk_search_button button_type="4">
						</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cf_box title="#getLang('','Scorm Sonuçları','64249')#"  uidrop="1" hide_table_column="1" resize="0" collapsable="0"> 
		<cf_grid_list>
			<thead>
				<tr> 
					<th><cf_get_lang_main no='1165. Sıra'></th>
					<th><cf_get_lang_main no='7.Eğitim'></th>
					<th><cf_get_lang dictionary_id ='64242.Scorm'></th>
					<th><cf_get_lang dictionary_id ='58522.Kullanıcı Kodu'></th>
					<th><cf_get_lang dictionary_id ='57930.Kullanıcı'></th>
					<th><cf_get_lang dictionary_id ='64250.Scorm İzleme Tarihi'></th>
					<th><cf_get_lang dictionary_id ='34413.Tamamlanma'><cf_get_lang dictionary_id ='58593.Tarihi'></th>
					<th><cf_get_lang dictionary_id ='34413.Tamamlanma'><cf_get_lang dictionary_id ='30111.Durumu'></th>
					<th><cf_get_lang dictionary_id ='46266.Başarı Durumu'></th>
					<th><cf_get_lang dictionary_id ='38160.Tamamlanma Yüzdesi'></th>
					<th><cf_get_lang dictionary_id ='34413.Tamamlanma'><cf_get_lang dictionary_id ='56145.Süresi'></th>

				</tr>
			</thead>
			<tbody>
				<cfif get_class_scorm_results.recordcount>
					<cfoutput query="get_class_scorm_results" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
						<tr>
							<td>#currentrow#</td>
							<td>#CLASS_NAME#</td>
							<td>#NAME#</td>
							<td>#EMPLOYEE_NO#</td>
							<td>#CALISAN#</td>
							<td>#dateformat(RECORD_DATE,dateformat_style)#</td>
							<td>#dateformat(TOTAL_TIME_RECORD_DATE,dateformat_style)#</td>
							<td><cfif COMPLETION_STATUS is 'completed'>Tamamlandı<cfelse>Tamamlanmadı</cfif></td>
							<td>-</td>
							<td>#SCORE_RAW#</td>
							<td>#TOTAL_TIME#</td>
						</tr>
					</cfoutput> 
				<cfelse>
					<tr> 
						<td colspan="8"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>		
			<cf_paging 
				page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="training_management.list_class&event=scorm_result&class_id=#attributes.class_id##url_str#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
