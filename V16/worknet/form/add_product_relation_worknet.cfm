<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.select" default="0"> <!--- Filtreler için eklendi. --->
<cfset wrk = createObject("component","V16.worknet.cfc.product")>
<cfif attributes.select eq 0>
    <cfset getProduct = wrk.getProduct(product_id:attributes.pid)>
    <cfif isdefined("attributes.form_submitted")>
        <cfset get_all_worknet = wrk.getNotRelationWorknet(
            keyword             : attributes.keyword,
            status     :   attributes.status,
            pid : attributes.pid
        )>
    <cfelse> 
        <cfset get_all_worknet.recordcount = 0>
    </cfif> 
<cfelse>
    <cfset get_all_worknet = wrk.getNotRelationWorknet(
            keyword             :  attributes.keyword,
            status     :   attributes.status
        )>
</cfif>
<cfset company_cmp = createObject("component","V16.member.cfc.member_company")>
<cfset get_our_cmp = company_cmp.GET_OURCMP_INFO(company_id : session.ep.company_id)>   
<cfset get_all_worknets = wrk.getNotRelationWorknet()>
<cfif get_all_worknets.recordcount eq 0 and not len(get_our_cmp.WATALOGY_MEMBER_CODE)>
    <script>
        if (confirm("<cf_get_lang dictionary_id='65309.Henüz bir pazaryeri bağlantınız yok. Watalogy servisleri hakkında bilgi edinmek ister misiniz?'>")){
            window.open('https://www.workcube.com/<cfif session.ep.language eq 'tr'>tr<cfelse>en</cfif>/watalogy','_blank');
            <cfif isDefined("attributes.draggable")>closeBoxDraggable(<cfoutput>#attributes.modal_id#</cfoutput>);</cfif>
        }
            
    </script>
</cfif>

<cfparam name="attributes.totalrecords" default='#get_all_worknet.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cf_box title="#getLang('','Pazaryeri Ekle',63772)#" id="list_worknet_search" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
    <cfform name="list_worknet" id="list_worknet" method="post" action="">
        <input type="hidden" name="form_submitted" id="form_submitted" value="1">
        <cfsavecontent  variable="title"><cf_get_lang dictionary_id='26.Pazaryerleri'></cfsavecontent>
        <cf_box_search more="0">
            <div class="form-group" id="form_ul_keyword">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                <cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#message#">
            </div>
            <div class="form-group small">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" onKeyUp="isNumber(this)">
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('list_worknet' , ##attributes.modal_id##)"),DE(""))#">
            </div>
        </cf_box_search>
    </cfform>
    <cf_ajax_list>
        <thead>
            <tr>
                <th width="20"></th>
                <th><cf_get_lang dictionary_id='58158.Pazaryeri'></th>
                <th width="50"><cf_get_lang dictionary_id='58637.Logo'></th>
            </tr>       
        </thead>
        <tbody id="tbodyWorknet">
            <cfif attributes.totalrecords>
                <cfoutput query="get_all_worknet" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                    <tr id="row_#currentrow#">
                        <td><a href="javascript://" onclick="postData('#WORKNET_ID#','#attributes.pid#',#currentrow#,'#WORKNET#'); return false;" title="<cf_get_lang dictionary_id='57582.Ekle'>"><i class="fa fa-plus"></i></a></td>
                        <td>#WORKNET#</td>
                        <td>
                            <cfif len(get_all_worknet.IMAGE_PATH)>
                                <cf_get_server_file output_file="asset/watalogyImages/#IMAGE_PATH#" output_server="#SERVER_IMAGE_PATH_ID#" output_type="0" image_height="20">
                            <cfelse>
                                <img src="/images/no_photo.gif" height="20">
                            </cfif>
                        </td> 
                    </tr>
                </cfoutput>
            <cfelse>
                <tr>
                    <td colspan="3"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Yok'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                </tr>
            </cfif>
        </tbody>
    </cf_ajax_list>
    <cfif attributes.totalrecords gt attributes.maxrows>
        <cfset url_str = "">
        <cfif isdefined("attributes.form_submitted")>
            <cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
        </cfif>
        <cfif len(attributes.keyword)>
            <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
        </cfif> 
        <cfif len(attributes.status)>
            <cfset url_str = "#url_str#&status=#attributes.status#">
        </cfif> 
        <cfif len(attributes.pid)>
            <cfset url_str = "#url_str#&pid=#attributes.pid#">
        </cfif> 
        <cfif isDefined("attributes.draggable") and len(attributes.draggable)>
            <cfset url_str = '#url_str#&draggable=#attributes.draggable#'>
        </cfif>
        <cf_paging page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="worknet.list_product&event=popup_addWorknetRelation#url_str#&form_submitted=#attributes.form_submitted#"
                isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
            
    </cfif>
</cf_box>
<script type="text/javascript">

   // document.getElementById('keyword').focus();
    var recCount = <cfoutput>#attributes.totalrecords#</cfoutput>;
    function postData(wrkid, pid, rowid, name){
        if(pid != 0){
            $.ajax({
                type:'POST',
                dataType: 'JSON',
                url: 'V16/worknet/cfc/product.cfc?method=insertRelationWorknet',
                data: 'pid='+pid+'&wrkid='+wrkid,
                success: function (response) {
                    if(response.STATUS){
                        $("tr#row_"+rowid).remove();
                        <cfif not isdefined("attributes.draggable")>window.opener.</cfif>jQuery('#list_worknet_relation .catalyst-refresh').click();
                        recCount--;
                    }
                    else{
                        alert(response.MESSAGE);
                    }
                    if(recCount <= 0){
                        $("#tbodyWorknet").append("<tr><td colspan=3><cf_get_lang dictionary_id='63773.Bütün pazar yerlerine entegrasyon sağlandı.'></td></tr>");
                    }
                }
            });
        }
        else{
            <cfif isdefined("attributes.field_id") and len(attributes.field_id) and isdefined("attributes.field_name") and len(attributes.field_name)>
                if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value == '')
                    <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = wrkid;
                else
                    <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_id#</cfoutput>.value + ',' + wrkid;
                if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value == '')
                    <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = name;
                else
                    <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value = <cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.<cfoutput>#attributes.field_name#</cfoutput>.value + ',' +name;
            </cfif>
            
 
        }
        return false;
        
    }
</script>