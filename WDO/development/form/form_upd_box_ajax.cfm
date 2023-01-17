<cfquery name="GET_WRK_FUSEACTIONS" datasource="#DSN#">
	 SELECT
	 	WRK_OBJECTS_ID, 
		BASE,
		MODUL,
		MODUL_SHORT_NAME,
		FUSEACTION,
		HEAD,
        FRIENDLY_URL,
		FOLDER,
		FILE_NAME,
		STAGE,
		TYPE,
		WINDOW,
		SECURITY,
		STATUS,
		VERSION,
		AUTHOR,
        DETAIL,
        LEFT_MENU_NAME,
		RECORD_IP,
		RECORD_EMP,
		RECORD_DATE,
		UPDATE_IP,
		UPDATE_EMP,
		UPDATE_DATE,
		IS_ACTIVE,
        RELATED_FUSEACTION,
        RELATED_MODUL_SHORT_NAME,            
        LEFT_MENU_NAME,
        DESTINATION_MODUL,
		OBJECTS_COUNT,
        IS_WBO_DENIED,
		IS_WBO_LOCK,
		IS_WBO_LOG,
        IS_ADD,
        IS_UPDATE,
        IS_DELETE,
        IS_SPECIAL
	FROM
		WRK_OBJECTS
	WHERE 
		WRK_OBJECTS_ID = #attributes.woid#
</cfquery>
<cfquery name="GET_FUSEACTION_RELATION" datasource="#DSN#">
    SELECT
        WRK_OBJECTS_ID, 
        BASE,
        MODUL,
        MODUL_SHORT_NAME,
        FUSEACTION,
        HEAD,
        FRIENDLY_URL,
        FOLDER,
        FILE_NAME,
        STAGE,
        TYPE,
        WINDOW,
        SECURITY,
        STATUS,
        VERSION,
        AUTHOR,
        DETAIL,
        RECORD_IP,
        RECORD_EMP,
        RECORD_DATE,
        UPDATE_IP,
        UPDATE_EMP,
        UPDATE_DATE,
        IS_ACTIVE,
        ISNULL(RELATED_FUSEACTION,'NULL') RELATED_FUSEACTION,
        ISNULL(RELATED_MODUL_SHORT_NAME,'NULL') RELATED_MODUL_SHORT_NAME,
        ISNULL(LEFT_MENU_NAME,'NULL') LEFT_MENU_NAME,
        IS_WBO_DENIED,
        IS_WBO_LOCK,
        IS_WBO_LOG
    FROM
        WRK_OBJECTS
    WHERE
        RELATED_FUSEACTION = '#GET_WRK_FUSEACTIONS.FUSEACTION#' AND
        RELATED_MODUL_SHORT_NAME = '#GET_WRK_FUSEACTIONS.MODUL_SHORT_NAME#'
</cfquery>
<table width="99%">
				<tr>
					<td align="left">
						<cfoutput query="GET_WRK_FUSEACTIONS">
						<cfif not len(FRIENDLY_URL)>
                            <cfset FRIENDLY_URL_ = "NULL">
                        <cfelse>
	                        <cfset FRIENDLY_URL_ = "'#FRIENDLY_URL#'">
                        </cfif>
						<cfif not len(RELATED_FUSEACTION)>
                            <cfset RELATED_FUSEACTION_ = 'NULL'>
                        <cfelse>
	                        <cfset RELATED_FUSEACTION_ = '#RELATED_FUSEACTION#'>
                        </cfif>
                        <cfif not len(RELATED_MODUL_SHORT_NAME)>
                            <cfset RELATED_MODUL_SHORT_NAME_ = "NULL">
                        <cfelse>
	                        <cfset RELATED_MODUL_SHORT_NAME_ = "'#RELATED_MODUL_SHORT_NAME#'">
                        </cfif>
                        <cfif not len(LEFT_MENU_NAME)>
                            <cfset LEFT_MENU_NAME_ = "NULL">
                        <cfelse>
	                        <cfset LEFT_MENU_NAME_ = "'#LEFT_MENU_NAME#'">
                        </cfif>
                        <cfif not len(DETAIL)>
                            <cfset DETAIL_ = "NULL">
                        <cfelse>
	                        <cfset DETAIL_ = '#DETAIL#'>
                        </cfif>
                        <cfif len(FILE_NAME)>
	                        <cfset FILE_NAME_ = "NULL">
                        <cfelse>
	                        <cfset FILE_NAME_ = "'#FILE_NAME#'">
                        </cfif>           
	                    <cfset ins_query = "IF EXISTS(SELECT WRK_OBJECTS_ID FROM WRK_OBJECTS WHERE FUSEACTION = '#FUSEACTION#' AND MODUL='#MODUL#')
BEGIN
	UPDATE WRK_OBJECTS SET IS_ACTIVE=#IS_ACTIVE#,BASE='#BASE#',MODUL='#MODUL#',MODUL_SHORT_NAME='#MODUL_SHORT_NAME#',FUSEACTION='#FUSEACTION#',HEAD='#HEAD#',FOLDER='#FOLDER#',FRIENDLY_URL=#FRIENDLY_URL_#,FILE_NAME='#FILE_NAME#',STAGE=#STAGE#,TYPE='#TYPE#',WINDOW='#WINDOW#',SECURITY='#SECURITY#',STATUS='#STATUS#',VERSION='#VERSION#',AUTHOR=#AUTHOR#,DETAIL='#DETAIL#',RELATED_FUSEACTION=#'RELATED_FUSEACTION'#,RELATED_MODUL_SHORT_NAME='#RELATED_MODUL_SHORT_NAME#',LEFT_MENU_NAME='#LEFT_MENU_NAME#' WHERE FUSEACTION = '#FUSEACTION#' AND MODUL='#MODUL#'
END
	ELSE
BEGIN
">
						<cfset ins_query = "#ins_query#INSERT INTO WRK_OBJECTS 
	(IS_ACTIVE,BASE,MODUL,MODUL_SHORT_NAME,FUSEACTION,HEAD,FOLDER,FRIENDLY_URL,FILE_NAME,STAGE,TYPE,WINDOW,SECURITY,STATUS,VERSION,AUTHOR,DETAIL,RELATED_FUSEACTION,RELATED_MODUL_SHORT_NAME,LEFT_MENU_NAME,IS_WBO_DENIED,IS_WBO_LOCK)
VALUES
	(#IS_ACTIVE#,'#BASE#','#MODUL#','#MODUL_SHORT_NAME#','#FUSEACTION#','#HEAD#','#FOLDER#',#FRIENDLY_URL_#,'#FILE_NAME#',#STAGE#,'#TYPE#','#WINDOW#','#SECURITY#','#STATUS#','#VERSION#',#AUTHOR#,#DETAIL_#,#RELATED_FUSEACTION_#,#RELATED_MODUL_SHORT_NAME_#,#LEFT_MENU_NAME_#,0,0) END">
						<!---<cfset ins_query = '#ins_query##RELATED_FUSEACTION_#,#RELATED_MODUL_SHORT_NAME_#,#LEFT_MENU_NAME_#,0,0,0) END'>--->
						<textarea name="INSERT_TEXT" id="INSERT_TEXT" style="width:100%;height:65px" onclick="this.select();">#ins_query#</textarea>
						</cfoutput>
						<br />
					</td> 
				</tr> 
               </table>
