<cfsetting showdebugoutput="no">
<cfinclude template="../query/get_company.cfm">
<cfoutput><cf_workcube_barcode show="1" type="qrcode" width="150" height="150" value="geo:#get_company.coordinate_1#,#get_company.coordinate_2#"></cfoutput>
