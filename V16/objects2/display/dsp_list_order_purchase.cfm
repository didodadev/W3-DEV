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
	SELECT CARGO_CUSTOMER_CODE FROM OUR_COMPANY_INFO WHERE  
	<cfif isdefined("session.pp.company_id")>
		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.our_company_id#">
	<cfelseif  isdefined("session.ww.userid")>
		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.our_company_id#">
	</cfif>
</cfquery>
<cfif isdefined('attributes.form_submitted')>
	<cfquery name="GET_ORDER_LIST" datasource="#DSN3#">
		SELECT DISTINCT
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
            ORDERS.PURCHASE_SALES = 0 AND 
            ORDERS.ORDER_ZONE = 0 AND
            <cfif isdefined("session.pp.company_id")>
                ORDERS.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#">
            <cfelseif isdefined("session.ww.userid")>
                ORDERS.CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#">
            </cfif>
            <cfif isDefined("attributes.keyword") and len(attributes.keyword)>
                 AND (ORDERS.ORDER_HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR ORDERS.ORDER_NUMBER LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">) 
            </cfif>
            <cfif isDefined("attributes.currency_id") and len(attributes.currency_id)>
                 AND ORDERS.ORDER_ID = ORDER_ROW.ORDER_ID
                 AND ORDER_ROW.ORDER_ROW_CURRENCY = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.currency_id#">
            </cfif>
            <cfif isDefined("attributes.STATUS") and len(attributes.STATUS)>
                 AND ORDERS.ORDER_STATUS = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.status#">
            </cfif>
            <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
                AND ORDERS.ORDER_DATE >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#">
            </cfif>
            <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
                AND ORDERS.ORDER_DATE <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
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
	<cfset url_str = "#url_str#&status=#attributes.zone#">
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
<table border="0" cellspacing="0" cellpadding="0" align="center" style="width:100%">
	<tr>
		<td> 
        	<cfform name="list_order" method="post" action="#request.self#?fuseaction=objects2.view_list_order_purchase">
				<table style="text-align:right;">
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
					<tr> 
                        <td><cf_get_lang_main no="48.Filtre">: </td>
                        <td><cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" style="width:100px;"></td>
                        <td> 
							<select name="currency_id" id="currency_id">
							<option value=""><cf_get_lang_main no="669.Hepsi"></option>
							<cfloop from="1" to="#listlen(order_currency_list)#" index="cur_list">
								<cfoutput>
								<option value="#-1*cur_list#"<cfif attributes.currency_id eq (-1*cur_list)> selected</cfif>>#ListGetAt(order_currency_list,cur_list,",")#</option>
								</cfoutput>
							</cfloop>
                            </select>
                        </td>
                        <td>
							<select name="status" id="status">
                                <option value=""><cf_get_lang_main no="669.Hepsi"></option>
                                <option value="0"<cfif isdefined('attributes.status') and (attributes.status eq 0)> selected</cfif>><cf_get_lang_main no="82.Pasif"></option>
                                <option value="1"<cfif isdefined('attributes.status') and (attributes.status eq 1)> selected</cfif>><cf_get_lang_main no="81.Aktif"></option>
                            </select>
                        </td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang no="154.Baslangi Tarihini Kontrol Ediniz"></cfsavecontent>
                            <cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
                            <cf_wrk_date_image date_field="start_date"> 
                        </td>
                        <td>
                            <cfsavecontent variable="message"><cf_get_lang no="155.Bitis Tarihini Kontrol Ediniz"></cfsavecontent>
                            <cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:65px;">
                            <cf_wrk_date_image date_field="finish_date"> 
                        </td>
                        <td>
                          <cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                          <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                        </td>
                        <td><cf_wrk_search_button></td>
                    </tr>
            	</table>
            </cfform>
    	</td>
	</tr>
</table>
<table cellspacing="2" cellpadding="1" border="0" align="center" style="width:100%">
	<tr class="color-header" style="height:22px;"> 
		<td class="form-title" style="width:65px;"><cf_get_lang_main no="75.No"></td>
		<td class="form-title" style="width:55px;"><cf_get_lang_main no="330.Tarih"></td>
		<td class="form-title"><cf_get_lang_main no="68.Baslik"></td>
		<td class="form-title" style="width:120px;"><cf_get_lang_main no='1384.Siparis Veren'></td>
		<td  class="form-title" style="width:100px;text-align:right;"><cf_get_lang_main no="644.Dvizli Tutar"></td>
		<td  class="form-title" style="width:100px;text-align:right;"><cf_get_lang_main no="261.Tutar"></td>
		<td style="width:25px;">&nbsp;</td>
	</tr>
	<cfset partner_id_list = ''>
	<cfset consumer_id_list = ''>
	<cfset order_id_list = ''>
	<cfif get_order_list.recordcount>
	<cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<cfif len(partner_id) and not listfind(partner_id_list,partner_id)>
			<cfset partner_id_list=listappend(partner_id_list,partner_id)>
		</cfif>
		<cfif len(consumer_id) and not listfind(consumer_id_list,consumer_id)>
			<cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
		</cfif>
		<cfif len(order_id) and not listfind(order_id_list,order_id) and (is_processed eq 1)><!--- BK 20070522 is_processed sevk durumuna gelme olayi  --->
			<cfset order_id_list=listappend(order_id_list,order_id)>
		</cfif>		
	</cfoutput>
	
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
				<cfif isDefined("session.pp")>
                    OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#"> AND
                <cfelse>
                    OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.period_id#"> AND
                </cfif>
				SR.IS_TYPE = 'SHIP' AND
				OS.ORDER_ID IN(#order_id_list#) AND
				OS.SHIP_ID = SR.SHIP_ID
			ORDER BY
				OS.SHIP_ID						
		</cfquery>
	</cfif>
	
	<cfif len(partner_id_list)>
		<cfset partner_id_list=listsort(partner_id_list,"numeric","ASC",",")>
		<cfquery name="GET_PARTNER" datasource="#DSN#">
			SELECT
				COMPANY_PARTNER_NAME,
				COMPANY_PARTNER_SURNAME
			FROM
				COMPANY_PARTNER
			WHERE
				COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
				PARTNER_ID IN (#partner_id_list#)
			ORDER BY
				COMPANY_ID
		</cfquery>
	<cfelse>
		<cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
		<cfquery name="GET_CONSUMER" datasource="#DSN#">
			SELECT
				CONSUMER_NAME,
				CONSUMER_SURNAME
			FROM
				CONSUMER
			WHERE
				CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ww.userid#"> AND
				CONSUMER_ID IN (#consumer_id_list#)
			ORDER BY
				CONSUMER_ID
		</cfquery>
	</cfif>
	<cfoutput query="get_order_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
		<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="height:20px;">
            <td><a href="#request.self#?fuseaction=objects2.order_detail_purchase&order_id=#order_id#" class="tableyazi">#order_number#</a></td>
            <td>#dateformat(order_date,'dd/mm/yyyy')#</td>
            <td><a href="#request.self#?fuseaction=objects2.order_detail_purchase&order_id=#order_id#" class="tableyazi">#order_head#</a></td>
            <td>
                <cfif len(partner_id_list)>
                    #get_partner.company_partner_name[listfind(partner_id_list,get_order_list.partner_id,',')]# #get_partner.company_partner_surname[listfind(partner_id_list,get_order_list.partner_id,',')]#
                <cfelse>
                    #get_consumer.consumer_name[listfind(consumer_id_list,get_order_list.consumer_id,',')]# #get_consumer.consumer_surname[listfind(consumer_id_list,get_order_list.consumer_id,',')]#
              </cfif>
            </td>
            <td  style="text-align:right;"><cfif len(other_money_value)>#TLFormat(other_money_value)# #other_money#</cfif></td>
            <td  style="text-align:right;">
				<cfif len(nettotal) and isdefined("session.pp.money")>
                    #TLFormat(NETTOTAL)# #session.pp.money#
                <cfelse>
                    #TLFormat(NETTOTAL)# #session.ww.money#
              </cfif>
            </td>
            <td>
                <cfif is_processed eq 1>
                    <cfquery name="GET_ORDERS_" dbtype="query">
                        SELECT * FROM GET_ORDERS_SHIP WHERE ORDER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_order_list.order_id#">
                    </cfquery>
                    <cfif get_orders_.recordcount>
                        <cfif get_orders_.ozel_kod_2 eq 'YURTICI KARGO'>
                            <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects2.popup_cargo_information&cargo_type=1&order_number=#order_number#','horizantal','popup_cargo_information');" title="<cf_get_lang no ='1193.Yurt Ii Kargo Bilgileri'>"><img src="/images/cargo.gif" alt="<cf_get_lang no ='1193.Yurt Ii Kargo Bilgileri'>" border="0" /></a>
                        <cfelseif get_orders_.ozel_kod_2 eq 'UPS' and len(get_our_company_info.cargo_customer_code)><!--- BK Kargo kodu tanimli degil ise girmesin --->
                            <!--- BK 20070521 UPS Kargo linki icin duzenlendi --->
                            <cfset date1 = get_order_list.order_date>
                            <cfset date2 = date_add('d',15,get_order_list.order_date)>
                            <cfset g1 = dateformat(date1,"dd")>
                            <cfset a1 = dateformat(date1,"mm")>
                            <cfset y1 = dateformat(date1,"yyyy")>
                            <cfset g2 = dateformat(date2,"dd")>
                            <cfset a2 = dateformat(date2,"mm")>
                            <cfset y2 = dateformat(date2,"yyyy")>
                            <a href="javascript://" onclick="windowopen('http://www.ups.com.tr/PMusteriRefSorguSonuc.asp?musterikodu=#get_our_company_info.cargo_customer_code#&referansNo=#listlast(get_orders_.ship_fis_no,'-')#&g1=#g1#&a1=#a1#&y1=#y1#&g2=#g2#&a2=#a2#&y2=#y2#','horizantal','popup_cargo_information');" title="<cf_get_lang no ='1194.UPS Kargo Bilgileri'>"><img src="/images/cargo.gif" alt="<cf_get_lang no ='1194.UPS Kargo Bilgileri'>" border="0" /></a>
                        </cfif>
                    </cfif>
                <cfelse>
		  			<font color="FF0000"><cf_get_lang no="165.Açık"></font>
				</cfif>
            </td>
        </tr>
	</cfoutput> 
	<cfelse>
		<tr class="color-row" style="height:20px;"> 
            <td colspan="9"><cfif isdefined('attributes.form_submitted')><cf_get_lang_main no="72.Kayit Yok"> !<cfelse><cf_get_lang_main no="289.Filtre Ediniz"> !</cfif></td>
        </tr>
	</cfif>
</table>
<cfif attributes.maxrows lt attributes.totalrecords> 
	<table cellpadding="0" cellspacing="0" border="0" align="center" style="width:100%; height:35px;">
        <tr> 
            <td> 
              	<cf_pages page="#attributes.page#" 
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="objects2.view_list_order&#url_str#"> 
            </td>
            <td  style="text-align:right;"><cfoutput> <cf_get_lang_main no="128.Toplam Kayit">:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no="169.Sayfa">:#attributes.page#/#lastpage#</cfoutput></td>
        </tr>
    </table>
</cfif>
