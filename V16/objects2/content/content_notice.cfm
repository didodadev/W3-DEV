<script type="text/javascript"><!--- bu javascript sağ tuş koruması sağlar ve ctrl + c yi yasaklar!! 06/07/2007 FS--->
	var omitformtags=["input", "textarea", "select"]
	omitformtags=omitformtags.join("|")
	function disableselect(e){
		if (omitformtags.indexOf(e.target.tagName.toLowerCase())==-1)
			return false
		}
	function reEnable(){
		return true
	}
	
	if (typeof document.onselectstart!="undefined")
	{
		//document.onselectstart=new Function ("return false")
	}
	else{
	}
		function click()
	{
	}
</script>
<script language="JavaScript1.2"><!-- Mozilla için text seçme koruması ... !--->
	function disabletext(e){
		return false
	}
	
	function reEnable(){
		return true
	}
	if (window.sidebar){
	}
</script>

<script type="text/javascript">
	function connectAjax()
	{
		var bb = "<cfoutput>#request.self#?fuseaction=objects2.emptypopup_get_body_query&content_id=#attributes.content_id#&is_body=1</cfoutput>";
		AjaxPageLoad(bb,'content_body_place');
	}
</script>
<cflock name="#CreateUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="GET_CONTENT" datasource="#DSN#" maxrows="1">
			SELECT
				C.CONTENT_ID,
				C.CONT_HEAD,
				C.CONT_BODY,
				C.CONT_SUMMARY, 
				C.RECORD_MEMBER,
				C.UPDATE_MEMBER,
				C.HIT,
				C.HIT_PARTNER 
			FROM
				CONTENT C
			WHERE 
				C.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_id#">
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
		<cfquery name="HIT_UPDATE" datasource="#DSN#">
			UPDATE
				CONTENT
			SET
				<cfif isdefined("session.ww")>HIT = #hit_#,</cfif>
				<cfif isdefined("session.pp")>HIT_PARTNER = #hit_partner_#,</cfif>
				LASTVISIT = #now()#
			WHERE
				CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.content_id#">
		</cfquery>
  	</cftransaction>
</cflock>
<cfif get_content.recordcount>
	<cfquery name="GET_IMAGE_CONT" datasource="#DSN#" maxrows="1">
		SELECT CONTIMAGE_SMALL, IMAGE_SERVER_ID FROM CONTENT_IMAGE WHERE CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_content.content_id#"> AND IMAGE_SIZE = 0
	</cfquery>
	<cfoutput query="get_content">
		<table width="100%" cellpadding="2" cellspacing="1" height="100%">
			<tr>
				<td valign="top">
			  		<cfif get_image_cont.recordcount>
						<cf_get_server_file output_file="content/#get_image_cont.contimage_small#" output_server="#get_image_cont.image_server_id#" output_type="0" alt="#getLang('main',668)#" title="#getLang('main',668)#"><br/><br/>
			  		</cfif>
			  		<div align="left" id="content_body_place"></div>
				 	<script type="text/javascript">
						connectAjax();
				 	</script>
				</td>
			</tr>
		</table>
	</cfoutput>
</cfif>
