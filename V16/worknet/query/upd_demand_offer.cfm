<cfif isdefined("attributes.deliver_date") and len(attributes.deliver_date)>
	<cf_date tarih="attributes.deliver_date">
</cfif>
<cfif len(attributes.old_offer_file) and isdefined("attributes.del_file")>
	<cf_del_server_file output_file="worknet/#attributes.old_offer_file#" output_server="#attributes.old_offer_file_server_id#">
</cfif>
<cfif isDefined("attributes.offer_file") and len(attributes.offer_file)>
	<cfset upload_folder = "#upload_folder##dir_seperator#worknet#dir_seperator#">
	<cftry>
		<cffile action="UPLOAD"
				filefield="offer_file"
				destination="#upload_folder#"
				mode="777"
				nameconflict="MAKEUNIQUE">
			<cfset file_name = createUUID()>
			<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
			<!---Script dosyalarını engelle  02092010 FA-ND --->
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				<cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
				<script type="text/javascript">
					alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
					history.back();
				</script>
				<cfabort>
			</cfif>	
			<cfset attributes.offer_file = '#file_name#.#cffile.serverfileext#'>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'> !");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>
<cfquery name="upd_demand_offer" datasource="#dsn#">
	UPDATE
		WORKNET_DEMAND_OFFER
	SET
		COMPANY_ID = <cfif isdefined("session.pp.company_id")>#session.pp.company_id#<cfelse>NULL</cfif>,
		CONSUMER_ID = <cfif isdefined("session.ww.userid")>#session.ww.userid#<cfelse>NULL</cfif>,
		PARTNER_ID = <cfif isdefined("session.pp.userid")>#session.pp.userid#<cfelse>NULL</cfif>,
		EMPLOYEE_ID = <cfif isdefined("session.ep.userid")>#session.ep.userid#<cfelse>NULL</cfif>,
		SHIP_METHOD = <cfif isDefined("attributes.ship_method") and len(attributes.ship_method)>'#attributes.ship_method#',<cfelse>NULL,</cfif>
		DELIVER_ADDRES = <cfif isDefined("attributes.deliver_addres") and len(attributes.deliver_addres)>'#attributes.deliver_addres#',<cfelse>NULL,</cfif>
		PAYMETHOD = <cfif isDefined("attributes.paymethod") and len(attributes.paymethod)>'#attributes.paymethod#',<cfelse>NULL,</cfif>
		DETAIL = '#left(attributes.detail,500)#',
		DELIVER_DATE = <cfif isDefined("attributes.deliver_date") and len(attributes.deliver_date)>#attributes.deliver_date#,<cfelse>NULL,</cfif>
		OFFER_TOTAL = <cfif isdefined("attributes.total_amount") and len(attributes.total_amount)>#filterNum(attributes.total_amount)#,<cfelse>NULL,</cfif>
		OFFER_MONEY = <cfif isdefined("attributes.money") and len(attributes.money)>'#attributes.money#',<cfelse>NULL,</cfif>
		<cfif isDefined("attributes.offer_file") and len(attributes.offer_file)>
			OFFER_FILE = '#attributes.offer_file#',
			OFFER_FILE_SERVER_ID = #fusebox.server_machine#,
		<cfelseif isdefined("attributes.del_file")>
			OFFER_FILE = NULL,
			OFFER_FILE_SERVER_ID = NULL,
		</cfif>
		OFFER_STAGE = #attributes.process_stage#,
		UPDATE_DATE = #now()#,
		UPDATE_MEMBER = 
			<cfif isdefined("session.ep")>
				#session.ep.userid#,
			<cfelseif isdefined("session.pp")>
				#session.pp.userid#,
			<cfelseif isdefined("session.ww")>
				#session.ww.userid#,
			</cfif>
		UPDATE_MEMBER_TYPE =
			<cfif isdefined("session.ep")>
				'employee',
			<cfelseif isdefined("session.pp")>
				'partner',
			<cfelseif isdefined("session.ww")>
				'consumer',
			</cfif>
		UPDATE_IP = '#cgi.remote_addr#'
	WHERE
		DEMAND_OFFER_ID = #attributes.demand_offer_id#
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
	old_process_line='#attributes.old_process_line#'
	process_stage='#attributes.process_stage#' 
	RECORD_MEMBER_TYPE='#process_user_id#' 
	record_date='#now()#' 
	action_table='WORKNET_DEMAND_OFFER'
	action_column='DEMAND_OFFER_ID'
	action_id='#attributes.demand_offer_id#'
	action_page='#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_demand&demand_id=#attributes.demand_id#' 
	warning_description = 'Talep : #left(attributes.detail,500)#'>

<script type="text/javascript">
	alert('Teklifiniz başarı ile kaydedilmiştir !');
	wrk_opener_reload();
	window.close();
</script>
