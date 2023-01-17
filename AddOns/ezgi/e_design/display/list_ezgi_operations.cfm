<cfparam name="attributes.keyword" default=''>
<cfparam name="attributes.is_filter" default="1">
<cfif attributes.is_filter>
	<cfquery name="operations" datasource="#dsn3#">
    	SELECT        
        	OPERATION_TYPE_ID, 
            OPERATION_CODE, 
            OPERATION_TYPE
		FROM            
        	OPERATION_TYPES
		WHERE  
        	1=1
            <cfif len(attributes.keyword)>    
        		AND (OPERATION_CODE LIKE N'#attributes.keyword#%' OR OPERATION_TYPE LIKE N'#attributes.keyword#%')
          	</cfif>
      	ORDER BY
        	OPERATION_CODE
	</cfquery>
<cfelse>
	<cfset operations.recordcount = 0>
</cfif>
<cfparam name="attributes.maxrows" default="#SESSION.EP.MAXROWS#">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.totalrecords" default=#operations.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfform name="operations_search" action="#request.self#?fuseaction=prod.popup_list_ezgi_operations" method="post">
	<input type="hidden" name="is_filter" id="is_filter" value="1">
	<cf_medium_list_search title=''>
		<cf_medium_list_search_area>
			<table>
				<tr> 
					<td><cf_get_lang_main no='48.Filtre'></td>
					<td><cfinput type="text" name="keyword" maxlength="50" value="#attributes.keyword#" style="width:100px;"></td>
					<td>
						<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
						<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
					</td>
					<td style="text-align:right;"><cf_wrk_search_button search_function='input_control()'></td>
				</tr>       
			</table>
		</cf_medium_list_search_area>
	</cf_medium_list_search>
</cfform>
<cf_area width="200px">
<cf_medium_list>
	<thead>
		<tr>
        	<th><cf_get_lang_main no='1165.Sıra'></th>
			<th><cf_get_lang_main no='1173.Kod'></th>
			<th><cf_get_lang_main no='1622.Operasyon'></th>
		</tr>
	</thead>
	<tbody>
		<cfif operations.recordcount>
			<cfoutput query="operations" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                <form name="product#currentrow#" method="post" action="">
                    <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">     
                        <td style="text-align:right; width:30px">#currentrow#</td>      
                        <td style="text-align:center; width:60px">#operation_code#</td>
                        <cfscript>temp_operation_type=replace(operation_type,'"','','all');</cfscript>
                        <cfscript>temp_operation_code=replace(operation_code,'"','','all');</cfscript>
                        <cfset temp_operation_name = '#operation_code# - #operation_type#'>
                        <td style="cursor:pointer" class="tableyazi" onClick="javascript:opener.add_row(#operation_type_id#,'#temp_operation_name#');">#operation_type#</td> 
                    </tr>
              </form>
            </cfoutput> 
		<cfelse>
			<tr> 
				<td colspan="6">
					<cfif attributes.is_filter>
						<cf_get_lang_main no='72.Kayıt Bulunamadı'>!
					<cfelse>
						<cf_get_lang_main no='289.Filtre Ediniz'>!
					</cfif>
				</td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
</cf_area>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="99%">
	  <tr> 
		<td>
			<cfset adres = "prod.popup_list_ezgi_operations">
			<cfif len(attributes.keyword)>
				<cfset adres = "#adres#&keyword=#attributes.keyword#">
			</cfif>
			<cf_pages page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#adres#">
		  </td>
		  <!-- sil --><td style="text-align:right;"> <cfoutput> <cf_get_lang_main no='128.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang_main no='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> 
		  </td><!-- sil -->
	  </tr>
	</table>
</cfif>
<script type="text/javascript">
	operations_search.keyword.focus();
	function input_control()
	{
		return true;	
	}
</script>