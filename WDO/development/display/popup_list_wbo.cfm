<cfparam name="attributes.wbo_types" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.author_emp_id" default="">
<cfparam name="attributes.base" default="">
<cfparam name="attributes.modul" default="">
<cfparam name="attributes.process_stage" default="">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.FIELD_WRK_IDS" default=""><!--- FIELD_WRK_IDS tanimsiz diye hata veriyordu. O yuzden ekledim. E.Y 20120822 --->
<cfquery name="GET_MODULES" datasource="#DSN#">
	SELECT MODULE_NAME FROM MODULES ORDER BY MODULE_NAME
</cfquery>
<cfif isdefined("is_submitted") and is_submitted eq 1>
<cfset item_count = 0>
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
			TYPE,
            IS_ACTIVE,
			FOLDER,
			FILE_NAME,
            RELATED_FUSEACTION,
            IS_UPDATE,
            IS_ADD,
            IS_DELETE
		FROM
			WRK_OBJECTS
		WHERE 
			1=1 AND
			RELATED_FUSEACTION IS NULL AND
            WRK_OBJECTS_ID <> #attributes.woid#
			<cfif len(attributes.keyword)>
				AND 
				(
					FUSEACTION LIKE '%#attributes.keyword#%' OR 
					FILE_NAME LIKE '%#attributes.keyword#%' OR
					(MODUL_SHORT_NAME+'.'+ FUSEACTION) = '#attributes.keyword#'
                    <cfif isnumeric(attributes.keyword)>
                    OR WRK_OBJECTS_ID = #attributes.keyword#
                    </cfif>
				)
			</cfif>
			<cfif isdefined("attributes.author_emp_id") and len(attributes.author_emp_id)>
				AND AUTHOR = #attributes.author_emp_id#
			</cfif>
			<cfif isdefined("attributes.base") and len(attributes.base)>
				AND BASE = '#attributes.base#'
			</cfif>
			<cfif isdefined("attributes.modul") and len(attributes.modul)>
				AND MODUL = '#attributes.modul#'
			</cfif>
			<cfif isdefined("attributes.status") and len(attributes.status)>
				AND STATUS = '#attributes.status#'
			</cfif>
			<cfif isdefined("attributes.is_active") and len(attributes.is_active)>
				AND IS_ACTIVE = #attributes.is_active#
			</cfif>
            <cfif len(attributes.wbo_types) and not isdefined("attributes.wbo_empty")>
				AND(
				<cfloop list="#attributes.wbo_types#" index="k">
	                <cfset ++item_count>
                    (WRK_OBJECTS.TYPE = #left(k,1)#
                    <cfif listfind(attributes.wbo_types,'10') or listfind(attributes.wbo_types,'20')>
                        AND WRK_OBJECTS.IS_ADD = 1    
                    <cfelseif listfind(attributes.wbo_types,'11') or listfind(attributes.wbo_types,'21')>
                        AND WRK_OBJECTS.IS_UPDATE = 1
                    <cfelseif listfind(attributes.wbo_types,'22')>
                        AND WRK_OBJECTS.IS_DELETE = 1
                    </cfif>)
                    <cfif item_count neq listlen(attributes.wbo_types)>
                    OR
                    </cfif>
                </cfloop>
                )
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
                WRK_OBJECTS2.IS_UPDATE,
                WRK_OBJECTS2.IS_ADD,
                WRK_OBJECTS2.IS_DELETE
            FROM
                WRK_OBJECTS,
                WRK_OBJECTS WRK_OBJECTS2
            WHERE 
                1=1 AND
                WRK_OBJECTS.MODUL_SHORT_NAME = WRK_OBJECTS2.MODUL_SHORT_NAME AND 
                WRK_OBJECTS.RELATED_FUSEACTION = WRK_OBJECTS2.FUSEACTION AND
                WRK_OBJECTS.WRK_OBJECTS_ID <> #attributes.woid#
                <cfif len(attributes.keyword)>
                    AND 
                    (
                        WRK_OBJECTS.FUSEACTION LIKE '%#attributes.keyword#%' OR 
                        WRK_OBJECTS.FILE_NAME LIKE '%#attributes.keyword#%' OR
                        (WRK_OBJECTS.MODUL_SHORT_NAME+'.'+ WRK_OBJECTS.FUSEACTION) = '#attributes.keyword#'
                        <cfif isnumeric(attributes.keyword)>
                        OR WRK_OBJECTS.WRK_OBJECTS_ID = #attributes.keyword#
                        </cfif>
                    )
                </cfif>
                <cfif isdefined("attributes.author_emp_id") and len(attributes.author_emp_id)>
                    AND WRK_OBJECTS.AUTHOR = #attributes.author_emp_id#
                </cfif>
                <cfif isdefined("attributes.base") and len(attributes.base)>
                    AND  WRK_OBJECTS.BASE = '#attributes.base#'
                </cfif>
                <cfif isdefined("attributes.modul") and len(attributes.modul)>
                    AND  WRK_OBJECTS.MODUL = '#attributes.modul#'
                </cfif>
                <cfif isdefined("attributes.status") and len(attributes.status)>
                    AND  WRK_OBJECTS.STATUS = '#attributes.status#'
                </cfif>
                <cfif isdefined("attributes.is_active") and len(attributes.is_active)>
                    AND  WRK_OBJECTS.IS_ACTIVE = #attributes.is_active#
                </cfif>
                <cfif len(attributes.wbo_types) and not isdefined("attributes.wbo_empty")>
				AND(
				<cfloop list="#attributes.wbo_types#" index="k">
	                <cfset ++item_count>
                    (WRK_OBJECTS.TYPE = #left(k,1)#
                    <cfif listfind(attributes.wbo_types,'10') or listfind(attributes.wbo_types,'20')>
                        AND WRK_OBJECTS.IS_ADD = 1    
                    <cfelseif listfind(attributes.wbo_types,'11') or listfind(attributes.wbo_types,'21')>
                        AND WRK_OBJECTS.IS_UPDATE = 1
                    <cfelseif listfind(attributes.wbo_types,'22')>
                        AND WRK_OBJECTS.IS_DELETE = 1
                    </cfif>)
                    <cfif item_count neq listlen(attributes.wbo_types)>
                    OR
                    </cfif>
                </cfloop>
                )
            </cfif>
        ORDER BY
            MODUL,
            FUSEACTION
	</cfquery>
<cfelse>
	<cfset get_wbo.recordcount=0>
</cfif>
<!--- Sayfa Tipleri tanimlaniyor --->
<!--- Isme gore siralandi sira degistirilmesin --->
<cfscript>
	WBO_TYPES = QueryNew("TYPE_ID, TYPE_NAME");
	QueryAddRow(WBO_TYPES,12);
	QuerySetCell(WBO_TYPES,"TYPE_ID",50,1);
	QuerySetCell(WBO_TYPES,"TYPE_NAME","Ajax List",1);
	QuerySetCell(WBO_TYPES,"TYPE_ID",30,2);
	QuerySetCell(WBO_TYPES,"TYPE_NAME","Detail",2);		
	QuerySetCell(WBO_TYPES,"TYPE_ID",90,3);
	QuerySetCell(WBO_TYPES,"TYPE_NAME","Display",3);
	QuerySetCell(WBO_TYPES,"TYPE_ID",10,4);
	QuerySetCell(WBO_TYPES,"TYPE_NAME","Form Add",4);
	QuerySetCell(WBO_TYPES,"TYPE_ID",11,5);
	QuerySetCell(WBO_TYPES,"TYPE_NAME","Form Update",5);
	QuerySetCell(WBO_TYPES,"TYPE_ID",80,6);
	QuerySetCell(WBO_TYPES,"TYPE_NAME","Function",6);	
	QuerySetCell(WBO_TYPES,"TYPE_ID",40,7);
	QuerySetCell(WBO_TYPES,"TYPE_NAME","List",7);
	QuerySetCell(WBO_TYPES,"TYPE_ID",70,8);
	QuerySetCell(WBO_TYPES,"TYPE_NAME","Menu",8);
	QuerySetCell(WBO_TYPES,"TYPE_ID",60,9);
	QuerySetCell(WBO_TYPES,"TYPE_NAME","Report",9);
	QuerySetCell(WBO_TYPES,"TYPE_ID",20,10);
	QuerySetCell(WBO_TYPES,"TYPE_NAME","Query Add",10);
	QuerySetCell(WBO_TYPES,"TYPE_ID",21,11);
	QuerySetCell(WBO_TYPES,"TYPE_NAME","Query Update",11);
	QuerySetCell(WBO_TYPES,"TYPE_ID",22,12);
	QuerySetCell(WBO_TYPES,"TYPE_NAME","Query Delete",12);
</cfscript>
<cfif get_wbo.recordcount>
	<cfset author_id_list =''>
	<cfoutput query="get_wbo">
		<cfif len(author) and not listfind(author_id_list,author)>
			<cfset author_id_list = listappend(author_id_list,AUTHOR,',')>
		</cfif>
	</cfoutput>
	<cfif len(author_id_list)>
		<cfset author_id_list=listsort(author_id_list,"numeric","ASC",",")>
		<cfquery name="GET_AUTHORS" datasource="#DSN#">
			SELECT EMPLOYEE_NAME + ' ' + EMPLOYEE_SURNAME AS NAME FROM EMPLOYEES WHERE EMPLOYEE_ID IN (#author_id_list#)
		</cfquery>
	</cfif>
</cfif>
<cfset adres = ''>
<cfif isdefined("attributes.field_wrk_ids") and len(attributes.field_wrk_ids)>
	<cfset adres = "#adres#&field_wrk_ids=#field_wrk_ids#">
</cfif>
<cfif isdefined("attributes.field_obj_id") and len(attributes.field_obj_id)>
	<cfset adres = "#adres#&field_obj_id=#field_obj_id#">
</cfif>
<cfif isdefined("attributes.field_modul_name") and len(attributes.field_modul_name)>
	<cfset adres = "#adres#&field_modul_name=#field_modul_name#">
</cfif>
<cfif isdefined("attributes.table_name") and len(attributes.table_name)>
	<cfset adres = "#adres#&table_name=#table_name#">
</cfif>
<cfif isdefined("attributes.table_row_name") and len(attributes.table_row_name)>
	<cfset adres = "#adres#&table_row_name=#table_row_name#">
</cfif>
<cfif isdefined("attributes.function_row_name") and len(attributes.function_row_name)>
	<cfset adres = "#adres#&function_row_name=#function_row_name#">
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_wbo.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="popup_wbo_list" action="#request.self#?fuseaction=dev.popup_list_wbo#adres#" method="post">
<input type="hidden" name="is_submitted" id="is_submitted" value="1" />
<input type="hidden" name="woid" id="woid" value="<cfoutput>#attributes.woid#</cfoutput>" />
<input type="hidden" name="field_wrk_ids" id="field_wrk_ids" value="<cfoutput>#attributes.field_wrk_ids#"</cfoutput> />
	<cf_medium_list_search title='#lang_array.item [104]#'>
		<cf_medium_list_search_area>
			<table>
				<tr>
					<td><cf_get_lang_main no='48.Filtre'></td>
					<td><input type="text" name="keyword" id="keyword" style="width:100px;" value="<cfoutput>#attributes.keyword#</cfoutput>" maxlength="255"></td>
					<td>
						<select name="status" id="status" style="width:100px;">
							<option value="">Status</option>
							<option value="1">Analys</option>
							<option value="2">Design</option>
							<option value="3">Development</option>
							<option value="4">Testing</option>
							<option value="5">Deployment</option>
						</select>
					</td>
					<td><cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td><cf_wrk_search_button></td>
					<td><cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'></td>
				</tr>
			</table>
		</cf_medium_list_search_area>
	<cf_medium_list_search_detail_area>
		<table style="text-align:right;">
			<tr>
				<td>
					<select name="modul" id="modul" style="width:130px;">
						<option value="">Modul</option>
						<cfoutput query="get_modules">
							<option value="#module_name#"<cfif attributes.modul eq module_name>selected</cfif>>#module_name#</option>
						</cfoutput>
                        <!---
						<option value="Flex" <cfif 'Flex' eq get_fuseactions.modul>selected</cfif>>Flex</option> 
						<option value="Home" <cfif 'Home' eq get_fuseactions.modul>selected</cfif>>Home</option> 
						<option value="Myhome" <cfif 'Myhome' eq get_fuseactions.modul>selected</cfif>>My Home</option>
						<option value="Objects2" <cfif 'Objects2' eq get_fuseactions.modul>selected</cfif>>Objects 2</option> 
						<option value="PDA" <cfif 'PDA' eq get_fuseactions.modul>selected</cfif>>PDA</option> 
						<option value="Schedules" <cfif 'Schedules' eq get_fuseactions.modul>selected</cfif>>Schedules</option>
						<option value="Test" <cfif 'Test' eq get_fuseactions.modul>selected</cfif>>Test</option>
						<option value="Webhaber" <cfif 'Webhaber' eq get_fuseactions.modul>selected</cfif>>Web Haber</option>
						--->
					</select>
				</td>
				<td width="100">
					<select name="base" id="base" style="width:100px;">
						<option value="">Base</option>
						<option value="1"<cfif isdefined("attributes.base") and attributes.base eq 1>selected</cfif>>Intranet</option>
						<option value="2"<cfif isdefined("attributes.base") and attributes.base eq 2>selected</cfif>>ERP</option>
						<option value="3"<cfif isdefined("attributes.base") and attributes.base eq 3>selected</cfif>>CRM</option>
						<option value="4"<cfif isdefined("attributes.base") and attributes.base eq 4>selected</cfif>>PMS</option>
						<option value="5"<cfif isdefined("attributes.base") and attributes.base eq 5>selected</cfif>>Service</option>
						<option value="6"<cfif isdefined("attributes.base") and attributes.base eq 6>selected</cfif>>PAM</option>
						<option value="7"<cfif isdefined("attributes.base") and attributes.base eq 8>selected</cfif>>Store</option>
						<option value="8"<cfif isdefined("attributes.base") and attributes.base eq 8>selected</cfif>>HR</option>
						<option value="9"<cfif isdefined("attributes.base") and attributes.base eq 9>selected</cfif>>CMS</option>
						<option value="10"<cfif isdefined("attributes.base") and attributes.base eq 10>selected</cfif>>Communication</option>
						<option value="11"<cfif isdefined("attributes.base") and attributes.base eq 11>selected</cfif>>Report</option>
						<option value="12"<cfif isdefined("attributes.base") and attributes.base eq 12>selected</cfif>>Systems</option>
						<option value="13"<cfif isdefined("attributes.base") and attributes.base eq 13>selected</cfif>>Other</option>
					</select>
				</td>
				<td>
					<cf_multiselect_check 
						query_name="WBO_TYPES"  
						name="wbo_types"
						width="135" 
						option_value="TYPE_ID"
						option_name="TYPE_NAME"
						value="#attributes.wbo_types#">
				</td>
			</tr>
		</table>
	</cf_medium_list_search_detail_area>
</cf_medium_list_search>
<cf_medium_list>
	<thead>
		<tr>
			<th width="30">No</th>
			<th>Base</th>
			<th>Modul</th>
			<th>Fuseaction</th>
			<th>Head</th>
			<th>Type</th>
			<th>Status</th>
			<cfif get_wbo.recordcount><th width="15"><input type="Checkbox" name="all_" id="all_" value="1" onClick="hepsi();"></th></cfif>
		</tr>
	</thead>
	<tbody>
		<cfif get_wbo.recordcount>
			<cfoutput query="get_wbo" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				<tr>
					<td>#currentrow#</td>
					<td>#base#</td>
					<td><cfif isdefined("attributes.field_obj_id") and len(attributes.field_obj_id)><a href="javascript://" onclick="gonder('#wrk_objects_id#','#modul#','#fuseaction#');" class="tableyazi">#base#</a><cfelse>#modul#</cfif></td>
					<td><cfif isdefined("attributes.field_obj_id") and len(attributes.field_obj_id)><a href="javascript://" onclick="gonder('#wrk_objects_id#','#modul#','#fuseaction#');" class="tableyazi">#fuseaction#</a><cfelse>#fuseaction#</cfif></td>
					<td>#head#</td>
					<td nowrap="nowrap">
						<cfif listfind(type,'1')> <cfif is_update eq 1>Form Update<br /></cfif><cfif is_add eq 1>Form Add<br /></cfif>
						<cfelseif listfind(type,'2')><cfif is_update eq 1>Query Update<br /></cfif><cfif is_delete eq 1>Query Delete<br /></cfif><cfif is_add eq 1>Query Add<br /></cfif>
						<cfelseif listfind(type,'3')>Detail<br />
						<cfelseif listfind(type,'4')>List<br />
						<cfelseif listfind(type,'5')>Ajax List<br />
						<cfelseif listfind(type,'6')>Report<br />
						<cfelseif listfind(type,'7')>Menu<br />
						<cfelseif listfind(type,'8')>Function<br />
						<cfelseif listfind(type,'9')>Display<br />
						</cfif>
					</td>
					<td>#status#</td>
					<td>
						<input type="checkbox" value="#wrk_objects_id#" name="wrk_ids" id="wrk_ids">
						<input type="hidden" name="fuseaction_" id="fuseaction_" value="#fuseaction#">
						<input type="hidden" name="head_" id="head_" value="#head#">
						<input type="hidden" name="modul_" id="modul_" value="#modul#">
						<input type="hidden" name="type_" id="type_" value="#type#">
					</td>
				</tr>
			</cfoutput>
		</tbody>
		<tfoot>
			<tr>
				<td colspan="10" style="text-align:right"><input type="button" value="<cf_get_lang_main no='49.Kaydet'>" onClick="add_checked();"></td>
			</tr>
		</tfoot>
	<cfelse>
		<td colspan="10"><cfif isdefined("is_submitted")>Kayıt Yok !<cfelse>Filtre Ediniz !</cfif></td>
	</cfif>  
</cf_medium_list>
</cfform>
	<cfif attributes.totalrecords gt attributes.maxrows>
	
					<cfset adres = attributes.fuseaction>
					<cfif isdefined('is_submitted')><cfset adres = adres&"&is_submitted=1"></cfif>
					<cfif isdefined("attributes.keyword") and len(attributes.keyword)>
						<cfset adres = "#adres#&keyword=#attributes.keyword#"> 
					</cfif>
					<cfif isdefined("attributes.field_obj_id") and len(attributes.field_obj_id)>
						<cfset adres = "#adres#&field_obj_id=#attributes.field_obj_id#">
					</cfif>
					<cfif isdefined("attributes.field_modul_name") and len(attributes.field_modul_name)>
						<cfset adres = "#adres#&field_modul_name=#attributes.field_modul_name#">
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
					<cfif isdefined("attributes.project_id") and len(attributes.project_id)>
						<cfset adres = "#adres#&project_id=#attributes.project_id#">
					</cfif>
					<cfif isdefined("attributes.is_active")>
						<cfset adres = "#adres#&is_active=#attributes.is_active#">        
					</cfif>
					<cfif isdefined("attributes.wbo_types")>
						<cfset adres = "#adres#&wbo_types=#attributes.wbo_types#">                
					</cfif>
                    <cfif isdefined("attributes.woid")>
						<cfset adres = "#adres#&woid=#attributes.woid#">
					</cfif>
                    <cfif isdefined("attributes.field_wrk_ids")>
						<cfset adres = "#adres#&field_wrk_ids=#attributes.field_wrk_ids#">
					</cfif>
					<cf_paging page="#attributes.page#" 
						maxrows="#attributes.maxrows#"
						totalrecords="#attributes.totalrecords#"
						startrow="#attributes.startrow#" 
						adres="#adres#">
				
	</cfif>
<script language="JavaScript">
	document.popup_wbo_list.keyword.select();
<cfif isdefined("is_submitted")>		
	<cfif isdefined("attributes.row_count")>
		rowCount = parseInt(opener.document.<cfoutput>#attributes.row_count#</cfoutput>.value+1);
	</cfif>
		function hepsi()
		{
			if (document.popup_wbo_list.all.checked)
				{
					for(i=0;i<popup_wbo_list.wrk_ids.length;i++) popup_wbo_list.wrk_ids[i].checked = true;
				}
			else
				{
					for(i=0;i<popup_wbo_list.wrk_ids.length;i++) popup_wbo_list.wrk_ids[i].checked = false;
				}
		}
		function add_checked()
		{
			var counter = 0;
	
			<cfif attributes.maxrows neq 1>	
				for(i=0;i<popup_wbo_list.wrk_ids.length;i++) 
					if (popup_wbo_list.wrk_ids[i].checked == true) 
					{
						counter = counter + 1;
					}
					if (counter == 0)
					{
						alert("Fuseaction Seçmelisiniz!");
						return false;
					}
			<cfelseif attributes.maxrows eq 1>
				if (popup_wbo_list.wrk_ids.checked == true) 
				{
					counter = counter + 1;
				}
				if (counter == 0)
				{
					alert("Fuseaction Seçmelisiniz !");
					return false;
				}
			</cfif>
			
			<cfif attributes.maxrows neq 1 and isdefined("attributes.field_wrk_ids")>	
				counter = 0;
				wrk_ids="";
				fuseaction_="";
				
				for(i=0;i<popup_wbo_list.wrk_ids.length;i++)
				{
					if (popup_wbo_list.wrk_ids[i].checked == true) 
					{
						counter = counter + 1;
						if(counter == 1)
						{
							var wrk_ids = popup_wbo_list.wrk_ids[i].value;
							var fuseactions = popup_wbo_list.fuseaction_[i].value;
						}
						else
						{
							var wrk_ids = wrk_ids + ',' + popup_wbo_list.wrk_ids[i].value;					
							var fuseactions = fuseactions + ',' + popup_wbo_list.fuseaction_[i].value;
						}
					}
				}
				if(opener.document.upd_faction.<cfoutput>#attributes.field_wrk_ids#</cfoutput> != undefined)
					opener.document.upd_faction.<cfoutput>#attributes.field_wrk_ids#</cfoutput>.value +=  ',' + wrk_ids ; 
			<cfelseif (get_wbo.recordcount eq 1 or  attributes.maxrows eq 1) and isdefined("field_wrk_ids")>
				var field_wrk_ids = popup_wbo_list.wrk_ids.value;
				if(opener.document.upd_faction.<cfoutput>#attributes.field_wrk_ids#</cfoutput> != undefined)
					opener.document.upd_faction.<cfoutput>#attributes.field_wrk_ids#</cfoutput>.value +=  wrk_ids + ',';
			</cfif>
			
			<cfif isdefined("attributes.field_wrk_ids") and attributes.maxrows neq 1>	
					counter = 0;
					for(i=0;i<popup_wbo_list.wrk_ids.length;i++)
					{
						if (popup_wbo_list.wrk_ids[i].checked == true) 
							{
								counter = counter + 1;
								var wrk_ids = popup_wbo_list.wrk_ids[i].value;
								var fuseaction = popup_wbo_list.fuseaction_[i].value;
								var modul = popup_wbo_list.modul_[i].value;
								var type = popup_wbo_list.type_[i].value;
								rowCount = rowCount + 1;					
								var ss_int = ekle_str(fuseaction,wrk_ids,type,modul);
							}
					}
					<cfif isdefined("attributes.row_count")>opener.document.<cfoutput>#attributes.row_count#</cfoutput>.value = rowCount;</cfif>
			</cfif>
		}
		<cfif isdefined("attributes.table_name")>
			function ekle_str(fuseaction,wrk_ids,type,modul)
			{
				var newRow;
				var newCell;
				
				newRow = opener.document.getElementById('<cfoutput>#attributes.table_name#</cfoutput>').insertRow();
				newRow.setAttribute("name","<cfoutput>#attributes.table_row_name#</cfoutput>" + rowCount);
				newRow.setAttribute("id","<cfoutput>#attributes.table_row_name#</cfoutput>" + rowCount);		
				newRow.setAttribute("style","display:''");	
				newCell = newRow.insertCell(newRow.cells.length);
				str_html = '';
				str_html = str_html + '<input type="hidden" name="<cfoutput>#attributes.field_wrk_ids#</cfoutput>" value="' + wrk_ids + '">';	
				str_del = '<a href="javascript://" onClick="<cfoutput>#attributes.function_row_name#</cfoutput>(' + rowCount +');"><img src="/images/delete_list.gif"  width="15" height="15" align="absmiddle" border="0"></a>&nbsp';	
				newCell.innerHTML = str_del + str_html + fuseaction + '(' + type + '-' + modul + ')';
				return 1;
			 }
		<cfelse>
			function gonder(id,modul,name)
			{
				<cfif isdefined('attributes.call_function_first')>
					window.opener.<cfoutput>#attributes.call_function_first#(id,modul,name);</cfoutput>
				<cfelse>
					<cfif isDefined("attributes.field_obj_id")>
						opener.<cfoutput>#attributes.field_obj_id#</cfoutput>.value=id;
					</cfif>
					<cfif isDefined("attributes.field_modul_name")>
						opener.<cfoutput>#attributes.field_modul_name#</cfoutput>.value=modul;
					</cfif>
					<cfif isDefined("attributes.field_wbo_name")>
						opener.<cfoutput>#attributes.field_wbo_name#</cfoutput>.value=name;
					</cfif>
				</cfif>
			}
		</cfif>
</cfif>
</script>
