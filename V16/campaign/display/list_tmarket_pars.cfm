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
	windowopen('index.cfm?fuseaction=sales.popup_form_add_opportunity&cpid='+cid+'&member_id='+pid+'&&member_type='+mtype+'&membername='+mname+'&partnername='+name+'','list');
}

function view_message_sent_details_pars(userid,name,surname,email,faxcode,fax,mobilcode,mobil,companystr,comp_id)
{
	openBoxDraggable('index.cfm?fuseaction=objects.popup_view_message_sent_details&company_name='+companystr+'&type=PAR&consumer_name='+name+'&consumer_surname='+surname+'&sms_code='+mobilcode+'&sms_tel='+mobil+'&faxcode='+faxcode+'&faxno='+fax+'&consumer_email='+email+'&camp_id='+#attributes.camp_id#+'&user_id='+userid+'&comp_id='+comp_id+'&member_type=partner');
}
function add_etkilesimm(pid,type,email)
{
	window.open('<cfoutput>#request.self#</cfoutput>?fuseaction=call.helpdesk&event=add&window=popup&partner_id='+pid+'&member_type='+type+'&applicant_mail='+email+'',"<cf_get_lang dictionary_id='58729.Etkileşimler'>")
}
function type_(company_id,partner_id,type)
{	
	window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.my_company_details&cpid=' + company_id + '&member_type=' + type;
}
function Add_Event(var1,var2,var3,var4,var5,var6,var7,var8,var9,var10){
	windowopen('index.cfm?fuseaction=objects.popup_form_add_event&action_id=17&action_section=OPPORTUNITY_ID','page');
	event_name = var1;
	event_emp_id = var2;
	event_pos_id = var3;
	event_pos_code = var4;
	event_cons_ids = var5;
	event_comp_ids = var6;
	event_par_ids = var7;
	event_grp_ids = var8;
	event_wgrp_ids = var9;
	event_add_type = var10;
}
</script>
<!-- sil -->
</cfoutput>
<cfif get_pars.recordcount AND attributes.startrow2 GT 0 AND attributes.maxrows2 GT 0>
  <cfset pars_index = 0>
  <cfoutput query="get_pars" startrow="#attributes.startrow2#" maxrows="#attributes.maxrows2#">
    <cfset pars_index = pars_index+1>
    <tr>
        <td>#partner_id#</td>
        <td><cfif TYPE eq 1 >B<cfelse>K</cfif></td>
        <td>#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME# - #FULLNAME#</td>
        <td>#title#</td>
        <td>#company_partner_email#</td>
        <cf_santral tel="#company_partner_TELCODE##company_partner_TEL#" mobile="#get_pars.MOBIL_CODE##mobiltel#" table="1"></cf_santral>
        <!--- <td>(#company_partner_TELCODE#) #company_partner_TEL#</td>
        <td>(#get_pars.MOBIL_CODE#) #mobiltel#</td> --->      
        <td>#RECORD_EMP_NAME#</td>
        <!-- sil -->
        <td><cfif (WANT_EMAIL)><a href="javascript://"><i class="icon-check"></i></a><cfelse><a href="javascript://"><i class="icon-times"></i></a></cfif></td>
        <td><a href="javascript://" onClick="add_etkilesimm(#partner_id#,'partner','#COMPANY_PARTNER_EMAIL#')"><i class="fa fa-plug" title="<cf_get_lang dictionary_id='49354.Etkileşim'>" alt="<cf_get_lang dictionary_id='49354.Etkileşim'>"></i></a></td>
        <td><a href="javascript://" onClick="view_message_sent_details_pars(#partner_id#,'#COMPANY_PARTNER_NAME#','#COMPANY_PARTNER_SURNAME#','#COMPANY_PARTNER_EMAIL#','#COMPANY_PARTNER_TEL_EXT#','#COMPANY_PARTNER_FAX#','#MOBIL_CODE#','#MOBILTEL#','<cfif len(company_id)>#FULLNAME#</cfif>','<cfif len(company_id)>#company_id#</cfif>')"><i class="fa fa-share-alt" alt="<cf_get_lang dictionary_id='49543.Gönderi Detaylarını'>" title="<cf_get_lang dictionary_id='49543.Gönderi Detaylarını'>"></i></a></td>
        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57533.Silmek Istediginizden Emin Misiniz'></cfsavecontent>
        <td><a href="javascript://" onClick="javascript:if (confirm('#message#')) windowopen('#request.self#?fuseaction=campaign.emptypopup_del_camp_tmarket_pars&camp_id=#camp_id#&par_id=#partner_id#','small'); else return false;"><i class="fa fa-minus" alt="<cf_get_lang dictionary_id='57463.Sil'>" title="<cf_get_lang dictionary_id='57463.Sil'>"></i></a></td>
        <td class="text-center"><input type="checkbox" name="pars_list_#currentrow#" id="pars_list_#currentrow#" value="#partner_id#"></td>
        <!-- sil -->
    </tr>
  </cfoutput>
</cfif>
