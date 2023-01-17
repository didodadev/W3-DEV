<cfsetting showdebugoutput="no">
<cfset new_rating=0 />
<cfset old_rating=0 />
<cfset ratingCount=0/>
<cfquery name="get_video_rating" datasource="#dsn#">
	SELECT RATING, RATING_COUNT FROM ASSET WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.video_id#">
</cfquery>
<cfif len(get_video_rating.RATING) and get_video_rating.RATING neq ''>
	<cfset old_rating = get_video_rating.RATING />
</cfif>
<cfif len(get_video_rating.RATING_COUNT) and get_video_rating.RATING_COUNT neq ''>
	<cfset get_video_rating.RATING_COUNT = get_video_rating.RATING_COUNT />
<cfelse>
	<cfset get_video_rating.RATING_COUNT = 0>
</cfif>
<cfset new_rating=((old_rating*get_video_rating.RATING_COUNT)+attributes.my_rating) / (get_video_rating.RATING_COUNT+1) />
<cfset ratingCount=get_video_rating.RATING_COUNT+1 />
<cfquery name="upd_video_rating" datasource="#dsn#">
	UPDATE ASSET SET RATING_COUNT = #ratingCount#, RATING=#new_rating# WHERE ASSET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.video_id#">
</cfquery>
