<cfswitch expression = "#attributes.type#">
	<cfcase value="DB">    	
        <cfinclude template="UtilityDB.cfm">
    </cfcase>
    <cfcase value="Session">
    	<cfinclude template="UtilitySession.cfm">
    </cfcase>
	<cfcase value="SystemParam">
    	<cfinclude template="UtilitySystemParam.cfm">
    </cfcase>
    <cfcase value="MethodQuery">
    	<cfinclude template="UtilityMethodQuery.cfm">
    </cfcase>
    <cfcase value="CustomTag">
    	<cfinclude template="UtilityCustomTag.cfm">
    </cfcase>
    <cfcase value="Autocomplete">
    	<cfinclude template="UtilityAutocomplete.cfm">
    </cfcase>
    <cfcase value="CustomCode">
    	<cfinclude template="UtilityCustomCode.cfm">
    </cfcase>
    <cfcase value="CustomTagInfo">
    	<cfinclude template="UtilityCustomTagInfo.cfm">
    </cfcase>
    <cfcase value="ThreePoint">
        <cfinclude template="UtilityThreePoint.cfm">
    </cfcase>
    <cfcase value="Mapper">
        <cfinclude template="UtilityMapper.cfm">
    </cfcase>
    <cfcase value="ExpressionBuilder">
        <cfinclude template="UtilityExpressionBuilder.cfm">
    </cfcase>
    <cfcase value="List">
        <cfinclude template="utilityList.cfm">
    </cfcase>
    <cfdefaultcase>
    	<cfinclude template="UtilityDB.cfm">
    </cfdefaultcase>
</cfswitch>