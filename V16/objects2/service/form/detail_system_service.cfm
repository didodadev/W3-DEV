<cfinclude template="../../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfinclude template="../query/get_service_detail.cfm">
<cfif not get_service_detail.recordcount>
	<br/><font class="txtbold">&nbsp;&nbsp;<cf_get_lang no='595.Çalıştığınız Şirkete Ait Böyle Bir Başvuru Kaydı Bulunamadı'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfset attributes.PARTNER_ID = get_service_detail.service_partner_id>
<cfset attributes.CONSUMER_ID = get_service_detail.service_consumer_id>
<cfset employee_id = get_service_detail.service_employee_id>
<cfset service_id = get_service_detail.service_id>
<cfset service_status_id = get_service_detail.service_status_id>
<cfset attributes.service_id = get_service_detail.service_id>
<!--- garanti bilgileri --->

<cfif len(get_service_detail.subscription_id)>
	<cfquery name="get_subs" datasource="#dsn3#">
		SELECT
			SUBSCRIPTION_ID,
			SUBSCRIPTION_NO
		FROM
			SUBSCRIPTION_CONTRACT
		WHERE
			SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service_detail.subscription_id#">
	</cfquery>
</cfif>

<!--- <cfquery name="get_irs" datasource="#dsn2#">
	SELECT SHIP_ID FROM SHIP WHERE SERVICE_ID = #service_id#
</cfquery> Bunun neden cekilmis--->

<cfif isdefined("session.pp.userid") and len(get_service_detail.record_par) and get_service_detail.record_par eq session.pp.userid and not len(get_service_detail.update_member)>
	<cfinclude template="../query/get_service_appcat.cfm">
	<cfinclude template="upd_system_service.cfm">
<cfelseif isdefined("session.ww.userid") and len(get_service_detail.record_cons) and get_service_detail.record_cons eq session.ww.userid and not len(get_service_detail.update_member)>
	<cfinclude template="../query/get_service_appcat.cfm">
	<cfinclude template="upd_system_service.cfm">
<cfelse>
	<cfinclude template="dsp_system_service.cfm"><br/>
	<cfinclude template="dsp_service_plus.cfm">
</cfif>

