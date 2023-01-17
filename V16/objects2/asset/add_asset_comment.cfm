<cfparam name="xfa.video_detail" default="objects2.detail_video" />
<cfset cmp=createObject("component","objects2.asset.query.CommentData").init(dsn) />
<cfset cmp.AddComment(1,attributes.asset_id,attributes.body,attributes.responseof) />
<!--- <cflocation url="#request.self#?fuseaction=#xfa.video_detail#&video_id=#attributes.asset_id#" addtoken="no" /> --->
