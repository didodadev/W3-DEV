<cfcomponent>
	<cffunction name="CheckMobileNumber" returntype="string" >
    	<cfargument name="number" default="">
			<cfset TmpNumber = arguments.number>
            <cfset tmp=''>
            
            <cfif len(TmpNumber) eq 12 > 
				<cfif Left(TmpNumber, 2) eq '90'>
                        <cfif isNumeric(TmpNumber)>
                            <cfset tmp = TmpNumber>
                        </cfif>
                    </cfif>
            <cfelseif len(TmpNumber) eq 11>
				<cfif Left(TmpNumber, 2) eq '05'>
                        <cfif isNumeric(TmpNumber)>
                            <cfset tmp = '9' & '#TmpNumber#'>
                        </cfif>
                    </cfif>
            <cfelseif len(TmpNumber) eq 10>
            	<cfif Left(TmpNumber, 1) eq '5'>
                	<cfif isNumeric(TmpNumber)>
                    	<cfset tmp = '90' & '#TmpNumber#'>
                    </cfif>
                </cfif>
            </cfif>
		<cfreturn tmp>
	</cffunction>
</cfcomponent>
