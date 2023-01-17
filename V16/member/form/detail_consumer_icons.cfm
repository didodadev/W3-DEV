<cfoutput>
	<cfif xml_secret_question eq 1 and not listfindnocase(denied_pages,'member.popup_member_secret_answer')>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_member_secret_answer&consumer_id=#url.cid#','small','popup_member_secret_answer');"><img src="/images/icon_faq.gif" title="<cf_get_lang dictionary_id='30275.Gizli Soru'>" height="19" width="19" border="0" ></a>
	</cfif>
	<cfif get_module_user(3) and not listfindnocase(denied_pages,'report.bsc_company') and fusebox.use_period>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=report.popup_bsc_company&member_type=consumer&consumer_id=#url.cid#&member_name=#consumer#','page_horizantal','popup_bsc_company');"><img src="/images/dashboard.gif" title="<cf_get_lang dictionary_id ='30627.BSC Raporu'>" border="0" ></a>
	</cfif>
		<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=member.popup_member_history&member_type=consumer&member_id=#attributes.cid#','medium','popup_member_history');"><img src="/images/history.gif" title="<cf_get_lang dictionary_id='57473.Tarihçe'>" border="0"></a>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_page_warnings&action=member.consumer_list&event=det&action_name=cid&action_id=#attributes.cid#','list','popup_page_warnings');"><img src="/images/uyar.gif" title="<cf_get_lang dictionary_id='57757.Uyarılar'>" border="0"></a>
	<cfif not listfindnocase(denied_pages,'objects.popup_list_mail_relation')><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_mail_relation&relation_type=CONSUMER_ID&relation_type_id=#attributes.cid#</cfoutput>','wide');" ><img src="/images/mail.gif"  title="<cf_get_lang dictionary_id ='38321.Proje Mailleri'>" border="0"></a></cfif>
	<cfif not listfindnocase(denied_pages,'member.popup_education_info')><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_education_info&consumer_id=#attributes.cid#','small','popup_education_info');"><img src="/images/examination.gif" title="<cf_get_lang dictionary_id ='57419.Eğitim'>" border="0"></a></cfif>
	<cfif not listfindnocase(denied_pages,'member.popup_upd_consumer_hobbies')><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_upd_consumer_hobbies&consumer_id=#attributes.cid#','small','popup_upd_consumer_hobbies');"><img src="/images/speak.gif" title="<cf_get_lang dictionary_id='30509.Hobi'>" border="0"></a></cfif>
	<cfif not listfindnocase(denied_pages,'member.popup_upd_consumer_req_type')><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_upd_consumer_req_type&consumer_id=#attributes.cid#','small','popup_upd_consumer_req_type');"><img src="../../images/magic.gif" title="<cf_get_lang dictionary_id ='57907.Yetkinlik'>" border="0"></a></cfif>		
	<cfif not listfindnocase(denied_pages,'member.popup_list_con_agenda')><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_list_con_agenda&consumer_id=#attributes.cid#','list','popup_list_con_agenda');"><img src="/images/time.gif" title="<cf_get_lang dictionary_id='30466.Toplantılar'>" border="0"></a></cfif>
	<cfif not listfindnocase(denied_pages,'member.popup_list_consumer_surveys')><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_list_consumer_surveys&consumer_id=#url.cid#&consumer_cat_id=#get_consumer.consumer_cat_id#','list','popup_list_consumer_surveys');"><img src="/images/question.gif" border="0" title="<cf_get_lang dictionary_id='57947.Anketler'>"></a></cfif>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#url.cid#&type_id=-2','list','popup_list_comp_add_info')"> <img src="/images/info_plus.gif" title="<cf_get_lang dictionary_id='30219.Ek Bilgiler'>" border="0"></a>
	<cfif get_module_user(22)><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_consumer_periods&cpid=#url.cid#','list','popup_list_consumer_periods')"> <img src="/images/hand.gif" title="<cf_get_lang dictionary_id='30220.Muhasebe-Çalışma Dönemleri'>" border="0"></a></cfif>
	<cfif not listfindnocase(denied_pages,'member.popup_list_securefund')><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_list_securefund&consumer_id=#url.cid#','list','popup_list_securefund');"><img src="/images/kasa.gif" title="<cf_get_lang dictionary_id='57676.Teminatlar'>" border="0" align="absbottom"></a></cfif>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_list_comp_extre&member_type=consumer&member_id=#url.cid#','page','popup_list_comp_extre');"><img src="/images/extre_cari.gif" title="<cf_get_lang dictionary_id='57809.Hesap Ektresi'>" border="0"></a>
	<cfif not listfindnocase(denied_pages,'contract.detail_contract_company')>
		<a href="#request.self#?fuseaction=contract.detail_contract_company&consumer_id=#url.cid#"><img src="/images/credit.gif" border="0" title="<cf_get_lang dictionary_id='59895.Kredi Durumu'>"></a>
	</cfif>
	<cfif not listfindnocase(denied_pages,'member.add_consumer_contact')><a href="#request.self#?fuseaction=#fusebox.circuit#.add_consumer_contact&cid=#url.cid#"><img src="/images/homepage.gif" title="<cf_get_lang dictionary_id='30510.Diger Adres Ekle'>" border="0"></a></cfif>
	<cfif get_module_user(11) and session.ep.our_company_info.subscription_contract eq 1>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=member.popup_list_subscription_contract&cid=#url.cid#&member_name=#get_consumer.consumer_name#&nbsp;#get_consumer.consumer_surname#','list','popup_list_subscription_contract')"><img src="/images/contract.gif" title="<cf_get_lang dictionary_id='30520.Sistemler'>" border="0"></a>
	</cfif>
	<cfif not listfindnocase(denied_pages,'myhome.my_consumer_details')>
		<a href="#request.self#?fuseaction=myhome.my_consumer_details&cid=#attributes.cid#"><img src="/images/cubexport.gif" title="<cf_get_lang dictionary_id='57575.Üye Bilgileri'>" border="0"></a>
	</cfif>
		<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_training_trainer&consumer_id=#url.cid#','page','popup_training_trainer')"><img src="/images/apple.gif" title="<cf_get_lang dictionary_id ='46389.Verdiği Eğitimler'>" border="0"></a>
		<a href="#request.self#?fuseaction=#fusebox.circuit#.form_add_consumer"><img src="/images/plus1.gif" border="0" title="<cf_get_lang dictionary_id='57582.Ekle'>"></a>
</cfoutput> 
<cf_np tablename="consumer" primary_key = "consumer_id"	where = "consumer_status=1"	pointer = "cid=#url.cid#">

