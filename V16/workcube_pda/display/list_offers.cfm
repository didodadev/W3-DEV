<cf_xml_page_edit fuseact ="sales.list_offer" default_value="1">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.offer_status_cat_id" default="">
<cfparam name="attributes.offer_zone" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.company" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.consumer_id" default="">
<cfparam name="attributes.member_type" default="">
<cfparam name="attributes.member_name" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.form_varmi" default="">
<cfparam name="attributes.sales_partner" default="">
<cfparam name="attributes.sales_partner_id" default="">
<cfparam name="attributes.offer_stage" default="">
<cfparam name="attributes.sale_add_option" default="">
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">
<cfparam name="attributes.listing_type" default="1">
<cfparam name="attributes.status" default="1">

<cfif len(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif len(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>
<cfinclude template="../query/get_offer_list.cfm">
<cfinclude template="../query/get_sale_add_option.cfm">

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default="#session.pda.maxrows#">
<cfparam name="attributes.totalrecords" default="#get_offer_list.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_PROCESS_TYPE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR,
		PROCESS_TYPE_OUR_COMPANY PTO,
		PROCESS_TYPE PT
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pda.our_company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#listfirst(attributes.fuseaction,'.')#.list_offer%">
	ORDER BY
		PTR.LINE_NUMBER
</cfquery>
<table cellpadding="0" cellspacing="0" align="center" style="width:98%">
	<tr style="height:35px;">
		<td class="headbold">Satış Tekliflerim</td>
	</tr>
</table>
<table cellpadding="2" cellspacing="1" border="0" align="center" style="width:98%">	
	<tr>
		<td class="color-row" align="center">
			<table cellpadding="2" cellspacing="1" border="0" style="width:100%" class="color-border" align="right">
				<tr class="color-header">
					<td style="width:10px;" class="form-title"><cf_get_lang_main no='1165.Sıra'></td>
					<td class="form-title"><cf_get_lang_main no='75.No'></td>
					<cfif xml_offer_revision eq 1>
						<td class="form-title">Revize <cf_get_lang_main no='75.No'></td>
					</cfif>
                    <td class="form-title"><cf_get_lang_main no='330.Tarih'></td>
                    <td class="form-title"><cf_get_lang_main no='68.Başlık'></td>
                    <td class="form-title"><cf_get_lang_main no='162.Sirket'> - <cf_get_lang_main no='166.Yetkili'></td>
                    <td class="form-title"><cfif attributes.listing_type eq 1><cf_get_lang_main no='261.Tutar'><cfelse><cf_get_lang_main no='672.Fiyat'></cfif></td>
                    <cfif Len(attributes.listing_type) and attributes.listing_type eq 1>
                        <td class="form-title"><cf_get_lang_main no='4.Proje'></td>
                    </cfif>
                    <td class="form-title"><cf_get_lang_main no='1447.Surec'></td>
                    <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                        <td class="form-title"><cf_get_lang_main no='245.Ürün'></td>
                        <td class="form-title"><cf_get_lang_main no='223.Miktar'></td>
                        <td class="form-title"><cf_get_lang_main no='1032.Kalan'></td>
                    </cfif>
				</tr>
				<cfif isdefined("attributes.form_varmi") and get_offer_list.recordcount>
					<cfset partner_id_list=''>
                    <cfset company_id_list=''>
                    <cfset consumer_id_list=''>
                    <cfset emp_id_list=''>
                    <cfset offer_stage_list=''>
                    <cfset project_name_list = ''>
                    <cfset opp_name_list = ''>
                    <cfset offer_id_list =''>
                    <cfoutput query="get_offer_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <cfif len(offer_id) and not listFindnocase(offer_id_list,offer_id)>
							<cfset offer_id_list = listappend(offer_id_list,offer_id)>
                        </cfif>
                        <cfif len(partner_id) and not listFindnocase(partner_id_list,partner_id)>
                            <cfset partner_id_list = listappend(partner_id_list,partner_id)>
                        </cfif>
                        <cfif len(company_id) and not listFindnocase(company_id_list,company_id)>
                            <cfset company_id_list=listappend(company_id_list,company_id)>
                        </cfif>
                        <cfif len(consumer_id) and not listFindnocase(consumer_id_list,consumer_id)>
                            <cfset consumer_id_list=listappend(consumer_id_list,consumer_id)>
                        </cfif>
                        <cfif Listlen(offer_to_partner,',')>
                            <cfset partner_id_list=listappend(partner_id_list,offer_to_partner)>
                        </cfif>
                        <cfif len(sales_emp_id) and not listfind(emp_id_list,sales_emp_id)>
                            <cfset emp_id_list = Listappend(emp_id_list,sales_emp_id)>
                        </cfif>
                        <cfif len(offer_stage) and not listfind(offer_stage_list,offer_stage)>
                            <cfset offer_stage_list=listappend(offer_stage_list,offer_stage)>
                        </cfif>	  
                        <cfset partner_id_list = ListSort(ListDeleteDuplicates(partner_id_list),'Numeric','ASC',',')>
                        <cfif len(project_id) and not listfind(project_name_list,project_id)>
                            <cfset project_name_list = Listappend(project_name_list,project_id)>
                        </cfif>  
                        <cfif len(opp_id) and not listfind(opp_name_list,opp_id)>
                            <cfset opp_name_list = Listappend(opp_name_list,opp_id)>
                        </cfif>             
					</cfoutput>
					<cfif len(offer_id_list)>
                    	<cfset offer_id_list=listsort(offer_id_list,"numeric","ASC",",")>
                        <cfquery name="GET_PRICE_ROW" datasource="#DSN3#">
                            SELECT OFFER_ID,SUM(PRICE) SUM_PRICE FROM OFFER_ROW WHERE OFFER_ID IN (#offer_id_list#) GROUP BY OFFER_ID ORDER BY OFFER_ID 
                        </cfquery>
                        <cfset offer_id_list = listsort(listdeleteduplicates(valuelist(get_price_row.offer_id,',')),'numeric','ASC',',')>
                    </cfif>
                    <cfif listlen(partner_id_list)>
                        <cfset partner_id_list=listsort(partner_id_list,"numeric","ASC",",")>
                        <cfquery name="GET_PARTNER_DETAIL" datasource="#DSN#">
                            SELECT
                                CP.COMPANY_PARTNER_NAME,
                                CP.COMPANY_PARTNER_SURNAME,
                                CP.PARTNER_ID,						
                                C.FULLNAME,
                                C.NICKNAME,
                                C.COMPANY_ID
                            FROM 
                                COMPANY_PARTNER CP,
                                COMPANY C
                            WHERE 
                                CP.PARTNER_ID IN (#partner_id_list#) AND
                                CP.COMPANY_ID=C.COMPANY_ID
                            ORDER BY
                                CP.PARTNER_ID
                        </cfquery>
						<cfset main_partner_id_list = listsort(listdeleteduplicates(valuelist(get_partner_detail.partner_id,',')),'numeric','ASC',',')>
					</cfif>
					<cfif listlen(company_id_list)>
                        <cfset company_id_list=listsort(company_id_list,"numeric","ASC",",")>
                        <cfquery name="GET_COMPANY_DETAIL" datasource="#DSN#">
                            SELECT NICKNAME, COMPANY_ID FROM COMPANY WHERE COMPANY_ID IN (#company_id_list#) ORDER BY COMPANY_ID
                        </cfquery>
                        <cfset main_company_id_list = listsort(listdeleteduplicates(valuelist(get_company_detail.company_id,',')),'numeric','ASC',',')>
                    </cfif>
                    <cfif listlen(consumer_id_list)>
                        <cfset consumer_id_list=listsort(consumer_id_list,"numeric","ASC",",")>
                        <cfquery name="GET_CONSUMER_DETAIL" datasource="#DSN#">
                            SELECT CONSUMER_ID, CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_ID IN (#consumer_id_list#) ORDER BY CONSUMER_ID
                        </cfquery>
                        <cfset main_consumer_id_list = listsort(listdeleteduplicates(valuelist(get_consumer_detail.consumer_id,',')),'numeric','ASC',',')>
                    </cfif>
                    <cfif len(emp_id_list)>
                        <cfset emp_id_list=listsort(emp_id_list,"numeric","ASC",",")>
                        <cfquery name="GET_POSITION" datasource="#DSN#">
                            SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME, EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#emp_id_list#) ORDER BY EMPLOYEE_ID
                        </cfquery>
                        <cfset emp_id_list2=ValueList(get_position.EMPLOYEE_ID,',')>
                    </cfif>
                    <cfif len(offer_stage_list)>
                        <cfset offer_stage_list=listsort(offer_stage_list,"numeric","ASC",",")>
                        <cfquery name="PROCESS_TYPE" datasource="#DSN#">
                            SELECT STAGE, PROCESS_ROW_ID FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID IN (#offer_stage_list#) ORDER BY PROCESS_ROW_ID
                        </cfquery>
                    </cfif>
                    <cfif len(project_name_list)>
                        <cfquery name="OFFER_PRO" datasource="#DSN#">
                            SELECT PROJECT_HEAD, PROJECT_ID FROM PRO_PROJECTS WHERE PROJECT_ID IN (#project_name_list#) ORDER BY PROJECT_ID
                        </cfquery>
                        <cfset project_name_list = listsort(listdeleteduplicates(valuelist(offer_pro.project_id,',')),'numeric','ASC',',')>
                    </cfif>
                    <cfif len(opp_name_list)>
                        <cfquery name="OFFER_OPP" datasource="#DSN3#">
                            SELECT OPP_HEAD, OPP_ID FROM OPPORTUNITIES WHERE OPP_ID IN (#opp_name_list#) ORDER BY OPP_ID
                        </cfquery>
                        <cfset opp_name_list = listsort(listdeleteduplicates(valuelist(offer_opp.opp_id,',')),'numeric','ASC',',')>
                    </cfif>
					<!--- Send_member_ degeri teklif satir bazinda siparise donusturulurken gonderilen member degerini tutuyor fbs20100705 --->
                    <cfset send_member_ = "">
                    <cfif Len(attributes.company_id) and Len(attributes.member_name)>
                        <cfset send_member_ = "&company_id=#attributes.company_id#">
                    <cfelseif Len(attributes.consumer_id) and Len(attributes.member_name)>
                        <cfset send_member_ = "&consumer_id=#attributes.consumer_id#">
                    </cfif>
                    <cfform name="sale_order_relation" action="#request.self#?fuseaction=sales.form_add_order#send_member_#">
						<cfoutput query="get_offer_list" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr class="color-row">
                                <td>#currentrow#</td>
                                <td><a href="#request.self#?fuseaction=pda.detail_offer&offer_id=#offer_id#" class="tableyazi">#offer_number#</a></td>
                                <cfif xml_offer_revision eq 1>
                                    <td><cfif len(offer_revize_no)>#offer_revize_no#<cfelse>#offer_number#-00</cfif></td>
                                </cfif>
                                <td>#dateformat(offer_date,'dd/mm/yyyy')#</td>
                                <td style="width:150px;"><a href="#request.self#?fuseaction=pda.detail_offer&offer_id=#offer_id#" class="tableyazi">#left(offer_head,25)#<cfif len(offer_head) gt 25>...</cfif></a></td>
                                <td><cfif len(company_id) and not Listlen(offer_to_partner)>
                                        <!---<a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#company_id#','medium');" class="tableyazi"> --->#get_company_detail.nickname[listfind(main_company_id_list,company_id,',')]# <!---</a> --->
                                    </cfif>
                                    <cfif len(consumer_id)>
                                        <!--- <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&consumer_id=#consumer_id#','medium');" class="tableyazi"> --->#get_consumer_detail.consumer_name[listfind(main_consumer_id_list,consumer_id,',')]#&nbsp; #get_consumer_detail.consumer_surname[listfind(main_consumer_id_list,consumer_id,',')]# <!---</a> ---->
                                    </cfif>
                                    <cfif Listlen(offer_to_partner)>
                                        <cfloop list="#offer_to_partner#" index="i">
                                            <!--- <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_com_det&company_id=#get_partner_detail.company_id[listfind(partner_id_list,i,',')]#','medium');"> --->#get_partner_detail.nickname[listfind(partner_id_list,i,',')]# <!---</a> ---> -
                                            <!--- <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#i#','medium');"> --->#get_partner_detail.company_partner_name[listfind(partner_id_list,i,',')]# #get_partner_detail.company_partner_surname[listfind(partner_id_list,i,',')]# <!--- </a> --->
                                        </cfloop>
                                    </cfif>
                                </td>
                                <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                                    <cfif len(discount_1)><cfset indirim1 = discount_1><cfelse><cfset indirim1 =0></cfif>
                                    <cfif len(discount_2)><cfset indirim2 = discount_2><cfelse><cfset indirim2 =0></cfif>
                                    <cfif len(discount_3)><cfset indirim3 = discount_3><cfelse><cfset indirim3 =0></cfif>
                                    <cfif len(discount_4)><cfset indirim4 = discount_4><cfelse><cfset indirim4 =0></cfif>
                                    <cfif len(discount_5)><cfset indirim5 = discount_5><cfelse><cfset indirim5 =0></cfif>
                                    <cfif len(discount_6)><cfset indirim6 = discount_6><cfelse><cfset indirim6 =0></cfif>
                                    <cfif len(discount_7)><cfset indirim7 = discount_7><cfelse><cfset indirim7 =0></cfif>
                                    <cfif len(discount_8)><cfset indirim8 = discount_8><cfelse><cfset indirim8 =0></cfif>
                                    <cfif len(discount_9)><cfset indirim9 = discount_9><cfelse><cfset indirim9 =0></cfif>
                                    <cfif len(discount_10)><cfset indirim10 = discount_10><cfelse><cfset indirim10 =0></cfif>
                                    <cfset indirim_carpan = (100-indirim1) * (100-indirim2) * (100-indirim3) * (100-indirim4) * (100-indirim5) * (100-indirim6) * (100-indirim7) * (100-indirim8) * (100-indirim9) * (100-indirim10)>
                                    <cfset row_total = (quantity * price) + extra_price_total>
                                    <cfset row_nettotal = (row_total/100000000000000000000) * indirim_carpan>
                                </cfif>	
                                <td align="right" style="text-align:right;"> 
                                    <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                                        #TLFormat(row_nettotal/quantity)# #session.pda.money#
                                    <cfelseif price neq "0" and attributes.listing_type eq 1>
                                        #TLFormat(price)# #session.pda.money#
                                    <cfelse>
                                        <cfif len(get_price_row.sum_price)>
                                            #TLFormat(get_price_row.sum_price[listfind(offer_id_list,offer_id,',')])# #session.pda.money#
                                        <cfelse>
                                            <font color="##ff0000"><cf_get_lang no='46.bedelsiz'></font>
                                        </cfif>
                                    </cfif>
                                </td>
                                <cfif Len(attributes.listing_type) and attributes.listing_type eq 1>
                                    <td><cfif isdefined("get_offer_list.project_id") and len(get_offer_list.project_id)>
                                            #offer_pro.project_head[listfind(project_name_list,project_id,',')]#
                                        <cfelse>
                                            <cf_get_lang_main no='1047.projesiz'>
                                        </cfif>
                                    </td> 		
                                </cfif>
                                <td><cfif len(offer_stage)>#process_type.stage[listfind(offer_stage_list,offer_stage,',')]#</cfif></td>
                                <!-- sil -->
                                <cfif Len(attributes.listing_type) and attributes.listing_type eq 2>
                                    <cfquery name="get_used_amount" datasource="#dsn3#">
                                        SELECT
                                            SUM(QUANTITY) QUANTITY
                                        FROM
                                            ORDER_ROW
                                        WHERE
                                            WRK_ROW_RELATION_ID = '#wrk_row_id#' AND
                                            STOCK_ID = #stock_id# AND
                                            PRODUCT_ID = #product_id#
                                    </cfquery>
                                    <cfif len(get_used_amount.quantity)>
                                        <cfset 'used_amount_#offer_id#_#wrk_row_id#' = get_used_amount.quantity>
                                    <cfelse>
                                        <cfset 'used_amount_#offer_id#_#wrk_row_id#' = 0>
                                    </cfif>
                                    <input type="hidden" name="offer_amount_list" id="offer_amount_list" value="">
                                    <cfset 'offer_amount_#offer_id#_#wrk_row_id#' = get_offer_list.quantity>
                                    <cfset 'offer_amount_#offer_id#_#wrk_row_id#' = Evaluate('offer_amount_#offer_id#_#wrk_row_id#') - Evaluate('used_amount_#offer_id#_#wrk_row_id#')>
                                    
                                    <td><a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#','medium');">#product_name#</a></td>
                                    <td align="right" style="text-align:right;">#quantity# #unit#</td>
                                    <td align="right" style="text-align:right;"><input type="text" name="offer_amount_#offer_id#_#wrk_row_id#" id="offer_amount_#offer_id#_#wrk_row_id#" onblur="if(filterNum(this.value,4)=='' || filterNum(this.value,4)==0)this.value=commaSplit(1);if(filterNum(this.value,4)> #evaluate('offer_amount_#offer_id#_#wrk_row_id#')#){alert('<cf_get_lang_main no='1471.Maksimum Kalan Miktar'> : #evaluate('offer_amount_#offer_id#_#wrk_row_id#')#\ !');this.value=#TLFormat(evaluate('offer_amount_#offer_id#_#wrk_row_id#'))#;}" onkeyup="return(FormatCurrency(this,event,4));" validate="float" class="box" value="#TLFormat(evaluate('offer_amount_#offer_id#_#wrk_row_id#'),4)#" range="0,#evaluate('offer_amount_#offer_id#_#wrk_row_id#')#" style="width:100%" message="Miktarı Kontrol Ediniz!" <cfif Evaluate('offer_amount_#offer_id#_#wrk_row_id#') lte 0>disabled</cfif>></td>
                                </cfif>
                            </tr>
                        </cfoutput>
                        <cfif Len(attributes.listing_type) and attributes.listing_type eq 2 and len(attributes.member_name) and (len(attributes.company_id) or len(attributes.consumer_id))>
                            <!--- Satir bazinda olup cari filtrelenmisse siparis olusturulabilir --->
                            <tr>
                                <td colspan="17" style="text-align:right;"><cf_workcube_buttons is_upd='0' is_cancel='0' insert_info='Satış Siparişi Oluştur' insert_alert=''></td>
                            </tr>
                        </cfif>
					</cfform>
                <cfelse>
                    <tr> 
                        <td colspan="14"><cfif len(attributes.form_varmi)><cf_get_lang_main no='72.Kayıt Yok'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
                    </tr>
                </cfif>
			</table>
        </td>
    </tr>
</table>
<cfset url_str = attributes.fuseaction>
<cfif isdefined("attributes.form_varmi")>
	<cfset url_str = "#url_str#&form_varmi=#attributes.form_varmi#" >
</cfif>
<cfif isdefined ("attributes.keyword") and len(attributes.keyword)>
  	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len(attributes.company_id)>
  	<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
</cfif>
<cfif len(attributes.company)>
  	<cfset url_str = "#url_str#&company=#attributes.company#">
</cfif>
<cfif len(attributes.consumer_id)>
  	<cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#">
</cfif>
<cfif len(attributes.member_name)>
  	<cfset url_str = "#url_str#&member_name=#attributes.member_name#">
</cfif>
<cfif len(attributes.member_type)>
  	<cfset url_str = "#url_str#&member_type=#attributes.member_type#">
</cfif>		
<cfif len(attributes.product_id)>
  	<cfset url_str = "#url_str#&product_id=#attributes.product_id#">
</cfif>
<cfif len(attributes.product_name)>
  	<cfset url_str = "#url_str#&product_name=#attributes.product_name#">
</cfif>
<cfif len(attributes.offer_stage)>
  	<cfset url_str = "#url_str#&offer_stage=#attributes.offer_stage#">
</cfif>
<cfif len(attributes.offer_zone)>
  	<cfset url_str = "#url_str#&offer_zone=#attributes.offer_zone#">
</cfif>
<cfif len(attributes.listing_type)>
  	<cfset url_str = "#url_str#&listing_type=#attributes.listing_type#">
</cfif>
<cfif len(attributes.offer_status_cat_id)>
  	<cfset url_str = "#url_str#&offer_status_cat_id=#attributes.offer_status_cat_id#">
</cfif>
<cfif isdefined("attributes.sale_add_option") and len(attributes.sale_add_option)>
    <cfset url_str = "#url_str#&sale_add_option=#attributes.sale_add_option#">
</cfif>		
<cfif len(attributes.start_date)>
    <cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,'dd/mm/yyyy')#">
</cfif>
<cfif len(attributes.finish_date)>
    <cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,'dd/mm/yyyy')#">
</cfif>
<cfif isDefined("attributes.sales_emp_id") and len(attributes.sales_emp_id) and len(attributes.sales_emp)>
    <cfset url_str = url_str & "&sales_emp_id=#attributes.sales_emp_id#&sales_emp=#attributes.sales_emp#">
</cfif>
<cfif len(attributes.sales_partner_id)>
    <cfset url_str = url_str & "&sales_partner_id=#attributes.sales_partner_id#&sales_partner=#attributes.sales_partner#">
</cfif>
<cfif isdefined("attributes.status") and len(attributes.status)>
  	<cfset url_str = "#url_str#&status=#attributes.status#">
</cfif>
<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
  	<cfset url_str = "#url_str#&project_id=#attributes.project_id#">
</cfif>
<cfif isdefined("attributes.project_head") and len(attributes.project_head)>
  	<cfset url_str = "#url_str#&project_head=#attributes.project_head#">
</cfif>
<cf_paging 
    page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#url_str#">
<script type="text/javascript">
	if(document.getElementById('keyword') != undefined) document.getElementById('keyword').focus();
</script>
