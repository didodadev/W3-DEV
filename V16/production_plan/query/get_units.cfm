<cfquery name="get_det_pu" datasource="#dsn3#">
select
	pu.main_unit,
	pu.product_UNIT_ID
from
	product_unit pu
where
	product_id=#attributes.id#
	and 
	Is_main=1
</cfquery>

<cfquery name="get_det_pu1" datasource="#dsn3#">
select
	pu.ADD_unit,
	pu.product_UNIT_ID
from
	product_unit pu
where
	product_id=#attributes.id#
	AND
	product_UNIT_ID <> #get_det_pu.product_UNIT_ID#
</cfquery>
