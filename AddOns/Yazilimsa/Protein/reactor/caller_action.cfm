<cfset dsn = application.systemParam.systemParam().dsn>
<cfset dsn1_alias = "#dsn#_product">
<cfset dsn1 = "#dsn#_product">
<cfset dsn_alias = '#dsn#'>
<cfset dsn2 = dsn2_alias = '#dsn#_#session_base.period_year#_#session_base.OUR_COMPANY_ID#' />
<cfset dsn3 = dsn3_alias = '#dsn#_#session_base.OUR_COMPANY_ID#' />
<cfset session_base = session_base>
<cfset IS_ONLY_SHOW_PAGE = 0>
<cfset WORKCUBE_MODE  = 0>
<cfset use_https  = 0>
<cfif not structKeyExists(url,'ajax') >
	<script  type="text/javascript" src="/src/assets/js/js_functions.js"></script>
	<script  type="text/javascript" src="/src/assets/js/js_functions_money_tr.js"></script>
	<div id="working_div_main"></div>
</cfif>
<cfset attributes = StructNew()>
<cfscript>
    StructAppend(attributes,url,true);
    StructAppend(attributes,form,true);
</cfscript>
<cfif structKeyExists(url,'fuseaction')>
	<cfset fuseact_control = replace(attributes.fuseaction,'objects2.','','all')>	
	<cfswitch expression="#fuseact_control#"> 
		<!--- sanal pos ve kredi karti tahsilati --->
		<cfcase value="popup_add_online_pos_kontrol"><!--- sipariş sonlandır ve tek ödeme kontrol ekranı --->
			<cfinclude template="/V16/objects2/form/add_online_pos_kontrol.cfm">
		</cfcase>
		<cfcase value="emptypopup_add_partner">
			<cfinclude template="/V16/objects2/query/add_partner.cfm">
		</cfcase>
		<cfcase value="emptypopup_add_online_pos_from_order"><!--- sipariş sonlandır tahsilat --->
			<cfinclude template="/V16/objects2/query/add_online_pos_from_order.cfm">
		</cfcase>
		<cfcase value="add_online_pos_from_order"><!--- sipariş sonlandır tahsilat --->
			<cfinclude template="/V16/objects2/display/dynamic_page.cfm">
		</cfcase>
		<cfcase value="popup_add_online_pos"><!--- ch tan tek ödeme sayfası--->
			*****
		</cfcase>
		<cfcase value="popup_add_online_pos_vft"><!--- ch tan tek ödeme sayfası--->
			<cfinclude template="/V16/objects2/display/dynamic_page.cfm">
		</cfcase>
		<cfcase value="popup_add_online_pos_action"><!--- ch tan tek ödeme action--->
			<cfinclude template="/V16/objects2/finance/query/add_online_pos.cfm">
		</cfcase>
		<cfcase value="emptypopup_add_credit_card_revenue"><!--- tahsilat--->
			<cfinclude template="/V16/objects2/finance/query/add_credit_card_revenue.cfm">
		</cfcase>
		<cfcase value="popup_add_online_pos_print">
			<cfinclude template="/V16/objects2/finance/display/add_online_pos_print.cfm">
		</cfcase>
		<cfcase value="popup_dsp_response_code"><!--- olumsuz dönüş kodlarını gösteren sayfa --->
			<cfinclude template="/V16/objects2/finance/display/dsp_response_code.cfm">
		</cfcase>
		<cfcase value="emptypopup_get_accounts_list_ajax">
			<cfinclude  template="/V16/objects2/finance/query/get_accounts_list_ajax.cfm">            
		</cfcase>
		<cfcase value="popup_3d_control">
			<cfinclude  template="/V16/objects2/finance/display/display_3d_control.cfm"> 
		</cfcase>
		<cfcase value="list_payments">
			<cfinclude template="/V16/objects2/finance/display/list_payments.cfm">
		</cfcase>
		<cfcase value="emptypopup_payment_cancellation">
			<cfinclude template="/V16/objects2/finance/query/payment_cancellation.cfm">
		</cfcase>
		<cfcase value="popup_dsp_credit_card_payment_type">
			<cfinclude template="/V16/objects2/finance/display/dsp_credit_card_payment_type.cfm"><!--- Kredi karti tahsilat --->
		</cfcase>
		<cfcase value="emptypopup_get_workdata">
			<cfinclude template="/V16/objects/query/get_workdata.cfm">
		</cfcase>
		<cfcase value="emptypopup_get_js_query">
			<cfinclude template="/V16/objects/query/get_js_query.cfm">
		</cfcase>
		<cfcase value="emptypopup_get_js_query2">
			<cfinclude template="/V16/objects/query/get_js_query2.cfm">
		</cfcase>
		<cfcase value="emptypopup_add_change_pass">
			<cfinclude template="/V16/objects2/career/query/add_change_pass.cfm">
		</cfcase>		
		<cfcase value="emptypopup_add_comp_member">
			<cfinclude template="/V16/objects2/query/add_member_company.cfm">
		</cfcase>
		<cfcase value="security_capcha_page">
			<cfinclude template="/V16/objects2/display/security_capcha_page.cfm">
		</cfcase>
		<cfcase value="emptypopup_add_cons_member">
			<cfinclude template="/V16/objects2/query/add_cons_member.cfm">
		</cfcase>
		<cfcase value="emptypopup_add_my_consumer">
			<cfinclude template="/V16/objects2/query/add_my_consumer.cfm">
		</cfcase>
		<cfcase value="upd_my_consumer">
			<cfinclude template="/V16/objects2/display/dynamic_page.cfm">
		</cfcase>
		<cfcase value="popup_detail_content,detail_content">
			<cfinclude template="/V16/objects2/display/dynamic_page.cfm">
		</cfcase>
		<cfcase value="emptypopup_add_member_site_relation">
			<cfinclude template="/V16/objects2/query/add_member_site_relation.cfm">
		</cfcase>
		<cfcase value="list_partner">
			<cfinclude template="/V16/objects2/display/dynamic_page.cfm">
		</cfcase>
		<cfcase value="popupajax_my_company_helps">
			<cfinclude template="/V16/objects2/member/my_company_helps.cfm">
		</cfcase>
		<cfcase value="popupajax_my_company_events">
			<cfinclude template="/V16/objects2/member/my_company_events.cfm">
		</cfcase>
		<cfcase value="popupajax_my_company_opportunities">
			<cfinclude template="/V16/objects2/member/my_company_opportunities.cfm">
		</cfcase>
		<cfcase value="popupajax_my_company_analyse">
			<cfinclude template="/V16/objects2/member/my_company_analyse.cfm">
		</cfcase>
		<cfcase value="emptypopup_upd_my_company">
			<cfinclude template="/V16/objects2/query/upd_my_company.cfm">
		</cfcase>
		<cfcase value="emptypopup_partner_hobbies_upd">
			<cfinclude template="/V16/objects2/query/partner_hobbies_upd.cfm">
		</cfcase>
		<cfcase value="popup_app_add_mail">
			<cfinclude template="/V16/objects2/career/form/form_add_app_mail.cfm">
		</cfcase>
		<cfcase value="popup_upd_app_mail">
			<cfinclude template="/V16/objects2/career/form/form_upd_app_mail.cfm">
		</cfcase>
		<cfcase value="popup_show_cv_page">
			<cfinclude template="/V16/objects2/career/display/show_cv_page.cfm">
		</cfcase>
		<cfcase value="popup_print_files">
			<cfinclude template="/V16/objects2/display/print_files.cfm">">
		</cfcase>
		<cfcase value="popup_add_select_emp_list">
			<cfinclude template="/V16/objects2/career/form/add_select_emp_list.cfm">
		</cfcase>
		<cfcase value="emptypopup_add_select_emp_list">
			<cfinclude template="/V16/objects2/career/query/add_emp_app_select_list.cfm">
		</cfcase>
		<cfcase value="popup_dsp_city_ik">
			<cfinclude template="/V16/objects2/display/dsp_city.cfm">
		</cfcase>
		<cfcase value="popup_dsp_city">
			<cfinclude template="/V16/objects2/display/dsp_city.cfm">
		</cfcase>
		<cfcase value="popup_dsp_county">
			<cfinclude template="/V16/objects2/display/dsp_county.cfm">
		</cfcase>
		<cfcase value="add_message_send">
			<cfinclude template="/V16/objects2/career/query/add_message_send.cfm">			
		</cfcase>
		<cfcase value="emptypopup_updcv">
			<cfinclude template="/V16/objects2/career/query/upd_cv.cfm">
		</cfcase>
		<!--- sanal pos ve kredi karti tahsilati --->
		<cfcase value="******">
		</cfcase>
		<cfdefaultcase>
			<cfdump  var="error #fuseact_control#">

		</cfdefaultcase> 
	</cfswitch>
</cfif>