<cfif thisTag.executionMode eq "start">
    <cfparam name="attributes.inputType" default="">
    <cfparam name="attributes.inputName" default="">
    <cfparam name="attributes.inputValue" default="">
    <cfparam name="attributes.inputViews" default="">
    <cfparam name="attributes.selectStatement" default="">
    <cfparam name="attributes.tableName" default="">
    <cfparam name="attributes.whereClause" default="">
    <cfparam name="attributes.orderBy" default="">
    <cfparam name="attributes.multiple" default="">
    <cfparam name="attributes.value" default="">
    <cfparam name="attributes.title" default="">
    <cfparam name="attributes.onchange" default="">
    <cfparam name="attributes.delimiter" default=";">
    <cfparam name="attributes.selectedValue" default="">
    <cfparam name="attributes.detailPath" default="">
    <cfparam name="attributes.gridColumns" default="">
    <cfif not len(attributes.selectedValue)>
    	<cfset attributes.selectedValue = attributes.value>
    </cfif>
    
    <cfquery name="GET_DATA" datasource="#caller.dsn#">
        SELECT
            #attributes.selectStatement#
        FROM
        	#attributes.tableName#
        <cfif len(attributes.whereClause)>
        	WHERE
            	#attributes.whereClause#
		</cfif>
        <cfif len(attributes.orderBy)>
        	ORDER BY
            	#attributes.orderBy#
		</cfif>
    </cfquery>
    <cfset inputValueCount = listlen(attributes.inputValue,attributes.delimiter)>
        
    <cfoutput>
		<cfif attributes.inputType is 'select'>
            <select dataTable="#attributes.tableName#" dataTitle="#attributes.title#" detailPath="#attributes.detailPath#" gridColumns="#attributes.gridColumns#" name="#attributes.inputName#" id="#attributes.inputName#" title="#attributes.title#" <cfif len(attributes.multiple)>multiple</cfif> <cfif len(attributes.onChange)>onChange="#attributes.onChange#"</cfif>>
            	<option value=""><cf_get_lang_main no="322.Seçiniz"></option>
                <cfloop query="GET_DATA">
                	<cfset data = ''>
                	<cfloop index="indSelect" from="1" to="#inputValueCount#">
                    	<cfset data = listAppend(data,evaluate('#listgetat(attributes.inputValue,indSelect,"#attributes.delimiter#")#'),'#attributes.delimiter#')>
                    </cfloop>
                	<cfloop index="indSelect" from="1" to="#inputValueCount#">
						<cfif listFirst(attributes.selectedValue,':') eq listgetat(attributes.inputValue,indSelect,"#attributes.delimiter#") and evaluate('#listLast(attributes.selectedValue,":")#') eq evaluate('#listgetat(attributes.inputValue,indSelect,"#attributes.delimiter#")#')>
	                        <cfset selectedVal = 1>
                            <cfbreak>
                        <cfelse>
                        	<cfset selectedVal = 0>
                        </cfif>
                    </cfloop>
                	<option value="#data#" <cfif isdefined("selectedVal") and selectedVal eq 1>selected<cfelse><cfif data eq attributes.selectedValue>selected</cfif></cfif>>#evaluate('#attributes.inputViews#')#</option>
                </cfloop>
            </select>
        </cfif>
    </cfoutput>
</cfif>