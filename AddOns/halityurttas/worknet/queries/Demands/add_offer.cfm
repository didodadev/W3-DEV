<cfinclude template="../../config.cfm">
<cfif isdefined("attributes.deliver_date") and len(attributes.deliver_date)>
	<cf_date tarih="attributes.deliver_date">
</cfif>
<cfif isDefined("attributes.offer_file") and len(attributes.offer_file)>
	<cfset upload_folder = "#upload_folder##dir_seperator#worknet#dir_seperator#">
    <cftry>
        <cfset fileHelper = objectResolver.resolveByRequest("#addonNS#.components.common.filehelper")>
        <cftry>
            <cfset attributes.offer_file = fileHelper.save_uploaded_file('offer_file', upload_folder)>
            <cfcatch type="any">
                <script type="text/javascript">
                    alert('<cfoutput>#cfcatch#</cfoutput>');
                    history.back();
                    <cfabort>
                </script>
            </cfcatch>
        </cftry>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>
<cfquery name="add_demand_offer" datasource="#dsn#" result="res">
	INSERT INTO
		WORKNET_DEMAND_OFFER
		(
			DEMAND_ID,
			OFFER_STATUS,
			COMPANY_ID,
			CONSUMER_ID,
			PARTNER_ID,
			EMPLOYEE_ID,
			SHIP_METHOD,
			DELIVER_ADDRES,
			PAYMETHOD,
			DETAIL,
			DELIVER_DATE,
			OFFER_TOTAL,
			OFFER_MONEY,
			OFFER_FILE,
			OFFER_FILE_SERVER_ID,
			OFFER_STAGE,
			RECORD_DATE,
			RECORD_MEMBER,
			RECORD_MEMBER_TYPE,
			RECORD_IP
		)
		VALUES
		(
			#attributes.demand_id#,
			1,
			<cfif isdefined("session.pp.company_id")>#session.pp.company_id#<cfelse>NULL</cfif>,
			<cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
			<cfif isdefined("session.pp.userid")>#session.pp.userid#<cfelse>NULL</cfif>,
			<cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
			<cfif isDefined("attributes.ship_method") and len(attributes.ship_method)>'#attributes.ship_method#',<cfelse>NULL,</cfif>
			<cfif isDefined("attributes.deliver_addres") and len(attributes.deliver_addres)>'#attributes.deliver_addres#',<cfelse>NULL,</cfif>
			<cfif isDefined("attributes.paymethod") and len(attributes.paymethod)>'#attributes.paymethod#',<cfelse>NULL,</cfif>
			'#left(attributes.detail,500)#',
			<cfif isDefined("attributes.deliver_date") and len(attributes.deliver_date)>#attributes.deliver_date#,<cfelse>NULL,</cfif>
			<cfif isdefined("attributes.total_amount") and len(attributes.total_amount)>#attributes.total_amount#,<cfelse>NULL,</cfif>
			<cfif isdefined("attributes.money") and len(attributes.money)>'#attributes.money#',<cfelse>NULL,</cfif>
			<cfif isDefined("attributes.offer_file") and len(attributes.offer_file)>
				'#attributes.offer_file#',
				#fusebox.server_machine#,
			<cfelse>
				NULL,
				NULL,
			</cfif>
			#attributes.process_stage#,
			#now()#,
			<cfif isdefined("session.ep")>
				#session.ep.userid#,
				'employee',
			<cfelseif isdefined("session.pp")>
				#session.pp.userid#,
				'partner',
			<cfelseif isdefined("session.ww")>
				#session.ww.userid#,
				'consumer',
			</cfif>
			'#cgi.remote_addr#'
		)
</cfquery>
<cfif isdefined('session.ep')>
	<cfset process_user_id = session.ep.userid>
<cfelseif isdefined('session.pp')>
	<cfset process_user_id = session.pp.userid>
<cfelseif isdefined('session.ww.userid')>
	<cfset process_user_id = session.ww.userid>
</cfif>

<cf_workcube_process 
	is_upd='1' 
	old_process_line='0'
	process_stage='#attributes.process_stage#' 
	record_member='#process_user_id#' 
	record_date='#now()#' 
	action_table='WORKNET_DEMAND_OFFER'
	action_column='DEMAND_OFFER_ID'
	action_id='#res.identitycol#'
	action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.demands&event=add-offer&demand_id=#attributes.demand_id#' 
	warning_description = 'Talep : #left(attributes.detail,500)#'>

<script type="text/javascript">
	alert('<cf_get_lang no="301.Teklifiniz başarı ile kaydedilmiştir"> !');
	wrk_opener_reload();
	window.close();
</script>
