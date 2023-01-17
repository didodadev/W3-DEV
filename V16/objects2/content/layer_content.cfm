<cfif len(attributes.layer_content_width) and len(attributes.layer_content_height) and len(attributes.layer_content_cid)>
	<cfquery name="GET_CONTENT" datasource="#DSN#" maxrows="1">
		SELECT
			C.CONTENT_ID,
			C.CONT_HEAD,
			C.CONT_BODY,
			C.CONT_SUMMARY, 
			C.RECORD_MEMBER,
			C.UPDATE_MEMBER,
			C.HIT,
			C.HIT_PARTNER,
			C.IS_DSP_HEADER,
			C.IS_DSP_SUMMARY,
			OUTHOR_EMP_ID,
			OUTHOR_CONS_ID,
			OUTHOR_PAR_ID,
			WRITING_DATE
		FROM
			CONTENT C
		WHERE 
			C.STAGE_ID = -2 AND	 
			C.CONTENT_STATUS = 1 AND
			<cfif isdefined("session.pp.company_category")>
				C.COMPANY_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.pp.company_category#,%"> AND
			<cfelseif isdefined("session.ww.consumer_category")>
				C.CONSUMER_CAT  LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#session.ww.consumer_category#,%"> AND
			<cfelseif isdefined("session.cp")>
				CAREER_VIEW = 1  AND
			<cfelse>
				INTERNET_VIEW = 1  AND
			</cfif>
			C.CONTENT_ID = <cfqueryparam value="#attributes.layer_content_cid#" cfsqltype="cf_sql_integer">
		ORDER BY
			C.CONTENT_ID DESC
	</cfquery>
    <cfif isdefined("session.ww") and len(get_content.hit)>
	  <cfset hit_ = get_content.hit + 1>
	<cfelse>
	  <cfset hit_ = 1>
	</cfif>
	<cfif isdefined("session.pp") and len(get_content.hit_partner)>
	  <cfset hit_partner_ = get_content.hit_partner + 1>
	<cfelse>
	  <cfset hit_partner_ = 1>
	</cfif>
	<cfquery name="HIT_UPDATE" datasource="#dsn#">
		UPDATE
			CONTENT
		SET
			<cfif isdefined("session.ww")>HIT = #hit_#,</cfif>
			<cfif isdefined("session.pp")>HIT_PARTNER = #hit_partner_#,</cfif>
			LASTVISIT = #now()#
		WHERE
			CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.layer_content_cid#">
	</cfquery>
<cfelse>
	<cfexit method="exittemplate">
</cfif>
<cfoutput>
	<style type="text/css">
	##layer_content_div_#attributes.layer_content_cid#
	{
	position:relative;
	width:#attributes.layer_content_width#px;
	height:#attributes.layer_content_height#px;
	background-color:##cccccc;
	border-right:1px solid ##000000;
	border-bottom:1px solid ##000000;
	border-left:1px solid ##000000;
	border-top:1px solid ##000000;
	position:absolute;
	z-index:10;
	visibility:hidden;
	}
	.layer_content_header_#attributes.layer_content_cid#
	{
	background-image:url(/images/print.gif);
	display:table-cell;
	height:25px;
	width:35px;
	background-repeat:repeat-x;
	}
	</style>
<div id="layer_content_div_#attributes.layer_content_cid#" onMouseOut="workcube_showHideLayers('layer_content_div_#attributes.layer_content_cid#','','hide');" onMouseOver="workcube_showHideLayers('layer_content_div_#attributes.layer_content_cid#','','show');">
	<a href="##" class="layer_content_header_#attributes.layer_content_cid#"></a><br/>
	<cfif get_content.is_dsp_header eq 0><span class="headbold">#cont_head#</span><br/><br/></cfif>
	#get_content.cont_body#
</div>
<a href="##" onMouseOver="workcube_showHideLayers('layer_content_div_#attributes.layer_content_cid#','','show');" class="layer_content_header_#attributes.layer_content_cid#"></a>
</cfoutput>

