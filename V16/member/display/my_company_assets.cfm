<cfsetting showdebugoutput="no">
<cfset div_name_ = "body_box_physical_assets">
<cfquery name="get_physical_assets_list" datasource="#dsn#">
	SELECT 
    	ASSETP_ID,
		ASSETP,
		ASSETP_CATID,
		MAKE_YEAR,
		ASSETP_STATUS
    FROM 
    	ASSET_P 
    WHERE 
    	(
			SUP_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#"> OR
			<!--- Bireysel Uye ile iliskili partnerlari da getiriyor FBS 20101222 --->
			SUP_CONSUMER_ID IN (SELECT RELATED_CONSUMER_ID FROM COMPANY_PARTNER WHERE COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">) OR
			ASSETP_ID IN (SELECT ASSETP_ID FROM RELATION_ASSETP_MEMBER RAM WHERE RAM.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cpid#">)
		)
        <cfif isdefined('attributes.physical_keyword')> 
        	AND ASSETP LIKE '%#attributes.physical_keyword#%'
        </cfif>
    ORDER BY 
    	ASSETP_ID DESC
</cfquery>
<cfparam name="attributes.totalrecords" default="#get_physical_assets_list.recordcount#">
<cf_ajax_list_search>
<cf_ajax_list_search_area>
	<cfform>
	<table>
		<tr>
			<td>
                <input type="text" id="physical_keyword" name="physical_keyword" value="<cfif isdefined('attributes.physical_keyword')><cfoutput>#attributes.physical_keyword#</cfoutput></cfif>" style="width:100px;">
                <input type="button" name="gonder" id="gonder" value="Ara" onClick="connectAjax_physical();">
			</td>
		</tr>
	</table>
    </cfform>
</cf_ajax_list_search_area>
</cf_ajax_list_search>
<cf_ajax_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id='30212.Varlik_Adi'></th>
			<th><cf_get_lang dictionary_id='30217.Varlik_Tipi'></th>
			<th><cf_get_lang dictionary_id='58225.Model'></th>
			<th><cf_get_lang dictionary_id='57756.Durum'></th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="get_physical_assets_list" startrow="1"><!---maxrows="#attributes.maxrows#" FA--->
			<cfquery name="GET_ASSETP_CATS" datasource="#DSN#">
				SELECT ASSETP_CATID,ASSETP_CAT FROM ASSET_P_CAT WHERE ASSETP_CATID = #ASSETP_CATID#
			</cfquery>
			<tr>
				<td width="25%"><a href="javascript:gizle_goster(upd_assetp#assetp_id#);connectAjax('UPD_MY_COMPANY_ASSETS#assetp_id#','','#assetp_id#');" class="tableyazi">#ASSETP#</a></td>
				<td width="25%">#GET_ASSETP_CATS.ASSETP_CAT#</td>
				<td width="25%">#MAKE_YEAR#</td>
				<td width="25%">
					<cfif len(ASSETP_STATUS)>
						<cfquery name="GET_ASSET_STATE" datasource="#DSN#">
							SELECT ASSET_STATE_ID,ASSET_STATE FROM ASSET_STATE WHERE ASSET_STATE_ID = #ASSETP_STATUS#
						</cfquery>
						#GET_ASSET_STATE.ASSET_STATE#
					</cfif>
				</td>
			</tr>
			<tr class="nohover" id="upd_assetp#assetp_id#" style="display:none;">
				<td colspan="4">
					<div align="left" id="UPD_MY_COMPANY_ASSETS#assetp_id#"></div>
				</td>
			</tr>
		</cfoutput>
		<cfif not get_physical_assets_list.recordcount>
			<tr>
				<td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
			</tr>
		</cfif>
	</tbody>
</cf_ajax_list>
<script type="text/javascript">
	function connectAjax_physical()
	{	
		addr_ = '<cfoutput>#request.self#?fuseaction=member.popupajax_my_company_assets&physical_keyword=</cfoutput>' + document.getElementById('physical_keyword').value + '<cfif len(attributes.cpid)>&cpid=<cfoutput>#attributes.cpid#</cfoutput></cfif>';
		alert(<cfoutput>#div_name_#</cfoutput>);
		AjaxPageLoad(addr_,'<cfoutput>#div_name_#</cfoutput>',1);
	}
</script>
<cfabort>
