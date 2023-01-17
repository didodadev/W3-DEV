<cfcomponent>
	<cffunction name="AddCookie" access="public" output="yes" >
		<cfargument name="cookied" type="string" required="yes">
        <cfargument name="actionType" type="string" required="yes">
            <cfif isDefined("cookie.#actionType#")>  <!--- Cookie var mı kontrolü --->
            <cfset isExists = false>    <!--- İlk olarak id nin cookie de olmadığını varsayıyoruz --->
             <cfset listcookie = cookie["#actionType#"]>
                 <cfset arr = listToArray (listcookie,",",true)>
                	 <cfloop index = "LoopCount" from = "1" to = "#ArrayLen(arr)#" >
                        <cfif arr[LoopCount] eq cookied >  <!--- Eğer eleman cookie de varsa kontrolü --->
                         	<cfset isExists = true>
                        </cfif>
                     </cfloop>
                      		<cfif isExists eq false>
                              <cfif ArrayLen(arr) eq 5 >
                                 <cfset arrayDeleteAt(arr,5)>
                                    </cfif>
                    			<cfloop index = "LoopCount" from = "#ArrayLen(arr)#" to = "1" step="-1"> <!--- Array Elemanları Kaydırılır --->
                      		  		<cfset arr[LoopCount+1] = arr [LoopCount]>
                    			</cfloop>
                      	  <cfset arr[1] = "#cookied#">   <!--- En son gelen eleman en başa koyulur --->
                		  <cfset listCookie = ArrayToList (arr)>
       					<cfcookie name="#actionType#" value="#listCookie#" expires="never" > <!--- Cookie Güncellenir --->
                  	</cfif>
             <cfelse>
         	 	<cfcookie name="#actionType#" value="#cookied#" expires="never" >   <!--- Cookie yoksa ilk elemanı gönderilen değer şeklinde oluşturulur --->
            </cfif>
	</cffunction>
    <cffunction name="GetCookie" access="public">
            <cfargument name="actionType" type="string" required="yes">     <!--- Cookie Döndürülür --->
            	 <cfif isDefined("cookie.#actionType#")>
            		 <cfset listcookie = cookie["#actionType#"] >
           			 <cfset returnvar = listToArray (listcookie,",",true)>
                 <cfelse>
                     <cfset returnvar=ArrayNew(1)>    <!--- Cookie boş ise boş array döner --->
           		 </cfif>
             <cfreturn returnvar>
    </cffunction>
</cfcomponent>
