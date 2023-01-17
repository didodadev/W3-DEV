<cfsetting enablecfoutputonly="yes">
<cfprocessingdirective suppresswhitespace="Yes">
<!--- 
Description			: (Değerlendirme formlarınının ilişkilendirilmesi)form generatorda tumu olarak iliskilendirilmis form tipleri icin  ilgili kaydı ilişkili alanlara ekler.
Parameters			:
	action_type		: form tipi:eğitim,cv,içerik... --- required
	action_type_id	:  ilgili kaydın id si--- required
Syntax				: <cf_add_content_relation action_type="#attributes.action_type#" action_type_id="#attributes.action_type_id#">
Created				: SG 20120920
--->
<cfparam name="attributes.data_source" default="#caller.dsn#">
<cfquery name="get_relation_content" datasource="#attributes.data_source#">
	SELECT  
		SURVEY_MAIN.SURVEY_MAIN_ID 
	FROM 
		CONTENT_RELATION,
		SURVEY_MAIN
	WHERE 
		SURVEY_MAIN.TYPE = #attributes.action_type# AND 
		RELATION_TYPE = #attributes.action_type# AND 
		RELATED_ALL = 1 AND
		SURVEY_MAIN.IS_ACTIVE = 1 AND
		SURVEY_MAIN.SURVEY_MAIN_ID = CONTENT_RELATION.SURVEY_MAIN_ID
</cfquery>
<cfif get_relation_content.recordcount>
	<cfoutput query="get_relation_content">
		<cfquery name="get_control" datasource="#attributes.data_source#">
			SELECT 
				RELATION_CAT	
			FROM 
				CONTENT_RELATION 
			WHERE 
				SURVEY_MAIN_ID = #get_relation_content.SURVEY_MAIN_ID# AND 
				RELATION_TYPE = #attributes.action_type# AND 
				RELATION_CAT = #attributes.action_type_id#
		</cfquery>
		<cfif not get_control.recordcount>
			<cfquery name="add_relation_cat" datasource="#caller.dsn#">
				INSERT INTO 
				CONTENT_RELATION
				(
					SURVEY_MAIN_ID,
					RELATION_CAT,
					RELATION_TYPE,
					RECORD_EMP,
					RECORD_DATE,
					RECORD_IP				
				)
				VALUES
				(
					#get_relation_content.survey_main_id#,
					#attributes.action_type_id#,
					#attributes.action_type#,
					#session.ep.userid#,
					#now()#,
					'#cgi.REMOTE_ADDR#'
				)
			</cfquery>
		</cfif>
	</cfoutput>
</cfif>
</cfprocessingdirective><cfsetting enablecfoutputonly="no">
