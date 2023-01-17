<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.subscription_id" default="">
<cfparam name="attributes.subscription_no" default="">
<cfparam name="attributes.work_status" default="">
<cfparam name="attributes.wex_id" default="">
<cfparam name="attributes.wex_name" default="">


<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif IsDefined("attributes.form_submitted")>
    <cfset listCM = createObject("component","V16.sales.cfc.counter_meter")>
    <cfset listCMsel = listCM.select(
        keyword             :   attributes.keyword,
        subscription_id     :   attributes.subscription_id,
        subscription_no     :   attributes.subscription_no,
        wex_id        :   attributes.wex_id,
        wex_name        :   attributes.wex_name
    )>
    <cfparam name="attributes.totalrecords" default='#listCMsel.recordcount#'>
<cfelse>
    <cfparam name="attributes.totalrecords" default='0'>
</cfif>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="form_list_counter_meter" id="form_list_counter_meter" method="post" action="">
            <cf_box_search>
                <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                <div class="form-group" id="form_ul_keyword">
                    <cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255" placeholder="#getLang('main','Filtre',57460)#">
                </div>
                <div class="form-group" id="form_ul_subscription">
                    <cf_wrk_subscriptions width_info='140' fieldid='subscription_id' fieldname='subscription_no' form_name='form_list_counter_meter' img_info='plus_thin'>
                    <!--- <cfsavecontent  variable="head"><cf_get_lang dictionary_id='29502.Abone No'></cfsavecontent> --->
                    <!--- <input type="hidden" name="subscription_id" id="subscription_id" value="<cfoutput>#attributes.subscription_id#</cfoutput>">
                    <input type="text" name="subscription_no" id="subscription_no" value="<cfoutput>#attributes.subscription_no#</cfoutput>" placeholder="<cfoutput>#head#</cfoutput>">
                    <span class="input-group-addon btn_Pointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_subscription&field_id=form_list_counter_meter.subscription_id&field_no=form_list_counter_meter.subscription_no','list','popup_list_subscription');"></span> --->
                </div>
                <div class="form-group" id="form_ul_wex">       
                    <div class="input-group">
                        <input type="hidden" name="wex_id" id="wex_id" value="<cfoutput>#attributes.wex_id#</cfoutput>">     
                        <input type="text" name="wex_name" id="wex_name" value="<cfoutput>#attributes.wex_name#</cfoutput>" placeholder="<cfoutput>#getLang('','WEX',47849)#</cfoutput>">
                        <span class="input-group-addon btn_Pointer icon-ellipsis" href="javascript://" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_wex&fieldId=form_list_counter_meter.wex_id&fieldName=form_list_counter_meter.wex_name');"></span>                                                               
                    </div>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3" onKeyUp="isNumber(this)">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang('','Sayaç Okuma',41271)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="30"><cf_get_lang dictionary_id='57487.No'></th>
                    <th width="20" class="text-center">F</th>
                    <th><cf_get_lang dictionary_id='29502.Abone No'></th>
                    <th><cf_get_lang dictionary_id='48871.Sayaç No'></th>
                    <th><cf_get_lang dictionary_id='41294.Önceki Değer'></th>
                    <th><cf_get_lang dictionary_id='41295.Son Değer'></th>
                    <th><cf_get_lang dictionary_id='58583.Fark'></th>
                    <th title="<cf_get_lang dictionary_id='30616.Web Servis Bilgileri'>">R</th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=sales.counter_meter&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                </tr>       
            </thead>
            <tbody>
                <cfif attributes.totalrecords>
                    <cfoutput query="listCMsel" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td class="text-center"><input type="checkbox" name=""></td>
                            <td>#SUBSCRIPTION_NO#</td>
                            <td>#COUNTER_NO#</td>
                            <td>#TLFORMAT(PREVIOUS_VALUE)#</td>
                            <td>#TLFORMAT(LAST_VALUE)#</td>
                            <td>#TLFORMAT(DIFFERENCE)#</td>
                            <td style="text-align:center;font-size:14px;"><i class="fa fa-dot-circle-o" title="Referral(Web Servis)"></i></td>
                            <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                            <td>#dateformat(LOADING_DATE,dateformat_style)#</td>
                            <td class="text-center"><a href="#request.self#?fuseaction=sales.counter_meter&event=upd&cm_id=#SCM_ID#" class="tableyazi"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="11"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '>!</cfif></td>
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
            <cfif len(attributes.subscription_no)>
                <cfset url_str = "#url_str#&subscription_no=#attributes.subscription_no#">
            </cfif>
            <cfif isdefined("attributes.wex_name")>
                <cfset url_str = "#url_str#&wex_name=#attributes.wex_name#">
            </cfif>
            <cf_paging page="#attributes.page#" 
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#fusebox.circuit#.counter_meter&#url_str#">
    </cf_box>
</div>