<cfparam name="attributes.keyword" default="">
<cfset url_str = "">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
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
		CASE WHEN TR.USER_TYPE= 0 THEN  
		(SELECT EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID = TR.USER_ID) 
		WHEN TR.USER_TYPE= 1 THEN
		(SELECT COMPANY_PARTNER_NAME+' '+COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE PARTNER_ID = TR.USER_ID) 
		WHEN TR.USER_TYPE =2 THEN 
		(SELECT CONSUMER_NAME+' 'CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID = TR.USER_ID) 
		END 
		AS ONERILEN,
		TR.CLASS_ID,
		TR.RECORD_DATE,
		TR.DETAIL,
		TC.CLASS_NAME,
		TR.USER_TYPE,
		TR.RECORDED_TYPE
	FROM	
		TRAINING_RECOMMENDATIONS TR,
		TRAINING_CLASS TC
	WHERE
		TR.CLASS_ID = TC.CLASS_ID
		<cfif len(attributes.keyword)>
		AND (
			TC.CLASS_NAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
			OR TR.RECORDED_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
			OR TR.USER_ID IN(SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_NAME+' '+EMPLOYEE_SURNAME LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI)
			OR TR.DETAIL LIKE '%#attributes.keyword#%' COLLATE SQL_Latin1_General_CP1_CI_AI
		)
		</cfif>
		AND 
			(
				<cfif isdefined("session.ep.userid")>
				(TR.USER_TYPE = 0 AND TR.USER_ID = #session.ep.userid#) OR
				(TR.RECORDED_TYPE = 0 AND TR.RECORDED_ID = #session.ep.userid#)
				<cfelseif isdefined("session.pp.userid")>
				(TR.USER_TYPE = 0 AND TR.USER_ID = #session.pp.userid#) OR
				(TR.RECORDED_TYPE = 0 AND TR.RECORDED_ID = #session.pp.userid#)
				<cfelseif isdefined("session.ww.userid")>
				(TR.USER_TYPE = 0 AND TR.USER_ID = #session.ww.userid#) OR
				(TR.RECORDED_TYPE = 0 AND TR.RECORDED_ID = #session.ww.userid#)
				</cfif>
			)
	ORDER BY TR.ID DESC
</cfquery>
<cfelse>
	<cfset get_train_recommendation.recordcount = 0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_train_recommendation.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform method="post" action="#request.self#?fuseaction=training.list_training_recommendations">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
<cf_big_list_search title="#getLang('training',79)#"> 
	<cf_big_list_search_area>
		<table>
			<tr>
				<td class="label"><cf_get_lang_main no='48.Filtre'></td>
				<td><cfinput type="text" name="keyword" maxlength="50"  value="#attributes.keyword#"></td>
				<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber (this)" style="width:25px;"></td>
				<td><cf_wrk_search_button></td>
			</tr>
		</table>
	</cf_big_list_search_area>
</cf_big_list_search> 
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th width="35"><cf_get_lang_main no='1165.Sira'></th>
			<th><cf_get_lang no='3.Oneren'></th>
			<th><cf_get_lang no='4.Onerilen'></th>
			<th><cf_get_lang_main no='7.Eğitim'></th>
			<th width="300"><cf_get_lang_main no='217.Açıklama'></th>
			<th width="80"><cf_get_lang_main no='215.Kayıt Tarihi'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_train_recommendation.recordcount>
			<cfoutput query="get_train_recommendation" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td width="35">#currentrow#</td>
					<td>#ONEREN#</td>
					<td>#ONERILEN#</td>
					<td><a href="#request.self#?fuseaction=training.view_class&class_id=#class_id#" class="tableyazi">#CLASS_NAME#</a></td>
					<td>#DETAIL#</td>
					<td>#dateformat(record_date,dateformat_style)#</td>
				</tr>
			</cfoutput>
			<cfelse>
				<tr>
					<td colspan="6" class="color-row"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'><cfelse><cf_get_lang_main no='289.Filtre Ediniz '></cfif></td>
				</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
	<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td height="35">
				<cfif len(attributes.form_submitted)>
				<cfset url_str="#url_str#&form_submitted=#attributes.form_submitted#">
				</cfif>
					<cf_pages page="#attributes.page#"
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="training.list_training_recommendations#url_str#">
			</td>
			<!-- sil -->
			<td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
			<!-- sil -->
		</tr>
	</table>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

