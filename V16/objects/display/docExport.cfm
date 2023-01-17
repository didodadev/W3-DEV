<cfset pageDetail = URLDecode(DeserializeJSON(attributes.data),'utf-8')>
<cfset attributes.is_auto_excel = 1>
<cfinclude template="../../../WMO/fileConverter.cfm">
