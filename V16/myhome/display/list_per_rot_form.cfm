<!--- bu sayfanın benzere hr de var yapılan değişiklikler ordada yapılsın--->
<cfif isdefined("attributes.is_form_submitted")>
	<cfset form_varmi = 1>
<cfelse>
	<cfset form_varmi = 0>
</cfif>
<cfquery name="get_form" datasource="#dsn#">
	SELECT
		PRF.*
	FROM
		PERSONEL_ROTATION_FORM PRF,
		EMPLOYEES_APP_AUTHORITY EA
	WHERE
		EA.POS_CODE=#session.ep.position_code# AND	
		EA.ROTATION_FORM_ID IS NOT NULL AND
		PRF.ROTATION_FORM_ID=EA.ROTATION_FORM_ID AND
		EA.AUTHORITY_STATUS = 1
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND PRF.ROTATION_FORM_HEAD LIKE '#attributes.keyword#%'
		</cfif>
UNION
	SELECT
		PRF.*
	FROM
		PERSONEL_ROTATION_FORM PRF
	WHERE
		PRF.RECORD_EMP = #session.ep.userid#
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND PRF.ROTATION_FORM_HEAD LIKE '#attributes.keyword#%'
		</cfif>
</cfquery>
<cfif get_form.recordcount>
	<cfset pos_code_list=listdeleteduplicates(valuelist(get_form.pos_code_exist,','))>
	<cfset pos_code_list2=listdeleteduplicates(valuelist(get_form.pos_code_request,','))>
	<cfset pos_code_list=ListAppend(pos_code_list,pos_code_list2,',')>
	<cfset pos_code_list=listsort(listdeleteduplicates(pos_code_list),"numeric","ASC",",")>	
	
	<cfquery name="get_position" datasource="#dsn#">
	SELECT
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME,
		POSITION_NAME
	FROM
		EMPLOYEE_POSITIONS
	WHERE
		POSITION_CODE IN (#pos_code_list#)
	ORDER BY POSITION_CODE
	</cfquery>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_form.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="search_form" action="#request.self#?fuseaction=myhome.list_personel_rotation_form" method="post">
	<cfsavecontent variable="message"><cf_get_lang dictionary_id='31344.Terfi-Transfer-Rotasyon Talep Formu'></cfsavecontent
	<cf_big_list_search title="#message#">
		<cf_big_list_search_area>
			<table>
				<tr>
                	<cfinput type="hidden" name="is_form_submitted" value="1">
					<td><cf_get_lang dictionary_id='57460.Filtre'></td>
					<td>
						<input type="text" maxlength="50" id="keyword" name="keyword" value="<cfif isdefined("attributes.keyword")><cfoutput>#attributes.keyword#</cfoutput></cfif>">
					</td>				
					<td>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
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
        	<th width="15"><cf_get_lang dictionary_id='58577.Sıra'></th>
			<th><cf_get_lang dictionary_id='57480.Konu'></th>
			<th><cf_get_lang dictionary_id='31345.Mevcut Kadro'></th>
			<th><cf_get_lang dictionary_id='31181.Talep Edilen'></th>
			<th><cf_get_lang dictionary_id='57482.Aşama'></th>
			<th class="header_icn_none"></th>
		</tr>
	</thead>
	<tbody>
		<cfif get_form.recordcount and form_varmi eq 1>
			<cfset process_list = ''>
			<cfoutput query="get_form" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<cfif not listfind(process_list,get_form.form_stage)>
					<cfset process_list=listappend(process_list,get_form.form_stage)>
				</cfif>
			</cfoutput>
			<cfset process_list=listsort(process_list,"numeric")>
			<cfif len(process_list)>
				<cfquery name="get_process" datasource="#dsn#">
					SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#process_list#) 
				</cfquery>
			</cfif>				
			<cfoutput query="get_form" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
                	<td>#currentrow#</td>
					<td>#get_form.rotation_form_head#</td>
					<td>#get_position.employee_name[listfind(pos_code_list,get_form.pos_code_exist,',')]# #get_position.employee_surname[listfind(pos_code_list,get_form.pos_code_exist,',')]# - #get_position.position_name[listfind(pos_code_list,get_form.pos_code_exist,',')]#</td>
					<td>#get_position.employee_name[listfind(pos_code_list,get_form.pos_code_request,',')]# #get_position.employee_surname[listfind(pos_code_list,get_form.pos_code_request,',')]# - #get_position.position_name[listfind(pos_code_list,get_form.pos_code_request,',')]#</td>
					<td>#get_process.stage [listfind(process_list,get_form.form_stage,',')]#</td>
					<td width="15"><a href="#request.self#?fuseaction=myhome.upd_personel_rotation_form&per_rot_id=#get_form.rotation_form_id#"><img src="images/update_list.gif" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></a></td><!-- sil -->
				</tr>
			</cfoutput>
			<cfelse>
				<tr>
					<td colspan="10"><cfif form_varmi eq 0><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!<cfelse><cf_get_lang dictionary_id='57484.Kayit Bulunamadi'></cfif></td>
				</tr>
		</cfif>
	</tbody>
</cf_big_list>
<cfset url_str = "">
<cfif isdefined('attributes.keyword') and len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cf_paging
    page="#attributes.page#" 
    maxrows="#attributes.maxrows#" 
    totalrecords="#attributes.totalrecords#" 
    startrow="#attributes.startrow#" 
    adres="myhome.list_personel_rotation_form#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
