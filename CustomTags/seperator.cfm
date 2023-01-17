<!---<cfparam name="attributes.title" default="">
<cfparam name="attributes.is_closed" default="0">
<cfparam name="attributes.header" default="#attributes.title#">
<cfparam name="attributes.no_line" default="0">
<cfparam name="attributes.onClick_function" default="">
<cfoutput>
<cfif isdefined("attributes.close_form_box")>
    </tr>
    </table>
    <cfset caller.form_box_count = 0>
</cfif>
<table class="seperator" id="seperator">
    <tr>
        <td class="seperator_left" nowrap="nowrap"><a href="javascript://" onclick="gizle_goster_image('#attributes.id#1','#attributes.id#2','#attributes.id#'); <cfif len(attributes.onClick_function)>#attributes.onClick_function#</cfif>" class="txtboldblue"><img  src="/images/open_close_1.gif" border="0" id="#attributes.id#2" style="<cfif attributes.is_closed><cfelse>display:none;</cfif>" /><img src="/images/open_close_2.gif" id="#attributes.id#1" border="0" style="<cfif attributes.is_closed>display:none;<cfelse></cfif>"/> #attributes.header#</a></td>
        <td <cfif attributes.no_line eq 0>class="seperator_right"</cfif>></td>
    </tr>
</table>
</cfoutput>--->
<cfparam name="attributes.title" default="">
<cfparam name="attributes.is_closed" default="0">
<cfparam name="attributes.important_closed" default="0">
<cfparam name="attributes.header" default="#attributes.title#">
<cfparam name="attributes.no_line" default="0">
<cfparam name="attributes.onClick_function" default="">
<cfparam name="attributes.box_seperator" default="0"><!--- Box sayfalarin icinde gelen seperatorlerin fonksiyonlari onload fonksiyonlarinda calismiyordu. Cunku bu sayfalar ajax ile geldigi icin load sayfaya bakiyor. --->
<cfparam name="attributes.close" default="0">
<cfparam name="attributes.closeForGrid" default="0"><!--- Sağ panelden açılan grid'ler için xml'lere bağlı kalmadan kapalı gelmesi sağlanıyor. --->
<cfparam name="attributes.detailPath" default="">
<cfparam name="attributes.class" default=""><!---- Seperatore class eklemek için kullanılır --->
<cfparam name="attributes.seperator_width" default="">
<cfparam name="attributes.upd_href" default="">
<cfparam name="attributes.upd_href_title" default="">
<cfparam name="attributes.add_href" default="">
<cfparam name="attributes.add_href_title" default="">
<cfparam name="attributes.del_href" default="">
<cfparam name="attributes.del_href_title" default="">
<cfparam name="attributes.info_title_upd" default="">
<cfparam name="attributes.info_title_add" default="">
<cfparam name="attributes.info_title_del" default="">
<cfparam name="attributes.style" default="">
<cfparam name="attributes.seperator_id" default="">

<cfif attributes.close eq 0>
    <cfif isdefined("caller.attributes.fuseaction")>
        <cfset this_act_ = caller.attributes.fuseaction>
    <cfelseif isdefined("caller.caller.attributes.fuseaction")>
        <cfset this_act_ = caller.caller.attributes.fuseaction>
    <cfelse>
        <cfset this_act_ = 'myhome.welcome'>
    </cfif>
    <cfif isdefined("caller.xml_unload_body_sep_#attributes.id#")>
        <cfset attributes.is_closed = evaluate("caller.xml_unload_body_sep_#attributes.id#")>
    <cfelseif isdefined("caller.caller.xml_unload_body_sep_#attributes.id#")>
        <cfset attributes.is_closed = evaluate("caller.caller.xml_unload_body_sep_#attributes.id#")>
    </cfif>
    <cfoutput>
    <cfif isdefined("attributes.close_form_box")>
        </tr>
        </table>
        <cfset caller.form_box_count = 0>
    </cfif>
    <cfif attributes.closeForGrid eq 1>
        <cfset attributes.is_closed = 1>
    </cfif>
    <cfif attributes.important_closed eq 1>
        <cfset attributes.is_closed = 1>
    </cfif>
    <cfif isdefined("attributes.is_designer")><div class="row" type="row" style="#attributes.style#"><div class="col col-12 col-md-12 col-sm-12 col-xs-12"  type="column" index="#attributes.index#" sort="true" id="#attributes.seperator_id#"> <div class="form-group" id="item-form-seperator_#attributes.id#"><label style="display:none!important">#attributes.header#</label></cfif>
  
    <div class="seperator #attributes.class#" id="seperator" <cfif len(attributes.seperator_width)>style="width:#attributes.seperator_width#px"</cfif>>
        
        <cfif isdefined("seperator_order_id")><ul style="list-style-type:none;padding-left: inherit;"><cfelse><ul style="list-style-type:none;background-color:##f9f9f9;padding-left: inherit;"></cfif>
            <li style="display:inline-block;">
                <a href="javascript://"style="text-decoration: none!important;" class="<cfif attributes.is_closed eq 0><cfelse>active</cfif>"  onclick="gizle_goster_image1(this, '#attributes.id#_1','#attributes.id#_2','#attributes.id#','#this_act_#'); <cfif len(attributes.onClick_function)>#attributes.onClick_function#</cfif>">
                    <i class="fa fa-chevron-right" id="#attributes.id#_2"></i>
                    #attributes.header#
                </a>
            </li>
                
        
            <div class="pull-right">
                <li style="display:inline-block;">
                    <!--- add_href --->
                    <cfif len(attributes.add_href) and attributes.add_href contains 'javascript:'>
                        <a href="javascript://" onclick="#attributes.add_href#" class="font-red-pink"><i style="font-size:14px!important;" class="fa fa-plus"></i>#attributes.info_title_add#</a>
                    <cfelseif len(attributes.add_href) and attributes.add_href contains 'ajaxpageload'>
                        <a href="javascript://" onclick="#attributes.add_href#" class="font-red-pink"><i style="font-size:14px!important;" class="fa fa-plus"></i>#attributes.info_title_add#</a>
                    <cfelseif len(attributes.add_href) and (attributes.add_href contains 'cfmodal' or attributes.add_href contains 'openBoxDraggable')>
                        <a href="javascript://" onclick="#attributes.add_href#" class="font-red-pink"><i style="font-size:14px!important;" class="fa fa-plus"></i>#attributes.info_title_add#</a>
                    <cfelseif len(attributes.add_href) and not(attributes.add_href contains 'popup_' or attributes.add_href contains '_popup')>
                        
                            <cfif attributes.is_blank eq 1>
                                <a href="#attributes.add_href#" target="_blank" class="font-red-pink"><i style="font-size:14px!important;" class="fa fa-plus"></i>#attributes.info_title_add#</a>
                            <cfelse>
                                <a href="#attributes.add_href#" class="font-red-pink"><i style="font-size:14px!important;" class="fa fa-plus"></i>#attributes.info_title_add#</a>
                            </cfif>
                        
                    <cfelseif len(attributes.add_href)>
                        <a href="javascript://" onclick="windowopen('#attributes.add_href#','#attributes.add_href_size#');" class="font-red-pink"><i style="font-size:14px!important;" class="fa fa-plus"></i>#attributes.add_href_title#</a>
                    </cfif>
                    <!--- //add_href --->
    
                </li>
                <li style="display:inline-block;">
                    <!--- upd_href --->
                    <cfif len(attributes.upd_href) and attributes.upd_href contains 'javascript:'>
                        <a href="javascript://" onclick="#attributes.upd_href#" class="font-red-pink"><i style="font-size:14px!important;" class="fa fa-pencil"></i>#attributes.info_title_upd#</a>
                    <cfelseif len(attributes.upd_href) and attributes.upd_href contains 'ajaxpageload'>
                        <a href="javascript://" onclick="#attributes.upd_href#" class="font-red-pink"><i style="font-size:14px!important;" class="fa fa-pencil"></i>#attributes.info_title_upd#</a>
                    <cfelseif len(attributes.upd_href) and (attributes.upd_href contains 'cfmodal' or attributes.upd_href contains 'openBoxDraggable')>
                        <a href="javascript://" onclick="#attributes.upd_href#" class="font-red-pink"><i style="font-size:14px!important;" class="fa fa-pencil"></i>#attributes.info_title_upd#</a>
                    <cfelseif len(attributes.upd_href) and not(attributes.upd_href contains 'popup_' or attributes.upd_href contains '_popup')>
                        
                            <cfif attributes.is_blank eq 1>
                                <a href="#attributes.upd_href#" target="_blank" class="font-red-pink"><i style="font-size:14px!important;" class="fa fa-pencil"></i>#attributes.info_title_upd#</a>
                            <cfelse>
                                <a href="#attributes.upd_href#" class="font-red-pink"><i style="font-size:14px!important;" class="fa fa-pencil"></i>#attributes.info_title_upd#</a>
                            </cfif>
                        
                    <cfelseif len(attributes.upd_href)>
                        <a href="javascript://" onclick="windowopen('#attributes.upd_href#','#attributes.upd_href_size#','#attributes.id#');" class="font-red-pink"><i style="font-size:14px!important;" class="fa fa-pencil"></i>#attributes.upd_href_title#</a>
                    </cfif>
                    <!--- //upd_href --->
    
                </li>
                
                <li style="display:inline-block;">
                    <!--- del_href --->
                    <cfif len(attributes.del_href) and attributes.del_href contains 'javascript:'>
                        <a href="javascript://" onclick="#attributes.del_href#" class="font-red-pink"><i style="font-size:14px!important;" class="fa fa-trash"></i>#attributes.info_title_del#</a>
                    <cfelseif len(attributes.del_href) and attributes.del_href contains 'ajaxpageload'>
                        <a href="javascript://" onclick="#attributes.del_href#" class="font-red-pink"><i style="font-size:14px!important;" class="fa fa-trash"></i>#attributes.info_title_del#</a>
                    <cfelseif len(attributes.del_href) and (attributes.del_href contains 'cfmodal' or attributes.del_href contains 'openBoxDraggable')>
                        <a href="javascript://" onclick="#attributes.del_href#" class="font-red-pink"><i style="font-size:14px!important;" class="fa fa-trash"></i>#attributes.info_title_del#</a>
                    <cfelseif len(attributes.del_href) and not(attributes.del_href contains 'popup_' or attributes.del_href contains '_popup')>
                        
                            <cfif attributes.is_blank eq 1>
                                <a href="#attributes.del_href#" target="_blank" class="font-red-pink"><i style="font-size:14px!important;" class="fa fa-trash"></i>#attributes.info_title_del#</a>
                            <cfelse>
                                <a href="#attributes.del_href#" class="font-red-pink"><i style="font-size:14px!important;" class="fa fa-trash"></i>#attributes.info_title_del#</a>
                            </cfif>
                        
                    <cfelseif len(attributes.del_href)>
                        <a href="javascript://" onclick="windowopen('#attributes.del_href#','#attributes.del_href_size#','#attributes.id#');" class="font-red-pink"><i class="catalyst-trash"></i>#attributes.del_href_title#</a>
                    </cfif>
                    <!--- //del_href --->
                </li>
            </div>
        </ul>
       
    </div>
    <cfif isdefined("attributes.is_designer")></div></div></div></cfif>

    <script type="text/javascript">
    <cfif isdefined("caller.attributes.ajax")><!--- Box sayfanin icinden gelen seperatorler icin bu fonksiyona girmesi gerekiyor. EY20130917 --->
        <cfif attributes.is_closed eq 0>
        $(window).load(function () {init_#attributes.id#()});
        function init_#attributes.id#(){
            document.getElementById('<cfoutput>#attributes.id#</cfoutput>').style.display = '';
            }
        </cfif>
    <cfelse>
        <cfif attributes.is_closed eq 0>
         function init_#attributes.id#(){
            document.getElementById('<cfoutput>#attributes.id#</cfoutput>').style.display = '';
            }
        $(window).load(function () 
                        { 
                        init_#attributes.id#();
                        });
        </cfif>
    </cfif>
    function gizle_goster_image1(el,id,id2,txt,this_fuseact){
        var action_div_ = 'action_' + txt;
        var load_info_ = 0;
        if(document.getElementById(txt).style.display == 'block' || document.getElementById(txt).style.display == ''){
            document.getElementById(txt).style.display = 'none';
            el.classList.remove("active");
            load_info_ = 0;
        }
        else{
            document.getElementById(txt).style.display = '';
            el.classList.add("active");
            load_info_ = 1;
        }
        adress_ = 'index.cfm?fuseaction=objects.xml_setting_personality';
        adress_ += '&bid=' + txt;
        adress_ += '&fuse=' + this_fuseact;
        adress_ += '&action_name=unload_body_sep';
        adress_ += '&action_value=' + load_info_;
        AjaxPageLoad(adress_,action_div_);
    }
    </script>
    </cfoutput>
<cfelse>
    </section>
</cfif>
