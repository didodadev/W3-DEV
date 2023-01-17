<cfparam name="attributes.protein_menu" default="">
<cfset GET_MENU = MAIN.GET_MENU(MENU:attributes.protein_menu)>
<cfif len(GET_MENU.MENU_DATA)>
    <cfset GET_MENU_JSON = #deserializeJSON(GET_MENU.MENU_DATA)#>
<cfelse>
    <cfset GET_MENU_JSON = #deserializeJSON("[]")#>
</cfif>

<cfoutput>
    <nav aria-label="breadcrumb" class="nav-button">
        <div class="row">
            <div class="col">
                <div style=" padding: 0px 0 0 5px;font-weight: 700!important;font-size: 22px;margin-top:-5px">
                    <cfif attributes.protein_menu_title eq 1>                
                    #GET_MENU.MENU_NAME#
                    <cfelseif attributes.protein_menu_title eq 3>
                        #widget_box_data.title#
                    <cfelseif isDefined("attributes.protein_menu_action") and attributes.protein_menu_title eq 2> 
                        #MAIN.GET_ACTION_TITLE(attributes.protein_menu_action,evaluate("attributes.#attributes.protein_menu_action#"))#
                    </cfif>
                </div>
            </div>
            <div class="col">      
                <ol class="bg-transparent breadcrumb justify-content-end" style=" padding: 0px 0 0 5px;font-weight: 700!important;font-size: 22px; font-weight: 700!important; font-size: 22px;margin:0px;">            
                    <cfloop array="#GET_MENU_JSON#" item="ITEM">
                        <cfset item_url = ITEM.url>
                        <cfloop array="#reMatch("{{[\.a-zA-Z0-9_-]+}}",item_url)#" item="e">
                            <cfset newparam = evaluate(replace(replace(e,"{{","","all"),"}}","","all"))>
                            <cfset item_url = replace(ITEM.url,e,newparam,"all")>
                        </cfloop>
                        <li <cfif ITEM.type eq "group">class="nav-item dropdown"<cfelse> class="breadcrumb-item"</cfif>>
                            <a <cfif ITEM.type neq "group"> class="-link color-#Left(ITEM.name, 1)#" href="#item_url#"<cfelse>class="-group"</cfif>>
                            <cfif structKeyExists(ITEM, 'icn') AND len(ITEM.icn)>
                                <i class="#ITEM.icn#"></i>
                            </cfif>
                            #ITEM.name#                            
                        </a>
                        <cfif ITEM.type eq 'group'>        
                            <!--- <div class="dropdown-menu">
                            <cfloop array="#ITEM.CHILDREN#" item="ITEM">
                                <a class="dropdown-item" href="#ITEM.url#">#ITEM.name#</a>
                            </cfloop>
                            </div> --->
                        </cfif>
                        </li>
                    </cfloop>
                </ol>           
            </div>
        </div>
    </nav>
</cfoutput>
