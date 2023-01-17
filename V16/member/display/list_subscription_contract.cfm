<cf_xml_page_edit>
<cfquery name="GET_SUBSCRIPTIONS" datasource="#DSN3#">
	SELECT 
		SC.SUBSCRIPTION_ID,
		SC.START_DATE,
		SC.SUBSCRIPTION_NO,
		SC.SUBSCRIPTION_HEAD,
		SC.SUBSCRIPTION_TYPE_ID,
		SST.SUBSCRIPTION_TYPE,
		SC.PARTNER_ID,
		SC.COMPANY_ID,
		SC.CONSUMER_ID,
		SC.IS_ACTIVE,
		SC.CANCEL_TYPE_ID,
		SC.CANCEL_DATE,
		SC.REF_COMPANY_ID,
		SC.REF_PARTNER_ID,
		SC.PROJECT_ID,
        SC.REFERANCE_STATUS_ID
	FROM 
		SUBSCRIPTION_CONTRACT SC,
		SETUP_SUBSCRIPTION_TYPE SST
	WHERE 
		SST.SUBSCRIPTION_TYPE_ID = SC.SUBSCRIPTION_TYPE_ID AND
	<cfif isDefined("attributes.project_id")><!--- proje detayından proje ilişkili sistemleri sadece görebilmek için --->
		SC.PROJECT_ID = #attributes.project_id#
	<cfelse>
		<cfif isdefined('attributes.cpid')>
			SC.COMPANY_ID = #attributes.cpid#
		<cfelse>
			SC.CONSUMER_ID = #attributes.cid#
		</cfif>
	</cfif>
</cfquery>
<cfif not isDefined("attributes.project_id")><!--- proje detayından gidildiğinde görülmeyecek --->
	<cfquery name="GET_REFERENCES" datasource="#DSN3#">
		SELECT 
			SC.SUBSCRIPTION_ID,
			SC.START_DATE,
			SC.SUBSCRIPTION_NO,
			SC.SUBSCRIPTION_HEAD,
			SC.SUBSCRIPTION_TYPE_ID,
			SST.SUBSCRIPTION_TYPE,
			SC.PARTNER_ID,
			SC.COMPANY_ID,
			SC.CONSUMER_ID,
			SC.IS_ACTIVE,
			SC.CANCEL_TYPE_ID,
			SC.CANCEL_DATE,
			SC.REF_COMPANY_ID,
			SC.REF_PARTNER_ID,
            SC.REFERANCE_STATUS_ID
		FROM 
			SUBSCRIPTION_CONTRACT SC,
			SETUP_SUBSCRIPTION_TYPE SST
		WHERE 
			SST.SUBSCRIPTION_TYPE_ID = SC.SUBSCRIPTION_TYPE_ID AND
		  <cfif isdefined('attributes.cpid')>
			SC.REF_COMPANY_ID = #attributes.cpid#
		  <cfelse>
			SC.REF_CONSUMER_ID = #attributes.cid#
		  </cfif>
	</cfquery>
</cfif>
<!--- sistem ekleme listesi icin eklenen form--->
<form name="add_subscription_contract" method="post" target="_blank" action="<cfoutput>#request.self#</cfoutput>?fuseaction=sales.list_subscription_contract&event=add">
	<cfoutput>
    <input type="hidden" name="project_id" id="project_id" value="<cfif isDefined("attributes.project_id")>#attributes.project_id#</cfif>">
    <cfif isDefined("attributes.project_id")>
        <cfquery name="GET_PROJECT" datasource="#DSN#">
            SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = #attributes.project_id#
        </cfquery>
    </cfif>
    <input type="hidden" name="project_name" id="project_name" value="<cfif isDefined("attributes.project_id")>#GET_PROJECT.PROJECT_HEAD#</cfif>">
  <cfif isdefined('attributes.cpid')>
	<input type="hidden" name="member_type" id="member_type" value="partner">
	<input type="hidden" name="company_id" id="company_id" value="#attributes.cpid#">
	<input type="hidden" name="company_name" id="company_name" value="#attributes.member_name#">
	<cfquery name="GET_PARTNER" datasource="#DSN#" maxrows="1">
		SELECT
			COMPANY_PARTNER_NAME,
			COMPANY_PARTNER_SURNAME,
			PARTNER_ID						
		FROM 
			COMPANY_PARTNER
		WHERE 
			COMPANY_ID = #attributes.cpid#
		ORDER BY
			PARTNER_ID
	</cfquery>
	<input type="hidden" name="partner_id" id="partner_id" value="#get_partner.partner_id#">
	<input type="hidden" name="member_name" id="member_name" value="#get_partner.company_partner_name# #get_partner.company_partner_surname#">
	<cfquery name="GET_COMP_ADDRESS" datasource="#DSN#">
		SELECT
			POS_CODE,
			COMPANY_ADDRESS,
			COMPANY_POSTCODE,
			SEMT,
			COUNTY,
			CITY,
			COUNTRY,
            COORDINATE_1,
            COORDINATE_2,
            SALES_COUNTY,
			FULLNAME
		FROM
			COMPANY
		WHERE
			COMPANY_ID = #attributes.cpid#
	</cfquery>
	<input type="hidden" name="address" id="address" value="#get_comp_address.company_address#">
	<input type="hidden" name="postcode" id="postcode" value="#get_comp_address.company_postcode#">
	<input type="hidden" name="semt" id="semt" value="#get_comp_address.semt#">
	<input type="hidden" name="county_id" id="county_id" value="#get_comp_address.county#">
	<input type="hidden" name="city_id" id="city_id" value="#get_comp_address.city#">
	<input type="hidden" name="country_id" id="country_id" value="#get_comp_address.country#">
    <input type="hidden" name="coordinate_1" id="coordinate_1" value="#get_comp_address.COORDINATE_1#">
	<input type="hidden" name="coordinate_2" id="coordinate_2" value="#get_comp_address.COORDINATE_2#">
    <input type="hidden" name="sz_id" id="sz_id" value="#get_comp_address.sales_county#">
	<cfif len(get_comp_address.county)>
		<cfquery name="GET_COUNTY" datasource="#DSN#">
			SELECT
				COUNTY_NAME
			FROM
				SETUP_COUNTY
			WHERE
				COUNTY_ID = #get_comp_address.county#
		</cfquery>
		<input type="hidden" name="county" id="county" value="#get_county.county_name#">
	</cfif>
	<cfif len(get_comp_address.city)>
		<cfquery name="GET_CITY" datasource="#DSN#">
			SELECT
				CITY_NAME
			FROM
				SETUP_CITY
			WHERE
				CITY_ID = #get_comp_address.city#		
		</cfquery>
		<input type="hidden" name="city" id="city" value="#get_city.city_name#">
	</cfif>
	<cfif len(get_comp_address.country)>
		<cfquery name="GET_COUNTRY" datasource="#DSN#">
			SELECT
				COUNTRY_NAME
			FROM
				SETUP_COUNTRY
			WHERE
				COUNTRY_ID = #get_comp_address.country#	
		</cfquery>
		<input type="hidden" name="country" id="country" value="#get_country.country_name#">
	</cfif>
	<cfif len(get_comp_address.pos_code)>
		<cfquery name="GET_EMP" datasource="#DSN#">
			SELECT
				EMPLOYEE_NAME,
				EMPLOYEE_SURNAME,
				EMPLOYEE_ID
			FROM
				EMPLOYEE_POSITIONS
			WHERE
				POSITION_CODE = #get_comp_address.pos_code#
		</cfquery>
		<input type="hidden" name="sales_emp_id" id="sales_emp_id" value="#get_emp.employee_id#">
		<input type="hidden" name="sales_emp" id="sales_emp" value="#get_emp.employee_name# #get_emp.employee_surname#">
	</cfif>
  <cfelse>
	<input type="hidden" name="member_type" id="member_type" value="consumer">
	<input type="hidden" name="consumer_id" id="consumer_id" value="#attributes.cid#">
	<input type="hidden" name="member_name" id="member_name" value="#attributes.member_name#">
  
	<cfquery name="GET_CON_ADDRESS" datasource="#DSN#">
		SELECT
			<!--- POS_CODE, --->
			WORKADDRESS,
			WORKPOSTCODE,
			WORKSEMT,
			WORK_COUNTY_ID,
			WORK_CITY_ID,
			WORK_COUNTRY_ID,
            COORDINATE_1,
            COORDINATE_2,
            SALES_COUNTY
		FROM
			CONSUMER
		WHERE
			CONSUMER_ID = #attributes.cid#
	</cfquery>  
  	<input type="hidden" name="address" id="address" value="#get_con_address.workaddress#">
	<input type="hidden" name="postcode" id="postcode" value="#get_con_address.workpostcode#">
	<input type="hidden" name="semt" id="semt" value="#get_con_address.worksemt#">
	<input type="hidden" name="county_id" id="county_id" value="#get_con_address.work_county_id#">
	<input type="hidden" name="city_id" id="city_id" value="#get_con_address.work_city_id#">
	<input type="hidden" name="country_id" id="country_id" value="#get_con_address.work_country_id#">
	<input type="hidden" name="coordinate_1" id="coordinate_1" value="#get_con_address.COORDINATE_1#">
	<input type="hidden" name="coordinate_2" id="coordinate_2" value="#get_con_address.COORDINATE_2#">
    <input type="hidden" name="sz_id" id="sz_id" value="#get_con_address.sales_county#">
	<cfif len(get_con_address.work_county_id)>
		<cfquery name="GET_COUNTY" datasource="#DSN#">
			SELECT
				COUNTY_NAME
			FROM
				SETUP_COUNTY
			WHERE
				COUNTY_ID = #get_con_address.work_county_id#
		</cfquery>
		<input type="hidden" name="county" id="county" value="<cfoutput>#get_county.county_name#</cfoutput>">
	</cfif>
	<cfif len(get_con_address.work_city_id)>
		<cfquery name="GET_CITY" datasource="#DSN#">
			SELECT
				CITY_NAME
			FROM
				SETUP_CITY
			WHERE
				CITY_ID = #get_con_address.work_city_id#		
		</cfquery>
		<input type="hidden" name="city" id="city" value="#get_city.city_name#">
	</cfif>
	<cfif len(get_con_address.work_country_id)>
		<cfquery name="GET_COUNTRY" datasource="#DSN#">
			SELECT
				COUNTRY_NAME
			FROM
				SETUP_COUNTRY
			WHERE
				COUNTRY_ID = #get_con_address.work_country_id#	
		</cfquery>
		<input type="hidden" name="country" id="country" value="#get_country.country_name#">
	</cfif>
  </cfif>
  </cfoutput> 
</form>
<cfsavecontent variable="Fullname">
	<cfoutput>
		<cfif len(attributes.member_name)>
			#attributes.member_name#
			
		<cfelse>
				#get_comp_address.fullname#
		</cfif>
	</cfoutput>
	</cfsavecontent>
	<cf_box title="#getLang('','Abone',58832)# : #Fullname#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_seperator id="subscription_sep" title="#getLang('','Aboneler',30003)#">
		<cf_grid_list id="subscription_sep">
			<thead>
				<tr>
					<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
					<th width="100"><cf_get_lang dictionary_id='57457.Müşteri'></th>
					<th><cf_get_lang dictionary_id='57747.Sözleşme Tarihi'></th>
					<th><cf_get_lang dictionary_id='58233.Tanım'></th>
					<th><cf_get_lang dictionary_id='57756.Durum'></th>
					<th><cf_get_lang dictionary_id='58825.İptal Nedeni'></th>
					<th><cf_get_lang dictionary_id='57748.İptal Tarihi'></th>
					<th><cf_get_lang dictionary_id='57486.Kategori'></th>
					<cfif is_payment_plan>
						<th><cf_get_lang dictionary_id="39253.Ödeme Planı Başlangıç Tarihi"></th>
						<th><cf_get_lang dictionary_id="35618.Ödeme Bilgisi"></th>
					</cfif>
					<cfif is_referance_status>
						<th><cf_get_lang dictionary_id="59660.Referans Durumu"></th>
					</cfif>
					<th width="20">
						<cfif get_module_user(11) and not listfindnocase(denied_pages,'sales.list_subscription_contract&event=add')>
							<a name="contract_submit" id="contract_submit"  href="javascript://" onClick="add_subscription_contract.submit();"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='30284.Abone Ekle'>" border="0"></i></a>
						</cfif>
					</th>
				</tr>
			</thead>
			<tbody>
				<cfif get_subscriptions.recordcount>
					<cfset partner_id_list=''>
					<cfset company_id_list=''> 
					<cfset consumer_id_list=''>
					<cfset cancel_type_id_list=''>
				<cfoutput query="get_subscriptions">
				<cfif len(partner_id) and not listfind(partner_id_list,partner_id)>
					<cfset partner_id_list=listappend(partner_id_list,partner_id)>
				</cfif>
				<cfif len(company_id) and not listfind(company_id_list,company_id)>
					<cfset company_id_list=listappend(company_id_list,company_id)>
				</cfif> 
				<cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
					<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
				</cfif>
				<cfif len(cancel_type_id) and not listfind(cancel_type_id_list,cancel_type_id)>
					<cfset cancel_type_id_list=listappend(cancel_type_id_list,cancel_type_id)>
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
				<cfif listlen(cancel_type_id_list)>
				<cfset cancel_type_id_list = listsort(cancel_type_id_list,"numeric","ASC",",")>
				<cfquery name="GET_SUBSCRIPTION_CANCEL_TYPE" datasource="#DSN3#">
					SELECT
						SUBSCRIPTION_CANCEL_TYPE_ID,
						SUBSCRIPTION_CANCEL_TYPE
					FROM 
						SETUP_SUBSCRIPTION_CANCEL_TYPE
					WHERE
						SUBSCRIPTION_CANCEL_TYPE_ID IN (#cancel_type_id_list#)
					ORDER BY
						SUBSCRIPTION_CANCEL_TYPE_ID
				</cfquery>
				<cfset main_cancel_type_id_list = listsort(listdeleteduplicates(valuelist(GET_SUBSCRIPTION_CANCEL_TYPE.SUBSCRIPTION_CANCEL_TYPE_ID,',')),'numeric','ASC',',')>
				</cfif>
				<cfoutput query="get_subscriptions">
				<tr>
					<td><a href="#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#subscription_id#" target="_blank">#subscription_no#</a></td>
					<td>
					<cfif len(partner_id)><!--- burdaki şirket isimleri vs yeniden yazılıyor cunku proje detayından farklı düzenlemeler var --->
						#get_company_detail.fullname[listfind(main_company_id_list,get_subscriptions.company_id,',')]#<!--- #attributes.member_name# -  --->#get_partner_detail.company_partner_name[listfind(main_partner_id_list,get_subscriptions.partner_id,',')]# #get_partner_detail.company_partner_surname[listfind(main_partner_id_list,get_subscriptions.partner_id,',')]#
					<cfelseif len(consumer_id)>
						#get_consumer_detail.consumer_name[listfind(main_consumer_id_list,get_subscriptions.consumer_id,',')]#&nbsp;#get_consumer_detail.consumer_surname[listfind(main_consumer_id_list,get_subscriptions.consumer_id,',')]#<!--- #attributes.member_name# --->
					</cfif>
					</td>
					<td><a href="#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#subscription_id#" target="_blank"><cfif len(start_date)>#dateformat(start_date,dateformat_style)#</cfif></a></td>
					<td>#subscription_head#</td>
					<td><cfif is_active eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
					<td><cfif len(cancel_type_id)>#get_subscription_cancel_type.subscription_cancel_type[listfind(main_cancel_type_id_list,get_subscriptions.cancel_type_id,',')]#</cfif></td>
					<td><cfif len(cancel_date)>#dateformat(cancel_date,dateformat_style)#</cfif></td>
					<td>#subscription_type#</td>
					<cfif is_payment_plan>
						<td>
							<cfquery name="get_payment_info" datasource="#dsn3#" maxrows="1">
								SELECT IS_PAID,PAYMENT_DATE FROM SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE IS_ACTIVE = 1 AND SUBSCRIPTION_ID = #SUBSCRIPTION_ID# ORDER BY PAYMENT_DATE
							</cfquery>
							<cfif get_payment_info.recordcount>
								#dateformat(dateadd('h',session.ep.time_zone,get_payment_info.payment_date),dateformat_style)#
							</cfif>
						</td>
						<td>
							<cfif get_payment_info.recordcount>
								<cfif get_payment_info.is_paid eq 1><cf_get_lang dictionary_id='41117.Ödendi'><cfelseif get_payment_info.is_paid eq 0><font color="##FF0000"><cf_get_lang dictionary_id='54547.Ödenmedi'></font></cfif>
							</cfif>
						</td>
					</cfif>
					<cfif is_referance_status>
						<td>
							<cfif len(REFERANCE_STATUS_ID)>
								<cfquery name="get_ref_state" datasource="#dsn3#">
									SELECT REFERANCE_STATUS FROM SETUP_REFERANCE_STATUS WHERE REFERANCE_STATUS_ID = #REFERANCE_STATUS_ID#
								</cfquery>
								<cfif get_ref_state.recordcount>
									#get_ref_state.referance_status#
								</cfif>
							</cfif>
						</td>
					</cfif>
					<td></td>
				</tr>
				</cfoutput>
				<cfelse>
				<tr>
					<td colspan="12"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif not isDefined("attributes.project_id")>
			<cf_seperator id="ref_subscription_sep" title="#getLang('','Referans Olunan Aboneler',30353)#">
			<cf_grid_list id="ref_subscription_sep">
				<thead>
					<tr>
						<th width="30"><cf_get_lang dictionary_id='57487.No'></th>
						<th width="100"><cf_get_lang dictionary_id='57457.Müşteri'></th>
						<th><cf_get_lang dictionary_id='57747.Sözleşme Tarihi'></th>
						<th><cf_get_lang dictionary_id='58233.Tanım'></th>
						<th><cf_get_lang dictionary_id='57756.Durum'></th>
						<th><cf_get_lang dictionary_id='58825.İptal Nedeni'></th>
						<th><cf_get_lang dictionary_id='57748.İptal Tarihi'></th>
						<th><cf_get_lang dictionary_id='57486.Kategori'></th>
						<cfif is_payment_plan>
							<th><cf_get_lang dictionary_id='39253.Ödeme Planı Başlangıç Tarihi'></th>
							<th><cf_get_lang dictionary_id='35618.Ödeme Bilgisi'></th>
						</cfif>
						<cfif is_referance_status>
							<th><cf_get_lang dictionary_id='59660.Referans Durumu'></th>
						</cfif>
					</tr>
				</thead>
				<tbody>
					<cfif get_references.recordcount>
						<cfset company_id_list2=''> 
						<cfset consumer_id_list2=''>
						<cfset cancel_type_id_list2=''>
					<cfoutput query="get_references">
						<cfif len(company_id) and not listfind(company_id_list2,company_id)>
							<cfset company_id_list2=listappend(company_id_list2,company_id)>
						</cfif> 
						<cfif len(consumer_id) and not listfind(consumer_id_list2,consumer_id)>
							<cfset consumer_id_list2=listappend(consumer_id_list2,consumer_id)>
						</cfif>
						<cfif len(cancel_type_id) and not listfind(cancel_type_id_list2,cancel_type_id)>
							<cfset cancel_type_id_list2=listappend(cancel_type_id_list2,cancel_type_id)>
						</cfif>
					</cfoutput>
					<cfif listlen(company_id_list2)>
						<cfset company_id_list2 = listsort(company_id_list2,"numeric","ASC",",")>
							<cfquery name="GET_COMPANY_DETAIL2" datasource="#DSN#">
								SELECT
									COMPANY_ID,
									NICKNAME,
									FULLNAME
								FROM
									COMPANY
								WHERE
									COMPANY_ID IN (#company_id_list2#)
								ORDER BY
									COMPANY_ID
							</cfquery>
						<cfset main_company_id_list2 = listsort(listdeleteduplicates(valuelist(get_company_detail2.company_id,',')),'numeric','ASC',',')>
					</cfif> 
					<cfif listlen(consumer_id_list2)>
						<cfset consumer_id_list2 = listsort(consumer_id_list2,"numeric","ASC",",")>
							<cfquery name="GET_CONSUMER_DETAIL2" datasource="#DSN#">
								SELECT 
									CONSUMER_ID,
									CONSUMER_NAME,
									CONSUMER_SURNAME
								FROM
									CONSUMER
								WHERE
									CONSUMER_ID IN (#consumer_id_list2#)
								ORDER BY
									CONSUMER_ID
							</cfquery>
						<cfset main_consumer_id_list2 = listsort(listdeleteduplicates(valuelist(get_consumer_detail2.consumer_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif listlen(cancel_type_id_list2)>
						<cfset cancel_type_id_list2 = listsort(cancel_type_id_list2,"numeric","ASC",",")>
							<cfquery name="GET_SUBSCRIPTION_CANCEL_TYPE2" datasource="#DSN3#">
								SELECT
									SUBSCRIPTION_CANCEL_TYPE_ID,
									SUBSCRIPTION_CANCEL_TYPE
								FROM 
									SETUP_SUBSCRIPTION_CANCEL_TYPE
								WHERE
									SUBSCRIPTION_CANCEL_TYPE_ID IN (#cancel_type_id_list2#)
								ORDER BY
									SUBSCRIPTION_CANCEL_TYPE_ID
							</cfquery>
						<cfset main_cancel_type_id_list2 = listsort(listdeleteduplicates(valuelist(GET_SUBSCRIPTION_CANCEL_TYPE2.SUBSCRIPTION_CANCEL_TYPE_ID,',')),'numeric','ASC',',')>
					</cfif>
					<cfoutput query="get_references">
						<tr>
							<td><a href="#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#subscription_id#" class="tableyazi" target="_blank">#subscription_no#</a></td>
							<td>
							<cfif len(company_id)>
								#get_company_detail2.fullname[listfind(main_company_id_list2,get_references.company_id,',')]# 
							<cfelseif len(consumer_id)>
								#get_consumer_detail2.consumer_name[listfind(main_consumer_id_list2,get_references.consumer_id,',')]# #get_consumer_detail2.consumer_surname[listfind(main_consumer_id_list2,get_references.consumer_id,',')]#
							</cfif>
							</td>
							<td><a href="#request.self#?fuseaction=sales.list_subscription_contract&event=upd&subscription_id=#subscription_id#" class="tableyazi" target="_blank"><cfif len(start_date)>#dateformat(start_date,dateformat_style)#</cfif></a></td>
							<td>#subscription_head#</td>
							<td><cfif is_active eq 0><cf_get_lang dictionary_id='57494.Pasif'><cfelse><cf_get_lang dictionary_id='57493.Aktif'></cfif></td>
							<td><cfif len(cancel_type_id)>#get_subscription_cancel_type2.subscription_cancel_type[listfind(main_cancel_type_id_list2,get_references.cancel_type_id,',')]#</cfif></td>
							<td><cfif len(cancel_date)>#dateformat(cancel_date,dateformat_style)#</cfif></td>
							<td>#subscription_type#</td>
							<cfif is_payment_plan>
								<td>
									<cfquery name="get_payment_info" datasource="#dsn3#" maxrows="1">
										SELECT IS_PAID,PAYMENT_DATE FROM SUBSCRIPTION_PAYMENT_PLAN_ROW WHERE IS_ACTIVE = 1 AND SUBSCRIPTION_ID = #SUBSCRIPTION_ID# ORDER BY PAYMENT_DATE
									</cfquery>
									<cfif get_payment_info.recordcount>
										#dateformat(dateadd('h',session.ep.time_zone,get_payment_info.payment_date),dateformat_style)#
									</cfif>
								</td>
								<td>
									<cfif get_payment_info.recordcount>
										<cfif get_payment_info.is_paid eq 1><cf_get_lang dictionary_id='54548.Ödendi'><cfelseif get_payment_info.is_paid eq 0><font color="##FF0000"><cf_get_lang dictionary_id='54547.Ödenmedi'></font></cfif>
									</cfif>
								</td>
							</cfif>
							<cfif is_referance_status>
								<td>
									<cfif len(REFERANCE_STATUS_ID)>
										<cfquery name="get_ref_state" datasource="#dsn3#">
											SELECT REFERANCE_STATUS FROM SETUP_REFERANCE_STATUS WHERE REFERANCE_STATUS_ID = #REFERANCE_STATUS_ID#
										</cfquery>
										<cfif get_ref_state.recordcount>
											#get_ref_state.referance_status#
										</cfif>
									</cfif>
								</td>
							</cfif>
						</tr>
					</cfoutput>
					<cfelse>
						<tr>
							<td colspan="12"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
						</tr>
					</cfif>
				</tbody>
			</cf_grid_list>
		</cfif>
	</cf_box>
