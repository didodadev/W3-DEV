<cfparam name="attributes.is_active" default="1">
<cfparam name="attributes.keyword" default="">
<cfset url_string = "">
<cfif isdefined("attributes.branch_id")>
	<cfset url_string = "#url_string#&branch_id=#attributes.branch_id#">
</cfif>
<cfif isdefined("attributes.branch_name")>
	<cfset url_string = "#url_string#&branch_name=#attributes.branch_name#">
</cfif>
<cfif isdefined("attributes.our_company_id")>
	<cfset url_string = "#url_string#&our_company_id=#attributes.our_company_id#">
</cfif>
<cfif isdefined("attributes.our_company_name")>
	<cfset url_string = "#url_string#&our_company_name=#attributes.our_company_name#">
</cfif>
<cfif isdefined("attributes.without_self_branch")>
	<cfset url_string = "#url_string#&without_self_branch=#attributes.without_self_branch#">
</cfif>

<cfquery name="get_branch_names" datasource="#dsn#">
	SELECT 
		B.BRANCH_ID,
		B.BRANCH_NAME,
		O.NICK_NAME,
		O.COMP_ID
	FROM 
		BRANCH B,
		OUR_COMPANY O
	WHERE 
		B.COMPANY_ID = O.COMP_ID 
		<cfif isdefined("attributes.search_our_company_id") and len(attributes.search_our_company_id)>
			AND O.COMP_ID = #attributes.search_our_company_id# 
		</cfif>
		<cfif not session.ep.ehesap>
			AND B.BRANCH_ID IN (	SELECT
										BRANCH_ID
									FROM
										EMPLOYEE_POSITION_BRANCHES
									WHERE
										POSITION_CODE = #SESSION.EP.POSITION_CODE#
								)
		</cfif>
		<cfif isdefined("attributes.without_self_branch") and len(attributes.without_self_branch)>
			AND B.BRANCH_ID <> #attributes.without_self_branch#
		</cfif>
		<cfif isDefined("attributes.is_active") and len(attributes.is_active)>
			AND B.BRANCH_STATUS = #attributes.is_active#
		</cfif>
		<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
			AND B.BRANCH_NAME LIKE '<cfif len(attributes.keyword) gt 1>%</cfif>#attributes.keyword#%'
		</cfif>
	ORDER BY
		O.NICK_NAME,
		B.BRANCH_NAME
</cfquery>
<cfquery name="get_company_name" datasource="#dsn#">
	SELECT
		NICK_NAME,
		COMPANY_NAME,
		COMP_ID	
	FROM
		OUR_COMPANY
	ORDER BY
		COMPANY_NAME
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_branch_names.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<script type="text/javascript">
	function gonder(b_id,b_name,our_comp_id,our_comp_name)
	{
		<cfoutput>
		<cfif isdefined("branch_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.#branch_id#.value = b_id;
		</cfif>
		<cfif isdefined("branch_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.#branch_name#.value = b_name;
		</cfif>
		<cfif isdefined("our_company_id")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.#our_company_id#.value = our_comp_id;
		</cfif>
		<cfif isdefined("our_company_name")>
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.#our_company_name#.value = our_comp_name;
		</cfif>
        <cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		</cfoutput>
	}
</script>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='29434.Şubeler'></cfsavecontent>
    <cf_box title="#message#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">

        <cfform name="search" action="#request.self#?fuseaction=objects.popup_list_related_branches#url_string#" method="post">
            <cf_box_search>
                <div class="form-group" id="item-keyword">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput type="text" tabindex="1" name="keyword" id="keyword" value="#attributes.keyword#" maxlength="255"  placeholder="#message#">
                </div>
                <div class="form-group" id="item-search_our_company_id">
					<select name="search_our_company_id" id="search_our_company_id">
                        <option value=""><cf_get_lang dictionary_id='57734.Seçiniz'></option>
                        <cfoutput query="get_company_name">
                            <option value="#comp_id#" <cfif isdefined("attributes.search_our_company_id") and attributes.search_our_company_id eq comp_id>selected</cfif>>#nick_name#</option>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group" id="item-is_active">
					<select name="is_active" id="is_active" >
                        <option value=""><cf_get_lang dictionary_id='57708.Tümü'>
                        <option value="1" <cfif attributes.is_active eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'>
                        <option value="0" <cfif attributes.is_active eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'>
                    </select>
                </div>
                <div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" tabindex="3" name="maxrows" id="maxrows" required="yes" value="#attributes.maxrows#"  validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4" is_excel="0" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
                </div>
            </cf_box_search>
        </cfform>
        <cfif len(attributes.keyword)>
            <cfset url_string = "#url_string#&keyword=#attributes.keyword#">
        </cfif>
        <cfif isdefined("attributes.search_our_company_id")>
            <cfset url_string = "#url_string#&search_our_company_id=#attributes.search_our_company_id#">
        </cfif>
        <cfif isdefined("attributes.is_active")>
            <cfset url_string = "#url_string#&is_active=#attributes.is_active#">
        </cfif>
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="200"><cf_get_lang dictionary_id='57574.Şirket'></th>
                    <th><cf_get_lang dictionary_id='57453.Şube'></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_branch_names.recordcount>
                    <cfoutput query="get_branch_names" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#nick_name#</td>
                            <td><a href="javascript://" onClick="gonder('#branch_id#','#BRANCH_NAME#','#comp_id#','#NICK_NAME#');<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>" class="tableyazi">#branch_name#</a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="3"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>
        <cfif attributes.totalrecords gt attributes.maxrows>
            <cf_paging 
            page="#attributes.page#" 
            maxrows="#attributes.maxrows#" 
            totalrecords="#attributes.totalrecords#" 
            startrow="#attributes.startrow#" 
            adres="objects.popup_list_related_branches#url_string#"
            isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
		
    </cfif>
</cf_box>
<script type="text/javascript">
	document.getElementById('keyword').focus();
</script>
