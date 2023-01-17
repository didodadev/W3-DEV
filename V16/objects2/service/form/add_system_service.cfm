<cfinclude template="../../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<!--- sistemlerden gelince sevk adresini montaj adresiyle dolduruyor --->
<cfset ship_address = "">
<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
	<cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
		SELECT 
			SUBSCRIPTION_NO,
			SUBSCRIPTION_ID,
			SHIP_ADDRESS,
			SHIP_CITY_ID,
			SHIP_COUNTY_ID,
			SHIP_COUNTRY_ID,
			SHIP_POSTCODE,
			COMPANY_ID,
			PARTNER_ID,
			CONSUMER_ID
		FROM 
			SUBSCRIPTION_CONTRACT 
		WHERE 
			SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.subscription_id#">
	</cfquery>
	<cfif len(GET_SUBSCRIPTION.consumer_id)>
		<cfset subs_member_id_ = GET_SUBSCRIPTION.consumer_id>
		<cfset subs_partner_id_ = "">
	<cfelseif len(GET_SUBSCRIPTION.company_id) and len(GET_SUBSCRIPTION.partner_id)>
		<cfset subs_member_id_ = GET_SUBSCRIPTION.company_id>
		<cfset subs_partner_id_ = GET_SUBSCRIPTION.partner_id>
	<cfelse>
		<cfset subs_member_id_ = "">
		<cfset subs_partner_id_ = "">
	</cfif>
	
	<cfif len(GET_SUBSCRIPTION.ship_county_id)>
		<cfquery name="GET_COUNTY" datasource="#DSN#">
			SELECT COUNTY_NAME,COUNTY_ID FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.ship_county_id#">
		</cfquery>
		<cfset county_ = #get_county.county_name#>
	<cfelse>
		<cfset county_ = "">
	</cfif>
	<cfif len(GET_SUBSCRIPTION.ship_city_id)>
		<cfquery name="GET_CITY" datasource="#DSN#">
			SELECT CITY_NAME,CITY_ID FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.ship_city_id#">
		</cfquery>
		<cfset city_ = #get_city.city_name#>
	<cfelse>
		<cfset city_ = "">
	</cfif>
	<cfif len(GET_SUBSCRIPTION.ship_country_id)>	
		<cfquery name="GET_COUNTRY" datasource="#DSN#">
			SELECT COUNTRY_NAME,COUNTRY_ID FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.ship_country_id#">
		</cfquery>
		<cfset country_ = #get_country.country_name#>
	<cfelse>
		<cfset country_ = "">
	</cfif>
	<cfset ship_address = "#get_subscription.ship_address# #county_# - #city_# - #get_subscription.ship_postcode# - #country_#">
</cfif>
<!--- sistemlerden gelince sevk adresini montaj adresiyle dolduruyor --->

<cfinclude template="../query/get_service_appcat.cfm">
<cfinclude template="../query/get_sale_add_options.cfm">
<table class="color-border" width="100%" cellpadding="1" cellspacing="0">
	<tr>
		<td>
		<table class="color-row" width="100%">
		<cfform name="add_service" method="post" action="#request.self#?fuseaction=objects2.emptypopup_add_system_service">
			<cfif isdefined("attributes.subscription_id") and len(attributes.subscription_id)>
				<cfif len(GET_SUBSCRIPTION.consumer_id)>
					<input type="hidden" name="consumer_id"id="consumer_id" value="<cfoutput>#GET_SUBSCRIPTION.consumer_id#</cfoutput>">
					<input type="hidden" name="company_id" id="company_id" value="">
					<input type="hidden" name="partner_id" id="partner_id" value="">
				<cfelseif len(GET_SUBSCRIPTION.company_id) and len(GET_SUBSCRIPTION.partner_id)>
					<input type="hidden" name="consumer_id" id="consumer_id" value="">
					<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#GET_SUBSCRIPTION.company_id#</cfoutput>">
					<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#GET_SUBSCRIPTION.partner_id#</cfoutput>">
				<cfelse>
					<input type="hidden" name="consumer_id" id="consumer_id" value="">
					<input type="hidden" name="company_id" id="company_id" value="">
					<input type="hidden" name="partner_id" id="partner_id" value="">
				</cfif>
			<cfelse>
				<cfif isdefined("session.ww.userid")>
					<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#session.ww.userid#</cfoutput>">
					<input type="hidden" name="company_id" id="company_id" value="">
					<input type="hidden" name="partner_id" id="partner_id" value="">
				<cfelseif isdefined("session.pp.userid")>
					<input type="hidden" name="consumer_id" id="consumer_id" value="">
					<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#session.pp.company_id#</cfoutput>">
					<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#session.pp.userid#</cfoutput>">
				</cfif>
			</cfif>
		  	<tr>
				<td><cf_get_lang_main no='1420.Abone'></td>
				<td>
				  <input type="hidden" name="subscription_id" id="subscription_id" value="<cfif isdefined("attributes.subscription_id")><cfoutput>#attributes.subscription_id#</cfoutput></cfif>">
				  <input type="text" name="subscription_no" id="subscription_no" value="<cfif isdefined("get_subscription.subscription_no")><cfoutput>#get_subscription.subscription_no#</cfoutput></cfif>" readonly style="width:180px;">
				  <cfset str_subscription_link="field_par_id=add_service.partner_id&field_comp_id=add_service.company_id&field_cons_id=add_service.consumer_id&field_id=add_service.subscription_id&field_no=add_service.subscription_no&field_ship_address=add_service.service_address">
				  <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects2.popup_list_subscriptions&#str_subscription_link#'</cfoutput>,'list','popup_list_subscriptions');"><img src="/images/plus_list.gif" align="absmiddle" border="0"></a>
				</td>
			</tr>
		  <tr>
		  	<td><cf_get_lang_main no='68.Baslik'></td>
			<td><cfinput type="text" name="service_head" value="" maxlength="100" style="width:200px;"></td>
		  </tr>
		  <tr>
			<td width="100"><cf_get_lang_main no='74.Kategori'></td>
			<td>
			  <select name="appcat" id="appcat" style="width:200px;">
			  <cfoutput query="get_service_appcat">
				<cfif is_internet eq 1>
					<option value="#SERVICECAT_ID#">#SERVICECAT#</option>
				</cfif>
			  </cfoutput>
			  </select>
			</td>
		  </tr>
		  <tr>
		  	<td><cf_get_lang no ='432.Özel Tanim'></td>
			<td>
				<select name="sale_add_option_id" id="sale_add_option_id" style="width:200px;">
				<cfoutput query="get_sale_add_options">
					<option value="#SALES_ADD_OPTION_ID#">#SALES_ADD_OPTION_NAME#</option>
				</cfoutput>
				</select>
			</td>
		  </tr>
		<tr>
			<td valign="top"><cf_get_lang no ='477.Sevk Adresi'></td>
			<td><textarea name="service_address" id="service_address" style="width:200px;height:70px;"><cfoutput>#ship_address#</cfoutput></textarea></td>
		</tr>
		<tr>
			<td valign="top"><cf_get_lang no ='597.Ariza Tanimi'></td>
			<td><textarea name="CRM_DETAIL" id="CRM_DETAIL" style="width:300px; height:75px;"></textarea></td>
		  </tr>
		  <tr>
			<td></td>
			<td><cf_workcube_buttons is_upd='0'></td>
		  </tr>
		  </cfform>
		</table>
		</td>
	</tr>
</table>
