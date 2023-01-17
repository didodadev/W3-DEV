<cfinclude template="../query/get_departments.cfm">
<cfinclude template="../query/get_position_cats.cfm">

<cfparam name="attributes.report_type" default="3">
<cfinclude  template="../../agenda/display/view_daily.cfm">