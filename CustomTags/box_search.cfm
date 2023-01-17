<!--- Kullanımı
    <cf_box_search>
        <div class="form-group">
            <input type="text" palceholder="Filtre">
        </div>
        .....
        <div class="form-group"><cf_wrk_search_button button_type="4"></div>
    </cf_box_search> --->

    <cfparam name="attributes.id" default="box_search_#caller.attributes.fuseaction#">
    <cfset fuseact = '#caller.attributes.fuseaction#'>
    <cfparam name="attributes.extra" default="0"> <!--- Sayfada birden fazla box_search varsa ve bazılarında daha fazlası olmasını istemiyorsan , daha fazlası olacak box_searche extra="1" btn_id="search butonun olduğu form group divinin id si" verebilirsin. Idler unique olmalı --->
    <cfparam name="attributes.btn_id" default="0">
    <cfparam name="attributes.more" default="1"><!---Form da daha fazlası yok ise 0 gönderiyoruz.--->
    <cfparam name="attributes.plus" default="1"><!---Form da + butonu fonskiyon ile gelmesini istemiyorsak 0 veriyoruz.--->
    <cfset attributes.id = replace(attributes.id,'.','_')>
    <cfset caller.last_table_id = attributes.id>
    <cfif isdefined("attributes.collapsed") and attributes.collapsed eq 1> <!--- Bu kosul disaridan collapsed attributes'u find_active imajinin degilde find imajinin gelmesi icin eklendi. Bunun devami detail_area custom tag'inde. Orada da detail_area'nin gizli gelmesi icin kullaniliyor... E:Y 20121011 --->
        <cfset caller.collapsed = 1>
    <cfelseif isdefined("attributes.collapsed") and attributes.collapsed eq 0>
        <cfset caller.collapsed = 0>
    <cfelse>
        <cfset attributes.collapsed = 0>
        <cfif isdefined("caller.xml_unload_body_#caller.last_table_id#")>   
            <cfset attributes.collapsed = evaluate("caller.xml_unload_body_#caller.last_table_id#")>
        <cfelseif isdefined("caller.caller.xml_unload_body_#caller.last_table_id#")> 
            <cfset attributes.collapsed = evaluate("caller.caller.xml_unload_body_#caller.last_table_id#")>
        </cfif>
        <cfset caller.collapsed = 2>
    </cfif>
    
    <cfoutput>
        <cfif thisTag.executionMode eq "start">
            <div class="ui-form-list flex-list" id="<cfoutput>#attributes.id#</cfoutput>" cellspacing="0">
                <cfif isdefined("caller.WOStruct") and StructKeyExists(caller.WOStruct['#caller.attributes.fuseaction#'],'add') and StructKeyExists(caller.WOStruct['#caller.attributes.fuseaction#']['add'],'fuseaction')>
                    <cfif StructKeyExists(caller.WOStruct['#caller.attributes.fuseaction#'],'list') and StructKeyExists(caller.WOStruct['#caller.attributes.fuseaction#']['list'],'addButton') and caller.WOStruct['#caller.attributes.fuseaction#']['list']['addButton'] eq 0>
                        <cfset addFuseaction = ''>
                    <cfelse>
                        <cfset addFuseaction = '#caller.attributes.fuseaction#&event=add'><!--- #caller.attributes.fuseaction#&event=add Daha sonra bakılacak.EY20161020 ---> 
                    </cfif>
                <cfelse>
                    <cfset addFuseaction = ''>
                </cfif>
                <cfif attributes.more eq 1>
                <script type="text/javascript">
                    $(function (){
    
                        var form_group = $('<div>');
                        form_group.attr("class", "form-group");
    
                        var btn = $('<a>');
                        btn.attr({
                            "id":"ui-otherFileBtn_#attributes.id#",
                            "href":"javascript://",
                            "class":"ui-btn ui-btn-blue ui-btn-addon-right"
                        });
                        btn.text("<cf_get_lang dictionary_id='57904'>");
                        btn.click(function(){
                            show_hide_big_list('#attributes.id#','#fuseact#');
                            $("###attributes.id#_search_div").stop().slideToggle();
                            $(this).toggleClass("ui-otherFileBtn-open");
                        });
    
                        var icon = "<i class='fa fa-angle-down'></i>";
    
                        btn.append(icon);
                        form_group.append(btn);
                        if( $('##ui-otherFileBtn').length == 0 &&  $(".ui-otherFile").length > 0 &&   $('##ui-otherFileBtn_#attributes.id#').length == 0){
                            $('###attributes.id# ##wrk_search_button').parent('.form-group').after(form_group);
                        } 
                        <cfif attributes.plus eq 1>
                            <cfif len(addFuseaction)>
                                var form_group2 = $('<div>');
                                form_group2.attr("class", "form-group");
    
                                var btn2 = $('<a>');
                                btn2.attr({
                                    "id":"ui-plus",
                                    "href":"javascript://",
                                    "class":"ui-btn ui-btn-gray"
                                });
                                $("table.ui-table-list th, table.ajax_list th").find("i[class='fa fa-plus']").parent("a").attr("id","add-plus-button");
                                btn2.click(function(){
                                    if($("##add-plus-button").attr("onClick"))
                                        $("##add-plus-button").trigger("click");
                                    else
                                        window.location.href = $("##add-plus-button").attr("href");
                                });
    
                                var icon2 = "<i class='fa fa-plus'></i>";
    
                                btn2.append(icon2);
                                form_group2.append(btn2);
                                $('.flex-list').eq(0).append(form_group2);
                            </cfif>        
                        </cfif>
                    }); 
                    
                </script>
                </cfif>
                <cfif attributes.extra eq 1>
                    <script type="text/javascript">
                    $(function (){
    
                        var form_group = $('<div>');
                        form_group.attr("class", "form-group");
    
                        var btn = $('<a>');
                        btn.attr({
                            "id":"ui-otherFileBtn",
                            "href":"javascript://",
                            "class":"ui-btn ui-btn-blue ui-btn-addon-right"
                        });
                        btn.text("<cf_get_lang dictionary_id='57904'>");
                        btn.click(function(){
                            show_hide_big_list('#attributes.id#','#fuseact#');
                            $(".ui-otherFile").stop().slideToggle();
                            $(this).toggleClass("ui-otherFileBtn-open");
                        });
    
                        var icon = "<i class='fa fa-angle-down'></i>";
                        btn.append(icon);
                        form_group.append(btn);                   
                        $('.ui-form-list ##<cfoutput>#attributes.btn_id#</cfoutput>').after(form_group);
                    }); 
                    
                </script>
                </cfif>
        <cfelse>
            </div>
        </cfif>
    </cfoutput>
    
    
    