<!--- Kullanımı
    <cf_box_search_detail>
        <div class="form-group col col-3 col-md-4 col-sm-6 col xs-12">
            <label><cf_get_lang_main no="1655.Varlık"></label>
            <input type="text">
        </div>
        .....
    </cf_box_search_detail> --->

<!--- Butona box_searchde bulunan search butonun onclickine verilen fonksiyonu vermek istiyorsak search_function attributes ile gerçekleştirebilriz. 
KULLANIMI <cf_box_search_detail search_function="control()"></cf_box_search_detail> --->
<cfparam name="attributes.float" default="left">
<cfparam name="attributes.type" default="1">
<cfif caller.collapsed eq 1> <!--- Bu kosul big_list_search custom tag'inde atanip XML'leri dikkate almayip direk olarak buranin gizli gelmesini sagliyor... E:Y 20121011 --->
	<cfset attributes.collapsed = 1>
<cfelseif caller.collapsed eq 0>
	<cfset attributes.collapsed = 0>
<cfelse>
	<cfset attributes.collapsed = 0>
	<cfif isdefined("caller.xml_unload_body_#caller.last_table_id#")>
        <cfset attributes.collapsed = evaluate("caller.xml_unload_body_#caller.last_table_id#")>
    <cfelseif isdefined("caller.caller.xml_unload_body_#caller.last_table_id#")>
        <cfset attributes.collapsed = evaluate("caller.caller.xml_unload_body_#caller.last_table_id#")>
    </cfif>
</cfif>
<cfparam name="attributes.fuseaction" default="#caller.attributes.fuseaction#">
<cfparam name="attributes.is_excel" default="1">
<cfif thisTag.executionMode eq "start">
	<cfoutput>
    <div  style="<cfif attributes.collapsed eq 0>display:none;<cfelse>display:block;</cfif>" id="#caller.last_table_id#_search_div" class="ui-otherFile">
            <div class="ui-otherFileTitle">
                <h2><cf_get_lang dictionary_id="47523.Filtre S."></h2>
            </div>
            <div class="ui-form-list ui-form-block">
                <div>
                    <div class="row" <cfif attributes.type eq 1>type="row"</cfif>>
	</cfoutput>    
<cfelse>            </div>
                </div>
            </div>
            <div class="ui-form-list-btn">
                <cf_wrk_search_button button_type="5" search_function="#IIf((isdefined('attributes.search_function')),Evaluate(DE('attributes.search_function')),'')#">
            </div>
        </div>
</cfif>
