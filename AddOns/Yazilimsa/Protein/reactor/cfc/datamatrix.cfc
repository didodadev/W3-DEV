<cfcomponent displayname="Wrapper for BarCode4j Datamatrix libraries">
<cffunction name="DMBarcode" access="public" returntype="void" output="no" hint="Create Datamatrix Barcode">
	<cfargument name="value" 		hint="String encode in barcode." required="true">
    <cfargument name="file" 		hint="File Name to be saved. (xxx.eps, xxx.jpg or xxx.bmp file)" 	default="dm.png">
    <cfargument name="shape" 		hint="Shape of the Barcode (SQUARE, RECTANGLE, NONE)" 				default="SQUARE">
    <cfargument name="resoluton" 	hint="Resolution of JPG PNG output" 	default="50">
    <cfargument name="savepath" 	hint="Path of the image to be saved" 	default="#ExpandPath('./')#">
    <cfargument name="loaderpath" 	hint="JavaLoader.cfc path" 				default="JavaLoader.JavaLoader">

	<cfset in		= ArrayNew(1)>
    <cfset in[1]	= "#ExpandPath('/')#barcode/barcode4j.jar">
    <cfset loader  	= createObject("component", loaderpath).init(in)>
    <cfset format	= listlast(file,'.')>

	<cfset Reader 		= loader.create("org.krysalis.barcode4j.impl.datamatrix.DataMatrixBean")>
    <cfset sharpner		= loader.create("org.krysalis.barcode4j.impl.datamatrix.SymbolShapeHint")>
    <cfset out 			= CreateObject("java","java.io.FileOutputStream").Init(CreateObject("java","java.io.File").Init('#savepath##file#')) />

    <cfswitch expression="#format#">
        <cfcase value="eps">
            <!--- EPS file format --->
            <cfset canvas 	= loader.create('org.krysalis.barcode4j.output.eps.EPSCanvasProvider').init(out,0)>
            <cfset ctype	= "application/postscript">
        </cfcase>
        <cfcase value="jpg">
            <!--- JPG file format --->
            <cfset BufferedImage 	= CreateObject('java',"java.awt.image.BufferedImage")>
            <cfset canvas = loader.create('org.krysalis.barcode4j.output.bitmap.BitmapCanvasProvider').init(out, "image/jpeg", JavaCast('double',resoluton), BufferedImage.TYPE_BYTE_BINARY, false, 0)>
            <cfset ctype	= "image/jpeg">
        </cfcase>
        <cfdefaultcase>
            <!--- PNG file format --->
            <cfset BufferedImage 	= CreateObject('java',"java.awt.image.BufferedImage")>
            <cfset canvas = loader.create('org.krysalis.barcode4j.output.bitmap.BitmapCanvasProvider').init(out, "image/x-png", JavaCast('double',resoluton), BufferedImage.TYPE_BYTE_BINARY, false, 0)>
            <cfset ctype	= "image/png">
        </cfdefaultcase>
    </cfswitch>

	<cfset Reader.setModuleWidth(JavaCast('int',1))>
    
    <!--- set the shape of the barcode --->
    <cfswitch expression="#shape#">
        <cfcase value="SQUARE">
            <cfset Reader.setShape(sharpner.FORCE_SQUARE)>
        </cfcase>
        <cfcase value="RECTANGLE">
            <cfset Reader.setShape(sharpner.FORCE_RECTANGLE)>
        </cfcase>
        <cfdefaultcase>
            <cfset Reader.setShape(sharpner.FORCE_NONE)>
        </cfdefaultcase>
    </cfswitch>
    
    <cfset Reader.generateBarcode(canvas, JavaCast('string',value))>
    <cfset canvas.finish()>
    <cfset out.close()>
</cffunction>
</cfcomponent>
