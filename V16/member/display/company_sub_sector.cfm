<cfsetting showdebugoutput="no">
<cfquery name="GET_SUB_SECTOR" datasource="#DSN#">
	SELECT SECTOR_CAT,SECTOR_CAT_ID,SECTOR_CAT_CODE FROM SETUP_SECTOR_CATS WHERE SECTOR_UPPER_ID = #attributes.upSector#
</cfquery>

<select name="subCompanySector" id="subCompanySector" style="width:300px;height:100px;" multiple="multiple" size="5">
   <cfoutput query="GET_SUB_SECTOR">
        <option value="#SECTOR_CAT_ID#">#IIf(len(SECTOR_CAT_CODE), DE(SECTOR_CAT_CODE), DE(""))# #SECTOR_CAT#</option>
   </cfoutput>
</select>
<cfabort>
