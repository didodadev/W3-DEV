<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_product_name.cfm">
<cfinclude template="../query/get_serial_info.cfm">
<cfscript>CRLF=chr(13)&chr(10);</cfscript>
<cfheader name="Expires" value="#Now()#">
<cfcontent type="text/plain;charset=utf-8">
<cfheader name="Content-Disposition" value="attachment;filename=SERIALNO.TXT">
<cfset last_writen_code = "">
<cfoutput query="GET_SERIAL_INFO">
<cfset code_ = "#PROCESS_ID[currentrow]#-#PROCESS_CAT[currentrow]#-#SERIAL_NO[currentrow]#">
<cfif code_ is not last_writen_code><cfset last_writen_code = code_>
    #serial_no#<cfif len(lot_no)>,1,#lot_no#</cfif>#CRLF#
</cfif>
</cfoutput>
