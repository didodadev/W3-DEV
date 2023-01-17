<cfsetting showdebugoutput="no">
<cfparam name="attributes.module" default="">
<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_PROCESS_CATS" datasource="#dsn3#">
	SELECT 
		*
	FROM 
		SETUP_PROCESS_CAT_HISTORY
	WHERE
		PROCESS_CAT_ID = '#attributes.process_cat_id#'
	ORDER BY
		ISNULL(UPDATE_DATE ,RECORD_DATE) DESC
</cfquery>
<cfparam name="attributes.totalrecords" default="#GET_PROCESS_CATS.RecordCount#">

    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57473.Tarihçe'></cfsavecontent>
    <cf_seperator title="#message#" id="item_#attributes.process_cat_id#" >
        <div  id="item_<cfoutput>#attributes.process_cat_id#</cfoutput>" style="display:none;">
            <table class="ui-table-list">
                <thead>
                    <tr>
                        <th><cf_get_lang dictionary_id='57692.İşlem'></th>
                    <cfif session.ep.our_company_info.is_efatura>
                        <th><cf_get_lang dictionary_id="57441.Fatura"></th> 
                        <th><cf_get_lang dictionary_id="59321.Senaryo"></th>
                    </cfif>
                        <th><cf_get_lang dictionary_id='58061.Cari'></th>
                        <th><cf_get_lang dictionary_id='57447.Muhasebe'></th>
                        <th><cf_get_lang dictionary_id='57559.Bütçe'></th>
                        <th><cf_get_lang dictionary_id='58258.Maliyet'></th>
                        <th><cf_get_lang dictionary_id='43231.Stok Hareketi'></th>            
                        <th><cf_get_lang dictionary_id='58885.Partner'></th>
                        <th><cf_get_lang dictionary_id='43232.Public'></th>
                        <th><cf_get_lang dictionary_id='43880.Sıfır Stok Kontrolu Yapılsın'></th>
                        <th><cf_get_lang dictionary_id="47807.Ödeme Yöntemi Bazında Cari İşlem"></th>
                        <th><cf_get_lang dictionary_id='43442.Hizmet Kalemiyle Muhasebeleştir'></th>
                        <th><cf_get_lang dictionary_id='57891.Güncelleyen'></th>
                        <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                        <th> <cf_get_lang dictionary_id='59000.Display File'></th>
                        <th> <cf_get_lang dictionary_id='59001.Action File'></th>
                    </tr>
                </thead>
            <tbody>
                <cfif GET_PROCESS_CATS.RecordCount>
                    <cfoutput query="GET_PROCESS_CATS" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                      <tr>
                        <td>#PROCESS_TYPE#</td>
                     <cfif session.ep.our_company_info.is_efatura>
                        <td>#INVOICE_TYPE_CODE#</td>
                        <td>#PROFILE_ID#</td>
                    </cfif>
                        <td style="text-align:center;"><cfif IS_CARI eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
                        <td style="text-align:center;"><cfif IS_ACCOUNT eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
                        <td style="text-align:center;"><cfif IS_BUDGET eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
                        <td style="text-align:center;"><cfif IS_COST eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
                        <td style="text-align:center;"><cfif IS_STOCK_ACTION eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>                
                        <td style="text-align:center;"><cfif IS_PARTNER eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
                        <td style="text-align:center;"><cfif IS_PUBLIC eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
                        <td style="text-align:center;"><cfif IS_ZERO_STOCK_CONTROL eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
                        <td style="text-align:center;"><cfif IS_PAYMETHOD_BASED_CARI eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
                        <td style="text-align:center;"><cfif IS_EXP_BASED_ACC eq 1><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
                        <td style="text-align:center;"><cfif len(update_emp)>#get_emp_info(update_emp,0,0)#<cfelse>#get_emp_info(RECORD_EMP,0,0)#</cfif></td>
                        <td style="text-align:center;"><cfif len(update_date)>#DateFormat(update_date,dateformat_style)#-(#timeformat(date_add("h",session.ep.time_zone,update_date),timeformat_style)#)<cfelse>#DateFormat(record_date,dateformat_style)#-(#timeformat(date_add("h",session.ep.time_zone,record_date),timeformat_style)#)</cfif></td>
                        <td style="text-align:center;"><cfif len(DISPLAY_FILE_NAME)><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
                        <td style="text-align:center;"><cfif len(ACTION_FILE_NAME)><b><i class="icon-circle" style="color:##44b6ae"></b></cfif></td>
                    </cfoutput> 
                <cfelse>
                    <tr> 
                        <td colspan="15"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
             </tbody>
            </table>
        </div>
