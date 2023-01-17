<br />
<cfoutput>
  <div class="menus2">
    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
            <td>
               <table border="0" cellpadding="0" cellspacing="0" id="wrk_module_menu_inner_table">
                    <tr>
                        <cfset c_f_ = 0>
                        <cfloop list="#f_n_action_list#" index="mcc">
                                <cfset link_type_ = listgetat(mcc,2,"*")>
                                <cfif len(mcc) and not listfindnocase(denied_pages,'#listfirst(listgetat(mcc,1,"*"),"&")#')>
                                <td nowrap id="wrk_module_menu_inner_table_td" style="font-size:12px; color:blue">
                                    <cfset c_f_ = c_f_ + 1>
                                    <cfif c_f_ eq 1></cfif>
                                    <cfif link_type_ is '0' or link_type_ is '3'>
                                        <a href="#request.self#?fuseaction=#listgetat(mcc,1,"*")#">#listgetat(mcc,4,"*")#</a>
                                    <cfelseif link_type_ is '2'>
                                        <cfset link_layer_ = listgetat(mcc,3,"*")>
                                        <a href="##" onMouseOver="workcube_showHideLayers('#link_layer_#','','show');" onMouseOut="workcube_showHideLayers('#link_layer_#','','hide');">#listgetat(mcc,4,"*")#</a>
                                    <cfelseif link_type_ is '1'>
                                        <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=#listgetat(mcc,1,"*")#','#listgetat(mcc,3,"*")#');">#listgetat(mcc,4,"*")#</a>
                                    </cfif>
                                    <cfif c_f_ eq 1></cfif>
                                    <cfif c_f_ eq listlen(f_n_action_list)>
                                        <cfif c_f_ neq 1></cfif>							
                                    <cfelse>
                                        <cfif c_f_ neq 1></cfif>							
                                    </cfif>
                                    &nbsp;&nbsp;
                                </td>	
                            </cfif>					
                            </cfloop>
                       <cfif isdefined("add_info_table")><td width="20%">#add_info_table#</td></cfif>
                    </tr>
                    <tr style="line-height:0px;height:0px;">
                        <cfset c_f_ = 0>
                        <cfloop list="#f_n_action_list#" index="mcc">
                        <cfset link_type_ = listgetat(mcc,2,"*")>
                        <cfif len(mcc) and not listfindnocase(denied_pages,'#listfirst(listgetat(mcc,1,"*"),"&")#')>
                            <td>					 	
                                <cfset c_f_ = c_f_ + 1>
                                <cfif c_f_ eq 1></cfif>
                                <cfif link_type_ is '0'>
                                <cfelseif link_type_ is '3'>
                                <cfelseif link_type_ is '2'>
                                    <cfset link_layer_ = listgetat(mcc,3,"*")>
                                    #evaluate("#link_layer_#_div")#
                                <cfelseif link_type_ is '1'>
                                </cfif>
                                <cfif c_f_ eq 1></cfif>
                            </td>
                        </cfif>
                        </cfloop>	
                        <cfif isdefined("add_info_table")><td></td></cfif>	
                        <td></td>
                    </tr>
                </table>
            </td>
            <td style="text-align:right;"></td>
        </tr>
    </table>
  </div>
</cfoutput>