<header class="site_head">
    <div class="top"></div> 
    <div class="nav">
        <div class="container">
            <div class="row">
                <div class="col">
                        <div class="menu">
                        <a class="line" href="javascript://">
                            <span></span>
                            <span></span>
                            <span></span>
                        </a>
                        <!-- Menu -->
                        <ul>
                            <cfoutput>                        
                              <cfloop array="#GET_DEFAULT_MENU_JSON#" item="ITEM">
                                <li <cfif ITEM.type eq "group">class="dropdown"</cfif>><a <cfif ITEM.type neq "group"> href="#ITEM.url#"<cfelse>class="dropdown-toggle" data-toggle="dropdown"</cfif>>#ITEM.name#</a>
                                <cfif ITEM.type eq 'group'>
                                  <ul class="dropdown-menu d-none">
                                    <cfloop array="#ITEM.CHILDREN#" item="ITEM">
                                      <li <cfif ITEM.type eq "group">class="dropdown"</cfif>><a <cfif ITEM.type neq "group"> href="#ITEM.url#"<cfelse>class="dropdown-toggle" data-toggle="dropdown"</cfif>>#ITEM.name#</a>                                      
                                        <cfif ITEM.type eq 'group'>
                                          <ul class="dropdown-menu">
                                            <cfloop array="#ITEM.CHILDREN#" item="ITEM">
                                              <li <cfif ITEM.type eq "group">class="dropdown"</cfif>><a <cfif ITEM.type neq "group"> href="#ITEM.url#"<cfelse>class="dropdown-toggle" data-toggle="dropdown"</cfif>>#ITEM.name#</a>
                                                <cfif ITEM.type eq 'group'>
                                                  <ul class="dropdown-menu">
                                                    <cfloop array="#ITEM.CHILDREN#" item="ITEM">
                                                      <li <cfif ITEM.type eq "group">class="dropdown"</cfif>><a <cfif ITEM.type neq "group"> href="#ITEM.url#"<cfelse>class="dropdown-toggle" data-toggle="dropdown"</cfif>>#ITEM.name#</a>
                                                        <cfif ITEM.type eq 'group'>
                                                          <ul class="dropdown-menu">
                                                            <cfloop array="#ITEM.CHILDREN#" item="ITEM">
                                                              <li <cfif ITEM.type eq "group">class="dropdown"</cfif>><a <cfif ITEM.type neq "group"> href="#ITEM.url#"<cfelse>class="dropdown-toggle" data-toggle="dropdown"</cfif>>#ITEM.name#</a></li>
                                                            </cfloop>
                                                          </ul>
                                                        </cfif>                                                      
                                                      </li>
                                                    </cfloop>
                                                  </ul>
                                                </cfif>                                              
                                              </li>
                                            </cfloop>
                                          </ul>
                                        </cfif>
                                      </li>
                                    </cfloop>
                                  </ul>
                                </cfif>
                                </li>
                              </cfloop>
                            </cfoutput>
                        </ul>
                    </div> 
                </div>
                <div class="col">
                    <div class="icon_menu">
                        <form>
                            <input type="search" placeholder="Site içi arama">
                        </form>
                        <ul>
                            <li><a href=""><i class="fas fa-shopping-basket"></i>
                                <span class="badge">1</span>
                            </a></li>
                            <li><a href=""><i class="fas fa-user"></i></a></li>
                            <li><a href=""><i class="fas fa-heart"></i>
                                <span class="badge">2</span>
                            </a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</header>