<cfsetting showdebugoutput="yes">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.author_emp_id" default="">
<cfparam name="attributes.base" default="">
<cfparam name="attributes.query_order" default="">
<cfparam name="attributes.modul" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.is_active" default=1>
<cfparam name="attributes.wbo_types" default="">
<cfparam name="attributes.is_special" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>

<cfquery name="GET_MODULES" datasource="#DSN#">
	SELECT MODULE_NAME,MODULE_SHORT_NAME FROM MODULES WHERE MODULE_SHORT_NAME IS NOT NULL ORDER BY MODULE_NAME
</cfquery>
<!--- Sayfa Tipleri tanimlaniyor --->
<!--- Isme gore siralandi sira degistirilmesin --->
<cfset list_wbo = createObject("component", "development.cfc.list_wbo")>
<cfset WBO_TYPES = list_wbo.getWboList()>

<cfset item_count = 0>
<cfif isdefined("attributes.is_submitted")>
	<cfquery name="GET_WBO" datasource="#DSN#">
		SELECT 
			WRK_OBJECTS_ID,
			FUSEACTION,
			BASE,
			STATUS,
			MODUL,			
			AUTHOR,
			STAGE,
			MODUL_SHORT_NAME,
			HEAD,
			TYPE,IS_ACTIVE,
			FOLDER,
			FILE_NAME,
            RELATED_FUSEACTION,
            IS_ADD,
            IS_DELETE,
            IS_UPDATE,
            OBJECTS_COUNT
		FROM
			WRK_OBJECTS
		WHERE 
			RELATED_FUSEACTION IS NULL 
			<cfif len(attributes.keyword)>
				AND 
				(
					FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                    HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					(MODUL_SHORT_NAME+'.'+ FUSEACTION) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
				<cfif isnumeric(attributes.keyword)>
                    OR WRK_OBJECTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.keyword#">
                </cfif>
				)
			</cfif>
			<cfif isdefined("attributes.author_emp_id") and len(attributes.author_emp_id)>
				AND AUTHOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.author_emp_id#">
			</cfif>
			<cfif isdefined("attributes.base") and len(attributes.base)>
				AND BASE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.base#">
			</cfif>
			<cfif isdefined("attributes.modul") and len(attributes.modul)>
				AND MODUL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.modul#">
			</cfif>
			<cfif isdefined("attributes.status") and len(attributes.status)>
				AND STATUS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.status#">
			</cfif>
			<cfif len(attributes.is_active)>
				AND IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_active#">
			</cfif>
            <cfif isdefined("attributes.wbo_empty")>
            	AND WRK_OBJECTS.TYPE IS NULL
            </cfif>
            <cfif len(attributes.wbo_types) and not isdefined("attributes.wbo_empty")>
				AND(
				<cfloop list="#attributes.wbo_types#" index="k">
	                <cfset ++item_count>
                    (WRK_OBJECTS.TYPE = #left(k,1)#
                    <cfif k eq '10' or k eq '20'>
                        AND WRK_OBJECTS.IS_ADD = 1    
                    <cfelseif k eq '11' or  k eq '21'>
                        AND WRK_OBJECTS.IS_UPDATE = 1
                    <cfelseif k eq '22'>
                        AND WRK_OBJECTS.IS_DELETE = 1
                    </cfif>)
                    <cfif item_count neq listlen(attributes.wbo_types)>
                    OR
                    </cfif>
                </cfloop>
                )
            </cfif>
            <cfif len(attributes.is_special)>
            	<cfif attributes.is_special eq 0 or attributes.is_special eq 1>
                	AND WRK_OBJECTS.IS_SPECIAL = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_special#">
                </cfif>
            </cfif>
		UNION
		<cfset item_count = 0>
		SELECT 
			WRK_OBJECTS2.WRK_OBJECTS_ID,
			WRK_OBJECTS2.FUSEACTION,
			WRK_OBJECTS2.BASE,
			WRK_OBJECTS2.STATUS,
			WRK_OBJECTS2.MODUL,			
			WRK_OBJECTS2.AUTHOR,
			WRK_OBJECTS2.STAGE,
			WRK_OBJECTS2.MODUL_SHORT_NAME,
			WRK_OBJECTS2.HEAD,
			WRK_OBJECTS2.TYPE,
			WRK_OBJECTS2.IS_ACTIVE,
			WRK_OBJECTS2.FOLDER,
			WRK_OBJECTS2.FILE_NAME,
            WRK_OBJECTS2.RELATED_FUSEACTION,
            WRK_OBJECTS2.IS_ADD,
            WRK_OBJECTS2.IS_DELETE,
            WRK_OBJECTS2.IS_UPDATE,
            WRK_OBJECTS2.OBJECTS_COUNT
		FROM
			WRK_OBJECTS,
			WRK_OBJECTS WRK_OBJECTS2
		WHERE 
			WRK_OBJECTS.RELATED_MODUL_SHORT_NAME = 	WRK_OBJECTS2.MODUL_SHORT_NAME AND 
			WRK_OBJECTS.RELATED_FUSEACTION = WRK_OBJECTS2.FUSEACTION  
			<cfif len(attributes.keyword)>		
				AND 
				(
					WRK_OBJECTS.FUSEACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR 
					WRK_OBJECTS.FILE_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
                    WRK_OBJECTS.HEAD LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
					(WRK_OBJECTS.MODUL_SHORT_NAME+'.'+ WRK_OBJECTS.FUSEACTION) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#">
                    <cfif isnumeric(attributes.keyword)>
                    OR WRK_OBJECTS.WRK_OBJECTS_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.keyword#">
                    </cfif>
				)
			</cfif>
			<cfif isdefined("attributes.author_emp_id") and len(attributes.author_emp_id)>
				AND WRK_OBJECTS.AUTHOR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.author_emp_id#">
			</cfif>
			<cfif isdefined("attributes.base") and len(attributes.base)>
				AND WRK_OBJECTS.BASE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.base#">
			</cfif>
			<cfif isdefined("attributes.modul") and len(attributes.modul)>
				AND WRK_OBJECTS.MODUL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.modul#">
			</cfif>
			<cfif isdefined("attributes.status") and len(attributes.status)>
				AND WRK_OBJECTS.STATUS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.status#">
			</cfif>
			<cfif len(attributes.is_active)>
				AND WRK_OBJECTS.IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_active#">
			</cfif>
            <cfif isdefined("attributes.wbo_empty")>
            	AND WRK_OBJECTS.TYPE IS NULL
            </cfif>
            <cfif len(attributes.wbo_types) and not isdefined("attributes.wbo_empty")>
				AND (
				<cfloop list="#attributes.wbo_types#" index="k">
	                <cfset ++item_count>
                    (WRK_OBJECTS.TYPE = #left(k,1)#
                    <cfif k eq '10' or k eq '20'>
                        AND WRK_OBJECTS.IS_ADD = 1    
                    <cfelseif k eq '11' or  k eq '21'>
                        AND WRK_OBJECTS.IS_UPDATE = 1
                    <cfelseif k eq '22'>
                        AND WRK_OBJECTS.IS_DELETE = 1
                    </cfif>)
                    <cfif item_count neq listlen(attributes.wbo_types)>
                    OR
                    </cfif>
                </cfloop>
                )
            </cfif>
            <cfif len(attributes.is_special)>
            	<cfif attributes.is_special eq 0 or attributes.is_special eq 1>
                	AND WRK_OBJECTS.IS_SPECIAL = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.is_special#">
                </cfif>
            </cfif>
			ORDER BY
			<cfif attributes.query_order eq 1>
				OBJECTS_COUNT DESC			
			<cfelse>
				MODUL,
				FUSEACTION
			</cfif>
	</cfquery>
<cfelse>
	<cfset get_wbo.recordcount=0>
</cfif>
<cfif get_wbo.recordcount>
	<cfset author_id_list =''>
    <cfset module_list =''>
	<cfoutput query="get_wbo">
		<cfif len(author) and not listfind(author_id_list,author)>
			<cfset author_id_list = listappend(author_id_list,AUTHOR,',')>
		</cfif>
		<cfif len(modul_short_name) and not listfind(module_list,modul_short_name)>
			<cfset module_list = listappend(module_list,modul_short_name,',')>
		</cfif>        
	</cfoutput>
	<cfif len(author_id_list)>
		<cfset author_id_list=listsort(author_id_list,"numeric","ASC",",")>
		<cfquery name="GET_AUTHORS" datasource="#DSN#">
			SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS NAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#author_id_list#)
		</cfquery>
	</cfif>
	<cfif len(module_list)>
        <cfquery name="GET_FOLDER" datasource="#DSN#">
            SELECT FOLDER FROM MODULES WHERE MODULE_SHORT_NAME IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#module_list#" list="yes">) ORDER BY MODULE_SHORT_NAME
        </cfquery>
	</cfif>
</cfif>    

<cfparam name="attributes.totalrecords" default="#get_wbo.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfform name="wbo_list" action="#request.self#?fuseaction=dev.list_wbo" method="post">
<cf_big_list_search>
    <cf_big_list_search_area>
        <input type="hidden" name="is_submitted" id="is_submitted" value="1" />
        <table style="text-align:right;">
            <td><cf_get_lang_main no='48.Filtre'>:</td>
            <td><input type="text" name="keyword" id="keyword" style="width:100px;" value="<cfoutput>#attributes.keyword#</cfoutput>" maxlength="255"></td>
            <td>
                <select name="status" id="status" style="width:100px;">
                    <option value="">Status</option>
                    <option value="Analys" <cfif attributes.status eq "Analys"> selected="selected"</cfif>><cf_get_lang no="237.Analys"></option>
                    <option value="Design" <cfif attributes.status eq "Design"> selected="selected"</cfif>><cf_get_lang no="238.Design"></option>
                    <option value="Development" <cfif attributes.status eq "Development"> selected="selected"</cfif>><cf_get_lang no="239.Development"></option>
                    <option value="Testing" <cfif attributes.status eq "Testing"> selected="selected"</cfif>><cf_get_lang no="240.Testing"></option>
                    <option value="Deployment" <cfif attributes.status eq "Deployment"> selected="selected"</cfif>><cf_get_lang no="241.Deployment"></option>
                </select>
            </td>
            
            <td><input type="checkbox" name="wbo_empty" id="wbo_empty" value="1" <cfif isdefined("attributes.wbo_empty")>checked="checked"</cfif>/><cf_get_lang no="213.Type Değeri Şeçili Olmayan Sayfalar"></td>
            <td>
                <select name="is_active" id="is_active" style="width:100px;">
                    <option value="" <cfif attributes.is_active eq "">selected="selected"</cfif>><cf_get_lang no="212.All"></option>
                    <option value="1" <cfif attributes.is_active eq 1>selected="selected"</cfif>><cf_get_lang no="169.Active"></option>
                    <option value="0" <cfif attributes.is_active eq 0>selected="selected"</cfif>><cf_get_lang no="155.Passive"></option>
                </select>
            </td>
            <td>
                <select name="is_special" id="is_special"  style="width:100px;">
                    <option value="" <cfif attributes.is_special eq "">selected="selected"</cfif>><cf_get_lang_main no="669.Hepsi"></option>
                    <option value="1" <cfif attributes.is_special eq 1>selected="selected"</cfif>><cf_get_lang no="233.Sisteme Özel"></option>
                    <option value="0" <cfif attributes.is_special eq 0>selected="selected"</cfif>><cf_get_lang no="234.Sisteme Özel Değil"></option>
                    <option value="2" <cfif attributes.is_special eq 2>selected="selected"</cfif>><cf_get_lang no="235.Obje Yetkilendirme Seçilenler"></option>
                    <option value="3" <cfif attributes.is_special eq 3>selected="selected"</cfif>><cf_get_lang no="236.Obje Yetkilendirme Seçilmeyenler"></option>
                </select>
            </td>                
            <td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
            </td>
            <td><cf_wrk_search_button is_excel="1"></td>
            <td><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></td>
        </table>
    </cf_big_list_search_area>
    <cf_big_list_search_detail_area>
        <table style="text-align:right;">
            <tr>
                <td>
                    <cf_multiselect_check 
                        query_name="WBO_TYPES"  
                        name="wbo_types"
                        width="135" 
                        option_value="TYPE_ID"
                        option_name="TYPE_NAME"
                        value="#attributes.wbo_types#">
                </td>
                <td align="left"><cf_get_lang no="78.Author"></td>
                <td>
                    <input type="hidden" name="author_emp_id" id="author_emp_id" value="">
                    <cfinput type="text" name="author_name" id="author_name" value="" onFocus="AutoComplete_Create('author_name','MEMBER_NAME,MEMBER_PARTNER_NAME2','MEMBER_PARTNER_NAME2,MEMBER_NAME2','get_member_autocomplete','\'1,3\',0,0','EMPLOYEE_ID','author_emp_id','','3','200');" style="width:150px;">
                    <a href="javascript://" onclick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_positions&field_emp_id=wbo_list.author_emp_id&field_name=wbo_list.author_name&select_list=1</cfoutput>','list');"><img src="/images/plus_thin.gif" alt="Author"  align="absmiddle" border="0"></a>
                </td>
                <td>
                    <select name="modul" id="modul" style="width:130px;">
                        <option value=""><cf_get_lang no="44.Modul"></option>
                        <cfoutput query="get_modules">
                        <option value="#module_name#"<cfif attributes.modul eq module_name>selected</cfif>>#module_name#</option>
                        </cfoutput>
                        <option value="Flex" <cfif 'Flex' eq attributes.modul>selected</cfif>><cf_get_lang no="171.Flex"></option> 
                        <option value="Home" <cfif 'Home' eq attributes.modul>selected</cfif>><cf_get_lang no="173.Home"></option> 
                        <option value="Myhome" <cfif 'Myhome' eq attributes.modul>selected</cfif>><cf_get_lang no="176.My Home"></option>
                        <option value="Objects2" <cfif 'Objects2' eq attributes.modul>selected</cfif>><cf_get_lang_main no="486.Objects"> 2</option> 
                        <option value="PDA" <cfif 'PDA' eq attributes.modul>selected</cfif>><cf_get_lang no="178.PDA"></option> 
                        <option value="Schedules" <cfif 'Schedules' eq attributes.modul>selected</cfif>><cf_get_lang no="189.Schedules"></option>
                        <option value="Test" <cfif 'Test' eq attributes.modul>selected</cfif>><cf_get_lang_main no="1414.Test"></option>
                        <option value="Webhaber" <cfif 'Webhaber' eq attributes.modul>selected</cfif>><cf_get_lang no="210.Web Haber"></option>
                    </select>
                </td>
                <td width="100">
                    <select name="base" id="base" style="width:100px;">
                        <option value=""><cf_get_lang no="50.Base"></option>
                        <option value="Intranet"<cfif isdefined("attributes.base") and attributes.base eq 'Intranet'>selected</cfif>><cf_get_lang_main no="1862.Intranet"></option>
                        <option value="ERP"<cfif isdefined("attributes.base") and attributes.base eq 'ERP'>selected</cfif>><cf_get_lang_main no="1860.ERP"></option>
                        <option value="CRM"<cfif isdefined("attributes.base") and attributes.base eq 'CRM'>selected</cfif>><cf_get_lang_main no="374.CRM"></option>
                        <option value="PMS"<cfif isdefined("attributes.base") and attributes.base eq 'PMS'>selected</cfif>><cf_get_lang_main no="1861.PMS"></option>
                        <option value="Service"<cfif isdefined("attributes.base") and attributes.base eq 'Service'>selected</cfif>><cf_get_lang no="105.Service"></option>
                        <option value="PAM"<cfif isdefined("attributes.base") and attributes.base eq 'PAM'>selected</cfif>><cf_get_lang_main no="1863.PAM"></option>
                        <option value="Store"<cfif isdefined("attributes.base") and attributes.base eq 'Store'>selected</cfif>><cf_get_lang no="96.Store"></option>
                        <option value="HR"<cfif isdefined("attributes.base") and attributes.base eq 'HR'>selected</cfif>><cf_get_lang_main no="1864.HR"></option>
                        <option value="CMS"<cfif isdefined("attributes.base") and attributes.base eq 'CMS'>selected</cfif>><cf_get_lang_main no="1866.CMS"></option>
                        <option value="Communication"<cfif isdefined("attributes.base") and attributes.base eq 'Communication'>selected</cfif>><cf_get_lang no="109.Communication"></option>
                        <option value="Report"<cfif isdefined("attributes.base") and attributes.base eq 'Report'>selected</cfif>><cf_get_lang no="9.Report"></option>
                        <option value="Systems"<cfif isdefined("attributes.base") and attributes.base eq 'Systems'>selected</cfif>><cf_get_lang no="62.Systems"></option>
                        <option value="Cube TV"<cfif isdefined("attributes.base") and attributes.base eq 'Cube TV'>selected</cfif>><cf_get_lang no="107.Cube TV"></option>
                        <option value="Other"<cfif isdefined("attributes.base") and attributes.base eq 'Other'>selected</cfif>><cf_get_lang no="57.Other"></option>
                    </select>
                </td>
                <td>
                    <select name="query_order" id="query_order" style="width:100px;">
                        <option value=""><cf_get_lang no="56.Sıralama Şekli"></option>
                        <option value="1" <cfif isdefined("attributes.query_order") and attributes.query_order eq 1>selected</cfif>><cf_get_lang no="54.En Çok Çağrılan"></option>
                    </select>
                </td>
            </tr>
        </table>
    </cf_big_list_search_detail_area>
</cf_big_list_search>
<cf_big_list>
		<thead>
            <tr>
                <th width="15"><cf_get_lang_main no="1165.Sıra"></th>
                <th width="30"><cf_get_lang no="47.Count"></th>
                <th><cf_get_lang no="50.Base"></th>
                <th><cf_get_lang no="44.Modul"></th>
                <th width="30"><cf_get_lang_main no="1115.ID"></th>
                <th><cf_get_lang no="4.Fuseaction"></th>
                <th><cf_get_lang no="126.Head"></th>
                <th><cf_get_lang no="30.Type"></th>
                <th><cf_get_lang no="43.Status"></th>
                <th style="width:130px;"><cf_get_lang no="78.Author"></th>
                <th style="width:50px;">&nbsp;</th>
                <th></th>
                <th style="width:15px;">&nbsp;</th>
                <!-- sil --><th style="width:15px;"><a href="<cfoutput>#request.self#?fuseaction=dev.list_wbo&event=add</cfoutput>"><img src="/images/plus_list.gif" alt="" border="0"></a></th><!-- sil -->
            </tr>
        </thead>
        <cfif get_wbo.recordcount>
			<cfoutput query="get_wbo" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tbody>
                    <tr>
                        <td>#currentrow#</td>
                        <td>#objects_count#</td>
                        <td>#base#</td>
                        <td>#modul#</td>
                        <td>#wrk_objects_id#</td>
                        <td><a href="#Evaluate(DE('#updPage#'))#" class="tableyazi">#fuseaction#</a></td>
                        <td>#head#</td>
                        <td>
                            <cfif listfind(type,'1')> <cfif is_update eq 1><cf_get_lang_main no="1967.Form"> <cf_get_lang no="134.Update"><br /></cfif><cfif is_add eq 1><cf_get_lang no="115.Form Add"><br /></cfif>
                            <cfelseif listfind(type,'2')><cfif is_add eq 1><cf_get_lang no="118.Query Add"> </cfif><cfif is_update eq 1><cf_get_lang no="120.Query Update"> </cfif><cfif is_delete eq 1><cf_get_lang no="136.Query Delete"> </cfif><br />
                            <cfelseif listfind(type,'3')><cf_get_lang no="45.Detail"><br />
                            <cfelseif listfind(type,'4')><cf_get_lang no="138.List"><br />
                            <cfelseif listfind(type,'5')><cf_get_lang no="139.Ajax List"><br />
                            <cfelseif listfind(type,'6')><cf_get_lang no="9.Report"><br />
                            <cfelseif listfind(type,'7')><cf_get_lang no="142.Menu"><br />
                            <cfelseif listfind(type,'8')><cf_get_lang no="143.Function"><br />
                            <cfelseif listfind(type,'9')><cf_get_lang no="149.Display"><br />
                            </cfif>
                        </td>
                        <td>#status#</td>
                        <td>#get_authors.name[listfind(author_id_list,AUTHOR,',')]#</td>
                        <td><cfif get_wbo.is_active eq 0><cf_get_lang no="155.Passive"><cfelse><cf_get_lang no="169.Active"></cfif></td>
                        <td>
                            <cfif type neq 'query'>
                                <!-- sil --><a href="#request.self#?fuseaction=#modul_short_name#.#fuseaction#"><img src="../images/devam.gif" alt="Sayfaya Git" align="absmiddle" border="0" title="Sayfaya Git"></a><!-- sil -->
                            </cfif>
                        </td>
                        <td align="center">
							<cfif modul_short_name eq 'pda'>
                                <cfset get_folder.modul_short_name = 'workcube_pda'>
                            </cfif>
	                        <!-- sil --><a href="file://#index_folder##get_folder.folder[listfind(module_list,modul_short_name,',')]#/#folder#/#file_name#"><img src="../images/topdoc.gif" alt="Open File in Editor"  align="absmiddle" border="0" title="Open File in Editor"></a><!-- sil -->
                        </td>
                        <!-- sil --><td><a href="#Evaluate(DE('#updPage#'))#"><img src="/images/update_list.gif"  alt="Güncelle" border="0"></a></td><!-- sil -->
                    </tr>
                </tbody>
            </cfoutput>
        <cfelse>
        	<td colspan="14" class="color-row"><cfif isdefined("attributes.is_submitted")><cf_get_lang_main no="72.Kayıt Yok"> !<cfelse><cf_get_lang_main no="289.Filtre Ediniz"> !</cfif></td>
        </cfif>  
    </cf_big_list>
</cfform>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset adres = "">
	<cfif isdefined('attributes.is_submitted')>
		<cfset adres = "#adres#&is_submitted=1">
	</cfif>
	<cfif len(attributes.keyword)>
		<cfset adres = "#adres#&keyword=#attributes.keyword#"> 
	</cfif>
	<cfif isdefined("attributes.author_emp_id") and len(attributes.author_emp_id)>
		<cfset adres = "#adres#&author_emp_id=#attributes.author_emp_id#">
	</cfif>
	<cfif isdefined("attributes.base") and len(attributes.base)>
		<cfset adres = "#adres#&base=#attributes.base#">
	</cfif>
	<cfif isdefined("attributes.modul") and len(attributes.modul)>
		<cfset adres = "#adres#&modul=#attributes.modul#">
	</cfif>
	<cfif isdefined("attributes.process_stage") and len(attributes.process_stage)>
		<cfset adres = "#adres#&process_stage=#attributes.process_stage#">
	</cfif>
	<cfif isdefined("attributes.status") and len(attributes.status)>
		<cfset adres = "#adres#&status=#attributes.status#">
	</cfif>
	<cfif isdefined("attributes.wbo_types") and len(attributes.wbo_types)>
		<cfset adres = "#adres#&wbo_types=#attributes.wbo_types#">
	</cfif>
	<cfif isdefined("attributes.wbo_empty")>
		<cfset adres = "#adres#&wbo_empty=#attributes.wbo_empty#">
	</cfif>
	<cfif isdefined("attributes.query_order")>
		<cfset adres = "#adres#&query_order=#attributes.query_order#">
	</cfif>
	<cfif isdefined("attributes.is_active")>
		<cfset adres = "#adres#&is_active=#attributes.is_active#">
	</cfif>
	<cfif isdefined("attributes.is_special")>
		<cfset adres = "#adres#&is_special=#attributes.is_special#">
	</cfif>
	
			<cf_paging page="#attributes.page#" 
				maxrows="#attributes.maxrows#"
				totalrecords="#get_wbo.recordcount#"
				startrow="#attributes.startrow#"
				adres="dev.list_wbo#adres#"> 
	
</cfif>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
