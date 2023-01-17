<cfset cont = ReplaceList(attributes.template_content,chr(13),'')>
<cfset cont = ReplaceList(cont,chr(10),'')>
<cfset cont = ReplaceList(cont,"'","""")>

<cfquery name="INSTEMPLATE" datasource="#DSN#" result="MAX_ID">
	INSERT INTO 
	   TEMPLATE_FORMS
	   (
			TEMPLATE_HEAD,
			TEMPLATE_MODULE, 
			TEMPLATE_CONTENT,
			IS_LOGO,
			IS_PURSUIT_TEMPLATE,
			IS_LICENCE,
			RECORD_DATE,
			RECORD_EMP,
			RECORD_IP
	   )
	VALUES 
		(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.template_head#">,
			#attributes.module#,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#cont#">,
			<cfif isdefined('attributes.is_logo')>1<cfelse>0</cfif>,
			<cfif not isDefined("attributes.is_pursuit_template")>0<cfelse>1</cfif>,
			<cfif isdefined('attributes.is_licence')>1<cfelse>0</cfif>,
			#now()#,
			#session.ep.userid#,
			'#cgi.remote_addr#'
		)		
</cfquery>
<cfif isdefined('attributes.is_licence')>
	<cfquery name="UPD_OTHER_LICENCE" datasource="#dsn#">UPDATE TEMPLATE_FORMS SET IS_LICENCE = 0 WHERE TEMPLATE_ID <> MAX_ID.IDENTITYCOL</cfquery>
</cfif>

<cfquery name="GET_TEMPLATES" datasource="#DSN#">
	SELECT TEMPLATE_HEAD,TEMPLATE_CONTENT FROM TEMPLATE_FORMS ORDER BY TEMPLATE_HEAD
</cfquery>

<!---
<cfsavecontent variable="icerik">
<?xml version="1.0" encoding="utf-8" ?>
<Templates imagesBasePath="fck_template/images/">
	<cfoutput query="get_templates">
		<Template title="#TEMPLATE_HEAD#" image="template1.gif">
			<Description>#TEMPLATE_HEAD#</Description>
			<Html>
				<![CDATA[#TEMPLATE_CONTENT#]]>
			</Html>
		</Template>
	</cfoutput>
</Templates>
</cfsavecontent>
<cfset icerik = replace(trim(icerik),'&nbsp;',' ','all')>
<cfset icerik = replace(trim(icerik),'&','&amp;','all')>
<cffile action="write" file="#replace(index_folder,'\v16','')#\fckeditor\fcktemplates.xml" output="#toString(icerik)#" charset="utf-8">
--->

<cflocation url="#request.self#?fuseaction=settings.form_add_template" addtoken="no">
