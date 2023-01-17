<cfquery name="GET_COLUMNS" datasource="#DSN#">
    SELECT   
        c.name AS ColumnName,
        C.user_type_id ColumnType
    FROM 
        sys.columns c
        inner join sys.tables t ON c.object_id = t.object_id
    WHERE
        t.name = 'WRK_OBJECTS'
        AND c.is_identity <> 1
   	ORDER BY 
        ColumnName
</cfquery>
<!--- DETAIL KOLONU BOS GELSIN DIYE BU SEKILDE YAZILDI LUTFEN DEGISTIRMEYIN --->
<cfquery name="GET_FUSEACTION" datasource="#DSN#">
	SELECT '' DETAIL,1 AS AUTHOR,*  FROM WRK_OBJECTS WHERE IS_ACTIVE = 1 AND ISNULL(IS_SPECIAL,0) !=1 ORDER BY MODUL,FUSEACTION
</cfquery>
<cfif FileExists("#index_folder#CustomTags#dir_seperator#xml#dir_seperator#wrk_switchs.csv")>
	<cffile action="rename" source="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#wrk_switchs.csv" destination="#index_folder#CustomTags#dir_seperator#xml#dir_seperator##dateformat(now(),'ddmmyyyyhhmm')#_wrk_switchs.csv">
</cfif>
<cffile action="write" charset="utf-8" file="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#wrk_switchs.csv" output="#valuelist(get_columns.columnname,',')#" addnewline="yes">

<cfset outputlist = "">
<cfoutput query="GET_COLUMNS">
	<cfset outputlist = "#outputlist####columnname###;">
</cfoutput>
<cfsavecontent variable="outputlist_new">
	<cfoutput query="GET_FUSEACTION"><cfset loop_count = 0><cfloop list="#outputlist#" index="kk" delimiters=";"><cfset ++loop_count><cfif GET_COLUMNS.ColumnType[loop_count] eq 231 or GET_COLUMNS.ColumnType[loop_count] eq 61><cfif len(rereplace(evaluate(kk),"'|;"," ","ALL"))>'#rereplace(evaluate(kk),"'|;"," ","ALL")#'<cfelse>NULL</cfif><cfelse><cfif len(evaluate(kk))>#evaluate(kk)#<cfelse>NULL</cfif></cfif><cfif loop_count neq GET_COLUMNS.recordcount>,</cfif></cfloop>#Chr(13) & Chr(10)#</cfoutput>
</cfsavecontent>
<cffile action="append" charset="utf-8" file="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#wrk_switchs.csv" output="#outputlist_new#" addnewline="yes">

<cfif FileExists("#download_folder#admin_tools#dir_seperator#xml#dir_seperator#wrk_switchs.csv")>
	<cffile action="delete" file="#download_folder#admin_tools#dir_seperator#xml#dir_seperator#wrk_switchs.csv">
</cfif>
<cffile action="copy" destination="#download_folder#admin_tools#dir_seperator#xml#dir_seperator#wrk_switchs.csv" source="#index_folder#CustomTags#dir_seperator#xml#dir_seperator#wrk_switchs.csv">

<script type="text/javascript">
	alert("Dosya CustomTags altında XML altında wrk_switchs.csv dosyası oluştururdu !");
	history.back();
</script>
