 <cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cf_get_lang_set module_name="training">
<cfparam name="attributes.keyword" default="">
<cfinclude template="../query/get_training_cats.cfm">
<cfinclude template="../query/get_training_sec_names.cfm">
<cfquery name="get_training_cat" datasource="#dsn#">
	SELECT 
    	TRAINING_CAT_ID, 
        TRAINING_CAT, 
        DETAIL, 
        TRAINING_LANGUAGE, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP 
    FROM 
    	TRAINING_CAT
</cfquery>
<cfquery name="get_training_sec" datasource="#dsn#">
	SELECT 
		TRAINING_CAT_ID, 
        TRAINING_SEC_ID, 
        SECTION_NAME, 
        SECTION_DETAIL, 
        RECORD_EMP, 
        RECORD_PAR, 
        RECORD_DATE, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_PAR, 
        UPDATE_EMP, 
        UPDATE_IP
    FROM 
    	TRAINING_SEC
</cfquery>
<!--- **** --->
<cfif isdefined("attributes.is_submit")>
	<cfinclude template="../query/get_trainings.cfm">
<cfelse>
	<cfset get_trainings.recordcount = 0>   
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_trainings.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_training_subjects">
<input type="hidden" name="is_submit" id="is_submit" value="1">
<cf_big_list_search title="#getLang('training',172)#"> <!---20131104--->
	<cf_big_list_search_area>
	 <!-- sil -->
		<table>
			<tr>
				<cfinput type="hidden" name="is_form_submitted" value="1">
				<td><cf_get_lang_main no='48.Filtre'></td>
				<td><cfinput type="text" maxlength="50" name="keyword" value="#attributes.keyword#"></td>
				<td>
				<select name="training_cat_id" id="training_cat_id" style="width:135px">
					<option value="0"><cf_get_lang_main no='74.Kategori'></option>
					<cfoutput query="get_training_cat">
						<option value="#training_cat_id#" <cfif isdefined("attributes.training_cat_id") and (attributes.training_cat_id eq training_cat_id)>selected</cfif>>#training_cat#</option>
					</cfoutput>
				</select>
				<select name="training_sec_id" id="training_sec_id" style="width:135px">
					<option value="0"><cf_get_lang_main no ='583.Bölüm'></option>
					<cfoutput query="get_training_sec">
						<option value="#training_sec_id#" <cfif isdefined("attributes.training_sec_id") and (attributes.training_sec_id eq training_sec_id)>selected</cfif>>#section_name#</option>
					</cfoutput>
				</select>
				</td>
				<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" onKeyUp="isNumber (this)" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;"></td>
				<td><cf_wrk_search_button></td>
			</tr>
		</table>
		<!-- sil -->
	</cf_big_list_search_area>
</cf_big_list_search> 
</cfform>
<cf_big_list>
	<thead>
		<tr>
			<th width="35"><cf_get_lang_main no='1168. Sira'></th>
			<th><cf_get_lang_main no='68.Konu'></th>
			<th><cf_get_lang no='7.Amaç'></th>
			<th><cf_get_lang_main no='1978.Hazırlayan'></th>
			<th width="85"><cf_get_lang_main no='215.Kayıt Tarihi'></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_trainings.recordcount and form_varmi eq 1>
			<cfoutput query="get_trainings" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">


				<tr>
					<td width="35">#currentrow#</td>
					<td><a href="#request.self#?fuseaction=training.training_subject&train_id=#train_id#" class="tableyazi">#train_head#</a></td>
					<td>#train_objective#</td>
					<td>
						<cfif len(record_emp)>
							#get_emp_info(record_emp,0,1)#
						<cfelseif len(record_par)>
						<cfset attributes.partner_id = record_par>
						<cfinclude template="../query/get_partner.cfm">
						<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#get_partner.partner_id#','medium');" class="tableyazi">#get_partner.company_partner_name# #get_partner.company_partner_surname#</a>
						</cfif>
					</td>
					<td>#dateformat(record_date,dateformat_style)#</td>
				</tr>

				
			</cfoutput>
		<cfelse>
			<tr>
				<td colspan="6"><cfif form_varmi eq 0><cf_get_lang_main no='289. Filtre Ediniz'>!<cfelse><cf_get_lang_main no='72.Kayit Bulunamadi'></cfif></td>
			</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfif get_trainings.recordcount>
<cfif attributes.totalrecords gt attributes.maxrows>
<cfset url_str = "">
<cfif len(attributes.keyword)>
<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.training_sec_id")>
<cfset url_str = "#url_str#&training_sec_id=#training_sec_id#">
<cfelse>
<cfset attributes.training_sec_id = 0>
</cfif>
<cfif isdefined("attributes.training_cat_id")>
<cfset url_str = "#url_str#&training_cat_id=#training_cat_id#">
<cfelse>
<cfset attributes.training_sec_id = 0>
</cfif>
<cfif isdefined("attributes.attenders")>
<cfset url_str = "#url_str#&attenders=#attenders#">
<cfelse>
<cfset attributes.attenders = 0>
</cfif>
<cfif isdefined("attributes.is_submit")>
<cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
<cfset url_str = "#url_str#&is_form_submitted=1">
	</cfif>
		<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td height="35"><cf_pages page="#attributes.page#" maxrows="#attributes.maxrows#" totalrecords="#attributes.totalrecords#" startrow="#attributes.startrow#" adres="#listgetat(attributes.fuseaction,1,'.')#.list_training_subjects#url_str#"> </td>
				<!-- sil -->
				<td style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td> 
				<!-- sil -->
			</tr>
		</table>
	</cfif>
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>

