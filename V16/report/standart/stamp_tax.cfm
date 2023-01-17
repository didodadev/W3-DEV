<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.sal_mon" default="#month(now())#">
<cfparam name="attributes.account_process" default="">
<cfset periods = createObject('component','V16.objects.cfc.periods')>
<cfparam name="attributes.is_excel" default="">
<cfset period_years = periods.get_period_year()>
<cfparam name="attributes.totalrecords" default="">
<cfparam name="attributes.page" default=1>
<cfobject name="stamp_tax" component="V16.contract.cfc.contract">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1> 
<cfif isdefined("attributes.form_submitted")>
    <cfset get_stamp_tax = stamp_tax.get_stamp_tax(
        sal_mon : attributes.sal_mon,
        sal_year : attributes.sal_year,
        account_process : attributes.account_process
    )>
<cfelse>
    <cfset get_stamp_tax.recordcount = 0>
</cfif>
<cfset get_tax_type = stamp_tax.get_tax_type()>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent variable="title"><cf_get_lang dictionary_id='62906.Damga Vergisi Beyanname Hazırlık Raporu'></cfsavecontent>
    <cf_box title="#title#">
    <cfform name="report_stamp_tax" action="" method="post">
        <input type="hidden" name="form_submitted" id="form_submitted" value="1" />
        <input type="hidden" name="is_select" id="is_select" value="" />
        <cf_box_search more="0">
            <div class="form-group">
                <select name="sal_mon" id="sal_mon">
                    <cfloop from="1" to="12" index="i">
                        <cfoutput>
                            <option value="#i#"<cfif attributes.sal_mon eq i> selected</cfif>>#listgetat(ay_list(),i,',')#</option>
                        </cfoutput>
                    </cfloop>
                </select>
            </div>
            <div class="form-group">
                <select name="sal_year" id="sal_year">
                    <cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+5#" index="i">
                        <cfoutput>
                            <option value="#i#" <cfif (isdefined("attributes.sal_year") and attributes.sal_year eq i)>selected</cfif>>#i#</option>
                        </cfoutput>
                    </cfloop>
                </select>
            </div>
            <div class="form-group">
                <select name="account_process" id="account_process">
                    <option value="1"<cfif attributes.account_process eq 1> selected</cfif>><cf_get_lang dictionary_id='62910.Muhasebe İşlemi Yapılanlar'></option>
                    <option value="2"<cfif attributes.account_process eq 2> selected</cfif>><cf_get_lang dictionary_id='31140.Tüm'><cf_get_lang dictionary_id='57777.İşlemler'></option>
                </select>
            </div>
            <div class="form-group">
                <label><cf_get_lang dictionary_id='57858.Excel Getir'><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>></label>
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="3"  search_function="control()" is_excel='1'>
            </div>
        </cf_box_search>
    </cfform>
</cf_box>
</div>

<cfif isdefined("attributes.form_submitted")>
    <cfif isdefined('attributes.is_excel') and attributes.is_excel eq 1>
        <cfset filename = "#createuuid()#">
        <cfheader name="Expires" value="#Now()#">
        <cfcontent type="application/vnd.msexcel;charset=utf-8">
        <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    </cfif>
<cf_report_list>
    <thead>
        <tr>
            <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
            <th><cf_get_lang dictionary_id='57800.İşlem Tipi'></th>
            <th><cf_get_lang dictionary_id='56032.Düzenleme Tarihi'></th>
            <th><cf_get_lang dictionary_id='30044.Sözleşme No'></th>
            <th><cf_get_lang dictionary_id='51040.sözleşme Tipi'></th>
            <th><cf_get_lang dictionary_id='57486.Kategori'></th>
            <th><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
            <th><cf_get_lang dictionary_id='50985.Sözleşme Tutarı'>(<cf_get_lang dictionary_id='48656.KDV hariç'>)</th>
            <th><cf_get_lang dictionary_id='57492.Toplam'><cf_get_lang dictionary_id='53252.Damga Vergisi'> <cf_get_lang dictionary_id='54452.Tutar'></th>
        </tr>
    </thead> 
    <tbody>
        <cfif get_stamp_tax.recordcount>
            <cfset contract_company_list = "">
            <cfset contract_consumer_list = "">
            
        <cfoutput query="get_stamp_tax">
            <cfif Len(company_id) and not ListFind(contract_company_list,company_id,',')>
                <cfset contract_company_list = ListAppend(contract_company_list,company_id,',')>
            </cfif>
            <cfif Len(consumer_id) and not ListFind(contract_consumer_list,consumer_id,',')>
                <cfset contract_consumer_list = ListAppend(contract_consumer_list,consumer_id,',')>
            </cfif>
        </cfoutput>
        <cfif ListLen(contract_company_list)>
            <cfquery name="get_contract_company" datasource="#dsn#">
                SELECT COMPANY_ID, FULLNAME FROM COMPANY WHERE COMPANY_ID IN (#contract_company_list#) ORDER BY COMPANY_ID
            </cfquery>
            <cfset contract_company_list = ListSort(ListDeleteDuplicates(ValueList(get_contract_company.company_id,',')),"numeric","asc",",")>
        </cfif>
        <cfif ListLen(contract_consumer_list)>
            <cfquery name="get_contract_consumer" datasource="#dsn#">
                SELECT CONSUMER_ID, CONSUMER_NAME + ' ' + CONSUMER_SURNAME FULLNAME FROM CONSUMER WHERE CONSUMER_ID IN (#contract_consumer_list#) ORDER BY CONSUMER_ID
            </cfquery>
            <cfset contract_consumer_list = ListSort(ListDeleteDuplicates(ValueList(get_contract_consumer.consumer_id,',')),"numeric","asc",",")>
        </cfif>
       <cfoutput query="get_stamp_tax" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
        <tr>
            <td>#currentrow#</td>
            <td>#PROCESS_CAT#</td>
            <td>#DateFormat(STARTDATE,dateformat_style)#</td>
            <td><a href="#request.self#?fuseaction=contract.list_related_contracts&event=upd&contract_id=#CONTRACT_ID#">#contract_no#</a></td>
            <td>#contract_cat#</td>
            <cfif  not (isdefined("attributes.is_excel") and attributes.is_excel eq 1)>
                <td> 
                    <div class="form-group">
                        <select id="tax_type_#currentrow#" name="tax_type">
                            <option value="0">Seçiniz</option>
                            <cfloop query="get_tax_type">
                                <option value="#TAX_TYPE#">#tax_type#</option>
                            </cfloop>
                        </select>
                    </div> 
                </td>
            <cfelse>
              <td id="is_#currentrow#"><cfif ListGetAt(attributes.is_select,currentrow) neq 0>#ListGetAt(attributes.is_select,currentrow)#</cfif></td>
            </cfif>
            <td>
                <cfif Len(company_id)>
                    #get_contract_company.fullname[ListFind(contract_company_list,company_id,',')]#
                <cfelseif Len(consumer_id)>
                    #get_contract_consumer.fullname[ListFind(contract_consumer_list,consumer_id,',')]#
                </cfif>
            </td>
            <td class="moneybox">#TLFormat(contract_amount)#</td>
            <td class="moneybox">
                <cfif len(copy_number)>
                    #TLFormat(stamp_tax*copy_number)#
                <cfelse>
                    #TLFormat(stamp_tax)#
                </cfif>
            </td>	
        </tr>
       </cfoutput>
        <cfelse>
            <tr>
                <td colspan="8"><cf_get_lang dictionary_id='57484.kayıt yok'>!</td>
            </tr>
        </cfif>
</tbody>
</cf_report_list>
</cfif>
<script type="text/javascript">

    function control(){
    if(document.report_stamp_tax.is_excel.checked==false)
        {
            document.report_stamp_tax.action="<cfoutput>#request.self#</cfoutput>?fuseaction=account.stamp_tax"
            return true;
        }
        else
        { 
           var listOfObjects = [];
           $( "select[name=tax_type]" ).each(function( index ) {
                
                listOfObjects.push($( this ).val());
            });
            $('#is_select').val(listOfObjects);
            document.report_stamp_tax.action="<cfoutput>#request.self#?fuseaction=account.emptypopup_stamp_tax</cfoutput>";
            report_stamp_tax.submit();
         } 
    }  
</script>