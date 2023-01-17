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
	openBoxDraggable('index.cfm?fuseaction=objects.popup_view_message_sent_details&company_name='+encodeURIComponent(companystr)+'&type=con&consumer_name='+encodeURIComponent(name)+'&consumer_surname='+encodeURIComponent(surname)+'&sms_code='+mobilcode+'&sms_tel='+mobil+'&faxcode='+faxcode+'&faxno='+fax+'&consumer_email='+email+'&camp_id=#attributes.camp_id#&camp_head=#campaign.camp_head#&user_id='+userid+'&member_type=consumer');
}
function add_etkilesim(pid,type,consumer_email)
{
	windowopen('index.cfm?fuseaction=call.helpdesk&event=add&window=popup&cid='+pid+'&member_type='+type+'&applicant_mail='+consumer_email+'','list')
}
function type__(consumer_id,type)
{
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_consumer_details&cid=' + consumer_id + '&member_type=' + type;
}
</script>
<!-- sil -->
</cfoutput>
<cfif get_cons.recordcount AND attributes.startrow1 GT 0 AND attributes.maxrows1 GT 0>
  <cfset cons_index = 0>
  <cfoutput query="get_cons" startrow="#attributes.startrow1#" maxrows="#attributes.maxrows1#">
    <cfset cons_index = cons_index+1>
    <tr>
        <td>&nbsp;#consumer_id#</td>
        <td><cfif TYPE eq 1 >B<cfelse>K</cfif></td>
        <td><a href="##" onClick="type__('#consumer_id#','consumer');"><cfif len(consumer_id)>#get_cons_info(consumer_id,0,0)# </cfif><cfif len(trim(company))> - #company#</cfif></a></td>
        <td>#title#</td>
        <td>#consumer_email#</td>
        <cf_santral tel="#CONSUMER_WORKTELCODE##CONSUMER_WORKTEL#" mobile="#get_cons.MOBIL_CODE##mobiltel#" table="1"></cf_santral>
        <td>#record_emp_name#</td>
        <!-- sil -->
        <td><cfif (WANT_EMAIL)><a href="javascript://"><i class="icon-check"></i></a><cfelse><a href="javascript://"><i class="icon-times"></i></a></cfif></td>
        <td><a href="javascript://" onClick="add_etkilesim(#consumer_id#,'consumer','#consumer_email#')"><i class="fa fa-plug" title="<cf_get_lang dictionary_id='49354.Etkileşim Ekle'>" alt="<cf_get_lang dictionary_id='49354.Etkileşim Ekle'>"></i></a></td>
        <td><a href="javascript://" onClick="view_message_sent_details_cons(#consumer_id#,'#CONSUMER_NAME#','#CONSUMER_SURNAME#','#CONSUMER_EMAIL#','#CONSUMER_FAXCODE#','#CONSUMER_FAX#','#MOBIL_CODE#','#MOBILTEL#','<cfif len(trim(company))>#company#</cfif>')"><i class="fa fa-share-alt" alt="<cf_get_lang dictionary_id='49543.Gönderi Detaylarını Görüntülemek İçin Tıklayınız'>" title="<cf_get_lang dictionary_id='49543.Gönderi Detaylarını Görüntülemek İçin Tıklayınız'>"></i></a></td>
         <cfsavecontent variable="message"><cf_get_lang dictionary_id='57533.Silmek Istediginizden Emin Misiniz'></cfsavecontent> 
        <td><a href="javascript://" onClick="javascript:if (confirm('#message#')) windowopen('#request.self#?fuseaction=campaign.emptypopup_del_camp_tmarket_cons&camp_id=#camp_id#&con_id=#consumer_id#','small'); else return false;"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
        <td class="text-center"><input type="checkbox" name="cons_list_#currentrow#" id="cons_list_#currentrow#" value="#consumer_id#"></td>
        <!-- sil -->
    </tr>
  </cfoutput>
</cfif>
