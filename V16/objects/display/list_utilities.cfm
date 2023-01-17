<cfform name="search" action="" method="post">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.form_varmi" default="">
<input type="hidden" name="form_varmi" id="form_varmi" value="1">
<cf_wrk_alphabet>
	<cf_big_list_search title="Utilities">
		<cf_big_list_search_area>
	<div class="row form-inline">	
		<div class="form-group" id="keyword">
			<div class="input-group x-12">
				<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
			 	<cfinput type="text" name="keyword" placeholder="#message#" style="width:90px;" value="#attributes.keyword#" maxlength="50">
			</div>
		</div>	
		<div class="form-group">
						<cf_wrk_search_button>
					<div>
				</div>
		</cf_big_list_search_area>
	</cf_big_list_search>
</cfform>
<cfif attributes.form_varmi eq 1>
	<cfset getUtilities.recordcount = 0>
<cfelse>
	<cfset getUtilities.recordcount = 0>
</cfif>
<div id="detailFormBase" style="display:none">
	<table width="50%">
    	<input type="hidden" id="UTILITY_ID" />
    	<tr>
        	<td>
            	UTILITY : <label id="UTILITY_NAME"></label>
            </td>
        </tr>
    	<tr>
        	<td>
            	<label id="DETAIL"></label>
            </td>
        </tr>
        <cfif isDefined('attributes.threepoint_data') and len(attributes.threepoint_data)>
            <tr>
                <td>
                    ThreePoint Data:
                    <textarea rows="3" id="THREEPOINT_DATA" style="width:100%"></textarea>
                    <input type="button" id="set_threepoint" value="Add" onclick="getToOpener()" />
                </td>
            </tr>
        </cfif>
        <cfif isDefined('attributes.autocomplete_data') and len(attributes.autocomplete_data)>
            <tr>
                <td>
                    AutoComplete Data:
                    <textarea rows="3" id="AUTOCOMPLETE_DATA" style="width:100%"></textarea>
                    <input type="button" id="set_autocomplete" value="Add" onclick="getToOpener()" />
                </td>
            </tr>
        </cfif>
        <cfif isDefined('attributes.methodquery_data') and len(attributes.methodquery_data)>
            <tr>
                <td>
                    MethodQuery Data:
                    <textarea rows="3" id="METHODQUERY_DATA" style="width:100%"></textarea>
                    <input type="button" id="set_methodquery" value="Add" onclick="getToOpener()" />
                </td>
            </tr>
        </cfif>
    </table>
</div>

<cf_medium_list>
	<thead>
		<tr height="20">
        	<th></th>
			<th><cf_get_lang dictionary_id='57487.No'></th>
			<th><cf_get_lang dictionary_id='60144.Utility Name'></th>
			<th><cf_get_lang dictionary_id='33599.Description'></th>
			<th><cf_get_lang dictionary_id='60145.Types'></th>
		</tr>
	</thead>
	<tbody>
		<cfif isdefined("attributes.form_varmi") and getUtilities.recordcount>
        	<cfoutput query="getUtilities">
                <tr height="20">
                	<td onclick="getDetail('#UTILITY_ID#', '#UTILITY_NAME#', '#DEVELOPER#', '#VERSION#', '#DETAIL#', '#IS_THREEPOINT#', '#THREEPOINT_DATA#', '#IS_AUTOCOMPLETE#', '#AUTOCOMPLETE_DATA#', '#IS_METHODQUERY#', '#METHODQUERY_DATA#')">
                    	<img id="siparis_goster#currentrow#" src="/images/listele.gif" title="<cf_get_lang dictionary_id ='58596.Göster'>">
                    </td>
                    <td>#currentrow#</td>
                    <cfset autoComplete = Replace(AUTOCOMPLETE_DATA,"'","\'","All")>
                    <cfset methodQuery = Replace(METHODQUERY_DATA,"'","\'","All")>
                    <cfset threePoint = Replace(THREEPOINT_DATA,"'","\'","All")>
                    <td><a href="javascript://" onClick="getDetail('#UTILITY_ID#', '#UTILITY_NAME#', '#DEVELOPER#', '#VERSION#', '#DETAIL#', '#IS_THREEPOINT#', '#threePoint#', '#IS_AUTOCOMPLETE#', '#autoComplete#')" class="tableyazi">#URLDecode(UTILITY_NAME)#</a></td>
                    <td>#URLDecode(DETAIL)#</td>
                    <td>#TYPES#</td>
                </tr>
				<tr id="utility_detail#UTILITY_ID#" style="display:none" class="nohover">
					<td colspan="5">
						<div align="left" id="utility_detail_div#UTILITY_ID#"></div>
					</td>
				</tr>
            </cfoutput>
		<cfelse>
			<tr>
				<td colspan="8">
					<cfif attributes.form_varmi eq 1><cf_get_lang dictionary_id='57484.Kayıt Yok'><cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif>!
                </td>
			</tr>
		</cfif>
	</tbody>
</cf_medium_list>
<script type="text/javascript">
	function getDetail(UTILITY_ID, UTILITY_NAME, DEVELOPER, VERSION, DETAIL, IS_THREEPOINT, THREEPOINT_DATA, IS_AUTOCOMPLETE, AUTOCOMPLETE_DATA, IS_METHODQUERY, METHODQUERY_DATA) {
		$("#utility_detail_div" + UTILITY_ID).html($("#detailFormBase").html());
		$('#utility_detail' + UTILITY_ID).toggle();
		$("#UTILITY_ID").text(UTILITY_ID);
		$("#UTILITY_NAME").text(UTILITY_NAME);
		$("#DETAIL").text(DETAIL);
		$("#THREEPOINT_DATA").text(THREEPOINT_DATA);
		$("#AUTOCOMPLETE_DATA").text(AUTOCOMPLETE_DATA);
		$("#METHODQUERY_DATA").text(METHODQUERY_DATA);

	}
	function getToOpener() {
		<cfif isdefined("attributes.form_varmi") and getUtilities.recordcount>
			<cfloop from="1" to="#listlen(getUtilities.columnlist)#" index = "col">
				<cfif isDefined('attributes.#listGetAt(getUtilities.columnlist,col)#') and len(evaluate('attributes.#listGetAt(getUtilities.columnlist,col)#'))>
					<cfoutput>opener.#evaluate(listGetAt(getUtilities.columnlist,col))#.value = $("###listGetAt(getUtilities.columnlist,col)#").val();</cfoutput>
				</cfif>
			</cfloop>
		</cfif>
	}
</script>