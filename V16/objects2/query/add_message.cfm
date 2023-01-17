<!--- /// Kisilere Mesaj Atma /// --->
<cfif ( isDefined('attributes.user_emp') and len(attributes.user_emp)) or (isDefined('attributes.user_par') and len(attributes.user_par)) or (isDefined('attributes.user_con') and len(attributes.user_con))>
	<cfif isDefined('attributes.user_emp') and len(attributes.user_emp)>
		<cfquery name="ADD_MESSAGES" datasource="#dsn#">
			INSERT INTO WRK_MESSAGE
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
				#form.user_emp#,
				0,
				<cfif isdefined("session.pp.userid")>
                #session.pp.userid#,
				1,
                <cfelseif isdefined("session.ww.userid")>
                #session.ww.userid#,
				2,
                </cfif>
				'#FORM.MESSAGE#',
				<cfif isdefined("attributes.is_chat")>1,<cfelse>0,</cfif>
				<cfif isdefined("attributes.is_chat") and len(attributes.room_id)>#attributes.room_id#,<cfelse>NULL,</cfif>
				#NOW()#
				)
		</cfquery>
	</cfif>
	<cfif isDefined('attributes.user_par') and len(attributes.user_par)>
		<cfquery name="ADD_MESSAGES" datasource="#dsn#">
			INSERT INTO WRK_MESSAGE
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
				#form.user_par#,
				1,
				<cfif isdefined("session.pp.userid")>
                #session.pp.userid#,
				1,
                <cfelseif isdefined("session.ww.userid")>
                #session.ww.userid#,
				2,
                </cfif>
				'#FORM.MESSAGE#',
				<cfif isdefined("attributes.is_chat")>1,<cfelse>0,</cfif>
				<cfif isdefined("attributes.is_chat") and len(attributes.room_id)>#attributes.room_id#,<cfelse>NULL,</cfif>
				#NOW()#
				)
		</cfquery>
	</cfif>
	<cfif isDefined('attributes.user_con') and len(attributes.user_con)>
		<cfquery name="ADD_MESSAGES" datasource="#dsn#">
			INSERT INTO WRK_MESSAGE
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
				#form.user_con#,
				2,
				<cfif isdefined("session.pp.userid")>
                #session.pp.userid#,
				1,
                <cfelseif isdefined("session.ww.userid")>
                #session.ww.userid#,
				2,
                </cfif>
				'#FORM.MESSAGE#',
				<cfif isdefined("attributes.is_chat")>1,<cfelse>0,</cfif>
				<cfif isdefined("attributes.is_chat") and len(attributes.room_id)>#attributes.room_id#,<cfelse>NULL,</cfif>
				#NOW()#
				)
		</cfquery>
	</cfif>
</cfif>
<!--- /// Kisilere Mesaj Atma Bitti /// --->
<script type="text/javascript">
	window.close();
</script>
<cfabort>
