<!--- /// Gruplara Mesaj Atma /// --->
<cfset attributes.message = replace(attributes.message,'&','','all')>
<cfset attributes.message = replace(attributes.message,';;',';','all')>

<cfif isDefined('form.all_ep')>
	<!--- tum calisanlar --->
	<cfquery name="GET_WRK_EP_APPS" datasource="#DSN#">
		SELECT USERID FROM WRK_SESSION WHERE USER_TYPE = 0
	</cfquery>
	<cfloop query="get_wrk_ep_apps">
	<cfset user_id_ = USERID>
		<cfquery name="ADD_MESSAGES" datasource="#DSN#">
			INSERT INTO 
				WRK_MESSAGE
			(
				RECEIVER_ID,
				RECEIVER_TYPE,
				SENDER_ID,
				SENDER_TYPE,
				MESSAGE,
				IS_CHAT,
				ROOM_ID,
				SEND_DATE
			)
			VALUES
			(
				#userid#,
				0,
				#session.ep.userid#,
				0,
				'#form.message#',
				<cfif isdefined("attributes.is_chat")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_chat") and len(attributes.room_id)>#attributes.room_id#<cfelse>NULL</cfif>,
				#now()#
			)
		</cfquery>
		<cfif isdefined("application.emp_message_list")>
			<cfif not listfindnocase(application.emp_message_list,user_id_)>
				<cfset application.emp_message_list = listappend(application.emp_message_list,user_id_)>
			</cfif>
		<cfelse>
			<cfset application.emp_message_list = user_id_>
		</cfif>
	</cfloop>
</cfif>

<cfif isDefined('form.all_pp')>
	<!--- Calisan Tum Partnerler --->
	<cfquery name="get_wrk_ep_apps" datasource="#DSN#">
		SELECT USERID FROM WRK_SESSION WHERE USER_TYPE = 1
	</cfquery>
	<cfloop query="get_wrk_ep_apps">
	<cfset user_id_ = USERID>
    <cfquery name="ADD_MESSAGES" datasource="#DSN#">
			INSERT INTO 
				WRK_MESSAGE
			(
				RECEIVER_ID,
				RECEIVER_TYPE,
				SENDER_ID,
				SENDER_TYPE,
				MESSAGE,
				IS_CHAT,
				ROOM_ID,
				SEND_DATE
			)
			VALUES
			(
				#userid#,
				1,
				#session.ep.userid#,
				0,
				'#form.message#',
				<cfif isdefined("attributes.is_chat")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_chat") and len(attributes.room_id)>#attributes.room_id#<cfelse>NULL</cfif>,
				#now()#
			)
		</cfquery>
		<cfif isdefined("application.emp_message_list")>
			<cfif not listfindnocase(application.par_message_list,user_id_)>
				<cfset application.par_message_list = listappend(application.par_message_list,user_id_)>
			</cfif>
		<cfelse>
			<cfset application.par_message_list = user_id_>
		</cfif>
	</cfloop>
</cfif>

<cfif isDefined('form.all_ww')>
	<!--- Calisan Tum web kullanicilarina --->
	<cfquery name="get_wrk_ep_apps" datasource="#DSN#">
		SELECT USERID FROM WRK_SESSION WHERE USER_TYPE = 2
	</cfquery>
	<cfloop query="get_wrk_ep_apps">
		<cfquery name="ADD_MESSAGES" datasource="#DSN#">
			INSERT INTO 
				WRK_MESSAGE
			(
				RECEIVER_ID,
				RECEIVER_TYPE,
				SENDER_ID,
				SENDER_TYPE,
				MESSAGE,
				IS_CHAT,
				ROOM_ID,
				SEND_DATE
			)
			VALUES
			(
				#userid#,
				2,
				#session.ep.userid#,
				0,
				'#form.message#',
				<cfif isdefined("attributes.is_chat")>1<cfelse>0</cfif>,
				<cfif isdefined("attributes.is_chat") and len(attributes.room_id)>#attributes.room_id#<cfelse>NULL</cfif>,
				#now()#
			)
		</cfquery>
		<cfif isdefined("application.cons_message_list")>
			<cfif not listfindnocase(application.cons_message_list,USERID)>
				<cfset application.cons_message_list = listappend(application.cons_message_list,userid)>
			</cfif>
		<cfelse>
			<cfset application.cons_message_list = userid>
		</cfif>
	</cfloop>
</cfif>
<!--- /// Gruplara Mesaj Atma Bitti /// --->


<!--- /// Kisilere Mesaj Atma /// --->
	<cfif isDefined('attributes.user_emp') and listlen(attributes.user_emp)>
		<!--- calisan calisana mesaj atiyor --->
		<cfloop list="#attributes.user_emp#" index="mmk">
			<cfquery name="ADD_MESSAGES" datasource="#DSN#">
				INSERT INTO
					WRK_MESSAGE
				(
					RECEIVER_ID,
					RECEIVER_TYPE,
					SENDER_ID,
					SENDER_TYPE,
					MESSAGE,
					IS_CHAT,
					ROOM_ID,
					SEND_DATE
				)
				VALUES
				(
					#mmk#,
					0,
					#session.ep.userid#,
					0,
					'#form.message#',
					<cfif isdefined("attributes.is_chat")>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.is_chat") and len(attributes.room_id)>#attributes.room_id#<cfelse>NULL</cfif>,
					#now()#
				)
			</cfquery>
			<cfif isdefined("application.emp_message_list") and listlen(application.emp_message_list)>
				<cfif not listfindnocase(application.emp_message_list,mmk)>
					<cfset application.emp_message_list = listappend(application.emp_message_list,mmk)>
				</cfif>
			<cfelse>
				<cfset application.emp_message_list = mmk>
			</cfif>
		</cfloop>
	</cfif>

	<cfif isDefined('attributes.user_par') and listlen(attributes.user_par)>
		<!--- calisan partnere mesaj atiyor --->
		<cfloop list="#attributes.user_par#" index="mmk">
			<cfquery name="ADD_MESSAGES" datasource="#DSN#">
				INSERT INTO 
					WRK_MESSAGE
				(
					RECEIVER_ID,
					RECEIVER_TYPE,
					SENDER_ID,
					SENDER_TYPE,
					MESSAGE,
					IS_CHAT,
					ROOM_ID,
					SEND_DATE
				)
				VALUES
				(
					#mmk#,
					1,
					#session.ep.userid#,
					0,
					'#form.message#',
					<cfif isdefined("attributes.is_chat")>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.is_chat") and len(attributes.room_id)>#attributes.room_id#<cfelse>NULL</cfif>,
					#now()#
				)
			</cfquery>
			<cfif isdefined("application.par_message_list")>
				<cfif not listfindnocase(application.par_message_list,mmk)>
					<cfset application.par_message_list = listappend(application.par_message_list,mmk)>
				</cfif>
			<cfelse>
				<cfset application.par_message_list = mmk>
			</cfif>
		</cfloop>
	</cfif>
	

	<cfif isDefined('attributes.user_con') and listlen(attributes.user_con)>
		<!--- calisan web kullanıcisina mesaj atiyor --->
		<cfloop list="#attributes.user_con#" index="mmk">
			<cfquery name="ADD_MESSAGES" datasource="#DSN#">
				INSERT INTO 
					WRK_MESSAGE
				(
					RECEIVER_ID,
					RECEIVER_TYPE,
					SENDER_ID,
					SENDER_TYPE,
					MESSAGE,
					IS_CHAT,
					ROOM_ID,
					SEND_DATE
				)
				VALUES
				(
					#mmk#,
					2,
					#session.ep.userid#,
					0,
					'#form.message#',
					<cfif isdefined("attributes.is_chat")>1<cfelse>0</cfif>,
					<cfif isdefined("attributes.is_chat") and len(attributes.room_id)>#attributes.room_id#<cfelse>NULL</cfif>,
					#now()#
				)
			</cfquery>
			<cfif isdefined("application.cons_message_list")>
				<cfif not listfindnocase(application.cons_message_list,mmk)>
					<cfset application.cons_message_list = listappend(application.cons_message_list,mmk)>
				</cfif>
			<cfelse>
				<cfset application.cons_message_list = mmk>
			</cfif>
		</cfloop>
	</cfif>
<script type="text/javascript">
	window.close();
</script>
<cfabort>
