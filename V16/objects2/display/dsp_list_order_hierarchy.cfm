<cfinclude template="../login/send_login.cfm">
<cfif not isdefined("session_base.userid")><cfexit method="exittemplate"></cfif>
<cfparam name="attributes.currency_id" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.zone" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>

<!--- BK 20070521 UPS Kargo linki icin duzenlendi --->
<cfquery name="GET_OUR_COMPANY_INFO" datasource="#DSN#">
	SELECT CARGO_CUSTOMER_CODE FROM OUR_COMPANY_INFO WHERE COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
</cfquery>

<cfif isdefined('attributes.form_submitted')>
	<cfquery name="GET_ORDER_LIST" datasource="#DSN3#">
		SELECT DISTINCT
			ORDERS.COMPANY_ID,
			ORDERS.ORDER_ID,
			ORDERS.ORDER_NUMBER, 
			ORDERS.RECORD_DATE, 
			ORDERS.ORDER_HEAD,
			ORDERS.NETTOTAL,
			ORDERS.GROSSTOTAL,
			ORDERS.ORDER_DATE,
			ORDERS.PARTNER_ID,
			ORDERS.CONSUMER_ID,
			ORDERS.OTHER_MONEY,
			ORDERS.OTHER_MONEY_VALUE,
			ORDERS.IS_PROCESSED
		FROM 
			<cfif isDefined("attributes.currency_id") and len(attributes.currency_id)>
				ORDER_ROW,
			</cfif>
			ORDERS
		WHERE
			<cfif not len(attributes.zone)>
				(
					(ORDERS.PURCHASE_SALES = 1 AND
					 ORDERS.ORDER_ZONE = 0
					 )
					OR
					(	ORDERS.PURCHASE_SALES = 0 AND
						ORDERS.ORDER_ZONE = 1
					)
				) AND
			<cfelseif attributes.zone eq 0>
				(	ORDERS.PURCHASE_SALES = 1 AND
					ORDERS.ORDER_ZONE = 0
				) AND
			<cfelseif attributes.zone eq 1>
				(	ORDERS.PURCHASE_SALES = 0 AND
					ORDERS.ORDER_ZONE = 1
				) AND
			</cfif>
			<cfif isdefined("session.pp.company_id")>
				(
					ORDERS.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">) OR
					ORDERS.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE HIERARCHY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">)
				)
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND 
				(
					ORDERS.ORDER_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					ORDERS.ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					ORDERS.COMPANY_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.COMPANY WHERE FULLNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">) OR
					ORDERS.CONSUMER_ID IN (SELECT CONSUMER_ID FROM #dsn_alias#.CONSUMER WHERE CONSUMER_NAME +' '+ CONSUMER_SURNAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
				)
			</cfif>
			<cfif isDefined("attributes.currency_id") and len(attributes.currency_id)>
				 AND ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID
				 AND ORDER_ROW.ORDER_ROW_CURRENCY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.currency_id#">
			</cfif>
			<cfif isDefined("attributes.STATUS") and len(attributes.STATUS)>
				 AND ORDERS.ORDER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.STATUS#">
			</cfif>
			<cfif isDefined("attributes.zone") and len(attributes.zone)>
				 AND ORDERS.ORDER_ZONE = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.zone#">
			</cfif>
			<cfif isdefined("attributes.start_date") and len(attributes.start_date)>
				AND ORDERS.ORDER_DATE >= #attributes.start_date# 
			</cfif>
			<cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
				AND ORDERS.ORDER_DATE <= #attributes.finish_date#
			</cfif>
		ORDER BY 
			ORDER_DATE DESC
	</cfquery>
<cfelse>
	<cfset get_order_list.recordcount = 0>
</cfif>
<cfset order_currency_list="#getLang('main',1305)#,#getLang('main',1948)#,#getLang('main',1949)#,#getLang('main',1950)#,#getLang('main',44)#,#getLang('main',1349)#,#getLang('main',1951)#,#getLang('main',1952)#,#getLang('main',1094)#,#getLang('main',1211)#">


<cfparam name="attributes.page" default=1>
<cfif isdefined("session.pp.maxrows")>
	<cfparam name="attributes.maxrows" default='#session.pp.maxrows#'>
<cfelse>
	<cfparam name="attributes.maxrows" default='#session.ww.maxrows#'>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_order_list.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.currency_id)>
	<cfset url_str = "#url_str#&currency_id=#attributes.currency_id#">
</cfif>
<cfif len(attributes.status)>
	<cfset url_str = "#url_str#&status=#attributes.status#">
</cfif>
<cfif len(attributes.zone)>
	<cfset url_str = "#url_str#&zone=#attributes.zone#">
</cfif>
<cfif len(attributes.start_date)>
	<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
</cfif>
<cfif len(attributes.finish_date)>
	<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
</cfif>
<cfif isdefined("attributes.form_submitted")>
	<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
</cfif>
<cfif isdefined("attributes.my_company")>
	<cfset url_str = "#url_str#&my_company=#attributes.my_company#">
</cfif>
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
  	<tr>
    	<td  style="text-align:right;"> 
			<table>
    			<cfform name="list_order" method="post" action="#request.self#?fuseaction=objects2.view_list_order_hierarchy">
				<input type="hidden"name="form_submitted" id="form_submitted"  value="1">
	  			<tr> 
					<td><cf_get_lang_main no='48.Filtre'>: </td>
					<td><cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" style="width:100px;"></td>
					<td> 
					  	<select name="currency_id" id="currency_id">
					  	<option value=""><cf_get_lang_main no='669.Hepsi'></option>
						<cfloop from="1" to="#listlen(order_currency_list)#" index="cur_list">
							<cfoutput>
							<option value="#-1*cur_list#"<cfif attributes.currency_id eq (-1*cur_list)> selected</cfif>>#ListGetAt(order_currency_list,cur_list,",")#</option>
							</cfoutput>
						</cfloop>
					  	</select>
					</td>
					<td>
					  	<select name="status" id="status">
					  	<option value=""><cf_get_lang_main no='669.Hepsi'></option>
					  	<option value="0"<cfif isdefined('attributes.status') and (attributes.status eq 0)> selected</cfif>><cf_get_lang_main no='82.Pasif'></option>
					  	<option value="1"<cfif isdefined('attributes.status') and (attributes.status eq 1)> selected</cfif>><cf_get_lang_main no='81.Aktif'></option>
					  	</select>
					</td>
					<td>
						<select name="zone" id="zone">
						<option value=""><cf_get_lang_main no='669.Hepsi'></option>
						<option value="1"<cfif isdefined('attributes.zone') and (attributes.zone eq 1)> selected</cfif>><cf_get_lang_main no='667.İnternet'></option>
						<option value="0"<cfif isdefined('attributes.zone') and (attributes.zone eq 0)> selected</cfif>><cf_get_lang_main no='744.Diğer'></option>
						</select>
					</td>
					<td>
					  	<cfsavecontent variable="message"><cf_get_lang no='154.Başlangıç Tarihini Kontrol Ediniz'></cfsavecontent>
					  	<cfinput type="text" name="start_date" id="start_date"  value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
					  	<cf_wrk_date_image date_field="start_date"> 
					</td>
					<td>
					  	<cfsavecontent variable="message"><cf_get_lang_main no ='2326.Bitiş Tarihini Kontrol Ediniz'></cfsavecontent>
					  	<cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
					  	<cf_wrk_date_image date_field="finish_date"> 
					</td>
					<td>
					  	<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
					  	<cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td><cf_wrk_search_button></td>
	  			</tr>
				</cfform>
    		</table>
    	</td>
  	</tr>
</table>
<table cellspacing="2" cellpadding="1" border="0" width="100%" align="center">
	<tr class="color-header" height="22"> 
		<td class="form-title" width="65"><cf_get_lang_main no='75.No'></td>
	  	<td class="form-title" width="55"><cf_get_lang_main no='330.Tarih'></td>
	  	<td class="form-title"><cf_get_lang_main no='68.Başlık'></td>
	 	<td class="form-title" width="120"><cf_get_lang_main no='1384.Sipariş Veren'></td>
	 	<td width="100"  class="form-title" style="text-align:right;"><cf_get_lang_main no='644.Dövizli Tutar'></td>
	  	<td width="100"  class="form-title" style="text-align:right;"><cf_get_lang_main no='261.Tutar'></td>
		<td width="25">&nbsp;</td>
	</tr>
	<cfif get_order_list.recordcount>
		<cfset partner_id_list = ''>
		<cfset order_id_list = ''>
		<cfset consumer_id_list = ''>
		<cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif len(partner_id) and not listfind(partner_id_list,partner_id)>
				<cfset partner_id_list = listappend(partner_id_list,partner_id)>
			</cfif>
		</cfoutput>	
		<cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
			<cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
				<cfset consumer_id_list = listappend(consumer_id_list,consumer_id)>
			</cfif>
			<cfif len(order_id) and not listfind(order_id_list,order_id) and (is_processed eq 1)><!--- BK 20070522 is_processed sevk durumuna gelme olayi  --->
				<cfset order_id_list=listappend(order_id_list,order_id)>
			</cfif>		
		</cfoutput>

		<cfif len(partner_id_list)>
			<cfset partner_id_list = listsort(partner_id_list,"numeric","ASC",",")>
			<cfquery name="GET_PARTNER" datasource="#DSN#">
				SELECT
					COMPANY_PARTNER_NAME,
					COMPANY_PARTNER_SURNAME,
					COMPANY.NICKNAME
				FROM
					COMPANY_PARTNER,
					COMPANY
				WHERE
					COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID AND
					COMPANY_PARTNER.PARTNER_ID IN (#partner_id_list#)
				ORDER BY
					COMPANY_PARTNER.COMPANY_ID
			</cfquery>
		</cfif>
		<cfif len(consumer_id_list)>
			<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
			<cfquery name="GET_CONSUMER" datasource="#DSN#">
				SELECT
					CONSUMER_NAME,
					CONSUMER_SURNAME
				FROM
					CONSUMER
				WHERE
					CONSUMER_ID IN (#consumer_id_list#)
				ORDER BY
					CONSUMER_ID
			</cfquery>
		</cfif>
	
		<cfif len(order_id_list)>
			<cfset order_id_list=listsort(order_id_list,"numeric","ASC",",")>
			<cfquery name="GET_ORDERS_SHIP" datasource="#DSN3#">
				SELECT 
					OS.SHIP_ID,
					OS.ORDER_ID,				
					SR.SERVICE_COMPANY_ID,
					SR.SHIP_FIS_NO,
					SR.OZEL_KOD_2
				FROM
					ORDERS_SHIP OS,
					#dsn2_alias#.GET_SHIP_RESULT SR
				WHERE
					OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND
					SR.IS_TYPE = 'SHIP' AND
					OS.ORDER_ID IN(#order_id_list#) AND
					OS.SHIP_ID = SR.SHIP_ID
				ORDER BY
					OS.SHIP_ID						
			</cfquery>
		</cfif>
	
		<cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
	  		<tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
	  			<!--- my_company parametresi uyelerimin siparislerinden geldiğini belirtmek icin --->
				<td><a href="#request.self#?fuseaction=objects2.order_detail&order_id=#order_id#&my_company=1" class="tableyazi">#order_number#</a></td>
				<td>#dateformat(order_date,'dd/mm/yyyy')#</td>
				<td>#order_head#</td>
				<td>
				<cfif len(get_order_list.partner_id)>
					#get_partner.nickname[listfind(partner_id_list,get_order_list.partner_id,',')]# - #get_partner.company_partner_name[listfind(partner_id_list,get_order_list.partner_id,',')]# #get_partner.company_partner_surname[listfind(partner_id_list,get_order_list.partner_id,',')]#
				<cfelse>
					#get_consumer.consumer_name[listfind(consumer_id_list,get_order_list.consumer_id,',')]# #get_consumer.consumer_surname[listfind(consumer_id_list,get_order_list.consumer_id,',')]#
				</cfif>
				</td>
				<td  style="text-align:right;"><cfif len(other_money_value)>#tlformat(other_money_value)# #other_money#</cfif></td>
				<td  style="text-align:right;">
					<cfif len(nettotal) and isdefined("session.pp.money")>
						#tlformat(grosstotal)# #session.pp.money#
					<cfelse>
						#tlformat(grosstotal)# #session.ww.money#
				  </cfif>
				</td>
				<td>
					<cfif is_processed eq 1>
						<cfquery name="GET_ORDERS_" dbtype="query">
							SELECT * FROM GET_ORDERS_SHIP WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_list.order_id#">
						</cfquery>
						<cfif get_orders_.recordcount>
							<cfif get_orders_.ozel_kod_2 eq 'YURTICI KARGO'>
								<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_cargo_information&cargo_type=1&order_number=#order_number#','horizantal','popup_cargo_information');" title="<cf_get_lang no ='1193.Yurt İçi Kargo Bilgileri'>"><img src="/images/cargo.gif" alt="<cf_get_lang no ='1193.Yurt İçi Kargo Bilgileri'>" border="0" /></a>
							<cfelseif get_orders_.ozel_kod_2 eq 'UPS' and len(get_our_company_info.cargo_customer_code)><!--- BK Kargo kodu tanımlı degil ise girmesin --->
								<!--- BK 20070521 UPS Kargo linki icin duzenlendi --->
								<cfset date1 = get_order_list.order_date>
								<cfset date2 = date_add('d',15,get_order_list.order_date)>
								<cfset g1 = dateformat(date1,"dd")>
								<cfset a1 = dateformat(date1,"mm")>
								<cfset y1 = dateformat(date1,"yyyy")>
								<cfset g2 = dateformat(date2,"dd")>
								<cfset a2 = dateformat(date2,"mm")>
								<cfset y2 = dateformat(date2,"yyyy")>
								<a href="javascript://" onclick="windowopen('http://www.ups.com.tr/PMusteriRefSorguSonuc.asp?musterikodu=#get_our_company_info.cargo_customer_code#&referansNo=#listlast(get_orders_.ship_fis_no,'-')#&g1=#g1#&a1=#a1#&y1=#y1#&g2=#g2#&a2=#a2#&y2=#y2#','horizantal','popup_cargo_information');" title="<cf_get_lang no='1194.UPS Kargo Bilgileri'>"><img src="/images/cargo.gif" alt="<cf_get_lang no='1194.UPS Kargo Bilgileri'>" border="0" /></a>
							</cfif>
						</cfif>
					<cfelse>
						<font color="FF0000"><cf_get_lang_main no='1305.Açık'></font>
					</cfif>
				</td>
	  		</tr>
		</cfoutput> 
	<cfelse>
	  	<tr class="color-row" height="20"> 
			<td colspan="9"><cfif isdefined('attributes.form_submitted')><cf_get_lang_main no='72.Kayıt Yok'> !<cfelse><cf_get_lang_main no='289.Filtre Ediniz'> !</cfif></td>
	  	</tr>
	</cfif>
</table>
<cfif attributes.maxrows lt attributes.totalrecords> 
	<table cellpadding="0" cellspacing="0" border="0" width="100%" height="35" align="center">
  		<tr> 
			<td> 
	  			<cf_pages page="#attributes.page#" 
					maxrows="#attributes.maxrows#"
					totalrecords="#attributes.totalrecords#"
					startrow="#attributes.startrow#"
					adres="objects2.view_list_order_hierarchy&#url_str#"> 
			</td>
			<td  style="text-align:right;"><cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td>
  		</tr>
	</table>
</cfif>
