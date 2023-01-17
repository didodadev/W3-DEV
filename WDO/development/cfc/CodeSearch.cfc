<cfcomponent>
	<cffunction
	    name="SearchFiles"
	    access="public"
	    returntype="array"
	    output="false"
	    hint="Verilen kelimeyi dosyalarda arar. Geriye kelimeyi bulduğu dosyaların olduğu, dizi tipinde değer döndürür.">
	
	    <!--- Fonksiyon parametreleri tanımlanıyor. --->
	    <cfargument
	        name="Path"
	        type="any"
	        required="true"
	        hint="Değer olarak dizin yolu veya dosya yolu alabilir."
	        />
	
	    <cfargument
	        name="Criteria"
	        type="string"
	        required="true"
	        hint="Dosyaların içinde arayacağımız kelimeyi içerir."
	        />
	
	    <cfargument
	        name="Filter"
	        type="string"
	        required="false"
	        default="cfm,css,htm,html,js,txt,xml"
	        hint="İzin verilen dosya uzantılarının listesi."
	        />
	
	    <cfargument
	        name="IsRegex"
	        type="boolean"
	        required="false"
	        default="false"
	        hint="Arama ifadelerinin normal bir ifade olup olmadığını denetler."
	        />
	
	
	    <cfset var LOCAL = StructNew() />
	
	    <cfif IsSimpleValue( ARGUMENTS.Path )>
	
	        <cfdirectory
	            action="LIST"
	            directory="#ARGUMENTS.Path#"
	            name="LOCAL.FileQuery"
	            recurse="true"
	            filter="*.*"
	            />

	        <cfset LOCAL.Paths = ArrayNew( 1 ) />
	
	        <cfloop query="LOCAL.FileQuery">
	
	            <cfset ArrayAppend(
	                LOCAL.Paths,
	                (LOCAL.FileQuery.directory & "\" & LOCAL.FileQuery.name)
	                ) />

	        </cfloop>
	
	    <cfelse>
	
	        <cfset LOCAL.Paths = ARGUMENTS.Path />
	
	    </cfif>
	
	    <cfset LOCAL.MatchingPaths = ArrayNew( 1 ) />
	
	    <cfset ARGUMENTS.Filter = ARGUMENTS.Filter.ReplaceAll(
	        "[^\w\d,]+",
	        ""
	        ).ReplaceAll(
	            ",",
	            "|"
	        ) />
	
	    <cfloop
	        index="LOCAL.PathIndex"
	        from="1"
	        to="#ArrayLen( LOCAL.Paths )#"
	        step="1">
	
	        <cfset LOCAL.Path = LOCAL.Paths[ LOCAL.PathIndex ] />
	
	        <cfif (
	            (NOT Len( ARGUMENTS.Filter )) OR
	            (
	                REFindNoCase(
	                    "(#ARGUMENTS.Filter#)$",
	                    LOCAL.Path
	                    )
	            ))>
	
	            <cffile
	                action="READ"
	                file="#LOCAL.Path#"
	                variable="LOCAL.FileData"
	                />
	
	            <cfif (
	                (
	                    ARGUMENTS.IsRegex AND
	                    REFindNoCase(
	                        ARGUMENTS.Criteria,
	                        LOCAL.FileData
	                    )
	                ) OR
	                (
	                    (NOT ARGUMENTS.IsRegex) AND
	                    FindNoCase(
	                        ARGUMENTS.Criteria,
	                        LOCAL.FileData
	                    )
	                )
	                )>
	
	                <cfset ArrayAppend(
	                    LOCAL.MatchingPaths,
	                    LOCAL.Path
	                    ) />
	
	            </cfif>
	
	        </cfif>
	
	    </cfloop>
	
	    <cfreturn LOCAL.MatchingPaths />
	
	</cffunction>
</cfcomponent>