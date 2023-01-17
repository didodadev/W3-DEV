<cfset consumerIdList = ListSort(attributes.consumer_ids,"numeric","ASC",",")>
<cfset partnerIdList = ListSort(attributes.partner_ids,"numeric","ASC",",")>
<cftransaction>
    <cfloop from="1" to="#listlen(partnerIdList, ',')#" index="i"><!---partners recording--->
        <cfquery name="get_partner" datasource="#dsn#">
            SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME,COMPANY_PARTNER_EMAIL,COMPANY_ID FROM COMPANY_PARTNER WHERE PARTNER_ID = #listgetat(partnerIdList,i,',')#
        </cfquery>
        <cfquery name="add_interaction" datasource="#dsn#">
            INSERT INTO
                    CUSTOMER_HELP
                (
					PARTNER_ID,
					COMPANY_ID,					
					APP_CAT,
					INTERACTION_CAT,
					INTERACTION_DATE,
					SUBJECT,
					PROCESS_STAGE,
					DETAIL,
					APPLICANT_NAME,
					APPLICANT_MAIL,
					IS_REPLY_MAIL,
					IS_REPLY,	
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
					#listgetat(partnerIdList, i, ',')#,
                    #get_partner.COMPANY_ID#,
					#attributes.app_cat#,
					#attributes.interaction_cat#,
					#CreateOdbcDate(now())#,
					'#attributes.interaction_detail#',
					#attributes.interaction_process#,
					'#attributes.interaction_detail#',
					'#get_partner.COMPANY_PARTNER_NAME# #get_partner.COMPANY_PARTNER_SURNAME#',
                    '#get_partner.COMPANY_PARTNER_EMAIL#',
					1,
					0,
					#session.ep.userid#,
					#now()#,
					'#cgi.remote_addr#'
				)
        </cfquery>
    </cfloop>
    <cfloop from="1" to="#listlen(consumerIdList, ',')#" index="j"><!---consumers recording--->
        <cfquery name="get_consumer" datasource="#dsn#">
            SELECT CONSUMER_NAME,CONSUMER_SURNAME,CONSUMER_EMAIL,CONSUMER_ID FROM CONSUMER WHERE CONSUMER_ID = #listgetat(consumerIdList, j, ',')#
        </cfquery>
        <cfquery name="add_interaction" datasource="#dsn#">
            INSERT INTO
                    CUSTOMER_HELP
                (
					PARTNER_ID,
					COMPANY_ID,
					CONSUMER_ID,
					APP_CAT,
					INTERACTION_CAT,
					INTERACTION_DATE,
					SUBJECT,
					PROCESS_STAGE,
					DETAIL,
					APPLICANT_NAME,
					APPLICANT_MAIL,
					IS_REPLY_MAIL,
					IS_REPLY,	
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP
				)
				VALUES
				(
					NULL,
					NULL,
					#listgetat(consumerIdList,j,',')#,
					#attributes.app_cat#,
					#attributes.interaction_cat#,
					#CreateOdbcDate(now())#,
					'#attributes.interaction_detail#',
					#attributes.interaction_process#,
					'#attributes.interaction_detail#',
					'#get_consumer.CONSUMER_NAME# #get_consumer.CONSUMER_SURNAME#',
                    '#get_consumer.CONSUMER_EMAIL#',
					1,
					0,
					#session.ep.userid#,
					#now()#,
					'#cgi.remote_addr#'
				)
        </cfquery>
    </cfloop>
</cftransaction>
<script type="text/javascript">
	window.location.href="<cfoutput>#request.self#?fuseaction=campaign.list_campaign_target&camp_id=#attributes.camp_id#</cfoutput>";
</script>

