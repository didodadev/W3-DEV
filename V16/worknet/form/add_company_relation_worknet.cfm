<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status" default="1">
<cfparam name="attributes.logo_list" default="0">
<cfset wrk = createObject("component","V16.worknet.cfc.worknet_add_member")>
<cfset getCompany = wrk.getCompany(company_id:attributes.cpid) />
<cfif isdefined("attributes.form_submitted")>
    <cfset get_all_worknet = wrk.getNotRelationWorknet(
        keyword             :   attributes.keyword,
        status     :   attributes.status,
        logo_list : attributes.logo_list,
        cpid : attributes.cpid
    )>
<cfelse> 
	<cfset get_all_worknet.recordcount = 0>
</cfif> 
<cfparam name="attributes.totalrecords" default='#get_all_worknet.recordcount#'>
<cfparam name="attributes.page" default='1'>
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cfsavecontent  variable="title"><cf_get_lang dictionary_id='61344.Pazaryerleri'></cfsavecontent>
    <cf_box title="#title#" id="list_worknet_list" closable="0" collapsable="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cfif attributes.logo_list eq 0>        
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cfform name="list_worknet" id="list_worknet" method="post" action="">
                <cf_box_search more="0">
                    <div class="form-group" id="form_ul_keyword">
                        <cfinput type="text" name="keyword" value="#attributes.keyword#" placeholder="#getLang('main',48)#">
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
            <cf_flat_list>
                <thead>
                    <tr>
                        <th style="width:25px;"></th>
                        <th><cf_get_lang dictionary_id='58158.Pazaryeri'></th>
                        <th><cf_get_lang dictionary_id='58637.Logo'></th>
                    </tr>       
                </thead>
                <tbody id="tbodyWorknet">
                    <cfif attributes.totalrecords>
                        <cfoutput query="get_all_worknet" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <tr id="row_#currentrow#">
                                <td><a href="javascript://" onclick="postData('#WORKNET_ID#','#attributes.cpid#',#currentrow#); return false;"><i class="fa fa-plus"></i></a></td>
                                <td>#WORKNET#</td>
                                <td>
                                    <cfif len(get_all_worknet.IMAGE_PATH)>
                                        <cf_get_server_file output_file="asset/watalogyImages/#IMAGE_PATH#" output_server="#SERVER_IMAGE_PATH_ID#" output_type="0" image_height="30">
                                    <cfelse>
                                        <img src="/images/no_photo.gif" height="30">
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
            </cf_flat_list>
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
                <cfif isDefined("attributes.draggable") and len(attributes.draggable)>
                    <cfset url_str = '#url_str#&draggable=#attributes.draggable#'>
                </cfif>
                <cfif isDefined("attributes.cpid") and len(attributes.cpid)>
                    <cfset url_str = '#url_str#&cpid=#attributes.cpid#'>
                </cfif>
                <cf_paging page="#attributes.page#"
                        maxrows="#attributes.maxrows#"
                        totalrecords="#attributes.totalrecords#"
                        startrow="#attributes.startrow#"
                        adres="worknet.form_list_company&event=popup_addWorknetRelation&#url_str#&form_submitted=#attributes.form_submitted#"
                        isAjax="#iif(isdefined("attributes.draggable"),1,0)#">                        
            </cfif>
        <cfelse>
            <div class="w-cards">
                <cfif attributes.totalrecords>
                    <cfoutput query="get_all_worknet">
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                            <div class="watalogy-cards" style="height:100px;">
                                <cf_get_server_file output_file="asset/watalogyImages/#IMAGE_PATH#" output_server="#SERVER_IMAGE_PATH_ID#" output_type="0" image_class="w-cards">
                            </div>
                        </div>
                    </cfoutput>
                <cfelse>
                    <cf_get_lang dictionary_id='57484.Kayıt Yok'> !
                </cfif>
            </div>
        </cfif>      
    </cf_box>
</div>

<script type="text/javascript">

   // document.getElementById('keyword').focus();
    var recCount = <cfoutput>#attributes.totalrecords#</cfoutput>;
    function postData(wrkid, compid, rowid){
        $.ajax({
            type:'POST',
            dataType: 'JSON',
            url: 'V16/worknet/cfc/worknet_add_member.cfc?method=insertRelationWorknet',
            data: 'cpid='+compid+'&wrkid='+wrkid,
            success: function (response) {
                if(response.STATUS){
                    $("tr#row_"+rowid).remove();
                    <cfif not isdefined("attributes.draggable")>window.opener.</cfif>jQuery( '#list_worknet_relation .catalyst-refresh' ).click();
                    recCount--;
                }
                else{
                    alert(response.MESSAGE);
                }
                if(recCount <= 0){
                    $("tr#tbodyWorknet").append("<tr><td colspan=3><cf_get_lang dictionary_id='63773.Bütün pazar yerlerine entegrasyon sağlandı.'></td></tr>");
                }
            }
        });
    }
</script>