<cfoutput>
<!-- sil -->
<script language="JavaScript" type="text/javascript">
var message_type_old = '';
var event_name = '';
var event_emp_id = '';
var event_pos_id = '';
var event_pos_code = '';
var event_cons_ids = '';
var event_comp_ids = '';
var event_par_ids = '';
var event_grp_ids = '';
var event_wgrp_ids = '';
var event_add_type = '';

function add_opportunity(cid,pid,name,mname,mtype)
{
	windowopen('index.cfm?fuseaction=sales.popup_form_add_opportunity&cpid='+cid+'&member_id='+pid+'&&member_type='+mtype+'&membername='+mname+'&partnername='+name+'','page');
}

function view_message_sent_details_cons(userid,name,surname,email,faxcode,fax,mobilcode,mobil,companystr)
{
	windowopen('index.cfm?fuseaction=objects.popup_view_message_sent_details&company_name='+companystr+'&type=cons&consumer_name='+name+'&consumer_surname='+surname+'&sms_code='+mobilcode+'&sms_tel='+mobil+'&faxcode='+faxcode+'&faxno='+fax+'&consumer_email='+email+'&camp_id='+#attributes.camp_id#+'&user_id='+userid+'','list');
}
function add_etkilesim(pid,type,consumer_email)
{
	windowopen('index.cfm?fuseaction=call.popup_add_helpdesk&cid='+pid+'&member_type='+type+'&applicant_mail='+consumer_email+'','medium')
}
function type__(consumer_id,type)
{
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_consumer_details&cid=' + consumer_id + '&member_type=' + type;
	<!--- windowopen(<cfoutput>'#request.self#?fuseaction=call.popup_add_helpdesk&member_type=' + type + '&cid=' + consumer_id,'medium'</cfoutput>); --->
}
</script>
<!-- sil -->
</cfoutput>
<cfif get_cons.recordcount>
	<cfset employee_list = ''>
	<cfoutput query="get_cons" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfif len(record_emp) and not listfind(employee_list,record_emp)>
			<cfset employee_list=listappend(employee_list,record_emp)>
		</cfif>
	</cfoutput>
	<cfif len(employee_list)>
		<cfset employee_list = listsort(employee_list,"numeric","ASC",",")>
		<cfquery name="get_emp" datasource="#dsn#">
			SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#employee_list#)
		</cfquery>
	</cfif>
</cfif>

<cfif get_cons.recordcount AND attributes.startrow1 GT 0 AND attributes.maxrows1 GT 0>
  <cfset cons_index = 0>
  <cfoutput query="get_cons" startrow="#attributes.startrow1#" maxrows="#attributes.maxrows1#">
    <cfset cons_index = cons_index+1>
    <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
       <td height="20">&nbsp;#consumer_id#</td>
	  <td width="1%" align="center"><cfif TYPE eq 1 >B<cfelse>K</cfif></td>
	  <td height="20"><a href="##" onClick="type__('#consumer_id#','consumer');" class="tableyazi"><cfif len(consumer_id)>#get_cons_info(consumer_id,0,0)# </cfif><cfif len(trim(company))> - #company#</cfif></a></td>
      <td>#title#</td>
	  <td>#consumer_email#</td>
	  <td><cfif len(trim(consumer_fax)) GT 5>(#CONSUMER_WORKTELCODE#) #CONSUMER_WORKTEL#</cfif></td>
	  <td><cfif len(trim(mobiltel)) GT 5>(#get_cons.MOBIL_CODE#) #mobiltel#</cfif></td>
      <td><cfif len(employee_list)>
	  		#get_emp.employee_name[listfind(employee_list,record_emp,',')]# #get_emp.employee_surname[listfind(employee_list,record_emp,',')]#
	  	  </cfif>
	  </td>
	<!-- sil -->
		<td><a href="javascript://" onClick="add_etkilesim(#consumer_id#,'consumer','#consumer_email#')"><img src="../../images/instmes.gif" alt="" border="0" /></a></td>
		<td><a href="javascript://" onClick="view_message_sent_details_cons(#consumer_id#,'#CONSUMER_NAME#','#CONSUMER_SURNAME#','#CONSUMER_EMAIL#','#CONSUMER_FAXCODE#','#CONSUMER_FAX#','#MOBIL_CODE#','#MOBILTEL#','<cfif len(trim(company))>#company#</cfif>')"><img src="/images/devfolder.gif" alt="<cf_get_lang no='223.Gönderi Detaylarını Görüntülemek İçin Tıklayınız'>" border="0" title="<cf_get_lang no='223.Gönderi Detaylarını Görüntülemek İçin Tıklayınız'>"></a></td>
  		<cfsavecontent variable="del_message"><cf_get_lang_main no='121.Silmek Istediginizden Emin Misiniz'></cfsavecontent>
		<td width="10"><a href="javascript://" onClick="javascript:if (confirm('#del_message#')) windowopen('#request.self#?fuseaction=campaign.emptypopup_del_camp_tmarket_cons&camp_id=#camp_id#&con_id=#consumer_id#','small'); else return false;"><img src="/images/delete_list.gif" alt="<cf_get_lang_main no='51.Sil'>" title="<cf_get_lang_main no='51.Sil'>" border="0" align="middle"></a></td>
  		<td width="10"><input type="checkbox" name="cons_list_#currentrow#" id="cons_list_#currentrow#" value="#consumer_id#"></td>
 	<!-- sil -->
    </tr>
  </cfoutput>
</cfif>
