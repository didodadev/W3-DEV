<!--- Pozisyon Tipinin Iliskili Olcme Degerlendirme Formlari Yeni Bir Tabloyla Ilıskilendirildigi Icin Query Degistirildi --->
<cfquery name="GET_POSCAT_EMPQUIZ" datasource="#dsn#">
SELECT 
	RELATION_FIELD_ID,
	RELATION_ACTION_ID
FROM 
	RELATION_SEGMENT_QUIZ
WHERE 
    RELATION_ACTION_ID = #attributes.poscat_id#
</cfquery>
<cfset quiz_id_list = valuelist(GET_POSCAT_EMPQUIZ.RELATION_FIELD_ID)>
<cfif ListFind(quiz_id_list,attributes.QUIZ_ID)>
  <script type="text/javascript">
    alert("<cf_get_lang no ='1792.Seçtiğiniz Form ilgili Poziyon Tipine Eklidir'> !");
	history.back();
	window.close();
  </script>
  <cfabort>
</cfif>
<cfif not ListFind(quiz_id_list,attributes.QUIZ_ID)>
	<cfquery name="ADD_POSCAT_EMPQUIZ" datasource="#dsn#">
		INSERT INTO 
			RELATION_SEGMENT_QUIZ
		(
			RELATION_TABLE,
			RELATION_FIELD_ID,
			RELATION_ACTION,
			RELATION_ACTION_ID,
			RELATION_YEAR
		)VALUES
		(
			'EMPLOYEE_QUIZ',
			#attributes.quiz_id#,
			3,
			#attributes.poscat_id#,
			NULL
		)
	</cfquery>
</cfif>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
<!---//Pozisyon Tipinin Iliskili Olcme Degerlendirme Formlari Yeni Bir Tabloyla Ilıskilendirildigi Icin Query Degistirildi --->

<!--- <cfquery name="GET_POSCAT_EMPQUIZ" datasource="#dsn#">
SELECT 
	QUIZ_ID,
	POSITION_CAT_ID
FROM 
	EMPLOYEE_QUIZ
WHERE 
    QUIZ_ID = #attributes.QUIZ_ID#
</cfquery>

<cfif not isdefined("attributes.poscat_id")>
  <script type="text/javascript">
    alert("<cf_get_lang no ='1739.Seçtiğiniz form başvuru formu değil'> !!");
	history.back();
  </script>
  <cfabort>
</cfif>
<cfif ListContains(GET_POSCAT_EMPQUIZ.POSITION_CAT_ID, attributes.poscat_id) eq 0>
	<cfset new_poscat_list = ListSort(ListAppend(GET_POSCAT_EMPQUIZ.POSITION_CAT_ID, attributes.poscat_id),"numeric")>
	<cfquery name="UPD_POSCAT_EMPQUIZ" datasource="#dsn#">
	UPDATE 
		EMPLOYEE_QUIZ
	SET
		POSITION_CAT_ID = ',#new_poscat_list#,'
	WHERE 
		QUIZ_ID = #attributes.QUIZ_ID#
	</cfquery>
</cfif>

<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>

 --->
