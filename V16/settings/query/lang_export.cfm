<cfsetting enablecfoutputonly="yes" requesttimeout="3600">
	<cfprocessingdirective suppresswhitespace="Yes">
        <cfif FileExists("#index_folder#CustomTags#dir_seperator#xml#dir_seperator#language.csv")>
            <cffile action="rename" source="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#language.csv" destination="#index_folder#CustomTags#dir_seperator#xml#dir_seperator##dateformat(now(),'ddmmyyyyhhmm')#_language.csv">
        </cfif>
        <cfquery name="DB_COLUMNS" datasource="#DSN#">
            SELECT name FROM syscolumns WHERE id = object_id(N'[SETUP_LANGUAGE_TR]') ORDER BY colorder
        </cfquery>
        <cfoutput query="DB_COLUMNS">
        	<cfset column_list = listDeleteAt(valueList(DB_COLUMNS.name,';'),1,';')><!---DictionaryId alanını almamak için kaldırıldı.--->
        	<cffile action="write" charset="utf-8" file="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#language.csv" output="#column_list#" addnewline="yes">
        </cfoutput>
        <cfquery name="GET_LANGUAGE_ITEM" datasource="#DSN#"> 
            SELECT * FROM SETUP_LANGUAGE_TR ORDER BY MODULE_ID,ITEM_ID
        </cfquery>
        <cfoutput query="GET_LANGUAGE_ITEM">
            <cfset GET_LANGUAGE_ITEM.ITEM = replace("#ITEM#",chr(13)&chr(10),"","ALL")> 
<cfset GET_LANGUAGE_ITEM.ITEM = replace("#ITEM#","'","''","ALL")> 
	<cfset GET_LANGUAGE_ITEM.ITEM_TR = replace("#ITEM_TR#","'","''","ALL")>   
<cfset GET_LANGUAGE_ITEM.ITEM_ENG = replace("#ITEM_ENG#","'","''","ALL")> 
<cfset GET_LANGUAGE_ITEM.ITEM_DE = replace("#ITEM_DE#","'","''","ALL")> 
<cfset GET_LANGUAGE_ITEM.ITEM_ARB = replace("#ITEM_ARB#","'","''","ALL")> 
<cfset GET_LANGUAGE_ITEM.ITEM_ES = replace("#ITEM_ES#","'","''","ALL")> 
<cfset GET_LANGUAGE_ITEM.ITEM_RUS = replace("#ITEM_RUS#","'","''","ALL")> 
<cfset GET_LANGUAGE_ITEM.ITEM_UKR = replace("#ITEM_UKR#","'","''","ALL")> 
            <cffile action="append" charset="utf-8" file="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#language.csv" output="#ITEM_ID#;#MODULE_ID#;#ITEM#;#ITEM_TR#;#ITEM_ARB#;#ITEM_DE#;#ITEM_ENG#;#ITEM_ES#;#ITEM_RUS#;#ITEM_UKR#" addnewline="yes">
        </cfoutput>
    </cfprocessingdirective>
<cfsetting enablecfoutputonly="no">
<script type="text/javascript">
	alert("<cf_get_lang no ='2534.Dosya CustomTags altında XML altında Language CSV Dosyası Oluşturuldu'> !");
	history.back();
</script>
