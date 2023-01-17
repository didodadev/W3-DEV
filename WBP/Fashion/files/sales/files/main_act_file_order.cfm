<cfset baskettotalamount=0>
<cfloop from="1" to="#caller.attributes.row_#" index="i">
<cfset baskettotalamount = baskettotalamount + caller["attributes.amount#i#"]>
</cfloop>
<cfif caller.attributes.process_stage eq 108 and caller.attributes.priority_id neq 14 and baskettotalamount gt 10>
    <script>alert("Sipariş miktarınız 10 adedi geçmektedir. Lütfen sürecinizi üretim sipariş talebine çekiniz.");</script>
    <cftransaction action="rollback">
        <cfabort>
</cfif>