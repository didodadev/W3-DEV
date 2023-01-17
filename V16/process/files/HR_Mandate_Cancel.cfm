<!---
    Author: Workcube - Gülbahar Inan <gulbaharinan@workcube.com>
    Date: 13.04.2020
    Description:
--->
<cfquery name="upd_mandate" datasource="#caller.dsn#">
    UPDATE EMPLOYEE_MANDATE SET IS_APPROVE = 0  WHERE MANDATE_MASTER_ID =#caller.id#
</cfquery>