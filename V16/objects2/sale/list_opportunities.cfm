<cfparam name="attributes.opportunity_type_id" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.opp_status" default=1>
<cfparam name="attributes.sale_add_option" default="">
<cfparam name="attributes.opp_keyword" default="">
<cfset url_str = "">
<cfquery name="GET_OPP_CURRENCIES" datasource="#DSN3#">
	SELECT OPP_CURRENCY_ID,OPP_CURRENCY FROM OPPORTUNITY_CURRENCY ORDER BY OPP_CURRENCY
</cfquery>
<cfquery name="GET_OPPORTUNITY_TYPE" datasource="#DSN3#">
	SELECT OPPORTUNITY_TYPE_ID, OPPORTUNITY_TYPE FROM SETUP_OPPORTUNITY_TYPE WHERE IS_INTERNET = 1 ORDER BY OPPORTUNITY_TYPE
</cfquery>
<cfquery name="GET_SALE_ADD_OPTION" datasource="#DSN3#">
	SELECT SALES_ADD_OPTION_ID, SALES_ADD_OPTION_NAME FROM SETUP_SALES_ADD_OPTIONS WHERE IS_INTERNET = 1
</cfquery>
<cfif isdefined('attributes.form_submited')>
	<cfinclude template="../query/get_opportunities.cfm">	
<cfelse>
	<cfset get_opportunities.recordcount = 0>
</cfif>
<cfset opp_currency_list = valuelist(get_opp_currencies.opp_currency_id)>

<cfif len(attributes.opp_keyword)>
  	<cfset url_str = "#url_str#&opp_keyword=#attributes.opp_keyword#">
</cfif>
<cfset url_str = "#url_str#&opp_status=#attributes.opp_status#">
<cfif len(attributes.opportunity_type_id)>
  	<cfset url_str = "#url_str#&opportunity_type_id=#attributes.opportunity_type_id#">
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
<cfsavecontent variable="title"><cf_get_lang_main no='48.Filtre'></cfsavecontent>
<!--- Seçili olursa filtresiz ve başlıklsı kullanılabilir--->
<cfif isdefined('attributes.is_list_opp_filter') and attributes.is_list_opp_filter eq 1>
	<table cellspacing="1" cellpadding="2" align="center" style="width:98%">
		<form name="send_form" method="post" action="<cfoutput>#request.self#?fuseaction=objects2.form_upd_opportunity</cfoutput>">
			<input type="hidden" name="opp_id" id="opp_id" value="" />
		</form>
		<form name="send_form_display" method="post" action="<cfoutput>#request.self#?fuseaction=objects2.dsp_opportunity</cfoutput>">
			<input type="hidden" name="opp_id" id="opp_id" value="" />
		</form>
		<tr style="height:35px;">
			<td class="headbold"><cf_get_lang_main no='1282.Fırsatlar'></td>
			<td>
				<cfform name="list_opportunities" method="post" action="#request.self#?fuseaction=#attributes.fuseaction#">
                	<!-- sil -->
                	<input type="hidden" name="form_submited" id="form_submited" value="1" />
                    <table align="right">
                        <tr>
                            <td style="vertical-align:bottom;">
								<cf_get_lang_main no="48.Filtre">:
                      			<cfinput type="text" name="opp_keyword" id="opp_keyword" onChange="return percent()" value="#attributes.opp_keyword#" style="width:100px;">
                                <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lütfen Tarih Giriniz'></cfsavecontent>
                                <cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
                                <cf_wrk_date_image date_field="start_date">
                                
                                <cfsavecontent variable="message"><cf_get_lang_main no='1091.Lütfen Tarih Giriniz'></cfsavecontent>
                                <cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
                                <cf_wrk_date_image date_field="finish_date">
	                        </td>
                            <td style="vertical-align:bottom;">
                                <select name="opportunity_type_id" id="opportunity_type_id" style="width:120px;">
                                    <option value=""><cf_get_lang_main no='74.Kategori'></option>
                                    <cfoutput query="get_opportunity_type">
                                        <option value="#opportunity_type_id#">#opportunity_type#</option>
                                    </cfoutput>
                                </select>
                                <select name="opp_status" id="opp_status" style="width:50px;">
                                    <option value=""<cfif not len(attributes.opp_status)> selected</cfif>><cf_get_lang_main no='669.Hepsi'>
                                    <option value="1"<cfif attributes.opp_status eq 1> selected</cfif>><cf_get_lang_main no='81.Aktif'>
                                    <option value="0"<cfif attributes.opp_status eq 0> selected</cfif>><cf_get_lang_main no='82.Pasif'>
                                </select>
                            </td>
                            <td style="vertical-align:bottom;">
                                <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                                <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                                <cfif isdefined('attributes.is_select_opp_filter') and attributes.is_select_opp_filter eq 1>
                                    <cf_wrk_search_button search_function='search_keyword()'>
                                <cfelse>
                                    <cf_wrk_search_button>
                                </cfif> 
                        	</td>
                    	</tr>
                    </table>
                	<!-- sil -->
				</cfform>
			</td>
		</tr>
   	</table>
</cfif>
<table cellspacing="1" cellpadding="2" border="0" align="center" class="color-border" style="width:98%">
	<tr class="color-header" style="height:22px;">
		<td class="form-title" style="width:57px;"><cf_get_lang_main no='330.Tarih'></td>
		<td class="form-title"><cf_get_lang_main no='68.Başlık'></td>
        <td class="form-title" style="width:120px;"><cf_get_lang_main no='45.Müşteri'></td>
		<cfif isdefined("attributes.is_opp_sales_partner") and attributes.is_opp_sales_partner eq 1>
			<td class="form-title" style="width:100px;">
				<cfif isdefined("attributes.is_opp_view") and attributes.is_opp_view eq 1>
					<cf_get_lang no='457.Satış Çalışanı'>
				<cfelse>
					<cf_get_lang no='491.İş Ortağı'>
				</cfif>
			</td>
		</cfif>
		<td class="form-title" style="width:100px;"><cf_get_lang_main no='74.Kategori'></td>
        <td class="form-title" style="width:45px;"><cf_get_lang_main no='1240.Olasılık'></td>
        <td class="form-title" style="width:80px;"><cf_get_lang_main no='70.Aşama'></td>
		<td align="center" style="width:15px;"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=objects2.form_add_opportunity"><img src="/images/plus_square.gif" border="0"></a></td>
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
 		  	<cfset main_sales_pcode_list = listsort(listdeleteduplicates(valuelist(get_position_detail.employee_id,',')),'numeric','ASC',',')>
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
	  		<tr onmouseover="this.className='color-light';" onmouseout="this.className='color-row';" class="color-row" style="height:20px;">
				<td>
				  	<cfif len(opp_date)>
						#dateformat(date_add('h',session.pp.time_zone,opp_date),'dd/mm/yyyy')#
				  	<cfelse>
						#dateformat(date_add('h',session.pp.time_zone,record_date),'dd/mm/yyyy')#
					</cfif>
				</td>
				<td>
					<cfif isdefined("attributes.is_opp_detail") and attributes.is_opp_detail eq 0>
						#opp_head#
					<cfelse>
                        <cfif isdefined("attributes.is_opp_view") and attributes.is_opp_view eq 1>
							<a href="#request.self#?fuseaction=objects2.form_upd_opportunity&opp_id=#opp_id#" class="tableyazi">#opp_head#</a>
						<cfelse>
							<cfif (isdefined("attributes.is_opp_sales_partner_detail") and attributes.is_opp_sales_partner_detail eq 1) and (sales_partner_id eq session.pp.userid)>
								<a href="#request.self#?fuseaction=objects2.form_upd_opportunity&opp_id=#opp_id#" class="tableyazi">#opp_head#</a>
							<cfelse>
								<a href="#request.self#?fuseaction=objects2.dsp_opportunity&opp_id=#opp_id#" class="tableyazi">#opp_head#</a>
							</cfif>
						</cfif>
					</cfif>       
				</td>
				<td>
				  	<cfif len(partner_id)>
						#get_company_detail.fullname[listfind(main_company_id_list,get_opportunities.company_id,',')]# <!--- - #get_partner_detail.company_partner_name[listfind(main_partner_id_list,get_opportunities.partner_id,',')]# #get_partner_detail.company_partner_surname[listfind(main_partner_id_list,get_opportunities.partner_id,',')]#--->
				  	<cfelseif len(consumer_id)>
						#get_consumer_detail.consumer_name[listfind(main_consumer_id_list,get_opportunities.consumer_id,',')]# #get_consumer_detail.consumer_surname[listfind(main_consumer_id_list,get_opportunities.consumer_id,',')]#
				  	</cfif>
				</td>
				<cfif isdefined("attributes.is_opp_sales_partner") and attributes.is_opp_sales_partner eq 1>
					<td>
						<cfif  isdefined("attributes.is_opp_view") and attributes.is_opp_view eq 1>
							<cfif len(get_opportunities.sales_emp_id)>
								#get_position_detail.employee_name[listfind(main_sales_pcode_list,get_opportunities.sales_emp_id,',')]# #get_position_detail.employee_surname[listfind(main_sales_pcode_list,get_opportunities.sales_emp_id,',')]#
							<cfelseif len(get_opportunities.sales_partner_id)>
								#get_partner_detail.nickname[listfind(main_partner_id_list,get_opportunities.sales_partner_id,',')]#-#get_partner_detail.company_partner_name[listfind(main_partner_id_list,get_opportunities.sales_partner_id,',')]# #get_partner_detail.company_partner_surname[listfind(main_partner_id_list,get_opportunities.sales_partner_id,',')]#
							</cfif>
						<cfelse>
							#get_partner_detail.nickname[listfind(main_partner_id_list,get_opportunities.sales_partner_id,',')]#
						</cfif>
					</td>
				</cfif>
				<td>
				  	<cfif len(opportunity_type_id)>#get_opportunity_types.opportunity_type[listfind(main_opportunity_type_list,get_opportunities.opportunity_type_id,',')]#</cfif> 
				</td>
				<td align="center"><cfif len(probability)>% #probability#</cfif></td>
				<td>
				  	<cfif len(opp_currency_id)>
						<cfset counter = listfindnocase(opp_currency_list,opp_currency_id)>#get_opp_currencies.opp_currency[counter]#
				  	</cfif>
				</td>
				<td align="center">
					<cfif isdefined("attributes.is_opp_detail") and attributes.is_opp_detail eq 1>
                 		<a href="#request.self#?fuseaction=objects2.dsp_opportunity&opp_id=#opp_id#" class="tableyazi"><img src="/images/update_list.gif" border="0"></a>
					</cfif>
				</td>
			</tr>
		</cfoutput>
	<cfelse>
	  	<tr class="color-row" style="height:20px;">
			<td colspan="9"><cfif isdefined('attributes.form_submited')><cf_get_lang_main no='72.Kayıt Yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz '>!</cfif></td>
	  	</tr>
	</cfif>
</table>
<cfif get_opportunities.recordcount and (attributes.totalrecords gt attributes.maxrows)>
  	<table align="center" cellpadding="0" cellspacing="0" style="height:35px; width:98%">
    	<tr>
	  		<td colspan="3">
				<cf_pages page="#attributes.page#" 
			   		maxrows="#attributes.maxrows#" 
		  			totalrecords="#attributes.totalrecords#" 
			  		startrow="#attributes.startrow#" 
				 	adres="#attributes.fuseaction##url_str#&form_submited=1">
	  		</td>
	  		<td colspan="5" align="right" style="text-align:right;"><cfoutput><cf_get_lang_main no='128.Toplam Kayıt'> : #get_opportunities.recordcount# - <cf_get_lang_main no='169.Sayfa'> : #attributes.page#/#lastpage#</cfoutput></td>
		</tr>
  	</table>
</cfif>
<script type="text/javascript">
	function send_opp_id(opp_id,type_)
	{
		if(type_ == 1)
		{
			document.send_form.opp_id.value = opp_id;
			document.send_form.submit();
		}
		else
		{
			document.send_form_display.opp_id.value = opp_id;
			document.send_form_display.submit();
		}
		
	}
	
	function search_keyword()
	{
		if(document.getElementById('opp_keyword').value.length < 3)
		{
			alert("<cf_get_lang_main no='2152.En Az 3 Karakter Girmelisiniz'>");
			return false;
		}
		return true;
	}
	
	function percent()
	{   
		if(document.list_opportunities.opp_keyword.value.indexOf('%') != -1)
		{
			alert("<cf_get_lang_main no='224.Lütfen yüzde işareti (%) girmeyiniz!'>");
			document.getElementById('opp_keyword').value = '';
			return false;
		}
	}
</script>


