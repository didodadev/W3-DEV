<cfparam name="attributes.module_id_control" default="5">
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.product_id" default="">
<cfparam name="attributes.product_name" default="">
<cfparam name="attributes.date_1" default="">
<cfparam name="attributes.date_2" default="">
<cfparam name="attributes.is_excel" default="">
<cfif len(attributes.date_1)>
	<cf_date tarih='attributes.date_1'>
</cfif>
<cfif len(attributes.date_2)>
	<cf_date tarih='attributes.date_2'>
</cfif>
<cfif isdefined('attributes.pid') and len(attributes.pid)>
	<cfquery name="GET_PRODUCT_NAME" datasource="#DSN3#">
		SELECT PRODUCT_ID, PRODUCT_NAME FROM PRODUCT WHERE PRODUCT_ID = #attributes.pid#
	</cfquery>
	<cfset attributes.product_name = get_product_name.product_name>
	<cfset attributes.product_id = get_product_name.product_id>
</cfif>
<cfform name="action_search" action="#request.self#?fuseaction=report.product_action_search" method="post">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='39063.Ürün Aksiyon Raporu'></cfsavecontent>
    <cf_report_list_search title="#title#">
        <cf_report_list_search_area>
                <div class="row">
                    <div class="col col-12 col-xs">
                        <div class="row formContent">
                            <div class="row" type="row">
                                <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                    <div class="col col-12 col-xs-12">
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57657.Ürün'>*</label>
                                            <div class="col col-12">
                                                <div class="input-group"> 
                                                    <input type="hidden" name="product_id" id="product_id" value="<cfoutput>#attributes.product_id#</cfoutput>">
                                                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58194.Zorunlu Alan"> : <cf_get_lang dictionary_id='57657.Ürün'></cfsavecontent>
                                                    <cfinput type="text" name="product_name" id="product_name" required="yes" message="#message#" value="#attributes.product_name#" onFocus="AutoComplete_Create('product_name','PRODUCT_NAME','PRODUCT_NAME,STOCK_CODE','get_product_autocomplete','0','PRODUCT_ID','product_id','','3','120');" style="width:150px;">
                                                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_product_names</cfoutput>&product_id=action_search.product_id&field_name=action_search.product_name','list');"></span>
                                                </div>    
                                            </div>    
                                        </div>
                                        <div class="form-group">
                                            <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58690.Tarih Aralığı'></label>    
                                            <div class="col col-6">
                                                <div class="input-group">
                                                    <cfinput type="text" name="date_1" value="#dateformat(attributes.date_1,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#">
                                                    <span class="input-group-addon">
                                                        <cf_wrk_date_image date_field="date_1">
                                                    </span>	                           
                                                </div>
                                            </div>
                                            <div class="col col-6">
                                                <div class="input-group">
                                                    <cfinput type="text" name="date_2" value="#dateformat(attributes.date_2,dateformat_style)#" maxlength="10" validate="#validate_style#" message="#message#" style="width:65px;">
                                                    <span class="input-group-addon">
                                                    <cf_wrk_date_image date_field="date_2">
                                                    </span>
                                                </div>                                                 
                                            </div>
                                        </div>
                                    </div>
                                </div>		
                            </div>
                        </div>
                        <div class="row ReportContentBorder">
                            <div class="ReportContentFooter">
                                <input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'> <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                                <cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" message="#message#" maxlength="3" style="width:25px;">
                                <cfelse>
                                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                                </cfif>
                                <input name="is_form_submitted" id="is_form_submitted" type="hidden" value="1">
                                <cf_wrk_report_search_button button_type='1' search_function='control()' is_excel='1'>
                            </div>
                        </div>	
                    </div>	
                </div>	
        </cf_report_list_search_area>
    </cf_report_list_search>    
</cfform>
<cfif isdefined("attributes.is_excel") and attributes.is_excel eq 1>
	<cfset filename = "#createuuid()#">
	<cfheader name="Expires" value="#Now()#">
	<cfcontent type="application/vnd.msexcel;charset=utf-16">
	<cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-16">	
		<cfset type_ = 1>
	<cfelse>
		<cfset type_ = 0>
</cfif>
<cfif isdefined("attributes.is_form_submitted") and len(attributes.is_form_submitted)>
    <cf_report_list>
        <cfif len(attributes.product_id) and len(attributes.product_name)>
            <cfquery name="GET_CATALOG_PRODUCT" datasource="#dsn3#">
                SELECT 
                    CPP.*,
                    C.STARTDATE,
                    C.CATALOG_HEAD,
                    C.FINISHDATE
                FROM 
                    CATALOG_PROMOTION_PRODUCTS  AS CPP,
                    CATALOG_PROMOTION AS C
                WHERE	
                    CPP.PRODUCT_ID = #attributes.product_id# AND
                    C.CATALOG_ID = CPP.CATALOG_ID
                    <cfif len(attributes.date_1) AND len(attributes.date_2)>
                        AND 
                            (
                                (C.STARTDATE >= #attributes.date_1# AND C.STARTDATE <= #attributes.date_2#) OR
                                (C.FINISHDATE > #attributes.date_1# AND C.FINISHDATE <= #attributes.date_2#) OR
                                (C.STARTDATE < #attributes.date_1# AND C.FINISHDATE > #attributes.date_2#)
                            )
                    <cfelseif len(attributes.date_1)>
                        AND C.STARTDATE >= #attributes.date_1#
                    <cfelseif len(attributes.date_2)>
                        AND C.FINISHDATE <= #attributes.date_2#
                    </cfif>
                ORDER BY
                    C.CATALOG_ID DESC
            </cfquery>
            <cfparam name='attributes.totalrecords' default='#get_catalog_product.recordcount#'>
        <cfelse>
            <cfparam name='attributes.totalrecords' default='0'>
            <cfset get_catalog_product.recordcount = 0>
        </cfif>
        <cfparam name="attributes.page" default=1>
        <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
        <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
            <thead name="table1" id="table1">
                <tr>
                    <th>&nbsp;</th>
                    <th>&nbsp;</th>
                    <th class="form-title" nowrap>&nbsp;</th>
                    <th class="form-title" nowrap>&nbsp;</th>
                    <th colspan="4" align="center" nowrap class="form-title"><cf_get_lang dictionary_id='40056.standart'></th>
                    <th colspan="5" nowrap class="form-title" align="center"><cf_get_lang dictionary_id='57641.iskont'>%</th>
                    <th colspan="2" align="center" class="form-title"><cf_get_lang dictionary_id='58258.Maliyet'></th>
                    <th colspan="2" align="center" nowrap class="form-title"><cf_get_lang dictionary_id='57639.kdv'></th>
                    <th class="form-title" nowrap align="center" colspan="3"><cf_get_lang dictionary_id='40059.Aksiyon Fiyat'></th>
                    <th class="form-title" nowrap >&nbsp;</th>
                </tr>
                <tr>
                    <th height="22" nowrap class="txtboldblue"><cf_get_lang dictionary_id='57487.No'></th>
                    <th height="22" nowrap class="txtboldblue"><cf_get_lang dictionary_id='40061.Aksiyon'></th>
                    <th class="txtboldblue"><cf_get_lang dictionary_id='40062.Geç Tarihi'></th>
                    <th class="txtboldblue" nowrap><cf_get_lang dictionary_id='57636.Birim'></th>
                    <th class="txtboldblue" nowrap width="50"><cf_get_lang dictionary_id='57489.Para Br'></th>
                    <th nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58176.alış'></th>
                    <th nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='57448.satış'></th>
                    <th class="txtboldblue" nowrap><cf_get_lang dictionary_id='40064.S Mrj'></th>
                    <th nowrap class="txtboldblue" style="text-align:right;">1</th>
                    <th nowrap class="txtboldblue" style="text-align:right;">2</th>
                    <th nowrap class="txtboldblue" style="text-align:right;">3</th>
                    <th nowrap class="txtboldblue" style="text-align:right;">4</th>
                    <th nowrap class="txtboldblue" style="text-align:right;">5</th>
                    <th width="70" class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58083.Net'></th>
                    <th width="70" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58716.KDV li'></th>
                    <th nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='58176.alış'></th> 
                    <th class="txtboldblue" nowrap ><cf_get_lang dictionary_id='57448.satış'></th>
                    <th nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='40065.A Mrj'></th>
                    <th width="75" nowrap class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='39059.KDV Dahil'></th>
                    <th class="txtboldblue" style="text-align:right;"><cf_get_lang dictionary_id='57640.Vade'></th>
                    <th class="txtboldblue" nowrap ><cf_get_lang dictionary_id='40066.Raf Tipi'></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_catalog_product.recordcount and isdefined("is_form_submitted")>
                    <cfoutput query="get_catalog_product" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td><a href="#request.self#?fuseaction=product.list_catalog_promotion&event=upd&id=#catalog_id#" class="tableyazi">#catalog_head#</a></td>
                            <td nowrap>#dateformat(startdate,dateformat_style)# - #dateformat(finishdate,dateformat_style)#</td>
                            <td>#unit#</td>
                            <td>#money#</td>
                            <td style="text-align:right;">#TLFormat(purchase_price,4)#</td>
                            <td style="text-align:right;">#TLFormat(sales_price)#</td>
                            <td style="text-align:right;">#TLFormat(profit_margin)#</td>
                            <td style="text-align:right;">#TLFormat(discount1)#</td>
                            <td style="text-align:right;">#TLFormat(discount2)#</td>
                            <td style="text-align:right;">#TLFormat(discount3)#</td>
                            <td style="text-align:right;">#TLFormat(discount4)#</td>
                            <td style="text-align:right;">#TLFormat(discount5)#</td>
                            <td style="text-align:right;">#TLFormat(row_nettotal,4)#</td>
                            <td style="text-align:right;">#TLFormat(row_total,4)#</td>
                            <td style="text-align:right;">#TLFormat(tax_purchase,4)#</td>
                            <td style="text-align:right;">#TLFormat(tax)#</td>
                            <td style="text-align:right;">#TLFormat(action_profit_margin)#</td>
                            <td style="text-align:right;">#TLFormat(action_price)#</td>
                            <td style="text-align:right;">#duedate#</td>
                            <cfif len(shelf_id)>
                                <cfquery name="GET_SHELF_NAME" datasource="#dsn#">
                                    SELECT SHELF_NAME FROM SHELF WHERE SHELF_MAIN_ID = #shelf_id#
                                </cfquery>
                            </cfif>
                            <td nowrap><cfif len(shelf_id)>#get_shelf_name.shelf_name#</cfif></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr><td height="20" colspan="21"><cfif not isdefined("is_form_submitted")><cfelse><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td></tr>
                </cfif>
            </tbody>
    </cf_report_list>
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_catalog_product.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cfif attributes.totalrecords gt attributes.maxrows>
        <cfset url_str = attributes.fuseaction >
        <cfif len(attributes.is_form_submitted)>
            <cfset url_str =  "#url_str#&is_form_submitted=#attributes.is_form_submitted#">
        </cfif>
        <cfif len(attributes.product_id)>
            <cfset url_str =  "#url_str#&product_id=#attributes.product_id#">
        </cfif>
        <cfif len(attributes.product_name)>
            <cfset url_str = '#url_str#&product_name=#attributes.product_name#'>
        </cfif>
        <cfif isdate(attributes.date_1)>
            <cfset url_str = '#url_str#&date_1=#dateformat(attributes.date_1,dateformat_style)#'>
        </cfif>
        <cfif isdate(attributes.date_2)>
            <cfset url_str = '#url_str#&date_2=#dateformat(attributes.date_2,dateformat_style)#'>
        </cfif>
        <cf_paging 
                page="#attributes.page#" 
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#url_str#">	
    </cfif>
</cfif>
<script>
    function control()
    {
        if((document.action_search.date_1.value != '') && (document.action_search.date_2.value != '') && !date_check(action_search.date_1, action_search.date_2, "<cf_get_lang dictionary_id ='39814.Başlangıç Tarihi Bitiş Tarihinden Küçük Olmalıdır'>!"))
        return false;

        if(document.action_search.is_excel.checked==false)
		{
			document.action_search.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>";
			return true;
		}
		else
			document.action_search.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_product_action_search</cfoutput>";
    }
</script>

