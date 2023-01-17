<cfset url_str = ''>
<cfif isdefined("attributes.record_num_value")>
	<cfset url_str = '#url_str#&record_num_value=#attributes.record_num_value#'>
</cfif>
<cfif isdefined("attributes.property_id")>
	<cfset url_str = '#url_str#&property_id=#attributes.property_id#'>
</cfif>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="GET_PROPERTY_DETAIL" datasource="#dsn1#">
    SELECT
        PRPT_ID,
        PROPERTY_DETAIL,
        PROPERTY_DETAIL_ID
        
    FROM
        PRODUCT_PROPERTY_DETAIL 
    WHERE 
    	PRPT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.property_id#"> 
    	<cfif len(attributes.keyword)>
        	AND PROPERTY_DETAIL LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> 
        </cfif>
    	
</cfquery>
<cfparam name="attributes.totalrecords" default='#GET_PROPERTY_DETAIL.recordcount#'>
<cfform name="search_variations" method="post" action="#request.self#?fuseaction=#url.fuseaction#&#url_str#">
<cf_medium_list_search title='#lang_array.item [247]#'>
<cf_medium_list_search_area>	
        <table>
            <tr>
                <td><cf_get_lang dictionary_id='57460.Filtre'></td>
                <td><cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="50"></td>
                <td>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" onKeyUp="isNumber(this)" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </td>
                <td><cf_wrk_search_button></td>
            </tr>
        </table>  
</cf_medium_list_search_area>
</cf_medium_list_search>
</cfform>
<cf_medium_list>	
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='37258.Varyasyonlar'></th>
			<!---<th width="1%" align="center"><input type="checkbox" name="main_variation_" id="main_variation_" title="Hepsini Seç" onClick="wrk_select_all(this.id,'variation_');"></th>--->
		</tr>
	</thead>
	<tbody>
		<cfif GET_PROPERTY_DETAIL.recordcount>		 
			<cfoutput query="GET_PROPERTY_DETAIL" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
				<tr>
					<td><a onClick="gonder('#PROPERTY_DETAIL_ID#','#PROPERTY_DETAIL#');" style="cursor:pointer;">#PROPERTY_DETAIL#</a></td>
					
					<!---<td><input type="checkbox" name="variation_" id="variation_" <cfif listfind(attributes.related_variation_id,VARIATION_ID)>checked</cfif> value="#VARIATION_ID#█#PROPERTY_DETAIL#"></td>--->
				</tr>
			</cfoutput> 
			<cfelse>
				<tr> 
					<td colspan="5" height="20"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
				</tr>
		</cfif>
	</tbody>
	<!---<tfoot>
		<tr>
			<td colspan="4" style="text-align:right;"><input type="button" value="Ekle" onClick="add_variation();"></td>
		</tr>
	</tfoot>--->
</cf_medium_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<table width="99%">
		<tr> 
			<td> 
				<cfset adres = url.fuseaction>
				<cfif len(attributes.keyword)>
					<cfset adres = '#adres#&keyword=#attributes.keyword#'>
				</cfif>
				<cfif isdefined("attributes.related_variation_id")>
					<cfset adres = '#adres#&related_variation_id=#attributes.related_variation_id#'>
				</cfif>
				<cf_pages page="#attributes.page#" 
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#adres##url_str#">
			</td>
			<!-- sil -->
			<td style="text-align:right;">
				<cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput>
			</td>
			<!-- sil -->
		</tr>
	</table>
</cfif>
<script type="text/javascript">
	<cfoutput>
	var crntrw = #attributes.record_num_value#
	function add_variation(){
		var check_leng = document.getElementsByName('variation_').length;
		<!---<cfif len(attributes.related_variation_id)>
			opener.window.document.getElementById('#attributes.variation_id#').value=#attributes.related_variation_id#;
		</cfif>--->
		for(var _ind_=0; _ind_<check_leng; _ind_++){
			if(document.getElementsByName('variation_')[_ind_].checked == true){
				<cfif isdefined('attributes.variation_id')><!--- Variation ID --->
					opener.window.document.getElementById('#attributes.variation_id#').value=opener.window.document.getElementById('#attributes.variation_id#').value+','+list_getat(document.getElementsByName('variation_')[_ind_].value,1,'█');
					opener.window.document.getElementById('#attributes.variation_id#').value;
				</cfif>
				<cfif isdefined('attributes.variation')><!--- Variation Name --->
					opener.window.document.getElementById('#attributes.variation#').value=opener.window.document.getElementById('#attributes.variation#').value+','+list_getat(document.getElementsByName('variation_')[_ind_].value,2,'█');
				</cfif>
			}	
		}
	}
	function gonder(variation_id,variation_name){
		<!--- Variation ID --->
		opener.window.eval("document.getElementById('variation_id" + crntrw + "')").value = variation_id;
		<!--- Variation Name --->
		opener.window.eval("document.getElementById('variation" + crntrw + "')").value = variation_name;
		this.close();
	}
	</cfoutput>
</script>