<cfif not structkeyexists(session,"basketww_camp")>
	<cfset session.basketww_camp = ArrayNew(2)>
</cfif>
<cfset fuseact_control = replace(fusebox.fuseaction,'autoexcelpopuppage_','','all')>
<cfswitch expression = "#fuseact_control#">
	<!--- agenda --->
	<cfcase value="form_add_event">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_form_add_detailed_survey_main_result">
		<cfinclude template="../objects/form/form_add_detailed_survey_main_result.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_detailed_survey_main_result">
		<cfinclude template="../objects/query/emptypopup_add_detailed_survey_main_result.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_event">
		<cfinclude template="agenda/query/popup_add_event.cfm">
	</cfcase>
	<cfcase value="form_upd_event">
		<cfinclude template="display/dynamic_page.cfm">		
	</cfcase>
	<cfcase value="emptypopup_upd_event">
		<cfinclude template="agenda/query/popup_upd_event.cfm">
	</cfcase>
	<cfcase value="emptypopup_del_event">
		<cfinclude template="agenda/query/del_event.cfm">
	</cfcase>
	<cfcase value="view_daily">
		<cfinclude template="agenda/display/view_daily.cfm">		
	</cfcase>
	<cfcase value="view_weekly">
		<cfinclude template="agenda/display/view_weekly.cfm">		
	</cfcase>
	<cfcase value="view_monthly">
		<cfinclude template="agenda/display/view_monthly.cfm">		
	</cfcase>
    <cfcase value="popup_event_result">
		<cfinclude template="agenda/display/event_result_new.cfm">
	</cfcase>
	<cfcase value="emptypopup_event_result">
		<cfinclude template="agenda/query/add_event_result.cfm">
	</cfcase>
	<cfcase value="list_events">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>

 	<!--- asset --->
	<cfcase value="list_assets">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_flvplayer">
		<cfinclude template="asset/flvplayer.cfm" />
	</cfcase>
	<cfcase value="form_add_asset">
		<cfset xfa.add = "add_asset" />
		<cfinclude template="form/add_asset.cfm" />
	</cfcase>
	<cfcase value="add_asset">
		<cfset attributes.extensionFilter="flv,mov,mpg,avi,wmv" />
		<cfset attributes.mimeTypeFilter="application/octet-stream" />
		<cfset attributes.maxFileSize=10*1000 /> <!--- 10 MB --->
		<cfset attributes.maxDuration=10*60 /> <!--- 10 minutes --->
		<cfinclude template="query/add_asset.cfm" />
	</cfcase>
	<cfcase value="popup_add_video_stream">
		<cfset xfa.add = "#request.self#?fuseaction=objects2.add_asset">
		<cfinclude template="form/add_video_stream.cfm" />
	</cfcase>
	<cfcase value="detail_video">
	   <cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="detail_live_video">
		<cfinclude template="asset/detail_live_video.cfm" />
	</cfcase>
	<cfcase value="popup_live_video_capture">
		<cfinclude template="asset/live_video_capture.cfm">
	</cfcase>
	<cfcase value="popup_live_video_player">
		<cfinclude template="asset/live_video_player.cfm" />
	</cfcase>
	<cfcase value="add_asset_comment">
		<cfinclude template="asset/add_asset_comment.cfm" />
	</cfcase>
	<cfcase value="add_live_asset_comment">
		<cfset xfa.video_detail = "objects2.detail_live_video" />
		<cfinclude template="asset/add_asset_comment.cfm" />
	</cfcase>
	<cfcase value="emptypopup_list_asset_comments">
		<cfinclude template="asset/list_asset_comments.cfm" />
	</cfcase>
	<cfcase value="emptypopup_set_asset_rating">
		<cfinclude template="asset/set_asset_rating.cfm" />
	</cfcase>
	<cfcase value="detail_photo">
		<cfinclude template="asset/detail_photo.cfm" />
	</cfcase>
	<cfcase value="list_all_videos">
		<cfinclude template="asset/list_all_videos.cfm">
	</cfcase>
	<cfcase value="list_videos">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="list_video">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_video_comment">
		<cfinclude template="asset/query/add_video_comment.cfm">
	</cfcase>
	<cfcase value="emptypopup_list_video_comments">
		<cfinclude template="asset/list_comments.cfm">
	</cfcase>
	<cfcase value="emptypopup_video_info">
		<cfinclude template="asset/video_info.cfm">
	</cfcase>
	<cfcase value="dsp_opportunity">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_add_asset">
		<cfinclude template="asset/add_asset.cfm">
	</cfcase>
	<cfcase value="popup_upd_asset">
		<cfinclude template="asset/upd_asset.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_asset">
		<cfinclude template="query/add_asset_file.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_asset">
		<cfinclude template="query/upd_asset_file.cfm">
	</cfcase>
	<cfcase value="emptypopup_del_asset_file">
		<cfinclude template="query/del_asset_file.cfm">
	</cfcase>
        
	<!--- call center --->
	<cfcase value="popup_add_service_help,add_service_help,add_service_help_supp">
		<cfinclude template="display/dynamic_page.cfm">			
	</cfcase>
	<cfcase value="security_capcha_page">
		<cfinclude template="display/security_capcha_page.cfm">			
	</cfcase>
	<cfcase value="emptypopup_add_service_help">
		<cfinclude template="query/add_service_help.cfm">			
	</cfcase>
	<cfcase value="emptypopup_add_service">
		<cfinclude template="service/query/add_service.cfm">			
	</cfcase>
	<cfcase value="helpdesk">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="online_support_team">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="add_customer_help">
		<cfinclude template="display/dynamic_page.cfm">			
	</cfcase>
	<cfcase value="upd_service_call_center">
		<cfinclude template="display/dynamic_page.cfm">		
	</cfcase>
	<cfcase value="popup_help_detail">
		<cfinclude template="display/help_detail.cfm">
	</cfcase>


	<!--- campaign --->
	<cfcase value="list_campaign">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="list_campaign_ww">
		<cfinclude template="display/dynamic_page.cfm">			
	</cfcase>
	<cfcase value="list_survey">
		<cfinclude template="display/dynamic_page.cfm">			
	</cfcase>
	<cfcase value="dsp_campaign">
		<cfinclude template="display/dynamic_page.cfm">	
	</cfcase>
	<cfcase value="poll">
		<cfinclude template="display/dynamic_page.cfm">	
	</cfcase>
	<cfcase value="form_vote_survey">
		<cfinclude template="display/dynamic_page.cfm">	
	</cfcase>
	<cfcase value="camp_mail">
		<cfinclude template="display/dynamic_page.cfm">	
	</cfcase>
	<cfcase value="popup_add_survey_vote">
		<cfinclude template="campaign/query/get_survey.cfm">
		<cfinclude template="campaign/query/get_survey_alts.cfm">
		<cfinclude template="campaign/query/add_survey_vote.cfm">
		<cflocation url="#request.self#?fuseaction=objects2.form_vote_survey&survey_id=#survey_id#" addtoken="No">
	</cfcase>
	<cfcase value="popup_add_campaign_maillist">
		<cfinclude template="campaign/query/add_campaign_maillist.cfm">	
	</cfcase>
	<cfcase value="emptypopup_add_campaign_comment">
		<cfinclude template="campaign/query/add_campaign_comment.cfm">
	</cfcase>

	<!--- career --->
	<cfcase value="form_add_cv">
		<cfinclude template="login/add_cv.cfm">
	</cfcase>
	<cfcase value="popup_add_cv">
		<cfinclude template="query/add_cv.cfm">
	</cfcase>
	<cfcase value="form_upd_cv">
		<cfinclude template="login/upd_cv.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_cv">
		<cfinclude template="query/upd_cv.cfm">
	</cfcase>
	<cfcase value="popup_show_cv_page">
		<cfinclude template="career/display/show_cv_page.cfm">
	</cfcase>
	<cfcase value="view_last_in_outs">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="upd_dsp_cv">
		<cfinclude template="career/display/upd_dsp_cv.cfm">
	</cfcase>
	<cfcase value="list_notices_partner">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="dsp_cv_partner">
		<cfinclude template="career/display/dsp_cv_partner.cfm">
	</cfcase>
	<cfcase value="list_cv">
		<cfinclude template="career/display/list_cv.cfm">
	</cfcase>	
	<cfcase value="form_add_notice">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_notice">
		<cfinclude template="career/query/add_notice.cfm">		
	</cfcase>
	<cfcase value="emptypopup_upd_notice">
		<cfinclude template="career/query/upd_notice.cfm">		
	</cfcase>
	<cfcase value="form_upd_notice">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_upd_notıce">
		<cfinclude template="career/query/upd_notice.cfm">		
	</cfcase>
	<cfcase value="emptypopup_del_notice">
		<cfinclude template="career/query/del_notice.cfm">
	</cfcase>
	<cfcase value="list_apps">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="upd_app_pos">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_app_pos">
		<cfinclude template="career/query/upd_app_pos.cfm">		
	</cfcase>
	<cfcase value="popup_app_add_mail">
		<cfinclude template="career/form/form_add_app_mail.cfm">		
	</cfcase>
	<cfcase value="emptypopup_add_empapp_mail">
		<cfinclude template="career/query/add_empapp_mail.cfm">		
	</cfcase>
	<cfcase value="popup_upd_app_mail">
		<cfinclude template="career/form/form_upd_app_mail.cfm">		
	</cfcase>
	<cfcase value="emptypopup_upd_empapp_mail">
		<cfinclude template="career/query/upd_empapp_mail.cfm">		
	</cfcase>
	<cfcase value="list_notices">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="search_app">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="list_search_app">
		<cfinclude template="career/display/list_search_app.cfm">
	</cfcase>
	<cfcase value="popup_list_notices">
		<cfinclude template="career/display/list_app_notices.cfm">
	</cfcase>
	<cfcase value="popup_add_select_emp_list">
		<cfinclude template="career/form/add_select_emp_list.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_select_emp_list">
		<cfinclude template="career/query/add_emp_app_select_list.cfm">
	</cfcase>
	<cfcase value="kariyer_login">
		<cfinclude template="display/dynamic_page.cfm"> <!-- Üye giriş --->
	</cfcase>
	<cfcase value="form_add_new_user">
		<cfinclude template="display/dynamic_page.cfm">		
	</cfcase>
	<cfcase value="popup_add_new_user">
		<cfinclude template="career/query/add_new_user.cfm">		
	</cfcase>
	<cfcase value="popup_list_spect_main">
		<cfinclude template="display/list_spect_main.cfm">
	</cfcase>
	<cfcase value="dsp_notice">
		<cfinclude template="display/dynamic_page.cfm">	
	</cfcase>
	<cfcase value="popup_calender_ik">
		<cfinclude template="career/form/list_calender.cfm">
	</cfcase>
	<cfcase value="form_upd_fast_cv">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_fast_updcv">
		<cfinclude template="career/query/upd_fast_cv.cfm">
	</cfcase>
	<cfcase value="form_upd_cv_1">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_updcv">
		<cfinclude template="career/query/upd_cv.cfm">
	</cfcase>
	<cfcase value="popup_dsp_city_ik">
		<cfinclude template="career/display/dsp_city.cfm">
	</cfcase>
	<cfcase value="popup_dsp_county_ik">
		<cfinclude template="career/display/dsp_county_ik.cfm">
	</cfcase>
	<cfcase value="form_upd_cv_2">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="form_upd_cv_3">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="form_upd_cv_4">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="add_message_send">
		<cfinclude template="career/query/add_message_send.cfm">			
	</cfcase>
	<cfcase value="popup_upd_work_info">
		<cfinclude template="career/form/emp_upd_work_info.cfm">
	</cfcase>
	<cfcase value="form_upd_cv_5">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="form_upd_cv_6">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="form_upd_cv_7">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="form_upd_cv_8">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="form_upd_cv_9">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="form_upd_cv_10">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="form_upd_cv_11">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_form_add_relative">
		<cfinclude template="career/form/form_add_relative.cfm">
	</cfcase>
	<cfcase value="popup_form_upd_relative">
		<cfinclude template="career/form/form_upd_relative.cfm">
	</cfcase>
	<cfcase value="popup_form_add_app_pos">
		<cfinclude template="career/form/form_add_app_pos.cfm">
	</cfcase>
	<cfcase value="popup_form_share_notice">
		<cfinclude template="career/form/form_share_notice.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_app_pos">
		<cfinclude template="career/query/add_app_pos.cfm">
	</cfcase>
	<cfcase value="form_lost_pass">
		<cfinclude template="career/form/form_lost_pass.cfm">
	</cfcase>
	<cfcase value="popup_lost_pass">
		<cfinclude template="career/query/lost_pass.cfm">
	</cfcase>
	<cfcase value="list_app_pos">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_dsp_app_pos">
		<cfinclude template="career/display/dsp_app_pos.cfm">
	</cfcase>
	<cfcase value="popup_dsp_mails">
		<cfinclude template="career/display/dsp_mails.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_relative">
		<cfinclude template="career/query/add_relative.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_relative">
		<cfinclude template="career/query/upd_relative.cfm">
	</cfcase>
	<cfcase value="emptypopup_del_relative">
		<cfinclude template="career/query/del_relative.cfm">
	</cfcase>
	<cfcase value="dsp_cv">
		<cfinclude template="display/dynamic_page.cfm">	
	</cfcase>
	<cfcase value="popup_change_pass,change_pass">
		<cfinclude template="display/dynamic_page.cfm">	
	</cfcase>
	<cfcase value="emptypopup_add_change_pass">
		<cfinclude template="career/query/add_change_pass.cfm">	
	</cfcase>
	<cfcase value="emptypopup_add_change_cons_pass">
		<cfinclude template="query/add_change_cons_pass.cfm">	
	</cfcase>
        		
	<!--- chart --->
	<cfcase value="list_basket_camp">
		<cfinclude template="display/dynamic_page.cfm">  
	</cfcase>
	<cfcase value="form_add_orderww_camp"><!--- sepeti sipariş olarak kaydet formu --->
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_basketww_row_puan"><!--- sepete tek ürün ekle --->
		<cfinclude template="query/add_basketww_row_puan.cfm">  
	</cfcase>
	<cfcase value="emptypopup_add_basketww_row"><!--- sepete tek ürün ekle --->
		<cfinclude template="query/add_basketww_row.cfm">  
	</cfcase>
	<cfcase value="emptypopup_add_basket_row_bundle"><!--- sepete karma ürün ekle --->
		<cfinclude template="query/add_basket_row_bundle.cfm">  
	</cfcase>
	<cfcase value="emptypopup_upd_basketww_row"><!--- sepetteki ürünlerin miktarını güncelle --->
		<cfinclude template="query/upd_basketww_row.cfm">  
	</cfcase>	
	<cfcase value="popup_list_basketww_proposal"><!--- sepetten teklif hazırlama --->
		<cfinclude template="sale/basket_proposal.cfm">  
	</cfcase>
	<cfcase value="emptypopup_del_basketww_row"><!--- sepetten tek ürün sil --->
		<cfinclude template="query/del_basketww_row.cfm">  
	</cfcase>
	<cfcase value="emptypopup_upd_basketww_row_one"><!--- sepetten tek ürün sil --->
		<cfinclude template="query/upd_basketww_row_one.cfm">  
	</cfcase>
    <cfcase value="emptypopup_upd_basketww_row_checked"><!--- sepetten ürünlerin checkini kaldır --->
		<cfinclude template="query/upd_basketww_row_checked.cfm">  
	</cfcase>
    <cfcase value="emptypopup_upd_basketww_row_discounts"><!--- sepetteki urunlerin secilen proje baglantılarına gore indirimleri set edilir--->
		<cfinclude template="query/upd_basketww_row_discounts.cfm">  
	</cfcase>
	<cfcase value="emptypopup_add_basketww_config_row"><!--- konfigüre edilen ürünü sepete ekle --->
		<cfinclude template="query/add_basketww_config_row.cfm">  
	</cfcase>	
	<cfcase value="emptypopup_add_basketww_custom_row"><!--- özelleştirilebilir ürünü sepete ekle --->
		<cfinclude template="query/add_basketww_custom_row.cfm">  
	</cfcase>			
	<cfcase value="emptypopup_del_basketww"><!--- sepeti boşalt --->
		<cfinclude template="query/del_basketww.cfm">
	</cfcase>
	<cfcase value="emptypopup_del_basket_puan"><!--- sepeti boşalt puan--->
		<cfinclude template="query/del_basket_puan.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_orderww_js"><!--- sepeti sipariş olarak kaydet formu --->
		<cfcontent type="application/x-javascript; charset=utf-8">
		<cfsetting showdebugoutput="no">
		<cfinclude template="form/add_orderww_ic_js.cfm">
	</cfcase>
	<cfcase value="emptypopup_get_cargo_information"><!--- sepeti sipariş olarak kaydet formu --->
		<cfinclude template="form/get_cargo_information.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_orderww"><!--- sepeti sipariş olarak kaydet --->
		<cfinclude template="query/add_orderww.cfm">
	</cfcase>
	<cfcase value="emptypopup_del_row_puan">
		<cfinclude template="query/del_row_puan.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_offerww"><!--- sepeti teklif olarak kaydet formu --->
		<cfinclude template="query/add_offerww.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_offer_pp"><!--- sepeti teklif olarak kaydet formu --->
		<cfinclude template="query/add_offer_pp.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_basketww_row_camp"><!--- sepete tek ürün ekle --->
		<cfinclude template="query/add_basketww_row_camp.cfm">  
	</cfcase>
	<cfcase value="emptypopup_upd_basketww_row_camp"><!--- sepetteki ürünlerin miktarını güncelle --->
		<cfinclude template="query/upd_basketww_row_camp.cfm">  
	</cfcase>
	<cfcase value="emptypopup_del_basketww_row_camp"><!--- sepetten tek ürün sil --->
		<cfinclude template="query/del_basketww_row_camp.cfm">  
	</cfcase>
	<cfcase value="emptypopup_del_basketww_camp"><!--- sepeti boşalt --->
		<cfinclude template="query/del_basketww_camp.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_orderww_camp"><!--- sepeti sipariş olarak kaydet --->
		<cfinclude template="query/add_orderww_camp.cfm">
	</cfcase>
        
	<!--- content --->
	<cfcase value="view_content">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="view_content_category">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="view_content_member">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="view_content_chapter">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_detail_content,detail_content">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="chapter_content_list">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="search_result">
		<cfinclude template="display/dynamic_page.cfm">		
	</cfcase>
	<cfcase value="general_search_result">
		<cfinclude template="display/dynamic_page.cfm">		
	</cfcase>
	<cfcase value="emptypopup_get_body_query">
		<cfinclude template="query/get_body_query.cfm">
	</cfcase>
	<cfcase value="popup_add_content_comment">
		<cfinclude template="content/add_content_comment.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_content_comment">
		<cfinclude template="query/add_content_comment.cfm">
	</cfcase>
	<cfcase value="popup_view_content_comment">
		<cfinclude template="content/view_content_comment.cfm">
	</cfcase>
	<cfcase value="popup_content_notice">
		<cfinclude template="content/content_notice.cfm">		
	</cfcase>
	<cfcase value="content_vote">
		<cfinclude template="content/content_vote.cfm">		
	</cfcase>
	<cfcase value="emptypopup_add_content_vote">
		<cfinclude template="query/add_content_vote.cfm">
	</cfcase>
	<cfcase value="emptypopup_get_contentcat">
		<cfinclude template="query/get_contentcat_ajax.cfm">
	</cfcase>
	<cfcase value="emptypopup_get_content_ajax">
		<cfinclude template="query/get_content_ajax.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_cont_comment">
		<cfinclude template="query/add_cont_comment.cfm">
	</cfcase>
	<cfcase value="emptypopupajax_view_content_comment">
		<cfinclude template="content/contentComments.cfm">
	</cfcase>


	<!--- education --->
	<cfcase value="popup_add_edu_info">
		<cfinclude  template="career/form/add_edu_info.cfm">
	</cfcase>
	<cfcase value="list_class">
		<cfinclude template="training/display/list_class.cfm">
	</cfcase>
	<cfcase value="view_class">
		<cfinclude template="../training/display/view_class.cfm">
	</cfcase>
	<cfcase value="popup_make_quiz">
		<cfinclude template="../training/display/make_quiz.cfm">
	</cfcase>
	<cfcase value="emptypopup_list_content_relation">
		<cfinclude template="../objects/display/list_content_ajax.cfm">
	</cfcase>
	<cfcase value="popup_dsp_content">
		<cfinclude template="../objects/display/dsp_content.cfm">
	</cfcase>
	<cfcase value="popup_form_add_training_note">
		<cfinclude template="../training/form/add_training_note.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_training_note">
		<cfinclude template="../training/query/add_training_note.cfm">
	</cfcase>
	<cfcase value="popup_form_upd_training_note">
		<cfinclude template="../training/form/upd_training_note.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_training_note">
		<cfinclude template="../training/query/upd_training_note.cfm">
	</cfcase>
	<cfcase value="popup_inspection_class">
	   <cfinclude template="../training/display/inspection_class.cfm">
	</cfcase>
	<cfcase value="emptypopup_inspection_class">
	   <cfinclude template="../training/query/inspection_class.cfm">
	</cfcase>
	<cfcase value="popup_added_class">
	   <cfinclude template="../training/form/added_class.cfm">
	</cfcase>
	<cfcase value="emptypopup_added_class">
	   <cfinclude template="../training/query/added_class.cfm">
	</cfcase>
	<cfcase value="popup_online_white_board">
		<cfinclude template="../training_management/display/online_white_board.cfm">
	</cfcase>
	<cfcase value="popup_list_product_cats">
		<cfinclude template="product/list_product_cats_popup.cfm">
	</cfcase>
	<cfcase value="popup_list_ship_methods">
		<cfinclude template="display/list_ship_methods_popup.cfm">
	</cfcase>
	<cfcase value="popup_list_projects">
		<cfinclude template="display/list_projects_popup.cfm">
	</cfcase>
	<cfcase value="training_list">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_add_class_attender">
		<cfinclude template="training/display/add_class_attender.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_class_attender">
		<cfinclude template="training/query/add_class_attender.cfm">
	</cfcase>
	
	<!--- finance --->
	<cfcase value="list_extre_simple">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="list_extre">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="list_payments">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_dsp_credit_card_payment_type">
		<cfinclude template="finance/display/dsp_credit_card_payment_type.cfm"><!--- Kredi karti tahsilat --->
	</cfcase>
	<cfcase value="popup_dsp_credit_card_pay">
		<cfinclude template="finance/display/dsp_credit_card_pay.cfm"><!--- kredi karti odeme --->
	</cfcase>
	<cfcase value="popup_dsp_debt_claim_note">
		<cfinclude template="finance/display/dsp_debt_claim_note.cfm"><!--- borc/alacak dekontu --->
	</cfcase>
	<cfcase value="popup_dsp_cari_to_cari">
		<cfinclude template="finance/display/dsp_cari_to_cari.cfm"><!--- cari virman --->
	</cfcase>
	<cfcase value="popup_dsp_alisf_kapa">
		<cfinclude template="finance/display/upd_alisf_kapa_.cfm"><!--- alis fatura kapama --->
	</cfcase>
	<cfcase value="popup_dsp_satisf_kapa">
		<cfinclude template="finance/display/upd_satisf_kapa_.cfm"><!--- satis fatura kapama --->
	</cfcase>
	<cfcase value="popup_dsp_cash_revenue">
		<cfinclude template="finance/display/upd_cash_revenue_.cfm"><!--- nakit tahsilat --->
	</cfcase>
	<cfcase value="popup_dsp_cash_payment">
		<cfinclude template="finance/display/upd_cash_payment_.cfm"><!--- Odeme islemi --->
	</cfcase>
	<cfcase value="popup_dsp_gelenh">
		<cfinclude template="finance/display/upd_gelenh_.cfm"><!--- gelen havale --->
	</cfcase>
	<cfcase value="popup_dsp_gidenh">
		<cfinclude template="finance/display/upd_gidenh_.cfm"><!--- giden havale --->
	</cfcase>
	<cfcase value="popup_detail_invoice">
		<cfinclude template="finance/display/detail_invoice.cfm"><!--- Fatura detay --->
	</cfcase>
	<cfcase value="popup_dsp_payroll_entry">
		<cfinclude template="finance/display/upd_payroll_entry_.cfm"><!--- Cek Giris Bordrosu --->
	</cfcase>
	<cfcase value="popup_dsp_payroll_entry_return">
		<cfinclude template="finance/display/upd_payroll_entry_return_.cfm"><!--- Cek Giris İade Bordrosu --->
	</cfcase>
	<cfcase value="popup_dsp_payroll_endor_return">
		<cfinclude template="finance/display/upd_payroll_endor_return_.cfm"><!--- Cek Cikis Bordrosu İade --->
	</cfcase>
	<cfcase value="popup_dsp_payroll_endorsement">
		<cfinclude template="finance/display/upd_payroll_endorsement_.cfm"><!--- Cek Cikis Bordrosu (Ciro) --->
	</cfcase>
	<cfcase value="popup_dsp_voucher_endorsement">
		<cfinclude template="finance/display/upd_voucher_endorsement_.cfm"><!--- Senet Cikis Bordrosu --->
	</cfcase>
	<cfcase value="popup_dsp_account_open">
		<cfinclude template="finance/display/dsp_acc_opening.cfm"><!--- Cari Acilis Fisi --->
	</cfcase>
	<cfcase value="popup_dsp_assign_order">
		<cfinclude template="finance/display/dsp_assign_order.cfm"><!--- Banka Talimatı --->
	</cfcase>
	<cfcase value="popup_list_cost_expense">
		<cfinclude template="finance/display/list_cost_expense.cfm"><!--- Gelir/Masraf Fisi--->
	</cfcase>		
	<cfcase value="popup_cheque_det">
		<cfinclude template="finance/display/detail_cheque.cfm">
	</cfcase>
	<cfcase value="popup_paymethods">
		<cfinclude template="finance/display/popup_list_paymethods.cfm">
	</cfcase>
    	<cfcase value="popup_voucher_det">
		<cfinclude template="../objects/display/detail_voucher.cfm">
	</cfcase>

	
	<!--- forum --->
	<cfcase value="list_forums">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="view_reply">
		<cfinclude template="forum/display/list_reply.cfm">	
	</cfcase>
	<cfcase value="form_add_reply">
		<cfinclude template="forum/display/form_add_reply.cfm">
	</cfcase>
	<cfcase value="form_upd_reply">
		<cfinclude template="forum/display/form_upd_reply.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_reply">
		<cfinclude template="forum/query/add_reply.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_reply">
		<cfinclude template="forum/query/upd_reply.cfm">
	</cfcase>
	<cfcase value="emptypopup_del_reply">
		<cfinclude template="forum/query/del_reply.cfm">
	</cfcase>
	<cfcase value="view_topic">
		<cfinclude template="forum/display/list_topic.cfm">
	</cfcase>
	<cfcase value="form_add_topic">
		<cfinclude template="forum/display/form_add_topic.cfm">
	</cfcase>
	<cfcase value="form_upd_topic">
		<cfinclude template="forum/display/form_upd_topic.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_topic">
		<cfinclude template="forum/query/add_topic.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_topic">
		<cfinclude template="forum/query/upd_topic.cfm">
	</cfcase>
	<cfcase value="emptypopup_del_topic">
		<cfinclude template="forum/query/del_topic.cfm">
	</cfcase>
	<cfcase value="search">
		<cfinclude template="forum/display/list_results.cfm">
	</cfcase>
	<cfcase value="popup_list_currency_history">
		<cfinclude template="display/popup_list_currency_history.cfm">
	</cfcase>
    
	<!--- homepage --->
	<cfcase value="public_homepage,partner_homepage,welcome">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="new_friends">
		<cfinclude template="display/dynamic_page.cfm">			
	</cfcase>
	<cfcase value="sector_cats">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>


	<!--- login / logout --->
	<cfcase value="public_login">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="partner_login">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>

		
	<!--- member --->
	<cfcase value="list_partner">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="view_member">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="member_login">
		<cfinclude template="display/dynamic_page.cfm"> <!-- Üye giriş --->
	</cfcase>
	<cfcase value="add_my_member">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="upd_my_member">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="upd_my_partner">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>	
	<cfcase value="list_my_members">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="list_members">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="list_brands">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="add_member">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="add_member_consumer">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_add_member_company">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="add_member_company">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="add_opportunity">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="add_supplier">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="add_my_consumer">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="upd_my_consumer">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="upd_consumer">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="communication">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_add_service_callcenter,add_service_callcenter">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="add_service_callcenter_system">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="add_notes">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="me">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="add_consumer">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_list_member_address">
		<cfinclude template="member/list_member_address.cfm">
	</cfcase>
	<cfcase value="popup_par_det">
		<cfinclude template="login/detail_par.cfm">
	</cfcase>
	<cfcase value="popup_emp_det">
		<cfinclude template="login/detail_emp.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_my_member">
		<cfinclude template="query/upd_my_member.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_my_partner">
		<cfinclude template="query/upd_my_partner.cfm">
	</cfcase>
	<cfcase value="popup_check_company_prerecords">
		<cfinclude template="member/check_company_prerecords.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_cons_member">
		<cfinclude template="query/add_cons_member.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_comp_member">
		<cfinclude template="query/add_member_company.cfm">
	</cfcase>
	<cfcase value="popup_add_consumer_address">
		<cfinclude template="member/add_consumer_address.cfm">
	</cfcase>
	<cfcase value="popup_upd_consumer_address">
		<cfinclude template="member/upd_consumer_address.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_member_team">
		<cfinclude template="query/add_member_team.cfm">
	</cfcase>
	<cfcase value="popup_list_ims_code">
		<cfinclude template="login/list_ims_code.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_my_consumer">
		<cfinclude template="query/upd_my_consumer.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_member_site_relation">
		<cfinclude template="query/add_member_site_relation.cfm">
	</cfcase>
	<cfcase value="popup_denied_pages_partner">
		<cfinclude template="member/denied_pages_partner.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_denied_pages_partner">
		<cfinclude template="query/add_denied_pages_partner.cfm">
	</cfcase>
		<cfcase value="popup_form_add_branch,form_add_branch">
		<cfinclude template="form/form_add_address.cfm">
	</cfcase>
	<cfcase value="form_add_address">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_branch_address">
		<cfinclude template="query/add_address.cfm">
	</cfcase>
	<cfcase value="popup_form_upd_branch,form_upd_branch">
		<cfinclude template="form/form_upd_address.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_branch_address">
		<cfinclude template="query/upd_address.cfm">
	</cfcase>
	<cfcase value="form_upd_my_company">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_my_company">
		<cfinclude template="query/upd_my_company.cfm">
	</cfcase>
	<cfcase value="popup_form_add_partner,form_add_partner">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_partner">
		<cfinclude template="query/add_partner.cfm">
	</cfcase>
	<cfcase value="form_upd_partner">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_partner">
		<cfinclude template="query/upd_partner.cfm">
	</cfcase>
	<cfcase value="list_analyses">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="dsp_analyses">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_con_det">
		<cfinclude template="../objects/display/detail_con.cfm">
	</cfcase>
	<cfcase value="popup_list_cons">
		<cfinclude template="../objects/display/list_cons.cfm">
	</cfcase>
	<cfcase value="popup_membercode_remainder">
		<cfinclude template="form/membercode_remainder.cfm">
	</cfcase>
	<cfcase value="emptypopup_calc_analysis">
		<cfinclude template="query/get_analysis.cfm">
		<cfset session.analysis_id = attributes.analysis_id>
		<cfinclude template="query/get_analysis_questions.cfm">
		<cfinclude template="query/calc_analysis_result.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_calc_analysis">
		<cfinclude template="query/get_analysis.cfm">
		<cfset session.analysis_id = attributes.analysis_id>
		<cfinclude template="query/get_analysis_questions.cfm">
		<!---<cfinclude template="query/upd_calc_analysis_result.cfm">--->
	</cfcase>
	<cfcase value="analysis_results">
		<cfinclude template="query/get_analysis.cfm">
		<cfinclude template="query/get_analysis_questions.cfm">
		<cfinclude template="query/get_analysis_results.cfm">
	<!--- <cfinclude template="login/analysis_results.cfm">--->
	</cfcase>
	<cfcase value="emptypopup_add_my_consumer">
		<cfinclude template="query/add_my_consumer.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_consumer">
		<cfinclude template="query/upd_consumer.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_comp_member">
		<cfinclude template="query/upd_member_company.cfm">
	</cfcase>
	<cfcase value="partner_hobbies">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_partner_hobbies_upd">
		<cfinclude template="query/partner_hobbies_upd.cfm">
	</cfcase>
	<cfcase value="popup_upd_company_partner_req_type">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_company_partner_req_type_upd">
		<cfinclude template="query/company_partner_req_type_upd.cfm">
	</cfcase>

		
	<!--- messaging --->
	<cfcase value="pm_kontrol,emptypopup_pm_kontrol">
		<cfinclude template="display/pm_message_control.cfm">
	</cfcase>
	<cfcase value="popup_online_chat">
		<cfinclude template="../objects/display/live_chat.cfm">
	</cfcase>
	<cfcase value="popup_service_defect_codes">
		<cfinclude template="service/display/list_service_defect_codes_popup.cfm">
	</cfcase>
	<cfcase value="popup_add_nott">
		<cfinclude template="form/add_notes.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_notes_visited">
		<cfinclude template="query/add_notes_visited.cfm">
	</cfcase>
	<cfcase value="popup_message">
		<cfinclude template="login/dsp_message.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_message">
		<cfinclude template="query/add_message.cfm">
	</cfcase>
	<cfcase value="popup_send_sms_arrangement">
		<cfinclude template="query/arrange_sms.cfm">
	</cfcase>
	<cfcase value="popup_send_sms">
		<cfinclude template="login/send_sms.cfm">
	</cfcase>
	<cfcase value="popup_form_add_note">
		<cfinclude template="../objects/form/popup_add_note.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_all_note">
		<cfinclude template="../objects/query/add_all_note.cfm">
	</cfcase>
	<cfcase value="emptypopup_del_note">
		<cfinclude template="../objects/query/del_note.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_note">
		<cfinclude template="../objects/query/upd_note.cfm">
	</cfcase>	
	<cfcase value="popup_form_upd_note">
		<cfinclude template="../objects/form/popup_upd_note.cfm">
	</cfcase>
 
 	<!--- pdf , mail , fax , documenter objects --->
	<cfcase value="popup_convertpdf">
		<cfinclude template="../objects/display/documenter_pdf.cfm">
	</cfcase>
	<cfcase value="popup_list_all_pars_multiuser">
		<cfinclude template="display/list_pars_multiuser_popup.cfm">
	</cfcase>
	<cfcase value="popup_list_pot_pars_multiuser">
		<cfinclude template="display/list_pars_multiuser_popup.cfm">
	</cfcase>
	<cfcase value="popup_list_all_cons_multiuser">
		<cfinclude template="display/list_cons_multiuser_popup.cfm">
	</cfcase>
	<cfcase value="popup_list_pot_cons_multiuser">
		<cfinclude template="display/list_cons_multiuser_popup.cfm">
	</cfcase>
	<cfcase value="popup_send_flash_paper_action">
		<cfinclude template="../objects/display/dsp_flash_paper_action.cfm">
	</cfcase>

	<cfcase value="popup_mail">
		<cfinclude template="../objects/display/documenter_mail.cfm">
	</cfcase>

	<cfcase value="popup_mail_act">
		<cfinclude template="../objects/display/get_document_mail.cfm">
	</cfcase>

	<cfcase value="popup_content">
		<cfinclude template="../objects/display/dsp_template.cfm">		
	</cfcase>
	<cfcase value="popup_operate_action">
		<cfinclude template="../objects/display/operate_action.cfm">		
	</cfcase>
	<cfcase value="popup_operate_page">
		<cfinclude template="../objects/display/operate_page.cfm">		
	</cfcase>

    	<cfcase value="get_app_sub_cat_ajax">
		<cfinclude template="../service/display/get_appcat_sub_cat.cfm">  
	</cfcase>
	<cfcase value="popup_documenter,emptypopup_documenter">
		<cfinclude template="../objects/display/documenter.cfm">
	</cfcase>
	<cfcase value="emptypopup_get_document">
		<cfinclude template="../objects/display/get_document.cfm">
	</cfcase>
	<cfcase value="emptypopup_get_document2">
		<cfinclude template="../objects/display/get_document2.cfm">
	</cfcase>
	<cfcase value="popup_send_print">
		<cfinclude template="../objects/display/dsp_print.cfm">
	</cfcase>
	<cfcase value="popup_send_print_action">
		<cfinclude template="../objects/display/dsp_action_print.cfm">
	</cfcase>
	<cfcase value="popup_view_map">
		<cfinclude template="../objects/display/view_map.cfm">
	</cfcase>	
	<!--- pdf , mail , fax , documenter objects --->
       			
	<!--- print --->
	<cfcase value="popup_print_files,popupflush_print_files">
		<cfinclude template="display/print_files.cfm">
	</cfcase>
	<cfcase value="emptypopup_print_files_inner">
		<cfinclude template="display/print_files_inner.cfm">
	</cfcase>

        			
	<!--- product --->
	<cfcase value="list_promotions">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="detail_product,popup_detail_product">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="view_vision">
		<cfinclude template="display/dynamic_page.cfm"> <!-- Vizyon ürünleri -->
	</cfcase>
	<cfcase value="view_vision_simple">
		<cfinclude template="display/dynamic_page.cfm"> <!-- Vizyon ürünleri simple -->
	</cfcase>
	<cfcase value="product_category_brand_image">
		<cfinclude template="display/dynamic_page.cfm"> <!-- Kategori Marka İkonlu -->
	</cfcase>
	<cfcase value="view_product_list,popup_view_product_list">
		<cfinclude template="display/dynamic_page.cfm"> <!-- Özel fiyatlı liste -->
	</cfcase>
	<cfcase value="list_favourities">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="list_price_end_series">
		<cfinclude template="display/dynamic_page.cfm"> <!-- Özel fiyatlı liste -->
	</cfcase>
	<cfcase value="view_product_configure">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="search_product_result">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="view_brand_page">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="product_compare">
		<cfinclude template="display/dynamic_page.cfm"> <!-- Aynı kategorideki ürünleri karşılaştırır -->
	</cfcase>
	<cfcase value="view_product_list_bundle">
		<cfinclude template="display/dynamic_page.cfm"> <!-- Karma Koli liste -->
	</cfcase>
	<cfcase value="list_product_simple">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="list_detail_promotions,popup_list_detail_promotions">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="view_action">
		<cfinclude template="display/dynamic_page.cfm"> <!-- Aksiyon ürünleri -->
	</cfcase>
	<cfcase value="emptypopup_get_summary_tabbed">
		<cfinclude template="query/get_summary_tabbed.cfm"/>
	</cfcase>
	<cfcase value="emptypopup_get_vision_tabbed">
		<cfinclude template="query/get_vision_tabbed.cfm" />
	</cfcase>
	<cfcase value="emptypopup_dsp_promotion_detail">
		<cfinclude template="campaign/display/dsp_promotion_detail.cfm">
	</cfcase>
	<cfcase value="emptypopup_ajax_check_paper_promotion_products">
		<cfinclude template="query/check_promotion_products.cfm">
	</cfcase>
	<cfcase value="popup_add_product_comment">
		<cfinclude template="product/add_product_comment.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_product_comment">
		<cfinclude template="query/add_product_comment.cfm">
	</cfcase>
	<cfcase value="popup_view_all_product_comment">
		<cfinclude template="product/view_all_product_comment.cfm">
	</cfcase>
	<cfcase value="product_vote">
		<cfinclude template="product/product_vote.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_product_vote">
		<cfinclude template="query/add_product_vote.cfm">
	</cfcase>
	<cfcase value="emptypopup_stock_inform">
		<cfinclude template="query/stock_inform.cfm">
	</cfcase>
	<cfcase value="product_configure_proposal">
		<cfinclude template="product/product_configure_proposal.cfm">
	</cfcase>
	<cfcase value="product_configure">
		<cfinclude template="product/product_configure.cfm">
	</cfcase>
	<cfcase value="popup_product_customize">
		<cfinclude template="product/product_customize.cfm">
	</cfcase>
	<cfcase value="popup_product_customize_proposal">
		<cfinclude template="product/product_customize_proposal.cfm">
	</cfcase>
	<cfcase value="popup_order_print">
		<cfinclude template="display/popup_order_print.cfm">
	</cfcase>
	<cfcase value="popup_print_product_label">
		<cfinclude template="display/print_product_property_label.cfm">
	</cfcase>
	<!--- Spec kayıt popupu --->
    <cfcase value="popup_add_spect_list">
		<cfinclude template="../objects/form/add_spect_list.cfm">
	</cfcase>
    <!--- alternative sorulardan spec kaydetme --->
	<cfcase value="emptypopup_addSpecFromAlternativeProduct">
		<cfinclude template="../objects/query/addSpecFromAlternativeProduct.cfm">
	</cfcase>
	<cfcase value="emptypopup_spec_alternative_product_image">
		<cfinclude template="../objects/display/spec_alternative_product_image.cfm">
	</cfcase>
    <cfcase value="add_my_favourites">
		<cfinclude template="query/add_my_favourites.cfm">
	</cfcase>
	 <cfcase value="del_my_favourites">
		<cfinclude template="query/del_my_favourites.cfm">
	</cfcase>
	<cfcase value="popup_addSpecFromAlternativeProduct">
		<cfinclude template="../objects/query/addSpecFromAlternativeProduct.cfm">
	</cfcase>

	<!--- project --->
	<cfcase value="list_projects">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="dsp_pro_detail">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_ajax_project_works">
		<cfinclude template="project/display/pro_works_list.cfm">
	</cfcase>
	<cfcase value="popup_graph">
		<cfinclude template="project/display/popup_graph.cfm">
	</cfcase>
	<cfcase value="updwork,popup_updwork">
		<cfinclude template="project/form/upd_work.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_work">
		<cfinclude template="project/query/upd_work.cfm">
	</cfcase>
	<cfcase value="delwork">
		<cfinclude template="project/query/del_work.cfm">
	</cfcase>
	<cfcase value="popup_addwork">
		<cfinclude template="project/form/add_prowork.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_pro_work">
		<cfinclude template="project/query/add_prowork.cfm">
	</cfcase>
	<cfcase value="popup_add_relation">
		<cfinclude template="project/form/add_work_relation.cfm">
	</cfcase>
	<cfcase value="emptypopup_relate_event">
		<cfinclude template="project/query/relate_opp_event.cfm">
	</cfcase>
	<cfcase value="popup_add_mail">
		<cfinclude template="project/form/add_mail.cfm">
	</cfcase>
	<cfcase value="graph">
		<cfinclude template="../project/display/graph.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_mail">
		<cfinclude template="project/query/add_mail.cfm">
	</cfcase>
	<cfcase value="popup_add_work">
		<cfinclude template="../objects/display/list_works.cfm">
	</cfcase>

            
	<!--- sanal pos ve kredi karti tahsilati --->
	<cfcase value="popup_add_online_pos_kontrol"><!--- sipariş sonlandır ve tek ödeme kontrol ekranı --->
		<cfinclude template="form/add_online_pos_kontrol.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_online_pos_from_order"><!--- sipariş sonlandır tahsilat --->
		<cfinclude template="query/add_online_pos_from_order.cfm">
	</cfcase>
	<cfcase value="add_online_pos_from_order"><!--- sipariş sonlandır tahsilat --->
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_add_online_pos"><!--- ch tan tek ödeme sayfası--->
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_add_online_pos_vft"><!--- ch tan tek ödeme sayfası--->
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_add_online_pos_action"><!--- ch tan tek ödeme action--->
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_credit_card_revenue"><!--- tahsilat--->
		<cfinclude template="finance/query/add_credit_card_revenue.cfm">
	</cfcase>
	<cfcase value="popup_add_online_pos_print">
		<cfinclude template="finance/display/add_online_pos_print.cfm">
	</cfcase>
	<cfcase value="popup_dsp_response_code"><!--- olumsuz dönüş kodlarını gösteren sayfa --->
		<cfinclude template="finance/display/dsp_response_code.cfm">
	</cfcase>
	<!--- sanal pos ve kredi karti tahsilati --->

	<!--- sale --->
	<cfcase value="add_orderww"><!--- sepeti sipariş olarak kaydet --->
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="form_add_orderww"><!--- sepeti sipariş olarak kaydet formu --->
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="view_list_ref_order">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="view_list_order_purchase">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="view_list_order_ref">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="view_list_order">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="view_list_old_order">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="view_list_order_hierarchy">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="list_money_credits">
		<cfinclude template="display/dynamic_page.cfm">			
	</cfcase>	
	<cfcase value="online_sales_team">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="order_detail">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="order_detail_purchase">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="list_gift_cards">
		<cfinclude template="display/dynamic_page.cfm">			
	</cfcase>
	<cfcase value="view_list_offer">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="offer_detail">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="add_offer">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="list_basket">
		<cfinclude template="display/dynamic_page.cfm">  
	</cfcase>
	<cfcase value="sale_analyse">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="list_order_demands">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="sale_analyse_orders">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="purchase_analyse">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="list_opportunities">
		<cfinclude template="display/dynamic_page.cfm">	
	</cfcase>
	<cfcase value="opportunities">
		<cfinclude template="display/dynamic_page.cfm">	
	</cfcase>
	<cfcase value="form_add_opportunity">
		<cfinclude template="display/dynamic_page.cfm">	
	</cfcase>
	<cfcase value="form_upd_opportunity">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="list_subscription">
		<cfinclude template="display/dynamic_page.cfm">	
	</cfcase>
	<cfcase value="list_subscription_ref">
		<cfinclude template="display/dynamic_page.cfm">	
	</cfcase>
	<cfcase value="dsp_subscription">
		<cfinclude template="display/dynamic_page.cfm">	
	</cfcase>
	<cfcase value="emptypopup_show_joker_vada">
		<cfinclude template="form/show_joker_vada.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_order_hier">
		<cfinclude template="query/upd_order_hier.cfm">	
	</cfcase>
	<cfcase value="emptypopup_upd_offer">
		<cfinclude template="query/upd_offer.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_offer_pp">
		<cfinclude template="query/upd_offer_pp.cfm">
	</cfcase>
	<cfcase value="emptypopup_del_offer">
		<cfinclude template="query/del_offer.cfm">
	</cfcase>
	<cfcase value="emptypopup_del_offer_row">
		<cfinclude template="query/del_offer_row.cfm">
	</cfcase>
	<cfcase value="popup_dsp_offer_plus">
		<cfinclude template="sale/dsp_offer_plus.cfm">
	</cfcase>
	<cfcase value="popup_form_add_offer_plus">
		<cfinclude template="sale/add_offer_plus.cfm">
	</cfcase>
	<cfcase value="popup_add_offer_plus">
		<cfinclude template="query/add_offer_plus.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_order_purchase">
		<cfinclude template="query/upd_order_purchase.cfm">	
	</cfcase>
	<cfcase value="popup_iframe_list_basket">
		<cfinclude template="sale/mini_basket_ww.cfm">	
	</cfcase>
	<cfcase value="popup_iframe_list_basket_camp">
		<cfinclude template="sale/mini_basket_ww_camp.cfm">	
	</cfcase>	
	<cfcase value="popup_iframe_form_basket">
		<cfinclude template="sale/iframe_form_basket.cfm">	
	</cfcase>	
	<cfcase value="popup_iframe_puan_basket">
		<cfinclude template="sale/iframe_puan_basket.cfm">	
	</cfcase>	
	<cfcase value="emptypopup_ajax_upd_order_demand">
		<cfinclude template="query/upd_order_demand_status.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_opportunity">
		<cfinclude template="query/add_opportunity.cfm">	
	</cfcase>
	<cfcase value="emptypopup_upd_opportunity">
		<cfinclude template="query/upd_opportunity.cfm">
	</cfcase>
	<cfcase value="emptypopup_del_opportunity">
		<cfinclude template="query/del_opp.cfm">
	</cfcase>
	<cfcase value="emptypopup_list_opportunity_plus">
		<cfinclude template="sale/list_opportunity_plus.cfm">
	</cfcase>
	<cfcase value="popup_add_opp_plus">
		<cfinclude template="sale/add_opp_plus.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_opp_plus">
		<cfinclude template="query/add_opp_plus.cfm">
	</cfcase>
	<cfcase value="popup_add_order_demand">
		<cfinclude template="form/add_order_demand.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_order_demand">
		<cfinclude template="query/add_order_demand.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_order_status">
		<cfinclude template="query/upd_order_status.cfm">
	</cfcase>
        
    <!--- security --->
	<cfcase value="emptypopup_ban">
		<cfinclude template="../ban.cfm">
	</cfcase>
	<cfcase value="attacked">
		<cfinclude template="../attacked.cfm">
	</cfcase>	


	<!--- service --->
	<cfcase value="list_service_hierarchy">
		<cfinclude template="display/dynamic_page.cfm">			
	</cfcase>
	<cfcase value="list_incoming_services">
		<cfinclude template="display/dynamic_page.cfm">			
	</cfcase>
	<cfcase value="list_service">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="upd_service">
		<cfinclude template="display/dynamic_page.cfm">			
	</cfcase>
	<cfcase value="serial_no">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="serial_noww">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="add_service">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="add_service_party">
		<cfinclude template="display/dynamic_page.cfm">			
	</cfcase>
	<cfcase value="list_return">
		<cfinclude template="display/dynamic_page.cfm">			
	</cfcase>
	<cfcase value="add_return">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="upd_return">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_service">
		<cfinclude template="service/query/upd_service.cfm">			
	</cfcase>
	<cfcase value="popup_list_subscriptions">
		<cfinclude template="service/display/list_subscriptions_popup.cfm">			
	</cfcase>
	<cfcase value="popup_service_application_print_form">
		<cfinclude template="service/display/service_application_print_form.cfm">
	</cfcase>
	<cfcase value="add_service_act">
		<cfinclude template="service/query/add_service.cfm">			
	</cfcase>
	<cfcase value="emptypopup_add_system_service">
		<cfinclude template="service/query/add_system_service.cfm">			
	</cfcase>
	<cfcase value="emptypopup_upd_system_service">
		<cfinclude template="service/query/upd_system_service.cfm">
	</cfcase>
	<cfcase value="add_service_act_party">
		<cfinclude template="service/query/add_service_party.cfm">			
	</cfcase>
	<cfcase value="popup_add_service_plus">
		<cfinclude template="service/form/add_service_plus.cfm">
	</cfcase>
	<cfcase value="popup_upd_service_plus">
		<cfinclude template="service/form/upd_service_plus.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_service_plus">
		<cfinclude template="service/query/add_service_plus.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_service_plus">
		<cfinclude template="service/query/upd_service_plus.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_return">
		<cfinclude template="service/query/add_return.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_return">
		<cfinclude template="service/query/upd_return.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_service_call_center">
		<cfinclude template="service/query/upd_service_call_center.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_service_call">
		<cfinclude template="query/add_service_call.cfm">
	</cfcase>

	
    	<!--- settings --->
	<cfcase value="popup_dsp_county">
		<cfinclude template="display/dsp_county.cfm">
	</cfcase>
	<cfcase value="popup_calender">
		<cfinclude template="form/list_calender.cfm">
	</cfcase> 
	<cfcase value="popup_cargo_information">
		<cfinclude template="display/dsp_cargo_information.cfm">
	</cfcase>     
	<cfcase value="popup_online_information">
		<cfinclude template="login/online_information.cfm">
	</cfcase>
	<cfcase value="popup_dsp_city">
		<cfinclude template="display/dsp_city.cfm">
	</cfcase>
	<cfcase value="dsp_contact">
		<cfinclude template="display/dynamic_page.cfm">			
	</cfcase>

    
	<cfcase value="add_info_plus_act"> 
		<cfinclude template="query/add_info_plus.cfm">	
	</cfcase>
	<cfcase value="upd_info_plus_act"> 
		<cfinclude template="query/upd_info_plus.cfm">	
	</cfcase>

	<!---//sistem + my_cube --->
	<cfcase value="popup_content_webmail"> 
		<cfinclude template="content/content_webmail.cfm">	
	</cfcase>
	<cfcase value="emptypopup_add_content_webmail"> 
		<cfinclude template="query/add_content_webmail.cfm">	
	</cfcase>
	<!--- maillist kaydi icin --->
	<cfcase value="emptypopup_add_maillist"> 
		<cfinclude template="query/add_maillist.cfm">	
	</cfcase>
	<cfcase value="emptypopup_temp_detail_content"> 
		<cfinclude template="content/temp_detail_content.cfm">	
	</cfcase>
	<cfcase value="emptypopup_get_url"> 
		<cfinclude template="display/get_url.cfm">	
	</cfcase>

	<!--- kategory sayfaları --->
	<cfcase value="emptypopup_get_property">
		<cfinclude template="query/get_property_ajax.cfm" />
	</cfcase>
	<cfcase value="emptypopup_get_altcategory">
		<cfinclude template="query/get_altcategory_ajax.cfm" />
	</cfcase>
	<cfcase value="emptypopup_get_altgroups">
		<cfinclude template="query/get_altgroups_ajax.cfm" />
	</cfcase>
	<cfcase value="emptypopup_get_altbrands">
		<cfinclude template="query/get_altbrands_ajax.cfm" />
	</cfcase>
	<cfcase value="search_helpdesk">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_view_help">
		<cfinclude template="display/view_help.cfm">
	</cfcase>
	<cfcase value="emptypopup_control_control_captcha">
		<cfinclude template="query/control_control_captcha.cfm">
	</cfcase>
	<cfcase value="add_project_info">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="add_info_plus_project_act">
		<cfinclude template="query/add_info_plus_project_act.cfm">
	</cfcase>
	<cfcase value="list_service_call_center">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="list_packetship">
		<cfinclude template="display/dynamic_page.cfm"><!---uyenin sevkiyatlari --->
	</cfcase>
	<cfcase value="list_old_packetship">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="dsp_packetship">
		<cfinclude template="display/dynamic_page.cfm"><!---sevkiyat detay --->
	</cfcase>
	<cfcase value="popup_detail_ship">
		<cfinclude template="display/detail_ship.cfm"><!---irsaliye popup --->
	</cfcase>
	<cfcase value="list_opportunities_hier">
		<cfinclude template="display/dynamic_page.cfm"><!---uyelerimin fırsatları --->
	</cfcase>
	<cfcase value="list_subscription_hier">
		<cfinclude template="display/dynamic_page.cfm"><!---üyelerimin sistemleri --->
	</cfcase>
	<cfcase value="workcube_configurator">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_work_conf_query_page">
		<cfinclude template="product/work_conf_query_page.cfm">
	</cfcase>
	<!--- hızlı siparis kaydı --->
	<cfcase value="basket_expres">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_basket_row_expres">
		<cfinclude template="query/add_basket_row_expres.cfm">  
	</cfcase>
	<cfcase value="emptypopup_ajax_add_row_from_excel">
		<cfinclude template="query/add_basket_express_row_excel.cfm">  
	</cfcase>
	<cfcase value="emptypopup_ajax_add_reserved_stock">
		<cfinclude template="../objects/functions/add_reserved_stock.cfm">
	</cfcase>
	<cfcase value="emptypopup_ajax_add_basket_prom_row">
		<cfinclude template="query/add_basket_prom_row.cfm">
	</cfcase>
	<cfcase value="emptypopup_ajax_upd_cons_session">
		<cfinclude template="query/upd_basket_row_express_cons.cfm">
	</cfcase>
	<!--- Referans olduğum üyeler --->
	<cfcase value="my_ref_member">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_list_campaigns">
		<cfinclude template="campaign/display/popup_list_campaigns.cfm">
	</cfcase>
	<cfcase value="popup_list_positions">
		<cfinclude template="display/list_positions_popup.cfm">
	</cfcase>
	<cfcase value="popup_list_products">
		<cfinclude template="display/list_products_popup.cfm">
	</cfcase>
	<cfcase value="popupajax_my_consumer_ref_member">
		<cfinclude template="member/my_ref_member.cfm">
	</cfcase>
	<cfcase value="user_friendly">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="list_service_partners">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_information_workgroup">
		<cfinclude template="query/add_information_workgroup.cfm">  
	</cfcase>
	<!--- company_detay sayfasında açilan ajaxlar --->
	<cfcase value="popupajax_my_company_helps">
		<cfinclude template="member/my_company_helps.cfm">
	</cfcase>
	<cfcase value="popupajax_my_company_events">
		<cfinclude template="member/my_company_events.cfm">
	</cfcase>
	<cfcase value="popupajax_my_company_opportunities">
		<cfinclude template="member/my_company_opportunities.cfm">
	</cfcase>
	<cfcase value="popupajax_my_company_analyse">
		<cfinclude template="member/my_company_analyse.cfm">
	</cfcase>
	<cfcase value="emptypopup_sale_basket_rows,popupajax_sale_basket_rows">
		<cfinclude template="form/sale_basket_rows.cfm">
	</cfcase>
	<cfcase value="emptypopup_sale_basket_rows_camp,popupajax_sale_basket_rows_camp">
		<cfinclude template="form/sale_basket_rows_camp.cfm">
	</cfcase>
	<!--- uyenin kredi kartları --->
	<cfcase value="list_member_credit_card">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_list_member_credit_card">
		<cfinclude template="member/member_credit_card.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_member_credit_card">
		<cfinclude template="query/add_member_credit_card.cfm">
	</cfcase>
	<cfcase value="emptypopup_dsp_credit_card">
		<cfinclude template="../bank/form/dsp_cc_number.cfm">
	</cfcase>
	<!--- uyenin kredi kartları --->

	<cfcase value="list_partner_serials">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="add_partner_serials">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_session">
		<cfinclude template="../objects/display/list_session_var.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_partner_serials">
		<cfinclude template="service/query/add_partner_serials.cfm">
	</cfcase>

	

	
	<cfcase value="popup_add_bank_account">
		<cfinclude template="../objects/display/form_add_bank_account.cfm">
	</cfcase>	
	<cfcase value="emptypopup_add_bank_account">
		<cfinclude template="../objects/query/add_bank_account.cfm">
	</cfcase>
	<cfcase value="popup_form_upd_bank_account">
		<cfinclude template="../objects/display/form_upd_bank_account.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_bank_account">
		<cfinclude template="../objects/query/upd_bank_account.cfm">
	</cfcase>
	<cfcase value="del_bank_account">
		<cfinclude template="../objects/query/del_bank_account.cfm">
	</cfcase>
    <cfcase value="emptypopup_member_address">
		<cfinclude template="query/member_address_ajax.cfm">
	</cfcase>
    <cfcase value="popup_wrk_list_comp">
		<cfinclude template="../objects/display/wrk_list_page.cfm">
	</cfcase>
    

	<cfcase value="reference_detail">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="help_search_result">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="emptypopup_get_basket_expres_stock">
		<cfinclude template="query/get_basket_expres_stock.cfm">
	</cfcase>
	<!--- sanal pos popup --->
	<cfcase value="emptypopup_get_accounts_list_ajax">
		<cfinclude template="finance/query/get_accounts_list_ajax.cfm">
	</cfcase>
	<!--- siparis sonlandir --->
	<cfcase value="emptypopup_get_credit_accounts_list_ajax">
		<cfinclude template="form/get_credit_accounts_list_ajax.cfm">
	</cfcase>
	<cfcase value="emptypopup_verify_tc_identyno">
		<cfinclude template="../objects/query/verify_tc_identyno.cfm">
	</cfcase>
	<cfcase value="emptypopup_spect_stock_detail">
		<cfinclude template="display/list_detail_stock_spect.cfm">
	</cfcase>
	<cfcase value="list_my_ref_order_demands">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popupajax_list_departments">
		<cfinclude template="../objects/display/list_positions_multiuser.cfm">
	</cfcase>
	<cfcase value="popup_list_positions_multiuser">
		<cfinclude template="display/list_positions_multiuser_popup.cfm">
	</cfcase>
	<cfcase value="popup_list_pars_multiuser">
		<cfinclude template="display/list_pars_multiuser_popup.cfm">
	</cfcase>
	<cfcase value="popup_list_cons_multiuser">
		<cfinclude template="display/list_cons_multiuser_popup.cfm">
	</cfcase>
	<cfcase value="popup_list_my_pars">
		<cfinclude template="display/list_pars_multiuser_popup.cfm">
	</cfcase>
	<cfcase value="popup_list_my_cons">
		<cfinclude template="display/list_cons_multiuser_popup.cfm">
	</cfcase>
	<cfcase value="popup_com_det">
		<cfinclude template="../objects/display/detail_com.cfm">
	</cfcase>
	<cfcase value="popup_list_brands">
		<cfinclude template="product/list_brand_popup.cfm">
	</cfcase>	
	<cfcase value="popup_3d_control">
		<cfinclude template="finance/display/display_3d_control.cfm">
	</cfcase>
	<cfcase value="emptypopup_form_3d">
		<cfinclude template="finance/form/form_3d.cfm">
	</cfcase>
	<cfcase value="emptypopup_cargo_detail">
		<cfinclude template="display/cargo_detail.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_service_operation">
		<cfinclude template="service/query/upd_service_operation.cfm">
	</cfcase>
	<cfcase value="popup_dsp_serial_number_result">
		<cfinclude template="service/display/serial_no.cfm">
	</cfcase>
	<cfcase value="emptypopup_check_seri_no">
		<cfinclude template="../objects/query/check_seri_no.cfm">
	</cfcase>
	<cfcase value="emptypopup_get_product_with_serial">
		<cfinclude template="../service/query/get_product_with_serial.cfm">
	</cfcase>	
    
	<cfcase value="emptypopup_autocomplete">
		<cfinclude template="display/autocomplete.cfm">
	</cfcase>
	<cfcase value="popup_dsp_app_prerecords">
		<cfinclude template="login/dsp_app_prerecords.cfm">
	</cfcase>
	<cfcase value="mq">
		<cfinclude template="display/dsp_mq1.cfm">			
	</cfcase>
	<cfcase value="emptypopup_vote_survey">
		<cfinclude template="query/act_vote_survey.cfm">
	</cfcase>
	<cfcase value="popup_vote_results">
		<cfinclude template="query/get_survey2.cfm">	
		<cfinclude template="query/get_survey_alts.cfm">	
		<cfinclude template="survey/vote_results.cfm">
	</cfcase>



	<cfcase value="emptypopup_pd_edit">
		<cfinclude template="../objects/display/pd_edit.cfm">
	</cfcase>
	<cfcase value="popup_add_table_toeditor">
		<cfinclude template="../objects/display/popup_add_table_toeditor.cfm">		
	</cfcase>
	<cfcase value="emptypopup_get_js_query">
		<cfinclude template="../objects/query/get_js_query.cfm">
	</cfcase>
	<cfcase value="emptypopup_get_js_query2">
		<cfinclude template="../objects/query/get_js_query2.cfm">
	</cfcase>
	<cfcase value="emptypopup_get_workdata">
		<cfinclude template="../objects/query/get_workdata.cfm">
	</cfcase>
	<cfcase value="emptypopup_get_workdata_agenda">
		<cfinclude template="../objects/query/get_workdata_agenda.cfm">
	</cfcase>
	<cfcase value="ajax_notes">
		<cfinclude template="../objects/display/ajax_notes.cfm">		
	</cfcase>	
	<!--- kariyer --->

	<cfcase value="wp_change_pass">
		<cfinclude template="login/change_cons_pass.cfm">	
	</cfcase>
	<cfcase value="popup_dsp_cv_print">
		<cfinclude template="career/display/dsp_cv_print.cfm">	
	</cfcase>
	<cfcase value="popup_online_help">
		<cfinclude template="service/display/help_search.cfm">
	</cfcase>
	<cfcase value="popup_workcube_userguide">
		<cfinclude template="service/display/dsp_workcube_userguide.cfm">			
	</cfcase>
	<cfcase value="popup_search_detail">
		<cfinclude template="service/display/search_detail.cfm">
	</cfcase>
	<cfcase value="list_securefund">
		<cfinclude template="display/dynamic_page.cfm">		
	</cfcase>

	<cfcase value="popup_add_basket_row_from_barcod">
		<cfinclude template="form/add_basket_row_from_barcod.cfm">
	</cfcase>
	<cfcase value="sector">
		<cfinclude template="display/dynamic_page.cfm">	
	</cfcase>	
	<cfcase value="support">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="popup_download_file">
		<cfinclude template="display/download_file.cfm">
	</cfcase>
	<cfcase value="product_xml_files">
		<cfinclude template="product/product_xml_files.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_product_xml">
		<cfinclude template="query/add_product_xml.cfm">
	</cfcase>
	<cfcase value="list_production_orders">
		<cfinclude template="display/dynamic_page.cfm">
	</cfcase>
	<cfcase value="form_add_prod_order_result">
		<cfinclude template="product/add_prod_order_result.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_prod_order_result">
		<cfinclude template="query/add_prod_order_result.cfm">
	</cfcase>
	<cfcase value="form_upd_prod_order_result">
		<cfinclude template="product/upd_prod_order_result.cfm">
	</cfcase>
	<cfcase value="emptypopup_upd_prod_order_result">
		<cfinclude template="query/upd_prod_order_result.cfm">
	</cfcase>
	<cfcase value="detail_prod_order">
		<cfinclude template="product/dsp_prod_order.cfm">
	</cfcase>
	<cfcase value="popup_add_upper_serial_operations">
		<cfinclude template="../objects/form/add_upper_serial_operations.cfm">
	</cfcase>
	<cfcase value="popup_upd_stock_serialno">
		<cfinclude template="../objects/form/upd_stock_serial_no.cfm">
	</cfcase>
	<cfcase value="emptypopup_get_serial_info2">
		<cfinclude template="../objects/query/get_serial_info2.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_stock_serialno">
		<cfinclude template="../objects/query/add_stock_serial_no.cfm">
	</cfcase>
	<cfcase value="emptypopup_del_serial_info">
		<cfinclude template="../objects/query/del_serial_info.cfm">
	</cfcase>
	<cfcase value="upd_stock_serialno">
		<cfinclude template="../objects/query/upd_stock_serialno.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_serial_operations_action">
		<cfinclude template="../objects/query/add_serial_operations_action.cfm">
	</cfcase>
	<cfcase value="emptypopup_add_serial_action_detail">
		<cfinclude template="../objects/query/serial_no_detail.cfm">
	</cfcase>
	<cfcase value="popup_save_asset_file">
		<cfinclude template="../objects/form/popup_save_asset_file.cfm">
	</cfcase>
	<!--- get_workcube_note --->	
	<cfdefaultcase>
		<cfset hata="5">
		<cfinclude template="../dsp_hata.cfm">
	</cfdefaultcase>
</cfswitch>