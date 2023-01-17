<cfsetting showdebugoutput="no">
<cfset intranet = createObject('component','cfc.intranet')>
<cfset lastReplys = intranet.lastReplys()>
<cfquery name="get_forum" datasource="#dsn#" maxrows="5">
	SELECT
		FORUMID,
		FORUMNAME,
		REPLY_COUNT,
		TOPIC_COUNT,
		LAST_MSG_USERKEY,
		LAST_MSG_DATE
	FROM
		FORUM_MAIN
	WHERE
		FORUM_EMPS = 1 OR
		ADMIN_POS LIKE '%,#session.ep.position_code#,%'
	ORDER BY
		LAST_MSG_DATE DESC
</cfquery>
	<cfif get_forum.recordcount>		
			<cfset user_id = "">
			<cfset user_emp_list = "">
			<cfset user_par_list = "">
			<cfset user_con_list = "">
			<cfoutput query="get_forum">
				<cfset user_id = listlast(last_msg_userkey,'-')>
				<cfif len(last_msg_userkey) and (last_msg_userkey contains "e") and not listfind(user_emp_list,user_id)>
					<cfset user_emp_list=listappend(user_emp_list,user_id)>
				</cfif>
				<cfif len(last_msg_userkey) and (last_msg_userkey contains "p") and not listfind(user_par_list,user_id)>
					<cfset user_par_list=listappend(user_par_list,user_id)>
				</cfif>
				<cfif len(last_msg_userkey) and (last_msg_userkey contains "c") and not listfind(user_con_list,user_id)>
					<cfset user_con_list=listappend(user_con_list,user_id)>
				</cfif>
			</cfoutput>
			<cfif len(user_emp_list)>
				<cfset user_emp_list = listsort(user_emp_list,"numeric","ASC",',')>
				<cfquery name="get_emp_username" datasource="#dsn#">
					SELECT
					<cfif (database_type is 'MSSQL')>
						EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME NAME_SURNAME,
					<cfelseif (database_type is 'DB2')>
						EMPLOYEE_NAME || ' ' || EMPLOYEE_SURNAME NAME_SURNAME,
					</cfif>
						EMPLOYEE_ID
					FROM
						EMPLOYEES
					WHERE
						EMPLOYEE_ID IN (#user_emp_list#)
					ORDER BY
						EMPLOYEE_ID
				</cfquery>
				<cfset user_emp_list = listsort(listdeleteduplicates(valuelist(get_emp_username.employee_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(user_par_list)>
				<cfset user_par_list = listsort(user_par_list,"numeric","ASC",',')>
				<cfquery name="get_par_username" datasource="#dsn#">
					SELECT
					<cfif (database_type is 'MSSQL')>
						COMPANY_PARTNER_NAME + ' ' + COMPANY_PARTNER_SURNAME NAME_SURNAME,
					<cfelseif (database_type is 'DB2')>
						COMPANY_PARTNER_NAME || ' ' || COMPANY_PARTNER_SURNAME NAME_SURNAME,
					</cfif>
						PARTNER_ID
					FROM
						COMPANY_PARTNER
					WHERE
						PARTNER_ID IN (#user_par_list#)
					ORDER BY
						PARTNER_ID
				</cfquery>
				<cfset user_par_list = listsort(listdeleteduplicates(valuelist(get_par_username.partner_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfif len(user_con_list)>
				<cfset user_con_list = listsort(user_con_list,"numeric","ASC",',')>
				<cfquery name="get_con_username" datasource="#dsn#">
					SELECT
					<cfif (database_type is 'MSSQL')>
						CONSUMER_NAME + ' ' + CONSUMER_SURNAME NAME_SURNAME,
					<cfelseif (database_type is 'DB2')>
						CONSUMER_NAME || ' ' || CONSUMER_SURNAME NAME_SURNAME,
					</cfif>
						CONSUMER_ID
					FROM
						CONSUMER
					WHERE
						CONSUMER_ID IN (#user_con_list#)
					ORDER BY
						CONSUMER_ID
				</cfquery>
				<cfset user_con_list = listsort(listdeleteduplicates(valuelist(get_con_username.consumer_id,',')),'numeric','ASC',',')>
			</cfif>
			<cfoutput query="get_forum">
				<cfquery name="get_last_replys" dbtype="query">
					SELECT 						
						REPLY,
						REPLYID
					FROM 
						lastReplys
					WHERE
						FORUMID = #FORUMID#
				</cfquery>		
				<cfset forumNameFirstChar= UCase(left(get_forum.FORUMNAME,1))>		
				<div class="forum_main_item flex-row">
					<div class="forum_main_item_avatar" id="#forumid#">
						<i>#forumNameFirstChar#</i>
					</div>
					<div class="forum_main_item_message">
						<div class="forum_main_item_message_title">
							<a class="general" href="#request.self#?fuseaction=forum.view_topic&forumid=#forumid#">#forumname#</a>
						</div>
						<div class="forum_main_item_message_content">
							<a href="#request.self#?fuseaction=forum.view_topic&forumid=#forumid####get_last_replys.REPLYID#">#LEFT(REReplaceNoCase(get_last_replys.REPLY, "<[^><]*>", '', 'ALL'),150)#...</a>
						</div>
						<div class="forum_main_item_message_info">
							<cfif len(last_msg_date) and len(get_last_replys.REPLY)>														
								<cfset user_id = listlast(last_msg_userkey,'-')>
								<cfif len(user_emp_list) and last_msg_userkey contains "e">
									<a href="#request.self#?fuseaction=rule.list_hr&event=det&emp_id=#get_emp_username.employee_id[listfind(user_emp_list,user_id,',')]#" class="tableyazi" target="_blank">#get_emp_username.name_surname[listfind(user_emp_list,user_id,',')]#</a>
								<cfelseif len(user_par_list) and last_msg_userkey contains "p">
									<a href="#request.self#?fuseaction=rule.list_hr&event=det&par_id=#get_par_username.partner_id[listfind(user_par_list,user_id,',')]#" class="tableyazi" target="_blank">#get_par_username.name_surname[listfind(user_par_list,user_id,',')]#</a>
								<cfelseif len(user_con_list) and last_msg_userkey contains "c">
									<a href="#request.self#?fuseaction=rule.list_hr&event=det&con_id=#get_con_username.consumer_id[listfind(user_con_list,user_id,',')]#" class="tableyazi" target="_blank">#get_con_username.name_surname[listfind(user_con_list,user_id,',')]#</a>
								</cfif>	
								<span>#dateformat(date_add('h',session.ep.time_zone,last_msg_date),dateformat_style)# #timeformat(date_add('h',session.ep.time_zone,last_msg_date),timeformat_style)#</span>									
							</cfif>
							<a class="read_more" href="#request.self#?fuseaction=forum.view_topic&forumid=#FORUMID#"><i class="fa fa-lightbulb-o"></i><cf_get_lang dictionary_id='63112.Fikrini Paylaş'></a>			
						</div>
					</div>		
				</div>				
			</cfoutput>		
	<cfelse>		
		<cf_get_lang dictionary_id='58486.Kayıt Bulunamadı'>!		
	</cfif>

<script>
	$( document ).ready(function() {
		elements = [<cfloop query="get_forum"><cfoutput>"#forumid#"</cfoutput>,</cfloop>];
		for(i=0;i<elements.length;i++){
			var colors = ["#4db6ac","#f6bf26","#e06055","#b39ddb","#009688","#607D8B","#8D6E63","#4fc3f7","#aed581","#FF7043","#1abc9c", "#2ecc71", "#3498db", "#9b59b6", "#34495e", "#16a085", "#27ae60", "#2980b9", "#8e44ad", "#2c3e50", "#f1c40f", "#e67e22", "#e74c3c", "#ecf0f1", "#95a5a6", "#f39c12", "#d35400", "#c0392b", "#bdc3c7", "#7f8c8d"];
			var getRandom = colors[Math.floor(Math.random() * colors.length)];
			document.getElementById(elements[i]).style.backgroundColor= getRandom;
		}
	});
</script>