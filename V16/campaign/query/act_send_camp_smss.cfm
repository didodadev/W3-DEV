<!---SMS içerikleri--->
<cfquery name="sms_cont" datasource="#dsn3#">
	SELECT 
    	SMS_CONT_ID, 
        CAMP_ID, 
        SMS_BODY, 
        IS_SENT, 
        SENDED_TARGET_MASS, 
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP
    FROM 
    	CAMPAIGN_SMS_CONT 
    WHERE 
    	SMS_CONT_ID = #attributes.sms_cont_id#
</cfquery>
<cfif isdefined('attributes.send_date') and isdate(attributes.send_date)>
	<cfset attributes.sms_send_date=CreateODBCDateTime(dateformat(send_date,dateformat_style)&" "&send_hour&":"&send_minute&":00")>
</cfif>
<cftransaction>
	<cfif isdefined('attributes.target_mass')>
		<!--- Hedef kitlelerden seçilmiş uyeler --->
		<cfloop from="1" to="#listlen(attributes.target_mass)#" index="gonderim"><!--- Seçili olan gönderim sayısı kadar dön --->
			<cfif (isdefined("cons_sms_list_#ListGetAt(attributes.target_mass,gonderim,',')#") and len(Evaluate('cons_sms_list_#ListGetAt(attributes.target_mass,gonderim,',')#'))) or (isdefined("PARS_SMS_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#") and len(Evaluate('PARS_SMS_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#')))>
				<cfquery name="get_tmarket_members_mass" datasource="#dsn#">
					<cfif isdefined("cons_sms_list_#ListGetAt(attributes.target_mass,gonderim,',')#") and len(Evaluate('cons_sms_list_#ListGetAt(attributes.target_mass,gonderim,',')#'))>
					SELECT
						0 COMPANY_ID,
						CONSUMER_ID MEMBER_ID,
						CONSUMER_NAME MEMBER_NAME,
						CONSUMER_SURNAME MEMBER_SURNAME,
						MOBIL_CODE + MOBILTEL MEMBER_PHONE,
						'consumer' MEMBER_TYPE
					FROM
						CONSUMER
					WHERE
						CONSUMER_ID IN (#Evaluate('CONS_SMS_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#')#)
						AND LEN(MOBIL_CODE + MOBILTEL) = 10
					</cfif>
				<cfif (isdefined("cons_sms_list_#ListGetAt(attributes.target_mass,gonderim,',')#") and len(Evaluate('cons_sms_list_#ListGetAt(attributes.target_mass,gonderim,',')#'))) and (isdefined("PARS_SMS_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#") and len(Evaluate('PARS_SMS_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#')))>
				UNION ALL
				</cfif>
					<cfif isdefined("PARS_SMS_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#") and len(Evaluate('PARS_SMS_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#'))>
					SELECT 
						COMPANY_ID COMPANY_ID,
						PARTNER_ID MEMBER_ID,
						COMPANY_PARTNER_NAME MEMBER_NAME,
						COMPANY_PARTNER_SURNAME MEMBER_SURNAME,
						MOBIL_CODE + MOBILTEL MEMBER_PHONE,
						'partner' MEMBER_TYPE
					FROM 
						COMPANY_PARTNER
					WHERE
						PARTNER_ID IN(#Evaluate('PARS_SMS_LIST_#ListGetAt(attributes.target_mass,gonderim,',')#')#)
						AND LEN(MOBIL_CODE + MOBILTEL) = 10
					</cfif>
				</cfquery>
				<cfoutput query="get_tmarket_members_mass">
					<cfset sms_text=wrk_sms_body_replace(sms_body:sms_cont.sms_body,member_type:member_type,member_id:member_id,paper_type:"",paper_id:"")>
					<cfif len(sms_text) lte 462>
						<cfset attributes.sms_body = Left(sms_text,462)>
						<cfset attributes.mobil_phone = get_tmarket_members_mass.member_phone>
						<cfset attributes.campaign_id = sms_cont.camp_id>
						<cfset attributes.member_type = get_tmarket_members_mass.member_type>
						<cfset attributes.member_id = get_tmarket_members_mass.member_id>
						<cfset attributes.member_id_2 = get_tmarket_members_mass.company_id>
						<cfset callcenter_include = 1>
						<cfinclude template="../../objects/query/add_send_sms.cfm">
						<cfquery name="update_campaign_info" datasource="#dsn#">
							UPDATE #dsn3_alias#.CAMPAIGN_SMS_CONT SET IS_SENT = 1 WHERE SMS_CONT_ID = #attributes.sms_cont_id#
						</cfquery>  
					</cfif>
				</cfoutput>
			</cfif>
		</cfloop>
	</cfif>
	<cfif isDefined("attributes.target_mass_other")>
		<!--- Elle eklenmis uyeler --->
		<cfif (isdefined('attributes.OTHER_CONS_SMS_LIST') and len(attributes.OTHER_CONS_SMS_LIST)) or (isdefined('attributes.OTHER_PARS_SMS_LIST') and  len(attributes.OTHER_PARS_SMS_LIST))>
			<cfquery name="get_tmarket_members_mass_other" datasource="#dsn#">
				<cfif (isdefined('attributes.OTHER_CONS_SMS_LIST') and len(attributes.OTHER_CONS_SMS_LIST))>	
				SELECT
					0 COMPANY_ID,
					CONSUMER_ID MEMBER_ID,
					CONSUMER_NAME MEMBER_NAME,
					CONSUMER_SURNAME MEMBER_SURNAME,
					MOBIL_CODE + MOBILTEL MEMBER_PHONE,
					'consumer' MEMBER_TYPE
				FROM
					CONSUMER
				WHERE
					CONSUMER_ID IN (#attributes.OTHER_CONS_SMS_LIST#)
					AND LEN(MOBIL_CODE + MOBILTEL) = 10
				</cfif>
			<cfif (isdefined('attributes.OTHER_CONS_SMS_LIST') and len(attributes.OTHER_CONS_SMS_LIST)) and (isdefined('attributes.OTHER_PARS_SMS_LIST') and  len(attributes.OTHER_PARS_SMS_LIST))>
			UNION ALL
			</cfif>
				<cfif isdefined('attributes.OTHER_PARS_SMS_LIST') and  len(attributes.OTHER_PARS_SMS_LIST)>
				SELECT 
					COMPANY_ID COMPANY_ID,
					PARTNER_ID MEMBER_ID,
					COMPANY_PARTNER_NAME MEMBER_NAME,
					COMPANY_PARTNER_SURNAME MEMBER_SURNAME,
					MOBIL_CODE + MOBILTEL MEMBER_PHONE,
					'partner' MEMBER_TYPE
				FROM 
					COMPANY_PARTNER
				WHERE
					PARTNER_ID IN (#attributes.OTHER_PARS_SMS_LIST#)
					AND LEN(MOBIL_CODE + MOBILTEL) = 10
				</cfif>
			</cfquery>
			<cfoutput query="get_tmarket_members_mass_other"><!--- GET_TMARKET_USERS'dan gelen üyelerin gönderimi yapılıyor. --->
				<cfset sms_text=wrk_sms_body_replace(sms_body:sms_cont.sms_body,member_type:member_type,member_id:member_id,paper_type:"",paper_id:"")>
				<cfif len(sms_text) lte 462>
					<cfset attributes.sms_body = Left(sms_text,462)>
					<cfset attributes.mobil_phone = get_tmarket_members_mass_other.member_phone>
					<cfset attributes.campaign_id = sms_cont.camp_id>
					<cfset attributes.member_type = get_tmarket_members_mass_other.member_type>
					<cfset attributes.member_id = get_tmarket_members_mass_other.member_id>
					<cfset attributes.member_id_2 = get_tmarket_members_mass_other.company_id>
					<cfset callcenter_include = 1>
					<cfinclude template="../../objects/query/add_send_sms.cfm">
					<cfquery name="update_campaign_info" datasource="#dsn#">
						UPDATE #dsn3_alias#.CAMPAIGN_SMS_CONT SET IS_SENT = 1 WHERE SMS_CONT_ID = #attributes.sms_cont_id#
					</cfquery>
				</cfif>
			</cfoutput>
		</cfif>
	</cfif>
</cftransaction>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>
		window.close();
	<cfelse>
		closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );
	</cfif>
</script>
