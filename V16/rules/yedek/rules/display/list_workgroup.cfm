<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.department_id" default="">
<cfif isdefined("form_submitted")>
    <cfquery name="GET_WORKGROUPS" datasource="#DSN#">
     SELECT 
       GOAL,
       WORKGROUP_ID,
       WORKGROUP_NAME 
     FROM 
       WORK_GROUP 
     WHERE 
        STATUS = 1
      <cfif len(attributes.keyword)>
          AND
        WORKGROUP_NAME LIKE <cfqueryparam cfsqltype="cf_sql_longvarchar" value="%#attributes.keyword#%">
      </cfif>
    </cfquery>
<cfelse>
	<cfset get_workgroups.recordcount = 0>    
</cfif>

<cfif fuseaction contains "popup">
	<cfset is_popup=1>
<cfelse>
	<cfset is_popup=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_workgroups.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="form1" method="post" action="#request.self#?fuseaction=rule.workgroup">
<input type="hidden" name="form_submitted" id="form_submitted" value="1">
	<cf_big_list_search title="#getLang('main',2021,'İş Grubu')#">
		<cf_big_list_search_area>
			<table>
				<tr> 
					<td><cf_get_lang_main no='48.Filtre'></td>
					<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
					<td>
					<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td><cf_wrk_search_button></td>
				</tr>
			</table>
		</cf_big_list_search_area>
	</cf_big_list_search>
</cfform>	  
	<cf_big_list>
		<thead>
			<tr>  
				<th width="35"><cf_get_lang_main no='1165.Sıra'></th>
				<th><cf_get_lang_main no='728.İş Grubu'></th>
				<th width="50"><cf_get_lang no='13.Amaç'></th> 				   
			</tr>
		</thead>
		<tbody>
			<cfparam name="attributes.page" default=1>
			<cfparam name="attributes.totalrecords" default=#get_workgroups.recordcount#>
			<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
			<cfif get_workgroups.recordcount>
				<cfoutput query="get_workgroups" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 			 
					<tr>
						<td>#workgroup_id#</td>
						<td>
							<!---<a href="#request.self#?fuseaction=rule.popup_form_dsp_workgroup&workgroup_id=#workgroup_id#" class="tableyazi">#workgroup_name#</a>--->
							<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=rule.popup_form_dsp_workgroup&workgroup_id=#workgroup_id#','medium');" class="tableyazi">#workgroup_name#</a>
						</td>
						<cfif LEN(goal)>
							<td>#goal#</td>
						<cfelse>
							<td><cf_get_lang_main no='4.Proje'></td>
						</cfif>
					</tr>
				</cfoutput> 
			<cfelse>
				<tr>
					<td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
				</tr>
			</cfif>
		</tbody>
	</cf_big_list>
<cfset url_str = "">
<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>
<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
	<cfset url_str = "#url_str#&department_id=#attributes.department_id#">
</cfif>
<cf_paging page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="rule.workgroup#url_str#">
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
