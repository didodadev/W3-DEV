<cf_get_lang_set module_name="stock">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfif fuseaction contains "popup">
  <cfset is_popup=1>
 <cfelse>
  <cfset is_popup=0>
</cfif>
<cfif session.ep.isBranchAuthorization>
    <cfset attributes.branch_id = listgetat(session.ep.user_location,2,'-')>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=#fusebox.circuit#.list_category_place" method="post" name="search_form" >
            <cf_box_search>
                <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                <div class="form-group">
                    <cfinput type="text" name="keyword" id="keyword" placeholder="#getlang(48,'Filtre',57460)#" maxlength="50" style="width:100px;" value="#attributes.keyword#">
                </div>
                <div class="form-group">
                    <cfinclude template="../../product/query/get_stores.cfm">
                    <select name="store" id="store" style="width:140px;">
                        <option  value=""><cf_get_lang dictionary_id='45372.Depo Seçiniz'></option>
                        <cfoutput query="get_stores">
                        <option value="#department_id#" <cfif isDefined("attributes.store") and attributes.store eq DEPARTMENT_ID>selected</cfif> >#DEPARTMENT_HEAD#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" style="width:25px;" maxlength="3" onKeyUp="isNumber (this)" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" message="#message#">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                    <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(14,'Kategori Alanı',45191)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="20"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id='45278.kategori Kodu'></th>
                    <th><cf_get_lang dictionary_id='57486.kategori'></th>
                    <th><cf_get_lang dictionary_id='58763.depo'></th>
                    <th><cf_get_lang dictionary_id='30031.lokasyon'></th>
                    <th><cf_get_lang dictionary_id='57629.Açıklama'></th>
                    <th width="20" class="header_icn_none"><a href="javascript://"  onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=stock.list_category_place&event=add</cfoutput>');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='45192.Kategori Alanı Ekle'>" alt="<cf_get_lang dictionary_id ='45192.Kategori Alanı Ekle'>"></i></a></th>
                </tr>
            </thead>
            <tbody>
                <cfif isdefined("attributes.form_submitted")>
                    <cfinclude template="../query/get_pro_cat_place_all.cfm">
                    <cfelse>
                    <cfset get_pro_cat_place.recordcount=0>
                </cfif>
                    <cfparam name="attributes.totalrecords" default="#get_pro_cat_place.RecordCount#">
                    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
                <cfif get_pro_cat_place.RecordCount>
                    <cfoutput query="get_pro_cat_place" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#HIERARCHY#</td>
                            <td>#PRODUCT_CAT#</td>
                            <td>
                                #DEPARTMENT_HEAD# 
                            </td>
                            <td>
                                <cfif len(get_pro_cat_place.LOCATION_ID) >
                                <cfset attributes.ID=get_pro_cat_place.DEPARTMENT_ID & '-' & get_pro_cat_place.LOCATION_ID >
                                <cfinclude template="../query/get_det_stock_location.cfm">
                                #GET_DET_STOCK_LOCATION.COMMENT#
                                </cfif>
                            </td>
                            <td>#get_pro_cat_place.detail#</td>
                            <!-- sil -->
                            <td width="20"><a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=stock.list_category_place&event=upd&PC_PLACE_ID=#get_pro_cat_place.PC_PLACE_ID#');"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                            <!-- sil -->
                        </tr>
                    </cfoutput>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif not get_pro_cat_place.RecordCount>
            <div class="ui-info-bottom">
            <p><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></p>
            </div>
        </cfif>
        <cfset adres = "#fusebox.circuit#.list_category_place">
        <cfif isdefined("attributes.form_submitted") and len(attributes.form_submitted)>
            <cfset adres = '#adres#&form_submitted=#attributes.form_submitted#'>
        </cfif>            
        <cf_paging
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#adres#">
    </cf_box>
</div>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
