<cfif isdefined("attributes.product_id")>
	<cfset attributes.pid = attributes.product_id>
</cfif>
<cflock name="#CreateUUID()#" timeout="20">
  	<cftransaction>
		<cfquery name="GET_CONTENT_PROD" datasource="#DSN#" maxrows="1">
            SELECT 
                CONTENT_RELATION.*, 
                C.CONT_HEAD,
                C.CONT_SUMMARY,
                C.CONT_BODY,
                C.HIT,
                C.HIT_PARTNER,
                C.IS_DSP_HEADER,
                C.IS_DSP_SUMMARY
            FROM 
                CONTENT_RELATION, 
                CONTENT C,
                CONTENT_CHAPTER CH,
                CONTENT_CAT CC
            WHERE 
                C.CHAPTER_ID = CH.CHAPTER_ID AND
                CH.CONTENTCAT_ID = CC.CONTENTCAT_ID AND
                CC.IS_RULE <> 1 AND
                CC.CONTENTCAT_ID <> 0 AND
                C.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session_base.language#"> AND
                CONTENT_RELATION.CONTENT_ID = C.CONTENT_ID AND
                CONTENT_RELATION.ACTION_TYPE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.pid#"> AND  
                CONTENT_RELATION.ACTION_TYPE = 'PRODUCT_ID' AND
                C.STAGE_ID = -2
                <cfif isdefined("session.pp.company_category")>
                    AND ','+C.COMPANY_CAT+','  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%"> 
                <cfelseif isdefined("session.ww.consumer_category")>
					AND ','+C.CONSUMER_CAT+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.consumer_category#,%">
                <cfelseif isdefined("session.cp")>
                    AND C.CAREER_VIEW = 1  
                <cfelse>
                    AND C.INTERNET_VIEW = 1  
                </cfif> 
                <cfif isdefined('attributes.is_content_type_id') and len(attributes.is_content_type_id)>
                    AND C.CONTENT_PROPERTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_content_type_id#">
                </cfif>
            ORDER BY
                C.PRIORITY
        </cfquery>
        <cfif isdefined("session.ww") and len(get_content_prod.hit)>
          	<cfset hit_ = get_content_prod.hit + 1>
        <cfelse>
          	<cfset hit_ = 1>
        </cfif>
        <cfif isdefined("session.pp") and len(get_content_prod.hit_partner)>
          	<cfset hit_partner_ = get_content_prod.hit_partner + 1>
        <cfelse>
          	<cfset hit_partner_ = 1>
        </cfif>
        <cfif get_content_prod.recordcount>
            <cfquery name="HIT_UPDATE" datasource="#DSN#">
                UPDATE
                    CONTENT
                SET
                    <cfif isdefined("session.ww")>HIT = #hit_#,</cfif>
                    <cfif isdefined("session.pp")>HIT_PARTNER = #hit_partner_#,</cfif>
                    LASTVISIT = #now()#
                WHERE
                    CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_content_prod.content_id#">
            </cfquery>
        </cfif>
  	</cftransaction>
</cflock>

<cfif get_content_prod.recordcount>
	<cfoutput query="get_content_prod">
	<table align="center" style="width:100%;">
    	<tr>
			<td>
			<cfif get_content_prod.is_dsp_header eq 0>
		  		<span class="headbold">#cont_head#</span>
			</cfif>
			</td>
	  	</tr>
	  	<cfif get_content_prod.is_dsp_summary eq 0>
			<tr>
				<td>#cont_summary#<br/><br/></td>
		  	</tr>
	  	</cfif>
	  	<cfif attributes.is_body eq 1>
		  	<tr>
				<td>#cont_body#</td>
		  	</tr>
	  	</cfif>
	  	<tr>
			<cfif attributes.is_content_webmail eq 1>
				<td style="vertical-align:top;"><cfinclude template="../content/content_webmail.cfm"></td>
			</cfif>
			<cfif attributes.is_content_print eq 1>
				<td style="text-align:right; vertical-align:top;"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects2.popup_operate_page&operation=emptypopup_temp_detail_content&action=print&id=#get_content_prod.content_id#&module=objects2','page');return false;"><img src="objects2/image/button_print.gif" border="0" align="absmiddle" title="<cf_get_lang_main no='62.Yazdır'>"></a></td>
			</cfif>
	  	</tr>
	</table>
	</cfoutput>
</cfif>
