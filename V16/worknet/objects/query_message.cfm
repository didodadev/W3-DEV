<cfset cmp = createObject("component","worknet.objects.messages") />
<cfif isdefined('attributes.change_type')>
	<!--- upd message --->
	<cfloop from=1 to="#attributes.rowcount#" index="i">	
		<cfif isdefined("attributes.is_selected_#i#")>
			<cfset getMessage = cmp.getMessage(msg_id : evaluate('attributes.is_selected_#i#')) />
			<cfif getMessage.recordcount>
				<cfif attributes.change_type eq 1>
					<cfset updMessage = cmp.updMessage(
						msg_id : evaluate('attributes.is_selected_#i#'), 
						is_deleted:1)
					/>
				<cfelseif attributes.change_type eq 0>
					<cfset updMessage = cmp.updMessage(
						msg_id : evaluate('attributes.is_selected_#i#'), 
						is_read:0)
					/>
				<cfelseif attributes.change_type eq 2>
					<cfset delMessage = cmp.delMessage(
						msg_id : evaluate('attributes.is_selected_#i#')
						)
					/>
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
    <script language="javascript">
		window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.inbox';
	</script>
<cfelse>
	<!--- add message --->
	<cfset cmp.addMessage(
				message_type : 0,
				sender_id : attributes.sender_id,
				sender_type : attributes.sender_type,
				receiver_id : attributes.receiver_id,
				receiver_type : attributes.receiver_type,
				subject : attributes.subject,
				body : attributes.body,
				action_id : attributes.action_id,
				action_type : attributes.action_type,
				is_read : 0
			) />
			
	<cfset cmp.addMessage(
				message_type : 1,
				sender_id : attributes.sender_id,
				sender_type : attributes.sender_type,
				receiver_id : attributes.receiver_id,
				receiver_type : attributes.receiver_type,
				subject : attributes.subject,
				body : attributes.body,
				action_id : attributes.action_id,
				action_type : attributes.action_type,
				is_read : 1
			) />
            
     <cfset getMailTo = createObject("component","V16.worknet.query.worknet_member").getPartner(partner_id:attributes.receiver_id) />
	 <cfif len(getMailTo.company_partner_email)>
		 <cfsavecontent variable="mail_body">
			<cfoutput>
				<b>#session.pp.company# - #session.pp.name# #session.pp.surname#</b> kullanıcısı size mesaj gönderdi.<br /><br />
				
				#left(attributes.body,100)#...<br /><br />
				
				gelen mesajlarınıza ulaşmak için lütfen <a href="http://#cgi.HTTP_HOST#/inbox" style="color:red;">tıklayınız.</a>
			</cfoutput>
		 </cfsavecontent>
		 <cfset createObject("component","worknet.objects.worknet_objects").getMailTemplate(
					is_status:1,
					subject:'www.styleturkish.com bilgilendirme',
					message:mail_body,
					mail_to:getMailTo.company_partner_email
		 ) />
     </cfif>
     <cfif isdefined('attributes.fuse_type') and attributes.fuse_type eq 1>
		<script language="javascript">
            alert("<cf_get_lang no='180.Mesajınız gönderilmiştir'>");
            window.close();
        </script>
    <cfelse>
        <script language="javascript">
            alert("<cf_get_lang no='180.Mesajınız gönderilmiştir'>");
            window.location.href = '<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.inbox';
        </script>
    </cfif>
</cfif>

