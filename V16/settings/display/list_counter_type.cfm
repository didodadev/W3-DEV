<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif IsDefined("attributes.form_submitted")>
    <cfset counter_type = createObject("component","V16.settings.cfc.counter_type")>
    <cfset get_counter_type = counter_type.get_counter_type(
        keyword: attributes.keyword,
        maxrows: attributes.maxrows
    )>
    <cfparam name="attributes.totalrecords" default='#get_counter_type.recordcount#'>
<cfelse>
    <cfset get_counter_type.recordCount = 0>
    <cfparam name="attributes.totalrecords" default='0'>
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="list_counter_type" method="post" action="#request.self#?fuseaction=settings.counter_type">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfinput name="keyword" id="keyword" value="#attributes.keyword#" placeholder="#getLang('main','Filtre',57460)#">
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Sayaç Tipleri',42933)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <th width="30"><cf_get_lang dictionary_id='57487.No'></th>
                <th><cf_get_lang dictionary_id='41282.Sayaç Tipi'></th>
                <th><cf_get_lang dictionary_id='40984.Okuma Tipi'></th>
                <th><cf_get_lang dictionary_id='62224.Okuma Periyodu'></th>
                <th><cf_get_lang dictionary_id='41283.Başlama Değeri'></th>
                <th><cf_get_lang dictionary_id='62222.Tarife/Ek Ürün'></th>
                <th><cf_get_lang dictionary_id='41285.Fatura Periyodu'></th>
                <th><cf_get_lang dictionary_id='40994.Ücretsiz Dönem'></th>
                <th><cf_get_lang dictionary_id='62244.Wex Code'></th>
                <th width="20" class="header_icn_none text-center"><a href="index.cfm?fuseaction=settings.counter_type&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
            </thead>
            <tbody>
                <cfif get_counter_type.recordCount>
                    <cfoutput query="get_counter_type" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#COUNTER_TYPE#</td>
                            <td>
                                <cfif READING_TYPE_ID eq 1><cf_get_lang dictionary_id='39250.Sistem Bazında'></cfif>
                                <cfif READING_TYPE_ID eq 2><cf_get_lang dictionary_id='62220.Kullanıcı Bazında'></cfif>
                                <cfif READING_TYPE_ID eq 3><cf_get_lang dictionary_id='62221.İşlem Bazında'></cfif>
                            </td>
                            <td>
                                <cfif READING_PERIOD eq 1><cf_get_lang dictionary_id='57490.Gün'></cfif>
                                <cfif READING_PERIOD eq 2><cf_get_lang dictionary_id='58734.Hafta'></cfif>
                                <cfif READING_PERIOD eq 3><cf_get_lang dictionary_id='58724.Ay'></cfif>
                                <cfif READING_PERIOD eq 4>3 <cf_get_lang dictionary_id='58724.Ay'></cfif>
                                <cfif READING_PERIOD eq 5><cf_get_lang dictionary_id='58455.Yıl'></cfif>
                            </td>
                            <td>#TLFORMAT(START_VALUE)#</td>
                            <td><!--- #TLFORMAT(PRODUCT_UNIT_PRICE)##ListLast(UNIT_CURRENCY_ID,';')# ---></td>
                            <td>
                                <cfif INVOICE_PERIOD eq 1><cf_get_lang dictionary_id='58724.Ay'></cfif>
                                <cfif INVOICE_PERIOD eq 2>3 <cf_get_lang dictionary_id='58724.Ay'></cfif>
                                <cfif INVOICE_PERIOD eq 3><cf_get_lang dictionary_id='58455.Yıl'></cfif>
                            </td>
                            <td>#FREE_PERIOD#</td>
                            <td>#WEX_CODE#</td>
                            <td class="text-center"><a href="#request.self#?fuseaction=settings.counter_type&event=upd&ct_id=#COUNTER_TYPE_ID#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="9"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '>!</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfset url_str = "">
        <cfif isdefined("attributes.form_submitted")>
            <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
        </cfif>
        <cfif len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cf_paging page="#attributes.page#" 
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#fusebox.circuit#.counter_type&#url_str#">
    </cf_box>
</div>