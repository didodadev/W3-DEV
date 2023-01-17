<!---
    File:V16\correspondence\display\list_paperandcargo.cfm
    Controller:WBO\controller\PaperAndCargoController.cfm
    Folder: correspondence\display\list_papernadcargo.cfm
    Author: Fatma zehra Dere
    Date: 2020-12-01 
    Description:
    Gelen giden evrak ve kargo işlemlerinin listelendiği sayfadır
    Correspendence kullanım sayfasıdır.
    History:
    To Do:
--->
<cfparam  name="attributes.page" default="1">
<cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
    <cfset attributes.maxrows = session.ep.maxrows />
</cfif>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1 />
<cfparam  name="attributes.document_registration_no" default="">
<cfparam  name="attributes.keyword"default="">
<cfparam  name="attributes.form_submitted" default="">
<cfparam  name="attributes.cargo_id" default="0">
<cfparam  name="attributes.coming_out"default="">
<cfparam  name="attributes.sender_id" default="">
<cfparam  name="attributes.sender_name" default="">
<cfparam  name="attributes.receiver_id" default="">
<cfparam  name="attributes.receiver_name" default="">
<cfparam  name="attributes.start_date" default="">
<cfparam  name="attributes.finish_date" default="">
<cfparam  name="attributes.sender_comp_id" default="">

<cfif isdefined("attributes.form_submitted")>
<cfset comp    = createObject("component","V16.correspondence.cfc.PaperAndCargo") />
<cfset list_cargo = comp.list_cargo(
    keyword :#attributes.keyword#,
    coming_out:#attributes.coming_out#,
    start_date:#attributes.start_date#,
    finish_date:#attributes.finish_date#,
    receiver_id:#attributes.receiver_id#,
    sender_id:#attributes.sender_id#,
    sender_name:#attributes.sender_name#,
    receiver_name:#attributes.receiver_name#,
    sender_comp_id:#attributes.sender_comp_id# 
)/>
<cfparam name='attributes.totalrecords' default="#list_cargo.recordcount#">
<cfelse>
    <cfset list_cargo.recordcount = 0>
    <cfparam name='attributes.totalrecords' default="0">
</cfif>
<cf_box scroll="0">
    <cfform  name="list_cargo" action="#request.self#?fuseaction=correspondence.paperandcargo" method="post">
        <input type="hidden" name="form_submitted" id="form_submitted" value="1">
        <cf_box_search more="0">
            <div class="form-group">
                <cfinput type="text" name="keyword" id="keyword" autocomplete="off" value="#attributes.keyword#" maxlength="50" style="width:50px;" placeholder="#getLang(48,'Keyword',47046)#">
            </div>
            <div class="form-group">
                <select name="coming_out" id="coming_out">
                    <option value=""><cf_get_lang dictionary_id='33037.Kargo Durum'></option>
                    <option value="1"<cfif isDefined("attributes.coming_out") and (attributes.coming_out eq 1)> selected</cfif>><cf_get_lang dictionary_id ='58974.Gelen'></option>
                    <option value="2"<cfif isDefined("attributes.coming_out") and (attributes.coming_out eq 2)> selected</cfif>><cf_get_lang dictionary_id ='58975.Giden'></option>
                </select>
            </div>
            <div class="form-group" id="item-start_date">
                <div class="input-group">                                  
                <input type="text" name="start_date" id="start_date"  autocomplete="off" value="<cfif len(attributes.start_date)><cfoutput>#dateformat(attributes.start_date,dateformat_style)#</cfoutput></cfif>" maxlength="10"placeholder="<cf_get_lang dictionary_id='58690.Tarih Aralığı'>">
                <span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
                </div>
            </div>
            <div class="form-group" id="item-finish_date">
                <div class="input-group">                      
                    <input type="text" name="finish_date" id="finish_date" autocomplete="off" value="<cfif len(attributes.finish_date)><cfoutput>#dateformat(attributes.finish_date,dateformat_style)#</cfoutput></cfif>" maxlength="10"placeholder="<cf_get_lang dictionary_id='58690.Tarih Aralığı'>">
                    <span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
                </div>
            </div>
            <div class="form-group" id="item-sender">
                <div class="input-group">
                    <input type="hidden" name="sender_id" id="sender_id"  value="<cfoutput>#attributes.sender_id#</cfoutput>">
                    <input type="hidden" name="sender_comp_id" id="sender_comp_id"  value="<cfoutput>#attributes.sender_comp_id#</cfoutput>">
                    <input type="text" name="sender_name" id="sender_name" placeholder="<cf_get_lang dictionary_id='60308.Gönderici'>" autocomplete="off" value="<cfoutput>#attributes.sender_name#</cfoutput>">
                    <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57734.seçiniz'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_cargo.sender_id&field_comp_id=list_cargo.sender_comp_id&field_name=list_cargo.sender_name&select_list=1,7','list');"></span>
                </div>
            </div>
            <div class="form-group" id="item-receiver">
                <div class="input-group">
                    <input type="hidden" name="receiver_id" id="receiver_id"  value="<cfoutput>#attributes.receiver_id#</cfoutput>">
                    <input type="text" name="receiver_name" id="receiver_name" placeholder="<cf_get_lang dictionary_id='64077.Alıcı'>" autocomplete="off" value="<cfoutput>#attributes.receiver_name#</cfoutput>">
                    <span class="input-group-addon btnPointer icon-ellipsis" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=list_cargo.receiver_id&field_name=list_cargo.receiver_name<cfif fusebox.circuit is "store">&is_store_module=1</cfif>&select_list=1','list','popup_list_positions');"></span>  
                </div>
            </div>
            <div class="form-group small">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4">
            </div>
        </cf_box_search> 
    </cfform>
</cf_box>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="61455.Gelen Giden Evrak ve Kargo İşlemleri "> </cfsavecontent> 
    <cf_box title="#message#" uidrop="1" hide_table_column="1" > 
        <cf_grid_list>  
            <thead>
                <tr>
                    <th><cf_get_lang dictionary_id='58577.Sıra'></th> 
                        <th><cf_get_lang dictionary_id='58974.Gelen'>/<cf_get_lang dictionary_id='58975.Giden'></th>
                        <th><cf_get_lang dictionary_id='48274.Evrak No'>/<cf_get_lang dictionary_id='31257.Kayıt No'></th>
                        <th><cf_get_lang dictionary_id='60308.Gönderici'></th>
                        <th><cf_get_lang dictionary_id='64077.Alıcı'></th>
                        <th><cf_get_lang dictionary_id='46140.Tür'></th>
                        <th><cf_get_lang dictionary_id='39248.Taşıyıcı Firma'></th>
                        <th><cf_get_lang dictionary_id='50724.Ücret'></th>
                        <th><cf_get_lang dictionary_id='61471.A.Ö'>/<cf_get_lang dictionary_id='61472.G.Ö'></th>
                        <th><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=correspondence.paperandcargo&event=add"><i class="fa fa-plus" alt="<cf_get_lang no='503.Formu Doldur'>" title="<cf_get_lang_main no='170.Ekle'>" ></i></a></th>
                </tr> 
            </thead>
            <cfif list_cargo.recordcount>
                <cfoutput query="list_cargo" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tbody>
                        <tr>
                            <td>#CURRENTROW#</td>
                            <td>
                                <cfif coming_out eq 1>
                                    <cf_get_lang dictionary_id='58974.Gelen'>
                                <cfelseif coming_out eq 2>
                                    <cf_get_lang dictionary_id='58975.Giden'>
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td>#DOCUMENT_REGISTRATION_NO#</td>
                            <td>
                                <cfif len(list_cargo.sender_id)> 
                                    #get_emp_info(list_cargo.sender_id,0,0)#
                                <cfelseif len(list_cargo.sender_comp_id)> 
                                    #get_par_info(list_cargo.sender_comp_id,1,1,0)# 
                                <cfelse>
                                    -
                                </cfif>
                            </td>
                            <td>#get_emp_info(RECEIVER_ID,0,0)#</td>
                            <td>#DOCUMENT_TYPE#</td>
                            <td> #get_par_info(list_cargo.CARRIER_COMPANY_ID,1,1,0)#</td>
                            <td class="moneybox">#TLformat(CARGO_PRICE)#</td>
                            <td> <cfif PAYMENT_METHOD eq 1>
                                <cf_get_lang dictionary_id='61471.A.Ö'>
                            <cfelseif PAYMENT_METHOD eq 0>
                                <cf_get_lang dictionary_id='61472.G.Ö'>
                            <cfelse>
                            </cfif></td>
                            <td><a href="#request.self#?fuseaction=correspondence.paperandcargo&event=upd&cargo_id=#CARGO_ID#"> <i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>   
                                </a>
                            </td>
                        </tr>
                    </tbody> 
                </cfoutput>
            <cfelse>
                <tbody> 
                    <tr>
                        <td colspan="20"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!</td>
                    </tr>
                </tbody> 
            </cfif>
        </cf_grid_list> 
        <cfset url_str = "">
        <cfif len(attributes.form_submitted)>
            <cfset url_str = '#url_str#&form_submitted=#attributes.form_submitted#'>
        </cfif>
        <cfif len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif>
        <cfif len(attributes.coming_out)>
            <cfset url_str = "#url_str#&coming_out=#attributes.coming_out#">
        </cfif>
        <cfif isdefined("attributes.finish_date") and len(attributes.finish_date)>
            <cfset url_str = "#url_str#&finish_date=#attributes.finish_date#">
        </cfif>
        <cfif isdefined("attributes.start_date") and len(attributes.start_date)>
            <cfset url_str = "#url_str#&start_date=#attributes.start_date#">
        </cfif>
        <cfif len(attributes.receiver_id)>
            <cfset url_str = "#url_str#&receiver_id=#attributes.receiver_id#">
        </cfif>
        <cfif len(attributes.receiver_name)>
            <cfset url_str = "#url_str#&receiver_name=#attributes.receiver_name#">
        </cfif>
        <cfif len(attributes.sender_id)>
            <cfset url_str = "#url_str#&sender_id=#attributes.sender_id#">
        </cfif>
        <cfif len(attributes.sender_name)>
            <cfset url_str = "#url_str#&sender_name=#attributes.sender_name#">
        </cfif> 
        <cfif len(attributes.sender_comp_id)>
            <cfset url_str = "#url_str#&sender_comp_id=#attributes.sender_comp_id#">
        </cfif>
        <cf_paging page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="correspondence.paperandcargo#url_str#">
    </cf_box>  

  
