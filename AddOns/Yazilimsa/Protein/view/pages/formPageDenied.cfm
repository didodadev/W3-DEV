<!---
    File :          AddOns\Yazilimsa\Protein\view\pages\formPageDenied.cfm
    Author :        Semih Akartuna <semihakartuna@yazilimsa.com>
    Date :          23.01.2021
    Description :   Protein sayfa kısıt ayarları yapılır
    Notes :         /AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc ile çalışır
--->
<script src="https://cdn.jsdelivr.net/npm/sortablejs@latest/Sortable.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/jquery-sortablejs@latest/jquery-sortable.js"></script> 
<script src="/JS/assets/plugins/vue.js"></script>
<script src="/JS/assets/plugins/axios.min.js"></script>
<script src="/AddOns/Yazilimsa/Protein/src/assets/js/protein_general_functions.js?v=240121"></script>
<link rel="stylesheet" href="/AddOns/Yazilimsa/Protein/src/assets/css/protein.css" />
<cfquery name="thısPage" datasource="#dsn#">
    SELECT TITLE,FRIENDLY_URL FROM PROTEIN_PAGES WHERE PAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.page#">
</cfquery>
<cfset pageHead = "Page : #thısPage.TITLE#">
<cf_catalystHeader>
<div class="row" id="addDenied"> 
    <div class="col col-3 col-md-6 col-sm-12 uniqueRow" id="content">
        <cfsavecontent variable="message">Page Denied</cfsavecontent>
        <cf_box title="#message#" closable="0">
             <form name="form_page_denied" id="form_page_denied" v-on:submit.prevent enctype="multipart/form-data">                
                <cf_box_elements vertical="1">
                <cfoutput>
                    <input type="hidden" name="page" value="#attributes.page#">                       
                    <div class="form-group col col-12">
                        <label>Url</label>
                        <input type="text" name="url" readonly value="#thısPage.TITLE#">
                    </div>
                    <div class="form-group  col col-12" id="item-denied_app_name">
						<label>Kullanıcı</label>
                        <div class="input-group">
                            <input type="hidden" name="denied_emp_id" id="denied_emp_id">
                            <input type="hidden" name="denied_par_id" id="denied_par_id">
                            <input type="hidden" name="denied_con_id" id="denied_con_id">
                            <input name="denied_app_name" type="text" id="denied_app_name" onfocus="AutoComplete_Create('denied_app_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,2,3\'','EMPLOYEE_ID,PARTNER_ID,CONSUMER_ID','denied_emp_id,denied_par_id,denied_con_id','form_page_denied','3','110');" autocomplete="off">
                            <span class="input-group-addon btnPointer icon-ellipsis" title="Kullanıcı" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_pars&is_period_kontrol=0&field_location=service&field_emp_id=form_page_denied.denied_emp_id&field_partner=form_page_denied.denied_par_id&field_consumer=form_page_denied.denied_con_id&field_name=form_page_denied.denied_app_name&select_list=1,2,3&keyword='+encodeURIComponent(document.form_page_denied.denied_app_name.value),'list');"></span>
                        </div>
					</div>
                    <div class="form-group">   
                        <div class="col"><label>View <input type="checkbox" name="is_view" value="1"></label></div>
                        <div class="col"><label>İnsert <input type="checkbox" name="is_insert" value="1"></label></div>
                        <div class="col"><label>Delete <input type="checkbox" name="is_delete" value="1"></label></div>
                    </div>
                </cfoutput>                    
                </cf_box_elements>
                <div class="ui-form-list-btn padding-top-10">
                    <cf_workcube_buttons add_function="proteinApp.save()">
                </div> 
            </form>
        </cf_box>       
    </div>
    <div class="col col-4 col-md-6 col-sm-12 uniqueRow">
       <!--- TODO: PROTEIN_MENUS querysi cfc ye alınmalı--->
        <cfquery name="GET_COMPANY_PARTNER_DENIED" datasource="#dsn#">
            SELECT
                CPD.DENIED_PAGE_ID,
                CPD.PARTNER_ID,
                CPD.PARTNER_POSITION_ID,
                CPD.COMPANY_CAT_ID,
                CPD.MENU_ID,
                CPD.DENIED_PAGE,
                COALESCE(CPD.IS_VIEW,0) IS_VIEW,
                COALESCE(CPD.IS_INSERT,0) IS_INSERT,
                COALESCE(CPD.IS_DELETE,0) IS_DELETE,
                CPD.CONSUMER_CAT_ID,
                CPD.CONSUMER_ID,
                CP.COMPANY_PARTNER_NAME,
                CP.COMPANY_PARTNER_SURNAME,
                C.FULLNAME
            FROM 
                COMPANY_PARTNER_DENIED CPD
                LEFT JOIN COMPANY_PARTNER CP ON CPD.PARTNER_ID = CP.PARTNER_ID
                LEFT JOIN COMPANY C ON CP.COMPANY_ID = C.COMPANY_ID
            WHERE
                DENIED_PAGE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.page#">
        </cfquery>
        <cfsavecontent variable="message">Denied Users</cfsavecontent>
        <cf_box title="#message#" uidrop="1" hide_table_column="1"> 
            <cf_flat_list sort="1">
                <thead>
                    <tr>
                        <th>#</th>
                        <th class="text-left">User</th>
                        <th class="text-center">View</th>
                        <th class="text-center">Insert</th>
                        <th class="text-center">Delete</th>
                        <th class="header_icn_none text-center">
                            <i class="fa fa-cogs"></i>                         
                        </th>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="GET_COMPANY_PARTNER_DENIED"> 
                        <tr data-partner="#partner_id#" data-consumer="">
                            <td>#currentRow#</td>
                            <td class="text-left">
                                <cfif len(PARTNER_ID)>
                                    #COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#
                                    <br><small>#FULLNAME#</small>
                                </cfif>
                            </td>
                            <td class="text-center" data-view-status="#IS_VIEW#">
                                <cfif IS_VIEW eq 1>
                                    <i class="fa fa-unlock font-green-jungle" @click="update_denied(#partner_id#,'view',0)"></i>
                                <cfelse>
                                    <i class="fa fa-lock font-red" @click="update_denied(#partner_id#,'view',1)"></i>
                                </cfif>
                            </td>
                            <td class="text-center" data-insert-status="#IS_INSERT#">
                                <cfif IS_INSERT eq 1>
                                    <i class="fa fa-unlock font-green-jungle" @click="update_denied(#partner_id#,'insert',0)"></i>
                                <cfelse>
                                    <i class="fa fa-lock font-red" @click="update_denied(#partner_id#,'insert',1)"></i>
                                </cfif>
                            </td>
                            <td class="text-center" data-delete-status="#IS_DELETE#">
                                <cfif IS_DELETE eq 1>
                                    <i class="fa fa-unlock font-green-jungle" @click="update_denied(#partner_id#,'delete',0)"></i>
                                <cfelse>
                                    <i class="fa fa-lock font-red" @click="update_denied(#partner_id#,'delete',1)"></i>
                                </cfif>
                            </td>
                            <td class="text-center">
                                <i class="fa fa-minus font-red" @click="delete_denied(#partner_id#)"></i>
                            </td>
                        </tr>
                    </cfoutput>
                </tbody>
            </cf_flat_list>
        </cf_box>
    </div>
</div>
<script>
    var proteinApp = new Vue({
        el: '#addDenied',
        data: {        
        method : '<cfoutput>#attributes.event#</cfoutput>', 
        status :1,    
        ID : <cfif isdefined('attributes.page') and len(attributes.page)><cfoutput>#attributes.page#</cfoutput><cfelse>null</cfif>,
        SITE : <cfoutput>#attributes.site#</cfoutput>,          
        error: []
        },
        methods: {           
            save : function(){
                form_date = JSON.stringify($('#form_page_denied').serializeObject());
                form_date = JSON.parse(form_date);
                console.log(form_date.denied_app_name);
                if(form_date.denied_app_name.length == 0){alertObject({message:"Kullanıcı seçiniz.",type:"warning"}); return false;}
                if(typeof(form_date.is_view) == "undefined" && typeof(form_date.is_insert) == "undefined" && typeof(form_date.is_delete) == "undefined"){alertObject({message:"Kısıt seçiniz. *view, insert, delete",type:"warning"}); return false;}
               
                if(form_date.denied_par_id == $('[data-partner="'+form_date.denied_par_id +'"]').data('partner')){
                    alertObject({message:"Daha önce eklenen kullanıcı, listeden düzenleyebilirsiniz.",type:"warning"}); 
                    $('[data-partner="'+form_date.denied_par_id +'"]').addClass("remark_row");
                    setTimeout(function() {$('[data-partner="'+form_date.denied_par_id +'"]').removeClass("remark_row");}, 2000);   
                    return false;
                }
                
                axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=add_"+proteinApp.method, form_date)
                    .then(response => {
                            console.log(response.data.STATUS);
                            if(response.data.STATUS == true){
                                alertObject({message:"Sayfa Kısıdı: " + response.data.IDENTITYCOL+ " kaydedildi 😉",type:"success"});
                                setTimeout(function(){window.location="/index.cfm?fuseaction=protein.pages&event=denied&page=" + proteinApp.ID + "&site="+proteinApp.SITE;} , 2000);
                                
                            }else{
                                alertObject({message:"Hata : 1996 - " + response.data.ERROR ,type:"danger"});  
                            }                            
                    })
                    .catch(e => {
                        alertObject({message:"Hata : 1997 - sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                        proteinApp.error.push({ecode: 1000, message:"method:"+proteinApp.method+" bir porblem meydana geldi..."})
                    })
                console.log(form_date);
            },
            update_denied : function(i,t,s){
                var row = $('[data-partner="'+i+'"]');
                var cell = $(row).find('[data-'+t+'-status]')[0];
                console.log(cell);
                console.log(i,t,s);
                if(s == 1){
                    $(cell).html('<i class="fa fa-unlock font-green-jungle" onClick=\'proteinApp.update_denied('+i+',"'+t+'",0)\'></i>');
                }else{
                    $(cell).html('<i class="fa fa-lock font-red" onClick=\'proteinApp.update_denied('+i+',"'+t+'",1)\'></i>');                    
                }

                axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=upd_"+proteinApp.method,
                    {
                        page:<cfoutput>#attributes.page#</cfoutput>,
                        partner:i,
                        denied:t,
                        status:s
                    })
                    .then(response => {
                        console.log(response.data.STATUS);
                        if(response.data.STATUS == true){
                            alertObject({message:"Sayfa Kısıtı: " + response.data.IDENTITYCOL+ " güncellendi 😉",type:"success"});                                
                        }else{
                            alertObject({message:"Hata : 1996 - " + response.data.ERROR ,type:"danger"});  
                        }                            
                    })
                    .catch(e => {
                        alertObject({message:"Hata : 1997 - sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                        proteinApp.error.push({ecode: 1000, message:"method:"+proteinApp.method+" bir porblem meydana geldi..."})
                    })
            },
            delete_denied : function(i){
                var row = $('[data-partner="'+i+'"]');
                axios.post( "/AddOns/Yazilimsa/Protein/cfc/siteMethods.cfc?method=del_"+proteinApp.method,
                    {
                        page:<cfoutput>#attributes.page#</cfoutput>,
                        partner:i
                    })
                    .then(response => {
                        console.log(response.data.STATUS);
                        if(response.data.STATUS == true){
                            alertObject({message:"Sayfa Kısıtı: " + i + " silindi 😉",type:"success"});                                
                        }else{
                            alertObject({message:"Hata : 1996 - " + response.data.ERROR ,type:"danger"});  
                        }   
                        $(row).remove();                         
                    })
                    .catch(e => {
                        alertObject({message:"Hata : 1997 - sistem yanıt veremedi, daha sonra tekrar dene.",type:"danger"});
                        proteinApp.error.push({ecode: 1000, message:"method:"+proteinApp.method+" bir porblem meydana geldi..."})
                    })

            }  
        },
        mounted () {         
        }
    });
</script>
