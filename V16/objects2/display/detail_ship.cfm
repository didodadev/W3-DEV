<cf_get_lang_set module_name="objects">
<cfquery name="GET_UPD_PURCHASE" datasource="#DSN2#">
	SELECT 
		S.COMPANY_ID,
		S.CONSUMER_ID,
		S.SHIP_NUMBER,
		S.SHIP_TYPE,
		S.SHIP_DATE,
		S.DELIVER_DATE,
		S.SHIP_METHOD,
		S.DEPARTMENT_IN,
		S.DELIVER_STORE_ID,
		S.NETTOTAL,
		S.TAXTOTAL,
		S.LOCATION_IN,
		S.LOCATION,
		S.PROJECT_ID,
		SR.NAME_PRODUCT,
		SR.PRODUCT_NAME2,
		SR.AMOUNT,
		SR.UNIT,
		SR.PRICE,
		SR.TAX,
		SR.DISCOUNT,
		SR.DISCOUNT2,
		SR.DISCOUNT3,
		SR.OTHER_MONEY,
		SR.PRICE_OTHER,
		S.FREE_PROM_LIMIT
	FROM 
		SHIP S,
		SHIP_ROW SR
	WHERE 
     	S.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.company_id#"> AND
		S.SHIP_ID = SR.SHIP_ID AND
		S.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
</cfquery>

<cfif not get_upd_purchase.recordcount>
	<script>
		alert('Yetkiniz Yok');
		window.history.back(-1);
	</script>
    <cfabort>
</cfif>

<cfquery name="GET_ORDER" datasource="#DSN3#">
	SELECT 
		O.ORDER_NUMBER
	FROM 
		ORDERS_SHIP OS,	
		ORDERS O 
	WHERE 
		OS.ORDER_ID = O.ORDER_ID AND
		OS.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#"> AND 
		OS.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.pp.period_id#">
</cfquery>

<cfquery name="GET_INVOICE_SHIPS" datasource="#DSN2#">
	SELECT
		ISH.SHIP_PERIOD_ID,
		ISH.INVOICE_ID,
        ISH.INVOICE_NUMBER,
		I.PURCHASE_SALES <!--- 1 satis, 0 alis --->
	FROM
		INVOICE I,
		INVOICE_SHIPS ISH
	WHERE
		I.INVOICE_ID = ISH.INVOICE_ID AND
		ISH.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
</cfquery>

<table border="0" cellspacing="0" cellpadding="0" style="width:100%; height:100%;">
	<tr class="color-border">
		<td>
            <table border="0" cellspacing="1" cellpadding="2" style="width:100%; height:100%;">
                <tr class="color-list" style="height:35px;">
                    <td class="headbold">&nbsp;<cf_get_lang no='700.İrsaliye Bilgileri'></td>
                </tr>
                <tr class="color-row">
                    <td style="vertical-align:top;">
                        <table border="0"  cellpadding="0" cellspacing="0">
                            <tr>
                                <td style="width:350px; vertical-align:top;">
                                    <table style="width:99%;">
                                        <tr>
                                            <td colspan="2" class="txtboldblue">
												<cfif len(get_upd_purchase.company_id) and get_upd_purchase.company_id neq 0> 
                                                    <cfset attributes.company_id = get_upd_purchase.company_id>
                                                    <cfquery name="COMPANY_NAME" datasource="#DSN#">
                                                        SELECT
                                                            NICKNAME,
                                                            COMPANY_ID,
                                                            FULLNAME,
                                                            COMPANY_ADDRESS,
                                                            COUNTY,
                                                            CITY,
                                                            COUNTRY,
                                                            TAXOFFICE,
                                                            TAXNO
                                                        FROM
                                                            COMPANY
                                                        WHERE
                                                            COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
                                                    </cfquery>
                                                    <cfoutput>#company_name.fullname#</cfoutput>
                                                <cfelseif len(get_upd_purchase.consumer_id)>
                                                    <cfquery name="GET_CONSUMER" datasource="#DSN#">
                                                        SELECT 
                                                            CONSUMER_NAME,
                                                            CONSUMER_SURNAME, 
                                                            COMPANY,
                                                            WORKADDRESS,
                                                            WORK_COUNTY_ID,
                                                            WORK_CITY_ID,
                                                            WORK_COUNTRY_ID,
                                                            TAX_OFFICE,
                                                            TAX_NO,							  
                                                            CONSUMER_ID 
                                                        FROM 
                                                            CONSUMER 
                                                        WHERE 
                                                            CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.consumer_id#">
                                                    </cfquery>
                                                    <cfoutput>#get_consumer.company#</cfoutput>
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2" class="txtboldblue">
                                                <cfif len(get_upd_purchase.company_id) and (get_upd_purchase.company_id neq 0)>
                                                    <cfif len(company_name.city)>
                                                        <cfquery name="GET_CITY" datasource="#DSN#">
                                                            SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_name.city#">
                                                        </cfquery>
                                                    </cfif>
                                                    <cfif len(company_name.county)>
                                                        <cfquery name="GET_COUNTY" datasource="#DSN#">
                                                            SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_name.county#">
                                                        </cfquery>
                                                    </cfif>
                                                    <cfif len(company_name.country)>
                                                        <cfquery name="GET_COUNTRY" datasource="#DSN#">
                                                            SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#company_name.country#">
                                                        </cfquery>
                                                    </cfif>
                                                    <cfoutput>
                                                        #company_name.company_address#  
                                                        <cfif isdefined('get_county') and get_county.recordcount> - #get_county.county_name#</cfif>
                                                        <cfif isdefined('get_city') and get_city.recordcount> - #get_city.city_name#</cfif>
                                                        <cfif isdefined('get_country') and get_country.recordcount> - #get_country.country_name#</cfif>
                                                    </cfoutput>
												<cfelseif len(get_upd_purchase.consumer_id)>
                                                    <cfoutput>#get_consumer.consumer_name# #get_consumer.consumer_surname#</cfoutput>
                                                    <cfif len(get_consumer.work_county_id)>
                                                        <cfquery name="GET_COUNTY2" datasource="#DSN#">
                                                            SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_county_id#">
                                                        </cfquery>
                                                    </cfif>
                                                    <cfif len(get_consumer.work_city_id)>
                                                        <cfquery name="GET_CITY2" datasource="#DSN#">
                                                            SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_city_id#">
                                                        </cfquery>
                                                    </cfif>
                                                    <cfif len(get_consumer.work_country_id)>
                                                        <cfquery name="GET_COUNTRY2" datasource="#DSN#">
                                                            SELECT COUNTRY_NAME FROM SETUP_COUNTRY WHERE COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_consumer.work_country_id#">
                                                        </cfquery>
                                                    </cfif>				  
                                                    <cfoutput>
                                                        #get_consumer.workaddress#
                                                        <cfif len(get_consumer.work_county_id)> - #get_county2.county_name#</cfif>
                                                        <cfif len(get_consumer.work_city_id)> - #get_city2.city_name#</cfif>
                                                        <cfif len(get_consumer.work_country_id)> - #get_country2.country_name#</cfif>
                                                    </cfoutput>
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="txtboldblue"><cf_get_lang_main no='1350.Vergi Dairesi'> : </td>
                                            <td style="width:200px;">
                                                <cfif len(get_upd_purchase.company_id) and get_upd_purchase.company_id neq 0>
                                                    <cfoutput>#company_name.taxoffice#</cfoutput>
                                                <cfelseif len(get_upd_purchase.consumer_id)>
                                                    <cfoutput>#get_consumer.tax_office#</cfoutput>
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="txtboldblue"><cf_get_lang_main no='340.Vergi No'> : </td>
                                            <td><cfif len(get_upd_purchase.company_id) and get_upd_purchase.company_id neq 0>
                                                    <cfoutput>#company_name.taxno#</cfoutput>
                                                <cfelseif len(get_upd_purchase.consumer_id)>
                                                    <cfoutput>#get_consumer.tax_no#</cfoutput>
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="txtboldblue"><cf_get_lang_main no='4.Proje'> : </td>
                                            <td><cfif len(get_upd_purchase.project_id)>
                                                    <cfquery name="GET_PROJECT_NAME" datasource="#DSN#">
                                                        SELECT PROJECT_HEAD FROM PRO_PROJECTS WHERE PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.project_id#">
                                                    </cfquery>
                                                    <cfoutput>#get_project_name.project_head#</cfoutput>
                                                </cfif>
                                            </td>
                                        </tr>
                                       	<tr>
                                            <td class="txtboldblue"><cf_get_lang_main no='799.Sipariş No'> : </td>
                                            <td>
												<cfif get_order.recordcount>
                                                	<cfoutput query="get_order">
                                                		#order_number#<br/>
                                                    </cfoutput>
												</cfif>                                            
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td style="width:350px; vertical-align:top;">
                                    <table style="width:98%;">
                                        <tr>
                                            <td class="txtboldblue"><cf_get_lang_main no='75.No'> : </td>
                                            <td><cfoutput><strong>#get_upd_purchase.ship_number#</strong></cfoutput>
                                                <!---<cfif get_upd_purchase.ship_type eq 70><cf_get_lang no='701.Parekande Satış İrsaliyesi'>
                                                <cfelseif get_upd_purchase.ship_type eq 71><cf_get_lang no='702.Toptan Satış İrsaliyesi'>
                                                <cfelseif get_upd_purchase.ship_type eq 72><cf_get_lang no='703.Konsinye Çıkış İrsaliyesi'>
                                                <cfelseif get_upd_purchase.ship_type eq 78><cf_get_lang no='704.Alım İade İrsaliyesi'>
                                                <cfelseif get_upd_purchase.ship_type eq 79><cf_get_lang no='705.Konsinye Giriş İade İrsaliye'>--->
                                               	<cfif get_upd_purchase.ship_type eq 70><cf_get_lang_msin no='1782.Parekande Satış İrsaliyesi'>
                                                <cfelseif get_upd_purchase.ship_type eq 71><cf_get_lang_main no='1340.Toptan Satış İrsaliyesi'>
                                                <cfelseif get_upd_purchase.ship_type eq 72><cf_get_lang_main no='1341.Konsinye Çıkış İrsaliyesi'>
                                                <cfelseif get_upd_purchase.ship_type eq 78><cf_get_lang_main no='1787.Alım İade İrsaliyesi'>
                                                <cfelseif get_upd_purchase.ship_type eq 79><cf_get_lang_main no='1788.Konsinye Giriş İade İrsaliye'>
                                                </cfif>
                                            </td>
                                        </tr>
                                        <cfif get_invoice_ships.recordcount>
                                            <tr>
                                                <td class="txtboldblue" style="width:100px;"><cf_get_lang_main no='721.Fatura No'> : </td>
                                                <td><cfoutput>
                                                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_detail_invoice&period_id=#Encrypt(get_invoice_ships.ship_period_id,session_base.userid,"CFMX_COMPAT","Hex")#&id=#Encrypt(get_invoice_ships.invoice_id,'AASDFSAD23423',"CFMX_COMPAT","Hex")#','list','popup_detail_invoice');" class="tableyazi">#get_invoice_ships.invoice_number#</a>
                                                    </cfoutput>
                                                </td>
                                            </tr>
                                        </cfif>
                                        <tr>
                                            <td class="txtboldblue"><cf_get_lang no='706.İrsaliye Tarihi'> : </td>
                                            <td><cfoutput>#dateformat(get_upd_purchase.ship_date,"dd/mm/yyyy")#</cfoutput></td>
                                        </tr>
                                        <tr>
                                            <td class="txtboldblue"><cf_get_lang_main no='233.Teslim Tarihi'> :</td>
                                            <td><cfoutput>#dateformat(get_upd_purchase.deliver_date,"dd/mm/yyyy")#</cfoutput></td>
                                        </tr>
                                        <tr>
                                            <td class="txtboldblue"><cf_get_lang_main no='1349.Sevk'> :</td>
                                            <td><cfif len(get_upd_purchase.ship_method)>
                                                    <cfquery name="SHIP_METHODS" datasource="#DSN#">
                                                        SELECT SHIP_METHOD FROM SHIP_METHOD WHERE SHIP_METHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.ship_method#">
                                                    </cfquery>
                                                    <cfoutput>#ship_methods.ship_method#</cfoutput>				
                                                </cfif>
                                            </td>								
                                        </tr>           
                                        <tr>
                                            <td class="txtboldblue"><cf_get_lang no ='1268.Giriş Depo'>:</td>
                                            <td><cfif len(get_upd_purchase.department_in)>
                                                    <cfquery name="GET_DEPT" datasource="#DSN#">
                                                        SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.department_in#">
                                                    </cfquery>
                                                    <cfoutput>#get_dept.department_head#</cfoutput>
                                                </cfif>
                                                <cfif len(get_upd_purchase.location_in)>
                                                    <cfquery name="GET_DEPT_LOCATION" datasource="#DSN#">
                                                        SELECT COMMENT FROM STOCKS_LOCATION WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.department_in#"> AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.location_in#">
                                                    </cfquery>
                                                    <cfoutput>-#get_dept_location.comment#</cfoutput>
                                                </cfif>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="txtboldblue"><cf_get_lang_main no ='1631.Çıkış Depo'>:</td>
                                            <td><cfif len(get_upd_purchase.deliver_store_id)>
                                                    <cfquery name="GET_DEPT1" datasource="#DSN#">
                                                        SELECT DEPARTMENT_HEAD FROM DEPARTMENT WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.deliver_store_id#">
                                                    </cfquery>
                                                    <cfoutput>#get_dept1.department_head#</cfoutput>
                                                </cfif>
                                                <cfif len(get_upd_purchase.location)>
                                                    <cfquery name="GET_DEPT_LOCATION1" datasource="#DSN#">
                                                        SELECT COMMENT FROM STOCKS_LOCATION WHERE DEPARTMENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.deliver_store_id#"> AND LOCATION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_upd_purchase.location#">
                                                    </cfquery>
                                                    <cfoutput>-#get_dept_location1.comment#</cfoutput>
                                                </cfif>
                                            </td>
                                        </tr> 
                                        <tr>
                                            <td class="txtboldblue"><cf_get_lang_main no ='230.Net Toplam'> : </td>
                                            <td><cfoutput>#TLFormat(get_upd_purchase.nettotal-get_upd_purchase.taxtotal)#</cfoutput></td>
                                        </tr>
                                        <tr>
                                            <td class="txtboldblue"><cf_get_lang_main no ='231.KDV Toplam'> : </td>
                                            <td><cfoutput>#TLFormat(get_upd_purchase.taxtotal)#</cfoutput></td>
                                        </tr>
                                        <tr>
                                            <td class="txtboldblue"><cf_get_lang_main no ='268.Genel Toplam'> :</td>
                                            <td><cfoutput>#TLFormat(get_upd_purchase.nettotal)#</cfoutput></td>
                                        </tr>			
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <br/><br/>	
                        <table cellpadding="0" cellspacing="0" border="0" align="center" style="width:98%;">
                            <tr>
                                <td class="color-border">
                                    <table border="0" cellspacing="1" cellpadding="2" align="center" style="width:100%;">
                                        <tr class="color-header"> 
                                            <td clasS="form-title"><cf_get_lang_main no='217.Açıklama'></td>
                                            <td clasS="form-title"><cf_get_lang_main no='223.Miktar'></td>
                                            <td clasS="form-title"><cf_get_lang_main no='224.Birim'></td>
                                            <td clasS="form-title"><cf_get_lang_main no='226.B Fiyat'></td>
                                            <td clasS="form-title"><cf_get_lang_main no='227.KDV'></td>
                                            <td clasS="form-title"><cf_get_lang_main no='228.Vade'></td>
                                            <td clasS="form-title"><cf_get_lang_main no='265.Döviz'> <cf_get_lang_main no='672.Fiyat'></td>
                                            <td clasS="form-title"><cf_get_lang_main no='229.İndirim'>1</td>
                                            <td clasS="form-title"><cf_get_lang_main no='229.İndirim'>2</td>
                                            <td clasS="form-title"><cf_get_lang_main no='229.İndirim'>3</td>
                                            <td clasS="form-title"><cf_get_lang_main no='80.Toplam'></td>
                                            <td clasS="form-title"><cf_get_lang_main no='230.NToplam'></td>
                                            <td clasS="form-title"><cf_get_lang_main no='231.KDV Top'></td>
                                            <td clasS="form-title"><cf_get_lang_main no='232.Son Top'></td>
                                        </tr>		
										<cfoutput query="get_upd_purchase">
                                            <tr class="color-row">
                                                <td>#get_upd_purchase.name_product#</td>
                                                <td  style="text-align:right;">#TLFormat(get_upd_purchase.amount)#</td>
                                                <td>#get_upd_purchase.unit#</td>
                                                <td  style="text-align:right;">#TLFormat(get_upd_purchase.price,4)#</td>
                                                <td  style="text-align:right;">#get_upd_purchase.tax#</td>
                                                <td  style="text-align:right;"></td>
                                                <td  style="text-align:right;">#TLFormat(get_upd_purchase.price_other,4)#&nbsp;#get_upd_purchase.other_money#</td>
                                                <td  style="text-align:right;">#TLFormat(get_upd_purchase.discount)#</td>
                                                <td  style="text-align:right;">#TLFormat(get_upd_purchase.discount2)#</td>
                                                <td  style="text-align:right;">#TLFormat(get_upd_purchase.discount3)#</td>
                                                <cfif not len(get_upd_purchase.price)>
                                                    <cfset get_upd_purchase.price = 0>
                                                </cfif>
                                                <td  style="text-align:right;">#TLFormat(get_upd_purchase.amount * get_upd_purchase.price)#</td>
                                                <cfset net_satir = ( (get_upd_purchase.amount * get_upd_purchase.price)*(100-get_upd_purchase.discount) /100)>
                                                <td  style="text-align:right;">#TLFormat(net_satir)#</td>
                                                <td  style="text-align:right;">#TLFormat(net_satir*(get_upd_purchase.tax/100))#</td>
                                                <td  style="text-align:right;">#TLFormat(net_satir+(net_satir*(get_upd_purchase.tax/100)))#</td>
                                            </tr>
                                        </cfoutput>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <br><br><br>
                        <cfquery name="GET_SHIP_MONEY" datasource="#DSN2#">
                            SELECT 
                            	MONEY_TYPE,
                                RATE1,
                                RATE2
                            FROM 
                            	SHIP_MONEY 
                            WHERE 
                            	ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
                        </cfquery>
                        <cfquery name="GET_INVOICE_SHIPS_MONEY" datasource="#DSN2#">
                            SELECT
                                IM.MONEY_TYPE,
                                IM.RATE1,
                                IM.RATE2
                            FROM
                                INVOICE_SHIPS ISH,
                                INVOICE_MONEY IM
                            WHERE
                                ISH.INVOICE_ID = IM.ACTION_ID AND
                                ISH.SHIP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ship_id#">
                        </cfquery>
                        <cfif get_ship_money.recordcount>
                            <table>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td colspan="2" class="txtboldblue">
                                        <!---<cf_get_lang no='641.Kur Bilgileri'>--->
                                        <cf_get_lang_main no='262.Kur Bilgileri'>
                                    </td>
                                </tr>
                                <cfoutput query="get_ship_money">
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td>#get_ship_money.money_type#</td>
                                        <td>#get_ship_money.rate1# / #TLFormat(get_ship_money.rate2)#</td>
                                    </tr>
                                </cfoutput>
                            </table>
                        <cfelseif get_invoice_ships_money.recordcount>
                            <table>
                                <tr>
                                    <td>&nbsp;</td>
                                    <td colspan="2" class="txtboldblue">
                                        <!---<cf_get_lang no='641.Kur Bilgileri'>--->
                                        <cf_get_lang_main no='262.Kur Bilgileri'>                            
                                    </td>
                                </tr>
                                <cfoutput query="get_invoice_ships_money">
                                    <tr>
                                        <td>&nbsp;</td>
                                        <td>#get_invoice_ships_money.money_type#</td>
                                        <td>#get_invoice_ships_money.rate1# / #TLFormat(get_invoice_ships_money.rate2)#</td>
                                    </tr>
                            </cfoutput>
                            </table>
                        </cfif>
                    </td>
                </tr>
            </table>		
		</td>
	</tr>
</table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
