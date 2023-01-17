<cfparam name="attributes.keyword" default="">
<cfsetting showdebugoutput="no">
<cfquery name="get_langs" datasource="#dsn#">
	SELECT LANGUAGE_SHORT FROM SETUP_LANGUAGE WHERE LANGUAGE_SHORT <> '#lang_list#'
</cfquery>
<cfset query = URLDecode(url.query)>
<cfset userInfo = URLDecode(url.userInfo)>
<cfset datasource = URLDecode(url.datasource)>
<cfset delTablesColumns = URLDecode(url.delTablesColumns)>
<cfset column1 = URLDecode(url.column1)>
<cfset column2 = URLDecode(url.column2)>
<cfset column3 = URLDecode(url.column3)>
<cfset column4 = URLDecode(url.column4)>
<cfset column5 = URLDecode(url.column5)>
<cfset column6 = URLDecode(url.column6)>
<cfset column7 = URLDecode(url.column7)>
<cfset column8 = URLDecode(url.column8)>
<cfset column9 = URLDecode(url.column9)>
<cfset column10 = URLDecode(url.column10)>
<cfscript>
	CreateComponent = CreateObject("component","/../workdata/#query#");
	queryResult = CreateComponent.getComponentFunction(keyword:attributes.keyword);
</cfscript><title></title>
<table border="0" cellspacing="1" cellpadding="2" class="color-border">
    <tr height="20" class="color-row">
       <cfloop from="1" to="10" index="i">
            <cfoutput>
            <cfif isdefined("column#i#")>
                <cfif ListGetAt(Evaluate("column#i#"),5) eq 1>
                    <input type="hidden" name="column#i#" id="column#i#" value="#Evaluate("column#i#")#"/>
                    <td class="txtboldblue">
						<cfset deger_ = ListGetAt(Evaluate("column#i#"),2)>
						<cfif listlen(deger_,':') eq 2 and listfirst(deger_,':') is 'd'>
						  #getLang('report',listlast(deger_,':'))#
						<cfelseif listlen(deger_,':') eq 2 and listfirst(deger_,':') is 'm'>
						  #getLang('main',listlast(deger_,':'))#
						<cfelse>
							#deger_#
						</cfif>
						<cfif listfindnocase("text,textarea",ListGetAt(Evaluate("column#i#"),3)) and get_langs.recordcount>
							<cfset kolon_adi_ = ListGetAt(Evaluate("column#i#"),1)>
							<cfloop query="get_langs">
								<a href="javascript://" onclick="kolon_getir('#kolon_adi_#','#LANGUAGE_SHORT#');" class="tableyazi">#LANGUAGE_SHORT#</a>
							</cfloop>
						</cfif>
					</td>
					<cfif listfindnocase("text,textarea",ListGetAt(Evaluate("column#i#"),3)) and get_langs.recordcount>
						<cfloop query="get_langs">
						<cfset td_adi_ = 'isim_#ListGetAt(Evaluate("column#i#"),1)#_#LANGUAGE_SHORT#_baslik'>
						<td class="txtboldblue" id="#td_adi_#" name="#td_adi_#" style="display:none;">
							#LANGUAGE_SHORT#
						</td>
						</cfloop>
					</cfif>
                </cfif>
            </cfif>
            </cfoutput>
       </cfloop>
       <td class="txtboldblue" width="45"></td>
    </tr>
<cfif queryResult.recordcount>
<cfset count_ = 0>
    <cfloop query="queryResult">
	<cfset count_ = count_ + 1>
    <cfset crntr_a = count_>
    <cfform name="_form_#crntr_a#" action="#request.self#?fuseaction=settings.emptypopup_add_task" onsubmit="update_row('_form_#crntr_a#',#crntr_a#);return false;">
    <input type="hidden" name="tableNames" id="tableNames" value="<cfoutput>#attributes.tableName#</cfoutput>">
    <input type="hidden" name="datasource" id="datasource" value="<cfoutput>#listfirst(attributes.datasource)#</cfoutput>">
    <input type="hidden" name="userInfos" id="userInfos" value="<cfoutput>#attributes.userInfo#</cfoutput>">
    <input type="hidden" name="updForm" id="updForm" value="" />
    <input type="hidden" name="count" id="count" value="<cfoutput>#crntr_a#</cfoutput>" />
    <input type="hidden" name="taskId" id="taskId" value="<cfoutput>#Evaluate('queryResult.#ListGetAt(Evaluate('column1'),1)#')#</cfoutput>" />
    <input type="hidden" name="key" id="key" value="<cfoutput>#ListGetAt(Evaluate('column1'),1)#</cfoutput>" />
        <tr id="<cfoutput>_row_#crntr_a#</cfoutput>" height="20"  class="color-row">
        <cfloop from="1" to="10" index="i">
        <cfset cr2 = #currentrow#>
	        <cfoutput>
                <cfif isdefined("column#i#")>
					<cfif  ListGetAt(Evaluate("column#i#"),5) eq 1> 
	                    <input type="hidden" name="column#i#" id="column#i#" value="#Evaluate("column#i#")#"/>
						<cfif not (IsNumeric(ListGetAt(Evaluate("column#i#"),8)))> 
                            <cfscript>
                                component_name = ListGetAt(Evaluate("column#i#"),8);
                                CreateComponent = CreateObject("component","/../workdata/#component_name#");
                                queryResult2 = CreateComponent.getComponentFunction();
                            </cfscript>
                            <cfif ListGetAt(Evaluate("column#i#"),3) eq "select">
                                <td>
                                    <cfselect
                                    onfocus="javascript:this.className=''" 
                                    onchange="javascript:_row_#crntr_a#.className='color-light'"  
                                    onblur="javascript:this.className='boxtext'"
                                    style="width:200px;"
                                    class="boxtext"
                                    name="input#crntr_a#task#ListGetAt(Evaluate('column#i#'),1)#" 
                                    query="queryResult2"
                                    selected="#Evaluate('queryResult.#ListGetAt(Evaluate('column#i#'),1)#')#"
                                    value="#ListGetAt(Evaluate("column#i#"),11)#"
                                    display="#ListGetAt(Evaluate("column#i#"),9)#" >
                                    </cfselect>
                                </td>
                            </cfif>                              
                            <cfif ListGetAt(Evaluate("column#i#"),3) eq "radio">
                                <td>
                                	<cfset columnName_ = ListGetAt(Evaluate("column#i#"),9) >
                                    <cfset columnValue_ = ListGetAt(Evaluate("column#i#"),11) >
                                    <cfset counter_=0>
                                	<cfloop query="queryResult2">
                                    	<cfset counter_ = counter_ + 1>
                                        <input 
                                        onfocus="javascript:this.className=''" 
                                        onchange="javascript:_row_#crntr_a#.className='color-light'"  
                                        onblur="javascript:this.className='boxtext'"
                                        class="boxtext"
										<cfif #Evaluate('queryResult2.#columnValue_#')# eq #Evaluate('queryResult.#columnValue_#')# >checked="checked" </cfif> 
                                        type="radio"   
                                        name="input#crntr_a#task#ListGetAt(Evaluate('column#i#'),1)#" 
                                        id="input#crntr_a#task#ListGetAt(Evaluate('column#i#'),1)#" 
                                        value="#Evaluate('queryResult2.#columnValue_#')#" />#Evaluate('queryResult2.#columnName_#')#
                                    </cfloop>
                                </td>
                            </cfif>
                            
                            <cfif ListGetAt(Evaluate("column#i#"),3) eq "checkbox">
                                <td align="center">
                                	<cfset columnName_ = ListGetAt(Evaluate("column#i#"),9) >
                                    <cfset columnValue_ = ListGetAt(Evaluate("column#i#"),11) >
                                    <cfset counter_=0>
                                	<cfloop query="queryResult2">
                                    	<cfset counter_ = counter_ + 1>
                                        <input 
                                        onfocus="javascript:this.className=''" 
                                        onchange="javascript:_row_#crntr_a#.className='color-light'"  
                                        onblur="javascript:this.className='boxtext'"
                                        class="boxtext" #Evaluate('queryResult.#columnValue_#')#
										<cfif ListFind(#Evaluate('queryResult.#columnValue_#')#,#Evaluate('queryResult2.#columnValue_#')#)>checked="checked"</cfif> 
                                        type="checkbox"   
                                        name="c#crntr_a#task#ListGetAt(Evaluate('column#i#'),1)#"
                                        id="c#crntr_a#task#ListGetAt(Evaluate('column#i#'),1)#"  
                                        value="#Evaluate('queryResult2.#columnValue_#')#" />#Evaluate('queryResult2.#columnName_#')#
                                    </cfloop>
                                    <cfset counter_=0>
                                </td>
                            </cfif>
                        </cfif>
						<cfif ListGetAt(Evaluate("column#i#"),3) eq "textarea">
                           <td>
                           <textarea onfocus="javascript:this.className=''" 
                           onchange="javascript:_row_#crntr_a#.className='color-light'"  
                           onblur="javascript:this.className='boxtext'"
                           <cfif listlen(Evaluate("column#i#")) gte 12 and ListGetAt(Evaluate("column#i#"),12) gt 0>
							   maxlength="#ListGetAt(Evaluate('column#i#'),12)#" 
							   onkeyup="return ismaxlength(this)" 
							   onBlur="return ismaxlength(this);" 
							   message="Maksimum Karakter Sayısı : #ListGetAt(Evaluate('column#i#'),12)#"
						   </cfif>
						   class="boxtext"
                           name="input#crntr_a#task#ListGetAt(Evaluate('column#i#'),1)#" 
                           id="input#crntr_a#task#ListGetAt(Evaluate('column#i#'),1)#" 
                           style="width:150;height:20;">#Evaluate('queryResult.#ListGetAt(Evaluate('column#i#'),1)#')#</textarea>
						   </td>
						 <cfif get_langs.recordcount>  
						  <cfloop query="get_langs">
						  	<cfset taskid = Evaluate('queryResult.#ListGetAt(Evaluate('column1'),1)#')>			
							<cfset columnValue = #getData('#attributes.tableName#','#ListGetAt(Evaluate("column#i#"),1)#','#LANGUAGE_SHORT#','#taskid#')#>
							<cfset td_adi_ = 'isim_#ListGetAt(Evaluate("column#i#"),1)#_#LANGUAGE_SHORT#_#count_#'>
						   <td id="#td_adi_#" name="#td_adi_#" style="display:none;">
						   <textarea onfocus="javascript:this.className=''" 						  
                           onchange="javascript:_row_#crntr_a#.className='color-light'"  
                           onblur="javascript:this.className='boxtext'"
                           <cfif listlen(Evaluate("column#i#")) gte 12 and ListGetAt(Evaluate("column#i#"),12) gt 0>
							   maxlength="#ListGetAt(Evaluate('column#i#'),12)#" 
							   onkeyup="return ismaxlength(this)" 
							   onBlur="return ismaxlength(this);" 
							   message="Maksimum Karakter Sayısı : #ListGetAt(Evaluate('column#i#'),12)#"
						   </cfif>
						   class="boxtext"
                           name="input#crntr_a#task#ListGetAt(Evaluate('column#i#'),1)#_#LANGUAGE_SHORT#" 
                           id="input#crntr_a#task#ListGetAt(Evaluate('column#i#'),1)#_#LANGUAGE_SHORT#" 
                           style="width:150px;height:20px;">#columnValue#</textarea>
						   </td>
						   </cfloop>
						</cfif>
                        <cfelseif ListGetAt(Evaluate("column#i#"),3) eq "static">
                        	<td>#Evaluate('queryResult.#ListGetAt(Evaluate('column#i#'),1)#')#</td>                       	
                        <cfelseif listfindnocase("hidden,integer,text",ListGetAt(Evaluate("column#i#"),3))>
	                   	   <td><input 
                           onfocus="javascript:this.className=''" 
                           onchange="javascript:_row_#crntr_a#.className='color-light'"  
                           onblur="javascript:this.className='boxtext'" 
                           class="boxtext"
                           <cfif listlen(Evaluate("column#i#")) gte 12 and ListGetAt(Evaluate("column#i#"),12) gt 0>
								maxlength="#ListGetAt(Evaluate('column#i#'),12)#"
							</cfif>
						   <cfif ListGetAt(Evaluate("column#i#"),6) eq 0> readonly</cfif> 
                           type="#ListGetAt(Evaluate('column#i#'),3)#"
						   <cfif listfindnocase("float0,float2,float4",ListGetAt(Evaluate("column#i#"),4))>
						   		onkeyup="return(FormatCurrency(this,event,#mid(ListGetAt(Evaluate('column#i#'),4),6,1)#));"
						  	 	value="#tlformat(Evaluate('queryResult.#ListGetAt(Evaluate('column#i#'),1)#'),mid(ListGetAt(Evaluate('column#i#'),4),6,1))#" 
						   <cfelseif listfindnocase("integer",ListGetAt(Evaluate("column#i#"),3)) or listfindnocase("integer",ListGetAt(Evaluate("column#i#"),4))>
						   		onkeyup="return(isNumber(this));"
								value="#Evaluate('queryResult.#ListGetAt(Evaluate('column#i#'),1)#')#" 
						   <cfelse>						   
						   		value="#Evaluate('queryResult.#ListGetAt(Evaluate('column#i#'),1)#')#" 
						   </cfif>
                           name="input#crntr_a#task#ListGetAt(Evaluate('column#i#'),1)#" id="input#crntr_a#task#ListGetAt(Evaluate('column#i#'),1)#" style="width:150;" value=""></td> 
						   <cfif get_langs.recordcount and listfindnocase("text",ListGetAt(Evaluate("column#i#"),3))>  
							  <cfloop query="get_langs">
								<cfset td_adi_ = 'isim_#ListGetAt(Evaluate("column#i#"),1)#_#LANGUAGE_SHORT#_#count_#'>
							  	<cfset taskid = Evaluate('queryResult.#ListGetAt(Evaluate('column1'),1)#')>			
								<cfset columnValue = #getData('#attributes.tableName#','#ListGetAt(Evaluate("column#i#"),1)#','#LANGUAGE_SHORT#','#taskid#')#>		
							   <td id="#td_adi_#" name="#td_adi_#" style="display:none;">
							   <input 
							   onfocus="javascript:this.className=''" 
							   onchange="javascript:_row_#crntr_a#.className='color-light'"  
							   onblur="javascript:this.className='boxtext'" 
							   class="boxtext"
							   <cfif listlen(Evaluate("column#i#")) gte 12 and ListGetAt(Evaluate("column#i#"),12) gt 0>
									maxlength="#ListGetAt(Evaluate('column#i#'),12)#"
								</cfif>
							   <cfif ListGetAt(Evaluate("column#i#"),6) eq 0> readonly</cfif> 
							   type="#ListGetAt(Evaluate('column#i#'),3)#"
							   value="#columnValue#" 
							   name="input#crntr_a#task#ListGetAt(Evaluate('column#i#'),1)#_#LANGUAGE_SHORT#" style="width:150;" value="">
							   </td>
							   </cfloop>
							</cfif>   
                        </cfif>
                    </cfif>
                </cfif>
             </cfoutput>
	       </cfloop>
              <td nowrap>
				<cfoutput>
					<!--- İlgili Kategori Kullanılmışsa Delete Butonunun Kullanılmasını Engeller --->
					<cfset DelFlag = 0>
					<cfif isDefined('delTablesColumns') and len(delTablesColumns)>
						<cfloop list="#delTablesColumns#" index="dct">
							<cfset delTables = ListFirst(dct,';')>
							<cfset delColumns = ListLast(dct,';')>
							<cfquery name="get_related" datasource="#dsn#">
								SELECT TOP 1 #delColumns# FROM #delTables# WHERE #delColumns# = #Evaluate('queryResult.#ListGetAt(Evaluate('column1'),1)#')#
							</cfquery>
							<cfif get_related.recordcount><cfset DelFlag = 1></cfif>
						</cfloop>
					</cfif>
					<!--- // İlgili Kategori Kullanılmışsa Delete Butonunun Kullanılmasını Engeller --->
					<cfif DelFlag eq 0>
						<img src="/images/pod_delete_list.gif"
						width="15" style="cursor:pointer;" align="left"
						onClick="delete_row(<cfoutput>#crntr_a#,#Evaluate('queryResult.#ListGetAt(Evaluate('column1'),1)#')#,'#ListGetAt(Evaluate('column1'),1)#'</cfoutput>);" 
						alt="<cf_get_lang_main no='51.Sil'>">
					</cfif>
					<img src="/images/pod_update_list.gif"
					width="15" style="cursor:pointer;" align="right" 
					onmouseup="javascript:_row_#crntr_a#.className='color-row'" onClick="update_row('_form_#crntr_a#',#crntr_a#)"
					alt="<cf_get_lang_main no='52.Güncelle'>">
                </cfoutput>
			</td>
        </tr>
        </cfform>
    </cfloop>
<cfelse>
    <tr class="color-list">
        <td height="20" colspan="10"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
    </tr>
</cfif>
</table>
<script type="text/javascript">
	function delete_row(row,id,key)
	{
		if(confirm('<cf_get_lang_main no="121.Silmek İstediğinizden Emin Misiniz ?">'))
		{
			document.getElementById('_row_'+row).style.display ='none';
			AjaxPageLoad("<cfoutput>#request.self#</cfoutput>?fuseaction=settings.emptypopup_add_task&key="+key+"&datasource=<cfoutput>#listfirst(attributes.datasource)#</cfoutput>&tableName=<cfoutput>#attributes.tableName#</cfoutput>&is_delete="+id,"_USER_INFO_MESSAGE_",1,"Siliniyor!");
		}
		document.getElementById('_USER_INFO_MESSAGE_').innerHTML ='Silindi!';
	}
	function update_row(formId,satirid)
	{
		<cfoutput>
			<cfloop from="1" to="10" index="i">
				<cfif isdefined("column#i#")>
					<cfif ListGetAt(Evaluate("column#i#"),7) EQ 1>
						if(!form_warning('input'+satirid+'task#ListGetAt(Evaluate("column#i#"),1)#','Lütfen Zorunlu Alanları Doldurun.'))
							return false;
					</cfif>
				</cfif>
			</cfloop>
		</cfoutput>
		<cfoutput>
			<cfloop from="1" to="10" index="i">
				<cfif isdefined("column#i#")>
					<cfif ListGetAt(Evaluate("column#i#"),4) contains "float">
						eval(formId+'.input'+satirid+'task#ListGetAt(Evaluate("column#i#"),1)#').value = filterNum(eval(formId+'.input'+satirid+'task#ListGetAt(Evaluate("column#i#"),1)#').value);
					</cfif>
				</cfif>
			</cfloop>
		</cfoutput>
		//alert(decodeURIComponent(GetFormData(document.getElementById(formId))));
		//return;
		//_form_1.submit();
		AjaxFormSubmit(formId,'_USER_INFO_MESSAGE_','1','Güncelleniyor..','Güncellendi');
		<cfoutput>
			<cfloop from="1" to="10" index="i">
				<cfif isdefined("column#i#")>
					<cfif ListGetAt(Evaluate("column#i#"),4) contains "float">
						eval(formId+'.input'+satirid+'task#ListGetAt(Evaluate("column#i#"),1)#').value = commaSplit(eval(formId+'.input'+satirid+'task#ListGetAt(Evaluate("column#i#"),1)#').value,#mid(ListGetAt(Evaluate('column#i#'),4),6,1)#);
					</cfif>
				</cfif>
			</cfloop>
		</cfoutput>
	}
function kolon_getir(name,language_name)
{
	baslik_ = document.getElementById('isim_' + name + '_' + language_name + '_baslik');
	
	if(baslik_.style.display=='')
		{
			baslik_.style.display='none';
		} 
		else 
		{
			baslik_.style.display='';
		}
	<cfoutput query="queryResult">
	baslik_ = document.getElementById('isim_' + name + '_' + language_name + '_#currentrow#');
	if(baslik_.style.display=='')
		{
			baslik_.style.display='none';
		} 
		else 
		{
			baslik_.style.display='';
		}
	</cfoutput>
}
</script>

<cffunction name="getData" returntype="string">
	<cfargument name="tableName" required="yes">
	<cfargument name="columnName" required="yes">
	<cfargument name="lang" required="yes">
	<cfargument name="unique_id" required="yes" type="numeric">
	<cfquery name="_GET" datasource="#dsn#">
		SELECT
			ITEM
		FROM
			SETUP_LANGUAGE_INFO_SETTINGS
		WHERE
			COMPANY_ID = #session.ep.company_id# AND
            PERIOD_ID = #session.ep.period_id# AND
            TABLE_NAME = '#tableName#' AND
			COLUMN_NAME = '#columnName#' AND
			LANGUAGE = '#lang#' AND
			UNIQUE_COLUMN_ID= #unique_id#
	</cfquery>
	<cfreturn #_GET.ITEM#>
</cffunction>
