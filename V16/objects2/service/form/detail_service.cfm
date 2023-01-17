<cfinclude template="../../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfinclude template="../query/get_service_detail.cfm">
<cfif not get_service_detail.recordcount>
	<br/><font class="txtbold">&nbsp;&nbsp;<cf_get_lang no='595.Çalıştığınız Şirkete Ait Böyle Bir Başvuru Kaydı Bulunamadı'> !</font>
	<cfexit method="exittemplate">
</cfif>
<cfset attributes.partner_id = get_service_detail.service_partner_id>
<cfset attributes.consumer_id = get_service_detail.service_consumer_id>
<cfset employee_id = get_service_detail.service_employee_id>
<cfset service_id = get_service_detail.service_id>
<cfset service_status_id = get_service_detail.service_status_id>
<cfset attributes.service_id = get_service_detail.service_id>
<!--- garanti bilgileri --->
<cfscript>
	stock_id = get_service_detail.stock_id;
	pro_serial_no = get_service_detail.pro_serial_no;
	page_no = get_service_detail.guaranty_page_no;
</cfscript>
<cfif len(stock_id) and len(pro_serial_no)>
	<cfinclude template="../query/get_pro_guaranty.cfm">
</cfif>
<cfquery name="GET_CITY" datasource="#DSN#">
	SELECT CITY_ID,CITY_NAME,PHONE_CODE,COUNTRY_ID,PLATE_CODE FROM SETUP_CITY ORDER BY PRIORITY,CITY_NAME
</cfquery>
<cfquery name="GET_IRS" datasource="#DSN2#">
	SELECT SHIP.SHIP_ID FROM SHIP,SHIP_ROW WHERE SHIP_ROW.SHIP_ID = SHIP.SHIP_ID AND SHIP_ROW.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#service_id#">
</cfquery>

<cfif isdefined("session.pp.userid") and len(get_service_detail.record_par) and get_service_detail.record_par eq session.pp.userid and not len(get_service_detail.update_member) and get_irs.recordcount eq 0>
	<cfinclude template="../query/get_service_appcat.cfm">
	<cfinclude template="upd_service.cfm">
    <cfif isDefined('attributes.is_service_operation') and (attributes.is_service_operation eq 2 or attributes.is_service_operation eq 1)>
    	<cfinclude template="add_service_operation.cfm">
    </cfif>
<cfelseif isdefined("session.ww.userid") and len(get_service_detail.record_cons) and get_service_detail.record_cons eq session.ww.userid and not len(get_service_detail.update_member) and get_irs.recordcount eq 0>
	<cfinclude template="../query/get_service_appcat.cfm">
	<cfinclude template="upd_service.cfm">
<cfelse>
	<cfinclude template="dsp_service.cfm"><br/>
	<cfinclude template="dsp_service_plus.cfm"><br />
    <cfif isDefined('attributes.is_service_operation') and (attributes.is_service_operation eq 2 or attributes.is_service_operation eq 1)>
    	<cfinclude template="add_service_operation.cfm">
    </cfif>
</cfif>

