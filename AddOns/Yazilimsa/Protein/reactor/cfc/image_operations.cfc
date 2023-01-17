<cfcomponent>
    <!---
    <cffunction name = "imageResize" returnType = "any" access = "remote" displayName = "İmage resize">
        
        <cfargument name="imagePath" type="string" required="true"> <!--- Fotoğrafın bulunduğu dizin --->
        <cfargument name="imageThumbPath" type="string" required="true"> <!--- Fotoğrafın Crop işlemi sonrası kaydolacağı dizin --->
        <cfargument name="imageResizeType" type="integer"  default="0"> <!--- Yeniden boyutlandırma işlemi en ve boy oranı orantılı olsun isteniyorsa 1 gönderin! --->
        <cfargument name="newWidth" type="integer" default="0"> 
        <cfargument name="newHeight" type="integer" default="0">

        <cfimage source="#imagePath#" name="wlResizeImage" action="info" structName="imageInfo">

        

        <cfimage action="resize" source="#wlResizeImage#" destination="#imageThumbPath#" height="#finalHeight#" width="#finalWidth#" overwrite="yes" />

    </cffunction>


    --->

    <cffunction name = "imageCrop" returnType = "any" access = "remote" displayName = "İmage crop">
        
        <cfargument name="imagePath" type="string" required="true"> <!--- Fotoğrafın bulunduğu dizin --->
        <cfargument name="imageThumbPath" type="string" required="true"> <!--- Fotoğrafın Crop işlemi sonrası kaydolacağı dizin --->
        <cfargument name="imageCropType" type="numeric" default="0"> <!--- Kırpma işlemi en ve boy oranı orantılı olsun isteniyorsa 1 gönderin! --->
        <cfargument name="PositionX" type="numeric" default="0"> <!--- X düzlemindeki konumu --->
        <cfargument name="PositionY" type="numeric" default="0"> <!--- Y düzlemindeki konumu --->
        <cfargument name="newWidth" type="numeric" required="true"> 
        <cfargument name="newHeight" type="numeric" required="true">

        <cfimage source="#imagePath#" name="wlCropImage" action="info" structName="imageInfo">
        
        <cfif imageCropType eq 1>

            <cfset srcRatio = imageInfo.width / imageInfo.height />
            <cfset trgRatio =  newWidth / newHeight/>

            <cfif imageInfo.height lt newHeight or imageInfo.width lt newWidth>
                
                <cfif ((PositionX eq 0) and (PositionY eq 0))>

                    <cfset finalHeight = imageInfo.height />
                    <cfset finalWidth = imageInfo.width />

                </cfif>

            <cfelse>

                <cfif srcRatio gt trgRatio>

                    <cfset finalHeight = imageInfo.height />
                    <cfset finalWidth = imageInfo.height * trgRatio />

                <cfelse>

                    <cfset finalWidth = imageInfo.width />
                    <cfset finalHeight = imageInfo.width / trgRatio />

                </cfif>
                
            </cfif>
            
            <cfset PositionX = (imageInfo.width - finalWidth) / 2 />
            <cfset PositionY = (imageInfo.height - finalHeight) / 2 />

        <cfelse>

            <cfif ((PositionX eq 0) and (PositionY eq 0))>

                <cfset finalWidth = imageInfo.width />
                <cfset finalHeight = imageInfo.height />
                <cfset PositionX = (finalWidth / 2) - (newWidth / 2) />
                <cfset PositionY = (finalHeight / 2) - (newHeight / 2) />
                
                <cfif finalWidth lt newWidth><cfset newWidth = finalWidth /></cfif>
                <cfif finalWidth lt newHeight><cfset newWidth = finalHeight /></cfif>
                <cfif PositionX lt finalWidth><cfset PositionX = 0 /></cfif>
                <cfif PositionY lt finalHeight><cfset PositionY = 0 /></cfif>

            </cfif>

        </cfif>
        
        <cfset imageCrop("#wlCropImage#","#PositionX#","#PositionY#","#newWidth#","#newHeight#") /> <!--- Croplama işlemi ---->
        <cfimage action="write" source="#wlCropImage#" destination="#imageThumbPath#" overwrite="yes"> <!--- Foto croptan sonra yeniden kaydedilir. --->
        
    </cffunction>

</cfcomponent>