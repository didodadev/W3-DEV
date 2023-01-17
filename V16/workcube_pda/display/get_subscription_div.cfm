<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.s_status" default="1">
<cfparam name="attributes.s_member" default="1">

<cfif isdefined("session.pp.userid") and attributes.s_member eq 2>
	<cfquery name="GET_COMP_HIER" datasource="#DSN#">
		SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
	</cfquery>
	<cfset list_comp_hier = ''>
	<cfoutput query="get_comp_hier">
		<cfif len(company_id) and not listfind(list_comp_hier,company_id)>
			<cfset list_comp_hier = Listappend(list_comp_hier,company_id)>
		</cfif>
	</cfoutput>
</cfif>

<cfset url_string = "">
 <cfif isdefined("attributes.field_id")>
	<cfset url_string = "#url_string#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_no")>
	<cfset url_string = "#url_string#&field_no=#attributes.field_no#">
</cfif>
<cfif isdefined("attributes.field_comp_id")>
	<cfset url_string = "#url_string#&field_comp_id=#attributes.field_comp_id#">
</cfif>
<cfif isdefined("attributes.field_par_id")>
	<cfset url_string = "#url_string#&field_par_id=#attributes.field_par_id#">
</cfif>
<cfif isdefined("attributes.field_cons_id")>
	<cfset url_string = "#url_string#&field_cons_id=#attributes.field_cons_id#">
</cfif>
<cfif isdefined("attributes.field_ship_address")>
	<cfset url_string = "#url_string#&field_ship_address=#attributes.field_ship_address#">
</cfif>

<cfif isdefined('session.pp.userid') and attributes.s_member eq 2 and not len(list_comp_hier)>
	<cfset get_subscription.recordcount = 0>
<cfelse>
	<cfquery name="GET_SUBSCRIPTIONS" datasource="#DSN3#">
		SELECT
			SC.SUBSCRIPTION_ID,
			SC.SUBSCRIPTION_NO,
			SC.SUBSCRIPTION_HEAD,
			SC.SALES_EMP_ID,
			SC.SUBSCRIPTION_STAGE,
			SC.RECORD_EMP,
			SC.SHIP_ADDRESS,
			SC.SHIP_COUNTY_ID,
			SC.SHIP_CITY_ID,
			SC.SHIP_COUNTRY_ID,
			SC.SHIP_POSTCODE,
            SC.PROJECT_ID,
			SST.SUBSCRIPTION_TYPE,
			SC.COMPANY_ID,
			SC.PARTNER_ID,
			SC.CONSUMER_ID
		FROM
			SUBSCRIPTION_CONTRACT SC,
			SETUP_SUBSCRIPTION_TYPE AS SST
		WHERE
        	<cfif isDefined('session.pp.userid')>
				<cfif isDefined('attributes.s_member') and attributes.s_member eq 1>
                (
                    SC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> OR
                    SC.INVOICE_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
                ) AND
                <cfelse>
                (
                    COMPANY_ID IN (#list_comp_hier#) OR
                    INVOICE_COMPANY_ID IN (#list_comp_hier#)
                ) AND
                </cfif>
            </cfif>
			<cfif isDefined('attributes.s_status') and attributes.s_status eq 1>
				SC.IS_ACTIVE = 1 AND
			<cfelseif isDefined('attributes.s_status') and attributes.s_status eq 0>
				SC.IS_ACTIVE = 0 AND
			</cfif>
			SUBSCRIPTION_ID IS NOT NULL AND 
			SST.SUBSCRIPTION_TYPE_ID = SC.SUBSCRIPTION_TYPE_ID
			<cfif len(attributes.keyword)>
				AND 
                (
						SC.SUBSCRIPTION_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
						SC.SUBSCRIPTION_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				)
			</cfif>
	</cfquery>
	<cfif len(get_subscriptions.ship_county_id)>
		<cfquery name="GET_COUNTY" datasource="#DSN#">
			SELECT COUNTY_NAME,COUNTY_ID FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscriptions.ship_county_id#">
		</cfquery>
	<cfelse>
		<cfset get_county.county_name = ''>
	</cfif>
	<cfif len(get_subscriptions.ship_city_id)>
		<cfquery name="GET_CITY" datasource="#DSN#">
			SELECT CITY_NAME,CITY_ID FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscriptions.ship_city_id#">
		</cfquery>
	<cfelse>
		<cfset get_city.city_name = ''>
	</cfif>
	<cfif not len(get_subscriptions.ship_address)>
		<cfset get_subscriptions.ship_address = ''>
	</cfif>
	<cfif not len(get_subscriptions.ship_postcode)>
		<cfset get_subscriptions.ship_postcode = ''>
	</cfif>
	
	<cfif len(get_subscriptions.ship_city_id)>
		<cfquery name="GET_COUNTRY" datasource="#DSN#">
			SELECT COUNTRY_NAME,COUNTRY_ID FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscriptions.ship_country_id#">
		</cfquery>
	<cfelse>
		<cfset get_country.country_name = ''>
	</cfif>
	<cfset address = "#get_subscriptions.ship_address# #get_county.county_name# - #get_city.city_name# - #get_subscriptions.ship_postcode# - #get_country.country_name#">
</cfif>

<cf_box title="Sistemler" body_style="overflow-y:scroll;height:400px;" call_function='gizle(subscription_div);' header_style='height:25px;'>
	<table cellspacing="1" cellpadding="2" border="0" class="color-border" align="center" style="width:98%">
		<tr class="color-header" style="height:22px;">
			<td class="form-title"><cf_get_lang_main no='1705.Sistem No'></td>
			<td class="form-title"><cf_get_lang_main no='821.Tanım'></td>
			<td class="form-title"><cf_get_lang_main no='74.Kategori'></td>
			<td class="form-title">Satış Temsilcisi</td>
		</tr>
		<cfif get_subscriptions.recordcount>
			<cfset process_list=''>
            <cfset employee_list=''>
            <cfoutput query="get_subscriptions">
                <cfif len(get_subscriptions.subscription_stage) and not listfind(process_list,get_subscriptions.subscription_stage)>
                    <cfset process_list = listappend(process_list,get_subscriptions.subscription_stage)>
                </cfif>
                <cfif len(get_subscriptions.record_emp) and not listfind(employee_list,get_subscriptions.record_emp)>
                    <cfset employee_list = listappend(employee_list,get_subscriptions.record_emp)>
                </cfif>
                <cfif len(get_subscriptions.sales_emp_id) and not listfind(employee_list,get_subscriptions.sales_emp_id)>
                    <cfset employee_list = listappend(employee_list,get_subscriptions.sales_emp_id)>
                </cfif>
            </cfoutput>
		
			<cfif len(employee_list)>
                <cfset employee_list=listsort(employee_list,"numeric","ASC",",")>
                <cfquery name="GET_EMPLOYEE" datasource="#DSN#">
                    SELECT
                        EMPLOYEE_NAME,
                        EMPLOYEE_SURNAME,
                        EMPLOYEE_ID
                    FROM
                        EMPLOYEES
                    WHERE
                        EMPLOYEE_ID IN (#employee_list#)
                    ORDER BY
                        EMPLOYEE_ID
                </cfquery>
                <cfset main_employee_list = listsort(listdeleteduplicates(valuelist(get_employee.employee_id,',')),'numeric','ASC',',')>
            </cfif>
			<cfoutput query="get_subscriptions">
                <tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" style="height:20px;">
                    <td><a onclick="add_subscription_div('#subscription_id#','#subscription_no#','#project_id#');" class="tableyazi" style="cursor:hand;">#subscription_no#</a></td>
                    <td>#left(subscription_head,50)#</td>
                    <td>#subscription_type#</td>
                    <td>
 						<cfif len(get_subscriptions.sales_emp_id)>
                          	<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_emp_det&emp_id=#encrypt(get_subscriptions.sales_emp_id,"WORKCUBE","BLOWFISH","Hex")#','medium');" class="tableyazi">
                              	#get_employee.employee_name[listfind(main_employee_list,get_subscriptions.sales_emp_id,',')]#&nbsp;#get_employee.employee_surname[listfind(main_employee_list,get_subscriptions.sales_emp_id,',')]#
                          	</a>
                      	</cfif>
                    </td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr class="color-row">
                <td colspan="4"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
    </table>
</cf_box>
