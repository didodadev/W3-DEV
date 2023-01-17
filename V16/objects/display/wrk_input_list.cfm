<cfsetting showdebugoutput="no">
<cfquery name="GET_QUERY" datasource="#attributes.datasource#">
    SELECT  #attributes.column_name#,#attributes.column_id# FROM #attributes.table_name# WHERE 1=1 <cfif len(attributes.keyword_)>AND #attributes.column_name# LIKE '%#attributes.keyword_#%'</cfif> ORDER BY #attributes.column_name#
</cfquery>
<cfparam name="attributes.boxwidth" default="200">
<cfparam name="attributes.boxheight" default="200">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_query.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset sayac = 0>
<cf_box title="Parametre" body_style="overflow:auto;width:#attributes.boxwidth#px;height:#attributes.boxheight#px;">
<table cellpadding="2" cellspacing="1" class="color-header" width="100%">
	<cfif GET_QUERY.recordcount>
    	<cfset _lastpage_ = (attributes.totalrecords \ attributes.maxrows) + iif(attributes.totalrecords mod attributes.maxrows,1,0) >
        <cfoutput query="GET_QUERY" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
        <cfset sayac = sayac+1>
        <cfset name = replace(wrk_eval('#attributes.column_name#'),"'"," ","all")>
        <cfset name = replace(name,";"," ","all")>
        <cfset name = replace(name,'"','','all')>
        <cfset name = replace(name,";"," ","all")>
            <tr height="20" onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row">
            	<cfif sayac eq 1 and GET_QUERY.recordcount gt attributes.maxrows>
                <td align="center" nowrap width="1%" dir="rtl" valign="top" rowspan="#attributes.maxrows+1#">
					<cfif attributes.page neq 1><a href="##" onClick="ajaxPage('1');"  class="tableyazi"></cfif><img src="../images/arrowleft.png" border="0"><cfif attributes.page neq 1></a></cfif><br/>
                    <cfif attributes.page - 2 gt 0><a href="##" onClick="ajaxPage('#attributes.page-2#');">[#attributes.page-2#]</a><cfelse>[...]</cfif><br/>
                    <cfif attributes.page - 1 gt 0><a href="##" onClick="ajaxPage('#attributes.page-1#');">[#attributes.page-1#]</a><cfelse>[...]</cfif><br/>	
                    <b>[<font color="red">#attributes.page#</font>]</b><br/>
                    <cfif attributes.page + 1 lte _lastpage_ ><a href="##" onClick="ajaxPage('#attributes.page+1#');">[#attributes.page+1#]</a><cfelse>[...]</cfif><br/>
                    <cfif attributes.page + 2 lte _lastpage_ ><a href="##" onClick="ajaxPage('#attributes.page+2#');">[#attributes.page+2#]</a><cfelse>[...]</cfif><br/>
                    <cfif attributes.page neq _lastpage_><a href="##" onClick="ajaxPage('#_lastpage_#');"class="tableyazi"></cfif><img src="../images/arrowright.png" border="0"><cfif attributes.page neq _lastpage_></a></cfif><br/>
                    #attributes.page#/#_lastpage_#<br/>
                    <abbr title="Kayıt Sayısı" style="color:red;font-size:14px;">#get_query.recordcount#</abbr>
                </td>
				</cfif>
                <td width="1%">#currentrow#</td>
            	<td><a style="cursor:pointer;" onClick='send_value(#Evaluate("#attributes.column_id#")#,"#name#");'>#name#</a></td>
            </tr>
		</cfoutput>
    <cfelse>
        <tr class="color-list">
        	<td colspan="2"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
        </tr>
    </cfif>
</table>
</cf_box>
<cfoutput>
<script type="text/javascript">
	function ajaxPage(page){
		<cfoutput>
		var wrk_list_url_strings = '&input_name=#attributes.input_name#&column_name=#attributes.column_name#&column_id=#attributes.column_id#&datasource=#attributes.datasource#&table_name=#attributes.table_name#&keyword_=#attributes.keyword_#';
		AjaxPageLoad('#request.self#?fuseaction=objects.popup_wrk_input_list&page='+page+''+wrk_list_url_strings+'','wrk_input_div_#attributes.input_name#',1);
		</cfoutput>
	}
	function send_value(id,name){
		document.getElementById('#attributes.input_name#_id').value = id;
		document.getElementById('#attributes.input_name#').value = name;
		gizle(wrk_input_div_#attributes.input_name#);
	}
</script>
</cfoutput>
<cfabort>
