<cfprocessingdirective suppresswhitespace="Yes">
<cfif listfindnocase(employee_url,'#cgi.http_host#',';')>
	<cfswitch expression = "#fusebox.fuseaction#">
		<cfcase value="welcome">
			<cflocation addtoken="No" url="#request.self#?fuseaction=myhome.welcome">
		</cfcase>
		<!--- Workcube kurulum --->
		<cfcase value="installation">
			<cfinclude template="installation/installation.cfm">
		</cfcase>
		<cfcase value="emptypopup_installation">
			<cfinclude template="installation/add_installation.cfm">
		</cfcase>
		<!--- Workcube kurulum --->
		<cfcase value="login">
			<cfinclude template="dsp_login.cfm">
		</cfcase>
		<cfcase value="logout">
			<cfinclude template="act_logout.cfm">
		</cfcase>
		<cfcase value="act_login">
			<cfinclude template="act_login.cfm">
		</cfcase>	
		<cfcase value="act_ban">
			<cfinclude template="act_ban.cfm">
		</cfcase>	
		<cfcase value="emptypopup_ban">
			<cfinclude template="ban.cfm">
		</cfcase>
		<cfcase value="emptypopup_check_session">
			<cfinclude template="check_session.cfm">
		</cfcase>
		<cfcase value="attacked">
			<cfinclude template="attacked.cfm">
		</cfcase>
		<cfcase value="session_creater">
			<cfinclude template="V16/development/form/session_creater.cfm">
		</cfcase>
		<cfcase value="rs">
			<cf_rs start=1>
			<cflocation addtoken="No" url="#request.self#?fuseaction=home.logout">
		</cfcase>
		<cfcase value="popup_clear_session">
			<cfinclude template="clear_session.cfm">
		</cfcase>
		<cfcase value="emptypopup_clear_session">
			<cfinclude template="clear_session_action.cfm">
		</cfcase>
		<cfcase value="emptypopup_special_functions">
			<cfcontent type="application/x-javascript; charset=utf-8">
			<cfsetting showdebugoutput="no">
			<cfinclude template="JS/special_functions.cfm">
			<cfif fileExists("#index_folder#add_options/JS/special_functions.cfm")>
				<cfinclude template="/V16/add_options/JS/special_functions.cfm">
			</cfif>
		</cfcase>
		<cfcase value="emptypopup_js_functions">
			<cfcontent type="application/x-javascript; charset=utf-8">
			<cfsetting showdebugoutput="no">
			<cfinclude template="JS/ajax.cfm">
			<cfinclude template="JS/js_functions.cfm">
		</cfcase>
		<cfcase value="emptypopup_process_functions">
			<cfcontent type="application/x-javascript; charset=utf-8">
			<cfsetting showdebugoutput="no">
			<cfinclude template="#attributes.get_procees_file#">
		</cfcase>
		<cfcase value="emptypopup_calender_functions">
			<cfcontent type="application/x-javascript; charset=utf-8">
			<cfsetting showdebugoutput="no">
			<cfinclude template="JS/calendar-tr.cfm">
		</cfcase>
		<cfcase value="emptypopup_set_lang_change_action">
			<cfinclude template="V16/objects/query/set_lang_change_action.cfm">
		</cfcase>
		<cfcase value="popup_send_password">
			<cfinclude template="V16/objects2/login/send_password.cfm">
		</cfcase>
		<cfcase value="popup_password_arrangement">
			<cfinclude template="V16/objects2/query/arrange_password.cfm">
		</cfcase>
        <cfcase value="emptypopup_remove_email_from_list">
			<cfinclude template="remove_email_from_list.cfm">
		</cfcase>
		<cfdefaultcase>
			<cfset hata="5">
			<cfinclude template="V16/dsp_hata.cfm">
		</cfdefaultcase>
	</cfswitch>
<cfelseif listfindnocase(partner_url,'#cgi.http_host#',';')>
	<cfswitch expression = "#fusebox.fuseaction#">
		<cfcase value="welcome">
			<cflocation addtoken="No" url="#request.self#?fuseaction=objects2.welcome">
		</cfcase>
		<cfcase value="login">
			<cfinclude template="extranet_login.cfm">
		</cfcase>
		<cfcase value="act_login">
			<cfinclude template="extranet_act_login.cfm">
		</cfcase>
		<cfcase value="logout">
			<cfinclude template="extranet_act_logout.cfm">
		</cfcase>
		<cfcase value="popup_time_out">
			<cfinclude template="dsp_time_out.cfm">
		</cfcase>
		<cfcase value="popup_clear_session">
			<cfinclude template="clear_session.cfm">
		</cfcase>
		<cfcase value="emptypopup_clear_session">
			<cfinclude template="clear_session_action.cfm">
		</cfcase>
		<cfcase value="emptypopup_special_functions">
			<cfcontent type="application/x-javascript; charset=utf-8">
			<cfsetting showdebugoutput="no">
			<cfinclude template="JS/special_functions.cfm">
		</cfcase>
		<cfcase value="emptypopup_js_functions">
			<cfcontent type="application/x-javascript; charset=utf-8">
			<cfsetting showdebugoutput="no">
			<cfinclude template="JS/js_functions.cfm">
		</cfcase>
		<cfcase value="emptypopup_process_functions">
			<cfcontent type="application/x-javascript; charset=utf-8">
			<cfsetting showdebugoutput="no">
			<cfinclude template="#attributes.get_procees_file#">
		</cfcase>
		<cfcase value="ban">
			<cfinclude template="ban.cfm">
		</cfcase>
		<cfcase value="emptypopup_calender_functions">
			<cfcontent type="application/x-javascript; charset=utf-8">
			<cfsetting showdebugoutput="no">
			<cfinclude template="JS/calendar-tr.cfm">
		</cfcase>
		<cfcase value="popup_send_password">
			<cfinclude template="objects2/login/send_password.cfm">
		</cfcase>
		<cfcase value="popup_password_arrangement">
			<cfinclude template="objects2/query/arrange_password.cfm">
		</cfcase>
		<cfcase value="emptypopup_fms_auth_id">
			<cfinclude template="objects2/display/fms_auth_id.cfm">
		</cfcase>
        <cfcase value="emptypopup_tvradio_channel_status">
			<cfinclude template="objects2/display/tvradio_channel_status.cfm">
		</cfcase>
		<cfdefaultcase>
			<cfset hata="5">
			<cfinclude template="dsp_hata.cfm">
		</cfdefaultcase>
	</cfswitch>
<cfelseif listfindnocase(server_url,'#cgi.http_host#',';')>
	<cfswitch expression = "#fusebox.fuseaction#">
		<cfcase value="welcome">
			<cflocation addtoken="No" url="#request.self#?fuseaction=objects2.welcome">
		</cfcase>
		<cfcase value="act_login">
			<cfinclude template="public_act_login.cfm">
		</cfcase>
		<cfcase value="act_logout,logout">
			<cfinclude template="public_act_logout.cfm">
		</cfcase>
		<cfcase value="popup_time_out">
			<cfinclude template="dsp_time_out.cfm">
		</cfcase>
		<cfcase value="emptypopup_special_functions">
			<cfcontent type="application/x-javascript; charset=utf-8">
			<cfsetting showdebugoutput="no">
			<cfinclude template="JS/special_functions.cfm">
		</cfcase>
		<cfcase value="emptypopup_active_consumer">
			<cfinclude template="active_consumer.cfm">
		</cfcase>
		<cfcase value="emptypopup_vote_survey1">
			<cfinclude template="vote_survey.cfm">
		</cfcase>
		<cfcase value="emptypopup_js_functions">
			<cfcontent type="application/x-javascript; charset=utf-8">
			<cfsetting showdebugoutput="no">
			<cfinclude template="JS/ajax.cfm">
			<cfinclude template="JS/js_functions.cfm">
		</cfcase>
		<cfcase value="emptypopup_process_functions">
			<cfcontent type="application/x-javascript; charset=utf-8">
			<cfsetting showdebugoutput="no">
			<cfinclude template="#attributes.get_procees_file#">
		</cfcase>
		<cfcase value="emptypopup_calender_functions">
			<cfcontent type="application/x-javascript; charset=utf-8">
			<cfsetting showdebugoutput="no">
			<cfinclude template="JS/calendar-tr.cfm">
		</cfcase>
		<cfcase value="ban">
			<cfinclude template="ban.cfm">
		</cfcase>
		<cfcase value="popup_send_password">
			<cfinclude template="objects2/login/send_password.cfm">
		</cfcase>
		<cfcase value="popup_password_arrangement">
			<cfinclude template="objects2/query/arrange_password.cfm">
		</cfcase>
		<cfcase value="emptypopup_fms_auth_id">
			<cfinclude template="objects2/display/fms_auth_id.cfm">
		</cfcase>
        <cfcase value="emptypopup_tvradio_channel_status">
			<cfinclude template="objects2/display/tvradio_channel_status.cfm">
		</cfcase>
		<cfdefaultcase>
			<cfinclude template="dsp_hata_public.cfm">
		</cfdefaultcase>
	</cfswitch>
<cfelseif listfindnocase(pda_url,'#cgi.http_host#',';')>
	<cfswitch expression = "#fusebox.fuseaction#">
		<cfcase value="welcome">
			<cflocation addtoken="No" url="#request.self#?fuseaction=pda.welcome">
		</cfcase>
		<cfcase value="login">
			<cfinclude template="pda_login.cfm">
		</cfcase>
		<cfcase value="act_login">
			<cfinclude template="pda_act_login.cfm">
		</cfcase>
		<cfcase value="act_logout,logout">
			<cfinclude template="pda_act_logout.cfm">
		</cfcase>
		<cfcase value="popup_time_out">
			<cfinclude template="dsp_time_out.cfm">
		</cfcase>
		<cfcase value="emptypopup_calendar_functions">
			<cfcontent type="application/x-javascript; charset=utf-8">
			<cfsetting showdebugoutput="no">
			<cfinclude template="JS/pda_calendar.cfm">
			<cfinclude template="JS/pda_calendar-tr.cfm">
			<cfinclude template="JS/pda_calendar-setup.cfm">
		</cfcase>
		<cfcase value="emptypopup_js_functions">
			<cfinclude template="JS/js_functions.cfm">
		</cfcase>
		<cfcase value="emptypopup_calender_functions">
			<cfcontent type="application/x-javascript; charset=utf-8">
			<cfsetting showdebugoutput="no">
			<cfinclude template="JS/calendar-tr.cfm">
		</cfcase>
		<cfdefaultcase>
			<cfinclude template="dsp_hata_pda.cfm">
		</cfdefaultcase>
	</cfswitch>
<cfelseif listfindnocase(career_url,'#cgi.http_host#',';')>
	<cfswitch expression = "#fusebox.fuseaction#">
		<cfcase value="welcome">
			<cflocation addtoken="No" url="#request.self#?fuseaction=career.welcome">
		</cfcase>
		<cfcase value="act_login">
			<cfinclude template="career_act_login.cfm">
		</cfcase>
		<cfcase value="act_logout,logout">
			<cfinclude template="career_act_logout.cfm">
		</cfcase>
		<cfcase value="popup_time_out">
			<cfinclude template="dsp_time_out.cfm">
		</cfcase>
		<cfcase value="emptypopup_special_functions">
			<cfcontent type="application/x-javascript; charset=utf-8">
			<cfsetting showdebugoutput="no">
			<cfinclude template="JS/special_functions.cfm">
		</cfcase>
		<cfcase value="emptypopup_calender_functions">
			<cfcontent type="application/x-javascript; charset=utf-8">
			<cfsetting showdebugoutput="no">
			<cfinclude template="JS/calendar-tr.cfm">
		</cfcase>
		<cfcase value="emptypopup_js_functions">
			<cfinclude template="JS/js_functions.cfm">
		</cfcase>
		<cfcase value="emptypopup_fms_auth_id">
			<cfinclude template="objects2/display/fms_auth_id.cfm">
		</cfcase>
        <cfcase value="emptypopup_tvradio_channel_status">
			<cfinclude template="objects2/display/tvradio_channel_status.cfm">
		</cfcase>
		<cfdefaultcase>
			<cfinclude template="dsp_hata_public.cfm">
		</cfdefaultcase>
	</cfswitch>
<cfelseif listfindnocase(mobile_url,'#cgi.http_host#',';')>
	<cfswitch expression = "#fusebox.fuseaction#">
		<cfcase value="welcome">
			<cflocation addtoken="No" url="#request.self#?fuseaction=mobile.welcome">
		</cfcase>
		<cfcase value="login">
			<cfinclude template="mobile_login.cfm">
		</cfcase>
		<cfcase value="act_login">
			<cfinclude template="mobile_act_login.cfm">
		</cfcase>
		<cfcase value="act_logout,logout">
			<cfinclude template="mobile_act_logout.cfm">
		</cfcase>
		<cfcase value="popup_clear_session">
			<cfinclude template="clear_session.cfm">
		</cfcase>
		<cfcase value="emptypopup_clear_session">
			<cfinclude template="clear_session_action.cfm">
		</cfcase>
		<cfcase value="emptypopup_special_functions">
			<cfcontent type="application/x-javascript; charset=utf-8">
			<cfsetting showdebugoutput="no">
			<cfinclude template="JS/special_functions.cfm">
		</cfcase>
		<cfcase value="emptypopup_calender_functions">
			<cfcontent type="application/x-javascript; charset=utf-8">
			<cfsetting showdebugoutput="no">
			<cfinclude template="JS/calendar-tr.cfm">
		</cfcase>
		<cfcase value="emptypopup_js_functions">
			<cfinclude template="JS/js_functions.cfm">
		</cfcase>
		<cfcase value="emptypopup_fms_auth_id">
			<cfinclude template="objects2/display/fms_auth_id.cfm">
		</cfcase>
        <cfcase value="emptypopup_tvradio_channel_status">
			<cfinclude template="objects2/display/tvradio_channel_status.cfm">
		</cfcase>
		<cfdefaultcase>
			<cfinclude template="dsp_hata_public.cfm">
		</cfdefaultcase>
	</cfswitch>
</cfif>
</cfprocessingdirective>
