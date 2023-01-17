<cfparam name="attributes.keyword" default="">
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.form_submitted")>
<cfquery name="get_train_recommendation" datasource="#dsn#">
	SELECT
		CASE WHEN TR.RECORDED_TYPE= 0 THEN  
		(SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = TR.RECORDED_ID) 
		WHEN TR.RECORDED_TYPE= 1 THEN
		(SELECT COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = TR.RECORDED_ID) 
		WHEN TR.RECORDED_TYPE =2 THEN 
		(SELECT CONSUMER_NAME+' 'CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = TR.RECORDED_ID) 
		END 
		AS ONEREN, 
		(SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = TR.USER_ID) AS ONERILEN,
		TR.CLASS_ID,
		TR.RECORD_DATE,
		TR.DETAIL,
		TC.CLASS_NAME,
		TR.USER_TYPE,
		TR.ID
	FROM	
		TRAINING_RECOMMENDATIONS TR,
		TRAINING_CLASS TC
	WHERE
		TR.CLASS_ID = TC.CLASS_ID AND
		TR.USER_TYPE = 0
		<cfif len(attributes.keyword)>
		AND (
			TC.CLASS_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			OR TR.RECORDED_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
			OR TR.USER_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
			OR TR.DETAIL LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		)
		</cfif>
	UNION ALL
	SELECT
		CASE WHEN TR.RECORDED_TYPE= 0 THEN  
		(SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = TR.RECORDED_ID) 
		WHEN TR.RECORDED_TYPE= 1 THEN
		(SELECT COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = TR.RECORDED_ID) 
		WHEN TR.RECORDED_TYPE =2 THEN 
		(SELECT CONSUMER_NAME+' 'CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = TR.RECORDED_ID) 
		END 
		AS ONEREN, 
		(SELECT COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID=TR.USER_ID) AS ONERILEN,
		TR.CLASS_ID,
		TR.RECORD_DATE,
		TR.DETAIL,
		TC.CLASS_NAME,
		TR.USER_TYPE,
		TR.ID
	FROM	
		TRAINING_RECOMMENDATIONS TR,
		TRAINING_CLASS TC
	WHERE
		TR.CLASS_ID = TC.CLASS_ID AND
		TR.USER_TYPE = 1
		<cfif len(attributes.keyword)>
		AND (
			TC.CLASS_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			OR TR.RECORDED_ID IN(SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER_SURNAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
			OR TR.USER_ID IN(SELECT PARTNER_ID FROM COMPANY_PARTNER WHERE COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER_SURNAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
			OR TR.DETAIL LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			)
		</cfif>
	UNION ALL
	SELECT
		CASE WHEN TR.RECORDED_TYPE= 0 THEN  
		(SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = TR.RECORDED_ID) 
		WHEN TR.RECORDED_TYPE= 1 THEN
		(SELECT COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = TR.RECORDED_ID) 
		WHEN TR.RECORDED_TYPE =2 THEN 
		(SELECT CONSUMER_NAME+' 'CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = TR.RECORDED_ID) 
		END 
		AS ONEREN, 
		(SELECT CONSUMER_NAME+' '+CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID=TR.USER_ID) AS ONERILEN,
		TR.CLASS_ID,
		TR.RECORD_DATE,
		TR.DETAIL,
		TC.CLASS_NAME,
		TR.USER_TYPE,
		TR.ID
	FROM	
		TRAINING_RECOMMENDATIONS TR,
		TRAINING_CLASS TC
	WHERE
		TR.CLASS_ID = TC.CLASS_ID AND
		TR.USER_TYPE = 2
		<cfif len(attributes.keyword)>
		AND (
			TC.CLASS_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			OR TR.RECORDED_ID IN(SELECT CONSUMER_ID FROM CONSUMER WHERE CONSUMER_NAME+' '+CONSUMER_SURNAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
			OR TR.USER_ID IN(SELECT CONSUMER_ID FROM CONSUMER WHERE CONSUMER_NAME+' '+CONSUMER_SURNAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
			OR TR.DETAIL LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			)
		</cfif>
	ORDER BY
		TR.ID DESC
</cfquery>
<cfelse>
	<cfset get_train_recommendation.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_train_recommendation.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
		<cfform method="post" action="#request.self#?fuseaction=training_management.list_training_recommendations">
			<input type="hidden" name="form_submitted" id="form_submitted" value="1">
			<cf_box_search more="0">
				<div class="form-group">
					<cfinput type="text" name="keyword" id="keyword" maxlength="50" value="#attributes.keyword#" placeHolder="#getLang(48,'Filtre',57460)#">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='46067.Training Suggestions | GENERAL'></cfsavecontent>
	<cf_box  title="#head#" uidrop="1" hide_table_column="1" resize="1" collapsable="1">
		<cf_grid_list sort="0">
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='46276.Öneren'></th>
					<th><cf_get_lang dictionary_id='46277.Önerilen'></th>
					<th><cf_get_lang dictionary_id='57419.Eğitim'></th>
					<th><cf_get_lang dictionary_id='57629.Açıklama'></th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
				</tr>
			</thead>
			<tbody>
				<cfif get_train_recommendation.recordcount>
					<cfoutput query="get_train_recommendation" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#ONEREN#</td>
							<td>#ONERILEN#</td>
							<td><a href="#request.self#?fuseaction=training_management.list_training_recommendations&event=upd&class_id=#class_id#" class="tableyazi">#CLASS_NAME#</a></td>
							<td style="width:300px;">#DETAIL#</td>
							<td>#dateformat(record_date,dateformat_style)#</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="6" class="color-row"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
			<cfif len(attributes.form_submitted)>
			<cfset url_str="#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
				<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="training_management.list_training_recommendations#url_str#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
