<!--- Get directory entries for Ajax CFTREE --->
<cffunction name="getDirEntries" access="remote" returnType="array">
   <cfargument name="path" type="string" required="false" default="">
   <cfargument name="value" type="string" required="false" default="">

   <!--- Init variables --->
   <cfset var dir="">
   <cfset var entry="">
   <cfset var result=arrayNew(1)>
   <cfset var filepath="">

   <!--- Check if top level --->
   <cfif ARGUMENTS.value IS "">
      <!--- Yes, top level, get drives --->
<cfset dir=getDrives()>
      <!--- Loop through dir list --->
      <cfloop query="dir">
         <!--- Add each drive/root --->
         <cfset entry=StructNew()>
         <cfset entry.value=dir.name>
         <cfset entry.display=dir.name>
         <cfset entry.img="fixed">
         <cfset ArrayAppend(result, entry)>
      </cfloop>
   <cfelse>
      <!--- Not top level, get dir list --->
      <cfdirectory action="list"
               directory="#upload_folder#mails\#SESSION.EP.USERID#"
               name="dir"
               sort="name">
      <!--- Loop through dir list --->
      <cfloop query="dir">
         <!--- Create entry --->
         <cfset entry=StructNew()>
         <!--- Use full path as value --->
         <cfset entry.value=ARGUMENTS.value & THIS.separator & dir.name>
         <!--- Use just name for display --->
         <cfset entry.display=dir.name>
         <!--- Is this a file or a dir? --->
         <cfif dir.type IS "file">
            <!--- A file, so no children --->
            <cfset entry.leafnode=TRUE>
            <!--- Use document icon --->
            <cfset entry.img="document">
         <cfelse>
            <!--- A dir, use folder icon --->
            <cfset entry.img="folder">
            <cfset entry.imgopen="folder">
         </cfif>
         <!--- Add it to the array --->
         <cfset ArrayAppend(result, entry)>
      </cfloop>
   </cfif>

   <!--- And return the results --->
   <cfreturn result>
</cffunction>
