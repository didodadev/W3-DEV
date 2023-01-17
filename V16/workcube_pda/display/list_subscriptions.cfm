<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.s_status" default="1">
<cfparam name="attributes.s_member" default="1">

<!---<cfif isdefined("session.pp.userid") and attributes.s_member eq 2>
	<cfquery name="get_comp_hier" datasource="#dsn#">
		SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
	</cfquery>
	<cfset list_comp_hier = ''>
	<cfoutput query="get_comp_hier">
		<cfif len(company_id) and not listfind(list_comp_hier,company_id)>
			<cfset list_comp_hier = Listappend(list_comp_hier,company_id)>
		</cfif>
	</cfoutput>
</cfif>--->

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

<cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
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
        SST.SUBSCRIPTION_TYPE,
        SC.COMPANY_ID,
        SC.PARTNER_ID,
        SC.CONSUMER_ID
    FROM
        SUBSCRIPTION_CONTRACT SC,
        SETUP_SUBSCRIPTION_TYPE AS SST
    WHERE
        <cfif attributes.s_status eq 1>
            SC.IS_ACTIVE = 1 AND
        <cfelseif attributes.s_status eq 0>
            SC.IS_ACTIVE = 0 AND
        </cfif>
        SUBSCRIPTION_ID IS NOT NULL AND
        SST.SUBSCRIPTION_TYPE_ID = SC.SUBSCRIPTION_TYPE_ID
        <cfif len(attributes.keyword)>
			AND 
            (
                SUBSCRIPTION_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                SUBSCRIPTION_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
            )
		</cfif>
</cfquery>

<cfif len(get_subscription.ship_county_id)>
	<cfquery name="GET_COUNTY" datasource="#DSN#">
		SELECT COUNTY_NAME,COUNTY_ID FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.ship_county_id#">
	</cfquery>
<cfelse>
	<cfset get_county.county_name = ''>
</cfif>
<cfif len(get_subscription.ship_city_id)>
	<cfquery name="GET_CITY" datasource="#DSN#">
		SELECT CITY_NAME,CITY_ID FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.ship_city_id#">
	</cfquery>
<cfelse>
	<cfset get_city.city_name = ''>
</cfif>
<cfif not len(get_subscription.ship_address)>
	<cfset get_subscription.ship_address = ''>
</cfif>
<cfif not len(get_subscription.ship_postcode)>
	<cfset get_subscription.ship_postcode = ''>
</cfif>

<cfif len(get_subscription.ship_city_id)>
	<cfquery name="GET_COUNTRY" datasource="#DSN#">
		SELECT COUNTRY_NAME,COUNTRY_ID FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_subscription.ship_country_id#">
	</cfquery>
<cfelse>
	<cfset get_country.country_name = ''>
</cfif>
<cfset address = "#get_subscription.ship_address# #get_county.county_name# - #get_city.city_name# - #get_subscription.ship_postcode# - #get_country.country_name#">

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.pda.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_subscription.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<table cellpadding="0" cellspacing="0" align="center" style="width:98%">
	<tr style="height:35px;">
		<td class="headbold">Sistemler</td>
	</tr>
</table>
<table cellspacing="0" cellpadding="0" align="center" style="width:98%">
  	<tr style="height:25px;">
        <td class="headbold"></td>
        <td style="text-align:right;">
        	<cfform name="list_subscription" action="#request.self#?fuseaction=#attributes.fuseaction##url_string#" method="post">
                <table align="right">
                	<input type="hidden" name="is_submited" id="is_submited" value="1" />
                	<tr>
                        <td><cf_get_lang_main no='48.Filtre'>:</td>
                        <td><input type="text" name="keyword" id="keyword" style="width:100px;" value="<cfif isDefined('attributes.keyword') and len(attributes.keyword)><cfoutput>#attributes.keyword#</cfoutput></cfif>" maxlength="255"></td>
                        <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        </td>
                        <td style="vertical-align:middle;"><cf_wrk_search_button is_excel='0'></td>
                    </tr>
                </table>
            </cfform>
        </td>
  	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" align="center" style="width:98%">	
	<tr>
		<td class="color-row">
            <table cellspacing="1" cellpadding="2" border="0" class="color-border" align="center" style="width:100%">
                <tr class="color-header" style="height:20px;">
                    <td class="form-title" style="width:18%"><cf_get_lang_main no='1705.Sistem No'></td>
                    <td class="form-title"><cf_get_lang_main no='821.Tanım'></td>
                    <td class="form-title"><cf_get_lang_main no='74.Kategori'></td>
                </tr>
                <cfif get_subscription.recordcount>
                    <cfset process_list=''>
                    <cfset employee_list=''>
                    <cfoutput query="get_subscription" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif len(get_subscription.subscription_stage) and not listfind(process_list,get_subscription.subscription_stage)>
                            <cfset process_list = listappend(process_list,get_subscription.subscription_stage)>
                        </cfif>
                        <cfif len(get_subscription.record_emp) and not listfind(employee_list,get_subscription.record_emp)>
                            <cfset employee_list = listappend(employee_list,get_subscription.record_emp)>
                        </cfif>
                        <cfif len(get_subscription.sales_emp_id) and not listfind(employee_list,get_subscription.sales_emp_id)>
                            <cfset employee_list = listappend(employee_list,get_subscription.sales_emp_id)>
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
                    <cfoutput query="get_subscription" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="height:20px;">
                            <td><a href="#request.self#?fuseaction=pda.detail_subscription&subscription_id=#subscription_id#" class="tableyazi">#subscription_no#</a></td>
                            <td>#left(subscription_head,50)#</td>
                            <td>#subscription_type#</td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr class="color-row">
                        <td colspan="4"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
            </table>
		</td>
	</tr>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
  	<table cellpadding="0" cellspacing="0" border="0" align="center" style="width:98%; height:30px;">
    	<tr>
      		<td> 
            	<cf_pages page="#attributes.page#"
			  		maxrows="#attributes.maxrows#"
			  		totalrecords="#attributes.totalrecords#"
			  		startrow="#attributes.startrow#"
			  		adres="#attributes.fuseaction##url_string#&keyword=#attributes.keyword#&s_status=#attributes.s_status#"> </td>
     		<td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#get_subscription.recordcount#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
    	</tr>
  	</table>
</cfif>
<script type="text/javascript">
	function gonder(id,no,address,comp_id,par_id,cons_id)
	{
		<cfoutput>
		<cfif isdefined("attributes.field_id")>
			opener.#attributes.field_id#.value = id;
		</cfif>
		<cfif isdefined("attributes.field_no")>
			opener.#attributes.field_no#.value = no;
		</cfif>
		<cfif isdefined("attributes.field_ship_address")>
			opener.#attributes.field_ship_address#.value = address;
		</cfif>
		<cfif isdefined("attributes.field_comp_id")>
			opener.#attributes.field_comp_id#.value = comp_id;
		</cfif>
		<cfif isdefined("attributes.field_par_id")>
			opener.#attributes.field_par_id#.value = par_id;
		</cfif>
		<cfif isdefined("attributes.field_cons_id")>
			opener.#attributes.field_cons_id#.value = cons_id;
		</cfif>
		</cfoutput>
		<!--- window.close(); --->
	}		
</script>
