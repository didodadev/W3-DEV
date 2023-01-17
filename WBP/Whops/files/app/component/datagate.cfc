<cfcomponent>

    <cfif isdefined("session.pp")>
        <cfset session_base = evaluate('session.pp')>
    <cfelseif isdefined("session.ep")>
        <cfset session_base = evaluate('session.ep')>
    <cfelseif isdefined("session.ww")>
        <cfset session_base = evaluate('session.ww')>
    <cfelseif isdefined("session.wp")>
        <cfset session_base = evaluate('session.wp')>
    </cfif>

    <cffunction name="basketConverter" access="remote" returnformat="JSON" hint="Basket tarafından gelen datalar convert edip ilgili cfc adresine gönderilir">
        <cfset data_packet = arguments>
        <cfif not isDefined("session_base.USERID")>
            <cfreturn '{ status: false, message: "user not found" }'>
        </cfif>
        <!--- <cfif super.resolveObject("AddOns.Plevne.core.requestfilter").inspect_onservice(arguments) neq true>
            <cfreturn '{ status: false, message: "inspeced" }'>
        </cfif> --->
        
        <cfset data_packet.form_data = deserializeJson(URLDecode( data_packet.form_data, "utf-8" )) />
        <cfset funct_instance = createObject("component", "#data_packet.cfc#")>
        <cfset response = structNew()>
        <cftry>
            <cfloop array="#DeserializeJSON(data_packet.form_data.basket_json)#" index="bi" item="basket_row">
                <cfloop array="#structKeyArray(basket_row)#" index="ri" item="rk">
                    <cfif not (isArray(basket_row[rk]) or isStruct(basket_row[rk]))>
                        <cfset data_packet.form_data["#rk##bi#"] = basket_row[rk]>
                        <cfif findNoCase("other_money", rk) gt 0 >
                            <cfset data_packet.form_data["#rk#_#bi#"] = basket_row[rk]>
                        <cfelseif findNoCase("tax_percent", rk) gt 0 >
                            <cfset data_packet.form_data["#rk##bi#"] = basket_row[rk]>
                        <cfelseif findNoCase("other_money_value", rk) gt 0 > 
                            <cfset data_packet.form_data["#rk#_#bi#"] = basket_row[rk]>
                        <cfelseif findNoCase("unit2", rk) gt 0 > 
                            <cfset data_packet.form_data["unit_other#bi#"] = basket_row[rk]>
                            <cfset data_packet.form_data["#rk##bi#"] = basket_row[rk]>
                        <cfelseif findNoCase("other_money_grosstotal", rk) gt 0 > 
                            <cfset data_packet.form_data["#rk##bi#"] = basket_row[rk]>
                            <cfset data_packet.form_data["other_money_gross_total#bi#"] = basket_row[rk]>
                        <cfelseif findNoCase("deliver_dept", rk) gt 0 > 
                            <cfset data_packet.form_data["#rk##bi#"] = basket_row[rk]>
                            <cfset data_packet.form_data["basket_row_departman#bi#"] = basket_row[rk]>
                        <cfelseif FindNoCase("disc_ount", rk) gt 0 > 
                            <cfif listFindNoCase("disc_ount", rk) gt 0 > 
                                <cfset data_packet.form_data["indirim1#bi#"] = basket_row[rk]>
                            <cfelseif listFindNoCase("disc_ount2_", rk) gt 0 > 
                                <cfset data_packet.form_data["indirim2#bi#"] = basket_row[rk]>
                            <cfelseif listFindNoCase("disc_ount3_", rk) gt 0 > 
                                <cfset data_packet.form_data["indirim3#bi#"] = basket_row[rk]>
                            <cfelseif listFindNoCase("disc_ount4_", rk) gt 0 > 
                                <cfset data_packet.form_data["indirim4#bi#"] = basket_row[rk]>
                            <cfelseif listFindNoCase("disc_ount5_", rk) gt 0 > 
                                <cfset data_packet.form_data["indirim5#bi#"] = basket_row[rk]>
                            <cfelseif listFindNoCase("disc_ount6_", rk) gt 0 > 
                                <cfset data_packet.form_data["indirim6#bi#"] = basket_row[rk]>
                            <cfelseif listFindNoCase("disc_ount7_", rk) gt 0 > 
                                <cfset data_packet.form_data["indirim7#bi#"] = basket_row[rk]>
                            <cfelseif listFindNoCase("disc_ount8_", rk) gt 0 > 
                                <cfset data_packet.form_data["indirim8#bi#"] = basket_row[rk]>
                            <cfelseif listFindNoCase("disc_ount9_", rk) gt 0 > 
                                <cfset data_packet.form_data["indirim9#bi#"] = basket_row[rk]>
                            <cfelseif listFindNoCase("disc_ount10_", rk) gt 0 > 
                                <cfset data_packet.form_data["indirim10#bi#"] = basket_row[rk]>
                            </cfif>
                        </cfif>
                    </cfif>
                </cfloop>
            </cfloop>
            <cfset header_value_json = data_packet.form_data.header_value_json>
            <cfloop array="#structKeyArray(header_value_json)#" index="si" item="sk">
                <cfif not ( isArray(header_value_json[sk]) or isStruct(header_value_json[sk]) )>
                    <cfset data_packet.form_data[sk] = header_value_json[sk]>
                </cfif>
            </cfloop>
            <cfset summary_json = DeserializeJSON(data_packet.form_data.summary_json)>
            <cfset data_packet.form_data.rows_ = arrayLen(DeserializeJSON(data_packet.form_data.basket_json))>
            <cfloop array="#structKeyArray(summary_json)#" index="si" item="sk">
                <cfif not ( isArray(summary_json[sk]) or isStruct(summary_json[sk]) )>
                    <cfset data_packet.form_data[sk] = summary_json[sk]>
                </cfif>
            </cfloop>
            <cfloop array="#DeserializeJSON(data_packet.form_data.rates_json)#" index="ri" item="rt">
                <cfset data_packet.form_data["hidden_rd_money_#ri#"] = rt.money_type>
                <cfset data_packet.form_data["txt_rate1_#ri#"] = rt.rate1>
                <cfset data_packet.form_data["txt_rate2_#ri#"] = rt.rate2>
            </cfloop>
            <!--- <cfset extensions = createObject('component','WDO.development.cfc.extensions')>
            <cfset before_extensions = extensions.get_related_components( (data_packet.basketv eq 1) ? data_packet.form_data.hidden_values.fuseaction : data_packet.form_data.header_value_json.fuseaction, 2, 1, isDefined("data_packet.event") ? data_packet.event : "list")>
            <cfloop query="before_extensions">
                <cfinclude template="../#before_extensions.COMPONENT_FILE_PATH#">
            </cfloop> --->

            <cfset response = evaluate("funct_instance.#data_packet.function#(argumentCollection=data_packet.form_data)")>

            <!--- <cfset after_extensions = extensions.get_related_components( (data_packet.basketv eq 1) ? data_packet.form_data.hidden_values.fuseaction : data_packet.form_data.header_value_json.fuseaction, 2, 2, isDefined("data_packet.event") ? data_packet.event : "list")>
            <cfloop query="after_extensions">
                <cfinclude template="../#after_extensions.COMPONENT_FILE_PATH#">
            </cfloop> --->
            <cfcatch type="any">
                <cfsavecontent variable="control2"><cfdump var="#arguments#"></cfsavecontent>
                <cffile action="write" file = "c:\attributes.html" output="#control2#"></cffile>
                <cfsavecontent variable="control5"><cfdump var="#cfcatch#"></cfsavecontent>
                <cffile action="write" file = "c:\cfcatch.html" output="#control5#"></cffile>
                <cfset response.status = false>
                <cfset response.message = "İşlem Hatalı">
                <cfset response.error = cfcatch>
            </cfcatch>
        </cftry>
        <cfset getPageContext().getCFOutput().clearAll()>
        <cfset getPageContext().getCFOutput().clearHeaderBuffers()>
        <cfreturn Replace( SerializeJson( response ), "//", "" )>
    </cffunction>

    <cffunction name="delActions" access="remote" returnformat="JSON" hint="Wrk buton içerisinden gelen cfc,fonksiyon ve parametrelerine göre del event işlemleri yapılır">
        <cfset data_packet = arguments>
        
        <cfif not isDefined("session_base.USERID")>
            <cfreturn "{ status: true }">
        </cfif>
        <cfif super.resolveObject("AddOns.Plevne.core.requestfilter").inspect_onservice(arguments) neq true>
            <cfreturn "{ status: true }">
        </cfif>

        <cfset funct_instance = createObject("component", "#data_packet.cfc#")>
        <cfset response = structNew()>

        <cfset extensions = createObject('component','WDO.development.cfc.extensions')>
        <cfset before_extensions = extensions.get_related_components(data_packet.fuseaction, 2, 1, "del")>
        <cfloop query="before_extensions">
            <cfinclude template="../#before_extensions.COMPONENT_FILE_PATH#">
        </cfloop>

        <cfset response = evaluate("funct_instance.#data_packet.function#(argumentCollection=data_packet)")>

        <cfset after_extensions = extensions.get_related_components(data_packet.fuseaction, 2, 2, "del")>
        <cfloop query="after_extensions">
            <cfinclude template="../#after_extensions.COMPONENT_FILE_PATH#">
        </cfloop>
        <cfset GetPageContext().getCFOutput().clear()>
        <cfreturn Replace( SerializeJson( response ), "//", "" )>
    </cffunction>

    <cffunction name="formConverter" access="remote" returnformat="JSON" hint="wrk button tarafından gelen datalar convert edip ilgili cfc adresine gönderilir">
        <cfset data_packet = arguments>
        <cfset getFormData = deserializeJSON(data_packet.form_data)>
        <cfset formDataStruct = structNew()>
        
        <cfif not isDefined("session_base.USERID")>
            <cfreturn "{ status: true }">
        </cfif>
        <cfif super.resolveObject("AddOns.Plevne.core.requestfilter").inspect_onservice(arguments) neq true>
            <cfreturn "{ status: true }">
        </cfif>

        <cfloop from="1" to="#arrayLen(getFormData)#" index="k">
            <cfif not structKeyExists( formDataStruct, getFormData[k].name )>
                <cfset structInsert(formDataStruct, getFormData[k].name, getFormData[k].value)>
            </cfif>
        </cfloop>
            <cfset structInsert(formDataStruct, "fuseaction", data_packet.fuseaction)>
        <cfset data_packet.form_data = formDataStruct>
        <cfset funct_instance = createObject("component", "#data_packet.cfc#")>
        <cfset response = structNew()>
        
        <cftry>
            <cfloop collection='#data_packet.form_data#' item='k'>
                <cfset data_packet.form_data[k] = data_packet.form_data[k]>
                <cfif k contains 'CKEDITOR_'>
                    <cfset data_packet.form_data[Replace(k,'CKEDITOR_','')] = data_packet.form_data[k]>
                </cfif>
            </cfloop>

            <cfset extensions = createObject('component','WDO.development.cfc.extensions')>
            <cfset before_extensions = extensions.get_related_components(data_packet.fuseaction, 2, 1, isDefined("data_packet.event") ? data_packet.event : "list")>
            <cfloop query="before_extensions">
                <cfinclude template="../#before_extensions.COMPONENT_FILE_PATH#">
            </cfloop>

            <cfset response = evaluate("funct_instance.#data_packet.function#(argumentCollection=data_packet.form_data)")>
            <!--- <cfheader name="Content-Type" value="application/json"> --->
            <cfset after_extensions = extensions.get_related_components(data_packet.fuseaction, 2, 2, isDefined("data_packet.event") ? data_packet.event : "list")>
            <cfloop query="after_extensions">
                <cfinclude template="../#after_extensions.COMPONENT_FILE_PATH#">
            </cfloop>

            <cfcatch type="any">
                <cfsavecontent variable="control2"><cfdump var="#arguments#"></cfsavecontent>
                <cffile action="write" file = "c:\attributes.html" output="#control2#"></cffile>
                <cfsavecontent variable="control5"><cfdump var="#cfcatch#"></cfsavecontent>
                <cffile action="write" file = "c:\cfcatch.html" output="#control5#"></cffile>
                <cfset response.status = false>
                <cfset response.message = "İşlem Hatalı">
                <cfset response.error = cfcatch>
            </cfcatch>
        </cftry>
        <cfset getPageContext().getCFOutput().clearAll()>
        <cfset getPageContext().getCFOutput().clearHeaderBuffers()>
        <cfreturn Replace( SerializeJson( response ), "//", "" )>
    </cffunction>
    

</cfcomponent>