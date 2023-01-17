<div id="hidden_fields"></div><!--- silmeyin asortiler için kullanıyorum erk 20040210 SA20160428 Div e çevirildi--->

    <div class="ui-scroll">
        <table class="ui-table-list">
            <thead>
                <cfif not isdefined("attributes.no_header")>
                    <tr class="color-header" height="20">		
                        <cfoutput>
                            <cfif ListFindNoCase(display_list, "price_other")><cfset int_dovizli_fiyat = 1><cfelse><cfset int_dovizli_fiyat = 0></cfif>
                            <cfif ListFindNoCase(display_list, "stock_code")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "stock_code", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "barcod")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "barcod", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "manufact_code")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "manufact_code", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "product_name")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "product_name", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "amount")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "amount", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "unit")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "unit", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "spec")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "spec", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "price")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "price", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "price_other")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "price_other", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "price_net")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "price_net", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "price_net_doviz")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "price_net_doviz", ","), ",")#</th>
                            </cfif>						
                            <cfif ListFindNoCase(display_list, "tax")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "tax", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "duedate")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "duedate", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "disc_ount")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "disc_ount", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "disc_ount2_")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "disc_ount2_", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "disc_ount3_")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "disc_ount3_", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "disc_ount4_")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "disc_ount4_", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "disc_ount5_")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "disc_ount5_", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "row_total")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "row_total", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "row_nettotal")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "row_nettotal", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "row_taxtotal")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "row_taxtotal", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "row_lasttotal")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "row_lasttotal", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "other_money")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "other_money", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "other_money_value")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "other_money_value", ","), ",")#</th>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "other_money_gross_total", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "deliver_date")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "deliver_date", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "deliver_dept")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "deliver_dept", ","), ",")#</th>
                            </cfif>  
                            <cfif ListFindNoCase(display_list, "is_parse")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "is_parse", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "lot_no")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "lot_no", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "shelf_number")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "shelf_number", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "order_currency")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "order_currency", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "reserve_type")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "reserve_type", ","), ",")#</th>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "reserve_date")>
                                <th>#ListGetAt(display_field_name_list, ListFindNoCase(display_list, "reserve_date", ","), ",")#</th>
                            </cfif>
                        </cfoutput>
                    </tr>
                </cfif>
            </thead>
            <tbody>
                <cfloop from="1" to="#ArrayLen(sepet.satir)#" index="i">
                    <cfoutput>
                        <tr> 
                            <cfif ListFindNoCase(display_list, "stock_code")><td>#sepet.satir[i].stock_code#</td></cfif>
                            <cfif ListFindNoCase(display_list, "barcod")><td>#sepet.satir[i].barcode#</td></cfif>
                            <cfif ListFindNoCase(display_list, "manufact_code")><td>#sepet.satir[i].manufact_code#</td></cfif>
                            <cfif ListFindNoCase(display_list, "product_name")><td nowrap>#sepet.satir[i].product_name#</td></cfif>
                            <cfif ListFindNoCase(display_list, "amount")><td  style="text-align:right;">#sepet.satir[i].amount#</td></cfif>
                            <cfif ListFindNoCase(display_list, "unit")><td>#sepet.satir[i].unit#</td></cfif>
                            <cfif ListFindNoCase(display_list, "spec")><td nowrap>#sepet.satir[i].spect_name#</td></cfif>
                            <cfif ListFindNoCase(display_list, "price")><td  nowrap style="text-align:right;">#TLFormat(sepet.satir[i].price)#</td></cfif>
                            <cfif ListFindNoCase(display_list, "price_other")><td  nowrap style="text-align:right;">#TLFormat(sepet.satir[i].price_other)#</td></cfif>
                            <cfif ListFindNoCase(display_list, "price_net")>
                            <td  nowrap style="text-align:right;">
                            <cfset float_price_net = (sepet.satir[i].price/100000000000000000000) * sepet.satir[i].indirim_carpan>
                            #TLFormat(float_price_net)#
                            </td>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "price_net_doviz")>
                                <td  nowrap style="text-align:right;">
                                <cfset float_price_net_doviz = (sepet.satir[i].price_other/100000000000000000000) * sepet.satir[i].indirim_carpan>
                                #TLFormat(float_price_net_doviz)#
                                </td>
                            </cfif>									
                            <cfif ListFindNoCase(display_list, "tax")><td  style="text-align:right;">#TLFormat(sepet.satir[i].tax_percent)#</td></cfif>
                            <cfif ListFindNoCase(display_list, "duedate")><td style="text-align:right;">#TLFormat(sepet.satir[i].duedate)#</td></cfif>
                            <cfif ListFindNoCase(display_list, "disc_ount")><td style="text-align:right;">#TLFormat(sepet.satir[i].indirim1)#</td></cfif>
                            <cfif ListFindNoCase(display_list, "disc_ount2_")><td style="text-align:right;">#TLFormat(sepet.satir[i].indirim2)#</td></cfif>
                            <cfif ListFindNoCase(display_list, "disc_ount3_")><td style="text-align:right;">#TLFormat(sepet.satir[i].indirim3)#</td></cfif>
                            <cfif ListFindNoCase(display_list, "disc_ount4_")><td style="text-align:right;">#TLFormat(sepet.satir[i].indirim4)#</td></cfif>
                            <cfif ListFindNoCase(display_list, "disc_ount5_")><td style="text-align:right;">#TLFormat(sepet.satir[i].indirim5)#</td></cfif>
                            <cfif ListFindNoCase(display_list, "row_total")><td style="text-align:right;">#TLFormat(sepet.satir[i].row_total)#</td></cfif>
                            <cfif ListFindNoCase(display_list, "row_nettotal")><td  style="text-align:right;">#TLFormat(sepet.satir[i].row_nettotal)#</td></cfif>
                            <cfif ListFindNoCase(display_list, "row_taxtotal")><td  style="text-align:right;">#TLFormat(sepet.satir[i].row_taxtotal)#</td></cfif>
                            <cfif ListFindNoCase(display_list, "row_lasttotal")><td  style="text-align:right;">#TLFormat(sepet.satir[i].row_lasttotal)#</td></cfif>
                            <cfif ListFindNoCase(display_list, "other_money")>
                            <td>
                                <cfloop query="get_money_bskt">
                                    <cfif sepet.satir[i].other_money eq money_type>
                                        <cfset fl_total_2 = rate1>
                                        <cfset fl_total = rate2>
                                    </cfif>
                                    <cfif sepet.satir[i].other_money eq money_type>#money_type#</cfif>
                                </cfloop>
                            </td>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "other_money_value")>
                                <td style="text-align:right;">
                                <cfif isdefined("fl_total")>
                                    <cfif ListFindNoCase(display_list, "price_other")>
                                        <cfif (sepet.satir[i].price_other neq sepet.satir[i].price) and (sepet.satir[i].price_other neq 0)>
                                            <cfset fl_other_money = ((sepet.satir[i].amount * sepet.satir[i].price_other)/100000000000000000000) * sepet.satir[i].indirim_carpan>
                                        <cfelse>
                                            <cfset fl_other_money = sepet.satir[i].other_money_value> 
                                        </cfif>
                                    <cfelse>
                                        <cfset fl_other_money = (sepet.satir[i].row_total / 100000000000000000000) * sepet.satir[i].indirim_carpan / fl_total >
                                        <cfif fl_other_money neq sepet.satir[i].other_money_value and sepet.satir[i].other_money_value neq 0 >
                                            <cfset fl_other_money = sepet.satir[i].other_money_value >
                                        </cfif>							
                                    </cfif>
                                <cfelse>
                                    <cfset fl_other_money = sepet.satir[i].other_money_value >
                                </cfif>
                                <!--- önceden sepet şablonunda olmayan yerlerde sonradan şablondan seçilme sorununa karşı--->
                                <cfif fl_other_money is "">
                                    <cfset fl_other_money = sepet.satir[i].price>
                                </cfif>
                                <cfset sepet.satir[i].other_money_grosstotal = (fl_other_money*(sepet.satir[i].tax_percent+100))/100>
                                #TLFormat(fl_other_money)#
                                </td>
                                <td style="text-align:right;">#TLFormat(sepet.satir[i].other_money_grosstotal)#</td>
                            </cfif>
                            <cfif ListFindNoCase(display_list, "deliver_date")><td  nowrap style="text-align:right;">#sepet.satir[i].deliver_date#</td></cfif>
                            <cfif ListFindNoCase(display_list, "deliver_dept")>
                                <td  nowrap style="text-align:right;">
                                <cfif len(listsort(sepet.satir[i].deliver_dept,"Text","asc","-"))>
                                    <cfset attributes.department_id = listgetat(sepet.satir[i].deliver_dept,1,"-")>
                                    <cfif len(trim(attributes.department_id))>
                                        <cfif listlen(attributes.department_id,"-") eq 2>  <!--- sepet.satir[i].deliver_dept --->
                                            <cfset attributes.department_location = attributes.department_id>  <!--- sepet.satir[i].deliver_dept --->
                                            <cfinclude template="../query/get_department_location.cfm">
                                            <cfset department_head = "#department_head#-#get_department_location.comment#">
                                        <cfelse>
                                            <cfinclude template="../query/get_department.cfm">
                                            <cfset department_head = get_department.DEPARTMENT_HEAD>
                                        </cfif>
                                    <cfelse>
                                        <cfset department_head = "">
                                    </cfif>
                                <cfelse>
                                    <cfset department_head = "">
                                </cfif>
                                #DEPARTMENT_HEAD# 
                                </td>
                            </cfif>
                                <cfif ListFindNoCase(display_list, "is_parse")>
                                <td><!--- asortiler özel durumu olabilir ---></td>
                                </cfif>
                                <cfif ListFindNoCase(display_list, "lot_no")>
                                    <td  nowrap style="text-align:right;">#sepet.satir[i].lot_no#</td>
                                </cfif>
                                <cfif ListFindNoCase(display_list, "shelf_number")>
                                    <cfif StructKeyExists(sepet.satir[i],'shelf_number') and len(sepet.satir[i].shelf_number)>
                                        <cfquery name="get_shelf_name" datasource="#dsn3#">
                                            SELECT SHELF_CODE FROM PRODUCT_PLACE WHERE PLACE_STATUS=1 AND PRODUCT_PLACE_ID=#sepet.satir[i].shelf_number#
                                        </cfquery>
                                        <cfif len(get_shelf_name.SHELF_CODE)>
                                            <cfset temp_shelf_number_ = get_shelf_name.SHELF_CODE>
                                        <cfelse>
                                            <cfset temp_shelf_number_ = ''>
                                        </cfif>
                                        <td nowrap style="text-align:right;">#temp_shelf_number_#</td>
                                    <cfelse>
                                        <td nowrap>&nbsp;</td>
                                    </cfif>
                                    
                                </cfif>
                                <cfif ListFindNoCase(display_list, "order_currency")>
                                    <cfif StructKeyExists(sepet.satir[i],'order_currency') and len(sepet.satir[i].order_currency )>
                                        <cfloop from="1" to="#listlen(order_currency_list)#" index="cur_list">
                                            <cfif sepet.satir[i].order_currency eq (-1*cur_list)>
                                                <td nowrap>#ListGetAt(order_currency_list,(-1*sepet.satir[i].order_currency),",")#</td>
                                            </cfif>
                                        </cfloop>
                                    <cfelse>
                                        <td nowrap>&nbsp;</td>
                                    </cfif>
                                </cfif>
                                <cfif ListFindNoCase(display_list, "reserve_type")>
                                    <cfif StructKeyExists(sepet.satir[i],'reserve_type') and len(sepet.satir[i].reserve_type )>
                                        <cfloop from="1" to="#listlen(reserve_type_list)#" index="cur_list">
                                            <cfif sepet.satir[i].reserve_type eq (-1*cur_list)>
                                                <td nowrap>#ListGetAt(reserve_type_list,(-1*sepet.satir[i].reserve_type),",")#</td>
                                            </cfif>
                                        </cfloop>
                                    <cfelse>
                                        <td nowrap>&nbsp;</td>
                                    </cfif>
                                </cfif>
                                <cfif ListFindNoCase(display_list, "reserve_date")>
                                    <td nowrap><cfif StructKeyExists(sepet.satir[i],'reserve_date') and len(sepet.satir[i].reserve_date)>#sepet.satir[i].reserve_date#</cfif></td>
                                </cfif>
                        </tr>
                    </cfoutput> 
                </cfloop>
            </tbody>
        </table>
    </div>

<cfif ListFindNoCase(display_list, "price_total")>
	<cfscript>
	sa_percent = 0;
	if (((fusebox.circuit is 'invoice') or listfind("1,2,3,4,10,14,18,20,21,33,38,51,52",attributes.basket_id,","))and arraylen(sepet.satir))
		{
		if (not isnumeric(sepet.genel_indirim)) sepet.genel_indirim = 0;
		if ((sepet.total-sepet.toplam_indirim) gt 0)
			{
			/*sa_percent = Round((sepet.genel_indirim / sepet.total) * 1000) / 10;
			sepet.total_tax = (sepet.total_tax / 100) * (100-sa_percent);
			sepet.toplam_indirim = sepet.toplam_indirim + sepet.genel_indirim;
			sepet.net_total = (sepet.net_total / 100) * (100-sa_percent);*/
			sa_percent = (sepet.genel_indirim / (sepet.total-sepet.toplam_indirim)) * 100;
			sepet.total_tax = wrk_round( (sepet.total_tax * (100-sa_percent)) / 100 );
			sepet.toplam_indirim = sepet.toplam_indirim + sepet.genel_indirim;
			sepet.net_total = wrk_round( (sepet.net_total * (100-sa_percent)) / 100 );
			}
		}
	</cfscript>
	<cfinclude template="dsp_basket_total_view_js.cfm">
</cfif>
