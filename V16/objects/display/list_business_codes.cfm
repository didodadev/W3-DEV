<cf_get_lang_set module_name="ehesap"><!--- sayfanin en altinda kapanisi var --->

<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.status_id" default="1">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.modal_id" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isdefined("attributes.is_form_submitted")>
	<cfquery name="get_business_codes" datasource="#DSN#">
		WITH CTE1 AS (
			SELECT	
				BUSINESS_CODE_ID,
				BUSINESS_CODE,
				BUSINESS_CODE_NAME 
			FROM 
				SETUP_BUSINESS_CODES
			WHERE
				1=1
				<cfif len(attributes.keyword)>	
					AND BUSINESS_CODE LIKE <cfif len(attributes.keyword) gt 1><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
					OR BUSINESS_CODE_NAME LIKE <cfif len(attributes.keyword) gt 1><cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"><cfelse><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.keyword#%"></cfif>
				</cfif>
				<cfif len(attributes.status_id)>
					AND IS_ACTIVE = <cfqueryparam cfsqltype="cf_sql_bit" value="#attributes.status_id#">
				</cfif>
		),
            CTE2 AS (
            	SELECT
                	CTE1.*,
                    	ROW_NUMBER() OVER (	ORDER BY
                        	BUSINESS_CODE_NAME
                      	) AS RowNum,(SELECT COUNT(*) FROM CTE1) AS QUERY_COUNT
               	FROM
                	CTE1
           		)
                SELECT
                    CTE2.*
               	FROM
                	CTE2
				WHERE
					RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
	</cfquery>
<cfelse>
	<cfset get_business_codes.query_count = 0>
</cfif>
<cfparam name="attributes.totalrecords" default='#get_business_codes.query_count#'>

<cfscript>
	url_string = "";
	if (isdefined('attributes.is_form_submitted'))
		url_string = "#url_string#&is_form_submitted=1";
	if (isdefined("attributes.field_id"))
		url_string = "#url_string#&field_id=#attributes.field_id#";
	if (isdefined("attributes.field_name"))
		url_string = "#url_string#&field_name=#attributes.field_name#";
</cfscript>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12"> 
	<cf_box title="#getLang('','Meslek Kodları','53840')#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cf_wrk_alphabet keyword="url_string" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform action="#request.self#?fuseaction=#ListFirst(attributes.fuseaction,'.')#.popup_list_business_codes#url_string#" method="post" name="search">
			<cfinput type="hidden" name="is_form_submitted" value="1">
			<div class="ui-form-list flex-list">
				<div class="form-group large" id="item-keyword">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="50">
				</div>				
				<div class="form-group" id="item-status">		
					<select name="status_id" id="status_id">
						<option value=""><cf_get_lang dictionary_id='57708.Tümü'></option>
						<option value="1" <cfif attributes.status_id eq 1>selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
						<option value="0" <cfif attributes.status_id eq 0>selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>
					</select>
				</div>	
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" is_excel="0" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</div>
			<cfif (len(attributes.keyword))>
				<cfset url_string = "#url_string#&keyword=#attributes.keyword#">
			</cfif>
			<cfif (len(attributes.status_id))>
				<cfset url_string = "#url_string#&status_id=#attributes.status_id#">
			</cfif>
		</cfform>
		<cf_ajax_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='58585.Kod'></th>
					<th><cf_get_lang dictionary_id='53861.Meslek Grubu'></th>
				</tr>
			</thead>
			<tbody>
				<cfif len(get_business_codes.query_count) and get_business_codes.query_count and isdefined("attributes.is_form_submitted")>
					<cfoutput query="get_business_codes">
						<tr>
							<td>#business_code#</td>
							<td><a href="javascript://" onClick="gonder('#business_code_id#','#business_code#','#business_code_name#')">#business_code_name#</a></td>
						</tr>
					</cfoutput>
				</cfif>
			</tbody>
		</cf_ajax_list>
		<cfif attributes.totalrecords gt attributes.maxrows and isdefined('attributes.is_form_submitted')>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="#ListFirst(attributes.fuseaction,'.')#.popup_list_business_codes#url_string#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	$('#keyword').focus();
	function gonder(id,code,name)
	{
		
		<cfif isdefined("field_id")>
		if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_id#</cfoutput>') != undefined)
		{
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_id#</cfoutput>').value = id;
		}	
		else
		{
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_id#</cfoutput>.value = id;
		}
		</cfif>
		<cfif isdefined("field_name")>
		if(<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_name#</cfoutput>') != undefined)
		{
			<cfif isdefined("attributes.draggable")>document<cfelse>window.opener.document</cfif>.getElementById('<cfoutput>#field_name#</cfoutput>').value = name + ' (' + code + ')';
		}	
		else
		{
			<cfif isdefined("attributes.draggable")>document<cfelse>opener</cfif>.<cfoutput>#field_name#</cfoutput>.value = name + ' (' + code + ')';
		}
		</cfif>
		<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable('<cfoutput>#attributes.modal_id#</cfoutput>');</cfif>
		
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#"><!--- sayfanin en ustunde acilisi var --->