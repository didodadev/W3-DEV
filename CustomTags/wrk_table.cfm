<cfparam name="attributes.name" default="workcube_grid">
<cfparam name="attributes.header" default="">
<cfparam name="attributes.width" default="100%">
<cfparam name="attributes.userInfo" default="0">
<cfparam name="attributes.tableName" default="">
<cfparam name="attributes.query" default="">
<cfparam name="attributes.datasource" default="">
<cfparam name="attributes.delTablesColumns" default="">
<cfparam name="attributes.uppercontrol" default="">
<cfparam name="attributes.column1" default="0,0,0,0,0,0,0,0,0,0,0">
<cfparam name="attributes.column2" default="0,0,0,0,0,0,0,0,0,0,0">
<cfparam name="attributes.column3" default="0,0,0,0,0,0,0,0,0,0,0">
<cfparam name="attributes.column4" default="0,0,0,0,0,0,0,0,0,0,0">
<cfparam name="attributes.column5" default="0,0,0,0,0,0,0,0,0,0,0">
<cfparam name="attributes.column6" default="0,0,0,0,0,0,0,0,0,0,0">
<cfparam name="attributes.column7" default="0,0,0,0,0,0,0,0,0,0,0">
<cfparam name="attributes.column8" default="0,0,0,0,0,0,0,0,0,0,0">
<cfparam name="attributes.column9" default="0,0,0,0,0,0,0,0,0,0,0">
<cfparam name="attributes.column10" default="0,0,0,0,0,0,0,0,0,0,0">
<cfset sayac = 0>
<cfset static_ = 0>
<cfoutput>
    <cfform  name="list_task" action="#request.self#?fuseaction=objects.emptypopup_ajax_list_task">
        <input type="hidden" name="query" id="query" value="#attributes.query#"/>
        <input type="hidden" name="datasource" id="datasource" value="#attributes.datasource#"/>
        <input type="hidden" name="userInfo" id="userInfo" value="#attributes.userInfo#"/>
        <input type="hidden" name="tableName" id="tableName" value="#attributes.tableName#"/>
        <input type="hidden" name="uppercontrol" id="uppercontrol" value="#attributes.uppercontrol#" />
		<input type="hidden" name="delTablesColumns" id="delTablesColumns" value="#attributes.delTablesColumns#" />
		<input type="hidden" name="fuseact_" id="fuseact_" value="#listfirst(caller.attributes.fuseaction,'.')#"/>
        <input type="hidden" name="column1" id="column1" value="#attributes.column1#"/>
        <input type="hidden" name="column2" id="column2" value="#attributes.column2#"/>
        <input type="hidden" name="column3" id="column3" value="#attributes.column3#"/>
        <input type="hidden" name="column4" id="column4" value="#attributes.column4#"/>
        <input type="hidden" name="column5" id="column5" value="#attributes.column5#"/>
        <input type="hidden" name="column6" id="column6" value="#attributes.column6#"/>
        <input type="hidden" name="column7" id="column7" value="#attributes.column7#"/>
        <input type="hidden" name="column8" id="column8" value="#attributes.column8#"/>
        <input type="hidden" name="column9" id="column9" value="#attributes.column9#"/>
        <input type="hidden" name="column10" id="column10" value="#attributes.column10#"/>   
    </cfform>
</cfoutput>
<table cellspacing="1" cellpadding="2" width="98%" align="center" >
    <tr>
		<td class="headbold" height="35">
			<cfoutput>
				<cfif listlen(attributes.header,':') eq 2 and listfirst(attributes.header,':') is 'd'>
                    #caller.getLang('settings',listlast(attributes.header,':'))#
				<cfelseif listlen(attributes.header,':') eq 2 and listfirst(attributes.header,':') is 'm'>
					#caller.getLang('main',listlast(attributes.header,':'))#
				<cfelse>
					#attributes.header#
				</cfif>
			</cfoutput>
		</td>
	</tr>
    <tr height="30">
    	<td>
        <cfform  name="add_task" action="#request.self#?fuseaction=objects.emptypopup_add_task" onsubmit="form_control();return false;">
        	<table cellspacing="1" cellpadding="2" class="color-border">
                <tr class="color-header" height="25">
                <cfoutput>
                    <input type="hidden" name="userInfos" id="userInfos" value="#attributes.userInfo#"/>
                    <input type="hidden" name="tableNames" id="tableNames" value="#attributes.tableName#"/>
                    <input type="hidden" name="saveForm" id="saveForm" value=""/>
                    <input type="hidden" name="datasource" id="datasource" value="#attributes.datasource#"/>
                </cfoutput>
                <cfloop from="1" to="10" index="i">
                    <cfoutput>
                    <cfif isdefined("attributes.column#i#")>
                        <cfif ListGetAt(Evaluate("attributes.column#i#"),5) eq 1 >
                            <input type="hidden" name="column#i#" id="column#i#" value="#Evaluate('attributes.column#i#')#"/>
                            <td style="color:FFFFFF" class="txtboldblue">
                                <cfset deger_ = ListGetAt(Evaluate("attributes.column#i#"),2)>
                                <cfif listlen(deger_,':') eq 2 and listfirst(deger_,':') is 'd'>
                                    #caller.getLang('settings',listlast(deger_,':'))#
                                <cfelseif listlen(deger_,':') eq 2 and listfirst(deger_,':') is 'm'>
                                    #caller.getLang('main',listlast(deger_,':'))#
                                <cfelse>
                                    #deger_#
                                </cfif>
                            </td>    
                        </cfif>
                    </cfif>
                    </cfoutput>
               </cfloop>
               <td>&nbsp;</td>
               </tr>
               <tr class="color-row">
              <cfloop from="1" to="10" index="i">
                <cfoutput>
                    <cfif isdefined("attributes.column#i#")>
                    <cfif  ListGetAt(Evaluate("attributes.column#i#"),1) eq 0>
                        <cfset sayac=sayac+1>
                    </cfif>
                        <cfif ListGetAt(Evaluate("attributes.column#i#"),5) eq 1>
                            <cfif not (IsNumeric(ListGetAt(Evaluate("attributes.column#i#"),8)))>
                                <cfscript>
                                    component_name = ListGetAt(Evaluate("attributes.column#i#"),8);
                                    CreateComponent = CreateObject("component","/../workdata/#component_name#");
                                    CreateComponent.dsn = caller.dsn;
                                    CreateComponent.dsn2 = caller.dsn2;
                                    CreateComponent.dsn3 = caller.dsn3;
                                    queryResult = CreateComponent.getComponentFunction(
                                        datasource :  '#iif(isdefined("attributes.datasource"),"attributes.datasource",DE(""))#'
                                    );
                                </cfscript>
    
                                <cfif ListGetAt(Evaluate("attributes.column#i#"),3) eq "select">
                                    <td style="color:FFFFFF">
                                    <cfselect
                                        name="task#ListGetAt(Evaluate('attributes.column#i#'),1)#" 
                                        style="width:150px;"
                                        query="queryResult"
                                        value="#ListGetAt(Evaluate("attributes.column#i#"),11)#"
                                        display="#ListGetAt(Evaluate("attributes.column#i#"),9)#"
                                        onChange="LoadAjax(1);">
                                        </cfselect>
                                    </td>
                                </cfif>
                                
                                <cfif ListGetAt(Evaluate("attributes.column#i#"),3) eq "radio">
                                    <td>
                                        <cfset columnName_ = ListGetAt(Evaluate("attributes.column#i#"),9)>
                                        <cfset columnValue_ = ListGetAt(Evaluate("attributes.column#i#"),11)>
                                        <cfset counter_=0>
                                        <cfloop query="queryResult">
                                            <cfset counter_ = counter_ + 1>
                                            <input <cfif counter_ eq 1 >checked="checked" </cfif> type="#ListGetAt(Evaluate('attributes.column#i#'),3)#" name="task#ListGetAt(Evaluate("attributes.column#i#"),1)#" id="task#ListGetAt(Evaluate("attributes.column#i#"),1)#" value="#Evaluate('queryResult.#columnValue_#')#" />#Evaluate('queryResult.#columnName_#')#
                                        </cfloop>
                                    </td>
                                </cfif>
                                <cfif ListGetAt(Evaluate("attributes.column#i#"),3) eq "checkbox">
                                    <td style="color:FFFFFF">
                                        <cfset columnName_ = ListGetAt(Evaluate("attributes.column#i#"),9)>
                                        <cfset columnValue_ = ListGetAt(Evaluate("attributes.column#i#"),11)>
                                        <cfset counter_=0>
                                        <cfloop query="queryResult">
                                            <cfset counter_ = counter_ + 1>
                                            <input <cfif counter_ eq 1 >checked="checked"</cfif> type="#ListGetAt(Evaluate('attributes.column#i#'),3)#"  name="task#ListGetAt(Evaluate("attributes.column#i#"),1)#" id="task#ListGetAt(Evaluate("attributes.column#i#"),1)#"  value="#Evaluate('queryResult.#columnValue_#')#" />#Evaluate('queryResult.#columnName_#')#
                                        </cfloop>
                                        <cfset counter_=0>
                                    </td>
                                </cfif>
                            </cfif>
                            
                            <cfif ListGetAt(Evaluate("attributes.column#i#"),3) eq "textarea">
                               <td><textarea <cfif listlen(Evaluate("attributes.column#i#")) gte 12 and ListGetAt(Evaluate("attributes.column#i#"),12) gt 0>maxlength="#ListGetAt(Evaluate('attributes.column#i#'),12)#" onkeyup="return ismaxlength(this)" onBlur="return ismaxlength(this);" message="Maksimum Karakter Sayısı : #ListGetAt(Evaluate('attributes.column#i#'),12)#"</cfif><cfif ListGetAt(Evaluate("attributes.column#i#"),6) EQ 0> readonly="readonly"</cfif> name="task#ListGetAt(Evaluate('attributes.column#i#'),1)#" style="width:150;height:20;"></textarea></td>                        	
                            <cfelseif ListGetAt(Evaluate("attributes.column#i#"),3) eq "static">
                                <td>-</td> <cfset static_ = static_ +1>
                            <cfelseif listfindnocase("hidden,integer,text",ListGetAt(Evaluate("attributes.column#i#"),3))>
                               <td> 
                               <input 
                                    <cfif ListGetAt(Evaluate("attributes.column#i#"),6) EQ 0> <cfoutput>readonly="readonly"</cfoutput></cfif> 
                                    type="text"  
                                    name="task#ListGetAt(Evaluate('attributes.column#i#'),1)#"
                                    id="task#ListGetAt(Evaluate('attributes.column#i#'),1)#" 
                                    style="width:150px;"
                                    <cfif listlen(Evaluate("attributes.column#i#")) gte 12 and ListGetAt(Evaluate("attributes.column#i#"),12) gt 0>
                                        maxlength="#ListGetAt(Evaluate('attributes.column#i#'),12)#"
                                    </cfif>
                                    <cfif listfindnocase("float0,float2,float4",ListGetAt(Evaluate("attributes.column#i#"),4))>
                                        onkeyup="return(FormatCurrency(this,event,#mid(ListGetAt(Evaluate('attributes.column#i#'),4),6,1)#));" 
                                    </cfif>
                                    <cfif listfindnocase("integer",ListGetAt(Evaluate("attributes.column#i#"),3)) or listfindnocase("integer",ListGetAt(Evaluate("attributes.column#i#"),4))>
                                        onkeyup="return(isNumber(this));" 
                                    </cfif>
                                    value="">
                                </td>    
                            </cfif>
                        </cfif>
                    </cfif>
                 </cfoutput>
               </cfloop>
                   <td align="center" width="35"><a href="##" onclick="form_control();"><img align="middle" src="/images/pod_add.gif" name="save" alt="<cfoutput>#caller.lang_array_main.item[49]#</cfoutput>" title="<cfoutput>#caller.lang_array_main.item[49]#</cfoutput>"  border="0"></a></td>
                   </tr>
                   <tr>
                        <cfset sayac = (10 - sayac) + static_>
                        <td height="25" class="color-list" colspan="<cfoutput>#sayac#"><div id="_USER_INFO_MESSAGE_"><cf_get_lang_main no="1930.İşlem Bekleniyor">!</div></cfoutput></td>
                    </tr>
                </table>               
        </cfform>
        </td>
    </tr>
    <tr>
    	<td id="SHOW_LIST_PAGE"></td>
    </tr>
</table>
<script type="text/javascript">
	var form_values =GetFormData(list_task);
	LoadAjax(0);

	function form_control()
	{
		<cfloop from="1" to="10" index="i">
			<cfoutput>
			<cfif isdefined("attributes.column#i#")>
				<cfif #ListGetAt(Evaluate("attributes.column#i#"),7)# eq 1>
					if(!form_warning('task#ListGetAt(Evaluate("attributes.column#i#"),1)#','<cf_get_lang_main no="1925.Lütfen Zorunlu Alanları Doldurun">.'))
						return false;
				</cfif>
			</cfif>
			</cfoutput>
		</cfloop>
		if(selected_ == undefined) var selected_ = 1;
		<cfloop from="1" to="10" index="i">
			<cfoutput>
			<cfif isdefined("attributes.column#i#")>
				<cfif ListGetAt(Evaluate("attributes.column#i#"),4) contains "float">
					add_task.task#ListGetAt(Evaluate("attributes.column#i#"),1)#.value = filterNum(add_task.task#ListGetAt(Evaluate("attributes.column#i#"),1)#.value);
				</cfif>
				<cfif isdefined("attributes.column#i#") and ListGetAt(Evaluate("attributes.column#i#"),3) eq "select">
					var selected_ = <cfoutput>add_task.task#ListGetAt(Evaluate("attributes.column#i#"),1)#.value;</cfoutput>
				</cfif>
			</cfif>
			</cfoutput>
		</cfloop>
		AjaxFormSubmit('add_task','_USER_INFO_MESSAGE_','1','<cf_get_lang_main no="1477.Kaydediliyor">..','<cf_get_lang_main no="1478.Kaydedildi">','<cfoutput>#request.self#?fuseaction=objects.emptypopup_ajax_list_task&keyword='+selected_+'&'+form_values+'</cfoutput>','SHOW_LIST_PAGE')
		document.add_task.reset();
	}
	
	//Ajax Yukleniyor, Ayrica Gonderilen Selected Parametresine Gore de Secilen Tipler Filtreleniyor
	function LoadAjax(x)
	{
		if(selected_ == undefined) var selected_ = 1;
		if(x == 1)
		{
			<cfloop from="1" to="10" index="i">
				<cfif isdefined("attributes.column#i#") and ListGetAt(Evaluate("attributes.column#i#"),3) eq "select">
					var selected_ = <cfoutput>add_task.task#ListGetAt(Evaluate("attributes.column#i#"),1)#.value;</cfoutput>
				</cfif>
			</cfloop>
		}
		//wrk_table_adress = "<cfoutput>#request.self#?fuseaction=#listfirst(caller.attributes.fuseaction,'.')#</cfoutput>.emptypopup_ajax_list_task&keyword="+selected_+"&"+form_values+"";
		//SHOW_LIST_PAGE.innerHTML = wrk_table_adress;
		AjaxPageLoad("<cfoutput>#request.self#?fuseaction=objects</cfoutput>.emptypopup_ajax_list_task&keyword="+selected_+"&"+form_values+"","SHOW_LIST_PAGE",1);
	}
</script>
