<cfif isdefined("attributes.is_submited")>
<cfquery name="get_subscription" datasource="#dsn3#">
	SELECT
		SC.SUBSCRIPTION_ID,
		SC.SUBSCRIPTION_NO,
		SC.SUBSCRIPTION_HEAD,
		SC.PARTNER_ID,
		SC.COMPANY_ID,
		SC.CONSUMER_ID,
		SC.SALES_EMP_ID,
		SC.SUBSCRIPTION_STAGE,
		SC.MONTAGE_DATE,
		SC.START_DATE,
		SC.FINISH_DATE,
		SC.RECORD_EMP,
		SC.SUBSCRIPTION_ADD_OPTION_ID,
		SC.SALES_ADD_OPTION_ID,
		SST.SUBSCRIPTION_TYPE
	FROM
		SUBSCRIPTION_CONTRACT SC,
		SETUP_SUBSCRIPTION_TYPE AS SST
	WHERE
		SUBSCRIPTION_ID IS NOT NULL AND 
		SST.SUBSCRIPTION_TYPE_ID = SC.SUBSCRIPTION_TYPE_ID 
		AND SC.IS_ACTIVE = 1 AND
		REF_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
		<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
		AND (
				SC.SUBSCRIPTION_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
				SC.SUBSCRIPTION_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
			)
	</cfif>
</cfquery>
<cfelse> 
	<cfset get_subscription.recordCount = 0>
</cfif> 

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_subscription.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<table cellspacing="0" cellpadding="0" width="100%" border="0" align="center">
  <tr class="formbold" height="27">
    <td align="right">
      <!---Arama --->
      <table>
        <cfform name="list_subscription" action="#request.self#?fuseaction=objects2.list_subscription_ref" method="post">
		<input type="hidden" name="is_submited" id="is_submited" value="1">
          <tr>
            <td><cf_get_lang_main no='48.Filtre'>:</td>
			<td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255"></td>
            </td>
            <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
				<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </td>
            <td><cf_wrk_search_button></td>
            </tr>
        </cfform>
      </table>
      <!---Arama --->
    </td>
  </tr>
</table>
<table cellspacing="1" cellpadding="2" width="100%" border="0">
	<tr class="color-header" height="20">
		<td class="form-title" width="60"><cf_get_lang_main no='1705.Sistem No'></td>
		<td class="form-title"><cf_get_lang_main no='821.Tanım'></td>
		<td class="form-title">Sistem</td>
		<td class="form-title"><cf_get_lang_main no='74.Kategori'></td>
		<td class="form-title"><cf_get_lang_main no='70.Aşama'></td>
		<!--- <td class="form-title">Satış Temsilcisi</td>
		<td class="form-title">Kayıt</td> --->
		<td width="20"></td>
	</tr>
	<cfif get_subscription.recordcount>
	<cfset process_list=''>
	<!--- <cfset employee_list=''> --->
	<cfset consumer_list=''>
	<cfset partner_list=''>
		<cfoutput query="get_subscription" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif len(get_subscription.consumer_id) and not listfind(consumer_list,get_subscription.consumer_id)>
				<cfset consumer_list = listappend(consumer_list,get_subscription.consumer_id)>
			</cfif>
			<cfif len(get_subscription.partner_id) and not listfind(partner_list,get_subscription.partner_id)>
				<cfset partner_list = listappend(partner_list,get_subscription.partner_id)>
			</cfif>
			<cfif len(get_subscription.subscription_stage) and not listfind(process_list,get_subscription.subscription_stage)>
				<cfset process_list = listappend(process_list,get_subscription.subscription_stage)>
			</cfif>
			<!--- <cfif len(get_subscription.record_emp) and not listfind(employee_list,get_subscription.record_emp)>
				<cfset employee_list = listappend(employee_list,get_subscription.record_emp)>
			</cfif>
			<cfif len(get_subscription.sales_emp_id) and not listfind(employee_list,get_subscription.sales_emp_id)>
				<cfset employee_list = listappend(employee_list,get_subscription.sales_emp_id)>
			</cfif> --->
		</cfoutput>
		<cfif len(partner_list)>
			<cfset partner_list=listsort(partner_list,"numeric","ASC",",")>
			<cfquery name="GET_PARTNER" datasource="#DSN#">
				SELECT
					COMPANY_PARTNER.COMPANY_PARTNER_NAME,
					COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
					COMPANY_PARTNER.PARTNER_ID,						
					COMPANY.FULLNAME,
					COMPANY.NICKNAME,
					COMPANY.COMPANY_ID
				FROM 
					COMPANY_PARTNER,
					COMPANY
				WHERE 
					COMPANY_PARTNER.PARTNER_ID IN (#partner_list#) AND
					COMPANY_PARTNER.COMPANY_ID = COMPANY.COMPANY_ID
				ORDER BY
					COMPANY_PARTNER.PARTNER_ID
			</cfquery>
			<cfset main_partner_list = listsort(listdeleteduplicates(valuelist(get_partner.partner_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif len(consumer_list)>
			<cfset consumer_list=listsort(consumer_list,"numeric","ASC",",")>
			<cfquery name="GET_CONSUMER" datasource="#DSN#">
				SELECT 
					CONSUMER_ID,
					CONSUMER_NAME,
					CONSUMER_SURNAME
				FROM
					CONSUMER 
				WHERE
					CONSUMER_ID IN (#consumer_list#)
				ORDER BY
					CONSUMER_ID			
			</cfquery>
			<cfset main_consumer_list = listsort(listdeleteduplicates(valuelist(get_consumer.consumer_id,',')),'numeric','ASC',',')>
		</cfif>
		<!--- <cfif len(employee_list)>
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
		</cfif> --->
		<cfif len(process_list)>
			<cfset process_list=listsort(process_list,"numeric","ASC",",")>
			<cfquery name="get_process_type" datasource="#dsn#">
				SELECT 
					STAGE,
					PROCESS_ROW_ID
				FROM
					PROCESS_TYPE_ROWS
				WHERE
					PROCESS_ROW_ID IN (#process_list#)
			</cfquery>
			<cfset main_process_list = listsort(listdeleteduplicates(valuelist(get_process_type.process_row_id,',')),'numeric','ASC',',')>
		</cfif> 
		<cfoutput query="get_subscription" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
				<td width="60"><a href="#request.self#?fuseaction=objects2.dsp_subscription&subscription_id=#get_subscription.subscription_id#" class="tableyazi">#subscription_no#</a></td>
				<td>#left(subscription_head,50)#</td>
				<td><cfif len(get_subscription.consumer_id)>
					#get_consumer.consumer_name[listfind(main_consumer_list,get_subscription.consumer_id,',')]#&nbsp;#get_consumer.consumer_surname[listfind(main_consumer_list,get_subscription.consumer_id,',')]#
				  <cfelseif len(get_subscription.partner_id)>
					#get_partner.nickname[listfind(main_partner_list,get_subscriptions.partner_id,',')]#
					#get_partner.company_partner_name[listfind(main_partner_list,get_subscription.partner_id,',')]#&nbsp;#get_partner.company_partner_surname[listfind(main_partner_list,get_subscription.partner_id,',')]#
				  </cfif>
				</td>
				<td>#subscription_type#</td>
				<td><cfif len(subscription_stage)>#get_process_type.STAGE[listfind(main_process_list,get_subscription.subscription_stage,',')]#</cfif></td> 
				<!--- <td>
				  <cfif len(get_subscription.sales_emp_id)>
					  <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_emp_det&emp_id=#get_subscription.sales_emp_id#','medium');" class="tableyazi">
						  #get_employee.employee_name[listfind(main_employee_list,get_subscription.sales_emp_id,',')]#&nbsp;#get_employee.employee_surname[listfind(main_employee_list,get_subscription.sales_emp_id,',')]#
					  </a>
				  </cfif>
				</td>
				<td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_emp_det&emp_id=#get_subscription.record_emp#','medium');" class="tableyazi">
						#get_employee.employee_name[listfind(main_employee_list,get_subscription.record_emp,',')]#&nbsp;#get_employee.employee_surname[listfind(main_employee_list,get_subscription.record_emp,',')]#
					</a>						
				</td> --->
				<td align="center"><a href="#request.self#?fuseaction=objects2.dsp_subscription&subscription_id=#get_subscription.subscription_id#"><img src="/images/update_list.gif" title="<cf_get_lang_main no='52.Güncelle'>" border="0" align="absmiddle"></a></td>
			</tr>
		</cfoutput>
	<cfelse>
		<tr class="color-row">
			<td colspan="8"><cfif isdefined("attributes.is_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz '> !</cfif></td>
		</tr>
	</cfif>
</table>
<cfif attributes.totalrecords gt attributes.maxrows>
  <table cellpadding="0" cellspacing="0" border="0" align="center" width="98%" height="30">
    <tr>
      <td> <cf_pages page="#attributes.page#"
			  maxrows="#attributes.maxrows#"
			  totalrecords="#attributes.totalrecords#"
			  startrow="#attributes.startrow#"
			  adres="objects2.list_subscription_ref&keyword=#attributes.keyword#&is_submited=1"> </td>
     <td align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'>:#get_subscription.recordcount#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
    </tr>
  </table>
</cfif>
