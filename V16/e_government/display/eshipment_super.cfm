<cfinclude template="create_ubltr_eshipment.cfm" />

<!--- XML dosya dolduruluyor --->
<cffile action="write" file="#directory_name##dir_seperator##shipment_number#.xml" output="#trim(eshipment_data)#" charset="utf-8" />

<cfif attributes.fuseaction neq 'stock.popup_preview_shipment'>

    <Cfif getCompInfo.IS_MULTIPLE_PREFIX eq 1>
		<cfset sendShipment = soap.SendDespatchData(ubl: eshipment_data, shipment_prefix: left(get_ship.ship_number,3), shipment_number: shipment_number, path: temp_path)>
	<cfelse>
		<cfset sendShipment = soap.SendDespatchData(ubl: eshipment_data, shipment_prefix: get_ship_number.eshipment_prefix, shipment_number: shipment_number, path: temp_path)>
	</cfif>

    <cfif sendShipment.statuscode neq 0>
		<cfset new_shipment_number = sendShipment.despatchid>
	</cfif>

</cfif>

