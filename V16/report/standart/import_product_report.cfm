<cfparam name="attributes.is_foreign" default="">
<cfparam name="attributes.page" default=1>

<cfquery name="GET_STAGE_NAME" datasource="#DSN#">
	SELECT PROCESS_ROW_ID,STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ID = 3 ORDER BY LINE_NUMBER
</cfquery>
<cfparam name="attributes.date_type" default="">
<cfparam name="attributes.report_type" default="">
<cfparam name="attributes.is_excel" default="">
<cfif isdefined("attributes.start_date") and isdate(attributes.start_date)>
	<cf_date tarih="attributes.start_date">
</cfif>
<cfif isdefined("attributes.finish_date") and isdate(attributes.finish_date)>
	<cf_date tarih="attributes.finish_date">
</cfif>

<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_ORDER" datasource="#dsn#">
    	SELECT 
            O.ORDER_ID,
            O.ORDER_NUMBER, 
		    CASE 
                WHEN O.CONSUMER_ID IS NOT NULL THEN 
                    C.CONSUMER_NAME + ' ' + C.CONSUMER_SURNAME
                WHEN O.EMPLOYEE_ID IS NOT NULL THEN
                    E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME
                WHEN O.PARTNER_ID IS NOT NULL THEN
                    CP.COMPANY_PARTNER_NAME + ' ' + CP.COMPANY_PARTNER_SURNAME
            END AS
                NAME,
            O.ORDER_HEAD,
            O.ORDER_DATE,
            O.RECORD_DATE,
            O.DELIVERDATE,
            <cfif attributes.report_type eq 1>
	            O.OTHER_MONEY,
    	        O.OTHER_MONEY_VALUE,
            <cfelse>
        	    OROW.OTHER_MONEY,
				OROW.OTHER_MONEY_VALUE,
                OROW.PRODUCT_ID,
                OROW.STOCK_ID,
                P.PRODUCT_NAME,
            </cfif>
            O.CONSUMER_ID,
            O.PARTNER_ID,
            O.EMPLOYEE_ID,
            O.PUBLISHDATE,
            PTR.STAGE,
            O.IS_FOREIGN
        FROM 
        	#dsn3_alias#.ORDERS O
                LEFT JOIN CONSUMER C ON O.CONSUMER_ID = C.CONSUMER_ID
                LEFT JOIN EMPLOYEES E ON O.EMPLOYEE_ID = E.EMPLOYEE_ID
                LEFT JOIN COMPANY_PARTNER CP ON O.PARTNER_ID = CP.PARTNER_ID
                LEFT JOIN COMPANY COM ON O.COMPANY_ID = COM.COMPANY_ID,
            <cfif attributes.report_type eq 2>
            	#dsn3_alias#.ORDER_ROW OROW,
                #dsn1_alias#.PRODUCT P,
            </cfif>
			PROCESS_TYPE_ROWS PTR
        WHERE
        	<cfif attributes.report_type eq 2>
            	OROW.ORDER_ID = O.ORDER_ID AND
                P.PRODUCT_ID = OROW.PRODUCT_ID AND
            </cfif>
            O.PURCHASE_SALES = 0 AND
            O.ORDER_ZONE = 0 AND
            PTR.PROCESS_ROW_ID = O.ORDER_STAGE
            <cfif attributes.date_type eq 1>
            	AND O.DELIVERDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
            <cfelseif attributes.date_type eq 2>
            	AND O.ORDER_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
            <cfelseif attributes.date_type eq 3>
				AND O.PUBLISHDATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
			<cfelseif attributes.date_type eq 4>
	        	AND O.ORDER_ID IN (SELECT OH.ORDER_ID FROM #dsn3_alias#.ORDERS_HISTORY OH WHERE OH.ORDER_STAGE = 117 AND OH.RECORD_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">)
                AND O.ORDER_STAGE = 117 AND O.UPDATE_DATE BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.start_date#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#attributes.finish_date#">
            </cfif>
            <cfif isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
	            AND O.CONSUMER_ID = #attributes.consumer_id#
            <cfelseif isdefined("attributes.company_id") and len(attributes.company_id)>
            	AND O.COMPANY_ID = #attributes.company_id#
            </cfif>
            <cfif isdefined("attributes.is_foreign") and len(attributes.is_foreign)>
                AND O.IS_FOREIGN = #attributes.is_foreign#
            </cfif>
         ORDER BY
            <cfif attributes.date_type eq 1>
            	O.DELIVERDATE
	    <cfelseif attributes.date_type eq 2>
            	O.ORDER_DATE
            <cfelseif attributes.date_type eq 3>
            	O.PUBLISHDATE
            <cfelseif attributes.date_type eq 4>
            	O.UPDATE_DATE
            </cfif>
    </cfquery>
<cfelse>
	<cfset GET_ORDER.recordcount = 0>
</cfif>
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
  <cfset attributes.maxrows = session.ep.maxrows>
</cfif>
<cfparam name="attributes.totalrecords" default='#GET_ORDER.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif not isdefined("attributes.start_date")>
 	<cfset attributes.start_date = dateadd('ww',-1,now())> 
</cfif>
<cfif not isdefined("attributes.finish_date")>
	<cfset attributes.finish_date = wrk_get_today()>
</cfif>

<cfform name="order_detail_report" action="#request.self#?fuseaction=report.import_product_report" method="post">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='39184.İthalat Üye Sipariş Raporu'></cfsavecontent>
    <cf_report_list_search title="#title#">
        <cf_report_list_search_area>
        <input name="form_submitted" id="form_submitted" value="1" type="hidden">
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-3 col-md-6 col-xs-12">
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                                    <div class="col col-12 col-xs-12">
                                    <div class="input-group">
                                        <input type="hidden" name="consumer_id" id="consumer_id" value="<cfif isdefined("attributes.consumer_id")><cfoutput>#attributes.consumer_id#</cfoutput></cfif>">
                                        <input type="hidden" name="company_id" id="company_id" value="<cfif isdefined("attributes.company_id")><cfoutput>#attributes.company_id#</cfoutput></cfif>">
                                        <input type="hidden" name="member_type" id="member_type" value="<cfif isdefined("attributes.member_type")><cfoutput>#attributes.member_type#</cfoutput></cfif>">
                                        <input name="member_name" type="text" id="member_name" style="width:90px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_PARTNER_NAME,MEMBER_CODE','get_member_autocomplete','\'1,2\'','CONSUMER_ID,COMPANY_ID,MEMBER_TYPE','consumer_id,company_id,member_type','','3','250');" value="<cfif isdefined("attributes.member_name") and len(attributes.member_name)><cfoutput>#attributes.member_name#</cfoutput></cfif>" autocomplete="off">
                                        <cfset str_linke_ait="&field_consumer=order_detail_report.consumer_id&field_comp_id=order_detail_report.company_id&field_member_name=order_detail_report.member_name&field_type=order_detail_report.member_type">
                                        <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars<cfoutput>#str_linke_ait#<cfif session.ep.isBranchAuthorization>&is_store_module=1</cfif></cfoutput>&select_list=7,8&keyword='+encodeURIComponent(document.order_detail_report.member_name.value),'list');"></span>  
                                    </div>
                                    </div>
                                </div>
                                 <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id="39467.Tarih Tipi"></label>
                                    <div class="col col-12 col-xs-12">
                                      <select name="date_type" id="date_type">
                                        <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                                        <option value="1" <cfif attributes.date_type eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id="57645.Teslim Tarihi"></option>
                                        <option value="2" <cfif attributes.date_type eq 2>selected="selected"</cfif>><cf_get_lang dictionary_id="29501.Sipariş Tarihi"></option>
                                        <option value="3" <cfif attributes.date_type eq 3>selected="selected"</cfif>><cf_get_lang dictionary_id="39469.Proforma Tarihi"></option>
                                        <option value="4" <cfif attributes.date_type eq 4>selected="selected"</cfif>><cf_get_lang dictionary_id="39465.Depoya Giriş Tarihi"></option>
                                      </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-6 col-xs-12">
                                 <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='57742.Tarih'></label>
                                    <div class="col col-12 col-xs-12">
                                        <div class="input-group">
                                        <cfinput type="text" name="start_date" id="start_date" value="#dateformat(attributes.start_date,dateformat_style)#" validate="#validate_style#" maxlength="10" style="width:65px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>   
                                        <span class="input-group-addon no-bg"></span>
                                        <cfinput type="text" name="finish_date" id="finish_date" value="#dateformat(attributes.finish_date,dateformat_style)#" validate="#validate_style#" maxlength="10" style="width:65px;">
                                        <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>   
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col col-12 col-xs-12"><cf_get_lang dictionary_id='58960.rapor Tipi'></label>
                                    <div class="col col-6 col-xs-12">
                                        <div class="input-group">
                                            <select name="report_type" id="report_type">
                                                <option value="1" <cfif attributes.report_type eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id="57660.Belge Bazında"></option>
                                                <option value="2" <cfif attributes.report_type eq 2>selected="selected"</cfif>><cf_get_lang dictionary_id="29539.Satır Bazında"></option>
                                            </select>
                                            <span class="input-group-addon no-bg"></span>
                                        </div>
                                    </div>
                                    <div class="col col-6 col-xs-12">
                                        <div class="input-group">
                                            <select name="is_foreign" id="is_foreign">
                                                <option value="" selected="selected"><cf_get_lang dictionary_id="58081.Hepsi"></option>
                                                <option value="1"  <cfif attributes.is_foreign eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id="39476.Yurt Dışı"></option>
                                                <option value="0"  <cfif attributes.is_foreign eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id="39477.Yurt İçi"></option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>				                            
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                            <cfinput type="text" name="maxrows" value="#attributes.maxrows#" validate="integer" range="1,999" required="yes" onKeyUp="isNumber(this)" message="#message#" maxlength="3" style="width:25px;">
                            <cf_wrk_report_search_button button_type='1' search_function='kontrol()' insert_info='#message#' is_excel="1"> 
                        </div>
                    </div>
                </div>
            </div>       
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
    <cfset filename="import_product_report#dateformat(now(),'ddmmyyyy')#_#timeformat(now(),'HHMMl')#_#session.ep.userid#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-16">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/plain; charset=utf-16">
    <cfset attributes.startrow=1>
    <cfset attributes.maxrows=GET_ORDER.recordcount>
</cfif>
<cfif isdefined("attributes.form_submitted")> 
    <cf_report_list>
            <thead>
            <tr>
                <th><cf_get_lang dictionary_id="58211.Sipariş No"></th>
                <th><cf_get_lang dictionary_id="57611.Sipariş"></th>
                <th></th>
                <th><cf_get_lang dictionary_id="58061.Cari"> <cf_get_lang dictionary_id="57897.Adı"></th>
                <cfif attributes.report_type eq 2>
                    <th><cf_get_lang dictionary_id="58221.Ürün Adı"></th>
                </cfif>               
                <th><cfif attributes.report_type eq 1><cf_get_lang dictionary_id="57611.Sipariş"> <cf_get_lang dictionary_id="57680.Sipariş Genel Toplam"><cfelse><cf_get_lang dictionary_id="39490.Satır Toplamı"></cfif></th>
                <th><cf_get_lang dictionary_id="57489.Para birimi"></th>
                <th><cf_get_lang dictionary_id="40555.Sipariş Durum"></th>
                <th>
                    <cfif attributes.date_type eq 1><cf_get_lang dictionary_id="39478.Teslim">
                    <cfelseif attributes.date_type eq 2><cf_get_lang dictionary_id="57611.Sipariş">
                    <cfelseif attributes.date_type eq 3><cf_get_lang dictionary_id="39481.Proforma">
                    <cfelseif attributes.date_type eq 4><cf_get_lang dictionary_id="39487.Depoya">
                    </cfif> <cf_get_lang dictionary_id="58593.Tarihi">
                </th>
            </tr>
            </thead>
            <tbody>
            <cfif GET_ORDER.recordcount>
                <cfoutput query="GET_ORDER" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr>
                        <td><a href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#order_id#" class="tableyazi">#ORDER_NUMBER#</a></td>
                        <td><a href="#request.self#?fuseaction=purchase.list_order&event=upd&order_id=#order_id#" class="tableyazi">#ORDER_HEAD#</a></td>
                        <td><cfif IS_FOREIGN eq 1><cf_get_lang dictionary_id="39476.Yurt Dışı"><cfelse><cf_get_lang dictionary_id="39477.Yurt İçi"></cfif></td>
                        <td>
                            <cfif len(PARTNER_ID)>
                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_par_det&par_id=#PARTNER_ID#','medium');">#Name#</a>
                            <cfelseif len(EMPLOYEE_ID)>
                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&EMP_ID=#EMPLOYEE_ID#','medium');">#Name#</a>
                            <cfelseif len(CONSUMER_ID)>
                                <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_con_det&con_id=#CONSUMER_ID#','medium');">#Name#</a>
                            </cfif>
                        </td>
                        <cfif attributes.report_type eq 2>
                        <td>
                            <a href="javascript://" class="tableyazi" onclick="windowopen('#request.self#?fuseaction=objects.popup_detail_product&pid=#product_id#&sid=#stock_id#','medium');">#product_name#</a></td>
                        </cfif>
                        <td style="text-align:right;">#tlformat(OTHER_MONEY_VALUE)#</td>
                        <td>#OTHER_MONEY#</td>
                        <td>#Stage#</td>
                        <td>
                            <cfif attributes.date_type eq 1>#dateformat(DELIVERDATE,dateformat_style)#
                            <cfelseif attributes.date_type eq 2>#dateformat(ORDER_DATE,dateformat_style)#
                            <cfelseif attributes.date_type eq 3>#dateformat(PUBLISHDATE,dateformat_style)#
                            <cfelseif attributes.date_type eq 4>#dateformat(UPDATE_DATE,dateformat_style)#
                            </cfif>
                        </td>
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="8"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</cfif></td>
                </tr>
            </cfif>
            </tbody>
        </table>
    </cf_report_list>
</cfif>
<cfset adres = url.fuseaction>
<cfif isDefined('attributes.consumer_id') and len(attributes.consumer_id)>
  <cfset adres = '#adres#&consumer_id=#attributes.consumer_id#'>
</cfif>	
<cfif isDefined('attributes.company_id') and len(attributes.company_id)>
  <cfset adres = '#adres#&is_foreign=#attributes.company_id#'>
</cfif>	
<cfif isDefined('attributes.member_type') and len(attributes.member_type)>
  <cfset adres = '#adres#&member_type=#attributes.member_type#'>
</cfif>	
<cfif isDefined('attributes.member_name') and len(attributes.member_name)>
  <cfset adres = '#adres#&member_name=#attributes.member_name#'>
</cfif>	
<cfif isDefined('attributes.is_foreign') and len(attributes.is_foreign)>
  <cfset adres = '#adres#&is_foreign=#attributes.is_foreign#'>
</cfif>	
<cfif isDefined('attributes.start_date') and len(attributes.start_date)>
  <cfset adres = '#adres#&start_date=#dateformat(attributes.start_date,dateformat_style)#'>
</cfif>	
<cfif isDefined('attributes.finish_date') and len(attributes.finish_date)>
  <cfset adres = '#adres#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#'>
</cfif>	
<cfif isDefined('attributes.date_type') and len(attributes.date_type)>
  <cfset adres = '#adres#&date_type=#attributes.date_type#'>
</cfif>	
<cfif isDefined('attributes.report_type') and len(attributes.report_type)>
  <cfset adres = '#adres#&report_type=#attributes.report_type#'>
</cfif>	
<cf_paging 
	page="#attributes.page#"
    maxrows="#attributes.maxrows#"
    totalrecords="#attributes.totalrecords#"
    startrow="#attributes.startrow#"
    adres="#adres#&form_submitted=1">
<script type="text/javascript">
	function kontrol()
	{	
       
		if(document.getElementById('date_type').value == '')
		{
			alert('<cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id="39467.Tarih Tipi">');
			return false;
		}
        
        if(document.order_detail_report.is_excel.checked==false)
			{
				document.order_detail_report.action="<cfoutput>#request.self#</cfoutput>?fuseaction=report.import_product_report"
				return true;
			}
			else{
                document.order_detail_report.action="<cfoutput>#request.self#?fuseaction=report.emptypopup_import_product_report</cfoutput>"
            }

           
    }
</script>
