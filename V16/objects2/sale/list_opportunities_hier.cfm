<cfinclude template="../query/get_emps_pars_cons.cfm">
<cfif isdefined("session.pp.userid")>
	<cfquery name="get_comp_hier" datasource="#dsn#">
		SELECT COMPANY_ID,FULLNAME FROM COMPANY WHERE HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
	</cfquery>
	<cfset list_comp_hier = ''>
	<cfoutput query="get_comp_hier">
		<cfif len(company_id) and not listfind(list_comp_hier,company_id)>
			<cfset list_comp_hier = Listappend(list_comp_hier,company_id)>
		</cfif>
	</cfoutput>
</cfif>
<cfparam name="attributes.opportunity_type_id" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.opp_status" default=1>
<cfparam name="attributes.opp_currency_id" default="">
<cfparam name="attributes.sales_emp" default="">
<cfparam name="attributes.keyword" default="">
<cfset url_str = "">
<cfquery name="GET_OPP_CURRENCIES" datasource="#dsn3#">
	SELECT * FROM OPPORTUNITY_CURRENCY ORDER BY OPP_CURRENCY
</cfquery>
<cfquery name="GET_OPPORTUNITY_TYPE" datasource="#DSN3#">
	SELECT OPPORTUNITY_TYPE_ID,OPPORTUNITY_TYPE FROM SETUP_OPPORTUNITY_TYPE WHERE IS_INTERNET = 1 ORDER BY OPPORTUNITY_TYPE
</cfquery>
<cfquery name="GET_SALE_ADD_OPTION" datasource="#DSN3#">
	SELECT SALES_ADD_OPTION_ID, SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS WHERE IS_INTERNET = 1
</cfquery>
 <cfif isdefined("attributes.start_date") and len(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
 <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>
	<cfif len(list_comp_hier)>
	<cfquery name="GET_OPPORTUNITIES" datasource="#DSN3#" cachedwithin="#fusebox.general_cached_time#">
		SELECT
			OPPORTUNITIES.OPP_NO,
			OPPORTUNITIES.OPP_CURRENCY_ID,
			OPPORTUNITIES.CONSUMER_ID,
			OPPORTUNITIES.PARTNER_ID,
			OPPORTUNITIES.OPP_HEAD,
			OPPORTUNITIES.OPP_DATE,
			OPPORTUNITIES.PROBABILITY,
			OPPORTUNITIES.INCOME,
			OPPORTUNITIES.SALES_EMP_ID,
			OPPORTUNITIES.SALES_PARTNER_ID,
			OPPORTUNITIES.RECORD_DATE,
			OPPORTUNITIES.OPP_ID,
			OPPORTUNITIES.STOCK_ID,
			OPPORTUNITIES.PRODUCT_CAT_ID,
			OPPORTUNITIES.COMPANY_ID,
			OPPORTUNITIES.OPPORTUNITY_TYPE_ID,
			OPPORTUNITIES.UPDATE_DATE
		FROM
			OPPORTUNITIES
		WHERE
			OPPORTUNITIES.OPP_ID IS NOT NULL AND
			OPPORTUNITIES.COMPANY_ID IN (#list_comp_hier#) AND 
	        OPPORTUNITIES.OPPORTUNITY_TYPE_ID IN (SELECT OPPORTUNITY_TYPE_ID FROM SETUP_OPPORTUNITY_TYPE WHERE IS_INTERNET = 1)
			<cfif isdefined('attributes.company_id') and len(attributes.company_id)>
				AND OPPORTUNITIES.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
			</cfif>
			<cfif isdefined("attributes.opp_status") and len(attributes.opp_status)>
				AND OPPORTUNITIES.OPP_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opp_status#">
			</cfif>
			<cfif len(attributes.keyword)>
				AND 
				(
					OPPORTUNITIES.OPP_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					OPPORTUNITIES.OPP_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">
				)
			</cfif>
			<cfif isdefined('attributes.opp_currency_id') and len(attributes.opp_currency_id)> 
				AND OPPORTUNITIES.OPP_CURRENCY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opp_currency_id#">
			</cfif>
			<cfif isdefined('attributes.sales_emp') and len(attributes.sales_emp)> 
				AND OPPORTUNITIES.SALES_EMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_emp#">
			</cfif>
			<cfif isdefined("attributes.opportunity_type_id") and len(attributes.opportunity_type_id)>
				AND OPPORTUNITIES.OPPORTUNITY_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.opportunity_type_id#">
			</cfif>
			<cfif isdefined("attributes.start_date") and len(attributes.start_date)>AND OPPORTUNITIES.OPP_DATE >= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.start_date#"></cfif>
			<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>AND OPPORTUNITIES.OPP_DATE <= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.finish_date#"></cfif>
		ORDER BY
			RECORD_DATE DESC
	</cfquery>
	<cfelse>
		<cfset GET_OPPORTUNITIES.recordcount = 0>
	</cfif>
<cfset opp_currency_list = valuelist(GET_OPP_CURRENCIES.OPP_CURRENCY_ID)>
<cfset url_str = "#url_str#&is_filtre=1">

<cfif len(attributes.keyword)>
  <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfset url_str = "#url_str#&opp_status=#attributes.opp_status#">
<cfif len(attributes.opportunity_type_id)>
  <cfset url_str = "#url_str#&opportunity_type_id=#attributes.opportunity_type_id#">
</cfif>
<cfif len(attributes.opp_currency_id)>
  <cfset url_str = "#url_str#&opp_currency_id=#attributes.opp_currency_id#">
</cfif>
<cfif len(attributes.sales_emp)>
  <cfset url_str = "#url_str#&sales_emp=#attributes.sales_emp#">
</cfif>
<cfif isdate(attributes.start_date)>
	<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#" >
</cfif>
<cfif isdate(attributes.finish_date)>
	<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#" >
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_opportunities.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<form name="send_form" method="post" action="<cfoutput>#request.self#?fuseaction=objects2.form_upd_opportunity</cfoutput>">
	<input type="hidden" name="opp_id" id="opp_id" value="" />
</form>
  <tr>
    <td height="35" align="right" valign="bottom" class="headbold" style="text-align:right;">
    <table>
    <cfform name="list_opportunities" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
	  <tr>
		<td><cf_get_lang_main no='48.Filtre'> : </td>
		<td align="right"><cfinput type="text" name="keyword" value="#attributes.keyword#" style="width:100px;"></td>
		<td colspan="9" style="text-align:right;">
			<select name="sales_emp" id="sales_emp" style="width:120px;">
				<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
				<cfoutput query="get_emps_pars_cons">
				<cfif type eq 1>
					<option value="#uye_id#" <cfif uye_id eq attributes.sales_emp>selected</cfif>>#uye_name# #uye_surname#</option>
				</cfif>
				</cfoutput>
			</select>
			<select name="opp_currency_id" id="opp_currency_id" style=" width:120px;">
				<option value="">Aşama</option>
				<cfoutput query="GET_OPP_CURRENCIES">
					<option value="#OPP_CURRENCY_ID#"<cfif attributes.opp_currency_id eq opp_currency_id>selected</cfif>>#OPP_CURRENCY#</option>
				</cfoutput>
			</select>
			<select name="opportunity_type_id" id="opportunity_type_id" style="width:120px;">
				<option value=""><cf_get_lang_main no='74.Kategori'></option>
			<cfoutput query="get_opportunity_type">
				<option value="#opportunity_type_id#"<cfif attributes.opportunity_type_id eq opportunity_type_id>selected</cfif>>#opportunity_type#</option>
			</cfoutput>
			</select>
		   <select name="opp_status" id="opp_status">
				<option value=""<cfif not len(attributes.opp_status)> selected</cfif>><cf_get_lang_main no='669.Hepsi'>
				<option value="1"<cfif attributes.opp_status eq 1> selected</cfif>><cf_get_lang_main no='81.Aktif'>
				<option value="0"<cfif attributes.opp_status eq 0> selected</cfif>><cf_get_lang_main no='82.Pasif'>
			</select>
		  <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lütfen Tarih Giriniz'></cfsavecontent>
		  <cfinput type="text" name="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
		  <cf_wrk_date_image date_field="start_date">
			
		  <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lütfen Tarih Giriniz'></cfsavecontent>
		  <cfinput type="text" name="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
		  <cf_wrk_date_image date_field="finish_date">
		</td>
		<td align="right">
		  <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
		  <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
		</td>
		<td valign="middle" align="right"><cf_wrk_search_button></td> 
	  </tr>
	  </cfform>
	</table>
    </td>
  </tr>
</table>
	<table cellspacing="1" cellpadding="2" width="100%" border="0" align="center">
	  <tr class="color-header">
		<td class="form-title" width="57"><cf_get_lang_main no='330.Tarih'></td>
		<td class="form-title"><cf_get_lang_main no='68.Baslik'></td>
        <td class="form-title" width="120"><cf_get_lang_main no='45.Müsteri'></td>
        <td class="form-title" width="120"><cf_get_lang no='457.Satis Çalisani'></td>
		<td class="form-title" width="100"><cf_get_lang_main no='74.Kategori'></td>
        <td class="form-title" width="45"><cf_get_lang_main no='1240.Olasilik'></td>
        <td class="form-title" width="80"><cf_get_lang_main no='70.Asama'></td>
		<td width="15"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.form_add_opportunity"><img src="/images/plus_square.gif" border="0"></a></td>
	  </tr>
      <cfif get_opportunities.recordcount>
		<cfset counter1 = 1>
		<cfset partner_id_list=''>
		<cfset company_id_list=''>
		<cfset consumer_id_list=''>
		<cfset sales_pcode_list=''>
		<cfset opportunity_type_list = ''>
		<cfoutput query="get_opportunities" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		  <cfif len(partner_id) and not listfind(partner_id_list,partner_id)>
			<cfset partner_id_list=listappend(partner_id_list,partner_id)>
		  </cfif>
		  <cfif len(company_id) and not listfind(company_id_list,company_id)>
			<cfset company_id_list=listappend(company_id_list,company_id)>
		  </cfif>
		  <cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
			<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
		  </cfif>
		  <cfif len(sales_emp_id) and not listfind(sales_pcode_list,sales_emp_id)>
			<cfset sales_pcode_list=listappend(sales_pcode_list,sales_emp_id)>
		  </cfif>
		 <cfif len(sales_partner_id) and not listfind(partner_id_list,sales_partner_id)>
			<cfset partner_id_list=listappend(partner_id_list,sales_partner_id)>
		  </cfif> 
		  <cfif len(opportunity_type_id) and not listFindnocase(opportunity_type_list,opportunity_type_id,',')>
			<cfset opportunity_type_list = listAppend(opportunity_type_list,opportunity_type_id)>
		  </cfif>
		</cfoutput>
		<cfif listlen(partner_id_list)>
		  <cfset partner_id_list = listsort(partner_id_list,"numeric","ASC",",")>	
		  <cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
			SELECT
				CP.COMPANY_PARTNER_NAME,
				CP.COMPANY_PARTNER_SURNAME,
				CP.PARTNER_ID,						
				C.FULLNAME,
				C.NICKNAME
			FROM 
				COMPANY_PARTNER CP,
				COMPANY C
			WHERE 
				CP.PARTNER_ID IN (#partner_id_list#) AND
				CP.COMPANY_ID = C.COMPANY_ID
			ORDER BY
				CP.PARTNER_ID				
		  </cfquery>
		  <cfset main_partner_id_list = listsort(listdeleteduplicates(valuelist(get_partner_detail.partner_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif listlen(company_id_list)>
		  <cfset company_id_list = listsort(company_id_list,"numeric","ASC",",")>
		  <cfquery name="GET_COMPANY_DETAIL" datasource="#DSN#">
			SELECT
				COMPANY_ID,
				NICKNAME,
				FULLNAME
			FROM
				COMPANY
			WHERE
				COMPANY_ID IN (#company_id_list#)
			ORDER BY
				COMPANY_ID
		  </cfquery>
		  <cfset main_company_id_list = listsort(listdeleteduplicates(valuelist(get_company_detail.company_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif listlen(consumer_id_list)>
		  <cfset consumer_id_list = listsort(consumer_id_list,"numeric","ASC",",")>
		  <cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
			SELECT 
				CONSUMER_ID,
				CONSUMER_NAME,
				CONSUMER_SURNAME
			FROM
				CONSUMER
			WHERE
				CONSUMER_ID IN (#consumer_id_list#)
			ORDER BY
				CONSUMER_ID
		  </cfquery>
		  <cfset main_consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
		</cfif>
		<cfif listlen(sales_pcode_list)>
		  <cfset sales_pcode_list = listsort(sales_pcode_list,"numeric","ASC",",")>
		  <cfquery name="GET_POSITION_DETAIL" datasource="#DSN#">
			SELECT
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME,
				EMPLOYEE_ID
			FROM
				EMPLOYEES
			WHERE
				EMPLOYEE_ID IN (#sales_pcode_list#)
			ORDER BY
				EMPLOYEE_ID
		  </cfquery>
 		  <cfset main_sales_pcode_list = listsort(listdeleteduplicates(valuelist(get_position_detail.EMPLOYEE_ID,',')),'numeric','ASC',',')>
		</cfif>
		<cfif listlen(opportunity_type_list)>
		  <cfset opportunity_type_list = listsort(opportunity_type_list,"numeric","ASC",",")>
		  <cfquery name="GET_OPPORTUNITY_TYPES" datasource="#DSN3#">
			SELECT
				OPPORTUNITY_TYPE_ID,
				OPPORTUNITY_TYPE
			FROM
				SETUP_OPPORTUNITY_TYPE
			WHERE
				OPPORTUNITY_TYPE_ID IN (#opportunity_type_list#)
			ORDER BY
				OPPORTUNITY_TYPE_ID
		  </cfquery>
 		  <cfset main_opportunity_type_list = listsort(listdeleteduplicates(valuelist(get_opportunity_types.opportunity_type_id,',')),'numeric','ASC',',')>
		</cfif>
	<cfoutput query="get_opportunities" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
	  <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
		<td height="20">
		  <cfif len(opp_date)>
		  	#dateformat(date_add('h',session.pp.time_zone,opp_date),'dd/mm/yyyy')#
		  <cfelse>
		  	#dateformat(date_add('h',session.pp.time_zone,record_date),'dd/mm/yyyy')#
		  </cfif>
		</td>
        <td><a href="##" onclick="javascript:send_opp_id(#opp_id#);" class="tableyazi">#opp_head#</a></td>
        <td>
		  <cfif len(partner_id)>
		    #get_company_detail.fullname[listfind(main_company_id_list,get_opportunities.company_id,',')]# - #get_partner_detail.company_partner_name[listfind(main_partner_id_list,get_opportunities.partner_id,',')]# #get_partner_detail.company_partner_surname[listfind(main_partner_id_list,get_opportunities.partner_id,',')]#
		  <cfelseif len(consumer_id)>
		    #get_consumer_detail.consumer_name[listfind(main_consumer_id_list,get_opportunities.consumer_id,',')]# #get_consumer_detail.consumer_surname[listfind(main_consumer_id_list,get_opportunities.consumer_id,',')]#
		  </cfif>
		</td>
        <td>
		 <cfif len(get_opportunities.sales_emp_id)>#get_position_detail.employee_name[listfind(main_sales_pcode_list,get_opportunities.sales_emp_id,',')]# #get_position_detail.employee_surname[listfind(main_sales_pcode_list,get_opportunities.sales_emp_id,',')]# <!--- #get_sale_emp_name.employee_name# #get_sale_emp_name.employee_surname# --->
   		  <cfelseif len(get_opportunities.sales_partner_id)>#get_partner_detail.company_partner_name[listfind(main_partner_id_list,get_opportunities.sales_partner_id,',')]# #get_partner_detail.company_partner_surname[listfind(main_partner_id_list,get_opportunities.sales_partner_id,',')]#<!--- #get_sales_partner_name.company_partner_name# #get_sales_partner_name.company_partner_surname# --->
          </cfif>
		</td>
		<td>
		  <cfif len(opportunity_type_id)>#get_opportunity_types.opportunity_type[listfind(main_opportunity_type_list,get_opportunities.opportunity_type_id,',')]#</cfif> 
		</td>
        <td align="center"><cfif len(probability)>% #probability#</cfif></td>
        <td>
		  <cfif len(opp_currency_id)>
         	<cfset counter = listfindnocase(opp_currency_list,opp_currency_id)>#get_opp_currencies.opp_currency[counter]#
		  </cfif>
		</td>
		<td width="15" align="center"><a href="##" onclick="javascript:send_opp_id(#opp_id#);" class="tableyazi"><img src="/images/update_list.gif" border="0"></a></td>
	  </tr>
	</cfoutput>
    <cfelse>
	  <tr class="color-row" height="20">
     	<td colspan="9"><cf_get_lang_main no='72.Kayit Yok'>!</td>
      </tr>
    </cfif>
	</table>
<cfif get_opportunities.recordcount and (attributes.totalrecords gt attributes.maxrows)>
  <table width="98%" align="center" height="35" cellpadding="0" cellspacing="0">
    <tr>
	  <td colspan="3">
		<cf_pages page="#attributes.page#" 
			   maxrows="#attributes.maxrows#" 
		  totalrecords="#attributes.totalrecords#" 
			  startrow="#attributes.startrow#" 
				 adres="#attributes.fuseaction##url_str#">
	  </td>
	  <td colspan="5" align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayit'> : #get_opportunities.recordcount# - <cf_get_lang_main no='169.Sayfa'> : #attributes.page#/#lastpage#</cfoutput></td>
	</tr>
  </table>
</cfif>
<script type="text/javascript">
document.getElementById('keyword').focus();
function send_opp_id(opp_id)
{
	document.send_form.opp_id.value = opp_id;
	document.send_form.submit();
}
</script>
