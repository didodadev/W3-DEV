<cfcomponent>
    
    <cffunction name="DecompressFirstEntry" access="public" returntype="any" hint="Decompress zip and get first content">
        <cfargument name="deflated" type="binary">

        <cfset bytearrayinputstreamInstance = createObject("java", "java.io.ByteArrayInputStream").init(deflated)>
        <cfset zipinputstreamInstance = createObject("java", "java.util.zip.ZipInputStream").init(bytearrayinputstreamInstance)>
        <cfset zipentryInstance = zipinputstreamInstance.getNextEntry()>
        <cfset byteArrayInstance = createObject("java", "java.io.ByteArrayOutputStream").init().toByteArray()>
        <cfset byteArrayClass = byteArrayInstance.getClass().getComponentType()>
        <cfset zipBytes = createObject("java","java.lang.reflect.Array").newInstance(byteArrayClass, 1024)>
        <cfset outputBytes = createObject("java","java.lang.reflect.Array").newInstance(byteArrayClass, zipentryInstance.getSize())>
        <cfset totalreaded = zipinputstreamInstance.read(zipBytes, 0, len(zipBytes))>
        <cfset systemInstance = createObject("java", "java.lang.System")>
        <cfset systemInstance.arraycopy(zipBytes, 0, outputBytes, 0, totalreaded)>

        <cfloop condition="totalreaded lt zipentryInstance.getSize()">
            <cfset readed = zipinputstreamInstance.read(zipBytes, 0, len(zipBytes))>
            <cfset systemInstance.arraycopy(zipBytes, 0, outputBytes, totalreaded, readed)>
            <cfset totalreaded = totalreaded + readed>
        </cfloop>

        <cfreturn outputBytes>
    </cffunction>

    <cffunction name="ExtractFilesFromPath" access="public" hint="Extract all files to path">
        <cfargument name="fromPath" type="string">
        <cfargument name="toPath" type="string">

        <cfset zipFile = createObject("java", "java.util.zip.ZipFile").init(fromPath)>
        <cfset zipEntries = zipFile.entries()>
        <cfloop condition="#zipEntries.hasMoreElements()#">
            <cfset zipEntry = zipEntries.nextElement()>
            <cfif zipEntry.isDirectory()>
                <cfdirectory action="create" directory="#toPath##zipEntry.getName()#">
            <cfelse>
                <cfset inputStream = zipFile.getInputStream(zipEntry)>
                <cfset bufferedInputStream = createObject("java", "java.io.BufferedInputStream").init(inputStream)>
                <cfset fileOutputStream = createObject("java", "java.io.FileOutputStream").init("#toPath##zipEntry.getName()#")>
                <cfloop condition="#bufferedInputStream.available()#">
                    <cfset fileOutputStream.write(bufferedInputStream.read())>
                </cfloop>
                <cfset fileOutputStream.close()>
                <cfset inputStream.close()>
            </cfif>
        </cfloop>
        <cfset zipFile.close()>
    </cffunction>

</cfcomponent>