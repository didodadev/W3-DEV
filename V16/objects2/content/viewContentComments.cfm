<!--- <script type="text/javascript">
	function connectAjax(div_id,data)
	{
		if (div_id == 'list_my_content_comment')//icerik yorumlari
			var page = '<cfoutput>#attributes.content_detail#?cid=#attributes.cid#</cfoutput>';

		AjaxPageLoad(page,''+div_id+'',0);
	}
</script> --->

<cfif not isdefined("attributes.content_id")>
	<cfset attributes.content_id = #attributes.cid#>
</cfif>
<cfquery name="GET_CONTENT_COMMENTS" datasource="#DSN#">
	SELECT 
		NAME,
		SURNAME,
		CONTENT_COMMENT,
		RECORD_DATE
	FROM
		CONTENT_COMMENT
	WHERE
		STAGE_ID = -2 AND
		CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.cntid#">
	ORDER BY
		RECORD_DATE DESC
</cfquery>
<div class="comment_item">
	<!--- <cfif get_content_comments.recordcount>
		<a href="javascript:gizle_goster(addComment);">Yorum Ekle</a>
	<cfelse>
	</cfif> --->
	<div class="comment_item_title">
		Yorumlar
	</div>
	<cfif get_content_comments.recordcount>
		<cfoutput query="get_content_comments" maxrows="4">
				<div class="comment_item_text">
					<div class="comment_item_name">
						#name# #surname#
						<span>#dateformat(record_date,'dd/mm/yyyy')#, #timeformat(record_date,'HH:mm')#</span>
					</div>
					<div class="comment_item_content">
						<p>#content_comment#</p>
					</div>
				</div>			
		</cfoutput>
	</cfif>
	<div class="comment-form">
		<cfinclude template="add_cont_comment.cfm">
	</div>
</div>
<!--- id="commentFail" --->

