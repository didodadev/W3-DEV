<cfquery datasource="#dsn#" name="get_primary_column">
	SELECT COLUMN_ID,COLUMN_NAME
	FROM	
		WRK_COLUMN_INFORMATION
	WHERE
		TABLE_ID = #attributes.table_id# 
</cfquery>
<cfif isdefined("attributes.is_submitted")>
    <cfquery name="get_relationship" datasource="#dsn#">
        SELECT 
			DB_NAME,
			TABLE_NAME,
			COLUMN_NAME,
			TYPE,
			STATUS,
			COLUMN_ID  
        FROM 
            WRK_COLUMN_INFORMATION CI JOIN
             WRK_OBJECT_INFORMATION OI ON 
             OI.OBJECT_ID=CI.TABLE_ID <cfif isdefined("attributes.type") and attributes.type is 'Aktive'>and 
             TYPE=1<cfelseif isdefined("attributes.type") and attributes.type is 'Passive'>and TYPE=0</cfif> 
        WHERE 
            <cfif isdefined("attributes.table_name") and len(attributes.table_name)>TABLE_NAME like'%#attributes.table_name#%' and </cfif>
            <cfif isdefined("attributes.column_name") and len(attributes.column_name)>COLUMN_NAME LIKE '%#attributes.column_name#%' and</cfif> 
			1=1
    </cfquery>
<cfelse>
	<cfset get_relationship.recordcount=0>
</cfif>
<cfparam  name="attributes.column_name" default="">
<cfparam name="attributes.table_name" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_relationship.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfform name="add_relationships" action="#request.self#?fuseaction=dev.popup_add_relationship" method="post">	 
	<input type="hidden" name="is_submitted" id="is_submitted" value="1" />
    <input type="hidden" name="table_id" id="table_id" value="<cfoutput>#attributes.table_id#</cfoutput>">
    <cf_medium_list_search title="İlişki Ekle">
    	<cf_medium_list_search_area>
        <table style="text-align:right;">
            <tr>
                <td>Table Name</td>
                <td><input type="text" name="table_name" style="width:70px" value="<cfoutput>#attributes.table_name#</cfoutput>" id="table_name" /></td>
                <td>Column Name</td>
                <td><input type="text" name="column_name" style="width:70px" value="<cfoutput>#attributes.column_name#</cfoutput>" id="column_name" /></td>
                <!---<td>Active</td>
                <td>
                    <select name="type" id="type" style="width:55px">
                        <option  Value="1" <cfif isdefined("attributes.type") and attributes.type eq 1>Selected</cfif>>Aktive</option>
                        <option value="0" <cfif isdefined("attributes.type") and attributes.type eq 0>Selected</cfif> >Passive</option>
                    </select> 
                </td>--->
                <td>Primary Key *</td>
                <td>
                    <select name="primary_key_column" id="primary_key_column" onchange="kontrol(this.value)" style="width:160px;">
                        <cfoutput query="get_primary_column">
                            <option value="#COLUMN_NAME#">#COLUMN_NAME#</option>
                        </cfoutput>
                    </select>
                </td>
                <td><cf_wrk_search_button></td>
            </tr>
        </table>
		</cf_medium_list_search_area>
    </cf_medium_list_search>
</cfform>
 <cfform name="add_relationship" action="#request.self#?fuseaction=dev.emptypopup_add_relationship" onsubmit="return mycontrol()" method="post">
 	<cf_medium_list>
    	<thead>
            <tr>
                <th>Database Name</th>
                <th>Table Name</th>
                <th>Column Name</th>
                <th>Status</th>
                <th>&nbsp;</th>
            </tr>
        </thead>
			<cfif isdefined("attributes.is_submitted")>
                <cfif get_relationship.recordcount>
                        <input type="text" name="table_id_" id="table_id_" value="<cfoutput>#attributes.table_id#</cfoutput>" />
                        <input type="text" name="primary_key_" id="primary_key_" value="<cfoutput>#get_primary_column.column_name#</cfoutput>"/>
                        <cfoutput query="get_relationship" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tbody>
                            <tr>
                                <td> 
									<cfif DB_NAME is 'workcube_cf'>
                                        Workcube_Main_Db
                                    <cfelseif DB_NAME is 'workcube_cf_product'>
                                        Workcube_Product_Db	
                                    <cfelseif DB_NAME is 'workcube_cf_1'>
                                        Workcube_Company_Db
                                    <cfelseif DB_NAME is 'workcube_cf_2012_1'>
                                        Workcube_Period_Db		
                                    </cfif>
                                </td>
                                <td>#TABLE_NAME#</td>
                                <td>#COLUMN_NAME#</td>
                                <td><cfif not len (STATUS)>Deployment<cfelse>#STATUS#</cfif></td>
                                <td><input type="checkbox" name="insert_relation" onclick="egemen_a(this.value)" id="insert_relation#COLUMN_ID#"  value="#TABLE_NAME#-#COLUMN_NAME#" /></td>
                            </tr>
                        </tbody>					
                        </cfoutput>
                        <tfoot>
                            <tr>
                                <td colspan="6" style="text-align:right;"><input type="submit" value="Kaydet" /></td>
                            </tr>
                        </tfoot>
                    <cfelse>
                        <tbody>
                            <tr>
                                <td colspan="6"><cf_get_lang_main no='72.Kayıt Bulunamadı'> !</td>
                            </tr>
                        </tbody>
                    </cfif>
            <cfelse>
            	<tbody>
                    <tr>
                        <td colspan="6"><cfif isdefined("attributes.is_submitted")>Kayıt Yok !<cfelse>Filtre Ediniz!</cfif></td>
                    </tr>
                </tbody>
            </cfif>
	</cf_medium_list>
	</cfform> 	
	<cfif attributes.totalrecords gt attributes.maxrows>
       	  <cfset url_string = "">
		  <cfif isdefined("attributes.table_name") and len(attributes.table_name)>
              <cfset url_string = '#url_string#&table_name=#attributes.table_name#'>
          </cfif>
          <cfif isdefined("attributes.column_name") and len(attributes.column_name)>
              <cfset url_string = '#url_string#&column_name=#attributes.column_name#'>
          </cfif>
			<cfif isdefined("attributes.is_submitted") and len(attributes.is_submitted)>
                <cfset url_string = '#url_string#&is_submitted=1'>
            </cfif>
           <cfif isdefined("attributes.table_id") and len(attributes.table_id)>
              <cfset url_string = '#url_string#&table_id=#attributes.table_id#'>
          </cfif>
					<cf_paging
					page="#attributes.page#"
					maxrows="#attributes.maxrows#" 
					totalrecords="#attributes.totalrecords#" 
					startrow="#attributes.startrow#" 
					adres="dev.popup_add_relationship#url_string#">
				
	</cfif>
	
	<script type="text/javascript">	
			function egemen_a(x)
			{
				var primary_key = document.getElementById("primary_key_").value;
				var ext_params_ = x + ';' + primary_key;
				var relationship_control = wrk_safe_query('relationship_control_','dsn',0,ext_params_);
				if (relationship_control.recordcount > 0)
				{
					alert("ilişki mevcut ,tekrardan ekleyemezsin...");
					document.getElementById('insert_relation'+x).checked=false;
				}
			}
		
		function kontrol(x)
		{
			<cfif isdefined("attributes.is_submitted")>
			//document.forms['add_relationships']['primary_key_'].value =x;
			document.getElementById('primary_key_').value=x;
			</cfif>
		}
		
		function mycontrol()
		{		
			if (document.getElementById('primary_key_').value == '')
			
			{
				alert("Primary Key Seçmelisiniz");
				return false;
			}
		}
	</script>
