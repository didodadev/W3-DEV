<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8">
<html>
<head>
	<title>Workcube </title>
</head>
<body>
<cfif isdefined("dsn")>
	<cfset dsnnew = DSN>
<cfelse>
	<cfset dsnnew = caller.DSN>
</cfif>
<cfquery name="GET_CONTENT" datasource="#dsnnew#">
	SELECT 
		CCH.CONTENTCAT_ID, 
		CCH.CHAPTER,
		CC.CONTENTCAT, 
		C.CONTENT_ID,
		C.CONT_HEAD,
		C.RECORD_DATE,
		C.CONT_SUMMARY,
		C.CONT_BODY,
		C.CONT_POSITION,
		C.CONSUMER_CAT,
		C.COMPANY_CAT,
		C.CHAPTER_ID 
	FROM 
		CONTENT C ,
		CONTENT_CAT CC, 
		CONTENT_CHAPTER CCH
	WHERE 
		C.CHAPTER_ID = CCH.CHAPTER_ID AND
		CCH.CONTENTCAT_ID = CC.CONTENTCAT_ID	 
		<cfif isDefined("url.cntid")>
			AND 
				C.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.cntid#">
		<cfelseif isDefined("form.cntid")>
			AND 
				C.CONTENT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.cntid#">
		</cfif>
	ORDER BY 
		C.RECORD_DATE DESC
</cfquery>

<cfoutput query="get_content">
	<table>
		<tr>
			<td>
				#form.detail#
			</td>
		</tr>
		<tr>
			<td>
				#cont_head#	
			</td>
		</tr>
		<tr>
			<td>
				#cont_body# 
			</td>
		</tr>
	</table>
</cfoutput>
</body>
</html>

