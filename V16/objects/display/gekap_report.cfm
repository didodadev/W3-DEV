<cfset gekap_cfc = createObject("component","V16.objects.cfc.gekap_report")>
<cfset getPeriods = gekap_cfc.getPeriods()>
<cfparam name="attributes.period" default="">
<cfparam name="attributes.year" default="">
<cfparam name="attributes.last_year" default="#session.ep.period_year-1#">
<cfparam name="attributes.startdate" default="">
<cfparam name="attributes.finishdate" default="">
<cfif len(attributes.year)>
    <cfif attributes.period eq 1>
        <cfset attributes.startdate = dateformat(CreateDate(attributes.year,1,1))>
        <cfset attributes.finishdate = dateformat(CreateDate(attributes.year,3,daysinmonth(createdate(attributes.year,3,1))))>
    <cfelseif attributes.period eq 2>
        <cfset attributes.startdate = dateformat(CreateDate(attributes.year,4,1))>
        <cfset attributes.finishdate = dateformat(CreateDate(attributes.year,6,daysinmonth(createdate(attributes.year,6,1))))>
    <cfelseif attributes.period eq 3>
        <cfset attributes.startdate = dateformat(CreateDate(attributes.year,7,1))>
        <cfset attributes.finishdate = dateformat(CreateDate(attributes.year,9,daysinmonth(createdate(attributes.year,9,1))))>
    <cfelseif attributes.period eq 4>
        <cfset attributes.startdate = dateformat(CreateDate(attributes.year,10,1))>
        <cfset attributes.finishdate = dateformat(CreateDate(attributes.year,12,daysinmonth(createdate(attributes.year,12,1))))>
    </cfif>
    <cfset attributes.last_year= (attributes.year-1) >
</cfif>
<cfset getInvoice = gekap_cfc.get_invoice(year:attributes.year,period:attributes.period,startdate:attributes.startdate,finishdate:attributes.finishdate)>
<cfset getInvoice_domestic = gekap_cfc.get_invoice_domestic(year:attributes.year,period:attributes.period,startdate:attributes.startdate,finishdate:attributes.finishdate)>
<cfset getInvoice_imported = gekap_cfc.get_invoice_imported(year:attributes.year,period:attributes.period,startdate:attributes.startdate,finishdate:attributes.finishdate)>
<cfset getInvoice_last = gekap_cfc.get_invoice_last_year(last_year:attributes.last_year,period:attributes.period,startdate:attributes.startdate,finishdate:attributes.finishdate)>
<cfset get_invoice_return = gekap_cfc.get_invoice_return(year:attributes.year,period:attributes.period,startdate:attributes.startdate,finishdate:attributes.finishdate)>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#getInvoice.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-xs-12">
    <cf_box title="#getLang('','Geri Kazanım Payı Beyanname Hazırlama Raporu',62239)#">
        <cfform name="gekap_report" action="#request.self#?fuseaction=recycle.gekap_report">
            <cf_box_search>
                    <div class="form-group medium">
                        <select name="year" id="year" >
                            <option value=""><cf_get_lang dictionary_id='58455.Yıl'></option>
                            <cfoutput query="getPeriods">
                                <option value="#PERIOD_YEAR#" <cfif attributes.year eq period_year>selected</cfif>>#PERIOD_YEAR#</option>
                            </cfoutput>
                        </select>
                    </div>
                    <div class="form-group medium">
                        <select name="period" id="period" onchange="select_year()">
                            <option value=""><cf_get_lang dictionary_id='58472.Dönem'></option>
                            <option value="1" <cfif attributes.period eq 1>selected</cfif>>1. <cf_get_lang dictionary_id='52247.Çeyrek'></option>
                            <option value="2" <cfif attributes.period eq 2>selected</cfif>>2. <cf_get_lang dictionary_id='52247.Çeyrek'></option>
                            <option value="3" <cfif attributes.period eq 3>selected</cfif>>3. <cf_get_lang dictionary_id='52247.Çeyrek'></option>
                            <option value="4" <cfif attributes.period eq 4>selected</cfif>>4. <cf_get_lang dictionary_id='52247.Çeyrek'></option>
                        </select>
                    </div>
                    <div class="form-group">
                        <cf_wrk_search_button button_type="4">
                    </div>
            </cf_box_search>
            <cf_seperator id="plastic_bag_sales" title="#getLang('','Plastik Poşet Satışları',60330)#">
                <div id="plastic_bag_sales">
                    <cf_grid_list>
                        <thead>
                            <th><cf_get_lang dictionary_id='56759.Temin Edilen'><cf_get_lang dictionary_id='58219.Ülke'></th>
                            <th><cf_get_lang dictionary_id='56759.Temin Edilen'><cf_get_lang dictionary_id='58608.İl'></th>
                            <th><cf_get_lang dictionary_id='29533.Tedarikçi'><cf_get_lang dictionary_id='65057.TCKN'>/ <cf_get_lang dictionary_id='57752.Vergi No'></th>
                            <th><cf_get_lang dictionary_id='29533.Tedarikçi'><cf_get_lang dictionary_id='57631.Ad'>/ <cf_get_lang dictionary_id='57571.Ünvan'></th>
                            <th><cf_get_lang dictionary_id='58724.Ay'></th>
                            <th class="text-right"><cf_get_lang dictionary_id='56683.Satılan Poşet Adeti'></th>
                            <th class="text-right"><cf_get_lang dictionary_id='39129.Satış Tutarı'></th>
                        </thead>
                        <cfif getInvoice.recordcount>
                            <cfset company_list = ''>
                            <cfoutput query="getInvoice">
                                <cfif len(company_id) and not listfind(company_list,company_id)>
                                    <cfset company_list = listappend(company_list,company_id)>
                                </cfif>
                            </cfoutput>
                            <cfif len(company_list)>
                                <cfset get_comp_info = gekap_cfc.get_comp_info(company_list:company_list)>
                                <cfset company_list=listsort(valuelist(get_comp_info.company_id,','),"numeric","ASC",",")>
                            </cfif>
                            <cfquery name="total_sales" dbtype="query">
                                SELECT SUM(SALES_TOTAL) AS total_bag_sales FROM getInvoice
                            </cfquery>
                            <cfoutput query="getInvoice">
                                <tbody>
                                    <tr>
                                        <td><cfif invoice_cat eq 531><cf_get_lang dictionary_id='29692.Yurtdışı'><cfelseif invoice_cat eq 52 or invoice_cat eq 53><cf_get_lang dictionary_id='29691.Yurtiçi'></cfif></td>
                                        <td><cfif len(company_list)>#get_comp_info.city_name[listfind(company_list,company_id,',')]#</cfif></td>
                                        <td><cfif len(company_list)><cfif len(get_comp_info.TC_IDENTITY) or len(get_comp_info.taxno)>#get_comp_info.TC_IDENTITY[listfind(company_list,company_id,',')]# / #get_comp_info.taxno[listfind(company_list,company_id,',')]#</cfif></cfif></td>
                                        <td><cfif len(company_list)>#get_comp_info.company_name[listfind(company_list,company_id,',')]#</cfif></td>
                                        <td>#Listgetat(ay_list(),SALES_MONTH,',')#</td>
                                        <td class="moneybox">#TLformat(SALES_QUANTITY)#</td>
                                        <td class="moneybox">#Tlformat(SALES_TOTAL)#</td>
                                    </tr>
                                </tbody>
                            </cfoutput>
                        <cfelse>
                            <tr>
                                <td colspan="30"> <cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                            </tr>
                        </cfif>
                    </cf_grid_list>
                </div>
            <cf_seperator id="domestically_supplied_products" title="#getLang('','Yurtiçinde Üretilerek Arz Edilen Ürünler',55937)#">
                <div id="domestically_supplied_products">
                    <cf_grid_list>
                        <thead>
                            <th><cf_get_lang dictionary_id='65342.Geri Kazanım Grubu'>/ <cf_get_lang dictionary_id='57657.Ürün'></th>
                            <th><cf_get_lang dictionary_id='51855.Depozito Onay Kodu'></th>
                            <th class="text-right"><cf_get_lang dictionary_id='37618.Birim Tutar'></th>
                            <th class="text-right"><cf_get_lang dictionary_id='57635.Miktar'></th>
                            <th class="text-right"><cf_get_lang dictionary_id='57673.Tutar'></th>
                        </thead>
                        <tbody>
                            <cfif getInvoice_domestic.recordcount>
                                <cfquery name="total_sales_dom" dbtype="query">
                                    SELECT SUM(SALES_TOTAL) AS total_domestic FROM getInvoice_domestic 
                                </cfquery>
                                <cfoutput query="getInvoice_domestic">
                                    <tbody>
                                        <td>#RECYCLE_SUB_GROUP# / #PRODUCT_NAME#</td>
                                        <td></td>
                                        <td class="moneybox">#Tlformat(SALES_UNIT_AMOUNT)#</td>
                                        <td class="moneybox">#Tlformat(SALES_QUANTITY)#</td>
                                        <td class="moneybox">#Tlformat(SALES_TOTAL)#</td>
                                    </tbody>
                                </cfoutput>
                            <cfelse>
                                <tr>
                                    <td colspan="30"> <cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                                </tr>
                            </cfif>
                        </tbody>
                    </cf_grid_list>
                </div>
            <cf_seperator id="imported_products" title="#getLang('','İthal Edilerek Arz Edilen Ürünler',54065)#">
                <div id="imported_products">
                    <cf_grid_list>
                        <thead>
                            <th><cf_get_lang dictionary_id='65342.Geri Kazanım Grubu'>/ <cf_get_lang dictionary_id='57657.Ürün'></th>
                            <th><cf_get_lang dictionary_id='51855.Depozito Onay Kodu'></th>
                            <th><cf_get_lang dictionary_id='37618.Birim Tutar'></th>
                            <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                            <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                        </thead>
                        <tbody>
                            <cfif getInvoice_imported.recordcount>
                                <cfquery name="total_sales_imp" dbtype="query">
                                    SELECT SUM(SALES_TOTAL) AS total_imported FROM getInvoice_imported  
                                </cfquery>
                                <cfoutput query="getInvoice_imported">
                                    <tbody>
                                        <tbody>
                                            <td>#RECYCLE_SUB_GROUP# / #PRODUCT_NAME#</td>
                                            <td></td>
                                            <td class="moneybox">#Tlformat(SALES_UNIT_AMOUNT)#</td>
                                            <td class="moneybox">#Tlformat(SALES_QUANTITY)#</td>
                                            <td class="moneybox">#Tlformat(SALES_TOTAL)#</td>
                                        </tbody>
                                    </tbody>
                                </cfoutput>
                            <cfelse>
                                <tr>
                                    <td colspan="30"> <cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                                </tr>
                            </cfif>
                        </tbody>
                    </cf_grid_list>
                </div>
            <cf_seperator id="recycle_group_notices" title="#getLang('','Önceki Yıl',57940)# #getLang('','Depozito Kaynaklı Geri Kazanım Bildirimleri',53481)#">
                <div id="recycle_group_notices">
                    <cf_grid_list>
                        <thead>
                            <th><cf_get_lang dictionary_id='65342.Geri Kazanım Grubu'>/ <cf_get_lang dictionary_id='57657.Ürün'></th>
                            <th><cf_get_lang dictionary_id='51855.Depozito Onay Kodu'></th>
                            <th><cf_get_lang dictionary_id='37618.Birim Tutar'></th>
                            <th><cf_get_lang dictionary_id='57635.Miktar'></th>
                            <th><cf_get_lang dictionary_id='57673.Tutar'></th>
                        </thead>
                        <tbody>
                            <cfif getInvoice_last.recordcount>
                                <cfquery name="total_sales_last_year" dbtype="query">
                                    SELECT SUM(SALES_TOTAL) AS total_last FROM getInvoice_last  
                                </cfquery>
                                <cfoutput query="getInvoice_last">
                                    <tbody>
                                        <td>#RECYCLE_SUB_GROUP# / #PRODUCT_NAME#</td>
                                        <td></td>
                                        <td class="moneybox">#Tlformat(SALES_UNIT_AMOUNT)#</td>
                                        <td class="moneybox">#Tlformat(SALES_QUANTITY)#</td>
                                        <td class="moneybox">#Tlformat(SALES_TOTAL)#</td>
                                    </tbody>
                                </cfoutput>
                            <cfelse>
                                <tr>
                                    <td colspan="30"> <cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                                </tr>
                            </cfif>
                        </tbody>
                    </cf_grid_list>
                </div>
            <cf_seperator id="result" title="#getLang('','Sonuç',41580)#">
                <cfif get_invoice_return.recordcount>
                    <cfquery name="total_invoice_return" dbtype="query">
                        SELECT SUM(SALES_TOTAL) AS total_return FROM get_invoice_return  
                    </cfquery>
                </cfif>
                <div id="result">
                    <cf_box_elements>
                        <div class="col col-12 col-xs-12">
                            <div class="col col-6 col-xs-12">
                            </div>
                            <div class="col col-6 col-xs-12">
                                <div class="form-group">
                                <label class="col col-12 col-xs-12 bold"><h3>B - <cf_get_lang dictionary_id='42143.Gruplar'>,<cf_get_lang dictionary_id='51870.Yurtiçi/İthal Ürünler'></h3></label>
                                <div  class="col col-12 col-xs-12 bold"></div>
                            </div>
                        </div>
                        <div class="col col-6 col-xs-12">
                            <div class="form-group">
                                <cfif isDefined('total_sales')>
                                    <cfset total_bag_sales_ = total_sales.total_bag_sales>
                                <cfelse>
                                    <cfset total_bag_sales_ = 0>
                                </cfif>
                                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='56266.Poşet Geri Kazanım Tutarı'> - A</label>
                                <div class="col col-6 col-xs-12"> 
                                    <cfinput type="text" class="moneybox" name="bag_recovery_amount" id="bag_recovery_amount" value="#TLformat(total_bag_sales_)#">
                                </div>
                            </div>
                            <div class="form-group">
                                <cfif isDefined('total_sales_dom')>
                                    <cfset total_domestic_ = total_sales_dom.total_domestic>
                                <cfelse>
                                    <cfset total_domestic_ = 0>
                                </cfif>
                                <cfif isDefined('total_sales_imp')>
                                    <cfset total_imported_ = total_sales_imp.total_imported>
                                <cfelse>
                                    <cfset total_imported_ = 0>
                                </cfif>
                                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='32048.Yurtiçi/İthal Ürünler Geri Kazanım Tutarı'> - B</label>
                                <div class="col col-6 col-xs-12"> 
                                    <cfinput type="text" class="moneybox" name="domestic_product_recovery_amount" id="domestic_product_recovery_amount" value="#TLformat(total_domestic_ + total_imported_)#">
                                </div>
                            </div>
                            <div class="form-group">
                                <cfif isDefined('total_sales_last_year')>
                                    <cfset total_last_ = total_sales_last_year.total_last>
                                <cfelse>
                                    <cfset total_last_ = 0>
                                </cfif>
                                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='51654.Önceki Yıl Depozito Kaynaklı Geri Kazanım Tutarı'> - C</label>
                                <div class="col col-6 col-xs-12"> 
                                    <cfinput type="text" class="moneybox" name="last_bag_recovery_amount" id="last_bag_recovery_amount" value="#TLformat(total_last_)#">
                                </div>
                            </div>
                            <div class="form-group">
                                <cfif isDefined('total_invoice_return') and len(total_invoice_return.total_return)>
                                    <cfset total_return_ = total_invoice_return.total_return>
                                <cfelse>
                                    <cfset total_return_ = 0>
                                </cfif>
                                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='53571.Mahsup Edilen İade Tutarı'>(<cf_get_lang dictionary_id='53345.Poşet Hariç'>) - D</label>
                                <div class="col col-6 col-xs-12"> 
                                    <cfinput type="text" class="moneybox" name="return_recovery_amount" id="return_recovery_amount" value="#TLformat(total_return_)#">
                                </div>
                            </div>
                            <cfset import_recovery_amount_ = (total_domestic_ + total_imported_ + total_last_)-0>
                            <div class="form-group">
                                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='47468.Yurt içi Ürünlere İlişkin Ödenecek GEKAP Tutarı'>(<cf_get_lang dictionary_id='53345.Poşet Hariç'>) - E (E= (B+C)-D)</label>
                                <div class="col col-6 col-xs-12"> 
                                    <cfinput type="text" class="moneybox" name="import_recovery_amount" id="import_recovery_amount" value="#Tlformat(import_recovery_amount_)#">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='49745.Sonraki Döneme Devredecek GEKAP Tutarı'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <cfinput type="text" class="moneybox" name="next_year_recovery_amount" id="next_year_recovery_amount" value="#Tlformat(0)#">
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='54946.Ödenecek GEKAP Tutarı'>- A+E</label>
                                <div class="col col-6 col-xs-12"> 
                                    <cfinput type="text" class="moneybox" name="recovery_amount" id="recovery_amount" value="#TLformat(total_bag_sales_+import_recovery_amount_)#">
                                </div>
                            </div>
                        </div>
                        <div class="col col-6 col-xs-12">
                            <cfset mineral_oils = gekap_cfc.get_recycle_group_sales(year:attributes.year,period:attributes.period,startdate:attributes.startdate,finishdate:attributes.finishdate,recycle_id:8)>
                            <div class="form-group">
                                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='54865.Madeni Yağlar'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <input type="text" class="moneybox" name="mineral_oils" id="mineral_oils" value="<cfoutput><cfif mineral_oils.recordcount>#TLformat(mineral_oils.total_)#<cfelse>#TLformat(0)#</cfif></cfoutput>">
                                </div>
                            </div>
                            <div class="form-group">
                                <cfset elect_electronics = gekap_cfc.get_recycle_group_sales(year:attributes.year,period:attributes.period,startdate:attributes.startdate,finishdate:attributes.finishdate,recycle_id:9)>
                                <label class="col col-6 col-xs-12 "><cf_get_lang dictionary_id='43168.Elektrik,Elektronik Eşya'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <input type="text" class="moneybox" name="elect_electronics" id="elect_electronics" value="<cfoutput><cfif elect_electronics.recordcount>#TLformat(elect_electronics.total_)#<cfelse>#TLformat(0)#</cfif></cfoutput>">
                                </div>
                            </div>
                            <div class="form-group">
                                <cfset packaging = gekap_cfc.get_recycle_group_sales(year:attributes.year,period:attributes.period,startdate:attributes.startdate,finishdate:attributes.finishdate,recycle_id:10)>
                                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='41864.Ambalaj'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <input type="text" class="moneybox" name="packaging" id="packaging" value="<cfoutput><cfif packaging.recordcount>#TLformat(packaging.total_)#<cfelse>#TLformat(0)#</cfif></cfoutput>">
                                </div>
                            </div>
                            <div class="form-group">
                                <cfset medicine = gekap_cfc.get_recycle_group_sales(year:attributes.year,period:attributes.period,startdate:attributes.startdate,finishdate:attributes.finishdate,recycle_id:11)>
                                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='55884.İlaç'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <input type="text" class="moneybox" name="medicine" id="medicine" value="<cfoutput><cfif medicine.recordcount>#TLformat(medicine.total_)#<cfelse>#TLformat(0)#</cfif></cfoutput>">
                                </div>
                            </div>
                            <div class="form-group">
                                <cfset battery = gekap_cfc.get_recycle_group_sales(year:attributes.year,period:attributes.period,startdate:attributes.startdate,finishdate:attributes.finishdate,recycle_id:7)>
                                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='38487.Pil'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <input type="text" class="moneybox" name="battery" id="battery" value="<cfoutput><cfif battery.recordcount>#TLformat(battery.total_)#<cfelse>#TLformat(0)#</cfif></cfoutput>">
                                </div>
                            </div>
                            <div class="form-group">
                                <cfset accumulator = gekap_cfc.get_recycle_group_sales(year:attributes.year,period:attributes.period,startdate:attributes.startdate,finishdate:attributes.finishdate,recycle_id:15)>
                                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='44432.Akümülator'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <input type="text" class="moneybox" name="accumulator" id="accumulator" value="<cfoutput><cfif accumulator.recordcount>#TLformat(accumulator.total_)#<cfelse>#TLformat(0)#</cfif></cfoutput>">
                                </div>
                            </div>
                            <div class="form-group">
                                <cfset vegetable_oils = gekap_cfc.get_recycle_group_sales(year:attributes.year,period:attributes.period,startdate:attributes.startdate,finishdate:attributes.finishdate,recycle_id:13)>
                                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='49481.Bitkisel Yağlar'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <input type="text" class="moneybox" name="vegetable_oils" id="vegetable_oils" value="<cfoutput><cfif vegetable_oils.recordcount>#TLformat(vegetable_oils.total_)#<cfelse>#TLformat(0)#</cfif></cfoutput>">
                                </div>
                            </div>
                            <div class="form-group">
                                <cfset tire = gekap_cfc.get_recycle_group_sales(year:attributes.year,period:attributes.period,startdate:attributes.startdate,finishdate:attributes.finishdate,recycle_id:14)>
                                <label class="col col-6 col-xs-12"><cf_get_lang dictionary_id='49086.Lastik'></label>
                                <div class="col col-6 col-xs-12"> 
                                    <input type="text" class="moneybox" name="tire" id="tire" value="<cfoutput><cfif tire.recordcount>#TLformat(tire.total_)#<cfelse>#TLformat(0)#</cfif></cfoutput>">
                                </div>
                            </div>
                        </div>
                    </cf_box_elements>
                </div>
        </cfform>
    </cf_box>
</div>
<script>
    function select_year() {
        if($('#year').val() == '')
        {
            alert('<cf_get_lang dictionary_id='54029.Yıl Değerini Giriniz'>');
            $('#period').val('');
            return false;
        }
        
    }
</script>