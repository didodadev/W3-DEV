<cfset xfa.video_detail = "objects2.detail_video" />
<cfset cmp=createObject("component","objects2.asset.query.CommentData").init(dsn) />
<cfset cmp.SetRating(attributes.comment_id, attributes.rating) />
<cflocation url="#request.self#?fuseaction=#xfa.video_detail#&video_id=#attributes.video_id#" addtoken="no" />
